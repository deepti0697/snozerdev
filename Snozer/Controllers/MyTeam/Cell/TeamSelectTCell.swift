//
//  TeamSelectTCell.swift
//  Snozer
//
//  Created by Admin on 20/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class TeamSelectTCell: UITableViewCell {

    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblAlready: UILabel!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lblCaptionValue: UILabel!
    @IBOutlet weak var imgCaption: UIImageView!
    @IBOutlet weak var lblC: UILabel!
    
    
    @IBOutlet weak var lblVCaption: UILabel!
    @IBOutlet weak var lblVCaptionValue: UILabel!
    @IBOutlet weak var imgVCaption: UIImageView!
    @IBOutlet weak var lblVC: UILabel!
    
    @IBOutlet weak var lblPreviewStmt: UILabel!
    var parentVC : UIViewController?
    var teamInfo: Jointeam?
    
    @IBOutlet weak var vwContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp() {
        lblTeamName.textColor = APPCOLOR.TextDarkGrayColor;
        lblAlready.textColor = APPCOLOR.greenCustom;
        lblCaption.textColor = APPCOLOR.TextDarkGrayColor;
        lblCaptionValue.textColor = APPCOLOR.redCustom;
        lblVCaption.textColor = APPCOLOR.TextDarkGrayColor;
        lblVCaptionValue.textColor = APPCOLOR.redCustom;
        lblPreviewStmt.textColor = APPCOLOR.TextDarkGrayColor;
        
        lblC.textColor = APPCOLOR.TextWhiteColor;
        lblVC.textColor = APPCOLOR.TextWhiteColor
        
        lblC.backgroundColor = APPCOLOR.OrangeCustom
        lblVC.backgroundColor = APPCOLOR.redCustom
        
        self.lblTeamName.font = UIFont(name: font_reguler, size: 15);
        self.lblAlready.font = UIFont(name: font_reguler, size: 10)
        self.lblCaption.font = UIFont(name: font_reguler, size: 12);
        self.lblCaptionValue.font = UIFont(name: font_reguler, size: 10)
        self.lblVCaption.font = UIFont(name: font_reguler, size: 12);
        self.lblVCaptionValue.font = UIFont(name: font_reguler, size: 10)
        self.lblPreviewStmt.font = UIFont(name: font_reguler, size: 12);
        
        self.lblC.font = UIFont(name: font_reguler, size: 9)
        self.lblVC.font = UIFont(name: font_reguler, size: 9)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionForPreview(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamPreviewController") as! TeamPreviewController
        vc.selectedTeamID = teamInfo!.id;
        vc.sportsType = appdelegate.matchType;
        vc.matchUrl = appdelegate.matchTypeUrl;
	vc.fromClass = "teamList";
	vc.isFromCreateteam = 2;
	vc.parentVC = parentVC;
        vc.modalPresentationStyle = .overFullScreen;
        parentVC?.present(vc, animated: true, completion: nil);
    }
    
    func setCellInfo(info : Jointeam, contestData: ContestPool?) {
        teamInfo = info;
        self.lblTeamName.text = "Team \(info.name!)".uppercased();
        self.lblCaption.text = info.caption.playerName;
        self.lblVCaption.text = info.vcCaption.playerName;
        self.lblCaptionValue.text = info.caption.totalPoints;
        self.lblVCaptionValue.text = info.vcCaption.totalPoints;
        
        lblAlready.isHidden = true
        
        self.vwContainer.borderColor = APPCOLOR.TextLightGrayColor;
        self.imgCaption.sd_setImage(with:  URL.init(string: info.caption.image),placeholderImage: UIImage.init(named: "user_icon"))
        self.imgVCaption.sd_setImage(with:  URL.init(string: info.caption.image),placeholderImage: UIImage.init(named: "user_icon"))
        
        if let data = contestData {
            if data.joinedTeams.count > 0{
                if data.joinedTeams.components(separatedBy: ",").contains(info.id){
                    imgTick.image = UIImage(named: "check_icon_tick");
                    imgTick.tintColor = APPCOLOR.greenCustom;
                    self.vwContainer.borderColor = APPCOLOR.greenCustom
                    lblAlready.isHidden = false;
                }
            }
        }
        
        
    }

}
