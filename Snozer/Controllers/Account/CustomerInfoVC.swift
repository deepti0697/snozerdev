//
//  CustomerInfoVC.swift
//  Snozer
//
//  Created by Admin on 08/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class CustomerInfoVC: ViewController {
    
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwLocation: UIView!
    @IBOutlet weak var vwPhone: UIView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var collectionPerformance: UICollectionView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    
    
    @IBOutlet weak var vwUserInfo: UIView!
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
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblSeriesStmt: UILabel!
    
    @IBOutlet weak var lblWins: UILabel!
    @IBOutlet weak var lblWinsStmt: UILabel!
    
    @IBOutlet weak var lblRecentPerformanceStmt: UILabel!
    
    @IBOutlet weak var vwSocialInfo: UIView!
    
    @IBOutlet weak var vwPlayingHistoryInfo: UIView!
    var customerId: String = "";
    var userInfo : CustomerInfoDto?;
    var arrRecentPerformance: [SeriesLeaderBoardDto] = [];
    var headerView: NavHeaderView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
        self.callApiCustomerInfo();
    }
    
    
    func setHeaderView() {
       headerView = NavHeaderView.loadViewFromNib();
       headerView?.parentVC = self;
       headerView?.stckLeft.isHidden = true;
       vwHeader.addSubview(headerView!);
       headerView?.setHeaderinfo(title: "");
       headerView?.lblNotificationCount.isHidden = true;
       headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
   }
    
    
    func setUp() {
        
        btnFollow.cornerRadius = 6;
        vwUserInfo.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
       
        vwSocialInfo.setshadow(cornerR: 2, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        vwPlayingHistoryInfo.setshadow(cornerR: 2, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        
        lblName.font = UIFont(name: font_reguler, size: 15);
        lblEmail.font = UIFont(name: font_reguler, size: 13);
        
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

        
        lblName.textColor = APPCOLOR.TextBlackColor
        
        lblEmail.textColor = APPCOLOR.TextDarkGrayColor
        
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
        self.setCollectionLayout();
    }
    
    func setCollectionLayout() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 60 )/2 , height: 70)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionPerformance.collectionViewLayout = layout
    }
    
    func setData() {
        if let userData = userInfo {
            self.imgUser.sd_setImage(with:  URL.init(string: userData.image),placeholderImage: UIImage.init(named: "user_icon"))
            self.lblName.text = userData.firstname + " " + userData.lastname;
            
            self.lblEmail.text = userData.email
            
            self.lblFollowers.text = userData.followerCount;
            self.lblFollowing.text = userData.followingCount;
            self.lblPost.text = userData.postCount;
            self.btnFollow.setTitle(userData.isFollow == "N" ? "FOLLOW" : "UNFOLLOW", for: .normal);
            self.btnFollow.backgroundColor = userData.isFollow == "N" ? APPCOLOR.greenCustom : APPCOLOR.redCustom
            headerView?.setHeaderinfo(title: (userData.firstname + " " + userData.lastname).uppercased());
            headerView?.lblNotificationCount.isHidden = true;
            
            vwPhone.isHidden = true;
            if userData.phone.count > 0 {
                vwPhone.isHidden = false;
                guard userData.phone.count > 5 else {
                    fatalError("The phone number is not complete")
                }
                
                let intLetters = userData.phone.prefix(3)
                let endLetters = userData.phone.suffix(2)

                let stars = String(repeating: "*", count: userData.phone.count - 5)

                let result = intLetters + stars + endLetters
                self.lblMobile.text = userData.customerMobileCode + " " + result;
            }
            
            vwLocation.isHidden = true;
            if let state = userData.state {
                vwLocation.isHidden = false;
                self.lblAddress.text = state.name;
            }
            
        }
    }
    
    func setPlayingHistory(info : PlayingHistory) {
        self.lblWins.text = "\(info.wins!)";
        self.lblContest.text = "\(info.contests!)";
        self.lblMatches.text = "\(info.matches!)";
        self.lblSeries.text = "\(info.series!)";
        
    }
    
    
    func callApiCustomerInfo() {
            
        ProfileService.getCustomerProfile(params: ["customer_id":customerId]) { (flag, respones, msg) in
            if flag{
                if let data = respones{
                    self.userInfo = data;
                    if let info =  self.userInfo?.playingHistory{
                        self.setPlayingHistory(info: info);
                    }
                    self.arrRecentPerformance = self.userInfo?.seriesLeaderboard ?? [];
                    self.lblRecentPerformanceStmt.isHidden = false;
                    if self.arrRecentPerformance.count == 0{
                        self.lblRecentPerformanceStmt.isHidden = true;
                    }
                    self.collectionPerformance.dataSource = self;
                    self.collectionPerformance.delegate = self;
                    self.collectionPerformance.reloadData();
                    
                    self.setData();
                }
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    
    @IBAction func actionForFollow(_ sender: Any) {
        let api = APPURL.BaseURL + APPURL.CricketUrl + APPURL.FollowNUnFollow;
        if userInfo != nil{
            UserService.followAndUnfollow(api, ["following_id" : self.userInfo!.id, "type" :  userInfo!.isFollow == "N" ? "FOLLOW" : "UNFOLLOW"]) { (flag, respone, msg) in
                if flag{
                    self.userInfo?.isFollow = self.userInfo?.isFollow == "N" ? "Y" : "N"
                    self.btnFollow.setTitle(self.userInfo!.isFollow == "N" ? "FOLLOW" : "UNFOLLOW", for: .normal);
                    self.btnFollow.backgroundColor = self.userInfo!.isFollow == "N" ? APPCOLOR.greenCustom : APPCOLOR.redCustom
                }
            }
        }
    }
    
    @IBAction func actionForFollowers(_ sender: Any) {
        if self.userInfo?.followerCount != "0"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC;
             vc.isFollower = true;
             vc.userId = self.customerId;
             vc.customerInfo = self.userInfo;
             vc.hidesBottomBarWhenPushed = true;
             self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    @IBAction func actionForFollowings(_ sender: Any) {
        if self.userInfo?.followingCount != "0"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC;
            vc.isFollower = true;
            vc.userId = self.customerId;
            vc.customerInfo = self.userInfo;
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        }
        
    }
    
    @IBAction func actionForPost(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostListVC") as! PostListVC;
        vc.userId = self.customerId;
	vc.headerTitle = (self.userInfo?.firstname ?? "") + " " + (self.userInfo?.lastname ?? "")
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
}

extension CustomerInfoVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrRecentPerformance.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PerformanceCell", for: indexPath);
        let lblRank = cell.viewWithTag(101) as! UILabel
        let lblName = cell.viewWithTag(102) as! UILabel
        lblRank.text = "#" + arrRecentPerformance[indexPath.row].newRank;
        lblName.text = arrRecentPerformance[indexPath.row].name;
        return cell;
    }

}
