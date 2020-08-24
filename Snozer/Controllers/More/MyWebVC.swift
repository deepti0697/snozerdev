//
//  FAQDetailVC.swift
//  TheTeam11
//
//  Created by AK on 25/02/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import Alamofire
import WebKit
import SVProgressHUD

class MyWebVC: ViewController,WKNavigationDelegate, UIGestureRecognizerDelegate {

	@IBOutlet weak var layoutHeaderH: NSLayoutConstraint!
	@IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var mywebView: WKWebView!
    var navtitle: String?
    var slugname = ""
    var isFromRegi = false
    var headerView : NavHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
	self.layoutHeaderH.constant = appdelegate.hasTopNotch ? 93 : 64
        self.setHeaderView();
        showWebPage()
        
        
       // getPlayingHistory()
    }
    
    func setHeaderView() {
        headerView = NavHeaderView.loadViewFromNib();
        headerView?.parentVC = self;
        headerView?.stckLeft.isHidden = true;
        vwHeader.addSubview(headerView!);
        headerView?.setHeaderinfo(title: navtitle ?? "");
        headerView?.lblNotificationCount.isHidden = true;
        headerView?.addConstaints(top: 0, right: 0, bottom: 0, left: 0, width: nil, height: nil);
        
    }
    
    func showWebPage() {
        
        let STRurl = WebURL.BaseURL + slugname + ".html"
        
        let url = NSURL(string: STRurl)
        let request = NSURLRequest(url: url! as URL)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // init and load request in webview.
        mywebView.navigationDelegate = self
        mywebView.load(request as URLRequest)
    }
    
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        let url = change?[.newKey] as! NSURL
//        print(url)
//        if url.absoluteString?.lowercased().contains("http://gc11api.svapinfotech.com/amount/paymentsuccess") ?? false {
//            let TabVC: UITabBarController = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
//            TabVC.selectedIndex = 0
//            appdelegate.window?.rootViewController = TabVC
//        } else if url.absoluteString?.lowercased().contains("dashboard/home") ?? false {
//            let TabVC: UITabBarController = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
//            TabVC.selectedIndex = 0
//            appdelegate.window?.rootViewController = TabVC
//        }
//    }
    
    
    // Back swipe gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK:- WKNavigationDelegate
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
        self.popupAlert(title: kAppName, message:"Some error occured. Please try again later." , actionTitles: ["OK"], actions: [{ () in
            self.btnBackTap(nil)
            }])
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //        print("Strat to load")
        SVProgressHUD.show(withStatus: "Loading...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //        print("finish to load")
        SVProgressHUD.dismiss()
    }
    
    @objc func btnBackTap(_ sender: UIBarButtonItem?) {
        navigationController?.popViewController(animated: true)
        SVProgressHUD.dismiss()
    }
    
}
