//
//  BeaconDetailViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 27/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class BeaconDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: LinedLabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var keywordsTextField: UITextField!
    
    
    
    @IBOutlet weak var categoryTextField: UITextField!
    var actionType:String = "create"
    var beaconRegionIndex:Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if actionType == "create" {
            titleLabel.text = "Create an iBeacon to monitor"
            actionButton.setTitle("Create", forState: UIControlState.Normal)
        }else {
            titleLabel.text = "Edit an monitored iBeacon"
            actionButton.setTitle("Apply", forState: UIControlState.Normal)
            uuidTextField.enabled = false
            identifierTextField.enabled = false
            
            let tuple = AppDelegate.beaconManager.beaconRegions[beaconRegionIndex]
            uuidTextField.text = tuple.beaconRegion.proximityUUID.UUIDString
            identifierTextField.text = tuple.beaconRegion.identifier
            categoryTextField.text = tuple.category
            
            var ks = ""
            for s in tuple.keywords {
                ks.appendContentsOf("\(s) ")
            }
            ks = ks.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
            keywordsTextField.text = ks
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var tag = textField.tag
        textField.resignFirstResponder()
        tag = (tag + 1)%4
        self.view.viewWithTag(tag)?.becomeFirstResponder()
        return false
    }

    
    @IBAction func touchActionButton(sender: AnyObject) {
        
        let uuid = uuidTextField.text!
        let identifier = identifierTextField.text!
        let keywords = keywordsTextField.text!
        let category =  categoryTextField.text!
        
        if actionType=="edit" {
            AppDelegate.beaconManager.beaconRegions[beaconRegionIndex].keywords = (keywords.componentsSeparatedByString(" "))
            AppDelegate.beaconManager.beaconRegions[beaconRegionIndex].category = category
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            let nsuuid = NSUUID(UUIDString: uuid)
            let arrayk = keywords.componentsSeparatedByString(" ")
            if nsuuid == nil {
                presentUUIDError()
            } else {
                AppDelegate.beaconManager.addBeaconRegionWithUUID( nsuuid!, identifier: identifier, category:category, keywords: arrayk)
                NSNotificationCenter.defaultCenter().postNotificationName(AddBeaconRegionNotification, object: self)
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func presentUUIDError() {
        let alert = UIAlertController(title: "Error", message: "The Proximity UUID for the iBeacon is not valid, please retry", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Button"), style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
