//
//  OfferingDetailViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 20/03/2015.
//  Copyright (c) 2015 ibm. All rights reserved.
//

import UIKit

class OfferingDetailViewController: UIViewController {
    
    var item:OfferingItem!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var keywords: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = item.title
        self.title = item.title
        summaryLabel.text = item.summary
        image.image = UIImage(data: item.imageData)
        
        let encodedData = item.body.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        let attrStr = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)
        //body.attributedText = attrStr
        detailTextView.attributedText = attrStr
        
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
