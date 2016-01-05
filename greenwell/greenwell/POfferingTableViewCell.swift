//
//  POfferingTableViewCell.swift
//  greenwell
//
//  Created by Philippe Toussaint on 31/03/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class POfferingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    // index of the offering item associated to this cell
    var offeringItemIndex:Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
