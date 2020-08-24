//
//  SeriesContestTCell.swift
//  Snozer
//
//  Created by Admin on 07/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class SeriesContestTCell: UITableViewCell {

    @IBOutlet weak var lblContestName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp() {
        self.lblContestName.textColor = APPCOLOR.TextBlackColor;
        self.lblPoints.textColor = APPCOLOR.TextBlackColor;
        self.lblDate.textColor = APPCOLOR.TextGrayColor;
        
        self.lblContestName.font = UIFont(name: font_reguler, size: 14);
        self.lblPoints.font = UIFont(name: font_reguler, size: 14);
        self.lblDate.font = UIFont(name: font_reguler, size: 14);
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
