//
//  InitialScreenViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class InitialScreenViewController: UIViewController {

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
