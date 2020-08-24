//
//  PostTCell.swift
//  Snozer
//
//  Created by Admin on 07/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PostTCell: UITableViewCell {

    @IBOutlet weak var lblSharedStmt: UILabel!
    @IBOutlet weak var btnUserReactions: UIButton!
    @IBOutlet weak var btnRreaction: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblPostStmt: UILabel!
    @IBOutlet weak var lblTeamsName: UILabel!
    @IBOutlet weak var lblUserTeamName: UILabel!
    @IBOutlet weak var lblCaption: UILabel!
    
    @IBOutlet weak var lblCaptionStmt: UILabel!
    @IBOutlet weak var lblVCStmt: UILabel!
    @IBOutlet weak var lblVC: UILabel!
    
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
    @IBOutlet weak var lblMsg: UILabel!
    
    @IBOutlet weak var imgSelectReact: UIImageView!
    @IBOutlet weak var lblReactStmt: UILabel!
    @IBOutlet weak var vwReactResponse: UIView!
    @IBOutlet weak var lblReactValue: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgClock: UIImageView!
    @IBOutlet weak var imgR1: UIImageView!
    @IBOutlet weak var imgR2: UIImageView!
    @IBOutlet weak var imgR3: UIImageView!
    @IBOutlet weak var imgR4: UIImageView!
    @IBOutlet weak var imgR5: UIImageView!
    var parentVC: UIViewController?
    var postInfo : PostShareDto?
    var customerId = "0";
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUP();
    }
    
    func setUP() {
         self.lblPostStmt.textColor = APPCOLOR.TextBlackColor;
         self.lblPostStmt.font = UIFont(name: font_medium, size: 14);
        
        self.lblSharedStmt.textColor = APPCOLOR.TextLightGrayColor;
        self.lblSharedStmt.font = UIFont(name: font_reguler, size: 14);
        
        self.lblTeamsName.textColor = APPCOLOR.TextGrayColor;
        self.lblTeamsName.font = UIFont(name: font_reguler, size: 11);

        self.lblUserTeamName.textColor = APPCOLOR.TextBlackColor;
        self.lblUserTeamName.font = UIFont(name: font_medium, size: 16);
        
        self.lblMsg.textColor = APPCOLOR.TextGrayColor;
        self.lblMsg.font = UIFont(name: font_reguler, size: 12);
        
        self.lblReactStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblReactStmt.font = UIFont(name: font_reguler, size: 11);
        
        self.lblReactValue.textColor = APPCOLOR.BlueTintCustom;
        self.lblReactValue.font = UIFont(name: font_reguler, size: 11);
        
        self.lblDate.textColor = APPCOLOR.TextGrayColor;
        self.lblDate.font = UIFont(name: font_reguler, size: 11);
         
         self.lblCaptionStmt.textColor = APPCOLOR.OrangeCustom;
         self.lblCaption.textColor = APPCOLOR.TextBlackColor;
         
         self.lblCaptionStmt.font = UIFont(name: font_medium, size: 14);
         self.lblCaption.font = UIFont(name: font_bold, size: 13);
         
         self.lblVCStmt.textColor = APPCOLOR.redCustom;
         self.lblVC.textColor = APPCOLOR.TextBlackColor;
         
         self.lblVCStmt.font = UIFont(name: font_medium, size: 14);
         self.lblVC.font = UIFont(name: font_bold, size: 13);
         
         
         for lbl in [lblPlayerType1, lblPlayerType2, lblPlayerType3, lblPlayerType4]{
             lbl?.textColor = APPCOLOR.TextLightGrayColor;
             lbl?.font = UIFont(name: font_reguler, size: 14);
         }
         
         for lbl in [lblPlayerType1Value, lblPlayerType2Value, lblPlayerType3Value, lblPlayerType4Value]{
             lbl?.textColor = APPCOLOR.TextBlackColor;
             lbl?.font = UIFont(name: font_reguler, size: 13);
         }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoProfile))
        tap.numberOfTapsRequired = 1;
        imgUser.isUserInteractionEnabled = true;
        imgUser.addGestureRecognizer(tap);
    }
    
    @objc func gotoProfile() {
        if customerId != "0"{
            if customerId == appdelegate.objAccountInfo?.id{
                if self.parentVC?.isKind(of: PostListVC.self) ?? false{
                    self.parentVC?.navigationController?.popViewController(animated: true);
                }else{
                    self.parentVC?.tabBarController?.selectedIndex = 3;
                }
            }else{
                let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "CustomerInfoVC") as! CustomerInfoVC
                vc.customerId = customerId;
                self.parentVC?.navigationController?.pushViewController(vc, animated: true);
            }
        }
    }

    func setCellInfo(postData : PostShareDto) {
        postInfo = postData;
        customerId = postData.userDetail?.id ?? "0"
        if let info = postData.postTeam{            
            self.lblCaption.text = info.caption.playerName;
            self.lblVC.text = info.vcCaption.playerName;
            var sportid = kCricket;
            if let sport = postData.sport{
                sportid = sport.sportId;
            }
            if sportid == kCricket{
                vwPlayerType1.isHidden = false;
                self.lblPlayerType1.text = "WK"
                self.lblPlayerType1Value.text = "\(info.wicketkeapers.count)"
                self.lblPlayerType2.text = "BAT"
                self.lblPlayerType2Value.text = "\(info.batsmans.count)"
                self.lblPlayerType3.text = "ALL"
                self.lblPlayerType3Value.text = "\(info.allrounders.count)"
                self.lblPlayerType4.text = "BOWL"
                self.lblPlayerType4Value.text = "\(info.bowlers.count)"
            }else if sportid == kFootball{
                vwPlayerType1.isHidden = false;
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
                self.lblPlayerType4.text = "RAI"
                self.lblPlayerType4Value.text = "\(info.bowlers.count)"
            }
        }
        
        if let info = postData.userDetail{
            imgUser.sd_setImage(with:  URL.init(string: info.image),placeholderImage: UIImage.init(named: "user_icon"));
            self.lblUserTeamName.text = "\(info.teamName!) (T\(postData.postTeam?.name ?? ""))".uppercased();
        }
        
        lblReactValue.text = postData.reactionDMsg;
        lblReactStmt.text = "React";
        imgSelectReact.image = UIImage(named: "smiling");
        if let rData = postData.reactionDetail{
            lblReactStmt.text = rData.name;
            imgSelectReact.sd_setImage(with:  URL.init(string: rData.image),placeholderImage: UIImage.init(named: "user_icon"));
        }
        
        lblTeamsName.text = "\(postData.sport!.name) | \(postData.matchName)"
        lblMsg.text = postData.des;
        lblDate.text = Double(postData.created)?.getDate("dd-MM-yyyy");
        lblSharedStmt.text = "shared a Team";
        if let info = Utility.sharedInstance.getUserInfo(){
            if info.id == postData.userDetail?.id{
                lblPostStmt.text = "You";                
            }else{
                lblPostStmt.text = (postData.userDetail?.firstname ?? "Some one")
            }
        }
        
        
        let arrReacts = postData.reactions.filter({Int($0.reactionCount) ?? 0 > 0});
        vwReactResponse.isHidden = true;
        if postData.reactionDMsg != ""{
            vwReactResponse.isHidden = false;
        }
        
        for img in [imgR1, imgR2, imgR3, imgR4, imgR5] {
            img?.isHidden = true;
        }
        
        for (index,react) in arrReacts.enumerated() {
            if index == 0{
                imgR1.isHidden = false;
                imgR1.sd_setImage(with:  URL.init(string: react.image),placeholderImage: UIImage.init(named: "user_icon"));
            } else if index == 1{
                imgR2.isHidden = false;
                imgR2.sd_setImage(with:  URL.init(string: react.image),placeholderImage: UIImage.init(named: "user_icon"));
            } else if index == 2{
                imgR3.isHidden = false;
                imgR3.sd_setImage(with:  URL.init(string: react.image),placeholderImage: UIImage.init(named: "user_icon"));
            } else if index == 3{
                imgR4.isHidden = false;
                imgR4.sd_setImage(with:  URL.init(string: react.image),placeholderImage: UIImage.init(named: "user_icon"));
            } else if index == 4{
                imgR5.isHidden = false;
                imgR5.sd_setImage(with:  URL.init(string: react.image),placeholderImage: UIImage.init(named: "user_icon"));
            }
        }
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
