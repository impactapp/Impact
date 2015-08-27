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
    
        //tap gesture recognizer
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
       
        initTextFields()
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
    
    
    //MARK: text field actions
    func DismissKeyboard(){
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
        passwordTextField.needsBottomBorder = false
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .Done
        
        emailTextField.delegate = self
        emailTextField.returnKeyType = .Next
        
    }
    
    
    
    
    
    //IB actions
    @IBAction func forgotPasswordButtonPressed(sender: AnyObject) {
        
    }
    @IBAction func signInButtonPressed(sender: AnyObject) {
        var tabBarController = TabBarViewController()
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

}
