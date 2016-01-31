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
import FBSDKCoreKit

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
    private let useStagingServer = false
    private let baseURL = "https://murmuring-coast-1876.herokuapp.com/api/"
    private let stagingURL = "https://pacific-wildwood-1045.herokuapp.com/api/"
    private let kUserRequestKey = "user"
    private let kFacebookRequestKey = "facebook"
    private let kStripePublishableKey = "pk_test_xxr45bpY3r0T5MZ4dGbeTQ7L"
    static let shared = ServerRequest();
    
    //MARK :  Helper Methods
    private func getWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let url = useStagingServer ? stagingURL : baseURL
        let path : String = url + endpoint;
        let headers = getRequestHeaders(authenticated)
        Alamofire.request(.GET, path, parameters: parameters, headers:headers, encoding: .JSON).responseJSON { response in
            let status = response.response?.statusCode
            if let data = response.data {
                let json = JSON(data:data)
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    failure(error: json)
                }
            }
        }
    }
    
    private func updateWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let url = useStagingServer ? stagingURL : baseURL
        let path : String = url + endpoint
        let headers = getRequestHeaders(authenticated)
        Alamofire.request(.PUT, path, parameters: parameters, headers:headers, encoding: .JSON).responseJSON { response in
            let status = response.response?.statusCode
            if let data = response.data {
                let json = JSON(data:data)
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    failure(error: json)
                }
            }
        }
    }
    
    private func postWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let url = useStagingServer ? stagingURL : baseURL
        let path : String = url + endpoint
        let headers = getRequestHeaders(authenticated)
        Alamofire.request(.POST, path, parameters: parameters, headers:headers, encoding: .JSON).responseJSON { response in
            let status = response.response?.statusCode
            if let data = response.data {
                let json = JSON(data:data)
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    failure(error: json)
                }
            }
        }
    }
    
    private func stagedPostWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON,completed:Bool) -> Void, failure:(error:JSON) -> Void) {
        let url = useStagingServer ? stagingURL : baseURL
        let path : String = url + endpoint
        let headers = getRequestHeaders(authenticated)
        Alamofire.request(.POST, path, parameters: parameters, headers:headers, encoding: .JSON).responseJSON { (response) -> Void in
            let status = response.response?.statusCode
            if let data = response.data {
                let json = JSON(data:data)
                if(status == 200 || status == 201) {
                    success(json: json, completed: (status == 200))
                } else {
                    failure(error: json)
                }
            }

            
        }
    }
    
    private func deleteWithEndoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:JSON) -> Void, failure:(error:JSON) -> Void) {
        let url = useStagingServer ? stagingURL : baseURL
        let path : String = url + endpoint
        let headers = getRequestHeaders(authenticated)
        Alamofire.request(.DELETE, path, parameters: parameters, headers:headers, encoding: .JSON).responseJSON { (response) -> Void in
            let status = response.response?.statusCode
            if let data = response.data {
                let json = JSON(data:data)
                if(status == 200 || status == 201) {
                    success(json: json)
                } else {
                    failure(error: json)
                }
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
    
    func loginWithEmail(email:String, password:String, success:(currentUser:User) -> Void, failure:(errorMessage:String) -> Void) {
        let parameters = [kUserRequestKey:["email":email, "password":password]]
        postWithEndpoint("login", parameters: parameters, authenticated: false, success: { (json) -> Void in
            self.updateAuthenticationToken(json["authentication_token"].string)
            let result:User =  User(fromJson:json)
            success(currentUser: result)
            }, failure: { (error) -> Void in
                failure(errorMessage: "Invalid Email and Password")
        })
    }
    
    //MARK: User
    func getCurrentUser(completion:(currentUser:User) -> Void) {
        let endpoint = "current_user"
        
        getWithEndpoint(endpoint, parameters: nil, authenticated: true, success: { (json) -> Void in
            let result:User =  User(fromJson:json)
            completion(currentUser: result)
            },failure: { (error) -> Void in
                
        })
    }
    
    func postClearUserStreak(completion:(currentUser:User) -> Void) {
        let endpoint = "current_user/update/clear_streak"
        postWithEndpoint(endpoint, parameters: nil, authenticated: true, success: { (json) -> Void in
            let result:User =  User(fromJson:json)
            completion(currentUser: result)
            },failure: { (error) -> Void in
                
        })
    }
    
    
    //MARK: Facebook
    
    
    func loginWithFacebook(email:String, facebookAccessToken:String, facebookID:String, success:(currentUser:User) -> Void, failure:(errorMessage:String)->Void){
        let parameters = [kFacebookRequestKey:["email":email, "facebook_id":facebookID, "facebook_access_token":facebookAccessToken]]
        
        postWithEndpoint("facebook_auth", parameters: parameters, authenticated: false, success: { (json) -> Void in
            
            self.updateAuthenticationToken(json["authentication_token"].string)
            let result:User =  User(fromJson:json)
            
            success(currentUser: result)
            
            }, failure: { (error) -> Void in
                
                if let errorArray = error["errors"].array {
                    let errorMessage = errorArray[0]
                    failure(errorMessage: errorMessage.string!)
                }
        })
    
    }
    
    func getFacebookFriends(friends:(friends:[AnyObject]) -> Void) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            let params = ["fields":"name,id"]
            let request = FBSDKGraphRequest(graphPath: "/me/friends", parameters: params, HTTPMethod: "GET")
            request.startWithCompletionHandler({ (connection, result, error) -> Void in
                
            })
        }

    }
    
    
    
    //MARK: Stripe and Credit Card Info
    
    func updateStripeCustomer(card:STPCard,success:(success:Bool) -> Void, failure:(errorMessage:String) -> Void) {
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
    
    func getCreditCards(success:(cards:[CreditCard]) -> Void, failure:(errorMessage:String) -> Void) {
        let endpoint = "stripe/cards"
        getWithEndpoint(endpoint, parameters: nil, authenticated: true, success: { (json) -> Void in
            var result: [CreditCard] = []
            if let array = json.array {
                for jsonObject in array {
                    result.append(CreditCard(fromJson: jsonObject))
                }
            }
            success(cards: result)

            },failure: { (error) -> Void in
               
                
        })
    }
    
    //MARK: Contributions
    func getContributions(completion:(contributions:[Contribution]) -> Void) {
        let endpoint = "current_user/contributions"
        
        getWithEndpoint(endpoint, parameters: nil, authenticated: true, success: { (json) -> Void in
            var result: [Contribution] = []
            if let array = json.array {
                for jsonObject in array {
                    result.append(Contribution(fromJson: jsonObject))
                }
            }
            completion(contributions: result)
            },failure: { (error) -> Void in
                
        })
    }
    
    
    
    //MARK: Categories
    
    func getCategories(completion:(categories:[Category]) -> Void) {
        let endpoint = "categories"
        
        getWithEndpoint(endpoint, parameters: nil, authenticated: true, success: { (json) -> Void in
            var result: [Category] = []
            if let array = json.array {
                for jsonObject in array {
                    result.append(Category(fromJson: jsonObject))
                }
            }
            completion(categories: result)
            },failure: { (error) -> Void in
                
        })
    }
    
    func chooseCategories(categories:[Category], completion:(success:Bool) -> Void) {
        let endpoint = "categories/choose"
        
        let parameters = ["categories":["category_ids":categories.map{$0.id}]]
        postWithEndpoint(endpoint, parameters: parameters, authenticated: true, success: { (json) -> Void in
            
            completion(success:true)
            },failure: { (error) -> Void in
                completion(success:false)
        })
    }
    
    //MARK: Causes
    
    func getAllCauses(completion:(causes:[Cause]) -> Void) {
        let endpoint = "causes/all"
        getWithEndpoint(endpoint, parameters: nil, authenticated: true, success: { (json) -> Void in
            var result: [Cause] = []
            if let array = json.array {
                for jsonObject in array {
                    result.append(Cause(fromJson: jsonObject))
                }
            }
            completion(causes: result)
            },failure: { (error) -> Void in
        })
    }
    
    func getPreviousCauses(completion:(causes:[Cause]) -> Void) {
        let endpoint = "current_user/causes"
        getWithEndpoint(endpoint, parameters: nil, authenticated: true, success: { (json) -> Void in
            var result: [Cause] = []
            if let array = json.array {
                for jsonObject in array {
                    result.append(Cause(fromJson:jsonObject))
                }
            }
            completion(causes:result)
            
            }, failure: { (error) -> Void in
                
        })
    }
    
    func joinCause(cause:Cause, success:(successful:Bool) -> Void, failure:(errorMessage:String)->Void) {
        let endpoint = "causes/\(cause.id)/join"
        postWithEndpoint(endpoint, parameters: nil, authenticated: true, success: { (json) -> Void in
            success(successful: true)
            }, failure: { (error) -> Void in
                failure(errorMessage: "Unable to join cause")
        })
    }
    
    func getCauseBlogPostsAndContributors(cause:Cause, success:(blogPosts:[BlogPost], contributors: [User]) -> Void, failure:(errorMessage:String)->Void) {
        let endpoint = "causes/show_extra/\(cause.id)"
        getWithEndpoint(endpoint, parameters: nil, authenticated: true, success: { (json) -> Void in
            var blogPosts : [BlogPost] = []
            if let array = json["blogs_posts"].array {
                for jsonObject in array {
                    blogPosts.append(BlogPost(fromJson: jsonObject))
                }
            }
            var contributors : [User] = []
            if let array = json["fb_sorted_users"].array {
                for jsonObject in array {
                    contributors.append(User(fromJson: jsonObject))
                }
            }
            success(blogPosts: blogPosts, contributors: contributors)
            },failure: { (error) -> Void in
                
                failure(errorMessage: "Unable to retrieve blog posts from cause")
        })
    }
    
    //MARK: Banks
    
    func submitBankAccountInfo(bankUserName:String, bankPassword:String, bankType:String, pin: String?,success:(isFinished:Bool,user:User?, question:String?, plaidToken:String?) -> Void, failure:(errorMessage:String) -> Void) {
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
            var user:User? = nil
            if completed {
                user = User(fromJson: json)
            }
            success(isFinished: completed,user:user, question:question, plaidToken:plaidToken)
            }, failure: { (error) -> Void in
                failure(errorMessage: "Invalid Credentials")
        })
    }
    
    func answerMFA(answer:String,plaidToken:String, success:(isFinished:Bool, user:User?, question:String?, plaidToken:String?) -> Void, failure:(errorMessage:String) -> Void) {
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
            var user:User? = nil
            if completed {
                user = User(fromJson: json)
            }
            success(isFinished: completed,user:user, question:question, plaidToken:plaidToken)
            }, failure: { (error) -> Void in
                failure(errorMessage: "That answer is incorrect")
        })
    }
    
    //TODO: load real banks from server
    func getAllBanks(completion:(banks:[Bank]) -> Void) {
        var banks : [Bank] = [];
        let endpoint = "plaid/banks"
        getWithEndpoint(endpoint, parameters: nil, authenticated: true, success: { (json) -> Void in
            if let banksResponse = json.array {
                for bankJSON in banksResponse {
                    banks.append(Bank(json: bankJSON))
                }
            }
            completion(banks:banks)
            }, failure: { (error) -> Void in
                
        })
        
    }
}
