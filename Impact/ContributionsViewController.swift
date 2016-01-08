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
    var previousCauses : [Cause] = []
    var contributions : [Contribution] = []
    var categories : [Category] = []
    var currentUser : User!
    var mostContributedCategory : Category!
    let contributingCauseNameFontSize:CGFloat = 30
    let contritedAmountFontSize:CGFloat = 50
    let defaultTitleLabelFontSize:CGFloat = 125

    let statusBarHeight = CGFloat(20)
    let tabBarHeight = CGFloat(44)
    let collectionCellOffset = CGFloat(2)

    let cellIdentifier = "ContributionsCollectionViewCell"
    let titles :[String] = ["Currently Impacting", "Total Contributions", "Current Streak", "Donation Breakdown", "Round Up Log", "Previous Impacts"]
    let details :[String] = ["You're impacting:", "You've donated:", "You've consecutively impacted:", "You've mostly impacted:", "You've made:", "You've helped"]
    let bottomLabels :[String] = ["Causes", "In Total", "Days", "Armed Services", "Round Ups", "Causes"]
    
    var header = HeaderView(view:UIView())
    var previousBarYOrigin = CGFloat(0)
    var previousScrollViewOffset = CGFloat(0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCollectionView()
        refreshCollectionView()
        initHeader()
    }
    
    override func viewWillAppear(animated: Bool) {
        ServerRequest.shared.getCurrentUser{ (currentUser) -> Void in
            self.currentUser = currentUser
            self.collectionView.reloadData()
        }
        ServerRequest.shared.getPreviousCauses { (causes) -> Void in
            self.previousCauses = causes
            self.collectionView.reloadData()
        }
        ServerRequest.shared.getContributions { (contributions) -> Void in
            self.contributions = contributions
            self.collectionView.reloadData()
        }
        ServerRequest.shared.getCategories { (categories) -> Void in
            self.categories = categories
        }
        
        
        refreshCollectionView()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initHeader() {
        self.header = HeaderView(view: self.view)
        self.view.addSubview(self.header)
    }
    
    //TODO
    private func refreshCollectionView(){
        
        
        
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
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.detailLabel.adjustsFontSizeToFitWidth = true
        if(itemNum != 3){
            cell.finishingLabel.text = bottomLabels[itemNum]
            cell.imageView.hidden = true
        }
        //set defaults
        cell.numberLabel.baselineAdjustment = UIBaselineAdjustment.AlignCenters
            cell.finishingLabel.hidden = false
        cell.numberLabel.textColor = UIColor.whiteColor()
        switch itemNum{
        case 0:
            if(self.previousCauses.count>0){
                cell.numberLabel.numberOfLines = 2

                cell.numberLabel.text = self.previousCauses[0].name

            }else{
                cell.numberLabel.text = ""

            }
            cell.numberLabel.adjustsFontSizeToFitWidth = true

            cell.finishingLabel.hidden = true;
            
        case 1:
            if((self.currentUser) != nil){
                cell.numberLabel.text = "$" + String(self.currentUser.total_amount_contributed);
            }
            cell.numberLabel.adjustsFontSizeToFitWidth = true

        case 2:
            
            cell.numberLabel.hidden = false
            
            if((self.currentUser) != nil){
                let currentTime : NSDate = NSDate()
                if(self.currentUser.last_contribution_date != nil){
                    let lastContribution = self.currentUser.last_contribution_date
                    let oneDayLater = lastContribution!.dateByAddingTimeInterval(60*60*24)
                    print(oneDayLater)
                    print(lastContribution)
                    print(currentTime)
                    if(currentTime.compare(oneDayLater)  == .OrderedAscending){
                        cell.numberLabel.text = String(self.currentUser.current_streak);
                    }else{
                        ServerRequest.shared.postClearUserStreak{ (currentUser) -> Void in
                            
                        }
                        cell.numberLabel.text = "0"
                    }
                }
                
            }
            
        case 3:
            cell.numberLabel.hidden = true
            cell.imageView.hidden = false
            let category:String = getMostContributedCategory()
            if(self.mostContributedCategory != nil){
                //gotta figure out colors here
                cell.imageView.setImageWithUrl(NSURL(string: self.mostContributedCategory.icon_url))
                cell.imageView.backgroundColor = UIColor.whiteColor()
            }

            cell.finishingLabel.text = category
            
        case 4:
            cell.numberLabel.text = String(self.contributions.count)
            cell.numberLabel.textColor = UIColor.customRed()
            
        case 5:
            cell.numberLabel.text = String(self.previousCauses.count)
            cell.numberLabel.textColor = UIColor.customRed()
            cell.numberLabel.adjustsFontSizeToFitWidth = false


        default:
            cell.numberLabel.text = ""
            cell.imageView.hidden = true
        }
        
        return cell
    }
    
    private func getMostContributedCategory() -> String{
        let defaultString = "default string"
        var causeCategories = [String: Int]()

        for cause:Cause in self.previousCauses{
            if let val = causeCategories[cause.category] {
                let inc = val+1
                causeCategories[cause.category] = inc
                
            }else{
                causeCategories[cause.category] = 1
            }
        }
        var maxVal = 0
        var maxCat = defaultString
        for (category, num) in causeCategories{
            if(num>maxVal){
                maxVal = num
                maxCat = category
            }
        }
        
        if(maxCat != defaultString){
            for category in self.categories{
                if(category.name.lowercaseString == maxCat.lowercaseString){
                    self.mostContributedCategory = category
                }
            }
            
        }
        
        
        return maxCat
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let itemNum = indexPath.item
        switch itemNum{
        case 5:
            let previousImpactsVC : PreviousImpactsViewController = PreviousImpactsViewController(nibName: "PreviousImpactsViewController", bundle: nil);
            self.navigationController?.pushViewController(previousImpactsVC, animated: true);
            
        default:
            _ = 0
        }

    }
    


}
