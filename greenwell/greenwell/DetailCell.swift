//
//  DetailCell.swift
//  greenwell
//
//  Created by Philippe Toussaint on 21/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
