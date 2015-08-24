//
//  Bank.swift
//  Impact
//
//  Created by Phillip Ou on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class Bank: NSObject {
    var name : String = "";
    var logoURL : String? = nil;
    var bankId : String = "";
    
    init(name:String, logoURL : String?, bankId: String) {
        self.name = name;
        self.logoURL = logoURL;
        self.bankId = bankId;
    }
    
}
