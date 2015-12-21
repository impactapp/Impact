//
//  AccessoryTableViewCell.swift
//  Impact
//
//  Created by Phillip Ou on 12/21/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class AccessoryTableViewCell: UITableViewCell {

    @IBOutlet weak var accessoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryImageView.transform = CGAffineTransformMakeScale(-1, 1)
        self.backgroundColor = UIColor.customDarkGrey()
        self.titleLabel.textColor = UIColor.whiteColor()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
