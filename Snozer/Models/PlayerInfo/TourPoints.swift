//
//	TourPoints.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class TourPoints : NSObject, NSCoding, Mappable{

	var credits : Float!
	var matchPoints : [MatchPoint]!
	var playerImage : String!
	var playerName : String!
	var playerRole : String!
	var selectedBy : Float!
	var teamName : String!
	var totalPoints : Float!


    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        credits <- map["Credits"];
        matchPoints <- map["MatchPoints"]
        playerImage <- map["PlayerImage"];
        playerName <- map["PlayerName"];
        playerRole <- map["PlayerRole"];
        selectedBy <- map["SelectedBy"];
        teamName <- map["TeamName"];
        totalPoints <- map["TotalPoints"];
    }
    
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		credits = dictionary["Credits"] as? Float
		matchPoints = [MatchPoint]()
		if let matchPointsArray = dictionary["MatchPoints"] as? [[String:Any]]{
			for dic in matchPointsArray{
				let value = MatchPoint(fromDictionary: dic)
				matchPoints.append(value)
			}
		}
		playerImage = dictionary["PlayerImage"] as? String
		playerName = dictionary["PlayerName"] as? String
		playerRole = dictionary["PlayerRole"] as? String
		selectedBy = dictionary["SelectedBy"] as? Float
		teamName = dictionary["TeamName"] as? String
		totalPoints = dictionary["TotalPoints"] as? Float
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if credits != nil{
			dictionary["Credits"] = credits
		}
		if matchPoints != nil{
			var dictionaryElements = [[String:Any]]()
			for matchPointsElement in matchPoints {
				dictionaryElements.append(matchPointsElement.toDictionary())
			}
			dictionary["MatchPoints"] = dictionaryElements
		}
		if playerImage != nil{
			dictionary["PlayerImage"] = playerImage
		}
		if playerName != nil{
			dictionary["PlayerName"] = playerName
		}
		if playerRole != nil{
			dictionary["PlayerRole"] = playerRole
		}
		if selectedBy != nil{
			dictionary["SelectedBy"] = selectedBy
		}
		if teamName != nil{
			dictionary["TeamName"] = teamName
		}
		if totalPoints != nil{
			dictionary["TotalPoints"] = totalPoints
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         credits = aDecoder.decodeObject(forKey: "Credits") as? Float
         matchPoints = aDecoder.decodeObject(forKey :"MatchPoints") as? [MatchPoint]
         playerImage = aDecoder.decodeObject(forKey: "PlayerImage") as? String
         playerName = aDecoder.decodeObject(forKey: "PlayerName") as? String
         playerRole = aDecoder.decodeObject(forKey: "PlayerRole") as? String
         selectedBy = aDecoder.decodeObject(forKey: "SelectedBy") as? Float
         teamName = aDecoder.decodeObject(forKey: "TeamName") as? String
         totalPoints = aDecoder.decodeObject(forKey: "TotalPoints") as? Float

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if credits != nil{
			aCoder.encode(credits, forKey: "Credits")
		}
		if matchPoints != nil{
			aCoder.encode(matchPoints, forKey: "MatchPoints")
		}
		if playerImage != nil{
			aCoder.encode(playerImage, forKey: "PlayerImage")
		}
		if playerName != nil{
			aCoder.encode(playerName, forKey: "PlayerName")
		}
		if playerRole != nil{
			aCoder.encode(playerRole, forKey: "PlayerRole")
		}
		if selectedBy != nil{
			aCoder.encode(selectedBy, forKey: "SelectedBy")
		}
		if teamName != nil{
			aCoder.encode(teamName, forKey: "TeamName")
		}
		if totalPoints != nil{
			aCoder.encode(totalPoints, forKey: "TotalPoints")
		}

	}

}
