//
//  CustomIconDto.swift
//  Snozer
//
//  Created by Admin on 01/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class CustomIconDto: NSObject, Mappable {
    var moreAboutus: CommonDto?;
    var moreContact: CommonDto?;
    var moreContestInviteCode: CommonDto?;
    var moreFantasyPointSystem: CommonDto?;
    var moreFaq: CommonDto?;
    var moreHelpdesk: CommonDto?;
    var moreHowToPlay: CommonDto?;
    var moreInviteFriends: CommonDto?;
    var moreLegality: CommonDto?;
    var moreTermsOfServices: CommonDto?;
    var moreWithdrawPolicy: CommonDto?;
    var tabAccount: CommonDto?;
    var tabFeeds: CommonDto?;
    var tabHome: CommonDto?;
    var tabMyContest: CommonDto?;
    var tabMore: CommonDto?

    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        moreAboutus <- map["more_aboutus"];
        moreContact <- map["more_contact"];
        moreContestInviteCode <- map["more_contest_invite_code"];
        moreFantasyPointSystem <- map["more_fantasy_point_system"];
        moreFaq <- map["more_faq"];
        moreHelpdesk <- map["more_helpdesk"];
        moreHowToPlay <- map["more_how_to_play"];
        moreInviteFriends <- map["more_invite_friends"];
        moreLegality <- map["more_legality"];
        moreTermsOfServices <- map["more_terms_of_services"];
        moreWithdrawPolicy <- map["more_withdraw_policy"];
        tabAccount <- map["tab_account"];
        tabHome <- map["tab_home"];
        tabMyContest <- map["tab_my_contest"];
        tabFeeds <- map["tab_feeds"];
        tabMore <- map["tab_more"]
    }
}
