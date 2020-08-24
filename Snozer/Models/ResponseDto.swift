//
//  ResponseDto.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//
//

import Foundation
import UIKit;
import ObjectMapper;

class ResponseDto:  Mappable {
    
    var error: Bool?
    var data: Any?
    var message: String?
    var code: Int?
    var internetAvailable = true
    
    func isSuccess() -> Bool {
        return error != nil && error == false
    }
    func getMessage() -> String {
        return message ?? ""
    }
    init() {
        
    }
    
    init(status: Bool = false
        , internetAvailable: Bool = true
        , data: Any? = nil
        , message: String? = nil) {
        
        self.error = status
        self.data = data
        self.message = message
    }
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        error <- map["error"]
        data <- map["data"];
        message <- map["message"];
        code <- map["code"];
    }
    let transform = TransformOf<Bool, String>(fromJSON: { (value: String?) -> Bool? in
        return (value == "true" || value == "1") ? true : false
    }, toJSON: { (value: Bool?) -> String? in
        if let value = value {
            return value == true ? "1" : "0"
        }
        return nil
    })
}
