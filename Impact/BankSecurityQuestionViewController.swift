//
//  BankSecurityQuestionViewController.swift
//  Impact
//
//  Created by Phillip Ou on 8/24/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class BankSecurityQuestionViewController: UIViewController, UITextFieldDelegate {
    var securityQuestions : [String]? = ["What is your dog's name?", "What is your mother's maiden name?", "Where is your hometown?"];
    var responses : [String] = [];
    var currentIndex = 0;
    var question : String = "";
    var bank : Bank? = nil;
    var nextButton : DoneButton = DoneButton();
    var keyboardFrame = CGRectZero;
    
    @IBOutlet var navigationHeaderView: UIView!
    @IBOutlet var answerTextField: UITextField!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionIndexLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSecurityQuestion();
        self.navigationHeaderView.addBottomBorder(UIColor.customGrey());
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil);
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
        if (currentIndex == securityQuestions!.count) {
            self.answerTextField.returnKeyType = .Done
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let validInputs = self.answerTextField.text != ""
         if validInputs{
            currentIndex++;
            if (currentIndex < securityQuestions!.count) {
                let answer = self.answerTextField.text;
                responses.append(answer!);
                self.answerTextField.text = "";
                updateSecurityQuestion();
            }
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
        if let securityQuestions = self.securityQuestions {
            self.question = securityQuestions[currentIndex];
            self.questionIndexLabel.text = "\(currentIndex+1) / \(securityQuestions.count)";
            self.questionLabel.text = self.question;
            if (currentIndex + 1 == securityQuestions.count) {
                self.nextButton.setTitle("Done", forState: .Normal);
            }
        }
    }
    
    func nextButtonPressed() {
        currentIndex++;
        if (currentIndex < securityQuestions!.count) {
            let answer = self.answerTextField.text;
            responses.append(answer!);
            self.answerTextField.text = "";
            updateSecurityQuestion();
        } else { //done
            let ccvc = CreditCardViewController(nibName: "CreditCardViewController", bundle: nil);
            self.navigationController?.pushViewController(ccvc, animated: true)
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }

}
