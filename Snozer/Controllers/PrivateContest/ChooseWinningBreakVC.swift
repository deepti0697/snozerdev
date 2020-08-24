//
//  ChooseWinningBreakVC.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class ChooseWinningBreakVC: ViewController {

    var objContestWinning: WinningBreakups!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var vwTimer: UIView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwUpper: UIView!
    
    @IBOutlet weak var vwContainer: UIView!
    
    @IBOutlet weak var lblContestSizeStmt: UILabel!
    
    @IBOutlet weak var lblContestSize: UILabel!
    @IBOutlet weak var lblPrizePoolStmt: UILabel!
    
    @IBOutlet weak var lblPrizePool: UILabel!
    
    @IBOutlet weak var lblEntryFeeStmt: UILabel!
    
    @IBOutlet weak var lblEntryFee: UILabel!
    
    @IBOutlet weak var lblChooseTotalStmt: UILabel!
    
    @IBOutlet weak var vwWinnersPopup: UIView!
    
    @IBOutlet weak var lblWinnerTitle: UILabel!
    
    
    @IBOutlet weak var tblWinnerOption: UITableView!
    
    @IBOutlet weak var btnCreateOption: UIButton!
    var contestSize = "";
    var prizepool = "";
    var entryFee = ""
    var headerView: NavHeaderView?
    var diff_seconds = 0.0;
    var timer = Timer()
    var objPrivateCat : PrivateWinningOptionDto!
    var teamCount = 0;
    var isMultiEntry = "0";
    var privateContestTitle = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUP();
        self.setHeaderView();
        tblWinnerOption.registerTableViewCellWithNib(nibName: "PrivateWinningTCell");
        self.callApiForGetRankingList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.tick), name:  Common.NotificationNames.Tick, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.joinContestWithSingleTeam), name:  Common.NotificationNames.JoinContestPrivateWithSingleTeam, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    @objc func tick() {
        let (time_diff, progress) = UIApplication.matchTime(appdelegate.SingleMatchInfo)
        if progress == false {
            self.timer.invalidate()
            self.lblTimer.text = time_diff
            self.popupAlert(title: "The deadline has passed!", message: "Check out the contests you've joined for this match", actionTitles: ["OK"], actions: [ {
                    self.presentedViewController?.dismiss(animated: true, completion: nil)
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let TabVC: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    TabVC.selectedIndex = 0
                    UIApplication.shared.windows.first?.rootViewController = TabVC
                }
                ])
        } else {
            self.lblTimer.text = time_diff
        }
    }
    
    func setUP() {
		
		self.tblWinnerOption.backgroundColor = .white;
        lblTeam.text = "\(appdelegate.SingleMatchInfo.team1.sortName!) vs \(appdelegate.SingleMatchInfo.team2.sortName ?? "")"
        
        lblTeam.textColor = APPCOLOR.TextBlackColor;
        lblTimer.textColor = APPCOLOR.redCustom;
        
        lblTeam.font = UIFont(name: font_reguler, size: 14);
        lblTimer.font = UIFont(name: font_reguler, size: 14);
        vwTimer.setshadow(cornerR: 18, shadowC: .black, shadowO: 0.4, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
        
        
        self.lblContestSizeStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblContestSizeStmt.font = UIFont(name: font_medium, size: 15);
        
        self.lblPrizePoolStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblPrizePoolStmt.font = UIFont(name: font_medium, size: 15);
        
        self.lblEntryFeeStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblPrizePoolStmt.font = UIFont(name: font_medium, size: 15);
        
        self.lblContestSize.textColor = APPCOLOR.TextGrayColor;
        self.lblContestSize.font = UIFont(name: font_reguler, size: 14);
        
        self.lblPrizePool.textColor = APPCOLOR.TextGrayColor;
        self.lblPrizePool.font = UIFont(name: font_medium, size: 15);
        
        self.lblEntryFee.textColor = APPCOLOR.TextGrayColor;
        self.lblEntryFee.font = UIFont(name: font_reguler, size: 14);
        
        lblChooseTotalStmt.textColor = APPCOLOR.TextBlackColor;
        lblChooseTotalStmt.font = UIFont(name: font_reguler, size: 12);
        
        vwWinnersPopup.setshadow(cornerR: 4, shadowC: .black, shadowO: 0.4, shadowR: 4, shadowOffset: CGSize(width: -1, height: -1));
        lblWinnerTitle.font = UIFont(name: font_reguler, size: 14);
        
        btnCreateOption.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        btnCreateOption.backgroundColor = APPCOLOR.redCustom;
        
        
        
        lblContestSize.text =  self.contestSize;
        lblPrizePool.text = rupeeSymbol + self.prizepool;
        lblEntryFee.text = rupeeSymbol + self.entryFee;
        
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "MAKE YOUR OWN CONTEST");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
//        self.timer.invalidate()
//        self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
//        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
        self.callApiTeamCount();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    
    func callApiForGetRankingList() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.PrivateChooseWinningBreakup
        HomeService.getPrivateContestWinningBrackups(api, params: ["contest_size" : contestSize, "prize_pool":prizepool]) { (flag, response, msg) in
            if flag{
                if let info = response{
                    self.objPrivateCat = info;
                    if let contestWinning = info.winningBreakups.first{
                        self.objContestWinning = contestWinning;
                        self.lblWinnerTitle.text = self.objContestWinning.totalWinners + " Winners (Recommended)"
                        self.tblWinnerOption.delegate = self;
                        self.tblWinnerOption.dataSource = self;
                        self.tblWinnerOption.reloadData();
                    }
                }
            }else{
                
            }
        }
    }
    
    func callApiTeamCount() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.CreatedTeamCount + "/" + appdelegate.SingleMatchInfo.matchId
        HomeService.getCreatedTeamCount(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                if let count = response{
                    self.teamCount = count;
                }
            }
        }
    }
    
    @IBAction func actionForCreateContest(_ sender: Any) {
	
	if !Utility.sharedInstance.checkUserCompleteHisProfileOrNot(){
		Utility.sharedInstance.gotoForEditProfile(fromVc: self)
		return
	}
        if self.teamCount == 0{
            if appdelegate.matchType == kCricket {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
                vc.fromClass = "PrivateContest"
                self.navigationController!.pushViewController(vc, animated: true)
            }else if appdelegate.matchType == kFootball {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
                vc.fromClass = "PrivateContest"
                self.navigationController!.pushViewController(vc, animated: true)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
                vc.fromClass = "PrivateContest"
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamListJoinContestVC") as! TeamListJoinContestVC
            vc.viewType = "joincontest"
            vc.entryFee = self.entryFee;
            vc.prizePool = self.prizepool;
            vc.contestSize = self.contestSize;
            vc.isMultiply = self.isMultiEntry;
            vc.myTeamCount = self.teamCount;
            vc.winningBreakUpId = self.objContestWinning.id;
            vc.isFromPrivate = true;
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func actionForWinnerOption(_ sender: Any) {
        let vc = self.loadNib(WinningBreakUpOptionVC.self);
        vc.arrContestInfo = self.objPrivateCat.winningBreakups;
        vc.winningOptionId = self.objContestWinning.id;
        vc.privateContestTitle = self.privateContestTitle;
        vc.delegate = self;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @objc func joinContestWithSingleTeam(){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JoinConfirmContestVC") as! JoinConfirmContestVC;
        vc.contestID = appdelegate.ContestInfo?.id ?? "0";
        vc.teamId = appdelegate.JoinTeamId;
        vc.entryFee = self.entryFee;
        vc.parentVC = self;
        vc.isPrivateContest = true
        vc.contestSize = self.contestSize;
        vc.prizePool = self.prizepool;
        vc.isMultiple = self.isMultiEntry;
        vc.winningBreakUpId = self.objContestWinning.id;
        vc.modalPresentationStyle = .overCurrentContext;
        self.present(vc, animated: true, completion: nil);
        vc.completion = { (slug) in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareContestVC") as! ShareContestVC
            vc.contestid = slug;
            vc.matchDetail = appdelegate.SingleMatchInfo;
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }

}

extension ChooseWinningBreakVC: UITableViewDelegate, UITableViewDataSource, WinningOptionDelegate{
    
    func selectedOption(info: WinningBreakups) {
        self.objContestWinning = info;
        self.lblWinnerTitle.text = info.totalWinners + " Winners";
        self.tblWinnerOption.reloadData();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.objContestWinning.contestJson!.perMinP.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateWinningTCell") as! PrivateWinningTCell;
        if self.objContestWinning.contestJson?.perMinP[indexPath.row] == self.objContestWinning.contestJson?.perMaxP[indexPath.row]{
            cell.lblRank.text = "Rank: \(self.objContestWinning.contestJson?.perMinP[indexPath.row] ?? "1")"
        }else{
            cell.lblRank.text = "Rank: \(self.objContestWinning.contestJson?.perMinP[indexPath.row] ?? "1") - \(self.objContestWinning.contestJson?.perMaxP[indexPath.row] ?? "1")"
        }
        cell.lblPercentage.text = "\(self.objContestWinning.contestJson?.perPercent[indexPath.row] ?? "0")%";
        cell.lblPrizeAmount.text = rupeeSymbol + " " + "\((self.objContestWinning.contestJson?.perPrice[indexPath.row] ?? 0))"
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
    
}
