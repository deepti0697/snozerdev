//
//  PlayerStatsCell.swift
//  Snozer
//
//  Created by Admin on 24/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PlayerStatsCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgInPlayer: UIImageView!
    @IBOutlet weak var imgTopPlayer: UIImageView!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblSelectedBy: UILabel!
    
    let dict : [String : String] = ["midfielder": "MID", "forward" : "ST", "defender":"DEF", "goalkeeper" : "GK", "allrounder":"ALL", "bowler":"BOWL", "batsman":"BAT", "wicketkeeper":"WK","raider":"RID"]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func  setUp() {
        self.lblPoints.textColor = APPCOLOR.TextBlackColor;
        self.lblName.textColor = APPCOLOR.redCustom;
        self.lblCountry.textColor = APPCOLOR.TextBlackColor
        self.lblType.textColor = APPCOLOR.TextGrayColor;
        self.lblSelectedBy.textColor = APPCOLOR.TextBlackColor;
        
        self.lblName.font = UIFont(name: font_reguler, size: 12);
        self.lblCountry.font = UIFont(name: font_reguler, size: 12);
        self.lblSelectedBy.font = UIFont(name: font_reguler, size: 12);
        self.lblType.font = UIFont(name: font_reguler, size: 12);
        self.lblPoints.font = UIFont(name: font_reguler, size: 12);
    }
    
    func setCellInfo(model : PlayerStatsDto) {
        self.imgUser.sd_setImage(with:  URL.init(string: model.image),placeholderImage: UIImage.init(named: "user_icon"))
        self.lblSelectedBy.text = Double(model.selectedBy)!.clean + " " + "%";
        self.lblPoints.text = model.points
        self.lblName.text = model.name;
        self.lblCountry.text = model.teamData?.sortName
        self.lblType.text = self.getPlayerType(postion: model.position);
        self.imgTopPlayer.isHidden = model.dreamTeamPlayer == "N";
        self.imgInPlayer.tintColor = model.isMyPlayer == "Y" ? APPCOLOR.greenCustom : APPCOLOR.redCustom;
    }
    
    func  getPlayerType(postion : String) -> String {
        return dict[postion.lowercased()]!;
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
