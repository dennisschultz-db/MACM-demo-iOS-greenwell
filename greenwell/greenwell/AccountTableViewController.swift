//
//  AccountTableViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 07/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
   

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
        return Util.accountsDictionary.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var keyforIndex = Util.accountsDictionary.keys.array[section]
        let values:Array = Util.accountsDictionary[keyforIndex]!
        return values.count
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderTableViewCell
        
        headerCell.label.text = Util.accountsDictionary.keys.array[section]
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  footer = tableView.dequeueReusableCellWithIdentifier("PAccountFooterCell") as! PAccountFooterCell
        
        var totalSection:Float = 0.0
        let keyForSection = Util.accountsDictionary.keys.array[section]
        var accountsForSection:Array = Util.accountsDictionary[keyForSection]!
        for i in 0...accountsForSection.count-1 {
            totalSection = totalSection + Util.computeTotalForAccount( Util.getAccountForRow(i) )
        }
        footer.totalLabel.text = "$\(totalSection)"
        
        return footer
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as! AccountTableViewCell

        // Configure the cell...
        let keyforIndex = Util.accountsDictionary.keys.array[indexPath.section]
        var values:Array = Util.accountsDictionary[keyforIndex]!
        cell.label.text = values[indexPath.row]["name"]
        cell.number.text = values[indexPath.row]["number"]
        
        let v = Util.computeTotalForAccount( Util.getAccountForRow(indexPath.row) )
        values[indexPath.row]["total"] = "\(v)"
        cell.total.text = "$ \(v)"
        
        
        return cell
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.destinationViewController.isMemberOfClass(AccountDetailsTableViewController) {
            let cell:AccountTableViewCell = sender as! AccountTableViewCell
            let vc:AccountDetailsTableViewController = segue.destinationViewController as! AccountDetailsTableViewController
            vc.title = cell.label.text
            
            let idx:NSIndexPath = self.tableView.indexPathForCell(cell)!
            vc.dataSource = Util.getAccountForRow( idx.row ) as [[Array<String>]]
        }
    }

    

}
