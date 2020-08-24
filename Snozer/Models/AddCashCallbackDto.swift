//
//  AddCashCallbackDto.swift
//  Snozer
//
//  Created by Admin on 09/12/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//

import Foundation
import ObjectMapper

class AddCashCallbackDto: NSObject, Mappable {
    var taxId: String = "";
    var bankTaxId: String = "";
    var orderId: String = "";
    var taxAmount: String = "";
    var status: String = "";
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        taxId <- map["TXNID"];
        bankTaxId <- map["BANKTXNID"];
        orderId <- map["ORDERID"];
        status <- map["STATUS"];
    }
}



//
