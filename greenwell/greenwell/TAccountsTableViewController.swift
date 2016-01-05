//
//  TAccountsTableViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 10/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class TAccountsTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // creates labels that will identify each sections of the table.
        // the label will be located on the left side of each section and is rotated to 90°. It is added to the table's scrollview
        for section in 0...(tableView.numberOfSections-1) {
            let r =  tableView.rectForSection(section)
            let rh = tableView.rectForHeaderInSection(section)
            //let rf = tableView.rectForFooterInSection(section)

            var l = UILabel()
            l.textColor = UIColor.whiteColor()
            l.backgroundColor = UIColor(red: 0/255, green: 138/255, blue: 82/255, alpha: 1.0)
            l.textAlignment = NSTextAlignment.Center
            l.font = UIFont.boldSystemFontOfSize(14)
            l.adjustsFontSizeToFitWidth = true
            l.minimumScaleFactor = 0.5
            l.text = Util.accountsDictionary.keys.array[section]
            l.transform = CGAffineTransformMakeRotation( CGFloat(-90.0 * M_PI / 180.0));
            l.frame = CGRect(x: r.origin.x, y: r.origin.y+rh.height , width: 42, height: r.height-rh.height)
            tableView.addSubview(l)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source, tableview delegate

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Util.accountsDictionary.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyforIndex = Util.accountsDictionary.keys.array[section]
        let values:Array = Util.accountsDictionary[keyforIndex]!
        return values.count
    }
    
    // Creates footer cells
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  footerCell = tableView.dequeueReusableCellWithIdentifier("AccountFooterCell") as! AccountFooterCell
        
        var totalSection:Float = 0.0
        let keyForSection = Util.accountsDictionary.keys.array[section]
        let accountsForSection:Array = Util.accountsDictionary[keyForSection]!
        for i in 0...accountsForSection.count-1 {
//            totalSection = totalSection + Util.computeTotalForAccount( Util.getAccountDetailsForRow(i) )
        }
        
        footerCell.totalLabel.text = "$ \(totalSection)"
        return footerCell
    }
    
    
    // Creates cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as! AccountCell

        // Configure the cell...
        let keyforIndex = Util.accountsDictionary.keys.array[indexPath.section]
        var values:Array = Util.accountsDictionary[keyforIndex]!
        cell.name.text = values[indexPath.row]["name"]
        cell.number.text = values[indexPath.row]["number"]
        
//        let v = Util.computeTotalForAccount( Util.getAccountDetailsForRow(indexPath.row) )
//        values[indexPath.row]["total"] = "\(v)"
//        cell.total.text = "$ \(v)"

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let pvc:TAccountsViewController = self.parentViewController as! TAccountsViewController
        for vc in pvc.childViewControllers {
            if vc .isKindOfClass(TAccountDetailsViewController) {
                
//                (vc as! TAccountDetailsViewController).dataSource = Util.getAccountDetailsForRow(indexPath.row ) as [[Array<String>]]

            }
        }
    }



}
