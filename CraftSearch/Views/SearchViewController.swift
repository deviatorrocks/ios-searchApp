//
//  ViewController.swift
//  CraftSearch
//
//  Created by mkadam on 4/5/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var viewModel: SearchViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = SearchViewModel(service: SearchService())
        viewModel.delegate = self
        viewModel.loadDataForText("taylor swift")
    }


}
extension SearchViewController: SearchViewModelDelegate {
    func loadUIData() {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                print("//Reload tabelview")
                ///Will remove once UI come sin picture.
                if self.viewModel.getTotalRecords() > 30 {
                    for i in 0...10 {
                        print("\(i)---\(self.viewModel.getItemTitle(i))")
                    }
                    return
                }
                self.viewModel.loadNextData()
            }
            
        }
    }
    
    func loadError() {
        DispatchQueue.main.async {
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

