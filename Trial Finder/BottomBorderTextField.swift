//
//  BottomLineTextField.swift
//  Trial Finder
//
//  Created by Huynh Danh on 10/18/16.
//  Copyright © 2016 Iran Mateu. All rights reserved.
//

import UIKit

@IBDesignable
class BottomLineTextField: UITextField {
    
    @IBInspectable
    var borderColor: UIColor = UIColor.darkGray
    
    @IBInspectable
    var boderWidth: CGFloat = 1.0
    
    @IBInspectable
    var placeholderColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        if let placeholderColor = placeholderColor, let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: placeholderColor])
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let border = CALayer()
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - boderWidth, width:  frame.size.width, height: frame.size.height)
        
        border.borderWidth = boderWidth
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
}
