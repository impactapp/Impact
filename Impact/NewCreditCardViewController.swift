//
//  NewCreditCardViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 2/4/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit
import Stripe


class NewCreditCardViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FooterCollectionReusableViewDelegate, UITextFieldDelegate, AlertViewControllerDelegate {
    let statusBarHeight = CGFloat(20)
    let cellHeight = CGFloat(165)
    @IBOutlet var headerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    let cellIdentifier = "CreditCardCollectionViewCell"
    let footerViewIdentifier = "FooterCollectionReusableView"
    var collectionCell:CreditCardCollectionViewCell!
    var cardTextField:UITextField!
    var cvvTextField:UITextField!
    var expTextField:UITextField!
    var successIndicator:Bool = false
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
           self.currentUser = currentUser
        }

        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    private func setUpCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: self.headerView.frame.size.height - statusBarHeight/2);
        layout.footerReferenceSize = CGSize(width: self.view.frame.size.width, height: 150);

        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 10;
        self.collectionView.scrollEnabled = true
        self.collectionView.collectionViewLayout = layout;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier);
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.registerNib(UINib(nibName: footerViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewIdentifier);
        self.collectionView.registerNib(UINib(nibName: footerViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: footerViewIdentifier);
        
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.view.frame.size.width - 20;
        let height = cellHeight
        return CGSizeMake(width, height);
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell :CreditCardCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CreditCardCollectionViewCell
        cell.cardNumberTextField.secureTextEntry = false
        cell.layer.cornerRadius = 10
        cell.cvvTextField.enablePadding(true)
        cell.cardNumberTextField.enablePadding(true)
        cell.expDateTextField.enablePadding(true)
        
        expTextField = cell.expDateTextField
        cardTextField = cell.cardNumberTextField
        cvvTextField = cell.cvvTextField
        cardTextField.delegate = self
        expTextField.delegate = self
        cvvTextField.delegate = self
        self.collectionCell = cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            
            switch kind {
                
            case UICollectionElementKindSectionHeader:
                
                //have to have something here because we need the header for space at the top
                let footerView : FooterCollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: footerViewIdentifier,
                    forIndexPath: indexPath) as! FooterCollectionReusableView
                footerView.topButton.hidden = true
                footerView.bottomButton.hidden = true
                footerView.delegate = self
                
                
                return footerView
                
            case UICollectionElementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: footerViewIdentifier,
                    forIndexPath: indexPath) as! FooterCollectionReusableView
                footerView.bottomButton.hidden = true
                footerView.topButton.setTitle("Add Card", forState: UIControlState.Normal)
                footerView.delegate = self
                
                
                return footerView
                
            default:
                
                let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: footerViewIdentifier,
                    forIndexPath: indexPath) as! FooterCollectionReusableView
                footerView.bottomButton.hidden = true
                footerView.delegate = self
                
                return footerView
            }
            
            
            
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let allowEditing = formatTextFields(textField, newString: string, range:range)
        return allowEditing
    }
    
    //TextField
    func formatTextFields(textField:UITextField, newString:String, range:NSRange) -> Bool{
        var validInput = true
        let deletePressed = range.length==1 && newString.characters.count==0
        if textField == self.cardTextField {
            if self.cardTextField.text!.characters.count % 5 == 0 && self.cardTextField.text!.characters.count < 20 && !deletePressed {
                var cardString = self.cardTextField.text
                cardString = cardString! + String(" ")
                self.cardTextField.text = cardString
            }
            validInput =  self.cardTextField.text!.characters.count < 20
            
        } else if textField == self.expTextField {
            if self.expTextField.text!.characters.count == 2 && !deletePressed {
                var dateString = self.expTextField.text
                dateString = dateString! + String("/")
                self.expTextField.text = dateString
            }
            validInput = self.expTextField.text!.characters.count < 5
            
        } else if textField == self.cvvTextField {
            validInput = self.cvvTextField.text!.characters.count < 4
        }
        
        let allowEditing = validInput || deletePressed
        return allowEditing
    }
    
    
    //CARD
    func addCard(){
        let stripeCard: STPCard = STPCard()        
        
        if let creditCardString = collectionCell.cardNumberTextField.text {
            stripeCard.number = creditCardString.stringByReplacingOccurrencesOfString(" ", withString: "")
        }
        stripeCard.cvc = collectionCell.cvvTextField.text
        if let dateString = collectionCell.expDateTextField.text {
            let month = dateString[dateString.startIndex ..< dateString.characters.indexOf("/")!]
            let year = String(dateString.substringFromIndex(dateString.rangeOfString("/")!.startIndex).characters.dropFirst())
            if let monthInt = Int(month) {
                stripeCard.expMonth = UInt(monthInt)
            }
            if let yearInt = Int(year) {
                stripeCard.expYear = UInt(yearInt)
            }
        }
        let activityIndicator = ActivityIndicator(view: self.view)
        activityIndicator.startCustomAnimation()
        
        if let currentUser = self.currentUser{
            if currentUser.needsCreditCardInfo == false{
                ServerRequest.shared.addCreditCard(stripeCard, success: { (success) -> Void in
                    self.successIndicator = true
                    activityIndicator.stopAnimating()
                    let alertController = AlertViewController()
                    alertController.delegate = self
                    alertController.setUp(self, title: "Success!", message: "Added credit card", buttonText: "Continue")
                    alertController.show()
                    }, failure: { (errorMessage) -> Void in
                        self.successIndicator = false
                        activityIndicator.stopAnimating()
                        let alertController = AlertViewController()
                        alertController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
                        alertController.show()
                })
            }else{
                ServerRequest.shared.updateStripeCustomer(stripeCard, success: { (success) -> Void in
                    self.successIndicator = true
                    activityIndicator.stopAnimating()
                    let alertController = AlertViewController()
                    alertController.delegate = self
                    alertController.setUp(self, title: "Success!", message: "Added credit card", buttonText: "Continue")
                    alertController.show()
                    }, failure: { (errorMessage) -> Void in
                        self.successIndicator = false
                        activityIndicator.stopAnimating()
                        let alertController = AlertViewController()
                        alertController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
                        alertController.show()
                })
            }
        }else{
            let alertController = AlertViewController()
            alertController.setUp(self, title: "No Current User", message: "Check internet connection, and make sure you are logged in", buttonText: "Dismiss")
            alertController.show()
        }
        
        

    }
    
    
    //MARK - footer view delegate methods
    
    
    func footerViewTopButtonPressed() {
        addCard()
        
    }
    func footerViewBottomButtonPressed() {
        
    }
    
    func popupDismissed() {
        if(successIndicator){
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    

}
