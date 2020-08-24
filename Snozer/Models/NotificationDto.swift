//
//  NotificationDto.swift
//  Snozer
//
//  Created by Admin on 26/11/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import ObjectMapper
class NotificationDto: NSObject, Mappable {
    
    var date: String = "0";
    var imageLarge: String = "";
    var imageThumb: String = "";
    var notification: String = "";
    var senderType: String = "";
    var title: String = "";

    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        date <- map["created"];
        imageLarge <- map["image_large"];
        imageThumb <- map["image_thumb"];
        notification <- map["notification"];
        senderType <- map["sender_type"];
        title <- map["title"];
    }
}
