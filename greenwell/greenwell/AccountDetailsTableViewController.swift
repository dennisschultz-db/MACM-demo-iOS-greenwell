//
//  AccountDetailsTableViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 07/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit
import Foundation

class AccountDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var balanceAmountLabel: UILabel!
    
    var dataSource:[[Array<String>]] = Util.accountDetails {
        didSet {
            tableView.reloadData()
            updateBalance()
        }
    }
    
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
    
    
    
    func updateBalance() {
        var total = Util.computeTotalForAccount(dataSource)
        
        balanceAmountLabel.text = "$ \(total)"
        if total<0{
            balanceAmountLabel.textColor = UIColor.redColor()
        }else {
            balanceAmountLabel.textColor = UIColor.whiteColor()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return dataSource.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataSource[section].count
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("PAccountDetailHeaderCell") as! PAccountDetailHeaderCell
        cell.dateLabel.text = dataSource[section][0][3]
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountDetailCell", forIndexPath: indexPath) as! AccountDetailTableViewCell

        // Configure the cell...
        var values = dataSource[indexPath.section][indexPath.row]
        cell.name.text = values[0] as String
        cell.detail.text = values[1] as String
        cell.amount.text = "$ \(values[2] as String)"

        return cell
    }



}
