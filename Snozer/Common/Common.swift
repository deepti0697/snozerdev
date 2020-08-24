//
//  Common.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//
//

import Foundation
import UIKit
import FacebookLogin
import UserNotifications
import SVProgressHUD

class Common: NSObject {
    
    static var serverTime : Double = 0 {
        
        didSet {            
            NotificationCenter.default.post(name: Common.NotificationNames.Tick, object: nil)
        }
    }
    
    static let sharedInstance = Common()
    
    //get dynamic font size
    func getFontSizeBasedOnDevice(fontsize : CGFloat) -> CGFloat {
        var calculatedFont: CGFloat = fontsize
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            calculatedFont = fontsize * 0.7;
            break
        case 568.0: //iphone 5, 5s => 4 inch
            calculatedFont = fontsize * 0.8;
            break
        case 667.0: //iphone 6, 6s => 4.7 inch
            calculatedFont = fontsize * 0.9;
            break
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
            calculatedFont = fontsize;
            break
        default:
           // print("not an iPhone")
            break
        }
        return calculatedFont;
    }
    
    
    func getTimeDuration(sec : Int) -> String {
        var duration = "recently";
        if sec > 60{
            if sec < 3600{
                duration = "\(sec/60)m ago"
            } else if sec < 86400{
                duration = "\(sec/3600)h ago"
            } else {
                duration = "\(sec/86400)d ago"
            }
        }
        return duration;
    }
    
    //MARK:- Show HUD
    func showHud(_ title: String = "Loading...") {
        SVProgressHUD.show();
    }
    
    func hideHud() {
        SVProgressHUD.dismiss()
    }
    
    //update text field based on error
    func updateTextFields(vw: UIView, error: Bool)  {
        if error{
            vw.shake();
        }
    }
    
    func printMsg(_ str: Any) {
        if isDebug{
            print(str);
        }
    }
    
    
    func requestForPushNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
    }
    
    func checkNotificationEnableOrNot(callback:@escaping (Bool) -> Void) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
                callback(false)
            } else if settings.authorizationStatus == .denied {
                // Notification permission was previously denied, go to settings & privacy to re-enable
                callback(false)
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                callback(true)
            }
        })
    }
    
    
    struct NotificationNames {
        
        
        static let getUpcomingMatch = Notification.Name("getUpcomingMatch")
        static let RefreshSegmentios = Notification.Name("RefreshSegmentios")
        static let NotificationBtn = Notification.Name("NotificationBtn")
        
        
        
        static let SideBarEvent = Notification.Name("SideBarEvent")
        static let SideBarTapped = Notification.Name("SideBarTapped")
        static let GotSport = Notification.Name("gotSport")
        static let Tick = Notification.Name("Tick")
        
        static let JoinContestWithSingleTeam = Notification.Name("JoinContestWithSingleTeam")
		
		static let privateContestFresh = Notification.Name("privateContestFresh")
		
        static let JoinContestDetailWithSingleTeam = Notification.Name("JoinContestDetailWithSingleTeam")
        static let JoinContestPrivateWithSingleTeam = Notification.Name("JoinContestPrivateWithSingleTeam")
        
        static let GotMyTeams = Notification.Name("MyTeams")
        static let GotMyContests = Notification.Name("GotMyContests")
        
         static let GetMatchContestList = Notification.Name("GetMatchContestList")
        
        static let Fantasy_PS = Notification.Name("Fantasy_PS")
        
        static let liveScore =  Notification.Name("liveScore")
        static let LiveResult = Notification.Name("LiveResult")
        
        static let LiveFullScore = Notification.Name("LiveFullScore")
        
        static let PreViewData = Notification.Name("PreViewData")
        
         static let VerifyKYC = Notification.Name("VerifyKYC")
        static let RefreshTeam = Notification.Name("RefreshTeam")
        
         static let showSegmentioOnVerification = Notification.Name("showSegmentioOnVerification")
        
         static let RefreshMyProfile = Notification.Name("RefreshMyProfile")
        
    }
    
}
