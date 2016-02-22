//
//  User.swift
//  Impact
//
//  Created by Anthony Emberley on 12/26/15.
//  Copyright © 2015 Impact. All rights reserved.
//



import UIKit
import SwiftyJSON

class User: NSObject {
    var id: Int!
    var name : String!
    var email : String!
    var facebook_id: Int!
    var current_cause_id: Int!
    var current_cause_name : String!
    var current_cause_join_date: NSDate?
    var total_amount_contributed : Float!
    var current_cause_amount_contributed: Float!
    var last_contribution_date: NSDate?
    var pending_contribution_amount: Int!
    var stripe_customer_id: Int!
    var current_payment_id: Int!
    var weekly_budget: Float!
    var current_streak: Int!
    var total_contributions: Int!
    var device_token: String!
    var needsBankInfo: Bool!
    var needsCreditCardInfo: Bool!
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
        name = json["name"].stringValue
        email = json["email"].stringValue
        facebook_id = json["facebook_id"].intValue
        current_cause_id = json["current_cause_id"].intValue
        current_cause_name = json["current_cause_name"].stringValue
        total_amount_contributed = json["total_amount_contributed"].floatValue
        current_cause_amount_contributed = json["current_cause_amount_contributed"].floatValue
        pending_contribution_amount = json["pending_contribution_amount"].intValue
        stripe_customer_id = json["stripe_customer_id"].intValue
        current_payment_id = json["current_payment_id"].intValue
        weekly_budget = json["weekly_budget"].floatValue
        current_streak = json["current_streak"].intValue
        total_contributions = json["total_contributions"].intValue
        device_token = json["device_token"].stringValue
        needsBankInfo = json["needs_bank_information"].bool ?? false
        needsCreditCardInfo = json["needs_credit_card_information"].bool ?? false
        
        //dates
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let created_at_string = json["created_at"].stringValue
        let updated_at_string = json["updated_at"].stringValue
        let last_contribution_date_string = json["last_contribution_date"].stringValue
        
        let current_cause_join_date_string = json["current_cause_join_date"].stringValue

        current_cause_join_date = dateformatter.dateFromString(current_cause_join_date_string)
        last_contribution_date = dateformatter.dateFromString(last_contribution_date_string)
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
        if name != nil {
            dictionary["name"] = name
        }
        if email != nil{
            dictionary["email"] = email
        }
        if current_cause_id != nil{
            dictionary["current_cause_id"] = current_cause_id
        }
        if current_cause_name != nil{
            dictionary["current_cause_name"] = current_cause_name
        }
        if current_cause_join_date != nil{
            dictionary["current_cause_join_date"] = current_cause_join_date
        }
        if total_amount_contributed != nil{
            dictionary["total_amount_contributed"] = total_amount_contributed
        }
        if current_cause_amount_contributed != nil{
            dictionary["current_cause_amount_contributed"] = current_cause_amount_contributed
        }
        if last_contribution_date != nil {
            dictionary["last_contribution_date"] = last_contribution_date
        }
        if pending_contribution_amount != nil {
            dictionary["pending_contribution_amount"] = pending_contribution_amount
        }
        if stripe_customer_id != nil{
            dictionary["stripe_customer_id"] = stripe_customer_id
        }
        if current_payment_id != nil{
            dictionary["current_payment_id"] = current_payment_id
        }
        if weekly_budget != nil{
            dictionary["weekly_budget"] = weekly_budget
        }
        if current_streak != nil{
            dictionary["current_streak"] = current_streak
        }
        if total_contributions != nil{
            dictionary["total_contributions"] = total_contributions
        }
        if device_token != nil{
            dictionary["device_token"] = device_token
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
