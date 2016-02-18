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

class EditCreditCardViewController:UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FooterCollectionReusableViewDelegate{
    let statusBarHeight = CGFloat(20)
    let cellHeight = CGFloat(165)
    @IBOutlet var headerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    let cellIdentifier = "CreditCardCollectionViewCell"
    let footerViewIdentifier = "FooterCollectionReusableView"

    var creditCard: CreditCard!
    
    
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
        cell.cvvTextField.text = "***"
        var monthString = ""
        if(creditCard.exp_month < 10){
            monthString = "0" + String(creditCard.exp_month)
        }else{
            monthString = String(creditCard.exp_month)
        }
        cell.expDateTextField.text = monthString + "/" + String(creditCard.exp_year%100)
        
        
        
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
    
    
    
    func footerViewTopButtonPressed() {
        //alert view - changes saved
        //pop vc
        //delete credit card and add a new one w/ information
        
    }
    func footerViewBottomButtonPressed() {
        //alert view - sure you want to remove?
        //pop vc
        //remove credit card from server
        
    }
    
    
    
    
    
    
    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }


}
