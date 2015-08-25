//
//  BankSecurityQuestionViewController.swift
//  Impact
//
//  Created by Phillip Ou on 8/24/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class BankSecurityQuestionViewController: UIViewController {
    var securityQuestions : [String]? = ["What is your dog's name?", "What is your mother's maiden name?", "Where is your hometown?"];
    var responses : [String] = [];
    var currentIndex = 0;
    var question : String = "";
    var bank : Bank? = nil;
    var doneButton : DoneButton = DoneButton();
    var keyboardFrame = CGRectZero;
    
    @IBOutlet var navigationHeaderView: UIView!
    @IBOutlet var answerTextField: BottomBorderedTextField!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionIndexLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSecurityQuestion();
        self.navigationHeaderView.addBottomBorder(UIColor.customGrey());
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil);
        self.answerTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged);
    }
    
    func textFieldDidChange() {
        let validInputs = self.answerTextField.text != "";
        self.doneButton.animateDoneButton(validInputs);
    }
    
    func keyboardWasShown(notification: NSNotification) {
        self.keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue();
        initDoneButton();
    }
    
    private func initDoneButton() {
        self.doneButton = DoneButton(keyboardFrame: self.keyboardFrame, hidden: true);
        self.doneButton.backgroundColor = UIColor.customRed();
        self.doneButton.setTitle("Next", forState: .Normal);
        self.doneButton.titleLabel?.textColor = UIColor.whiteColor();
        self.view.addSubview(self.doneButton);
        self.doneButton.addTarget(self, action: "buttonPressed", forControlEvents: .TouchUpInside);
    }
    
    func updateSecurityQuestion() {
        if let securityQuestions = self.securityQuestions {
            self.question = securityQuestions[currentIndex];
            self.questionIndexLabel.text = "\(currentIndex+1) / \(securityQuestions.count)";
            self.questionLabel.text = self.question;
            if (currentIndex + 1 == securityQuestions.count) {
                self.doneButton.setTitle("Done", forState: .Normal);
            }
        }
    }
    
    func buttonPressed() {
        currentIndex++;
        if (currentIndex < securityQuestions!.count) {
            let answer = self.answerTextField.text;
            responses.append(answer);
            self.answerTextField.text = "";
            updateSecurityQuestion();
        } else {
            
        }
    }

}
