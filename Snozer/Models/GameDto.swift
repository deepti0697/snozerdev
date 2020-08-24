//
//  GameDto.swift
//  Snozer
//
//  Created by Admin on 02/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import ObjectMapper

class GameDto: NSObject, Mappable {
    var id: String = "";
    var name: String = "";
    var image: String = "";
    var isShowAgain = true;
    var quotation : QuotationDto?
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"];
        name <- map["name"];
        image <- map["image"];
        quotation <- map["quotation"];
       
    }
}

class QuotationDto: NSObject, Mappable {
    var gameId: String = "";
    var image: String = "";
    var link: String = "";
    var height: String = "0";
    var width: String = "0";

    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        gameId <- map["game_id"];
        image <- map["image"];
        link <- map["link"];
        height <- map["height"];
        width <- map["width"];
    }
}

