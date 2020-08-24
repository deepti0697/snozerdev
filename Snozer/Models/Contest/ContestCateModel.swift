//
//	ContestCateModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class ContestCateModel: NSObject, Mappable {

	var desc : String!
	var iD : Int!
	var image : String!
    var contests : [ContestPool] = [];
	var title : String!
    var discountImage : String = "";
    var isDiscount: String = "N"
    var isViewMore = false;
    var isShowViewMore : Bool{
       return self.contests.count > 3
    }
    
    init(title: String, des: String) {
        self.title = title;
        self.desc = des;
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        desc <- map["description"];
        iD <- map["id"]
        image <- map["image"];
        contests <- map["contests"];
        title <- map["name"];
        discountImage <- map["discount_image"];
        isDiscount <- map["is_discounted"]
    }

}

