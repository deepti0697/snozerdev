//
//  MatchScoreDto.swift
//  Snozer
//
//  Created by Admin on 23/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import ObjectMapper

class MatchScoreDto: NSObject, Mappable {
    var notes: String = "";
    var team1: TeamScoreDto?;
    var team2: TeamScoreDto?;
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        notes <- map["score_board_notes"];
        team1 <- map["team1"];
        team2 <- map["team2"];
       
    }
}

class TeamScoreDto: NSObject, Mappable {
    var id: String = "";
    var name: String = "";
    var sortName: String = "";
    var teamOvers: String = "";
    var teamRun: String = "";
    var teamWicket: String = "";
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"];
        name <- map["name"];
        sortName <- map["sort_name"];
        teamOvers <- map["team_overs"];
        teamRun <- map["team_run"];
        teamWicket <- map["team_wicket"];
       
    }
}
