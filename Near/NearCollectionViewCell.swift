//
//  NearCollectionViewCell.swift
//  Near
//
//  Created by John Vu on 2017-02-27.
//  Copyright © 2017 John Vu. All rights reserved.
//

import SDWebImage
import SwiftyJSON
import UIKit

class NearCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nearImageView: UIImageView!
    
    var image:JSON? {
        didSet {
            self.setupImage()
        }
    }
    
    func setupImage() {
        if let urlString = self.image?["images"]["standard_resolution"]["url"] {
            // Use SDWebImage framework to load image from URL
            self.nearImageView.sd_setImage(with: URL(string: urlString.stringValue), placeholderImage: UIImage(named: "skull.png"))
        }
    }
}
