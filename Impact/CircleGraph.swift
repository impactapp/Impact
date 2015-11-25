//
//  CircleGraph.swift
//  Impact
//
//  Created by Phillip Ou on 10/17/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

public class CircleGraph: UIControl {
    var circleLayer: CAShapeLayer!
    var outerCircleLayer: CAShapeLayer!
    var percentage: CGFloat = CGFloat(0)
    let startAngle = CGFloat(-M_PI * 2.0*0.25)
    
    init(frame: CGRect, percentage:CGFloat) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.percentage = percentage
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: self.startAngle, endAngle: CGFloat(M_PI * 2.0)*self.percentage + startAngle, clockwise: false)
        
        let outerCirclePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: false)

        // Setup the CAShapeLayer with the path, colors, and line width
        outerCircleLayer = CAShapeLayer()
        outerCircleLayer.path = outerCirclePath.CGPath
        outerCircleLayer.fillColor = UIColor.clearColor().CGColor
        outerCircleLayer.strokeColor = UIColor.customGreyWithAlpha(0.4).CGColor
        outerCircleLayer.lineWidth = 5.0;
        outerCircleLayer.strokeEnd = 1.0
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.whiteColor().CGColor
        circleLayer.lineWidth = 8.0;
        circleLayer.strokeEnd = 1.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(outerCircleLayer)
        layer.addSublayer(circleLayer)
    }
    
    func setThickeness(thickness:CGFloat) {
        outerCircleLayer.lineWidth = thickness
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}