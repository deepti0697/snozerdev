//
//  RecentTransactionTableViewCell.swift
//  GameChanger11
//
//  Created by GameChanger11 on 05/04/19.
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import UIKit

class RecentTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var vwHeading2: UIView!
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var vwTimer: UIView!
    @IBOutlet weak var vwHeading1: UIView!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblHeading1: UILabel!
    @IBOutlet weak var lblHeading2: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var vwContainer: UIView!
    
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwBottom: UIView!
    
//    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwContainer.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: 1, height: 3));
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
//            self.vwContainer.roundCorners([.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 6);
//        }
//        
        
        lblHeading.font = UIFont(name: font_reguler, size: 12);
        lblHeading.textColor = APPCOLOR.TextBlackColor;
        
        lblHeading1.font = UIFont(name: font_reguler, size: 10);
        lblHeading1.textColor = APPCOLOR.TextBlackColor;
        
        lblHeading2.font = UIFont(name: font_reguler, size: 10);
        lblHeading2.textColor = APPCOLOR.TextBlackColor;
        
        lblAmount.font = UIFont(name: font_bold, size: 12);
        lblAmount.textColor = APPCOLOR.TextBlackColor;
        
        
        lblTime.font = UIFont(name: font_reguler, size: 10);
        lblTime.textColor = APPCOLOR.TextBlackColor;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
