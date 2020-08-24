//
//  CommonDto.swift
//  Snozer
//
//  Created by Admin on 06/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class CommonDto: NSObject, Mappable {
    var name: String = "";
    var id: String = "";
    var image: String = "";
    var reactionCount : String = "0"
    var isSelected = false;
    var sportId = "0"
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"];
        id <- map["id"];
        image <- map["image"];
        reactionCount <- map["reaction_count"];
        sportId <- map["sport_id"];
    }
}
