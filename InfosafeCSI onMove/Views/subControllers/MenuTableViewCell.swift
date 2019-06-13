//
//  MenuTableViewCell.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 12/6/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var btnImg: UIImageView!
    @IBOutlet weak var btnLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
