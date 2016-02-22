//
//  AlertViewController.swift
//  Impact
//
//  Created by Phillip Ou on 10/2/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

protocol AlertViewControllerDelegate{
    func popupDismissed()
}

class AlertViewController: UIViewController {
    var viewController: UIViewController = UIViewController()
    var popup: UIView = UIView()
    let height = CGFloat(160)
    let widthRatio = CGFloat(0.90)
    weak var button: RoundedButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    var delegate: AlertViewControllerDelegate? = nil

    
    
    
    func setUp(viewController:UIViewController,title:String, message:String, buttonText:String) {
        self.viewController = viewController
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        setUpPopup(title, message: message, buttonText: buttonText)
        
    }
    
    private func setUpPopup(title:String, message:String, buttonText:String) {
        if let alertView:UIView = UINib(nibName: "AlertPopupView", bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView {
            self.popup = alertView
            self.popup.frame = CGRectMake(0, 0, getWidth(), getHeight())
            let x = self.view.center.x
            let y = self.view.center.y - 50
            self.popup.center = CGPointMake(x, y)
            self.titleLabel.text = title
            self.messageLabel.text = message
            self.popup.layer.masksToBounds = true
            self.popup.layer.cornerRadius = 7
            self.view.addSubview(self.popup)
        }
    }
    
    private func getHeight() -> CGFloat {
        return self.height
    }
    
    private func getWidth() -> CGFloat {
        return self.widthRatio * self.view.frame.size.width
    }
    
    func show() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext;
        self.viewController.presentViewController(self, animated: false, completion: nil)
    }
    
    @IBAction func dismissPopup(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let delegate = self.delegate {
            delegate.popupDismissed()
        }
    }
    

}
