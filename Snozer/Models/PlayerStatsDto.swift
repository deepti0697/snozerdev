//
//  PlayerStatsDto.swift
//  Snozer
//
//  Created by Admin on 24/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import ObjectMapper

class PlayerStatsDto: NSObject, Mappable {
    var dreamTeamPlayer: String = "";
    var image: String = "";
    var isMyPlayer: String = "N";
    var matchTeamCount: String = "";
    var name: String = "";
    var playerEvents: [PlayerSkillDto] = [];
    
    var playerTeamCount: String = "";
    var playerId: String = "";
    var points: String = "0";
    var position: String = "";
    var selectedCaption: String = "0";
    var selectedVCaption: String = "0"
    var selectedBy: String = "0";
    var teamData: Team?
    var matchName: String = "";
    var matchDate: String = "";
    
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        dreamTeamPlayer <- map["dream_team_player"];
        image <- map["image"];
        isMyPlayer <- map["is_my_player"];
        matchTeamCount <- map["match_team_count"];
        name <- map["name"];
        playerEvents <- map["player_events"];
        playerTeamCount <- map["player_team_count"];
        playerId <- map["player_unique_id"];
        points <- map["points"];
        position <- map["position"];
        selectedCaption <- map["selected_as_caption"];
        selectedVCaption <- map["selected_as_vccaption"];
        selectedBy <- map["selected_by"];
        teamData <- map["team_data"];
        matchName <- map["match_name"]
        matchDate <- map["match_date"]
       
    }
}

class PlayerSkillDto: NSObject, Mappable {
    var keyName: String = "";
    var ponits: String = "0";
    var value: String = "0";
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        keyName <- map["key"];
        ponits <- map["points"];
        value <- map["value"];
    }
}
