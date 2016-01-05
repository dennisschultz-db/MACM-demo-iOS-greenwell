//
//  InitialViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 05/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var pinButtons: [UIButton]!
    @IBOutlet weak var pinTextfield: UITextField!
    
    var PINcount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        relocatePINbuttons()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return Util.shouldAutoRotate()
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // set file to display when user chooses to view information about "Privacy" or "Legal"
        if( segue.identifier == "segueToPrivacy"){
            let vc = segue.destinationViewController as! InfoViewController
            vc.fileToLoad = "privacy"
        }else if(segue.identifier=="segueToLegal"){
            let vc = segue.destinationViewController as! InfoViewController
            vc.fileToLoad = "legal"
        }
    }
    
    /**
    Randomly changes the layout of the virtual keyboard used to enter PIN.
    */
    func relocatePINbuttons() {
        
        var numbers = [0,1,2,3,4,5,6,7,8,9]

        for btn in pinButtons {
            let idx = Int(arc4random_uniform( UInt32(numbers.count) ))
            btn.setTitle("\(numbers[idx])", forState: UIControlState.Normal)
            numbers.removeAtIndex(idx)
        }
    }

    @IBAction func touchPINbutton(sender: AnyObject) {
        pinTextfield.text = pinTextfield.text! + ((sender as! UIButton).titleLabel?.text)!
        PINcount++
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    @IBAction func touchLoginButton(sender: AnyObject) {
        performSegueWithIdentifier("segueToHome", sender: sender)
    }
    
    
}
