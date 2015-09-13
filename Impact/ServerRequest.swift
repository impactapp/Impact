//
//  ServerRequest.swift
//  Impact
//
//  Created by Phillip Ou on 8/20/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ServerRequest: NSObject {
    let baseURL = "https://murmuring-coast-1876.herokuapp.com/api/";
    let kUserRequestKey = "user"
    static let shared = ServerRequest();
    
    //MARK :  Helper Methods
    private func getWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let path : String = baseURL + endpoint;
        let manager = getRequestManager(authenticated);
        Alamofire.request(.GET, path, parameters: parameters).responseJSON{ (request, response, dataResponse, error) -> Void in
            if let data: AnyObject = dataResponse {
                let json = JSON(data)
                let status = response?.statusCode
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    println("Error: \(json)")
                    failure(error: json["errors"])
                }
            }
        }
    }
    
    private func updateWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let path : String = baseURL + endpoint;
        let manager = getRequestManager(authenticated);
        Alamofire.request(.PUT, path, parameters: parameters).responseJSON{ (request, response, dataResponse, error) -> Void in
            if let data: AnyObject = dataResponse {
                let json = JSON(data)
                let status = response?.statusCode
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    failure(error: json)
                }
            }

        }
        
    }
    
    private func postWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let path : String = baseURL + endpoint;
        let manager = getRequestManager(authenticated);
        Alamofire.request(.POST, path, parameters: parameters).responseJSON{ (request, response, dataResponse, error) -> Void in
            if let data: AnyObject = dataResponse {
                let json = JSON(data)
                let status = response?.statusCode
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    failure(error: json["errors"])
                }
            }
        }
    }
    
    private func deleteWithEndoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let path : String = baseURL + endpoint;
        let manager = getRequestManager(authenticated);
        Alamofire.request(.DELETE, path, parameters: parameters).responseJSON{ (request, response, dataResponse, error) -> Void in
            if let data: AnyObject = dataResponse {
                let json = JSON(data)
                let status = response?.statusCode
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    failure(error: json)
                }
            }
        }
        
    }
    
    private func getAuthenticationToken() -> String? {
        return "";
    }
    
    private func getRequestManager(authenticated:Bool) -> Manager {
        var manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type" : "application/json", "Accept": "application/json"];
        if (authenticated) {
            if let api_token = getAuthenticationToken() {
                manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type" : "application/json", "Accept" : "application/json", "API-TOKEN" : api_token];
            }
        }
        return manager;
    }
    
    //MARK: UserAuthentication
    func signUpWithPayload(payload:NSDictionary, success:(json:JSON) -> Void, failure:(errorMessage:String) -> Void) {
        let parameters = [kUserRequestKey : payload]
        postWithEndpoint("signup", parameters: parameters, authenticated: false, success: { (json) -> Void in
            //TODO : UPDATE CORE DATA
            success(json: json)
            }, failure: { (error) -> Void in
                let errorObject = error.object as! NSMutableArray
                let error = errorObject[0] as! NSDictionary
                let reasons = error["email"] as! NSArray
                let errorMessage = "Email "+(reasons[0] as! String)
                failure(errorMessage: errorMessage)
        })
    }
    
    func loginWithEmail(email:String, password:String, success:(json:JSON) -> Void, failure:(errorMessage:String) -> Void) {
        let parameters = [kUserRequestKey:["email":email, "password":password]]
        postWithEndpoint("login", parameters: parameters, authenticated: false, success: { (json) -> Void in
            //TODO : UPDATE CORE DATA
            success(json: json)
            }, failure: { (error) -> Void in
                failure(errorMessage: "Invalid Email and Password")
        })
    }
    
    //MARK: Banks
    
    //TODO: load real banks from server
    func getAllBanks(completion:(banks:[Bank]) -> Void) {
        var banks : [Bank] = [];
        let BOA =  Bank(name: "Bank of America", logoURL: "http://about.bankofamerica.com/assets/images/common/bank_logo_256x256.png",bankId:"BOA");
        let citi = Bank(name: "Citi Bank", logoURL: "http://images.all-free-download.com/images/graphicthumb/citibank_0_62794.jpg", bankId: "citi");
        banks = [BOA, citi,BOA, citi,BOA, citi];
        completion(banks: banks)
    }
}
