//
//	TemporaryAddres.swift
//
//	Create by Mukesh Yadav on 25/12/2019

import JSONParserSwift


class TemporaryAddres: ParsableModel {

	var addressID: NSNumber?
	var custVenID: NSNumber?
	var lastModifiedBy: NSNumber?
	var verified: Bool?
    var addressLine1:String?
    var addressLine2:String?
    var city:String?
    var state:String?
    var country:String?
    var pincode:String?
    var lattitude:String?
    var longitude:String?
    

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
        
        if state != nil{
            dictionary["State"] = state
        }
        
        if country != nil{
            dictionary["Country"] = country
        }
        
        if pincode != nil{
            dictionary["Pincode"] = pincode
        }
        if lattitude != nil{
            dictionary["Lattitude"] = lattitude
        }
        if longitude != nil{
            dictionary["Longitude"] = longitude
        }
		if custVenID != nil{
			dictionary["CustVenID"] = custVenID
		}
		if lastModifiedBy != nil{
			dictionary["LastModifiedBy"] = lastModifiedBy
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
         custVenID = aDecoder.decodeObject(forKey: "CustVenID") as? NSNumber
         lastModifiedBy = aDecoder.decodeObject(forKey: "LastModifiedBy") as? NSNumber
         verified = aDecoder.decodeObject(forKey: "Verified") as? Bool
        addressLine1 = aDecoder.decodeObject(forKey: "AddressLine1") as? String ?? ""
        addressLine2 = aDecoder.decodeObject(forKey: "AddressLine2") as? String ?? ""
        city = aDecoder.decodeObject(forKey: "City") as? String ?? ""
        state = aDecoder.decodeObject(forKey: "State") as? String ?? ""
        country = aDecoder.decodeObject(forKey: "Country") as? String ?? ""
        pincode = aDecoder.decodeObject(forKey: "Pincode") as? String ?? ""
	}
    
    required init(dictionary: [String : Any]) {
        super.init(dictionary: [:])
        addressID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "AddressID")//aDecoder.decodeObject(forKey: "AddressID") as? NSNumber
        custVenID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CustVenID")
        lastModifiedBy = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "LastModifiedBy")
        verified = Common.returndefaultbool(dic: dictionary, keyvalue: "Verified")
        addressLine1 =  Common.returndefaultstring(dic: dictionary, keyvalue: "AddressLine1")
        addressLine2 =  Common.returndefaultstring(dic: dictionary, keyvalue: "AddressLine2")
        city =  Common.returndefaultstring(dic: dictionary, keyvalue: "City")
        state =  Common.returndefaultstring(dic: dictionary, keyvalue: "State")
       country =  Common.returndefaultstring(dic: dictionary, keyvalue: "Country")
        pincode =  Common.returndefaultstring(dic: dictionary, keyvalue: "Pincode")
        lattitude   =  Common.returndefaultstring(dic: dictionary, keyvalue: "Lattitude")
        longitude  =  Common.returndefaultstring(dic: dictionary, keyvalue: "Longitude")
        //fatalError("init(dictionary:) has not been implemented")
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
		if custVenID != nil{
			aCoder.encode(custVenID, forKey: "CustVenID")
		}
		if lastModifiedBy != nil{
			aCoder.encode(lastModifiedBy, forKey: "LastModifiedBy")
		}
		if verified != nil{
			aCoder.encode(verified, forKey: "Verified")
		}
        if addressLine1 != nil{
            aCoder.encode(verified, forKey: "AddressLine1")
        }
        if addressLine2 != nil{
            aCoder.encode(verified, forKey: "AddressLine2")
        }
        if city != nil{
            aCoder.encode(verified, forKey: "City")
        }
        if state != nil{
            aCoder.encode(verified, forKey: "State")
        }
        if country != nil{
            aCoder.encode(verified, forKey: "Country")
        }
        if pincode != nil{
            aCoder.encode(verified, forKey: "Pincode")
        }
	}

}
