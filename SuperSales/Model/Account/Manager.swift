//
//	Manager.swift
//
//	Create by Mukesh Yadav on 25/12/2019

import JSONParserSwift


class Manager: ParsableModel {
    
	var addressVerified: Bool?
	var applicationID: NSNumber?
	var companyID: NSNumber?
	var deviceType: NSNumber?
	var dottedManagerID: NSNumber?
	var emailVerified: Bool?
	var isAllowApproveLeave: NSNumber?
	var isCheckInAllowedFromHome: Bool?
	var isFreeze: Bool?
	var lastModifiedBy: NSNumber?
	var userID: NSNumber?
	var applicationGcmID: ApplicationGcmID?
	var basetowncityID: NSNumber?
	var branchID: NSNumber?
	var departmentID: NSNumber?
	var designationID: NSNumber?
	var gradelevelID: NSNumber?
	var invalidLoginAttempt: NSNumber?
	var isGeoFencing: Bool?
	var roleId: NSNumber?


	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if addressVerified != nil{
			dictionary["Address_Verified"] = addressVerified
		}
		if applicationID != nil{
			dictionary["ApplicationID"] = applicationID
		}
		if companyID != nil{
			dictionary["CompanyID"] = companyID
		}
		if deviceType != nil{
			dictionary["DeviceType"] = deviceType
		}
		if dottedManagerID != nil{
			dictionary["DottedManagerID"] = dottedManagerID
		}
		if emailVerified != nil{
			dictionary["EmailVerified"] = emailVerified
		}
		if isAllowApproveLeave != nil{
			dictionary["IsAllowApproveLeave"] = isAllowApproveLeave
		}
		if isCheckInAllowedFromHome != nil{
			dictionary["IsCheckInAllowedFromHome"] = isCheckInAllowedFromHome
		}
		if isFreeze != nil{
			dictionary["IsFreeze"] = isFreeze
		}
		if lastModifiedBy != nil{
			dictionary["LastModifiedBy"] = lastModifiedBy
		}
		if userID != nil{
			dictionary["UserID"] = userID
		}
		if applicationGcmID != nil{
            dictionary["applicationGcmID"] = applicationGcmID?.toDictionary()
		}
		if basetowncityID != nil{
			dictionary["basetowncityID"] = basetowncityID
		}
		if branchID != nil{
			dictionary["branchID"] = branchID
		}
		if departmentID != nil{
			dictionary["departmentID"] = departmentID
		}
		if designationID != nil{
			dictionary["designationID"] = designationID
		}
		if gradelevelID != nil{
			dictionary["gradelevelID"] = gradelevelID
		}
		if invalidLoginAttempt != nil{
			dictionary["invalidLoginAttempt"] = invalidLoginAttempt
		}
		if isGeoFencing != nil{
			dictionary["isGeoFencing"] = isGeoFencing
		}
		if roleId != nil{
			dictionary["roleId"] = roleId
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
         addressVerified = aDecoder.decodeObject(forKey: "Address_Verified") as? Bool
         applicationID = aDecoder.decodeObject(forKey: "ApplicationID") as? NSNumber
         companyID = aDecoder.decodeObject(forKey: "CompanyID") as? NSNumber
         deviceType = aDecoder.decodeObject(forKey: "DeviceType") as? NSNumber
         dottedManagerID = aDecoder.decodeObject(forKey: "DottedManagerID") as? NSNumber
         emailVerified = aDecoder.decodeObject(forKey: "EmailVerified") as? Bool
         isAllowApproveLeave = aDecoder.decodeObject(forKey: "IsAllowApproveLeave") as? NSNumber
         isCheckInAllowedFromHome = aDecoder.decodeObject(forKey: "IsCheckInAllowedFromHome") as? Bool
         isFreeze = aDecoder.decodeObject(forKey: "IsFreeze") as? Bool
         lastModifiedBy = aDecoder.decodeObject(forKey: "LastModifiedBy") as? NSNumber
         userID = aDecoder.decodeObject(forKey: "UserID") as? NSNumber
         applicationGcmID = aDecoder.decodeObject(forKey: "applicationGcmID") as? ApplicationGcmID
         basetowncityID = aDecoder.decodeObject(forKey: "basetowncityID") as? NSNumber
         branchID = aDecoder.decodeObject(forKey: "branchID") as? NSNumber
         departmentID = aDecoder.decodeObject(forKey: "departmentID") as? NSNumber
         designationID = aDecoder.decodeObject(forKey: "designationID") as? NSNumber
         gradelevelID = aDecoder.decodeObject(forKey: "gradelevelID") as? NSNumber
         invalidLoginAttempt = aDecoder.decodeObject(forKey: "invalidLoginAttempt") as? NSNumber
         isGeoFencing = aDecoder.decodeObject(forKey: "isGeoFencing") as? Bool
         roleId = aDecoder.decodeObject(forKey: "roleId") as? NSNumber

	}
    
    required init(dictionary: [String : Any]) {
        super.init(dictionary: [:])
        
        addressVerified = Common.returndefaultbool(dic: dictionary, keyvalue: "Address_Verified")
        applicationID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "ApplicationID")
        companyID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CompanyID")
        deviceType =  Common.returndefaultnsnumber(dic: dictionary, keyvalue: "DeviceType")
        dottedManagerID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "DottedManagerID")
        emailVerified = Common.returndefaultbool(dic: dictionary, keyvalue: "EmailVerified")
        isAllowApproveLeave =   Common.returndefaultnsnumber(dic: dictionary, keyvalue: "IsAllowApproveLeave")
        isCheckInAllowedFromHome =  Common.returndefaultbool(dic: dictionary, keyvalue: "IsCheckInAllowedFromHome")
        isFreeze = Common.returndefaultbool(dic: dictionary, keyvalue: "IsFreeze")
        lastModifiedBy = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "LastModifiedBy")
        userID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "UserID")
        applicationGcmID = ApplicationGcmID.init(dictionary:  Common.returndefaultdictionary(dic: dictionary, keyvalue: "applicationGcmID"))
        basetowncityID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "basetowncityID")
        branchID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "branchID")
        departmentID =  Common.returndefaultnsnumber(dic: dictionary, keyvalue: "departmentID")
        designationID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "designationID")
        gradelevelID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "gradelevelID")
        invalidLoginAttempt =  Common.returndefaultnsnumber(dic: dictionary, keyvalue: "invalidLoginAttempt")
        isGeoFencing  = Common.returndefaultbool(dic: dictionary, keyvalue: "isGeoFencing")
        roleId =  Common.returndefaultnsnumber(dic: dictionary, keyvalue: "roleId")
       // fatalError("init(dictionary:) has not been implemented")
    }
    
    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if addressVerified != nil{
			aCoder.encode(addressVerified, forKey: "Address_Verified")
		}
		if applicationID != nil{
			aCoder.encode(applicationID, forKey: "ApplicationID")
		}
		if companyID != nil{
			aCoder.encode(companyID, forKey: "CompanyID")
		}
		if deviceType != nil{
			aCoder.encode(deviceType, forKey: "DeviceType")
		}
		if dottedManagerID != nil{
			aCoder.encode(dottedManagerID, forKey: "DottedManagerID")
		}
		if emailVerified != nil{
			aCoder.encode(emailVerified, forKey: "EmailVerified")
		}
		if isAllowApproveLeave != nil{
			aCoder.encode(isAllowApproveLeave, forKey: "IsAllowApproveLeave")
		}
		if isCheckInAllowedFromHome != nil{
			aCoder.encode(isCheckInAllowedFromHome, forKey: "IsCheckInAllowedFromHome")
		}
		if isFreeze != nil{
			aCoder.encode(isFreeze, forKey: "IsFreeze")
		}
		if lastModifiedBy != nil{
			aCoder.encode(lastModifiedBy, forKey: "LastModifiedBy")
		}
		if userID != nil{
			aCoder.encode(userID, forKey: "UserID")
		}
		if applicationGcmID != nil{
			aCoder.encode(applicationGcmID, forKey: "applicationGcmID")
		}
		if basetowncityID != nil{
			aCoder.encode(basetowncityID, forKey: "basetowncityID")
		}
		if branchID != nil{
			aCoder.encode(branchID, forKey: "branchID")
		}
		if departmentID != nil{
			aCoder.encode(departmentID, forKey: "departmentID")
		}
		if designationID != nil{
			aCoder.encode(designationID, forKey: "designationID")
		}
		if gradelevelID != nil{
			aCoder.encode(gradelevelID, forKey: "gradelevelID")
		}
		if invalidLoginAttempt != nil{
			aCoder.encode(invalidLoginAttempt, forKey: "invalidLoginAttempt")
		}
		if isGeoFencing != nil{
			aCoder.encode(isGeoFencing, forKey: "isGeoFencing")
		}
		if roleId != nil{
			aCoder.encode(roleId, forKey: "roleId")
		}

	}

}
