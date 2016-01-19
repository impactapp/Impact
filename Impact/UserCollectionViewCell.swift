//
//  UserCollectionViewCell.swift
//  Impact
//
//  Created by Phillip Ou on 1/18/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var user : User? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
