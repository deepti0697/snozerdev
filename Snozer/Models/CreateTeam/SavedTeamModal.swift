//
//	SavedTeamModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct SavedTeamModal: Mappable{

	var currentTime : String!
	var matchId : Int!
	var maxTeam : Int!
	var startDate : String!
	var status : String!
	var jointeam : [Jointeam]!

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        currentTime <- map["CurrentTime"];
        matchId <- map["MatchId"]
        maxTeam <- map["MaxTeam"];
        startDate <- map["Start_Date"];
        status <- map["Status"];
        jointeam <- map["jointeam"];
    }
}
