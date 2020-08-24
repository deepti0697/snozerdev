//
//  Utility.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//
//

import Foundation
import UIKit
import SystemConfiguration
import Alamofire
import ObjectMapper



class Utility: NSObject {
    static let sharedInstance = Utility()
    var appTheme: String = kDarkTheme;
    var isGoldAnimate = false;
    var isSilverAnimate = false;
    var isCurrencyAnimate = false;
    var isNotificationNewsId: String = "";
    var isNotificationMagazineId: String = "";
    var isNewMagazineCreateFromMagazineList = false;
    var isMagazineUpdateDB = false;
    var userInfo: UserData?
    var arrGames: [GameDto] = [];
    var iconsInfo: CustomIconDto?
    
//    var arrBackendRequest: [BackendApiRequestModel] = [];
    var isPostUpdate = false;
    
//    private var pendingRequestWorkItem: DispatchWorkItem?
//
//    //call api for stack request
//    func saveAndCallApi(requestData : BackendApiRequestModel) {
//
//        let arr = self.arrBackendRequest.filter({$0.apiName == requestData.apiName && $0.postId == requestData.postId})
//
//        if arr.count == 0{
//            self.arrBackendRequest.append(requestData);
//        }else{
//            let req = arr.first!;
//            req.value = requestData.value;
//        }
//        self.callBackendApi();
//    }
//
//    //MARK: Call Api for backend
//    func callBackendApi() {
//        // Cancel the currently pending item
//        pendingRequestWorkItem?.cancel()
//
//        // Wrap our request in a work item
//        let requestWorkItem = DispatchWorkItem { [weak self] in
//            let group = DispatchGroup()
//            group.enter();
//            for api in self?.arrBackendRequest ?? []{
//                PostService.requestApi(["postId" : api.postId!, "isLike" : api.value!, "isPost": api.isPost], apiName: api.apiName)
//            }
//            group.leave();
//            group.notify(queue: .global()) {
//                self?.arrBackendRequest.removeAll();
//            }
//        }
//        // Save the new work item and execute it after 250 ms
//        pendingRequestWorkItem = requestWorkItem
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2,
//                                      execute: requestWorkItem)
//    }
    
	func checkUserCompleteHisProfileOrNot() -> Bool {
		var valid = false;
		if let user = appdelegate.objAccountInfo{
			if user.phone != "" && user.email != "" && user.dob != "0" && user.state != nil{
				valid = true
			}
		}
		return valid;
	}
	
	func gotoForEditProfile(fromVc: UIViewController)  {
		fromVc.popupAlert(title: kAppName, message: appdelegate.objAccountInfo!.settings.pROFILEUPDATEMESSAGE, actionTitles: ["CANCEL", "GO AHEAD"], actions: [{
		
		},{
			
			let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "EditProfleVC") as! EditProfleVC
			vc.hidesBottomBarWhenPushed = true;
			vc.userInfo = Utility.sharedInstance.getUserInfo();
			fromVc.navigationController?.pushViewController(vc, animated: true);
		}])
	}
	
    func saveAuthToken(token: String) {
        defaults.set(token, forKey: kAuthExpire);
        defaults.synchronize();
    }
    
    func getAuthToken() -> String? {
        return defaults.string(forKey: kAuthExpire);
    }
    
    
    //MARK: - Manage Other info
    func save(object:Any, key:String){
        defaults.setValue(object, forKeyPath: key);
        defaults.synchronize();
    }
    
    func get(key:String) -> Any? {
        return defaults.object(forKey: key)
    }
    
    func delete(key:String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize();
    }

    func saveUserInfo(info : UserData) {
        if let json = info.toJSONString(){
            self.save(object: json, key: kUserInfo);
        }
    }

    func getUserInfo() -> UserData? {
        if let json = self.get(key: kUserInfo) as? String{
            if let dict = self.convertToDictionary(text: json){
                return Mapper<UserData>().map(JSON: dict)
            }
        }
        return nil
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func deleteLoginUser(){
        self.delete(key: kUserInfo);
    }
    
    /////---Email Validation----//////
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /////---Trim String----//////
    
    func trimStringWithString(strOriginal: String) -> String {
        let replacedString = strOriginal.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return replacedString
        
    }
    
    /////---Chek Userdefaults key value nil or not----//////
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
//    func isUserLogged() -> Bool {
//        return self.getLoginUser() != nil
//    }
}

/////---Check Internet Availiblity----//////

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    
}
