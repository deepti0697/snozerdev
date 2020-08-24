//
//  JoinedContestVC.swift
//  Snozer
//
//  Created by Admin on 11/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import ObjectMapper

class JoinedContestVC: ViewController, UITableViewDelegate, UITableViewDataSource {
    
	@IBOutlet weak var imgClock: UIImageView!
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwTimer: UIView!
    @IBOutlet weak var lblTeams: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var tblContest: UITableView!
    var arrContestList  = [ContestCateModel]()
    var timer = Timer()
    var diff_seconds = Double()
    var headerView : NavHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.diff_seconds = 0
        ////--Register Nib for UITableViewCell
       self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
	tblContest.register(UINib(nibName: "BeatTheExpertTCell", bundle: nil), forCellReuseIdentifier: "BeatTheExpertTCell")
        tblContest.register(UINib(nibName: "ContestTCell", bundle: nil), forCellReuseIdentifier: "ContestTCell")
        tblContest.register(UINib(nibName: "CategoryHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "CategoryHeaderCell")
        self.setUp();
        self.setHeaderView();
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
            self.lblTimer.text = time_diff;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if  self.isMovingToParent {
            self.GetContest(isProgressHud: true)
        } else {
            self.GetContest(isProgressHud: false)
        }
    }
    
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = false;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "JOIN CONTEST");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    
    func setUp() {
        
		
		self.tblContest.backgroundColor = .white;
        lblTeams.text = "\(appdelegate.SingleMatchInfo.team1.sortName!) vs \(appdelegate.SingleMatchInfo.team2.sortName ?? "")"
        
        lblTeams.textColor = APPCOLOR.TextBlackColor;
        lblTimer.textColor = APPCOLOR.redCustom;
        
        lblTeams.font = UIFont(name: font_reguler, size: 14);
        lblTimer.font = UIFont(name: font_reguler, size: 12);
        vwTimer.setshadow(cornerR: 18, shadowC: .black, shadowO: 0.4, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
        vwTimer.backgroundColor = APPCOLOR.YellowCustom;
        let templateImage1 = imgClock.image?.withRenderingMode(.alwaysTemplate)
		imgClock.image = templateImage1
		imgClock.tintColor = APPCOLOR.redCustom
    }
    
    
    // MARK: - API Method
    
    func GetContest(isProgressHud: Bool) {
        
        if isProgressHud {
            Common.sharedInstance.showHud();
        }
        let api = String(format: "%@%@%@/%@/%@", APPURL.BaseURL,appdelegate.matchTypeUrl,APPURL.GetCustomerContest,appdelegate.SingleMatchInfo.id,appdelegate.SingleMatchInfo.matchId);
        
        HomeService.GetContest(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                if let dict = response{
                    self.arrContestList.removeAll();
                    if let dictResults = dict["data"] as? [[String : Any]]{
                        let arr = Mapper<ContestCateModel>().mapArray(JSONArray: dictResults )
                        self.arrContestList = arr.filter({$0.contests.count > 0});
                    }
                    
                    if let dictResults = dict["beat_the_expert"] as? [[String : Any]]{
                        let arr = Mapper<ContestCateModel>().mapArray(JSONArray: dictResults )
                        if arr.count > 0{
//                            self.beatTheExpert = arr.first;
                            self.arrContestList.insert(arr.first!, at: 0);
                        }
                    }

                    
                    self.tblContest.delegate = self;
                    self.tblContest.dataSource = self;
                    self.tblContest.reloadData();
                }
            }else{
                self.view.showToast(message: msg);
            }
            Common.sharedInstance.hideHud();
        }
    }
    
    // MARK: - TableView Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrContestList.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrContestList[section].contests.count
    }
    
    //--Header View
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.arrContestList[section].title == "Beat The Expert" {
            return 0;
        }
        return 60;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CategoryHeaderCell") as! CategoryHeaderCell
        headerCell.lblCategoryTitle?.text = self.arrContestList[section].title ?? ""
        headerCell.lblCategoryDesc?.text = self.arrContestList[section].desc ?? ""
        headerCell.imgCategory?.backgroundColor = .lightGray
        headerCell.imgCategory?.sd_setImage(with: URL.init(string: (self.arrContestList[section].image ?? "")), completed: { (image, error, SDImageCacheType, url) in
            if image != nil {
                headerCell.imgCategory?.backgroundColor = .clear
            }
        })
        return headerCell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if self.arrContestList[indexPath.section].title == "Beat The Expert"{
            let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "BeatTheExpertTCell", for:indexPath) as! BeatTheExpertTCell
            ContestCell.parentVC = self;
            ContestCell.teamCount = 1;
            ContestCell.SetCellData(model: arrContestList[indexPath.section]);
            return ContestCell
        }else{
            let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "ContestTCell", for:indexPath) as! ContestTCell
            ContestCell.parentVC = self;
            ContestCell.teamCount = 1;
            ContestCell.SetCellData(model: self.arrContestList[indexPath.section].contests[indexPath.row],isDiscount:
            self.arrContestList[indexPath.section].isDiscount)
            
            return ContestCell
        }
        
//        let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "ContestTCell", for:indexPath) as! ContestTCell
//        ContestCell.parentVC = self;
//        ContestCell.SetCellData(model: self.arrContestList[indexPath.section].contests[indexPath.row])
//        return ContestCell
        
    }
    
    ///--Footer View
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContestDetailVC") as! ContestDetailVC
        vc.contestId = self.arrContestList[indexPath.section].contests[indexPath.row].id
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
}
