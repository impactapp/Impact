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
    @IBOutlet var bankPasswordTextField: BottomBorderedTextField!
    @IBOutlet var bankUserNameTextField: BottomBorderedTextField!
    
    
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
        self.bankUserNameTextField.delegate = self;
        self.bankUserNameTextField.returnKeyType = .Next
        self.bankUserNameTextField.autocorrectionType = .No;
        self.bankPasswordTextField.delegate = self;
        self.bankPasswordTextField.returnKeyType = .Done
        if let bankName = self.bank?.name {
            self.bankUserNameTextField.placeHolderText = "\(bankName) username";
            self.bankPasswordTextField.placeHolderText = "\(bankName) password";
        }
        self.bankPasswordTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged);
    }
    
    //MARK: UITextFieldDelegate methods
    
    func textFieldDidChange() {
        let validInputs = self.bankPasswordTextField.text != "" && self.bankUserNameTextField.text != "";
        self.doneButton.animateDoneButton(validInputs);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let validInputs = self.bankPasswordTextField.text != "" && self.bankUserNameTextField.text != "";
        if textField == bankUserNameTextField {
            self.bankPasswordTextField.becomeFirstResponder()
        }else if textField == bankPasswordTextField && validInputs{
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
        self.doneButton.setTitle("Done", forState: .Normal);
        self.doneButton.titleLabel?.textColor = UIColor.whiteColor();
        self.view.addSubview(self.doneButton);
        self.doneButton.addTarget(self, action: "donePressed", forControlEvents: .TouchUpInside);
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func donePressed() {
        let bpvc = BankPinViewController(nibName: "BankPinViewController", bundle: nil);
        bpvc.bank = self.bank;
        self.navigationController?.pushViewController(bpvc, animated: true);
    }
}
