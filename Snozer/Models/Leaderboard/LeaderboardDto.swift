//
//  LeaderboardDto.swift
//  Snozer
//
//  Created by Admin on 06/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class LeaderboardDto: NSObject, Mappable {
    var id: String = "";
    var newpoint: String = "0";
    var newrank: String = "0";
    var oldpoint: String = "0";
    var oldrank : String = "0";
    var userdetail : LeadorboardUserDetail?;
    
    var customerTeamID = "";
    var matchDetail : LeadorboardMatchDetail?;
    
    
    init(id: String, points: String, rank: String, name: String, image : String) {
        self.id = id;
        self.newrank = rank;
        self.newpoint = points;
        self.userdetail = LeadorboardUserDetail();
        self.userdetail?.image  = image;
        self.userdetail?.fname = name;
        self.userdetail?.id = id;
    }
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"];
        newpoint <- map["new_point"];
        newrank <- map["new_rank"];
        oldpoint <- map["old_point"];
        oldrank <- map["old_rank"];
        userdetail <- map["user_detail"];
        customerTeamID <- map["customer_team_id"];
        matchDetail <- map["match_detail"];
    }
}

class LeadorboardUserDetail: NSObject, Mappable {
    var id: String = "";
    var fname: String = "";
    var image: String = "";
    var lname: String = "";
    var teamname : String = "";
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"];
        fname <- map["firstname"];
        image <- map["image"];
        lname <- map["lastname"];
        teamname <- map["team_name"];
    }
}

class LeadorboardMatchDetail: NSObject, Mappable {
    var id: String = "";
    var matchDate: String = "";
    var name: String = "";
    var shortTitle: String = "";
    var subtitle : String = "";
    var uniqueId : String = "";
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"];
        matchDate <- map["match_date"];
        name <- map["name"];
        shortTitle <- map["short_title"];
        subtitle <- map["subtitle"];
        uniqueId <- map["unique_id"];
    }
}
