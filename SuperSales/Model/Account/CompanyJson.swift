//
//	Company.swift
//
//	Create by Mukesh Yadav on 25/12/2019

import JSONParserSwift


class CompanyJson: ParsableModel {

	var addressList: [AddressInfo]?//[BranchAddres]?
	var companyTypeID: NSNumber?
	var countryCode: String?
	var createdBy: NSNumber?
	var defaultNoticePeriod: NSNumber?
	var defaultProbationPeriod: NSNumber?
	var descriptionField: String?
	var emailID: String?
	var iD: NSNumber?
	var landlineNo: String?
	var lastModified: String?
	var lastModifiedBy: NSNumber?
	var logo: String?
	var mobileNo: String?
	var name: String?
	var ownerID: NSNumber?
	var brandName: String?
	var currCode: String?
	var currSymbol: String?
	var currencyID: NSNumber?
	var disableOtherLogin: NSNumber?
	var financialYear: NSNumber?
	var isActive: Bool?
	var isCustomerTagging: NSNumber?
	var isCustomerTaggingSupersales: NSNumber?
	var isGeoFencing: Bool?
	var radius: NSNumber?
	var radiusSuperSales: NSNumber?
	var timeZone: String?
	var timeZoneID: NSNumber?
	var timeZoneOffset: String?


	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
    // swiftlint:disable cyclomatic_complexity
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if addressList != nil{
			var dictionaryElements = [[String:Any]]()
            for addressListElement in addressList! {
				dictionaryElements.append(addressListElement.toDictionary())
			}
			dictionary["AddressList"] = dictionaryElements
		}
		if companyTypeID != nil{
			dictionary["CompanyTypeID"] = companyTypeID
		}
		if countryCode != nil{
			dictionary["CountryCode"] = countryCode
		}
		if createdBy != nil{
			dictionary["CreatedBy"] = createdBy
		}
		if defaultNoticePeriod != nil{
			dictionary["DefaultNoticePeriod"] = defaultNoticePeriod
		}
		if defaultProbationPeriod != nil{
			dictionary["DefaultProbationPeriod"] = defaultProbationPeriod
		}
		if descriptionField != nil{
			dictionary["Description"] = descriptionField
		}
		if emailID != nil{
			dictionary["EmailID"] = emailID
		}
		if iD != nil{
			dictionary["ID"] = iD
		}
		if landlineNo != nil{
			dictionary["LandlineNo"] = landlineNo
		}
		if lastModified != nil{
			dictionary["LastModified"] = lastModified
		}
		if lastModifiedBy != nil{
			dictionary["LastModifiedBy"] = lastModifiedBy
		}
		if logo != nil{
			dictionary["Logo"] = logo
		}
		if mobileNo != nil{
			dictionary["MobileNo"] = mobileNo
		}
		if name != nil{
			dictionary["Name"] = name
		}
		if ownerID != nil{
			dictionary["OwnerID"] = ownerID
		}
		if brandName != nil{
			dictionary["brandName"] = brandName
		}
		if currCode != nil{
			dictionary["currCode"] = currCode
		}
		if currSymbol != nil{
			dictionary["currSymbol"] = currSymbol
		}
		if currencyID != nil{
			dictionary["currencyID"] = currencyID
		}
		if disableOtherLogin != nil{
			dictionary["disableOtherLogin"] = disableOtherLogin
		}
		if financialYear != nil{
			dictionary["financialYear"] = financialYear
		}
		if isActive != nil{
			dictionary["isActive"] = isActive
		}
		if isCustomerTagging != nil{
			dictionary["isCustomerTagging"] = isCustomerTagging
		}
		if isCustomerTaggingSupersales != nil{
			dictionary["isCustomerTagging_Supersales"] = isCustomerTaggingSupersales
		}
		if isGeoFencing != nil{
			dictionary["isGeoFencing"] = isGeoFencing
		}
		if radius != nil{
			dictionary["radius"] = radius
		}
		if radiusSuperSales != nil{
			dictionary["radius_SuperSales"] = radiusSuperSales
		}
		if timeZone != nil{
			dictionary["timeZone"] = timeZone
		}
		if timeZoneID != nil{
			dictionary["timeZoneID"] = timeZoneID
		}
		if timeZoneOffset != nil{
			dictionary["timeZoneOffset"] = timeZoneOffset
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

         addressList = aDecoder.decodeObject(forKey :"AddressList") as? [AddressInfo]
         companyTypeID = aDecoder.decodeObject(forKey: "CompanyTypeID") as? NSNumber
         countryCode = aDecoder.decodeObject(forKey: "CountryCode") as? String
         createdBy = aDecoder.decodeObject(forKey: "CreatedBy") as? NSNumber
         defaultNoticePeriod = aDecoder.decodeObject(forKey: "DefaultNoticePeriod") as? NSNumber
         defaultProbationPeriod = aDecoder.decodeObject(forKey: "DefaultProbationPeriod") as? NSNumber
         descriptionField = aDecoder.decodeObject(forKey: "Description") as? String
         emailID = aDecoder.decodeObject(forKey: "EmailID") as? String
         iD = aDecoder.decodeObject(forKey: "ID") as? NSNumber
         landlineNo = aDecoder.decodeObject(forKey: "LandlineNo") as? String
         lastModified = aDecoder.decodeObject(forKey: "LastModified") as? String
         lastModifiedBy = aDecoder.decodeObject(forKey: "LastModifiedBy") as? NSNumber
         logo = aDecoder.decodeObject(forKey: "Logo") as? String
         mobileNo = aDecoder.decodeObject(forKey: "MobileNo") as? String
         name = aDecoder.decodeObject(forKey: "Name") as? String
         ownerID = aDecoder.decodeObject(forKey: "OwnerID") as? NSNumber
         brandName = aDecoder.decodeObject(forKey: "brandName") as? String
         currCode = aDecoder.decodeObject(forKey: "currCode") as? String
         currSymbol = aDecoder.decodeObject(forKey: "currSymbol") as? String
         currencyID = aDecoder.decodeObject(forKey: "currencyID") as? NSNumber
         disableOtherLogin = aDecoder.decodeObject(forKey: "disableOtherLogin") as? NSNumber
         financialYear = aDecoder.decodeObject(forKey: "financialYear") as? NSNumber
         isActive = aDecoder.decodeObject(forKey: "isActive") as? Bool
         isCustomerTagging = aDecoder.decodeObject(forKey: "isCustomerTagging") as? NSNumber
         isCustomerTaggingSupersales = aDecoder.decodeObject(forKey: "isCustomerTagging_Supersales") as? NSNumber
         isGeoFencing = aDecoder.decodeObject(forKey: "isGeoFencing") as? Bool
         radius = aDecoder.decodeObject(forKey: "radius") as? NSNumber
         radiusSuperSales = aDecoder.decodeObject(forKey: "radius_SuperSales") as? NSNumber
         timeZone = aDecoder.decodeObject(forKey: "timeZone") as? String
         timeZoneID = aDecoder.decodeObject(forKey: "timeZoneID") as? NSNumber
         timeZoneOffset = aDecoder.decodeObject(forKey: "timeZoneOffset") as? String

	}

    required init(dictionary: [String : Any]) {
        super.init(dictionary: [:])
        addressList = [AddressInfo]()
        if let arrAdd =  dictionary["AddressList"] as? [[String:Any]]{
        for add in arrAdd{
            let adi = AddressInfo().initWithdic(dic: add)
            addressList?.append(adi)
        }
        }
        //addressList = [AddressInfo().initWithdic(dic:Common.returndefaultdictionary(dic: dictionary, keyvalue: "AddressList"))]
        //(dictionary:Common.returndefaultdictionary(dic:dictionary,keyvalue:"AddressList")

        companyTypeID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CompanyTypeID")
        countryCode = Common.returndefaultstring(dic: dictionary, keyvalue: "CountryCode")
        createdBy = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CreatedBy")
        defaultNoticePeriod = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "DefaultNoticePeriod")
        defaultProbationPeriod = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "DefaultProbationPeriod")
        descriptionField =  Common.returndefaultstring(dic: dictionary, keyvalue: "Description")
        emailID =  Common.returndefaultstring(dic: dictionary, keyvalue: "EmailID")
        iD =  Common.returndefaultnsnumber(dic: dictionary, keyvalue: "ID")
        landlineNo =  Common.returndefaultstring(dic: dictionary, keyvalue: "LandlineNo")
        lastModified =  Common.returndefaultstring(dic: dictionary, keyvalue: "LastModified")
        lastModifiedBy = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "LastModifiedBy")
        logo =  Common.returndefaultstring(dic: dictionary, keyvalue: "Logo")
        mobileNo =  Common.returndefaultstring(dic: dictionary, keyvalue: "MobileNo")
        name =  Common.returndefaultstring(dic: dictionary, keyvalue: "Name")
        ownerID =  Common.returndefaultnsnumber(dic: dictionary, keyvalue: "OwnerID")
        brandName =  Common.returndefaultstring(dic: dictionary, keyvalue: "brandName")
        currCode =  Common.returndefaultstring(dic: dictionary, keyvalue: "currCode")
        currSymbol =  Common.returndefaultstring(dic: dictionary, keyvalue: "currSymbol")
        currencyID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "currencyID")
        disableOtherLogin = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "disableOtherLogin")
        financialYear = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "financialYear")
        isActive = Common.returndefaultbool(dic: dictionary, keyvalue: "isActive")
        isCustomerTagging = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "isCustomerTagging")
        isCustomerTaggingSupersales = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "isCustomerTagging_Supersales")
        isGeoFencing = Common.returndefaultbool(dic: dictionary, keyvalue: "isGeoFencing")
        radius = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "radius")
        radiusSuperSales = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "radius_SuperSales")
        timeZone = Common.returndefaultstring(dic: dictionary, keyvalue: "timeZone")
        timeZoneID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "timeZoneID")
        timeZoneOffset =  Common.returndefaultstring(dic: dictionary, keyvalue: "timeZoneOffset")
        //fatalError("init(dictionary:) has not been implemented")
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if addressList != nil{
			aCoder.encode(addressList, forKey: "AddressList")
		}
		if companyTypeID != nil{
			aCoder.encode(companyTypeID, forKey: "CompanyTypeID")
		}
		if countryCode != nil{
			aCoder.encode(countryCode, forKey: "CountryCode")
		}
		if createdBy != nil{
			aCoder.encode(createdBy, forKey: "CreatedBy")
		}
		if defaultNoticePeriod != nil{
			aCoder.encode(defaultNoticePeriod, forKey: "DefaultNoticePeriod")
		}
		if defaultProbationPeriod != nil{
			aCoder.encode(defaultProbationPeriod, forKey: "DefaultProbationPeriod")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "Description")
		}
		if emailID != nil{
			aCoder.encode(emailID, forKey: "EmailID")
		}
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if landlineNo != nil{
			aCoder.encode(landlineNo, forKey: "LandlineNo")
		}
		if lastModified != nil{
			aCoder.encode(lastModified, forKey: "LastModified")
		}
		if lastModifiedBy != nil{
			aCoder.encode(lastModifiedBy, forKey: "LastModifiedBy")
		}
		if logo != nil{
			aCoder.encode(logo, forKey: "Logo")
		}
		if mobileNo != nil{
			aCoder.encode(mobileNo, forKey: "MobileNo")
		}
		if name != nil{
			aCoder.encode(name, forKey: "Name")
		}
		if ownerID != nil{
			aCoder.encode(ownerID, forKey: "OwnerID")
		}
		if brandName != nil{
			aCoder.encode(brandName, forKey: "brandName")
		}
		if currCode != nil{
			aCoder.encode(currCode, forKey: "currCode")
		}
		if currSymbol != nil{
			aCoder.encode(currSymbol, forKey: "currSymbol")
		}
		if currencyID != nil{
			aCoder.encode(currencyID, forKey: "currencyID")
		}
		if disableOtherLogin != nil{
			aCoder.encode(disableOtherLogin, forKey: "disableOtherLogin")
		}
		if financialYear != nil{
			aCoder.encode(financialYear, forKey: "financialYear")
		}
		if isActive != nil{
			aCoder.encode(isActive, forKey: "isActive")
		}
		if isCustomerTagging != nil{
			aCoder.encode(isCustomerTagging, forKey: "isCustomerTagging")
		}
		if isCustomerTaggingSupersales != nil{
			aCoder.encode(isCustomerTaggingSupersales, forKey: "isCustomerTagging_Supersales")
		}
		if isGeoFencing != nil{
			aCoder.encode(isGeoFencing, forKey: "isGeoFencing")
		}
		if radius != nil{
			aCoder.encode(radius, forKey: "radius")
		}
		if radiusSuperSales != nil{
			aCoder.encode(radiusSuperSales, forKey: "radius_SuperSales")
		}
		if timeZone != nil{
			aCoder.encode(timeZone, forKey: "timeZone")
		}
		if timeZoneID != nil{
			aCoder.encode(timeZoneID, forKey: "timeZoneID")
		}
		if timeZoneOffset != nil{
			aCoder.encode(timeZoneOffset, forKey: "timeZoneOffset")
		}

	}

}
