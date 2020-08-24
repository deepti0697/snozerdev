//
//  LandingVC.swift
//  Snozer
//
//  Created by Admin on 28/09/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import SVProgressHUD
import AuthenticationServices


class LandingVC: ViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    var headerView : NavHeaderView?
    @IBOutlet weak var lblNotAMemberStmt: UILabel!
    @IBOutlet weak var lblRegisterStmt: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtEmailMobile: UITextField!
    @IBOutlet weak var vwTxtEmail: UIView!
    @IBOutlet weak var lblLoginWithFacebookStmt: UILabel!
    @IBOutlet weak var lblLoginWithGoogleStmt: UILabel!
    @IBOutlet weak var lblLoginWithAppleStmt: UILabel!
    @IBOutlet weak var vwFacebook: UIView!
    @IBOutlet weak var vwGoogle: UIView!
    @IBOutlet weak var vwApple: UIView!
    
    @IBOutlet weak var AppleLoginBtn: UIButton!
    @IBOutlet weak var vwApple2: UIView!
    @IBOutlet weak var imgFacebook: UIImageView!
	@IBOutlet weak var imgGoogle: UIImageView!
    @IBOutlet weak var imgApple: UIImageView!
    @IBOutlet weak var AppliLoginBtn: UIButton!
    var strSocialLoginType = "";
    var inputType = "";
    var gmailId = "";
    var userName = "";
    var SocialEmail = "";
    var facebookId = "";
    var appleId = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Landing VC");
	
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64;
	
        self.setHeaderView()
        self.setUp();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.SocialMediaLinksAlignment()
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        headerView?.btnBack.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "LOG IN");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    func setUp(){
		
		let templateImage = imgFacebook.image?.withRenderingMode(.alwaysTemplate)
		imgFacebook.image = templateImage
		imgFacebook.tintColor = APPCOLOR.TextWhiteColor
		
		let templateImage1 = imgGoogle.image?.withRenderingMode(.alwaysTemplate)
		imgGoogle.image = templateImage1
		imgGoogle.tintColor = APPCOLOR.TextWhiteColor
		
        vwTxtEmail.setshadow(cornerR: 2, shadowC: .black, shadowO: 0.4, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        
        
        txtEmailMobile?.font = UIFont(name: font_reguler, size: 11);
        
        txtEmailMobile?.attributedPlaceholder = NSAttributedString(string: "Email or Mobile Number",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: APPCOLOR.TextGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_reguler, size: 11)!])
        txtEmailMobile.textColor = APPCOLOR.TextBlackColor;
        btnNext.setTitleColor(APPCOLOR.TextBlackColor, for: .normal);
        btnNext.titleLabel?.font = UIFont(name: font_reguler, size: 14);
        btnNext.backgroundColor = APPCOLOR.YellowCustom;
//        btnNext.setButtonShadow(color: APPCOLOR.YellowCustom);
        
        lblLoginWithFacebookStmt.font = UIFont(name: font_reguler, size: 14);
        lblLoginWithGoogleStmt.font = UIFont(name: font_reguler, size: 14);
        lblLoginWithGoogleStmt.textColor = APPCOLOR.TextWhiteColor;
        lblLoginWithFacebookStmt.textColor = APPCOLOR.TextWhiteColor;
//        vwFacebook.setButtonShadow(color: APPCOLOR.BlueTintCustom);
        
        lblNotAMemberStmt.textColor = APPCOLOR.TextGrayColor;
        lblRegisterStmt.textColor = APPCOLOR.redCustom;
        lblNotAMemberStmt.font = UIFont(name: font_reguler, size: 14);
        lblRegisterStmt.font = UIFont(name: font_medium, size: 14);
//        vwGoogle.setButtonShadow(color: APPCOLOR.redCustom);
        
    }
    
    func SocialMediaLinksAlignment()
    {
        let countryLocale = NSLocale.current
        var countryCode = "";
        if(countryLocale.regionCode != nil)
        {
            countryCode = countryLocale.regionCode!
        }
        print("Co: \(countryCode)")
        
        self.vwGoogle.isHidden = false;
        self.vwGoogle.isHidden = false;
        self.AppleLoginBtn.isHidden = true;
        
        if(countryCode != "IN")
        {
            if #available(iOS 13.0, *)
            {
                self.AppleLoginBtn.isHidden = false;
                let authorizationButton = ASAuthorizationAppleIDButton()
                authorizationButton.translatesAutoresizingMaskIntoConstraints = false
                authorizationButton.addTarget(self, action: 	#selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
                
                AppleLoginBtn.addSubview(authorizationButton)
                NSLayoutConstraint.activate([
                    authorizationButton.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1),
                    authorizationButton.heightAnchor.constraint(equalToConstant: 40),
                    authorizationButton.widthAnchor.constraint(equalToConstant: self.vwFacebook.frame.size.width)
                       ])
                        
            } else {
                // Fallback on earlier versions
                self.AppleLoginBtn.isHidden = true;
            }
        }
        
    }
    
    @objc private func handleLogInWithAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            strSocialLoginType = "Apple"
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
                
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    //Apple Logi
    @IBAction func actionForApple(_ sender: Any) {
       
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        if #available(iOS 13.0, *) {
            let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
            // Create an authorization controller with the given requests.
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle error here
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        print("Cred 1: \(authorization)")
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            self.appleId = "";
            self.userName = "";
            self.SocialEmail = "";
            
            //Apple ID
            let userIdentifier = appleIDCredential.user
            self.appleId = userIdentifier
            
            //User Name
            var userFirstName = "";
            if(appleIDCredential.fullName?.givenName != nil)
            {
                userFirstName = "\(appleIDCredential.fullName!.givenName!)"
            }
            
            var userLastName = "";
            if(appleIDCredential.fullName?.familyName != nil)
            {
                userLastName = "\(appleIDCredential.fullName!.familyName!)"
            }
            
            var UserFullName = "\(userFirstName) \(userLastName)"
            UserFullName = UserFullName.trim();
            if(UserFullName.count == 0)
            {
                self.userName = "\(self.appleId)"
            }
            else
            {
                self.userName = UserFullName
            }
            
            Common.sharedInstance.printMsg(self.userName)
            
            print("Cred: \(appleIDCredential)")
            print("Add ID:\(self.appleId)")
            print("User Name: \(self.userName)")
            
            let userEmail = appleIDCredential.email
            if(userEmail != nil)
            {
                self.SocialEmail = userEmail!
            }
            Common.sharedInstance.printMsg(self.SocialEmail)
            
            
            print("Email: \(self.SocialEmail)")
            if(self.SocialEmail.count == 0)
            {
                self.SocialEmail = "\(userFirstName)"
            }
        
            self.callForSocialLogin();
            
            //Navigate to other view controller
        } else {
            
        }
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @IBAction func actionForNext(_ sender: Any) {
        var userName = txtEmailMobile.text!;
        if txtEmailMobile.text!.isBlank{
            self.view.showToast(message: "Please enter email and mobile number.");
            return;
        } else{
            
            if txtEmailMobile.text!.isEmail{
                self.inputType = "E";
            } else if txtEmailMobile.text!.isPhoneNumber{
                self.inputType = "M";
                userName = "+91" + userName
            } else{
                self.view.showToast(message: "Please enter valid email or mobile number");
                return;
            }
        }
        
        UserService.checkUserStatus(["type" : self.inputType, "username" : userName]) { (flag,response, msg) in
            if flag{
                if self.inputType == "E"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginWithEmailVC") as! LoginWithEmailVC
                    vc.emailId = self.txtEmailMobile.text!;
                    self.navigationController?.pushViewController(vc, animated: true);
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtpVerifyVC") as! OtpVerifyVC
                    vc.strMobileNumber = self.txtEmailMobile.text!
                    vc.dict = response as! [String : String];
                    vc.strComeFrom = "LoginOtp"
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    @IBAction func actionForFaceBook(_ sender: Any) {
        
//        self.view.showToast(message: "Need facebook developer account");
        
        
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
//        self.view.showToast(message: "Need google developer account");
        strSocialLoginType = "Gmail"
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.delegate = self;
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func actionForRedirectRegister(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC");
        self.navigationController?.pushViewController(vc!, animated: true);
    }
    
    func callForSocialLogin() {
    
        var dict : [String : String] = [:];
        if strSocialLoginType == "Gmail"{
		dict = ["email":self.SocialEmail,"social_type": "G","firstname": self.userName, "social_id" : gmailId];
        }
        else if strSocialLoginType == "Facebook"{
        dict = ["Email":self.SocialEmail,"social_type": "F", "firstname" : self.userName, "social_id" : self.facebookId];
        }
        else{
            
		dict = ["Email":self.SocialEmail,"social_type": "A", "firstname" : self.userName, "social_id" : self.appleId];
        }
        self.socialSignUpAPI(headersParam: dict)
    }
    
    func socialSignUpAPI(headersParam : [String : String]) {
        
        let baseURL : String = APPURL.SocialLogin
        UserService.socialSignUpAPI(baseURL, params: headersParam) { (flag, response, msg) in
            if flag{
                if let user = response{
                    Utility.sharedInstance.saveUserInfo(info: user);
                    appdelegate.objAccountInfo = user;
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


extension LandingVC : GIDSignInDelegate{
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
