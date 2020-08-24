//
//  MatchScoreTCell.swift
//  Snozer
//
//  Created by Admin on 17/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class MatchScoreTCell: UITableViewCell {

	@IBOutlet weak var stckScore: UIStackView!
	@IBOutlet weak var lblNoMatchStartYet: UILabel!
	@IBOutlet weak var lblScoreCardStmt: UILabel!
    @IBOutlet weak var lblTeam1: UILabel!
    @IBOutlet weak var lblTeam1Score: UILabel!
    @IBOutlet weak var lblTeam2: UILabel!
    @IBOutlet weak var lblTeam2Score: UILabel!
    @IBOutlet weak var lblWinningStmt: UILabel!
    @IBOutlet weak var lblViewPlayerStmt: UILabel!
    var parentVC : UIViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp() {
        
        self.lblScoreCardStmt.font = UIFont(name: font_medium, size: 12);
        self.lblTeam1.font = UIFont(name: font_reguler, size: 11);
        self.lblTeam2.font = UIFont(name: font_reguler, size: 11);
        self.lblTeam1Score.font = UIFont(name: font_reguler, size: 11);
        self.lblTeam2Score.font = UIFont(name: font_reguler, size: 11);
        self.lblWinningStmt.font = UIFont(name: font_reguler, size: 11);
        self.lblViewPlayerStmt.font = UIFont(name: font_medium, size: 12);
        
        self.lblScoreCardStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblTeam1.textColor = APPCOLOR.TextBlackColor;
        self.lblTeam2.textColor = APPCOLOR.TextBlackColor;
        self.lblTeam1Score.textColor = APPCOLOR.TextBlackColor;
        self.lblTeam2Score.textColor = APPCOLOR.TextBlackColor;
        self.lblWinningStmt.textColor = APPCOLOR.TextBlackColor;
    }
    
    func setInfo(model: MatchScoreDto)  {
        self.lblTeam1.text = model.team1?.sortName;
        self.lblTeam2.text = model.team2?.sortName;
        self.lblWinningStmt.text = model.notes;
	stckScore.isHidden = false;
	lblNoMatchStartYet.isHidden = true
	if model.team1?.teamRun == "0" &&  model.team2?.teamRun == "0"{
		stckScore.isHidden = true;
		lblNoMatchStartYet.isHidden = false
	}
        if appdelegate.matchType == kCricket{
            lblTeam1Score.text = "\(model.team1!.teamRun)/\(model.team1!.teamWicket) (\(model.team1!.teamOvers) ov)";
            lblTeam2Score.text = "\(model.team2!.teamRun)/\(model.team2!.teamWicket) (\(model.team2!.teamOvers) ov)";
        }else{
            lblTeam1Score.text = model.team1?.teamRun;
            lblTeam2Score.text = model.team2?.teamRun;
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionForPlayerStats(_ sender: Any) {
    }
    
}
