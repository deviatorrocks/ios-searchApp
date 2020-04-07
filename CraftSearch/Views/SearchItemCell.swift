//
//  SearchItemCell.swift
//  CraftSearch
//
//  Created by mkadam on 4/6/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import Foundation
import UIKit
protocol SearchCellDelegate: class {
    func handleImageTap(_ index: Int)
}
class SearchItemCell: UITableViewCell {
    var index: Int = 0
    weak var delegate: SearchCellDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImage: CustomImageView!
    
    func configure(_ imageUrl: String, _ title: String, _ description: String, _ index: Int) {
        self.index = index
        if let url = URL(string: "\(imageUrl)") {
            self.thumbnailImage.loadImageFromUrl(url)
        }
        self.titleLabel.text = title
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        thumbnailImage.addGestureRecognizer(tap)
    }
    override func draw(_ rect: CGRect) {
        thumbnailImage.layer.borderWidth = 0.5
        thumbnailImage.layer.borderColor = UIColor.black.cgColor
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // handling code
        self.delegate?.handleImageTap(self.index)
    }
}
