//
//  AccountDetailsViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 20/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class AccountDetailsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountTotalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var accountIndexPath:NSIndexPath!  {
        didSet {
            if accountIndexPath != oldValue {
                updateContent()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "accountChanged:", name: SelectedAccountDidChangeNotification, object: nil)
        updateContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func accountChanged(notification:NSNotification) {
        let dico:Dictionary = notification.userInfo!
        accountIndexPath = dico["indexPath"] as? NSIndexPath
    }

    func updateContent() {
        
        if !self.isViewLoaded() || accountIndexPath==nil {
            return
        }
        
        let a = Array(Util.accountsDictionary.keys)
        let keyforIndex = a[accountIndexPath.section]
        let accounts:[[String:String]] = Util.accountsDictionary[keyforIndex]!
        let account: [String:String] = accounts[accountIndexPath.row]
        
        accountNameLabel.text = account["name"]?.uppercaseString
        accountTotalLabel.text = "\(Util.getAccountTotalForRow(accountIndexPath.row))"
        
        tableView.reloadData()
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if accountIndexPath==nil {
            return 0
        }
        let a = Util.getAccountDetailsForRow(accountIndexPath.row)
        return a.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailCell
        
        let details = Util.getAccountDetailsForRow(accountIndexPath.row)
        
        cell.dateLabel.text = details[indexPath.row][3]
        cell.descriptionLabel.text = details[indexPath.row][0]
        cell.amountLabel.text = details[indexPath.row][2]
        
        if cell.amountLabel.text?.characters.contains("-")==true {
            cell.amountLabel.textColor = UIColor.redColor()
        } else {
            cell.amountLabel.textColor = UIColor.blackColor()
        }
    
        return cell
    }
    
    

}
