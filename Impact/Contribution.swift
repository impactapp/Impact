//
//  Contribution.swift
//  Impact
//
//  Created by Anthony Emberley on 12/26/15.
//  Copyright © 2015 Impact. All rights reserved.
//


import UIKit
import SwiftyJSON

class Contribution: NSObject {
    var id: Int!
    var amount : Float!
    var user_id : Int!
    var user_name : String!
    var cause_id : Int!
    var payment_id : Int!
    var created_at : NSDate?
    var updated_at : NSDate?
    
    /**
    * Instantiate the instance using the passed json values to set the properties values
    */
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        id = json["id"].intValue
        amount = json["amount"].floatValue
        user_id = json["user_id"].intValue
        user_name = json["user_name"].stringValue
        cause_id = json["cause_id"].intValue
        payment_id = json["payment_id"].intValue
        created_at = json["created_at"].stringValue.convertToDate()
        updated_at = json["updated_at"].stringValue.convertToDate()
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
        if user_id != nil{
            dictionary["user_id"] = user_id
        }
        if user_name != nil{
            dictionary["user_name"] = user_name
        }
        if cause_id != nil{
            dictionary["cause_id"] = cause_id
        }
        if payment_id != nil{
            dictionary["payment_id"] = payment_id
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