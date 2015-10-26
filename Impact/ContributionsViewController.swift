//
//  ContributionsViewController.swift
//  Impact
//
//  Created by Anthony Emberley on 10/25/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class ContributionsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!
    let cellIdentifier = "ContributionsCollectionViewCell"
    let titles :[String] = ["Currently Impacting", "Weekly Budget", "Current Streak", "Donation Breakdown", "Round Up Log", "Previous Impacts"]
    let details :[String] = ["You're impacting:", "You're contributing:", "You've consecutively impacted:", "You've mostly impacted:", "You've made:", "You've helped"]
    let bottomLabels :[String] = ["Causes", "Per Week", "Days", "Armed Services", "Round Ups", "Causes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Collectionview
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.view.frame.size.width / 2 - 20;
        return CGSizeMake(width, width);
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier, forIndexPath: indexPath) ;
//    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let itemNum = indexPath.item
        let cell :ContributionsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContributionsCollectionViewCell
        cell.titleLabel.text = titles[itemNum]
        cell.detailLabel.text = details[itemNum]
        cell.finishingLabel.text = bottomLabels[itemNum]
        if(itemNum != 3){
            cell.imageView.hidden = true
        }else{
            
        }
        
        return cell
    }
    
//    private func cellWithBank(bank : Bank, indexPath:NSIndexPath) -> RoundedCollectionViewCell {
//        let cell : RoundedCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! RoundedCollectionViewCell;
//        cell.titleLabel.text = bank.name;
//        cell.titleLabel.hidden = true //TODO: ASK VAL WHAT HER THOUGHTS ARE ON THIS
//        if let imageURL = bank.logoURL {
//            cell.imageView.setImageWithUrl(NSURL(string: imageURL), placeHolderImage: nil);
//        }
//        return cell;
//    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    


}
