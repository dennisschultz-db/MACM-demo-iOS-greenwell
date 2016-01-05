//
//  POfferingTableViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 31/03/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class POfferingTableViewController: UITableViewController {
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // properties to control the update of the view
    private var needUpdate = false
    var categoriesFilter = [String]()
    var keywordsFilter = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func needUpdateOfferingsWithFilter(categories:[String], keywords:[String]){
        categoriesFilter = categories
        keywordsFilter = keywords
        needUpdate = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if needUpdate {
            AppDelegate.caas.offerings.removeAll(keepCapacity: false)
            self.tableView.reloadData()
             self.activityView.hidden = false
            // get all offering items, then stop indicator
            AppDelegate.caas.getOffers(self, categories: categoriesFilter, keywords:keywordsFilter, senderCompletionBlock:{ ()->Void in
                self.activityIndicator.stopAnimating()
                self.activityView.hidden = true
                self.tableView.reloadData()
                }
            )
            needUpdate = false
        }else {
            self.activityIndicator.stopAnimating()
            self.activityView.hidden = true
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return Util.shouldAutoRotate()
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let idx = (sender as! POfferingTableViewCell).offeringItemIndex
        
        (segue.destinationViewController as! POfferingDetailsViewController).item = AppDelegate.caas.offerings[idx]
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return AppDelegate.caas.offerings.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("POfferingTableViewCell", forIndexPath: indexPath) as! POfferingTableViewCell

        // Configure the cell
        let offering = AppDelegate.caas.offerings[indexPath.row]
        cell.offeringItemIndex = indexPath.row
        cell.label.text = offering.title.uppercaseString
        cell.summary.text = offering.summary
        cell.img.image = offering.imageData

        return cell
    }
    

 
}
