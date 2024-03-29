//
//  ViewController.swift
//  CraftSearch
//
//  Created by mkadam on 4/5/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import UIKit
import Foundation
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet var popOverView: UIView!
    @IBOutlet weak var popoverImageVIew: CustomImageView!
    @IBOutlet weak var searchListTableView: UITableView!
    @IBOutlet weak var searchbarView: UISearchBar!
    var isLoadingMore = false
    var viewModel: SearchViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SearchViewModel(service: SearchService())
        viewModel.delegate = self
        searchbarView.text = "taylor swift"
        viewModel.loadDataForText(searchbarView.text ?? "")
        self.popOverView.layer.cornerRadius = 10
        
        self.searchListTableView.tableFooterView = UIView()
        showLoading()
    }
    @IBAction func dismissPopover(_ sender: Any) {
        self.popOverView.removeFromSuperview()
    }
    func showPopOver(index: Int) {
        popOverView.layer.borderWidth = 1
        popOverView.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(popOverView)
        if let url = URL(string: self.viewModel.getThumbnailImage(index)) {
            self.popoverImageVIew.loadImageFromUrl(url)
            popOverView.center = self.view.center
        }
    }
    func showLoading() {
        self.searchListTableView.bringSubviewToFront(self.loadingIndicatorView)
        self.loadingIndicatorView.startAnimating()        
        self.loadingIndicatorView.isHidden = false
    }
    func dismissLoading() {
        self.loadingIndicatorView.stopAnimating()
        self.loadingIndicatorView.isHidden = true
    }
}
extension SearchViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCurrentRecords()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCell", for: indexPath) as! SearchItemCell
        let imageUrl = viewModel.getItemImage(indexPath.row)
        let title = viewModel.getItemTitle(indexPath.row)
        let desc = viewModel.getWebSearchUrl(indexPath.row)
        cell.configure(imageUrl, title, desc, indexPath.row)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissPopover(self.popOverView)
        let url = viewModel.getWebSearchUrl(indexPath.row)
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let webVC = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        self.navigationController?.present(webVC, animated: true, completion: {
            webVC.loadWebUrl(url: url)
        })
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.viewModel.getCurrentRecords()
        if indexPath.row + 1 == count {
            if self.isLoadingMore {
                return
            }
            self.isLoadingMore = true
            self.viewModel.loadNextData()
        }
    }
}
extension SearchViewController: SearchCellDelegate {
    func handleImageTap(_ index: Int) {
        self.showPopOver(index: index)
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchBar.resignFirstResponder()
            self.viewModel.loadDataForText(text)
            showLoading()
        }
    }

}
extension SearchViewController: SearchViewModelDelegate {
    func loadUIData() {
        DispatchQueue.main.async {
                self.isLoadingMore = false
                self.searchListTableView.reloadData()
                self.dismissLoading()
            }
    }
    
    func loadError() {
        DispatchQueue.main.async {
            self.dismissLoading()
            self.isLoadingMore = false
            self.showAlertWith(title: "Error", message: "Error message")
        }
    }
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

