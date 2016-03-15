//
//  SignUpViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: BottomBorderedTextField!
    @IBOutlet var fullNameTextField: BottomBorderedTextField!
    @IBOutlet var passwordTextField: BottomBorderedTextField!
    @IBOutlet var createAccountButton: RoundedButton!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var checkBoxButton: UIButton!
    let checkboxChangeWidth = CGFloat(4)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden = true;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        initTextFields()
        shouldEnableSignUpButton(false)
    }

    func shouldEnableSignUpButton(enable:Bool) {
        self.createAccountButton.enabled = enable
        self.createAccountButton.backgroundColor = enable ? UIColor.customRed() : UIColor(red: 175/255.0, green: 175/255.0, blue: 175/255.0, alpha: 1)
    }

    
    //MARK: TextFieldMethods
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func initTextFields(){
        fullNameTextField.delegate = self
        fullNameTextField.returnKeyType = .Next
        fullNameTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        
        emailTextField.delegate = self
        emailTextField.returnKeyType = .Next
        passwordTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .Done
        emailTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
    }
    
    func textFieldDidChange() {
        let enable = emailTextField.text != "" && fullNameTextField.text != "" && passwordTextField.text!.characters.count >= 6  
        shouldEnableSignUpButton(enable)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == fullNameTextField{
            emailTextField.becomeFirstResponder()
            
        }else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            textField.resignFirstResponder()

        }
        return true
    }
    
    
    //MARK: IBActions
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    @IBAction func termsOfUsePressed(sender: AnyObject) {
        
        //modal segue here
        let touvc = TermsOfServiceViewController()
        touvc.cameFromSignUp = true
        self.presentViewController(touvc, animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonPressed(sender: AnyObject) {
        let payload = ["name":fullNameTextField.text!, "password": passwordTextField.text!, "email": emailTextField.text!]
        ServerRequest.shared.signUpWithPayload(payload, success: { (json) -> Void in
            self.navigateToBankViewController()
            },failure: { (errorMessage) -> Void in
                let alertController = AlertViewController()
                alertController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
                alertController.show()
        })
    }
    
    @IBAction func termsSwitchPressed(sender: AnyObject) {
        textFieldDidChange()
        
    }

    @IBAction func checkBoxButtonPressed(sender: AnyObject) {
        if self.checkBoxButton.selected{
           // self.checkBoxButton.frame = CGRectMake(self.checkBoxButton.frame.origin.x , self.checkBoxButton.frame.origin.y, self.checkBoxButton.frame.size.width - self.checkboxChangeWidth , self.checkBoxButton.frame.size.height)
        }else{
           // self.checkBoxButton.frame = CGRectMake(self.checkBoxButton.frame.origin.x , self.checkBoxButton.frame.origin.y, self.checkBoxButton.frame.size.width + self.checkboxChangeWidth , self.checkBoxButton.frame.size.height)
        }
        self.checkBoxButton.selected = !self.checkBoxButton.selected
    }
    
    func navigateToBankViewController() {
        let chooseBankViewController = ChooseBankViewController(nibName: "ChooseBankViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: chooseBankViewController);
        navigationController.navigationBarHidden = true;
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

}
