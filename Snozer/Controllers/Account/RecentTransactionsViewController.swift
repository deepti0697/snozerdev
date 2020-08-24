//
//  RecentTransactionsViewController.swift
//  GameChanger11
//
//  Created by GameChanger11 on 05/04/19.
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import UIKit
import SVProgressHUD

class RecentTransactionsViewController: ViewController, UIGestureRecognizerDelegate {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var lblNoData: UILabel!
	@IBOutlet weak var layoutTblY: NSLayoutConstraint!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var txtTransactionType: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var vwFilter: UIView!
    
//    var refreshControl = UIRefreshControl()
    var loadPage = 1;
    var isNoMore = false;
    var transactionType = "All";
    
    var dictType : [String : String] = ["All Transactions":"All","CUSTOMER_JOIN_CONTEST":"Joined A Contest", "CUSTOMER_RECEIVED_RCB":"Cash Bonus Received", "CUSTOMER_WALLET_RECHARGE":"Deposit Cash", "CUSTOMER_REFUND_ABCONTEST":"Refund Contest", "CUSTOMER_WIN_CONTEST":"Won A Contest"];
    
    var dictReType : [String : String] = ["All Transactions":"All","Join":"Join","Winning":"Win","Refund":"Refund", "Deposit":"Deposit","Bonus":"Bonus"];
    
    
    var arrAllTranctions : [TxnHistory] = [];
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var arrTxn = Array<[String: Any]>()
    var selectedRow = -1;
    var selectedSection = -1;
    var fromType = "TRANSACTIONS HISTORY"
    var page = 0;
    var headerView: NavHeaderView?
    var pickerTypes = UIPickerView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setHeaderView();
        
        tableview.register(UINib(nibName: String(describing: RecentTransactionTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: RecentTransactionTableViewCell.self))
        tableview.register(UINib(nibName: "RecentTransactionDate", bundle: nil), forHeaderFooterViewReuseIdentifier: RecentTransactionDate.reuseIdentifier)
        tableview.contentInset = UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 0)
        tableview.tableFooterView = UIView();
        GetHistory(type: "All")
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        tableview.allowsSelection = true
		tableview.backgroundColor = .white;
        
//        ////--Pull to Refresh---///
//        refreshControl.attributedTitle = NSAttributedString(string: "")
//        refreshControl.addTarget(self, action: #selector(RefreshData(refreshControl:)), for: .valueChanged)
//        tableview.addSubview(refreshControl)
        
        pickerTypes.delegate = self;
        pickerTypes.dataSource = self;
        txtTransactionType.inputView = pickerTypes;
        txtTransactionType.addDoneOnKeyboardWithTarget(self, action: #selector(doneForTypes))
        if self.fromType == "TRANSACTIONS HISTORY"{
            vwFilter.isHidden = false;
            layoutTblY.constant = 60;
        }else{
            vwFilter.isHidden = true;
            layoutTblY.constant = 10;
        }
    }
    
    @objc func doneForTypes() {
        txtTransactionType.resignFirstResponder();
        let index = pickerTypes.selectedRow(inComponent: 0);
        let arr = Array(dictReType.keys)
        let key = arr[index];
        txtTransactionType.text = key;
        loadPage = 1;
        transactionType = dictReType[key] ?? "All"
        self.GetHistory(type: transactionType)
//        self.filterTransactions(type: dictReType[key] ?? "All Transactions");
    }
    
    func filterTransactions() {
        self.arrTxn.removeAll()
        var arrDates = [String]()
        
        let arrTypeFilter = self.arrAllTranctions
        
        let arrTempTxn = arrTypeFilter.map { dict -> TxnHistory in
            if !arrDates.contains(Double(dict.date ?? "0")!.getDate("dd-MM-yyyy")) {
                arrDates.append(Double(dict.date ?? "0")!.getDate("dd-MM-yyyy"))
            }
            return dict
        }
        
        for strDate in arrDates {
            let arrFilter = arrTempTxn.filter{ Double($0.date ?? "0")!.getDate("dd-MM-yyyy") == strDate }
            let dict = [
                "date": strDate,
                "array": arrFilter
                ] as [String : Any]
            self.arrTxn.append(dict)
        }
        
        if self.arrTxn.count == 0 {
		self.tableview.reloadData()
//            self.popupAlert(title: nil, message: "No transaction list found.", actionTitles: ["OK"], actions: [{
//
//                }])
        }
        else {
            self.tableview.reloadData()
        }
    }
    
    
    func setHeaderView() {
           headerView = NavHeaderView.loadViewFromNib();
           headerView?.parentVC = self;
           headerView?.stckLeft.isHidden = true;
           vwHeader.addSubview(headerView!);
           headerView?.setHeaderinfo(title: fromType);
           headerView?.lblNotificationCount.isHidden = true;
           headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    // Back swipe gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    // MARK: - API Methods
    
    func GetHistory(type: String = "", page : Int = 1) {
        var api = "";
        if fromType == "TRANSACTIONS HISTORY"{
            api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetWalletHistory + "/" + "\(page)" + "/\(type)";
        } else{
            api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetWithdaralHistory + "/" + "\(page)";
        }
        
        ProfileService.GetHistory(apiName: api, params: [:]) { (flag, response, msg) in
            if flag{
		self.lblNoData.isHidden = true;
		self.tableview.isHidden = false;
                if page == 1{
                    self.isNoMore = false;
                    self.arrAllTranctions = response
			if response.count == 0{
				self.lblNoData.isHidden = false;
				self.tableview.isHidden = true;
				self.lblNoData.text = msg;
			}
                }else{
                    if response.count == 0{
                        self.isNoMore = true;
                    }else{
                        self.arrAllTranctions.append(contentsOf: response);
                    }
                }
		
                self.arrTxn.removeAll();
                if self.fromType == "TRANSACTIONS HISTORY"{
                    self.filterTransactions();
                }else{
                    self.setUpWithdrawlList()
                }
            }else{
                self.isNoMore = true;
                self.arrTxn.removeAll();
                self.tableview.reloadData();
		self.lblNoData.isHidden = false;
		self.tableview.isHidden = true;
		self.lblNoData.text = msg;
//                self.view.showToast(message: msg);
            }
        }
    }
    
    func setUpWithdrawlList() {
        self.arrTxn.removeAll()
        var arrDates = [String]()
        
        let arrTypeFilter = self.arrAllTranctions
        
        let arrTempTxn = arrTypeFilter.map { dict -> TxnHistory in
            if !arrDates.contains(Double(dict.dateW ?? "0")!.getDate("dd-MM-yyyy")) {
                arrDates.append(Double(dict.dateW ?? "0")!.getDate("dd-MM-yyyy"))
            }
            return dict
        }
        
        for strDate in arrDates {
            let arrFilter = arrTempTxn.filter{ Double($0.dateW ?? "0")!.getDate("dd-MM-yyyy") == strDate }
            let dict = [
                "date": strDate,
                "array": arrFilter
                ] as [String : Any]
            self.arrTxn.append(dict)
        }
        
        if self.arrTxn.count == 0 {
		self.tableview.reloadData()
		
//            self.popupAlert(title: nil, message: "No transaction list found.", actionTitles: ["OK"], actions: [{
//
//                }])
        }
        else {
            self.tableview.reloadData()
        }
    }
    
}



extension RecentTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arrTxn.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dict = arrTxn[section]
        let arr = dict["array"] as! [TxnHistory]
        
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: RecentTransactionTableViewCell.self), for: indexPath) as! RecentTransactionTableViewCell
        let dict = arrTxn[indexPath.section]
        let arr = dict["array"] as! [TxnHistory]
        let obj = arr[indexPath.row]
        
        if fromType == "TRANSACTIONS HISTORY"{
            cell.lblAmount.text = obj.amount;
            cell.lblAmount.text = obj.transactionType == "CREDIT" ? "+ " + rupeeSymbol + " " + obj.amount : "- " + rupeeSymbol + " " + obj.amount;
            cell.lblHeading.text = obj.titleText;
//                self.getTransationTitle(type: obj.type, subType: obj.walletType) ;
        } else {
            cell.lblAmount.text = rupeeSymbol  + " " + obj.amount;
            cell.lblHeading.text = obj.status == "C" ? "Completed" : (obj.status == "P" ? "In Review" : "Rejected");
            cell.lblHeading.textColor = obj.status == "C" ? APPCOLOR.greenCustom : (obj.status == "P" ? APPCOLOR.OrangeCustom : APPCOLOR.redCustom);
        }
        
        
        
        if indexPath.row == selectedRow && indexPath.section == selectedSection{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                cell.vwTop.roundCorners([.topLeft,.topRight], radius: 6);
                cell.vwBottom.roundCorners([.bottomLeft,.bottomRight], radius: 6);
            }
            
            cell.vwLine.isHidden = false;
            cell.vwHeading1.isHidden = false;
            cell.vwHeading2.isHidden = false;
            cell.vwTimer.isHidden = false;
            cell.imgArrow.image = UIImage(named: "arrow_Up");
            cell.lblHeading1.text = "Transaction Id: \(obj.transcationID ?? "")";
            cell.lblHeading2.text = "Description: \(obj.descriptionField ?? "")";
            if fromType == "TRANSACTIONS HISTORY"{
                cell.lblTime.text = "Transaction Date: \(Double(obj.date ?? "0")!.getDate("dd-MM-yyyy hh:mm:ss a"))";
//                if obj.type == "WALLET_RECHARGE_ADMIN" || obj.type == "WALLET_WITHDRAW_ADMIN"{
//                    cell.vwHeading2.isHidden = false;
//                }
            }else{
                cell.lblTime.text = "Transaction Date: \(Double(obj.dateW ?? "0")!.getDate("dd-MM-yyyy hh:mm:ss a"))";
                cell.lblHeading2.text = "Description: \(obj.descriptionField ?? "")";
		cell.lblHeading2.isHidden = true;
            }
            
        }else{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                cell.vwTop.roundCorners([.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 6);
            }
            cell.imgArrow.image = UIImage(named: "arrow_down");
            cell.vwLine.isHidden = true;
            cell.vwHeading1.isHidden = true;
            cell.vwHeading2.isHidden = true;
            cell.vwTimer.isHidden = true;
        }
        return cell
    }
    
    

    func getTransationTitle(type : String, subType : String) -> String{
        var str = "";
        switch type {
        case "CUSTOMER_JOIN_CONTEST":
            str = "Joined A Contest"
        case "WALLET_RECHARGE_ADMIN":
            switch subType {
            case "Winning Wallet":
                str = "Admin Recharge Winning Wallet"
            case "Deposit Wallet":
                str = "Admin Recharge Deposit Wallet"
            case "Bonus Wallet":
                str = "Admin Recharge Bonus Wallet"
            default:
                str = "Deposit Cash (Admin)";
            }
        case "WALLET_WITHDRAW_ADMIN":
            switch subType {
            case "Winning Wallet":
                str = "Admin Withdraw Winning Wallet"
            case "Deposit Wallet":
                str = "Admin Withdraw Deposit Wallet"
            case "Bonus Wallet":
                str = "Admin Withdraw Bonus Wallet"
            default:
                str = "Withdraw Cash (Admin)";
            }
        case "CUSTOMER_RECEIVED_RCB":
            str = "Cash Bonus Received"
        case "CUSTOMER_WALLET_RECHARGE":
            str = "Deposit Cash"
        case "CUSTOMER_REFUND_ABCONTEST":
            str = "Refund Contest"
        case "CUSTOMER_WIN_CONTEST":
            str = "Won A Contest"
        case "REGISTER_CASH_BONUS":
            str = "Register Cash Bonus"
        default:
            str = ""
        }
        return str
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedRow == indexPath.row && selectedSection == indexPath.section{
            selectedRow = -1;
            selectedSection = -1;
        }else{
            selectedRow = indexPath.row;
            selectedSection = indexPath.section;
        }
        
        tableView.reloadData();
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSect = arrTxn.count - 1
        let dict = arrTxn[lastSect]
        let arr = dict["array"] as! [TxnHistory]
        let lastRow = arr.count - 1
        if indexPath.section == lastSect && indexPath.row == lastRow && !isNoMore{
            loadPage = loadPage + 1
            self.GetHistory(type: transactionType, page: loadPage);
//            self.callApiForPost(page: loadPage);
        }
    }
    
    
}

class RecentTransactionDate: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lblDate: UILabel!
    
    static let reuseIdentifier = "RecentTransactionDate"
    
}


extension RecentTransactionsViewController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dictReType.keys.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let arr = Array(dictReType.keys)
        return arr[row];
    }
    
}
