//
//  PrivateWinningTCell.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PrivateWinningTCell: UITableViewCell {

    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblPrizeAmount: UILabel!
    
    @IBOutlet weak var vwLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
