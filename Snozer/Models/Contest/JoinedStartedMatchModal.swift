//
//	JoinedStartedMatchModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


struct JoinedStartedMatchModal : Mappable{

	var currentTime : AnyObject!
	var leagueLiveData : [LeagueLiveData]!
	var matchID : Int!
	var matchName : String!
	var status : String!

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        currentTime <- map["CurrentTime"];
        leagueLiveData <- map["LeagueLiveData"]
        matchID <- map["MatchID"];
        matchName <- map["MatchName"];
        status <- map["Status"];
    }

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		currentTime = dictionary["CurrentTime"] as? AnyObject
		leagueLiveData = [LeagueLiveData]()
		if let leagueLiveDataArray = dictionary["LeagueLiveData"] as? [[String:Any]]{
			for dic in leagueLiveDataArray{
				let value = LeagueLiveData(fromDictionary: dic)
				leagueLiveData.append(value)
			}
		}
		matchID = dictionary["MatchID"] as? Int
		matchName = dictionary["MatchName"] as? String
		status = dictionary["Status"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if currentTime != nil{
			dictionary["CurrentTime"] = currentTime
		}
		if leagueLiveData != nil{
			var dictionaryElements = [[String:Any]]()
			for leagueLiveDataElement in leagueLiveData {
				dictionaryElements.append(leagueLiveDataElement.toDictionary())
			}
			dictionary["LeagueLiveData"] = dictionaryElements
		}
		if matchID != nil{
			dictionary["MatchID"] = matchID
		}
		if matchName != nil{
			dictionary["MatchName"] = matchName
		}
		if status != nil{
			dictionary["Status"] = status
		}
		return dictionary
	}

}


struct LiveScore : Mappable{
    
    var matchId : Int!
    var result : String!
    var team1Flag : String!
    var team1Name : String!
    var team1Overs : Double!
    var team1Score : Int!
    var team1Wicket : Int!
    var team2Flag : String!
    var team2Name : String!
    var team2Overs : Double!
    var team2Score : Int!
    var team2Wicket : Int!
    
    init?(map: Map) {
        
    }
    
    
    mutating func mapping(map: Map) {
        
        matchId <- map["MatchId"];
        result <- map["Result"]
        team1Flag <- map["Team1Flag"];
        team1Name <- map["Team1Name"];
        team1Overs <- map["Team1Overs"];
        
        team1Score <- map["Team1Score"];
        team1Wicket <- map["Team1Wicket"]
        team2Flag <- map["Team2Flag"];
        team2Name <- map["Team2Name"];
        team2Overs <- map["Team2Overs"];
        
        team2Score <- map["Team2Score"];
        team2Wicket <- map["Team2Wicket"];
    }
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        matchId = dictionary["MatchId"] as? Int
        result = dictionary["Result"] as? String
        team1Flag = dictionary["Team1Flag"] as? String
        team1Name = dictionary["Team1Name"] as? String
        team1Overs = dictionary["Team1Overs"] as? Double
        team1Score = dictionary["Team1Score"] as? Int
        team1Wicket = dictionary["Team1Wicket"] as? Int
        team2Flag = dictionary["Team2Flag"] as? String
        team2Name = dictionary["Team2Name"] as? String
        team2Overs = dictionary["Team2Overs"] as? Double
        team2Score = dictionary["Team2Score"] as? Int
        team2Wicket = dictionary["Team2Wicket"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if matchId != nil{
            dictionary["MatchId"] = matchId
        }
        if result != nil{
            dictionary["Result"] = result
        }
        if team1Flag != nil{
            dictionary["Team1Flag"] = team1Flag
        }
        if team1Name != nil{
            dictionary["Team1Name"] = team1Name
        }
        if team1Overs != nil{
            dictionary["Team1Overs"] = team1Overs
        }
        if team1Score != nil{
            dictionary["Team1Score"] = team1Score
        }
        if team1Wicket != nil{
            dictionary["Team1Wicket"] = team1Wicket
        }
        if team2Flag != nil{
            dictionary["Team2Flag"] = team2Flag
        }
        if team2Name != nil{
            dictionary["Team2Name"] = team2Name
        }
        if team2Overs != nil{
            dictionary["Team2Overs"] = team2Overs
        }
        if team2Score != nil{
            dictionary["Team2Score"] = team2Score
        }
        if team2Wicket != nil{
            dictionary["Team2Wicket"] = team2Wicket
        }
        return dictionary
    }
    
}
