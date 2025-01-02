//
//	CustomerVendor.swift
//
//	Create by Mukesh Yadav on 3/1/2020

import Foundation
import CoreData


class CustomerVendor : ParsableModel{

	@NSManaged var rootClass : RootClass!
	@NSManaged var companyID : Int
	@NSManaged var companyTypeID : Int
	@NSManaged var createdBy : Int
	@NSManaged var customerClass : Int
	@NSManaged var distributorID : Int
	@NSManaged var iD : Int
	@NSManaged var keyCustomer : Bool
	@NSManaged var lastModifiedBy : Int
	@NSManaged var name : String!
	@NSManaged var ownerID : Int
	@NSManaged var segmentID : Int
	@NSManaged var statusID : Int
	@NSManaged var taggedRole : Int
	@NSManaged var taggedStatus : String!
	@NSManaged var taggedToID : Int
	@NSManaged var townID : Int
	@NSManaged var transactional : Bool
	@NSManaged var type : String!
	@NSManaged var vATCode : Int
	@NSManaged var visitFrequency : Int
	@NSManaged var addressID : Int
	@NSManaged var isActive : Bool
	@NSManaged var isAdminSuperAdmin : Int
	@NSManaged var priviledgeID : Int
	@NSManaged var territoryID : Int
	@NSManaged var verified : Bool


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)	{
		let entity = NSEntityDescription.entityForName("CustomerVendor", inManagedObjectContext: context)!
		super.init(entity: entity, insertIntoManagedObjectContext: context)
		if let rootClassData = dictionary["rootClass"] as? [String:Any]{
			rootClass = RootClass(fromDictionary: rootClassData, context:context)
		}
		if let companyIDValue = dictionary["CompanyID"] as? Int{
			companyID = companyIDValue
		}
		if let companyTypeIDValue = dictionary["CompanyTypeID"] as? Int{
			companyTypeID = companyTypeIDValue
		}
		if let createdByValue = dictionary["CreatedBy"] as? Int{
			createdBy = createdByValue
		}
		if let customerClassValue = dictionary["CustomerClass"] as? Int{
			customerClass = customerClassValue
		}
		if let distributorIDValue = dictionary["DistributorID"] as? Int{
			distributorID = distributorIDValue
		}
		if let iDValue = dictionary["ID"] as? Int{
			iD = iDValue
		}
		if let keyCustomerValue = dictionary["Key_Customer"] as? Bool{
			keyCustomer = keyCustomerValue
		}
		if let lastModifiedByValue = dictionary["LastModifiedBy"] as? Int{
			lastModifiedBy = lastModifiedByValue
		}
		if let nameValue = dictionary["Name"] as? String{
			name = nameValue
		}
		if let ownerIDValue = dictionary["OwnerID"] as? Int{
			ownerID = ownerIDValue
		}
		if let segmentIDValue = dictionary["SegmentID"] as? Int{
			segmentID = segmentIDValue
		}
		if let statusIDValue = dictionary["StatusID"] as? Int{
			statusID = statusIDValue
		}
		if let taggedRoleValue = dictionary["TaggedRole"] as? Int{
			taggedRole = taggedRoleValue
		}
		if let taggedStatusValue = dictionary["TaggedStatus"] as? String{
			taggedStatus = taggedStatusValue
		}
		if let taggedToIDValue = dictionary["TaggedToID"] as? Int{
			taggedToID = taggedToIDValue
		}
		if let townIDValue = dictionary["TownID"] as? Int{
			townID = townIDValue
		}
		if let transactionalValue = dictionary["Transactional"] as? Bool{
			transactional = transactionalValue
		}
		if let typeValue = dictionary["Type"] as? String{
			type = typeValue
		}
		if let vATCodeValue = dictionary["VATCode"] as? Int{
			vATCode = vATCodeValue
		}
		if let visitFrequencyValue = dictionary["VisitFrequency"] as? Int{
			visitFrequency = visitFrequencyValue
		}
		if let addressIDValue = dictionary["addressID"] as? Int{
			addressID = addressIDValue
		}
		if let isActiveValue = dictionary["isActive"] as? Bool{
			isActive = isActiveValue
		}
		if let isAdminSuperAdminValue = dictionary["isAdminSuperAdmin"] as? Int{
			isAdminSuperAdmin = isAdminSuperAdminValue
		}
		if let priviledgeIDValue = dictionary["priviledgeID"] as? Int{
			priviledgeID = priviledgeIDValue
		}
		if let territoryIDValue = dictionary["territoryID"] as? Int{
			territoryID = territoryIDValue
		}
		if let verifiedValue = dictionary["verified"] as? Bool{
			verified = verifiedValue
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if rootClass != nil{
			dictionary["rootClass"] = rootClass.toDictionary()
		}
		dictionary["CompanyID"] = companyID
		dictionary["CompanyTypeID"] = companyTypeID
		dictionary["CreatedBy"] = createdBy
		dictionary["CustomerClass"] = customerClass
		dictionary["DistributorID"] = distributorID
		dictionary["ID"] = iD
		dictionary["Key_Customer"] = keyCustomer
		dictionary["LastModifiedBy"] = lastModifiedBy
		if name != nil{
			dictionary["Name"] = name
		}
		dictionary["OwnerID"] = ownerID
		dictionary["SegmentID"] = segmentID
		dictionary["StatusID"] = statusID
		dictionary["TaggedRole"] = taggedRole
		if taggedStatus != nil{
			dictionary["TaggedStatus"] = taggedStatus
		}
		dictionary["TaggedToID"] = taggedToID
		dictionary["TownID"] = townID
		dictionary["Transactional"] = transactional
		if type != nil{
			dictionary["Type"] = type
		}
		dictionary["VATCode"] = vATCode
		dictionary["VisitFrequency"] = visitFrequency
		dictionary["addressID"] = addressID
		dictionary["isActive"] = isActive
		dictionary["isAdminSuperAdmin"] = isAdminSuperAdmin
		dictionary["priviledgeID"] = priviledgeID
		dictionary["territoryID"] = territoryID
		dictionary["verified"] = verified
		return dictionary
	}

}