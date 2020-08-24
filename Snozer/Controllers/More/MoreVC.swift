//
//  MoreVC.swift
//  Snozer
//
//  Created by Admin on 20/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class MoreVC: ViewController {
    
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tblMoreList: UITableView!
    var headerView: NavHeaderView?
    var data1 : [[String:String]] =  [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setHeaderView();
        tblMoreList.registerTableViewCellWithNib(nibName: "MoreTCell");
		tblMoreList.backgroundColor = .white;
        self.setMoreData()
    }
    
    func setMoreData() {
        
        if let info = Utility.sharedInstance.iconsInfo?.moreInviteFriends{
            data1.append(["title" : "Invite Friends" , "icon" : info.image , "api" : ""]);
        }
        if let info = Utility.sharedInstance.iconsInfo?.moreContestInviteCode{
            data1.append(["title" : "Contest Invite Code" , "icon" : info.image , "api" : ""]);
        }
        if let info = Utility.sharedInstance.iconsInfo?.moreFantasyPointSystem{
            data1.append(["title" : "Fantasy Points System" , "icon" : info.image , "api" : "fantasy-point-system"]);
        }
        if let info = Utility.sharedInstance.iconsInfo?.moreHowToPlay{
            data1.append(["title" : "How to Play" , "icon" : info.image , "api" : "how-to-play"]);
        }
        if let info = Utility.sharedInstance.iconsInfo?.moreHelpdesk{
            data1.append(["title" : "Helpdesk" , "icon" : info.image , "api" : ""]);
        }
        if let info = Utility.sharedInstance.iconsInfo?.moreAboutus{
            data1.append(["title" : "About Us" , "icon" : info.image , "api" : "about-us"]);
        }
        if let info = Utility.sharedInstance.iconsInfo?.moreLegality{
            data1.append(["title" : "Legality" , "icon" : info.image , "api" : "legality"]);
        }
        if let info = Utility.sharedInstance.iconsInfo?.moreWithdrawPolicy{
            data1.append(["title" : "Withdraw Policy" , "icon" : info.image , "api" : "withdrawal_policy"]);
        }
        if let info = Utility.sharedInstance.iconsInfo?.moreTermsOfServices{
            data1.append(["title" : "Term of Services" , "icon" : info.image , "api" : "tnc"]);
        }
        if let info = Utility.sharedInstance.iconsInfo?.moreContact{
            data1.append(["title" : "Contact" , "icon" : info.image , "api" : "contact_us"]);
        }
        if let info = Utility.sharedInstance.iconsInfo?.moreFaq{
            data1.append(["title" : "Faq" , "icon" : info.image , "api" : "faq"]);
        }
	data1.append(["title" : "Version " + (Bundle.main.releaseVersionNumber ?? "1.0") , "icon" : "" , "api" : ""]);
        tblMoreList.reloadData();
    }
    
    

    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = false;
        headerView?.btnBack.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "MORE");
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        self.headerView?.setWallet();
    }
    
    @objc func NotificationBtnTapped()
    {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
//
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension MoreVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTCell") as! MoreTCell
	cell.imgIcon.isHidden = false;
	cell.lblTitle.text = data1[indexPath.row]["title"]
	if data1[indexPath.row]["icon"] == ""{
		cell.imgIcon.isHidden = true;
	}
        cell.imgIcon.sd_setImage(with:  URL.init(string: data1[indexPath.row]["icon"] ?? ""),placeholderImage: UIImage.init(named: "user_icon"))
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if data1[indexPath.row]["title"] == "Invite Friends" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendsVC") as! InviteFriendsVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if data1[indexPath.row]["title"] == "Contest Invite Code" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContestInviteVC") as! ContestInviteVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if data1[indexPath.row]["title"] == "Helpdesk" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpDeskVC") as! HelpDeskVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyWebVC") as! MyWebVC
            let dict = data1[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            vc.navtitle = dict["title"]
            vc.slugname = dict["api"]!
    
            self.navigationController?.pushViewController(vc, animated: true)
       }
        
    }
}
