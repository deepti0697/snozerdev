//
//  AppDelegate.swift
//  Snozer
//
//  Created by Admin on 27/09/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DeviceKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import UserNotifications
import AWSCore
import AWSS3


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var matchTypeUrl = APPURL.CricketUrl;
    var matchType = "0";
    var window : UIWindow?;
    var screenSize: CGRect = UIScreen.main.bounds
    var SingleMatchInfo : HomeMatchList!
    var ContestInfo : ContestPool?
    var JoinTeamId = "0";
    var isBeatExpert = false;
    var StrLeagueId = String()
    
    var arrState: Array<String>?
    var objAmountDetail: AmountDetail?
    var strKYCStatus: String?
    var objAccountInfo: UserData?
    
    let gcmMessageIDKey = "gcm.message_id"
    var PushStatus: String = "Off"
    
    ///Private Contest
    var privatContestDict = NSDictionary()
    var privatContestCode = String()
    
    lazy var device: Device = {
        let device = Device()
        return device
    }()
    
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    
    func setAWSSetting() {
        if let info = self.objAccountInfo {
            let accessKey = info.aws.aWSKEY
            let secretKey = info.aws.aWSSECRET
            
            let credentialsProvider = AWSStaticCredentialsProvider (accessKey: accessKey!, secretKey: secretKey!)
            let configuration = AWSServiceConfiguration(region: AWSRegionType.APSouth1, credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration
        }
    }
    
    func downloadImage(Name imageName:String, fromBucket bucketName:String, onDownload successCallback: @escaping (UIImage) -> Void, andOnError errorCallback: @escaping (String) -> Void){
        self.setAWSSetting();
        let transferManager     = AWSS3.default()
        let getImageRequest     = AWSS3GetObjectRequest()
        getImageRequest?.bucket = bucketName
        getImageRequest?.key    = appdelegate.objAccountInfo?.aws.aWSKEY
        getImageRequest?.downloadingFileURL = URL(string: imageName);
        
        transferManager.getObject(getImageRequest!).continueWith(executor: AWSExecutor.mainThread()) { (anandt) -> Void in
            if anandt.error == nil {
                if let imageData = anandt.result?.body as? Data, let image = UIImage(data: imageData) {

                    successCallback(image)
                } else {
                    errorCallback("Download failed")
                }
            } else {

                let error = "Error \(anandt.error?.localizedDescription ?? "unknown by dev")"
                errorCallback(error)
            }
        }
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.white
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        ///---Google Key
        GIDSignIn.sharedInstance().clientID = kGoogleClientID
//        let bounds = UIScreen.main.bounds
//        self.window = UIWindow(frame: bounds)
//        let vc = UIStoryboard(name: "Initial", bundle: nil).instantiateViewController(withIdentifier: "navLogin")
//        self.window?.makeKeyAndVisible()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = vc
        
        if #available(iOS 10.0, *) {
                   // For iOS 10 display notification (sent via APNS)
           UNUserNotificationCenter.current().delegate = self
           
           let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
           UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (isSuccess, error) in
               if let error = error {
                   print(error.localizedDescription)
               }
           })
       } else {
           let settings: UIUserNotificationSettings =
               UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
           application.registerUserNotificationSettings(settings)
       }
       
       // FirebaseApp.configure()
       application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
                
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if Common.serverTime > 0 {
                Common.serverTime += 1
            }
        }
        RunLoop.main.add(timer, forMode: .common)
        self.updateNotificationToken();

        return true
     
    }
           
    func updateNotificationToken() {
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            UserService.updateNotificationDevice(["device_token" : result.token]);
          }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    
          // If you are receiving a notification message while your app is in the background,
          // this callback will not be fired till the user taps on the notification launching the application.
          // TODO: Handle data of notification
          // With swizzling disabled you must let Messaging know about the message, for Analytics
          // Messaging.messaging().appDidReceiveMessage(userInfo)
          // Print message ID.
    
          if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
          }

        self.PushStatus = "On"
        // Print full message.
          print(userInfo)
    
        }
    
        
    
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
        {
          // If you are receiving a notification message while your app is in the background
          // this callback will not be fired till the user taps on the notification launching the application.
          // TODO: Handle data of notification
          // With swizzling disabled you must let Messaging know about the message, for Analytics
          // Messaging.messaging().appDidReceiveMessage(userInfo)
          // Print message ID.
          if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
          }
    
        self.PushStatus = "On"
        // Print full message.
        print(userInfo)

        Messaging.messaging().appDidReceiveMessage(userInfo)
    
        let PushValue: NSDictionary = userInfo as NSDictionary
        print("Msg 1: \(PushValue)")
    
        completionHandler(UIBackgroundFetchResult.newData)
    
        }
    
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
        {
          print("Unable to register for remote notifications: \(error.localizedDescription)")
        }
    
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          print("APNs token retrieved: \(deviceToken)")
    
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
        Messaging.messaging().apnsToken = deviceToken
 
          // With swizzling disabled you must set the APNs token here.
          // Messaging.messaging().apnsToken = deviceToken
        }
    
        public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
        {
            print("Firebase registration token: \(fcmToken)")
            UserDefaults.standard.set("\(fcmToken)", forKey: "FCMToken")
            UserDefaults.standard.synchronize()
    
            let dataDict:[String: String] = ["token": fcmToken]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
    
        func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage)
        {
            print("Received data message: \(remoteMessage.appData)")
        }
    
        @available(iOS 10.0, *)
        func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
        {
    
            completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    
        }
    
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
        {
            //Push Status
            let SelectedPracticeIdText = "Yes"
            UserDefaults.standard.set(SelectedPracticeIdText, forKey: "NewNotificationReceived")
            UserDefaults.standard.synchronize()
    
            let userInfo = notification.request.content.userInfo
            print("Received Notification 2: \(userInfo)")
    
            self.PushStatus = "On"
    
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")

            }
            completionHandler([.alert, .badge, .sound])
        }
    
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    
        {
            let userInfo = response.notification.request.content.userInfo
            Messaging.messaging().appDidReceiveMessage(userInfo)
            let PushValue: NSDictionary = userInfo as NSDictionary
             print("Msg 2: \(PushValue)")
    
            self.PushStatus = "On"
    
            // Print message ID.
    
            if let messageID = userInfo[gcmMessageIDKey] {
    
                print("Message ID: \(messageID)")
    
            }
    
            completionHandler()
    
        }
    
        func scheduleNotification(title : String, body: String, interval: TimeInterval)
        {
            if #available(iOS 10.0, *)
            {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default
                content.categoryIdentifier = "CALLINNOTIFICATION"
                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: interval, repeats: false)
                let identifier = "id_"+title
                let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error) in
    
                }
            }
        }
    
        @objc func tokenRefreshNotification(notification: NSNotification)
        {
            guard let contents = Messaging.messaging().fcmToken
                else
            {
                return
            }
    
            print("InstanceID token: \(contents)")
            // Connect to FCM since connection may have failed when attempted before having a token.
            connectToFcm()
        }
    
        func connectToFcm()
        {
            guard Messaging.messaging().fcmToken != nil else
            {
                return
            }
    
            // Disconnect previous FCM connection if it exists.
            Messaging.messaging().shouldEstablishDirectChannel = false
            print("Disconnected from FCM.")
        }
    
    // MARK: - Deep Link Methods
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let isFBOpenUrl = FBSDKCoreKit.ApplicationDelegate.shared.application(app, open: url, options: options)
        let isGoogleOpenUrl = GIDSignIn.sharedInstance().handle(url)
    
        if isFBOpenUrl { return true }
        if isGoogleOpenUrl { return true }
        return true
    }

    // MARK: UISceneSession Lifecycle

    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

   

}

