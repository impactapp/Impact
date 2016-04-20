//
//  FooterCollectionReusableView.swift
//  Impact
//
//  Created by Anthony Emberley on 2/5/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

protocol FooterCollectionReusableViewDelegate {
    func footerViewTopButtonPressed()
    func footerViewBottomButtonPressed()
}

class FooterCollectionReusableView: UICollectionReusableView {
    @IBOutlet var topButton: RoundedButton!
    @IBOutlet var bottomButton: RoundedButton!
    var delegate: FooterCollectionReusableViewDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func switchColors() {
        self.topButton.backgroundColor = UIColor.blackColor()
    }
    
    @IBAction func topButtonPressed(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.footerViewTopButtonPressed()
        }
        
    }
    
    @IBAction func bottomButtonPressed(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.footerViewBottomButtonPressed()
        }
    }
    
}
