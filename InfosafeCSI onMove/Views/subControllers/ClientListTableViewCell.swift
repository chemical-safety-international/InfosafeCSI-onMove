//
//  ClientListTableViewCell.swift
//  InfosafeCSI onMove
//
//  Created by Releski Tan on 21/10/20.
//  Copyright © 2020 Chemical Safety International. All rights reserved.
//

import UIKit

class ClientListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clientNameLabel: clientName!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        layoutSubviews()
        setLabelStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabelStyle() {
//        self.backgroundColor = UIColor(red:0.25, green:0.26, blue:0.26, alpha:1.0)
//        self.layer.cornerRadius = 15
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.white.cgColor
//        clientNameLabel.layer.cornerRadius = 18
        
//        clientNameLabel.layer.borderWidth = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    

    
}


class clientName: UILabel {
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
