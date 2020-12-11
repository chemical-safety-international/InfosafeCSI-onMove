//
//  CheckBuyTableViewCell.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 17/11/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class CheckPurchaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var supplierLabel: UILabel!
    @IBOutlet weak var issueDateLabel: UILabel!
    @IBOutlet weak var noOfSDSLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        supplierLabel.font = UIFont.boldSystemFont(ofSize: 15)
        issueDateLabel.font = UIFont.boldSystemFont(ofSize: 13)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        bounds = bounds.inset(by: padding)
//    }

}
