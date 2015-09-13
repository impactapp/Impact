//
//  BankSignInViewController.swift
//  Impact
//
//  Created by Phillip Ou on 8/24/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class BankSignInViewController: UIViewController, UITextFieldDelegate {
    var bank : Bank? = nil;
    var doneButton : DoneButton = DoneButton();
    var keyboardFrame : CGRect = CGRectZero;
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var navigationHeaderView: UIView!
    @IBOutlet weak var bankPasswordTextfield: UITextField!
    @IBOutlet weak var bankUsernameTextField: UITextField!
    @IBOutlet weak var bankPasswordLabel: UILabel!
    @IBOutlet weak var bankUserNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        initHeaderView();
        initTextFields();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil);
    }
    
    private func initHeaderView() {
        self.navigationHeaderView.addBottomBorder(UIColor.customGrey())
        if let bankName = self.bank?.name {
            self.titleLabel.text = bankName;
        }
    };
    
    private func initTextFields() {
        self.bankUsernameTextField.delegate = self;
        self.bankUsernameTextField.returnKeyType = .Next
        self.bankUsernameTextField.autocorrectionType = .No;
        self.bankUsernameTextField.autocorrectionType = .No;
        self.bankUsernameTextField.delegate = self;
        self.bankUsernameTextField.returnKeyType = .Done
        if let bankName = self.bank?.name {
            self.bankUserNameLabel.text = "\(bankName) Username";
            self.bankPasswordLabel.text = "\(bankName) Password";
        }
        self.bankUsernameTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged);
        self.bankPasswordTextfield.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged);
        let padding = CGFloat(15);
        let usernamePaddingView = UIView(frame: CGRectMake(0, 0, padding, self.bankUsernameTextField.frame.height))
        let passwordPaddingView = UIView(frame: CGRectMake(0, 0, padding, self.bankPasswordTextfield.frame.height))
        self.bankUsernameTextField.leftView = usernamePaddingView
        self.bankPasswordTextfield.leftView = passwordPaddingView
        self.bankPasswordTextfield.leftViewMode = UITextFieldViewMode.Always
        self.bankUsernameTextField.leftViewMode = UITextFieldViewMode.Always
    }
    
    //MARK: UITextFieldDelegate methods
    
    func textFieldDidChange() {
        let validInputs = self.bankPasswordTextfield.text != "" && self.bankUsernameTextField.text != "";
        self.doneButton.animateDoneButton(validInputs);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let validInputs = self.bankUsernameTextField.text != "" && self.bankUsernameTextField.text != "";
        if textField == bankUsernameTextField {
            self.bankUsernameTextField.becomeFirstResponder()
        }else if textField == bankUsernameTextField && validInputs{
            let bpvc = BankPinViewController(nibName: "BankPinViewController", bundle: nil);
            bpvc.bank = self.bank;
            self.navigationController?.pushViewController(bpvc, animated: true);
            
        }
        return true
    }
    
    func keyboardWasShown(notification: NSNotification) {
        self.keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue();
        initDoneButton();
    }
    
    private func initDoneButton() {
        self.doneButton = DoneButton(keyboardFrame: self.keyboardFrame, hidden: true);
        self.doneButton.backgroundColor = UIColor.customRed();
        self.doneButton.setTitle("Continue", forState: .Normal);
        self.doneButton.titleLabel?.textColor = UIColor.whiteColor();
        self.view.addSubview(self.doneButton);
        self.doneButton.addTarget(self, action: "donePressed", forControlEvents: .TouchUpInside);
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func donePressed() {
        let bsqvc = BankSecurityQuestionViewController(nibName: "BankSecurityQuestionViewController", bundle: nil);
        bsqvc.bank = self.bank;
        self.navigationController?.pushViewController(bsqvc, animated: true);
    }
}
