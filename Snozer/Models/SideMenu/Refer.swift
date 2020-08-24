//
//	Refer.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class Refer : NSObject, NSCoding, Mappable{

	var amount : Int!
	var getAmountuser : Int!
	var remaningAmount : Int!
	var teamName : String!

    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        amount <- map["Amount"];
        getAmountuser <- map["GetAmountuser"];
        remaningAmount <- map["RemaningAmount"];
        teamName <- map["Name"];
    }
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		amount = dictionary["Amount"] as? Int ?? 0
		getAmountuser = dictionary["GetAmountuser"] as? Int ?? 0
		remaningAmount = dictionary["RemaningAmount"] as? Int ?? 0
		teamName = dictionary["Name"] as? String ?? ""
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if amount != nil{
			dictionary["Amount"] = amount
		}
		if getAmountuser != nil{
			dictionary["GetAmountuser"] = getAmountuser
		}
		if remaningAmount != nil{
			dictionary["RemaningAmount"] = remaningAmount
		}
		if teamName != nil{
			dictionary["Name"] = teamName
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         amount = aDecoder.decodeObject(forKey: "Amount") as? Int
         getAmountuser = aDecoder.decodeObject(forKey: "GetAmountuser") as? Int
         remaningAmount = aDecoder.decodeObject(forKey: "RemaningAmount") as? Int
         teamName = aDecoder.decodeObject(forKey: "Name") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if amount != nil{
			aCoder.encode(amount, forKey: "Amount")
		}
		if getAmountuser != nil{
			aCoder.encode(getAmountuser, forKey: "GetAmountuser")
		}
		if remaningAmount != nil{
			aCoder.encode(remaningAmount, forKey: "RemaningAmount")
		}
		if teamName != nil{
			aCoder.encode(teamName, forKey: "Name")
		}

	}

}
