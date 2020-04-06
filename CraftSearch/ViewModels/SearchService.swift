//
//  SearchService.swift
//  CraftSearch
//
//  Created by mkadam on 4/6/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import Foundation
class SearchService {
    let apiService: NetworkServiceProtocol.Type
    init(serviceManager: NetworkServiceProtocol.Type = APIService.self) {
        self.apiService = serviceManager
    }
    func loadSrvice(apiName: APIName,
                    parameters: [String: AnyObject],
                    completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        self.apiService.getDataWith(apiName: apiName,
                                    parameters: parameters,
                                    completion: completion)
    }
}
