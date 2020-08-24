//
//  LeaderBoardVC.swift
//  Snozer
//
//  Created by Admin on 05/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import ObjectMapper

class LeaderBoardVC: ViewController {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	
    var headerView : NavHeaderView?
    var arrSeries : [CommonDto] = [];
    var arrLeaderBoard : [LeaderboardDto] = [];
    var userLeaderboard : LeaderboardDto?
    @IBOutlet weak var tblLeaderBoard: UITableView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var txtSeries: UITextField!
    @IBOutlet weak var lblAllTeam: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    
    @IBOutlet weak var lblPoints: UILabel!
    
    var seriesPicker = UIPickerView();
    var seriesObj : CommonDto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setUp();
        self.setHeaderView();
        seriesPicker.delegate = self;
        seriesPicker.dataSource = self;
        txtSeries.inputView = seriesPicker;
        self.tblLeaderBoard.registerTableViewCellWithNib(nibName: "LeaderBoardTCell");
        self.tblLeaderBoard.tableFooterView = UIView();
        self.tblLeaderBoard.estimatedRowHeight = 62;
        self.tblLeaderBoard.rowHeight = UITableView.automaticDimension
        self.txtSeries.addDoneOnKeyboardWithTarget(self, action: #selector(doneForSeries))
        self.callApiForSeries();
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "SERIES LEADERBOARD");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    @objc func doneForSeries(){
        txtSeries.resignFirstResponder();
        let index = seriesPicker.selectedRow(inComponent: 0);
        seriesObj = arrSeries[index];
        self.callApiForSeriesLeaderboard();
        
    }
    
    func setUp() {
		
		self.tblLeaderBoard.backgroundColor = .white;
		
        self.lblAllTeam.font = UIFont(name: font_reguler, size: 12);
        self.lblPoints.font = UIFont(name: font_reguler, size: 12);
        self.lblRank.font = UIFont(name: font_reguler, size: 12);
        
        self.lblPoints.textColor = APPCOLOR.TextBlackColor;
        self.lblAllTeam.textColor = APPCOLOR.TextBlackColor;
        self.lblRank.textColor = APPCOLOR.TextBlackColor;
    }
    
    func callApiForSeries() {
        let url = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetSeries;
        UserService.getSeries(url, params: [:]) { (flag, response, msg) in
            if flag{
                self.arrSeries = response
                self.seriesPicker.reloadAllComponents();
                self.seriesObj = self.arrSeries.first;
                self.callApiForSeriesLeaderboard()
            }
        }
    }
    
    
    func callApiForSeriesLeaderboard() {
        if seriesObj != nil{
            txtSeries.text = seriesObj?.name;
            let url = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetSeriesLeaderboard;
            UserService.getSeriesLeaderboard(url, ["page_no" : "1", "series_id": seriesObj!.id]) { (flag, response, msg) in
                if flag{
                    self.arrLeaderBoard.removeAll();
                    if let data = response["data"] as? [[String:Any]]{
                        self.arrLeaderBoard = Mapper<LeaderboardDto>().mapArray(JSONArray: data)
                    }
                    
                    if let data = response["data_self"] as? [String : Any]{
                        self.userLeaderboard = Mapper<LeaderboardDto>().map(JSON: data)
                    }else{
                        if let user = appdelegate.objAccountInfo{
                            self.userLeaderboard = LeaderboardDto(id: user.id, points: "0", rank: "0", name: user.firstname + " " + user.lastname,image: user.image);
                        }else{
                            self.userLeaderboard = LeaderboardDto(id: "-1", points: "0", rank: "0", name: "self",image: "")
                        }
                        
                        
                    }
                    self.arrLeaderBoard.insert(self.userLeaderboard!, at: 0);
                    self.lblAllTeam.text = "ALL TEAMS(\(self.arrLeaderBoard.count))"
                    self.tblLeaderBoard.reloadData();
                    
                }else{
                    self.view.showToast(message: msg);
                }
            }
        }
        
    }

}

extension LeaderBoardVC: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.seriesPicker.reloadAllComponents();
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrSeries.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrSeries[row].name;
    }

}

extension LeaderBoardVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLeaderBoard.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderBoardTCell") as! LeaderBoardTCell
        cell.lblPoints.text = Double(arrLeaderBoard[indexPath.row].newpoint)!.clean;
        cell.lblRank.text = "#" + arrLeaderBoard[indexPath.row].newrank;
        cell.lbName.text = ((arrLeaderBoard[indexPath.row].userdetail?.fname ?? "") + " " + (arrLeaderBoard[indexPath.row].userdetail?.lname ?? "")).uppercased() ;
        cell.vwLine.isHidden = false;
        cell.vwContainer.backgroundColor = APPCOLOR.TextWhiteColor;
        cell.parentVC = self;
        cell.customerId = arrLeaderBoard[indexPath.row].userdetail?.id ?? "0"
        cell.imgUser.sd_setImage(with:  URL.init(string: arrLeaderBoard[indexPath.row].userdetail?.image ?? ""),placeholderImage: UIImage.init(named: "user_icon"))
        if indexPath.row == 0{
            cell.vwLine.isHidden = true;
            cell.vwContainer.backgroundColor = APPCOLOR.redCustom.withAlphaComponent(0.2);
        }
        cell.imgTrophy.isHidden = true;
        if arrLeaderBoard[indexPath.row].newrank == "1"{
            cell.imgTrophy.isHidden = false;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrLeaderBoard[indexPath.row].id != appdelegate.objAccountInfo?.id{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeriesCustomerMatchVC") as! SeriesCustomerMatchVC
            vc.customerId = self.arrLeaderBoard[indexPath.row].userdetail?.id ?? "0";
            vc.seriesName = txtSeries.text!;
            vc.leaderBoardInfo = arrLeaderBoard[indexPath.row];
            vc.seriesId = seriesObj?.id ?? "0";
            self.navigationController?.pushViewController(vc, animated: true);
        }
        
    }
    
    
}
