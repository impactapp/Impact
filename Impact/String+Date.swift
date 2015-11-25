//
//  String+Date.swift
//  Impact
//
//  Created by Phillip Ou on 10/15/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import Foundation


extension String {
    func convertToDate() -> NSDate? {
        let apiDateFormat = "yyyy-MM-dd'T'HH:mm:ss:SSS"
        let dateFor: NSDateFormatter = NSDateFormatter()
        dateFor.dateFormat = apiDateFormat
        return dateFor.dateFromString(self)
    }
    
    func sizeForText(font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: self, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        let size = CGSizeMake(rect.size.width, rect.size.height)
        return size
    }
}
