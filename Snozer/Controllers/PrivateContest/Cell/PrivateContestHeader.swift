//
//  PrivateContestHeader.swift
//  Snozer
//
//  Created by Admin on 22/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PrivateContestHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var imgRight: UIImageView!
    @IBOutlet weak var imgLeft: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClick: UIButton!
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
           self.setUp();
    }
    
    func setUp() {
        vwContainer.clipsToBounds = true;
        vwContainer.borderColor = APPCOLOR.TextGrayColor;
        vwContainer.borderWidth = 1;
        vwContainer.cornerRadius = 4;
        self.lblTitle.font = UIFont(name: font_reguler, size: 12);
        self.lblTitle.textColor = APPCOLOR.TextBlackColor;
    }
}
