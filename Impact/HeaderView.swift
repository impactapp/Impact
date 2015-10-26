//
//  HeaderView.swift
//  Impact
//
//  Created by Phillip Ou on 10/15/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    var parentView:UIView? = nil
    let headerHeight = CGFloat(44)
    
    init(view:UIView) {
        super.init(frame: CGRectMake(0,0,view.frame.size.width,self.headerHeight))
        self.parentView = view
        self.initProperties()
    }
    
    func addHeaderToView(view:UIView) {
        if let parentView = self.parentView {
            
            parentView.addSubview(self)
        }
    }
    
    private func initProperties() {
        self.backgroundColor = UIColor.customRed()
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
