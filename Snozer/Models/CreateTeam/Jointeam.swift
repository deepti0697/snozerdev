//
//	Jointeam.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class Jointeam : Mappable {
    
    var id : String!
    var name : String!
    var team1 : Team!
    var team2 : Team!
    var caption : PlayerData!
    var vcCaption : PlayerData!
    var batsmans : [PlayerData]!
    var bowlers : [PlayerData]!
    var show : Bool!
    var wicketkeapers : [PlayerData]!
    var allrounders : [PlayerData]!

    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        
        id <- map["id"];
        name <- map["name"]
        team1 <- map["team1"];
        team2 <- map["team2"];
        caption <- map["captain"];
        vcCaption <- map["vise_captain"];
        
        batsmans <- map["batsmans"];
        allrounders <- map["allrounders"]
        bowlers <- map["bowlers"];
        wicketkeapers <- map["wicketkeapers"];
    }
}
