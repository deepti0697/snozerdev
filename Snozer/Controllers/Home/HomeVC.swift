//
//  HomeVC.swift
//  Snozer
//
//  Created by Admin on 30/09/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class HomeVC: ViewController {
    
	@IBOutlet weak var layoutLogoC: NSLayoutConstraint!
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var imgWallet: UIImageView!
	@IBOutlet weak var imgQW: NSLayoutConstraint!
    @IBOutlet weak var imgQH: NSLayoutConstraint!
    var arrGames : [GameDto] = [];
    @IBOutlet weak var tblContest: UITableView!
    @IBOutlet weak var vwTopTab: UIView!
    @IBOutlet weak var vwCricket: UIView!
    @IBOutlet weak var vwKabaddi: UIView!
    @IBOutlet weak var vwFootBall: UIView!
    @IBOutlet weak var imgCricket: UIImageView!
    @IBOutlet weak var lblCricket: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var imgKabaddi: UIImageView!
    @IBOutlet weak var lblKabaddi: UILabel!
    
    @IBOutlet weak var imgFootBall: UIImageView!
    
    @IBOutlet weak var lblFootball: UILabel!
    
    @IBOutlet weak var vwQuotation: UIView!
    @IBOutlet weak var imgQuotation: UIImageView!
    
    @IBOutlet weak var lblNotification: UILabel!
    
    
    var selectedSportsIndex = Int()
    var strPlayType = String()    
    var MatchListCell : UITableViewCell!
    var refreshControl = UIRefreshControl()
    var strSegmentType = Int()
    var selectedTabIndex = Int()
    var HeaderImageAPICall = Bool()
    var strMatchType = "F"
    
    //--Model object
    var objMatchList : HomeMatchList!
    var arrMatchList  = [HomeMatchList]()
    var isUserCameFromSideMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
		layoutLogoC.constant = appdelegate.hasTopNotch ? 15 : 5
        if let sType = Utility.sharedInstance.get(key: "SelectedSport") as? String{
            appdelegate.matchType = sType;
            appdelegate.matchTypeUrl = sType == kCricket ? APPURL.CricketUrl : (sType == kFootball ? APPURL.FootBallUrl : APPURL.KabaddiUrl)
        }
        self.setUp();
        
        self.HeaderImageAPICall = false
        self.getGamesTypes();
        
		let templateImage = imgWallet.image?.withRenderingMode(.alwaysTemplate)
		imgWallet.image = templateImage
		imgWallet.tintColor = APPCOLOR.redCustom
		self.imgWallet.tintAdjustmentMode = .normal
        
        selectedSportsIndex = 101
        ////--Pull to Refresh---///
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(RefreshData(refreshControl:)), for: .valueChanged)
        tblContest.addSubview(refreshControl)
        
        ////--Register Nib for UITableViewCell
        tblContest.register(UINib(nibName: "MatchTCell", bundle: nil), forCellReuseIdentifier: "MatchTCell")
        tblContest.register(UINib(nibName: "NoDataCell", bundle: nil), forCellReuseIdentifier: "NoDataCell")
        tblContest.register(UINib(nibName: "OfferImageCell", bundle: nil), forCellReuseIdentifier: "OfferImageCell")
        tblContest.register(UINib(nibName: "MatchCenterHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "MatchCenterHeaderCell")
        
        self.tblContest.estimatedSectionHeaderHeight = 80
        
        self.tabBarController?.tabBar.isTranslucent = false // For tab bar issue when coming back from detail screen.
        //        self.GetAccInfo()
        
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
    
    
    func getGamesTypes(){
        
        HomeService.getGames(params: [:]) { (flag, response, msg) in
            if flag{
                self.vwCricket.isHidden = true;
                self.vwKabaddi.isHidden = true;
                self.vwFootBall.isHidden = true;
                Utility.sharedInstance.arrGames = response;
                self.arrGames = response;
                if self.arrGames.count > 0 {
                    for gm in self.arrGames {
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
            }
        }
    }
    
    
    func setUp() {
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
		self.tblContest.backgroundColor = .white;
        
        if let info = appdelegate.objAccountInfo{
            if Int(info.notificationCounter) ?? 0 > 0{
                self.lblNotification.isHidden = false;
                self.lblNotification.text = info.notificationCounter;
            }else{
                self.lblNotification.isHidden = true;
            }
        }
    }
    
    @IBAction func actionForCloseQuotation(_ sender: Any) {
        vwQuotation.isHidden = true;
    }
    
    @IBAction func actionForDontShowAgain(_ sender: Any) {
        let arr = self.arrGames.filter({$0.id == appdelegate.matchType})
        if let gm = arr.first{
            gm.isShowAgain = false;
        }
        vwQuotation.isHidden = true;
    }
    
    @objc func RefreshData(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .background).async {
            self.getmatchListAPI()
        }
    }
    
    @IBAction func actionForChangeSportType(_ sender: UIButton) {
        
        self.vwCricket.backgroundColor  = APPCOLOR.TextWhiteColor;
        self.imgCricket.tintColor       = APPCOLOR.TextBlackColor;
        self.lblCricket.textColor       = APPCOLOR.TextBlackColor;
//        let templateImage = self.imgCricket.image?.withRenderingMode(.alwaysTemplate)
//        self.imgCricket.image = templateImage
//        self.imgCricket.tintColor = APPCOLOR.TextBlackColor;
        
        self.vwKabaddi.backgroundColor  = APPCOLOR.TextWhiteColor;
        self.imgKabaddi.tintColor       = APPCOLOR.TextBlackColor;
        self.lblKabaddi.textColor       = APPCOLOR.TextBlackColor;
        
//        let templateImage1 = self.imgKabaddi.image?.withRenderingMode(.alwaysTemplate)
//        self.imgKabaddi.image = templateImage1
//        self.imgKabaddi.tintColor = APPCOLOR.TextBlackColor;
//
        self.vwFootBall.backgroundColor  = APPCOLOR.TextWhiteColor;
        self.imgFootBall.tintColor       = APPCOLOR.TextBlackColor;
        self.lblFootball.textColor       = APPCOLOR.TextBlackColor;
        
//        let templateImage2 = self.imgFootBall.image?.withRenderingMode(.alwaysTemplate)
//        self.imgFootBall.image = templateImage2
//        self.imgFootBall.tintColor = APPCOLOR.TextBlackColor;
//
        switch sender.tag {
        case 101:
            vwCricket.backgroundColor   = APPCOLOR.redCustom;
            imgCricket.tintColor        = APPCOLOR.TextWhiteColor;
            lblCricket.textColor        = APPCOLOR.TextWhiteColor;
            strPlayType = "C";
            appdelegate.matchTypeUrl = APPURL.CricketUrl;
            appdelegate.matchType = kCricket;
            Utility.sharedInstance.save(object: kCricket, key: "SelectedSport");
            
        case 102:
            vwKabaddi.backgroundColor   = APPCOLOR.redCustom;
            imgKabaddi.tintColor        = APPCOLOR.TextWhiteColor;
            lblKabaddi.textColor        = APPCOLOR.TextWhiteColor;
            strPlayType = "K";
            appdelegate.matchTypeUrl = APPURL.KabaddiUrl;
            appdelegate.matchType = kKabaddi;
            Utility.sharedInstance.save(object: kKabaddi, key: "SelectedSport");
        case 103:
            vwFootBall.backgroundColor   = APPCOLOR.redCustom;
            imgFootBall.tintColor        = APPCOLOR.TextWhiteColor;
            lblFootball.textColor        = APPCOLOR.TextWhiteColor;
            strPlayType = "F";
            appdelegate.matchTypeUrl = APPURL.FootBallUrl;
            appdelegate.matchType = kFootball;
            Utility.sharedInstance.save(object: kFootball, key: "SelectedSport");
        default:
            print("nothing tab");
        }
        let arr = self.arrGames.filter({$0.id == appdelegate.matchType})
        if let gm = arr.first{
            if gm.quotation != nil{
                if gm.isShowAgain{
                    self.showQuation(quotationValue: gm.quotation!);
                    gm.isShowAgain = false;
                }
            }
        }
        self.getmatchListAPI();
    }
    
    func showQuation(quotationValue: QuotationDto) {
        self.updateImageHight(quotationValue: quotationValue);
        imgQuotation.sd_setImage(with:  URL.init(string: quotationValue.image),placeholderImage: UIImage.init(named: "KDEF"))
        vwQuotation.isHidden = false;
    }
    
    func updateImageHight(quotationValue: QuotationDto) {
        if Int(quotationValue.width)! > Int(quotationValue.height)! {
            let newWidth = Float(UIScreen.main.bounds.width - 40);
            let oldWidth = Float(quotationValue.width)!
            let scale = newWidth/oldWidth
            let newHeight = Float(quotationValue.height)! * scale
            imgQH.constant = CGFloat(newHeight);
            imgQW.constant = CGFloat(newWidth);
        } else{
            let newHeight : Float = 400;
            let oldHeight = Float(quotationValue.height)!
            let scale = newHeight/oldHeight
            let newWidth = Float(quotationValue.width)! * scale
            imgQH.constant = CGFloat(newHeight);
            imgQW.constant = CGFloat(newWidth);
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if !isUserCameFromSideMenu {
            //                self.GetAmountDetail()
            self.getmatchListAPI()
        }
        self.GetAmountDetail()
        isUserCameFromSideMenu = true
        if let info = appdelegate.objAccountInfo{
            if Int(info.notificationCounter) ?? 0 > 0{
                self.lblNotification.isHidden = false;
                self.lblNotification.text = info.notificationCounter;
            }else{
                self.lblNotification.isHidden = true;
            }
        }
    }
    
    @IBAction func actionForNotifcation(_ sender: Any) {
        let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC");
        vc.hidesBottomBarWhenPushed = true;
        if let info = appdelegate.objAccountInfo{
            info.notificationCounter = "0"
        }
        self.navigationController?.pushViewController(vc, animated: true);
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
    
    
    @IBAction func openWalletInfo(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "More", bundle: nil)
        let screen = mainStoryboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        screen.parentVC = self;
        screen.transitioningDelegate = self
        self.present(screen, animated: true, completion: nil)
    }
    
    
    // MARK: - API
    func GetAmountDetail() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.WalletInfo
        ProfileService.GetAmountDetail(api, params: [:]) { (flag, resposne, msg) in
            if flag{
                if let obj = resposne{
                    appdelegate.objAmountDetail = obj;
                    let total = obj.depositAmount + obj.winningAmount + obj.bonusAmount;
                    appdelegate.objAmountDetail?.totalAmount = total;
                    self.lblAmount.text = String(format: "%.2f", total);
                }
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    func getmatchListAPI()  {
        let apiUrl = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetMatchList + "/" + strMatchType;
        HomeService.getmatchList(_apiName: apiUrl, params: [:]) { (flag, response, msg) in
            if flag{
                self.arrMatchList = response;
                self.HeaderImageAPICall = true
                self.tblContest.delegate = self
                self.tblContest.dataSource = self
            }else{
                self.view.showToast(message: msg);
            }
            self.tblContest.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}


extension HomeVC : UITableViewDelegate, UITableViewDataSource{
    // MARK: - TableView Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            if arrMatchList.count == 0 {
                return 1
            } else {
                return self.arrMatchList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 180
            }
            else
            {
                return 130
            }
            
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 180
            }
            else
            {
                return 130
            }
        } else {
            return 100
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            if selectedSportsIndex == 101{
                return 80
            }else{
                return 55
            }
            
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 1 {
            if selectedSportsIndex == 101{
                return 80
            }else{
                return 55
            }
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MatchCenterHeaderCell") as! MatchCenterHeaderCell
        headerCell.btnLive.addTarget(self, action: #selector(btnMatchTypeAction(_:)), for: .touchUpInside)
        headerCell.btnFixture.addTarget(self, action: #selector(btnMatchTypeAction(_:)), for: .touchUpInside)
        headerCell.btnCompleted.addTarget(self, action: #selector(btnMatchTypeAction(_:)), for: .touchUpInside)
        
        headerCell.btnLive.backgroundColor = APPCOLOR.CustomWhiteColor
        headerCell.btnFixture.backgroundColor = APPCOLOR.CustomWhiteColor
        headerCell.btnCompleted.backgroundColor = APPCOLOR.CustomWhiteColor
        
        headerCell.btnLive.setTitleColor(APPCOLOR.TextLightGrayColor, for: .normal)
        headerCell.btnFixture.setTitleColor(APPCOLOR.TextLightGrayColor, for: .normal)
        headerCell.btnCompleted.setTitleColor(APPCOLOR.TextLightGrayColor, for: .normal)
        
        if selectedSportsIndex == 101 {
            headerCell.btnFixture.backgroundColor = APPCOLOR.redCustom;
            headerCell.btnFixture.setTitleColor(UIColor.white, for: .normal)
            headerCell.lblText?.text = "Upcoming Matches";
        } else if selectedSportsIndex == 102 {
            headerCell.btnLive.backgroundColor = APPCOLOR.redCustom;
            headerCell.btnLive.setTitleColor(UIColor.white, for: .normal)
            headerCell.lblText?.text = "";
        } else if selectedSportsIndex == 103 {
            headerCell.btnCompleted.backgroundColor = APPCOLOR.redCustom;
            headerCell.btnCompleted.setTitleColor(UIColor.white, for: .normal)
            headerCell.lblText?.text = "";
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let OfferImageCell =  tableView.dequeueReusableCell(withIdentifier: "OfferImageCell", for:indexPath) as! OfferImageCell
            if self.HeaderImageAPICall {
                self.HeaderImageAPICall = false
                OfferImageCell.sportType = strPlayType;
                OfferImageCell.GetHeaderImageList()
            }
            return OfferImageCell
        } else {
            if arrMatchList.count == 0 {
                let NoDataCell =  tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for:indexPath) as! NoDataCell
                NoDataAlert.getValueByTabAndSegment(tabIndex: 0, SegmentIndex: strSegmentType)
                if selectedSportsIndex == 101 {
                    NoDataCell.lblNoData?.text = "No Upcoming match available";
                } else if selectedSportsIndex == 102 {
                    NoDataCell.lblNoData?.text = "No Live match available";
                } else if selectedSportsIndex == 103 {
                    NoDataCell.lblNoData?.text = "No Complete match available";
                }
                return NoDataCell
            } else {
                
                let objMatch = self.arrMatchList[indexPath.row]
                let MatchListCell =  tableView.dequeueReusableCell(withIdentifier: "MatchTCell", for:indexPath) as! MatchTCell
                Common.serverTime = objMatch.serverDate
                MatchListCell.vwJoinedContest.isHidden = true;
                MatchListCell.lblDate.isHidden = true;
                MatchListCell.configureLayoutScreen(objMatch)
                return MatchListCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.arrMatchList[indexPath.row].contestCount != "0"{
            if self.arrMatchList[indexPath.row].matchProgress == "F"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContestVC") as! ContestVC
                appdelegate.SingleMatchInfo = self.arrMatchList[indexPath.row]
                vc.hidesBottomBarWhenPushed = true
                self.navigationController!.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "StartedContestsVC") as! StartedContestsVC
                appdelegate.SingleMatchInfo = self.arrMatchList[indexPath.row]
                vc.comeFrom = "Home";
                vc.hidesBottomBarWhenPushed = true
                self.navigationController!.pushViewController(vc, animated: true)
            }
            
        }else{
            if self.arrMatchList[indexPath.row].matchProgress == "F"{
                self.view.showToast(message: "Contests for this match will open soon, stay tuned.")
            } else{
//                self.view.showToast(message: "Match doesn't have any contest.")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "StartedContestsVC") as! StartedContestsVC
                appdelegate.SingleMatchInfo = self.arrMatchList[indexPath.row]
                vc.comeFrom = "Home";
                vc.hidesBottomBarWhenPushed = true
                self.navigationController!.pushViewController(vc, animated: true)
            }
            
        }
        
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            print(response);
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
