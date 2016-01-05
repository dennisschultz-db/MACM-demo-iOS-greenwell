//
//  AccountDetailCell.swift
//  greenwell
//
//  Created by Philippe Toussaint on 08/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class AccountDetailCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
