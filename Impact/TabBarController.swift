//
//  TabBarViewController.swift
//  Impact
//
//  Created by Phillip Ou on 8/21/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var contributeButton : UIButton = UIButton();
    let contributeButtonWidth = CGFloat(80);
    
    //MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad();
        initTabBarAttributes();
        setUpViewControllers();
        setUpContributeButton();
    }
    
    func initTabBarAttributes() {
        self.selectedIndex = 0;
        self.tabBar.barTintColor = UIColor.whiteColor()
        self.tabBar.tintColor = UIColor.customRed();
        self.tabBar.opaque = true;
    }
    
    func setUpViewControllers() {
        
        let causesViewController = UIViewController();
        causesViewController.title = "Causes";
        causesViewController.tabBarItem.image = UIImage(named: "CausesIcon");
        
        //add blank viewcontroller here to improve spacing of tabbar
        let blank = UIViewController();
        blank.tabBarItem.enabled = false;
        
        let profileViewController = UIViewController();
        profileViewController.view.backgroundColor = UIColor.customRed();
        profileViewController.title = "Profile";
        profileViewController.tabBarItem.image = UIImage(named: "ProfileIcon");
        self.viewControllers = [causesViewController,blank,profileViewController];
        self.selectedViewController = causesViewController;
    }
    
    //MARK: Contribute Button
    
    //TODO: Need to figure out why button is always slightly transparent
    private func setUpContributeButton() {
        let buttonFrame = CGRectMake(self.tabBar.frame.size.width/2 - contributeButtonWidth/2, -30.0, contributeButtonWidth, contributeButtonWidth);
        self.contributeButton = UIButton(frame: buttonFrame);
        self.contributeButton.addTarget(self, action: "didPressContributeButton:", forControlEvents: .TouchUpInside);
        self.contributeButton.backgroundColor = UIColor.whiteColor();
        self.contributeButton.layer.cornerRadius = contributeButtonWidth/2;
        self.contributeButton.layer.masksToBounds = true;
        self.contributeButton.layer.borderColor = UIColor.customDarkGrey().CGColor;
        self.contributeButton.layer.borderWidth = 1.0;
        self.contributeButton.setImage(UIImage(named:"ContributeIcon"), forState: .Normal);
        self.contributeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        
        var buttonLabel = UILabel(frame: CGRectMake(0,contributeButtonWidth-25,contributeButtonWidth,15));
        buttonLabel.font = UIFont.systemFontOfSize(10);
        buttonLabel.text = "Contribute";
        buttonLabel.textAlignment = .Center;
        buttonLabel.textColor = UIColor.customDarkGrey();
        self.contributeButton.addSubview(buttonLabel);
        var titleLabel = self.contributeButton.titleLabel;
        
        self.tabBar.addSubview(contributeButton);
    }
    
    func didPressContributeButton(sender:UIButton!) {
        animateContributeButton { () -> Void in
            self.presentContributionViewController();
        }
    }
    
    private func animateContributeButton(completion:() -> Void) {
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
    
    //MARK: Navigation
    
    private func presentContributionViewController() {
        
    }
}
