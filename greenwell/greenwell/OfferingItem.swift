//
//  OfferingItem.swift
//  greenwell
//
//  Created by Philippe Toussaint on 16/03/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation
import UIKit

/**
Description of a content item of type Offer
*/
class OfferingItem: NSObject {
    
    var id: String = ""
    var title:String = ""
    var summary:String = ""
    var imageURL: NSURL!
    var price: String = ""
    var lastModifiedDate: NSDate!
    var imageData:UIImage!
    var body:String = ""
    var keywords:String = ""
}