//
//  KYCPanBankViewController.swift
//  Cricshot
//
//  Created by Cricshot on 04/04/19.
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import SVProgressHUD
import AWSS3


class KYCPanBankViewController: ViewController {
	
	var showingDOB = "";
	@IBOutlet weak var vwBottomBtns: UIView!
	var isPanCard = false
	let datePicker = UIDatePicker()
	let picker = UIPickerView()
	
	var strPanCardDOB: String = "" {
		didSet {
			self.setDateInDatePicker()
		}
	}
	var strState: String = "" {
		didSet {
			delay(0.5) {
				self.setStateInPicker()
			}
		}
	}
	var arrState: Array<CommonDto>? {
		didSet {
			self.picker.reloadAllComponents()
		}
	}
	var imageDoc: UIImage?
	var strPanCardStateID = ""
	var strPanCardName = ""
	var strPanCardNumber = ""
	var strPanCardState = ""
	var strBankAccName = ""
	var strBankAccNumber = ""
	var strBankReAccNumber = ""
	var strBankIFSCCode = ""
	var strBankName = ""
	var imageUrl = "";
	
	@IBOutlet weak var tableview: UITableView!
	@IBOutlet weak var btnSubmit: UIButton!
	@IBOutlet weak var lblHeader: UILabel!
	@IBOutlet weak var viewVerify: UIView!
	
	let imagePicker = UIImagePickerController()
	var objAccInfo: UserData?
	var refreshAccInfo: ((_ refresh: Bool) -> Void)? // Callback function to parent VC. Opening verify segment on tap of verify now button.
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setUp();
		
		tableview.register(UINib(nibName: String(describing: UploadProofTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: UploadProofTableViewCell.self))
		tableview.register(UINib(nibName: String(describing: KYCInputTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: KYCInputTableViewCell.self))
		tableview.register(UINib(nibName: String(describing: KYCInputMessageTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: KYCInputMessageTableViewCell.self))
		tableview.tableFooterView = UIView()
		
		tableview.layer.shadowColor = UIColor.init(red: 4/255, green: 68/255, blue: 191/255, alpha: 0.4).cgColor
		tableview.layer.shadowOpacity = 0.5
		tableview.layer.shadowOffset = CGSize.init(width: 0, height: 0)
		tableview.layer.shadowRadius = 3
		picker.dataSource = self
		picker.delegate = self
		// setting properties of imagepicker and pickerview.
		imagePicker.delegate = self
		self.imagePicker.allowsEditing = false
		self.imagePicker.mediaTypes = [kUTTypeImage] as [String]
		self.imagePicker.navigationBar.tintColor = APPCOLOR.redCustom
		self.imagePicker.navigationBar.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor : APPCOLOR.redCustom
		]
		self.getStateList();
		self.objAccInfo = appdelegate.objAccountInfo;
		if !isPanCard {
			if let info = self.objAccInfo{
				if info.isEmailVerified == "N" || info.isPhoneVerified == "N" || info.pancard ==  nil{
					tableview.isHidden = true;
					vwBottomBtns.isHidden = true;
					viewVerify.isHidden = false;
				}else{
					if let bank = info.bankdetail {
						vwBottomBtns.isHidden = bank.status != "R";
					}
					
				}
			}
		}else{
			if let info = self.objAccInfo{
				if let pan = info.pancard {
					vwBottomBtns.isHidden = pan.status != "R";
				}
			}
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.updateAccountInfo(notification:)), name: Notification.Name("updateAccountInfo"), object: nil)
		definesPresentationContext = true
		
	}
	
	func getStateList() {
		let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetStateList
		UserService.getStates(api, params: [:]) { (flag, response, msg) in
			if flag{
				self.arrState = response;
			}
		}
	}
	
	func setUpUI() {
		if !isPanCard {
			if let info = self.objAccInfo{
				if let bank = info.bankdetail {
					vwBottomBtns.isHidden = bank.status != "R";
				}
			}
		}else{
			if let info = self.objAccInfo{
				if let pan = info.pancard {
					vwBottomBtns.isHidden = pan.status != "R";
				}
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		self.view.endEditing(true)
	}
	
	// Removing notification for self when class is deallocated.
	deinit {
		NotificationCenter.default.removeObserver(self, name: Notification.Name("updateAccountInfo"), object: nil)
	}
	
	func setUp() {
		viewVerify.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: 1, height: 3));
		btnSubmit.titleLabel?.font = UIFont(name: font_bold, size: 14);
		btnSubmit.backgroundColor = APPCOLOR.redCustom;
		vwBottomBtns.backgroundColor = APPCOLOR.redCustom
		tableview.backgroundColor = .white;
	}
	
	
	// MARK: - Action Methods
	
	@objc func updateAccountInfo(notification: Notification) {
		
		SVProgressHUD.dismiss()
		objAccInfo = (notification.userInfo!["AccountInfo"] as! UserData)
		
		//        checkForDetails()
	}
	
	@IBAction func btnSubmitTap(_ sender: UIButton) {
		
		if isPanCard {
			validatePanCardDetails()
		}
		else {
			validateBankAccountProof()
		}
	}
	
	@IBAction func btnVerifyTap(_ sender: UIButton) {
		
		
	}
	
	@objc func btnUploadTap(_ sender: UIButton) {
		
		let controller = UIAlertController(title: kAppName, message: "Select source for media.", preferredStyle: .actionSheet)
		controller.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
			
		}))
		controller.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (action) in
			self.imagePicker.sourceType = .camera
			self.present(self.imagePicker, animated: true, completion: nil)
		}))
		controller.addAction(UIAlertAction.init(title: "Gallery", style: .default, handler: { (action) in
			self.delay(0.5, closure: {
				// Opening photo library.
				self.imagePicker.sourceType = .photoLibrary
				self.present(self.imagePicker, animated: true, completion: nil)
			})
		}))
		present(controller, animated: true, completion: nil)
		
		//        self.popupAlert(title: MessageAlert.appName, message: "Select source for media.", actionTitles: ["Camera", "Gallery", "Cancel"], actions: [
		//            {
		//
		//
		//            },
		//            {
		//
		//
		//            },
		//            {
		//
		//            }
		//            ])
	}
	
	@objc func donedatePicker() {
		strPanCardDOB = datePicker.date.toString(format: "yyyy-MM-dd")
		showingDOB = datePicker.date.toString(format: "dd-MM-yyyy")
		self.tableview.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
		self.view.endEditing(true)
	}
	
	@objc func cancelDatePicker() {
		self.view.endEditing(true)
	}
	
	@objc func donePicker() {
		strState = arrState?[picker.selectedRow(inComponent: 0)].name ?? ""
		strPanCardStateID = "\(arrState?[picker.selectedRow(inComponent: 0)].id ?? "1")"
		self.tableview.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .fade)
		self.view.endEditing(true)
	}
	
	fileprivate func setDateInDatePicker() {
		let date = strPanCardDOB.toDate(format: "yyyy-MM-dd");
		datePicker.date = date
	}
	
	fileprivate func setStateInPicker() {
		
		var index = 0
		for item in arrState ?? [] {
			if item.name.lowercased().contains(strState.lowercased()) {
				picker.selectRow(index, inComponent: 0, animated: false)
				break
			}
			index += 1
		}
	}
	
	// Checking for validation of details entered in pan card information. If any details mismatch than showing alert to user and popping that particular textfield.
	func validatePanCardDetails() {
		
		var strMessage: String?
		
		if strPanCardName.isEmpty || strPanCardNumber.isEmpty || strPanCardDOB.isEmpty || strState.isEmpty {
			strMessage = "Please fill all the input fields."
		}
		else if imageDoc == nil {
			strMessage = "Please upload the Pan Card attachment."
		}
		else if !validatePANCardNumber() {
			strMessage = "Enter a valid Pan card number."
		}
		else { // If all details are fine than uploading details
			self.popupAlert(title: kAppName,
					message: "Continue uploading the details?",
					actionTitles: ["NO", "YES"],
					actions: [
						{
							
						},
						{
							self.UploadPanCardDetails()
						}
			])
			return
		}
		
		// Showing alert  if validation failed and if needs to navigate user to textfield than doing that action.
		self.view.showToast(message: strMessage!)
	}
	
	// Checking for validation of details entered in bank account information. If any details mismatch than showing alert to user and popping that particular textfield.
	func validateBankAccountProof() {
		
		var strMessage: String?
		
		if strBankAccName.isEmpty || strBankAccNumber.isEmpty || strBankReAccNumber.isEmpty || strBankIFSCCode.isEmpty {
			strMessage = "Please fill all the input fields."
		}
		else if strBankAccNumber != strBankReAccNumber {
			strMessage = "Account Number didn't matched. Please check and enter again."
		}
		else if imageDoc == nil {
			strMessage = "Please upload the Bank Account Proof attachment."
		}
		else if !validateIFSCCode() {
			strMessage = "Enter a valid IFSC Code."
		}
		else { // If all details are fine than uploading details
			self.popupAlert(title: kAppName,
					message: "Continue uploading the details?",
					actionTitles: ["NO", "YES"],
					actions: [
						{
							
						},
						{
							self.UploadBankAccountDetails()
						}
			])
			return
		}
		
		// Showing alert  if validation failed and if needs to navigate user to textfield than doing that action.
		self.view.showToast(message: strMessage!)
	}
	
	// Passing pan details to upload api call.
	func UploadPanCardDetails() {
		
		let parameters = [
			"number": strPanCardNumber,
			"name": strPanCardName,
			"dob": strPanCardDOB,
			"state": strPanCardStateID,
			"image" : self.imageUrl
		]
		ProfileService.UploadBankPanDetail(APPURL.UploadPanCard, params: parameters) { (flag, response, msg) in
			if flag{
				if let user = response{
					appdelegate.objAccountInfo = user;
					self.objAccInfo = user
					self.tableview.reloadData();
					self.setUpUI();
				}
			}
		}
	}
	
	// Passing bank account details to upload api call.
	func UploadBankAccountDetails() {
		
		let parameters = [
			"name": strBankAccName,
			"account_number": strBankAccNumber,
			"ifsc": strBankIFSCCode,
			"image" : self.imageUrl
		]
		ProfileService.UploadBankPanDetail(APPURL.UploadBankProof, params: parameters) { (flag, response, msg) in
			if flag{
				if let user = response{
					appdelegate.objAccountInfo = user;
					self.objAccInfo = user
					self.tableview.reloadData();
					self.setUpUI();
				}
			}
		}
	}
	
	// Checking for format of ifsc code using regular expression.
	func validateIFSCCode() -> Bool {
		
		let regularExpression = "[A-Za-z]{4}0[A-Z0-9a-z]{6}"
		let ifscCodeValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
		if ifscCodeValidation.evaluate(with: strBankIFSCCode) {
			return true
		}
		return false
	}
	
	// Checking for format of pan card number using regular expression.
	func validatePANCardNumber()-> Bool {
		
		let regularExpression = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
		let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
		if panCardValidation.evaluate(with: strPanCardNumber) {
			return true
		}
		return false
	}
	
	func showDatePicker(_ textfield: UITextField) {
		
		//Formate Date
		datePicker.datePickerMode = .date
		//        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
		datePicker.set18YearValidation()
		
		//ToolBar
		let toolbar = UIToolbar();
		toolbar.sizeToFit()
		
		let doneButton =  UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donedatePicker))
		
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: "Dismiss", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
		toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
		
		textfield.inputAccessoryView = toolbar
		textfield.inputView = datePicker
	}
	
	func showPickerView(_ textfield: UITextField) {
		
		//ToolBar
		let toolbar = UIToolbar();
		toolbar.sizeToFit()
		
		let doneButton =  UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
		
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: "Dismiss", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
		toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
		
		textfield.inputAccessoryView = toolbar
		textfield.inputView = picker
	}
	
}



extension KYCPanBankViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return isPanCard ? 6 : 6
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: UploadProofTableViewCell.self), for: indexPath) as! UploadProofTableViewCell
			cell.viewParent.roundCornersWith([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 3, borderColor: .clear, borderWidth: 0)
			cell.btnUpload.setTitle("UPLOAD BANK ACCOUNT PROOF", for: .normal)
			cell.lblHeading.text = "Enter Your Bank Details"
			
			cell.imgPic.image = UIImage.init(named: isPanCard ? "icon_pancard" : "icon_bank")
			cell.img.image = UIImage.init(named: isPanCard ? "icon_pancard" : "icon_bank")
			cell.imgPic.contentMode = .scaleToFill
			if imageDoc != nil {
				cell.imgPic.image = imageDoc!
				cell.imgPic.contentMode = .scaleToFill
				cell.btnUpload.setTitle("CHANGE BANK ACCOUNT PROOF", for: .normal);
				if isPanCard {
					cell.btnUpload.setTitle("CHANGE PAN CARD IMAGE", for: .normal);
				}
			}
			
			if isPanCard {
				cell.lblHeading.text = "Enter Your PAN Details"
				cell.btnUpload.setTitle("UPLOAD PAN CARD IMAGE", for: .normal)
				if let info = self.objAccInfo{
					if let pan = info.pancard {
						cell.lblHeading.text = pan.status == "R" ? "Pan detail rejected" : (pan.status == "A" ? "PAN details verified" : "Pan detail is under review");
						cell.lblHeading.textColor = pan.status == "R" ? APPCOLOR.redCustom : (pan.status == "A" ? APPCOLOR.greenCustom : APPCOLOR.YellowCustom);
						cell.btnUpload.isHidden = pan.status != "R";
						cell.imgPic.sd_setImage(with:  URL.init(string: pan.image),placeholderImage: UIImage.init(named: "icon_pancard"))
						cell.imgPic.contentMode = .scaleAspectFit
						imageDoc = cell.imgPic.image
						self.imageUrl = pan.image
					}
				}
				
			}else{
				cell.btnUpload.setTitle("UPLOAD BANK ACCOUNT PROOF", for: .normal)
				cell.lblHeading.text = "Enter Your Bank Details"
				if let info = self.objAccInfo{
					if let bank = info.bankdetail {
						cell.lblHeading.text = bank.status == "R" ? "Bank detail rejected" : "Bank detail is under review";
						cell.lblHeading.textColor = bank.status == "R" ? APPCOLOR.redCustom :  APPCOLOR.YellowCustom;
						cell.btnUpload.isHidden = bank.status != "R";
						cell.imgPic.sd_setImage(with:  URL.init(string: bank.image),placeholderImage: UIImage.init(named: "icon_bank"))
						cell.imgPic.contentMode = .scaleAspectFit
						imageDoc = cell.imgPic.image
						self.imageUrl = bank.image
					}
				}
				
			}
			cell.btnUpload.addTarget(self, action: #selector(btnUploadTap(_ :)), for: .touchUpInside)
			
			
			cell.setNeedsLayout()
			cell.layoutIfNeeded()
			//            cell.setDottedBorder()
			return cell
		}
		else if indexPath.row == (tableView.numberOfRows(inSection: 0) - 1) {
			let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: KYCInputMessageTableViewCell.self), for: indexPath) as! KYCInputMessageTableViewCell
			cell.viewParent.roundCornersWith([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 3, borderColor: .clear, borderWidth: 0)
			return cell
		}
		else {
			let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: KYCInputTableViewCell.self), for: indexPath) as! KYCInputTableViewCell
			cell.txtInput.keyboardType = .default
			cell.txtInput.delegate = self
			cell.txtInput.tag = indexPath.row
			cell.txtInput.text = ""
			if isPanCard {
				switch indexPath.row {
				case 1:
					cell.txtInput.attributedPlaceholder = NSAttributedString(string: "Name (As on PAN Card)", attributes: [NSAttributedString.Key.foregroundColor: AppDarkGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_light, size: 12)!])
					cell.txtInput.text = strPanCardName
					
					if let info = self.objAccInfo{
						if let pan = info.pancard {
							cell.txtInput.text = pan.name
							strPanCardName = pan.name
							cell.txtInput.isUserInteractionEnabled = pan.status == "R" ? true : false;
						}
					}
					
				case 2:
					//                    cell.txtInput.placeholder = "Enter 10 digit pan card no."
					cell.txtInput.attributedPlaceholder = NSAttributedString(string: "PAN number (10 Digit PAN No.)", attributes: [NSAttributedString.Key.foregroundColor: AppDarkGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_light, size: 12)!])
					cell.txtInput.text = strPanCardNumber
					cell.txtInput.autocapitalizationType = .allCharacters
					
					if let info = self.objAccInfo{
						if let pan = info.pancard {
							cell.txtInput.text = pan.number
							strPanCardNumber = pan.number
							cell.txtInput.isUserInteractionEnabled = pan.status == "R" ? true : false;
							
						}
					}
					
				case 3:
					//                    cell.txtInput.placeholder = "Enter date of birth"
					cell.txtInput.attributedPlaceholder = NSAttributedString(string: "Date of Birth", attributes: [NSAttributedString.Key.foregroundColor: AppDarkGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_light, size: 12)!])
					self.showDatePicker(cell.txtInput)
					cell.txtInput.text = showingDOB
					if let info = self.objAccInfo{
						if let pan = info.pancard {
							cell.txtInput.text = pan.dob.toDateString(format: "yyyy-MM-dd", changedFormat: "dd-MM-yyyy");
							strPanCardDOB = pan.dob;
							cell.txtInput.isUserInteractionEnabled = pan.status == "R" ? true : false;
						}
					}
				case 4:
					//                    cell.txtInput.placeholder = "Enter date of birth"
					cell.txtInput.attributedPlaceholder = NSAttributedString(string: "State", attributes: [NSAttributedString.Key.foregroundColor: AppDarkGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_light, size: 12)!])
					self.showPickerView(cell.txtInput)
					cell.txtInput.text = strState
					if let info = self.objAccInfo{
						if let pan = info.pancard {
							cell.txtInput.text = pan.state?.name
							strState = pan.state?.name ?? ""
							cell.txtInput.isUserInteractionEnabled = pan.status == "R" ? true : false;
						}
					}
				default:
					break
				}
			}
			else {
				switch indexPath.row {
				case 1:
					//                    cell.txtInput.placeholder = "Full Name"
					cell.txtInput.attributedPlaceholder = NSAttributedString(string: "Account number (Bank account number)", attributes: [NSAttributedString.Key.foregroundColor: AppDarkGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_light, size: 12)!])
					cell.txtInput.text = strBankAccNumber
					cell.txtInput.keyboardType = .numberPad;
					if let info = self.objAccInfo{
						if let bank = info.bankdetail {
							cell.txtInput.text = bank.accountNumber
							strBankAccNumber = bank.accountNumber
							cell.txtInput.isUserInteractionEnabled = bank.status == "R" ? true : false;
						}
					}
				case 2:
					//                    cell.txtInput.placeholder = "Account Number"
					cell.txtInput.attributedPlaceholder = NSAttributedString(string: "Retype account number", attributes: [NSAttributedString.Key.foregroundColor: AppDarkGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_light, size: 12)!])
					cell.txtInput.keyboardType = .numberPad
					cell.txtInput.text = strBankReAccNumber
					if let info = self.objAccInfo{
						if let bank = info.bankdetail {
							cell.txtInput.text = bank.accountNumber
							strBankReAccNumber = bank.accountNumber
							cell.txtInput.isUserInteractionEnabled = bank.status == "R" ? true : false;
						}
					}
					
				case 3:
					//                    cell.txtInput.placeholder = "Re-Enter Account Number"
					cell.txtInput.attributedPlaceholder = NSAttributedString(string: "Account holder name", attributes: [NSAttributedString.Key.foregroundColor: AppDarkGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_light, size: 12)!])
					cell.txtInput.keyboardType = .default
					cell.txtInput.text = strBankAccName
					if let info = self.objAccInfo{
						if let bank = info.bankdetail {
							cell.txtInput.text = bank.accountName
							strBankAccName = bank.accountName
							cell.txtInput.isUserInteractionEnabled = bank.status == "R" ? true : false;
						}
					}
				case 4:
					//                    cell.txtInput.placeholder = "IFSC Code"
					cell.txtInput.attributedPlaceholder = NSAttributedString(string: "IFSC Code", attributes: [NSAttributedString.Key.foregroundColor: AppDarkGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_light, size: 12)!])
					cell.txtInput.text = strBankIFSCCode
					if let info = self.objAccInfo{
						if let bank = info.bankdetail {
							cell.txtInput.text = bank.ifsc
							strBankIFSCCode = bank.ifsc
							cell.txtInput.isUserInteractionEnabled = bank.status == "R" ? true : false;
						}
					}
				case 5:
					//                    cell.txtInput.placeholder = "Bank Name"
					cell.txtInput.attributedPlaceholder = NSAttributedString(string: "Bank Name", attributes: [NSAttributedString.Key.foregroundColor: AppDarkGrayColor, NSAttributedString.Key.font: UIFont.init(name: font_light, size: 12)!])
					cell.txtInput.text = strBankName
				default:
					break
				}
			}
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 259
		}
		return 49
	}
	
}





extension KYCPanBankViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	
	// MARK: - UIPicker Delegate/DataSource Methods
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		return arrState?.count ?? 0
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		return arrState?[row].name ?? ""
	}
	
}

extension KYCPanBankViewController: UITextFieldDelegate {
	
	// MARK: - UITextfield Delegate Methods
	
	func textFieldDidEndEditing(_ textField: UITextField) { // Setting textfield data in class variables. Used those variables to pass data to api.
		
		if isPanCard {
			switch textField.tag {
			case 1:
				strPanCardName = textField.text ?? ""
			case 2:
				strPanCardNumber = textField.text ?? ""
			default:
				break
			}
		}
		else {
			switch textField.tag {
			case 1:
				strBankAccNumber = textField.text ?? ""
			case 2:
				strBankReAccNumber = textField.text ?? ""
			case 3:
				strBankAccName = textField.text ?? ""
			case 4:
				// As user enterd the ifsc code and keybaord removed from that textfield. We're calling api to get bank/branch details.
				strBankIFSCCode = textField.text ?? ""
				//                if strBankIFSCCode.count == 11 &&
				//                    strIFSCCodeForWhichAPICalled != strBankIFSCCode {
				//                    GetBankDetailsFromIFSCCode()
				//                }
				
			case 5:
				strBankName = textField.text ?? ""
				//            case 8:
			//                strBankBranchName = textField.text ?? ""
			default:
				break
			}
		}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		// maximum length check in textfield.
		var maxLength = 150
		
		if isPanCard {
			if textField.tag == 2 {
				if !disAllowSpecialCharacters(string) {
					return false
				}
				maxLength = 10
			} else if textField.tag == 1 {
				if !disAllowSpecialAndNumericCharacters(string) {
					return false
				}
			}
		}
		else {
			if textField.tag == 4 {
				if !disAllowSpecialCharacters(string) {
					return false
				}
				maxLength = 11
			} else if textField.tag == 1 || textField.tag == 2{
				maxLength = 20
			} 
		}
		
		let currentString: NSString = textField.text! as NSString
		let newString: NSString =
			currentString.replacingCharacters(in: range, with: string) as NSString
		if newString.length > maxLength {
			return false
		}
		
		return true
	}
	
	func disAllowSpecialCharacters(_ string: String) -> Bool {
		
		let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
		let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
		let filtered = string.components(separatedBy: cs).joined(separator: "")
		
		return (string == filtered)
	}
	
	func disAllowSpecialAndNumericCharacters(_ string: String) -> Bool {
		let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
		let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
		let filtered = string.components(separatedBy: cs).joined(separator: "")
		
		return (string == filtered)
	}
	
}

extension KYCPanBankViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	//MARK: - ImagePicker Delegates
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		// The info dictionary may contain multiple representations of the image. You want to use the original.
		guard let selectedImage = info[.originalImage] as? UIImage else {
			//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
			self.view.showToast(message: "Something went wrong please try again.")
			return
		}
		
		imageDoc = selectedImage;
		self.saveImageDocumentDirectory(image: selectedImage, imageName: "\(Date().toString(format: "yyyyddMMhhmmss")).jpg")
		// Dismiss the picker.
		dismiss(animated: true) {
			self.tableview.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { // Dismissing the imagepicker.
		
		dismiss(animated: true, completion: nil)
	}
	
	
	func saveImageDocumentDirectory(image: UIImage, imageName: String) {
		
		let fileURL =  URL(fileURLWithPath: NSTemporaryDirectory().appending(imageName));
		let data = image.jpegData(compressionQuality: 0.6)
		do{
			try data?.write(to: fileURL as URL)
		}catch{
			
		}
		
		let imageData = image.jpegData(compressionQuality: 0.6)
		let options = [
			kCGImageSourceCreateThumbnailWithTransform: true,
			kCGImageSourceCreateThumbnailFromImageAlways: true,
			kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary
		let source = CGImageSourceCreateWithData(imageData! as CFData, nil)!
		let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
		let thumbnail = UIImage(cgImage: imageReference)
		
		let fileURL1 =  URL(fileURLWithPath: NSTemporaryDirectory().appending("Thumbnail\(imageName)"));
		let data1 = thumbnail.jpegData(compressionQuality: 0.6)
		do{
			try data1?.write(to: fileURL1 as URL)
		}catch{
			
		}
		
		//        let fileManager = FileManager.default
		//        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("yourProjectImages")
		//        if !fileManager.fileExists(atPath: path) {
		//        try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
		//        }
		//        let url = NSURL(string: path)
		//        let imagePath = url!.appendingPathComponent(imageName)
		//        let urlString: String = imagePath!.absoluteString
		//        let imageData = image.jpegData(compressionQuality: 0.5)
		//        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
		
		if let user = appdelegate.objAccountInfo{
			self.uploadImageInAws(uploadLocalPath: fileURL, strFileName: imageName, savePath: isPanCard ? user.aws.pANCARDIMAGEPATH : user.aws.bANKIMAGEPATH, saveType: "large");
			self.uploadImageInAws(uploadLocalPath: fileURL1, strFileName: imageName, savePath: isPanCard ? user.aws.pANCARDIMAGEPATH : user.aws.bANKIMAGEPATH,saveType: "thumbnail");
		}
		
	}
	
	func uploadImageInAws(uploadLocalPath:URL,strFileName:String,savePath: String, saveType: String)   {
		SVProgressHUD.show()
		let uploadRequest = AWSS3TransferManagerUploadRequest()
		uploadRequest!.bucket = appdelegate.objAccountInfo?.aws.aWSBUCKET;
		uploadRequest!.key = "\(savePath)\(saveType)/\(strFileName)"
		uploadRequest!.contentType = "image/jpeg"
		uploadRequest!.body = uploadLocalPath
		uploadRequest!.acl = .publicRead
        
        print("s3: \(String(describing: uploadRequest))")
		
		let manager = AWSS3TransferManager.default()
		manager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
			SVProgressHUD.dismiss()
			if let error = task.error as NSError? {
				if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
					switch code {
					case .cancelled, .paused:
						break
					default:
						print("Error uploading: \(String(describing: uploadRequest?.key)) Error: \(error)")
					}
				} else {
					print("Error uploading: \(String(describing: uploadRequest?.key)) Error: \(error)")
				}
				return nil;
			}
			if task.result != nil {
				let url = AWSS3.default().configuration.endpoint.url
				let publicURL = url!.appendingPathComponent("brtaxinew").appendingPathComponent((uploadRequest?.key)!) as URL
				if saveType == "large"{
					self.imageUrl = (publicURL.absoluteString as String)
				}
				print(self.imageUrl)
			}
			return nil
		})
	}
	
}

// Functions to convert image to data.
extension UIImage {
	enum JPEGQuality: CGFloat {
		case lowest  = 0
		case low     = 0.25
		case medium  = 0.5
		case high    = 0.75
		case highest = 1
	}
	
	/// Returns the data for the specified image in JPEG format.
	/// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
	/// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
	func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
		return jpegData(compressionQuality: jpegQuality.rawValue)
	}
}
