//
//  MainService.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//
//

import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON
let kNoResponse = "No response"


class MainService : NSObject{
    
    static func setHeader() -> [String : String] {
        var dic = [
            "LANG": "1",
            "DEVICEINFO":appdelegate.device.systemVersion + "," + appdelegate.device.model,
            "DEVICETYPE" : "I",
            "APPINFO": Bundle.main.releaseVersionNumber ?? "1.0",
            "DEVICE-ID" : "340680945ipdigopdfgipdgp",
//            "TOKEN" : "MTU2OTI0OTE4OTQ=////AA"
            
        ];
        if let authToken = Utility.sharedInstance.getAuthToken() {
            dic["TOKEN"] = authToken;
            Common.sharedInstance.printMsg("auth token \(authToken)")
        }
        return dic;

    }
    
    static func getErrorMessage(_ message:String = kErrorNoInternet) -> [String:Any]{
        var params:[String:Any] = ["error":true];
        params["message"] = message;
        return params;
    }
    
    static func getRequest(endPoint: String,_ params:[String : String], callback: @escaping ([String : Any]) -> Void) {
        Common.sharedInstance.printMsg(params)
        Common.sharedInstance.printMsg(endPoint)
        if Reachability.isConnectedToNetwork() {
            AF.request(URL(string: endPoint)!, method: .get, parameters: params, encoding: URLEncoding.default, headers: HTTPHeaders(MainService.setHeader()), interceptor: nil).responseJSON { (response) in
                requestCallBack(result: response.result, callback: callback);
            }
        }else{
            callback(getErrorMessage());
        }
    }
    
    static func postRequest(endPoint: String,_ params: [String : String], callback: @escaping ([String : Any]) -> Void) {
        Common.sharedInstance.printMsg(params)
        Common.sharedInstance.printMsg(endPoint)
        
        if Reachability.isConnectedToNetwork(){
            
            AF.request(endPoint, method: .post, parameters: params, encoding: URLEncoding.default, headers: HTTPHeaders(MainService.setHeader())).responseJSON(completionHandler: { (response) in
                requestCallBack(result: response.result, callback: callback);
            })
            
        }else{
            callback(getErrorMessage());
        }
    }
    
    static func putRequest(endPoint: String,_ params: [String : String], callback: @escaping ([String : Any]) -> Void) {
        Common.sharedInstance.printMsg(params)
        Common.sharedInstance.printMsg(endPoint)
        
        if Reachability.isConnectedToNetwork(){
            
            AF.request(endPoint, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: HTTPHeaders(MainService.setHeader())).responseJSON(completionHandler: { (response) in
                requestCallBack(result: response.result, callback: callback);
            })
            
        }else{
            callback(getErrorMessage());
        }
    }
    
    
    static func requestCallBack(result: Result<Any, Error>, callback: ([String : Any]) -> Void) {
        switch result {
        case .success(let info):
            Common.sharedInstance.printMsg(info);
            if let dic = info as? [String : Any]{
                if let code = dic["code"] as? Int, code == 405{
                    Common.sharedInstance.hideHud();
                    let action = EMAlertAction(title: "Ok", style: .normal) {
                        Utility.sharedInstance.deleteLoginUser();
                      //  appdelegate.setController(isLogin: true);
                    }
                    UIApplication.topViewController()?.popupAlertWithActions(title: kAppName, message: kErrorExpiredToken, actions: [action]);
                    return
                }else if let code = dic["code"] as? Int, code == 404 {
                    Common.sharedInstance.hideHud();
                    let action = EMAlertAction(title: "Ok", style: .normal) {
                        Utility.sharedInstance.deleteLoginUser();
                      //  appdelegate.setController(isLogin: true);
                    }
                    UIApplication.topViewController()?.popupAlertWithActions(title: kAppName, message: (dic["message"] as? String) ?? "", actions: [action]);
                    return
                    
                }else{
                    callback(dic);
                }
                return
            }
            
        case .failure(let error):
            Common.sharedInstance.printMsg(error.localizedDescription)
            callback(getErrorMessage(error.localizedDescription));
        }
        
    }
    
    //MARK: - UPLOAD MEDIA IN MULTIPART
    static func uploadRequest(endPoint: String, _ header : [String : String], _ fileParams:[String : Any]?, _ fileName: String, callback: @escaping ([String : Any]) -> Void) {
        
        if !Reachability.isConnectedToNetwork() {
            callback(getErrorMessage());
            return
        }
        
        let urlRequest = try! URLRequest(url: endPoint, method: .post, headers: HTTPHeaders(header))
        let multipartFormData = MultipartFormData();
        for (key, value) in header {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!,withName: key)
        }
        if let fileParams = fileParams {
            for (key, value) in fileParams {
                multipartFormData.append(value as! Data, withName: key, fileName: fileName, mimeType: "image/png")
            }
        }
        
        AF.upload(multipartFormData: multipartFormData, with: urlRequest).responseJSON { (response) in
            requestCallBack(result: response.result, callback: callback);
            
        }
    }
}
