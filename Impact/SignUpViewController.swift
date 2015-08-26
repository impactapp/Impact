//
//  SignUpViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var emailTextField: BottomBorderedTextField!
    @IBOutlet var fullNameTextField: BottomBorderedTextField!
    @IBOutlet var passwordTextField: BottomBorderedTextField!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.needsBottomBorder = false
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
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    
    @IBAction func createAccountButtonPressed(sender: AnyObject) {
        
        var chooseBankViewController = ChooseBankViewController(nibName: "ChooseBankViewController", bundle: nil);
        let navigationController = UINavigationController(rootViewController: chooseBankViewController);
        navigationController.navigationBarHidden = true;
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }

}
