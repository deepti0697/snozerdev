//
//	LoginModel.swift
//
//	Create by Cricshot#1 on 3/4/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper
import SwiftyJSON

class UserData : Mappable {
    
    var addressline1 : String!
    var addressline2 : String!
    var aws : Aw!
    var bankdetail : BankInfo?
    var city : UserState?
    var state : UserState?
    var country : String!
    var countryMobileCode : String?
    var dob : String?
    var email : String?
    var firstname : String!
    var image : String!
    var isEmailVerified : String!
    var isPhoneVerified : String!
    var isSocial : String!
    var lastname : String = ""
    var notificationCounter : String = "0"
    var pancard : PanInfo?
    var phone : String?
    var pincode : String!
    var referralCode : String!
    var used_referralCode : String!
    var settings : Setting!
    var slug : String!
    var socialType : String!
    var teamChange : String!
    var teamName : String!
    var wallet : UserWallet?
    var followerCount : String?
    var followingCount : String?
    var id : String!
    var postCount: String!
    
     var jsonObj : JSON!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        addressline1 <- map["addressline1"];
        addressline2 <- map["addressline2"]
        aws <- map["aws"];
        bankdetail <- map["bankdetail"];
        city <- map["city"];
        state <- map["state"];
        country <- map["country"];
        countryMobileCode <- map["country_mobile_code"];
        dob <- map["dob"];
        
        email <- map["email"];
        firstname <- map["firstname"]
        image <- map["image"];
        isEmailVerified <- map["is_email_verified"];
        isPhoneVerified <- map["is_phone_verified"];
        isSocial <- map["is_social"];
        lastname <- map["lastname"];
        notificationCounter <- map["notification_counter"];
        pancard <- map["pancard"];
        pincode <- map["pincode"];
        phone <- map["phone"];
        referralCode <- map["referral_code"]
        used_referralCode <- map["used_referral_code"]
        settings <- map["settings"];
        slug <- map["slug"];
        socialType <- map["social_type"];
        teamChange <- map["team_change"];
        teamName <- map["team_name"];
        wallet <- map["wallet"];
        postCount <- map["post_count"];
        followerCount <- map["follower_count"];
        followingCount <- map["following_count"];
        
        
    }
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        jsonObj = json
    }
}


class Aw : Mappable {
    
    var aWSBUCKET : String!
    var aWSKEY : String!
    var aWSREGION : String!
    var aWSSECRET : String!
    var bANKIMAGEPATH : String!
    var pANCARDIMAGEPATH : String!
    
    
    required init?(map: Map) {
    }
   
    func mapping(map: Map) {
       aWSBUCKET <- map["AWS_BUCKET"];
       aWSKEY <- map["AWS_KEY"]
       aWSREGION <- map["AWS_REGION"];
       aWSSECRET <- map["AWS_SECRET"];
       bANKIMAGEPATH <- map["BANK_IMAGE_PATH"];
       pANCARDIMAGEPATH <- map["PANCARD_IMAGE_PATH"];
    }
}

class UserState: Mappable {
    
    var id : String!
    var name : String!
    
    required init?(map: Map) {
     }
    
     func mapping(map: Map) {
        id <- map["id"];
        name <- map["name"]
     }
}

class Setting : Mappable {
    
    var cASHBONUSPERCENTAGES : String!
    var jOINCONTESTMESSAGE : String!
    var pROFILEUPDATEMESSAGE : String!
    var wINNINGBREAKUPMESSAGE : String!
    var wITHDRAWAMOUNTMAX : String!
    var wITHDRAWAMOUNTMIN : String!
    
    required init?(map: Map) {
     }
    
     func mapping(map: Map) {
        cASHBONUSPERCENTAGES <- map["CASH_BONUS_PERCENTAGES"];
        jOINCONTESTMESSAGE <- map["JOIN_CONTEST_MESSAGE"]
        pROFILEUPDATEMESSAGE <- map["PROFILE_UPDATE_MESSAGE"];
        wINNINGBREAKUPMESSAGE <- map["WINNING_BREAKUP_MESSAGE"]
        wITHDRAWAMOUNTMAX <- map["WITHDRAW_AMOUNT_MAX"];
        wITHDRAWAMOUNTMIN <- map["WITHDRAW_AMOUNT_MIN"]
     }
}


class UserWallet : Mappable{
    
    
    var bAmount : Any?
    var bonusWallet : Double{
        if let e = bAmount as? String{
            return Double(e)!;
        }
        if let e = bAmount as? Int{
            return Double(e);
        }
        if let e = bAmount as? Double{
            return e;
        }
        
        return 0;
    }
    var dAmount: Any?
    var depositWallet : Double{
        if let e = dAmount as? String{
            return Double(e)!;
        }
        if let e = dAmount as? Int{
            return Double(e);
        }
        if let e = dAmount as? Double{
            return e;
        }
        return 0;
    }
    var pWAmount: Any?
    var pendingWidAmount : Double{
        if let e = pWAmount as? String{
            return Double(e)!;
        }
        if let e = pWAmount as? Int{
            return Double(e);
        }
        
        if let e = pWAmount as? Double{
            return e;
        }
        
        return 0;
    }
    var wAmount: Any?
    var winningWallet : Double{
        if let e = wAmount as? String{
            return Double(e)!;
        }
        if let e = wAmount as? Int{
            return Double(e);
        }
        
        if let e = wAmount as? Double{
            return e;
        }
        return 0;
    }
    
    required init?(map: Map) {
     
    }
    
     func mapping(map: Map) {
        bAmount <- map["bonus_wallet"];
        dAmount <- map["deposit_wallet"]
        pWAmount <- map["pending_wid_amount"];
        wAmount <- map["winning_wallet"]
     }
}



class BankInfo : Mappable {
    
    var accountName : String!
    var accountNumber : String!
    var id : String!
    var ifsc : String!
    var image: String!
    var reason : String!
    var status: String!
    
    required init?(map: Map) {
     }
    
     func mapping(map: Map) {
        accountName <- map["account_holder_name"];
        accountNumber <- map["account_number"]
        id <- map["id"];
        ifsc <- map["ifsc"]
        
        image <- map["image"];
        reason <- map["reason"]
        status <- map["status"];
     }
}

class PanInfo : Mappable {
    
    var name : String!
    var dob : String!
    var id : String!
    var number : String!
    var image: String!
    var reason : String!
    var status: String!
    var state : UserState?
    
    required init?(map: Map) {
     }
    
     func mapping(map: Map) {
        name <- map["name"];
        number <- map["number"]
        id <- map["id"];
        dob <- map["dob"]
        
        image <- map["image"];
        reason <- map["reason"]
        status <- map["status"];
        state <- map["state"];
     }
}

class PlayingHistory : Mappable{
    
    var contests : Int!
    var matches : Int!
    var series : Int!
    var wins : Int!
    
    required init?(map: Map) {
     }
    
     func mapping(map: Map) {
        contests <- map["contests"];
        matches <- map["matches"]
        series <- map["series"];
        wins <- map["wins"]
     }
}
