//
//  AppDelegate.swift
//  greenwell
//
//  Created by Philippe Toussaint on 05/03/2015.
//  Copyright (c) 2015 ibm. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var caas:Caas = Caas()
    static var beaconManager: BeaconManager!
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        AppDelegate.beaconManager = BeaconManager()
        //AppDelegate.beaconManager.addBeaconRegion( NSUUID(UUIDString: "F0018B9B-7509-4C31-A905-1A27D39C003C")!, identifier: "beacon 1")
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let configuration = PropertiesManager.sharedInstance.configuration
        let bluemixAppRoute = configuration["bluemixAppRoute"] as! String
        let backendGuid = configuration["backendGuid"] as! String
        // Initialize the Mobile First SDK with IBM Bluemix GUID and route
        IMFClient.sharedInstance().initializeWithBackendRoute(bluemixAppRoute, backendGUID: backendGuid)
        let push = IMFPushClient.sharedInstance()
        print("-> Register device token to Mobile First Push for iOS8 Service \(IMFPush.version())");
        push.registerDeviceToken(deviceToken, completionHandler: { (response, error) -> Void in
            if error != nil {
                print("-> Error during device registration to Mobile First Push for iOS8 Service \(error.description)")
            }
            else {
                print("-> Response after device registration (json): \(response.responseJson.description)")
                // Subscribe to tages to be notified of new publication in categories loan, insurance, investment and stockmarket
//                push.subscribeToTags(["category:MACM Default Application:MACM:loan", "category:MACM Default Application:MACM:insurance", "category:MACM Default Application:MACM:investment", "category:MACM Default Application:MACM:stockmarket"], completionHandler: { (response, error) -> Void in
//                    if error != nil {
//                        print("-> Error during device subscription to tags \(error.description)")
//                    } else {
//                        print("-> Response after device subscription to tags (json): \(response.responseJson.description)")
//                    }
//                })
            }
        })
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("-> Application failed to register for remote notifications: \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("DEBUG");
        let contentAPS = userInfo["aps"] as! [NSObject : AnyObject]
        if let contentAvailable = contentAPS["content-available"] as? Int {
            //silent or mixed push
            if contentAvailable == 1 {
                completionHandler(UIBackgroundFetchResult.NewData)
            } else {
                completionHandler(UIBackgroundFetchResult.NoData)
            }
        } else {
            //Default notification
            completionHandler(UIBackgroundFetchResult.NoData)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        AppDelegate.caas.signOut()
        
    }
    

}

