//
//  ServerRequest.swift
//  Impact
//
//  Created by Phillip Ou on 8/20/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit
import Alamofire

class ServerRequest: NSObject {
    let baseURL = "";
    static let shared = ServerRequest();
    
    //MARK :  Helper Methods
    private func getWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:String) -> Void, failure:(error:String) -> Void) {
        let path : String = baseURL + endpoint;
        let manager = getRequestManager(authenticated);
        Alamofire.request(.GET, path, parameters: parameters).responseJSON{ (request, response, dataResponse, error) -> Void in
            
        };
    }
    
    private func updateWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:String) -> Void, failure:(error:String) -> Void) {
        let path : String = baseURL + endpoint;
        let manager = getRequestManager(authenticated);
        Alamofire.request(.PUT, path, parameters: parameters).responseJSON{ (request, response, dataResponse, error) -> Void in
            
        };
        
    }
    
    private func postWithEndpoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:String) -> Void, failure:(error:String) -> Void) {
        let path : String = baseURL + endpoint;
        let manager = getRequestManager(authenticated);
        Alamofire.request(.POST, path, parameters: parameters).responseJSON{ (request, response, dataResponse, error) -> Void in
            
        };
        
    }
    
    private func deleteWithEndoint(endpoint:String, parameters:[String : AnyObject]?, authenticated:Bool, success:(json:String) -> Void, failure:(error:String) -> Void) {
        let path : String = baseURL + endpoint;
        let manager = getRequestManager(authenticated);
        Alamofire.request(.DELETE, path, parameters: parameters).responseJSON{ (request, response, dataResponse, error) -> Void in
            
        };
        
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
}
