//
//  FlatDonationsViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 2/24/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class FlatDonationsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate,FooterCollectionReusableViewDelegate, SearchViewControllerDelegate, AlertViewControllerDelegate {
    @IBOutlet var headerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    let statusBarHeight = CGFloat(20)
    let cellIdentifier = "DonationHelperCollectionViewCell"
    let cellHeight = CGFloat(100)
    let headerViewIdentifier = "DonateHeaderCollectionReusableView"
    let footerViewIdentifier = "FooterCollectionReusableView"
    let headerViewHeight = CGFloat(56)
    var moneyTextField: UITextField!
    var causeLabel:UILabel!
    var partnerLabel: UILabel!
    var bottomButton:RoundedButton!
    var selectedCause:Cause!
    


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
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: headerViewHeight);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 10;
        layout.footerReferenceSize = CGSize(width: self.view.frame.size.width, height: 150);

        self.collectionView.backgroundColor = UIColor.customDarkGrey()
        self.collectionView.scrollEnabled = true
        self.collectionView.collectionViewLayout = layout;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier);
        self.collectionView.registerNib(UINib(nibName: headerViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier);
        self.collectionView.registerNib(UINib(nibName: footerViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewIdentifier);
//        
        self.collectionView.alwaysBounceVertical = true
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.view.frame.size.width - 20;
        let height = cellHeight
        return CGSizeMake(width, height);
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell :DonationHelperCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! DonationHelperCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.moneyTextField.delegate = self
        let item = indexPath.item
        switch item{
        case 0:
            self.moneyTextField = cell.moneyTextField
            cell.topLeftLabel.text = "Flat Amount:"
            cell.bottomRightLabel.hidden = true
            cell.causeLabel.hidden = true
            cell.partnerLabel.hidden = true
        case 1:
            self.partnerLabel = cell.partnerLabel
            self.causeLabel = cell.causeLabel
            self.causeLabel.adjustsFontSizeToFitWidth = true
            cell.topLeftLabel.text = "Impacting:"
            cell.moneyTextField.text = "Select Cause"
            cell.moneyTextField.enabled = false
            cell.bottomRightLabel.hidden = true
            if(self.selectedCause != nil){
                self.causeLabel.hidden = false
                self.partnerLabel.hidden = false
                self.causeLabel.text = self.selectedCause.name
                self.partnerLabel.text = self.selectedCause.organizationName
                cell.moneyTextField.hidden = true
                
                
            }else{
                cell.causeLabel.hidden = true
                cell.partnerLabel.hidden = true
                cell.moneyTextField.textColor = UIColor.blackColor()
            }
            
            
        default:
            cell.moneyTextField.hidden = true
            cell.causeLabel.hidden = true
        }

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let itemNum = indexPath.item
        if(itemNum == 1){
            let svc = SearchViewController()
            svc.enteredFromDonate = true
            svc.delegate = self
            self.navigationController?.pushViewController(svc, animated: true)
            
        }
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            
            switch kind {
                
            case UICollectionElementKindSectionHeader:
                
                //have to have something here because we need the header for space at the top
                let headerView : DonateHeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: headerViewIdentifier,
                    forIndexPath: indexPath) as! DonateHeaderCollectionReusableView
                    headerView.textLabel.sizeToFit()
                
                
                return headerView
                
                
            case UICollectionElementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: footerViewIdentifier,
                    forIndexPath: indexPath) as! FooterCollectionReusableView
                footerView.bottomButton.hidden = true
                footerView.topButton.setTitle("DONATE", forState: UIControlState.Normal)
                footerView.bottomButton.enabled = false
                footerView.delegate = self
                self.bottomButton = footerView.bottomButton
                
                
                return footerView
                
                
            default:
                
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: headerViewIdentifier,
                    forIndexPath: indexPath) as! DonateHeaderCollectionReusableView
                    headerView.textLabel.sizeToFit()

                
                
                return headerView
            }
            
            
            
    }
    
    func donateAmount(amount:NSNumber){
        
        let activityIndicator: ActivityIndicator = ActivityIndicator(view: self.view)
        activityIndicator.startCustomAnimation()
        
        //times 100 for cents
        let centsAmount = Int(amount) * 100
        ServerRequest.shared.makeFlatDonation(Int(centsAmount), cause_id: self.selectedCause.id, completion:  { (payment) -> Void in
            activityIndicator.stopAnimating()
            let alertController = AlertViewController()
            alertController.setUp(self, title: "Success", message: "You have successfully contributed to this cause.  Thank you!", buttonText: "Dismiss")
            alertController.delegate = self
            alertController.show()
            
            
            }, failure: { (errorMessage) -> Void in
                activityIndicator.stopAnimating()
                let alertController = AlertViewController()
                alertController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
                alertController.show()
                
        })
        
    }
    
    func validMoneyText(moneyText:String) -> NSNumber?{
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        
        let testNum = numberFormatter.numberFromString(moneyText)
        if(testNum == 0){
            return nil
        }
        return testNum
    }
    
    func footerViewTopButtonPressed() {
        if((self.selectedCause) != nil){
            let moneyString = self.moneyTextField.text
            let amount = validMoneyText(moneyString!)
            if(amount != nil){
                let firstMessageString:String =  "You are about to contribute: " + self.moneyTextField.text! + " to " + self.causeLabel.text!
                let secondMessageString:String = " in partnership with " + partnerLabel.text! + " click OK to confirm your payment"
                let alertController = UIAlertController(title: "Flat Donation" , message: firstMessageString + secondMessageString, preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                    
                    self.donateAmount(amount!)
                    
                }
                alertController.addAction(OKAction)
                alertController.view.tintColor = UIColor.customRed()
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
            }else{
                let alertController = AlertViewController()
                alertController.setUp(self, title: "Error", message: "Invalid amount, please try again", buttonText: "Dismiss")
                alertController.show()
                
            }
            
            
            
        }else{
            let alertController = AlertViewController()
            alertController.setUp(self, title: "Error", message: "Please select a cause by pressing the Select Cause button", buttonText: "Dismiss")
            alertController.show()
            
        }
        

        
    }
    func footerViewBottomButtonPressed() {
        
    }
    
    //TEXT FIELD
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        if((textField.text?.characters.count) == 0){
            self.moneyTextField.text = "$"
        }
        return true
        
    }
    
    func selectedRow(cause: Cause) {
        self.selectedCause = cause
        self.collectionView.reloadData()
    }
    
    func popupDismissed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
