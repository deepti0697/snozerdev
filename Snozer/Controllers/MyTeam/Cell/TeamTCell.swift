//
//  TeamTCell.swift
//  Snozer
//
//  Created by BHUVAN SHARMA on 13/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class TeamTCell: UITableViewCell {
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblCaptionStmt: UILabel!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lblViceCaptionStmt: UILabel!
    @IBOutlet weak var lblViceCaption: UILabel!
    @IBOutlet weak var vwPlayerType1: UIView!
    @IBOutlet weak var vwPlayerType2: UIView!
    @IBOutlet weak var vwPlayerType3: UIView!
    @IBOutlet weak var vwPlayerType4: UIView!
    
    @IBOutlet weak var lblPlayerType1: UILabel!
    @IBOutlet weak var lblPlayerType1Value: UILabel!
    
    @IBOutlet weak var lblPlayerType2: UILabel!
    @IBOutlet weak var lblPlayerType2Value: UILabel!
    
    @IBOutlet weak var lblPlayerType3: UILabel!
    @IBOutlet weak var lblPlayerType3Value: UILabel!
    
    @IBOutlet weak var lblPlayerType4: UILabel!
    @IBOutlet weak var lblPlayerType4Value: UILabel!
    
    @IBOutlet weak var lblEditStmt: UILabel!
    @IBOutlet weak var imgEdit: UIImageView!
    
    @IBOutlet weak var lblPreivewStmt: UILabel!
    @IBOutlet weak var imgPreview: UIImageView!
    
    @IBOutlet weak var lblCloneStmt: UILabel!
    @IBOutlet weak var imgClone: UIImageView!
    
    @IBOutlet weak var vwCone: UIView!
    
    var parentVC : UIViewController?
    var teamInfo: Jointeam?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp() {
        self.lblTeamName.textColor = APPCOLOR.TextBlackColor;
        self.lblTeamName.font = UIFont(name: font_medium, size: 14);
        
        self.lblCaptionStmt.textColor = APPCOLOR.OrangeCustom;
        self.lblCaption.textColor = APPCOLOR.TextBlackColor;
        
        self.lblCaptionStmt.font = UIFont(name: font_medium, size: 14);
        self.lblCaption.font = UIFont(name: font_bold, size: 13);
        
        self.lblViceCaptionStmt.textColor = APPCOLOR.redCustom;
        self.lblViceCaption.textColor = APPCOLOR.TextBlackColor;
        
        self.lblViceCaptionStmt.font = UIFont(name: font_medium, size: 14);
        self.lblViceCaption.font = UIFont(name: font_bold, size: 13);
        
        
        for lbl in [lblPlayerType1, lblPlayerType2, lblPlayerType3, lblPlayerType4]{
            lbl?.textColor = APPCOLOR.TextLightGrayColor;
            lbl?.font = UIFont(name: font_reguler, size: 14);
        }
        
        for lbl in [lblPlayerType1Value, lblPlayerType2Value, lblPlayerType3Value, lblPlayerType4Value]{
            lbl?.textColor = APPCOLOR.TextBlackColor;
            lbl?.font = UIFont(name: font_reguler, size: 13);
        }
        
        for img in [imgEdit, imgClone, imgPreview] {
            img?.tintColor = APPCOLOR.redCustom;
        }
        
        for lbl in [lblEditStmt, lblPreivewStmt, lblCloneStmt] {
            lbl?.textColor = APPCOLOR.TextLightGrayColor;
            lbl?.font = UIFont(name: font_reguler, size: 14);
        }
    }
    
    func setCellInfo(info : Jointeam) {
        teamInfo = info;
        self.lblTeamName.text = "Team \(info.name!)".uppercased();
        self.lblCaption.text = info.caption.playerName;
        self.lblViceCaption.text = info.vcCaption.playerName;
        if appdelegate.matchType == kCricket{
            self.lblPlayerType1.text = "WK"
            self.lblPlayerType1Value.text = "\(info.wicketkeapers.count)"
            self.lblPlayerType2.text = "BAT"
            self.lblPlayerType2Value.text = "\(info.batsmans.count)"
            self.lblPlayerType3.text = "ALL"
            self.lblPlayerType3Value.text = "\(info.allrounders.count)"
            self.lblPlayerType4.text = "BOWL"
            self.lblPlayerType4Value.text = "\(info.bowlers.count)"
        }else if appdelegate.matchType == kFootball{
            self.lblPlayerType1.text = "GK"
            self.lblPlayerType1Value.text = "\(info.wicketkeapers.count)"
            self.lblPlayerType2.text = "DEF"
            self.lblPlayerType2Value.text = "\(info.batsmans.count)"
            self.lblPlayerType3.text = "MID"
            self.lblPlayerType3Value.text = "\(info.allrounders.count)"
            self.lblPlayerType4.text = "ST"
            self.lblPlayerType4Value.text = "\(info.bowlers.count)"
        } else{
            
            vwPlayerType1.isHidden = true;
            self.lblPlayerType2.text = "DEF"
            self.lblPlayerType2Value.text = "\(info.batsmans.count)"
            self.lblPlayerType3.text = "ALL"
            self.lblPlayerType3Value.text = "\(info.allrounders.count)"
            self.lblPlayerType4.text = "RAi"
            self.lblPlayerType4Value.text = "\(info.bowlers.count)"
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionForShare(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareTeamVC") as! ShareTeamVC;
        vc.teamInfo = teamInfo;
        parentVC?.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func actionForEdit(_ sender: Any) {
        if appdelegate.matchType == kCricket{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
            vc.isEditing = true;
            vc.strEditedTeamId = teamInfo!.id;
            vc.editTeamData = teamInfo;
            vc.fromClass = "myTeamList"
            parentVC?.navigationController?.pushViewController(vc, animated: true);
        }else if appdelegate.matchType == kFootball{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
            vc.isEditing = true;
            vc.strEditedTeamId = teamInfo!.id;
            vc.editTeamData = teamInfo;
            vc.fromClass = "myTeamList"
            parentVC?.navigationController?.pushViewController(vc, animated: true);
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
            vc.isEditing = true;
            vc.strEditedTeamId = teamInfo!.id;
            vc.editTeamData = teamInfo;
            vc.fromClass = "myTeamList"
            parentVC?.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    @IBAction func actionForPreview(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamPreviewController") as! TeamPreviewController
        vc.selectedTeamID = teamInfo!.id;
        vc.sportsType = appdelegate.matchType;
        vc.matchUrl = appdelegate.matchTypeUrl;
        vc.parentVC = self.parentVC;
        vc.isFromCreateteam = 2;
        vc.modalPresentationStyle = .overCurrentContext;
        parentVC?.present(vc, animated: true, completion: nil);
        
    }
    
    @IBAction func actionForClone(_ sender: Any) {
        if appdelegate.matchType == kCricket{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
            vc.isClone = true
            vc.editTeamData = teamInfo;
            vc.fromClass = "myTeamList"
            parentVC?.navigationController?.pushViewController(vc, animated: true);
        }else if appdelegate.matchType == kFootball{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
            vc.isClone = true
            vc.editTeamData = teamInfo;
            vc.fromClass = "myTeamList"
            parentVC?.navigationController?.pushViewController(vc, animated: true);
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
            vc.isClone = true
            vc.editTeamData = teamInfo;
            vc.fromClass = "myTeamList"
            parentVC?.navigationController?.pushViewController(vc, animated: true);
        }
    }
}
