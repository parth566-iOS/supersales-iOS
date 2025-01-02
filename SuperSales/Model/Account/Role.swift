//
//	Role.swift
//
//	Create by Mukesh Yadav on 25/12/2019

import JSONParserSwift


class Role: ParsableModel {

	var applicationID: NSNumber?
	var desc: String?
	var id: NSNumber?


	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if applicationID != nil{
			dictionary["applicationID"] = applicationID
		}
		if desc != nil{
			dictionary["desc"] = desc
		}
		if id != nil{
			dictionary["id"] = id
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         super.init(dictionary: [:])
         applicationID = aDecoder.decodeObject(forKey: "applicationID") as? NSNumber
         desc = aDecoder.decodeObject(forKey: "desc") as? String
         id = aDecoder.decodeObject(forKey: "id") as? NSNumber

	}
    
    required init(dictionary: [String : Any]) {
        super.init(dictionary: [:])
        applicationID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "applicationID")
        desc = Common.returndefaultstring(dic: dictionary, keyvalue: "desc")
        id = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "id") 
       // fatalError("init(dictionary:) has not been implemented")
    }
    
    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if applicationID != nil{
			aCoder.encode(applicationID, forKey: "applicationID")
		}
		if desc != nil{
			aCoder.encode(desc, forKey: "desc")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}

	}

}
