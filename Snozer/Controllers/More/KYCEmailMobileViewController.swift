//
//  KYCEmailMobileViewController.swift
//  Cricshot
//
//  Created by Cricshot on 04/04/19.
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import UIKit
import SVProgressHUD

class KYCEmailMobileViewController: ViewController, UITextFieldDelegate {
    
    @IBOutlet weak var vwMobileVerify: UIView!
    @IBOutlet weak var vwEmailVerify: UIView!
    @IBOutlet weak var vwEmailVerified: UIView!
    @IBOutlet weak var vwMobileVerified: UIView!
    @IBOutlet weak var btnMobileOtpSend: UIButton!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var lblMobileReceiveOtpStmt: UILabel!
    @IBOutlet weak var lblMobileVerifyStmt: UILabel!
    

    @IBOutlet weak var lblEmailVerifyStmt: UILabel!

    @IBOutlet weak var lblEmailAddressVerifiedStmt: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    
    @IBOutlet weak var lblMobileNumberVerifiedStmt: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    @IBOutlet weak var vwOtp: UIView!
    
    @IBOutlet weak var lblMobileOTP: UILabel!
    @IBOutlet weak var btnResendOTP: UIButton!
    var isOtpSend = false;
    
    var objAccInfo: UserData?
    @IBOutlet weak var txtOTP4: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP1: UITextField!
    
    
    var comeFromProfile1 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAccountInfo(notification:)), name: Notification.Name("updateAccountInfo"), object: nil)
        self.setUp();
    }
    
    
    func setUp() {
        
        txtMobile.placeholderColor = APPCOLOR.TextLightGrayColor;
        txtMobile.textColor = APPCOLOR.TextBlackColor;
        txtMobile.lineColor = APPCOLOR.TextLightGrayColor;
        txtMobile.selectedTitleColor = APPCOLOR.redCustom;
        txtMobile.selectedLineColor = APPCOLOR.TextBlackColor;
        txtMobile.tintColor = APPCOLOR.TextBlackColor;
        txtMobile.textColor = APPCOLOR.TextBlackColor;
        txtMobile.font = UIFont(name: font_reguler, size: 11);
//      txtMobile  txt?.placeholderColor = UIColor(red: 185.0/255, green: 185.0/255, blue: 185.0/255, alpha: 1)
        txtMobile.placeholderFont = UIFont.init(name: font_reguler, size: 12)
        
        vwEmailVerify.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: 1, height: 3));
        vwMobileVerify.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: 1, height: 3));
        
        vwEmailVerified.setshadow(cornerR: 6, shadowC: APPCOLOR.greenCustom, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: -1, height: 2));
        vwMobileVerified.setshadow(cornerR: 6, shadowC: APPCOLOR.greenCustom, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: -1, height: 2));

        btnMobileOtpSend.backgroundColor = APPCOLOR.redCustom;
        btnMobileOtpSend.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal)
        btnMobileOtpSend.titleLabel?.font = UIFont(name: font_reguler, size: 15);
        for textField in [txtOTP1, txtOTP2, txtOTP3, txtOTP4] {
            textField?.keyboardType = .phonePad
            textField?.delegate = self;
            textField?.textAlignment = .center;
            textField?.font = UIFont(name: font_reguler, size: 11);
            textField?.attributedPlaceholder = NSAttributedString(string: "-",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: APPCOLOR.TextGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_reguler, size: 12)!])
            textField?.cornerRadius = 4;
            textField?.borderWidth = 1;
            textField?.borderColor = APPCOLOR.TextLightGrayColor;
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
//                if textField == txtOTP4{
//                    self.btnVerify_Clicked();
//                }
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.endEditing(true)
        
        setData()
    }
    
    func setData() {
        objAccInfo = appdelegate.objAccountInfo
        guard let obj = objAccInfo else {
            return
        }
        
        vwMobileVerify.isHidden = true;
        vwEmailVerify.isHidden = true;
        
        if obj.isPhoneVerified == "Y"{
            lblMobileNumber.text = "+91 " + (obj.phone ?? "");
        }else{
            vwMobileVerified.isHidden = true;
            vwMobileVerify.isHidden = false;
        }
        
        if obj.isEmailVerified == "Y"{
            lblEmailAddress.text = obj.email ?? "";
        }else{
            vwEmailVerified.isHidden = true;
            vwEmailVerify.isHidden = false;
        }
        
        
        
    }
    
    // Removing notification for self when class is deallocated.
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateAccountInfo"), object: nil)
    }
    
    // MARK: - Action Methods
    
    @objc func updateAccountInfo(notification: Notification) {
        
        objAccInfo = (notification.userInfo!["AccountInfo"] as! UserData)
        setData()
    }
    @IBAction func actionForMobileVerify(_ sender: Any) {
        if isOtpSend{
            self.btnVerify_Clicked()
        }else{
            if txtMobile.text!.trim().count > 0{
                self.callApiForOTPSend()
            }else{
                self.view.showToast(message: "Please enter mobile number");
            }
        }
        
    }
    
    @IBAction func actionForEmailVerify(_ sender: Any) {
        
        if let info = appdelegate.objAccountInfo{
            if info.email != nil{
                UserService.VerifyEmail(APPURL.VerifyEmail, ["email" : info.email!, "is_social":"N"]) { (flag, msg) in
                    if flag{
                        if self.comeFromProfile1{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    self.view.showToast(message: msg);
                }
            }
        }
        
    }
    
    @IBAction func actionForSendOTPAgain(_ sender: Any) {
        self.isOtpSend = false;
        self.vwOtp.isHidden = true;
        self.btnMobileOtpSend.setTitle("SEND OTP", for: .normal);
    }

    func callApiForOTPSend() {
        let api = APPURL.OtpSend
        UserService.otpSend(api, params: ["country_mobile_code" : "+91", "phone":txtMobile.text!]) { (flag, response, msg) in
            if flag{
                self.isOtpSend = true;
                self.vwOtp.isHidden = false;
                self.lblMobileOTP.text = self.txtMobile.text!;
                self.btnMobileOtpSend.setTitle("VERIFY", for: .normal);
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    func btnVerify_Clicked() {
        if txtOTP1.text?.isEmpty != true || txtOTP2.text?.isEmpty != true || txtOTP3.text?.isEmpty != true || txtOTP4.text?.isEmpty != true {
            
            self.VerifyOTP_API()
        }else{
            self.view.showToast(message: "Please enter a valid OTP");
        }
    }
    
    func VerifyOTP_API() {
        txtOTP4.resignFirstResponder()
        let otp = String("\(self.txtOTP1.text!)\(self.txtOTP2.text!)\(self.txtOTP3.text!)\(self.txtOTP4.text!)")
        var headersParam = [String : String]()
        let APIURL = APPURL.VerifyMobile
        headersParam = [
            "otp": otp,
            "type" : "SP",
            "country_mobile_code" : kCounrtyCode,
            "phone": txtMobile.text!
        ]
        
        Common.sharedInstance.printMsg(headersParam);
        
        UserService.otpVerify(APIURL, params: headersParam) { (flag, response, msg) in
            if flag{
                self.vwMobileVerify.isHidden = true;
                self.vwMobileVerified.isHidden = false;
                self.lblMobileNumber.text = self.txtMobile.text!;
                
                if self.comeFromProfile1{
                    self.navigationController?.popViewController(animated: true)
                }
                
            }else{
                self.view.showToast(message: msg);
            }
            
            
        }
    }

}

