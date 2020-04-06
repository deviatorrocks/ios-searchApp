//
//  CustomImageView.swift
//  CraftSearch
//
//  Created by mkadam on 4/6/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import Foundation
import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var imageTask: URLSessionDataTask!
    var loadingIndicator = UIActivityIndicatorView(style: .gray)

    func loadImageFromUrl(_ url: URL) {

        image = nil
        addLoadingView()
        if let task = imageTask {
            task.cancel()
        }
        
        if let localImageFromCache = imageCache.object(forKey: (url.absoluteString as AnyObject) as! NSString) {
            image = localImageFromCache as? UIImage
            removeLoadingView()
            return
        }

        imageTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let checkData = data, let loadedImage = UIImage(data: checkData) else {
                //print("image can't be loaded \(url)")
                return
            }
            imageCache.setObject(loadedImage, forKey: (url.absoluteString as AnyObject) as! NSString)
            DispatchQueue.main.async {
                self.image = loadedImage
                self.removeLoadingView()
            }
        })
        imageTask.resume()
    }
    
    func addLoadingView() {
        addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingIndicator.startAnimating()
    }
    func removeLoadingView() {
        loadingIndicator.removeFromSuperview()
    }
}
