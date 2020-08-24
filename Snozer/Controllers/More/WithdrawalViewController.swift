//
//  WithdrawalViewController.swift
//  Cricshot
//
//  Created by Cricshot on 10/04/19.
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import UIKit
import SVProgressHUD

class WithdrawalViewController: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    var headerView : NavHeaderView?
    @IBOutlet weak var vwMoney: UIView!
    @IBOutlet weak var lblYourWinning: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var vwBankDetail: UIView!
    
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblIfsc: UILabel!
    @IBOutlet weak var lblWantTochangeStmt: UILabel!
    @IBOutlet weak var btnHelpDesk: UIButton!
    @IBOutlet weak var txtAmount: SkyFloatingLabelTextField!
    @IBOutlet weak var lblMaxMin: UILabel!
    @IBOutlet weak var btnWithdraw: UIButton!
    var minimumAmount = 0;
    var maximumAmount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        setHeaderView();
        self.setUp();
        self.setData();
    }
    
    func setUp() {
        
        vwBankDetail.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.3, shadowR: 2, shadowOffset: CGSize(width: 1, height: 3));
        vwMoney.backgroundColor = APPCOLOR.YellowCustom;
        txtAmount.font = UIFont(name: font_reguler, size: 16);
        txtAmount.tintColor = APPCOLOR.TextBlackColor;
        txtAmount.textColor = APPCOLOR.TextBlackColor;
        txtAmount.delegate = self;
        txtAmount.placeholderColor = APPCOLOR.TextBlackColor;
        txtAmount.placeholderFont = UIFont(name: font_reguler, size: 16);
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "WITHDRAW");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    
    func setData() {
        if let info = appdelegate.objAccountInfo{
            if let bnk = info.bankdetail{
                self.lblAccountNumber.text = "A/C" + " " + bnk.accountNumber;
                self.lblName.text = bnk.accountName;
                self.lblIfsc.text = bnk.ifsc;
            }
            
            if let set = info.settings{
                self.lblMaxMin.text = "min \(rupeeSymbol) \(set.wITHDRAWAMOUNTMIN ?? "") & max \(rupeeSymbol) \(set.wITHDRAWAMOUNTMAX ?? "") allowed per day";
                minimumAmount = Int(set.wITHDRAWAMOUNTMIN) ?? 0;
                maximumAmount = Int(set.wITHDRAWAMOUNTMAX) ?? 0;
            }
        }
        
        if let info = appdelegate.objAmountDetail{
            lblBalance.text = rupeeSymbol + " " + String(format: "%.2f", info.winningAmount);
        }
        txtAmount.text = rupeeSymbol + " " + "\(minimumAmount)";
    }
    
    @IBAction func actionForHelpDesk(_ sender: Any) {
        let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "HelpDeskVC") as! HelpDeskVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnWithdrawTap(_ sender: Any) {
        
        let arr = self.txtAmount.text?.components(separatedBy: "₹")
        var amount : Double = 0
        if let str = arr?[1].trim() {
            amount = str == "" ? amount : Double(str) as! Double
        }
        
        if amount >= Double(minimumAmount) && amount <= Double(maximumAmount){
            self.popupAlert(title: kAppName, message: "Do you want to continue withdrawal the amount?", actionTitles: ["Cancel", "Continue"], actions: [
                {
                    
                },
                {
                    self.delay(0.5, closure: {
                        self.WithdrawAmount()
                    })
                    
                }
            ])
        }else{
            self.view.showToast(message: "You can withdrawal any amount between Rs. \(minimumAmount) to Rs. \(maximumAmount)");
        }
        
        
    }

    
    // MARK: - API Methods
    
    func WithdrawAmount() {
        
        let arr = self.txtAmount.text?.components(separatedBy: "₹")
        var amount = "0"
        if let str = arr?[1].trim() {
            amount = (str == "") ? amount : str
        }
        
        
        let headersParam = [
            "amount": amount
        ]
        
        ProfileService.WithdrawAmount(params: headersParam) { (flag, msg) in
            if flag{
		self.view.showToast(message: msg);
		self.navigationController?.popViewController(animated: false);
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
}


extension WithdrawalViewController: UITextFieldDelegate {
    
    // MARK: - UITextfield Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Not allowing user to delete the ruppee symbol.
        let protectedRange = NSMakeRange(0, 1)
        let intersection = NSIntersectionRange(protectedRange, range)
        if intersection.length > 0 {
            return false
        }
        
        // Maximum character 8. Not allowing to enter more than that.
        let maxLength = 8
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length > maxLength {
            return false
        }
        
        return true
    }
    
}
