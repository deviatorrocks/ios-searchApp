//
//  SearchViewModel.swift
//  CraftSearch
//
//  Created by mkadam on 4/5/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import Foundation
import UIKit
protocol SearchViewModelDelegate: class {
    func loadUIData()
    func loadError()
}
class SearchViewModel {
    weak var delegate: SearchViewModelDelegate?
    private var dataSource = [Item]()
    private var currentPageNumber = 1
    private var currentSearchString = ""
    private var totalRecords: Int32 = 0
    private var errorCode: String = ""
    
    subscript(index: Int) -> Item? {
        get {
            if index <= dataSource.count {
                return self.dataSource[index]
            } else {
                return nil
            }
        }
    }
    let service: SearchService
    let storage = CoreDataStorageManager.sharedInstance
    
    init(service: SearchService) {
        self.service = service
    }
    func resetSearchConfig() {
        self.storage.clearData()
        self.dataSource.removeAll()
        self.currentPageNumber = 1
        self.totalRecords = 0
        self.delegate?.loadUIData()
    }
    func loadDataForText(_ searchString: String) {
        ///Previous searched data
        if searchString != currentSearchString && !currentSearchString.isEmpty {
            self.resetSearchConfig()
        }
        currentSearchString = searchString
        service.loadSrvice(apiName: .imageSearch,
                           parameters: getParameters()) { (value) in
                                switch value {
                                case .Success(let data):
                                    self.storage.clearData()
                                    let item = self.storage.saveInCoreDataWith(dictionary: data)
                                    self.updateDataSource(item)
                                    self.delegate?.loadUIData()
                                case .Error(let message):
                                    self.errorCode = message
                                    self.delegate?.loadError()
                                }
        }
    }
    func getItemTitle(_ index: Int) -> String {
        return dataSource[index].title ?? ""
    }
    func getItemDescription(_ index: Int) -> String {
        return dataSource[index].description
    }
    func getItemImage(_ index: Int) -> String {
        return dataSource[index].url ?? ""
    }
    func getThumbnailImage(_ index: Int) -> String {
        return dataSource[index].thumbnail ?? ""
    }
    func getWebSearchUrl(_ index: Int) -> String {
        return dataSource[index].imageWebSearchUrl ?? ""
    }
    func getTotalRecords() -> Int {
        return Int(self.totalRecords)
    }
    func getCurrentRecords() -> Int {
        return Int(self.dataSource.count)
    }
    func loadNextData() {
        currentPageNumber += 1
        loadDataForText(currentSearchString)
    }
    func getErrorCode() -> String {
        return errorCode
    }
}
extension SearchViewModel {
    private func getParameters() -> [String: AnyObject] {
        let params = [Constants.ParameterKeys.autoCorrectKey: "false",
                      Constants.ParameterKeys.safeSearchKey: "false",
                      Constants.ParameterKeys.pageNumber: currentPageNumber,
                      Constants.ParameterKeys.pageSizeKey: 10,
                      Constants.ParameterKeys.queryKey: currentSearchString] as [String : AnyObject]
        return params
    }
    private func updateDataSource(_ search: Search?) {
        if let localSearchObject = search {
            self.totalRecords = localSearchObject.totalCount
            if let subItems = localSearchObject.values {
                for item in subItems {
                    self.dataSource.append(item as! Item)
                }
            }
        }
    }
}
