//
//  MainViewController.swift
//  greenwell
//
//  Created by Philippe Toussaint on 06/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit
import CoreLocation

let ReloadContentFromMacmNotification = "ReloadContentFromMacmNotification"
let EnteredIBeaconRegionNotification = "EnteredIBeaconRegionNotification"

let operationsSection = 0
let offersSection = 1
let articlesSection = 2

var numCols = 2;


class MainViewController: UIViewController {

    var myAccountsCell:MyAccountsCollectionViewCell!
    
    // a timer to animated text in Accounts cell: a cyclic display of each bank account.
    var animationTimer:NSTimer!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func touchOperationButton(sender: AnyObject) {
        let alert = UIAlertController(title: "Information", message: "This feature is not yet available", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Button"), style: .Default, handler: { (alertAction) -> Void in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// change the header text  (Tyler) 
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Register the nib containing the section header view
        let nib = UINib(nibName: "HeaderCollectionReusableView", bundle: nil)
        collectionView.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")

        collectionView.dataSource = self
        collectionView.delegate = self

        // Fixed at two columns for now
        //computeColumnCount()

        // listen to notification about device orientation changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "computeColumnCount", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        // listen to notification about reloading the content from MACM
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadContentFromMacm", name: ReloadContentFromMacmNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enteredIBeaconRegion:", name: EnteredIBeaconRegionNotification, object: nil)

        AppDelegate.caas.signIn(self,completionBlock: nil)
        animationTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("setAccountSummary"), userInfo: nil, repeats: true)
        
        
        ///set user preferences
        if (userName == "Spencer"){
            Util.loanFilters = ["general":true, "Transportation":true,"Home":true,"Small Business":true]
            Util.insuranceFilters = ["Transportation":true,"Home":false,"Life":false]
            Util.investmentFilters = ["Retirement":false]
            Util.stockmarketFilters = ["Fund":false]
            
            Util.accountsDictionary = [
                "Bank Accounts":[
                    ["name":"Checking","number":"457B-DFR77","total":"0"],
                    ["name":"Premium Savings","number":"8784DF-DDD","total":"0"],
                    ["name":"Everyday Savings","number":"3342233","total":"0"]
                ],
                "Credits":[
                    ["name":"Visa","number":"CR-8744FCT","total":"0"],
                    ["name":"Line of Credit","number":"CR-7844LOC","total":"0"]
                ],
                "Retirements":[
                    ["name":"My 401(k)","number":"RE-DTZ7411","total":"$543,000"],
                    ["name":"College Savings)","number":"RE-DTZ7411","total":"$45,000"]
                ]
            ]
        
        }
        
        else if (userName == "Abby"){
           
            Util.loanFilters = ["Transportation":true,"Home":false,"Small Business":false]
            Util.insuranceFilters = ["Transportation":true,"Home":false,"Life":false]
            Util.investmentFilters = ["Retirement":false]
            Util.stockmarketFilters = ["Fund":true]
            
        }
        
        else if (userName == "Robert"){
            Util.loanFilters = ["greenwheel":true, "Transportation":true,"Home":false,"Small Business":false]
            Util.insuranceFilters = ["Transportation":false,"Home":false,"Life":false]
            Util.investmentFilters = ["Retirement":false]
            Util.stockmarketFilters = ["Fund":false]
            
        }
        
        else{
            Util.loanFilters = ["general":true,"greenwheel":true, "Transportation":false,"Home":false,"Small Business":false]
            Util.insuranceFilters = ["Transportation":false,"Home":false,"Life":false]
            Util.investmentFilters = ["Retirement":false]
            Util.stockmarketFilters = ["Fund":false]

        }
        
        // end user preference setup
        
        NSNotificationCenter.defaultCenter().postNotificationName(ReloadContentFromMacmNotification, object: self )
        
        // Assign this view controller as the delegate for the layout
        if let layout = collectionView?.collectionViewLayout as? MainLayout {
            layout.delegate = self
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Fixed at two columns for now
        //computeColumnCount()
    }
 
    // a kind of logout feature to go back to the login screen
    @IBAction func touchExitButton(sender: AnyObject) {
        Util.resetInitialViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func reloadContentFromMacm() {
        
        let (offerCategories,offerKeywords,articleCategories,articleKeywords) = Util.getFilters()
        
        AppDelegate.caas.offerings.removeAll(keepCapacity: false)
        AppDelegate.caas.articles.removeAll(keepCapacity: false)
        self.collectionView.reloadData()
        
        AppDelegate.caas.caasService.cancelAllPendingRequests()
        
        if offerCategories.count>0 || offerKeywords.count>0 {
            activityIndicator.startAnimating()
            
            AppDelegate.caas.getOffers(offerCategories, keywords:offerKeywords, updateBlock:{ (paths)->Void in
                self.activityIndicator.stopAnimating()
                self.reloadCollectionViewData(paths)
                }
            )
        }

        if articleCategories.count>0 || articleKeywords.count>0 {
            activityIndicator.startAnimating()
            
            AppDelegate.caas.getArticles(articleCategories, keywords: articleKeywords, updateBlock:{ (paths)->Void in
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadSections(NSIndexSet(index: articlesSection))
                }
            )
        }
    }
    
    // Reloads the items at the given indexPaths - or the entire page if indexPaths is nil
    func reloadCollectionViewData(indexPaths:[NSIndexPath]) {
        if indexPaths.count == 0 {
            collectionView.reloadData()
        } else {
            collectionView.reloadItemsAtIndexPaths(indexPaths)
        }
    }
    
    
    func computeColumnCount() {
        if Util.isTablet() {
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)){
                numCols = 4
                collectionView.reloadData()
            }
            else if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)){
                numCols = 3
                collectionView.reloadData()
            }
        } else {
            numCols = 2
        }
        
    }

    // Cycles through all accounts in animated box
    var accountIndex = 0
    func setAccountSummary() {
        let accounts:[[String:String]] = Util.accountsDictionary["Bank Accounts"]!
        let account:[String:String] = accounts[accountIndex]
        
        let name = account["name"]!
        let number = account["number"]!
        let total = "\(Util.getAccountTotalForRow(accountIndex))" //account["total"]!
        myAccountsCell.setAccountSummary((name,number,total))
        
        accountIndex = (accountIndex + 1) % (accounts.count)

    }
    
    func enteredIBeaconRegion(notification:NSNotification) {
        var dico:Dictionary = notification.userInfo!
        let category = dico["category"] as! String
        let keywords = dico["keywords"] as! [String]

        // Especially in demo situations, the device may enter a new beacon region before exiting another.
        // Remove any category and keyword values that possibly already exist
        Util.iBeaconCategories.removeAll(keepCapacity: false)
        Util.iBeaconKeywords.removeAll(keepCapacity: false)

        // get notification message associted to the ibeacon in MACM
        // we use the category, and the first keyword, associated to the beacon to get notification message from MACM: those
        // info can be found in the NSNotification userInfo
        AppDelegate.caas.getBeaconMessage(category, keyword: keywords[0],senderCompletionBlock:{(title,message)->Void in
            
            // creates and display an alert box. 
            // We user clics "OK" we reload the MACM content: previously when the iBeacon has been detected keywords to searched associated
            // articles have been set
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Button"), style: .Default, handler: { (alertAction) -> Void in
                Util.iBeaconCategories = [category]
                Util.iBeaconKeywords = keywords
                NSNotificationCenter.defaultCenter().postNotificationName(ReloadContentFromMacmNotification, object: self)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        })

    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier=="segueToOfferDetails" {
            let indexPath = (sender as! OfferCollectionViewCell).indexPath
            (segue.destinationViewController as! OfferDetailsViewController).item = AppDelegate.caas.offerings[indexPath.row]
        }
        
        if segue.identifier=="segueToArticleDetails" {
            let indexPath = (sender as! OfferCollectionViewCell).indexPath
            (segue.destinationViewController as! ArticleDetailsViewController).item = AppDelegate.caas.articles[indexPath.row]
        }
    }
    



}

// MARK: - UIViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var n = 0
        
        switch section {
        case operationsSection:
            n = 2
        case offersSection:
            n = AppDelegate.caas.offerings.count
        case articlesSection:
            n = AppDelegate.caas.articles.count
        default:
            n = 0
        }
        
        return n
    }
}


// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reusableID:String
        let cell:UICollectionViewCell
        
        switch indexPath.section {
        case operationsSection :
            switch indexPath.row {
            case 0 :
                myAccountsCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyAccountCell", forIndexPath: indexPath) as! MyAccountsCollectionViewCell
                setAccountSummary()
                cell = myAccountsCell
            case 1 :
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("OperationsCell", forIndexPath: indexPath) as UICollectionViewCell
            default :
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("AdCell", forIndexPath: indexPath) as UICollectionViewCell
            }
            
        case offersSection :
            reusableID = "OfferCell"
            let c = collectionView.dequeueReusableCellWithReuseIdentifier(reusableID, forIndexPath: indexPath) as! OfferCollectionViewCell
            
            // Configure the cell
            let offering = AppDelegate.caas.offerings[indexPath.row]
            c.indexPath = indexPath
            c.title.text = offering.title.uppercaseString
            let char:Character = "\n"
            c.title.text?.append(char)
            c.title.text?.appendContentsOf(offering.summary)
            c.image.image = offering.imageData
            cell = c
            
        case articlesSection:
            //articles
            reusableID = "ArticleCell"
            let c = collectionView.dequeueReusableCellWithReuseIdentifier(reusableID, forIndexPath: indexPath) as! OfferCollectionViewCell
            
            // Configure the cell
            let article = AppDelegate.caas.articles[indexPath.row]
            c.indexPath = indexPath
            c.title.text = article.title.uppercaseString
            let char:Character = "\n"
            c.title.text?.append(char)
            c.title.text?.appendContentsOf(article.summary)
            c.image.image = article.imageData
            cell = c
            
        default:
            reusableID = "OfferCell"
            let c = collectionView.dequeueReusableCellWithReuseIdentifier(reusableID, forIndexPath: indexPath) as! OfferCollectionViewCell
            cell = c
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var nCol = numCols // default
        let iiS = Int( (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing )
        let siR = Int( (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.right )
        let siL = Int( (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left )
        //let siT = Int( (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.top )
        
        // in case of banking operation section
        if indexPath.section == operationsSection {
            nCol = 2 //default
        }
        
        var w = Int(collectionView.bounds.width) - siR - siL - Int((nCol-1)*iiS)
        w = w / Int(nCol)
        
        var h = w
        
        // customize cell's height for "bank operations" section
//        if indexPath.section == operationsSection {
//            
//            // ipad
//            if Util.isTablet() {
//                h = w/2
//            }
//        }
        
        //print("----> \(collectionView.hidden)   \( collectionView.numberOfItemsInSection(0) )  \( collectionView.numberOfItemsInSection(1) )  \( collectionView.numberOfItemsInSection(2) )")
        return CGSize(width: w,height: h)
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusableView:UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HeaderCollectionReusableView", forIndexPath: indexPath) as! HeaderCollectionReusableView
            
            switch indexPath.section {
            case operationsSection:
                header.title.text = "Welcome \(userName) - Account: \(actNum)"
            case offersSection:
                header.title.text = "Greenwell Bank Services"
                header.title.hidden = AppDelegate.caas.offerings.count==0
            case articlesSection:
                header.title.text = "Helpful Articles and Events"
                header.title.hidden = AppDelegate.caas.articles.count==0
            default:
                header.title.text = "?????"
            }
            
            reusableView = header
        }
        
        return reusableView
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == operationsSection {
            if indexPath.row==0 {
                if   Util.isTablet() {
                    self.performSegueWithIdentifier("segueToAccounts2", sender: self)
                } else {
                    self.performSegueWithIdentifier("segueToAccounts1", sender: self)
                }
            }else {
            }
        }
    }

}


// MARK: - MainLayoutDelegate

extension MainViewController: MainLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat {
        
        // All elements have aspect ration 1:1, except the operations buttons
        var h = withWidth
        
        // customize cell's height for "bank operations" section
//        if indexPath.section == operationsSection {
//            
//            // ipad
//            if Util.isTablet() {
//                h = withWidth / 4
//            }
//        }
        
        return CGFloat(h)
    }

}
