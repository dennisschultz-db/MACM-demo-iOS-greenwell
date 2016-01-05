//
//  OfferDetailsViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 11/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class OfferDetailsViewController: UIViewController {

    /// the offering item associated to this view
    var item:OfferingItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var keywords: UILabel!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        rotated()


        titleLabel.text = item.title.uppercaseString
        summaryLabel.text = item.summary
        image.image = item.imageData
        
        // display the long description of the offering item as an attributed text
        let encodedData = item.body.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        do {
            let attrStr = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            detailTextView.attributedText = attrStr
        } catch {
            //detailTextView.attributedText = NSAttributedString(string: "")
        }
        price.text = item.price
        keywords.text = item.keywords
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func rotated()
    {
        if Util.isTablet() {
            
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
            {
                imageWidth.constant = 250
                imageHeight.constant = 250
            }
            else if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
            {
                imageWidth.constant = 160
                imageHeight.constant = 160
            }
        } else {
        }
    }
    
}
