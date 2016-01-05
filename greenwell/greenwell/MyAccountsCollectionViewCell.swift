//
//  MyAccountsCollectionViewCell.swift
//  greenwell
//
//  Created by Philippe Toussaint on 19/08/2015.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class MyAccountsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accountSummary: AnimatedLabel!
    
    
    func setAccountSummary(info:(name:String,number:String,total:String) ) {
        
        
        var text = "<h3 style='text-align:center;color:white'>\(info.name.uppercaseString)</h3><h2 style='text-align:center;color:white'>$\(info.total)</h2>"
        
        // for tablet
        if Util.isTablet() {
            text = "<h2 style='text-align:center;color:white'>\(info.name.uppercaseString)</h2><h1 style='text-align:center;color:white'><big>$\(info.total)</big></h1>"
        }
        
        let attrStr = Util.getAttributedString(text)
        accountSummary.attributedText = attrStr
    }
}
