//
//  ResetPasswordVC.swift
//  Snozer
//
//  Created by Admin on 30/09/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class ResetPasswordVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    var headerView: NavHeaderView?
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var lblDidntReceiveStmt: UILabel!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var lblStillNoEmailStmt: UILabel!
    @IBOutlet weak var lblCantFindStmt: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLinkToResetPasswordStmt: UILabel!
    var strMailId = "";
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp()
        self.setHeaderView();
        lblEmail.text = strMailId;
        self.callForSendEmail();
        // Do any additional setup after loading the view.
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "RESET PASSWORD");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    func setUp() {
        self.lblLinkToResetPasswordStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblLinkToResetPasswordStmt.font = UIFont(name: font_reguler, size: 14);
        self.lblEmail.textColor = APPCOLOR.TextBlackColor;
        self.lblEmail.font = UIFont(name: font_bold, size: 15);
        
        self.lblDidntReceiveStmt.textColor = APPCOLOR.redCustom;
        self.lblDidntReceiveStmt.font = UIFont(name: font_reguler, size: 12);
        btnResend.setTitleColor(APPCOLOR.redCustom, for: .normal);
        btnResend.titleLabel?.font = UIFont(name: font_bold, size: 15);
        lblCantFindStmt.textColor = APPCOLOR.TextGrayColor;
        lblCantFindStmt.font = UIFont(name: font_reguler, size: 11);
        lblStillNoEmailStmt.textColor = APPCOLOR.TextGrayColor;
        lblStillNoEmailStmt.font = UIFont(name: font_reguler, size: 11);
        
        btnContact.setTitleColor(APPCOLOR.redCustom, for: .normal);
        btnContact.titleLabel?.font = UIFont(name: font_bold, size: 11);
        vwBottom.setshadow(cornerR: 4, shadowC: .black, shadowO: 0.5, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1))
    }
    
    @IBAction func actionForResendEmailLink(_ sender: Any) {
        self.callForSendEmail();
    }
    
    func callForSendEmail() {
        UserService.resetPassword(["email" : strMailId]) { (flag, msg) in
            self.view.showToast(message: msg);
        }
    }
    
    @IBAction func actionForContact(_ sender: Any) {
    }

}
