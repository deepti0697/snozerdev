//
//  ReferralDto.swift
//  Snozer
//
//  Created by Admin on 03/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import ObjectMapper

class ReferralDto: NSObject, Mappable {
    var referData: ReferDataDto?;
    var userReferData: [UserReferDto] = [];
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        referData <- map["refer_data"];
        userReferData <- map["user_refer_data"];
    }
}

class ReferDataDto: NSObject, Mappable {
    var image: String = "";
    var shareContent: String = "";
    var teamCount: String = "0";
    var teamEarn: String = "0";
    var title: String = "";
    var totalReceivedAmount: String = "0";
    var subTitle: String = "";
    var teamEarnCash: String = "";
   
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        image <- map["image"];
        shareContent <- map["share_content"];
        teamCount <- map["team_count"];
        teamEarn <- map["team_earn"];
        title <- map["title"];
        totalReceivedAmount <- map["total_received_amount"];
        subTitle <- map["subtitle"];
        teamEarnCash <- map["team_earn_cash"]
        
       
    }
}
class UserReferDto: NSObject, Mappable {
	var firstName = "";
	var lastName = "";
	var receiveAmount = "0";
	var teamName = "";
	var referralAmount = "0";
    var image: String = "";

        var amount: String = "";
      var commission: String = "";
      var contest_category: String = "";
      var entry_fees: String = "";
      var match_date: String = "";
      var match_name: String = "";

    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        firstName <- map["firstname"];
        image <- map["image"];
        lastName <- map["lastname"];
		receiveAmount <- map["received_referral_amount"];
        teamName <- map["team_name"];
        referralAmount <- map["used_refferal_amount"];
        
        // Cash Earning
               amount <- map["amount"]
               commission <- map["commission"]
               contest_category <- map["contest_category"]
               entry_fees <- map["entry_fees"]
               match_date <- map["match_date"]
               match_name <- map["match_name"]
              
    }
}
