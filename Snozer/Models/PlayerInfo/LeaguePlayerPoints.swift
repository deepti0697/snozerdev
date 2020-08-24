//
//	LeaguePlayerPoints.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class LeaguePlayerPoints : NSObject, NSCoding, Mappable{

	var cP : Float!
	var isSelected : Bool!
	var playerId : Int!
	var playerImage : String!
	var playerName : String!
	var points : Float!
	var selectionP : Double!
	var vCP : Float!


    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        cP <- map["CP"];
        isSelected <- map["IsSelected"];
        playerId <- map["PlayerId"];
        playerImage <- map["PlayerImage"];
        playerName <- map["PlayerName"];
        points <- map["Points"];        
        selectionP <- map["SelectionP"];
        vCP <- map["VCP"];
        
    }
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		cP = dictionary["CP"] as? Float
		isSelected = dictionary["IsSelected"] as? Bool
		playerId = dictionary["PlayerId"] as? Int
		playerImage = dictionary["PlayerImage"] as? String
		playerName = dictionary["PlayerName"] as? String
		points = dictionary["Points"] as? Float
		selectionP = dictionary["SelectionP"] as? Double
		vCP = dictionary["VCP"] as? Float
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if cP != nil{
			dictionary["CP"] = cP
		}
		if isSelected != nil{
			dictionary["IsSelected"] = isSelected
		}
		if playerId != nil{
			dictionary["PlayerId"] = playerId
		}
		if playerImage != nil{
			dictionary["PlayerImage"] = playerImage
		}
		if playerName != nil{
			dictionary["PlayerName"] = playerName
		}
		if points != nil{
			dictionary["Points"] = points
		}
		if selectionP != nil{
			dictionary["SelectionP"] = selectionP
		}
		if vCP != nil{
			dictionary["VCP"] = vCP
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cP = aDecoder.decodeObject(forKey: "CP") as? Float
         isSelected = aDecoder.decodeObject(forKey: "IsSelected") as? Bool
         playerId = aDecoder.decodeObject(forKey: "PlayerId") as? Int
         playerImage = aDecoder.decodeObject(forKey: "PlayerImage") as? String
         playerName = aDecoder.decodeObject(forKey: "PlayerName") as? String
         points = aDecoder.decodeObject(forKey: "Points") as? Float
         selectionP = aDecoder.decodeObject(forKey: "SelectionP") as? Double
         vCP = aDecoder.decodeObject(forKey: "VCP") as? Float

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if cP != nil{
			aCoder.encode(cP, forKey: "CP")
		}
		if isSelected != nil{
			aCoder.encode(isSelected, forKey: "IsSelected")
		}
		if playerId != nil{
			aCoder.encode(playerId, forKey: "PlayerId")
		}
		if playerImage != nil{
			aCoder.encode(playerImage, forKey: "PlayerImage")
		}
		if playerName != nil{
			aCoder.encode(playerName, forKey: "PlayerName")
		}
		if points != nil{
			aCoder.encode(points, forKey: "Points")
		}
		if selectionP != nil{
			aCoder.encode(selectionP, forKey: "SelectionP")
		}
		if vCP != nil{
			aCoder.encode(vCP, forKey: "VCP")
		}

	}

}
