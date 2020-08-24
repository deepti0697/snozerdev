//
//  PlayerStatsVC.swift
//  Snozer
//
//  Created by Admin on 24/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PlayerStatsVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	var arrPlayers : [PlayerStatsDto] = [];
    @IBOutlet weak var tblPlayers: UITableView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblPlayerStmt: UILabel!
    @IBOutlet weak var lblPointsStmt: UILabel!
    @IBOutlet weak var lblSelectedStmt: UILabel!
    @IBOutlet weak var vwYourPlayers: UIView!
    @IBOutlet weak var vwTopPlayer: UIView!
    @IBOutlet weak var lblYourPlayerStmt: UILabel!
    @IBOutlet weak var lblTopPlayerStmt: UILabel!
    var headerView : NavHeaderView?
    var isMatchComplete = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
        tblPlayers.registerTableViewCellWithNib(nibName: "PlayerStatsCell");
        self.callApiForPlayerStats();
    }
    

        func setHeaderView() {
            headerView = NavHeaderView.loadViewFromNib();
            headerView?.parentVC = self;
            headerView?.stckLeft.isHidden = true;
            vwHeader.addSubview(headerView!);
            headerView?.setHeaderinfo(title: "PLAYER STATS");
            headerView?.lblNotificationCount.isHidden = true;
            headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
            
        }
    
    func setUp() {
		
		self.tblPlayers.backgroundColor = .white;
        self.lblPlayerStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblSelectedStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblPointsStmt.textColor = APPCOLOR.TextBlackColor;
        
        self.lblYourPlayerStmt.textColor = APPCOLOR.TextWhiteColor;
        self.lblTopPlayerStmt.textColor = APPCOLOR.TextWhiteColor;
        
        self.lblPlayerStmt.font = UIFont(name: font_medium, size: 12);
        self.lblSelectedStmt.font = UIFont(name: font_medium, size: 12);
        self.lblPointsStmt.font = UIFont(name: font_medium, size: 12);
        self.lblTopPlayerStmt.font = UIFont(name: font_medium, size: 12);
        self.lblYourPlayerStmt.font = UIFont(name: font_medium, size: 12);
        self.vwTopPlayer.isHidden = !isMatchComplete
        
    }
    
    func callApiForPlayerStats() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.MatchPlayerStats + "/" + appdelegate.SingleMatchInfo.matchId;
        HomeService.GetMatchTeamStats(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                self.arrPlayers = response;
                self.tblPlayers.reloadData();
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
}

extension PlayerStatsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlayers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "PlayerStatsCell") as! PlayerStatsCell
        cell.setCellInfo(model: arrPlayers[indexPath.row]);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerRealScoreVC") as! PlayerRealScoreVC
        vc.playerSkills = self.arrPlayers[indexPath.row];
        vc.modalPresentationStyle = .overCurrentContext;
        self.present(vc, animated: true, completion: nil);
    }
    
}
