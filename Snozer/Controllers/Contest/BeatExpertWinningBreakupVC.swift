//
//  BeatExpertWinningBreakupVC.swift
//  Snozer
//
//  Created by Admin on 23/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class BeatExpertWinningBreakupVC: ViewController {

    @IBOutlet weak var vwUpperView: UIView!
    @IBOutlet weak var imgExpert: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblJoindedTeamStmt: UILabel!
    @IBOutlet weak var lblJoinedTeam: UILabel!
    @IBOutlet weak var lblEntryFeesStmt: UILabel!
    @IBOutlet weak var lblEntryFee: UILabel!
    @IBOutlet weak var lblWinningStmt: UILabel!
    
    @IBOutlet weak var lblWinningAmountStmt: UILabel!
    var name: String = ""
    @IBOutlet weak var lblPrize: UILabel!
    
    var info : ContestCateModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp();
        self.setData();
    }
    
    func setData() {
        if let model = info{
            self.imgExpert.sd_setImage(with:  URL.init(string: model.image),placeholderImage: UIImage.init(named: "user_icon"))
            if let modelChild = model.contests.first{
                lblEntryFee.text = rupeeSymbol + modelChild.entryFees.clean;
                let total = Int(modelChild.totalTeam) ?? 0
               let left = Int(modelChild.totalTeamLeft)
               if total > 0 && left >= 0 {
                   lblJoinedTeam.text = "\(total-left)"
               }
                                
                let multipe = Float(modelChild.entryFeeMultiplier) ?? 1
                let winning = Float(modelChild.entryFees)
                
                let totalWin = multipe * winning;
                
                let strMultiplierStmt = "\(Int(multipe)) X ";
                let WinningAmountStmt = "\(rupeeSymbol) \(modelChild.entryFees.clean)";
                let finalWinningStmt = " = \(rupeeSymbol) \(totalWin.clean)";
                let finalStmt =  strMultiplierStmt + WinningAmountStmt + finalWinningStmt;
                
                let attributedString = NSMutableAttributedString(string: finalStmt, attributes: [
                    .font: UIFont(name: font_reguler, size: 12.0)!,
                    .foregroundColor: APPCOLOR.TextBlackColor
                    ])
                let range = (finalStmt as NSString).range(of: strMultiplierStmt, options: .caseInsensitive)
                
                attributedString.addAttribute(.font, value: UIFont(name: font_bold, size: 12.0)!, range: range);
                attributedString.addAttribute(.foregroundColor, value: APPCOLOR.redCustom, range: range);
                
                lblPrize.attributedText = attributedString;
                self.lblWinningStmt.text = "Score more than \(name) to become a winner!"
            }
        }
    }
    
    func setUp() {
        vwUpperView.backgroundColor = APPCOLOR.redCustom;
        lblJoinedTeam.textColor = APPCOLOR.TextBlackColor;
        lblEntryFee.textColor = APPCOLOR.TextBlackColor;
        lblWinningAmountStmt.textColor = APPCOLOR.TextBlackColor;
        lblJoindedTeamStmt.textColor = APPCOLOR.TextGrayColor;
        lblEntryFee.textColor = APPCOLOR.TextGrayColor;
        lblWinningStmt.textColor = APPCOLOR.TextGrayColor;
        lblTitle.textColor = APPCOLOR.TextWhiteColor;
        
        lblJoindedTeamStmt.font = UIFont(name: font_reguler, size: 12);
        lblTitle.font = UIFont(name: font_reguler, size: 15);
        lblEntryFee.font = UIFont(name: font_reguler, size: 12);
        lblWinningStmt.font = UIFont(name: font_reguler, size: 12);
        lblWinningAmountStmt.font = UIFont(name: font_medium, size: 12);
        lblEntryFeesStmt.font = UIFont(name: font_reguler, size: 12);
        lblJoinedTeam.font = UIFont(name: font_reguler, size: 12)
    }

    @IBAction func actionForClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
}
