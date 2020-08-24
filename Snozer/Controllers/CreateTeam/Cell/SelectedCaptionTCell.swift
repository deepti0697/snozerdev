//
//  SelectedCaptionTCell.swift
//  Snozer
//
//  Created by Admin on 11/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class SelectedCaptionTCell: UITableViewCell {

    @IBOutlet weak var lblPlayerType: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var imgPoint: UIImageView!
    @IBOutlet weak var btnVC: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var lblCSelectedBy: UILabel!
    @IBOutlet weak var lblVCSelectedBy: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp() {
        self.lblPoints.textColor = APPCOLOR.TextGrayColor;
        self.lblPlayerName.textColor = APPCOLOR.TextBlackColor;
        
        self.lblPoints.font = UIFont(name: font_reguler, size: 10);
        self.lblPlayerName.font = UIFont(name: font_bold, size: 12);
        
        self.lblTeamName.font = UIFont(name: font_reguler, size: 8);
        self.lblPlayerType.font = UIFont(name: font_reguler, size: 8);
        
        self.lblPlayerType.textColor = APPCOLOR.TextBlackColor;
        self.btnC.borderColor = APPCOLOR.TextGrayColor;
        self.btnVC.borderColor = APPCOLOR.TextGrayColor;
        self.btnC.borderWidth = 1.0;
        self.btnVC.borderWidth = 1.0;
        
        self.btnVC.setTitleColor(APPCOLOR.TextBlackColor, for: .normal);
        self.btnC.setTitleColor(APPCOLOR.TextBlackColor, for: .normal);
    }

    func configureLayoutScreen(_ TeamPlayerModelData : PlayerData) -> Void {
        self.lblPoints.text = "Points- \(TeamPlayerModelData.totalPoints)"
        self.lblPlayerName?.text = TeamPlayerModelData.playerName
//        self.lblTeamName.text = appdelegate.SingleMatchInfo.team1.id == TeamPlayerModelData.teamId ? appdelegate.SingleMatchInfo.team1.sortName : appdelegate.SingleMatchInfo.team2.sortName;
        self.lblTeamName.text = appdelegate.SingleMatchInfo.team1.id == TeamPlayerModelData.teamId ? (appdelegate.SingleMatchInfo.team1.sortName.count > 3 ? String(appdelegate.SingleMatchInfo.team1.sortName.prefix(3)) : appdelegate.SingleMatchInfo.team1.sortName) : (appdelegate.SingleMatchInfo.team2.sortName.count > 3 ? String(appdelegate.SingleMatchInfo.team2.sortName.prefix(3)) : appdelegate.SingleMatchInfo.team2.sortName)
        
        self.lblTeamName.backgroundColor = appdelegate.SingleMatchInfo.team1.id == TeamPlayerModelData.teamId ? APPCOLOR.TextWhiteColor : APPCOLOR.TextBlackColor;
        
        
        self.lblTeamName.textColor = appdelegate.SingleMatchInfo.team1.id == TeamPlayerModelData.teamId ? APPCOLOR.TextBlackColor : APPCOLOR.TextWhiteColor;
        
        self.lblPlayerType.text = playerTypeDict[TeamPlayerModelData.position.lowercased()] ;
        if appdelegate.matchType == kCricket{
            if TeamPlayerModelData.position.lowercased() == "allrounder"{
                self.lblPlayerType.text = playerTypeDict["allrounderc"] ;
            }
        }
        
        
        self.imgPlayer?.sd_setImage(with:  URL.init(string: TeamPlayerModelData.image),placeholderImage: UIImage.init(named: "user_icon"))
        self.lblCSelectedBy.text = Double(TeamPlayerModelData.selectedAsCaption)!.clean + "%"
        self.lblVCSelectedBy.text = Double(TeamPlayerModelData.selectedAsVccaption)!.clean + "%"
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
