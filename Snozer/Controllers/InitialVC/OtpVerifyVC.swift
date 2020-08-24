//
//  OtpVerifyVC.swift
//  Snozer
//
//  Created by Admin on 30/09/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import SVProgressHUD

class OtpVerifyVC: ViewController, UITextFieldDelegate {
    
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    var headerView : NavHeaderView?
    @IBOutlet weak var ViewOTP: UIView!
    @IBOutlet weak var txtOTP4: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP1: UITextField!
    @IBOutlet weak var lblResentOtpStmt: UILabel!
    @IBOutlet weak var lblEnterOtp: UILabel!

    @IBOutlet weak var lblTitle: UILabel!
    var strComeFrom = "";
    @IBOutlet weak var btnSendotp: UIButton!
    
    var timer = Timer()
    var count = 59
    var strMobileNumber = String()
    var dict : [String : String] = [:]
    
    /////---Modeal Varaible----/////
    var objLoginModel: UserData!

    override func viewDidLoad(){
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64;
        self.setHeaderView();
        self.btnSendotp.isUserInteractionEnabled = false
        lblTitle.text = "OTP sent to \(strMobileNumber)"
        self.count = 59
        self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        self.setUp();
        //self.SendOTP_API();
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "VERIFY OTP");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    
    func setUp() {
        
        lblResentOtpStmt.text = "Didn't receive the OTP? Request for a new one in";
        lblTitle.font = UIFont(name: font_medium, size: 16);
        lblResentOtpStmt.font = UIFont(name: font_reguler, size: 11);
        btnSendotp.titleLabel?.font = UIFont(name: font_medium, size: 12);
        lblEnterOtp.font = UIFont(name: font_reguler, size: 15);
        
        self.lblTitle.textColor = APPCOLOR.TextBlackColor;
        self.lblEnterOtp.textColor = APPCOLOR.TextBlackColor;
        self.btnSendotp.setTitleColor(APPCOLOR.redCustom, for: .normal);
        self.btnSendotp.setTitle("59 Seconds", for: .normal);
//        self.changeLabelAlpha(0.3)
        
        for textField in [txtOTP1, txtOTP2, txtOTP3, txtOTP4] {
            textField?.delegate = self;
            textField?.textAlignment = .center;
            textField?.font = UIFont(name: font_reguler, size: 11);
            textField?.attributedPlaceholder = NSAttributedString(string: "-",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: APPCOLOR.TextGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_reguler, size: 12)!])
            textField?.cornerRadius = 4;
            textField?.borderWidth = 1;
            textField?.borderColor = APPCOLOR.TextLightGrayColor;
            textField?.keyboardType = .numberPad
        }
    }
    
    // MARK: - Textfield Delegates
    
    func textFieldShouldReturnSingle(_ textField: UITextField , newString : String)
    {
        let nextTag: Int = textField.tag + 1
        let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
        
        if newString.utf16.count == 1 {
            textField.text = newString
            
            if let nextR = nextResponder {
                // Found next responder, so set it.
                nextR.becomeFirstResponder()
            } else {
                // Not found, so remove keyboard.
                textField.resignFirstResponder()
                
                if textField == txtOTP4{
                    self.btnVerify_Clicked();
                }
            }
        } else if newString.utf16.count == 0 {
            
            textField.text = ""
            switch textField{
            case txtOTP1:
                txtOTP1.becomeFirstResponder()
            case txtOTP2:
                txtOTP1.becomeFirstResponder()
            case txtOTP3:
                txtOTP2.becomeFirstResponder()
            case txtOTP4:
                txtOTP3.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        
        let newString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        let newLength = newString.count
        
        if newLength == 1 {
            textFieldShouldReturnSingle(textField , newString : newString)
            return false
        } else if newLength == 0 {
            textFieldShouldReturnSingle(textField , newString : "")
            return false
        } else {
            switch textField{
            case txtOTP1:
                txtOTP2.becomeFirstResponder()
                txtOTP2.text = string
            case txtOTP2:
                txtOTP3.becomeFirstResponder()
                txtOTP3.text = string
            case txtOTP3:
                txtOTP4.becomeFirstResponder()
                txtOTP4.text = string
            case txtOTP4:
                txtOTP4.resignFirstResponder()
            default:
                break
            }
            return false
            
        }
    }
    // MARK: - Button Methods
    @IBAction func btnSendOtpClick(_ sender: Any) {
            self.SendOTP_API()
    }
    
    func btnVerify_Clicked() {
        if txtOTP1.text?.isEmpty != true || txtOTP2.text?.isEmpty != true || txtOTP3.text?.isEmpty != true || txtOTP4.text?.isEmpty != true {
            self.VerifyOTP_API()
        }else{
            self.view.showToast(message: "Please enter a valid OTP");
        }
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: - Timer update Methods
    
    @objc func updateCounter() {
        
        if(count > 0) {
            btnSendotp.setTitle("00:" + String(count), for: .normal)
            count-=1
        } else if(count == 0) {
            lblResentOtpStmt.text =  "Didn't receive the OTP?"
            btnSendotp.setTitle("Resend OTP", for: .normal)
            self.btnSendotp.isUserInteractionEnabled = true
            self.timer.invalidate()
        }
    }
    
    // MARK: - API Methods
    func SendOTP_API() {
        if strComeFrom == "LoginOtp"{
            UserService.checkUserStatus(["type" : "M", "username":"+91\(strMobileNumber)"]) { (flag, response, msg) in
                self.btnSendotp.isUserInteractionEnabled = false
                self.count = 59
                self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
            }
        }else{
            UserService.register(self.dict) { (flag, response, msg) in
                self.btnSendotp.isUserInteractionEnabled = false
                self.count = 59
                self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
            }
        }
        
//        UserService.otpSend(APIURL, params: ["country_mobile_code":kCounrtyCode, "phone":strMobileNumber]) { (flag, otp, msg) in
//            if flag{
//                self.view.showToast(message: "Please this OTP for mobile verify \(otp)");
//                self.btnSendotp.isUserInteractionEnabled = false
//                self.count = 59
//                self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
//            }else{
//                self.view.showToast(message: msg);
//            }
//        }
    }
    
    @IBAction func actionForVerify(_ sender: Any) {
        self.btnVerify_Clicked();
    }
    
    func VerifyOTP_API() {
        txtOTP4.resignFirstResponder()
        let otp = String("\(self.txtOTP1.text!)\(self.txtOTP2.text!)\(self.txtOTP3.text!)\(self.txtOTP4.text!)")
        var headersParam = [String : String]()
        let APIURL = APPURL.OTPVerificationAPI
        headersParam = [
            "otp": otp,
            "type" : strComeFrom == "LoginOtp" ? "L" : "V",
            "country_mobile_code" : kCounrtyCode,
            "phone": strMobileNumber
        ]
        
        Common.sharedInstance.printMsg(headersParam);
        
        
        
        UserService.otpVerify(APIURL, params: headersParam) { (flag, response, msg) in
            
//            Utility.sharedInstance.save(object: true, key: kIsAutoLogin)
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            let TabVC: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
//            TabVC.selectedIndex = 0
//            UIApplication.shared.windows.first?.rootViewController = TabVC
            
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
