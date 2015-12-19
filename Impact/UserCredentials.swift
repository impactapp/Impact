//
//  UserCredentials.swift
//  Impact
//
//  Created by Phillip Ou on 9/16/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit
import Locksmith

class UserCredentials: NSObject {
    let kUserCredentialsConstant = "UserCredentials"
    let kAuthenticationTokenKey = "authenticationToken"
    let kFacebookCredentials = "FacebookCredentials"
    let kFacebookToken = "facebookToken"
    let kFacebookID = "facebookID"
    let kDeviceToken = "deviceToken"
    static let shared = UserCredentials()
    
    func updateUserToken(newToken:String) {
        do {
            try Locksmith.updateData([kAuthenticationTokenKey: newToken], forUserAccount: kUserCredentialsConstant)
        }
        catch {
            print("Unable to update Authentication Token")
        }
    }
    
    func updateDeviceToken(deviceToken:String) {
        do {
            try Locksmith.updateData([kDeviceToken: deviceToken], forUserAccount: kUserCredentialsConstant)
        }
        catch {
            print("Unable to update Device Token")
        }
        
    }
    
    func getCredentials() -> [String:AnyObject?]? {
        return Locksmith.loadDataForUserAccount(kUserCredentialsConstant)
    }
    
    func getUserToken() -> String? {
        if let credentials = getCredentials() {
            return credentials[kAuthenticationTokenKey] as? String
        }
        return nil
    }
    
    func updateFacebookInfo(facebookID:String,facebookToken:String) {
        do {
            try Locksmith.updateData([kFacebookToken:facebookToken, kFacebookID:facebookID], forUserAccount: kFacebookCredentials)
        }
        catch {
            print("Unable to update Token")
        }
    }
    
    func getFacebookCredentials() -> [String:AnyObject?]? {
        return Locksmith.loadDataForUserAccount(kFacebookCredentials)
    }
    
    func getFacebookID() -> String? {
        if let fbcredentials = getFacebookCredentials() {
            return fbcredentials[kFacebookID] as? String
        }
        return nil
    }
    
    func getFacebookToken() -> String? {
        if let fbcredentials = getFacebookCredentials() {
            return fbcredentials[kFacebookToken] as? String
        }
        return nil
    }
}
