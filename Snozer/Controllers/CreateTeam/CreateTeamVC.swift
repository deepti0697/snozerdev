//
//  CreateTeamVC.swift
//  Snozer
//
//  Created by Admin on 11/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class CreateTeamVC: ViewController {
    
	@IBOutlet weak var layoutLblTimeC: NSLayoutConstraint!
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	
    var matchSetting : TeamSetting?
    
    @IBOutlet weak var vwUpper: UIView!
    @IBOutlet weak var lblPlayerStmt: UILabel!
    @IBOutlet weak var lblCreditLimitStmt: UILabel!
    @IBOutlet weak var lblPlayerCount: UILabel!
    @IBOutlet weak var lblCredits: UILabel!
    @IBOutlet weak var lblTeam1Count: UILabel!
    @IBOutlet weak var lblTeam1Name: UILabel!
    @IBOutlet weak var lblTeam2Name: UILabel!
    @IBOutlet weak var imgTeam1: UIImageView!
    @IBOutlet weak var lblTeam2Count: UILabel!
    @IBOutlet weak var imgTeam2: UIImageView!
    @IBOutlet weak var vwLineUpper: UILabel!

    @IBOutlet weak var lblPickupCount: UILabel!
    
    @IBOutlet weak var vwPlayerPickupCount: UIView!
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var vwPlayersHeader: UIView!
    @IBOutlet weak var lblInfoStmt: UILabel!
    
    @IBOutlet weak var btnPlayer: UIButton!
    
    @IBOutlet weak var imgPlayerArrow: UIImageView!
    
    @IBOutlet weak var btnPoints: UIButton!
    
    @IBOutlet weak var imgPointsArrow: UIImageView!
    
    @IBOutlet weak var btnCredits: UIButton!
    @IBOutlet weak var imgCreditsArrow: UIImageView!
    @IBOutlet weak var tblPlayers: UITableView!
    
    @IBOutlet weak var btnTeamPreview: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblCat1: UILabel!
    @IBOutlet weak var lblCat2: UILabel!
    @IBOutlet weak var lblCat3: UILabel!
    @IBOutlet weak var lblCat4: UILabel!
    
    @IBOutlet weak var vwCat1: UIView!
    @IBOutlet weak var vwCat2: UIView!
    @IBOutlet weak var vwCat3: UIView!
    @IBOutlet weak var vwCat4: UIView!
    
    @IBOutlet weak var lblCat1Count: UILabel!
    @IBOutlet weak var lblCat2Count: UILabel!
    @IBOutlet weak var lblCat3Count: UILabel!
    @IBOutlet weak var lblCat4Count: UILabel!
    
    @IBOutlet weak var imgCat1: UIImageView!
    @IBOutlet weak var imgCat2: UIImageView!
    @IBOutlet weak var imgCat3: UIImageView!
    @IBOutlet weak var imgCat4: UIImageView!
    
    var diff_seconds = 0.0;
    var timer = Timer()
    var strGameType = String()
    var fromClass = String()
    var strEditedTeamId = String()
    var isClone = Bool()
    
    
    var arrTeamPlayers  = [PlayerData]()
    var arrSelectedTeamPlayers  = [PlayerData]()
    var arrPlayersCate1  = [PlayerData]()
    var arrPlayersCate2  = [PlayerData]()
    var arrPlayersCate3  = [PlayerData]()
    var arrPlayersCate4  = [PlayerData]()
    var arrPlayersCate5 = [PlayerData]()
    
    
    
    //--Model object
    var  objTeamPlayer : PlayerData!
    var  objTeamList : PlayerList!
    
    //--Model object
    
    
    //-- Varaible for Team select
    var totalPlayers = Int()
    var totalSelectedPlayers = Int()
    
    var totalCredits = Int()
    var totalLeftCredits = Float()
    
    var team1SelectedPlayers = Int()
    var team2SelectedPlayers = Int()
    
    var team1Name = String()
    var team2Name = String()
    
    var Cat1SelectedPlayer = Int()
    var Cat2SelectedPlayer = Int()
    var Cat3SelectedPlayer = Int()
    var Cat4SelectedPlayer = Int()
    var Cat5SelectedPlayer = Int()
    
    var Cat1MinimumPlayer = Int()
    var Cat2MinimumPlayer = Int()
    var Cat3MinimumPlayer = Int()
    var Cat4MinimumPlayer = Int()
    var Cat5MinimumPlayer = Int()
    
    var Cat1MaximumPlayer = Int()
    var Cat2MaximumPlayer = Int()
    var Cat3MaximumPlayer = Int()
    var Cat4MaximumPlayer = Int()
    var Cat5MaximumPlayer = Int()
    
    var MaxTeamPlayer = Int()
    var teamAId = Int()
    var teamBId = Int()
    
    var editTeamData : Jointeam?
    
    var  SelectedPlayerType = Int()
    
    ///----- filter outlets
    var isPlayer : Bool?
    var isCredit : Bool?
    var isSelectedBy : Bool?
    var isPoints : Bool?
    var selectedSort = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
	self.layoutLblTimeC.constant = appdelegate.hasTopNotch ? 15 : 5
        self.setUp();
        self.tblPlayers.registerTableViewCellWithNib(nibName: "CreateTeamTCell");
        isPlayer = false
        isPoints = false
        isCredit = false
        self.totalSelectedPlayers = 0
        selectedSort = 2
        self.SelectedPlayerType = 0
        self.callApiForPlayersInfo();

// Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tick), name:  Common.NotificationNames.Tick, object: nil)
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
            self.lblTimer.text = time_diff + " Left"
        }
    }
    
    
    func setUp() {
        
		
		self.tblPlayers.backgroundColor = .white;
        self.lblTeam1Count.text = "0";
        self.lblTeam2Count.text = "0";
        
        self.lblPlayerStmt.font = UIFont(name: font_reguler, size: 11);
        self.lblPlayerStmt.textColor = APPCOLOR.TextGrayColor;
        
        self.lblCreditLimitStmt.font = UIFont(name: font_reguler, size: 11);
        self.lblCreditLimitStmt.textColor = APPCOLOR.TextGrayColor;
        
        self.lblPlayerCount.font = UIFont(name: font_medium, size: 12);
        self.lblPlayerCount.textColor = APPCOLOR.TextBlackColor;
        self.lblCredits.font = UIFont(name: font_medium, size: 12);
        self.lblCredits.textColor = APPCOLOR.TextBlackColor;
        
        self.lblTeam1Name.font = UIFont(name: font_reguler, size: 10);
        self.lblTeam1Name.textColor = APPCOLOR.TextGrayColor;
        self.lblTeam2Name.font = UIFont(name: font_reguler, size: 10);
        self.lblTeam2Name.textColor = APPCOLOR.TextGrayColor;
        self.lblTeam1Count.font = UIFont(name: font_medium, size: 10);
        self.lblTeam1Count.backgroundColor = APPCOLOR.greenCustom;
        self.lblTeam1Count.textColor = APPCOLOR.TextWhiteColor;
        self.lblTeam2Count.font = UIFont(name: font_medium, size: 10);
        self.lblTeam2Count.backgroundColor = APPCOLOR.greenCustom;
        self.lblTeam2Count.textColor = APPCOLOR.TextWhiteColor;
        
        self.lblTeam1Count.cornerRadius = 10;
        self.lblTeam2Count.cornerRadius = 10;
        self.lblPickupCount.font = UIFont(name: font_reguler, size: 12);
        self.lblPickupCount.textColor = APPCOLOR.TextBlackColor;
        
        self.vwPlayerPickupCount.backgroundColor = AppYellow;
        self.vwPlayerPickupCount.setshadow(cornerR: 4, shadowC: .black, shadowO: 0.4, shadowR: 4, shadowOffset: CGSize(width: 1, height: 2));
        
        self.lblInfoStmt.textColor = APPCOLOR.TextWhiteColor;
        self.lblInfoStmt.font = UIFont(name: font_reguler, size: 10);
        
        self.vwPlayersHeader.backgroundColor = APPCOLOR.redCustom;
        
        for btn in [btnPlayer, btnPoints, btnCredits] {
            btn?.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
            btn?.titleLabel?.font = UIFont(name: font_reguler, size: 10);
        }
        
        self.btnTeamPreview.backgroundColor = APPCOLOR.redCustom;
        self.btnNext.backgroundColor = APPCOLOR.TextLightGrayColor;
        
        self.btnTeamPreview.titleLabel?.font = UIFont(name: font_bold, size: 14);
        self.btnNext.titleLabel?.font = UIFont(name: font_bold, size: 14);
        
        self.btnNext.setTitleColor(APPCOLOR.TextBlackColor, for: .normal);
        self.btnTeamPreview.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        
        
        for img in [imgCat1, imgCat2, imgCat3, imgCat4] {
            img?.cornerRadius = 25;
            img?.borderWidth = 2.0;
            img?.borderColor = APPCOLOR.TextLightGrayColor;
        }
        
        for vw in [vwCat1, vwCat2, vwCat3, vwCat4] {
            vw?.cornerRadius = 15;
            vw?.clipsToBounds = true;
            vw?.backgroundColor = APPCOLOR.TextLightGrayColor;
        }
        
        for lbl in [lblCat1Count, lblCat2Count, lblCat3Count, lblCat4Count]{
            lbl?.font = UIFont(name: font_reguler, size: 10);
            lbl?.textColor = APPCOLOR.TextBlackColor;
        }
        
        for lbl in [lblCat1, lblCat2, lblCat3, lblCat4]{
            lbl?.font = UIFont(name: font_reguler, size: 10);
            lbl?.textColor = APPCOLOR.TextBlackColor;
        }
        
		for img in [imgPlayerArrow, imgCreditsArrow, imgPointsArrow]{
			let templateImage = img?.image?.withRenderingMode(.alwaysTemplate)
			img?.image = templateImage
			img?.tintColor = APPCOLOR.TextWhiteColor
        }
//		let templateImage = imgCreditsArrow.image?.withRenderingMode(.alwaysTemplate)
//		imgCreditsArrow.image = templateImage
//		imgCreditsArrow.tintColor = APPCOLOR.TextWhiteColor
		
        lblCat1.textColor = APPCOLOR.redCustom;
        lblCat1Count.textColor = APPCOLOR.TextWhiteColor;
        vwCat1.backgroundColor = AppYellow
        imgCat1.borderColor = APPCOLOR.redCustom;
        
    }
    
    func callApiForPlayersInfo() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetMatchPalyers + "/" + appdelegate.SingleMatchInfo.id
        HomeService.GetPlayers(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                if let info = response{
                    self.objTeamList = info
                    self.arrPlayersCate1 = self.objTeamList.wicketkeapers.sorted(by: { Double($0.credits)! > Double($1.credits)! } )
                    self.arrPlayersCate2 = self.objTeamList.batsmans.sorted(by: { Double($0.credits)! > Double($1.credits)! } )
                    self.arrPlayersCate3 = self.objTeamList.allrounders.sorted(by: { Double($0.credits)! > Double($1.credits)! } )
                    self.arrPlayersCate4 = self.objTeamList.bowlers.sorted(by: { Double($0.credits)! > Double($1.credits)! } )
                    
                    self.arrTeamPlayers = self.arrPlayersCate1
                    
                    self.totalLeftCredits = 100.0
                    self.lblCredits?.text = String("\(self.totalLeftCredits )")
                    
                    if self.arrTeamPlayers.count > 0 {
                        self.arrTeamPlayers = self.arrTeamPlayers.sorted(by: { Double($0.credits)! > Double($1.credits)! } )
                        self.isCredit = false
                    }
                    
                    self.matchSetting = self.objTeamList.settingData;
                    self.setUpGameSettings();
                    self.lblPlayerCount.text = String("\(self.arrSelectedTeamPlayers.count)/\(self.totalPlayers)");
                    
                    if self.isEditing || self.isClone{
                        self.GetEditTeamPlayers();
                    }else{
                        self.tblPlayers.reloadData()
                    }
                }
            }
        }
    }
    
    func GetEditTeamPlayers() {
        if let info = self.editTeamData{
            for tm in self.arrPlayersCate1 {
                if info.wicketkeapers.filter({$0.playerId == tm.playerId}).count > 0, let data = info.wicketkeapers.filter({$0.playerId == tm.playerId}).first{
                    tm.isSelected = true;
                    tm.pMultiplier = data.playerMultiplier;
                    self.arrSelectedTeamPlayers.append(tm);
                }
            }
            
            for tm in self.arrPlayersCate2 {
                if info.batsmans.filter({$0.playerId == tm.playerId}).count > 0, let data = info.batsmans.filter({$0.playerId == tm.playerId}).first{
                    tm.isSelected = true;
                    tm.pMultiplier = data.playerMultiplier;
                    self.arrSelectedTeamPlayers.append(tm);
                }
            }
            
            for tm in self.arrPlayersCate3 {
                if info.allrounders.filter({$0.playerId == tm.playerId}).count > 0, let data = info.allrounders.filter({$0.playerId == tm.playerId}).first{
                    tm.isSelected = true;
                    tm.pMultiplier = data.playerMultiplier;
                    self.arrSelectedTeamPlayers.append(tm);
                }
            }
            
            for tm in self.arrPlayersCate4 {
                if info.bowlers.filter({$0.playerId == tm.playerId}).count > 0, let data = info.bowlers.filter({$0.playerId == tm.playerId}).first{
                    tm.isSelected = true;
                    tm.pMultiplier = data.playerMultiplier;
                    self.arrSelectedTeamPlayers.append(tm);
                }
            }
            self.arrTeamPlayers = self.arrPlayersCate1
            self.Cat1SelectedPlayer =  info.wicketkeapers.count
            self.Cat2SelectedPlayer =  info.batsmans.count
            self.Cat3SelectedPlayer =  info.allrounders.count
            self.Cat4SelectedPlayer =  info.bowlers.count
            
            self.totalLeftCredits = 100.0
            for selectedObj in self.arrSelectedTeamPlayers {
                self.totalLeftCredits -= Float( selectedObj.credits) ?? 0.0
            }
            self.lblCredits.text = String("\(self.totalLeftCredits )")
            if self.arrTeamPlayers.count > 0 {
                self.arrTeamPlayers = self.arrTeamPlayers.sorted(by: { Double($0.credits)! > Double($1.credits)! } )
                self.isCredit = false
            }
            team1SelectedPlayers =  (arrSelectedTeamPlayers.filter { $0.teamId == self.objTeamList.team1.id }).count
            team2SelectedPlayers =  (arrSelectedTeamPlayers.filter { $0.teamId == self.objTeamList.team2.id }).count
            lblTeam1Count?.text = String("\(team1SelectedPlayers)")
            lblTeam2Count?.text = String("\(team2SelectedPlayers)")
            lblPlayerCount.text = String("\(self.arrSelectedTeamPlayers.count)/\(self.totalPlayers)");
            
            self.lblCat1Count.text = "\(self.Cat1SelectedPlayer)"
            self.lblCat2Count.text = "\(self.Cat2SelectedPlayer)"
            self.lblCat3Count.text = "\(self.Cat3SelectedPlayer)"
            self.lblCat4Count.text = "\(self.Cat4SelectedPlayer)"
            self.btnNext.backgroundColor = APPCOLOR.greenCustom;
            self.btnNext.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
            self.tblPlayers.reloadData()
        }
    }
    
    func setUpGameSettings() {
        
        self.imgTeam1.sd_setImage(with:  URL.init(string: self.objTeamList.team1.image),placeholderImage: UIImage.init(named: "user_icon"))
        self.imgTeam2.sd_setImage(with:  URL.init(string:  self.objTeamList.team2.image),placeholderImage: UIImage.init(named: "user_icon"))
        self.lblTeam1Name.text = self.objTeamList.team1.sortName
        self.lblTeam2Name.text = self.objTeamList.team2.sortName
        
        if let setting = matchSetting{
            self.Cat1MinimumPlayer = Int(setting.minWicketKeeper)!
            self.Cat2MinimumPlayer = Int(setting.minBatsman)!
            self.Cat3MinimumPlayer = Int(setting.minAllrounder)!
            self.Cat4MinimumPlayer = Int(setting.minBowler)!
            
            self.Cat1MaximumPlayer = Int(setting.maxWicketKeeper)!
            self.Cat2MaximumPlayer = Int(setting.maxBatsman)!
            self.Cat3MaximumPlayer = Int(setting.maxAllrounder)!
            self.Cat4MaximumPlayer = Int(setting.maxBowler)!
            
            MaxTeamPlayer = Int(setting.maxPlayerPerTeam)!
            self.totalPlayers = Int(setting.maxPlayers)!
            
            
            self.lblPickupCount.text = "Pick \(self.Cat1MinimumPlayer) - \(self.Cat1MaximumPlayer) WICKETKEEPER";
        }
    }
    
    
    @IBAction func actionForBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    @IBAction func actionForSort(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        selectedSort =  button.tag
        
        switch button.tag {
            
        case 0: ///--Filter By winning prize
            
            imgPlayerArrow.isHidden = false
            imgCreditsArrow.isHidden = true
            imgPointsArrow.isHidden = true
            
            if isPlayer == false {
                isPlayer = true
                if self.arrTeamPlayers.count > 0 {
                    self.arrTeamPlayers = self.arrTeamPlayers.sorted(by: { ($0).playerName < ($1).playerName } )
                    self.tblPlayers.reloadData()
                }
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.imgPlayerArrow.transform = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
                })
            } else {
                isPlayer = false
                if self.arrTeamPlayers.count > 0 {
                    self.arrTeamPlayers = self.arrTeamPlayers.sorted(by: { ($0).playerName > ($1).playerName } )
                    self.tblPlayers.reloadData()
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.imgPlayerArrow.transform = CGAffineTransform(rotationAngle:  CGFloat.pi)
                })
            }
            
            
            
        case 1: ///--Filter By team size
            
            imgPlayerArrow.isHidden = true
            imgCreditsArrow.isHidden = true
            imgPointsArrow.isHidden = false
            if isPoints == false {
                isPoints = true
                if self.arrTeamPlayers.count > 0 {
                    self.arrTeamPlayers = self.arrTeamPlayers.sorted(by: { Double($0.totalPoints)! < Double($1.totalPoints)! } )
                    self.tblPlayers.reloadData()
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.imgPointsArrow.transform = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
                })
            } else {
                isPoints = false
                if self.arrTeamPlayers.count > 0 {
                    self.arrTeamPlayers = self.arrTeamPlayers.sorted(by: { Double($0.totalPoints)! > Double($1.totalPoints)! } )
                    self.tblPlayers.reloadData()
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.imgPointsArrow.transform = CGAffineTransform(rotationAngle:  CGFloat.pi)
                })
                
            }
        case 2: ///--Filter By winner size
            
            imgPlayerArrow.isHidden = true
            imgCreditsArrow.isHidden = false
            imgPointsArrow.isHidden = true
            
            if isCredit == false {
                isCredit = true
                if self.arrTeamPlayers.count > 0 {
                    self.arrTeamPlayers = self.arrTeamPlayers.sorted(by: { Double($0.credits)! < Double($1.credits)! } )
                    self.tblPlayers.reloadData()
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.imgCreditsArrow.transform = CGAffineTransform(rotationAngle:  CGFloat.pi)
                })
                
                
            } else {
                isCredit = false
                if self.arrTeamPlayers.count > 0 {
                    self.arrTeamPlayers = self.arrTeamPlayers.sorted(by: { Double($0.credits)! > Double($1.credits)! } )
                    self.tblPlayers.reloadData()
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.imgCreditsArrow.transform = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
                })
            }
        default:
            print("Unknown Filter")
            return
        }
    }
    
    @IBAction func actionForTeamPreview(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamPreviewController") as! TeamPreviewController
        vc.isFromCreateteam = 1
        vc.arrSelectedPlayers = self.arrSelectedTeamPlayers
        vc.sportsType = appdelegate.matchType;
        vc.matchUrl = appdelegate.matchTypeUrl;
        vc.str_team1Id = self.objTeamList.team1.id;
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func actionForNext(_ sender: Any) {
        if self.arrSelectedTeamPlayers.count == self.totalPlayers {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectedCaptionVC") as! SelectedCaptionVC
            vc.arrSelectedPlayers = self.arrSelectedTeamPlayers
            if self.isClone == true {
                vc.strEditedTeamId = ""
            } else {
                vc.strEditedTeamId = self.strEditedTeamId
            }
            vc.fromClass = self.fromClass
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.view.showToast(message: CreateTeamAlert.nextButtonAlert)
        }
    }
    
    
    @IBAction func btnSelectPlayeTypeAction(_ sender: UIButton)
       {
           for img in [imgCat1, imgCat2, imgCat3, imgCat4] {
               img?.cornerRadius = 25;
               img?.borderWidth = 2.0;
               img?.borderColor = APPCOLOR.TextLightGrayColor;
           }
           
           for vw in [vwCat1, vwCat2, vwCat3, vwCat4] {
               vw?.cornerRadius = 15;
               vw?.clipsToBounds = true;
               vw?.backgroundColor = APPCOLOR.TextLightGrayColor;
           }
           
           for lbl in [lblCat1Count, lblCat2Count, lblCat3Count, lblCat4Count]{
               lbl?.font = UIFont(name: font_reguler, size: 10);
               lbl?.textColor = APPCOLOR.TextBlackColor;
           }
           
           for lbl in [lblCat1, lblCat2, lblCat3, lblCat4]{
               lbl?.font = UIFont(name: font_reguler, size: 10);
               lbl?.textColor = APPCOLOR.TextBlackColor;
           }
           
           self.SelectedPlayerType = sender.tag
           if sender.tag == 0 {
               lblCat1.textColor = APPCOLOR.redCustom;
               lblCat1Count.textColor = APPCOLOR.TextWhiteColor;
               vwCat1.backgroundColor = AppYellow
               imgCat1.borderColor = APPCOLOR.redCustom;
               
           } else if sender.tag == 1 {
               lblCat2.textColor = APPCOLOR.redCustom;
               lblCat2Count.textColor = APPCOLOR.TextWhiteColor;
               vwCat2.backgroundColor = AppYellow
               imgCat2.borderColor = APPCOLOR.redCustom;
               
           } else if sender.tag == 2 {
               lblCat3.textColor = APPCOLOR.redCustom;
               lblCat3Count.textColor = APPCOLOR.TextWhiteColor;
               vwCat3.backgroundColor = AppYellow
               imgCat3.borderColor = APPCOLOR.redCustom;
               
           } else if sender.tag == 3 {
               lblCat4.textColor = APPCOLOR.redCustom;
               lblCat4Count.textColor = APPCOLOR.TextWhiteColor;
               vwCat4.backgroundColor = AppYellow
               imgCat4.borderColor = APPCOLOR.redCustom;
           }
           
           self.arrTeamPlayers.removeAll()
           
           switch sender.tag
           {
           case 0: ///--for 1st player category conditions
               print(CreateTeamAlert.pickWK)
//               lblPickupCount?.text = CreateTeamAlert.pickWK
               self.lblPickupCount.text = "Pick \(self.Cat1MinimumPlayer) - \(self.Cat1MaximumPlayer) WICKETKEEPER";
               self.arrTeamPlayers = self.filterArray(arr: self.arrPlayersCate1)
               self.tblPlayers.reloadData()
               
               
           case 1: ///--for 2nd player category conditions
//               lblPickupCount?.text = CreateTeamAlert.pickBAT
               self.lblPickupCount.text = "Pick \(self.Cat2MinimumPlayer) - \(self.Cat2MaximumPlayer) BATSMAN";
               self.arrTeamPlayers = self.filterArray(arr: self.arrPlayersCate2)
               self.tblPlayers.reloadData()
               
               
           case 2: ///--for 3rd player category conditions
//               lblPickupCount?.text = CreateTeamAlert.pickAR
               self.lblPickupCount.text = "Pick \(self.Cat3MinimumPlayer) - \(self.Cat3MaximumPlayer) ALLROUNDER";
               self.arrTeamPlayers = self.filterArray(arr: self.arrPlayersCate3)
               self.tblPlayers.reloadData()
               
               
           case 3: ///--for 4th player category conditions
//               lblPickupCount?.text = CreateTeamAlert.pickBOW
                self.lblPickupCount.text = "Pick \(self.Cat4MinimumPlayer) - \(self.Cat4MaximumPlayer) BOWLER";
               self.arrTeamPlayers = self.filterArray(arr: self.arrPlayersCate4)
               self.tblPlayers.reloadData()
               
               
           default:
               print("Unknown Filter")
               return
           }
           self.tblPlayers.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
       }

    func filterArray(arr : [PlayerData]) -> [PlayerData]
    {
        var arrReturn = [PlayerData]()
        switch selectedSort {
            
        case 0:
            if isPlayer == false {
                // isPlayer = true
                if arr.count > 0 {
                    let tempLeagueData : [PlayerData] = arr
                    arrReturn = tempLeagueData.sorted(by: { ($0).playerName < ($1).playerName } )
                }
            } else {
                //isPlayer = false
                if arr.count > 0
                {
                    let tempLeagueData : [PlayerData] = arr
                    arrReturn = tempLeagueData.sorted(by: { ($0).playerName > ($1).playerName } )
                }
            }
            return arrReturn
            
        case 1:
            if isPoints == false {
                if arr.count > 0 {
                    let tempLeagueData : [PlayerData] = arr
                    arrReturn = tempLeagueData.sorted(by: { Double($0.totalPoints)! > Double($1.totalPoints)! } )
                }
                
            } else {
                if arr.count > 0 {
                    let tempLeagueData : [PlayerData] = arr
                    arrReturn = tempLeagueData.sorted(by: { Double($0.totalPoints)! < Double($1.totalPoints)! } )
                }
            }
            return arrReturn
        case 2:
            if isCredit == false {
                if arr.count > 0 {
                    let tempLeagueData : [PlayerData] = arr
                    arrReturn = tempLeagueData.sorted(by: { Double($0.credits)! > Double($1.credits)! } )
                }
                
            } else {
                if arr.count > 0 {
                    let tempLeagueData : [PlayerData] = arr
                    arrReturn = tempLeagueData.sorted(by: { Double($0.credits)! < Double($1.credits)! } )
                }
            }
            return arrReturn
        case 3:
            if isSelectedBy == false {
                //isCredit = true
                if arr.count > 0 {
                    let tempLeagueData : [PlayerData] = arr
                    arrReturn = tempLeagueData.sorted(by: { ($0).selectedBy > ($1).selectedBy } )
                }
                
            } else {
                //  isCredit = false
                if arr.count > 0
                {
                    let tempLeagueData : [PlayerData] = arr
                    arrReturn = tempLeagueData.sorted(by: { ($0).selectedBy < ($1).selectedBy } )
                }
            }
            return arrReturn
        default:
            print("Unknown Filter")
            return []
        }
    }
}

extension CreateTeamVC : UITableViewDelegate, UITableViewDataSource, PlayerTeamSelectDelegate{
    
    func playerImageClick(info: PlayerData) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTeamPlayerStatsVC") as! CreateTeamPlayerStatsVC
        vc.playerInfo = info;
        vc.modalPresentationStyle = .overCurrentContext;
        vc.actionForTeamSelected = {(info) in
            self.selectPlayerAction(obj: info);
        }
        self.present(vc, animated: true, completion: nil);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTeamPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateTeamTCell") as! CreateTeamTCell
        cell.parentVC = self;
        cell.delegate = self;
        cell.configureLayoutScreen(self.arrTeamPlayers[indexPath.row])
        cell.lblTeamName.text = objTeamList.team1.sortName
        cell.vwGrayOut.isHidden  = true;
		if !self.arrTeamPlayers[indexPath.row].isSelected{
			if self.arrSelectedTeamPlayers.count == totalPlayers {
				cell.vwGrayOut.isHidden  = false;
			} else{
				if self.SelectedPlayerType == 0 {
					if  Cat1SelectedPlayer == Cat1MaximumPlayer {
						cell.vwGrayOut.isHidden  = false;
					}
				} else if self.SelectedPlayerType == 1 {
					if  Cat2SelectedPlayer == Cat2MaximumPlayer {
						cell.vwGrayOut.isHidden  = false;
					}
				} else if self.SelectedPlayerType == 2 {
					if  Cat3SelectedPlayer == Cat3MaximumPlayer {
						cell.vwGrayOut.isHidden  = false;
					}
				} else if self.SelectedPlayerType == 3 {
					if  Cat4SelectedPlayer == Cat4MaximumPlayer {
						cell.vwGrayOut.isHidden  = false;
					}
				}
			}
			
		}
		
		
        if objTeamList.team1.id == self.arrTeamPlayers[indexPath.row].teamId {
            cell.lblTeamName.text = objTeamList.team1.sortName.count > 3 ? String(objTeamList.team1.sortName.prefix(3)) : objTeamList.team1.sortName;
            cell.vwTeamName?.backgroundColor = APPCOLOR.TextWhiteColor;
            cell.lblTeamName.textColor = APPCOLOR.TextBlackColor;
        } else {
            cell.lblTeamName.text = objTeamList.team2.sortName.count > 3 ? String(objTeamList.team2.sortName.prefix(3)) : objTeamList.team2.sortName;
            cell.vwTeamName?.backgroundColor = APPCOLOR.TextBlackColor;
            cell.lblTeamName.textColor = APPCOLOR.TextWhiteColor;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrTeamPlayers[indexPath.row]
        self.selectPlayerAction(obj: obj);
    }
    
    func selectPlayerAction(obj : PlayerData) {
        var isSuccess = Bool()
        isSuccess =  self.CreateTeamLogic(obj, SelectedPlayer: self.arrSelectedTeamPlayers)
        if isSuccess {
            if obj.isSelected == true {
                
                totalLeftCredits += Float(obj.credits)!
                lblCredits?.text = String("\(totalLeftCredits )")
                obj.isSelected = false
                self.arrSelectedTeamPlayers = self.arrSelectedTeamPlayers.filter { $0.playerId != obj.playerId  }
            } else {
                totalLeftCredits -= Float(obj.credits)!
                lblCredits?.text = String("\(totalLeftCredits )")
                obj.isSelected = true
                self.arrSelectedTeamPlayers.append(obj)
            }
            
            if self.SelectedPlayerType == 0 {
                self.Cat1SelectedPlayer = (self.arrTeamPlayers.filter { $0.isSelected == true}).count
                self.lblCat1Count.text = String(self.Cat1SelectedPlayer);
            
            } else  if self.SelectedPlayerType == 1 {
                self.Cat2SelectedPlayer = (self.arrTeamPlayers.filter { $0.isSelected == true}).count
                self.lblCat2Count.text = String(self.Cat2SelectedPlayer);
                
            } else  if self.SelectedPlayerType == 2 {
                self.Cat3SelectedPlayer = (self.arrTeamPlayers.filter { $0.isSelected == true}).count
                self.lblCat3Count.text = String(self.Cat3SelectedPlayer);
            
            } else  if self.SelectedPlayerType == 3 {
                self.Cat4SelectedPlayer = (self.arrTeamPlayers.filter { $0.isSelected == true}).count
                self.lblCat4Count.text = String(self.Cat4SelectedPlayer);
            }
            
            team1SelectedPlayers =  (arrSelectedTeamPlayers.filter { $0.teamId == self.objTeamList.team1.id }).count
            team2SelectedPlayers =  (arrSelectedTeamPlayers.filter { $0.teamId == self.objTeamList.team2.id }).count
            lblTeam1Count?.text = String("\(team1SelectedPlayers)")
            lblTeam2Count?.text = String("\(team2SelectedPlayers)")
            lblPlayerCount.text = String("\(self.arrSelectedTeamPlayers.count)/\(self.totalPlayers)");
            
            self.btnNext.backgroundColor = APPCOLOR.TextLightGrayColor;
            self.btnNext.setTitleColor(APPCOLOR.TextBlackColor, for: .normal);
            if self.arrSelectedTeamPlayers.count > 10{
                self.btnNext.backgroundColor = APPCOLOR.greenCustom;
                self.btnNext.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
            }
            self.tblPlayers.reloadData()
        }
    }
    
    
    func CreateTeamLogic(_ SinglePlayerData : PlayerData , SelectedPlayer : [PlayerData]) -> Bool {
        if SinglePlayerData.isSelected == true {
            return true
        }
        if SinglePlayerData.isSelected == false && SelectedPlayer.count == totalPlayers {
            self.view.showToast(message: "Maximum \(self.totalPlayers) players allow")
            return false
        } else if SinglePlayerData.isSelected == false && totalLeftCredits < Float(SinglePlayerData.credits)! {
            self.view.showToast(message: CreateTeamAlert.EnoughCredit)
            return false
        } else if (SinglePlayerData.isSelected == false && team1SelectedPlayers  == MaxTeamPlayer && SinglePlayerData.country == self.objTeamList.team1.name) || (SinglePlayerData.isSelected == false && team2SelectedPlayers  == MaxTeamPlayer && SinglePlayerData.country == self.objTeamList.team2.name) {
            self.view.showToast(message: "Maximum \(self.MaxTeamPlayer) players are allow from 1 team")
            return false
        } else {
            
            let leftDeselectPlayer = totalPlayers - arrSelectedTeamPlayers.count
            
            if self.SelectedPlayerType == 0 {
                if  SinglePlayerData.isSelected == false && Cat1SelectedPlayer == Cat1MaximumPlayer {
                    
                    self.view.showToast(message: "max \(Cat1MaximumPlayer) wicket-keeper allowed")
                    return false
                } else {
                    return true
                }
            } else if self.SelectedPlayerType == 1 {
                
                if  SinglePlayerData.isSelected == false && Cat2SelectedPlayer == Cat2MaximumPlayer {
                    
                    self.view.showToast(message: "Max \(Cat2MaximumPlayer) batsmen allowed")
                    return false
                } else {
                    
                    if leftDeselectPlayer == ( max((Cat1MinimumPlayer - Cat1SelectedPlayer),0) + max((Cat4MinimumPlayer - Cat4SelectedPlayer), 0) + max((Cat3MinimumPlayer - Cat3SelectedPlayer),0)){
                        
                        if Cat1SelectedPlayer < Cat1MinimumPlayer {
                            self.view.showToast(message: "Pick at least \(Cat1MinimumPlayer) Wicket-Kepper");
                            return false
                        } else if Cat3SelectedPlayer < Cat3MinimumPlayer {
                            self.view.showToast(message: "Pick at least \(Cat3MinimumPlayer) All-Rounder");
                            return false
                        } else if Cat4SelectedPlayer < Cat4MinimumPlayer {
                            self.view.showToast(message: "Pick at least \(Cat4MinimumPlayer) Bowler");
                            return false
                        } else {
                            return true
                        }
                    } else {
                        return true
                    }
                }
            } else if self.SelectedPlayerType == 2 {
                if  SinglePlayerData.isSelected == false && Cat3SelectedPlayer == Cat3MaximumPlayer {
                    self.view.showToast(message: "Max \(Cat3MaximumPlayer) all-rounders allowed");
                    return false
                } else {
                    
                    if leftDeselectPlayer == ( max((Cat1MinimumPlayer - Cat1SelectedPlayer),0) + max((Cat2MinimumPlayer - Cat2SelectedPlayer), 0) + max((Cat4MinimumPlayer - Cat4SelectedPlayer),0)){
                        
                        if Cat1SelectedPlayer < Cat1MinimumPlayer {
                            self.view.showToast(message: "Pick at least \(Cat1MinimumPlayer) Wicket-Kepper");
                            return false
                        } else if Cat2SelectedPlayer < Cat2MinimumPlayer {
                            self.view.showToast(message: "Pick at least \(Cat2MinimumPlayer) batsmen");
                            return false
                        } else if Cat4SelectedPlayer < Cat4MinimumPlayer {
                            self.view.showToast(message: "Pick at least \(Cat4MinimumPlayer) Bowler");
                            return false
                        } else {
                            return true
                        }
                    }else {
                        return true
                    }
                }
            } else {
                if  SinglePlayerData.isSelected == false && Cat4SelectedPlayer == Cat4MaximumPlayer {
                    self.view.showToast(message: "Max \(Cat4MaximumPlayer) bowlers allowed");
                    return false
                } else {
                    if leftDeselectPlayer == ( max((Cat1MinimumPlayer - Cat1SelectedPlayer),0) + max((Cat2MinimumPlayer - Cat2SelectedPlayer), 0) + max((Cat3MinimumPlayer - Cat3SelectedPlayer),0)){
                        
                        if Cat1SelectedPlayer < Cat1MinimumPlayer {
                            self.view.showToast(message: "Pick at least \(Cat1MinimumPlayer) Wicket-Kepper");
                            return false
                        } else if Cat2SelectedPlayer < Cat2MinimumPlayer {
                            self.view.showToast(message: "Pick at least \(Cat2MinimumPlayer) batsmen");
                            return false
                        } else if Cat3SelectedPlayer < Cat3MinimumPlayer {
                            self.view.showToast(message: "Pick at least \(Cat3MinimumPlayer) All-Rounder");
                            return false
                        } else {
                            return true
                        }
                    } else {
                        return true
                    }
                    
                }
            }
        }
    }
    
}
