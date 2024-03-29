//
//  NetworkServiceProtocol.swift
//  CraftSearch
//
//  Created by mkadam on 4/5/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import Foundation
enum Result<T> {
    case Success(T)
    case Error(String)
}
enum APIName: String {
    case webSearch = "WebSearchAPI"
    case newsSearch = "NewsSearchAPI"
    case imageSearch = "ImageSearchAPI"
}
protocol NetworkServiceProtocol {
    static func getDataWith(apiName: APIName,
                    parameters: [String: AnyObject],
                    completion: @escaping (Result<[String: AnyObject]>) -> Void)
}
extension NetworkServiceProtocol {
    static func getDataWith(apiName: APIName,
                            parameters: [String: AnyObject],
                            completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        getDataWith(apiName: apiName, parameters: parameters, completion: completion)
    }
}
