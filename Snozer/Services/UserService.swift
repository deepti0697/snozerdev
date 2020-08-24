//
//  UserService.swift
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


class UserService: NSObject {
    
    static func getResponseDTO(_ response:[String:Any]) -> ResponseDto {
        return Mapper<ResponseDto>().map(JSON: response)!
    }
    
    static func getResultValue(_ response:ResponseDto) -> [String : Any] {
        guard let dict = response.data as? [String : Any] else {
            return [:]
        }
        return dict;
    }
    
    
    static func updateNotificationDevice(_ params:[String:String])  {
        MainService.postRequest(endPoint: APPURL.UpdateNotificationUpdate, params) { (response) in
            
        }
    }
    
    static func updateNewReferralCode(_ params:[String: String], callback: @escaping (Bool,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: APPURL.UpdateReferralCodeUpdate, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            
            Common.sharedInstance.hideHud()
        }
    }
    
    static func checkUserStatus(_ params:[String:String], callback: @escaping (Bool, [String:Any] ,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: APPURL.UserCheck, params) { (response) in
            let responseDto = getResponseDTO(response);
            callback(responseDto.isSuccess(), getResultValue(responseDto),responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    
    static func socialSignUpAPI(_ apiName: String,params:[String:String], callback: @escaping (Bool, UserData?, String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response);
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<UserData>().map(JSON: resultDto ) : nil,responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    static func appLogin(_ params:[String:String], callback: @escaping (Bool, UserData? ,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: APPURL.LoginAPI, params) { (response) in
            let responseDto = getResponseDTO(response);
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<UserData>().map(JSON: resultDto ) : nil,responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    static func register(_ params:[String:String], callback: @escaping (Bool,UserData?,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: APPURL.RegisterAPI, params) { (response) in
            let responseDto = getResponseDTO(response)
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<UserData>().map(JSON: resultDto) : nil,responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    static func otpSend(_ apiName: String, params:[String:String], callback: @escaping (Bool, String, String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            if let dict = responseDto.data as? [String: Any]{
                callback(responseDto.isSuccess(), (dict["otp"] as? String) ?? "", responseDto.getMessage());
            }else{
                callback(responseDto.isSuccess(), "", responseDto.getMessage());
            }
            
            
            Common.sharedInstance.hideHud()
        }
    }
    
   
    static func otpVerify(_ apiName: String, params:[String:String], callback: @escaping (Bool, UserData?,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response);
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<UserData>().map(JSON: resultDto) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    

    static func resetPassword(_ params:[String: String], callback: @escaping (Bool,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: APPURL.ResetPasswordAPI, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    
    static func getStates(_ apiName: String, params:[String:String], callback: @escaping (Bool,[CommonDto],String) -> Void)  {
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<CommonDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
        }
    }
    
    
    static func changePassword(_ params:[String:String], callback: @escaping (Bool,String) -> Void)  {
        Common.sharedInstance.showHud()
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.ChangePassword
        MainService.postRequest(endPoint: api, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    static func getProfilePictures(params:[String:String], callback: @escaping (Bool,[String],String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: APPURL.ProfilePictures, params) { (response) in
            let responseDto = getResponseDTO(response)
            if responseDto.isSuccess(){
                if  let arr = responseDto.data as? Array<String>{
                    callback(responseDto.isSuccess(), arr, responseDto.getMessage());
                }else{
                    callback(responseDto.isSuccess(), [], responseDto.getMessage());
                }
            }else{
                callback(responseDto.isSuccess(), [], responseDto.getMessage());
            }
            Common.sharedInstance.hideHud()
        }
    }
    
    static func setProfilePicture(_ params:[String:String], callback: @escaping (Bool,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: APPURL.SetProfilePicture, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    
    static func getSeries(_ apiname: String, params:[String:String], callback: @escaping (Bool,[CommonDto],String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiname, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<CommonDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    static func getSeriesLeaderboard(_ apiname: String, _ params:[String:String], callback: @escaping (Bool,[String:Any],String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiname, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), response, responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    static func getSeriesCustomerMatches(_ apiname: String, _ params:[String:String], callback: @escaping (Bool,[LeaderboardDto]?,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiname, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<LeaderboardDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    
    static func getCustomers(_ apiname: String, _ params:[String:String], callback: @escaping (Bool,[CustomerInfoDto]?,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiname, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<CustomerInfoDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    static func followAndUnfollow(_ apiname: String, _ params:[String:String], callback: @escaping (Bool,LeaderboardDto?,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiname, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<LeaderboardDto>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    
    static func getProfileInfo(_ apiname: String, callback: @escaping (Bool,UserData?,String) -> Void)  {        
        MainService.postRequest(endPoint: apiname, [:]) { (response) in
            
            let responseDto = getResponseDTO(response);
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<UserData>().map(JSON: resultDto) : nil, responseDto.getMessage());
        }
    }
    
    static func getPlayingHistory(_ apiname: String, callback: @escaping (Bool,PlayingHistory?,String) -> Void)  {
        MainService.postRequest(endPoint: apiname, [:]) { (response) in
            let responseDto = getResponseDTO(response);
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<PlayingHistory>().map(JSON: resultDto) : nil, responseDto.getMessage());
        }
    }
    
    
    static func getCustomIcons(callback: @escaping (Bool,CustomIconDto?,String) -> Void)  {
        let apiname = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.getCustomIcons;
        MainService.postRequest(endPoint: apiname, [:]) { (response) in
            let responseDto = getResponseDTO(response);
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<CustomIconDto>().map(JSON: resultDto) : nil, responseDto.getMessage());
        }
    }
    
    static func getReferDetail(callback: @escaping (Bool,ReferDataDto?,String) -> Void)  {
        let apiname = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GerReferEarn;
        MainService.postRequest(endPoint: apiname, [:]) { (response) in
            let responseDto = getResponseDTO(response);
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<ReferDataDto>().map(JSON: resultDto) : nil, responseDto.getMessage());
        }
    }
	
    static func getReferTeamDetail(callback: @escaping (Bool,ReferralDto?,String) -> Void)  {
        let apiname = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.RefereDetail;
        MainService.postRequest(endPoint: apiname, [:]) { (response) in
            let responseDto = getResponseDTO(response);
            let resultDto = getResultValue(responseDto);
			callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<ReferralDto>().map(JSON: resultDto) : nil, responseDto.getMessage());
        }
    }
    
    static func getReferTeamDetailCash(callback: @escaping (Bool,ReferralDto?,String) -> Void)  {
//        let apiname = APPURL.BaseURL + appdelegate.matchTypeUrl  + APPURL.RefereDetailCash;
        
        let apiname = APPURL.BaseURL + APPURL.CricketUrl  + APPURL.RefereDetailCash;
        
//        print("URL: \(apiname)");
//
           MainService.postRequest(endPoint: apiname, [:]) { (response) in
//            print("Res: \(response)");
            
               let responseDto = getResponseDTO(response);
               let resultDto = getResultValue(responseDto);
               callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<ReferralDto>().map(JSON: resultDto) : nil, responseDto.getMessage());
           }
       }
    
    static func CustomerInquiry(_ apiname: String, _ params:[String:String], callback: @escaping (Bool,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiname, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    static func ApplyPromoCode(_ apiname: String, _ params:[String:String], callback: @escaping (Bool,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiname, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
    
    static func VerifyEmail(_ apiname: String, _ params:[String:String], callback: @escaping (Bool,String) -> Void)  {
        Common.sharedInstance.showHud()
        MainService.postRequest(endPoint: apiname, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud()
        }
    }
}
