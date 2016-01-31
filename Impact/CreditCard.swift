//
//  CreditCard.swift
//  Impact
//
//  Created by Phillip Ou on 1/30/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreditCard: NSObject {
    var id: String!
    var brand : String!
    var country : String!
    var customer: String!
    var cvc_check: String!
    var last4 : String!
    var exp_month: Int!
    var exp_year : Int!
    var fingerprint: String!
    var funding: String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        id = json["id"].stringValue
        brand = json["brand"].stringValue
        country = json["country"].stringValue
        customer = json["customer"].stringValue
        cvc_check = json["cvc_check"].stringValue
        last4 = json["last4"].stringValue
        exp_month = json["exp_month"].intValue
        exp_year = json["exp_year"].intValue
        fingerprint = json["fingerprint"].stringValue
        funding = json["funding"].stringValue
    }
}
