//
//  SplashController.swift
//  GC11
//
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import UIKit

class SplashController: ViewController {
//    var appdelegate: AppDelegate!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgSplash: UIImageView!
    var apiHitCount = Int()
    /////---Modeal Varaible----/////
 //   var objSplashModel: SplashVersion2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Splash Screen: 11");
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        activityIndicator.startAnimating()
//        appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        UserService.getCustomIcons { (flag, response, msg) in
            if flag{
                if let info = response{
                    Utility.sharedInstance.iconsInfo = info;
                }
            }
        }
        self.callApiForProfile();
        apiHitCount = 0
        self.InternetStatus();
        self.delay(4) {
            self.redirectMethod()
        }
    }
  
    ////-- Check Internet status ---///
    @objc func InternetStatus()  {
        if Reachability.isConnectedToNetwork(){
            self.activityIndicator.startAnimating()
           // self.versionAPI()
        } else{
            self.view.showToast(message: "Please check your internet connection.")
        }
    }
    
    func callApiForProfile() {
        let api = APPURL.BaseURL + APPURL.CricketUrl + APPURL.GetProfile;
        UserService.getProfileInfo(api) { (flag, response, msg) in
            if flag{
                if let info = response{
                    appdelegate.objAccountInfo = info;
                    appdelegate.setAWSSetting();
                }
            }
        }
    }
    
    // MARK: - Class Redirect Methods
    ///-- This method redirect in further class according to Auto login and Skip Tutorial condition
    func redirectMethod()  {
        self.activityIndicator.stopAnimating();
        if (Utility.sharedInstance.get(key: kIsAutoLogin) as? Bool) ?? false {
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let TabVC: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            TabVC.selectedIndex = 0
            UIApplication.shared.windows.first?.rootViewController = TabVC
            
        } else {
            let vc = UIStoryboard(name: "Initial", bundle: nil).instantiateViewController(withIdentifier: "navLogin")
            UIApplication.shared.windows.first?.rootViewController = vc
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
