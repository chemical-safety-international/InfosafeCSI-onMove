//
//  CheckPurchaseMainTableViewCell.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 3/12/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class CheckPurchaseMainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var noOfSupplierLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let edge = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//
//        productNameLabel.drawText(in: UIEdgeInsetsInsetRect(rect, edge))
        
//        productNameLabel.textRect(forBounds: edge, limitedToNumberOfLines: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class LeftPaddingLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)//CGRect.inset(by:)
        super.drawText(in: rect.inset(by: insets))
    }
}

class rightPaddingLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)//CGRect.inset(by:)
        super.drawText(in: rect.inset(by: insets))
    }
}
