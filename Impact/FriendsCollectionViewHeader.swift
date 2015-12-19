//
//  FriendsCollectionViewHeader.swift
//  Impact
//
//  Created by Phillip Ou on 11/19/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class FriendsCollectionViewHeader: UIView {

    init(frame:CGRect, cause:Cause) {
        super.init(frame: frame)
        let xibView = NSBundle.mainBundle().loadNibNamed("FriendsCollectionViewHeader", owner: self, options: [:]).first as! UIView
        self.addSubview(xibView)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
