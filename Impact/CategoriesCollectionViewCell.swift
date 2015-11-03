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
    let cornerRadius = CGFloat(5)
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.masksToBounds = true;
        // Initialization code
    }

}
