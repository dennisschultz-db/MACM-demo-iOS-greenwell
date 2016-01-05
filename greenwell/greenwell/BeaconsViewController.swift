//
//  BeaconsViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 27/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

let AddBeaconRegionNotification = "AddBeaconRegionNotification"

class BeaconsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableTitleLabel: LinedLabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(tableView, selector: "reloadData", name: AddBeaconRegionNotification, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // if sender is a cell then the segue destination viewcontroller is used to edit
        if sender?.isKindOfClass(BeaconCell) == true {
            let cell = sender as! BeaconCell
            (segue.destinationViewController as! BeaconDetailViewController).actionType = "edit"
            (segue.destinationViewController as! BeaconDetailViewController).beaconRegionIndex = cell.beaconRegionIndex
        }else {
            (segue.destinationViewController as! BeaconDetailViewController).actionType = "create"
        }
    }
    

    // MARK: - TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let c = AppDelegate.beaconManager.beaconRegions.count
        
        if c > 0 {
            tableTitleLabel.text = "Registered iBeacons"
        } else {
            tableTitleLabel.text = "No registered iBeacons"
        }
        
        return c
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BeaconCell", forIndexPath: indexPath) as! BeaconCell
        let bgv = UIView()
        bgv.backgroundColor = UIColor(red: 192/255, green: 230/255, blue: 255/255, alpha: 1.0)
        cell.selectedBackgroundView = bgv
        
        // Configure the cell...
        cell.beaconRegionIndex = indexPath.row
        cell.descriptionLabel.text = AppDelegate.beaconManager.beaconRegions[indexPath.row].beaconRegion.identifier
        
        return cell

    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            AppDelegate.beaconManager.removeBeaconRegionAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    // MARK: - TableView delegate
    
    


    
    // MARK: - Toolbar item actions
    
    @IBAction func touchCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
