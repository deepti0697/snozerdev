//
//  ShareTeamVC.swift
//  Snozer
//
//  Created by Admin on 20/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class ShareTeamVC: ViewController {
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	
    @IBOutlet weak var vwHeader: UIView!
    
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
    
    var teamInfo: Jointeam?
    var headerView: NavHeaderView?
    @IBOutlet weak var txtSummry: UITextView!
    @IBOutlet weak var btnPost: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
        self.setInfo();
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "SHARE TEAM");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
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
    }
    
    func setInfo() {
        if let info = teamInfo{
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
    }
    
    
    @IBAction func actionForBtnPost(_ sender: Any) {
        
        if txtSummry.text.trim().count == 0{
            self.view.showToast(message: "Please enter description");
        }else{
            if let user = Utility.sharedInstance.getUserInfo(){
                let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.CreatePost;
                HomeService.createPost(_apiName: api, params: ["team_id" : teamInfo!.id, "post_type" : "POST_TEAM", "description":txtSummry.text!, "customer_id" : user.id]) { (flag, response, msg) in
                    if flag{
                        let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "PostListVC") as! PostListVC
                        vc.userId = appdelegate.objAccountInfo?.id ?? ""
                        vc.comeFrom = "ShareTeam";
                        self.navigationController?.pushViewController(vc, animated: true);
                    }else{
                        self.view.showToast(message: msg);
                    }
                }
            }
            
        }
    }
    
}
