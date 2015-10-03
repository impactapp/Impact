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

enum BankType:String {
    case BankOfAmerica = "bofa"
    case AmericanExpress = "amex"
    case CapitalOne = "capone360"
    case CharlesSchwab = "schwab"
    case Chase = "chase"
    case Citi = "citi"
    case Fidelity = "fidelity"
    case PNC = "pnc"
    case SiliconValleyBank = "svb"
    case TDBank = "td"
    case USBank = "us"
    case USAA = "usaa"
    case WellsFargo = "wells"
}

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
    
    private func stagedPostWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON,completed:Bool) -> Void, failure:(error:JSON) -> Void) {
        let path : String = baseURL + endpoint;
        let headers = getRequestHeaders(authenticated)
        Alamofire.request(.POST, path, parameters: parameters, headers:headers, encoding: .JSON).responseJSON{ (request,response, result) -> Void in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                let status = response?.statusCode
                if(status == 200 || status == 201) {
                    success(json: json, completed: status == 200)
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
        return UserCredentials.shared.getUserToken()
    }
    
    private func updateAuthenticationToken(token:String?) {
        if let authToken = token {
            UserCredentials.shared.updateUserToken(authToken)
        }
    }
    
    private func getRequestHeaders(authenticated:Bool) -> [String:String] {
        if (authenticated) {
            if let api_token = getAuthenticationToken() {
                return ["Content-Type" : "application/json", "Accept" : "application/json", "AUTHENTICATION-TOKEN" : api_token];
            }
        }
        return ["Content-Type" : "application/json", "Accept": "application/json"];
    }
    
    //MARK: UserAuthentication
    func signUpWithPayload(payload:NSDictionary, success:(json:JSON) -> Void, failure:(errorMessage:String) -> Void) {
        let parameters = [kUserRequestKey : payload]
        
        postWithEndpoint("signup", parameters: parameters, authenticated: false,
            success: { (json) -> Void in
                self.updateAuthenticationToken(json["authentication_token"].string)
                success(json: json)
            }, failure: { (errorJson) -> Void in
                let errors = errorJson["errors"][0]
                if let reasons = errors["email"].array {
                    let errorMessage = "Email "+(reasons[0].string)!
                    failure(errorMessage: errorMessage)
                }
        })
    }
    
    func loginWithEmail(email:String, password:String, success:(json:JSON) -> Void, failure:(errorMessage:String) -> Void) {
        let parameters = [kUserRequestKey:["email":email, "password":password]]
        postWithEndpoint("login", parameters: parameters, authenticated: false, success: { (json) -> Void in
            self.updateAuthenticationToken(json["authentication_token"].string)
            success(json: json)
            }, failure: { (error) -> Void in
                failure(errorMessage: "Invalid Email and Password")
        })
    }
    
    //MARK: Stripe and Credit Card Info
    
    func createStripeCustomer(card:STPCard,success:(success:Bool) -> Void, failure:(errorMessage:String) -> Void) {
        let apiClient = STPAPIClient(publishableKey: kStripePublishableKey)
        apiClient.createTokenWithCard(card, completion: { (stripeToken, error) -> Void in
            if let token = stripeToken?.tokenId {
                let parameters = ["contribution": ["stripe_generated_token":token]]
                let endpoint = "contributions/add_card"
                self.postWithEndpoint(endpoint, parameters: parameters, authenticated: true, success: { (json) -> Void in
                    success(success: true)
                    }, failure: { (error) -> Void in
                    failure(errorMessage: "Invalid Credit Card Credentials")
                })
            } else {
                var errorMessage = "Invalid Credit Card Credentials"
                if let reason = error?.localizedDescription {
                    errorMessage = reason
                }
                failure(errorMessage: errorMessage)
            }
        })
    }
    
    //MARK: Banks
    
    func submitBankAccountInfo(bankUserName:String, bankPassword:String, bankType:String, pin: String?,success:(isFinished:Bool, question:String?, plaidToken:String?) -> Void, failure:(errorMessage:String) -> Void) {
        let endpoint = "plaid/create"
        var payload = ["username":bankUserName, "password":bankPassword, "bank_type":bankType]
        if let bankPin = pin {
            payload["pin"] = bankPin
        }
        let parameters = ["plaid":payload]
        stagedPostWithEndpoint(endpoint, parameters: parameters, authenticated: true, success: { (json,completed) -> Void in
            var question:String? = nil
            var plaidToken:String? = nil
            if let questions = json["questions"]["mfa"].array {
                if let questionObject = questions[0].dictionary {
                    question = questionObject["question"]!.string
                }
                plaidToken = json["questions"]["access_token"].string
            }
            success(isFinished: completed, question:question, plaidToken:plaidToken)
            }, failure: { (error) -> Void in
                failure(errorMessage: "Invalid Credentials")
        })
    }
    
    func answerMFA(answer:String,plaidToken:String, success:(isFinished:Bool, question:String?, plaidToken:String?) -> Void, failure:(errorMessage:String) -> Void) {
        let endpoint = "plaid/answer"
        let parameters = ["plaid": ["plaid_access_token": plaidToken,
            "answer":answer] ]
        stagedPostWithEndpoint(endpoint, parameters: parameters, authenticated: true, success: { (json, completed) -> Void in
            var question:String? = nil
            if let questions = json["mfa"].array {
                if let questionObject = questions[0].dictionary {
                    question = questionObject["question"]!.string
                }
            }
            success(isFinished: completed, question:question, plaidToken:plaidToken)
            }, failure: { (error) -> Void in
                failure(errorMessage: "That answer is incorrect")
        })
    }
    
    //TODO: load real banks from server
    func getAllBanks(completion:(banks:[Bank]) -> Void) {
        var banks : [Bank] = [];
        let BOA =  Bank(name: "Bank of America", logoURL: "http://about.bankofamerica.com/assets/images/common/bank_logo_256x256.png",bankId:BankType.BankOfAmerica.rawValue);
        let citi = Bank(name: "Citi Bank", logoURL: "http://images.all-free-download.com/images/graphicthumb/citibank_0_62794.jpg", bankId: BankType.Citi.rawValue);
        banks = [BOA, citi,BOA, citi,BOA, citi];
        completion(banks:banks)
    }
}
