//
//  CustomSegmentControl.swift
//  Impact
//
//  Created by Phillip Ou on 11/14/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

protocol CustomSegmentControlDelegate{
    func segmentControlDidChange()
}

@IBDesignable class CustomSegmentControl: UIControl {
    
    var delegate:CustomSegmentControlDelegate! = nil
    
    private var labels = [UILabel]()
    
    //didSet is triggered once the property has changed
    var selectedIndex : Int = 0 {
        didSet {
            
            displayNewSelectedIndex()
        }
    }
    
    var items:[String] = ["Summary", "Updates"] {
        didSet {
            setUpLabels()
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setUpView()
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)!
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        if labels.count == 2 {
            let gap = CGFloat(10)
            let leftLabel = labels[0]
            leftLabel.textAlignment = .Right
            leftLabel.frame = CGRectMake(0,0,labelWidth-gap,labelHeight)
            leftLabel.font = UIFont.avenirNext(15.0)
            
            let rightLabel = labels[1]
            rightLabel.textAlignment = .Left
            rightLabel.frame = CGRectMake(labelWidth + gap,0,labelWidth - gap,labelHeight)
            rightLabel.font = UIFont.avenirNext(15.0)
            
        } else {
            for index in 0..<labels.count {
                let label = labels[index]
                label.textAlignment = .Center
                let xPosition = CGFloat(index)*labelWidth
                
                label.frame = CGRectMake(xPosition,0,labelWidth,labelHeight)
                label.font = UIFont.avenirNext(13.0)
            }
        }
        

        
        layer.borderColor = UIColor.clearColor().CGColor
        layer.borderWidth = CGFloat(1)
    }
    
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        
        var calculatedIndex: Int?
        for (index,item) in labels.enumerate() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActionsForControlEvents(.ValueChanged)
        }
        
        return false
    }
    
    func setUpView() {
        backgroundColor = UIColor.whiteColor()
        setUpLabels()
    }
    
    func setUpLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepCapacity: true)
        
        for index in 0..<items.count {
            let label = UILabel(frame:CGRectZero)
            label.text = items[index]
            label.textAlignment = .Center
            label.textColor = index == selectedIndex ? UIColor.blackColor() : UIColor.grayColor()
            label.font = UIFont(name: "STHeitiSC-Medium", size: 14)
            self.addSubview(label)
            labels.append(label)
        }
    }
    
    func displayNewSelectedIndex() {
        if let delegate = self.delegate {
            delegate.segmentControlDidChange()
        }
        setUpLabels()
    }
    
}