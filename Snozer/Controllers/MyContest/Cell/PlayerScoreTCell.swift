//
//  PlayerScoreTCell.swift
//  Snozer
//
//  Created by Admin on 24/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PlayerScoreTCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    
    @IBOutlet weak var lblActual: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    func setUp() {
        self.lblName.textColor = APPCOLOR.TextBlackColor;
        self.lblPoints.textColor = APPCOLOR.TextBlackColor;
        self.lblActual.textColor = APPCOLOR.TextBlackColor;
        
        self.lblName.font = UIFont(name: font_reguler, size: 12);
        self.lblPoints.font = UIFont(name: font_reguler, size: 12);
        self.lblActual.font = UIFont(name: font_reguler, size: 12);
    }
    
    func setCellInfo(model : PlayerSkillDto) {
        self.lblName.text = model.keyName;
        self.lblPoints.text = model.ponits;
        self.lblActual.text = model.value;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
