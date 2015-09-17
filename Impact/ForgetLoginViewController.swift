//
//  ForgetLoginViewController.swift
//  Impact
//
//  Created by Phillip Ou on 8/26/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class ForgetLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: BottomBorderedTextField!
    @IBOutlet var sendLinkButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden = true;
        //tap gesture recognizer
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        initTextFields()
        shouldEnableSendLinkButton(false)
        
        // Do any additional setup after loading the view.
    }
    
    func shouldEnableSendLinkButton(enable:Bool) {
        sendLinkButton.enabled = enable
        sendLinkButton.backgroundColor = enable ? UIColor.customRed() : UIColor(red: 175/255.0, green: 175/255.0, blue: 175/255.0, alpha: 1)
    }
    
    
    //MARK: text field actions
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func initTextFields() {
        emailTextField.delegate = self
        emailTextField.returnKeyType = .Done
        emailTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
    }
    
    func textFieldDidChange() {
        let enable = emailTextField.text != ""
        shouldEnableSendLinkButton(enable)
    }
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
