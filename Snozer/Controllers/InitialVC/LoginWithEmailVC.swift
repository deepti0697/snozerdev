//
//  LoginWithEmailVC.swift
//  Snozer
//
//  Created by Admin on 30/09/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class LoginWithEmailVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    var headerView : NavHeaderView?
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var vwTxtPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSecure: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var lblLoginStmt: UILabel!
    @IBOutlet weak var lblUsingMobileStmt: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    
    var emailId = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
	layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64;
        self.setHeaderView();
        self.lblEmail.text = emailId;
        self.setUp();
        // Do any additional setup after loading the view.
    }
    
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "LOG IN");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    func setUp() {
        self.vwContainer.borderColor = APPCOLOR.TextLightGrayColor;
        self.vwContainer.borderWidth = 1.0;
        self.vwContainer.cornerRadius = 4;
        lblEmailTitle.textColor = APPCOLOR.redCustom;
        lblEmailTitle.font = UIFont(name: font_medium
            , size: 15);
        lblEmail.textColor = APPCOLOR.TextBlackColor;
        lblEmail.font = UIFont(name: font_medium
            , size: 15);
        
        vwTxtPassword.setshadow(cornerR: 4, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        txtPassword?.font = UIFont(name: font_reguler, size: 11);
        
        txtPassword?.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: AppPlaceholderColor, NSAttributedString.Key.font: UIFont.init(name: font_reguler, size: 11)!])
        txtPassword.textColor = APPCOLOR.TextBlackColor;
        
        btnLogin.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        btnLogin.titleLabel?.font = UIFont(name: font_bold, size: 14);
        self.btnLogin.cornerRadius = 4;
        self.btnLogin.clipsToBounds = true
        btnForgotPassword.setTitleColor(APPCOLOR.redCustom, for: .normal);
        btnForgotPassword.titleLabel?.font = UIFont(name: font_bold, size: 14);
        lblLoginStmt.textColor = APPCOLOR.redCustom;
        lblUsingMobileStmt.textColor = APPCOLOR.TextBlackColor;
        
        lblUsingMobileStmt.font = UIFont(name: font_reguler, size: 14);
        lblLoginStmt.font = UIFont(name: font_medium, size: 14);
    }
    
    
    @IBAction func actionForSecure(_ sender: Any) {
        btnSecure.isSelected = !btnSecure.isSelected;
        txtPassword.isSecureTextEntry = btnSecure.isSelected
    }
    
    
    @IBAction func actionForLogin(_ sender: Any) {
            
        if txtPassword.text!.isBlank{
            self.view.showToast(message: "Please enter password");
        } else{
            UserService.appLogin(["email":emailId, "password" : txtPassword.text!]) { (flag, response, msg) in
                if flag{
                    if let user = response{
                        appdelegate.objAccountInfo = user;
                        Utility.sharedInstance.saveUserInfo(info: user);
                        Utility.sharedInstance.save(object: user.slug!, key: kAuthExpire);
                        Utility.sharedInstance.save(object: true, key: kIsAutoLogin)
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let TabVC: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                        TabVC.selectedIndex = 0
                        UIApplication.shared.windows.first?.rootViewController = TabVC
                    }
                }else{
                    self.view.showToast(message: msg);
                }
            }
        }
        
        
        
    }
    @IBAction func actionForForgotPassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ResetPasswordVC
        vc.strMailId = emailId;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func actionForMobileLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
}
