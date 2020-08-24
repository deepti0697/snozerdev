//
//  JoinConfirmContestVC.swift
//  Snozer
//
//  Created by Admin on 24/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class JoinConfirmContestVC: UIViewController {

    @IBOutlet weak var lblConfirmationStmt: UILabel!
    
    @IBOutlet weak var lblTotalBalanceStmt: UILabel!
    @IBOutlet weak var lblTotalBalance: UILabel!
    @IBOutlet weak var lblEntryStmt: UILabel!
    @IBOutlet weak var lblEntry: UILabel!
    @IBOutlet weak var lblUsableBalanceStmt: UILabel!
    @IBOutlet weak var lblUsableBalance: UILabel!
    @IBOutlet weak var lblToPayStmt: UILabel!
    @IBOutlet weak var lblTopay: UILabel!
    @IBOutlet weak var lblBottomLine: UILabel!
    @IBOutlet weak var btnContest: UIButton!
    typealias typeCompletionHandler = (_ slug: String) -> ()
    var completion : typeCompletionHandler = {_ in }
    var needAddCompletion : (_ cash: String) -> () = {_ in}
    var contestID: String = "0"
    var amountDetail:  ContestAmountDetail!
    var teamId: String = "";
    var entryFee = "0";
    var parentVC : UIViewController?
    var contestSize = "0";
    var prizePool = "0";
    var winningBreakUpId = "0"
    var isMultiple = "N"
    var isPrivateContest = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp();
        self.callApiForPreJoinContest();
    }
    
    func  setUp() {
        self.lblConfirmationStmt.textColor = APPCOLOR.TextWhiteColor;
        self.lblUsableBalanceStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblTotalBalanceStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblToPayStmt.textColor = APPCOLOR.greenCustom;
        self.lblEntryStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblBottomLine.textColor = APPCOLOR.TextBlackColor;
        
        
        self.lblTotalBalance.textColor = APPCOLOR.TextBlackColor;
        self.lblTopay.textColor = APPCOLOR.greenCustom;
        self.lblEntry.textColor = APPCOLOR.TextBlackColor;
        self.lblUsableBalance.textColor = APPCOLOR.TextBlackColor;
        
        
        self.btnContest.backgroundColor = APPCOLOR.redCustom;
        self.btnContest.titleLabel?.font = UIFont(name: font_reguler, size: 16);
        self.btnContest.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        
        
        self.lblConfirmationStmt.font = UIFont(name: font_reguler, size: 16);
        self.lblUsableBalanceStmt.font = UIFont(name: font_reguler, size: 14);
        self.lblTotalBalanceStmt.font = UIFont(name: font_reguler, size: 14);
        self.lblToPayStmt.font = UIFont(name: font_reguler, size: 14);
        self.lblEntryStmt.font = UIFont(name: font_reguler, size: 14);
        self.lblBottomLine.font = UIFont(name: font_reguler, size: 10);
        
        self.lblTotalBalance.font = UIFont(name: font_reguler, size: 14);
        self.lblTopay.font = UIFont(name: font_reguler, size: 14);
        self.lblEntry.font = UIFont(name: font_reguler, size: 14);
        self.lblUsableBalance.font = UIFont(name: font_reguler, size: 14);
    }
	@IBAction func actionForInfo(_ sender: Any) {
		self.popupAlert(title: kAppName, message: "Money that you can use to join any public contest.", actionTitles: ["OK"], actions: [{}]);
	}
	
    func dismissVCCompletion(completionHandler: @escaping typeCompletionHandler) {
        self.completion = completionHandler
    }
    
    func callApiForPreJoinContest() {
        
        if isPrivateContest{
            let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.PrivateCreateContest;
            HomeService.joinPrivateContestAPI(_apiName: api, params: ["contest_size":self.contestSize, "prize_pool":self.prizePool, "match_id" : appdelegate.SingleMatchInfo.id,"winning_breakup_id":winningBreakUpId, "match_unique_id": appdelegate.SingleMatchInfo.matchId, "is_multiple":self.isMultiple, "team_id" : teamId, "pre_join" : "Y"]) { (flag, response, msg) in
                if flag{
                    if let info = response{
                        self.amountDetail = info;
                        self.setData();
                        let needPay = info.needPay
                        if needPay > 0.0{
                            self.dismiss(animated: true, completion: {
                                self.needAddCompletion("\(needPay)");
                            })
                        }
                    }
                }else{
                    self.dismiss(animated: true, completion: nil);
                    self.view.showToast(message: msg);
                }
            }
        }else{
            let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.PreJoinContest;
            var dict : [String:String] = [:];
            if entryFee == "0"{
                dict = ["match_unique_id":appdelegate.SingleMatchInfo.matchId, "match_contest_id":contestID, "customer_team_ids":teamId]
            }else{
                dict = ["match_unique_id":appdelegate.SingleMatchInfo.matchId, "match_contest_id":contestID, "customer_team_ids":teamId, "entry_fees" : entryFee]
            }
            
            HomeService.PrejoinContestDetail(api, params:dict) { (flag, response, msg) in
                if flag{
                    if let info = response{
                        self.amountDetail = info;
                        self.setData();
                        let needPay = info.needPay
                        if needPay > 0.0{
                            self.dismiss(animated: true, completion: {
                                self.needAddCompletion("\(needPay)");
                            })                            
                        }
                    }
                }else{
                    self.dismiss(animated: true, completion: nil);
                    self.view.showToast(message: msg);
                }
            }
        }
        
        
    }
    
    func setData() {
        var total = (self.amountDetail.wallet?.depositAmount ?? 0.0) + (self.amountDetail.wallet?.winningAmount ?? 0.0)
        total = total + (self.amountDetail.wallet?.bonusAmount ?? 0.0)
        lblTotalBalance.text = rupeeSymbol + String(format: "%.2f", total);
        self.lblEntry.text = rupeeSymbol + String(format: "%.2f", self.amountDetail.entryFees);
        self.lblUsableBalance.text = rupeeSymbol + String(format: "%.2f", self.amountDetail.usedBonus);
        self.lblTopay.text = rupeeSymbol + String(format: "%.2f", self.amountDetail.toPay);
    }
    
    @IBAction func actionForDismiss(_ sender: Any) {
        appdelegate.ContestInfo = nil;
        appdelegate.JoinTeamId = "0";
        self.dismiss(animated: true, completion: nil);
    }
    @IBAction func actionForJoinContest(_ sender: Any) {
        
        if isPrivateContest{
            let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.PrivateCreateContest;
            HomeService.joinAfterPrivateContestAPI(_apiName: api, params: ["contest_size":self.contestSize, "prize_pool":self.prizePool, "match_id" : appdelegate.SingleMatchInfo.id,"winning_breakup_id":winningBreakUpId, "match_unique_id": appdelegate.SingleMatchInfo.matchId, "is_multiple":self.isMultiple, "team_id" : teamId, "pre_join" : "N"]) { (flag, response, msg) in
                if flag{
                    if let data = response{
                        appdelegate.ContestInfo = nil;
                        appdelegate.JoinTeamId = "0";
                        self.dismiss(animated: true, completion: {
                            self.view.showToast(message: msg)
                            self.completion(data);
                        })
                    }                    
                }else{
                    self.view.showToast(message: msg);
                }
            }
        }else{
            let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.CustomerJoinContest;
            var dict : [String:String] = [:];
            if entryFee == "0"{
                dict = ["match_unique_id":appdelegate.SingleMatchInfo.matchId, "match_contest_id":contestID, "customer_team_id":teamId]
            }else{
                dict = ["match_unique_id":appdelegate.SingleMatchInfo.matchId, "match_contest_id":contestID, "customer_team_id":teamId, "entry_fees" : entryFee]
            }
            
            HomeService.customerJoinContest(api, params: dict) { (flag, response, msg) in
                if flag{
                   self.dismiss(animated: true, completion: {
                    self.view.showToast(message: msg)
                    self.completion("")
                    appdelegate.ContestInfo = nil;
                    appdelegate.JoinTeamId = "0";
                    })
                }else{
                    self.view.showToast(message: msg);
                }
            }
        }
    }
}
