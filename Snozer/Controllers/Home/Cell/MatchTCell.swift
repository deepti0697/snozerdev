//
//  MatchTCell.swift
//  Snozer
//
//  Created by Admin on 30/09/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import SDWebImage

class MatchTCell: UITableViewCell {
    
    @IBOutlet weak var vwJoinedContest: UIView!
    @IBOutlet weak var lblJoinedContest: UILabel!
    @IBOutlet weak var lblMatchTitle: UILabel!
    @IBOutlet weak var bgContainer: UIView!
    @IBOutlet weak var vwLeft: UIView!
    @IBOutlet weak var vwRight: UIView!
    @IBOutlet weak var vwVs: UIView!
    
    @IBOutlet weak var imgTeam1: UIImageView!
    
    @IBOutlet weak var imgTeam2: UIImageView!
    
    @IBOutlet weak var lblTeamName1: UILabel!
    
    @IBOutlet weak var lblMatchType: UILabel!
    @IBOutlet weak var lblTeamName2: UILabel!

    @IBOutlet weak var imgClock: UIImageView!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var vwGrayout: UIView!
    
    @IBOutlet weak var lblDate: UILabel!
    var match : HomeMatchList!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp();
    }
    
    func setUp() {
        
        self.vwVs.cornerRadius = 15;
        self.vwVs.backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1);
//        self.vwVs.borderColor = APPCOLOR.TextWhiteColor;
//        self.vwVs.borderWidth = 2;
        
//        self.vwVs.setshadow(cornerR: 11, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        self.bgContainer.setshadow(cornerR: 4, shadowC: .darkGray, shadowO: 0.4, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.vwLeft.roundCorners([.topLeft,.bottomLeft], radius: 6);
            self.vwRight.roundCorners([.topRight,.bottomRight], radius: 6);
        }
        
        
        self.lblTeamName1.font = UIFont(name: font_bold, size: 10);
        self.lblTeamName2.font = UIFont(name: font_bold, size: 10);
        self.lblMatchType.font = UIFont(name: font_bold, size: 14);
        self.lblTimer.font = UIFont(name: font_reguler, size: 11);
    
        self.lblDate.font = UIFont(name: font_reguler, size: 10);
        self.lblDate.textColor = APPCOLOR.TextBlackColor;
        
        self.imgClock.tintColor = APPCOLOR.greenCustom;
        self.lblMatchTitle.font = UIFont(name: font_bold, size: 10);
        self.lblMatchTitle.textColor = APPCOLOR.TextBlackColor;
        self.lblJoinedContest.textColor = APPCOLOR.TextBlackColor;
        self.lblJoinedContest.font = UIFont(name: font_reguler, size: 12);
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureLayoutScreen(_ matchData : HomeMatchList) -> Void {
        match = matchData;
        self.imgTeam1?.sd_setImage(with:  URL.init(string: matchData.team1.image),placeholderImage: UIImage.init(named: "dummyTeam"))
        self.imgTeam2?.sd_setImage(with:  URL.init(string: matchData.team2.image),placeholderImage: UIImage.init(named: "dummyTeam"))
        
        self.lblTeamName1.text = (matchData.team1.sortName.count > 6 ? String(matchData.team1.sortName.prefix(6)).uppercased() : matchData.team1.sortName).uppercased()
        
        self.lblTeamName2.text = (matchData.team2.sortName.count > 6 ? String(matchData.team2.sortName.prefix(6)).uppercased() : matchData.team2.sortName).uppercased()

        self.lblMatchType.text =  String("\(matchData.gametype.name ?? "")")
        self.lblMatchTitle.text = matchData.series.name;
        self.lblDate.textColor = APPCOLOR.TextBlackColor;
        self.lblDate.text = Double(matchData.matchDate)!.getDate("dd-MM-yyyy");
        self.lblDate.isHidden = true;
        if matchData.playingSquadUpdate == "Y" && matchData.matchProgress == "F"{
            self.lblDate.isHidden = false;
            self.lblDate.text = "Line Up Out"
            self.lblDate.textColor = APPCOLOR.greenCustom;
        }
        
        
        
        if matchData.contestCount == "0" && matchData.matchProgress == "F"{
            self.vwGrayout.isHidden = false
        } else {
           self.vwGrayout.isHidden = true
        }
        self.lblJoinedContest.text = "\(matchData.contestCount ?? "0") Contest Joined"
	
		if matchData.matchProgress == "AB"{
			self.lblTimer?.text = "Abandoned";
			self.lblTimer.textColor = APPCOLOR.redCustom;
			self.lblDate.isHidden = false;
			self.imgClock.isHidden = true;
		}else{
			self.gameTime()
		}
        
    }
    
    @objc func gameTime() {
        let (time, what) = UIApplication.matchTime(match)
        if what {
            self.imgClock.isHidden = false;
            self.lblTimer.textColor = APPCOLOR.TextBlackColor;
			
        } else {
            self.imgClock.isHidden = true;
            self.lblTimer.textColor = time == "Completed" ? APPCOLOR.greenCustom : (time == "Abandoned" ? APPCOLOR.redCustom : APPCOLOR.greenCustom) // OrangeCustom
            if time == "Completed"{
                self.lblDate.isHidden = false;
            }
        }
		if match.matchProgress == "AB"{
			self.lblTimer?.text = "Abandoned";
			self.lblTimer.textColor = APPCOLOR.redCustom;
			self.lblDate.isHidden = false;
			self.imgClock.isHidden = true;
		}else{
			self.lblTimer?.text = time
		}
        
		
      }
}
