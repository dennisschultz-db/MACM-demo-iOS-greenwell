//
//  CustomView.swift
//  greenwell
//
//  Created by Philippe Toussaint on 11/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

/**
A custom view that draws a rectangle on its bounds with the new "borderColor" property
*/
@IBDesignable
class CustomView: UIView {

    /** Color of the border drawn on view's bounds */
    @IBInspectable var borderColor : UIColor!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1/UIScreen.mainScreen().scale)
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
        CGContextAddRect(context, self.bounds)
        CGContextStrokePath(context);
        
        super.drawRect(rect)
    }
    

}
