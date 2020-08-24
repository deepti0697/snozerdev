//
//  InviteContestTCell.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class InviteContestTCell: UITableViewCell {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwInside: UIView!
    @IBOutlet weak var btnJoinContest: UIButton!
    @IBOutlet weak var vwInviteCode: UIView!
    @IBOutlet weak var lblInviteCodeStmt: UILabel!
    @IBOutlet weak var txtInviteCode: UITextField!
    var parentVC : UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp();
    }

    func setUp() {
        
        vwContainer.borderWidth = 1.0;
        vwContainer.borderColor = APPCOLOR.TextGrayColor;
        vwContainer.cornerRadius = 6;
//        vwInviteCode.borderColor = APPCOLOR.TextLightGrayColor;
//        vwInside.borderColor = APPCOLOR.TextLightGrayColor;
//        vwInviteCode.borderWidth = 1;
        vwInviteCode.setshadow(cornerR: 4, shadowC: .lightGray, shadowO: 0.4, shadowR: 2, shadowOffset: CGSize(width: -1, height: 1));
//        vwInside.borderWidth = 1;
//        vwInviteCode.cornerRadius = 4
//        vwInside.cornerRadius = 6
        txtInviteCode.font = UIFont(name: font_reguler, size: 14);
	txtInviteCode.autocorrectionType = .no;
        txtInviteCode.textColor = APPCOLOR.TextBlackColor;
        lblInviteCodeStmt.textColor = APPCOLOR.TextBlackColor;
        lblInviteCodeStmt.font = UIFont(name: font_reguler, size: 14);
        
        btnJoinContest.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        btnJoinContest.backgroundColor = APPCOLOR.greenCustom;
        btnJoinContest.titleLabel?.font = UIFont(name: font_bold, size: 14);
        self.btnJoinContest.cornerRadius = 6;
        self.btnJoinContest.clipsToBounds = true;
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionForJoin(_ sender: Any) {
        if txtInviteCode.hasText{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContestDetailVC") as! ContestDetailVC
            vc.slug = txtInviteCode.text!;
			vc.matchSlugID = appdelegate.SingleMatchInfo.matchId;
            parentVC?.navigationController!.pushViewController(vc, animated: true)
        }else{
            parentVC?.view.showToast(message: "Please enter invite code");
        }
    }
}
