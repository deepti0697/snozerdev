//
//  WinningBreakUpOptionVC.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit

protocol WinningOptionDelegate {
    func selectedOption(info: WinningBreakups)
}

class WinningBreakUpOptionVC: ViewController {
    
    @IBOutlet weak var vwHeader: UIView!
    var headerView: NavHeaderView?;
    @IBOutlet weak var lblTitleStmt: UILabel!
    @IBOutlet weak var tblWinnerOptions: UITableView!
    var arrContestInfo : [WinningBreakups] = []
    var delegate : WinningOptionDelegate?
    var winningOptionId = "";
    var privateContestTitle = "";
    
    @IBOutlet weak var vwUpper: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setHeaderView();
        tblWinnerOptions.registerTableViewCellWithNib(nibName: "WinningBreakupOptionTCell");
        tblWinnerOptions.delegate = self;
        tblWinnerOptions.dataSource = self;
        tblWinnerOptions.reloadData();
		
		tblWinnerOptions.backgroundColor = .white;
        
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: privateContestTitle);
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
}


extension WinningBreakUpOptionVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContestInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WinningBreakupOptionTCell") as! WinningBreakupOptionTCell
        cell.btnRadio.setImage(UIImage(named: winningOptionId == arrContestInfo[indexPath.row].id ? "radio_icon_active" : "radio_icon" ), for: .normal);
        cell.setCellInfo(info: arrContestInfo[indexPath.row]);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60 + (Int(arrContestInfo[indexPath.row].contestJson!.perMinP.count)) * 40)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedOption(info:arrContestInfo[indexPath.row]);
        self.navigationController?.popViewController(animated: true);
    }
    
    
}
