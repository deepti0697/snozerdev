//
//  InviteFriendsVC.swift
//  Snozer
//
//  Created by Admin on 03/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class InviteFriendsVC: ViewController {

	@IBOutlet weak var lblEarnMony: UILabel!
	@IBOutlet weak var vwInviteeFriend: UIView!
	@IBOutlet weak var lblFriendCount: UILabel!
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblRefereStmt: UILabel!
    @IBOutlet weak var lblTagLine: UILabel!
    @IBOutlet weak var btnHowitWork: UIButton!
    @IBOutlet weak var btnFairPLay: UIButton!
    @IBOutlet weak var btnShareYourInviteCodeStmt: UILabel!
    @IBOutlet weak var lblCOde: UILabel!
	@IBOutlet weak var vwContestCode: UIView!
    
    @IBOutlet weak var referralCodeView: UIView!
    @IBOutlet weak var referralCodeSubView: UIView!
    @IBOutlet weak var refercode_txt: UITextField!
    @IBOutlet weak var referralCodeApplyBtn: UIButton!
    
    var headerView : NavHeaderView?
    var referralData : ReferDataDto!
	var share = "";
    var myreferralcode_txt = "";
    var userid_txt = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
		self.vwInviteeFriend.isHidden = true;
		self.setDottedBorder();
        self.setHeaderView()
        self.callRefereDetail();
        self.setUp();
        self.callApiForProfile();
    }
    
    func setUp()
    {
        self.referralCodeSubView.borderColor = APPCOLOR.TextLightGrayColor;
        self.referralCodeSubView.borderWidth = 1;
        self.referralCodeSubView.cornerRadius = 4;
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "INVITE FRIENDS");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
    }
    
    func setDottedBorder() {
        
		delay(0.3) {
			let yourViewBorder = CAShapeLayer()
			yourViewBorder.strokeColor = UIColor.black.cgColor
			yourViewBorder.lineDashPattern = [2, 2]
			yourViewBorder.frame = self.vwContestCode.bounds
			yourViewBorder.fillColor = nil
			yourViewBorder.path = UIBezierPath(rect: self.vwContestCode.bounds).cgPath
			self.vwContestCode.layer.addSublayer(yourViewBorder)
		}
        
    }
    
    func callRefereDetail() {
        UserService.getReferDetail { (flag, response, msg) in
            if flag{
                if let info = response{
                    self.referralData = info;
                    self.setData();
                }
            }
        }
    }
    @IBOutlet weak var lblCashContestEarning: UILabel!
    
    
    @IBAction func actionforReferralCode(_ sender: Any)
    {
        if validation() == ""{
            let dict = ["user_id" : userid_txt.trim(), "referral_code" : refercode_txt.text!.trim(), "my_referral_Code" : myreferralcode_txt.trim()]
            UserService.updateNewReferralCode(dict) { (flag, msg) in
                if flag{
                    
                    self.refercode_txt.isEnabled = false;
                    self.referralCodeApplyBtn.isEnabled = false;
                    self.referralCodeApplyBtn.alpha = 0.5;
                    
                    self.view.showToast(message: msg);
                    
                }else{
                    self.view.showToast(message: msg);
                }
            }
        }else{
            self.view.showToast(message: validation());
        }
    }
    
    @IBAction func cashContestEarningTapped(_ sender: Any)
    {
        let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "CashContestEarningVC") as! CashContestEarningVC
               vc.shareContent = self.share
               vc.referralData = self.referralData;
               self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func callApiForProfile() {
        let api = APPURL.BaseURL + APPURL.CricketUrl + APPURL.GetProfile;
        UserService.getProfileInfo(api) { (flag, response, msg) in
            if flag{
                if let info = response{
                
                    self.myreferralcode_txt = info.referralCode;
                    self.refercode_txt.text = info.used_referralCode;
                    self.userid_txt = info.id;
                    
                    print("My Code: \(self.myreferralcode_txt)");
                    print("user_id: \(self.userid_txt)");
                    print("New Refe Code: \(self.refercode_txt.text!)");
                    
                    if(self.refercode_txt.text != nil && self.refercode_txt.text!.count > 0)
                    {
                        self.refercode_txt.isEnabled = false;
                        self.referralCodeApplyBtn.isEnabled = false;
                        self.referralCodeApplyBtn.alpha = 0.5;
                    }
                    else
                    {
                        self.refercode_txt.isEnabled = true;
                        self.referralCodeApplyBtn.isEnabled = true;
                        self.referralCodeApplyBtn.alpha = 1;
                    }
                    
                    //RBX7TT8U847
                    
//                    self.objAccInfo = info;
//                    NotificationCenter.default.post(name: Notification.Name("updateAccountInfo"), object: nil, userInfo: ["AccountInfo": self.objAccInfo!])
//                    appdelegate.objAccountInfo = self.objAccInfo
                }
            }
        }
    }
    
    func setData() {
        imgHeader.sd_setImage(with:  URL.init(string: referralData.image),placeholderImage: UIImage.init(named: "dummyTeam"))
        lblTagLine.text = referralData.subTitle;
        lblRefereStmt.text = referralData.title;
        if let info = Utility.sharedInstance.getUserInfo(){
            lblCOde.text = info.referralCode;
                        
			share = referralData.shareContent.replacingOccurrences(of: "&", with: "and")
			share = share.replacingOccurrences(of: "%s", with: info.referralCode)
        }

		if Int(referralData.teamCount) != 0{
			self.vwInviteeFriend.isHidden = false;
			lblFriendCount.text = "\(referralData.teamCount) Friends Joined";
			if referralData.teamCount == "1"{
				lblFriendCount.text = "\(referralData.teamCount) Friend Joined";
			}
			lblEarnMony.text = rupeeSymbol + " " + referralData.teamEarn;
		}
        
        lblCashContestEarning.text = rupeeSymbol + " " + referralData.teamEarnCash;
    }
    
    
    @IBAction func actionForHowItWork(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyWebVC") as! MyWebVC
        vc.navtitle = "How It Works"
        vc.slugname = "refer-how-it-works"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func actionForRulesOfFairPlay(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyWebVC") as! MyWebVC
        vc.navtitle = "Rules Of FairPlay"
        vc.slugname = "refer-fair-play"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionForShareWhatsapp(_ sender: Any) {
		let urlWhats = "whatsapp://send?text=\(share)"
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: characterSet) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL)
                } else {
                    self.view.showToast(message: "Please install the Whatsapp app.")
                }
            }
        }else{
            self.view.showToast(message: "Something went wrong, Please try again.");
        }
    }
    
	@IBAction func actionForInviteeList(_ sender: Any) {
        let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "InviteeFriendsVC") as! InviteeFriendsVC
		vc.shareContent = self.share
		vc.referralData = self.referralData;
        self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func actionForMoreOption(_ sender: Any) {
	        let items = [share]
//        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
//        present(ac, animated: true)
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.excludedActivityTypes = []
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = self.view
            if #available(iOS 12.0, *) {
                activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).frame
            } else {
                // Fallback on earlier versions
            }
        }
        present(activityVC, animated: true, completion: nil)
        
    }
	
	@IBAction func actionForCopy(_ sender: Any) {
		UIPasteboard.general.string = self.lblCOde.text;
        self.view.showToast(message: "copied successfully");
    }
    
    func validation() -> String {
        var msg = "";
        if refercode_txt.text!.isBlank{
            msg = "Please enter referral code.";
        }
        else if refercode_txt.text! == myreferralcode_txt{
            msg = "Please enter different referral code.";
        }
        return msg
    }
    
}
