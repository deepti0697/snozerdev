//
//  FollowersVC.swift
//  Snozer
//
//  Created by Admin on 05/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class FollowersVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	
    @IBOutlet weak var lblNoDataTop: UILabel!
    @IBOutlet weak var lbNoDataBottom: UILabel!
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var vwNoData: UIView!
    
    
    var arrCustomers : [CustomerInfoDto] = [];
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwUserInfo: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var btnFollower: UIButton!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var lblUserFollowCountsStmt: UILabel!
    @IBOutlet weak var tblFollows: UITableView!
    var isFollower = true;
    var userInfo : UserData?
    var customerInfo : CustomerInfoDto?
    var headerView: NavHeaderView?
    var userId = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
        self.tblFollows.registerTableViewCellWithNib(nibName: "FollowTCell")
        self.callForCustomers();
    }
    
    func callForCustomers() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetCustomers;
        UserService.getCustomers(api, ["type" : isFollower ? "FL" : "FI", "page_no" : "1", "customer_id":userId]) { (flag, response, msg) in
            self.vwNoData.isHidden = true;
            if flag{
                if let data = response{
                    self.arrCustomers = data;
                    self.tblFollows.reloadData();
                    self.lblUserFollowCountsStmt.text = self.isFollower ? "You are followed by \(self.arrCustomers.count) person" : "You are following \(self.arrCustomers.count) person";
                    
                }
            }else{
                self.view.showToast(message: msg);
            }
            
            if self.isFollower{
                if self.arrCustomers.count == 0{
                    self.vwNoData.isHidden = false;
                    self.imgNoData.image = UIImage(named: "user-Minus");
                    self.lblNoDataTop.text = "No one is following you yet";
                    self.lbNoDataBottom.text = "Join more contests, get discovered by others!";
                }
            }else{
                if self.arrCustomers.count == 0{
                    self.vwNoData.isHidden = false;
                    self.imgNoData.image = UIImage(named: "user-tick");
                    self.lblNoDataTop.text = "Not following anyone? Follow the top performers and up your game!";
                    self.lbNoDataBottom.text = "Follow people by tapping on their profile picture on the contest Leaderboard";
                }
            }
        }
    }
    
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
        if let userData = userInfo {
            self.imgUser.sd_setImage(with:  URL.init(string: userData.image),placeholderImage: UIImage.init(named: "user_icon"))
            self.lblName.text = userData.firstname + " " +  userData.lastname;
            headerView?.setHeaderinfo(title: (userData.firstname + " " +  userData.lastname).uppercased());
            self.lblTeamName.text = (userData.teamName ?? "")
        } else {
            if let userData = customerInfo{
                self.imgUser.sd_setImage(with:  URL.init(string: userData.image),placeholderImage: UIImage.init(named: "user_icon"))
                self.lblName.text = userData.firstname + " " +  userData.lastname;
                headerView?.setHeaderinfo(title: (userData.firstname + " " +  userData.lastname).uppercased());
                self.lblTeamName.text = (userData.teamName ?? "")
            }
        }
        headerView?.lblNotificationCount.isHidden = true;
    }
    
    func setUp() {
        vwUserInfo.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: -1, height: -1));
		
		tblFollows.backgroundColor = .white;
        self.imgUser.cornerRadius = 30;
        self.lblName.textColor = APPCOLOR.TextBlackColor;
        self.lblName.font = UIFont(name: font_bold, size: 16);
        self.lblTeamName.textColor = APPCOLOR.TextGrayColor;
        self.lblTeamName.font = UIFont(name: font_reguler, size: 16);
        
        self.btnFollowing.titleLabel?.font = UIFont(name: font_reguler, size: 14);
        self.btnFollower.titleLabel?.font = UIFont(name: font_reguler, size: 14);
        lblUserFollowCountsStmt.textColor = APPCOLOR.TextBlackColor;
        lblUserFollowCountsStmt.font = UIFont(name: font_bold, size: 12);
        
        if isFollower{
            btnFollower.backgroundColor = APPCOLOR.redCustom;
            btnFollower.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
            btnFollowing.backgroundColor = AppLightGrayColor;
            btnFollowing.setTitleColor(APPCOLOR.TextGrayColor, for: .normal);
            
        }else{
            btnFollower.backgroundColor = AppLightGrayColor;
            btnFollower.setTitleColor(APPCOLOR.TextGrayColor, for: .normal);
            btnFollowing.backgroundColor = APPCOLOR.redCustom;
            btnFollowing.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
            
        }
        
    }
    
    
    @IBAction func actionForFollow(_ sender: UIButton) {
        
        btnFollower.backgroundColor = AppLightGrayColor;
        btnFollowing.backgroundColor = AppLightGrayColor;
        btnFollower.setTitleColor(APPCOLOR.TextGrayColor, for: .normal);
        btnFollowing.setTitleColor(APPCOLOR.TextGrayColor, for: .normal);
        
        switch sender.tag {
        case 101:
            isFollower = true;
            btnFollower.backgroundColor = APPCOLOR.redCustom;
            btnFollower.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        case 102:
            isFollower = false;
            btnFollowing.backgroundColor = APPCOLOR.redCustom;
            btnFollowing.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        default:
            print("its Okay")
        }
        self.callForCustomers();
        tblFollows.reloadData();
    }

}

extension FollowersVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCustomers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTCell") as! FollowTCell
        cell.cellSetup(info: arrCustomers[indexPath.row]);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "CustomerInfoVC") as! CustomerInfoVC
        vc.customerId = arrCustomers[indexPath.row].id;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
}
