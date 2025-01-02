//
//	BranchAddres.swift
//
//	Create by Mukesh Yadav on 25/12/2019

import JSONParserSwift


class BranchAddres: ParsableModel {

	var addressID: NSNumber?
	var addressLine1: String?
	var addressLine2: String?
	var city: String?
	var country: String?
	var custVenID: NSNumber?
	var lastModifiedBy: NSNumber?
	var lattitude: String?
	var longitude: String?
	var pincode: String?
	var state: String?
	var type: String?
	var verified: Bool?


	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if addressID != nil{
			dictionary["AddressID"] = addressID
		}
		if addressLine1 != nil{
			dictionary["AddressLine1"] = addressLine1
		}
		if addressLine2 != nil{
			dictionary["AddressLine2"] = addressLine2
		}
		if city != nil{
			dictionary["City"] = city
		}
		if country != nil{
			dictionary["Country"] = country
		}
		if custVenID != nil{
			dictionary["CustVenID"] = custVenID
		}
		if lastModifiedBy != nil{
			dictionary["LastModifiedBy"] = lastModifiedBy
		}
		if lattitude != nil{
			dictionary["Lattitude"] = lattitude
		}
		if longitude != nil{
			dictionary["Longitude"] = longitude
		}
		if pincode != nil{
			dictionary["Pincode"] = pincode
		}
		if state != nil{
			dictionary["State"] = state
		}
		if type != nil{
			dictionary["Type"] = type
		}
		if verified != nil{
			dictionary["Verified"] = verified
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
        
         addressID = aDecoder.decodeObject(forKey: "AddressID") as? NSNumber
         addressLine1 = aDecoder.decodeObject(forKey: "AddressLine1") as? String
         addressLine2 = aDecoder.decodeObject(forKey: "AddressLine2") as? String
         city = aDecoder.decodeObject(forKey: "City") as? String
         country = aDecoder.decodeObject(forKey: "Country") as? String
         custVenID = aDecoder.decodeObject(forKey: "CustVenID") as? NSNumber
         lastModifiedBy = aDecoder.decodeObject(forKey: "LastModifiedBy") as? NSNumber
         lattitude = aDecoder.decodeObject(forKey: "Lattitude") as? String
         longitude = aDecoder.decodeObject(forKey: "Longitude") as? String
         pincode = aDecoder.decodeObject(forKey: "Pincode") as? String
         state = aDecoder.decodeObject(forKey: "State") as? String
         type = aDecoder.decodeObject(forKey: "Type") as? String
         verified = aDecoder.decodeObject(forKey: "Verified") as? Bool

	}
    
    required init(dictionary: [String : Any]) {
        
        super.init(dictionary: [:])
        
        addressID =
            Common.returndefaultnsnumber(dic: dictionary, keyvalue: "AddressID")
        
        addressLine1 = Common.returndefaultstring(dic: dictionary, keyvalue: "AddressLine1")
        addressLine2 = Common.returndefaultstring(dic: dictionary, keyvalue: "AddressLine2")
        city =   Common.returndefaultstring(dic: dictionary, keyvalue: "City")
        country = Common.returndefaultstring(dic: dictionary, keyvalue: "Country")
        custVenID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CustVenID")
        lastModifiedBy = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "LastModifiedBy")
        lattitude = Common.returndefaultstring(dic: dictionary, keyvalue: "Lattitude")
        longitude = Common.returndefaultstring(dic: dictionary, keyvalue: "Longitude")
        pincode = Common.returndefaultstring(dic: dictionary, keyvalue: "Pincode")
        state = Common.returndefaultstring(dic: dictionary, keyvalue: "State")
        type = Common.returndefaultstring(dic: dictionary, keyvalue: "Type")
        verified = Common.returndefaultbool(dic: dictionary , keyvalue:"Verified") 
       // fatalError("init(dictionary:) has not been implemented")
    }
    
    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if addressID != nil{
			aCoder.encode(addressID, forKey: "AddressID")
		}
		if addressLine1 != nil{
			aCoder.encode(addressLine1, forKey: "AddressLine1")
		}
		if addressLine2 != nil{
			aCoder.encode(addressLine2, forKey: "AddressLine2")
		}
		if city != nil{
			aCoder.encode(city, forKey: "City")
		}
		if country != nil{
			aCoder.encode(country, forKey: "Country")
		}
		if custVenID != nil{
			aCoder.encode(custVenID, forKey: "CustVenID")
		}
		if lastModifiedBy != nil{
			aCoder.encode(lastModifiedBy, forKey: "LastModifiedBy")
		}
		if lattitude != nil{
			aCoder.encode(lattitude, forKey: "Lattitude")
		}
		if longitude != nil{
			aCoder.encode(longitude, forKey: "Longitude")
		}
		if pincode != nil{
			aCoder.encode(pincode, forKey: "Pincode")
		}
		if state != nil{
			aCoder.encode(state, forKey: "State")
		}
		if type != nil{
			aCoder.encode(type, forKey: "Type")
		}
		if verified != nil{
			aCoder.encode(verified, forKey: "Verified")
		}

	}
    
    func addressString()->String{
        let str = String.init(format:"\(self.addressLine1),\(self.addressLine2),\(self.city),\(self.state),\(self.country)")
        return str
    }
}
