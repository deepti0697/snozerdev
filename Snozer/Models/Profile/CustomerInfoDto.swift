//
//  CustomerInfoDto.swift
//  Snozer
//
//  Created by Admin on 08/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import ObjectMapper

class CustomerInfoDto : NSObject, Mappable{
    
    var postCount: String = "0"
    var phone: String = "";
    var followingCount: String = "0"
    var followerCount : String = "0"
    var email: String = "";
    var customerMobileCode : String = "+91";
    var image : String!
    var isFollow : String!
    var isFollowing : String!
    var firstname : String!
    var lastname : String = ""
    var teamName : String!
    var id : String!
    var playingHistory: PlayingHistory?
    var seriesLeaderboard: [SeriesLeaderBoardDto] = []
    var state: UserState?
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        
        
        postCount <- map["post_count"];
        phone <- map["phone"];
        followingCount <- map["following_count"];
        followerCount <- map["follower_count"];
        email <- map["email"];
        customerMobileCode <- map["country_mobile_code"];
        playingHistory <- map["playing_history"];
        seriesLeaderboard <- map["series_leaderboard"];
        
        image <- map["image"];
        isFollow <- map["is_follow"];
        isFollowing <- map["is_following"];
        firstname <- map["firstname"];
        lastname <- map["lastname"];
        teamName <- map["team_name"];
        id <- map["id"];
        state <- map["state"];
    }
}


class SeriesLeaderBoardDto : Mappable{
    
    var id : String = ""
    var name : String = ""
    var newPoint : String = "0"
    var newRank : String = "0"
    
    required init?(map: Map) {
     }
    
     func mapping(map: Map) {
        id <- map["id"];
        name <- map["name"]
        newPoint <- map["new_point"];
        newRank <- map["new_rank"]
     }
}
