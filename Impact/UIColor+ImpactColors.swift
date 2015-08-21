//
//  UIColor+ImpactColors.swift
//  Impact
//
//  Created by Phillip Ou on 8/20/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    static func customGrey() -> UIColor {
        return customGreyWithAlpha(1.0);
    }
    
    static func customGreyWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: alpha);
    }
    
    static func customDarkGrey() -> UIColor {
        return customDarkGreyWithAlpha(1.0);
    }
    
    static func customDarkGreyWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 92/255.0, green: 90/255.0, blue: 90/255.0, alpha: alpha);
    }
    
    static func customRed() -> UIColor {
        return customRedWithAlpha(1.0);
    }
    
    static func customRedWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 237/255.0, green: 123/255.0, blue: 119/255.0, alpha: alpha);
    }
    
    static func customDarkRed() -> UIColor {
        return customDarkRedWithAlpha(1.0);
    }
    
    static func customDarkRedWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 190/255.0, green: 78/255.0, blue: 78/255.0, alpha: alpha);
    }
    
    static func customBlue() -> UIColor {
        return customBlueWithAlpha(1.0);
    }
    
    static func customBlueWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: alpha);
    }
    
    static func customGreen() -> UIColor {
        return customGreenWithAlpha(1.0);
    }
    
    static func customGreenWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 93/255.0, green: 157/255.0, blue: 74/255.0, alpha: alpha);
    }
    
    static func customYellow() -> UIColor {
        return customYellowWithAlpha(1.0);
    }
    
    static func customYellowWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 230/255.0, green: 137/255.0, blue: 15/255.0, alpha: alpha);
    }

}
