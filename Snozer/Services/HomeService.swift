//
//  HomeService.swift
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


class HomeService: NSObject {
    
    static func getResponseDTO(_ response:[String:Any]) -> ResponseDto {
        return Mapper<ResponseDto>().map(JSON: response)!
    }
    
    static func getResultValue(_ response:ResponseDto) -> [String : Any] {
        guard let dict = response.data as? [String : Any] else {
            return [:]
        }
        return dict;
    }
    
    
    
    
    static func getmatchList(_apiName: String, params:[String:String], callback: @escaping (Bool,[HomeMatchList],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<HomeMatchList>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    static func getHeaderImageList(_apiName: String, params:[String:String], callback: @escaping (Bool,[HeaderModal],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<HeaderModal>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func getMyMatchList(_apiName: String, params:[String:String], callback: @escaping (Bool,[HomeMatchList],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<HomeMatchList>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    static func getGames(params:[String:String], callback: @escaping (Bool,[GameDto],String) -> Void)  {
        let api = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.GetGames;
        MainService.postRequest(endPoint: api, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<GameDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
        }
    }
    
    
    
    static func GetContest(_apiName: String,  params:[String:String], callback: @escaping (Bool,[String:Any]?,String) -> Void)  {
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), response, responseDto.getMessage());
        }
    }
    
    static func GetContestDetail(_apiName: String,  params:[String:String], callback: @escaping (Bool,[ContestCateModel],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<ContestCateModel>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetPrivateContestDetail(_apiName: String,  params:[String:String], callback: @escaping (Bool,[String: Any]?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), response, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetContestTeam(_apiName: String,  params:[String:String], callback: @escaping (Bool,[String:Any],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), response, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    static func createPost(_apiName: String,  params:[String:String], callback: @escaping (Bool,[String:Any]?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.data as? [String:Any], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    static func getPostList(_apiName: String,  params:[String:String], callback: @escaping (Bool,[PostShareDto],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<PostShareDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetReactionList(_apiName: String,  params:[String:String], callback: @escaping (Bool,[CommonDto],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<CommonDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func postReact(_apiName: String,  params:[String:String], callback: @escaping (Bool,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetCustomersReactions(_apiName: String,  params:[String:String], callback: @escaping (Bool, [[String:Any]]?, String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(),responseDto.data as? [[String:Any]], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    static func GetMatchScore(_apiName: String,  params:[String:String], callback: @escaping (Bool,MatchScoreDto?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<MatchScoreDto>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetCustomerMatchContest(_apiName: String,  params:[String:String], callback: @escaping (Bool,[String:Any]?,String) -> Void)  {
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), response, responseDto.getMessage());
        }
    }
    
    static func GetMatchTeamStats(_apiName: String,  params:[String:String], callback: @escaping (Bool,[PlayerStatsDto],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<PlayerStatsDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetCustomerTeamStats(_apiName: String,  params:[String:String], callback: @escaping (Bool,[PlayerStatsDto],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            if let data = responseDto.data as? [String : Any]{
                if let info = data["players_stats"] as? [[String:Any]]{
                    callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<PlayerStatsDto>().mapArray(JSONArray: info) : [], responseDto.getMessage());
                }else{
                    callback(false,[], responseDto.getMessage());
                }
            }else{
                callback(false,[], responseDto.getMessage());
            }
            
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetDreamTeamStats(_apiName: String,  params:[String:String], callback: @escaping (Bool,[PlayerStatsDto],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<PlayerStatsDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetCreateTeamPlayersStats(_apiName: String,  params:[String:String], callback: @escaping (Bool,[PlayerStatsDto],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<PlayerStatsDto>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func joinPrivateContestAPI(_apiName: String,  params:[String:String], callback: @escaping (Bool,ContestAmountDetail?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<ContestAmountDetail>().map(JSON: responseDto.data as! [String:Any]) : nil,responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func joinAfterPrivateContestAPI(_apiName: String,  params:[String:String], callback: @escaping (Bool,String?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(),response["match_contest_id"] as? String,responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetSingleMatchData(_apiName: String,  params:[String:String], callback: @escaping (Bool,HomeMatchList?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<HomeMatchList>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    

    
    static func GetSingleCategoryContest(_apiName: String,  params:[String:String], callback: @escaping (Bool,[String:Any]?,String) -> Void)  {
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.data as? [String:Any], responseDto.getMessage());
        }
    }
    
    
    static func GetJoinedContest(_apiName: String,  params:[String:String], callback: @escaping (Bool,[String:Any]?,String) -> Void)  {
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.data as? [String:Any], responseDto.getMessage());
        }
    }
    
    static func GetPlayers(_apiName: String,  params:[String:String], callback: @escaping (Bool,PlayerList?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<PlayerList>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func getTeamData(_apiName: String,  params:[String:String], callback: @escaping (Bool,Jointeam?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<Jointeam>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetTeamList(_apiName: String,  params:[String:String], callback: @escaping (Bool,[Jointeam],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<Jointeam>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    
    static func GetPlayerLivePoints(_apiName: String,  params:[String:String], callback: @escaping (Bool,LivePlayerPoints?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<LivePlayerPoints>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    static func GetLiveScore(_apiName: String,  params:[String:String], callback: @escaping (Bool,LiveScore?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<LiveScore>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }

    
    static func GetWinningBreakUp(_apiName: String,  params:[String:String], callback: @escaping (Bool,WinningBreakUpModal?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<WinningBreakUpModal>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    

    static func SaveTeamAPI(params:[String:String], callback: @escaping (Bool, String?, String) -> Void)  {
        Common.sharedInstance.showHud();
        let url = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.CreateCustomerTeam
        MainService.postRequest(endPoint: url, params) { (response) in
            let responseDto = getResponseDTO(response)
            let resultValue = getResultValue(responseDto);
            callback(responseDto.isSuccess(), resultValue["id"] as? String ,responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func SaveEditedTeamAPI(params:[String:String], callback: @escaping (Bool, String) -> Void)  {
        Common.sharedInstance.showHud();
        let url = APPURL.BaseURL + appdelegate.matchTypeUrl + APPURL.UpdateCustomerTeam
        MainService.postRequest(endPoint: url, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func GetMyJoinContestLive(_apiName: String,  params:[String:String], callback: @escaping (Bool,JoinedStartedMatchModal?,String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<JoinedStartedMatchModal>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    static func getJoinedMatchListAPI(_apiName: String,  params:[String:String], callback: @escaping (Bool,[HomeMatchList],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<HomeMatchList>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    

    static func GetPlayerTourPoints(_apiName: String,  params:[String:String], callback: @escaping (Bool,TourPoints?,String) -> Void)  {
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<TourPoints>().map(JSON: responseDto.data as! [String:Any]) : nil, responseDto.getMessage());
        }
    }
    
    static func GetPlayerPoints(_apiName: String,  params:[String:String], callback: @escaping (Bool,[LeaguePlayerPoints],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<LeaguePlayerPoints>().mapArray(JSONArray: responseDto.data as! [[String:Any]]) : [], responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }

    
    static func getPrivateContestSettings(_ apiName: String, params:[String:String], callback: @escaping (Bool, [String : Any] , String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), resultDto ,responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func getPrivateContestEntreeCalculate(_ apiName: String, params:[String:String], callback: @escaping (Bool, [String : Any] , String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            let resultDto = getResultValue(responseDto);
            callback(responseDto.isSuccess(), resultDto ,responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func getPrivateContestWinningBrackups(_ apiName: String, params:[String:String], callback: @escaping (Bool, PrivateWinningOptionDto? , String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<PrivateWinningOptionDto>().map(JSON: responseDto.data as! [String:Any]) : nil,responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func getCreatedTeamCount(_apiName: String,  params:[String:String], callback: @escaping (Bool,Int?,String) -> Void)  {
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.data  as? Int, responseDto.getMessage());
        }
    }
    
    static func PrejoinContestDetail(_ apiName: String, params:[String:String], callback: @escaping (Bool, ContestAmountDetail? , String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<ContestAmountDetail>().map(JSON: responseDto.data as! [String:Any]) : nil,responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func customerJoinContest(_ apiName: String, params:[String:String], callback: @escaping (Bool, PrivateWinningOptionDto? , String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.isSuccess() ? Mapper<PrivateWinningOptionDto>().map(JSON: responseDto.data as! [String:Any]) : nil,responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    static func customerSwitchTeamWithJoinContest(_ apiName: String, params:[String:String], callback: @escaping (Bool, String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
    
    static func ContestShareInfo(_apiName: String,  params:[String:String], callback: @escaping (Bool,[String:Any],String) -> Void)  {
        Common.sharedInstance.showHud();
        MainService.postRequest(endPoint: _apiName, params) { (response) in
            let responseDto = getResponseDTO(response)
            callback(responseDto.isSuccess(), response, responseDto.getMessage());
            Common.sharedInstance.hideHud();
        }
    }
    
}
