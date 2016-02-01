//
//  SettingsTableViewCell.swift
//  Impact
//
//  Created by Phillip Ou on 1/28/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var cellSwitch: UISwitch!
    @IBOutlet weak var customAccessoryView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customAccessoryView.transform = CGAffineTransformMakeScale(-1, 1)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(cellTitle:String, user:User?) -> SettingsTableViewCell {
        self.backgroundColor = UIColor.redColor()
        return self
    }
    
}
