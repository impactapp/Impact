//
//  AlertView.swift
//  Impact
//
//  Created by Phillip Ou on 10/2/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class AlertView: UIView {
    var title:String? = nil
    var message:String? = nil
    var buttonMessage:String? = nil
    var viewController: UIViewController = UIViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init() {
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
    }
    init(viewController:UIViewController, message:String, title:String, buttonMessage:String) {
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        self.message = message
        self.title = title
        self.buttonMessage = buttonMessage
        self.viewController = viewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func getHeight() -> CGFloat {
        return 0.25 * self.viewController.view.frame.size.height
    }
    
    private func getWidth() -> CGFloat {
        return 0.85 * self.viewController.view.frame.size.width
    }
    
    func setUpViews(viewController:UIViewController) {
        self.viewController = viewController
        self.frame = CGRectMake(0, 0, getWidth(), getHeight())
        let x = self.viewController.view.center.x
        let y = self.viewController.view.center.y - 50
        self.center = CGPointMake(x, y)
        //        self.titleLabel.text = self.title
        //        self.messageLabel.text = self.message
        //        self.button.titleLabel!.text = self.buttonMessage
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 7
    }
    
    func show() {
        self.viewController.view.addSubview(self)
    }
    
    
}
