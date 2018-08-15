//
//  RoundedButton.swift
//  Map Tell
//
//  Created by Huynh Danh on 8/21/16.
//  Copyright © 2016 alaamjoh. All rights reserved.
//

import UIKit

// MARK: - RoundButton: UIButton

@IBDesignable
class RoundedButton: UIButton {
    
    // MARK: Properties
    
    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var highlightedBgColor: UIColor?
    @IBInspectable var selectedBgColor: UIColor?
    
    @IBInspectable var borderColor: UIColor = UIColor.black
    @IBInspectable var borderWidth: CGFloat = 0.0
    
    // MARK: Override Functions
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // corner radius
        // -1 maximum rounded rectangle
        self.layer.cornerRadius = cornerRadius == -1 ? rect.size.height / 2 : cornerRadius
        self.layer.masksToBounds = true
        
        // background color
        if let backgroundColor = backgroundColor {
            setBackgroundImage(UIImage.imageWithColor(color: backgroundColor), for: .normal)
        }
        if let highlightedBgColor = highlightedBgColor {
            setBackgroundImage(UIImage.imageWithColor(color: highlightedBgColor), for: .highlighted)
        }
        if let selectedBgColor = selectedBgColor {
            setBackgroundImage(UIImage.imageWithColor(color: selectedBgColor), for: .selected)
        }
        
        // border
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

extension UIImage {
    
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()!
        color.setFill()
        
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}
