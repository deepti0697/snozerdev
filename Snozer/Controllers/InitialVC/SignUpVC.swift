//
//  SignUpVC.swift
//  Snozer
//
//  Created by Admin on 30/09/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import SVProgressHUD


class SignUpVC: ViewController {
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	
    @IBOutlet weak var vwHeader: UIView!
    var headerView: NavHeaderView?
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwFacebook: UIView!
    @IBOutlet weak var vwGoogle: UIView!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var lblOrStmt: UILabel!
    @IBOutlet weak var vwMobile: UIView!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblOtpStmt: UILabel!
    @IBOutlet weak var lblSpamStmt: UILabel!
    @IBOutlet weak var vwName: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblNameStmt: UILabel!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var txtpassword: UITextField!
    
    @IBOutlet weak var btnPassword: UIButton!
    
    @IBOutlet weak var vwReferral: UIView!
    @IBOutlet weak var txtReferral: UITextField!
    
    @IBOutlet weak var lblPasswordStmt: UILabel!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblAgreeStmt: UILabel!
    @IBOutlet weak var lblTNCStmt: UILabel!
    @IBOutlet weak var lblAlreadyStmtt: UILabel!
    @IBOutlet weak var lblLoginStmt: UILabel!
    
    var strSocialLoginType = "";
    var gmailId = "";
    var userName = "";
    var SocialEmail = "";
    var facebookId = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64;
        self.setUp();
        self.setHeaderView();
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "REGISTER & PLAY");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    func setUp() {
        self.vwContainer.borderColor = APPCOLOR.TextGrayColor;
        self.vwContainer.borderWidth = 1;
        self.vwContainer.cornerRadius = 4;
        
        for vw in [vwMobile, vwEmail, vwName, vwPassword, vwReferral]{
                vw?.borderColor = APPCOLOR.TextLightGrayColor;
                vw?.borderWidth = 1;
                vw?.cornerRadius = 4;
        }
        
        vwFacebook.borderWidth = 1;
        vwGoogle.borderWidth = 1;
        
        vwFacebook.borderColor = APPCOLOR.TextGrayColor;
        vwGoogle.borderColor = APPCOLOR.TextGrayColor;
        
        vwFacebook.cornerRadius = 4;
        vwGoogle.cornerRadius = 4;
        
        btnRegister.cornerRadius = 4;
        
        for txt in [txtEmail, txtMobile, txtName, txtReferral, txtpassword]{
            txt?.font = UIFont(name: font_reguler, size: 11);
            txt?.textColor = APPCOLOR.TextBlackColor;
        }
        
        for lbl in [lblOtpStmt, lblSpamStmt, lblNameStmt, lblPasswordStmt]{
            lbl?.font = UIFont(name: font_reguler, size: 9);
            lbl?.textColor = APPCOLOR.TextBlackColor;
        }
        
        lblFacebook.font = UIFont(name: font_reguler, size: 14);
        lblGoogle.font = UIFont(name: font_reguler, size: 14);
        
        lblFacebook.textColor = APPCOLOR.TextBlackColor;
        lblGoogle.textColor = APPCOLOR.TextBlackColor;
        lblOrStmt.font = UIFont(name: font_reguler, size: 18);
        lblOrStmt.textColor = APPCOLOR.TextBlackColor;
        
        btnRegister.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        btnRegister.backgroundColor = APPCOLOR.redCustom;
        btnRegister.titleLabel?.font = UIFont(name: font_bold, size: 14);
        
        lblAgreeStmt.font = UIFont(name: font_reguler, size: 12);
        lblTNCStmt.font = UIFont(name: font_bold, size: 12);
        
        lblAgreeStmt.textColor = APPCOLOR.TextBlackColor;
        lblTNCStmt.textColor = APPCOLOR.redCustom;
        
        lblAlreadyStmtt.font = UIFont(name: font_reguler, size: 12);
        lblLoginStmt.font = UIFont(name: font_bold, size: 12);
        
        lblAlreadyStmtt.textColor = APPCOLOR.TextBlackColor;
        lblLoginStmt.textColor = APPCOLOR.redCustom;
        
        
        
    }
    
    
    
    
    
    @IBAction func actionForFacebook(_ sender: Any) {
        strSocialLoginType = "Facebook"
                    
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions.contains("email")) {
//                    fbLoginManager.logOut();
                    self.getFBUserData();
                }
            }else{
                self.view.showToast(message: kErrorServerNotRespond);
            }
        }
    }
        
    func getFBUserData(){
           if(AccessToken.current != nil){
               GraphRequest(graphPath: "me", parameters:  ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start { (connection, result, error) in
                   if (error == nil){
                       if let dict = result as? [String : AnyObject]{
                           Common.sharedInstance.printMsg(dict)
                           self.SocialEmail = dict["email"] as? String ?? "";
                           self.userName = dict["name"] as? String ?? "";
                           self.facebookId = dict["id"] as? String ?? "";
                           self.callForSocialLogin()
                       } else{
                           self.view.showToast(message: kErrorServerNotRespond, duration: 2);
                       }
                   }else{
                       self.view.showToast(message: kErrorServerNotRespond, duration: 2);
                   }
               }
           }
       }
    
    @IBAction func actionForGoogle(_ sender: Any) {
        strSocialLoginType = "Gmail"
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.delegate = self;
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func actionForSecurePassword(_ sender: Any) {
        btnPassword.isSelected = !btnPassword.isSelected;
        txtpassword.isSecureTextEntry = btnPassword.isSelected;
    }
    
    @IBAction func actionForRegistration(_ sender: Any) {
        if validation() == ""{
            let dict = ["firstname" : txtName.text!.trim(), "country_mobile_code" : kCounrtyCode, "phone" : txtMobile.text!.trim(), "email" : txtEmail.text!.trim(), "password" : txtpassword.text!.trim(), "referral_code" : txtReferral.text!.trim()]
            UserService.register(dict) { (flag, response, msg) in
                if flag{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtpVerifyVC") as! OtpVerifyVC
                    vc.strMobileNumber = self.txtMobile.text!
                    vc.dict = dict;
                    self.navigationController?.pushViewController(vc, animated: true);
                }else{
                    self.view.showToast(message: msg);
                }
            }
        }else{
            self.view.showToast(message: validation());
        }
    }
    
    @IBAction func actionForTermAndCondition(_ sender: Any) {
        let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "MyWebVC") as! MyWebVC
        vc.navtitle = "Term of Services"
        vc.slugname = "tnc"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionForLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
    func validation() -> String {
        var msg = "";
        if txtMobile.text!.isBlank{
            msg = "Please enter mobile number.";
        } else if !txtMobile.text!.isPhoneNumber{
            msg = "Please enter valid mobile number.";
        } else if txtEmail.text!.isBlank{
            msg = "Please enter email address.";
        } else if !txtEmail.text!.isEmail{
            msg = "Please enter valid email address.";
        } else if txtName.text!.isBlank{
            msg = "Please enter your full name.";
        } else if txtpassword.text!.isBlank{
            msg = "Please enter password.";
        } else if !txtpassword.text!.isPasswordValid{
            msg = "Password must be 8 characters digit, one number and one special character.";
        }
        return msg
    }
    
    
    func callForSocialLogin() {
            var dict : [String : String] = [:];
            if strSocialLoginType == "Gmail"{
                dict = ["email":self.SocialEmail,"social_type": "G","firstname": self.userName];
            }else{
                dict = ["Email":self.SocialEmail,"social_type": "F", "firstname" : self.userName];
            }
            self.socialSignUpAPI(headersParam: dict)
        }
        
        func socialSignUpAPI(headersParam : [String : String]) {
            let baseURL : String = APPURL.SocialLogin
            UserService.socialSignUpAPI(baseURL, params: headersParam) { (flag, response, msg) in
                if flag{
                    if let user = response{
                        appdelegate.objAccountInfo = user;
                        Utility.sharedInstance.saveUserInfo(info: user);
                        Utility.sharedInstance.save(object: user.slug!, key: kAuthExpire);
                        Utility.sharedInstance.save(object: "Social", key: kUserType);
                        Utility.sharedInstance.save(object: true, key: kIsAutoLogin)
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let TabVC: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                        TabVC.selectedIndex = 0
                        UIApplication.shared.windows.first?.rootViewController = TabVC
                    }
                else{
                    self.view.showToast(message: msg)
                }
            }
        }
        }
    
}
extension SignUpVC : GIDSignInDelegate{
    //MARK:Google SignIn Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            self.gmailId = user.userID
            self.userName = user.profile.name
            self.SocialEmail = user.profile.email
            Common.sharedInstance.printMsg(self.userName)
            Common.sharedInstance.printMsg(self.SocialEmail)
            self.callForSocialLogin();
        } else {
            
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        //SignOut
        if error != nil {
            //handle error
            // print(err)
        }
    }
    
}
