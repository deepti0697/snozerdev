//
//  NotificationVC.swift
//  Snozer
//
//  Created by Admin on 26/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

class NotificationVC: ViewController, UIGestureRecognizerDelegate {
    
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tblNotification: UITableView!
    var headerView: NavHeaderView?
    var refreshControl = UIRefreshControl()
    var loadPage = 1;
    var isNoMore = false;
    var arrNotifications : [NotificationDto] = [];
    var arrTxn = Array<[String: Any]>()
    var page = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setHeaderView();
        
        tblNotification.register(UINib(nibName: String(describing: NotificationTCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: NotificationTCell.self))
        tblNotification.register(UINib(nibName: "RecentTransactionDate", bundle: nil), forHeaderFooterViewReuseIdentifier: RecentTransactionDate.reuseIdentifier)
        tblNotification.contentInset = UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 0)
        tblNotification.tableFooterView = UIView();
        ////--Pull to Refresh---///
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(RefreshData(refreshControl:)), for: .valueChanged)
        tblNotification.addSubview(refreshControl)
		tblNotification.backgroundColor = .white
        GetHistory(page: loadPage)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    @objc func RefreshData(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .background).async {
            self.loadPage = 1;
            self.GetHistory(page: self.loadPage);
        }
    }
    
    func filterTransactions() {
        self.arrTxn.removeAll()
        var arrDates = [String]()
        let arrTempTxn = arrNotifications.map { dict -> NotificationDto in
            if !arrDates.contains(Double(dict.date )!.getDate("dd-MM-yyyy")) {
                arrDates.append(Double(dict.date )!.getDate("dd-MM-yyyy"))
            }
            return dict
        }
        
        for strDate in arrDates {
            let arrFilter = arrTempTxn.filter{ Double($0.date )!.getDate("dd-MM-yyyy") == strDate }
            let dict = [
                "date": strDate,
                "array": arrFilter
                ] as [String : Any]
            self.arrTxn.append(dict)
        }
        
        if self.arrTxn.count == 0 {
            self.popupAlert(title: nil, message: "No Notification list found.", actionTitles: ["OK"], actions: [{
                
                }])
        }
        else {
            self.tblNotification.delegate = self;
            self.tblNotification.dataSource = self;
            self.tblNotification.reloadData()
        }
    }
    
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "NOTIFICATIONS");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    // Back swipe gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    // MARK: - API Methods
    
    func GetHistory(page : Int) {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetNotification + "/" + "\(page)";
        ProfileService.GetNotification(apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
                if page == 1{
                    self.isNoMore = false;
                    self.arrNotifications = response;
                }else{
                    if response.count == 0{
                        self.isNoMore = true;
                    }else{
                        self.arrNotifications.append(contentsOf: response);
                    }
                }
                self.filterTransactions();
            }else{
                self.isNoMore = true;
                self.view.showToast(message: msg);
            }
            self.refreshControl.endRefreshing();
        }
    }
    
}



extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arrTxn.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dict = arrTxn[section]
        let arr = dict["array"] as! [TxnHistory]
        
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationTCell.self), for: indexPath) as! NotificationTCell
        let dict = arrTxn[indexPath.section]
        let arr = dict["array"] as! [NotificationDto]
        let obj = arr[indexPath.row]
        cell.lblTitle.isHidden = true;
        cell.imgNotificaiton.isHidden = true;
        if obj.senderType == "ADMIN"{                
            if obj.imageLarge != ""{
                cell.imgNotificaiton.isHidden = false;
                cell.imgNotificaiton.sd_setImage(with:  URL.init(string: obj.imageLarge),placeholderImage: UIImage.init(named: "user_icon"))
            }
            cell.lblTitle.text = obj.title;
            cell.lblTitle.isHidden = false;
        }
        cell.lblMsg.text = obj.notification;
        cell.lblDate.text = Double(obj.date)?.getDate("hh:mm a");
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { // Header view for tableview.
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: RecentTransactionDate.self)) as! RecentTransactionDate
        let dict = arrTxn[section]
        let strDate = dict["date"] as! String
        headerView.lblDate.text = strDate
        headerView.lblDate.font = UIFont(name: font_medium, size: 14);
        headerView.lblDate.textColor = APPCOLOR.TextBlackColor;
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { // Height for header view.
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSect = arrTxn.count - 1
        let dict = arrTxn[lastSect]
        let arr = dict["array"] as! [TxnHistory]
        let lastRow = arr.count - 1
        if indexPath.section == lastSect && indexPath.row == lastRow && !isNoMore{
            loadPage = loadPage + 1
            self.GetHistory(page: loadPage);
        }
    }
    
}



