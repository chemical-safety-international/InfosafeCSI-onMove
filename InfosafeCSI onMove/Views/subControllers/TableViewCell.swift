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
    
    @IBOutlet weak var sdslbl: UILabel!
    @IBOutlet weak var supplbl: UILabel!
    @IBOutlet weak var isslbl: UILabel!
    @IBOutlet weak var unlbl: UILabel!
    
    @IBOutlet weak var SDSNoLbl: UILabel!
    @IBOutlet weak var SupplierLbl: UILabel!
    @IBOutlet weak var IssueDateLbl: UILabel!
    @IBOutlet weak var UNNoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //name.layer.borderWidth = 0.5
//        sdslbl.layer.borderWidth = 0.5
//        supplbl.layer.borderWidth = 0.5
//        isslbl.layer.borderWidth = 0.5
//        unlbl.layer.borderWidth = 0.5
//        SDSNoLbl.layer.borderWidth = 0.5
//        SupplierLbl.layer.borderWidth = 0.5
//        IssueDateLbl.layer.borderWidth = 0.5
//        UNNoLbl.layer.borderWidth = 0.5
        name.font = UIFont.boldSystemFont(ofSize: 21)
        
        sdslbl.font = UIFont.boldSystemFont(ofSize: 14)
        supplbl.font = UIFont.boldSystemFont(ofSize: 14)
        isslbl.font = UIFont.boldSystemFont(ofSize: 14)
        unlbl.font = UIFont.boldSystemFont(ofSize: 14)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
