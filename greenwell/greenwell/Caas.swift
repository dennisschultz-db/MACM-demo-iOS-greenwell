//
//  caas.swift
//  greenwell
//
//  Created by Philippe Toussaint on 12/03/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation
import UIKit
import CAASObjC

var transactionCounter = 0

/**
This class manages the communication with the MACM instance
*/
class Caas {
    
    // properties to access and log in the macm instance
 
    // data structure to store content type Offer
    var offerings:[OfferingItem] = [OfferingItem]()
    
    // data structure for content type Article
    var articles:[ArticleItem] = [ArticleItem]()
    
    /** URL of the MACM instance */
    var macminstance = PropertiesManager.sharedInstance.configuration["MACMInstance"] as! String

    
    /** library of content items */
     var library = PropertiesManager.sharedInstance.configuration["library"] as! String
    
    /** Tenant */
     var tenant = PropertiesManager.sharedInstance.configuration["tenant"] as! String
    
    /** Anonymous username for connection to MACM instance */
     var username = PropertiesManager.sharedInstance.configuration["MACMUsername"] as! String
    
    /** Anonymous password for connection to MACM instance */
    var password = PropertiesManager.sharedInstance.configuration["MACMPassword"] as! String
    
    var offerLibrary: String {
        get {
            return library + "/Content Types/Offer"
        }
    }
    var articleLibrary: String {
        get {
            return library + "/Content Types/Article"
        }
    }
    var iBeaconLibrary: String {
        get {
            return library + "/Content Types/iBeacon Notification"
        }
    }
    
    var caasService:CAASService!
    
    
    init() {
        
    }
    

    /**
    Sign in MACM with actual connection paratemers. The completion block is executed if sign-in is successful.
    */
    func signIn(vc:UIViewController, completionBlock:(()->Void)?){
        
        caasService = CAASService(baseURL: NSURL(string: macminstance)!, contextRoot: "wps", tenant: tenant)

        if !caasService.isUserAlreadySignedIn() {
            let startTime = NSDate()
            
            print("\(Util.timestamp(startTime)): signIn")
            caasService.signIn(username, password: password) { (error, httpStatusCode) -> Void in
                print("signIn took \(Util.elapsedTime(then: startTime))")
                if (httpStatusCode == 204) {
                    NSNotificationCenter.defaultCenter().postNotificationName(ReloadContentFromMacmNotification, object: self)
                    if completionBlock != nil {
                        completionBlock!()
                    }
                } else {
                    self.presentSignInError(vc)
                    
                }
            }
        }
    }
    
    /**
    Attempt to sig-in to a MACM instance with given parameters. 
    If signin is successful the given parameters are used to update actual connection settings, and the given completionblock is executed
    */
    func attemptSignInAndChangeSettings(purl:String, ptenant: String, pusername:String, ppassword:String, plibrary:String,vc:UIViewController, successCompletionBlock:(()->Void)?, failureCompletionBlock:(()->Void)?) {

        caasService = CAASService(baseURL: NSURL(string: purl)!, contextRoot: "wps", tenant: ptenant)
        
        caasService.signIn(pusername, password: ppassword) { (error, httpStatusCode) -> Void in
            if (httpStatusCode == 204) {
                AppDelegate.caas.macminstance = purl
                AppDelegate.caas.tenant = ptenant
                AppDelegate.caas.library = plibrary
                AppDelegate.caas.username = pusername
                AppDelegate.caas.password = ppassword
                
                let propertiesManager = PropertiesManager.sharedInstance
                
                propertiesManager.configuration.setValue(purl, forKey: "MACMInstance")
                propertiesManager.configuration.setValue(ptenant, forKey: "tenant")
                propertiesManager.configuration.setValue(plibrary, forKey: "library")
                propertiesManager.configuration.setValue(pusername, forKey: "MACMUsername")
                propertiesManager.configuration.setValue(ppassword, forKey: "MACMPassword")
                propertiesManager.saveData()
                
 
                NSNotificationCenter.defaultCenter().postNotificationName(ReloadContentFromMacmNotification, object: self)
                successCompletionBlock!()
            } else {
                failureCompletionBlock!()
                self.presentSignInError(vc)
            }
        }
    }
    
    
    /**
    Signout
    */
    func signOut(){
        caasService.signOut()
    }
          
    
    /**
    Load all content, type of Offer, from the MACM instance and store it for future use.
    
    :param: vc The view controller calling this method. It will be used to display Alert if needed.
    :param: sended The table or collection view that will display the content.
    :param: senderCompletionBlock Code executed when content has been loaded, for example to stop activity indicator
    */
    func getOffers(categories:[String]?, keywords:[String]?, updateBlock:([NSIndexPath])->Void){
        
        let startTime = NSDate()
        
        let contentItemsRequest = CAASContentItemsRequest(contentPath: offerLibrary, completionBlock: { (requestResult) -> Void in

            if (requestResult.error != nil) || (requestResult.httpStatusCode != 200) {
                //self.presentNetworkError(vc, error: requestResult.error,httpStatusCode: requestResult.httpStatusCode)
                print("getOffers error: " + requestResult.error.debugDescription)

            } else if let contentItems = requestResult.contentItems {
                let path : String = "\(self.caasService.baseURL)/\(self.caasService.contextRoot)/\(self.caasService.tenant!)/\(self.offerLibrary)"
                transactionCounter++
                print(
                    "getOffers : transaction \(transactionCounter)",
                    "    contentPath  : \(path)",
                    "    categories   : \(categories!)",
                    "    keywords     : \(keywords!)",
                    "    # items rtrnd: \(contentItems.count)",
                    "       start Time   : \(Util.timestamp(startTime))",
                    "       end Time     : \(Util.timestamp(NSDate()))",
                    "       elapsed Time : \(Util.elapsedTime(then: startTime)) sec\n", separator: "\n" )
                
                for contentItem in contentItems {
                    // merge content item dictionaries into one 
                    let elements = contentItem.elements
                    let properties = contentItem.properties
                    var values:[NSObject:AnyObject] = [:]
                    values.update(elements)
                    values.update(properties)
                    
                    let offeringItem:OfferingItem = OfferingItem()
                    offeringItem.id = values["id"] as! String
                    offeringItem.title = values["title"] as! String
                    offeringItem.lastModifiedDate = values["lastmodifieddate"] as! NSDate
                    offeringItem.summary =  values["Summary"] as! String
                    offeringItem.price = (values["Price"] != nil ? String(values["Price"]) : "")
                    offeringItem.body = values["Body"] as! String
                    offeringItem.keywords =  values["keywords"] as! String
                    offeringItem.imageURL = values["Image"] as! NSURL
                    self.offerings.append(offeringItem)
                }
                
                updateBlock([])
                
                // Load images for each content item
                for (idx,offeringItem) in self.offerings.enumerate() {
                    let ip = [NSIndexPath(forItem: idx, inSection: 1)]
                    
                    // load image
                    let imgRequest = CAASAssetRequest(assetURL: offeringItem.imageURL) {
                        (imgResult) -> Void in
                        
                        //print("\(Util.timestamp()): img for \(offeringItem.title) returned")
                        if imgResult.image != nil {
                            //print("Got image for offer \(offeringItem.title)")
                            offeringItem.imageData = imgResult.image
                            updateBlock(ip)
                        }
                    }
                    //print("\(Util.timestamp()): send request for img for \(offeringItem.title)")
                    self.caasService.executeRequest(imgRequest)
                
                } //end for
                
            } else {
                print("No error but also no Offer contentItems")

            }
        
        })
    
        contentItemsRequest.anyCategories = categories
        contentItemsRequest.anyKeywords   = keywords
        contentItemsRequest.properties    = Util.offerProperties
        contentItemsRequest.elements      = Util.offerElements
        print("\(Util.timestamp(startTime)): send getOffers request...")
        self.caasService.executeRequest(contentItemsRequest)
        
    }
    
    
    /**
    Get articles, filtered on given categorie(s) and keyword(s)
    */
    func getArticles( categories:[String]?, keywords:[String]?, updateBlock:([NSIndexPath])->Void){
        
        let startTime = NSDate()
        
        let contentItemsRequest = CAASContentItemsRequest(contentPath: articleLibrary, completionBlock: { (requestResult) -> Void in
            
            if (requestResult.error != nil) || (requestResult.httpStatusCode != 200) {
                //self.presentNetworkError(vc, error: requestResult.error,httpStatusCode: requestResult.httpStatusCode)
                print("getArticles error: " + requestResult.error.debugDescription)
                
            } else if let contentItems = requestResult.contentItems {
                let path : String = "\(self.caasService.baseURL)/\(self.caasService.contextRoot)/\(self.caasService.tenant!)/\(self.offerLibrary)"
                transactionCounter++
                print(
                    "getArticles: transaction \(transactionCounter)",
                    "    contentPath  : \(path)",
                    "    categories   : \(categories!)",
                    "    keywords     : \(keywords!)",
                    "    # items rtrnd: \(contentItems.count)",
                    "       start Time   : \(Util.timestamp(startTime))",
                    "       end Time     : \(Util.timestamp(NSDate()))",
                    "       elapsed Time : \(Util.elapsedTime(then: startTime)) sec\n", separator: "\n" )
                
                for contentItem in contentItems {
                    // merge content item dictionaries into one
                    let elements = contentItem.elements
                    let properties = contentItem.properties
                    var values:[NSObject:AnyObject] = [:]
                    values.update(elements)
                    values.update(properties)
                    
                    let articleItem:ArticleItem = ArticleItem()
                    articleItem.id = values["id"] as! String
                    articleItem.title = values["title"] as! String
                    articleItem.summary =  values["Summary"] as! String
                    articleItem.body = values["Body"] as! String
                    articleItem.keywords =  values["keywords"] as! String
                    articleItem.imageURL = values["Image"] as! NSURL
                    self.articles.append(articleItem)
                }
                
                updateBlock([])
                
                // Load images for each content item
                for (idx,articleItem) in self.articles.enumerate() {
                    let ip = [NSIndexPath(forItem: idx, inSection: 2)]
                    
                    // load image
                    let imgRequest = CAASAssetRequest(assetURL: articleItem.imageURL) {
                        (imgResult) -> Void in
                        
                        //print("\(Util.timestamp()): img for \(articleItem.title) returned")
                        if imgResult.image != nil {
                            //print("Got image for offer \(articleItem.title)")
                            articleItem.imageData = imgResult.image
                            updateBlock(ip)
                        }
                    }
                    //print("\(Util.timestamp()): send request for img for \(articleItem.title)")
                    self.caasService.executeRequest(imgRequest)
                    
                } //end for
                
            }
        })
        
        contentItemsRequest.anyCategories = categories
        contentItemsRequest.anyKeywords   = keywords
        contentItemsRequest.properties    = Util.articleProperties
        contentItemsRequest.elements      = Util.articleElements
        print("\(Util.timestamp(startTime)): send getArticles request...")
        self.caasService.executeRequest(contentItemsRequest)
    }
    
    /**
    Get iBeacon message
    */
    func getBeaconMessage(category:String, keyword:String, senderCompletionBlock:(String,String)->Void){

        let contentItemsRequest = CAASContentItemsRequest(contentPath: iBeaconLibrary, completionBlock: { (requestResult) -> Void in
            if (requestResult.error != nil) || (requestResult.httpStatusCode != 200) {
                //self.presentNetworkError(vc, error: requestResult.error,httpStatusCode: requestResult.httpStatusCode)
                senderCompletionBlock("IBeacon Message","You have entered an iBeacon area, click OK to see our special offers.")
            } else if let contentItems = requestResult.contentItems {
                
                for contentItem in contentItems {
                    // merge content item dictionaries into one
                    let elements = contentItem.elements
                    let properties = contentItem.properties
                    var values:[NSObject:AnyObject] = [:]
                    values.update(elements)
                    values.update(properties)
                    
                    senderCompletionBlock(values["title"] as! String,values["Dialog Message"] as! String)
                    
                }
            }
            
        })
        
        contentItemsRequest.anyCategories = [category]
        contentItemsRequest.anyKeywords   = [keyword]
        contentItemsRequest.properties    = Util.iBeaconProperties
        contentItemsRequest.elements      = Util.iBeaconElements
        self.caasService.executeRequest(contentItemsRequest)
    }
    
    
    
    
    /**
    Displays an alert box on network error
    */
    func presentNetworkError(vc: UIViewController,error:NSError?,httpStatusCode:Int){
        let message:String
        
        if error != nil {
            //println("error \(error)")
            message = error!.localizedDescription
        } else {
            //println("HTTPS Status \(httpStatusCode)")
            message = NSHTTPURLResponse.localizedStringForStatusCode(httpStatusCode)
        }
        
        let alert = UIAlertController(title: NSLocalizedString("NetworkError.Alert.Title",comment:"Network Error"), message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Button"), style: .Default, handler: { (alertAction) -> Void in
            
        }))
        
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
    Displays an alert box on network error
    */
    func presentSignInError(vc: UIViewController){
        let message = NSLocalizedString("SignIn.Alert.WrongCredentials",comment:"...")
        
        let alert = UIAlertController(title: NSLocalizedString("SignIn.Alert.Title",comment:"Sign In Error"), message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Button"), style: .Default, handler: { (alertAction) -> Void in
        }))
        
        vc.presentViewController(alert, animated: true, completion: nil)
    }


}


// extension of Dictionary class to add a new "update" method to update with an other dictionary
extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}