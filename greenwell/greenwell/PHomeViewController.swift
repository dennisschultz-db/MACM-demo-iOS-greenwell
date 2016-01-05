//
//  PHomeViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 08/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class PHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return Util.shouldAutoRotate()
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier == "segueToPrivacy"){
            let vc = segue.destinationViewController as! InformationViewController
            vc.fileToLoad = "privacy"
        }else if(segue.identifier=="segueToLegal"){
            let vc = segue.destinationViewController as! InformationViewController
            vc.fileToLoad = "legal"
        }
    }


}
