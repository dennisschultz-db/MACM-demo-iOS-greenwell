//
//  Util.swift
//  greenwell
//
//  Created by Philippe Toussaint on 02/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation
import UIKit


var userName = ""
var actNum = ""

class Util {
    
    // list of accounts, sorted in sections
    static var accountsDictionary = [
        "Bank Accounts":[
            ["name":"Infinity","number":"457B-DFR77","total":"0"],
            ["name":"Value Plus","number":"8784DF-DDD","total":"0"],
            ["name":"Everyday Savings","number":"3342233","total":"0"]
        ],
        "Credits":[
            ["name":"First Class Travel","number":"CR-8744FCT","total":"0"],
            ["name":"Line of Credit","number":"CR-7844LOC","total":"0"]
        ],
        "Retirements":[
            ["name":"My 401(k)","number":"RE-DTZ7411","total":"0"]
        ]
    ]
    
    // account details
    static var ac1 = [
        ["Payroll deposit", "Deposit", "1500.00","11/30/2012"],
        ["Norstrom Rack", "Retail purchase","-42.98","11/30/2012"],
        ["Monthly fee", "Service charge","-4.00",  "11/30/2012"],
        ["WL Property", "Monthly Rent", "-950.00", "11/30/2012"]
    ]
    static var ac1_1 = [
        ["Norstrom Rack", "Retail purchase","-50.51","11/30/2012"],
        ["WL Property", "Monthly Rent", "-950.00", "11/30/2012"],
        ["Monthly fee", "Service charge","-14.00",  "11/30/2012"],
        ["Payroll deposit", "Deposit", "1870.00","11/30/2012"],
    ]
    
    static var ac2_1 = [
        ["Avis","Car rental","-145.00","11/27/2012"],
        ["Bruno's fine foods","Retail purchase","-42.98","11/27/2012"],
        ["PTB  withdrawl n°12345678","ABM withdrawl","-100.00","11/27/2012"],
    ]
    static var ac2 = [
        ["PTB  withdrawl n°12345678","ABM withdrawl","-95.00","11/27/2012"],
        ["Bruno's fine foods","Retail purchase","-32.0","11/27/2012"],
        ["Avis","Car rental","-45.00","11/27/2012"]
    ]
    
    static var ac3 = [
        ["PTB  withdrawl n°3479382","ABM withdrawl","-50.00","11/18/2012"]
    ]
    
    static var accountDetails = ac1+ac2+ac3
    static var accountDetails2 = ac1_1+ac2_1+ac3
    
    static var loanFilters:[String:Bool] = ["general":false,"greenwheel":false,"Transportation":false,"Home":false,"Small Business":false]
    //static var loanFilters:[String:Bool] = ["Transportation":false,"Home":false,"Student":false]
    static var insuranceFilters:[String:Bool] = ["Transportation":false,"Home":false,"Life":false]
    static var investmentFilters:[String:Bool] = ["Retirement":false]
    static var stockmarketFilters:[String:Bool] = ["Fund":false]
    
    static var categoryNames: [String:String] {
        get {
            return [
                    "Insurance"  : AppDelegate.caas.library + "/macm/insurance",
                    "Loan"       : AppDelegate.caas.library + "/macm/loan",
                    "Investment" : AppDelegate.caas.library + "/macm/investment",
                    "Stockmarket": AppDelegate.caas.library + "/macm/stockmarket",
                    "Greenwheel" : AppDelegate.caas.library + "/macm/greenwheel",
                    "General"    : AppDelegate.caas.library + "/macm/general"
                ]
        }
    }
    
    static var keywordNames: [String:String] = [
        "Life": "life",
        "Transportation":"transportation",
        "Home":"home",
        "smallbusiness":"smallbusiness",
        //"Student":"student",
        "Retirement":"retirement",
        "invest2":"invest2",
        "invest3":"invest3",
        "Fund":"fund",
        "Trusts":"trusts",
        "Welcome":"welcome"
    ]
    
    // categories and  keywords coming from entered iBeacon region
    static var iBeaconCategories = [String]()
    static var iBeaconKeywords = [String]()

    // element and property key lists for various content types
    static let offerProperties   = ["id", "title", "keywords", "categories", "lastmodifieddate"]
    static let offerElements     = ["Summary", "Price", "Body", "Image"]
    static let articleProperties = ["id", "title", "keywords", "categories", "lastmodifieddate"]
    static let articleElements   = ["Body", "Image", "Summary"]
    static let iBeaconProperties = ["id", "title", "keywords", "categories", "lastmodifieddate"]
    static let iBeaconElements   = ["Dialog Message"]

    
    /**
    Indicates if the device is a tablet
    */
    static func isTablet()->Bool {
        let device:UIDevice = UIDevice.currentDevice()
        
        if device.model.lowercaseString.rangeOfString("iphone") != nil {
            return false
        }
        return true
    }
    
    /**
    Indicates if autorotation is allowed. Only allowed for tablet
    */
    static func shouldAutoRotate()->Bool {
        return isTablet()
    }
    
    
    /**
    Loads and displays a RTF file
    */
    static func loadRTFFile(fileToLoad:String, textField:UITextView){
        if let fileURL = NSBundle.mainBundle().URLForResource(fileToLoad, withExtension: "rtf") {
            do {
                let attrStr = try NSAttributedString(URL: fileURL, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
                textField.attributedText = attrStr
            } catch {
                textField.attributedText =  NSAttributedString(string: "")
            }

        }
    }
    
    /**
    Reset UI to initial view controller (login)
    */
    static func resetInitialViewController() {
        let w = (UIApplication.sharedApplication().delegate as! AppDelegate).window
        w!.rootViewController = w!.rootViewController!.storyboard?.instantiateInitialViewController()
        w!.makeKeyAndVisible()
    }
    
    /**
    Gets account details based on a row :
    accounts are stored per row per section: ie Bank Account/Account #1, BankAccount/account #2, etc...)
    To get fake data for a specific account identified by its row we return some details according to row modulo 2
    */
    static func getAccountDetailsForRow(row:Int)-> [[String]]{
        if (row % 2) == 0 {
            return self.accountDetails
        }
        else {
            return self.accountDetails2
        }
    }
    
    /**
    Get the total for an account
    */
    static func getAccountTotalForRow(row:Int) -> Float {
        var total: Float = 0.0
        let ac = getAccountDetailsForRow(row)
        
        for details in ac {
            total = total + (details[2] as NSString).floatValue
        }
        
        return total
    }
    
    /**
    */
    static func getAttributedString(bodystr:String) -> NSAttributedString {
        let encodedData = bodystr.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        var attrStr:NSAttributedString!
        do {
            attrStr = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
        } catch {
            attrStr = nil
        }
        return attrStr!
    }
    

    
    /**
    Gets arrays of string representing the categories and keywords used to filter 
    content of type Offer and Article.
    Return tuple contains offerCategories, offer keywords, article categories, article keywords
    */
    static func getFilters()-> ([String],[String],[String], [String]) {
        
        // uses Set to have unique values of categories, and keywords
        var offerCategoriesSet = Set<String>()
        var offerKeywordsSet = Set<String>()
        var articleCategoriesSet = Set<String>()
        var articleKeywordsSet = Set<String>()
        
        if iBeaconCategories.count>0 {
            offerCategoriesSet = Set(iBeaconCategories)
            articleCategoriesSet = Set(iBeaconCategories)
        }
        
        if iBeaconKeywords.count>0 {
            offerKeywordsSet = Set(iBeaconKeywords)
            articleKeywordsSet = Set(iBeaconKeywords)
        }
        
        if loanFilters["Transportation"] == true {
            offerCategoriesSet.insert( Util.categoryNames["Loan"]! )
            offerKeywordsSet.insert( Util.keywordNames["Transportation"]! )
            articleCategoriesSet.insert( Util.categoryNames["Loan"]! )
            articleKeywordsSet.insert( Util.keywordNames["Transportation"]! )
        }
        if loanFilters["Home"] == true {
            offerCategoriesSet.insert( Util.categoryNames["Loan"]! )
            offerKeywordsSet.insert( Util.keywordNames["Home"]! )
            articleCategoriesSet.insert( Util.categoryNames["Loan"]! )
            articleKeywordsSet.insert( Util.keywordNames["Home"]! )
        }
       // if loanFilters["Student"] == true {
         //   offerCategoriesSet.insert( Util.categoryNames["Loan"]! )
           // offerKeywordsSet.insert( Util.keywordNames["Student"]! )
            //articleCategoriesSet.insert( Util.categoryNames["Loan"]! )
            //articleKeywordsSet.insert( Util.keywordNames["Student"]! )
       
         if loanFilters["Small Business"] == true {
            offerCategoriesSet.insert( Util.categoryNames["Loan"]! )
            offerKeywordsSet.insert( Util.keywordNames["smallbusiness"]! )
            articleCategoriesSet.insert( Util.categoryNames["Loan"]! )
            articleKeywordsSet.insert( Util.keywordNames["smallbusiness"]! )
    
        }
        
        if userName == "Robert"{
            offerCategoriesSet.insert( Util.categoryNames["Greenwheel"]! )
            offerKeywordsSet.insert( Util.keywordNames["Welcome"]! )
            articleCategoriesSet.insert( Util.categoryNames["Greenwheel"]! )
            articleKeywordsSet.insert( Util.keywordNames["Welcome"]! )
        
        }
        
        if userName == ""{
            offerCategoriesSet.insert( Util.categoryNames["General"]! )
           // offerKeywordsSet.insert( Util.keywordNames["Welcome"]! )
            articleCategoriesSet.insert( Util.categoryNames["General"]! )
            //articleKeywordsSet.insert( Util.keywordNames["Welcome"]! )
            
            
            
        }
        
    

        if insuranceFilters["Transportation"] == true {
            offerCategoriesSet.insert( Util.categoryNames["Insurance"]! )
            offerKeywordsSet.insert( Util.keywordNames["Transportation"]! )
            articleCategoriesSet.insert( Util.categoryNames["Insurance"]! )
            articleKeywordsSet.insert( Util.keywordNames["Transportation"]! )
        }
        if insuranceFilters["Home"] == true {
            offerCategoriesSet.insert( Util.categoryNames["Insurance"]! )
            offerKeywordsSet.insert( Util.keywordNames["Home"]! )
            articleCategoriesSet.insert( Util.categoryNames["Insurance"]! )
            articleKeywordsSet.insert( Util.keywordNames["Home"]! )
        }
        if insuranceFilters["Life"] == true {
            offerCategoriesSet.insert( Util.categoryNames["Insurance"]! )
            offerKeywordsSet.insert( Util.keywordNames["Life"]! )
            articleCategoriesSet.insert( Util.categoryNames["Insurance"]! )
            articleKeywordsSet.insert( Util.keywordNames["Life"]! )
        }
        
        if investmentFilters["Retirement"] == true {
            offerCategoriesSet.insert( Util.categoryNames["Investment"]! )
            offerKeywordsSet.insert( Util.keywordNames["Retirement"]! )
            articleCategoriesSet.insert( Util.categoryNames["Investment"]! )
            articleKeywordsSet.insert( Util.keywordNames["Retirement"]! )
        }
        if stockmarketFilters["Fund"] == true {
            offerCategoriesSet.insert( Util.categoryNames["Stockmarket"]! )
            offerKeywordsSet.insert( Util.keywordNames["Fund"]! )
            articleCategoriesSet.insert( Util.categoryNames["Stockmarket"]! )
            articleKeywordsSet.insert( Util.keywordNames["Fund"]! )
        }
        
        
        // get sorted arrays from the sets
        var a1 = Array(offerCategoriesSet)
        var a2 = Array(offerKeywordsSet)
        var a3 = Array(articleCategoriesSet)
        var a4 = Array(articleKeywordsSet)

        a1 = a1.sort( { (s1, s2) -> Bool in
            return s1<s2
        })
        a2 = a2.sort( { (s1, s2) -> Bool in
            return s1<s2
        })
        a3 = a3.sort( { (s1, s2) -> Bool in
            return s1<s2
        })
        a4 = a4.sort( { (s1, s2) -> Bool in
            return s1<s2
        })
        
        return (a1, a2, a3,a4)
    }
    

    static func timestamp(now: NSDate = NSDate()) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm:ss.SSS"
        return formatter.stringFromDate(now)
    }
    
    static func elapsedTime(now: NSDate = NSDate(), then: NSDate) -> String {
        return String(now.timeIntervalSinceDate(then))
    }
    
   
}
