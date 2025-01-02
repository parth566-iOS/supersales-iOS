//
//	Data.swift
//
//	Create by Mukesh Yadav on 25/12/2019

import JSONParserSwift


class User: ParsableModel {

	var addressVerified: Bool?
	var applicationID: NSNumber?
	var companyID: NSNumber?
	var countryCode: String?
	var deviceID: String?
	var deviceType: NSNumber?
	var dottedManagerID: NSNumber?
	var emailID: String?
	var emailVerified: Bool?
	var firstName: String?
	var gender: String?
	var isAllowApproveLeave: NSNumber?
	var isCheckInAllowedFromHome: Bool?
	var isFreeze: Bool?
	var joiningDate: String?
	var lastModified: String?
	var lastModifiedBy: NSNumber?
	var lastName: String?
	var manager: Manager?
	var mobileNo1: String?
	var mobileNo2: String?
	var securityToken: String?
	var userID: NSNumber?
	var applicationGcmID: ApplicationGcmID?
	var basetowncityID: NSNumber?
	var branchAddress: BranchAddres?
	var branchID: NSNumber?
	var company: Company?
	var departmentID: NSNumber?
	var designationID: NSNumber?
	var employeeCode: String?
	var gradelevelID: NSNumber?
	var invalidLoginAttempt: NSNumber?
	var isGeoFencing: Bool?
	var otpGenerateTime: String?
	var permanentAddress: PermanentAddres?
	var picture: String?
	var role: Role?
	var roleId: NSNumber?
	var temporaryAddress: TemporaryAddres?


	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
      // swiftlint:disable cyclomatic_complexity
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
		if countryCode != nil{
			dictionary["CountryCode"] = countryCode
		}
		if deviceID != nil{
			dictionary["DeviceID"] = deviceID
		}
		if deviceType != nil{
			dictionary["DeviceType"] = deviceType
		}
		if dottedManagerID != nil{
			dictionary["DottedManagerID"] = dottedManagerID
		}
		if emailID != nil{
			dictionary["EmailID"] = emailID
		}
		if emailVerified != nil{
			dictionary["EmailVerified"] = emailVerified
		}
		if firstName != nil{
			dictionary["FirstName"] = firstName
		}
		if gender != nil{
			dictionary["Gender"] = gender
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
		if joiningDate != nil{
			dictionary["JoiningDate"] = joiningDate
		}
		if lastModified != nil{
			dictionary["LastModified"] = lastModified
		}
		if lastModifiedBy != nil{
			dictionary["LastModifiedBy"] = lastModifiedBy
		}
		if lastName != nil{
			dictionary["LastName"] = lastName
		}
		if manager != nil{
            dictionary["Manager"] = manager?.toDictionary()
		}
		if mobileNo1 != nil{
			dictionary["MobileNo1"] = mobileNo1
		}
		if mobileNo2 != nil{
			dictionary["MobileNo2"] = mobileNo2
		}
		if securityToken != nil{
			dictionary["SecurityToken"] = securityToken
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
		if branchAddress != nil{
            dictionary["branchAddress"] = branchAddress?.toDictionary()
		}
		if branchID != nil{
			dictionary["branchID"] = branchID
		}
		if company != nil{
            dictionary["company"] = company?.toDictionary()
		}
		if departmentID != nil{
			dictionary["departmentID"] = departmentID
		}
		if designationID != nil{
			dictionary["designationID"] = designationID
		}
		if employeeCode != nil{
			dictionary["employeeCode"] = employeeCode
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
		if otpGenerateTime != nil{
			dictionary["otpGenerateTime"] = otpGenerateTime
		}
		if permanentAddress != nil{
            dictionary["permanentAddress"] = permanentAddress?.toDictionary()
		}
		if picture != nil{
			dictionary["picture"] = picture
		}
		if role != nil{
            dictionary["role"] = role!.toDictionary()
		}
		if roleId != nil{
			dictionary["roleId"] = roleId
		}
		if temporaryAddress != nil{
            dictionary["temporaryAddress"] = temporaryAddress?.toDictionary()
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
         countryCode = aDecoder.decodeObject(forKey: "CountryCode") as? String
         deviceID = aDecoder.decodeObject(forKey: "DeviceID") as? String
         deviceType = aDecoder.decodeObject(forKey: "DeviceType") as? NSNumber
         dottedManagerID = aDecoder.decodeObject(forKey: "DottedManagerID") as? NSNumber
         emailID = aDecoder.decodeObject(forKey: "EmailID") as? String
         emailVerified = aDecoder.decodeObject(forKey: "EmailVerified") as? Bool
         firstName = aDecoder.decodeObject(forKey: "FirstName") as? String
         gender = aDecoder.decodeObject(forKey: "Gender") as? String
         isAllowApproveLeave = aDecoder.decodeObject(forKey: "IsAllowApproveLeave") as? NSNumber
         isCheckInAllowedFromHome = aDecoder.decodeObject(forKey: "IsCheckInAllowedFromHome") as? Bool
         isFreeze = aDecoder.decodeObject(forKey: "IsFreeze") as? Bool
         joiningDate = aDecoder.decodeObject(forKey: "JoiningDate") as? String
         lastModified = aDecoder.decodeObject(forKey: "LastModified") as? String
         lastModifiedBy = aDecoder.decodeObject(forKey: "LastModifiedBy") as? NSNumber
         lastName = aDecoder.decodeObject(forKey: "LastName") as? String
         manager = aDecoder.decodeObject(forKey: "Manager") as? Manager
         mobileNo1 = aDecoder.decodeObject(forKey: "MobileNo1") as? String
         mobileNo2 = aDecoder.decodeObject(forKey: "MobileNo2") as? String
         securityToken = aDecoder.decodeObject(forKey: "SecurityToken") as? String
         userID = aDecoder.decodeObject(forKey: "UserID") as? NSNumber
         applicationGcmID = aDecoder.decodeObject(forKey: "applicationGcmID") as? ApplicationGcmID
         basetowncityID = aDecoder.decodeObject(forKey: "basetowncityID") as? NSNumber
         branchAddress = aDecoder.decodeObject(forKey: "branchAddress") as? BranchAddres
         branchID = aDecoder.decodeObject(forKey: "branchID") as? NSNumber
         company = aDecoder.decodeObject(forKey: "company") as? Company
         departmentID = aDecoder.decodeObject(forKey: "departmentID") as? NSNumber
         designationID = aDecoder.decodeObject(forKey: "designationID") as? NSNumber
         employeeCode = aDecoder.decodeObject(forKey: "employeeCode") as? String
         gradelevelID = aDecoder.decodeObject(forKey: "gradelevelID") as? NSNumber
         invalidLoginAttempt = aDecoder.decodeObject(forKey: "invalidLoginAttempt") as? NSNumber
         isGeoFencing = aDecoder.decodeObject(forKey: "isGeoFencing") as? Bool
         otpGenerateTime = aDecoder.decodeObject(forKey: "otpGenerateTime") as? String
         permanentAddress = aDecoder.decodeObject(forKey: "permanentAddress") as? PermanentAddres
         picture = aDecoder.decodeObject(forKey: "picture") as? String
         role = aDecoder.decodeObject(forKey: "role") as? Role
         roleId = aDecoder.decodeObject(forKey: "roleId") as? NSNumber
         temporaryAddress = aDecoder.decodeObject(forKey: "temporaryAddress") as? TemporaryAddres

	}
    
    required init(dictionary: [String : Any]) {
        super.init(dictionary: [:])
        
        addressVerified = Common.returndefaultbool(dic: dictionary, keyvalue: "Address_Verified")
        
        applicationID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "ApplicationID")
        
        companyID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "CompanyID")
        
        countryCode = Common.returndefaultstring(dic: dictionary, keyvalue: "CountryCode")
        deviceID =  Common.returndefaultstring(dic: dictionary, keyvalue: "DeviceID")
        deviceType =  Common.returndefaultnsnumber(dic: dictionary, keyvalue: "DeviceType")
        dottedManagerID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "DottedManagerID")
        emailID = Common.returndefaultstring(dic: dictionary, keyvalue: "EmailID")
        emailVerified = Common.returndefaultbool(dic: dictionary, keyvalue: "EmailVerified")
        firstName = Common.returndefaultstring(dic: dictionary, keyvalue: "FirstName")
        gender = Common.returndefaultstring(dic: dictionary, keyvalue: "Gender")
        isAllowApproveLeave = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "IsAllowApproveLeave")
        isCheckInAllowedFromHome =  Common.returndefaultbool(dic: dictionary, keyvalue: "IsCheckInAllowedFromHome")
        isFreeze = Common.returndefaultbool(dic: dictionary, keyvalue: "IsFreeze")
        joiningDate = Common.returndefaultstring(dic: dictionary, keyvalue: "JoiningDate")
        lastModified =  Common.returndefaultstring(dic: dictionary, keyvalue: "LastModified")
        lastModifiedBy =  Common.returndefaultnsnumber(dic: dictionary, keyvalue: "LastModifiedBy")
        lastName = Common.returndefaultstring(dic: dictionary, keyvalue: "LastName")
        manager = Manager.init(dictionary:Common.returndefaultdictionary(dic:dictionary,keyvalue:"Manager"))
        mobileNo1 =  Common.returndefaultstring(dic: dictionary, keyvalue: "MobileNo1")
        mobileNo2 =   Common.returndefaultstring(dic: dictionary, keyvalue: "MobileNo2")
        securityToken =  Common.returndefaultstring(dic: dictionary, keyvalue: "SecurityToken")
        userID =  Common.returndefaultnsnumber(dic: dictionary, keyvalue: "UserID")
        applicationGcmID = ApplicationGcmID.init(dictionary:Common.returndefaultdictionary(dic: dictionary, keyvalue:"applicationGcmID"))
        basetowncityID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "basetowncityID")
        branchAddress = BranchAddres.init(dictionary: Common.returndefaultdictionary(dic: dictionary, keyvalue:"branchAddress"))
        branchID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "branchID")
        company = Company.init(dictionary:Common.returndefaultdictionary(dic: dictionary, keyvalue:"company") )
        departmentID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "departmentID")
        designationID = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "designationID")
        employeeCode =  Common.returndefaultstring(dic: dictionary, keyvalue: "employeeCode")
        gradelevelID =  Common.returndefaultnsnumber(dic: dictionary, keyvalue: "gradelevelID")
        invalidLoginAttempt = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "invalidLoginAttempt")
        isGeoFencing =  Common.returndefaultbool(dic: dictionary, keyvalue: "isGeoFencing")
        otpGenerateTime =  Common.returndefaultstring(dic: dictionary, keyvalue: "otpGenerateTime")
        permanentAddress = PermanentAddres.init(dictionary:Common.returndefaultdictionary(dic:dictionary,keyvalue: "permanentAddress") )
        picture = Common.returndefaultstring(dic: dictionary, keyvalue: "picture")
        role = Role.init(dictionary: Common.returndefaultdictionary(dic:dictionary,keyvalue: "role"))
        roleId = Common.returndefaultnsnumber(dic: dictionary, keyvalue: "roleId")
        temporaryAddress = TemporaryAddres.init(dictionary: Common.returndefaultdictionary(dic:dictionary,keyvalue: "temporaryAddress"))
       
    }
    
    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
      // swiftlint:disable cyclomatic_complexity
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
		if countryCode != nil{
			aCoder.encode(countryCode, forKey: "CountryCode")
		}
		if deviceID != nil{
			aCoder.encode(deviceID, forKey: "DeviceID")
		}
		if deviceType != nil{
			aCoder.encode(deviceType, forKey: "DeviceType")
		}
		if dottedManagerID != nil{
			aCoder.encode(dottedManagerID, forKey: "DottedManagerID")
		}
		if emailID != nil{
			aCoder.encode(emailID, forKey: "EmailID")
		}
		if emailVerified != nil{
			aCoder.encode(emailVerified, forKey: "EmailVerified")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "FirstName")
		}
		if gender != nil{
			aCoder.encode(gender, forKey: "Gender")
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
		if joiningDate != nil{
			aCoder.encode(joiningDate, forKey: "JoiningDate")
		}
		if lastModified != nil{
			aCoder.encode(lastModified, forKey: "LastModified")
		}
		if lastModifiedBy != nil{
			aCoder.encode(lastModifiedBy, forKey: "LastModifiedBy")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "LastName")
		}
		if manager != nil{
			aCoder.encode(manager, forKey: "Manager")
		}
		if mobileNo1 != nil{
			aCoder.encode(mobileNo1, forKey: "MobileNo1")
		}
		if mobileNo2 != nil{
			aCoder.encode(mobileNo2, forKey: "MobileNo2")
		}
		if securityToken != nil{
			aCoder.encode(securityToken, forKey: "SecurityToken")
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
		if branchAddress != nil{
			aCoder.encode(branchAddress, forKey: "branchAddress")
		}
		if branchID != nil{
			aCoder.encode(branchID, forKey: "branchID")
		}
		if company != nil{
			aCoder.encode(company, forKey: "company")
		}
		if departmentID != nil{
			aCoder.encode(departmentID, forKey: "departmentID")
		}
		if designationID != nil{
			aCoder.encode(designationID, forKey: "designationID")
		}
		if employeeCode != nil{
			aCoder.encode(employeeCode, forKey: "employeeCode")
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
		if otpGenerateTime != nil{
			aCoder.encode(otpGenerateTime, forKey: "otpGenerateTime")
		}
		if permanentAddress != nil{
			aCoder.encode(permanentAddress, forKey: "permanentAddress")
		}
		if picture != nil{
			aCoder.encode(picture, forKey: "picture")
		}
		if role != nil{
			aCoder.encode(role, forKey: "role")
		}
		if roleId != nil{
			aCoder.encode(roleId, forKey: "roleId")
		}
		if temporaryAddress != nil{
			aCoder.encode(temporaryAddress, forKey: "temporaryAddress")
		}

	}

}
