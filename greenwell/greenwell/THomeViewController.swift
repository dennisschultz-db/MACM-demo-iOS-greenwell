//
//  THomeViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 09/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class THomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginTextfield.delegate = self
        passwordTextfield.delegate = self
        messageLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier == "segueToPrivacy"){
            let vc = segue.destinationViewController as! InformationViewController
            vc.fileToLoad = "privacy"
        }else if(segue.identifier=="segueToLegal"){
            let vc = segue.destinationViewController as! InformationViewController
            vc.fileToLoad = "legal"
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField==loginTextfield {
            textField.resignFirstResponder();
            passwordTextfield.becomeFirstResponder()
        }
        if textField==passwordTextfield {
            checkLogin(loginTextfield.text!,password: passwordTextfield.text!)
        }
        
        return true
    }
    
    @IBAction func touchConnectButton(sender: AnyObject) {
        checkLogin(loginTextfield.text!,password: passwordTextfield.text!)
        
    }
    
    /**
    Checkin login credentials
    */
    func checkLogin(login:String, password:String) {
        
        if Util.checkLogin(login,password: password) {
            messageLabel.hidden = true
            self.performSegueWithIdentifier("segueToOperations", sender: self)
            
        }
        else {
            messageLabel.hidden=false
            loginTextfield.becomeFirstResponder()
        }
        
    }
    
    

}
