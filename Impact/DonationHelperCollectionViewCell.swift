//
//  DonationHelperCollectionViewCell.swift
//  Impact
//
//  Created by Anthony Emberley on 2/24/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class DonationHelperCollectionViewCell: UICollectionViewCell {
    @IBOutlet var moneyTextField: UITextField!
    @IBOutlet var topLeftLabel: UILabel!
    @IBOutlet var bottomRightLabel: UILabel!
    @IBOutlet var causeLabel: UILabel!
    @IBOutlet var partnerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
