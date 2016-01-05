//
//  AnimatedLabel.swift
//  greenwell
//
//  Created by Philippe Toussaint on 19/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

/**
A label with text animation (fade out/in) when user changes the attributedText property
*/
class AnimatedLabel: UILabel {
    
    
    override var attributedText: NSAttributedString?  {
        get {
            return super.attributedText
        }
        set {
            // Fade out
            UIView.animateWithDuration(1.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.alpha = 0.0
                }, completion: {
                    (finished: Bool) -> Void in
                    super.attributedText = newValue
                    // Fade in
                    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.alpha = 1.0
                        }, completion: nil)
            })
        
        }

    }


}
