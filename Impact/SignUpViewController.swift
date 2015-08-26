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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.needsBottomBorder = false
        // Do any additional setup after loading the view.
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        initTextFields()
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
    
    //MARK: TextFieldMethods
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func initTextFields(){
        fullNameTextField.delegate = self
        fullNameTextField.returnKeyType = .Next
        
        emailTextField.delegate = self
        emailTextField.returnKeyType = .Next
        
        
        passwordTextField.needsBottomBorder = false
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .Done
        
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
 
    
    @IBAction func createAccountButtonPressed(sender: AnyObject) {
        
        var chooseBankViewController = ChooseBankViewController(nibName: "ChooseBankViewController", bundle: nil);
        let navigationController = UINavigationController(rootViewController: chooseBankViewController);
        navigationController.navigationBarHidden = true;
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }

}
