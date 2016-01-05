//
//  TableViewCell.swift
//  greenwell
//
//  Created by Philippe Toussaint on 31/03/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class OfferingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    var offeringItemIndex:Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
