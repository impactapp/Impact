//
//  ChooseBankHeaderView.swift
//  Impact
//
//  Created by Phillip Ou on 4/22/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class ChooseBankHeaderView: UICollectionReusableView {
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureHeaderButtons(isFromSettings:Bool) {
        skipButton.hidden = isFromSettings
        backButton.hidden = !skipButton.hidden
    }
        
}
