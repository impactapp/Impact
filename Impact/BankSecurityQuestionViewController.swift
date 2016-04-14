//
//  BankSecurityQuestionViewController.swift
//  Impact
//
//  Created by Phillip Ou on 8/24/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class BankSecurityQuestionViewController: UIViewController, UITextFieldDelegate {
    var responses : [String] = []
    var question : String = ""
    var plaidToken : String = ""
    var bank : Bank? = nil
    var nextButton : DoneButton = DoneButton()
    var keyboardFrame = CGRectZero
    var enteredFromSettings : Bool!
    
    @IBOutlet var navigationHeaderView: UIView!
    @IBOutlet var answerTextField: UITextField!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionIndexLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationHeaderView.addBottomBorder(UIColor.customGrey());
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil);
        self.questionLabel.text = question
        setUpTextField()
    }
    
    func setUpTextField() {
        self.answerTextField.returnKeyType = .Next
        self.answerTextField.delegate = self
        self.answerTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged);
        self.answerTextField.autocorrectionType = .No
        self.answerTextField.enablePadding(true)
    }
    
    func textFieldDidChange() {
        let validInputs = self.answerTextField.text != "";
        self.nextButton.animateDoneButton(validInputs);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let validInputs = self.answerTextField.text != ""
         if validInputs{
            updateSecurityQuestion();
        }
        return true
    }
    
    
    func keyboardWasShown(notification: NSNotification) {
        self.keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue();
        initDoneButton();
    }
    
    private func initDoneButton() {
        self.nextButton = DoneButton(keyboardFrame: self.keyboardFrame, hidden: true);
        self.nextButton.backgroundColor = UIColor.customRed();
        self.nextButton.setTitle("Next", forState: .Normal);
        self.nextButton.titleLabel?.textColor = UIColor.whiteColor();
        self.view.addSubview(self.nextButton);
        self.nextButton.addTarget(self, action: "nextButtonPressed", forControlEvents: .TouchUpInside);
    }
    
    func updateSecurityQuestion() {
        if let answer = self.answerTextField.text {
            ServerRequest.shared.answerMFA(answer, plaidToken: self.plaidToken, success: { (isFinished, user, question, plaidToken) -> Void in
                if isFinished {
                    if let currentUser = user {
                        if currentUser.needsCreditCardInfo == true {
                            self.navigateToCreditCard()
                        } else {
                            self.navigateToApp()
                        }
                    }
                    
                } else {
                    self.questionLabel.text = question
                }
                self.answerTextField.text = "";
                }, failure: { (errorMessage) -> Void in
                    let alertController = AlertViewController()
                    alertController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
                    alertController.show()
            })
        }
        
    }
    
    func nextButtonPressed() {
        updateSecurityQuestion();
    }
    
    func navigateToCreditCard() {
        let ccvc = CreditCardViewController(nibName: "CreditCardViewController", bundle: nil);
        self.navigationController?.pushViewController(ccvc, animated: true)
    }
    
    func navigateToApp() {
        let tabBarController = TabBarViewController()
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    func navigateToProfile() {
        let tabBarController = TabBarViewController()
        tabBarController.selectedIndex = 4
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }

}
