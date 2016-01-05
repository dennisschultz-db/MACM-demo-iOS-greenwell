//
//  Cell.swift
//  greenwell
//
//  Created by Philippe Toussaint on 16/03/2015.
//  Copyright (c) 2015 ibm. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    var offeringItemIndex:Int = -1

}
