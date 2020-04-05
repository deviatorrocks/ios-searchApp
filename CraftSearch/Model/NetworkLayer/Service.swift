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
                     parameters: [String: AnyObject],
                     completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        
        let headers = APIService.getHeaders()
        
        guard let url = formUrl(apiName: apiName, parameters: parameters) else {
            print()
            return completion(.Error("Invalid URL, we can't update your feed"))
            
        }
        let request = NSMutableURLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default,
                                 delegate: nil,
                                 delegateQueue: nil)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
                guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                        DispatchQueue.main.async {
                            completion(.Success(json))
                        }
                    }
                } catch let error {
                    return completion(.Error(error.localizedDescription))
                }
        })
        task.resume()
    }
    func formUrl(apiName: APIName, parameters: [String: AnyObject]) -> URL? {
        let urlString = endPoint+apiName.rawValue
        var components = URLComponents(string: urlString)!
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
}
