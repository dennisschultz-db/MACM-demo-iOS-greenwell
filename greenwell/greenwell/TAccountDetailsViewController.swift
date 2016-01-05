//
//  TAccountDetailsViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 13/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class TAccountDetailsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceAmountLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    
    var dataSource:[[String]] = Util.accountDetails {
        didSet {
            tableView.reloadData()
            updateBalance()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Updates the amonut label in the balance view section
    */
    func updateBalance(){
//        let total = Util.computeTotalForAccount(dataSource)
//        
//        balanceAmountLabel.text = "$ \(total)"
//        if total<0{
//            balanceAmountLabel.textColor = UIColor.redColor()
//        }else {
//            balanceAmountLabel.textColor = UIColor.whiteColor()
//        }
    }
    
   
    
    // tableview data source and tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataSource[section].count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountDetailHeaderCell") as! AccountDetailHeaderCell
        
//        cell.dateLabel.text = dataSource[section][0][3]
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountDetailCell", forIndexPath: indexPath) as! AccountDetailCell
        
        // Configure the cell...
        var values = dataSource[indexPath.section][indexPath.row]
//        cell.name.text = values[0] as String
//        cell.detail.text = values[0] as String
//        cell.amount.text = values[2] as String
        
        return cell
    }

}
