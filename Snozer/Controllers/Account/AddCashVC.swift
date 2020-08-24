//
//  AddCashVC.swift
//  Snozer
//
//  Created by Admin on 26/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
import SVProgressHUD

class AddCashVC: ViewController,  WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate {
	
	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	
    var mywebView = WKWebView()
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblTopStmt: UILabel!
    @IBOutlet weak var txtAmount: SkyFloatingLabelTextField!
    @IBOutlet weak var btn500: UIButton!
    @IBOutlet weak var btn1000: UIButton!
    @IBOutlet weak var btn100: UIButton!
    @IBOutlet weak var btnPromoApply: UIButton!
    
    @IBOutlet weak var txtPromo: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblPaymentOptionStmt: UILabel!
    
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var imgPayment2: UIImageView!
    @IBOutlet weak var imgPayment1: UIImageView!
    var isPaytm = true;
    var needCash = "";
    
    var headerView: NavHeaderView?
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        imgPayment1.image = UIImage(named: "radio_icon_active");
        self.setUp();
        self.setHeaderView();
        mywebView.uiDelegate = self
    }
    
    func setUp() {
        lblTopStmt.textColor = APPCOLOR.TextBlackColor;
        lblTopStmt.font = UIFont(name: font_reguler, size: 15);
        btn100.titleLabel?.font = UIFont(name: font_medium, size: 14);
        btn500.titleLabel?.font = UIFont(name: font_medium, size: 14);
        btn1000.titleLabel?.font = UIFont(name: font_medium, size: 14);
        btnPromoApply.titleLabel?.font = UIFont(name: font_medium, size: 12);
        btnProceed.titleLabel?.font = UIFont(name: font_medium, size: 14);
        self.lblPaymentOptionStmt.textColor = APPCOLOR.TextBlackColor;
        self.lblPaymentOptionStmt.font = UIFont(name: font_reguler, size: 15);
        if needCash != ""{
            self.txtAmount.text = rupeeSymbol + " " + needCash;
        }else{
            self.txtAmount.text = rupeeSymbol + " " + "100";
        }
        self.btn100.setTitle(rupeeSymbol + " 100", for: .normal)
        self.btn500.setTitle(rupeeSymbol + " 500", for: .normal)
        self.btn1000.setTitle(rupeeSymbol + " 1000", for: .normal)
        
        for txt in [txtPromo, txtAmount] {
            txt?.placeholderColor = APPCOLOR.TextLightGrayColor;
            txt?.textColor = APPCOLOR.TextBlackColor;
            txt?.lineColor = APPCOLOR.TextLightGrayColor;
            txt?.selectedTitleColor = APPCOLOR.redCustom;
            txt?.selectedLineColor = APPCOLOR.TextBlackColor;
            txt?.tintColor = APPCOLOR.TextBlackColor;
            txt?.textColor = APPCOLOR.TextBlackColor;
            txt?.font = UIFont(name: font_reguler, size: 11);
//            txt?.placeholderColor = UIColor(red: 185.0/255, green: 185.0/255, blue: 185.0/255, alpha: 1)
            txt?.placeholderFont = UIFont.init(name: font_reguler, size: 12)
        }
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = false
        headerView?.vwNotification.isHidden = true
        headerView?.lblNotificationCount.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: "ADD CASH");
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
    }
    
    
    @IBAction func actionForPromoApply(_ sender: Any) {
        if txtPromo.text!.trim().count == 0{
            self.view.showToast(message: "Please enter promo code.")
        }else{
            let arr = txtAmount.text?.components(separatedBy: "₹")
            if (arr?.count)! > 1 {
                let strAmount = arr![1]
                if !strAmount.isEmpty {
                    let amount = Double(strAmount) ?? .nan
                    if amount >= (Double("10") ?? .nan) {
//                        self.PayNow(totalAmount: strAmount);
                        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.ApplyPromoCode;
                        UserService.ApplyPromoCode(api, ["amount":strAmount,"promocode":txtPromo.text!]) { (flag, msg) in
                            if flag{
                                
                            }
                        }
                    }else{
                        self.view.showToast(message: "Minimum add amount should be Rs. 10")
                    }
                }
            }
        }
    }
    
    
    @IBAction func actionForAddAmount(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            txtAmount.text = rupeeSymbol + "100"
        case 102:
            txtAmount.text = rupeeSymbol + "500"
        case 103:
            txtAmount.text = rupeeSymbol + "1000"
        default:
            print("ok")
        }
        
    }
    
    @IBAction func actionForChoosePayment(_ sender: UIButton) {
        imgPayment1.image = UIImage(named: "radio_icon");
        imgPayment2.image = UIImage(named: "radio_icon");
        switch sender.tag {
        case 201:
            imgPayment1.image = UIImage(named: "radio_icon_active");
            isPaytm = true
        case 202:
            imgPayment2.image = UIImage(named: "radio_icon_active");
            isPaytm = false
        default:
            print("ok")
        }
    }
    
    @IBAction func actionForProceed(_ sender: Any) {
        let arr = txtAmount.text?.components(separatedBy: "₹")
        if (arr?.count)! > 1 {
            let strAmount = arr![1].trim()
            if !strAmount.isEmpty {
                let amount = Double(strAmount) ?? .nan
                if amount >= (Double("10") ?? .nan) {
                    self.PayNow(totalAmount: strAmount);
                    return
                }
            }
        }
        self.view.showToast(message: "Minimum add amount should be  Rs. 10")
    }
    
    func PayNow(totalAmount : String){
        
        let api = "\(APPURL.BaseURL + APPURL.CricketUrl + APPURL.AdduserBalance)"
        AF.request(api, method: .post, parameters: ["amount":totalAmount, "paymentmethod" : isPaytm ? "PAYTM" : "RAZORPAY", "promocode" : txtPromo.text!], encoding: URLEncoding.default, headers: HTTPHeaders(MainService.setHeader())).response(completionHandler: { (response) in
            print(response.description);
            let str = String(decoding: response.data!, as: UTF8.self)
            print(str);
            let data = str.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                   print(jsonArray) // use the json here
                    if let error = jsonArray["error"] as? Bool, error{
                        self.view.showToast(message: (jsonArray["message"] as? String) ?? "Something went wrong, please try again.");
                    }
                }
            } catch let error as NSError {
                print(error)
                print("bad json")
                self.mywebView.isHidden = false
                self.mywebView.loadHTMLString(str, baseURL: URL(string: api)!)
                self.mywebView.navigationDelegate = self;
                self.mywebView.addObserver(self, forKeyPath: "URL", options: [.new, .old], context: nil)
                self.mywebView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)

                self.view.addSubview(self.mywebView)
            }

        })
    }
    
    //MARK:- WKNavigationDelegate
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           
        let url = change?[.newKey] as! NSURL
        print("Taken URL: \(url)");
        
        
        let ReceivedURL = url.absoluteString?.lowercased();
        
        if(ReceivedURL!.contains("api.razorpay.com") && ReceivedURL!.contains("status=failed") && ReceivedURL!.contains("token_recurring_status=rejected"))
        {
            self.mywebView.isHidden = true;
            self.view.showToast(message: "Your transaction has been cancelled")

        }
	        	
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + "paytm_wallet_callback";
        if url.absoluteString?.lowercased().contains(api) ?? false {
             //self.navigationController?.popViewController(animated: true);
        } else if url.absoluteString?.lowercased().contains("dashboard/home") ?? false {
            
        }
        
    }
    
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
        
        self.popupAlert(title: kAppName, message:"Some error occured. Please try again later." , actionTitles: ["OK"], actions: [{ () in
            self.navigationController?.popViewController(animated: true);
            }])
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //        print("Strat to load")
        SVProgressHUD.show(withStatus: "Loading...")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    
        if let response = navigationResponse.response as? HTTPURLResponse {
            print("Status Code: \(response.statusCode)");
           
            
            if response.statusCode != 200 {
                self.mywebView.isHidden = true;
                self.view.showToast(message: "Your transaction has been cancelled")
                
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("redirect didFinish")
        print(webView)
        SVProgressHUD.dismiss()
        if let url = webView.url{
//            print(url)
            
            let api =  isPaytm ? APPURL.BaseURL + APPURL.CricketUrl + "paytm_wallet_callback" : APPURL.BaseURL + APPURL.CricketUrl + "razorpay_wallet_callback";
            
            if url.absoluteString.lowercased().contains(api) {
                webView.evaluateJavaScript("document.body.innerHTML") { (value, error) in
                    if let jsn = value as? String{
                        var jsonString = "";
                        jsonString = jsn.replacingOccurrences(of: "<pre style=\"word-wrap: break-word; white-space: pre-wrap;\">", with: "")
                        jsonString = jsonString.replacingOccurrences(of: "</pre>", with: "")
                        
                         let dataNew = jsonString.data(using: String.Encoding.utf8)
                        
                        if let dict = self.nsdataToJSON(data: dataNew! as NSData){
                            self.navigationController?.popViewController(animated: false)
                            self.view.showToast(message: dict["message"] as? String ?? "")
                        }
                    }
                }
            }
        }
    }
    
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
}
extension AddCashVC: UITextFieldDelegate {
    
    // MARK: - UITextfield Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Not allowing user to delete the ruppee symbol.
        let protectedRange = NSMakeRange(0, 1)
        let intersection = NSIntersectionRange(protectedRange, range)
        if intersection.length > 0 {
            return false
        }
        
        // Maximum character 8. Not allowing to enter more than that.
        let maxLength = 8
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length > maxLength {
            return false
        }
        
        return true
    }
    
}
