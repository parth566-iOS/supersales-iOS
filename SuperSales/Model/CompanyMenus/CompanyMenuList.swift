//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 31/12/2019

import JSONParserSwift


class CompanyMenuList: ParsableModel {

	var menuList: [MenuList]?
	var tabList: [MenuList]?


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		menuList = [MenuList]()
		if let menuListArray = dictionary["menuList"] as? [[String:Any]]{
			for dic in menuListArray{
				let value = MenuList(fromDictionary: dic)
				menuList.append(value)
			}
		}
		tabList = [MenuList]()
		if let tabListArray = dictionary["tabList"] as? [[String:Any]]{
			for dic in tabListArray{
				let value = MenuList(fromDictionary: dic)
				tabList.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if menuList != nil{
			var dictionaryElements = [[String:Any]]()
			for menuListElement in menuList {
				dictionaryElements.append(menuListElement.toDictionary())
			}
			dictionary["menuList"] = dictionaryElements
		}
		if tabList != nil{
			var dictionaryElements = [[String:Any]]()
			for tabListElement in tabList {
				dictionaryElements.append(tabListElement.toDictionary())
			}
			dictionary["tabList"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         menuList = aDecoder.decodeObject(forKey :"menuList") as? [MenuList]
         tabList = aDecoder.decodeObject(forKey :"tabList") as? [MenuList]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if menuList != nil{
			aCoder.encode(menuList, forKey: "menuList")
		}
		if tabList != nil{
			aCoder.encode(tabList, forKey: "tabList")
		}

	}

}
