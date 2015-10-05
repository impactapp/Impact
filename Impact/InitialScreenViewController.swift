//
//  InitialScreenViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class InitialScreenViewController: UIViewController {
    var dict : NSDictionary!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().statusBarHidden = true;
    }

    @IBAction func facebookButtonPressed(sender: AnyObject) {
        //if facebook login is present, login.. otherwise sign up with facebook
//        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        [login
//        logInWithReadPermissions: @[@"public_profile"]
//        handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        if (error) {
//        NSLog(@"Process error");
//        } else if (result.isCancelled) {
//        NSLog(@"Cancelled");
//        } else {
//        NSLog(@"Logged in");
//        }
//        }];
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["email", "public_profile"],fromViewController:self, handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email") && fbloginresult.grantedPermissions.contains("public_profile"))
                {
                    self.getFBUserDataAndSendToAPI(fbloginresult)

                }
            }
        })
        
        
    }
    
    
    func getFBUserDataAndSendToAPI(fbLoginResult:FBSDKLoginManagerLoginResult){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! NSDictionary
                    print(result)
                    print(self.dict)
                    NSLog(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                    ServerRequest.shared.loginWithFacebook(self.dict["email"] as! String, facebookAccessToken: fbLoginResult.token.tokenString, facebookID: self.dict["id"] as! String, success: { (json) -> Void in
                        let tabBarController = TabBarViewController()
                        self.presentViewController(tabBarController, animated: true, completion: nil)
                        },failure: { (errorMessage) -> Void in
                            //TODO : Display error
                            
                            print("error:" + errorMessage)
                    })

                }
            })
        }
    }
    
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        let signInViewController = SignInViewController(nibName: "SignInViewController", bundle: nil);
        self.presentViewController(signInViewController, animated: true, completion: nil)

    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let signUpViewController = SignUpViewController(nibName: "SignUpViewController", bundle: nil);
        self.presentViewController(signUpViewController, animated: true, completion: nil)

    }
    

}
