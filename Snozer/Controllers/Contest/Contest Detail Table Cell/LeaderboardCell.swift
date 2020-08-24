//
//  LeaderboardCell.swift
//  Cricshot
//
//  Created by Cricshot#1 on 10/01/19.
//  Copyright © 2019 Cricshot. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell {
	
	@IBOutlet weak var lblWinningStmt: UILabel!
	@IBOutlet weak var imgTraphy: UIImageView!
	@IBOutlet weak var lblWinningAmount: UILabel!
	@IBOutlet weak var imgDollor: UIImageView!
	@IBOutlet weak var vwAfterWinnerRank: UIView!
	@IBOutlet weak var vwAfterWinner: UIView!
	@IBOutlet weak var lblTeamName: UILabel!
	@IBOutlet weak var lblPoints: UILabel!
	@IBOutlet weak var lblRank: UILabel!
	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var selectedbgView: UIView!
	@IBOutlet weak var vwLine: UIView!
	@IBOutlet weak var imgUser: UIImageView!
	var parentVC: UIViewController?
	var customerID = "";
	var isBeatTheExpert = false;
	var matchDetail : HomeMatchList?
	@IBOutlet weak var imgRank: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.setUp();
	}
	
	func setUp() {
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(gotoCustomerDetail))
		tap.numberOfTapsRequired = 1;
		imgUser.addGestureRecognizer(tap);
		imgUser.isUserInteractionEnabled = true;
		
		selectedbgView.backgroundColor = APPCOLOR.redCustom.withAlphaComponent(0.4)
		
		self.lblTeamName.font = UIFont(name: font_medium, size: 12);
		self.lblRank.font = UIFont(name: font_medium, size: 11);
		self.lblPoints.font = UIFont(name: font_reguler, size: 11);
		
		self.lblTeamName.textColor = APPCOLOR.TextBlackColor;
		self.lblRank.textColor = APPCOLOR.TextBlackColor;
		self.lblPoints.textColor = APPCOLOR.TextBlackColor;
		self.bgView.backgroundColor = APPCOLOR.TextWhiteColor;
	}
	
	@objc func gotoCustomerDetail(){
		if customerID != ""{
			if customerID == appdelegate.objAccountInfo?.id{
				parentVC?.tabBarController?.selectedIndex = 3;
			}else{
				let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "CustomerInfoVC") as! CustomerInfoVC
				vc.customerId = customerID;
				parentVC?.navigationController?.pushViewController(vc, animated: true);
			}
			
		}
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	func configureLayoutScreen(_ data : ContestLeaderboardData, contestData: ContestPool) -> Void {
		customerID = data.customerId;
		vwAfterWinner.isHidden = true;
		if Int(data.newRank) ?? 0 > Int(data.oldRank) ?? 0{
			imgRank.image = UIImage(named: "red_icon")
		} else if Int(data.newRank) ?? 0 == Int(data.oldRank) ?? 0{
			imgRank.image = UIImage(named: "yellow_icon")
		} else {
			imgRank.image = UIImage(named: "green")
		}
		if Int(data.newRank) ?? 0 > 0{
			self.lblRank.text = "#" + data.newRank;
			if let match = matchDetail, match.matchProgress == "R" || match.matchProgress == "AB"{
				if Int(data.newRank)! == 1{
					vwAfterWinner.isHidden = false;
				}
			}
		} else{
			self.lblRank.text = "-";
			self.imgRank.image = UIImage(named: "yellow_icon");
		}
		
		self.lblPoints?.text = Double(data.totalPoints)!.clean
		self.lblTeamName?.text = data.customerTeamName + "(T" + data.teamName + ")"
		let objEntry = "ENTRY FEE - " + rupeeSymbol + data.entryFee;
		if isBeatTheExpert && Double(data.entryFee)! > 0{
			self.lblTeamName.text = data.customerTeamName + "(T" + data.teamName + ")" + "\n" + objEntry;
		}
		
		self.imgUser.sd_setImage(with:  URL.init(string: data.image),placeholderImage: UIImage.init(named: "user_icon"))
		self.selectedbgView.isHidden = true
		if  contestData.joinedTeams.components(separatedBy: ",").contains(data.teamId){
			self.selectedbgView.isHidden = false
		}
		vwAfterWinnerRank.isHidden = true;
		
		if let match = matchDetail, match.matchProgress == "R" || match.matchProgress == "AB"{
			if data.winAmount > 0{
				vwAfterWinnerRank.isHidden = false;
				lblWinningAmount.text = rupeeSymbol + " " + "\(data.winAmount)";
			}
			
			if Double(data.refundAmount)! > 0{
				vwAfterWinner.isHidden = true;
				vwAfterWinnerRank.isHidden = false;
				lblWinningAmount.text = rupeeSymbol + " " + data.refundAmount;
			}
		}
	}
}

