//
//	MatchPoint.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class MatchPoint : NSObject, NSCoding, Mappable{

	var matchDate : String!
	var matchName : String!
	var points : Float!
	var selectedBy : Float!
    
    
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        matchDate <- map["MatchDate"];
        matchName <- map["MatchName"];
        points <- map["Points"];
        selectedBy <- map["SelectedBy"];
    }
    

//    var teamName : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		matchDate = dictionary["MatchDate"] as? String
		matchName = dictionary["MatchName"] as? String
		points = dictionary["Points"] as? Float
		selectedBy = dictionary["SelectedBy"] as? Float
//        teamName = dictionary["TeamName"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if matchDate != nil{
			dictionary["MatchDate"] = matchDate
		}
		if matchName != nil{
			dictionary["MatchName"] = matchName
		}
		if points != nil{
			dictionary["Points"] = points
		}
		if selectedBy != nil{
			dictionary["SelectedBy"] = selectedBy
		}
//        if teamName != nil{
//            dictionary["TeamName"] = teamName
//        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         matchDate = aDecoder.decodeObject(forKey: "MatchDate") as? String
         matchName = aDecoder.decodeObject(forKey: "MatchName") as? String
         points = aDecoder.decodeObject(forKey: "Points") as? Float
         selectedBy = aDecoder.decodeObject(forKey: "SelectedBy") as? Float
//         teamName = aDecoder.decodeObject(forKey: "TeamName") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if matchDate != nil{
			aCoder.encode(matchDate, forKey: "MatchDate")
		}
		if matchName != nil{
			aCoder.encode(matchName, forKey: "MatchName")
		}
		if points != nil{
			aCoder.encode(points, forKey: "Points")
		}
		if selectedBy != nil{
			aCoder.encode(selectedBy, forKey: "SelectedBy")
		}
//        if teamName != nil{
//            aCoder.encode(teamName, forKey: "TeamName")
//        }

	}

}
