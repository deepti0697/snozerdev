//
//  ContestInviteVC.swift
//  Snozer
//
//  Created by Admin on 26/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class ContestInviteVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var btnContest: UIButton!
    @IBOutlet weak var txtInviteCode: UITextField!
    @IBOutlet weak var vwTxtInput: UIView!
    @IBOutlet weak var vwHeader: UIView!
    var headerView: NavHeaderView?
    @IBOutlet weak var lblHaveContestStmt: UILabel!
    
    @IBOutlet weak var lblEnterInviteCodeStmt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp()
        self.setHeaderView();
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "CONTEST INVITE CODE");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
    }
    
    
    func setUp() {
        self.lblEnterInviteCodeStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblHaveContestStmt.textColor = APPCOLOR.TextBlackColor;
        vwTxtInput.setshadow(cornerR: 4, shadowC: .black, shadowO: 0.3, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1))
        txtInviteCode.font = UIFont(name: font_reguler, size: 14);
        txtInviteCode.textColor = APPCOLOR.TextBlackColor;
        txtInviteCode.autocorrectionType = .no;
        lblHaveContestStmt.font = UIFont(name: font_medium, size: 12);
        lblEnterInviteCodeStmt.font = UIFont(name: font_medium, size: 12);
        
        btnContest.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        btnContest.backgroundColor = APPCOLOR.greenCustom;
    }
    

    @IBAction func actionForJoinContest(_ sender: Any) {
        if txtInviteCode.text?.trim().count == 0{
            self.view.showToast(message: "Please enter contest invite code.")
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContestDetailVC") as! ContestDetailVC
            vc.slug = txtInviteCode.text!;
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}
