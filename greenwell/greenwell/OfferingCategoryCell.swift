//
//  OfferingCategoryCell.swift
//  greenwell
//
//  Created by Philippe Toussaint on 26/05/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class OfferingCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var keyword1: UILabel!
    @IBOutlet weak var keyword2: UILabel!
    @IBOutlet weak var keyword3: UILabel!
    @IBOutlet weak var value1: UISwitch!
    @IBOutlet weak var value2: UISwitch!
    @IBOutlet weak var value3: UISwitch!
    
    @IBAction func value1Changed(sender: AnyObject) {
        changeKeywordValue(keyword1.text!, value: (sender as! UISwitch).on)
    }
    
    @IBAction func value2Changed(sender: AnyObject) {
        changeKeywordValue(keyword2.text!, value: (sender as! UISwitch).on)

    }
    
    @IBAction func value3Changed(sender: AnyObject) {
        changeKeywordValue(keyword3.text!, value: (sender as! UISwitch).on)
    }
    
    
    /**
    Change the selection value (true/false) of a given keyword for the category corresponding to this cell
    */
    func changeKeywordValue(keyword:String, value:Bool) {
        
        let categ = title.text!
    
        // get the dictionnay [String:Bool] corresponding to the category of this cell
        var d = Util.offeringFilters[categ]
        
        // update the value of the given keyword in the dictionnary
        d?.updateValue(value, forKey: keyword)
        
        // reassign the dictionnay in the global one
        Util.offeringFilters.updateValue(d!, forKey: categ)
        
        // activate the "next" button on the parent view controller, if needed
        let vc = UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController as! UINavigationController
        let ovc = vc.visibleViewController as! OfferingCategoriesViewController
        ovc.activateNextBarButtonItem()
    }
}
