//
//  TableViewCell.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 12/5/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var sdsBtn: UIButton!
    @IBOutlet weak var nameType: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
