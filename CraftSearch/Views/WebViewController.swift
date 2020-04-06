//
//  WebViewController.swift
//  CraftSearch
//
//  Created by mkadam on 4/6/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class WebViewController: UIViewController {
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    override func viewDidLoad() {
        self.title = "Search View"
    }
    func loadWebUrl(url: String) {
        if let urlToLoad = URL(string: url) {
            webview.load(URLRequest(url: urlToLoad))
            activityView.startAnimating()
            webview.navigationDelegate = self
            activityView.hidesWhenStopped = true
            activityView.center = view.center
        }
    }
}
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView.stopAnimating()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityView.startAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityView.stopAnimating()
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        ///TODO: For now without trust loading the web url.
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return
        }
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
        return
    }
}
