//
//  TOfferingCategoriesViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 26/05/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class OfferingCategoriesViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    
    // current filters for categories and keywords
    var categoriesFilter = [String]()
    var keywordsFilter = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // reset all selected filters
        resetAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    Action to returns to the main view
    */
    @IBAction func touchHomeButton(sender: AnyObject) {
        Util.resetInitialViewController(self.storyboard!)
    }

    /**
    Action on UISwitch to select all keyword filters
    */
    @IBAction func selectAllValueChanged(sender: AnyObject) {
        // set all filters to "checked"
        setFilters((sender as! UISwitch).on)

    }
    
    /**
    Unselect all keyword filters
    */
    func resetAll(){
        setFilters(false)
    }
    
    
    /**
    Sets given value on all keyword filters for all categories
    */
    func setFilters(on:Bool) {
        for (categ, keywords) in Util.offeringFilters {
            
            // workaround: "keywords" is a immutable dictionnary then can not call updateValue(...) later.
            // Assiging to a mutable var will allow calling updateValue(...)
            var d = keywords
            
            for (key,value) in keywords {
                
                d.updateValue(on, forKey: key)
            }
            
            // reassign in global ditionnary
            Util.offeringFilters.updateValue(d, forKey: categ)
        }
        
        // activate or deactivate the "Next" button
        activateNextBarButtonItem()
        
        // refresh the UI with filter values
        collectionView.reloadData()        
    }
    
    /**
    Activate od deactivate the "Next" button according to the selected filters
    */
    func activateNextBarButtonItem(){
        // if there is at least one filter keyword set to "on" then the "Next" button should be enabled
        for kwrds in Util.offeringFilters.values {
            for value in kwrds.values {
                if value==true {
                    nextBarButtonItem.enabled = true
                    return
                }
            }
        }
        nextBarButtonItem.enabled = false
    }
    
    @IBAction func touchUpNextButton(sender: AnyObject) {
        performSegueWithIdentifier("segueToOfferings", sender: sender)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier=="segueToOfferings" {
            // compare old filters to new ones and if changes occured then request a
            // update in the offerings view
            let (cat,kwrds) = Util.getFilters()
            if !(categoriesFilter==cat) || !(keywordsFilter==kwrds)  {
                println("needupdate")
                if segue.destinationViewController.isKindOfClass(TOfferingsViewController) {
                    (segue.destinationViewController as! TOfferingsViewController).needUpdateOfferingsWithFilter(cat,keywords: kwrds)
                } else if segue.destinationViewController.isKindOfClass(POfferingTableViewController) {
                    (segue.destinationViewController as! POfferingTableViewController).needUpdateOfferingsWithFilter(cat,keywords: kwrds)

                }
            }
            categoriesFilter = cat
            keywordsFilter = kwrds
        }
        
        
    
    }

    
    // MARK: Collection View Datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Util.offeringFilters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OfferingCategory", forIndexPath: indexPath) as! OfferingCategoryCell
        
        // configure the cell
        let cat = Util.offeringFilters.keys.array[indexPath.row]
        let keywords: [String: Bool] = Util.offeringFilters[cat]!
        cell.title.text = cat
        
        let img:UIImage!
        switch cat {
        case "Insurance":
            img = UIImage(named: "icon_filter_insurance", inBundle: nil, compatibleWithTraitCollection: nil)
        case "Loan":
            img = UIImage(named: "icon_filter_loan", inBundle: nil, compatibleWithTraitCollection: nil)
        case "Market":
            img = UIImage(named: "icon_filter_markets", inBundle: nil, compatibleWithTraitCollection: nil)
        case "Real Estate Investment":
            img = UIImage(named: "icon_filter_realestate", inBundle: nil, compatibleWithTraitCollection: nil)
        default:
            img = nil
        }
        cell.image.image = img
        
        let key1 = keywords.keys.array[0]
        let val1: Bool = keywords[key1]!
        cell.keyword1.text = key1
        cell.value1.on = val1
        
        let key2 = keywords.keys.array[1]
        let val2: Bool = keywords[key2]!
        cell.keyword2.text = key2
        cell.value2.on = val2
        
        if cat != "Market" {
            let key3 = keywords.keys.array[2]
            let val3: Bool = keywords[key3]!
            cell.keyword3.text = key3
            cell.value3.on = val3
        }else {
            cell.keyword3.hidden = true
            cell.value3.hidden = true
        }
        
        return cell

    }
    
    
}
