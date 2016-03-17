//
//  Cause.swift
//  Impact
//
//  Created by Phillip Ou on 10/16/15.
//  Copyright © 2015 Impact. All rights reserved.
//
import SwiftyJSON

class Cause: NSObject {
    var category : String!
    var createdAt : NSDate?
    var currentTotal : Int!
    var descriptionField : String!
    var endDate : NSDate?
    var goal : Int!
    var id : Int!
    var name : String!
    var numberOfContributors : Int!
    var organizationId : Int!
    var organizationName : String!
    var organizationLogoUrl : String!
    var profileImageUrl : String!
    var updatedAt : NSDate?
    var state:String!
    var city:String!
    var longitude:Float!
    var latitude:Float!
    
    private let kDefaultImageURL = "https://upload.wikimedia.org/wikipedia/commons/b/be/Beldon_Field.jpg"
    
    /**
    * Instantiate the instance using the passed json values to set the properties values
    */
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        category = json["category"].stringValue
        currentTotal = json["current_total"].intValue
        descriptionField = json["description"].stringValue
        endDate = json["end_date"].stringValue.convertToDate()
        goal = json["goal"].intValue
        id = json["id"].intValue
        name = json["name"].stringValue
        numberOfContributors = json["number_of_contributors"].intValue
        organizationId = json["organization_id"].intValue
        organizationName = json["organization_name"].stringValue
        organizationLogoUrl = json["organization_logo_url"].stringValue
        profileImageUrl = json["profile_image_url"].stringValue
        if profileImageUrl.characters.count == 0 {
            profileImageUrl = kDefaultImageURL
        }
        state = json["state"].stringValue
        city = json["city"].stringValue
        longitude = json["longitude"].floatValue
        latitude = json["latitude"].floatValue
        
        
        
        //dates
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let created_at_string = json["created_at"].stringValue
        let updated_at_string = json["updated_at"].stringValue
        createdAt = dateformatter.dateFromString(created_at_string)
        updatedAt = dateformatter.dateFromString(updated_at_string)
    }
    
    /**
    * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
    */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if category != nil{
            dictionary["category"] = category
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if currentTotal != nil{
            dictionary["current_total"] = currentTotal
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if endDate != nil{
            dictionary["end_date"] = endDate
        }
        if goal != nil{
            dictionary["goal"] = goal
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if numberOfContributors != nil{
            dictionary["number_of_contributors"] = numberOfContributors
        }
        if organizationId != nil{
            dictionary["organization_id"] = organizationId
        }
        if organizationName != nil{
            dictionary["organization_name"] = organizationName
        }
        if organizationLogoUrl != nil{
            dictionary["organization_logo_url"] = organizationLogoUrl
        }
        if profileImageUrl != nil{
            dictionary["profile_image_url"] = profileImageUrl
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }


}
