//
//  ContestDetailVC.swift
//  Snozer
//
//  Created by Admin on 21/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import ObjectMapper;

class ContestDetailVC: ViewController {
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	
    @IBOutlet weak var btnJoinContest: UIButton!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var btnTopContest: UIButton!
    
    var cData:ContestPool!
    var matchInfo : MatchScoreDto?
    var beatExpertDetail: ContestLeaderboardData?
    var arrContestData = [ContestCateModel]()
    var cartegoryDetail : ContestCateModel?
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var vwTimer: UIView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var imgTimer: UIImageView!
    // var contestDetail:ContestDetail!
    var arrleaderBoard = [ContestLeaderboardData]()
    var matchDetail : HomeMatchList?;
	var matchSlugID = "0";
    var isJoinButtonShow = false
    
    var isSearchCell = false
    var pageNo = 1
    var button = UIButton()
    
    @IBOutlet weak var layoutTblBottom: NSLayoutConstraint!
    var headerView: NavHeaderView?;
    var contestId: String = "0";
    var slug = "";
    var diff_seconds = 0.0;
    var timer = Timer()
    var isScoreAvialble = false;
    var teamCount = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
		self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
	
        self.setUp();
        self.setHeaderView();
        
        detailTable.register(UINib(nibName: "ContestDetailCell", bundle: nil), forCellReuseIdentifier: "ContestDetailCell")
        detailTable.register(UINib(nibName: "BeatExpertDetailCell", bundle: nil), forCellReuseIdentifier: "BeatExpertDetailCell")
        detailTable.register(UINib(nibName: "ContestDetailCompletedCell", bundle: nil), forCellReuseIdentifier: "ContestDetailCompletedCell")
        detailTable.register(UINib(nibName: "LeaderboardCell", bundle: nil), forCellReuseIdentifier: "LeaderboardCell")
        detailTable.register(UINib(nibName: "MatchScoreTCell", bundle: nil), forCellReuseIdentifier: "MatchScoreTCell")
        detailTable.register(UINib(nibName: "LeaderboardHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "LeaderboardHeaderCell")
        
        detailTable.tableFooterView = UIView()
        
        detailTable.estimatedRowHeight = 290.0
        detailTable.rowHeight = UITableView.automaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(self.joinContestWithSingleTeam), name:  Common.NotificationNames.JoinContestDetailWithSingleTeam, object: nil)
    }
    
	deinit {
		NotificationCenter.default.removeObserver(self);
	}
    
    func setUp() {
		
		self.detailTable.backgroundColor = .white;
        lblTeamName.textColor = APPCOLOR.TextBlackColor;
        lblTimer.textColor = APPCOLOR.redCustom;
        
        lblTeamName.font = UIFont(name: font_reguler, size: 14);
        lblTimer.font = UIFont(name: font_reguler, size: 12);
        vwTimer.setshadow(cornerR: 18, shadowC: .black, shadowO: 0.4, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
        vwTimer.backgroundColor = APPCOLOR.YellowCustom;
        self.btnJoinContest.titleLabel?.font = UIFont(name: font_reguler, size: 16);
        self.btnTopContest.titleLabel?.font = UIFont(name: font_reguler, size: 16);
        self.btnTopContest.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        self.btnJoinContest.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        self.btnJoinContest.backgroundColor = APPCOLOR.redCustom;
        self.vwBottom.isHidden = true;
		
		let templateImage1 = imgTimer.image?.withRenderingMode(.alwaysTemplate)
		imgTimer.image = templateImage1
		imgTimer.tintColor = APPCOLOR.redCustom
    }
    
    func setData() {
        if let mInfo = matchDetail{
            lblTeamName.text = "\(mInfo.team1.sortName!) vs \(mInfo.team2.sortName ?? "")"
            self.btnTopContest.isHidden = mInfo.matchProgress != "R";
            layoutTblBottom.constant = mInfo.matchProgress == "F" ? 60 : 0
            self.vwBottom.isHidden = mInfo.matchProgress != "F"
            imgTimer.isHidden = mInfo.matchProgress != "F"
            if mInfo.matchProgress == "F"{
                lblTimer.textColor = APPCOLOR.redCustom;
                self.timer.invalidate()
                self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
            }else{
                lblTimer.text = mInfo.matchProgress == "L" ? "In Progress" : (mInfo.matchProgress == "IR" ? "In Review" : "Completed")
                lblTimer.textColor = mInfo.matchProgress == "L" ? APPCOLOR.redCustom : (mInfo.matchProgress == "IR" ?  APPCOLOR.redCustom :  APPCOLOR.greenCustom)
            }
            
            if mInfo.matchProgress == "R" {
                self.btnTopContest.isHidden = false;
            }
        }        
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "CONTEST DETAIL");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callMatchContestDetailInfo();
    }
    
    func callMatchContestDetailInfo() {
        if slug == ""{
            matchDetail = appdelegate.SingleMatchInfo;
            matchDetail?.serverDate = Common.serverTime;
            getContestDetails()
            self.setData();
        }else{
            getContestDetailWithSlug();
        }
    }

    @objc func updateTimer() {
        diff_seconds += 1
        let (time_diff, progress) =    UIApplication.matchTime(matchDetail!, diffrence: diff_seconds)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    func getContestDetails() {
        let urls = String(format: "%@%@%@/%@/%@", APPURL.BaseURL,appdelegate.matchTypeUrl, APPURL.GetContestDetail,contestId,matchDetail!.matchId)
        HomeService.GetContestDetail(_apiName: urls, params: [:]) { (flag, response, msg) in
            if flag{
                if let info = response.first{
                    self.cartegoryDetail = info
                    self.cData = info.contests.first;
                    self.detailTable.dataSource = self
                    self.detailTable.delegate = self
                    let left = Float(self.cData.totalTeamLeft)
                    if self.cData.joinedTeams != ""{
                        let count = self.cData.joinedTeams.components(separatedBy: ",").count
                        if count == Int(self.cData.perUserTeamAllowed) {
                            self.btnJoinContest.isUserInteractionEnabled = false
                            self.btnJoinContest.setTitle("JOINED", for: .normal)
                        } else {
                            if left > 0 {
                                self.btnJoinContest.isUserInteractionEnabled = true
                                self.btnJoinContest.setTitle("JOIN+", for: .normal)
                            } else {
                                self.btnJoinContest.isUserInteractionEnabled = false
                                self.btnJoinContest.setTitle("JOINED", for: .normal);
                            }
                        }
                    }else{
                        if self.cData.isBeatTheExpert != "Y"{
                            if left > 0 {
                                self.btnJoinContest.isUserInteractionEnabled = true
                                self.btnJoinContest.setTitle("JOIN NOW", for: .normal);
                            } else {
                                self.btnJoinContest.isUserInteractionEnabled = false
                                self.btnJoinContest.setTitle("Full", for: .normal);
                            }
                        }else{
                            self.btnJoinContest.isUserInteractionEnabled = true
                            self.btnJoinContest.setTitle("JOIN NOW", for: .normal);
                        }
                    }
                    self.callApiTeamCount();
                    self.getContestTeams()
                }
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    
    func getContestDetailWithSlug() {
        let urls = String(format: "%@%@%@/%@/%@", APPURL.BaseURL,appdelegate.matchTypeUrl, APPURL.SlugContestDetail,slug,matchSlugID)
        HomeService.GetPrivateContestDetail(_apiName: urls, params: [:]) { (flag, response, msg) in
            if flag{
                if let dict = response{
                    let obj  = Mapper<ContestCateModel>().mapArray(JSONArray: dict["data"] as! [[String:Any]])
                    if let info = obj.first{
                        self.cartegoryDetail = info
                        self.cData = info.contests.first;
                        self.detailTable.dataSource = self
                        self.detailTable.delegate = self
                        let left = Float(self.cData.totalTeamLeft)
                        
                        if self.cData.joinedTeams != ""{
                            let count = self.cData.joinedTeams.components(separatedBy: ",").count
                            if count == Int(self.cData.perUserTeamAllowed) {
                                self.btnJoinContest.isUserInteractionEnabled = false
                                self.btnJoinContest.setTitle("JOINED", for: .normal)
                            } else {
                                if left > 0 {
                                    self.btnJoinContest.isUserInteractionEnabled = true
                                    self.btnJoinContest.setTitle("JOIN+", for: .normal)
                                } else {
                                    self.btnJoinContest.isUserInteractionEnabled = false
                                    self.btnJoinContest.setTitle("JOINED", for: .normal);
                                }
                            }
                        }else{
                            if self.cData.isBeatTheExpert != "Y"{
                                if left > 0 {
                                    self.btnJoinContest.isUserInteractionEnabled = true
                                    self.btnJoinContest.setTitle("JOIN NOW", for: .normal);
                                } else {
                                    self.btnJoinContest.isUserInteractionEnabled = false
                                    self.btnJoinContest.setTitle("Full", for: .normal);
                                }
                            }else{
                                self.btnJoinContest.isUserInteractionEnabled = true
                                self.btnJoinContest.setTitle("JOIN NOW", for: .normal);
                            }
                        }
                    }
                    self.matchDetail = Mapper<HomeMatchList>().map(JSON: dict["match_detail"] as! [String:Any])
                    self.setData();
                    self.callApiTeamCount();
                    self.getContestTeams()
                }
            }else{
                self.navigationController?.popViewController(animated: true);
                self.view.showToast(message: msg);
            }
        }
    }
    
    func callApiTeamCount() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.CreatedTeamCount + "/" + matchDetail!.matchId
        HomeService.getCreatedTeamCount(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                if let count = response{
                    self.teamCount = count;
                }
            }
        }
    }
    
    
    func getContestTeams() {
        
        let urls = String(format: "%@%@%@/%@/%@/%d", APPURL.BaseURL,appdelegate.matchTypeUrl, APPURL.GetContestTeam,matchDetail!.matchId,cData.matchContestId,pageNo)
        
        HomeService.GetContestTeam(_apiName: urls, params: [:]) { (flag, response, msg) in
            if flag{
                if let info =  response["data"] as? [[String : Any]]{
                    self.arrleaderBoard = Mapper<ContestLeaderboardData>().mapArray(JSONArray: info)
                }
                
                if let info =  response["admin_data"] as? [String : Any]{
                    self.beatExpertDetail = Mapper<ContestLeaderboardData>().map(JSON: info)
                }
                
                self.detailTable.reloadData()
            }else{
                self.view.showToast(message: msg);
            }
        }
        
    }
    
    @IBAction func actionForTopContest(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeamPreviewController") as! TeamPreviewController
        vc.isTopTeam = true;
        vc.isShowPoints = true;
        vc.sportsType = appdelegate.matchType;
        vc.matchUrl = appdelegate.matchTypeUrl;
        vc.parentVC = self;
        vc.modalPresentationStyle = .overCurrentContext;
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func actionForJoinContest(_ sender: Any) {
	if !Utility.sharedInstance.checkUserCompleteHisProfileOrNot(){
		Utility.sharedInstance.gotoForEditProfile(fromVc: self )
		return
	}
        if self.teamCount == 0{
            if appdelegate.matchType == kCricket {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
                vc.fromClass = "contestDetailVC"
                self.navigationController!.pushViewController(vc, animated: true)
            }else if appdelegate.matchType == kFootball {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
                vc.fromClass = "contestDetailVC"
                self.navigationController!.pushViewController(vc, animated: true)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
                vc.fromClass = "contestDetailVC"
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeamListJoinContestVC") as! TeamListJoinContestVC
            if self.cData.joinedTeamsName.count > 0{
                vc.viewType = "rejoincontest"
            }else{
                vc.viewType = "joincontest"
            }
            vc.contestInfo = cData;
            vc.isBeatExpert = cData.isBeatTheExpert == "Y"
            vc.myTeamCount = self.teamCount;
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
        
    }
}


extension ContestDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //MARK:- Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            
            return UITableView.automaticDimension
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            
            return 126;
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let base = UIView()
        
        if section == 1 {            
            let LeaderboardHeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LeaderboardHeaderCell") as! LeaderboardHeaderCell
            LeaderboardHeaderCell.parentVC = self;
            LeaderboardHeaderCell.lbltotalTeams.text = String(self.arrleaderBoard.count);
            if self.beatExpertDetail != nil{
                LeaderboardHeaderCell.lbltotalTeams.text = String(self.arrleaderBoard.count + 1);
            }
            LeaderboardHeaderCell.matchDetail = self.matchDetail;
            LeaderboardHeaderCell.contestInfo = cData;
            LeaderboardHeaderCell.vwBeatTheExpert.isHidden = self.beatExpertDetail == nil;
            LeaderboardHeaderCell.setBeatExpertData(info: self.beatExpertDetail);
            LeaderboardHeaderCell.vwDisable.isHidden = matchDetail!.matchProgress != "F"
            return LeaderboardHeaderCell
        }
        
        return base
    }
    
    
    //MARK:- Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    //MARK:- Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return arrleaderBoard.count
        } else {
            return isScoreAvialble ? 2 : 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            
            return 50
        }
        
        return UITableView.automaticDimension//tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
            cell.isBeatTheExpert = cData.isBeatTheExpert == "Y"
            cell.matchDetail = self.matchDetail;
            cell.configureLayoutScreen(arrleaderBoard[indexPath.row], contestData: cData!)
            cell.parentVC = self;
            return cell
        } else{
            if matchDetail!.matchProgress == "F" {
                if cData.isBeatTheExpert == "Y"{
                    let ContestDetailCell =  tableView.dequeueReusableCell(withIdentifier: "BeatExpertDetailCell", for:indexPath) as! BeatExpertDetailCell
                    ContestDetailCell.SetCellData(model: cartegoryDetail!)
                    if self.beatExpertDetail != nil{
                        ContestDetailCell.name = self.beatExpertDetail!.firstname + " " + self.beatExpertDetail!.lastname
                    }
                    ContestDetailCell.parentVC = self;
                    return ContestDetailCell
                }else{
                    let ContestDetailCell =  tableView.dequeueReusableCell(withIdentifier: "ContestDetailCell", for:indexPath) as! ContestDetailCell
                    ContestDetailCell.matchDetail = self.matchDetail;
                    ContestDetailCell.configureLayoutScreen(cData)
                    ContestDetailCell.teamCount = self.teamCount;
                    ContestDetailCell.parentVC = self;                    
                    return ContestDetailCell
                }
                
            } else {
                if isScoreAvialble{
                    if indexPath.row == 0{
                        let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "MatchScoreTCell", for:indexPath) as! MatchScoreTCell
                        ContestCell.setInfo(model: matchInfo!);
                        return ContestCell;
                    }else{
                        if cData.isBeatTheExpert == "Y"{
                            let ContestDetailCell =  tableView.dequeueReusableCell(withIdentifier: "BeatExpertDetailCell", for:indexPath) as! BeatExpertDetailCell
                            ContestDetailCell.SetCellData(model: cartegoryDetail!)
                            ContestDetailCell.vwSwitchTeam.isHidden = true;
                            if self.beatExpertDetail != nil{
                                ContestDetailCell.name = self.beatExpertDetail!.firstname + " " + self.beatExpertDetail!.lastname
                            }
                            ContestDetailCell.parentVC = self;
                            return ContestDetailCell
                        }else{
                            let ContestDetailCell =  tableView.dequeueReusableCell(withIdentifier: "ContestDetailCompletedCell", for:indexPath) as! ContestDetailCompletedCell
                            ContestDetailCell.parentVC = self;
                            ContestDetailCell.configureLayoutScreen(self.cData)
                            return ContestDetailCell
                        }
                    }
                }else{
                    if cData.isBeatTheExpert == "Y"{
                        let ContestDetailCell =  tableView.dequeueReusableCell(withIdentifier: "BeatExpertDetailCell", for:indexPath) as! BeatExpertDetailCell
                        ContestDetailCell.SetCellData(model: cartegoryDetail!)
                        if self.beatExpertDetail != nil{
                            ContestDetailCell.name = self.beatExpertDetail!.firstname + " " + self.beatExpertDetail!.lastname
                        }
                        ContestDetailCell.parentVC = self;
                        return ContestDetailCell
                    }else{
                        let ContestDetailCell =  tableView.dequeueReusableCell(withIdentifier: "ContestDetailCompletedCell", for:indexPath) as! ContestDetailCompletedCell
                        ContestDetailCell.configureLayoutScreen(self.cData)
                        return ContestDetailCell
                    }
                }
                
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            if matchDetail!.matchProgress != "F"{
                let data = arrleaderBoard[indexPath.row]
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamPreviewController") as! TeamPreviewController
                vc.selectedTeamID = data.teamId
                vc.matchid = matchDetail!.matchId;
                vc.sportsType = appdelegate.matchType;
                vc.matchUrl = appdelegate.matchTypeUrl;
                vc.matchProgress = matchDetail!.matchProgress;
                vc.strTeamName = data.customerTeamName + "(T" + data.teamName + ")"
                vc.strTeamRank = "#" + data.newRank;
                vc.isShowPoints = true;
                vc.parentVC = self;
                vc.modalPresentationStyle = .overCurrentContext;
                self.present(vc, animated: true, completion: nil);
            }else{
                if  cData.joinedTeams.components(separatedBy: ",").contains(arrleaderBoard[indexPath.row].teamId){
                    let data = arrleaderBoard[indexPath.row]
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamPreviewController") as! TeamPreviewController
                    vc.selectedTeamID = data.teamId
                    vc.matchid = matchDetail!.matchId;
                    vc.sportsType = appdelegate.matchType;
                    vc.matchUrl = appdelegate.matchTypeUrl;
		vc.strTeamName = data.customerTeamName + "(T" + data.teamName + ")"
                    vc.isFromCreateteam = 2
			vc.fromClass = "contestDetailVC";
                    vc.parentVC = self;
                    vc.modalPresentationStyle = .overCurrentContext;
                    self.present(vc, animated: true, completion: nil);
                }else{
                    self.view.showToast(message: "You can see team preview after match live.")
                }
            }
            
            
            
        }else{
            if isScoreAvialble{
                if indexPath.row == 0{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerStatsVC") as! PlayerStatsVC
                    self.navigationController!.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    
    
    
    /* @objc func JoinBtntapped(sender : UIButton)
     {
     if Global.myTeams.count < 1 {
     
     Common.goNextView(Controller: self, StoryBoardIdentifier: "CreateTeamViewController")
     }
     else
     {
     let vc  = self.storyboard?.instantiateViewController(withIdentifier: "TeamSelectionViewController") as! TeamSelectionViewController
     vc.viewType = "JoinContest"
     // vc.selectedContestData = contestDetail.data
     self.navigationController?.pushViewController(vc, animated: true)
     }
     
     
     }*/
    
    @objc func InviteBtntapped(sender : UIButton)
    {
        let strMessage = "The Team 11"
//        let vc = UIActivityViewController(activityItems: [strMessage], applicationActivities: [])
//        present(vc, animated: true, completion: nil)
        
        let activityVC = UIActivityViewController(activityItems: [strMessage], applicationActivities: nil)
        activityVC.excludedActivityTypes = []
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = self.view
            if #available(iOS 12.0, *) {
                activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).frame
            } else {
                // Fallback on earlier versions
            }
        }
        present(activityVC, animated: true, completion: nil)
        
    }
    
    @objc func SwitchBtntapped(sender : UIButton)
    {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "TeamSelectionViewController") as! TeamSelectionViewController
        // vc.viewType = "switchteam"
        // vc.selectedContestData = contestDetail.data
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func joinContestWithSingleTeam(){
        if cData != nil && appdelegate.JoinTeamId != "0"{
            if cData.isBeatTheExpert == "Y"{
                appdelegate.isBeatExpert = false;
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeatTheExpertJoinVC") as! BeatTheExpertJoinVC;
                vc.contestInfo = cData;
                vc.modalPresentationStyle = .overCurrentContext;
                vc.SuccessPrice = {(entryFee) in
                    self.callForJoinCOnfirm(fee: entryFee)
                }
                self.present(vc, animated: true, completion: nil);
            }else{
                self.callForJoinCOnfirm(fee: "");
            }
        }
    }
    
    func  callForJoinCOnfirm(fee : String = "0") {
        if cData != nil && appdelegate.JoinTeamId != "0"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JoinConfirmContestVC") as! JoinConfirmContestVC;
            vc.contestID = cData.id ?? "0";
            vc.teamId = appdelegate.JoinTeamId;
            vc.entryFee = fee;
            vc.parentVC = self;
            vc.modalPresentationStyle = .overCurrentContext;
            self.present(vc, animated: true, completion: nil);
            vc.needAddCompletion = {(cash) in
                let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "AddCashVC") as! AddCashVC
                vc.needCash = cash;
                vc.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(vc, animated: true);
            }
            vc.completion = { (slug) in
                self.callMatchContestDetailInfo();
            }
        }
    }
    
}

