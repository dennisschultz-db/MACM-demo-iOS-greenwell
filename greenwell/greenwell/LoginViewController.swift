//
//  LoginViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 09/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageLabel.hidden = true
        loginTextfield.delegate = self
        passwordTextfield.delegate = self
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

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField==loginTextfield {
            textField.resignFirstResponder();
            passwordTextfield.becomeFirstResponder()
        }
        if textField==passwordTextfield {
            checkLogin(loginTextfield.text,password: passwordTextfield.text)
        }
        
        return true
    }
    
    @IBAction func touchConnectButton(sender: AnyObject) {
        checkLogin(loginTextfield.text,password: passwordTextfield.text)
        
    }
    
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
