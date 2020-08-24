//
//	ProfileUserInfo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class ProfileUserInfo : NSObject, NSCoding, Mappable{

	var address : String!
	var city : AnyObject!
	var dOB : String!
	var email : String!
	var gender : String!
	var isVerify : Bool!
	var name : String!
	var phoneNumber : String!
	var referCode : String!
	var state : String!
	var teamName : String!
	var userID : String!

    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        
        address <- map["Address"];
        city <- map["City"];
        dOB <- map["DOB"];
        email <- map["Email"];
        gender <- map["Gender"];
        isVerify <- map["IsVerify"];
        name <- map["Name"];
        phoneNumber <- map["PhoneNumber"];
        referCode <- map["ReferCode"];
        state <- map["State"];
        teamName <- map["TeamName"];
        userID <- map["UserID"];
        
    }
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		address = dictionary["Address"] as? String ?? ""
		city = dictionary["City"] as AnyObject
		dOB = dictionary["DOB"] as? String ?? ""
		email = dictionary["Email"] as? String ?? ""
		gender = dictionary["Gender"] as? String ?? ""
		isVerify = dictionary["IsVerify"] as? Bool
		name = dictionary["Name"] as? String ?? ""
		phoneNumber = dictionary["PhoneNumber"] as? String ?? ""
		referCode = dictionary["ReferCode"] as? String ?? ""
		state = dictionary["State"] as? String ?? ""
		teamName = dictionary["TeamName"] as? String ?? ""
		userID = dictionary["UserID"] as? String ?? ""
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if address != nil{
			dictionary["Address"] = address
		}
		if city != nil{
			dictionary["City"] = city
		}
		if dOB != nil{
			dictionary["DOB"] = dOB
		}
		if email != nil{
			dictionary["Email"] = email
		}
		if gender != nil{
			dictionary["Gender"] = gender
		}
		if isVerify != nil{
			dictionary["IsVerify"] = isVerify
		}
		if name != nil{
			dictionary["Name"] = name
		}
		if phoneNumber != nil{
			dictionary["PhoneNumber"] = phoneNumber
		}
		if referCode != nil{
			dictionary["ReferCode"] = referCode
		}
		if state != nil{
			dictionary["State"] = state
		}
		if teamName != nil{
			dictionary["TeamName"] = teamName
		}
		if userID != nil{
			dictionary["UserID"] = userID
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         address = aDecoder.decodeObject(forKey: "Address") as? String
         city = aDecoder.decodeObject(forKey: "City") as AnyObject
         dOB = aDecoder.decodeObject(forKey: "DOB") as? String
         email = aDecoder.decodeObject(forKey: "Email") as? String
         gender = aDecoder.decodeObject(forKey: "Gender") as? String
         isVerify = aDecoder.decodeObject(forKey: "IsVerify") as? Bool
         name = aDecoder.decodeObject(forKey: "Name") as? String
         phoneNumber = aDecoder.decodeObject(forKey: "PhoneNumber") as? String
         referCode = aDecoder.decodeObject(forKey: "ReferCode") as? String
         state = aDecoder.decodeObject(forKey: "State") as? String
         teamName = aDecoder.decodeObject(forKey: "TeamName") as? String
         userID = aDecoder.decodeObject(forKey: "UserID") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if address != nil{
			aCoder.encode(address, forKey: "Address")
		}
		if city != nil{
			aCoder.encode(city, forKey: "City")
		}
		if dOB != nil{
			aCoder.encode(dOB, forKey: "DOB")
		}
		if email != nil{
			aCoder.encode(email, forKey: "Email")
		}
		if gender != nil{
			aCoder.encode(gender, forKey: "Gender")
		}
		if isVerify != nil{
			aCoder.encode(isVerify, forKey: "IsVerify")
		}
		if name != nil{
			aCoder.encode(name, forKey: "Name")
		}
		if phoneNumber != nil{
			aCoder.encode(phoneNumber, forKey: "PhoneNumber")
		}
		if referCode != nil{
			aCoder.encode(referCode, forKey: "ReferCode")
		}
		if state != nil{
			aCoder.encode(state, forKey: "State")
		}
		if teamName != nil{
			aCoder.encode(teamName, forKey: "TeamName")
		}
		if userID != nil{
			aCoder.encode(userID, forKey: "UserID")
		}

	}

}
