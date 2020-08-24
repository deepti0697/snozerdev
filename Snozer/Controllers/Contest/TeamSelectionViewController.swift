//
//  TeamSelectionViewController.swift
//  TheTeam11
//
//  Created by AK on 12/3/18.
//  Copyright © . All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import DropDown

class TeamSelectionViewController: ViewController {
    /*
    @IBOutlet weak var matchView: MatchViewSmall!
    @IBOutlet weak var centerConsJoinbtn: NSLayoutConstraint!
    @IBOutlet weak var teamTable: UITableView!
    @IBOutlet weak var newTeamButton: UIButton!
    @IBOutlet weak var joinedContestButton: UIButton!
    
    @IBOutlet weak var centerContCreatTeam: NSLayoutConstraint!
    @IBOutlet weak var widthCreateNewTeam: NSLayoutConstraint!
    var selectedIndex = 100
    var selectedContestData : ContestPool!
    var joinTeam : [JoinedTeam]!
    var isConfirm = false
    var viewType = String() // myteamlist , joincontest , switchteam
    
    var addPayment = "0"
    // Confirmation Popup
    @IBOutlet weak var titleToPay: UILabel!
    @IBOutlet weak var JoinBtnOnPopup: UIButton!
    @IBOutlet weak var lblTotalPayAmt: UILabel!
    @IBOutlet weak var lblBonusAmt: UILabel!
    @IBOutlet weak var lblEntryFees: UILabel!
    @IBOutlet weak var lblTotalAmout: UILabel!
    @IBOutlet weak var popupSubview: UIView!
    @IBOutlet var confirmationPopup: UIView!
    
    @IBOutlet var lblMgs: UILabel!
    var myTeamTypeDropDown = DropDown()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        view.backgroundColor = UIColor.groupTableViewBackground
        
        teamTable.backgroundColor = UIColor.groupTableViewBackground
        
       // teamTable.backgroundColor = .clear
        teamTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        
        
        addBackButton()
        
    //    matchView.teams = (Global.selectedMatch.team1.sort_name.uppercased(), Global.selectedMatch.team2.sort_name.uppercased())
        
        newTeamButton.backgroundColor = UIColor.white
        newTeamButton.setTitleColor(.black, for: .normal)
        newTeamButton.layer.cornerRadius = 5
        newTeamButton.shadow()
        newTeamButton.titleLabel?.font = UIFont.appFontRegular(ofSize: 16)
        
        joinedContestButton.backgroundColor = UIColor.white
        joinedContestButton.setTitleColor(.black, for: .normal)
        joinedContestButton.layer.cornerRadius = 5
        joinedContestButton.shadow()
        joinedContestButton.titleLabel?.font = UIFont.appFontRegular(ofSize: 16)
        
        TeamButtonRefresh()
        
        JoinBtnOnPopup.backgroundColor = UIColor.appColorTheme()
        
    }
    
    override func backButtonTapped(_ sender: UIBarButtonItem) {
        
        if confirmationPopup.isHidden
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        teamTable.reloadData()
        Global.teamCreatType = "New"
        removeNavigationShadow()
        confirmationPopup.isHidden = true
         NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTeam), name: Global.NotificationNames.RefreshTeam, object: nil)
    }
    
    func TeamButtonRefresh()
    {
        if viewType == "joincontest"
        {
            navigationItem.title = "SELECT TEAM"
            
            // getMyJoinedTeamsForContest()
            joinedContestButton.setTitle("JOIN CONTEST", for: .normal)
            
            newTeamButton.setTitle(String(format: "CREATE TEAM %d", Global.myTeams.count+1), for: .normal)
        }
        else if viewType == "Rejoincontest"
        {
            navigationItem.title = "SELECT TEAM"
            
            // getMyJoinedTeamsForContest()
            joinedContestButton.setTitle("REJOIN", for: .normal)
            
            newTeamButton.setTitle(String(format: "CREATE TEAM %d", Global.myTeams.count+1), for: .normal)
        }
        else if viewType == "switchteam"
        {
            navigationItem.title = "SELECT TEAM"
            // getMyJoinedTeamsForContest()
            joinedContestButton.setTitle("SWITCH TEAM", for: .normal)
        }
        else  // myteamlist
        {
            navigationItem.title = "MY TEAMS"
            
            newTeamButton.setTitle(String(format: "CREATE TEAM %d", Global.myTeams.count+1), for: .normal)
            joinedContestButton.isHidden = true
            centerContCreatTeam = centerContCreatTeam.setMultiplier(multiplier: 1)
            //teamTable.reloadData()
        }
        
        
        if Global.myTeams.count >= Global.Constants.maxTeams
        {
            newTeamButton.isHidden = true
            widthCreateNewTeam.constant = 0
            centerConsJoinbtn = centerConsJoinbtn.setMultiplier(multiplier: 1)
        }
    }
    
    @objc func refreshTeam()
    {
        TeamButtonRefresh()
        
        if Global.myTeams.count >= Global.Constants.maxTeams
        {
            newTeamButton.isHidden = true
            widthCreateNewTeam.constant = 0
            centerConsJoinbtn = centerConsJoinbtn.setMultiplier(multiplier: 1)
        }
        teamTable.reloadData()
    }
   
    @IBAction func createTapped(_ sender: Any) {
        
        Common.goNextView(Controller: self, StoryBoardIdentifier: "CreateTeamViewController")
    }
    
    @IBAction func joinTapped(_ sender: UIButton)
    {
        if viewType == "switchteam"
        {
            SwitchTeam()
        }
        else
        { /// Join Contest
            
            if sender.titleLabel?.text == "REJOIN"
            {
                
            }
            else
            {
              JoinContest()
            }
            
        }
    }
    
    
    func SwitchTeam()
    {
        if selectedIndex == 100
        {
            Common.showAlertView(strMessage: Global.Messages.msgSwitchTeam)
            return
        }
        
        guard Common.isConnetctedToInternet() else {
            
            Common.showAlertView(strMessage: Global.Messages.errorNetworkConnection)
            return
        }
        
        
        showActivity(withColor: .black, onView: view)
        
        let team = Global.myTeams[selectedIndex]
        
        var dict = [String:Any]()
        dict["matchid"] = Global.selectedMatch.matchId
        dict["poolcontestid"] = selectedContestData.id
        dict["switchteamid"] = team.id
        /*if isTeamSelectFromDropDown
        {
            for ateam in Global.myTeams
            {
              /*  if ateam.teamname == lblSelectTeamName.text
                {
                    dict["uteamid"] = ateam.id
                }*/
            }
        }
        else
        {
            dict["uteamid"] = joinTeam[0].uteamid
        }*/
        
        
        
        let urls = Global.BaseURL + Global.WebAPI.switchteam
        
        Alamofire.request(urls, method: .post, parameters:dict, encoding: URLEncoding.default, headers:Common.header()).responseSwiftyJSON { (response) in
            
            self.hideActivity()
            
            let (_, json) = Common.validateResponse(response: response, show: true)
            
            if json != JSON.null {
                
                let verify = VerifyModel(fromJSON: json)
                
                if verify.code == Global.ErrorCodes.NoError {
                    
                    self.navigationController?.popViewController(animated: true)
                    Common.showAlertView(strMessage: verify.message)
                }
            }
        }
    }
    
    func JoinContest()
    {
        // Join Contest
        
        if selectedIndex == 100
        {
            Common.showAlertView(strMessage: Global.Messages.selectTeam)
            return
        }
        
        guard Common.isConnetctedToInternet() else {
            
            Common.showAlertView(strMessage: Global.Messages.errorNetworkConnection)
            return
        }
        
        showActivity(withColor: .black, onView: view)
        joinedContestButton.isUserInteractionEnabled = false
        
        let team = Global.myTeams[selectedIndex]
        
        var dict = [String:Any]()
        var urls = ""
        if isConfirm
        { // Join Contest
            dict["match_unique_id"] = Global.selectedMatch.matchId
            dict["match_contest_id"] = selectedContestData.matchContestId
            dict["customer_team_id"] = team.id
            
            urls = Global.BaseURL + Global.WebAPI.custJoinContest
        }
        else
        { // PreJoin Contest
            dict["match_unique_id"] = Global.selectedMatch.matchId
            dict["match_contest_id"] = selectedContestData.matchContestId
            
            urls = Global.BaseURL + Global.WebAPI.custPreJoinContest
        }
       
        Alamofire.request(urls, method: .post, parameters:dict, encoding: URLEncoding.default, headers:Common.header()).responseSwiftyJSON { (response) in
            
            self.hideActivity()
            self.joinedContestButton.isUserInteractionEnabled = true
            
            let (_, json) = Common.validateResponse(response: response, show: true)
            
            if json != JSON.null {
                
                let verify = VerifyModel(fromJSON: json)
                
                if verify.code == Global.ErrorCodes.NoError
                {
                    
                    if !self.isConfirm
                    {
                        let model = JoinContestConfirmationModel(fromJson: json)
                        
                        if model.data.needPay > 0
                        {
                            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "LowBalanceVC") as! LowBalanceVC
                            vc.aModel = model.data
                            
                        self.navigationController?.pushViewController(vc, animated: true)
                           
                        }
                        else
                        {
                            self.lblTotalPayAmt.text = Common.rupeeSymbol + model.data.entryFees
                            
                            self.addPayment = model.data.entryFees
                            
                            self.JoinBtnOnPopup.setTitle("JOIN CONTEST", for: .normal)
                            
                            self.lblEntryFees.text = Common.rupeeSymbol + model.data.entryFees
                            
                            self.lblBonusAmt.text = "- " + Common.rupeeSymbol + model.data.wallet.bonusWallet
                            
                            
                            
                         //   self.lblTotalAmout.text = "Wallet Balance: " + Common.rupeeSymbol + "\(model.data.wallet.walletbalance!)"
                            
                            self.showPopUp()
                            
                        }
                        
                    }
                    else
                    {
                        self.confirmationPopup.isHidden = true
                        self.isConfirm = false
                        
                        //Global.getJoinedContests()
                        
                         NotificationCenter.default.post(name: Global.NotificationNames.GetMatchContestList, object: nil)
                        
                        self.navigationController?.popViewController(animated: true)
                        Common.showAlertView(strMessage: verify.message)
                    }
                    
                }
                else
                {
                    self.isConfirm = false
                     self.confirmationPopup.isHidden = true
                    Common.showAlertView(strMessage: verify.message)
                }
            }
        }
    }
    
    
    //MARK:- Custom Methods
    func showPopUp()
    {
       
      lblMgs.text = Common.userInfo.settings.jOINCONTESTMESSAGE
        
        confirmationPopup.frame = UIScreen.main.bounds
        self.view.addSubview(confirmationPopup)
        confirmationPopup.isHidden = false
        
        
        popupSubview.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        popupSubview.alpha = 1.0
        popupSubview.isHidden = false
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 4.0, options: .curveEaseOut, animations:
            {
                self.popupSubview.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @IBAction func popupCloseBtn(_ sender: Any)
    {
        confirmationPopup.isHidden = true
    }
    @IBAction func confirmJoinContestBtn(_ sender: Any)
    {
        if JoinBtnOnPopup.titleLabel?.text == "JOIN CONTEST"
        {
             isConfirm = true
           JoinContest()
        }
    }
    
}


extension TeamSelectionViewController : UITableViewDelegate, UITableViewDataSource  {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let base = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        base.backgroundColor = .clear
        
        if viewType == "myteamlist"
        {
        }
        else
        {
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: tableView.frame.width, height: 25))
        label.font = UIFont.appFontRegular(ofSize: 15)
        label.textAlignment = .center
            
            if viewType == "joincontest"
            {
               label.text = "CHOOSE TEAM TO JOIN THE CONTEST WITH"
            }
            else if viewType == "Rejoincontest"
            {
               label.text = "CHOOSE TEAM TO REJOIN THE CONTEST WITH"
            }
            else if viewType == "switchteam"
            {
               label.text = "CHOOSE TEAM TO JOIN CONTEST WITH"
            }
            
            
            
       
        base.addSubview(label)
        }
        return base
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Global.myTeams.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if viewType == "myteamlist"
        {
            return 171
        }
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewType == "myteamlist"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellMyTeam", for: indexPath) as! CellMyTeam
            
           // cell.delegate = self
            
            let team = Global.myTeams[indexPath.row]
            
            cell.lblTeamName.text = "TEAM" + " " + "\(team.name ?? "")"
            
            cell.lblCName.text = team.captain.name
            cell.imgCPic.sd_setImage(with: URL(string: team.captain.image!),
                                     placeholderImage: UIImage.init(named: "dummy_player_icon"),
                                     options: [],
                                     completed: nil)
            
            if team.viseCaptain != nil
            {
               cell.lblVCName.text = team.viseCaptain.name ?? ""
                cell.imgVCPic.sd_setImage(with: URL(string: team.viseCaptain.image ?? "" ),
                                          placeholderImage: UIImage.init(named: "dummy_player_icon"),
                                          options: [],
                                          completed: nil)
            }
            
            let WK = team.wicketkeapers
            let BAT = team.batsmans
            let AR = team.allrounders
            let BOWL = team.bowlers
            
            cell.lblT1Name.text = team.team1.sort_name //+ "\n" + "\(team1Player!.count)"
            cell.lblT2Name.text = team.team2.sort_name //+ "\n" + "\(team2Player!.count)"
            
            cell.lblWK.text = String(format: "WK (%d)", (WK?.count)!)
            cell.lblBAT.text = String(format: "BAT (%d)", (BAT?.count)!)
            cell.lblAR.text = String(format: "AR (%d)", (AR?.count)!)
            cell.lblBOWL.text = String(format: "BOWL (%d)", (BOWL?.count)!)
            
            cell.editBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: #selector(CheckeditbtnTapped), for: .touchUpInside)
            
            cell.cloneBtn.tag = indexPath.row
            cell.cloneBtn.addTarget(self, action: #selector(CheckclonebtnTapped), for: .touchUpInside)
            
           // cell.nameTeam.text = team.teamname
           // cell.nameCaptain.text = team.cap
           // cell.nameViceCaptain.text = team.vcap
            
            cell.selectionStyle = .none
            
            return cell
        }
        else
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamCell
            
        let team = Global.myTeams[indexPath.row]
        
           
        
        if selectedIndex == indexPath.row
        {
            cell.base.layer.borderWidth = 1
            cell.base.layer.borderColor = UIColor.appColorGreen().cgColor
           
            cell.checkBox.setImage(UIImage.init(named: "check_fill"), for: .normal)
        }
        else
        {
            cell.base.layer.borderWidth = 0
            cell.checkBox.setImage(UIImage.init(named: "check_empty"), for: .normal)
        }
        
            cell.base.layer.cornerRadius = 5
            
        if viewType != "switchteam" && viewType != "joincontest" && viewType != "Rejoincontest"
        {
            cell.checkBox.isHidden = true
        }
            
        cell.checkBox.isUserInteractionEnabled = true
        cell.setwhiteBGColor()
        
        if viewType == "switchteam" || viewType == "joincontest" || viewType == "Rejoincontest"
        {
            cell.editButton.isHidden = true
            cell.cloneButton.isHidden = true
            
            cell.lblC_score.text = team.captain.totalPoints
            cell.lbl_VCScore.text = team.viseCaptain.totalPoints
            
            cell.img_VC.sd_setImage(with: URL(string: team.viseCaptain.image!),
                                    placeholderImage: UIImage.init(named: "dummy_player_icon"),
                                    options: [],
                                    completed: nil)
            
            cell.img_Captin.sd_setImage(with: URL(string: team.viseCaptain.image!),
                                        placeholderImage: UIImage.init(named: "dummy_player_icon"),
                                        options: [],
                                        completed: nil)
            
            if viewType == "Rejoincontest"
            {
                if selectedContestData.joinedTeams != ""
                {
                    if selectedContestData.joinedTeams == team.id
                    {
                        cell.base.layer.borderWidth = 1
                        cell.base.layer.borderColor = UIColor.appColorGreen().cgColor
                        
                        cell.checkBox.setImage(UIImage.init(named: "select"), for: .normal)
                        cell.checkBox.isUserInteractionEnabled = false
                        
                        cell.setSelectedTeamBGColor()
                    }
                }
            }
        }
        else
        {
            if Global.myTeams.count >= Global.Constants.maxTeams
            {
                cell.cloneButton.isHidden = true
            }
            else
            {
                cell.cloneButton.isHidden = false
            }
        }
        
        
        
        cell.checkBox.tag = indexPath.row
        cell.checkBox.addTarget(self, action: #selector(CheckboxbtnTapped), for: .touchUpInside)
        
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(CheckeditbtnTapped), for: .touchUpInside)
        
        cell.cloneButton.tag = indexPath.row
        cell.cloneButton.addTarget(self, action: #selector(CheckclonebtnTapped), for: .touchUpInside)
            
            cell.previewButton.tag = indexPath.row
            cell.previewButton.addTarget(self, action: #selector(PreviewbtnTapped), for: .touchUpInside)
        
        cell.nameTeam.text = "TEAM" + " " + "\(team.name ?? "")"
            
        cell.nameCaptain.text = team.captain.name
            
            if team.viseCaptain != nil
            {
                cell.nameViceCaptain.text = team.viseCaptain.name ?? ""
            }
      //  cell.nameViceCaptain.text = team.viseCaptain.name
        
        cell.selectionStyle = .none
        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if viewType == "myteamlist"
        {
             let team = Global.myTeams[indexPath.row]
            
            //BaseHttp.main.getUserMatchTeamDetail(teamid: team.id)
            
            let previewDetail = self.storyboard?.instantiateViewController(withIdentifier: "TeamPreviewViewController") as! TeamPreviewViewController
            previewDetail.myTeams = team
            previewDetail.navtitle = "TEAM" + "\(team.name!)" 
           previewDetail.comeFrom = "myteamlist"
            
            self.present(previewDetail, animated: true, completion: nil)
            
            //self.navigationController?.pushViewController(previewDetail, animated: true)
        }
        else
        {
            if selectedIndex == indexPath.row
            {
                selectedIndex =  100
            }
            else
            {
                selectedIndex = indexPath.row
            }
            
            teamTable.reloadData()
        }
    }
    
    @objc func PreviewbtnTapped(sender : UIButton)
    {
        let team = Global.myTeams[sender.tag]
        
        BaseHttp.main.getUserMatchTeamDetail(teamid: team.id)
        
        let previewDetail = self.storyboard?.instantiateViewController(withIdentifier: "TeamPreviewViewController") as! TeamPreviewViewController
       // previewDetail.myTeams = team
       // previewDetail.navtitle = "TEAM" + "\(team.name!)"
       // previewDetail.comeFrom = "myteamlist"
        
        self.present(previewDetail, animated: true, completion: nil)
    }
    
    @objc func CheckboxbtnTapped(sender : UIButton)
    {
        if selectedIndex == sender.tag
        {
            selectedIndex =  100
        }
        else
        {
            selectedIndex = sender.tag
        }
        
        teamTable.reloadData()
    }
    
    func previewbtnTapped(previewData: Team)
    {
        BaseHttp.main.getUserMatchTeamDetail(teamid: previewData.id)
        
        let previewDetail = self.storyboard?.instantiateViewController(withIdentifier: "TeamPreviewViewController") as! TeamPreviewViewController
        previewDetail.navtitle = previewData.teamname
        
        self.present(previewDetail, animated: true, completion: nil)
        
    }
    
    
    @objc func CheckeditbtnTapped(sender : UIButton)
    {
        
        Global.myTeamsForEditClone = Global.myTeams[sender.tag]
        Global.teamCreatType = "Edit"
        Common.goNextView(Controller: self, StoryBoardIdentifier: "CreateTeamViewController")
    }
    
    @objc func CheckclonebtnTapped(sender : UIButton)
    {
       Global.myTeamsForEditClone = Global.myTeams[sender.tag]
        Global.teamCreatType = "Clone"
        Common.goNextView(Controller: self, StoryBoardIdentifier: "CreateTeamViewController")
    }
    
}


class TeamCell : UITableViewCell {
    
    @IBOutlet weak var base: UIView!
    @IBOutlet weak var baseStack: UIStackView!
    
    @IBOutlet weak var nameBase: UIView!
    @IBOutlet weak var nameTeam: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    @IBOutlet weak var leaderStack: UIStackView!
    
    @IBOutlet weak var capBase: UIView!
   
    @IBOutlet weak var nameCaptain: UILabel!
    
    @IBOutlet weak var viceCapBase: UIView!
   
    @IBOutlet var lbl_VCScore: UILabel!
    @IBOutlet var img_VC: UIImageView!
    @IBOutlet var lblVC: UILabel!
    @IBOutlet var lblCap: UILabel!
    @IBOutlet var img_Captin: UIImageView!
    
    @IBOutlet var lblC_score: UILabel!
    @IBOutlet weak var nameViceCaptain: UILabel!
    
    @IBOutlet weak var buttonBase: UIView!
    
    @IBOutlet weak var previewButton: UIButton!
    
    @IBOutlet weak var cloneButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var previewTeamData : Team!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        shadow()
        
        base.layer.cornerRadius = 5
        checkBox.tintColor = UIColor.black
        
        lblVC.layer.cornerRadius = 11
        lblVC.layer.masksToBounds = true
        lblCap.layer.cornerRadius = 11
        lblCap.layer.masksToBounds = true
        
        nameCaptain.font = UIFont.appFontRegular(ofSize: 16)
        nameCaptain.textColor = UIColor.black
        
        nameViceCaptain.font = UIFont.appFontRegular(ofSize: 16)
        nameViceCaptain.textColor = UIColor.black
        
        nameTeam.font = UIFont.appFontRegular(ofSize: 16)
        nameTeam.textColor = UIColor.black
        
        
    }
    
    func setSelectedTeamBGColor()
    {
        let color = UIColor(red: 228.0/255.0, green: 240.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        
        nameBase.backgroundColor = color
        buttonBase.backgroundColor = color
        capBase.backgroundColor = color
        viceCapBase.backgroundColor = color
    }
    
    func setwhiteBGColor()
    {
        nameBase.backgroundColor = .white
        buttonBase.backgroundColor = .white
        capBase.backgroundColor = .white
        viceCapBase.backgroundColor = .white
    }



*/
}
