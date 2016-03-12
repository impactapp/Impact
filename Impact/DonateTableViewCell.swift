//
//  DonateTableViewCell.swift
//  Impact
//
//  Created by Anthony Emberley on 2/23/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

protocol DonateTableViewCellDelegate{
    func switchIsPressed()
}

class DonateTableViewCell: UITableViewCell {
    @IBOutlet var titleTextLabel: UILabel!
    @IBOutlet var moneyTextLabel: UILabel!
    
    @IBOutlet var cellSwitch: UISwitch!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var detailedTextLabel: UILabel!
    var delegate: DonateTableViewCellDelegate? = nil

    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.contentView.superview!.subviews {
            print(String(subview.classForCoder))
            if (NSStringFromClass(subview.classForCoder).hasSuffix("SeparatorView")) {
                subview.hidden = false;
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchPressed(sender: AnyObject) {
        if let delegate = self.delegate{
            delegate.switchIsPressed()
        }
    }
    
}
