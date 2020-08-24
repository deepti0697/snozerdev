//
//	HomeMatchList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class HomeMatchList: Mappable{

	var contestCount : String!
    var closeDate : String!
    var gametype : Gametype!
    var id : String!
    var matchDate : String!
    var matchId : String!
    var matchLimit : String!
    var matchProgress : String!
    var name : String!
    var series : Sery!
    var serverDate : Double = 0
    var team1 : Team!
    var team2 : Team!
    var playingSquadUpdate = "N"
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        contestCount <- map["contest_count"];
        closeDate <- map["close_date"]
        gametype <- map["gametype"];
        id <- map["id"];
        matchDate <- map["match_date"];
        matchId <- map["match_id"];
        matchLimit <- map["match_limit"];
        matchProgress <- map["match_progress"];
        name <- map["name"];
        
        series <- map["series"];
        serverDate <- map["server_date"];
        team1 <- map["team1"];
        team2 <- map["team2"];
        playingSquadUpdate <- map["playing_squad_updated"]
        
    }
}


class Gametype: Mappable {
    
    var id : String!
    var name : String!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        id <- map["id"];
        name <- map["name"]
    }
}


class Sery : Mappable {
    
    var id : String!
    var name : String!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        id <- map["id"];
        name <- map["name"]
        
    }
}


class Team: Mappable {
    
    var id : String!
    var image : String!
    var name : String!
    var sortName : String!
    var teamRun : String!
    var teamWicket : String!
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        id <- map["id"];
        image <- map["image"]
        name <- map["name"];
        sortName <- map["sort_name"];
        teamRun <- map["team_run"];
        teamWicket <- map["team_wicket"];
    }
}


