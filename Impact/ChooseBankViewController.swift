//
//  ChooseBankViewController.swift
//  Impact
//
//  Created by Phillip Ou on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class ChooseBankViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!
    let headerViewIdentifier = "ChooseBankHeaderView";
    let cellIdentifier = "RoundedCollectionViewCell";
    var banks : [Bank] = [];
    var selectedBank : Bank? = nil;

    override func viewDidLoad() {
        super.viewDidLoad();
        UIApplication.sharedApplication().statusBarHidden = true;
        setUpCollectionView();
        ServerRequest.shared.getAllBanks { (banks) -> Void in
            self.banks = banks;
            self.collectionView.reloadData();
        }
    }
    
    private func setUpCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12);
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 150);
        self.collectionView.collectionViewLayout = layout;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.alwaysBounceVertical = true;
        self.collectionView.registerNib(UINib(nibName: headerViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier);
        self.collectionView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier);
    }
    
    //MARK: - Collectionview
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banks.count;
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.view.frame.size.width / 2 - 20;
        return CGSizeMake(width, width);
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier, forIndexPath: indexPath) ;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let bank = banks[indexPath.row];
        return cellWithBank(bank, indexPath: indexPath);
    }
    
    private func cellWithBank(bank : Bank, indexPath:NSIndexPath) -> RoundedCollectionViewCell {
        let cell : RoundedCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! RoundedCollectionViewCell;
        cell.titleLabel.text = bank.name;
        cell.titleLabel.hidden = true //TODO: ASK VAL WHAT HER THOUGHTS ARE ON THIS
        if let imageURL = bank.logoURL {
            cell.imageView.setImageWithUrl(NSURL(string: imageURL), placeHolderImage: nil);
        }
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedBank = banks[indexPath.row];
        let bsvc : BankSignInViewController = BankSignInViewController(nibName: "BankSignInViewController", bundle: nil);
        bsvc.bank = self.selectedBank;
        self.navigationController?.pushViewController(bsvc, animated: true);
    }

}
