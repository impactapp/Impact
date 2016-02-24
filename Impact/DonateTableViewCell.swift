//
//  DonateTableViewCell.swift
//  Impact
//
//  Created by Anthony Emberley on 2/23/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class DonateTableViewCell: UITableViewCell {
    @IBOutlet var titleTextLabel: UILabel!
    @IBOutlet var moneyTextLabel: UILabel!
    
    @IBOutlet var cellSwitch: UISwitch!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var detailedTextLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
