//
//  ArticleDetailsViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 17/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var bodyTextview: UITextView!
    @IBOutlet weak var keywordsLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!

    /// the offering item associated to this view
    var item:ArticleItem!
    
    
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
            bodyTextview.attributedText = attrStr
        } catch {
            //bodyTextview.attributedText = NSAttributedString(string: "")
        }
        keywordsLabel.text = item.keywords
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rotated()
    {
        if UIDevice.currentDevice().model.lowercaseString.rangeOfString("iphone") == nil {
            
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
