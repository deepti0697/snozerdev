//
//  ChangePasswordVC.swift
//  Snozer
//
//  Created by Admin on 05/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class ChangePasswordVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    var headerView: NavHeaderView?
    
    
    @IBOutlet weak var txtOldPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtNewPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnChangePassword: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "CHANGE PASSWORD");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }

        
    func setUp() {
        btnChangePassword.backgroundColor = APPCOLOR.redCustom;
        btnChangePassword.titleLabel?.font = UIFont(name: font_bold, size: 16);
        btnChangePassword.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        btnChangePassword.cornerRadius = 6;
        
        for txt in [txtNewPassword, txtOldPassword, txtConfirmPassword] {
            txt?.placeholderColor = APPCOLOR.TextLightGrayColor;
            txt?.textColor = APPCOLOR.TextBlackColor;
            txt?.lineColor = APPCOLOR.TextLightGrayColor;
            txt?.selectedTitleColor = APPCOLOR.redCustom;
            txt?.selectedLineColor = APPCOLOR.TextBlackColor;
        }
        
    }
    
    @IBAction func actionForChangePassword(_ sender: Any) {
        self.updatePassword()
    }
    
    func updatePassword() {
        
        let oldP = txtOldPassword.text?.trim() ?? ""
        let newP = txtNewPassword.text?.trim() ?? ""
        let confirmNewP = txtConfirmPassword.text?.trim() ?? ""

        if oldP.count < 8 {
            self.view.showToast(message: "Password must be 8 characters long");
            return
        }
        
        if newP.count < 8 {
            self.view.showToast(message: "New Password must be 8 characters long");
            return
        }
        
        if newP != confirmNewP {
            
            self.view.showToast(message: "New Password and Confirm Password must be same.");
            return
        }
        
        var dict : [String:String] = [:]
        
        dict["old_password"] = oldP
        dict["password"] = newP
       
        UserService.changePassword(dict) { (flag, msg) in
            if flag{
                self.navigationController?.popViewController(animated: true)
            }
            self.view.showToast(message: msg);
        }
    }
}
