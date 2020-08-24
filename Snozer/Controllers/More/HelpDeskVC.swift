//
//  HelpDeskVC.swift
//  Snozer
//
//  Created by Admin on 03/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class HelpDeskVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblCaptcha: UILabel!
    @IBOutlet weak var txtCaptch: UITextField!
    @IBOutlet weak var lblHumanVerfication: UILabel!
    @IBOutlet weak var txtHelpDesk: UITextView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var txtSelectQuery: UITextField!
    @IBOutlet weak var lblQuerySttm: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblNameStmt: UILabel!
    @IBOutlet weak var lblEmailAddressStmt: UILabel!
    @IBOutlet weak var lblEnterYourDetailStmt: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var vwCaptch: UIView!
    var headerView: NavHeaderView?
    let arr: String = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@#!%*"
    
    var currentCaptcha = ""
    
    var categoryPicker = UIPickerView();
    
    var arrCat = ["Select Category", "How to play", "Withdraw Cash", "Technical", "Others"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setHeaderView();
        self.setUp();
        self.reloadCaptcha();
        
        
    }
    
    func setUp() {
        self.lblEnterYourDetailStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblEnterYourDetailStmt.font = UIFont(name: font_reguler, size: 16);
        self.lblEmailAddressStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblEmailAddressStmt.font = UIFont(name: font_reguler, size: 16);
        self.lblNameStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblNameStmt.font = UIFont(name: font_reguler, size: 16);
        self.lblQuerySttm.textColor = APPCOLOR.TextBlackColor;
        self.lblQuerySttm.font = UIFont(name: font_reguler, size: 16);
        self.lblMsg.textColor = APPCOLOR.TextBlackColor;
        self.lblMsg.font = UIFont(name: font_reguler, size: 16);
        self.lblHumanVerfication.textColor = APPCOLOR.TextBlackColor;
        self.lblHumanVerfication.font = UIFont(name: font_reguler, size: 16);
        
        self.txtName.font = UIFont(name: font_reguler, size: 15)
        self.txtEmail.font = UIFont(name: font_reguler, size: 15)
        self.txtSelectQuery.font = UIFont(name: font_reguler, size: 15)
        self.txtHelpDesk.font = UIFont(name: font_reguler, size: 15)
        self.txtCaptch.font = UIFont(name: font_reguler, size: 15)
        
        self.txtName.textColor = APPCOLOR.TextGrayColor
        self.txtEmail.textColor = APPCOLOR.TextGrayColor
        self.txtSelectQuery.textColor = APPCOLOR.TextGrayColor
        self.txtHelpDesk.textColor = APPCOLOR.TextGrayColor
        self.txtCaptch.textColor = APPCOLOR.TextGrayColor
		self.txtHelpDesk.backgroundColor = .white;
        
        if let info = Utility.sharedInstance.getUserInfo(){
            txtEmail.text = info.email ?? "";
            txtName.text = info.firstname + info.lastname;
        }
        txtSelectQuery.inputView = categoryPicker;
        categoryPicker.delegate = self;
        categoryPicker.dataSource = self;
        categoryPicker.reloadAllComponents();
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "HELPDESK");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
    }
    @IBAction func actionForReferesh(_ sender: Any) {
        self.reloadCaptcha()
    }
    
    func validate() -> String {
        var msg = "";
        if txtCaptch.text != currentCaptcha{
            msg = "Captch Wrong, Please try again"
            return msg;
        }
        
        if txtCaptch.text!.isBlank{
            msg = "Please enter the captcha."
        } else if txtHelpDesk.text!.isBlank{
            msg = "Please enter your message."
        } else if txtSelectQuery.text == "Select Category"{
            msg = "Please select your category."
        }
        return msg;
    }
    
    
    @IBAction func actionForSubmit(_ sender: Any) {
        
        if validate() == ""{
		let api = APPURL.BaseURL + APPURL.CricketUrl + APPURL.GetCustomerEnquiry
            UserService.CustomerInquiry(api, ["subject":txtSelectQuery.text!,"message":txtHelpDesk.text!]) { (flag, msg) in
                self.view.showToast(message: msg);
		self.navigationController?.popViewController(animated: true);
            }
        }else{
            self.view.showToast(message: validate());
        }
        
        
        
    }
    
    func reloadCaptcha() {
        currentCaptcha = getRandomCaptcha()
        lblCaptcha.text = currentCaptcha
        vwCaptch.backgroundColor = getRandomColor()
        txtCaptch.text = ""
    }
    
    func getRandomCaptcha() -> String {
        var captcha = ""
        let count = UInt32(arr.count)
        let charact = Array(arr)
        let index1 = Int(arc4random_uniform(count))
        let index2 = Int(arc4random_uniform(count))
        let index3 = Int(arc4random_uniform(count))
        let index4 = Int(arc4random_uniform(count))
        let index5 = Int(arc4random_uniform(count))
        captcha = String(charact[index1]) + String(charact[index2]) + String(charact[index3]) + String(charact[index4]) + String(charact[index5])
        print("\(index1)-\(index2)-\(index3)-\(index4)-\(index5)-\(captcha)")
        return captcha
    }
    func getRandomColor() -> UIColor {
        let hue : CGFloat = (CGFloat(arc4random() % 256) / 256.0) // 0.0 to 1.0
        let saturation : CGFloat = (CGFloat(arc4random() % 128) / 256.0) + 0.5 // 0.5 to 1.0, away from white
        let brightness : CGFloat = (CGFloat(arc4random() % 128) / 256.0) + 0.5 // 0.5 to 1.0, away from black
        let color: UIColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return color
    }
}

extension HelpDeskVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCat.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCat[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtSelectQuery.resignFirstResponder();
        self.txtSelectQuery.text = arrCat[row];
    }
}
