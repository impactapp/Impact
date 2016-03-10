//
//  TabBarViewController.swift
//  Impact
//
//  Created by Phillip Ou on 8/21/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var underlineView = UIView()
    let underlineHeight = CGFloat(4.0)
    let tabBarImageInsets = UIEdgeInsetsMake(3, 0, -3, 0)
    var contributeButton : UIButton = UIButton()
    let contributeButtonWidth = CGFloat(80)
    
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad();
        UIApplication.sharedApplication().statusBarHidden = false
        initTabBarAttributes();
        setUpViewControllers();
        initUnderLine()
        setUpContributeButton()
    }
    
    func initTabBarAttributes() {
        self.selectedIndex = 0;
        self.tabBar.barTintColor = UIColor.blackColor()
        self.tabBar.tintColor = UIColor.whiteColor();
        self.tabBar.opaque = true;
        self.tabBar.translucent = false
    }
    
    func setUpViewControllers() {
        let exploreViewController = ExploreViewController();
        exploreViewController.tabBarItem.image = UIImage(named: "Earth");
        exploreViewController.extendedLayoutIncludesOpaqueBars = true
        let profileViewController = ProfileViewController();
        profileViewController.tabBarItem.image = UIImage(named: "Person");
        profileViewController.extendedLayoutIncludesOpaqueBars = true
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem.image = UIImage(named:"MagnifyingGlass")
        searchViewController.extendedLayoutIncludesOpaqueBars = true
        let contributionsViewController = ContributionsViewController()
        contributionsViewController.tabBarItem.image = UIImage(named: "stats");
        contributionsViewController.extendedLayoutIncludesOpaqueBars = true
        let donateViewController = DonateViewController()
        donateViewController.extendedLayoutIncludesOpaqueBars = true
        donateViewController.tabBarItem.enabled = false
        
        self.viewControllers = [exploreViewController,contributionsViewController,donateViewController,searchViewController,profileViewController];
        for item:UITabBarItem in self.tabBar.items! {
            item.imageInsets = self.tabBarImageInsets
        }
        self.selectedViewController = exploreViewController;
    }
    
    func initUnderLine() {
        let tabBarFrame = self.tabBar.frame
        let underlineWidth = tabBarFrame.width / CGFloat(self.tabBar.items!.count)
        let underlineXOrigin = underlineWidth * CGFloat(self.selectedIndex)
        let underlineFrame = CGRectMake(underlineXOrigin, CGRectGetMaxY(tabBarFrame) - underlineHeight, underlineWidth, underlineHeight)
        self.underlineView = UIView(frame: underlineFrame)
        self.underlineView.backgroundColor = UIColor.customDarkRed()
        self.view.addSubview(self.underlineView)
    }
    
    private func setUpContributeButton() {
        let buttonFrame = CGRectMake(self.tabBar.frame.size.width/2 - contributeButtonWidth/2, -30.0, contributeButtonWidth, contributeButtonWidth);
        self.contributeButton = UIButton(frame: buttonFrame);
        self.contributeButton.addTarget(self, action: "didPressContributeButton:", forControlEvents: .TouchUpInside);
        self.contributeButton.tintColor = UIColor.whiteColor()
        self.contributeButton.backgroundColor = UIColor.blackColor()
        self.contributeButton.opaque = true
        self.contributeButton.layer.cornerRadius = contributeButtonWidth/2;
        self.contributeButton.layer.masksToBounds = true;
        self.contributeButton.layer.borderWidth = 1.0;
        self.contributeButton.setImage(UIImage(named:"colored-heart-unfilled"), forState: .Normal);
        self.contributeButton.setImage(UIImage(named: "colored-heart"), forState: .Highlighted)
        self.contributeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.tabBar.addSubview(contributeButton);
    }
    
    func didPressContributeButton(sender:UIButton!) {
        self.selectedIndex = 2
        animateContributeButton { () -> Void in
            self.contributeButton.highlighted = true
        }
    }
    
    private func animateContributeButton(completion:() -> Void) {
        let middleIndex = 2
        animateUndlerineToIndex(middleIndex)
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseInOut, animations: {
            //shrink button
            var shrinkTransformation = CATransform3DIdentity;
            shrinkTransformation = CATransform3DMakeScale(0.3, 0.3, 1.0);
            self.contributeButton.layer.transform = shrinkTransformation;

            }, completion: { finished in
                UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseInOut, animations: {
                    //enlarge button
                    var enlargeTransformation = CATransform3DIdentity;
                    enlargeTransformation = CATransform3DMakeScale(1.0, 1.0, 1.0);
                    self.contributeButton.layer.transform = enlargeTransformation;
                    }, completion: { finished in
                        completion();
                });
        });
    }
    
    
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        self.contributeButton.highlighted = false
        if let newIndex = self.tabBar.items?.indexOf(item) {
            animateUndlerineToIndex(newIndex)
        }
    }
    
    private func animateUndlerineToIndex(index: Int) {
        let underlineFrame = self.underlineView.frame
        let newXOrigin = underlineFrame.size.width * CGFloat(index)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.underlineView.frame = CGRectMake(newXOrigin, underlineFrame.origin.y, underlineFrame.width, underlineFrame.height)
            }, completion: nil)
        
    }
}
