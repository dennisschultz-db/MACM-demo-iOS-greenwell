//
//  LinedLabel.swift
//  greenwell
//
//  Created by Philippe Toussaint on 30/03/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

/**
This is a UILabel with a line drawn at the bottom. The line color is the same as the text color
*/
@IBDesignable
class LinedLabel: UILabel {

    
    override func drawRect(rect: CGRect) {
        
        // Draw a line at the bottom of the label, with the same color as the text color
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1/UIScreen.mainScreen().scale)
        CGContextSetStrokeColorWithColor(context, textColor.CGColor)
        CGContextMoveToPoint(context, 0, self.bounds.size.height-1);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height-1);
        CGContextStrokePath(context);
        super.drawRect(rect)
    }

}
