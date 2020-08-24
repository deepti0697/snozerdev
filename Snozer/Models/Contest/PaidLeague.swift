//
//	PaidLeague.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class ContestPool:NSObject, Mappable{
    
    var confirmWin : String!
    var eFees : Any?
    
    var entryFees : Double{
        if let e = eFees as? String{
            return Double(e)!;
        }
        if let e = eFees as? Int{
            return Double(e);
        }
        if let e = eFees as? Double{
            return e;
        }
        
        return 0;
    }
    
    var mEFee: Any?
    
    var moreEntryFee : Double{
        if let e = mEFee as? String{
            return Double(e)!;
        }
        if let e = mEFee as? Int{
            return Double(e);
        }
        if let e = mEFee as? Double{
            return e;
        }
        
        return 0;
    }
    
    var aEFees :  Any?
    
    var actualEntryFees : Double{
        if let e = aEFees as? String{
            return Double(e)!;
        }
        if let e = aEFees as? Int{
            return Double(e);
        }
        if let e = aEFees as? Double{
            return e;
        }
        
        return 0;
    }
    
    var maxEFees: Any?
    
    var maxEntryFees : Double{
        if let e = maxEFees as? String{
            return Double(e)!;
        }
        if let e = maxEFees as? Int{
            return Double(e);
        }
        if let e = maxEFees as? Double{
            return e;
        }        
        return 0;
    }
    
    
    var id : String!
    var joinedTeams : String = "";
    var joinedTeamsName : String!
    var matchContestId : String!
    var perUserTeamAllowed : String = "1"
    var totalPrice : String = "0"
    var totalTeam : String = "0"
    var totalTeamLeft : Int = 0
    var totalWinners : String = "0"
    var myteams : [Myteam] = [];
    var entryFeeMultiplier : String = "1"
    var discountImage: String = ""
    
    var isBeatTheExpert: String = "N"
    var eFSuggest : [Any?] = []
    var entryFeesSuggest : [Double]{
        if let _ = eFSuggest.first as? String{
            let arrOfDoubles = eFSuggest.map { (value) -> String in
                return String(describing: value ?? "")
            }
            return arrOfDoubles.map { (value) -> Double in
                return Double(value)!
            }
        }
        if let _ = eFSuggest.first as? Int{
            return eFSuggest.map({Double($0 as! Int)})
        }
        
        if let _ = eFSuggest.first as? Double{
            return eFSuggest.map({Double($0 as! Double)})
        }

        
        return [];
    }
    
    var slug: String = "";
    
    var multiTeamAllowed : String = "N";
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        confirmWin <- map["confirm_win"];
        eFees <- map["entry_fees"]
        id <- map["id"];
        joinedTeams <- map["joined_teams"];
        joinedTeamsName <- map["joined_teams_name"];
        matchContestId <- map["match_contest_id"];
        perUserTeamAllowed <- map["per_user_team_allowed"];
        totalPrice <- map["total_price"];
        totalTeam <- map["total_team"];
        totalTeamLeft <- map["total_team_left"];
        totalWinners <- map["total_winners"];
        myteams <- map["myteams"];
        entryFeeMultiplier <- map["entry_fee_multiplier"];
        multiTeamAllowed <- map["multi_team_allowed"]
        discountImage <- map["discount_image"];
        mEFee <- map["more_entry_fees"];
        isBeatTheExpert <- map["is_beat_the_expert"];
        eFSuggest <- map["entry_fees_suggest"];
        maxEFees <- map["max_entry_fees"];
        slug <- map["slug"];
        aEFees <- map["actual_entry_fees"];
        
    }
}

class WinningBreakUpModal : Mappable {
    var winnerBreakup : WinnerBreakup!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        winnerBreakup <- map["winner_breakup"];
    }
    
}


class WinnerBreakup: Mappable {
    
    var perMaxP : [String]!
    var perMinP : [String]!
    var perPrice : [String]!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        perMaxP <- map["per_max_p"];
        perMinP <- map["per_min_p"];
        perPrice <- map["per_price"];
    }
}


class Myteam: Mappable {
    
    var newRank : String = "0"
    var refundAmount : String = "0"
    var teamId : String!
    var teamName : String!
    var totalPoints : String = "0"
    var winAmount : Int = 0
    
    required init?(map: Map) {
    }
       
    
    func mapping(map: Map) {
        
        newRank <- map["new_rank"];
        refundAmount <- map["refund_amount"]
        teamId <- map["team_id"];
        teamName <- map["team_name"];
        totalPoints <- map["total_points"]
        winAmount <- map["win_amount"];
    }
}
