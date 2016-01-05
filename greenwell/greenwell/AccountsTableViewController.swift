//
//  AccountsTableViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 20/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

let SelectedAccountDidChangeNotification = "SelectedAccountDidChangeNotification"

class AccountsTableViewController: UITableViewController {
    
    var selectedAccountIndexPath:NSIndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Util.accountsDictionary.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let a = Array(Util.accountsDictionary.keys)
        let keyforIndex = a[section]
        let accounts:Array = Util.accountsDictionary[keyforIndex]!
        return accounts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as! AccountCell
        let bgv = UIView()
        bgv.backgroundColor = UIColor(red: 192/255, green: 230/255, blue: 255/255, alpha: 1.0)
        cell.selectedBackgroundView = bgv

        // Configure the cell...
        let a = Array(Util.accountsDictionary.keys)
        let keyforIndex = a[indexPath.section]
        let accounts:[[String:String]] = Util.accountsDictionary[keyforIndex]!
        let account: [String:String] = accounts[indexPath.row]
        
        cell.name.text = account["name"]
        cell.number.text = account["number"]
        cell.total.text = "\(Util.getAccountTotalForRow(indexPath.row))"
                
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let a = Array(Util.accountsDictionary.keys)
        return a[section]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedAccountIndexPath = indexPath
        // notify the account selection
        NSNotificationCenter.defaultCenter().postNotificationName(SelectedAccountDidChangeNotification, object: self,userInfo: ["indexPath":selectedAccountIndexPath])
        return indexPath
    }
    

    
    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // do not perform segue to Account details on iPad,
        if identifier=="segueToAccountDetails" && UIDevice.currentDevice().model.lowercaseString.rangeOfString("iphone") == nil {
            return false
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier=="segueToAccountDetails" {
            let vc = segue.destinationViewController as! AccountDetailsViewController
            vc.accountIndexPath = selectedAccountIndexPath
        }
    }
    

}
