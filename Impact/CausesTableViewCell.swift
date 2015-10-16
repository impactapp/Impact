//
//  CausesTableViewCell.swift
//  Impact
//
//  Created by Phillip Ou on 10/15/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit
class CausesTableViewCell: UITableViewCell {

    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var causeNameLabel: UILabel!
    @IBOutlet weak var causeImageView: UIImageView!
    @IBOutlet weak var shadeView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    let cause:Cause? = nil
    let shadeViewAlpha = CGFloat(0.2)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.shadeView.backgroundColor = UIColor(white: 0, alpha: shadeViewAlpha)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func drawPercentageGraph(percentage:CGFloat) {
        self.graphView.backgroundColor = UIColor.clearColor()
        let circleWidth = self.graphView.frame.width
        let circleHeight = circleWidth
        // Create a new CircleView
        let circleView = CircleGraph(frame: CGRectMake(0, 0, circleWidth, circleHeight), percentage: 1.0-percentage)
        self.graphView.addSubview(circleView)
    }
    
}
