//
//  Category.swift
//  Impact
//
//  Created by Phillip Ou on 11/1/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit
import SwiftyJSON

class Category: NSObject {
    var id: Int!
    var name : String!
    var icon_url : String!
    var selected_icon_url : String!
    
    private let kDefaultImageURL = "https://credible-content.com/blog/wp-content/uploads/2014/08/content-writing-that-helps.jpg"
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        
        id = json["id"].intValue
        name = json["name"].stringValue
        icon_url = json["icon_url"].stringValue
        selected_icon_url = json["selected_icon_url"].stringValue
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
        if icon_url != nil {
            dictionary["icon_url"] = icon_url
        }
        
        if selected_icon_url != nil {
            dictionary["selected_icon_url"] = selected_icon_url
        }
        
        return dictionary
    }


}
