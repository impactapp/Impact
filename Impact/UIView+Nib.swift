//
//  UIView+Nib.swift
//  Impact
//
//  Created by Phillip Ou on 8/24/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
                nibName: nibNamed,
                bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    func addBottomBorder(color : UIColor) {
        let lineView = UIView(frame: CGRectMake(0, self.frame.size.height - 1.0, self.frame.size.width, 1))
        lineView.backgroundColor=color;
        self.addSubview(lineView);
    }
    
    func resizeToFitSubviews() {
        
        let subviewsRect = subviews.reduce(CGRect.zero) {
            $0.union($1.frame)
        }
        
        let fix = subviewsRect.origin
        subviews.forEach {
            $0.frame.offsetInPlace(dx: -fix.x, dy: -fix.y)
        }
        
        frame.offsetInPlace(dx: fix.x, dy: fix.y)
        frame.size = subviewsRect.size
    }
}
