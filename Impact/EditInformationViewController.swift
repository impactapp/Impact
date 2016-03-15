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

class EditInformationViewController: UIViewController, UITextFieldDelegate, AlertViewControllerDelegate {

    @IBOutlet var bottomTextField: UITextField!
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
                self.editTextField.placeholder = "Enter Old Password"
                self.editTextField.text = ""
                self.confirmTextField.placeholder = "Enter New Password"
                self.confirmTextField.text = ""
                self.bottomTextField.text = ""
                self.bottomTextField.placeholder = "Confirm New Password"
            }
            
        }else{
            ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
                self.user = currentUser
                self.configureTextField()
                return
            }
        }
        
        self.editTextField.secureTextEntry = editType == .Password
        self.editTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);

        if editType == .Password {
            self.editTextField.returnKeyType = .Next
            self.confirmTextField.returnKeyType = .Next
        } else {
            self.editTextField.returnKeyType = .Done
        }
        self.editTextField.delegate = self
        self.bottomTextField.secureTextEntry = self.editType == .Password
        self.bottomTextField.hidden = self.editType != .Password
        self.confirmTextField.hidden = self.editType != .Password
        self.bottomTextField.returnKeyType  = .Done
        self.confirmTextField.secureTextEntry = editType == .Password
        self.confirmTextField.delegate = self
        self.confirmTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        self.confirmTextField.delegate = self
        self.bottomTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        self.bottomTextField.delegate = self

        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if editType == .Password && textField == self.editTextField {
            self.confirmTextField.becomeFirstResponder()
            return true
        }else if editType == .Password && textField == self.confirmTextField {
            self.bottomTextField.becomeFirstResponder()
            return true
        }
        if self.editType == .Email {
            if let text = textField.text {
                changeEmail(text)
            }
        }
        if self.editType == .Name {
            if let text = textField.text {
                changeName(text)
            }
        }
        if self.editType == .Password {
            if let oldPassword = self.editTextField.text{
                if let password = self.confirmTextField.text {
                    if let confirmPassword = self.bottomTextField.text {
                        changePassword(oldPassword, newPassword: password,newPasswordConfirm: confirmPassword)
                    }
                    
                }
            }
            
        }
        
        return true
    }
    
    func changeName(newName:String) {
        
        ServerRequest.shared.changeName(newName, completion:  { (currentUser) -> Void in
            if let delegate = self.userInfoDelegate {
                delegate.updateUserInfo(currentUser)
            }
            let alertController = AlertViewController()
            alertController.delegate = self
            alertController.setUp(self, title: "Updated Name", message: "You have successfully updated your name", buttonText: "Continue")
            alertController.show()
            },failure: {(errorMessage) -> Void in
                let alertController = AlertViewController()
                alertController.setUp(self, title: "Error!", message: errorMessage, buttonText: "Dismiss")
                alertController.show()
        })
        
        
        
    }
    
    func changeEmail(newEmail:String) {
        if (isValidEmail(newEmail)) {
            ServerRequest.shared.changeEmail(newEmail, completion: { (currentUser) -> Void in
                if let delegate = self.userInfoDelegate {
                    delegate.updateUserInfo(currentUser)
                }
                let alertController = AlertViewController()
                alertController.delegate = self
                alertController.setUp(self, title: "Updated Email", message: "You have successfully updated your email", buttonText: "Continue")
                alertController.show()
            },failure: {(errorMessage) -> Void in
                let alertController = AlertViewController()
                alertController.setUp(self, title: "Error!", message: errorMessage, buttonText: "Dismiss")
                alertController.show()
            })
        } else {
            let alertController = AlertViewController()
            alertController.setUp(self, title: "Error!", message: "Please Enter a Valid Email", buttonText: "Dismiss")
            alertController.show()
        }
        
    }
    
    func changePassword(oldPassword:String, newPassword:String, newPasswordConfirm:String) {
        var email = ""
        if let user = self.user{
            email = user.email
        }
        
        let activityIndicator = ActivityIndicator(view: self.view)
        ServerRequest.shared.loginWithEmail(email, password: oldPassword, success: { (user) -> Void in
            activityIndicator.stopAnimating()
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
                    activityIndicator.startCustomAnimation()
                    ServerRequest.shared.changePassword(newPassword, completion:  { (currentUser) -> Void in
                        activityIndicator.stopAnimating()
                        let alertController = AlertViewController()
                        alertController.delegate = self
                        alertController.setUp(self, title: "Updated Password", message: "You have successfully updated your password", buttonText: "Continue")
                        alertController.show()
                        
                        },failure: {(errorMessage) -> Void in
                            activityIndicator.stopAnimating()
                            let alertController = AlertViewController()
                            alertController.setUp(self, title: "Error!", message: errorMessage, buttonText: "Dismiss")
                            alertController.show()
                    })
                }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true) {
                    
                }
            }

            
            },failure: { (errorMessage) -> Void in
                activityIndicator.stopAnimating()
                let alertViewController = AlertViewController()
                alertViewController.setUp(self, title: "Error", message: "Invalid Password", buttonText: "Dismiss")
                alertViewController.show()
        })
        
        
        
        
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluateWithObject(testStr)
        
    }
    
    func popupDismissed() {
        self.navigationController?.popViewControllerAnimated(true)  
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
