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
    let statusBarHeight = CGFloat(20)
    let tabBarHeight = CGFloat(44)
    let collectionCellOffset = CGFloat(2)

    let cellIdentifier = "ContributionsCollectionViewCell"
    let titles :[String] = ["Currently Impacting", "Weekly Budget", "Current Streak", "Donation Breakdown", "Round Up Log", "Previous Impacts"]
    let details :[String] = ["You're impacting:", "You're contributing:", "You've consecutively impacted:", "You've mostly impacted:", "You've made:", "You've helped"]
    let bottomLabels :[String] = ["Causes", "Per Week", "Days", "Armed Services", "Round Ups", "Causes"]
    
    var header = HeaderView(view:UIView())
    var previousBarYOrigin = CGFloat(0)
    var previousScrollViewOffset = CGFloat(0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCollectionView()
        initHeader()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initHeader() {
        self.header = HeaderView(view: self.view)
        self.view.addSubview(self.header)
    }
    
    private func setUpCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: self.header.frame.size.height);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 2;
        self.collectionView.scrollEnabled = false
        self.collectionView.collectionViewLayout = layout;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier);
    }

    //MARK: - Collectionview
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.view.frame.size.width / 2 - 1;
        let height = (self.view.frame.size.height - header.frame.size.height - tabBarHeight - 2*collectionCellOffset-20)/3
        return CGSizeMake(width, height);
    }
    

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let itemNum = indexPath.item
        let cell :ContributionsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContributionsCollectionViewCell
        cell.titleLabel.text = titles[itemNum]
        cell.detailLabel.text = details[itemNum]
        cell.finishingLabel.text = bottomLabels[itemNum]
        if(itemNum != 3){
            cell.imageView.hidden = true
            
        }else{
            cell.numberLabel.hidden = true
        }
        
        return cell
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    


}
