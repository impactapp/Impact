//
//  LabelWithAdaptiveTextHeight.swift
//  Impact
//
//  Created by Anthony Emberley on 3/12/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class LabelWithAdaptiveTextHeight: UILabel {

    override func layoutSubviews() {
        super.layoutSubviews()
        font = fontToFitHeight()
    }
    
    // Returns an UIFont that fits the new label's height.
    private func fontToFitHeight() -> UIFont {
        
        var minFontSize: CGFloat = CGFloat(50)
        var maxFontSize: CGFloat = CGFloat(110)     // CGFloat 67
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard text?.characters.count > 0 else {
                break
            }
            
            if let labelText: NSString = text {
                let labelHeight = frame.size.height
                
                let testStringHeight = labelText.sizeWithAttributes(
                    [NSFontAttributeName: font.fontWithSize(fontSizeAverage)]
                    ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return font.fontWithSize(fontSizeAverage - 1)
                    }
                    return font.fontWithSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return font.fontWithSize(fontSizeAverage)
                }
            }
        }
        return font.fontWithSize(fontSizeAverage)
    }

}
