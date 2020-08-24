//
//	PlayerList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper



class PlayerList: Mappable{

	var status : String!
	var success : Bool!
    var id : String!
    var matchId: String!
    var matchDate: String!
    var closeDate: String!
    var serverDate: String!
    var matchProgress: String!
    var matchLimit: String!
    var gametype : Gametype!
    var series : Sery!
    var name : String!
    var team1 : Team!
    var team2 : Team!
    var batsmans : [PlayerData]!
    var bowlers : [PlayerData]!
    var show : Bool!
    var wicketkeapers : [PlayerData]!
    var allrounders : [PlayerData]!
    var settingData: TeamSetting!
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        id <- map["id"];
        name <- map["name"]
        team1 <- map["team1"];
        team2 <- map["team2"];

        batsmans <- map["batsmans"];
        allrounders <- map["allrounders"]
        bowlers <- map["bowlers"];
        wicketkeapers <- map["wicketkeapers"];
        closeDate <- map["close_date"]
        gametype <- map["gametype"];
        matchDate <- map["match_date"];
        matchId <- map["match_id"];
        matchLimit <- map["match_limit"];
        matchProgress <- map["match_progress"];
        
        series <- map["series"];
        serverDate <- map["server_date"];
        settingData <- map["team_settings"];
    }

}

class TeamSetting: Mappable{

    var maxPlayers : String!
    var maxPlayerPerTeam : String!
    var maxCredit : String!
    var minWicketKeeper: String!
    var maxWicketKeeper: String!
    var minBatsman: String!
    var maxBatsman: String!
    var minAllrounder: String!
    var maxAllrounder: String!
    var minBowler : String!
    var maxBowler : String!

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        maxPlayers <- map["MAX_PLAYERS"];
        maxPlayerPerTeam <- map["MAX_PLAYERS_PER_TEAM"]
        maxCredit <- map["MAX_CREDITS"];
        minWicketKeeper <- map["MIN_WICKETKEEPER"];
        maxWicketKeeper <- map["MAX_WICKETKEEPER"];
        minBatsman <- map["MIN_BATSMAN"];
        
        maxBatsman <- map["MAX_BATSMAN"];
        minBowler <- map["MIN_BOWLER"]
        maxBowler <- map["MAX_BOWLER"];
        minAllrounder <- map["MIN_ALLROUNDER"];
        maxAllrounder <- map["MAX_ALLROUNDER"]
    }

}
