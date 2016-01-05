//
//  ArticleItem.swift
//  greenwell
//
//  Created by Philippe Toussaint on 17/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation
import UIKit


/**
Description of a content item of type Article
*/
class ArticleItem: NSObject {
    
    var id: String = ""
    var title:String = ""
    var summary:String = ""
    var body:String = ""
    var imageURL: NSURL!
    var imageData:UIImage!
    var keywords:String = ""
}