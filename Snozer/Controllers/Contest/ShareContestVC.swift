//
//  ShareContestVC.swift
//  Snozer
//
//  Created by Admin on 01/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class ShareContestVC: ViewController {
    
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    var headerView : NavHeaderView?
    
    @IBOutlet weak var imgHeader: UIImageView!
    
    @IBOutlet weak var bgContainer: UIView!
    @IBOutlet weak var lblMatchTitle: UILabel!
    @IBOutlet weak var vwVs: UIView!
    
    @IBOutlet weak var imgTeam1: UIImageView!
    
    @IBOutlet weak var imgTeam2: UIImageView!
    
    @IBOutlet weak var lblTeamName1: UILabel!
    
    @IBOutlet weak var lblMatchType: UILabel!
    @IBOutlet weak var lblTeamName2: UILabel!
    
    @IBOutlet weak var imgClock: UIImageView!
    
    @IBOutlet weak var lblTimer: UILabel!
    
    
    @IBOutlet weak var lblShareInviteStmt: UILabel!
    
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var vwContestCode: UIView!
    @IBOutlet weak var lblCode: UILabel!
    var slug: String = "";
    var shareMsg: String = "";
    var contestid = "";
    var timer = Timer()
    var diff_seconds = Double()
    var matchDetail: HomeMatchList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
        self.setData();
        if contestid == ""{
            self.callApishareDetail()
        }else{
            self.getContestDetails()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.timer.invalidate()
        self.timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
    }
    
    
    func getContestDetails() {
        let urls = String(format: "%@%@%@/%@/%@", APPURL.BaseURL,appdelegate.matchTypeUrl, APPURL.GetContestDetail,contestid,appdelegate.SingleMatchInfo.matchId)
        HomeService.GetContestDetail(_apiName: urls, params: [:]) { (flag, response, msg) in
            if flag{
                if let info = response.first{
                    if let cData = info.contests.first{
                        self.slug = cData.slug;
                        self.callApishareDetail();
                    }
                }
            }else{
                self.view.showToast(message: msg);
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    @objc func updateTimer() {
        diff_seconds += 1
        let (time_diff, progress) =    UIApplication.matchTime(matchDetail!, diffrence: diff_seconds)
        if progress == false {
            self.timer.invalidate()
            self.lblTimer.text = time_diff
            self.popupAlert(title: "The deadline has passed!", message: "Check out the contests you've joined for this match", actionTitles: ["OK"], actions: [
                {
                    self.presentedViewController?.dismiss(animated: true, completion: nil)                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let TabVC: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    TabVC.selectedIndex = 0
                    UIApplication.shared.windows.first?.rootViewController = TabVC
                }
            ])
        }
        else
        {
            self.lblTimer.text = time_diff
        }
    }
    
    
    func callApishareDetail() {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.ContestShareDetail  + "/" + slug;
        HomeService.ContestShareInfo(_apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                if let code = response["data"] as? String{
                    self.lblCode.text = code;
                }
                if let image = response["image"] as? String{
                    
                    self.imgHeader.sd_setImage(with:  URL.init(string: image),placeholderImage: UIImage.init(named: "user_icon"))
                }
                
                if let msg = response["message"] as? String{
                    self.shareMsg = msg;
					self.shareMsg = self.shareMsg.replacingOccurrences(of: "&", with: "and");
                }
                
            }else{
                self.view.showToast(message: msg);
            }
        }
        
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        
        if contestid != ""{
            headerView?.isCustomBack = true;
        }
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "INVITE YOUR FRIENDS");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        headerView?.backAction = {
			if let arr = self.navigationController?.viewControllers.filter({$0.isKind(of: ContestVC.self) }), arr.count > 0{
				NotificationCenter.default.post(name: Common.NotificationNames.privateContestFresh, object: nil);
				self.navigationController!.popToViewController(arr.first!, animated: true)
			}else{
				self.navigationController?.popViewController(animated: false);
			}
        }
    }
    
    func setUp() {
        self.vwVs.cornerRadius = 11;
        self.vwVs.backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1);
        self.vwVs.borderColor = APPCOLOR.TextWhiteColor;
        self.vwVs.borderWidth = 2;
        
        self.vwVs.setshadow(cornerR: 11, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        self.bgContainer.setshadow(cornerR: 8, shadowC: .black, shadowO: 0.5, shadowR: 4, shadowOffset: CGSize(width: -1, height: 1));
        
        self.lblTeamName1.font = UIFont(name: font_bold, size: 10);
        self.lblTeamName2.font = UIFont(name: font_bold, size: 10);
        self.lblMatchType.font = UIFont(name: font_bold, size: 14);
        self.lblTimer.font = UIFont(name: font_reguler, size: 11);
        
        self.imgClock.tintColor = APPCOLOR.greenCustom;
        self.lblMatchTitle.font = UIFont(name: font_reguler, size: 10);
        self.lblMatchTitle.textColor = APPCOLOR.TextBlackColor;
        self.lblShareInviteStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblCode.textColor = APPCOLOR.TextBlackColor;
        self.btnCode.setTitleColor(APPCOLOR.BlueCustom, for: .normal);
        
        self.lblShareInviteStmt.font = UIFont(name: font_reguler, size: 14);
        self.lblCode.font = UIFont(name: font_medium, size: 16);
        self.btnCode.titleLabel?.font = UIFont(name: font_reguler, size: 16);
        self.setDottedBorder();
        
    }
    
    func setDottedBorder() {
        
		delay(0.3) {
			let yourViewBorder = CAShapeLayer()
			yourViewBorder.strokeColor = UIColor.black.cgColor
			yourViewBorder.lineDashPattern = [2, 2]
			yourViewBorder.frame = self.vwContestCode.bounds
			yourViewBorder.fillColor = nil
			yourViewBorder.path = UIBezierPath(rect: self.vwContestCode.bounds).cgPath
			self.vwContestCode.layer.addSublayer(yourViewBorder)
		}
        
    }
    
    func setData() {
        if let data = appdelegate.SingleMatchInfo{
            self.imgTeam1?.sd_setImage(with:  URL.init(string: data.team1.image),placeholderImage: UIImage.init(named: "dummyTeam"))
            self.imgTeam2?.sd_setImage(with:  URL.init(string: data.team2.image),placeholderImage: UIImage.init(named: "dummyTeam"))
            self.lblTeamName1.text =  String("\(data.team1.sortName ?? "")").uppercased()
            self.lblTeamName2.text =  String("\(data.team2.sortName ?? "")").uppercased()
            self.lblMatchType.text =  String("\(data.gametype.name ?? "")")
            self.lblMatchTitle.text = data.series.name;
        }
    }
    
    @IBAction func actionForCopy(_ sender: Any) {
        UIPasteboard.general.string = slug;
        self.view.showToast(message: "copied successfully");
    }
    
    @IBAction func actionForWhatsapp(_ sender: Any) {
        let urlWhats = "whatsapp://send?text=\(shareMsg)"
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: characterSet) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL)
                } else {
                    // Cannot open whatsapp
                    self.view.showToast(message: "Please install whatsapp App.")
                }
            }
        }else{
            self.view.showToast(message: "something went wrong, please try again.")
        }
    }
    
    @IBAction func actionForMoreOption(_ sender: Any) {
        let items = [shareMsg]
//        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
//        present(ac, animated: true)
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.excludedActivityTypes = []
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = self.view
            if #available(iOS 12.0, *) {
                activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).frame
            } else {
                // Fallback on earlier versions
            }
        }
        present(activityVC, animated: true, completion: nil)
        
    }
    
}
