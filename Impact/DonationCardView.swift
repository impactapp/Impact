//
//  DonationCardView.swift
//  Impact
//
//  Created by Phillip Ou on 2/15/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

protocol DonationCardViewDelegate {
    func donateButtonPressed(donationAmount: Int)
    func clearButtonPressed()
    func manageButtonPressed()
    func inRoundupsPressed()
}

class DonationCardView: UIView {
    var delegate : DonationCardViewDelegate? = nil
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet var youHaveCollectedLabel: UILabel!
    var amount:Int = 0{
        willSet(newValue){
            let decimalAmount = CGFloat(newValue) / CGFloat(100.00)
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            self.amountTextField.text = newValue == 0 ? "$0.00" : formatter.stringFromNumber(decimalAmount)
        }
    }
    override init(frame:CGRect) {
        super.init(frame: frame)
        let xibView = NSBundle.mainBundle().loadNibNamed("DonationCardView", owner: self, options: [:]).first as! UIView
        self.amountTextField.enabled = false
        self.addSubview(xibView)
        xibView.frame = self.frame;
        self.youHaveCollectedLabel.adjustsFontSizeToFitWidth = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBAction func donateButtonPressed(sender: AnyObject) {
        self.delegate?.donateButtonPressed(self.amount)
    }

    @IBAction func clearButtonPressed(sender: AnyObject) {
        self.delegate?.clearButtonPressed()
    }
    @IBAction func manageButtonPressed(sender: AnyObject) {
        self.delegate?.manageButtonPressed()
    }
    @IBAction func inRoundUpsButtonPressed(sender: AnyObject) {
        self.delegate?.inRoundupsPressed()
    }
    @IBAction func helperLinkPressed(sender: AnyObject) {
        self.delegate?.inRoundupsPressed()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
