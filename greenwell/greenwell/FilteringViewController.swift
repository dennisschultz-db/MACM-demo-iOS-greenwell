//
//  TOfferingCategoriesViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 26/05/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class FilteringViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    
    // current filters for categories and keywords
    var categoriesFilter = [String]()
    var keywordsFilter = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // reset all selected filters
        //resetAll()
        
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
               
        // refresh the UI with filter values
        collectionView.reloadData()        
    }
    

  
    @IBAction func touchUpNextButton(sender: AnyObject) {
        // compare old filters to new ones and if changes occured then request a
        // update in the offerings view
        let (cat,kwrds) = Util.getFilters()
        //if !(categoriesFilter==cat) || !(keywordsFilter==kwrds)  {
            var dico = Dictionary<String, [String]>()
            dico["categories"] = cat
            dico["keywords"] = kwrds
            NSNotificationCenter.defaultCenter().postNotificationName(ContentFiltersDidChangeNotification, object: self,userInfo: dico )
        //}
        categoriesFilter = cat
        keywordsFilter = kwrds
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: Collection View Datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Util.offeringFilters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OfferingCategory", forIndexPath: indexPath) as! FilteringCell
        
        // configure the cell
        let cat = Util.offeringFilters.keys.array[indexPath.row]
        let keywords: [String: Bool] = Util.offeringFilters[cat]!
        cell.title.text = cat
        
        let key1 = keywords.keys.array[0]
        let val1: Bool = keywords[key1]!
        cell.keyword1.text = key1
        cell.value1.on = val1
        
        if (cat != "Stockmarket") && (cat != "Investment") {
            let key2 = keywords.keys.array[1]
            let val2: Bool = keywords[key2]!
            cell.keyword2.text = key2
            cell.value2.on = val2
        }else {
            cell.keyword2.hidden = true
            cell.value2.hidden = true
        }
        
        if (cat != "Stockmarket") && (cat != "Investment") {
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
