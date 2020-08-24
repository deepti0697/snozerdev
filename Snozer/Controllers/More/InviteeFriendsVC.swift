//
//  InviteeFriendsVC.swift
//  Snozer
//
//  Created by BHUVAN SHARMA on 02/02/20.
//  Copyright © 2020 SynarionItSolutions. All rights reserved.
//

import UIKit

class InviteeFriendsVC: ViewController {
	var arrFriends : [UserReferDto] = [];
	
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
	@IBOutlet weak var tblInvitee: UITableView!
	
	@IBOutlet weak var lblToBeReceive: UILabel!
	@IBOutlet weak var lblReceive: UILabel!
	@IBOutlet weak var moneyProgress: GradientProgressBar!
	@IBOutlet weak var lblFriendscount: UILabel!
	@IBOutlet weak var lblTobeEarn: UILabel!
	@IBOutlet weak var lblEarningAmount: UILabel!
	var headerView : NavHeaderView?
	var shareContent = "";
	var referralData : ReferDataDto!
	var refDetail : ReferralDto?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
		self.tblInvitee.registerTableViewCellWithNib(nibName: "InviteeFriendCell");
		self.tblInvitee.backgroundColor = .white;
		self.setHeaderView();
		self.callApiForInvitee();
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
	
	func callApiForInvitee()  {
        UserService.getReferTeamDetail { (flag, response, msg) in
            if flag{
                if let info = response{
                    self.refDetail = info;
					self.arrFriends = self.refDetail!.userReferData;
                    self.setData();
                }
            }
        }
	}
	
    func setData() {
        
         //moneyProgress?.trackTintColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1)
        
		self.lblEarningAmount.text = rupeeSymbol + " " +  Float(self.referralData.totalReceivedAmount)!.clean;
		self.lblTobeEarn.text = rupeeSymbol + " " +  Float(self.referralData.teamEarn)!.clean;
			self.lblReceive.text = rupeeSymbol + " " +  Float(self.referralData.totalReceivedAmount)!.clean;
			self.lblToBeReceive.text = rupeeSymbol + " " +  Float(self.referralData.teamEarn)!.clean;
		//self.moneyProgress.trackTintColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1);
      //  self.moneyProgress.gradientColors = [APPCOLOR.redCustom.cgColor, APPCOLOR.redCustom.cgColor];
        
		let total = Float(referralData.teamEarn) ?? 0
        let left = Float(referralData.totalReceivedAmount) ?? 0
        
        if total > 0 && left >= 0 {
            var progress = 0.0
            let FinalValue = CGFloat(left / total)
            if(FinalValue == 1.0)
            {
                progress = Double(1.0)
            }
            else
            {
                progress = Double(FinalValue)
            }
            
            moneyProgress.progress = Float(progress)
        }
        
        self.moneyProgress.trackTintColor = UIColor(red: 216.0/255, green: 216.0/255, blue: 216.0/255, alpha: 1);
         self.moneyProgress?.gradientColors = [APPCOLOR.redCustom.cgColor, APPCOLOR.redCustom.cgColor]
        
		lblFriendscount.text = "\(referralData.teamCount) Friends Joined";
		if referralData.teamCount == "1"{
			lblFriendscount.text = "\(referralData.teamCount) Friend Joined";
		}
		
		self.tblInvitee.reloadData();
	}
    
    
    @IBAction func MoreButtonTabbed(_ sender: Any) {
        
        
    }
    
	@IBAction func actionForMoreInvite(_ sender: Any) {
        
		let items = [shareContent]
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
        present(activityVC, animated: true)
        
        
        
	}
	@IBAction func actionForInfo(_ sender: Any) {
		self.popupAlert(title: kAppName, message: "Cash bonus will be added to your Snozer account only once the winner has been declared for the matches your friends have joined cash contest in", actionTitles: ["OK"], actions: [{}]);
	}

}

extension InviteeFriendsVC : UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrFriends.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "InviteeFriendCell") as! InviteeFriendCell;
		cell.setUpData(data: arrFriends[indexPath.row]);
		return cell;
	}
}
