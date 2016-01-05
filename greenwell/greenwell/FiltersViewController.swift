//
//  FiltersViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 18/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    @IBOutlet weak var selectAllSwitch: UISwitch!
    @IBOutlet weak var loan_transportation: UISwitch!
    @IBOutlet weak var loan_home: UISwitch!
    @IBOutlet weak var loan_student: UISwitch!
    @IBOutlet weak var insurance_transportation: UISwitch!
    @IBOutlet weak var insurance_home: UISwitch!
    @IBOutlet weak var insurance_life: UISwitch!
    @IBOutlet weak var investment_retirement: UISwitch!
    @IBOutlet weak var stockmarket_fund: UISwitch!
    
    var somethingChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshUIFromData()
        setSelectAllState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return Util.shouldAutoRotate()
    }
    


    @IBAction func selectAllSwitch(sender: AnyObject) {
        setFilters((sender as! UISwitch).on)
        somethingChanged = true
    }
    
    /**
    Sets given value on all keyword filters for all categories
    */
    func setFilters(on:Bool) {
        Util.loanFilters["Transportation"] = on
        Util.loanFilters["Home"] = on
        Util.loanFilters["Student"] = on
        Util.insuranceFilters["Transportation"] = on
        Util.insuranceFilters["Home"] = on
        Util.insuranceFilters["Life"] = on
        Util.investmentFilters["Retirement"] = on
        Util.stockmarketFilters["Fund"] = on
        
        // refresh the UI with filter values
        refreshUIFromData()
    }

    func refreshUIFromData() {
        loan_transportation.on = Util.loanFilters["Transportation"]!
        loan_home.on = Util.loanFilters["Home"]!
        loan_student.on = Util.loanFilters["Student"]!
        insurance_transportation.on = Util.insuranceFilters["Transportation"]!
        insurance_home.on = Util.insuranceFilters["Home"]!
        insurance_life.on = Util.insuranceFilters["Life"]!
        investment_retirement.on = Util.investmentFilters["Retirement"]!
        stockmarket_fund.on = Util.stockmarketFilters["Fund"]!
    }
    
    func setSelectAllState(){
        var values = [Bool](Util.loanFilters.values)
        values = values + [Bool](Util.insuranceFilters.values)
        values = values + [Bool](Util.investmentFilters.values)
        values = values + [Bool](Util.stockmarketFilters.values)
        
        for v in values {
            if v == false {
                selectAllSwitch.on = false
                return
            }
        }
        
        selectAllSwitch.on = true
    }

    @IBAction func touchCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {()->Void in
            if self.somethingChanged {
                NSNotificationCenter.defaultCenter().postNotificationName(ReloadContentFromMacmNotification, object: self )
            }
            self.somethingChanged = false
        })
    }
    
    @IBAction func valueChange(sender: AnyObject) {
        let s = sender as! UISwitch
        
        somethingChanged = true
        
        switch s {
        case loan_transportation :
            Util.loanFilters["Transportation"] = s.on
        case loan_home :
            Util.loanFilters["Home"] = s.on
        case loan_student :
            Util.loanFilters["Student"] = s.on
        case insurance_transportation :
            Util.insuranceFilters["Transportation"] = s.on
        case insurance_home :
            Util.insuranceFilters["Home"] = s.on
        case insurance_life :
            Util.insuranceFilters["Life"] = s.on
        case investment_retirement :
            Util.investmentFilters["Retirement"] = s.on
        case stockmarket_fund :
            Util.stockmarketFilters["Fund"] = s.on
        default:
            print("")
        }
        
        setSelectAllState()
    }
}
