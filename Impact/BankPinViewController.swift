//
//  BankPinViewController.swift
//  Impact
//
//  Created by Phillip Ou on 8/24/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class BankPinViewController: UIViewController {

    @IBOutlet var navigationHeaderView: UIView!
    @IBOutlet var pinTextField: BottomBorderedTextField!
    var bank : Bank? = nil;
    var doneButton : DoneButton = DoneButton();
    var keyboardFrame = CGRectZero;
    var enteredFromSettings : Bool!
    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationHeaderView.addBottomBorder(UIColor.customGrey());
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil);
        self.pinTextField.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged);
        self.pinTextField.keyboardType = .NumberPad;
    }
    
    func textFieldDidChange() {
        let validInputs = self.pinTextField.text != "";
        self.doneButton.animateDoneButton(validInputs);
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

    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func donePressed() {
        let bsqvc = BankSecurityQuestionViewController(nibName: "BankSecurityQuestionViewController", bundle: nil);
        bsqvc.bank = self.bank;
        bsqvc.enteredFromSettings = self.enteredFromSettings
        self.navigationController?.pushViewController(bsqvc, animated: true);
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
