//
//  MyContestVC.swift
//  Snozer
//
//  Created by Admin on 11/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class MyContestVC: ViewController {
    
	
	@IBOutlet weak var layoutNoImageH: NSLayoutConstraint!
	
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var lblNoContestTop: UILabel!
    @IBOutlet weak var tblContest: UITableView!
    @IBOutlet weak var vwTopTab: UIView!
    @IBOutlet weak var vwCricket: UIView!
    @IBOutlet weak var vwKabaddi: UIView!
    @IBOutlet weak var vwFootBall: UIView!
    @IBOutlet weak var imgCricket: UIImageView!
    @IBOutlet weak var lblCricket: UILabel!
    
    @IBOutlet weak var imgKabaddi: UIImageView!
    @IBOutlet weak var lblKabaddi: UILabel!
    
    @IBOutlet weak var imgFootBall: UIImageView!
    
    @IBOutlet weak var lblFootball: UILabel!
    
    @IBOutlet weak var lblNoMatchStmt: UILabel!
    
    @IBOutlet weak var vwNoMatch: UIView!
    var selectedSportsIndex = Int()
    var strPlayType = String()
    var timer = Timer()
    var diff_seconds = Double()
    
    var MatchListCell : UITableViewCell!
    var refreshControl = UIRefreshControl()
    var strSegmentType = Int()
    var selectedTabIndex = Int()
    var strMatchType = "F"
    
    //--Model object
    var objMatchList : HomeMatchList!
    var arrMatchList  = [HomeMatchList]()
    var isUserCameFromSideMenu = false
    @IBOutlet weak var vwHeader: UIView!
    var headerView: NavHeaderView?
	@IBOutlet weak var vwNoImage: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
	
		
		self.layoutNoImageH.constant = appdelegate.device.isOneOf([.iPhone5,.iPhone5s, .iPhoneSE]) ? 90 : 180
		self.vwNoImage.cornerRadius = appdelegate.device.isOneOf([.iPhone5,.iPhone5s, .iPhoneSE]) ? 45 : 90
        self.setUp();
        self.setHeaderView();
        selectedSportsIndex = 101
        ////--Pull to Refresh---///
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(RefreshData(refreshControl:)), for: .valueChanged)
        tblContest.addSubview(refreshControl) // not required when using UITableViewController
        
        ////--Register Nib for UITableViewCell
        tblContest.register(UINib(nibName: "MatchTCell", bundle: nil), forCellReuseIdentifier: "MatchTCell")
        tblContest.register(UINib(nibName: "NoDataCell", bundle: nil), forCellReuseIdentifier: "NoDataCell")
        tblContest.register(UINib(nibName: "MatchCenterHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "MatchCenterHeaderCell")
        
        self.tblContest.estimatedSectionHeaderHeight = 85
        
        self.tabBarController?.tabBar.isTranslucent = false
        
        self.vwCricket.isHidden = true;
        self.vwKabaddi.isHidden = true;
        self.vwFootBall.isHidden = true;
        if Utility.sharedInstance.arrGames.count > 0 {
            for gm in Utility.sharedInstance.arrGames {
                if gm.id == kCricket{
                    self.vwCricket.isHidden = false;
                    self.lblCricket.text = gm.name;
                    self.imgCricket.sd_setImage(with:  URL.init(string: gm.image),placeholderImage: UIImage.init(named: "cricket_icon"))
                    self.delay(0.5) {
                        let templateImage = self.imgCricket.image?.withRenderingMode(.alwaysTemplate)
                        self.imgCricket.image = templateImage
                        self.imgCricket.tintColor = .white
                    }
                }
                if gm.id == kKabaddi{
                    self.vwKabaddi.isHidden = false;
                    self.lblKabaddi.text = gm.name;
                    self.imgKabaddi.sd_setImage(with:  URL.init(string: gm.image),placeholderImage: UIImage.init(named: "Kabaddi_icon"))
                    self.delay(0.5) {
                        let templateImage = self.imgKabaddi.image?.withRenderingMode(.alwaysTemplate)
                        self.imgKabaddi.image = templateImage
                        self.imgKabaddi.tintColor = .black
                    }
                }
                
                if gm.id == kFootball{
                    self.vwFootBall.isHidden = false;
                    self.lblFootball.text = gm.name;
                    self.imgFootBall.sd_setImage(with:  URL.init(string: gm.image),placeholderImage: UIImage.init(named: "football_icon"))
                    self.delay(0.5) {
                        let templateImage = self.imgFootBall.image?.withRenderingMode(.alwaysTemplate)
                        self.imgFootBall.image = templateImage
                        self.imgFootBall.tintColor = .black
                    }
                }
            }
        }
        let btn = UIButton();
        btn.tag = appdelegate.matchType == kCricket ? 101 : (appdelegate.matchType == kFootball ? 103 : 102)
        self.actionForChangeSportType(btn) 
        self.getmatchListAPI();
     NotificationCenter.default.addObserver(self, selector: #selector(self.updateMatchTimes), name: Common.NotificationNames.Tick, object: nil)
   }
   
   @objc func updateMatchTimes() {
       
       for cell in tblContest.visibleCells {
           if cell is MatchTCell {
               let mCell = cell as! MatchTCell
               mCell.gameTime()
           }
       }
   }

    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.btnBack.isHidden = true;
//        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "MY MATCHES");
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
    }
    
    func setUp() {
		
        self.vwNoMatch.isHidden = true;
        self.vwTopTab.cornerRadius = 20;
        self.vwTopTab.clipsToBounds = true;
        self.vwTopTab.borderColor = APPCOLOR.redCustom;
        self.vwTopTab.borderWidth = 1.0;
        self.vwTopTab.backgroundColor = APPCOLOR.redCustom;
        self.vwCricket.backgroundColor = APPCOLOR.redCustom;
        self.imgCricket.tintColor = APPCOLOR.TextWhiteColor;
        self.lblCricket.textColor = APPCOLOR.TextWhiteColor;
        
        self.vwKabaddi.backgroundColor  = APPCOLOR.TextWhiteColor;
        self.imgKabaddi.tintColor       = APPCOLOR.TextBlackColor;
        self.lblKabaddi.textColor       = APPCOLOR.TextBlackColor;
        
        self.vwFootBall.backgroundColor  = APPCOLOR.TextWhiteColor;
        self.imgFootBall.tintColor       = APPCOLOR.TextBlackColor;
        self.lblFootball.textColor       = APPCOLOR.TextBlackColor;
        
        self.lblCricket.font = UIFont(name: font_medium, size: 12);
        self.lblKabaddi.font = UIFont(name: font_medium, size: 12);
        self.lblFootball.font = UIFont(name: font_medium, size: 12);
        tblContest.tableFooterView = UIView();
		tblContest.backgroundColor = .white;
    }
    
    
    @objc func RefreshData(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .background).async {
            self.getmatchListAPI()
        }
    }
    
    @IBAction func actionForJoinContestTab(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0;
    }
    @IBAction func actionForChangeSportType(_ sender: UIButton) {
        
        self.vwCricket.backgroundColor  = APPCOLOR.TextWhiteColor;
        self.imgCricket.tintColor       = APPCOLOR.TextBlackColor;
        self.lblCricket.textColor       = APPCOLOR.TextBlackColor;
        
        
        self.vwKabaddi.backgroundColor  = APPCOLOR.TextWhiteColor;
        self.imgKabaddi.tintColor       = APPCOLOR.TextBlackColor;
        self.lblKabaddi.textColor       = APPCOLOR.TextBlackColor;
        
        self.vwFootBall.backgroundColor  = APPCOLOR.TextWhiteColor;
        self.imgFootBall.tintColor       = APPCOLOR.TextBlackColor;
        self.lblFootball.textColor       = APPCOLOR.TextBlackColor;
        
        switch sender.tag {
        case 101:
            vwCricket.backgroundColor   = APPCOLOR.redCustom;
            imgCricket.tintColor        = APPCOLOR.TextWhiteColor;
            lblCricket.textColor        = APPCOLOR.TextWhiteColor;
            strPlayType = "C";
            appdelegate.matchTypeUrl = APPURL.CricketUrl;
            appdelegate.matchType = kCricket;
        case 102:
            vwKabaddi.backgroundColor   = APPCOLOR.redCustom;
            imgKabaddi.tintColor        = APPCOLOR.TextWhiteColor;
            lblKabaddi.textColor        = APPCOLOR.TextWhiteColor;
            strPlayType = "K";
            appdelegate.matchTypeUrl = APPURL.KabaddiUrl;
            appdelegate.matchType = kKabaddi;
        case 103:
            vwFootBall.backgroundColor   = APPCOLOR.redCustom;
            imgFootBall.tintColor        = APPCOLOR.TextWhiteColor;
            lblFootball.textColor        = APPCOLOR.TextWhiteColor;
            strPlayType = "F";
            appdelegate.matchTypeUrl = APPURL.FootBallUrl;
            appdelegate.matchType = kFootball;
        default:
            print("nothing tab");
        }
        self.getmatchListAPI();
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if !isUserCameFromSideMenu {
            //                self.GetAmountDetail()
            self.getmatchListAPI()
        }
        self.headerView?.setWallet()
        isUserCameFromSideMenu = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func updateTimer() {
        self.diff_seconds += 1
        
        UIView.performWithoutAnimation {
            self.tblContest.reloadData()
            self.tblContest.beginUpdates()
            self.tblContest.endUpdates()
        }
    }
    
    @IBAction func btnMatchTypeAction(_ sender: UIButton) {
        selectedSportsIndex = sender.tag
        if selectedSportsIndex == 101 {
            self.strMatchType = "F";
        } else if selectedSportsIndex == 102 {
            self.strMatchType = "L";
        } else if selectedSportsIndex == 103 {
            self.strMatchType = "R";
        } else {
            arrMatchList.removeAll()
        }
        self.getmatchListAPI()
        self.tblContest.reloadData()
    }
    
    func getmatchListAPI()  {
        let apiUrl = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.CustomerMatches + "/" + strMatchType;
        HomeService.getMyMatchList(_apiName: apiUrl, params: [:], callback: { (flag, response, msg) in
            if flag{
                self.arrMatchList = response;
                if response.count > 0{
                    self.vwNoMatch.isHidden = true;
                    self.tblContest.delegate = self
                    self.tblContest.dataSource = self
                    self.timer.invalidate()
                    self.diff_seconds = 0
                    self.timer.invalidate()
                    self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                    RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
                }else{
                    self.vwNoMatch.isHidden = false;
                    if self.strMatchType == "R"{
                        self.lblNoMatchStmt.text = "Join contests for any of the upcoming matches";
                        self.lblNoContestTop.text = "You haven't joined any contests that are completed recently";
                    }else if self.strMatchType == "L"{
                        self.lblNoMatchStmt.text = "Join contests for any of the upcoming matches";
                        self.lblNoContestTop.text = "You haven't joined any contests that are live";
                    } else {
                        self.lblNoMatchStmt.text = "Join contests for any of the upcoming matches";
                        self.lblNoContestTop.text = "You haven't joined any upcoming contests";
                    }
                }
                
            }else{
                self.view.showToast(message: msg);
            }
            self.tblContest.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
}


extension MyContestVC : UITableViewDelegate, UITableViewDataSource{
    // MARK: - TableView Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrMatchList.count == 0 {
            return 1
        } else {
            return self.arrMatchList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
            return 90
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        return 55;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MatchCenterHeaderCell") as! MatchCenterHeaderCell
        
        headerCell.btnCompleted.setTitle("RESULT", for: .normal);
        headerCell.btnLive.addTarget(self, action: #selector(btnMatchTypeAction(_:)), for: .touchUpInside)
        headerCell.btnFixture.addTarget(self, action: #selector(btnMatchTypeAction(_:)), for: .touchUpInside)
        headerCell.btnCompleted.addTarget(self, action: #selector(btnMatchTypeAction(_:)), for: .touchUpInside)
        
        headerCell.btnLive.backgroundColor = APPCOLOR.CustomWhiteColor
        headerCell.btnFixture.backgroundColor = APPCOLOR.CustomWhiteColor
        headerCell.btnCompleted.backgroundColor = APPCOLOR.CustomWhiteColor
        
        headerCell.btnLive.setTitleColor(APPCOLOR.TextLightGrayColor, for: .normal)
        headerCell.btnFixture.setTitleColor(APPCOLOR.TextLightGrayColor, for: .normal)
        headerCell.btnCompleted.setTitleColor(APPCOLOR.TextLightGrayColor, for: .normal)
        headerCell.lblText.text = ""
        if selectedSportsIndex == 101 {
            headerCell.btnFixture.backgroundColor = APPCOLOR.redCustom;
            headerCell.btnFixture.setTitleColor(UIColor.white, for: .normal)
            
        } else if selectedSportsIndex == 102 {
            headerCell.btnLive.backgroundColor = APPCOLOR.redCustom;
            headerCell.btnLive.setTitleColor(UIColor.white, for: .normal)
        } else if selectedSportsIndex == 103 {
            headerCell.btnCompleted.backgroundColor = APPCOLOR.redCustom;
            headerCell.btnCompleted.setTitleColor(UIColor.white, for: .normal)
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrMatchList.count == 0 {
            let NoDataCell =  tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for:indexPath) as! NoDataCell
            NoDataAlert.getValueByTabAndSegment(tabIndex: 0, SegmentIndex: strSegmentType)
            NoDataCell.lblNoData?.text = "Coming Soon"
            return NoDataCell
        } else {
            
            let objMatch = self.arrMatchList[indexPath.row]
            let MatchListCell =  tableView.dequeueReusableCell(withIdentifier: "MatchTCell", for:indexPath) as! MatchTCell
            Common.serverTime = objMatch.serverDate
            MatchListCell.vwJoinedContest.isHidden = false;
            MatchListCell.lblDate.isHidden = true;
            MatchListCell.configureLayoutScreen(objMatch)
            return MatchListCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.strMatchType == "F"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JoinedContestVC") as! JoinedContestVC
            appdelegate.SingleMatchInfo = self.arrMatchList[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StartedContestsVC") as! StartedContestsVC
            appdelegate.SingleMatchInfo = self.arrMatchList[indexPath.row]
            vc.comeFrom = "My Contest";
            vc.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
    }
}

