//
//  PlayerRealInfoCell.swift
//  Snozer
//
//  Created by Admin on 10/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class PlayerRealInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var vwNoStats: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tblPlayer.registerTableViewCellWithNib(nibName: "PlayerScoreTCell");
        self.setUp();
    }
    
    @IBOutlet weak var tblPlayer: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgPlayerType: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPointsStmt: UILabel!
    @IBOutlet weak var lbPoints: UILabel!
    @IBOutlet weak var lblSelectedByStmt: UILabel!
    @IBOutlet weak var lblSelectedBy: UILabel!

    @IBOutlet weak var lblEventsStmt: UILabel!
    @IBOutlet weak var lblPointTblStmt: UILabel!
    @IBOutlet weak var lblActualStmt: UILabel!
    
    
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblPlayerType: UILabel!
    @IBOutlet weak var vwContaienr: UIView!
    
    var playerSkills: PlayerStatsDto?;
    var arrPlayerSkills:[PlayerSkillDto] = [];
    
    func setCellData() {
        self.setData();
    }
    
    func setData() {
        if let model = self.playerSkills{
            self.imgUser.sd_setImage(with:  URL.init(string: model.image),placeholderImage: UIImage.init(named: "user_icon"))
            self.lblName.text = model.name;
            self.lbPoints.text = model.points;
            self.lblSelectedBy.text = Double(model.selectedBy)!.clean + " " + "%";
            self.arrPlayerSkills = model.playerEvents;
            self.lblTeamName.text = model.teamData?.sortName;
            self.imgPlayerType.isHidden = model.dreamTeamPlayer == "N"
            self.lblPlayerType.text = playerTypeDict[model.position.lowercased()];
            tblPlayer.tableFooterView = UIView();
			self.tblPlayer.backgroundColor = .white;
            self.vwNoStats.isHidden = true;
            if self.arrPlayerSkills.count == 0{
                self.vwNoStats.isHidden = false;
            }
            self.tblPlayer.reloadData();
        }
        
    }
    
    func setUp() {
        vwContaienr.setshadow(cornerR: 4, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        self.lblName.textColor = APPCOLOR.TextBlackColor;
        self.lblPointsStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblSelectedByStmt.textColor = APPCOLOR.TextGrayColor;
        self.lbPoints.textColor = APPCOLOR.TextBlackColor;
        self.lblSelectedBy.textColor = APPCOLOR.TextBlackColor;
        
        self.lblPlayerType.textColor = APPCOLOR.TextGrayColor;
        self.lblTeamName.textColor = APPCOLOR.TextBlackColor;
        
        self.lblEventsStmt.textColor = APPCOLOR.TextGrayColor;
        self.lblPointTblStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblActualStmt.textColor = APPCOLOR.TextBlackColor;
        
        self.lblName.font = UIFont(name: font_reguler, size: 20);
        self.lblPointsStmt.font = UIFont(name: font_reguler, size: 12);
        self.lbPoints.font = UIFont(name: font_medium, size: 18);
        self.lblSelectedBy.font = UIFont(name: font_medium, size: 18);
        self.lblSelectedByStmt.font = UIFont(name: font_reguler, size: 12);
        
        self.lblEventsStmt.font = UIFont(name: font_reguler, size: 12);
        self.lblPointTblStmt.font = UIFont(name: font_reguler, size: 12);
        self.lblActualStmt.font = UIFont(name: font_reguler, size: 12);
        
        self.lblPlayerType.font = UIFont(name: font_reguler, size: 12);
        self.lblTeamName.font = UIFont(name: font_reguler, size: 12);
        
    }
    
    
}

extension PlayerRealInfoCell: UITableViewDelegate, UITableViewDataSource{
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
