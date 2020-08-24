//
//  MyTeamVC.swift
//  Snozer
//
//  Created by BHUVAN SHARMA on 13/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class MyTeamVC: ViewController {
    
	@IBOutlet weak var imgClock: UIImageView!
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwTimer: UIView!
    @IBOutlet weak var tblTeam: UITableView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var lblTeams: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    var timer = Timer()
    var diff_seconds = Double()
    var myTeamCount = Int()
    var headerView : NavHeaderView?
    var arrTeams: [Jointeam] = [];
    
    @IBOutlet weak var layoutTblBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
		self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
        self.diff_seconds = 0
        tblTeam.registerTableViewCellWithNib(nibName: "TeamTCell")
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
            self.lblTimer.text = time_diff
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.timer.invalidate()
//        self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
//        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)

        self.callTeamApi();
    }
    
   func setUp() {
       
        lblTeams.text = "\(appdelegate.SingleMatchInfo.team1.sortName!) vs \(appdelegate.SingleMatchInfo.team2.sortName ?? "")"
       lblTeams.textColor = APPCOLOR.TextBlackColor;
       lblTimer.textColor = APPCOLOR.redCustom;

       lblTeams.font = UIFont(name: font_reguler, size: 14);
       lblTimer.font = UIFont(name: font_reguler, size: 12);
       vwTimer.setshadow(cornerR: 18, shadowC: .black, shadowO: 0.4, shadowR: 1, shadowOffset: CGSize(width: 1, height: 1));
        vwTimer.backgroundColor = APPCOLOR.YellowCustom;
        btnCreate.backgroundColor = APPCOLOR.TextWhiteColor;
        btnCreate.setTitleColor(APPCOLOR.TextBlackColor, for: .normal);
	self.tblTeam.backgroundColor = .white;
        self.vwBottom.backgroundColor = APPCOLOR.redCustom;
	let templateImage1 = imgClock.image?.withRenderingMode(.alwaysTemplate)
	imgClock.image = templateImage1
	imgClock.tintColor = APPCOLOR.redCustom
   }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "MY TEAMS");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    func callTeamApi() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.MyTeams + "/" + appdelegate.SingleMatchInfo.matchId
        HomeService.GetTeamList(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                self.arrTeams = response;
                self.tblTeam.reloadData();
                if self.arrTeams.count == Int(appdelegate.SingleMatchInfo.matchLimit){
                    self.layoutTblBottom.constant = 0;
                    self.vwBottom.isHidden = true;
                }else{
                    self.btnCreate.setTitle("Create Team \(self.arrTeams.count + 1)", for: .normal);
                }
            }
        }
    }

    @IBAction func actionForCreateTeam(_ sender: Any) {
        
        if appdelegate.matchType == kCricket{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
            self.navigationController!.pushViewController(vc, animated: true)
        }else if appdelegate.matchType == kFootball{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateFootballTeamVC") as! CreateFootballTeamVC
            self.navigationController!.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateKabaddiTeamVC") as! CreateKabaddiTeamVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
        
    }
}

extension MyTeamVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTeams.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamTCell") as! TeamTCell
        cell.parentVC = self;
        cell.vwCone.isHidden = self.arrTeams.count == Int(appdelegate.SingleMatchInfo.matchLimit);
        cell.setCellInfo(info: arrTeams[indexPath.row]);
        return cell;
    }
}
