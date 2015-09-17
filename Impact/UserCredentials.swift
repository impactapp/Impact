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
    static let shared = UserCredentials()
    
    func updateUserToken(newToken:String) {
        do {
            try Locksmith.updateData([kAuthenticationTokenKey: newToken], forUserAccount: kUserCredentialsConstant)
        }
        catch {
            print("Unable to update Token")
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
}
