//
//  RoundedButton.swift
//  Impact
//
//  Created by Phillip Ou on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable
    var cornerRadius : CGFloat = 0 {
        didSet {
            roundCorners();
        }
    }
    
    //MARK : Initializers
    override init(frame: CGRect) {
        super.init(frame: frame);
        roundCorners();
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        roundCorners();
    }
    
    init(frame:CGRect,title:String,backgroundColor:UIColor, textColor:UIColor) {
        super.init(frame:frame);
        self.titleLabel?.text = title;
        self.backgroundColor = backgroundColor;
        self.titleLabel?.textColor = textColor;
    }
    
    func roundCorners() {
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.masksToBounds = true;
    }
}
