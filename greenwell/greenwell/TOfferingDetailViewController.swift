//
//  TOfferingDetailViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 20/03/2015.
//  Copyright (c) 2015 ibm. All rights reserved.
//

import UIKit

class TOfferingDetailViewController: UIViewController {
    
    /// the offering item associated to this view
    var item:OfferingItem!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var keywords: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = item.title
        self.title = item.title
        summaryLabel.text = item.summary
        image.image = item.imageData
        
        // display the long description of the offering item as an attributed text
        let encodedData = item.body.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        do {
            let attrStr = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            detailTextView.attributedText = attrStr
        } catch {
            detailTextView.attributedText = NSAttributedString(string: "")
        }
        price.text = item.price
        keywords.text = item.keywords
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
