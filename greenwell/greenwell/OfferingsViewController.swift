//
//  AdaptiveContentViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 12/03/2015.
//  Copyright (c) 2015 ibm. All rights reserved.
//

import UIKit


class OfferingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    let reuseIdentifier = "Cell"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var caas:Caas = Caas()
    var caasLoaded = false
    
 

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
        
        if caasLoaded==true {
            return
        }
        
        caas = Caas()
        caas.getAllContent("Offerings")
        collectionView.reloadData()
        
        activityIndicator.stopAnimating()
        activityLabel.hidden = true
        collectionView.hidden = false
        caasLoaded = true
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let idx = (sender as! Cell).offeringItemIndex
        println("---> item index \(idx)"  )
        (segue.destinationViewController as! OfferingDetailViewController).item = caas.offerings[idx]
        
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return caas.offerings.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
        
        // Configure the cell
        let offering = caas.offerings[indexPath.row]
        cell.offeringItemIndex = indexPath.row
        cell.label.text = offering.title.uppercaseString
        cell.summary.text = offering.summary
        cell.image.image = UIImage(data: offering.imageData)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    
//    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    
//    // Uncomment this method to specify if the specified item should be selected
//    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    
//    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false
//    }
//    
//    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
//        return false
//    }
//    
//    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
//        
//    }
    
    
    @IBAction func touchHomeButton(sender: AnyObject) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).loadMainOffering()
    }

    
    
    
}
