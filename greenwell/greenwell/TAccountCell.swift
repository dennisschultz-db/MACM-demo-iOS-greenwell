//
//  TAccountCell.swift
//  greenwell
//
//  Created by Philippe Toussaint on 10/04/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class TAccountCell: UITableViewCell {
    
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
