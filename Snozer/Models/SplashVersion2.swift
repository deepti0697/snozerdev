//
//	SplashVersion2.swift
//
//	Create by Cricshot#1 on 22/12/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SplashVersion2{

	var clearData : Bool!
	var forceUpdate : Bool!
	var isAppUpdate : Bool!
	var message : String!
	var messageShow : Bool!
	var runOnWeb : Bool!
	var title : String!
	var webURl : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		clearData = dictionary["ClearData"] as? Bool
		forceUpdate = dictionary["ForceUpdate"] as? Bool
		isAppUpdate = dictionary["IsAppUpdate"] as? Bool
		message = dictionary["Message"] as? String
		messageShow = dictionary["MessageShow"] as? Bool
		runOnWeb = dictionary["RunOnWeb"] as? Bool
		title = dictionary["Title"] as? String
		webURl = dictionary["WebURl"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if clearData != nil{
			dictionary["ClearData"] = clearData
		}
		if forceUpdate != nil{
			dictionary["ForceUpdate"] = forceUpdate
		}
		if isAppUpdate != nil{
			dictionary["IsAppUpdate"] = isAppUpdate
		}
		if message != nil{
			dictionary["Message"] = message
		}
		if messageShow != nil{
			dictionary["MessageShow"] = messageShow
		}
		if runOnWeb != nil{
			dictionary["RunOnWeb"] = runOnWeb
		}
		if title != nil{
			dictionary["Title"] = title
		}
		if webURl != nil{
			dictionary["WebURl"] = webURl
		}
		return dictionary
	}

}
