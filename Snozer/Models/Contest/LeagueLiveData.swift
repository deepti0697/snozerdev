//
//	LeagueLiveData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


struct LeagueLiveData: Mappable {

	var autoHeaderID : Int!
	var isPercentage : Bool!
	var isPercentageWinners : String!
	var leagueFees : Int!
	var leagueID : Int!
	var matchID : Int!
	var rank : String!
	var teamPoint : Double!
	var title : String!
	var totalTeam : Int!
	var winnerTitle : String!
    var leagueWinningAmount : Int!

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        autoHeaderID <- map["AutoHeaderID"];
        isPercentage <- map["IsPercentage"]
        isPercentageWinners <- map["IsPercentageWinners"];
        leagueFees <- map["LeagueFees"];
        leagueID <- map["LeagueID"];
        matchID <- map["MatchID"];
        
        rank <- map["Rank"];
        teamPoint <- map["TeamPoint"]
        title <- map["Title"];
        totalTeam <- map["TotalTeam"];
        winnerTitle <- map["WinnerTitle"];
        leagueWinningAmount <- map["LeagueWinningAmount"];
    }

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		autoHeaderID = dictionary["AutoHeaderID"] as? Int
		isPercentage = dictionary["IsPercentage"] as? Bool
		isPercentageWinners = dictionary["IsPercentageWinners"] as? String
		leagueFees = dictionary["LeagueFees"] as? Int
		leagueID = dictionary["LeagueID"] as? Int
		matchID = dictionary["MatchID"] as? Int
		rank = dictionary["Rank"] as? String
		teamPoint = dictionary["TeamPoint"] as? Double
		title = dictionary["Title"] as? String
		totalTeam = dictionary["TotalTeam"] as? Int
		winnerTitle = dictionary["WinnerTitle"] as? String
        leagueWinningAmount = dictionary["LeagueWinningAmount"] as? Int

	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if autoHeaderID != nil{
			dictionary["AutoHeaderID"] = autoHeaderID
		}
		if isPercentage != nil{
			dictionary["IsPercentage"] = isPercentage
		}
		if isPercentageWinners != nil{
			dictionary["IsPercentageWinners"] = isPercentageWinners
		}
		if leagueFees != nil{
			dictionary["LeagueFees"] = leagueFees
		}
		if leagueID != nil{
			dictionary["LeagueID"] = leagueID
		}
		if matchID != nil{
			dictionary["MatchID"] = matchID
		}
		if rank != nil{
			dictionary["Rank"] = rank
		}
		if teamPoint != nil{
			dictionary["TeamPoint"] = teamPoint
		}
		if title != nil{
			dictionary["Title"] = title
		}
		if totalTeam != nil{
			dictionary["TotalTeam"] = totalTeam
		}
		if winnerTitle != nil{
			dictionary["WinnerTitle"] = winnerTitle
		}
        if leagueWinningAmount != nil{
            dictionary["LeagueWinningAmount"] = leagueWinningAmount
        }
		return dictionary
	}

}
