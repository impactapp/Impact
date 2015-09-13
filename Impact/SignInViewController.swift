//
//  SignInViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: BottomBorderedTextField!
    @IBOutlet var passwordTextField: BottomBorderedTextField!
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var forgotButton: UIButton!
    @IBOutlet var signInButton: RoundedButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden = true;
        //tap gesture recognizer
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
       
        initTextFields()
        shouldEnableSignInButton(false)
        
        // Do any additional setup after loading the view.
    }
    
    func shouldEnableSignInButton(enable:Bool) {
        self.signInButton.enabled = enable
        self.signInButton.backgroundColor = enable ? UIColor.customRed() : UIColor(red: 175/255.0, green: 175/255.0, blue: 175/255.0, alpha: 1)
    }
    
    
    //MARK: text field actions
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
            
        }else if textField == passwordTextField{
            
            textField.resignFirstResponder()

        }
        return true
    }
    
    func initTextFields(){
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .Done
        passwordTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        
        emailTextField.delegate = self
        emailTextField.returnKeyType = .Next
        emailTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        
    }
    
    func textFieldDidChange() {
        let enable = emailTextField.text != "" && count(passwordTextField.text) >= 6;
        shouldEnableSignInButton(enable)
    }
    
    //IB actions
    @IBAction func forgotPasswordButtonPressed(sender: AnyObject) {
       let flvc = ForgetLoginViewController(nibName: "ForgetLoginViewController", bundle: nil);
        self.presentViewController(flvc, animated: true, completion: nil)
    }
    @IBAction func signInButtonPressed(sender: AnyObject) {
        ServerRequest.shared.loginWithEmail(emailTextField.text, password: passwordTextField.text, success: { (json) -> Void in
            var tabBarController = TabBarViewController()
            self.presentViewController(tabBarController, animated: true, completion: nil)
            },failure: { (errorMessage) -> Void in
            //TODO : Display error
        })
    }
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

}
