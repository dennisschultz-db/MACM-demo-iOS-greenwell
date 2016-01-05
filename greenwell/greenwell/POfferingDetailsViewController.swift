//
//  POfferingDetailsViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 01/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class POfferingDetailsViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var keywords: UILabel!

    var item:OfferingItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        label.text = item.title
        summary.text = item.summary
        img.image = item.imageData
        
        // display the long description of the offering as a attributed text
        let encodedData = item.body.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        do {
            let attrStr = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            details.attributedText = attrStr
        } catch {
             details.attributedText = NSAttributedString(string: "")
        }
        
        price.text = item.price
        keywords.text = item.keywords
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
