//
//  BeatTheExpertTCell.swift
//  Snozer
//
//  Created by Admin on 06/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class BeatTheExpertTCell: UITableViewCell {

    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var vwJoin: UIView!
    @IBOutlet weak var lblEntryFee: UILabel!
    @IBOutlet weak var vwEntryFee: UIView!
    @IBOutlet weak var lblEntryStmt: UILabel!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var lblJoinedTeams: UILabel!
    @IBOutlet weak var lblJoinedTeamStmt: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblBeatTheExpertStmt: UILabel!
    @IBOutlet weak var vwBeatTheExpert: UIView!
    var parentVC : UIViewController?
    var contestInfo : ContestCateModel!
    var teamCount = 0;
    @IBOutlet weak var vwDiscountBefore: UIView!
    @IBOutlet weak var imgDiscount: UIImageView!
    @IBOutlet weak var lblDiscountBeforeAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp();
    }
    
    func setUp() {
        
        self.vwContainer.setshadow(cornerR: 4, shadowC: .black, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: -1, height: -1))
        
        self.lblBeatTheExpertStmt.textColor = APPCOLOR.TextWhiteColor;
        self.lblBeatTheExpertStmt.font = UIFont(name: font_reguler, size: 14);
        
        vwBeatTheExpert.backgroundColor = APPCOLOR.redCustom;
        vwBeatTheExpert.cornerRadius = 4;

        lblEntryStmt.textColor = APPCOLOR.TextGrayColor;
        lblEntryFee.textColor = APPCOLOR.TextWhiteColor;
        vwEntryFee.backgroundColor = APPCOLOR.redCustom;
        
        lblEntryStmt.font = UIFont(name: font_reguler, size: 10);
        lblEntryFee.font = UIFont(name: font_bold, size: 11);
        
        vwBottom.backgroundColor = UIColor(red: 232.0/255, green: 232.0/255, blue: 232.0/255, alpha: 1);
        
        vwJoin.backgroundColor = APPCOLOR.greenCustom;
        btnJoin.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        
        lblTitle.font = UIFont(name: font_medium, size: 10);
        lblTitle.textColor = APPCOLOR.TextBlackColor;
        
        lblJoinedTeamStmt.textColor = APPCOLOR.TextBlackColor;
        lblJoinedTeamStmt.font = UIFont(name: font_reguler, size: 10);
        
        lblJoinedTeams.textColor = APPCOLOR.TextBlackColor;
        lblJoinedTeams.font = UIFont(name: font_reguler, size: 10);
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func SetCellData(model: ContestCateModel) {
        self.contestInfo = model;
        lblTitle.text = model.desc
        lblBeatTheExpertStmt.text = model.title
        
        self.img.sd_setImage(with:  URL.init(string: model.image),placeholderImage: UIImage.init(named: "user_icon"))
        
        if let modelChild = model.contests.first{
            lblEntryFee.text = rupeeSymbol + modelChild.entryFees.clean;
            let leftTeams = (Int(modelChild.totalTeam) ?? 0) - Int(modelChild.totalTeamLeft)
            lblJoinedTeams.text = "\(leftTeams)/∞"
            
            let multipe = Float(modelChild.entryFeeMultiplier) ?? 1
            let winning = Float(modelChild.entryFees)
            
            let totalWin = multipe * winning;
            
            let strWinStmt = "Win: "
            let strMultiplierStmt = "\(Int(multipe)) X ";
            let WinningAmountStmt = "\(rupeeSymbol) \(modelChild.entryFees.clean)";
            let finalWinningStmt = " = \(rupeeSymbol) \(totalWin.clean)";
            let finalStmt = strWinStmt + strMultiplierStmt + WinningAmountStmt + finalWinningStmt;
            
            let attributedString = NSMutableAttributedString(string: finalStmt, attributes: [
                .font: UIFont(name: font_reguler, size: 12.0)!,
                .foregroundColor: APPCOLOR.TextBlackColor
                ])
            let range = (finalStmt as NSString).range(of: strMultiplierStmt, options: .caseInsensitive)
            
            attributedString.addAttribute(.font, value: UIFont(name: font_bold, size: 12.0)!, range: range);
            attributedString.addAttribute(.foregroundColor, value: APPCOLOR.redCustom, range: range);
            
            lblSubTitle.attributedText = attributedString;
            self.lblBadge.isHidden = true;
            if modelChild.joinedTeams != ""{
                let count = modelChild.joinedTeams.components(separatedBy: ",").count
                self.lblBadge.isHidden = true;
                if count > 0{
                    self.lblBadge.text = "\(count)";
                    self.lblBadge.isHidden = false;
                }
                
                if Int(modelChild.perUserTeamAllowed) == count {
                    btnJoin.isUserInteractionEnabled = false
                    btnJoin.setTitle("JOINED", for: .normal)
                } else {
                    if modelChild.joinedTeams == "" {
                        btnJoin.isUserInteractionEnabled = true
                        btnJoin.setTitle("JOIN", for: .normal)
                    } else {
                        btnJoin.isUserInteractionEnabled = true
                        btnJoin.setTitle("JOIN+", for: .normal)
                    }
                }
            }
            
            if modelChild.moreEntryFee > 0{
                vwDiscountBefore.isHidden = false;
//                let discount = 100 - Double(modelChild.moreEntryFee)!
//                let superPrice = (Double(modelChild.entryFees)! * 100)/discount;
                self.lblDiscountBeforeAmount.text = rupeeSymbol + " " + modelChild.actualEntryFees.clean;
                self.imgDiscount.sd_setImage(with:  URL.init(string: modelChild.discountImage),placeholderImage: UIImage.init(named: "user_icon"))
                imgDiscount.isHidden = false;
            }else{
                vwDiscountBefore.isHidden = true;
                imgDiscount.isHidden = true;
            }
        }
    }
    
    @IBAction func actionForJoin(_ sender: Any) {
        if !Utility.sharedInstance.checkUserCompleteHisProfileOrNot(){
		Utility.sharedInstance.gotoForEditProfile(fromVc: parentVC! )
		return
	}
        if self.teamCount == 0{
            appdelegate.ContestInfo = self.contestInfo.contests.first
            appdelegate.isBeatExpert = true
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
             if self.contestInfo.contests.first!.joinedTeams != "" {
                 vc.viewType = "rejoincontest"
             } else{
                 vc.viewType = "joincontest"
             }
             vc.isBeatExpert = true
             vc.myTeamCount = self.teamCount;
             vc.contestInfo = self.contestInfo.contests.first;
            parentVC?.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
}
