//
//  AccountVC.swift
//  Snozer
//
//  Created by Admin on 20/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import SVProgressHUD


class AccountVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwMobile: UIView!
    @IBOutlet weak var vwHeader: UIView!
    var headerView: NavHeaderView?
    @IBOutlet weak var vwUserInfo: UIView!
    @IBOutlet weak var vwAccountInfo: UIView!
    @IBOutlet weak var vwSocialInfo: UIView!
    @IBOutlet weak var vwPlayingHistoryInfo: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblChangePasswordStmt: UILabel!
    @IBOutlet weak var lblAccountStmt: UILabel!
    @IBOutlet weak var lblDeposit: UILabel!
    @IBOutlet weak var lblDepositStmt: UILabel!
    @IBOutlet weak var lblBonus: UILabel!
    @IBOutlet weak var lblBonusStmt: UILabel!
    @IBOutlet weak var lblWinning: UILabel!
    @IBOutlet weak var lblWinningStmt: UILabel!
    @IBOutlet weak var btnAddBalance: UIButton!
    @IBOutlet weak var btnWithdraw: UIButton!
    @IBOutlet weak var lblLeaderboardStmt: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowerStmt: UILabel!
    @IBOutlet weak var lblFollowingstmt: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblPostStmt: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var lblPlayingHistoryStmt: UILabel!
    @IBOutlet weak var lblContest: UILabel!
    @IBOutlet weak var lblContestStmt: UILabel!
    @IBOutlet weak var lblMatches: UILabel!
    @IBOutlet weak var lblMatchesStmt: UILabel!
    @IBOutlet weak var lblSeries: UILabel!
    
    @IBOutlet weak var lblSeriesStmt: UILabel!
    
    @IBOutlet weak var lblWins: UILabel!
    @IBOutlet weak var lblWinsStmt: UILabel!
    
    @IBOutlet weak var btnTransaction: UIButton!
    
    @IBOutlet weak var btnWithdrawlHistory: UIButton!
    
    @IBOutlet weak var lblLogoutStmt: UILabel!
    
    var userInfo : UserData?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setHeaderView();
        self.setUp();
    }
    
    func setUp() {
        
        vwUserInfo.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        vwAccountInfo.setshadow(cornerR: 2, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        vwSocialInfo.setshadow(cornerR: 2, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        vwPlayingHistoryInfo.setshadow(cornerR: 2, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        
        lblName.font = UIFont(name: font_reguler, size: 16);
        lblMobile.font = UIFont(name: font_reguler, size: 14);
        lblEmail.font = UIFont(name: font_reguler, size: 14);
        lblChangePasswordStmt.font = UIFont(name: font_reguler, size: 14);
        
        lblAccountStmt.font = UIFont(name: font_medium, size: 16);
        lblDeposit.font = UIFont(name: font_medium, size: 14);
        lblDepositStmt.font = UIFont(name: font_reguler, size: 14);
        lblBonus.font = UIFont(name: font_medium, size: 14);
        lblBonusStmt.font = UIFont(name: font_reguler, size: 14);
        lblWinning.font = UIFont(name: font_medium, size: 14);
        lblWinningStmt.font = UIFont(name: font_reguler, size: 14);
        btnAddBalance.titleLabel?.font = UIFont(name: font_medium, size: 13);
        btnWithdraw.titleLabel?.font = UIFont(name: font_medium, size: 13);
        lblLeaderboardStmt.font = UIFont(name: font_reguler, size: 14);
        
        lblFollowers.font = UIFont(name: font_medium, size: 14);
        lblFollowerStmt.font = UIFont(name: font_reguler, size: 14);
        lblFollowing.font = UIFont(name: font_medium, size: 14);
        lblFollowingstmt.font = UIFont(name: font_reguler, size: 14);
        lblPost.font = UIFont(name: font_medium, size: 14);
        lblPostStmt.font = UIFont(name: font_reguler, size: 14);
        
        lblPlayingHistoryStmt.font = UIFont(name: font_medium, size: 16);
        lblContest.font = UIFont(name: font_medium, size: 14);
        lblContestStmt.font = UIFont(name: font_reguler, size: 14);
        lblMatches.font = UIFont(name: font_medium, size: 14);
        lblMatchesStmt.font = UIFont(name: font_reguler, size: 14);
        lblSeries.font = UIFont(name: font_medium, size: 14);
        lblSeriesStmt.font = UIFont(name: font_reguler, size: 14);
        lblWins.font = UIFont(name: font_medium, size: 14);
        lblWinsStmt.font = UIFont(name: font_reguler, size: 14);
        
        btnTransaction.titleLabel?.font = UIFont(name: font_reguler, size: 13);
        btnWithdrawlHistory.titleLabel?.font = UIFont(name: font_reguler, size: 13);
        lblLogoutStmt.font = UIFont(name: font_reguler, size: 16);
        
        lblName.textColor = APPCOLOR.TextBlackColor
        lblMobile.textColor = APPCOLOR.TextBlackColor
        lblEmail.textColor = APPCOLOR.TextBlackColor
        lblChangePasswordStmt.textColor = APPCOLOR.redCustom;
        
        lblAccountStmt.textColor = APPCOLOR.TextBlackColor;
        lblDepositStmt.textColor = APPCOLOR.TextBlackColor;
        lblDeposit.textColor = APPCOLOR.TextBlackColor;
        lblBonusStmt.textColor = APPCOLOR.TextBlackColor;
        lblBonus.textColor = APPCOLOR.TextBlackColor;
        lblWinningStmt.textColor = APPCOLOR.TextBlackColor;
        lblWinning.textColor = APPCOLOR.TextBlackColor;
        btnAddBalance.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        btnWithdraw.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        btnAddBalance.cornerRadius = 15;
        btnWithdraw.cornerRadius = 15;
        lblLeaderboardStmt.textColor = APPCOLOR.redCustom;
        
        lblFollowingstmt.textColor = APPCOLOR.TextBlackColor;
        lblFollowing.textColor = APPCOLOR.BlueTintCustom;
        lblFollowerStmt.textColor = APPCOLOR.TextBlackColor;
        lblFollowers.textColor = APPCOLOR.BlueTintCustom;
        lblPostStmt.textColor = APPCOLOR.TextBlackColor;
        lblPost.textColor = APPCOLOR.BlueTintCustom;
        
    
        lblPlayingHistoryStmt.textColor = APPCOLOR.TextBlackColor;
        lblContestStmt.textColor = APPCOLOR.TextBlackColor;
        lblContest.textColor = APPCOLOR.TextBlackColor;
        lblMatches.textColor = APPCOLOR.TextBlackColor;
        lblMatchesStmt.textColor = APPCOLOR.TextBlackColor;
        lblSeries.textColor = APPCOLOR.TextBlackColor;
        lblSeriesStmt.textColor = APPCOLOR.TextBlackColor;
        lblWinsStmt.textColor = APPCOLOR.TextBlackColor;
        lblWins.textColor = APPCOLOR.TextBlackColor;
        
        btnTransaction.setTitleColor(APPCOLOR.TextBlackColor, for: .normal);
        btnWithdrawlHistory.setTitleColor(APPCOLOR.TextBlackColor, for: .normal);
        
        btnTransaction.cornerRadius = 4;
        btnWithdrawlHistory.cornerRadius = 4;
        
        lblLogoutStmt.textColor = APPCOLOR.redCustom;
        
        btnWithdraw.backgroundColor = APPCOLOR.redCustom;
        btnWithdrawlHistory.backgroundColor = APPCOLOR.YellowCustom;
        btnTransaction.backgroundColor = APPCOLOR.YellowCustom;
        btnAddBalance.backgroundColor = APPCOLOR.greenCustom;
    }
    
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.vwWallet.isHidden = true
        headerView?.vwNotification.isHidden = false;
        headerView?.btnBack.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "PROFILE");
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.callApiForProfile();
        self.callApiForPlayingHistory();
        
    }
    
    func callApiForProfile() {    
        let api = APPURL.BaseURL + APPURL.CricketUrl + APPURL.GetProfile;
        UserService.getProfileInfo(api) { (flag, response, msg) in
            if flag{
                if let info = response{
                    self.userInfo = info;
                    appdelegate.objAccountInfo = info;                    
                    self.setData();
                }
            }
        }
    }
    
    func callApiForPlayingHistory() {
        let api = APPURL.BaseURL + APPURL.CricketUrl + APPURL.GetPlayingHistory;
        UserService.getPlayingHistory(api) { (flag, response, msg) in
            if flag{
                if let info = response{
                    self.setPlayingHistory(info: info);
                }
            }
        }
    }
    
    func setData() {
        if let userData = userInfo {
            self.imgAvatar.sd_setImage(with:  URL.init(string: userData.image),placeholderImage: UIImage.init(named: "user_icon"))
            self.lblName.text = userData.firstname + userData.lastname;
            vwEmail.isHidden = true;
            vwMobile.isHidden = true;
            if userData.phone != ""{
                vwMobile.isHidden = false;
                self.lblMobile.text = (userData.countryMobileCode ?? "")  + " " + (userData.phone ?? "")
                
            }
            if userData.email != ""{
                vwEmail.isHidden = false;
                self.lblEmail.text = userData.email ?? ""
            }
            
            self.lblDeposit.text = (rupeeSymbol + " 0");
            self.lblBonus.text = (rupeeSymbol + " 0");
            self.lblWinning.text = (rupeeSymbol + " 0");
            if let wallet = userData.wallet{
                self.lblDeposit.text = wallet.depositWallet == 0 ? (rupeeSymbol + " 0") : rupeeSymbol + " " + wallet.depositWallet.clean;
                self.lblBonus.text = wallet.bonusWallet == 0 ? (rupeeSymbol + " 0") : rupeeSymbol + " " + wallet.bonusWallet.clean;
                self.lblWinning.text = wallet.winningWallet == 0 ? (rupeeSymbol + " 0") : rupeeSymbol + " " + wallet.winningWallet.clean;
            }
            
            self.lblFollowers.text = userData.followerCount;
            self.lblFollowing.text = userData.followingCount;
            self.lblPost.text = userData.postCount;
            self.headerView?.setWallet();
        }
    }
    
    func setPlayingHistory(info : PlayingHistory) {
        self.lblWins.text = "\(info.wins!)";
        self.lblContest.text = "\(info.contests!)";
        self.lblMatches.text = "\(info.matches!)";
        self.lblSeries.text = "\(info.series!)";
        
    }
    
    
    @IBAction func actionForAvatar(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController( withIdentifier: "AvtarSelectionVC") as! AvtarSelectionVC ;
        if let userData = userInfo {
            vc.selectedUrl = userData.image
        }
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    
    @IBAction func actionForEdit(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfleVC") as! EditProfleVC
        vc.hidesBottomBarWhenPushed = true;
        vc.userInfo = self.userInfo;
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    @IBAction func actionForChangePassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC");
        vc?.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc!, animated: true);
    }
    @IBAction func actionForWithdrawl(_ sender: Any) {
        var isNotKYCUpdate = false;
        if self.userInfo?.isEmailVerified == "Y" || self.userInfo?.isPhoneVerified == "Y" || self.userInfo?.pancard != nil || self.userInfo?.bankdetail != nil{
            isNotKYCUpdate = true;
            if let pan = self.userInfo?.pancard{
                if pan.status == "A"{
                    isNotKYCUpdate = true;
                }else{
                    isNotKYCUpdate = false;
                }
                
            }else{
                isNotKYCUpdate = false;
            }
            
            if let bank = self.userInfo?.bankdetail{
                if bank.status == "A"{
                    isNotKYCUpdate = true;
                }else{
                    isNotKYCUpdate = false;
                }
            }else{
                isNotKYCUpdate = false;
            }
        }
        if isNotKYCUpdate{
            let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "WithdrawalViewController") as! WithdrawalViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.redirectTOKYC();
        }
    }
    
    func redirectTOKYC() {
        let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "KYCViewController");
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func actionForAddBalance(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCashVC");
        vc?.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc!, animated: true);
    }
    
    
    @IBAction func actionForLeaderboard(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeaderBoardVC") as! LeaderBoardVC;
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func actionForFollowers(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC;
        vc.userId = self.userInfo?.id ?? "0";
        vc.isFollower = true;
        vc.userInfo = self.userInfo;
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    @IBAction func actionForFollowings(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC;
        vc.isFollower = false;
        vc.userInfo = self.userInfo;
        vc.userId = self.userInfo?.id ?? "0";
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func actionForPost(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostListVC") as! PostListVC;
        vc.userId = self.userInfo?.id ?? "0";
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func actionForTransctionHistory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecentTransactionsViewController") as! RecentTransactionsViewController;
        vc.fromType = "TRANSACTIONS HISTORY"
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    @IBAction func actionForWithdrawlHistory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecentTransactionsViewController") as! RecentTransactionsViewController;
        vc.fromType = "WITHDRAWL HISTORY"
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func actionForLogout(_ sender: Any) {
        self.popupAlert(title: kAppName, message: "Are you sure you want to logout?", actionTitles: ["No", "Yes"], actions: [{
            
            },{
                self.dismissDetail({
                    SVProgressHUD.show()
                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                        Utility.sharedInstance.deleteLoginUser();
                        UserDefaults.standard.setValue(false, forKey: kIsAutoLogin)
                        let vc = UIStoryboard(name: "Initial", bundle: nil).instantiateViewController(withIdentifier: "navLogin")
                        UIApplication.shared.windows.first?.rootViewController = vc
                        
                    })
                })
            }])
    }
    
}
//8005812626
