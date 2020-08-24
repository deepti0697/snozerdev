//
//  SeriesCustomerMatchVC.swift
//  Snozer
//
//  Created by Admin on 07/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class SeriesCustomerMatchVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	
    var arrContests : [LeaderboardDto] = [];
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var vwSeriesName: UIView!
    
    @IBOutlet weak var vwInfo: UIView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblSeriesName: UILabel!
    @IBOutlet weak var lblPontsStmt: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblRankStmt: UILabel!
    @IBOutlet weak var lblMatchCount: UILabel!
    @IBOutlet weak var lblMatchPoints: UILabel!
    
    @IBOutlet weak var tblContest: UITableView!
    
    var leaderBoardInfo :  LeaderboardDto?
    var seriesName = "";
    var headerView : NavHeaderView?
    var seriesId = "";
    var customerId = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp();
		self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
	
		tblContest.registerTableViewCellWithNib(nibName: "SeriesContestTCell");
        self.setHeaderView();
        self.setData();
        self.callApiForSeriesContest()
    }
    
    func callApiForSeriesContest() {
        if seriesId != ""{
            let url = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetSeriesCustomerMatches;
            UserService.getSeriesCustomerMatches(url, ["customer_id" : customerId, "series_id": seriesId]) { (flag, response, msg) in
                if flag{
                    if let data = response{
                        self.arrContests = data;
                        self.tblContest.reloadData();
                        self.lblMatchCount.text = "MATCHES (\(self.arrContests.count))";
                    }
                }else{
                    self.view.showToast(message: msg);
                }
            }
        }
    }
    
    func setData() {
        if let info = leaderBoardInfo{
            imgUser.sd_setImage(with:  URL.init(string: info.userdetail?.image ?? ""),placeholderImage: UIImage.init(named: "user_icon"))
            lblName.text = (info.userdetail?.fname ?? "") + " " + (info.userdetail?.lname ?? "");
            lblPoints.text = Double(info.newpoint)!.clean;
            lblRank.text = "#" + info.newrank;
            lblTeamName.text = info.userdetail?.teamname
            lblSeriesName.text = seriesName;
        }
        
    }
    
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "USER STATS");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
    }
    
    func setUp() {
        
		self.tblContest.backgroundColor = .white;
        vwInfo.setshadow(cornerR: 6, shadowC: .black, shadowO: 0.5, shadowR: 2, shadowOffset: CGSize(width: -1, height: -1));
        self.lblName.textColor = APPCOLOR.TextBlackColor;
        self.lblTeamName.textColor = APPCOLOR.TextDarkGrayColor;
        self.lblName.font = UIFont(name: font_medium, size: 16);
        self.lblTeamName.font = UIFont(name: font_reguler, size: 16);
        
        self.lblSeriesName.textColor = APPCOLOR.TextGrayColor;
        self.lblSeriesName.font = UIFont(name: font_reguler, size: 10);
        
        self.lblPontsStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblPontsStmt.font = UIFont(name: font_reguler, size: 12);
        
        self.lblRankStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblRankStmt.font = UIFont(name: font_reguler, size: 12);
        
        self.lblPoints.textColor = APPCOLOR.TextBlackColor;
        self.lblPoints.font = UIFont(name: font_bold, size: 12);
        
        self.lblRank.textColor = APPCOLOR.TextBlackColor;
        self.lblRank.font = UIFont(name: font_bold, size: 12);
        
        self.lblMatchCount.textColor = APPCOLOR.TextBlackColor;
        self.lblMatchCount.font = UIFont(name: font_bold, size: 13)
        
        self.lblMatchPoints.textColor = APPCOLOR.TextBlackColor;
        self.lblMatchPoints.font = UIFont(name: font_bold, size: 13)
        
    }
    
    
}

extension SeriesCustomerMatchVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContests.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeriesContestTCell") as! SeriesContestTCell
        cell.lblContestName.text = arrContests[indexPath.row].matchDetail?.shortTitle;
        cell.lblPoints.text = Double(arrContests[indexPath.row].newpoint)!.clean;
        if let date = Double(arrContests[indexPath.row].matchDetail!.matchDate){
            cell.lblDate.text = date.getDate("dd-MM-yyyy")
        }
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor(red: 232.0/255, green: 232.0/255, blue: 232.0/255, alpha: 1) : APPCOLOR.TextWhiteColor;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamPreviewController") as! TeamPreviewController
        vc.selectedTeamID = arrContests[indexPath.row].customerTeamID
//        vc.sportsType = arrPost[indexPath.row].sport?.sportId ?? "0";
        vc.parentVC = self;
        vc.isShowPoints = true;
        vc.sportsType = appdelegate.matchType;
        vc.matchUrl = appdelegate.matchTypeUrl;
        vc.modalPresentationStyle = .overCurrentContext;
        self.present(vc, animated: true, completion: nil);
    }
    
}
