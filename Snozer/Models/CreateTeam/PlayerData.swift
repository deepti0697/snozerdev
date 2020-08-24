//
//	BOL.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class PlayerData : NSObject, Mappable{
    
    var playerId : String = ""
    var playerPos : String = ""
    var pMultiplier : Any?
    var playerMultiplier : Double {
        get{
            if let e = pMultiplier as? String{
                return Double(e)!;
            }
            if let e = pMultiplier as? Int{
                return Double(e);
            }
            if let e = pMultiplier as? Double{
                return e;
            }
            
            return 0;
        }
        set(newValue){
            
        }

    }
    
    var playerName : String = ""
    var batType : String = ""
    var bowlType : String = ""
    var points : String = "0"
    var teamId : String = ""
    var teamShortCode : String = ""
    var dob : String = ""
    var isSelected : Bool = false
    var image : String = ""
    var selectedBy : String = "0";
    var country: String = "";
    var credits: String = "0.0";
    var isInPlayingSquad : String = "";
    var playingSquadUpdated: String = "";
    var position: String = "";
    var totalPoints: String = "0.0";
    var pType: String = "";
    var selectedAsCaption: String = "0";
    var selectedAsVccaption: String = "0";
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        playerId <- map["player_id"];
        playerPos <- map["player_pos"]
        pMultiplier <- map["player_multiplier"];
        image <- map["image"];
        playerName <- map["name"];
        dob <- map["dob"];
        position <- map["position"];
        points <- map["points"];
        selectedBy <- map["selected_by"];
        teamId <- map["team_id"];
        
        batType <- map["bat_type"];
        bowlType <- map["bowl_type"];
        isSelected <- map["isSelected"];
        totalPoints <- map["total_points"];
        image <- map["Image"];
        country <- map["country"];
        credits <- map["credits"];
        isInPlayingSquad <- map["is_in_playing_squad"];
        playingSquadUpdated <- map["playing_squad_updated"];
        selectedAsCaption <- map["selected_as_caption"];
        selectedAsVccaption <- map["selected_as_vccaption"];
        
    }
    
}
