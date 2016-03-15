//
//  FriendsCollectionViewHeader.swift
//  Impact
//
//  Created by Phillip Ou on 11/19/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class FriendsCollectionViewHeader: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var contributorsCountLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var friends : [User] = []
    let maxFriendsToShow = 10
    init(frame:CGRect, friends:[User]) {
        super.init(frame: frame)
        self.friends = friends
        let xibView = NSBundle.mainBundle().loadNibNamed("FriendsCollectionViewHeader", owner: self, options: [:]).first as! UIView
        self.addSubview(xibView)
        self.contributorsCountLabel.text = "\(friends.count) Contributors"
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(60, 75)
        
        var rightInset:CGFloat? = nil
        if DeviceType.IS_IPHONE_5{
            rightInset = CGFloat((self.friends.count-3)*(60))
        }
        else{
            rightInset = CGFloat((self.friends.count-4)*(60))
        }
        layout.sectionInset = UIEdgeInsetsMake(-10, 5, 10, rightInset!)
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let nib = UINib(nibName: "UserCollectionViewCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "UserCollectionViewCell")
        collectionView.bounces = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.reloadData()
    }
    
    // MARK:  - Collection View
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //var numberOfCells = min(maxFriendsToShow,self.friends.count)
//        if self.friends.count > maxFriendsToShow {
//            numberOfCells += 1
//        }
        return self.friends.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        return configureUserCell(indexPath)
        
    }
    
    func configureUserCell(indexPath:NSIndexPath) -> UserCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCollectionViewCell", forIndexPath: indexPath) as! UserCollectionViewCell
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.cornerRadius = 30
        cell.nameLabel.layer.masksToBounds = true
        cell.nameLabel.layer.cornerRadius = 30
        cell.imageView.backgroundColor = UIColor.customGreyWithAlpha(0.8)
        let shouldShowExtraCell = indexPath.row == self.friends.count && self.friends.count > maxFriendsToShow
        if shouldShowExtraCell  {
            cell.nameLabel.text = nil
            cell.initialsLabel.hidden = false
            cell.initialsLabel.text = "\(self.friends.count)+"
            return cell
        }
        let user = self.friends[indexPath.row]
        
        cell.nameLabel.text = user.name.componentsSeparatedByString(" ").first
        
        
        if user.profile_image_url != nil && user.profile_image_url != ""{
            let urlString = user.profile_image_url
            cell.imageView.setImageWithUrl(NSURL(string:urlString), placeHolderImage: nil)
            cell.initialsLabel.hidden = true
            
        }else{
            if user.facebook_id != 0 {
                let facebookURLString = "http://graph.facebook.com/\(user.facebook_id)/picture?type=large"
                cell.imageView.setImageWithUrl(NSURL(string: facebookURLString), placeHolderImage: nil)
                cell.initialsLabel.hidden = true
                
            }else{
                cell.initialsLabel.hidden = false
                
                let nameComponents = user.name.componentsSeparatedByString(" ")
                var initials = ""
                if let firstName = nameComponents.first {
                    if firstName != "" {
                        initials += String(firstName[firstName.startIndex])
                    }
                }
                if nameComponents.count > 1 {
                    if let lastName = nameComponents.last {
                        if lastName != "" {
                            initials += String(lastName[lastName.startIndex])
                        }
                    }
                }
                
                cell.initialsLabel.text = initials
                
            }
        }
        
   
        
        return cell
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}