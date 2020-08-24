//
//  EditProfleVC.swift
//  Snozer
//
//  Created by Admin on 05/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class EditProfleVC: ViewController {
    
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    var headerView: NavHeaderView?

    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtFirstname: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtDob: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var txtAddress1: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtAddress2: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtCity: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtPinCode: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnUpdate: UIButton!
     @IBOutlet weak var btnMobileUpdate: UIButton!
     @IBOutlet weak var btnEmailUpdate: UIButton!
    
    var datePicker = UIDatePicker();
    var statePicker = UIPickerView();
    var stateId = "";
    var arrStates : [CommonDto] = [];
    var userInfo: UserData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
        self.getStateList();
      //  self.setProfileData();
        // Do any additional setup after loading the view.
    }
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "EDIT PROFILE");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callApiForProfile()
    }
    
    func callApiForProfile() {
        let api = APPURL.BaseURL + APPURL.CricketUrl + APPURL.GetProfile;
        UserService.getProfileInfo(api) { (flag, response, msg) in
            if flag{
                if let info = response{
                    self.userInfo = info;
                    appdelegate.objAccountInfo = info;
                    self.setProfileData();
                }
            }
        }
    }
    
    func setUp() {
        btnUpdate.backgroundColor = APPCOLOR.redCustom;
        btnUpdate.titleLabel?.font = UIFont(name: font_bold, size: 16);
        btnUpdate.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        btnUpdate.cornerRadius = 6;
        
        for txt in [txtEmail, txtMobile, txtFirstname, txtLastName, txtDob, txtAddress1, txtAddress2, txtState, txtCity, txtPinCode] {
            txt?.placeholderColor = APPCOLOR.TextLightGrayColor;
            txt?.textColor = APPCOLOR.TextBlackColor;
            txt?.lineColor = APPCOLOR.TextLightGrayColor;
            txt?.selectedTitleColor = APPCOLOR.redCustom;
            txt?.selectedLineColor = APPCOLOR.TextBlackColor;
            txt?.tintColor = APPCOLOR.TextBlackColor;
            txt?.textColor = APPCOLOR.TextBlackColor;
            txt?.font = UIFont(name: font_reguler, size: 11);
//            txt?.placeholderColor = UIColor(red: 185.0/255, green: 185.0/255, blue: 185.0/255, alpha: 1)
            txt?.placeholderFont = UIFont.init(name: font_reguler, size: 12)
        }
        
        datePicker.datePickerMode = .date;
        datePicker.maximumDate = Date();
        
        txtDob.inputView = datePicker;
        txtDob.addDoneOnKeyboardWithTarget(self, action: #selector(doneForDate));
        txtState.addDoneOnKeyboardWithTarget(self, action: #selector(doneForState));
        
        statePicker.dataSource = self;
        statePicker.delegate = self;
        txtState.inputView = statePicker;
        
	
        txtEmail.textColor = APPCOLOR.TextLightGrayColor;
        txtMobile.textColor = APPCOLOR.TextLightGrayColor;
    }
    
    func setProfileData() {
	
        btnEmailUpdate.isHidden = true
        btnMobileUpdate.isHidden = true
        
	if userInfo.email == ""{
        btnEmailUpdate.isHidden = false
		//txtEmail.isUserInteractionEnabled = true;
		//txtEmail.textColor = APPCOLOR.TextBlackColor;
	}
	
	if userInfo.phone == ""{
        btnMobileUpdate.isHidden = false
		//txtMobile.isUserInteractionEnabled = true;
		//txtMobile.textColor = APPCOLOR.TextBlackColor;
	}
	
        txtEmail.text = userInfo.email
        txtMobile.text = userInfo.phone
        txtFirstname.text = userInfo.firstname
        txtLastName.text = userInfo.lastname
        txtCity.text = userInfo.city?.name
        
        
        if userInfo.state != nil {
            txtState.text = userInfo.state?.name
            stateId = userInfo.state?.id ?? "0"
        }
    
        var dob = ""
        if userInfo.dob != "0" {
            dob = Double(userInfo.dob!)?.getDate("dd-MM-yyyy") ?? "";
        }
        
        txtDob.text = dob
        
        txtPinCode.text = userInfo.pincode
        txtAddress1.text = userInfo.addressline1
        txtAddress2.text = userInfo.addressline2
    }
    
    
    
    
    @objc func doneForDate(){
        txtDob.resignFirstResponder();
        txtDob.text = datePicker.date.toString(format: "dd-MM-yyyy");
    }
    
    @objc func doneForState(){
        txtState.resignFirstResponder();
        let index = statePicker.selectedRow(inComponent: 0);
        txtState.text = arrStates[index].name;
        stateId = arrStates[index].id;
        
    }
    
     @IBAction func actionMobileUpdate(_ sender: Any)
     {
       redirectTOKYC()
    }
    @IBAction func actionEmailUpdate(_ sender: Any)
    {
      redirectTOKYC()
    }
    
    func redirectTOKYC() {
        let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
        vc.comeFromProfile = true
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    
    @IBAction func actionForUpdate(_ sender: Any) {
	guard !txtEmail.text!.isBlank else {
            self.view.showToast(message: "Please enter your email address");
            return
        }
	
	guard !txtMobile.text!.isBlank else {
            self.view.showToast(message: "Please enter your mobile number");
            return
        }
	
	
	
        guard !txtFirstname.text!.isBlank else {
            self.view.showToast(message: "Please enter your First Name");
            return
        }
        
        
        guard !txtDob.text!.isBlank else {
            self.view.showToast(message: "Please enter your date of birth");
            return
        }
        
        guard !txtState.text!.isBlank else {
            self.view.showToast(message: "Please select your state");
            return
        }

        var dict = [String:String]()
        dict["firstname"] = txtFirstname.text
        dict["phone"] = txtMobile.text
        dict["country_mobile_code"] = "+91"
        dict["email"] = txtEmail.text
        dict["lastname"] = txtLastName.text
        dict["dob"] = String(self.getTimeStamp(str: txtDob.text!)) //txtDob.text
        dict["addressline1"] = txtAddress1.text
        dict["addressline2"] = txtAddress2.text
        dict["country"] = "1"
        dict["state"] = stateId
        dict["city"] = txtCity.text
        dict["pincode"] = txtPinCode.text
        
        ProfileService.UpdateUserProfile(params: dict) { (flag,response, msg) in
            if flag{
                if let info = response{
//			Utility.sharedInstance.saveUserInfo(info: info);
			appdelegate.objAccountInfo = info;
                }
                self.navigationController?.popViewController(animated: true);
            }else{
                
            }
            self.view.showToast(message: msg);
        }
    }
    
    func getTimeStamp(str:String) -> Int64{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.date(from: str){
            return Int64(date.timeIntervalSince1970)
        }else{
            return 0;
        }
    }
    
    
    func getStateList() {
    
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetStateList
        UserService.getStates(api, params: [:]) { (flag, response, msg) in
            if flag{
                self.arrStates = response;
                self.statePicker.reloadAllComponents();
            }
        }
    }
    
}

extension EditProfleVC : UIPickerViewDelegate, UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrStates.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrStates[row].name;
    }
}
