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
        
        // add a default iBeacon to monitor GreenWheel Regions
        addBeaconRegionWithUUID( NSUUID(UUIDString: "F0018B9B-7509-4C31-A905-1A27D39C003C")!, identifier: "GreenWheel iBeacon Region",category:Util.categoryNames["Greenwheel"]!,keywords: ["welcome","modelz","modelj"])

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
                NSNotificationCenter.defaultCenter().postNotificationName(EnteredIBeaconRegionNotification, object: self, userInfo: ["category":c, "keywords":k])
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
