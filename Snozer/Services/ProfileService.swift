//
//  ProfileService.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//
//

import Foundation
import UIKit
import SwiftyJSON
import ObjectMapper


class ProfileService: NSObject {
    
    static func getResponseDTO(_ response:[String:Any]) -> ResponseDto {
        return Mapper<ResponseDto>().map(JSON: response)!
    }
    
    static func getResultValue(_ response:ResponseDto) -> [String : Any] {
        guard let dict = response.data as? [String : Any] else {
            return [:]
        }
        return dict;
    }
    
    static func GetAmountDetail(_ apiName: String, params:[String:String], callback: @escaping (Bool,AmountDetail?,String) -> Void)  {
//        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            let resultDto = getResultValue(responseDto);
            
            if let data = resultDto["wallet"] as? [String: Any]{
                callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<AmountDetail>().map(JSON: data) : nil, responseDto.getMessage());
            }else{
                callback(false, nil, responseDto.getMessage());
            }
            
//            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetAccInfo(_ apiName: String, params:[String:String], callback: @escaping (Bool,AccountInfo?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<AccountInfo>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetReferCode(_ apiName: String, params:[String:String], callback: @escaping (Bool,String?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.data as? String, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func UploadDetails(apiName: String, header:[String:String], fileParam:[String:Any],fileName: String , callback: @escaping (Bool, String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.uploadRequest(endPoint: apiName, header, fileParam, fileName) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func UploadBankPanDetail(_ apiname:String, params:[String:String], callback: @escaping (Bool, UserData? ,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiname, params) { (response) in
            let responseDto = getResponseDTO(response);
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<UserData>().map(JSON: resultDto) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func UpdateUserProfile(params:[String:String], callback: @escaping (Bool, UserData? ,String) -> Void)  {
        Common.sharedInstance.showHud();
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.UpdateUserProfile;
        MainService.postRequest(endPoint: api, params) { (response) in
            let responseDto = getResponseDTO(response);
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<UserData>().map(JSON: resultDto) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetReferList(apiName: String, params:[String:String], callback: @escaping (Bool,[String:Any]?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.data as? [String:Any], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetNotification(apiName: String, params:[String:String], callback: @escaping (Bool,[NotificationDto],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<NotificationDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    static func GetHistory(apiName: String, params:[String:String], callback: @escaping (Bool,[TxnHistory],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<TxnHistory>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func WithdrawAmount(params:[String:String], callback: @escaping (Bool, String) -> Void)  {
        Common.sharedInstance.showHud();
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.Withdrawal
        MainService.postRequest(endPoint: api, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    static func addAmount(apiName: String, params:[String:String], callback: @escaping (Bool, String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func getCustomerProfile(params:[String:String], callback: @escaping (Bool,CustomerInfoDto?,String) -> Void)  {
        Common.sharedInstance.showHud();
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.CustomerProfile;
        MainService.postRequest(endPoint: api, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<CustomerInfoDto>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    static func GetAddCashCallback(apiName: String, params:[String:String], callback: @escaping (Bool, AddCashCallbackDto?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), Mapper<AddCashCallbackDto>().map(JSON: responseDto.data as! [String:Any]), responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
}
