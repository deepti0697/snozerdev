//
//  CreateTeamTCell.swift
//  Snozer
//
//  Created by Admin on 11/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

protocol PlayerTeamSelectDelegate {
    func playerImageClick(info : PlayerData);
}

class CreateTeamTCell: UITableViewCell {

	@IBOutlet weak var vwGrayOut: UIView!
	@IBOutlet weak var lblPlayingStatus: UILabel!
    @IBOutlet weak var vwInOut: UIView!
    @IBOutlet weak var vwPlayingSquad: UIView!
    @IBOutlet weak var vwSelected: UIView!
    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var lblSelectedBy: UILabel!
    @IBOutlet weak var imgAddRemove: UIImageView!
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var vwTeamName: UIView!
    @IBOutlet weak var lblTeamName: UILabel!
    var parentVC : UIViewController?
    var playerInfo : PlayerData?
    var delegate :  PlayerTeamSelectDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }

    func setUp() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoCustomerDetail))
        tap.numberOfTapsRequired = 1;
        imgPlayer.addGestureRecognizer(tap);
        imgPlayer.isUserInteractionEnabled = true;
        
        self.lblPlayerName.textColor = APPCOLOR.TextBlackColor;
        self.lblTeamName.textColor = APPCOLOR.TextGrayColor;
        self.lblSelectedBy.textColor = APPCOLOR.TextGrayColor;
        self.lblPoints.textColor = APPCOLOR.TextBlackColor;
        self.lblCredit.textColor = APPCOLOR.TextBlackColor;
        self.imgAddRemove.tintColor = APPCOLOR.greenCustom;
        self.vwTeamName.backgroundColor = APPCOLOR.TextLightGrayColor;
        
        self.lblPlayerName.font = UIFont(name: font_medium, size: 12);
        self.lblSelectedBy.font = UIFont(name: font_reguler, size: 11);
        self.lblPoints.font = UIFont(name: font_medium, size: 12);
        self.lblCredit.font = UIFont(name: font_medium, size: 12);
        self.lblTeamName.font = UIFont(name: font_reguler, size: 10);
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func gotoCustomerDetail(){
        if self.playerInfo != nil{
            delegate?.playerImageClick(info: self.playerInfo!)
        }
    }
    
    
    func configureLayoutScreen(_ TeamPlayerModelData : PlayerData) -> Void {
        self.playerInfo = TeamPlayerModelData;
        self.lblPlayerName?.text = TeamPlayerModelData.playerName
        self.lblCredit?.text = String("\(TeamPlayerModelData.credits)")
        self.lblPoints?.text = String("\(TeamPlayerModelData.totalPoints)")
        self.imgPlayer?.sd_setImage(with:  URL.init(string: TeamPlayerModelData.image),placeholderImage: UIImage.init(named: "user_icon"))
        
        self.imgPlayer.backgroundColor = UIColor.clear;
        self.vwSelected.isHidden = true
        self.lblSelectedBy.text = "Sel By \(Double(TeamPlayerModelData.selectedBy)!.clean)%"
        
        
        if TeamPlayerModelData.isSelected == true {
            self.imgAddRemove.image = UIImage.init(named: "remove")
            self.vwSelected.isHidden = false
        } else {
            self.imgAddRemove.image = UIImage.init(named: "add_icon")
        }
        
        vwPlayingSquad.isHidden = true
        if TeamPlayerModelData.playingSquadUpdated == "Y"{
            vwPlayingSquad.isHidden = false;
            vwInOut.backgroundColor = TeamPlayerModelData.isInPlayingSquad == "Y" ? APPCOLOR.greenCustom : APPCOLOR.redCustom;
            lblPlayingStatus.text = TeamPlayerModelData.isInPlayingSquad == "Y" ? "Playing" : "Not Playing";
        }
    }
}
