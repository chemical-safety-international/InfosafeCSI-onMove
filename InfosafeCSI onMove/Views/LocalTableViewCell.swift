//
//  LocalTableViewCell.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 21/8/19.
//  Copyright © 2019 Chemical Safety International. All rights reserved.
//

import UIKit

class LocalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var prodname: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var unno: UILabel!
    @IBOutlet weak var prodcode: UILabel!
    @IBOutlet weak var dgclass: UILabel!
    @IBOutlet weak var haz: UILabel!
    @IBOutlet weak var ps: UILabel!
    @IBOutlet weak var issuedate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
