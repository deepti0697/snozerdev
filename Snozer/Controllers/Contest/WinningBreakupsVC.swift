//
//  WinningBreakupsVC.swift
//  Snozer
//
//  Created by Admin on 11/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class WinningBreakupsVC: UIViewController {
    @IBOutlet weak var vwUpper: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblPrizepoolStmt: UILabel!
    @IBOutlet weak var lblPrizeAmount: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var layoutTblH: NSLayoutConstraint!
    @IBOutlet weak var tblPrizepool: UITableView!
    
    var winningBreakups : WinningBreakUpModal!
    
    var contestId : String = "0";
    var prizePool = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp();
        self.callApiForWinningBreakup();
        // Do any additional setup after loading the view.
    }
    
    func setUp() {
		
		self.tblPrizepool.backgroundColor = .white;
        self.vwUpper.backgroundColor = APPCOLOR.redCustom;
        self.lblTitle.textColor = APPCOLOR.TextWhiteColor;
        self.lblPrizeAmount.textColor = APPCOLOR.TextBlackColor;
        self.lblPrizepoolStmt.textColor = APPCOLOR.TextBlackColor;
        
        
        self.lblTitle.font = UIFont(name: font_reguler, size: 16);
        self.lblPrizeAmount.font = UIFont(name: font_medium, size: 15);
        self.lblPrizepoolStmt.font = UIFont(name: font_reguler, size: 14);
        self.lblNote.textColor = APPCOLOR.TextGrayColor;
        self.lblNote.font = UIFont(name: font_reguler, size: 11);
        self.lblPrizeAmount.text = rupeeSymbol + " " + self.prizePool;
		self.lblNote.text = appdelegate.objAccountInfo?.settings.wINNINGBREAKUPMESSAGE ?? "";
    }


    @IBAction func actionForClose(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
    func callApiForWinningBreakup() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetWinningBreakUpData + "/" + contestId
        HomeService.GetWinningBreakUp(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                if let info = response{
                    self.winningBreakups = info;
                }
                self.layoutTblH.constant = CGFloat(40 * self.winningBreakups.winnerBreakup.perMaxP.count);
                if self.layoutTblH.constant > UIScreen.main.bounds.height - 200{
                    self.layoutTblH.constant = UIScreen.main.bounds.height - 200;
                }
                self.tblPrizepool.reloadData();
            }
        }
    }
    
    
    
}

extension WinningBreakupsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.winningBreakups != nil{
            return self.winningBreakups.winnerBreakup.perMaxP.count;
        }else{
            return 0;
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WinningPrizePoolCell") as! WinningPrizePoolCell
        cell.lblRank.font = UIFont(name: font_medium, size: 13);
        cell.lblPrize.font = UIFont(name: font_medium, size: 13);
        cell.lblRank.textColor = APPCOLOR.TextBlackColor;
        cell.lblPrize.textColor = APPCOLOR.TextBlackColor;
        if self.winningBreakups.winnerBreakup.perMinP[indexPath.row] == self.winningBreakups.winnerBreakup.perMaxP[indexPath.row]{
                cell.lblRank.text = "Rank: \(self.winningBreakups.winnerBreakup.perMinP[indexPath.row])"
        }else{
            cell.lblRank.text = "Rank: \(self.winningBreakups.winnerBreakup.perMinP[indexPath.row]) - \(self.winningBreakups.winnerBreakup.perMaxP[indexPath.row])"
        }
        cell.lblPrize.text = rupeeSymbol + "\(self.winningBreakups.winnerBreakup.perPrice[indexPath.row])"
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
    
    
}

class WinningPrizePoolCell: UITableViewCell {
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblPrize: UILabel!
    @IBOutlet weak var vwLine: UIView!
}
