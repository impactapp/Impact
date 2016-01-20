//
//  BlogPostTableViewHeader.swift
//  Impact
//
//  Created by Phillip Ou on 11/20/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

class BlogPostTableViewHeader: UIView {

    var blogPostLabel: UILabel!
    let margins = CGFloat(20)
    var blogPostBody : String = ""
    var blogPostTitle : String = ""
    
    
    @IBOutlet weak var causeNameLabel: UILabel!
    @IBOutlet weak var blogPostTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var blogPostLabelHeight = CGFloat(0)
    var cause : Cause? = nil
    
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    
    init(frame:CGRect, blogPost:BlogPost, cause: Cause?) {
        super.init(frame: frame)
        self.blogPostBody = blogPost.blog_body
        self.blogPostTitle = blogPost.title
        self.cause = cause
        let xibView = NSBundle.mainBundle().loadNibNamed("BlogPostTableViewHeader", owner: self, options: [:]).first as! UIView
        self.addSubview(xibView)
        setUpLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLabel() {
        let textWidth = UIScreen.mainScreen().bounds.width - 2*margins

        let labelY = self.blogPostTitleLabel.frame.origin.y - 80//self.imageView.frame.origin.y + self.imageView.frame.size.height - 40
        self.blogPostTitleLabel.text = self.blogPostTitle
        self.blogPostLabel = UILabel(frame: CGRectMake(20,labelY,textWidth,0))
        self.blogPostLabel.numberOfLines = 0
        self.blogPostLabel.text = self.blogPostBody
        if let cause = self.cause {
            self.causeNameLabel.text = cause.name
        }
        let maximumLabelSize = CGSizeMake(textWidth, CGFloat(Double.infinity));
        let text = self.blogPostLabel.text!
        let font = UIFont(name: "AvenirNext-Regular", size: 15.0)!
        let expectedLabelSize = text.sizeForText(font, maxSize: maximumLabelSize)
        self.blogPostLabel.font = font
        self.blogPostLabel.textColor = UIColor.whiteColor()
        
        var newFrame = self.blogPostLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        self.blogPostLabel.frame = newFrame;

        self.addSubview(self.blogPostLabel)
        let verticalConstraint = NSLayoutConstraint(item: self.blogPostLabel, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.blogPostTitleLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 40)
        self.addConstraint(verticalConstraint)
        self.bringSubviewToFront(self.blogPostLabel)
        
        
    }



}
