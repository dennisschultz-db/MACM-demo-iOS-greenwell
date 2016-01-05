//
//  PropertiesManager.swift
//  doorbell
//
//  Created by Dennis Schultz on 11/10/15.
//  Copyright © 2015 Dennis Schultz. All rights reserved.
//

import Foundation


class PropertiesManager: NSObject {
    var configuration: NSDictionary = [:]
    
    
    internal class var sharedInstance : PropertiesManager{
        
        struct Singleton {
            static let instance = PropertiesManager()
        }
        return Singleton.instance
    }
    
    override init () {
        super.init()

        let configurationPath = NSBundle.mainBundle().pathForResource("greenwell", ofType: "plist")
        configuration = NSDictionary(contentsOfFile: configurationPath!)!
        
        
    }
}