//
//  SelectedCaptionVC.swift
//  Snozer
//
//  Created by Admin on 11/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class SelectedCaptionVC: ViewController, UITableViewDelegate, UITableViewDataSource {
    
	@IBOutlet weak var imgClock: UIImageView!
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwUpper: UIView!
    
    @IBOutlet weak var vwUpperLine: UIView!
    @IBOutlet weak var imgCaptain: UIImageView!
    
    @IBOutlet weak var lblCaptianStmt: UILabel!
    
    @IBOutlet weak var vwCaptianPoints: UIView!
    
    @IBOutlet weak var lblCaptionPoint: UILabel!
    
    
    var headerView: NavHeaderView?
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgVC: UIImageView!
    
    @IBOutlet weak var lblVCStmt: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var vwTimer: UIView!
    @IBOutlet weak var vwVCPoints: UIView!
    
    @IBOutlet weak var lblVCPoints: UILabel!
    
    @IBOutlet weak var tblSelectedPlayer: UITableView!
    
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var lblCShort: UILabel!
    @IBOutlet weak var lblVCShort: UILabel!
    var arrSelectedPlayers  = [PlayerData]()
    
    var captainName = String()
    var captionImage = "";
    var vcImage = "";
    var VCName = String()
//    var timer = Timer()
    var fromClass = String()
    var strEditedTeamId = String()
    
    var arrFinalTeam = NSMutableArray()
    var captainIndex = Int()
    var viceCaptainIndex = Int()
    var teamAId = Int()
    var teamBId = Int()
//    var diff_seconds : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
        captainIndex = 100
        viceCaptainIndex = 100
        
        for index in 0...self.arrSelectedPlayers.count - 1 {
            let objTemp =  self.arrSelectedPlayers[index]
            if objTemp.playerMultiplier == 2 {
                captainIndex = index
                captainName = objTemp.playerName
                captionImage = objTemp.image;
            }
            if objTemp.playerMultiplier == 1.5 {
                viceCaptainIndex = index
                VCName = objTemp.playerName
                vcImage = objTemp.image;
            }
        }
        if captionImage != ""{
            self.lblCaptianStmt.text = captainName;
            imgCaptain.sd_setImage(with:  URL.init(string: captionImage),placeholderImage: UIImage.init(named: "user_icon"))
        }
        
        if vcImage != ""{
            self.lblVCStmt.text = VCName;
            imgVC.sd_setImage(with:  URL.init(string: vcImage),placeholderImage: UIImage.init(named: "user_icon"))
        }
//        self.timer.invalidate()
//        self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
//        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
//
        ////--Register Nib for UITableViewCell
        tblSelectedPlayer.registerTableViewCellWithNib(nibName: "SelectedCaptionTCell")
        tblSelectedPlayer.delegate = self;
        tblSelectedPlayer.dataSource = self;
        tblSelectedPlayer.reloadData();
        NotificationCenter.default.addObserver(self, selector: #selector(self.tick), name:  Common.NotificationNames.Tick, object: nil)
    }
    
    @objc func tick() {
        let (time_diff, progress) = UIApplication.matchTime(appdelegate.SingleMatchInfo)
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
            self.lblTimer.text = time_diff
        }
    }
    
    func  setUp() {
		
		self.tblSelectedPlayer.backgroundColor = .white;
        lblTeamName.text = "\(appdelegate.SingleMatchInfo.team1.sortName!) vs \(appdelegate.SingleMatchInfo.team2.sortName ?? "")"
        
        lblTeamName.textColor = APPCOLOR.TextBlackColor;
        lblTimer.textColor = APPCOLOR.redCustom;
        
        lblTeamName.font = UIFont(name: font_reguler, size: 14);
        lblTimer.font = UIFont(name: font_reguler, size: 12);
        
        lblCaptianStmt.textColor = APPCOLOR.TextBlackColor;
        lblVCStmt.textColor = APPCOLOR.TextBlackColor;
        
        lblCShort.textColor = APPCOLOR.redCustom;
        lblVCShort.textColor = APPCOLOR.redCustom;
        
        lblCaptianStmt.font = UIFont(name: font_reguler, size: 12);
        lblVCStmt.font = UIFont(name: font_reguler, size: 12);
        
        vwUpperLine.backgroundColor = APPCOLOR.TextLightGrayColor;
        vwTimer.setshadow(cornerR: 18, shadowC: .black, shadowO: 0.4, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
        vwTimer.backgroundColor = APPCOLOR.YellowCustom;
        self.btnSave.backgroundColor = APPCOLOR.redCustom;
        self.btnSave.titleLabel?.font = UIFont(name: font_reguler, size: 16);
        self.btnSave.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
		let templateImage1 = imgClock.image?.withRenderingMode(.alwaysTemplate)
		imgClock.image = templateImage1
		imgClock.tintColor = APPCOLOR.redCustom
        
    }

    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "CHOOSE C & VC");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    @IBAction func actionForSave(_ sender: Any) {
        if captainName == "" &&  VCName == "" {
            self.view.showToast(message: "Select your captain and vice captain")
        } else if captainName == "" {
            self.view.showToast(message: "Select your captain ")
        } else if VCName == "" {
            self.view.showToast(message: "Select your vice captain")
        } else {
            
            let tmp = self.arrSelectedPlayers
            let  captainId = tmp[captainIndex].playerId
            let  viceCaptainId = tmp[viceCaptainIndex].playerId
            arrFinalTeam.removeAllObjects();
            var count = 2
            for i in 0..<arrSelectedPlayers.count
            {
                let dict = arrSelectedPlayers[i]
                var newDict : [String:Any] = [:]
                newDict["player_id"] = dict.playerId
                newDict["team_id"] = dict.teamId
                
                
                if dict.playerId == captainId
                {
                   newDict["player_multiplier"] = "2"
                    newDict["player_pos"] = "1"
                }
               else if dict.playerId == viceCaptainId
                {
                    newDict["player_multiplier"] = "1.5"
                     newDict["player_pos"] = "2"
                }
                else
                {
                    count = count + 1
                   newDict["player_multiplier"] = "1"
                     newDict["player_pos"] = "\(count)"
                }
                
                arrFinalTeam.add(newDict)
            }
            print(arrFinalTeam)
            print(("final team \(arrFinalTeam)"))
            
            if self.strEditedTeamId.count > 0
            {
                self.SaveEditedTeamAPI()
            }
            else
            {
                self.SaveTeamAPI()
            }
        }
    }
    
    
    @IBAction func btnCaptainClicked(_ sender: UIButton) {
        if viceCaptainIndex == sender.tag {
            viceCaptainIndex = 100
            VCName = ""
        }
        
        captainIndex = sender.tag
        self.tblSelectedPlayer.reloadData()
        captainName =  self.arrSelectedPlayers[sender.tag].playerName
        lblCaptianStmt.text = self.captainName;
        imgCaptain.sd_setImage(with:  URL.init(string: self.arrSelectedPlayers[sender.tag].image),placeholderImage: UIImage.init(named: "user_icon"))
        
        
    }
    
    @IBAction func btnViceCaptainClicked(_ sender: UIButton) {
        if captainIndex == sender.tag {
            captainIndex = 100
            captainName = ""
        }
        
        viceCaptainIndex = sender.tag
        self.tblSelectedPlayer.reloadData()
        VCName =  self.arrSelectedPlayers[sender.tag].playerName
        lblVCStmt.text = self.VCName;
        imgVC.sd_setImage(with:  URL.init(string: self.arrSelectedPlayers[sender.tag].image),placeholderImage: UIImage.init(named: "user_icon"))
        
    }
    
    //MARK:- API Methods
    
    func SaveTeamAPI() {
        let jsonData = try? JSONSerialization.data(withJSONObject: arrFinalTeam, options: [])
        let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
        
        let headersParam = [
            "match_unique_id": String ("\(appdelegate.SingleMatchInfo.matchId ?? "0")"),
            "player_json": jsonString
            ] as! [String : String]
        
        HomeService.SaveTeamAPI(params: headersParam) { (flag, response, msg) in
            if flag{
                
                if self.fromClass == "teamList"{
                    let arr = self.navigationController!.viewControllers.filter({$0.isKind(of: TeamListJoinContestVC.self)});
                    if arr.count > 0{
                        self.navigationController!.popToViewController(arr.first!, animated: true)
                    }
                } else  if self.fromClass == "myTeamList"{
                    let arr = self.navigationController!.viewControllers.filter({$0.isKind(of: MyTeamVC.self)});
                    if arr.count > 0{
                        self.navigationController!.popToViewController(arr.first!, animated: true)
                    }
                } else  if self.fromClass == "PrivateContest"{
                    appdelegate.JoinTeamId = response ?? "0";
                    let arr = self.navigationController!.viewControllers.filter({$0.isKind(of: ChooseWinningBreakVC.self)});
                    if arr.count > 0{
                        self.navigationController!.popToViewController(arr.first!, animated: true)
                        NotificationCenter.default.post(name: Common.NotificationNames.JoinContestPrivateWithSingleTeam, object: nil);
                    }
                    
                } else  if self.fromClass == "contestDetailVC"{
                    appdelegate.JoinTeamId = response ?? "0";
                    let arr = self.navigationController!.viewControllers.filter({$0.isKind(of: ContestDetailVC.self)});
                    if arr.count > 0{
                        self.navigationController!.popToViewController(arr.first!, animated: true)
                        NotificationCenter.default.post(name: Common.NotificationNames.JoinContestDetailWithSingleTeam, object: nil);
                    }
                } else{
                    appdelegate.JoinTeamId = response ?? "0";
                    let arr = self.navigationController!.viewControllers.filter({$0.isKind(of: ContestVC.self)});
                    if arr.count > 0{
                        self.navigationController!.popToViewController(arr.first!, animated: true)
                        NotificationCenter.default.post(name: Common.NotificationNames.JoinContestWithSingleTeam, object: nil);
                    }
                }
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    
    func SaveEditedTeamAPI() {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: arrFinalTeam, options: [])
        let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
        
        let headersParam = [
            "match_unique_id": String ("\(appdelegate.SingleMatchInfo.matchId ?? "0")"),
            "customer_team_id": String (self.strEditedTeamId),
            "player_json": jsonString,
            ] as! [String : String]
        print(headersParam)
        
        HomeService.SaveEditedTeamAPI(params: headersParam) { (flag, msg) in
            if flag{
                if self.fromClass == "teamList"{
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: TeamListJoinContestVC.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
                else  if self.fromClass == "myTeamList"{
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: MyTeamVC.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                } else  if self.fromClass == "contestDetailVC"{
                    let arr = self.navigationController!.viewControllers.filter({$0.isKind(of: ContestDetailVC.self)});
                    if arr.count > 0{
                        self.navigationController!.popToViewController(arr.first!, animated: true)
                    }
                } else {
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ContestVC.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    // MARK: - TableView Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSelectedPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SelectedCaptionTCell", for:indexPath) as! SelectedCaptionTCell
    
        cell.btnC?.tag = indexPath.row
        cell.btnVC?.tag = indexPath.row
        cell.btnC?.addTarget(self, action: #selector(btnCaptainClicked(_:)), for: .touchUpInside)
        cell.btnVC?.addTarget(self, action: #selector(btnViceCaptainClicked(_:)), for: .touchUpInside)
//        cell.btnPlayer?.addTarget(self, action: #selector(btnPlayerInfo(_:)), for: .touchUpInside)
//        cell.btnPlayer?.tag = indexPath.row
        cell.configureLayoutScreen(self.arrSelectedPlayers[indexPath.row])
        cell.imgPoint.isHidden = true;
        if indexPath.row == captainIndex {
            cell.btnC?.backgroundColor = APPCOLOR.OrangeCustom
            cell.btnC?.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal)
            cell.btnC.borderColor = APPCOLOR.OrangeCustom
            cell.imgPoint.isHidden = false;
            cell.imgPoint.image = UIImage(named: "points2x");
        } else {
            cell.btnC?.backgroundColor = APPCOLOR.TextWhiteColor
            cell.btnC?.setTitleColor(APPCOLOR.TextBlackColor, for: .normal)
            cell.btnC.borderColor = APPCOLOR.TextGrayColor
        }
        
        if indexPath.row == viceCaptainIndex {
            cell.btnVC?.backgroundColor = APPCOLOR.BlueTintCustom
            cell.btnVC?.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal)
            cell.btnVC.borderColor = APPCOLOR.BlueTintCustom
            cell.imgPoint.isHidden = false;
            cell.imgPoint.image = UIImage(named: "points15x");
        } else {
            cell.btnVC?.backgroundColor = APPCOLOR.TextWhiteColor
            cell.btnVC?.setTitleColor(APPCOLOR.TextBlackColor, for: .normal)
            cell.btnVC.borderColor = APPCOLOR.TextGrayColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

