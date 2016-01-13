//
//  BlogPost.swift
//  Impact
//
//  Created by Phillip Ou on 1/12/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit
import SwiftyJSON

class BlogPost: NSObject {
    var id: Int!
    var title : String!
    var blog_body : String!
    var image_url: String!
    var cause_id: Int!
    var created_at : NSDate?
    var updated_at : NSDate?
    
    override init() {
        super.init()
    }
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        id = json["id"].intValue
        title = json["title"].stringValue
        blog_body = json["blog_body"].stringValue
        image_url = json["image_url"].stringValue
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
        if title != nil {
            dictionary["title"] = title
        }
        if blog_body != nil{
            dictionary["blog_body"] = blog_body
        }
        if image_url != nil{
            dictionary["image_url"] = image_url
        }
        if cause_id != nil{
            dictionary["current_cause_name"] = cause_id
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
