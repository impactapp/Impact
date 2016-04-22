//
//  CreditCardViewController.swift
//  Impact
//
//  Created by Phillip Ou on 9/14/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit
import Stripe

class CreditCardViewController: UIViewController, CardIOPaymentViewControllerDelegate, UITextFieldDelegate {
    var cardIOContainerView : UIView = UIView()
    
    @IBOutlet weak var headerView: UIView!
    var doneButton : DoneButton = DoneButton();
    var keyboardFrame : CGRect = CGRectZero;

    @IBOutlet var headerViewLabel: UILabel!
    @IBOutlet weak var creditCardTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var securityCodeTextField: UITextField!
    var cardInfo : CardIOCreditCardInfo? = nil
    var userHasCategories = false
    
    override func viewDidLoad() {
        self.headerView.addBottomBorder(UIColor.customGrey())
        super.viewDidLoad()
        getUserCategories()
        self.headerViewLabel.adjustsFontSizeToFitWidth = true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarColor(UIColor.whiteColor(), useWhiteText: true)
        CardIOUtilities.preload()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        configureTextFields()
    }
    
    func getUserCategories(){
        ServerRequest.shared.getUserCategories { (categories) -> Void in
            self.userHasCategories = categories.count > 0
        }
    }
    
    private func configureTextFields() {
        self.expirationDateTextField.delegate = self
        self.expirationDateTextField.enablePadding(true)
        self.creditCardTextField.delegate = self
        self.creditCardTextField.enablePadding(true)
        self.securityCodeTextField.delegate = self
        self.securityCodeTextField.enablePadding(true)
        self.securityCodeTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.creditCardTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.expirationDateTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        

        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        checkAllFormsFilled()
        return allowEditting(textField, newString: string, range:range)
    }
    
    private func allowEditting(textField:UITextField, newString:String, range:NSRange) -> Bool {
        var validInput = true
        let deletePressed = range.length==1 && newString.characters.count==0
        if textField == self.creditCardTextField {
            if self.creditCardTextField.text!.characters.count % 5 == 0 && self.creditCardTextField.text!.characters.count < 20 && !deletePressed {
                var cardString = self.creditCardTextField.text
                cardString = cardString! + String(" ")
                self.creditCardTextField.text = cardString
            }
            validInput =  self.creditCardTextField.text!.characters.count < 20
            
        } else if textField == self.expirationDateTextField {
            if self.expirationDateTextField.text!.characters.count == 2 && !deletePressed {
                var dateString = self.expirationDateTextField.text
                dateString = dateString! + String("/")
                self.expirationDateTextField.text = dateString
            }
            validInput = self.expirationDateTextField.text!.characters.count < 5
            
        } else if textField == self.securityCodeTextField {
            validInput = self.securityCodeTextField.text!.characters.count < 4
        }
        let allowEditting = validInput || deletePressed
        return allowEditting
        
    }
    
    private func checkAllFormsFilled() {
        let finishedFillingForm = self.creditCardTextField.text!.characters.count == 20 && self.expirationDateTextField.text!.characters.count > 4 && self.securityCodeTextField.text!.characters.count >= 2
        self.doneButton.animateDoneButton(finishedFillingForm)
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
        self.doneButton.addTarget(self, action: "registerCard", forControlEvents: .TouchUpInside);
    }

    @IBAction func scanCardPressed(sender: AnyObject) {
        showCardScanner()
    }

    private func showCardScanner() {
        let cardScannerViewController = CardIOPaymentViewController(paymentDelegate: self)
        cardScannerViewController.disableManualEntryButtons = true
        self.presentViewController(cardScannerViewController, animated: true, completion: nil)
    }

    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        self.cardInfo = cardInfo
        registerCard()
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func registerCard() {
        let stripeCard: STPCard = STPCard()
        if let cardInfo = self.cardInfo {
            stripeCard.expMonth =  cardInfo.expiryMonth
            stripeCard.expYear = cardInfo.expiryYear
            stripeCard.cvc = cardInfo.cvv
            stripeCard.number = cardInfo.cardNumber;
            
        } else {
            if let creditCardString = self.creditCardTextField.text {
                stripeCard.number = creditCardString.stringByReplacingOccurrencesOfString(" ", withString: "")
            }
            stripeCard.cvc = self.securityCodeTextField.text
            if let dateString = self.expirationDateTextField.text {
                let month = dateString[dateString.startIndex ..< dateString.characters.indexOf("/")!]
                let year = String(dateString.substringFromIndex(dateString.rangeOfString("/")!.startIndex).characters.dropFirst())
                if let monthInt = Int(month) {
                     stripeCard.expMonth = UInt(monthInt)
                }
                if let yearInt = Int(year) {
                    stripeCard.expYear = UInt(yearInt)
                }
            }
        }
        
        ServerRequest.shared.updateStripeCustomer(stripeCard, success: { (success) -> Void in
            self.navigateToCategories()
            }, failure: { (errorMessage) -> Void in
                let alertController = AlertViewController()
                alertController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
                alertController.show()
        })
        
    }
    
    func navigateToApp() {
        let tbc = TabBarViewController()
        let nvc = UINavigationController(rootViewController: tbc)
        nvc.navigationBarHidden = true
        self.navigationController?.presentViewController(nvc, animated: true, completion: nil)
    }
    
    func navigateToCategories() {
        let cvc = CategoriesViewController(nibName:"CategoriesViewController", bundle:nil)
        self.navigationController?.pushViewController(cvc, animated: true)

    }

    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func skipToCategoriesAction(sender: AnyObject) {
        //self.setStatusBarColor(UIColor.customRed(), useWhiteText: true)
        self.userHasCategories ? navigateToApp() : navigateToCategories()
    }
    
    func textFieldDidChange(textField: UITextField) {
        checkAllFormsFilled()
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
