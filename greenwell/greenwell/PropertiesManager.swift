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
            let fileManager = NSFileManager.defaultManager()
            // Find Documents directory
            let documentsDirectory = try fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            // Append filename
            let path = documentsDirectory.URLByAppendingPathComponent(propertyFilename + ".plist")
            
            if(!fileManager.fileExistsAtPath(path.path!)) {
                if let bundlePath = NSBundle.mainBundle().URLForResource(propertyFilename, withExtension: "plist") {
                    do {
                        try fileManager.copyItemAtURL(bundlePath, toURL: path)
                    } catch {
                        print("Error copying properties file: \(error)")
                    }
                } else {
                    print("Bundle \(propertyFilename).plist not found in Application bundle")
                }
            } else {
                print ("Saved file exists")
                // try fileManager.removeItemAtURL(path)
            }
            
            configuration = NSMutableDictionary(contentsOfURL: path)!
            
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