//
//	ContestCompleteDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


struct ContestCompleteDetail : Mappable{

	var c : Bool!
	var currentTime : String!
	var fee : Int!
	var isPercentage : Bool!
	var isPercentageWinners : String!
	var isPrivate : Bool!
	var leaugeDetails : [LeaugeDetail]!
	var m : Bool!
	var referCode : String!
	var startDate : String!
	var status : String!
	var totalAmount : Int!
	var totalJoined : Int!
	var totalMember : Int!
	var winner : Int!
    var title : String!

    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        
        c <- map["C"];
        currentTime <- map["CurrentTime"]
        fee <- map["Fee"];
        isPercentage <- map["IsPercentage"];
        isPercentageWinners <- map["IsPercentageWinners"];
        isPrivate <- map["IsPrivate"];
        leaugeDetails <- map["LeaugeDetails"];
        m <- map["M"];
        referCode <- map["ReferCode"];
        startDate <- map["StartDate"]
        status <- map["Status"];
        totalAmount <- map["TotalAmount"];
        totalJoined <- map["TotalJoined"];
        totalMember <- map["TotalMember"];
        winner <- map["Winner"];
        title <- map["Title"];
        
        
        
    }
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		c = dictionary["C"] as? Bool
		currentTime = dictionary["CurrentTime"] as? String
		fee = dictionary["Fee"] as? Int
		isPercentage = dictionary["IsPercentage"] as? Bool
		isPercentageWinners = dictionary["IsPercentageWinners"] as? String
		isPrivate = dictionary["IsPrivate"] as? Bool
		leaugeDetails = [LeaugeDetail]()
		if let leaugeDetailsArray = dictionary["LeaugeDetails"] as? [[String:Any]]{
			for dic in leaugeDetailsArray{
				let value = LeaugeDetail(fromDictionary: dic)
				leaugeDetails.append(value)
			}
		}
		m = dictionary["M"] as? Bool
		referCode = dictionary["ReferCode"] as? String
		startDate = dictionary["StartDate"] as? String
		status = dictionary["Status"] as? String
		totalAmount = dictionary["TotalAmount"] as? Int
		totalJoined = dictionary["TotalJoined"] as? Int
		totalMember = dictionary["TotalMember"] as? Int
		winner = dictionary["Winner"] as? Int
        title = dictionary["Title"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if c != nil{
			dictionary["C"] = c
		}
		if currentTime != nil{
			dictionary["CurrentTime"] = currentTime
		}
		if fee != nil{
			dictionary["Fee"] = fee
		}
		if isPercentage != nil{
			dictionary["IsPercentage"] = isPercentage
		}
		if isPercentageWinners != nil{
			dictionary["IsPercentageWinners"] = isPercentageWinners
		}
		if isPrivate != nil{
			dictionary["IsPrivate"] = isPrivate
		}
		if leaugeDetails != nil{
			var dictionaryElements = [[String:Any]]()
			for leaugeDetailsElement in leaugeDetails {
				dictionaryElements.append(leaugeDetailsElement.toDictionary())
			}
			dictionary["LeaugeDetails"] = dictionaryElements
		}
		if m != nil{
			dictionary["M"] = m
		}
		if referCode != nil{
			dictionary["ReferCode"] = referCode
		}
		if startDate != nil{
			dictionary["StartDate"] = startDate
		}
		if status != nil{
			dictionary["Status"] = status
		}
		if totalAmount != nil{
			dictionary["TotalAmount"] = totalAmount
		}
		if totalJoined != nil{
			dictionary["TotalJoined"] = totalJoined
		}
		if totalMember != nil{
			dictionary["TotalMember"] = totalMember
		}
		if winner != nil{
			dictionary["Winner"] = winner
		}
        if title != nil{
            dictionary["Title"] = title
        }
		return dictionary
	}

}
