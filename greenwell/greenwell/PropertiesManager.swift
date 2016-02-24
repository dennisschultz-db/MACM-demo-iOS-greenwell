//
//  PropertiesManager.swift
//  doorbell
//
//  Created by Dennis Schultz on 11/10/15.
//  Copyright © 2015 Dennis Schultz. All rights reserved.
//

import Foundation

class PropertiesManager: NSObject {
    
    let propertyFilename = "greenwell"
    var configuration: NSMutableDictionary = [:]
    
    
    internal class var sharedInstance : PropertiesManager{
        
        struct Singleton {
            static let instance = PropertiesManager()
        }
        return Singleton.instance
    }
    
    override init () {
        super.init()
        
        loadData()
    }
    
    
    func loadData() {
        
        do {
            
            // Read the configuration file in the bundle
            guard let bundlePath = NSBundle.mainBundle().URLForResource(propertyFilename, withExtension: "plist") else {
                print("Bundle \(propertyFilename).plist not found in Application bundle")
                return
            }
            guard let bundleConfiguration = NSMutableDictionary(contentsOfURL: bundlePath) else {
                print("Bundle \(propertyFilename).plist not a valid dictionary")
                return
            }

            let fileManager = NSFileManager.defaultManager()
            // Find Documents directory
            let documentsDirectory = try fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            // Append filename
            let path = documentsDirectory.URLByAppendingPathComponent(propertyFilename + ".plist")

            
            // Look for a saved configuration file
            if fileManager.fileExistsAtPath(path.path!) {
                print ("A saved version of the configuration exists")
                let savedConfiguration = NSMutableDictionary(contentsOfURL: path)!
                
                if savedConfiguration["version"] as? Int == bundleConfiguration["version"] as? Int {
                    print("Saved version is the correct version")
                    configuration = savedConfiguration
                } else {
                    print("Saved version is an incorrect version")
                    configuration = bundleConfiguration
                    // Delete and replace the saved configuration.
                    do {
                        try fileManager.removeItemAtURL(path)
                        try fileManager.copyItemAtURL(bundlePath, toURL: path)
                    } catch {
                        print("Error replacing properties file: \(error)")
                    }
                }
            } else {
                // No saved configuration file
                print("No saved configuration file")
                configuration = bundleConfiguration
                do {
                    try fileManager.copyItemAtURL(bundlePath, toURL: path)
                } catch {
                    print("Error replacing properties file: \(error)")
                }
            }
            
        } catch {
            print ("Some misc error retrieving properties file \(error)")
        }
        
    }
    
    
    func saveData() {
        do {
            let documentsDirectory = try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let path = documentsDirectory.URLByAppendingPathComponent(propertyFilename + ".plist")
            
            configuration.writeToURL(path, atomically: true)
            
        } catch {
            print("Error writing properties file: \(error)")
        }
        
        
    }
    
}