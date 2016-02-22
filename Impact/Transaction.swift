//
//  Transaction.swift
//  Impact
//
//  Created by Anthony Emberley on 1/29/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit
import SwiftyJSON

class Transaction: NSObject {
    
    var _id: String!
    var amount : Float!
    var account : String!
    var name : String!
    var date : NSDate!
    var pending : Bool!
    
    var category : String!
    var category_id : Int!
    //var score : NSObject!
    //var meta : NSObject!
    //var type : NSObject!
    //TODO see what we should do for nsobjects?
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        _id = json["_id"].stringValue
        amount = json["amount"].floatValue
        account = json["user_id"].stringValue
        name = json["name"].stringValue
        pending = json["payment_id"].boolValue
        category = json["category"].stringValue
        category_id = json["category_id"].intValue
        
        //TODO figure out what these are for and if we need them
        //meta = json["meta"]
        //type = json["type"]
        //score = json["score"]
        
        //dates
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        let date_string = json["date"].stringValue
        date = dateformatter.dateFromString(date_string)
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if _id != nil {
            dictionary["_id"] = _id
        }
        if amount != nil {
            dictionary["amount"] = amount
        }
        if account != nil{
            dictionary["account"] = account
        }
        if name != nil{
            dictionary["name"] = name
        }
        if pending != nil{
            dictionary["pending"] = pending
        }
        if category != nil{
            dictionary["category"] = category
        }
        if category_id != nil{
            dictionary["category_id"] = category_id
        }
        if date != nil{
            dictionary["date"] = date
        }
//        if meta != nil{
//            dictionary["meta"] = meta
//        }
//        if type != nil{
//            dictionary["type"] = type
//        }
//        if score != nil{
//            dictionary["score"] = score
//        }
        
        return dictionary
    }
    


}
