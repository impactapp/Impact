//
//  CategoriesViewController.swift
//  Impact
//
//  Created by Phillip Ou on 10/31/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    let headerViewIdentifier = "ChooseCategoryHeaderView";
    let cellIdentifier = "CategoriesCollectionViewCell";
    let headerViewHeight = CGFloat(180)
    var fullRowCategories : [Category] = []
    var notFullRowCategories : [Category] = []
    let cellsPerRow = 3
    var selectedCategories: [Category] = []
    var continueButton:DoneButton = DoneButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        self.setStatusBarColor(UIColor.customRed(), useWhiteText: true)
        ServerRequest.shared.getCategories { (categories) -> Void in
            let lastIndex = categories.count - 1
            let leftOverCells = categories.count % self.cellsPerRow
            self.fullRowCategories = Array(categories[0...(lastIndex-leftOverCells)])
            if leftOverCells != 0 {
                self.notFullRowCategories = Array(categories[(lastIndex-leftOverCells+1)...lastIndex])
            }
            
            self.collectionView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setUpContinueButton()
    }
    
    private func setUpContinueButton() {
        self.continueButton = DoneButton(view: self.view, hidden: true)
        self.continueButton.backgroundColor = UIColor.customRed();
        self.continueButton.setTitle("Continue", forState: .Normal);
        self.continueButton.titleLabel?.textColor = UIColor.whiteColor();
        self.continueButton.addTarget(self, action: "continuePressed", forControlEvents: .TouchUpInside);
        self.view.addSubview(self.continueButton)
    }
    
    private func setUpCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        layout.sectionInset = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8);
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: self.headerViewHeight);
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.collectionViewLayout = layout;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.alwaysBounceVertical = true;
        self.collectionView.registerNib(UINib(nibName: headerViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier);
        self.collectionView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? self.fullRowCategories.count : self.notFullRowCategories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CategoriesCollectionViewCell
        let categories = indexPath.section == 0 ? self.fullRowCategories : self.notFullRowCategories
        let category = categories[indexPath.row]
        cell.categoryLabel.text = category.name
        cell.imageView.setImageWithUrl(NSURL(string: category.icon_url))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as!CategoriesCollectionViewCell
        cell.categoryLabel.textColor = cell.selected ? UIColor.customRed() : UIColor.whiteColor()
        let categories = indexPath.section == 0 ? self.fullRowCategories : self.notFullRowCategories
        let category = categories[indexPath.row]
        if self.selectedCategories.contains(category) {
            self.selectedCategories = self.selectedCategories.filter({ $0 != category })
        } else {
            self.selectedCategories.append(category)
        }
        self.continueButton.animateDoneButton(self.selectedCategories.count >= 4)
        let isSelectedCell =  self.selectedCategories.contains(category)
        cell.categoryLabel.textColor = isSelectedCell ? UIColor.customRed() : UIColor.whiteColor()
        cell.backgroundColorView.backgroundColor = isSelectedCell ? UIColor.customRed() : UIColor.whiteColor()
        let iconUrl = isSelectedCell ? category.selected_icon_url : category.icon_url
        cell.imageView.setImageWithUrl(NSURL(string: iconUrl))
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.collectionView.frame.size.width / 3 - 8;
        
        return CGSizeMake(width, width);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        } else {
            return getEdgeInsetByDevice()
        }
    }
    
    func getEdgeInsetByDevice() -> UIEdgeInsets {
        
        let numberOfCells = self.notFullRowCategories.count
        if DeviceType.IS_IPHONE_4_OR_LESS {
            let edgeInsets = (self.view.frame.size.width - (CGFloat(numberOfCells) * 50) - (CGFloat(numberOfCells) * 50)) / 2
            return UIEdgeInsetsMake(1, edgeInsets, 3, edgeInsets);
        } else {
            var offset : CGFloat = 0
            if DeviceType.IS_IPHONE_5 {
                offset = 40
            }
            if DeviceType.IS_IPHONE_6 {
                offset = 60
            }
            if DeviceType.IS_IPHONE_6P {
                offset = 72
            }
            let edgeInsets = (self.view.frame.size.width - (CGFloat(numberOfCells) * 50) - (CGFloat(numberOfCells) * 10)) / 2 - offset
            return UIEdgeInsetsMake(1, edgeInsets, 3, edgeInsets);

        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: self.view.frame.size.width, height: self.headerViewHeight)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier, forIndexPath: indexPath) ;
    }
    

    
    // MARK: - Navigation
    
    func continuePressed() {
        let tabBarController = TabBarViewController()
        let nvc = UINavigationController(rootViewController: tabBarController)
        nvc.navigationBarHidden = true
        
        ServerRequest.shared.chooseCategories(self.selectedCategories) { (success) -> Void in
            if success {
                self.presentViewController(nvc, animated: true, completion: nil)
            } else {
                //TODO: Display Error Message
            }
        }
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
