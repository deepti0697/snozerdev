//
//  PostShareDto.swift
//  Snozer
//
//  Created by Admin on 21/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class PostShareDto: NSObject, Mappable {
    var created: String = "";
    var des: String = "";
    var id: String = "";
    var postTeam: Jointeam?;
    var matchName: String = "";
    var matchId: String = "";
    var postType: String = "";
    var reactionDetail: CommonDto?;
    var reactionDMsg: String = "";
    var reactions: [CommonDto] = [];
    var title: String = "";
    var userDetail: CustomerInfoDto?;
    var teamId : String = "";
    var sport: CommonDto?
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        created <- map["created"];
        id <- map["id"];
        des <- map["description"];
        postTeam <- map["json"];
        matchName <- map["match_name"];
        matchId <- map["match_unique_id"];
        postType <- map["post_type"];
        reactionDMsg <- map["reaction_detail_message"];
        reactionDetail <- map["reaction_detail"];
        reactions <- map["reactions"];
        title <- map["title"];
        userDetail <- map["user_detail"];
        teamId <- map["team_id"];
        sport <- map["sport"]
    }
}
