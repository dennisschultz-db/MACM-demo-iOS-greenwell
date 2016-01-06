//
//  AppDelegate.swift
//  greenwell
//
//  Created by Philippe Toussaint on 05/03/2015.
//  Copyright (c) 2015 ibm. All rights reserved.
//

import UIKit

let logger = IMFLogger(forName: "Greenwell")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var caas:Caas = Caas()
    static var beaconManager: BeaconManager!
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // Register beacons defined in greenwell.plist or through UI
        AppDelegate.beaconManager = BeaconManager()
        
        // Push notifications
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]
        let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()

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
            }
        })
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("-> Application failed to register for remote notifications: \(error)")
    }
    
    // ========================================
    //   didReceiveRemoteNotifiation
    //      Called by the framework whenever a remote notification (Push) is received
    //   Retrieve the message text (from the body) and the filename of the image (from the URL).
    //   If the app was Inactive or in the Background, the user has already tapped the notification
    //   so go directly to load the image.  If the app was in the foreground, display an alert
    //   so the user can choose to open the picture or not.
    // ========================================
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        print("Push notification received");
        let contentAPS = userInfo["aps"] as! [NSObject : AnyObject]
        if let alert = contentAPS["alert"] as? NSDictionary {
            if let message = alert["body"] as? NSString {
                if (application.applicationState == UIApplicationState.Inactive ||
                    application.applicationState == UIApplicationState.Background) {
                    print("App was in the background when push arrived")
                        
                } else {
                    let noticeAlert = DBAlertController(
                        title: "Greenwell",
                        message: message as String,
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    noticeAlert.addAction(UIAlertAction(
                        title: "OK",
                        style: .Default,
                        handler: { (action: UIAlertAction!) in
                            print("User wants to see content.")
                            NSNotificationCenter.defaultCenter().postNotificationName(ReloadContentFromMacmNotification, object: self )
                            
                    }))
                    
                    // Display the dialog
                    noticeAlert.show()
                }
                
            }
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

