//
//  DoneButton.swift
//  Impact
//
//  Created by Phillip Ou on 8/24/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

class DoneButton: UIButton {
    var buttonHeight = CGFloat(50);
    var buttonWidth = CGFloat(0);
    var keyboardFrame : CGRect = CGRectZero;
    var outFrame : CGRect = CGRectZero;
    var inFrame : CGRect = CGRectZero;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(keyboardFrame: CGRect, hidden : Bool) {
        self.keyboardFrame = keyboardFrame;
        buttonWidth = keyboardFrame.size.width;
        self.inFrame = CGRectMake(0, self.keyboardFrame.origin.y-buttonHeight, buttonWidth, buttonHeight);
        self.outFrame = CGRectMake(0, self.keyboardFrame.origin.y-buttonHeight, 0, buttonHeight);
        let currentFrame = hidden ? self.outFrame : self.inFrame;
        super.init(frame:currentFrame);
    }
    
    init(view:UIView,hidden:Bool) {
        buttonWidth=view.frame.size.width
        self.inFrame = CGRectMake(0,view.frame.size.height - buttonHeight,buttonWidth,buttonHeight)
        self.outFrame = CGRectMake(0, view.frame.size.height - buttonHeight, 0, buttonHeight);
        let currentFrame = hidden ? self.outFrame : self.inFrame;
        super.init(frame:currentFrame);
    }
    
    func animateDoneButton(show:Bool) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.frame = show ? self.inFrame : self.outFrame;
        });
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
