//
//	AccountInfo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class AccountInfo : NSObject, Mappable, NSCoding{

	var accountNumber : String!
	var accounts : [BankAccountInfo]!
	var emailId : String!
	var isAccountSubmitted : Bool!
	var isAccountVerified : Bool!
	var isEmailVerify : Bool!
	var isMobileVerify : Bool!
	var isPanCardVerify : Bool!
	var isPancardSubmitted : Bool!
	var mobileNo : String!
	var pancardNumber : String!
	var tokenExpire : Bool!
    var name : String!
    var teamName : String!
    var gender : String!

    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        accountNumber <- map["AccountNumber"];
        accounts <- map["Accounts"];
        emailId <- map["EmailId"];
        isAccountSubmitted <- map["IsAccountSubmitted"];
        isAccountVerified <- map["IsAccountVerified"];
        isEmailVerify <- map["IsEmailVerify"];
        isMobileVerify <- map["IsMobileVerify"];
        isPanCardVerify <- map["IsPanCardVerify"];
        isPancardSubmitted <- map["IsPancardSubmitted"];
        mobileNo <- map["MobileNo"];
        pancardNumber <- map["PancardNumber"];
        tokenExpire <- map["TokenExpire"];
        name <- map["Name"];
        teamName <- map["TeamName"];
        gender <- map["Gender"];
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         accountNumber = aDecoder.decodeObject(forKey: "AccountNumber") as? String
         accounts = aDecoder.decodeObject(forKey :"Accounts") as? [BankAccountInfo]
         emailId = aDecoder.decodeObject(forKey: "EmailId") as? String
         isAccountSubmitted = aDecoder.decodeObject(forKey: "IsAccountSubmitted") as? Bool
         isAccountVerified = aDecoder.decodeObject(forKey: "IsAccountVerified") as? Bool
         isEmailVerify = aDecoder.decodeObject(forKey: "IsEmailVerify") as? Bool
         isMobileVerify = aDecoder.decodeObject(forKey: "IsMobileVerify") as? Bool
         isPanCardVerify = aDecoder.decodeObject(forKey: "IsPanCardVerify") as? Bool
         isPancardSubmitted = aDecoder.decodeObject(forKey: "IsPancardSubmitted") as? Bool
         mobileNo = aDecoder.decodeObject(forKey: "MobileNo") as? String
         pancardNumber = aDecoder.decodeObject(forKey: "PancardNumber") as? String
         tokenExpire = aDecoder.decodeObject(forKey: "TokenExpire") as? Bool
        name = aDecoder.decodeObject(forKey: "Name") as? String
        teamName = aDecoder.decodeObject(forKey: "TeamName") as? String


	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if accountNumber != nil{
			aCoder.encode(accountNumber, forKey: "AccountNumber")
		}
		if accounts != nil{
			aCoder.encode(accounts, forKey: "Accounts")
		}
		if emailId != nil{
			aCoder.encode(emailId, forKey: "EmailId")
		}
		if isAccountSubmitted != nil{
			aCoder.encode(isAccountSubmitted, forKey: "IsAccountSubmitted")
		}
		if isAccountVerified != nil{
			aCoder.encode(isAccountVerified, forKey: "IsAccountVerified")
		}
		if isEmailVerify != nil{
			aCoder.encode(isEmailVerify, forKey: "IsEmailVerify")
		}
		if isMobileVerify != nil{
			aCoder.encode(isMobileVerify, forKey: "IsMobileVerify")
		}
		if isPanCardVerify != nil{
			aCoder.encode(isPanCardVerify, forKey: "IsPanCardVerify")
		}
		if isPancardSubmitted != nil{
			aCoder.encode(isPancardSubmitted, forKey: "IsPancardSubmitted")
		}
		if mobileNo != nil{
			aCoder.encode(mobileNo, forKey: "MobileNo")
		}
		if pancardNumber != nil{
			aCoder.encode(pancardNumber, forKey: "PancardNumber")
		}
		if tokenExpire != nil{
			aCoder.encode(tokenExpire, forKey: "TokenExpire")
		}
        if name != nil{
            aCoder.encode(name, forKey: "Name")
        }
        if teamName != nil{
            aCoder.encode(teamName, forKey: "TeamName")
        }
	}

}
