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
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad();
        UIApplication.sharedApplication().statusBarHidden = false
        initTabBarAttributes();
        setUpViewControllers();
        initUnderLine()
    }
    
    func initTabBarAttributes() {
        self.selectedIndex = 0;
        self.tabBar.barTintColor = UIColor.blackColor()
        self.tabBar.tintColor = UIColor.whiteColor();
        self.tabBar.opaque = true;
    }
    
    func setUpViewControllers() {
        let exploreViewController = ExploreViewController();
        exploreViewController.tabBarItem.image = UIImage(named: "Earth");
        let profileViewController = UIViewController();
        profileViewController.tabBarItem.image = UIImage(named: "Heart");
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem.image = UIImage(named:"MagnifyingGlass")
        let test2 = UIViewController()
        test2.tabBarItem.image = UIImage(named: "Person");
        self.viewControllers = [exploreViewController,profileViewController,searchViewController,test2];
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
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let underlineFrame = self.underlineView.frame
        if let newIndex = self.tabBar.items?.indexOf(item) {
            let newXOrigin = underlineFrame.size.width * CGFloat(newIndex)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.underlineView.frame = CGRectMake(newXOrigin, underlineFrame.origin.y, underlineFrame.width, underlineFrame.height)
                }, completion: nil)
        }
    }
}
