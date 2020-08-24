//
//  PrivateCreateContestTCell.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PrivateCreateContestTCell: UITableViewCell {

    @IBOutlet weak var lblMixSizeContestStmt: UILabel!
    @IBOutlet weak var lblMaxContestStmt: UILabel!
    @IBOutlet weak var lblGiveContestNameStmt: UILabel!
    @IBOutlet weak var lblEntryFeeCalculatedStmt: UILabel!
    @IBOutlet weak var lblEntryFee: UILabel!
    @IBOutlet weak var lblEntryPerTeamStmt: UILabel!
    @IBOutlet weak var txtContestSize: UITextField!
    @IBOutlet weak var swtMultiple: UISwitch!
    @IBOutlet weak var lblAllowFriendsStmt: UILabel!
    @IBOutlet weak var vwContestSize: UIView!
    @IBOutlet weak var lblContestSizeStmt: UILabel!
    @IBOutlet weak var txtWinningAmount: UITextField!
    @IBOutlet weak var vwTotalWinning: UIView!
    @IBOutlet weak var lblWinningAmountStmt: UILabel!
    @IBOutlet weak var txtContestName: UITextField!
    @IBOutlet weak var vwContestName: UIView!
    @IBOutlet weak var lblContestNameStmt: UILabel!
    @IBOutlet weak var btnChooseWinning: UIButton!
    @IBOutlet weak var vwInside2: UIView!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwInside1: UIView!
    
    var maxPrizePool = "";
    var maxContestSize = "";
    var enteryFee = "";
    
    
    var parentVC : UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp();
        self.callApiPrivateSetting();
    }
    
    func setUp() {
        vwContainer.borderWidth = 1.0;
        vwContainer.borderColor = APPCOLOR.TextGrayColor;
        vwContainer.cornerRadius = 6;
        
        for lbl in [lblAllowFriendsStmt, lblWinningAmountStmt, lblContestSizeStmt, lblContestNameStmt] {
            lbl?.font = UIFont(name: font_reguler, size: 12);
            lbl?.textColor = APPCOLOR.TextBlackColor;
        }
        
        for lbl in [lblMaxContestStmt, lblGiveContestNameStmt, lblMixSizeContestStmt] {
            lbl?.font = UIFont(name: font_reguler, size: 11);
            lbl?.textColor = APPCOLOR.TextLightGrayColor;
        }
        
        
        for txt in [txtContestName, txtWinningAmount, txtContestSize]{
            txt?.font = UIFont(name: font_reguler, size: 12);
            txt?.textColor = APPCOLOR.TextBlackColor;
			txt?.text = "";
        }
        
        for vw in [vwContestName, vwTotalWinning, vwContestSize] {
            vw?.borderWidth = 1;
            vw?.borderColor = APPCOLOR.TextLightGrayColor;
            vw?.cornerRadius = 4;
        }
        
        vwInside1.setshadow(cornerR: 4, shadowC: .black, shadowO: 0.2, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
        vwInside2.setshadow(cornerR: 4, shadowC: .black, shadowO: 0.2, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
        
        for vw in [vwInside1, vwInside1] {
            vw?.borderWidth = 1;
            vw?.borderColor = APPCOLOR.TextLightGrayColor;
            vw?.cornerRadius = 6;
        }
        swtMultiple.onTintColor = APPCOLOR.redCustom;
        swtMultiple.thumbTintColor = APPCOLOR.TextWhiteColor;
        
        for lbl in [lblEntryFee, lblEntryPerTeamStmt]{
            lbl?.textColor = APPCOLOR.TextBlackColor;
            lbl?.font = UIFont(name: font_reguler, size: 16);
        }
		self.lblEntryFee.text = "";
        lblEntryFee.textColor = APPCOLOR.redCustom;
        
        lblEntryFeeCalculatedStmt.textColor = APPCOLOR.TextBlackColor;
        lblEntryFeeCalculatedStmt.font = UIFont(name: font_reguler, size: 11);
        
        self.btnChooseWinning.backgroundColor = APPCOLOR.greenCustom;
        self.btnChooseWinning.cornerRadius = 6;
        self.btnChooseWinning.clipsToBounds = true;
        self.btnChooseWinning.titleLabel?.font = UIFont(name: font_bold, size: 14);
        self.swtMultiple.isOn = false;
        
    }

    func callApiPrivateSetting() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.PrivateSettings;
        HomeService.getPrivateContestSettings(api, params: [:]) { (flag,response, msg) in
            if flag{
                if let maxP = response["PRIVATE_CONTEST_MAX_PRIZE_POOL"] as? String{
                    self.maxPrizePool = maxP;
                }
                
                if let maxC = response["PRIVATE_CONTEST_MAX_CONTEST_SIZE"] as? String{
                    self.maxContestSize = maxC;
                }
                self.lblMaxContestStmt.text = "Max \(self.maxPrizePool)";
                self.lblMixSizeContestStmt.text = "Min 2 - Max \(self.maxContestSize)";
            }
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func validation() -> String {
        var msg = "";
        if !txtContestName.hasText{
            msg = "Please enter contest name.";
        } else if !txtWinningAmount.hasText{
            msg = "Please enter total winning amount.";
	} else if Int(txtWinningAmount.text!) == 0 ||  Int(txtContestSize.text!)! > 10000{
            msg = "Please enter valid winning amount.";
        } else if !txtContestSize.hasText{
            msg = "Please enter content size.";
	} else if Int(txtContestSize.text!)!  < 2  ||  Int(txtContestSize.text!)! > 500{
            msg = "Please enter valid contest size.";
        }
        return msg;
    }
    
    @IBAction func actionForChooseWinningBreakup(_ sender: Any) {
        let msg = validation();
        if msg == ""{
            let vc =  parentVC?.loadNib(ChooseWinningBreakVC.self);
            vc?.prizepool = txtWinningAmount.text!
            vc?.contestSize = txtContestSize.text!
            vc?.entryFee = self.enteryFee;
            vc?.privateContestTitle = txtContestName.text!
            vc?.isMultiEntry = swtMultiple.isOn ? "1" : "0";
            parentVC?.navigationController?.pushViewController(vc!, animated: true);
        } else{
            parentVC?.view.showToast(message: msg);
        }
    }
    
    
}

extension PrivateCreateContestTCell : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtWinningAmount.text!.trim().count > 0 && txtContestSize.text!.trim().count > 0{
            self.callApiForWinningPrice()
        } 
    }
    
    func callApiForWinningPrice() {
        if Int(txtWinningAmount.text!)! > 0 && Int(txtContestSize.text!)! > 0{
            let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.PrivateEntreeCalculate
            HomeService.getPrivateContestEntreeCalculate(api, params: ["contest_size":txtContestSize.text!,"prize_pool":txtWinningAmount.text!]) { (flag, response, msg) in
                if flag{
                    if let info = response["entry_fees"] as? String{
                        self.lblEntryFee.text = rupeeSymbol + " " + info
                        self.enteryFee = info;
                    }                    
                }else{
                    self.parentVC?.view.showToast(message: msg);
                }
            }
        }
    }
}
