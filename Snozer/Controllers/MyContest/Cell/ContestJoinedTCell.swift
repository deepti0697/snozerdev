//
//  ContestJoinedTCell.swift
//  Snozer
//
//  Created by Admin on 20/11/19.
//  Copyright © 2019 Calieo Technologies.. All rights reserved.
//

import UIKit

class ContestJoinedTCell: UITableViewCell {

    @IBOutlet weak var lblPrizePoolStmt: UILabel!
    @IBOutlet weak var lblPrize: UILabel!
    @IBOutlet weak var lblWinnerStmt: UILabel!
    @IBOutlet weak var lblWinners: UILabel!
    @IBOutlet weak var lblJoinedWithstmt: UILabel!
    @IBOutlet weak var lblJoinedTeamCount: UILabel!
    @IBOutlet weak var lblPointsStmt: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblRankStmt: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblEntryStmt: UILabel!
    @IBOutlet weak var vwEntry: UIView!
    @IBOutlet weak var lblEntry: UILabel!
    @IBOutlet weak var vwDiscount: UIView!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var imgdiscount: UIImageView!
    @IBOutlet weak var imgMoney: UIImageView!
    @IBOutlet weak var lblBottomLine: UILabel!
    var parentVC: UIViewController?
    var contestInfo : ContestPool?
    
    @IBOutlet weak var imgDown: UIImageView!
    @IBOutlet weak var btnWinningBreakup: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp() {
        self.lblPrizePoolStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblPrize.textColor = APPCOLOR.TextBlackColor;
        self.lblWinnerStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblWinners.textColor = APPCOLOR.redCustom;
        self.lblJoinedWithstmt.textColor = APPCOLOR.TextGrayColor;
        self.lblPointsStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblRankStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblJoinedTeamCount.textColor = APPCOLOR.TextBlackColor;
        self.lblRank.textColor = APPCOLOR.TextBlackColor;
        self.lblPoints.textColor = APPCOLOR.TextBlackColor;
        
        self.lblEntryStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblEntry.textColor = APPCOLOR.TextWhiteColor;
        self.vwEntry.backgroundColor = APPCOLOR.redCustom;
        self.lblDiscountPrice.textColor = APPCOLOR.TextLightGrayColor;
        self.lblBottomLine.textColor = APPCOLOR.TextBlackColor;
        
        
        self.lblPrizePoolStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblWinnerStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblPrize.font = UIFont(name: font_reguler, size: 10);
        self.lblWinners.font = UIFont(name: font_reguler, size: 10);
        
        self.lblJoinedWithstmt.font = UIFont(name: font_reguler, size: 10);
        self.lblJoinedWithstmt.font = UIFont(name: font_reguler, size: 10);
        self.lblPointsStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblPoints.font = UIFont(name: font_reguler, size: 10);
        
        self.lblRank.font = UIFont(name: font_reguler, size: 10);
        self.lblRankStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblEntryStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblEntry.font = UIFont(name: font_reguler, size: 9);
        self.lblDiscountPrice.font = UIFont(name: font_reguler, size: 9);
        self.lblBottomLine.font = UIFont(name: font_reguler, size: 10);

    }
    
    
    func setCellinfo(model : ContestPool, isDiscount: String) {
        self.contestInfo = model;
        self.lblPrize.text = rupeeSymbol + " " +  model.totalPrice;
        self.lblWinners.text = model.totalWinners;
        
        imgDown.isHidden = false;
        btnWinningBreakup.isHidden = false;
        if Int(model.totalWinners)! <= 1{
            imgDown.isHidden = true;
            btnWinningBreakup.isHidden = true;
        }
        
        if model.joinedTeamsName.count > 0{
            let count = model.joinedTeamsName.components(separatedBy: ",").count;
            if count > 0{
                lblJoinedTeamCount.text = count == 1 ? "Team \(model.joinedTeamsName ?? "1")" : "\(count) Teams"
            }
        }
        
		if appdelegate.SingleMatchInfo.matchProgress == "L" || appdelegate.SingleMatchInfo.matchProgress == "IR"{
			self.lblBottomLine.text = "View Leaderboard";
			self.imgMoney.isHidden = true;
		}
		
		if model.myteams.count > 1{
			if let obj = model.myteams.max(by: { (m1, m2) -> Bool in
				return Int(m1.newRank)! > Int(m2.newRank)!
			}) {
				self.lblPoints.text = Double(obj.totalPoints)!.clean;
				if Int(obj.newRank) ?? 0 > 0{
					self.lblRank.text = "#" + obj.newRank;
				} else{
					self.lblRank.text = "-";
				}
			}
			let totalSum = model.myteams.map({$0.winAmount}).reduce(0, +)
			let totalRefund = model.myteams.map({Double($0.refundAmount)!}).reduce(0, +)
			
			if totalRefund > 0{
				self.lblBottomLine.text = "Refund " + rupeeSymbol + " \(totalRefund)"
				self.imgMoney.isHidden = false;
			}else if totalSum > 0{
				self.lblBottomLine.text = "Your Winning " + rupeeSymbol + " \(totalSum)"
				self.imgMoney.isHidden = false;
			}
		}else{
			if let team = model.myteams.first{
				self.lblPoints.text = Double(team.totalPoints)!.clean;
				if Int(team.newRank) ?? 0 > 0{
					self.lblRank.text = "#" + team.newRank;
				} else{
					self.lblRank.text = "-";
				}
				if Double(team.refundAmount)! > 0{
					self.lblBottomLine.text = "Refund " + rupeeSymbol + " \(Double(team.refundAmount)!.clean)"
					self.imgMoney.isHidden = false;
				}else if (team.winAmount) > 0{
					self.lblBottomLine.text = "Your Winning " + rupeeSymbol + " \(team.winAmount)"
					self.imgMoney.isHidden = false;
				}
			}
		}
		
        lblEntry.text = rupeeSymbol + " " + model.entryFees.clean;
        if model.moreEntryFee > 0{
            vwDiscount.isHidden = false;
//            let discount = 100 - Double(model.moreEntryFee)!
//            let superPrice = (Double(model.entryFees)! * 100)/discount;
            self.lblDiscountPrice.text = rupeeSymbol + " " + model.actualEntryFees.clean;
            self.imgdiscount.sd_setImage(with:  URL.init(string: model.discountImage),placeholderImage: UIImage.init(named: "user_icon"))
            imgdiscount.isHidden = isDiscount != "N";
        }else{
            vwDiscount.isHidden = true;
            imgdiscount.isHidden = true;
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionForWinnerBrack(_ sender: Any) {
        
        if let model = self.contestInfo{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WinningBreakupsVC") as! WinningBreakupsVC;
            vc.contestId = model.id;
            vc.prizePool = model.totalPrice
            vc.modalPresentationStyle = .overCurrentContext;
            parentVC?.present(vc, animated: true, completion: nil);
        }
    }
    
}
