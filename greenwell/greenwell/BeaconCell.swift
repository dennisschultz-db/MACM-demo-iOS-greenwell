//
//  BeaconCell.swift
//  greenwell
//
//  Created by Philippe Toussaint on 27/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class BeaconCell: UITableViewCell {

    var beaconRegionIndex: Int!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
