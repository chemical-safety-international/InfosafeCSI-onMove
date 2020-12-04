//
//  ClientListTableViewCell.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 21/10/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class ClientListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clientSelectButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setButtonStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setButtonStyle() {
        clientSelectButton.layer.cornerRadius = 18
        
        clientSelectButton.layer.borderWidth = 2
        clientSelectButton.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func clientSelectButtonTapped(_ sender: Any) {
        print("tapped")
        clientSelectButton.setTitleColor(.blue, for: .normal)
        
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "jumpToSearchPage"), object: nil)
    }
    
}
