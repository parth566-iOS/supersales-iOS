//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 25/12/2019

import JSONParserSwift


class RootClass: ParsableModel {

	var data: NSDictionary?//DataUser?
	var message: String?
	var status: String?
    var pageNo: NSNumber?
    var pagesize: NSNumber?
    var pagesAvailable: Int?
    var totalPages: Int?
    var totalRecords: Int?
    var arr:[[String:Any]]?
    var dic:[String:Any]?
    var str:String?
    var responseType:ResponseType?
    var lastSynchTime:String?
    
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if data != nil{
            dictionary["data"] = data
            
		}
		if message != nil{
			dictionary["message"] = message
		}
		if status != nil{
			dictionary["status"] = status
		}
        if let strlastsynctime = lastSynchTime{
            dictionary["lastSynchTime"] = lastSynchTime
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
        data = aDecoder.decodeObject(forKey: "data") as? NSDictionary
        message = aDecoder.decodeObject(forKey: "message") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        pageNo = aDecoder.decodeObject(forKey: "pageno") as? NSNumber
        
        pagesize = aDecoder.decodeObject(forKey: "pagesize") as? NSNumber
        arr = aDecoder.decodeObject(forKey: "data") as? [[String:Any]]? ?? [[String:Any]]()
        dic = aDecoder.decodeObject(forKey: "data") as? [String:Any]? ?? [String:Any]()
        lastSynchTime = aDecoder.decodeObject(forKey: "lastSynchTime") as? String ?? String()
	}
    
   
    
     required init(dictionary: [String : Any]) {
        super.init(dictionary: [:])
         data =  Common.returndefaultdictionary(dic: dictionary, keyvalue: "data") as NSDictionary
     
        
//        do{
//            let jsonData = try! JSONSerialization.data(withJSONObject: dictionary["data"] ?? [String:Any](), options: [])
//        let   dict = try  JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any]
//        if(JSONSerialization.isValidJSONObject(dict)){
//            let dic = dict as? [String:Any] ?? [String:Any]()
//            let arr = dict as? [[String:Any]] ?? [[String:Any]]()
//            let str =  dict as? String ?? ""
//            print("Dictionary = \(dic),array = \(arr),string = \(str)")
//        }else{
//            print("Invalid json in root class \(dictionary["data"])")
//        }
//        }catch let error as NSError {
//            print(error.localizedDescription)
//        }
//

        status = Common.returndefaultstring(dic: dictionary, keyvalue: "status")
        message =  Common.returndefaultstring(dic: dictionary, keyvalue: "message")
        pageNo  = Common.returndefaultnsnumber(dic: dictionary , keyvalue: "pageno")
        pagesize = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "totalRows")
        pagesAvailable = Common.returndefaultInteger(dic: dictionary, keyvalue: "pagesAvailable")
        totalRecords = Common.returndefaultInteger(dic: dictionary, keyvalue: "totalRows")
        lastSynchTime = Common.returndefaultstring(dic: dictionary, keyvalue: "lastSynchTime")
        totalPages = Common.returndefaultInteger(dic: dictionary, keyvalue: "totalPages")
        // fatalError("init(dictionary:) has not been implemented")
    }
    
    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
