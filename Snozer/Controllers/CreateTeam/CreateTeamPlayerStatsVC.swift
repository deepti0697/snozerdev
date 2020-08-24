//
//  CreateTeamPlayerStatsVC.swift
//  Snozer
//
//  Created by Admin on 15/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class CreateTeamPlayerStatsVC: ViewController {

	@IBOutlet weak var layoutLblTitleC: NSLayoutConstraint!
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	var arrStats : [PlayerStatsDto] = [];
    @IBOutlet weak var btnBottom: UIButton!
    @IBOutlet weak var tblStats: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblCredits: UILabel!
    @IBOutlet weak var lblTotalPoints: UILabel!
    @IBOutlet weak var lblSkill1: UILabel!
    @IBOutlet weak var lblSkill1Des: UILabel!
    @IBOutlet weak var lblSkill2: UILabel!
    @IBOutlet weak var lblSkill2Des: UILabel!
    @IBOutlet weak var lblDob: UILabel!
    @IBOutlet weak var lblNationality: UILabel!
    var playerInfo : PlayerData!;
    var actionForTeamSelected : (_ info : PlayerData) -> () = { _ in }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
		self.layoutLblTitleC.constant = appdelegate.hasTopNotch ? 15 : 5
	
		tblStats.registerTableViewCellWithNib(nibName: "CreateTeamPlayerStatsCell");
		tblStats.backgroundColor = .white;
        self.callApiForStats();
        self.setData();
    }
    
    func setData() {
        self.imgUser.sd_setImage(with:  URL.init(string: self.playerInfo!.image),placeholderImage: UIImage.init(named: "user_icon"))
        self.lblTitle.text = self.playerInfo!.playerName;
        self.lblCredits.text = self.playerInfo.credits;
        self.lblTotalPoints.text = self.playerInfo.totalPoints;
        self.lblNationality.text = self.playerInfo.country;
        self.lblSkill1Des.text = self.playerInfo.batType;
        self.lblSkill2Des.text = self.playerInfo.bowlType;
        self.lblDob.text = self.playerInfo.dob;
        
        if appdelegate.matchType ==  kKabaddi{
            self.lblSkill1.text = "Height";
            self.lblSkill2.text = "Weight";
        } else if appdelegate.matchType == kFootball{
            self.lblSkill1.text = "Height";
            self.lblSkill2.text = "Weight";
        }
        
        if self.playerInfo.isSelected{
            self.btnBottom.setTitle("REMOVE FROM MY TEAM", for: .normal);
        }else{
            self.btnBottom.setTitle("ADD TO MY TEAM", for: .normal);
        }
        
    }
    
    func callApiForStats() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.CreateTeamPlayerStats + "/" + appdelegate.SingleMatchInfo.matchId + "/" + self.playerInfo!.playerId
        HomeService.GetCreateTeamPlayersStats(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                self.arrStats = response
                self.tblStats.delegate = self;
                self.tblStats.dataSource = self;
                self.tblStats.reloadData();
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    @IBAction func actionForClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    

    @IBAction func actionForAddDelete(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
        self.actionForTeamSelected(self.playerInfo);
    }


}

extension CreateTeamPlayerStatsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStats.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateTeamPlayerStatsCell") as! CreateTeamPlayerStatsCell
        cell.setData(data: arrStats[indexPath.row]);
        return cell;
    }
    
    
}
