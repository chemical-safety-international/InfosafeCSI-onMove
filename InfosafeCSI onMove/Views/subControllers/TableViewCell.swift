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
    @IBOutlet weak var sdsBtn: UIButton!
    @IBOutlet weak var nameType: UIImageView!
    
    @IBOutlet weak var supplbl: UILabel!
    @IBOutlet weak var isslbl: UILabel!
    @IBOutlet weak var unlbl: UILabel!
    @IBOutlet weak var dgcLbl: UILabel!
    @IBOutlet weak var psLbl: UILabel!
    @IBOutlet weak var hazLbl: UILabel!
    
    
    @IBOutlet weak var prodCodeLbl: UILabel!
    @IBOutlet weak var SupplierLbl: UILabel!
    @IBOutlet weak var IssueDateLbl: UILabel!
    @IBOutlet weak var UNNoLbl: UILabel!
    
    @IBOutlet weak var DGClassLbl: UILabel!
    @IBOutlet weak var PoisonSLbl: UILabel!
    @IBOutlet weak var HazardousLbl: UILabel!
    
    
    @IBOutlet weak var prodCLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        name.font = UIFont.boldSystemFont(ofSize: 18)
        
        supplbl.font = UIFont.boldSystemFont(ofSize: 13)
        isslbl.font = UIFont.boldSystemFont(ofSize: 13)
        unlbl.font = UIFont.boldSystemFont(ofSize: 13)
        prodCodeLbl.font = UIFont.boldSystemFont(ofSize: 13)
        DGClassLbl.font = UIFont.boldSystemFont(ofSize: 13)
        PoisonSLbl.font = UIFont.boldSystemFont(ofSize: 13)
        HazardousLbl.font = UIFont.boldSystemFont(ofSize: 13)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
