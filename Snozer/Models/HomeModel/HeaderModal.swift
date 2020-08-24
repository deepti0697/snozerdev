//
//	HeaderModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct HeaderModal: Mappable{

	var id : Int!
	var image : String!
	var type : String!
	var url : String!

    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {        
        id <- map["id"];
        image <- map["image_large"]
        type <- map["content"];
        url <- map["Url"];
    }
}
