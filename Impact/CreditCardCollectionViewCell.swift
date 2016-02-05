//
//  CreditCardCollectionViewCell.swift
//  Impact
//
//  Created by Anthony Emberley on 2/4/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class CreditCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var cardNumberTextField: UITextField!
    @IBOutlet var cvvTextField: UITextField!
    @IBOutlet var expDateTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
