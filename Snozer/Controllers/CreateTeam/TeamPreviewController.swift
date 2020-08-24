//
//  TeamPreviewController.swift
//  Cricshot
//
//  Created by apple on 22/01/19.
//  Copyright © 2019 Cricshot. All rights reserved.
//

import UIKit
import SVProgressHUD

class sectionPlayer {
    var title : String = "";
    var arrPlayers : [PlayerData] = [];
}

class TeamPreviewController: ViewController, UITableViewDelegate,UITableViewDataSource {

    //    var arrCategories
    var team1 = Int()
    var team2 = Int()
    
    ///--Gasture
    typealias typeCompletionHandler = () -> ()
    var completion : typeCompletionHandler = {}
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    var sportsType = "";
    var matchUrl = "";
    
    var cellId = "Cell"
    var isFromCreateteam = Int()
    var isTopTeam = false;
    var matchid = "";
    var matchProgress = "F";
    var fromClass = "myTeamList"
    var selectedTeamID = String()
    
    @IBOutlet weak var lblTeamRank: UILabel!
    
    /////--- New Outlets
    @IBOutlet weak var lblTeamName: UILabel!
    
    @IBOutlet weak var lblTeam1Player: UILabel!
    @IBOutlet weak var lblTeam2Player: UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    
    ////////////
    var arrSectionPlayers : [sectionPlayer] = [];

    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    var parentVC : UIViewController?
    
    var selectedTeam :  Jointeam!
    var arrSelectedPlayers  = [PlayerData]()
    var isExpertTeam = false;
    var isShowPoints = false;
    
    @IBOutlet var viewNavigation : UIView!
    
    var str_team1Id: String = ""
    var str_team2Id: String = ""
    let activityView = UIActivityIndicatorView(style: .whiteLarge)
    let str_resueIdentifier = String(describing: type(of: PlayerLayoutCollectionViewCell()))
    
    var cell_w = CGFloat()
    var strTeamName : String = "";
    var strTeamRank = String()
    
    @IBOutlet weak var vwNoPlayers: UIView!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var viewPoints: UIView!
    @IBOutlet weak var lblPoints: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if sportsType == kCricket{
            imgBackground.image = UIImage(named: "CricketBG");
        }else if sportsType == kFootball{
            imgBackground.image = UIImage(named: "FootBallBG");
        }else{
            imgBackground.image = UIImage(named: "kabaddiBG");
        }
        btnEdit.isHidden = true
        btnShare.isHidden = true
        
        if isTopTeam{
            btnShare.isHidden = false
        }
        

        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        self.tblMain.separatorStyle = .none
        tblMain.register(UINib(nibName: "PlayerTypeCell", bundle: nil), forCellReuseIdentifier: "PlayerTypeCell")
        self.tblMain.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if self.isFromCreateteam != 1 {
            self.getTeamData()
        } else {
            viewPoints.isHidden = true
            if arrSelectedPlayers.count == 0{
                vwNoPlayers.isHidden = false;
                btnEdit.isHidden = true
                btnShare.isHidden = true
            }
            self.teamPreviewSetupFoCreateTeam()
        }
        
        if isFromCreateteam == 2 {
		btnEdit.isHidden = false
		btnShare.isHidden = false
		viewPoints.isHidden = true
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if !appdelegate.hasTopNotch {
            //            self.constraintTopViewTop.constant = -12
        }
        if self.navigationController != nil {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    

    func getSectionPlayerInfo( title: String, arr : [PlayerData] = []) -> sectionPlayer {
        let sect = sectionPlayer();
        sect.title = title;
        sect.arrPlayers = arr;
        return sect
    }
    
    @IBAction func actionForDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    func teamPreviewSetupFoCreateTeam() {
        viewPoints.isHidden = true;
	lblTeamName.text = "TEAM"
        if arrSelectedPlayers.count > 0 {
        
            if sportsType == kCricket{
                //cricket
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerWK, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "wicketkeeper"})))
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerBAT, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "batsman"})))
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerAR, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "allrounder"})))
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerBOWL, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "bowler"})))
                
            } else if sportsType == kFootball{
                //FootBall
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerGK, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "goalkeeper"})))
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerDEF, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "defender"})))
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerMID, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "midfielder"})))
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerST, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "forward"})))
                
            } else{
                //Kabaddi
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerDEFEN, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "defender"})))
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerAL, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "allrounder"})))
                self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerRAID, arr: arrSelectedPlayers.filter({$0.position.lowercased() == "raider"})))
            }
            
            self.tblMain.delegate =  self
            self.tblMain.dataSource = self
            self.tblMain.reloadData()
        }
        
    }
    
    // MARK: - Button Methods
    @IBAction func BackButton(_ sender: Any) {
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API Call
    func getTeamData() -> Void {
        
        var strURl = "";
        if isTopTeam{
            strURl = String("\(APPURL.BaseURL)\(matchUrl)\(APPURL.TopTeam)/\(appdelegate.SingleMatchInfo.matchId!)")
        } else{
            strURl = String("\(APPURL.BaseURL)\(matchUrl)\(APPURL.CustomerTeamDetail)/\(selectedTeamID)")
        }
        
        
        HomeService.getTeamData(_apiName: strURl, params: [:]) { (flag, response, msg) in
            if flag{
                var points: Double = 0.0
                if let info = response{
                    self.selectedTeam = info;
                    self.str_team1Id = info.team1.id;
                    if self.isTopTeam{
                        self.lblTeamName.text = "TOP TEAM";
                        self.btnShare.isHidden = true;
                    } else{
                        if self.isExpertTeam{
                            self.lblTeamName.text = self.strTeamName
                            self.lblTeamRank.isHidden = false
                            self.lblTeamRank.text = "Rank " + self.strTeamRank
                            self.btnShare.isHidden = false;
                        } else{
                            if self.strTeamName != ""{
                                self.lblTeamName.text = self.strTeamName
                            }else{
                                self.lblTeamName.text = "TEAM \(info.name ?? "")";
                            }
                            if self.matchProgress != "F"{
                                self.lblTeamRank.isHidden = false
                                self.lblTeamRank.text = "Rank " + self.strTeamRank
                                self.btnEdit.isHidden = true;
//                                self.btnShare.isHidden = false;
                            }
                        }
                    }

                    self.arrSectionPlayers.removeAll();
                    
                    if self.sportsType == kCricket{
                        //cricket
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerWK, arr: self.selectedTeam.wicketkeapers ?? []))
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerBAT, arr: self.selectedTeam.batsmans ?? []))
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerAR, arr: self.selectedTeam.allrounders ?? []))
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerBOWL, arr: self.selectedTeam.bowlers ?? []))
                        
                        for itm in self.selectedTeam.wicketkeapers {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }
                        
                        for itm in self.selectedTeam.batsmans {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }
                        
                        for itm in self.selectedTeam.allrounders {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }
                        
                        for itm in self.selectedTeam.bowlers {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }

                    } else if self.sportsType == kFootball{
                        //FootBall
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerGK, arr: self.selectedTeam.wicketkeapers ?? []))
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerDEF, arr: self.selectedTeam.batsmans ?? []))
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title:  CreateTeamAlert.strPlayerMID, arr: self.selectedTeam.allrounders ?? []))
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerST, arr: self.selectedTeam.bowlers ?? []))
                        
                        for itm in self.selectedTeam.wicketkeapers {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }
                        
                        for itm in self.selectedTeam.batsmans {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }
                        
                        for itm in self.selectedTeam.allrounders {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }
                        
                        for itm in self.selectedTeam.bowlers {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }
                        
                    } else {
                        //Kabaddi
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerDEFEN, arr: self.selectedTeam.bowlers ?? []))
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerAL, arr: self.selectedTeam.allrounders ?? []))
                        self.arrSectionPlayers.append(self.getSectionPlayerInfo(title: CreateTeamAlert.strPlayerRAID, arr: self.selectedTeam.batsmans ?? []))
                        
                        for itm in self.selectedTeam.batsmans {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }
                        
                        for itm in self.selectedTeam.allrounders {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }
                        
                        for itm in self.selectedTeam.bowlers {
                            points = points + Double(itm.points)! * itm.playerMultiplier
                        }
                        
                    }
                    self.tblMain.delegate =  self
                    self.tblMain.dataSource = self
                    self.tblMain.reloadData()
                    if self.isShowPoints{
                        if points > 0{
                            self.viewPoints.isHidden = false
                        }else{
                            self.viewPoints.isHidden = true
                        }
                    }else{
                        self.viewPoints.isHidden = true
                    }
                    
                    self.lblPoints.text = points.clean
                }
                
                
            }else{
                self.view.showToast(message:msg);
            }
        }
        
    }
    
    // MARK: - Custom Functions
    func layoutData() -> Void
    {}
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSectionPlayers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTypeCell", for: indexPath) as! PlayerTypeCell
        cell.playerCollection.tag =  11 + indexPath.row
        cell.lblPlayerName.text = self.arrSectionPlayers[indexPath.row].title;
        cell.backgroundColor = UIColor.clear
        cell.matchId = self.matchid;
        cell.isFromCreateteam = self.isFromCreateteam;
        cell.isShowPoints = self.isShowPoints;
        cell.isTopTeam = self.isTopTeam;
        cell.arrTeams = self.arrSectionPlayers[indexPath.row].arrPlayers;
        cell.team1Id = self.str_team1Id;
        cell.customerTeamID = selectedTeamID;
        cell.parentVC = self;
        cell.superParentVC = parentVC
        cell.playerCollection.reloadData();
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  self.tblMain.frame.size.height/(CGFloat.init(self.arrSectionPlayers.count))
    }
    
    // MARK: - Tap Gastures
    
    @IBAction func actionForEdit(_ sender: Any) {
        self.dismiss(animated: false, completion: nil);
        if sportsType == kCricket{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
            vc.isEditing = true;
            vc.strEditedTeamId = selectedTeamID;
            vc.editTeamData = self.selectedTeam;
            vc.fromClass = fromClass
            parentVC?.navigationController?.pushViewController(vc, animated: true);
        }else if sportsType == kFootball{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
            vc.isEditing = true;
            vc.strEditedTeamId = selectedTeamID;
            vc.editTeamData = self.selectedTeam;
            vc.fromClass = fromClass
            parentVC?.navigationController?.pushViewController(vc, animated: true);
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
            vc.isEditing = true;
            vc.strEditedTeamId = selectedTeamID;
            vc.editTeamData = self.selectedTeam;
            vc.fromClass = fromClass
            parentVC?.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    @IBAction func actionForShare(_ sender: Any) {
        self.dismiss(animated: false, completion: nil);
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareTeamVC") as! ShareTeamVC;
        vc.teamInfo = self.selectedTeam;
        parentVC?.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer)
    {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began
        {
            initialTouchPoint = touchPoint
        }
        else if sender.state == UIGestureRecognizer.State.changed
        {
            if touchPoint.y - initialTouchPoint.y > 0
            {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
        else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled
        {
            if touchPoint.y - initialTouchPoint.y > 100
            {
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}
