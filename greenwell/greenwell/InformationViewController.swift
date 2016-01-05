//
//  InformationViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 10/03/2015.
//  Copyright (c) 2015 ibm. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

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


}
