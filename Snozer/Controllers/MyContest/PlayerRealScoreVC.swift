//
//  PlayerRealScoreVC.swift
//  Snozer
//
//  Created by Admin on 24/11/19.
//  Copyright © 2019 Calieo Technologies.. All rights reserved.
//

import UIKit

class PlayerRealScoreVC: ViewController {

    @IBOutlet weak var tblPlayer: UITableView!
    @IBOutlet weak var lblPointsBreakUpStmt: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPointsStmt: UILabel!
    @IBOutlet weak var lbPoints: UILabel!
    @IBOutlet weak var lblSelectedByStmt: UILabel!
    @IBOutlet weak var lblSelectedBy: UILabel!
    @IBOutlet weak var lblPlayersInStmt: UILabel!
    @IBOutlet weak var imgIn: UIImageView!
    @IBOutlet weak var lblTopPlayerStmt: UILabel!
    
    @IBOutlet weak var lblEventsStmt: UILabel!
    @IBOutlet weak var lblPointTblStmt: UILabel!
    @IBOutlet weak var lblActualStmt: UILabel!
    
    @IBOutlet weak var vwTopPlayer: UIView!
    @IBOutlet weak var vwContaienr: UIView!
    
    var playerSkills: PlayerStatsDto?;
    var arrPlayerSkills:[PlayerSkillDto] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp();
        self.tblPlayer.registerTableViewCellWithNib(nibName: "PlayerScoreTCell");
        self.setData();
    }
    
    func setData() {
        if let model = self.playerSkills{
            self.imgUser.sd_setImage(with:  URL.init(string: model.image),placeholderImage: UIImage.init(named: "user_icon"))
            self.lblName.text = model.name;
            self.lbPoints.text = model.points;
            self.lblSelectedBy.text = Double(model.selectedBy)!.clean + " " + "%";
            self.arrPlayerSkills = model.playerEvents;
            self.imgIn.tintColor = model.isMyPlayer == "Y" ? APPCOLOR.greenCustom : APPCOLOR.redCustom;
            self.lblPlayersInStmt.text = model.isMyPlayer == "Y" ? "Your Player" : "Not in your team";
            self.vwTopPlayer.isHidden = model.dreamTeamPlayer == "N";
            tblPlayer.tableFooterView = UIView();
            self.tblPlayer.reloadData();
        }
        
    }
    
    func setUp() {
        vwContaienr.setshadow(cornerR: 4, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        self.lblPointsBreakUpStmt.textColor = APPCOLOR.TextWhiteColor;
        self.lblName.textColor = APPCOLOR.TextBlackColor;
        self.lblPointsStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblSelectedByStmt.textColor = APPCOLOR.TextGrayColor;
        self.lbPoints.textColor = APPCOLOR.TextBlackColor;
        self.lblSelectedBy.textColor = APPCOLOR.TextBlackColor;
        
        self.lblPlayersInStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblTopPlayerStmt.textColor = APPCOLOR.TextGrayColor;
        
        self.lblEventsStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblPointTblStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblActualStmt.textColor = APPCOLOR.TextBlackColor;
        
        self.lblPointsBreakUpStmt.font = UIFont(name: font_reguler, size: 15);
        self.lblName.font = UIFont(name: font_reguler, size: 20);
        self.lblPointsStmt.font = UIFont(name: font_reguler, size: 12);
        self.lbPoints.font = UIFont(name: font_medium, size: 18);
        self.lblSelectedBy.font = UIFont(name: font_medium, size: 18);
        self.lblSelectedByStmt.font = UIFont(name: font_reguler, size: 12);
        self.lblPlayersInStmt.font = UIFont(name: font_reguler, size: 10);
        self.lblTopPlayerStmt.font = UIFont(name: font_reguler, size: 10);
        
        self.lblEventsStmt.font = UIFont(name: font_reguler, size: 12);
        self.lblPointTblStmt.font = UIFont(name: font_reguler, size: 12);
        self.lblActualStmt.font = UIFont(name: font_reguler, size: 12);
		self.tblPlayer.backgroundColor = .white;
        
    }
    
    
    
    @IBAction func actionForCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
}

extension PlayerRealScoreVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlayerSkills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerScoreTCell") as! PlayerScoreTCell
        cell.setCellInfo(model: arrPlayerSkills[indexPath.row]);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
        
}
