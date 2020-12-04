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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
