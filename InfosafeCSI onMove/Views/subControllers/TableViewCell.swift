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
    

    @IBOutlet weak var isslbl: UILabel!
    @IBOutlet weak var unlbl: UILabel!

    @IBOutlet weak var psLbl: UILabel!

    
    
    @IBOutlet weak var prodCodeLbl: UILabel!
    @IBOutlet weak var SupplierLbl: UILabel!
    @IBOutlet weak var IssueDateLbl: UILabel!
    @IBOutlet weak var UNNoLbl: UILabel!
    

    @IBOutlet weak var PoisonSLbl: UILabel!
    
    
    @IBOutlet weak var countryLbl: UILabel!
    
    @IBOutlet weak var ghsImg1: UIImageView!
    @IBOutlet weak var ghsImg2: UIImageView!
    @IBOutlet weak var ghsImg3: UIImageView!
    @IBOutlet weak var ghsImg4: UIImageView!
    @IBOutlet weak var ghsImg5: UIImageView!
    
    
    @IBOutlet weak var issImg1Gap: NSLayoutConstraint!
    @IBOutlet weak var issImg4Gap: NSLayoutConstraint!
    
    @IBOutlet weak var img1Height: NSLayoutConstraint!
    @IBOutlet weak var img4Height: NSLayoutConstraint!
    
    @IBOutlet weak var img1BotGap: NSLayoutConstraint!
    
    @IBOutlet weak var prodCLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        name.font = UIFont.boldSystemFont(ofSize: 15)
        isslbl.font = UIFont.boldSystemFont(ofSize: 13)
        unlbl.font = UIFont.boldSystemFont(ofSize: 13)
        prodCodeLbl.font = UIFont.boldSystemFont(ofSize: 13)
        countryLbl.font = UIFont.systemFont(ofSize: 13)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state

    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
//    }
    
}
