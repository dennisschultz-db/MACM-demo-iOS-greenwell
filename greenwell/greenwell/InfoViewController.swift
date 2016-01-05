//
//  InfoViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 06/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    
    var fileToLoad:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set label text
        if(fileToLoad=="privacy"){
            titleLabel.text = "Privacy and Security"
        }else {
            titleLabel.text = "Legal Information"
        }
        
        // load the RTF file corresponding to the information to display
        Util.loadRTFFile(fileToLoad,textField: textField)
        
    }

    override func shouldAutorotate() -> Bool {
        return Util.shouldAutoRotate()
    }
    
    @IBAction func touchCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
