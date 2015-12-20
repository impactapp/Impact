//
//  SearchCauseTableViewCell.swift
//  Impact
//
//  Created by Phillip Ou on 12/19/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class SearchCauseTableViewCell: UITableViewCell {

    @IBOutlet weak var causeInfoLabel: UILabel!
    @IBOutlet weak var causeNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
