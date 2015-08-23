//
//  BottomBorderedTextField.swift
//  Impact
//
//  Created by Phillip Ou on 8/23/15.
//  Copyright (c) 2015 Impact. All rights reserved.
//

import UIKit

@IBDesignable
public class BottomBorderedTextField: UITextField {
    var bottomBorder : CALayer = CALayer();
    
    //MARK : Inspectables
    @IBInspectable
    var color : UIColor = UIColor.whiteColor() {
        didSet {
            setTextFieldColor(color);
        }
    }
    
    @IBInspectable
    var needsBottomBorder = true {
        didSet {
            self.bottomBorder.hidden = !needsBottomBorder;
        }
    }
    
    @IBInspectable
    var placeHolderText : String = "" {
        didSet {
            setPlaceHolder(placeHolderText);
        }
    }
    
    @IBInspectable
    var thumbnail : UIImage? = nil {
        didSet {
            setDefaultAttributes();
        }
    }
    
    //MARK : Initializers
    override init(frame: CGRect) {
        super.init(frame: frame);
        setDefaultAttributes();
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.borderStyle = .None;
        setDefaultAttributes();
    }
    
    init(frame: CGRect, placeHolderText : String, color : UIColor, thumbnail :UIImage?) {
        super.init(frame:frame);
        setAttributes(placeHolderText, color: color, thumbnail: thumbnail);
    }
    
    private func setDefaultAttributes() {
        setAttributes(self.placeHolderText, color: self.color, thumbnail: self.thumbnail);
    }
    
    private func setAttributes(placeHolderText : String, color : UIColor, thumbnail : UIImage?) {
        self.borderStyle = .None;
        setPlaceHolder(placeHolderText)
        setTextFieldColor(color);
        self.textAlignment = .Center;
        self.leftViewMode = .Always;
        if let image = thumbnail {
            let thumbnailImageView = UIImageView(image: image);
            thumbnailImageView.contentMode = .ScaleToFill;
            self.textAlignment = .Left;
            self.leftView = thumbnailImageView
        }
    }
    
    // MARK : Setters
    
    func setPlaceHolder(placeHolderText : String) {
        self.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSForegroundColorAttributeName:self.color]);
    }
    
    func setTextFieldColor(color : UIColor) {
        self.textColor = color;
        let width = CGFloat(2.0)
        self.bottomBorder.borderColor = color.CGColor
        self.bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        self.bottomBorder.borderWidth = width
        self.layer.addSublayer(self.bottomBorder)
        self.layer.masksToBounds = true
    }
}
