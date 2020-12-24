//
//  ClientListTableViewCell.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 21/10/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class ClientListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clientNameLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLabelStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabelStyle() {
//        self.backgroundColor = UIColor.systemBlue
//        self.layer.cornerRadius = 15
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.white.cgColor
//        clientNameLabel.layer.cornerRadius = 18
        
//        clientNameLabel.layer.borderWidth = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }

    
}
