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
    var categories : [Category] = []
    var selectedRows: [Int] = []
    var continueButton:DoneButton = DoneButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        self.setStatusBarColor(UIColor.customRed(), useWhiteText: true)
        ServerRequest.shared.getCategories { (categories) -> Void in
            self.categories = categories
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
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 180);
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
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CategoriesCollectionViewCell
        let isSelectedCell = self.selectedRows.contains(indexPath.row)
        let category = self.categories[indexPath.row]
        cell.categoryLabel.text = category.name
        cell.categoryLabel.textColor = isSelectedCell ? UIColor.customRed() : UIColor.whiteColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as!CategoriesCollectionViewCell
        cell.categoryLabel.textColor = cell.selected ? UIColor.customRed() : UIColor.whiteColor()
        if self.selectedRows.contains(indexPath.row) {
            self.selectedRows = self.selectedRows.filter({ $0 != indexPath.row })
        } else {
            self.selectedRows.append(indexPath.row)
        }
        self.continueButton.animateDoneButton(self.selectedRows.count >= 4)
        collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.collectionView.frame.size.width / 3 - 8;
        return CGSizeMake(width, width);
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier, forIndexPath: indexPath) ;
    }
    

    
    // MARK: - Navigation
    
    func continuePressed() {
        let tabBarController = TabBarViewController()
        let nvc = UINavigationController(rootViewController: tabBarController)
        nvc.navigationBarHidden = true
        self.presentViewController(nvc, animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
