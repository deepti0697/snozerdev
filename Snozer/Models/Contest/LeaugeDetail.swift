//
//	LeaugeDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct LeaugeDetail: Mappable{

	var leagueFees : Int!
	var matchID : Int!
	var point : Double!
	var rank : Int!
	var teamID : Int!
	var teamName : String!
	var teamNumber : String!
	var userId : Int!
    var wonDetail : String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        leagueFees <- map["LeagueFees"];
        matchID <- map["MatchID"]
        point <- map["Point"];
        rank <- map["Rank"];
        teamID <- map["TeamID"];
        teamName <- map["TeamName"];
        teamNumber <- map["TeamNumber"];
        userId <- map["UserId"];
        wonDetail <- map["WonDetail"];
    }
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		leagueFees = dictionary["LeagueFees"] as? Int
		matchID = dictionary["MatchID"] as? Int
		point = dictionary["Point"] as? Double
		rank = dictionary["Rank"] as? Int
		teamID = dictionary["TeamID"] as? Int
		teamName = dictionary["TeamName"] as? String
		teamNumber = dictionary["TeamNumber"] as? String
		userId = dictionary["UserId"] as? Int
        wonDetail = dictionary["WonDetail"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if leagueFees != nil{
			dictionary["LeagueFees"] = leagueFees
		}
		if matchID != nil{
			dictionary["MatchID"] = matchID
		}
		if point != nil{
			dictionary["Point"] = point
		}
		if rank != nil{
			dictionary["Rank"] = rank
		}
		if teamID != nil{
			dictionary["TeamID"] = teamID
		}
		if teamName != nil{
			dictionary["TeamName"] = teamName
		}
		if teamNumber != nil{
			dictionary["TeamNumber"] = teamNumber
		}
		if userId != nil{
			dictionary["UserId"] = userId
		}
        if wonDetail != nil {
            dictionary["WonDetail"] = wonDetail
        }
		return dictionary
	}

}
