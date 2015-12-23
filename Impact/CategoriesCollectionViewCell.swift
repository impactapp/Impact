//
//  CategoriesCollectionViewCell.swift
//  Impact
//
//  Created by Phillip Ou on 10/31/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!
    let cornerRadius = CGFloat(5)
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.masksToBounds = true;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColorView.layer.cornerRadius = self.backgroundColorView.frame.size.width/2
        self.backgroundColorView.layer.masksToBounds = true
    }

}
