//
//  BeatExpertDetailCell.swift
//  Snozer
//
//  Created by Admin on 23/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class BeatExpertDetailCell: UITableViewCell {
    
    
    @IBOutlet weak var vwUnlimited: UIView!
    @IBOutlet weak var lblUnlimited: UILabel!
    
    @IBOutlet weak var lblTeamCount: UILabel!
    
    @IBOutlet weak var vwSwitchTeam: UIView!
    @IBOutlet weak var vwContainer: UIView!
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
    var info : ContestCateModel?
    var name: String = "";
    var parentVC: UIViewController?
    var contestInfo : ContestPool?
    
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
        //
        
        lblEntryStmt.textColor = APPCOLOR.TextGrayColor;
        lblEntryFee.textColor = APPCOLOR.TextWhiteColor;
        vwEntryFee.backgroundColor = APPCOLOR.redCustom;
        
        lblEntryStmt.font = UIFont(name: font_reguler, size: 10);
        lblEntryFee.font = UIFont(name: font_bold, size: 11);
        
        vwBottom.backgroundColor = UIColor(red: 232.0/255, green: 232.0/255, blue: 232.0/255, alpha: 1);
        
        lblTitle.font = UIFont(name: font_medium, size: 10);
        lblTitle.textColor = APPCOLOR.TextBlackColor;
        
        lblJoinedTeamStmt.textColor = APPCOLOR.TextBlackColor;
        lblJoinedTeamStmt.font = UIFont(name: font_reguler, size: 10);
        
        lblJoinedTeams.textColor = APPCOLOR.TextBlackColor;
        lblJoinedTeams.font = UIFont(name: font_reguler, size: 10);
        
        lblUnlimited.textColor = APPCOLOR.redCustom;
        lblUnlimited.font = UIFont(name: font_reguler, size: 10);
    
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func SetCellData(model: ContestCateModel) {
        info = model;
        lblTitle.text = model.desc
        lblBeatTheExpertStmt.text = model.title
        
        self.img.sd_setImage(with:  URL.init(string: model.image),placeholderImage: UIImage.init(named: "user_icon"))
        
        if let modelChild = model.contests.first{
            self.contestInfo = modelChild;
            
            lblEntryFee.text = rupeeSymbol + modelChild.entryFees.clean;
            
            let total = Int(modelChild.totalTeam) ?? 0
            let left = Int(modelChild.totalTeamLeft)
            if total > 0 && left >= 0 {
                if (total - left) > 1{
                    self.lblJoinedTeamStmt.text = "TEAMS JOINED"
                }
                lblJoinedTeams.text = "\(total-left)/∞"
            }
            
            let multipe = Float(modelChild.entryFeeMultiplier) ?? 1
            let winning = Float(modelChild.entryFees)
            
            let totalWin = multipe * winning;
            
            let strWinStmt = "Win: "
            let strMultiplierStmt = "\(Int(multipe)) X ";
            let WinningAmountStmt = "\(rupeeSymbol) \(modelChild.entryFees.clean)";
            let finalWinningStmt = " = \(rupeeSymbol) \(totalWin)";
            let finalStmt = strWinStmt + strMultiplierStmt + WinningAmountStmt + finalWinningStmt;
            
            if modelChild.joinedTeamsName.count > 0{
                let count = modelChild.joinedTeamsName.components(separatedBy: ",").count;
                if count > 0{
                    lblTeamCount.text = count == 1 ? "Team \(modelChild.joinedTeamsName ?? "1")" : "\(count) Teams"
                }
            }
            
            let attributedString = NSMutableAttributedString(string: finalStmt, attributes: [
                .font: UIFont(name: font_reguler, size: 12.0)!,
                .foregroundColor: APPCOLOR.TextBlackColor
            ])
            let range = (finalStmt as NSString).range(of: strMultiplierStmt, options: .caseInsensitive)
            
            attributedString.addAttribute(.font, value: UIFont(name: font_bold, size: 12.0)!, range: range);
            attributedString.addAttribute(.foregroundColor, value: APPCOLOR.redCustom, range: range);
            
            lblSubTitle.attributedText = attributedString;
            
            vwSwitchTeam.isHidden = modelChild.joinedTeams.count == 0;
        }
    }
    @IBAction func actionForUnlimitedWInnerBreakup(_ sender: Any) {
        if let model = self.info{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BeatExpertWinningBreakupVC") as! BeatExpertWinningBreakupVC;
            vc.info = model;
            vc.name = self.name;
            vc.modalPresentationStyle = .overCurrentContext;
            parentVC?.present(vc, animated: true, completion: nil);
        }
    }
    @IBAction func actionForSwitchTeam(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamListJoinContestVC") as! TeamListJoinContestVC
        vc.viewType = "switchteam"
        vc.contestInfo = self.contestInfo;
        vc.myTeamCount = 1;
        parentVC?.navigationController!.pushViewController(vc, animated: true)
    }
    
}

