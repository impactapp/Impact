//
//  FlatDonationsViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 2/24/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class FlatDonationsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate,FooterCollectionReusableViewDelegate {
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
            cell.moneyTextField.text = "$0.00"
            cell.causeLabel.hidden = true
            cell.partnerLabel.hidden = true
        case 1:
            cell.causeLabel.hidden = true
            cell.partnerLabel.hidden = true
            cell.bottomRightLabel.hidden = true
            self.partnerLabel = cell.partnerLabel
            self.causeLabel = cell.causeLabel
            cell.topLeftLabel.text = "Impacting:"
            cell.moneyTextField.text = "Select Cause"
            cell.moneyTextField.enabled = false
            cell.moneyTextField.textColor = UIColor.blackColor()
        default:
            cell.moneyTextField.hidden = true
            cell.causeLabel.hidden = true
        }
        
        
        return cell
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
    
    func footerViewTopButtonPressed() {
        let firstMessageString:String =  "You are about to contribute: " + self.moneyTextField.text! + " to " + self.causeLabel.text!
        let secondMessageString:String = " in partnership with " + partnerLabel.text! + " click OK to confirm your payment"
        let alertController = UIAlertController(title: "Flat Donation" , message: firstMessageString + secondMessageString, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "YES", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        alertController.view.tintColor = UIColor.customRed()
        
        self.presentViewController(alertController, animated: true) {
            // ...
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
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
