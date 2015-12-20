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
        return UIColor(red: 72/255.0, green: 72/255.0, blue: 72/255.0, alpha: alpha);
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
    
    static func convertHexToColor(hexString: String?) -> UIColor {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if let hex = hexString {
            if hex.hasPrefix("#") {
                let index   = hex.startIndex.advancedBy(1)
                let hex     = hex.substringFromIndex(index)
                let scanner = NSScanner(string: hex)
                var hexValue: CUnsignedLongLong = 0
                if scanner.scanHexLongLong(&hexValue) {
                    switch (hex.characters.count) {
                    case 3:
                        red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                        green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                        blue  = CGFloat(hexValue & 0x00F)              / 15.0
                    case 4:
                        red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                        green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                        blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                        alpha = CGFloat(hexValue & 0x000F)             / 15.0
                    case 6:
                        red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                        green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                        blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                    case 8:
                        red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                        green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                        blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                        alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                    default:
                        print("Invalid Hex String", terminator: "")
                    }
                }
            }
        }
        return UIColor(red:red, green:green, blue:blue, alpha:alpha)
    }
}
