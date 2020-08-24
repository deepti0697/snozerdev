//
//	TxnHistory.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class TxnHistory : NSObject, Mappable{

	var date : String!
    var dateW : String!
	var amount : String!
	var descriptionField : String!
    var transcationID : String!
    var currentAmount: String = ""
    var previousAmount: String = ""
    var status: String = ""
    var transactionType: String = ""
    var type: String = ""
    var walletType: String = "";
    var titleText: String = "";

    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        date <- map["created"];
        dateW <- map["created_at"];
        type <- map["type"];
        amount <- map["amount"];
        descriptionField <- map["description"];
        currentAmount <- map["current_amount"];
        transcationID <- map["transaction_id"];
        previousAmount <- map["previous_amount"];
        status <- map["status"];
        transactionType <- map["transaction_type"];
        walletType <- map["wallet_type"];
        titleText <- map["title_text"];
        
        
    }
}
