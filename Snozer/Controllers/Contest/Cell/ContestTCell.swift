//
//  ContestTCell.swift
//  Snozer
//
//  Created by Admin on 03/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

@objc protocol JoinContest {
    
    func joinTapped(_ cell:UITableViewCell)
    @objc optional func otherTapped(_ cell:UITableViewCell)
}

class ContestTCell: UITableViewCell {
    @IBOutlet weak var lblPrizePoolStmt: UILabel!
    @IBOutlet weak var btnS: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var imgDown: UIImageView!
    @IBOutlet weak var btnWinningBreakup: UIButton!
    @IBOutlet weak var btnM: UIButton!
    
    @IBOutlet weak var lblWinnerStmt: UILabel!
    
    
    @IBOutlet weak var lblWinningAmount: UILabel!
    @IBOutlet weak var lblPrize: UILabel!
    @IBOutlet weak var progressBar: GradientProgressBar!
    @IBOutlet weak var lblLeftSpot: UILabel!
    @IBOutlet weak var lblTeamCount: UILabel!
    @IBOutlet weak var lblEntryFeeStmt: UILabel!
    
    @IBOutlet weak var vwEntryFee: UIView!
    
    @IBOutlet weak var lblEntryFee: UILabel!
    
    @IBOutlet weak var vwJoin: UIView!
    @IBOutlet weak var lblJoinStmt: UILabel!
    
    @IBOutlet weak var btnJoin: UIButton!
    
    @IBOutlet weak var vwShare: UIView!
    @IBOutlet weak var vwLower: UIView!
    @IBOutlet weak var vwUpper: UIView!
    
    @IBOutlet weak var vwContainer: UIView!
    
    @IBOutlet weak var lblDiscountBeforeAmount: UILabel!
    @IBOutlet weak var vwDiscountBefore: UIView!
    @IBOutlet weak var imgDiscount: UIImageView!
    
    @IBOutlet weak var lblShareStmt: UILabel!
    var parentVC:  UIViewController?
    var contestInfo : ContestPool?
    var teamCount = 0;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    func setUp() {
        self.lblPrizePoolStmt.font = UIFont(name: font_reguler, size: 11);
        self.lblPrize.font = UIFont(name: font_bold, size: 10);
        self.lblWinnerStmt.font = UIFont(name: font_reguler, size: 11);
        self.lblWinningAmount.font = UIFont(name: font_bold, size: 10);
        self.lblLeftSpot.font = UIFont(name: font_reguler, size: 10);
        self.lblTeamCount.font = UIFont(name: font_reguler, size: 10);
        self.lblEntryFee.font = UIFont(name: font_bold, size: 11);
        self.lblEntryFeeStmt.font = UIFont(name: font_reguler, size: 10);
        self.btnJoin.titleLabel?.font = UIFont(name: font_reguler, size: 12);
        self.progressBar.trackTintColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1);
        self.progressBar.progressTintColor = APPCOLOR.redCustom;
        self.progressBar.gradientColors = [APPCOLOR.redCustom.cgColor, APPCOLOR.redCustom.cgColor];
        
        self.btnM.cornerRadius = 8;
        self.btnS.cornerRadius = 8;
        
        self.btnM.borderColor = APPCOLOR.redCustom;
        self.btnS.borderColor = APPCOLOR.redCustom;
        
        self.btnM.setTitleColor(APPCOLOR.redCustom, for: .normal);
        self.btnS.setTitleColor(APPCOLOR.redCustom, for: .normal);
        
        self.btnS.borderWidth = 1;
        self.btnM.borderWidth = 1;
        
        self.btnS.titleLabel?.font = UIFont(name: font_reguler, size: 8);
        self.btnM.titleLabel?.font = UIFont(name: font_reguler, size: 8);
        
        self.lblDiscountBeforeAmount.font = UIFont(name: font_reguler, size: 10);
        self.lblDiscountBeforeAmount.textColor = APPCOLOR.TextLightGrayColor;
        lblShareStmt.font = UIFont(name: font_reguler, size: 12);
        lblShareStmt.textColor = APPCOLOR.TextDarkGrayColor;
        lblPrizePoolStmt.textColor = APPCOLOR.TextDarkGrayColor;
        lblWinnerStmt.textColor = APPCOLOR.TextDarkGrayColor;
        lblPrize.textColor = APPCOLOR.TextBlackColor;
        lblWinningAmount.textColor = APPCOLOR.redCustom
        lblLeftSpot.textColor = APPCOLOR.OrangeCustom;
        lblTeamCount.textColor = APPCOLOR.TextBlackColor;
        lblEntryFeeStmt.textColor = APPCOLOR.TextDarkGrayColor;
        lblEntryFee.textColor = APPCOLOR.TextWhiteColor;
        btnJoin.backgroundColor = APPCOLOR.greenCustom;
        btnJoin.cornerRadius = 6;
        btnJoin.clipsToBounds = true;
        vwEntryFee.backgroundColor = APPCOLOR.redCustom;
        vwEntryFee.cornerRadius = 6;
        vwEntryFee.clipsToBounds = true;
       // vwContainer.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.4, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
//        vwLower.backgroundColor = UIColor(red: 232.0/255, green: 232.0/255, blue: 232.0/255, alpha: 1);
//        vwShare.backgroundColor = UIColor(red: 232.0/255, green: 232.0/255, blue: 232.0/255, alpha: 1);
        vwShare.isHidden = true;
        self.vwContainer.backgroundColor = UIColor(red: 232.0/255, green: 232.0/255, blue: 232.0/255, alpha: 1);
    }
    
    func SetCellData(model: ContestPool, isDiscount : String = "N") {
        contestInfo = model;
        lblPrize.text = rupeeSymbol + model.totalPrice
        lblWinningAmount.text = model.totalWinners;
        imgDown.isHidden = false;
        btnWinningBreakup.isHidden = false;
        if Int(model.totalWinners)! <= 1{
            imgDown.isHidden = true;
            btnWinningBreakup.isHidden = true;
        }
        lblEntryFee.text = rupeeSymbol + model.entryFees.clean
        lblLeftSpot.text = String(format: "Only %d Spots left", model.totalTeamLeft)
        lblTeamCount.text = String(format: "%@ Teams", model.totalTeam)
        vwShare.isHidden = true;
        
        
        let total = Float(model.totalTeam) ?? 0
        let left = Float(model.totalTeamLeft)
        if total > 0 && left >= 0 {
            let progress = 1.0 - CGFloat(left / total)
            progressBar.progress = Float(progress)
        }

        imgShare.alpha = left > 0 ? 1 : 0.5
        btnShare.isHidden = left > 0 ? false : true
        if model.joinedTeams == "" {
            if left > 0 {
                btnJoin.isUserInteractionEnabled = true
                btnJoin.setTitle("JOIN", for: .normal)
            } else {
                btnJoin.isUserInteractionEnabled = false
                btnJoin.setTitle("FULL", for: .normal)
            }
            
        } else {
            vwShare.isHidden = false;
            let count = model.joinedTeams.components(separatedBy: ",").count
            if count == Int(model.perUserTeamAllowed) {
                btnJoin.isUserInteractionEnabled = false
                btnJoin.setTitle("JOINED", for: .normal)
            } else {
                if left > 0 {
                    btnJoin.isUserInteractionEnabled = true
                    btnJoin.setTitle("JOIN+", for: .normal)
                } else {
                    btnJoin.isUserInteractionEnabled = false
                    btnJoin.setTitle("JOINED", for: .normal)
                }                
            }
        }
        
        if model.moreEntryFee > 0{
            vwDiscountBefore.isHidden = false;            
//            let discount = 100 - Double(model.moreEntryFee)!
//            let superPrice = (Double(model.entryFees)! * 100)/discount;
            self.lblDiscountBeforeAmount.text = rupeeSymbol + " " + model.actualEntryFees.clean;
			if model.discountImage != ""{
				            self.imgDiscount.sd_setImage(with:  URL.init(string: model.discountImage),placeholderImage: UIImage.init(named: "user_icon"))
			}

            imgDiscount.isHidden = isDiscount != "N";
        }else{
            vwDiscountBefore.isHidden = true;
            imgDiscount.isHidden = true;
        }
        
        btnS.setTitle(model.perUserTeamAllowed == "1" ? "S" : "M", for: .normal);
        btnM.isHidden = model.confirmWin == "N"
        btnM.setTitle("C", for: .normal);
        
        
    }
    
    @IBAction func actionForWinningBreakUp(_ sender: Any) {
        if let model = self.contestInfo{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WinningBreakupsVC") as! WinningBreakupsVC;
            vc.contestId = model.id;
            vc.prizePool = model.totalPrice
            vc.modalPresentationStyle = .overCurrentContext;
            parentVC?.present(vc, animated: true, completion: nil);
        }
        
    }
    
    @IBAction func actionForJoin(_ sender: Any) {
        if !Utility.sharedInstance.checkUserCompleteHisProfileOrNot(){
		Utility.sharedInstance.gotoForEditProfile(fromVc: parentVC! )
		return
	}
        if self.teamCount == 0{
            appdelegate.ContestInfo = self.contestInfo;
            if appdelegate.matchType == kCricket {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
                parentVC?.navigationController!.pushViewController(vc, animated: true)
            }else if appdelegate.matchType == kFootball {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
                parentVC?.navigationController!.pushViewController(vc, animated: true)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
                parentVC?.navigationController!.pushViewController(vc, animated: true)
            }
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamListJoinContestVC") as! TeamListJoinContestVC
            if self.contestInfo!.joinedTeams != "" {
                vc.viewType = "rejoincontest"
            } else{
                vc.viewType = "joincontest"
            }
            vc.contestInfo = self.contestInfo;
            vc.myTeamCount = self.teamCount;
            parentVC?.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionForShare(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareContestVC") as! ShareContestVC
        vc.slug = self.contestInfo?.slug ?? "";
        vc.matchDetail = appdelegate.SingleMatchInfo;
        parentVC?.navigationController!.pushViewController(vc, animated: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
