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
    
    
    @IBOutlet weak var imageView: UIImageView!
    var blogPostLabelHeight = CGFloat(0)
    override init(frame:CGRect) {
        super.init(frame: frame)
        let xibView = NSBundle.mainBundle().loadNibNamed("BlogPostTableViewHeader", owner: self, options: [:]).first as! UIView
        self.addSubview(xibView)
        setUpLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLabel() {
        let textWidth = UIScreen.mainScreen().bounds.width - 2*margins
        let labelY = self.imageView.frame.origin.y + self.imageView.frame.size.height - 40
        self.blogPostLabel = UILabel(frame: CGRectMake(20,labelY,textWidth,0))
        self.blogPostLabel.numberOfLines = 0
        self.blogPostLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
        
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
        self.bringSubviewToFront(self.blogPostLabel)
        
    }



}
