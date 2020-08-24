//
//  KYCInputMessageTableViewCell.swift
//  Cricshot
//
//  Created by Cricshot on 04/04/19.
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import UIKit

class KYCInputMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var lblStmt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblStmt.font = UIFont(name: font_reguler, size: 11)
        self.lblStmt.textColor  = APPCOLOR.TextBlackColor;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
