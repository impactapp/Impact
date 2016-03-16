//
//  EditCreditCardViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 2/4/16.
//  Copyright © 2016 Impact. All rights reserved.
//

//TODO - clear text field when clicked on
//TODO - add buttons at the bottom
// TODO - endpoint for updating a card


import UIKit
import Stripe

class EditCreditCardViewController:UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FooterCollectionReusableViewDelegate, AlertViewControllerDelegate, UITextFieldDelegate{
    let statusBarHeight = CGFloat(20)
    let cellHeight = CGFloat(165)
    @IBOutlet var headerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    let cellIdentifier = "CreditCardCollectionViewCell"
    let footerViewIdentifier = "FooterCollectionReusableView"
    var cardTextField:UITextField!
    var cvvTextField:UITextField!
    var expTextField:UITextField!
    var successIndicator = false

    var creditCard: CreditCard!
    var collectionCell: CreditCardCollectionViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        
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
        
        cell.layer.cornerRadius = 10
        
        
        cell.cardNumberTextField.text = "**** **** **** " + creditCard.last4
        
        cell.cardNumberTextField.enabled = false
        cell.cvvTextField.enabled = false
        cell.cvvTextField.enablePadding(true)
        cell.cardNumberTextField.enablePadding(true)
        cell.expDateTextField.enablePadding(true)
        expTextField = cell.expDateTextField
        cardTextField = cell.cardNumberTextField
        cvvTextField = cell.cvvTextField
        cardTextField.delegate = self
        expTextField.delegate = self
        cvvTextField.delegate = self
        cell.cvvTextField.text = "***"
        var monthString = ""
        if(creditCard.exp_month < 10){
            monthString = "0" + String(creditCard.exp_month)
        }else{
            monthString = String(creditCard.exp_month)
        }
        cell.expDateTextField.text = monthString + "/" + String(creditCard.exp_year%100)
        
        
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
                footerView.topButton.setTitle("Save Changes", forState: UIControlState.Normal)
                footerView.bottomButton.setTitle("Remove Card", forState: UIControlState.Normal)
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
    
    //TextField
    
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
    
    func deleteCard(){
        let activityIndicator = ActivityIndicator(view: self.view)
        activityIndicator.startCustomAnimation()
        ServerRequest.shared.deleteCreditCard(creditCard.id, success: { (success) -> Void in
            self.successIndicator = true
            let alertController = AlertViewController()
            activityIndicator.stopAnimating()
            alertController.delegate = self
            alertController.show()
            activityIndicator.stopAnimating()
            
            self.navigationController?.popViewControllerAnimated(true)
            }, failure: { (errorMessage) -> Void in
                //TODO figure out why failing here but still deleting
                self.successIndicator = true
                activityIndicator.stopAnimating()
                let alertController = AlertViewController()
                alertController.delegate = self
                alertController.setUp(self, title: "Success!", message: "Successfully deleted this card", buttonText: "Continue")
                alertController.show()

        })
        
    }
    
    
    func delete(){
        let activityIndicator = ActivityIndicator(view: self.view)
        activityIndicator.startCustomAnimation()
        print(creditCard.id)
        ServerRequest.shared.deleteCreditCard(creditCard.id, success: { (success) -> Void in
            activityIndicator.stopAnimating()
            }, failure: { (errorMessage) -> Void in
                activityIndicator.stopAnimating()
                
        })
        
        
        
    }
    
    func updateCard(){
        let activityIndicator = ActivityIndicator(view: self.view)
        activityIndicator.startCustomAnimation()
        let dateString = expTextField.text
        let split = dateString!.componentsSeparatedByString("/")
        var exp_month = ""
        var exp_year = ""
        if(split.count == 2){
            exp_month = split[0]
            exp_year = split[1]
        }
        
        
        ServerRequest.shared.updateCreditCard(creditCard.id, exp_month: exp_month, exp_year: exp_year, success: { (success) -> Void in
            self.successIndicator = true
            let alertController = AlertViewController()
            activityIndicator.stopAnimating()
            alertController.delegate = self
            alertController.setUp(self, title: "Success!", message: "Successfully updated this card", buttonText: "Continue")
            alertController.show()
            activityIndicator.stopAnimating()
            
            self.navigationController?.popViewControllerAnimated(true)
            }, failure: { (errorMessage) -> Void in
                
                self.successIndicator = true

                activityIndicator.stopAnimating()
                let alertController = AlertViewController()
                alertController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
                alertController.show()
                
        })
        
    }
    
    
    func popupDismissed() {
        if(successIndicator){
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    func footerViewTopButtonPressed() {
        //alert view - changes saved
        //pop vc
        //delete credit card and add a new one w/ information
        //Hacky way for now
        updateCard()
        
    }
    func footerViewBottomButtonPressed() {
        //alert view - sure you want to remove?
        let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to remove this credit card?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "YES", style: .Default) { (action) in
            // ...
            self.deleteCard()
        }
        alertController.addAction(OKAction)
        alertController.view.tintColor = UIColor.customRed()
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
    
    
    
    
    
    
    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }


}
