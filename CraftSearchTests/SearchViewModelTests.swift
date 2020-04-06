//
//  SearchViewModelTests.swift
//  CraftSearchTests
//
//  Created by mkadam on 4/6/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import XCTest
@testable import CraftSearch

class SearchViewModelTests: XCTestCase {

    let mockApiService = MockApiService.self
    var viewModel: SearchViewModel?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = SearchViewModel(service: SearchService(serviceManager: mockApiService))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testDataResponse() {
        mockApiService.isFailure = false
        let expectedTotalRecords: Int32 = 2893
        viewModel?.delegate = self as? SearchViewModelDelegate
        viewModel?.loadDataForText("taylor swift")
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel?.getTotalRecords(), expectedTotalRecords)
        XCTAssertNotNil(viewModel?.getWebSearchUrl(0))
        XCTAssertNotNil(viewModel?.getItemImage(0))
        XCTAssertNotNil(viewModel?.getThumbnailImage(0))
    }
    func testFailureResponse() {
        mockApiService.isFailure = true
        let expectedErroCode: String = "401"
        viewModel?.delegate = self as? SearchViewModelDelegate
        viewModel?.loadDataForText("taylor swift")
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel?.getErrorCode(), expectedErroCode)
    }

}
extension SearchViewModel: SearchViewModelDelegate {
    public func loadUIData() {
        
    }
    
    public func loadError() {
        
    }
}
class MockApiService: NetworkServiceProtocol {
    static var isFailure = false
    static func getDataWith(apiName: APIName, parameters: [String : AnyObject], completion: @escaping (Result<[String : AnyObject]>) -> Void) {
        if self.isFailure {
            completion(.Error("401"))
        } else {
            if let value = MockTests().getJsonFromFileName(fileName: "SearchResults") {
                completion(.Success(value))
            }
        }
    }
}
