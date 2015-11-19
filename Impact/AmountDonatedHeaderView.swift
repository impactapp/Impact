//
//  AmountDonatedHeaderView.swift
//  Impact
//
//  Created by Phillip Ou on 11/15/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class AmountDonatedHeaderView: UIView {

    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var amountRaisedLabel: UILabel!
    @IBOutlet weak var amountLeftLabel: UILabel!
    var cause : Cause!
    
    init(frame:CGRect, cause:Cause) {
        super.init(frame: frame)
        let xibView = NSBundle.mainBundle().loadNibNamed("AmountDonatedHeaderView", owner: self, options: [:]).first as! UIView
        self.backgroundColor = UIColor.blackColor()
        self.addSubview(xibView)
        self.cause = cause
        initGraphView()
        self.titleLabel.text = cause.name
        let currentTotal = cause.currentTotal/100
        let goal = cause.goal/100
        if goal != 0 {
            let percentage = (currentTotal*100)/goal
            self.percentageLabel.text = "\(percentage)%"
        } else {
            self.percentageLabel.text = "0%"
        }
        self.amountRaisedLabel.text = "$\(currentTotal) raised"
        self.amountLeftLabel.text = "$\(goal-currentTotal) to go"

    }
    
    func initGraphView() {
        self.graphView.backgroundColor = UIColor.clearColor()

        let circleWidth = self.graphView.frame.width
        let circleHeight = circleWidth
        var percentage = CGFloat(0)
        if let goal = self.cause.goal {
            let amount = cause.currentTotal
            if goal != 0 {
                percentage = CGFloat(amount)/CGFloat(goal)
            }
        }
        let circleView = CircleGraph(frame: CGRectMake(0, 0, circleWidth, circleHeight), percentage: 1.0-percentage)
        circleView.setThickeness(10.0)
        self.graphView.addSubview(circleView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
