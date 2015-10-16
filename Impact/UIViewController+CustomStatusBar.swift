//
//  UIViewController+CustomStatusBar.swift
//  Impact
//
//  Created by Phillip Ou on 10/16/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import Foundation

extension UIViewController {
    func setStatusBarColor(color:UIColor, useWhiteText:Bool) {
        let statusBarHeight = CGFloat(20)
        let statusBarBackGround = UIView(frame: CGRectMake(0, 0, self.view.frame.width, statusBarHeight))
        statusBarBackGround.backgroundColor = color
        self.view.addSubview(statusBarBackGround)
        UIApplication.sharedApplication().statusBarStyle = useWhiteText ? .LightContent : .Default
    }
}
