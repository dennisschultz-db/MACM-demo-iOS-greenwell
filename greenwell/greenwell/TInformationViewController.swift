//
//  TInformationViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 09/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class TInformationViewController: UIViewController {

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
        
        // load the RTF file corresponding to the information to display according to the specified file
        Util.loadRTFFile(fileToLoad,textField: textField)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
