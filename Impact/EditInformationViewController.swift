//
//  EditInformationViewController.swift
//  Impact
//
//  Created by Phillip Ou on 2/1/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

enum EditField : String {
    case Name = "Name"
    case Email = "Email"
    case Password = "Password"
}

protocol UpdateUserInformationDelegate {
    func updateUserInfo(user:User)
}

class EditInformationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    var user : User? = nil
    var editType : EditField = .Name
    var userInfoDelegate : UpdateUserInformationDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.editType.rawValue
        configureTextField()

    }

    func configureTextField() {
        if let user = self.user {
            if editType == .Name {
                self.editTextField.text = user.name
            } else if editType == .Email {
                self.editTextField.text = user.email
            } else if editType == .Password {
                self.editTextField.text = ""
                self.editTextField.placeholder = "Enter New Password"
                self.confirmTextField.text = ""
                self.confirmTextField.placeholder = "Confirm New Password"
            }
            
        }
        
        self.editTextField.secureTextEntry = editType == .Password
        self.editTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        if editType == .Password {
            self.editTextField.returnKeyType = .Next
        } else {
            self.editTextField.returnKeyType = .Done
        }
        self.editTextField.delegate = self
        
        self.confirmTextField.hidden = self.editType != .Password
        self.confirmTextField.returnKeyType = .Done
        self.confirmTextField.secureTextEntry = editType == .Password
        self.confirmTextField.delegate = self
        self.confirmTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        self.confirmTextField.delegate = self

        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if editType == .Password && textField == self.editTextField {
            self.confirmTextField.becomeFirstResponder()
            return true
        }
        if self.editType == .Email {
            if let text = textField.text {
                changeEmail(text)
            }
        }
        if self.editType == .Password {
            if let password = self.editTextField.text {
                if let confirmPassword = self.confirmTextField.text {
                    changePassword(password,newPasswordConfirm: confirmPassword)
                }
                
            }
        }
        
        return true
    }
    
    func changeName(newName:String) {
    }
    
    func changeEmail(newEmail:String) {
        if (isValidEmail(newEmail)) {
            ServerRequest.shared.changeEmail(newEmail) { (currentUser) -> Void in
                if let delegate = self.userInfoDelegate {
                    delegate.updateUserInfo(currentUser)
                }
                self.navigationController?.popViewControllerAnimated(true)
            }
        } else {
            let alertController = AlertViewController()
            alertController.setUp(self, title: "Error!", message: "Please Enter a Valid Email", buttonText: "Dismiss")
            alertController.show()
        }
        
    }
    
    func changePassword(newPassword:String, newPasswordConfirm:String) {
        if newPassword != newPasswordConfirm {
            let alertController = AlertViewController()
            alertController.setUp(self, title: "Error!", message: "Please Ensure the two password inputs are the same", buttonText: "Dismiss")
            alertController.show()
        } else {
            let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to change your password?", preferredStyle: .Alert)
            alertController.view.tintColor = UIColor.customRed()
            
            let cancelAction = UIAlertAction(title: "NO", style: .Cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "YES", style: .Default) { (action) in
                ServerRequest.shared.changePassword(newPassword) { (currentUser) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                
            }
        }

    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluateWithObject(testStr)
        
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
