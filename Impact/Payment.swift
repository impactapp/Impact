//
//  Payment.swift
//  Impact
//
//  Created by Phillip Ou on 2/20/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit
import SwiftyJSON
/*
{
"amount" : "281.0",
"payment_id" : 6,
"id" : 61,
"created_at" : "2016-02-20T23:15:52.127Z",
"cause_name" : "Address Cause",
"user_id" : 46,
"user_name" : "Phillip Ou",
"updated_at" : "2016-02-20T23:15:52.127Z",
"cause_id" : 3
}
*/

class Payment: NSObject {
    var id: Int!
    var amount : String!
    var payment_id: Int!
    var created_at : NSDate!
    var cause_name : String!
    var user_name : String!
    var user_id : Int!
    var cause_id : Int!
    var updated_at : NSDate!
    
    /**
    * Instantiate the instance using the passed json values to set the properties values
    */
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        id = json["id"].intValue
        amount = json["amount"].stringValue
        payment_id = json["payment_id"].intValue
        cause_name = json["cause_name"].stringValue
        user_name = json["user_name"].stringValue
        user_id = json["user_id"].intValue
        cause_id = json["cause_id"].intValue
        
        //dates
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let created_at_string = json["created_at"].stringValue
        let updated_at_string = json["updated_at"].stringValue
        
        created_at = dateformatter.dateFromString(created_at_string)
        updated_at = dateformatter.dateFromString(updated_at_string)
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if id != nil {
            dictionary["id"] = id
        }
        if amount != nil {
            dictionary["amount"] = amount
        }
        if payment_id != nil{
            dictionary["payment_id"] = payment_id
        }
        if cause_name != nil{
            dictionary["cause_name"] = cause_name
        }
        if user_name != nil{
            dictionary["user_name"] = user_name
        }
        if user_id != nil{
            dictionary["user_id"] = user_id
        }
        if cause_id != nil{
            dictionary["cause_id"] = cause_id
        }
        if created_at != nil{
            dictionary["created_at"] = created_at
        }
        
        if updated_at != nil{
            dictionary["updated_at"] = updated_at
        }
        
        return dictionary
    }
    

}
