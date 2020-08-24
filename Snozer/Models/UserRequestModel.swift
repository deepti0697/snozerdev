//
//  UserRequestModel.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//
//

import Foundation
import UIKit
import ObjectMapper

class UserRequestModel: NSObject, Mappable {
    var name: String = "";
    var password: String = "";
    var socialToken: String = "";
    var email: String = "";
    var signinType : String = "1";
    var deviceToken : String = "";
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"];
        password <- map["password"];
        email <- map["email"];
        signinType <- map["signUpType"];
        deviceToken <- map["deviceToken"];
        socialToken <- map["socialToken"];
        
    }
}
