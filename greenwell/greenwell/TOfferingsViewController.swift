//
//  AdaptiveContentViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 12/03/2015.
//  Copyright (c) 2015 ibm. All rights reserved.
//

import UIKit


class TOfferingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    let reuseIdentifier = "TOfferingCell"
    
    private var needUpdate = false
    var categoriesFilter = [String]()
    var keywordsFilter = [String]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.hidden=true
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if needUpdate {
            // get all offering items, then stop indicator
            AppDelegate.caas.getOffers(self, categories:categoriesFilter, keywords:keywordsFilter, senderCompletionBlock:{ ()->Void in
                self.activityIndicator.stopAnimating()
                self.activityLabel.hidden = true
                self.collectionView.hidden = false
                self.collectionView.reloadData()
                }
            )
            needUpdate = false
        } else {
            self.activityIndicator.stopAnimating()
            self.activityLabel.hidden = true
            self.collectionView.hidden = false
        }
        
    }
    
    func needUpdateOfferingsWithFilter(categories:[String], keywords:[String]){
        categoriesFilter = categories
        keywordsFilter = keywords
        needUpdate = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // before transitioning to the offering item detail view, sets the item index
        let idx = (sender as! TOfferingCell).offeringItemIndex
        (segue.destinationViewController as! TOfferingDetailViewController).item = AppDelegate.caas.offerings[idx]
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return AppDelegate.caas.offerings.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TOfferingCell
        
        // Configure the cell
        let offering = AppDelegate.caas.offerings[indexPath.row]
        cell.offeringItemIndex = indexPath.row
        cell.label.text = offering.title.uppercaseString
        cell.summary.text = offering.summary
        cell.image.image = offering.imageData
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    

    
    
    
}
