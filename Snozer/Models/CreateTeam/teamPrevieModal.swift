//
//	teamPrevieModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct teamPrevieModal: Mappable{

	var matchDetailId : Int!
	var matchScheduleId : Int!
	var playerCatID : Int!
	var playerId : Int!
	var playerPoint : Int!
	var playerRole : String!
	var playerCategory : String!
	var playerPoints : Double!
	var playerShortName : String!
	var teamPoints : Double!
	var teamSno : Int!
	var teamCode : String!
	var teamImage : String!
	var totalNewPoint : Double!
	var userId : Int!
	var userTeamID : Int!
	var userTeamPlayersPoints : AnyObject!
	var userTeamVMList : AnyObject!
    var image : String!


    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        matchDetailId <- map["MatchDetailId"];
        matchScheduleId <- map["MatchScheduleId"]
        playerCatID <- map["PlayerCatID"];
        playerId <- map["PlayerId"];
        playerPoint <- map["PlayerPoint"];
        playerRole <- map["PlayerRole"];
        playerCategory <- map["Player_Category"];
        playerPoints <- map["Player_Points"];
        playerShortName <- map["Player_ShortName"];
        
        teamPoints <- map["TeamPoints"];
        teamSno <- map["TeamSno"]
        teamCode <- map["Team_Code"]
        teamImage <- map["Team_Image"];
        totalNewPoint <- map["TotalNewPoint"];
        userId <- map["UserId"];
        userTeamID <- map["UserTeamID"];
        userTeamPlayersPoints <- map["UserTeamPlayersPoints"];
        userTeamVMList <- map["UserTeamVMList"];
        image <- map["Image"];
        
    }
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		matchDetailId = dictionary["MatchDetailId"] as? Int
		matchScheduleId = dictionary["MatchScheduleId"] as? Int
		playerCatID = dictionary["PlayerCatID"] as? Int
		playerId = dictionary["PlayerId"] as? Int
		playerPoint = dictionary["PlayerPoint"] as? Int
		playerRole = dictionary["PlayerRole"] as? String
		playerCategory = dictionary["Player_Category"] as? String
		playerPoints = dictionary["Player_Points"] as? Double
		playerShortName = dictionary["Player_ShortName"] as? String
		teamPoints = dictionary["TeamPoints"] as? Double
		teamSno = dictionary["TeamSno"] as? Int
		teamCode = dictionary["Team_Code"] as? String
		teamImage = dictionary["Team_Image"] as? String
        image = dictionary["Image"] as? String
		totalNewPoint = dictionary["TotalNewPoint"] as? Double
		userId = dictionary["UserId"] as? Int
		userTeamID = dictionary["UserTeamID"] as? Int
		userTeamPlayersPoints = dictionary["UserTeamPlayersPoints"] as AnyObject
		userTeamVMList = dictionary["UserTeamVMList"] as AnyObject

	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if matchDetailId != nil{
			dictionary["MatchDetailId"] = matchDetailId
		}
		if matchScheduleId != nil{
			dictionary["MatchScheduleId"] = matchScheduleId
		}
		if playerCatID != nil{
			dictionary["PlayerCatID"] = playerCatID
		}
		if playerId != nil{
			dictionary["PlayerId"] = playerId
		}
		if playerPoint != nil{
			dictionary["PlayerPoint"] = playerPoint
		}
		if playerRole != nil{
			dictionary["PlayerRole"] = playerRole
		}
		if playerCategory != nil{
			dictionary["Player_Category"] = playerCategory
		}
		if playerPoints != nil{
			dictionary["Player_Points"] = playerPoints
		}
		if playerShortName != nil{
			dictionary["Player_ShortName"] = playerShortName
		}
		if teamPoints != nil{
			dictionary["TeamPoints"] = teamPoints
		}
		if teamSno != nil{
			dictionary["TeamSno"] = teamSno
		}
		if teamCode != nil{
			dictionary["Team_Code"] = teamCode
		}
		if teamImage != nil{
			dictionary["Team_Image"] = teamImage
		}
        if image != nil{
            dictionary["Image"] = image
        }
		if totalNewPoint != nil{
			dictionary["TotalNewPoint"] = totalNewPoint
		}
		if userId != nil{
			dictionary["UserId"] = userId
		}
		if userTeamID != nil{
			dictionary["UserTeamID"] = userTeamID
		}
		if userTeamPlayersPoints != nil{
			dictionary["UserTeamPlayersPoints"] = userTeamPlayersPoints
		}
		if userTeamVMList != nil{
			dictionary["UserTeamVMList"] = userTeamVMList
		}
       
		return dictionary
	}

}
