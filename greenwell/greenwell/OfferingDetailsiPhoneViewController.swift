//
//  OfferingDetailsiPhoneViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 01/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class OfferingDetailsiPhoneViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var keywords: UILabel!
    @IBOutlet weak var authors: UILabel!

    var item:OfferingItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        label.text = item.title
        summary.text = item.summary
        img.image = UIImage(data: item.imageData)
        
        let encodedData = item.body.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        let attrStr = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)
        details.attributedText = attrStr
        
        price.text = item.price
        keywords.text = item.keywords
        authors.text = item.authors
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
