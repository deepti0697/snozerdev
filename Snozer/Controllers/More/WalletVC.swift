//
//  WalletVC.swift
//  Snozer
//
//  Created by Admin on 24/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class WalletVC: UIViewController {

    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblBalanceStmt: UILabel!
    @IBOutlet weak var btnAddMoney: UIButton!
    @IBOutlet weak var btnWithdraw: UIButton!
    
    @IBOutlet weak var lblDepositStmt: UILabel!
    @IBOutlet weak var lblDeposit: UILabel!
    @IBOutlet weak var lblWinningStmt: UILabel!
    @IBOutlet weak var lblWinning: UILabel!
    @IBOutlet weak var lblBonusStmt: UILabel!
    
    @IBOutlet weak var lblBonus: UILabel!
    
    @IBOutlet weak var lblBotttomstmt: ActiveLabel!
    var parentVC : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp();
        self.setData();
    }
    
    func setUp() {
        self.lblBalance.textColor = APPCOLOR.TextBlackColor;
        self.lblBalanceStmt.textColor = APPCOLOR.TextDarkGrayColor;
        self.lblDepositStmt.textColor = APPCOLOR.TextDarkGrayColor;
        self.lblWinningStmt.textColor = APPCOLOR.TextDarkGrayColor;
        self.lblBonusStmt.textColor = APPCOLOR.TextDarkGrayColor;
        self.lblBotttomstmt.textColor = APPCOLOR.TextDarkGrayColor;
        
        btnAddMoney.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        btnWithdraw.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        
        btnAddMoney.backgroundColor = APPCOLOR.greenCustom;
        btnWithdraw.backgroundColor = APPCOLOR.redCustom;
        
        self.lblBalance.font = UIFont(name: font_bold, size: 18);
        self.lblBalanceStmt.font = UIFont(name: font_reguler, size: 14);
        self.lblDeposit.font = UIFont(name: font_reguler, size: 14);
        self.lblWinningStmt.font = UIFont(name: font_reguler, size: 14);
        self.lblBonusStmt.font = UIFont(name: font_reguler, size: 14);
        
        self.lblBonus.font = UIFont(name: font_bold, size: 15);
        self.lblWinning.font = UIFont(name: font_bold, size: 15);
        self.lblDeposit.font = UIFont(name: font_bold, size: 15);
        self.lblBotttomstmt.font = UIFont(name: font_reguler, size: 10);
        
        self.btnWithdraw.titleLabel?.font = UIFont(name: font_reguler, size: 14);
        self.btnAddMoney.titleLabel?.font = UIFont(name: font_reguler, size: 14);
        self.SetupKnowMoreText()
    }
    
    func setData()  {
        if let info = appdelegate.objAmountDetail{
            lblWinning.text = rupeeSymbol + " " + info.winningAmount.clean;
            lblBalance.text = rupeeSymbol + " " + info.totalAmount.clean;
            lblBonus.text = rupeeSymbol + " " + info.bonusAmount.clean;
            lblDeposit.text = rupeeSymbol + " " + info.depositAmount.clean;
        }
    }
    
    @IBAction func actionForAddmoney(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
        let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "AddCashVC");
        vc.hidesBottomBarWhenPushed = true;
        self.parentVC?.navigationController?.pushViewController(vc, animated: true);
       
    }
    
    //MARK: - T&C and policy Event
    
    func SetupKnowMoreText() {
        lblBotttomstmt.numberOfLines = 2 ;
        lblBotttomstmt.textColor =  APPCOLOR.TextBlackColor;
        
        let customType1 = ActiveType.custom(pattern: "\\sKnow More\\b") //Regex that looks for "with"
        lblBotttomstmt.enabledTypes = [customType1]
        lblBotttomstmt.text = "Minimum usable bonus = 0% of entry fees. Know More "
        
        
        lblBotttomstmt.customColor[customType1] = APPCOLOR.redCustom;
        lblBotttomstmt.customSelectedColor[customType1] = APPCOLOR.redCustom;
        
        lblBotttomstmt.handleCustomTap(for: customType1) { element in
            self.dismiss(animated: true, completion: nil);
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyWebVC") as! MyWebVC
            vc.hidesBottomBarWhenPushed = true
            vc.navtitle = "STAGGERED CASHBONUS"
            vc.slugname = "staggered-cashbonus"
            self.parentVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func actionForWithdraw(_ sender: Any) {
        var isNotKYCUpdate = false;
        if let userInfo = appdelegate.objAccountInfo{
            self.dismiss(animated: true, completion: nil);
            if userInfo.isEmailVerified == "Y" || userInfo.isPhoneVerified == "Y" || userInfo.pancard != nil || userInfo.bankdetail != nil{
                isNotKYCUpdate = true;
                if let pan = userInfo.pancard{
                    if pan.status == "A"{
                        isNotKYCUpdate = true;
                    }else{
                        isNotKYCUpdate = false;
                    }
                } else{
                    isNotKYCUpdate = false;
                }
                
                if let bank = userInfo.bankdetail{
                    if bank.status == "A"{
                        isNotKYCUpdate = true;
                    }else{
                        isNotKYCUpdate = false;
                    }
                } else{
                    isNotKYCUpdate = false;
                }
            }
            if isNotKYCUpdate{
                let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "WithdrawalViewController") as! WithdrawalViewController
                vc.hidesBottomBarWhenPushed = true
                self.parentVC?.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.redirectTOKYC();
            }
        }else{
            self.view.showToast(message: "Something went wrong. Please try after some time.")
        }
        
        
        
    }
    
    func redirectTOKYC() {
        let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "KYCViewController");
        vc.hidesBottomBarWhenPushed = true;
        self.parentVC?.navigationController?.pushViewController(vc, animated: true);
    }
    
    
    @IBAction func actionForDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
