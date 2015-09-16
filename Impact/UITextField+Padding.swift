//
//  UITextField+Padding.swift
//  Impact
//
//  Created by Phillip Ou on 9/15/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import Foundation

extension UITextField {
    func enablePadding(enabledPadding:Bool) {
        if enabledPadding {
            let padding = CGFloat(15)
            let answerPaddingView = UIView(frame: CGRectMake(0, 0, padding, self.frame.height))
            self.leftView = answerPaddingView
            self.leftViewMode = UITextFieldViewMode.Always
        }
    }
    

}
