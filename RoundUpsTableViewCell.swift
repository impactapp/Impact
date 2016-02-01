//
//  RoundUpsTableViewCell.swift
//  Impact
//
//  Created by Anthony Emberley on 1/19/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class RoundUpsTableViewCell: UITableViewCell {
    @IBOutlet var roundUpAmountLabel: UILabel!
    @IBOutlet var totalAmountSpentLabel: UILabel!
    @IBOutlet var roundUpLocationLabel: UILabel!
    @IBOutlet var roundUpDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
