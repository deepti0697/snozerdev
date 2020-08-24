//
//  TeamListJoinContestVC.swift
//  Snozer
//
//  Created by Admin on 21/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class TeamListJoinContestVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwAllSelect: UIView!
    @IBOutlet weak var imgSelectCheck: UIImageView!
    @IBOutlet weak var layoutTblY: NSLayoutConstraint!
    @IBOutlet weak var txtSwitchTeam: UITextField!
    @IBOutlet weak var lblTopStmt: UILabel!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwTimer: UIView!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var imgDown: UIImageView!
    
    @IBOutlet weak var tblTeams: UITableView!
    
    @IBOutlet weak var btnCreateTeam: UIButton!
    @IBOutlet weak var btnJoinTeam: UIButton!
    var isBeatExpert = false;
    var viewType = "";
    var timer = Timer()
    var diff_seconds = Double()
    var myTeamCount = 0;
    var headerView : NavHeaderView?
    var arrTeams: [Jointeam] = [];
    var contestInfo: ContestPool?;
    var entryFee = "0"
    var isFromPrivate = false
    var contestSize = "0";
    var prizePool = "0";
    var isMultiply = "N";
    var winningBreakUpId = "0"
    var isSelectAll = false;
    var pickerSelectTeam = UIPickerView();
    var arrSwitchedTeam : [CommonDto] = [];
    var switchedId: String = "";
    var isMultiSelctionAllow = false;
    var selectedTeamsIds : [String] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setHeaderView();
        self.diff_seconds = 0
        tblTeams.registerTableViewCellWithNib(nibName: "TeamSelectTCell")
        self.setUp();
        if myTeamCount == 0{
            if appdelegate.matchType == kCricket {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
                self.navigationController!.pushViewController(vc, animated: false)
            }else if appdelegate.matchType == kFootball {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
                self.navigationController!.pushViewController(vc, animated: false)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
                self.navigationController!.pushViewController(vc, animated: false)
            }
        }
// Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tick), name:  Common.NotificationNames.Tick, object: nil)
        vwAllSelect.isHidden = true;
        layoutTblY.constant = 2;
        if let data = self.contestInfo{
            if data.multiTeamAllowed != "N" && viewType != "switchteam"{
                isMultiSelctionAllow = true;
                vwAllSelect.isHidden = false;
                layoutTblY.constant = 40;
            }
        }
    }
    
    @objc func tick() {
        let (time_diff, progress) =  UIApplication.matchTime(appdelegate.SingleMatchInfo)
        if progress == false {
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
            self.lblTimer.text = time_diff;
        }
    }
    
     override func viewDidAppear(_ animated: Bool) {
//         self.timer.invalidate()
//         self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
//         RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
    
         self.callTeamApi();
     }
     
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "JOIN CONTEST");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    
    func setUp() {
        
		self.tblTeams.backgroundColor = .white;
        lblTeam.text = "\(appdelegate.SingleMatchInfo.team1.sortName!) vs \(appdelegate.SingleMatchInfo.team2.sortName ?? "")"
        
        lblTeam.textColor = APPCOLOR.TextBlackColor;
        lblTimer.textColor = APPCOLOR.redCustom;
        
        lblTeam.font = UIFont(name: font_reguler, size: 14);
        lblTimer.font = UIFont(name: font_reguler, size: 12);
        lblTopStmt.textColor = APPCOLOR.TextBlackColor;
        lblTopStmt.font = UIFont(name: font_reguler, size: 14);
        vwTimer.setshadow(cornerR: 18, shadowC: .black, shadowO: 0.4, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
        vwTimer.backgroundColor = APPCOLOR.YellowCustom;
        
    }
    @IBAction func actionForSelectAll(_ sender: Any) {
        isSelectAll = !isSelectAll;
        self.selectedTeamsIds.removeAll();
        imgSelectCheck.image = isSelectAll ? UIImage(named: "check_icon_tick") : UIImage(named: "check_icon");
        imgSelectCheck.tintColor = APPCOLOR.greenCustom
        if isSelectAll{
            for team in arrTeams {
                if let data = self.contestInfo{
                    if !data.joinedTeams.components(separatedBy: ",").contains(team.id){
                        self.selectedTeamsIds.append(team.id);
                    }
                }
            }
        }
        tblTeams.reloadData();
    }
    
    @IBAction func actionforCreateTeam(_ sender: Any) {
        if appdelegate.matchType == kCricket{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
            vc.fromClass = "teamList"
            self.navigationController!.pushViewController(vc, animated: true)
        }else if appdelegate.matchType == kFootball{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
            vc.fromClass = "teamList"
            self.navigationController!.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
            vc.fromClass = "teamList"
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionForJoinContest(_ sender: Any) {
        if selectedTeamsIds.count != 0{
            if viewType == "switchteam" {
                let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.SwitchTeam
                HomeService.customerSwitchTeamWithJoinContest(api, params: ["match_unique_id":appdelegate.SingleMatchInfo.matchId,"match_contest_id":self.contestInfo?.id ?? "0","customer_team_id_old":switchedId, "customer_team_id_new":selectedTeamsIds.first!]) { (flag, msg) in
                    if flag{
                        self.navigationController?.popViewController(animated: true);
                    }
                    self.view.showToast(message: msg);
                }
            } else{
                if isBeatExpert{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeatTheExpertJoinVC") as! BeatTheExpertJoinVC;
                    vc.contestInfo = self.contestInfo;
                    vc.modalPresentationStyle = .overCurrentContext;
                    vc.SuccessPrice = {(entryFee) in
                        self.callForJoinCOnfirm(fee: entryFee)
                    }
                    self.present(vc, animated: true, completion: nil);
                }else{
                    self.callForJoinCOnfirm(fee: entryFee);
                }
            }
        }else{
            self.view.showToast(message: "Please select a team")
        }
    }
    
    func  callForJoinCOnfirm(fee: String = "0") {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "JoinConfirmContestVC") as! JoinConfirmContestVC;
        vc.contestID = self.contestInfo?.id ?? "0";
        if selectedTeamsIds.count > 1{
            vc.teamId = selectedTeamsIds.joined(separator: ",");
        }else{
            vc.teamId = selectedTeamsIds.first!
        }
        vc.entryFee = fee;
        vc.parentVC = self;
        vc.isPrivateContest = self.isFromPrivate
        vc.contestSize = self.contestSize;
        vc.prizePool = self.prizePool;
        vc.isMultiple = self.isMultiply
        vc.winningBreakUpId = self.winningBreakUpId;
        vc.modalPresentationStyle = .overCurrentContext;
        self.present(vc, animated: true, completion: nil);
        vc.needAddCompletion = {(cash) in
            let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "AddCashVC") as! AddCashVC
            vc.needCash = cash;
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        }
        
        vc.completion = { (slug) in
            if self.isFromPrivate {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShareContestVC") as! ShareContestVC
                vc.contestid = slug;
                vc.matchDetail = appdelegate.SingleMatchInfo;
                self.navigationController?.pushViewController(vc, animated: true);
            } else {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ContestVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    func callTeamApi() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.MyTeams + "/" + appdelegate.SingleMatchInfo.matchId
        HomeService.GetTeamList(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                self.arrTeams = response;
                self.tblTeams.delegate = self;
                self.tblTeams.dataSource = self;
                self.tblTeams.reloadData();
                self.TeamButtonRefresh();
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    
    func TeamButtonRefresh() {
        txtSwitchTeam.text = "";
        if viewType == "joincontest" {
            self.lblTopStmt.text = "CHOOSE TEAMS TO JOIN THIS CONTEST WITH";
            self.headerView?.lblHeaderTitle.text = "SELECT TEAM";
            self.btnJoinTeam.setTitle("JOIN CONTEST", for: .normal)
            self.btnCreateTeam.setTitle(String(format: "CREATE TEAM %d", self.arrTeams.count+1), for: .normal)
            
        } else if viewType == "rejoincontest" {            
            self.lblTopStmt.text = "CHOOSE TEAMS TO REJOIN THIS CONTEST WITH"
            self.headerView?.lblHeaderTitle.text = "SELECT TEAM";
            self.btnJoinTeam.setTitle("REJOIN", for: .normal)
            self.btnCreateTeam.setTitle(String(format: "CREATE TEAM %d", self.arrTeams.count+1), for: .normal)
        }
        else if viewType == "switchteam" {
            txtSwitchTeam.text = "";
            self.lblTopStmt.text = "CHOOSE TEAM TO SWITCH WITH";
            self.headerView?.lblHeaderTitle.text = "SWITCH TEAM";
            self.btnJoinTeam.setTitle("SWITCH TEAM", for: .normal)
            self.btnCreateTeam.setTitle(String(format: "CREATE TEAM %d", self.arrTeams.count+1), for: .normal)
            self.imgDown.isHidden = false;
            if let team = self.contestInfo{
                if team.joinedTeams != ""{
                    let teamIds = team.joinedTeams.components(separatedBy: ",");
                    let teamNames = team.joinedTeamsName.components(separatedBy: ",");
                    for (index,value) in teamIds.enumerated() {
                        let cm = CommonDto();
                        cm.id = value;
                        cm.name = "TEAM \(teamNames[index])";
                        self.arrSwitchedTeam.append(cm);
                    }
                    if arrSwitchedTeam.count > 0{
                        txtSwitchTeam.text = arrSwitchedTeam.first!.name;
                        switchedId = arrSwitchedTeam.first!.id
                        pickerSelectTeam.delegate = self;
                        pickerSelectTeam.dataSource = self;
                        txtSwitchTeam.inputView = pickerSelectTeam;
                        txtSwitchTeam.addDoneOnKeyboardWithTarget(self, action: #selector(switchSelectDone))
                    }
                }
            }
        }
        
        if self.arrTeams.count == Int(appdelegate.SingleMatchInfo.matchLimit) {
            btnCreateTeam.isHidden = true
        }
        
    }
    
    @objc func switchSelectDone() {
        txtSwitchTeam.resignFirstResponder();
        let index = pickerSelectTeam.selectedRow(inComponent: 0);
        switchedId = arrSwitchedTeam[index].id;
        txtSwitchTeam.text = arrSwitchedTeam[index].name;
    }
    

}

extension TeamListJoinContestVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTeams.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSelectTCell") as! TeamSelectTCell
        cell.setCellInfo(info: arrTeams[indexPath.row], contestData: self.contestInfo);
        cell.imgTick.image = UIImage(named: "check_icon");
        cell.imgTick.tintColor = APPCOLOR.TextBlackColor;
        cell.vwContainer.borderColor = APPCOLOR.TextLightGrayColor;
        cell.vwContainer.backgroundColor = .white;
        if self.selectedTeamsIds.contains(arrTeams[indexPath.row].id){
            cell.imgTick.image = UIImage(named: "check_icon_tick");
            cell.imgTick.tintColor = APPCOLOR.greenCustom
            cell.vwContainer.borderColor = APPCOLOR.greenCustom;
        }
        
        if let data = self.contestInfo{
            if data.joinedTeams.count > 0{
                if data.joinedTeams.components(separatedBy: ",").contains(arrTeams[indexPath.row].id){
                    cell.imgTick.image = UIImage(named: "check_icon_tick");
                    cell.imgTick.tintColor = APPCOLOR.greenCustom
                    cell.vwContainer.borderColor = APPCOLOR.greenCustom;
                    cell.vwContainer.backgroundColor = UIColor(red: 232.0/255, green: 232.0/255, blue: 232.0/255, alpha: 1);
                }
            }
        }
        
        cell.parentVC = self;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = self.contestInfo{
            if data.joinedTeams.count > 0{
                if data.joinedTeams.components(separatedBy: ",").contains(arrTeams[indexPath.row].id){
                    return
                }
            }
            
            if self.selectedTeamsIds.contains(arrTeams[indexPath.row].id){
                self.selectedTeamsIds.removeAll(where: {$0 == arrTeams[indexPath.row].id })
            }else{
                if !isMultiSelctionAllow{
                    self.selectedTeamsIds.removeAll();
                }
                self.selectedTeamsIds.append(arrTeams[indexPath.row].id)
            }
        }else{
            if self.selectedTeamsIds.contains(arrTeams[indexPath.row].id){
                self.selectedTeamsIds.removeAll(where: {$0 == arrTeams[indexPath.row].id })
            }else{
                if !isMultiSelctionAllow{
                    self.selectedTeamsIds.removeAll();
                }
                self.selectedTeamsIds.append(arrTeams[indexPath.row].id)
            }
        }

        self.tblTeams.reloadData();
    }
}

extension TeamListJoinContestVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrSwitchedTeam.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrSwitchedTeam[row].name;
    }
    
    
}





