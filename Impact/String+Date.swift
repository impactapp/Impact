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
}
