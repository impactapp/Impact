//
//  RoundedCollectionViewCell.swift
//  Impact
//
//  Created by Phillip Ou on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class RoundedCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    var cornerRadius = CGFloat(16);

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.masksToBounds = true;
        self.layer.borderColor = UIColor.customGrey().CGColor;
        self.layer.borderWidth = 2.0;
    }

}
