//
//  PrivateWinningOptionDto.swift
//  Snozer
//
//  Created by Admin on 28/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import ObjectMapper
class PrivateWinningOptionDto: NSObject, Mappable {
    
    var privateContestCategory: String = "0";
    var winningBreakups: [WinningBreakups] = [];
  
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        privateContestCategory <- map["private_contest_category"];
        winningBreakups <- map["winning_breakups"];
        
    }
}

class WinningBreakups: NSObject, Mappable {
    
    var contestJson: ContestJson?;
    var id: String = "";
    var totalWinners: String = "0"
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        contestJson <- map["contest_json"];
        totalWinners <- map["total_winners"];
        id <- map["id"];
        
    }
}

class ContestJson: NSObject, Mappable {
    
    var perMaxP: [String] = [];
    var perMinP: [String] = [];
    var perPercent: [String] = []
    var perPrice: [Double] = []
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        perMaxP <- map["per_max_p"];
        perMinP <- map["per_min_p"];
        perPercent <- map["per_percent"];
        perPrice <- map["per_price"];
        
    }
}
