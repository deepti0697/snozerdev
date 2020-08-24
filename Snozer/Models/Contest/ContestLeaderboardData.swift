//
//  ContestLeaderboardData.swift
//  Snozer
//
//  Created by Admin on 17/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import ObjectMapper


class ContestLeaderboardData: Mappable {
    var customerId : String!
    var customerTeamName : String!
    var firstname : String!
    var image : String!
    var lastname : String = ""
    var newRank : String = "0"
    var oldRank : String = "0"
    var refundAmount : String = "0"
    var teamId : String!
    var teamName : String = ""
    var totalPoints : String = "0"
    var winAmount : Int = 0
    var ismyTeam : Bool = false
    var taxAmount : String = ""
    var entryFee : String = "0";

    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        customerId <- map["customer_id"]
        customerTeamName <- map["customer_team_name"]
        firstname <- map["firstname"]
        image <- map["image"]
        lastname <- map["lastname"]
        newRank <- map["new_rank"]
        oldRank <- map["old_rank"]
        refundAmount <- map["refund_amount"]
        teamId <- map["team_id"]
        teamName <- map["team_name"]
        totalPoints <- map["total_points"]
        winAmount <- map["win_amount"]
        taxAmount <- map["tax_amount"]
        entryFee <- map["user_entry_fees"]
    }
}
