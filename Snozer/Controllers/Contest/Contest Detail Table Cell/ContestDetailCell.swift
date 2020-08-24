//
//  ContestDetailCell.swift
//  Cricshot
//
//  Created by Rampratap on 08/01/19.
//  Copyright © 2019 Cricshot. All rights reserved.
//

import UIKit

class ContestDetailCell: UITableViewCell {

    
    @IBOutlet weak var lblEntryFee: UILabel!
    @IBOutlet weak var lblEntryStmt: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblShareContestStmt: UILabel!
    @IBOutlet weak var vwSwitch: UIView!
    @IBOutlet weak var lblMStmt: UILabel!
    @IBOutlet weak var lblCStmt: UILabel!
    @IBOutlet weak var lblPrizepoolStmt: UILabel!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet var lblTotalWinning : UILabel?
    @IBOutlet var lblTotalWinners : UILabel?
    @IBOutlet var lblTotalTeam : UILabel?
    @IBOutlet var lblLeftTeams : UILabel?

    @IBOutlet var progressBar : GradientProgressBar?
    
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var lblJoinedTeamCount: UILabel!
    @IBOutlet weak var lblJoinedStmt: UILabel!
    @IBOutlet weak var lblMDetail: UILabel!
    @IBOutlet weak var lblCDetail: UILabel!
    @IBOutlet var btnWinningBreakup : UIButton?
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var vwWinningStmt: UIView!
    ////---Multiple Confirm
//    @IBOutlet var lblM : UILabel!
//    @IBOutlet var lblMDetail : UILabel!
//    @IBOutlet var lblC : UILabel!
//    @IBOutlet var lblCDetail : UILabel!
    @IBOutlet weak var btnM: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var viewM: UIView!
    @IBOutlet weak var viewC: UIView!
    @IBOutlet weak var constraintViewMWidth: NSLayoutConstraint!
    @IBOutlet weak var btnSwitch: UIButton!
    var contestInfo : ContestPool!
    var parentVC : UIViewController?

    @IBOutlet weak var imgDiscount: UIImageView!
    @IBOutlet weak var vwDiscount: UIView!
    @IBOutlet weak var lblDiscountValue: UILabel!
    var teamCount = 0;
    var matchDetail : HomeMatchList?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp();
    }

    func setUp() {
        progressBar?.trackTintColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1)
        
        vwContainer.backgroundColor = APPCOLOR.TextWhiteColor;
        self.lblPrizepoolStmt.textColor = APPCOLOR.TextBlackColor
        self.lblEntryStmt.textColor = APPCOLOR.TextBlackColor
        self.lblTotalWinning?.textColor = APPCOLOR.greenCustom;
        self.lblCDetail?.textColor = APPCOLOR.TextBlackColor
        self.lblLeftTeams?.textColor = AppYellow;
        self.lblTotalTeam?.textColor = APPCOLOR.TextBlackColor;
        self.lblMDetail.textColor = APPCOLOR.TextBlackColor;
        self.lblTotalWinners?.textColor = APPCOLOR.redCustom;
        self.lblCStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblCStmt.borderColor = APPCOLOR.redCustom;
        self.lblMStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblMStmt.borderColor = APPCOLOR.redCustom;
        self.vwWinningStmt.backgroundColor = APPCOLOR.TextWhiteColor;
        self.lblDiscountValue.textColor = APPCOLOR.TextGrayColor

        self.lblShareContestStmt?.textColor = APPCOLOR.TextGrayColor;
        self.lblJoinedStmt?.textColor = APPCOLOR.TextGrayColor;
        self.lblJoinedTeamCount.textColor = APPCOLOR.TextBlackColor;
        self.lblEntryFee.backgroundColor = APPCOLOR.redCustom;
        self.lblEntryFee.textColor = APPCOLOR.TextWhiteColor;
        self.btnSwitch.backgroundColor = APPCOLOR.redCustom;
        self.btnSwitch.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        self.btnSwitch.cornerRadius = 6;
        
        self.lblDiscountValue.font = UIFont(name: font_reguler, size: 9);
        self.lblMDetail.font = UIFont(name: font_reguler, size: 10);
        self.lblTotalWinners?.font = UIFont(name: font_medium, size: 11);
        self.lblTotalTeam?.font = UIFont(name: font_medium, size: 10);
        self.lblLeftTeams?.font = UIFont(name: font_medium, size: 10);
        self.lblPrizepoolStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblEntryStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblTotalWinning?.font = UIFont(name: font_bold, size: 11);
        self.lblCDetail?.font = UIFont(name: font_reguler, size: 10);
        self.lblMStmt.font = UIFont(name: font_medium, size: 9);
        self.lblCStmt.font = UIFont(name: font_medium, size: 9);
        
        
        self.lblShareContestStmt?.font = UIFont(name: font_reguler, size: 10);
        self.lblJoinedStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblJoinedTeamCount.font = UIFont(name: font_medium, size: 10);
        self.lblEntryFee.font = UIFont(name: font_reguler, size: 10);
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionForShare(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareContestVC") as! ShareContestVC
        vc.slug = self.contestInfo?.slug ?? "";
        vc.matchDetail = self.matchDetail;
        parentVC?.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    func configureLayoutScreen(_ contestData : ContestPool) -> Void {
        self.contestInfo = contestData;
        //₹
        self.lblTotalWinning?.text = rupeeSymbol + " " +  String("\(contestData.totalPrice )")
        self.lblTotalWinners?.text = String("\(contestData.totalWinners)")
        self.lblTotalTeam?.text = String("\(contestData.totalTeam ) teams")
        self.lblLeftTeams?.text = String("Only \(contestData.totalTeamLeft) spots left");
        self.lblEntryFee.text = rupeeSymbol + " " + String("\(contestData.entryFees.clean)")
        
        self.btnShare.alpha = 1;
        self.btnShare.isUserInteractionEnabled = true;
        
        if contestData.totalTeamLeft == 0{
            btnShare.alpha = 0.5;
            btnShare.isUserInteractionEnabled = false;
        }
        
        imgArrow.isHidden = false;
        btnWinningBreakup?.isHidden = false;
        if Int(contestData.totalWinners)! <= 1{
            imgArrow.isHidden = true;
            btnWinningBreakup?.isHidden = true;
        }
        
        
        let total = Float(contestData.totalTeam) ?? 0
        let left = Float(contestData.totalTeamLeft)
        if total > 0 && left >= 0 {
            let progress = 1.0 - CGFloat(left / total)
            progressBar?.progress = Float(progress)
        }
        
    
        self.progressBar?.gradientColors = [APPCOLOR.greenCustom.cgColor, APPCOLOR.greenCustom.cgColor]
       
        constraintViewMWidth.constant = 16
        viewM.isHidden = false
        if contestData.perUserTeamAllowed == "1" {
            lblMStmt.text = "S"
            lblMDetail.isHidden = false
            lblMDetail.text = "Join with single team";
        }
        
        
        
        vwSwitch.isHidden = contestData.joinedTeams.count == 0;
        
        
        if contestData.joinedTeamsName.count > 0{
            let count = contestData.joinedTeamsName.components(separatedBy: ",").count;
            if count > 0{
                lblJoinedTeamCount.text = count == 1 ? "Team \(contestData.joinedTeamsName ?? "1")" : "\(count) Teams"
            }            
        }
        
        viewC.isHidden = false
        if contestData.confirmWin == "N" {
            viewC.isHidden = true
            lblCDetail.isHidden = true
        }
        
        if contestData.moreEntryFee > 0{
            vwDiscount.isHidden = false;
            imgDiscount.isHidden = false;
//            let discount = 100 - Double(contestData.moreEntryFee)!
//            let superPrice = (Double(contestData.entryFees)! * 100)/discount;
            self.lblDiscountValue.text = rupeeSymbol + " " + contestData.actualEntryFees.clean;
		if contestData.discountImage != "" {
			self.imgDiscount.sd_setImage(with:  URL.init(string: contestData.discountImage),placeholderImage: UIImage.init(named: "user_icon"))
		}
            
        }else{
            vwDiscount.isHidden = true;
            imgDiscount.isHidden = true;
        }
        
        if contestData.joinedTeams != ""{
            if contestData.joinedTeams.components(separatedBy: ",").count == Int(contestData.perUserTeamAllowed) || contestData.totalTeamLeft == 0{
                self.btnJoin.isHidden = true;
            }
        }
    }
    
    @IBAction func actionForJoinContest(_ sender: Any) {
	if !Utility.sharedInstance.checkUserCompleteHisProfileOrNot(){
		Utility.sharedInstance.gotoForEditProfile(fromVc: parentVC! )
		return
	}
	if self.teamCount == 0{
            if appdelegate.matchType == kCricket {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
                vc.fromClass = "contestDetailVC"
                parentVC?.navigationController!.pushViewController(vc, animated: true)
            }else if appdelegate.matchType == kFootball {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
                vc.fromClass = "contestDetailVC"
                parentVC?.navigationController!.pushViewController(vc, animated: true)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
                vc.fromClass = "contestDetailVC"
                parentVC?.navigationController!.pushViewController(vc, animated: true)
            }
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamListJoinContestVC") as! TeamListJoinContestVC
            if self.contestInfo!.joinedTeamsName.count > 0{
                vc.viewType = "rejoincontest"
            }else{
                vc.viewType = "joincontest"
            }
            vc.contestInfo = self.contestInfo;
            vc.myTeamCount = teamCount;
            parentVC?.navigationController!.pushViewController(vc, animated: true)
        }
        
        
        
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

    @IBAction func actionForSwitch(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamListJoinContestVC") as! TeamListJoinContestVC
        vc.viewType = "switchteam"
        vc.contestInfo = self.contestInfo;
        vc.myTeamCount = teamCount;
        parentVC?.navigationController!.pushViewController(vc, animated: true)
    }
    
}
