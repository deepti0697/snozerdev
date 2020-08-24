//
//  ContestVC.swift
//  Snozer
//
//  Created by Admin on 03/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import ObjectMapper

class ContestVC: ViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var imgClock: UIImageView!
	@IBOutlet weak var imgWallet: UIImageView!
	@IBOutlet weak var layoutLblTitleC: NSLayoutConstraint!
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	
    @IBOutlet weak var layoutTblY: NSLayoutConstraint!
    @IBOutlet weak var imgWinners: UIImageView!
    @IBOutlet weak var imgEntryFee: UIImageView!
    @IBOutlet weak var ImgTotalWinning: UIImageView!
    
    
    let privateDict : [[String : String]] = [["title" : "Create a contest", "image":"add_icon"],["title" : "Enter invite code", "image":"tickets_icon"]]
    
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwJoinContestBottom: UIView!
    @IBOutlet weak var vwMyTeamsBottom: UIView!
    @IBOutlet weak var lblNavBackTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var vwTimer: UIView!
    @IBOutlet weak var lblTeams: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var btnPractice: UIButton!
    @IBOutlet weak var btnPrivate: UIButton!
    @IBOutlet weak var tblContest: UITableView!
    @IBOutlet weak var lblTeamsCount: UILabel!
    @IBOutlet weak var lblMyTeam: UILabel!
    @IBOutlet weak var lblJoinedContestCount: UILabel!
    @IBOutlet weak var lblJoinedContest: UILabel!
    
    @IBOutlet weak var vwCreateTeam: UIView!
    
    var refreshControl = UIRefreshControl()
    var arrContestList  = [ContestCateModel]()
    var arrPaidContestList  = [ContestCateModel]()
    var arrFreeContestList  = [ContestCateModel]()
    var timer = Timer()
    var diff_seconds = Double()
    var myTeamCount = Int()
    var myJoinedCount = 0
    var beatTheExpert : ContestCateModel?
    
    var strContestType = "Cash";
    var privateSelectedSection = 1;
    
    
    var isWinning : Bool = false
    var isWinner : Bool = false
    var isEntry : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
	
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 75
	self.layoutLblTitleC.constant = appdelegate.hasTopNotch ? 15 : 5
	
        self.diff_seconds = 0
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        ////--Pull to Refresh---///
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(RefreshData(refreshControl:)), for: .valueChanged)
        tblContest.addSubview(refreshControl) // not required when using
        
        ////--Register Nib for UITableViewCell
        tblContest.register(UINib(nibName: "ContestTCell", bundle: nil), forCellReuseIdentifier: "ContestTCell")
        tblContest.register(UINib(nibName: "BeatTheExpertTCell", bundle: nil), forCellReuseIdentifier: "BeatTheExpertTCell")
        tblContest.register(UINib(nibName: "CategoryHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "CategoryHeaderCell")
        
        
        tblContest.register(UINib(nibName: "InviteContestTCell", bundle: nil), forCellReuseIdentifier: "InviteContestTCell")
        tblContest.register(UINib(nibName: "PrivateCreateContestTCell", bundle: nil), forCellReuseIdentifier: "PrivateCreateContestTCell")
        tblContest.register(UINib(nibName: "PrivateContestHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "PrivateContestHeader")
        tblContest.register(UINib(nibName: "ContestViewMoreFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "ContestViewMoreFooter")
        
        self.setUp();
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tick), name:  Common.NotificationNames.Tick, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.joinContestWithSingleTeam), name:  Common.NotificationNames.JoinContestWithSingleTeam, object: nil)
		
		        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCurrentSection), name:  Common.NotificationNames.privateContestFresh, object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self);
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
            self.lblTimer.text = time_diff
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if  self.isMovingToParent {
            self.GetContest(isProgressHud: true)
        } else {
            self.GetContest(isProgressHud: false)
        }
    }
    
    @objc func RefreshData(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .background).async {
            self.GetContest(isProgressHud: true)
        }
    }
    
	@objc func updateCurrentSection() {
		let btn = UIButton();
		btn.tag = 101;
		privateSelectedSection = 1
		self.actionForEventTypes(btn);
    }
	
    func setUp() {
        
		self.tblContest.backgroundColor = .white;
        lblTeams.text = "\(appdelegate.SingleMatchInfo.team1.sortName!) vs \(appdelegate.SingleMatchInfo.team2.sortName ?? "")"
        
        lblTeamsCount.cornerRadius = 12;
        lblJoinedContestCount.cornerRadius = 12;
        
        lblTeamsCount.font = UIFont(name: font_bold, size: 10);
        lblJoinedContestCount.font = UIFont(name: font_bold, size: 10);
        
        lblTeamsCount.textColor = APPCOLOR.TextWhiteColor;
        lblJoinedContestCount.textColor = APPCOLOR.TextWhiteColor;
        
        lblMyTeam.font = UIFont(name: font_bold, size: 14);
        lblJoinedContest.font = UIFont(name: font_bold, size: 14);
        
        lblMyTeam.textColor = APPCOLOR.TextGrayColor;
        lblJoinedContest.textColor = APPCOLOR.TextGrayColor;
        
        
        lblTeams.textColor = APPCOLOR.TextBlackColor;
        lblTimer.textColor = APPCOLOR.redCustom;
        
        lblNavBackTitle.textColor = APPCOLOR.TextWhiteColor;
        
        lblNavBackTitle.font = UIFont(name: font_medium, size: 14);
        lblAmount.font = UIFont(name: font_reguler, size: 10);
        lblTeams.font = UIFont(name: font_reguler, size: 14);
        lblTimer.font = UIFont(name: font_reguler, size: 14);
        vwTimer.setshadow(cornerR: 18, shadowC: .black, shadowO: 0.4, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
        vwTimer.backgroundColor = APPCOLOR.YellowCustom;
        for btn in [btnCash, btnPrivate, btnPractice] {
            btn?.titleLabel?.font = UIFont(name: font_bold, size: 12);
            btn?.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.4, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
            btn?.setTitleColor(APPCOLOR.TextLightGrayColor, for: .normal);
            btn?.backgroundColor = APPCOLOR.CustomWhiteColor;
        }
        
        btnCash.backgroundColor = APPCOLOR.redCustom;
        btnCash.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
        if let info = appdelegate.objAmountDetail{
            self.lblAmount.text = String(format: "%.2f", info.totalAmount);
            
        }
		
		let templateImage = imgWallet.image?.withRenderingMode(.alwaysTemplate)
		imgWallet.image = templateImage
		imgWallet.tintColor = APPCOLOR.redCustom
		self.imgWallet.tintAdjustmentMode = .normal
		
		let templateImage1 = imgClock.image?.withRenderingMode(.alwaysTemplate)
		imgClock.image = templateImage1
		imgClock.tintColor = APPCOLOR.redCustom

        
        if let info = appdelegate.objAccountInfo{
            if Int(info.notificationCounter) ?? 0 > 0{
                self.lblNotification.isHidden = false;
                self.lblNotification.text = info.notificationCounter;
            }else{
                self.lblNotification.isHidden = true;
            }
            
        }
        
    }
    
    @IBAction func actionForCreateTeam(_ sender: Any) {
        if appdelegate.matchType == kCricket {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
            self.navigationController!.pushViewController(vc, animated: true)
        }else if appdelegate.matchType == kFootball {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
            self.navigationController!.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func actionForFilters(_ sender: UIButton) {

        ImgTotalWinning.isHidden = true;
        imgEntryFee.isHidden = true;
        imgWinners.isHidden = true;
        switch sender.tag {
        case 301: ///--Filter By winning prize
            ImgTotalWinning.isHidden = false;
            if isWinning == false {
                isWinning = true
                if self.arrContestList.count > 0 {
                    ImgTotalWinning.image = UIImage(named: "arrow_down2")
                    for cat in self.arrContestList{
                        if cat.title != "Beat The Expert"{
                            cat.contests = cat.contests.sorted(by: { Int($0.totalPrice)! > Int($1.totalPrice)! } )
                        }
                    }
                    self.tblContest.reloadData()
                }
            } else {
                isWinning = false
                if self.arrContestList.count > 0 {
                    ImgTotalWinning.image = UIImage(named: "arrow_Up2")
                    for cat in self.arrContestList{
                        if cat.title != "Beat The Expert"{
                            cat.contests = cat.contests.sorted(by: { Int($0.totalPrice)! < Int($1.totalPrice)! } )
                        }
                    }
                    self.tblContest.reloadData()
                }
               
            }
        case 302: ///--Filter By winner size
            imgEntryFee.isHidden = false;
            if isEntry == false {
                isEntry = true
                if self.arrContestList.count > 0 {
                    imgEntryFee.image = UIImage(named: "arrow_down2")
                    for cat in self.arrContestList{
                        if cat.title != "Beat The Expert"{
                            cat.contests = cat.contests.sorted(by: { $0.entryFees > $1.entryFees } )
                        }
                    }
                    self.tblContest.reloadData()
                }
            } else {
                isEntry = false
                if self.arrContestList.count > 0 {
                    imgEntryFee.image = UIImage(named: "arrow_Up2")
                    for cat in self.arrContestList{
                        if cat.title != "Beat The Expert"{
                            cat.contests = cat.contests.sorted(by: { $0.entryFees < $1.entryFees } )
                        }
                    }
                    self.tblContest.reloadData()
                }
               
            }
        case 303: ///--Filter By winner size
            imgWinners.isHidden = false;
            if isWinner == false {
                isWinner = true
                if self.arrContestList.count > 0 {
                    imgWinners.image = UIImage(named: "arrow_down2")
                    for cat in self.arrContestList{
                        if cat.title != "Beat The Expert"{
                            cat.contests = cat.contests.sorted(by: { Int($0.totalWinners)! > Int($1.totalWinners)! } )
                        }
                    }
                    self.tblContest.reloadData()
                }
            } else {
                isWinner = false
                if self.arrContestList.count > 0 {
                    imgWinners.image = UIImage(named: "arrow_Up2")
                    for cat in self.arrContestList{
                        if cat.title != "Beat The Expert"{
                            cat.contests = cat.contests.sorted(by: { Int($0.totalWinners)! < Int($1.totalWinners)! } )
                        }
                    }
                    self.tblContest.reloadData()
                }
            }
        default:
            print("Unknown Filter")
            return
        }
    }
    
    
    @IBAction func actionForBack(_ sender: Any) {
        NotificationCenter.default.removeObserver(self);
        self.navigationController?.popViewController(animated: true);
    }
    @IBAction func actionForWallet(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "More", bundle: nil)
        let screen = mainStoryboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        screen.parentVC = self;
        screen.transitioningDelegate = self
        self.present(screen, animated: true, completion: nil)
    }
    
    @IBAction func actionForNotification(_ sender: Any) {
        let vc = UIStoryboard(name: "Account", bundle: nil)
            .instantiateViewController(withIdentifier: "NotificationVC");
        vc.hidesBottomBarWhenPushed = true;
        if let info = appdelegate.objAccountInfo{
            info.notificationCounter = "0"
        }
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func actionForEventTypes(_ sender: UIButton) {
        
        for btn in [btnCash, btnPrivate, btnPractice] {
            btn?.setTitleColor(APPCOLOR.TextLightGrayColor, for: .normal);
            btn?.backgroundColor = APPCOLOR.CustomWhiteColor;
        }
        layoutTblY.constant = 2;
        switch sender.tag {
        case 101:
            btnCash.backgroundColor = APPCOLOR.redCustom;
            btnCash.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
            arrContestList = arrPaidContestList;
            strContestType = "Cash";
            layoutTblY.constant = 45;
        case 102:
            btnPractice.backgroundColor = APPCOLOR.redCustom;
            btnPractice.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
            arrContestList = arrFreeContestList;
            strContestType = "Practice";
        case 103:
            btnPrivate.backgroundColor = APPCOLOR.redCustom;
            btnPrivate.setTitleColor(APPCOLOR.TextWhiteColor, for: .normal);
            strContestType = "Private";
            
        default:
            print("default");
        }
        self.tblContest.reloadData();
    }
    @IBAction func actionForMyTeams(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyTeamVC") as! MyTeamVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionForJoinedContest(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "JoinedContestVC") as! JoinedContestVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - API Method
     
     func GetContest(isProgressHud: Bool) {
         
         if isProgressHud {
             Common.sharedInstance.showHud();
         }
        let api = String(format: "%@%@%@/%@/%@", APPURL.BaseURL,appdelegate.matchTypeUrl,APPURL.GetContest,appdelegate.SingleMatchInfo.id,appdelegate.SingleMatchInfo.matchId);
        
        HomeService.GetContest(_apiName: api, params: [:]) { (flag, response, msg) in
             if flag{
                 if let dict = response{
                    self.arrContestList.removeAll();
                    self.arrPaidContestList.removeAll();
                    self.arrFreeContestList.removeAll();
                     if let dictResults = dict["data"] as? [[String : Any]]{
                         let arr = Mapper<ContestCateModel>().mapArray(JSONArray: dictResults )
                         self.arrPaidContestList = arr.filter({$0.contests.count > 0});
                     }
                    
                    if let dictResults = dict["practice"] as? [[String : Any]]{
                        let arr = Mapper<ContestCateModel>().mapArray(JSONArray: dictResults )
                        self.arrFreeContestList = arr.filter({$0.contests.count > 0});
                    }
                    
                    if let dictResults = dict["beat_the_expert"] as? [[String : Any]]{
                        let arr = Mapper<ContestCateModel>().mapArray(JSONArray: dictResults )
                        if arr.count > 0{
                            self.beatTheExpert = arr.first;
                            self.arrPaidContestList.insert(self.beatTheExpert!, at: 0);
                        }
                    }
                    
                    if self.strContestType == "Cash"{
                        self.arrContestList = self.arrPaidContestList;
                        for cat in self.arrContestList{
                            if cat.title != "Beat The Expert"{
                                cat.contests = cat.contests.sorted(by: { Int($0.totalPrice)! > Int($1.totalPrice)! } )
                            }
                        }
                    }else{
                        self.arrContestList = self.arrFreeContestList;
                    }
                                    
                    self.isWinning = true;
                    self.tblContest.delegate = self;
                    self.tblContest.dataSource = self;
                    self.tblContest.reloadData();
                    self.vwBottom.isHidden = false;
                    if let detailDict = dict["detail"] as? [String : Any]{
                        self.myTeamCount = detailDict ["total_teams"] as? Int ?? 0
                        self.myJoinedCount = detailDict ["total_joined_contest"] as? Int ?? 0
                    }
                    if  self.myTeamCount > 0 {
                        self.vwCreateTeam.isHidden = true;
                        self.vwMyTeamsBottom.isHidden = false;
                        self.lblTeamsCount.text = "\(self.myTeamCount)";
                        self.vwJoinContestBottom.isHidden = false;
			self.lblJoinedContestCount.isHidden = false;
			self.lblJoinedContestCount.text = "\(self.myJoinedCount)";
			self.lblJoinedContest.text = "JOINED CONTESTS"
                     } else {
                        self.vwBottom.isHidden = true;
                        self.vwCreateTeam.isHidden = false;
                     }
                 }
                 
             }else{
                self.view.showToast(message: msg);
             }
             Common.sharedInstance.hideHud();
             self.refreshControl.endRefreshing();
         }
     }
    
    @objc func privateSectionClick(sender : UIButton){
        if privateSelectedSection == sender.tag{
            privateSelectedSection = -1;
        } else{
            privateSelectedSection = sender.tag;
        }
        self.tblContest.reloadData();
    }
     
     
     // MARK: - TableView Datasource and Delegate Methods
     func numberOfSections(in tableView: UITableView) -> Int {
        if strContestType == "Private"{
            return self.privateDict.count;
        }else{
            return self.arrContestList.count
        }
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if strContestType == "Private"{
            return privateSelectedSection == section ? 1 : 0;
        }else{
            return self.arrContestList[section].isShowViewMore ? (self.arrContestList[section].isViewMore ? self.arrContestList[section].contests.count : 3) : self.arrContestList[section].contests.count
        }
     }
     
     //--Header View
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if strContestType == "Private"{
            return 50;
        }else{
            if self.arrContestList[section].title == "Beat The Expert" {
                return 0;
            }
            return 60;
        }
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if strContestType == "Private"{
            if indexPath.section == 0{
                return 525;
            }else{
                return 206;
            }
        }else{
            return UITableView.automaticDimension;
        }
    }
        
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        if strContestType == "Private"{
            if indexPath.section == 0{
                return 525;
            }else{
                return 206;
            }
        }else{
            return 120;
        }
    }
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if strContestType == "Private"{
            let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PrivateContestHeader") as! PrivateContestHeader
            headerCell.backgroundColor = .white;
            headerCell.lblTitle.text = privateDict[section]["title"];
            headerCell.imgLeft.image = UIImage(named: privateDict[section]["image"]!);
            if section == privateSelectedSection{
                headerCell.imgLeft.tintColor = APPCOLOR.greenCustom;
                headerCell.lblTitle.textColor = APPCOLOR.greenCustom;
            }else{
                headerCell.imgLeft.tintColor = APPCOLOR.TextBlackColor;
                headerCell.lblTitle.textColor = APPCOLOR.TextBlackColor;
            }
            headerCell.btnClick.addTarget(self, action: #selector(privateSectionClick(sender:)), for: .touchUpInside);
            headerCell.btnClick.tag = section;
            return headerCell
        }else{
            let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CategoryHeaderCell") as! CategoryHeaderCell
            headerCell.lblCategoryTitle?.text = self.arrContestList[section].title ?? ""
            headerCell.lblCategoryDesc?.text = self.arrContestList[section].desc ?? ""
            headerCell.imgCategory?.backgroundColor = .lightGray
            headerCell.imgCategory?.sd_setImage(with: URL.init(string: (self.arrContestList[section].image ?? "")), completed: { (image, error, SDImageCacheType, url) in
                if image != nil {
                    headerCell.imgCategory?.backgroundColor = .clear
                }
            })
			if self.arrContestList[section].discountImage != ""{
				headerCell.imgDiscount.sd_setImage(with:  URL.init(string: self.arrContestList[section].discountImage),placeholderImage: UIImage.init(named: "user_icon"))
			}
            
            if self.arrContestList[section].isDiscount != "N"{
                headerCell.imgDiscount.isHidden  = false;
            }else{
                headerCell.imgDiscount.isHidden  = true;
            }
            
            return headerCell
        }
     }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if strContestType == "Private"{
            if indexPath.section == 0{
                let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "PrivateCreateContestTCell", for:indexPath) as! PrivateCreateContestTCell
				ContestCell.setUp();
                ContestCell.parentVC = self;
                return ContestCell
            }else{
                let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "InviteContestTCell", for:indexPath) as! InviteContestTCell
                ContestCell.parentVC = self;
                return ContestCell
            }
        }else{
            
            if self.arrContestList[indexPath.section].title == "Beat The Expert"{
                let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "BeatTheExpertTCell", for:indexPath) as! BeatTheExpertTCell
                ContestCell.parentVC = self;
                ContestCell.teamCount = self.myTeamCount;
                ContestCell.SetCellData(model: arrContestList[indexPath.section]);
                return ContestCell
            }else{
                let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "ContestTCell", for:indexPath) as! ContestTCell
                ContestCell.parentVC = self;
                ContestCell.teamCount = self.myTeamCount;
                ContestCell.SetCellData(model: self.arrContestList[indexPath.section].contests[indexPath.row],isDiscount:
                self.arrContestList[indexPath.section].isDiscount)
                return ContestCell
            }
        }
     }
     
     ///--Footer View
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if strContestType == "Private"{
            return 0;
        }else{
            return self.arrContestList[section].isShowViewMore ? 20 : 0;
        }
     }
     
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let footerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContestViewMoreFooter") as! ContestViewMoreFooter
         footerCell.backgroundColor = .white;
        footerCell.lblViewMoreContent.text = self.arrContestList[section].isViewMore ? "View less" : " View \(self.arrContestList[section].contests.count - 3) more"
        footerCell.imgBack.isHidden = !self.arrContestList[section].isViewMore;
        footerCell.imgNext.isHidden = self.arrContestList[section].isViewMore;
         footerCell.btnViewMore.addTarget(self, action: #selector(viewMoreContest(sender:)), for: .touchUpInside);
         footerCell.btnViewMore.tag = section;
         return footerCell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if strContestType != "Private"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContestDetailVC") as! ContestDetailVC
            vc.contestId = self.arrContestList[indexPath.section].contests[indexPath.row].id
            self.navigationController!.pushViewController(vc, animated: true)
        }
     }
    
    
    @objc func viewMoreContest(sender : UIButton) {
        self.arrContestList[sender.tag].isViewMore = !self.arrContestList[sender.tag].isViewMore;
        self.tblContest.reloadData();
    }
    
    
    @objc func joinContestWithSingleTeam(){
        if appdelegate.ContestInfo != nil && appdelegate.JoinTeamId != "0"{
            if appdelegate.isBeatExpert{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeatTheExpertJoinVC") as! BeatTheExpertJoinVC;
                vc.contestInfo = appdelegate.ContestInfo;
                vc.modalPresentationStyle = .overCurrentContext;
                vc.SuccessPrice = {(entryFee) in
                    appdelegate.isBeatExpert = false;
                    self.callForJoinCOnfirm(fee: entryFee)
                }
                self.present(vc, animated: true, completion: nil);
            }else{
                self.callForJoinCOnfirm(fee: "");
            }
        }
    }
    
    func  callForJoinCOnfirm(fee : String = "0") {
        if appdelegate.ContestInfo != nil && appdelegate.JoinTeamId != "0"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JoinConfirmContestVC") as! JoinConfirmContestVC;
            vc.contestID = appdelegate.ContestInfo?.id ?? "0";
            vc.teamId = appdelegate.JoinTeamId;
            vc.entryFee = fee;
            vc.parentVC = self;
            vc.modalPresentationStyle = .overCurrentContext;
            self.present(vc, animated: true, completion: nil);
            vc.needAddCompletion = {(cash) in
                let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "AddCashVC") as! AddCashVC
                vc.needCash = cash;
                vc.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(vc, animated: true);
            }
            vc.completion = { (slug) in
                self.GetContest(isProgressHud: false);
            }
            
        }
    }
}
