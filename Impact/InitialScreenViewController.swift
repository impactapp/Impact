//
//  InitialScreenViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class InitialScreenViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden = true;
    }

    @IBAction func facebookButtonPressed(sender: AnyObject) {
        
    }
    @IBAction func signInButtonPressed(sender: AnyObject) {
        var signInViewController = SignInViewController(nibName: "SignInViewController", bundle: nil);
        self.presentViewController(signInViewController, animated: true, completion: nil)

    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        var signUpViewController = SignUpViewController(nibName: "SignUpViewController", bundle: nil);
        self.presentViewController(signUpViewController, animated: true, completion: nil)

    }
    

}
