//
//  Bank.swift
//  Impact
//
//  Created by Phillip Ou on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit
import SwiftyJSON

class Bank: NSObject {
    var name : String = "";
    var logoURL : String? = nil;
    var bankId : String = "";
    var bankType : String = ""
    var needsMFA: Bool = false
    var needsPin: Bool = false
    
    init(name:String, logoURL : String?, bankType: String, bankId: String) {
        self.name = name
        self.logoURL = logoURL
        self.bankType = bankType
        self.bankId = bankId
    }
    
    init(json:JSON) {
        if let name = json["name"].string {
            self.name = name
        }
        if let bankId = json["id"].string {
            self.bankId = bankId
        }
        if let bankType = json["type"].string {
            self.bankType = bankType
        }
        self.logoURL = json["logo_url"].string
        if let needsMFA = json["has_mfa"].bool {
            self.needsMFA = needsMFA
        }
        if let credentialsDictionary = json["credentials"].dictionary {
            self.needsPin = credentialsDictionary["pin"] != nil
        }
    }
    
}
