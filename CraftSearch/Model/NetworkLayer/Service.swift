//
//  NetworkService.swift
//  CraftSearch
//
//  Created by mkadam on 4/5/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import Foundation
import UIKit

class APIService: NetworkServiceProtocol {
    
    lazy var endPoint: String = {
        return "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/"
    }()

    static func getHeaders() -> [String: String] {
        var headers = [String: String]()
        headers[Constants.APIHeaderKeys.apiHostkey] = "contextualwebsearch-websearch-v1.p.rapidapi.com"
        headers[Constants.APIHeaderKeys.apiKey] = "14e1f691c0msha3d763bd79c45fep145bd1jsnfb664ff86ab3"
        return headers
    }
    func getDataWith(apiName: APIName,
                     parameters: [String: String],
                     completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = formUrl(apiName: apiName, parameters: parameters)
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
         guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json["items"] as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
    func formUrl(apiName: APIName, parameters: [String: String]) -> String {
        var urlString = endPoint+apiName.rawValue
        var paramStr = ""
        for (key, value) in parameters {
            paramStr += paramStr.isEmpty ? "?\(key)=\(value)" : "&\(key)=\(value)"
        }
        if !paramStr.isEmpty {
            urlString += paramStr
        }
        return urlString
    }
}
