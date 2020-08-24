//
//	BankAccountInfo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class BankAccountInfo : NSObject, Mappable ,NSCoding{

	var accountNumber : String!
	var bankName : String!
	var branch : String!
	var email : String!
	var iD : Int!
	var iFSC : String!
	var images : String!
	var isAdminVerified : Bool!


    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        accountNumber <- map["AccountNumber"];
        bankName <- map["BankName"];
        email <- map["Email"];
        branch <- map["Branch"];
        iD <- map["ID"];
        iFSC <- map["IFSC"];
        images <- map["Images"];
        isAdminVerified <- map["IsAdminVerified"];
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         accountNumber = aDecoder.decodeObject(forKey: "AccountNumber") as? String
         bankName = aDecoder.decodeObject(forKey: "BankName") as? String
         branch = aDecoder.decodeObject(forKey: "Branch") as? String
         email = aDecoder.decodeObject(forKey: "Email") as? String
         iD = aDecoder.decodeObject(forKey: "ID") as? Int
         iFSC = aDecoder.decodeObject(forKey: "IFSC") as? String
         images = aDecoder.decodeObject(forKey: "Images") as? String
         isAdminVerified = aDecoder.decodeObject(forKey: "IsAdminVerified") as? Bool

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
		if bankName != nil{
			aCoder.encode(bankName, forKey: "BankName")
		}
		if branch != nil{
			aCoder.encode(branch, forKey: "Branch")
		}
		if email != nil{
			aCoder.encode(email, forKey: "Email")
		}
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if iFSC != nil{
			aCoder.encode(iFSC, forKey: "IFSC")
		}
		if images != nil{
			aCoder.encode(images, forKey: "Images")
		}
		if isAdminVerified != nil{
			aCoder.encode(isAdminVerified, forKey: "IsAdminVerified")
		}

	}

}
