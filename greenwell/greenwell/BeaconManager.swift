//
//  BeaconManager.swift
//  greenwell
//
//  Created by Philippe Toussaint on 26/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconManager:NSObject, CLLocationManagerDelegate  {

    var locationManager: CLLocationManager
    
    // array of tuple (beacon,keywords)
    var beaconRegions = [ (beaconRegion:CLBeaconRegion,category:String,keywords:[String]) ]()
    
    
    override init() {
        // init properties
        locationManager = CLLocationManager()
        
        super.init()

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        // Read array of beacon information from project configuration file
        let propertiesManager = PropertiesManager.sharedInstance
        let beaconInfo = propertiesManager.configuration["beaconInfo"] as! [AnyObject]
        
        for beacon in beaconInfo {
            print("beaconInfo " + beacon.debugDescription!)
            let uuid = beacon["uuid"] as! String
            let region = beacon["region"] as! String
            let categoryFilter = beacon["categoryFilter"] as! String
            let keywordFilter = beacon["keywordFilter"] as! [String]
            addBeaconRegionWithUUID(
                NSUUID(UUIDString: uuid)!,
                identifier: region,
                category: categoryFilter,
                keywords: keywordFilter)
            
        }

    }
    
    func addBeaconRegionWithUUID(proximityUUID: NSUUID, identifier:String, category:String, keywords:[String]) {
        let beaconRegion =  CLBeaconRegion(proximityUUID: proximityUUID, identifier: identifier)
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.requestStateForRegion(beaconRegion)
        
        beaconRegions.append( (beaconRegion,category,keywords))
    }
    
    func removeBeaconRegionAtIndex(index:Int) {
        let tuple = beaconRegions[index]
        locationManager.stopMonitoringForRegion(tuple.beaconRegion)
        beaconRegions.removeAtIndex(index)
    }
    
    

    // MARK: - Location Manager delegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        // find the beacon according to its identifer and also gets keywords corresponding to the region
        for (r,c,k) in beaconRegions {
            if r.identifier == region.identifier {
                
                // notify that user entered an iBeacon region. 
                // we use the category, and the first keyword, associated to the beacon to get notification message from MACM
                NSNotificationCenter.defaultCenter().postNotificationName(EnteredIBeaconRegionNotification, object: self, userInfo: ["category":AppDelegate.caas.library + "/macm/" + c, "keywords":k])
            }
        }
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        // removes category and keyword to set
        Util.iBeaconCategories.removeAll(keepCapacity: false)
        Util.iBeaconKeywords.removeAll(keepCapacity: false)
        //NSNotificationCenter.defaultCenter().postNotificationName(ReloadContentFromMacmNotification, object: self)
    }


}
