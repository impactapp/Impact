//
//  UserCredentials.swift
//  Impact
//
//  Created by Phillip Ou on 9/16/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit
import KeychainSwift

class UserCredentials: NSObject {
    let kUserCredentialsConstant = "UserCredentials"
    let kAuthenticationTokenKey = "authenticationToken"
    let kFacebookCredentials = "FacebookCredentials"
    let kFacebookToken = "facebookToken"
    let kFacebookID = "facebookID"
    let kDeviceToken = "deviceToken"
    let keychain = KeychainSwift()
    static let shared = UserCredentials()
    
    func updateUserToken(newToken:String) {
        if keychain.set(newToken, forKey: kAuthenticationTokenKey) {
            
        } else {
            print("Unable to Update Token in Keychain")
        }
    }
    
    func deleteUserToken() {
        keychain.clear()
    }
    
    func updateDeviceToken(deviceToken:String) {
        if keychain.set(deviceToken, forKey: kDeviceToken) {
            
        } else {
            print("Unable to Update device token in Keychain")
        }
    }
    
    func getUserToken() -> String? {
        return keychain.get(kAuthenticationTokenKey)
    }
    
    func updateFacebookInfo(facebookID:String,facebookToken:String) {
        keychain.set(facebookToken, forKey: kFacebookToken)
        keychain.set(facebookID, forKey: kFacebookID)
    }
    
    func getFacebookCredentials() -> [String:[String:AnyObject?]]? {
        let facebookID = getFacebookID();
        let facebookToken = getFacebookToken()
        let credentials : [String:AnyObject?] = [kFacebookID:facebookID, kFacebookToken:facebookToken];
        return [kFacebookCredentials: credentials]
    }
    
    func getFacebookID() -> String? {
        return keychain.get(kFacebookID)
    }
    
    func getFacebookToken() -> String? {
        return keychain.get(kFacebookToken)
    }
}
