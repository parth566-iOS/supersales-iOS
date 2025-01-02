//
//	MenuList.swift
//
//	Create by Mukesh Yadav on 31/12/2019

import JSONParserSwift


class MenuList: ParsableModel {

	var iD: NSNumber?
	var companyID: NSNumber?
	var isVisible: NSNumber?
	var menuID: NSNumber?
	var menuLocalText: String?
	var menuValue: String?


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		iD = dictionary["ID"] as? NSNumber
		companyID = dictionary["companyID"] as? NSNumber
		isVisible = dictionary["isVisible"] as? NSNumber
		menuID = dictionary["menuID"] as? NSNumber
		menuLocalText = dictionary["menuLocalText"] as? String
		menuValue = dictionary["menuValue"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if iD != nil{
			dictionary["ID"] = iD
		}
		if companyID != nil{
			dictionary["companyID"] = companyID
		}
		if isVisible != nil{
			dictionary["isVisible"] = isVisible
		}
		if menuID != nil{
			dictionary["menuID"] = menuID
		}
		if menuLocalText != nil{
			dictionary["menuLocalText"] = menuLocalText
		}
		if menuValue != nil{
			dictionary["menuValue"] = menuValue
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         iD = aDecoder.decodeObject(forKey: "ID") as? NSNumber
         companyID = aDecoder.decodeObject(forKey: "companyID") as? NSNumber
         isVisible = aDecoder.decodeObject(forKey: "isVisible") as? NSNumber
         menuID = aDecoder.decodeObject(forKey: "menuID") as? NSNumber
         menuLocalText = aDecoder.decodeObject(forKey: "menuLocalText") as? String
         menuValue = aDecoder.decodeObject(forKey: "menuValue") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if companyID != nil{
			aCoder.encode(companyID, forKey: "companyID")
		}
		if isVisible != nil{
			aCoder.encode(isVisible, forKey: "isVisible")
		}
		if menuID != nil{
			aCoder.encode(menuID, forKey: "menuID")
		}
		if menuLocalText != nil{
			aCoder.encode(menuLocalText, forKey: "menuLocalText")
		}
		if menuValue != nil{
			aCoder.encode(menuValue, forKey: "menuValue")
		}

	}

}