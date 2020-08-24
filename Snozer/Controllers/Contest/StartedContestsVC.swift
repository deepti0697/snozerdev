//
//  StartedContestsVC.swift
//  Snozer
//
//  Created by Admin on 23/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import ObjectMapper

class StartedContestsVC: ViewController {
    
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwNoContest: UIView!
	@IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnTop: UIButton!
    @IBOutlet weak var vwTimer: UIView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tblJoinedContest: UITableView!
    var comeFrom = "HomeVC";
    var arrContestList : [ContestCateModel] = [];
    var headerView: NavHeaderView?
    var refreshControl = UIRefreshControl()
    var matchInfo : MatchScoreDto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 72
        self.setUp();
        self.setHeaderView();
        if comeFrom == "HomeVC"{
            self.callApiForMatchScore();
        } else {
            self.callApiForCustomerContest();
        }
        ////--Pull to Refresh---///
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(RefreshData(refreshControl:)), for: .valueChanged)
        tblJoinedContest.addSubview(refreshControl) // not required when using
        tblJoinedContest.tableFooterView = UIView();
        ////--Register Nib for UITableViewCell
        tblJoinedContest.register(UINib(nibName: "ContestJoinedTCell", bundle: nil), forCellReuseIdentifier: "ContestJoinedTCell")
        tblJoinedContest.register(UINib(nibName: "BeatTheExpertTCell", bundle: nil), forCellReuseIdentifier: "BeatTheExpertTCell")
        tblJoinedContest.register(UINib(nibName: "MatchScoreTCell", bundle: nil), forCellReuseIdentifier: "MatchScoreTCell")
        tblJoinedContest.register(UINib(nibName: "CategoryHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "CategoryHeaderCell")
    }
    
    @objc func RefreshData(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .background).async {
            self.callApiForCustomerContest()
        }
    }
    
    func  setUp() {
        
		
		self.tblJoinedContest.backgroundColor = .white;
        lblTitle.text = "\(appdelegate.SingleMatchInfo.team1.sortName!) vs \(appdelegate.SingleMatchInfo.team2.sortName ?? "")"
        lblTimer.text = appdelegate.SingleMatchInfo.matchProgress == "L" ? "In Progress" : (appdelegate.SingleMatchInfo.matchProgress == "IR" ? "In Review" : "Completed")
        lblTimer.textColor = appdelegate.SingleMatchInfo.matchProgress == "L" ? APPCOLOR.redCustom : (appdelegate.SingleMatchInfo.matchProgress == "IR" ?  APPCOLOR.redCustom :  APPCOLOR.greenCustom)
        self.btnTop.isHidden = true;
        
        if appdelegate.SingleMatchInfo.matchProgress == "R" {
            self.btnTop.isHidden = false;
        }
        
        lblTitle.textColor = APPCOLOR.TextBlackColor;
        
        
        lblTitle.font = UIFont(name: font_reguler, size: 14);
        lblTimer.font = UIFont(name: font_reguler, size: 14);
        vwTimer.setshadow(cornerR: 18, shadowC: .black, shadowO: 0.4, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
        vwTimer.backgroundColor = APPCOLOR.YellowCustom;
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
    
    func callApiForMatchScore() {
        let api = String(format: "%@%@%@/%@", APPURL.BaseURL,appdelegate.matchTypeUrl,APPURL.GetMatchScore,appdelegate.SingleMatchInfo.matchId);
        HomeService.GetMatchScore(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                if let info = response{
                    self.matchInfo = info;
                    let cat = ContestCateModel(title: "Match Score", des: info.notes)
                    self.arrContestList.insert(cat, at: 0);
                }
                self.tblJoinedContest.reloadData();
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    func callApiForCustomerContest() {
        
        let api = String(format: "%@%@%@/%@/%@", APPURL.BaseURL,appdelegate.matchTypeUrl,APPURL.GetCustomerContest,appdelegate.SingleMatchInfo.id,appdelegate.SingleMatchInfo.matchId);
        
        HomeService.GetCustomerMatchContest(_apiName: api, params: [:]) { (flag, response, msg) in
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
                            let beatTheExpert = arr.first;
                            self.arrContestList.insert(beatTheExpert!, at: 0);
                        }
                    }
		
			if self.arrContestList.count == 0{
				self.vwNoContest.isHidden = false;
			} else{
				self.vwNoContest.isHidden = true;
			}
                    self.tblJoinedContest.delegate = self;
                    self.tblJoinedContest.dataSource = self;
                 }
                
            }else{
                self.view.showToast(message: msg);
            }
	if self.arrContestList.count == 0{
		self.vwNoContest.isHidden = false;
	} else{
		self.vwNoContest.isHidden = true;
	}
            Common.sharedInstance.hideHud();
            self.refreshControl.endRefreshing();
            self.callApiForMatchScore()
        }
    }
    
    
    @IBAction func actionForTopTeam(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamPreviewController") as! TeamPreviewController
        vc.sportsType = appdelegate.matchType;
        vc.isTopTeam = true;
        vc.isShowPoints = true;
        vc.parentVC = self;
        vc.matchUrl = appdelegate.matchTypeUrl;
        vc.modalPresentationStyle = .overCurrentContext;
        self.present(vc, animated: true, completion: nil);
    }
    
}

extension StartedContestsVC: UITableViewDataSource, UITableViewDelegate{
    
    // MARK: - TableView Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrContestList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1;
        }
        return self.arrContestList[section].contests.count
        
        
    }
    
    //--Header View
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.arrContestList[section].title == "Beat The Expert" || self.arrContestList[section].title == "Match Score" {
            return 0;
        }
        return 60;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 140;
        
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
        headerCell.imgDiscount.sd_setImage(with:  URL.init(string: self.arrContestList[section].discountImage),placeholderImage: UIImage.init(named: "user_icon"))
        if self.arrContestList[section].isDiscount != "N"{
            headerCell.imgDiscount.isHidden  = false;
        }else{
            headerCell.imgDiscount.isHidden  = true;
        }
        
        return headerCell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.arrContestList[indexPath.section].title == "Beat The Expert"{
            let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "BeatTheExpertTCell", for:indexPath) as! BeatTheExpertTCell
            ContestCell.SetCellData(model: arrContestList[indexPath.section]);
            ContestCell.vwJoin.isHidden = true
            ContestCell.lblBadge.isHidden = true
            return ContestCell
        } else if self.arrContestList[indexPath.section].title == "Match Score"{
            let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "MatchScoreTCell", for:indexPath) as! MatchScoreTCell
            ContestCell.setInfo(model: matchInfo!);
            return ContestCell;
        } else{
            let ContestCell =  tableView.dequeueReusableCell(withIdentifier: "ContestJoinedTCell", for:indexPath) as! ContestJoinedTCell
            ContestCell.parentVC = self;
            ContestCell.setCellinfo(model: self.arrContestList[indexPath.section].contests[indexPath.row],isDiscount: self.arrContestList[indexPath.section].isDiscount)
            
            return ContestCell
        }
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
        if self.arrContestList[indexPath.section].title == "Match Score"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerStatsVC") as! PlayerStatsVC
            vc.isMatchComplete = appdelegate.SingleMatchInfo.matchProgress == "R"
            self.navigationController!.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContestDetailVC") as! ContestDetailVC
            vc.contestId = self.arrContestList[indexPath.section].contests[indexPath.row].id
            vc.isScoreAvialble = true;
            vc.matchInfo = self.matchInfo;
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
    }
}
