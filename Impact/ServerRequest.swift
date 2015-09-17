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
import Stripe

class ServerRequest: NSObject {
    private let baseURL = "https://murmuring-coast-1876.herokuapp.com/api/";
    private let kUserRequestKey = "user"
    private let kStripePublishableKey = "pk_test_xxr45bpY3r0T5MZ4dGbeTQ7L"
    static let shared = ServerRequest();
    
    //MARK :  Helper Methods
    private func getWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let path : String = baseURL + endpoint;
        let headers = getRequestHeaders(authenticated)
        Alamofire.request(.GET, path, parameters: parameters, headers:headers, encoding: .JSON).responseJSON{ (request,response, result) -> Void in
            switch result {
                case .Success(let data):
                    let json = JSON(data)
                    let status = response?.statusCode
                    if(status == 200 || status == 201) {
                        success(json: json)
                    } else {
                        failure(error: json)
                }
                case .Failure(let errorData):
                    print("Error: \(errorData)")
            }
        }
    }
    
    private func updateWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let path : String = baseURL + endpoint;
        let headers = getRequestHeaders(authenticated)
        Alamofire.request(.PUT, path, parameters: parameters, headers:headers, encoding: .JSON).responseJSON{ (request,response, result) -> Void in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                let status = response?.statusCode
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    failure(error: json)
                }
            case .Failure(let errorData):
                print("Error: \(errorData)")
            }
        }
        
    }
    
    private func postWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let path : String = baseURL + endpoint;
        let headers = getRequestHeaders(authenticated)
        Alamofire.request(.POST, path, parameters: parameters, headers:headers, encoding: .JSON).responseJSON{ (request,response, result) -> Void in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                let status = response?.statusCode
                
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    failure(error: json)
                }
            case .Failure(let errorData):
                print("Error: \(errorData)")
            }
        }
    }
    
    private func deleteWithEndoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let path : String = baseURL + endpoint;
        let headers = getRequestHeaders(authenticated)
        Alamofire.request(.DELETE, path, parameters: parameters, headers:headers, encoding: .JSON).responseJSON{ (request,response, result) -> Void in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                let status = response?.statusCode
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    failure(error: json)
                }
            case .Failure(let errorData):
                print("Error: \(errorData)")
            }
        }
    }
    
    private func getAuthenticationToken() -> String? {
        return "";
    }
    
    private func getRequestHeaders(authenticated:Bool) -> [String:String] {
        if (authenticated) {
            if let api_token = getAuthenticationToken() {
                return ["Content-Type" : "application/json", "Accept" : "application/json", "API-TOKEN" : api_token];
            }
        }
        return ["Content-Type" : "application/json", "Accept": "application/json"];
    }
    
    //MARK: UserAuthentication
    func signUpWithPayload(payload:NSDictionary, success:(json:JSON) -> Void, failure:(errorMessage:String) -> Void) {
        let parameters = [kUserRequestKey : payload]
        
        postWithEndpoint("signup", parameters: parameters, authenticated: false, success: { (json) -> Void in
            //TODO : UPDATE CORE DATA
            success(json: json)
            }, failure: { (error) -> Void in
                let errorObject = error.object as! NSDictionary
                let reasons = errorObject["email"] as! NSArray
                let errorMessage = "Email "+(reasons[0] as! String)
                failure(errorMessage: errorMessage)
        })
    }
    
    func loginWithEmail(email:String, password:String, success:(json:JSON) -> Void, failure:(errorMessage:String) -> Void) {
        let parameters = [kUserRequestKey:["email":email, "password":password]]
        postWithEndpoint("login", parameters: parameters, authenticated: false, success: { (json) -> Void in
            //TODO : UPDATE CORE DATA
            if let authenticationToken = json["authentication_token"].string {
                UserCredentials.shared.updateUserToken(authenticationToken)
            }
            success(json: json)
            }, failure: { (error) -> Void in
                failure(errorMessage: "Invalid Email and Password")
        })
    }
    
    //MARK: Stripe and Credit Card Info
    
    func createStripeCustomer(card:STPCard,success:(json:JSON) -> Void, failure:(errorMessage:String) -> Void) {
        let apiClient = STPAPIClient(publishableKey: kStripePublishableKey)
        apiClient.createTokenWithCard(card, completion: { (stripeToken, error) -> Void in
            if let token = stripeToken?.tokenId {
                let parameters = ["contribution": ["stripe_generated_token":token]]
                let endpoint = "contributions/add_card"
                
                
            } else {
                
            }
            
        })
    }
    
    
    //MARK: Banks
    
    //TODO: load real banks from server
    func getAllBanks(completion:(banks:[Bank]) -> Void) {
        var banks : [Bank] = [];
        let BOA =  Bank(name: "Bank of America", logoURL: "http://about.bankofamerica.com/assets/images/common/bank_logo_256x256.png",bankId:"BOA");
        let citi = Bank(name: "Citi Bank", logoURL: "http://images.all-free-download.com/images/graphicthumb/citibank_0_62794.jpg", bankId: "citi");
        banks = [BOA, citi,BOA, citi,BOA, citi];
        completion(banks:banks)
    }
}
