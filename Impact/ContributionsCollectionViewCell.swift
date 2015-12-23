//
//  ContributionsCollectionViewCell.swift
//  Impact
//
//  Created by Anthony Emberley on 10/25/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class ContributionsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var finishingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.backgroundColor = UIColor.customDarkGrey()
        
    }

}
