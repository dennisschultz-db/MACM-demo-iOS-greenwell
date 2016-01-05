//
//  ServerSettingsViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 24/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class ServerSettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var applyButton: UIBarButtonItem!
    @IBOutlet weak var serverURLTextfield: UITextField!
    @IBOutlet weak var tenantTextfield: UITextField!
    @IBOutlet weak var libraryTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidden = true
        
        serverURLTextfield.text = AppDelegate.caas.macminstance
        tenantTextfield.text = AppDelegate.caas.tenant
        libraryTextfield.text = AppDelegate.caas.library
        usernameTextfield.text = AppDelegate.caas.username
        passwordTextfield.text = AppDelegate.caas.password
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
        let tag = (textField.tag + 1) % 5
        
        if tag != 0 {
            self.view.viewWithTag( tag)?.becomeFirstResponder()
        } else {
            textField.endEditing(true)
        }
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        applyButton.enabled = true
    }
    
    
    @IBAction func touchCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func touchApplyButton(sender: AnyObject) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        AppDelegate.caas.attemptSignInAndChangeSettings(serverURLTextfield.text!, ptenant: tenantTextfield.text!, pusername:usernameTextfield.text!, ppassword:passwordTextfield.text!, plibrary:libraryTextfield.text!, vc: self,
            
            successCompletionBlock: { () -> Void in
                self.activityIndicator.stopAnimating()
                self.dismissViewControllerAnimated(true, completion: nil)
            },
            
            failureCompletionBlock: { () -> Void in
                self.activityIndicator.stopAnimating()
            }
        )
    }
}
