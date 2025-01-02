//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 6/1/2020

import Foundation
import CoreData
import FastEasyMapping

@objc(Vendor)
class Vendor : NSManagedObject{

	@NSManaged var addressList : NSOrderedSet!
	@NSManaged var birthDate : String!
	@NSManaged var companyID : Int
	@NSManaged var companyTypeID : Int
	@NSManaged var createdBy : Int
	@NSManaged var customerClass : Int
	@NSManaged var customerCode : String!
	@NSManaged var customerImage : String!
	@NSManaged var descriptionField : String!
	@NSManaged var distributorID : Int
	@NSManaged var emailID : String!
	@NSManaged var iD : Int
	@NSManaged var keyCustomer : Bool
	@NSManaged var landlineNo : String!
	@NSManaged var lastModified : String!
	@NSManaged var lastModifiedBy : Int
	@NSManaged var logo : String!
	@NSManaged var mobileNo : String!
	@NSManaged var name : String!
	@NSManaged var ownerID : Int
	@NSManaged var segmentID : Int
	@NSManaged var statusID : Int
	@NSManaged var taggedRole : Int
	@NSManaged var taggedStatus : String!
	@NSManaged var taggedToID : Int
	@NSManaged var taggedToName : String!
	@NSManaged var taxType : String!
	@NSManaged var townID : Int64
	@NSManaged var transactional : Bool
	@NSManaged var type : String!
	@NSManaged var vATCode : Int
	@NSManaged var visitFrequency : Int
	@NSManaged var visitingCard : String!
	@NSManaged var addressID : Int
	@NSManaged var isActive : Bool
	@NSManaged var isAdminSuperAdmin : Int
	@NSManaged var priviledgeID : Int
	@NSManaged var territoryCode : String!
	@NSManaged var territoryID : Int
	@NSManaged var verified : Bool

    class func entityName()->String{
        return "Vendor"
    }
    
    //AddressList
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "Vendor")
       // let mapping = FEMMapping.init(objectClass: Vendor.self);
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
   //     mapping.addAttribute(Mapping.intAttributeFor(property: "townID", keyPath: "TownID"))//TownID
        mapping.addAttribute(Mapping.intAttributeFor(property: "ownerID", keyPath: "OwnerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyTypeID", keyPath: "CompanyTypeID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isActive", keyPath: "IsActive"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "taggedRole", keyPath: "TaggedRole"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "keyCustomer", keyPath: "Key_Customer"))
          mapping.addAttribute(Mapping.boolAttributeFor(property: "transactional", keyPath: "Transactional"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "taggedRole", keyPath: "TaggedRole"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "priviledgeID", keyPath: "priviledgeID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isAdminSuperAdmin", keyPath: "isAdminSuperAdmin"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "segmentID", keyPath: "SegmentID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "customerClass", keyPath: "CustomerClass"))
        /*FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[Person class]];
        FEMMapping *phoneMapping = [[FEMMapping alloc] initWithObjectClass:[Phone class]];
        
        [mapping addToManyRelationshipMapping:phoneMapping property:@"phones" keyPath:@"phones"];*/
       // let addressmapping = FEMMapping.init(objectClass: AddressList.self)
        //mapping.addToManyRelationshipMapping(addressmapping, forProperty: "addressList", keyPath: "AddressList")
        mapping.addToManyRelationshipMapping(AddressList.defaultmapping(), forProperty: "addressList", keyPath: "AddressList")
        mapping.addAttributes(from: ["name": "Name","logo":"Logo","mobileNo":"MobileNo","landlineNo":"LandlineNo","emailID":"EmailID","type":"Type","desc":"Description","taxType":"Tax_Type","taggedToName":"TaggedToName","lastModified":"LastModified","taggedStatus":"TaggedStatus","customerCode":"CustomerCode","customerImage":"CustomerImage","visitingCard":"VisitingCard","customerGSTNo":"CustomerGSTNo"])
        
        mapping.primaryKey = "iD"
        return mapping
    }
    
    func getVendorById(aId:NSNumber)->Vendor?{
        
        if  let vendor = Vendor.mr_findFirst(byAttribute: "iD", withValue: aId){
        return vendor
        
    }else{
    return nil
    }
    }
    
    class func getAll()->[Vendor]{
        let predicate = NSPredicate.init(format: "type contains[cd] 'V' ", argumentArray: nil)
        return Vendor.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [Vendor] ?? [Vendor]()
    }
    
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if addressList != nil{
			var dictionaryElements = [[String:Any]]()
			for addressListElement in addressList {
                dictionaryElements.append((addressListElement as? AddressList ?? AddressList()).toDictionary())
			}
			dictionary["AddressList"] = dictionaryElements
		}
		if birthDate != nil{
			dictionary["BirthDate"] = birthDate
		}
		dictionary["CompanyID"] = companyID
		dictionary["CompanyTypeID"] = companyTypeID
		dictionary["CreatedBy"] = createdBy
		dictionary["CustomerClass"] = customerClass
		if customerCode != nil{
			dictionary["CustomerCode"] = customerCode
		}
		if customerImage != nil{
			dictionary["CustomerImage"] = customerImage
		}
		if descriptionField != nil{
			dictionary["Description"] = descriptionField
		}
		dictionary["DistributorID"] = distributorID
		if emailID != nil{
			dictionary["EmailID"] = emailID
		}
		dictionary["ID"] = iD
		dictionary["Key_Customer"] = keyCustomer
		if landlineNo != nil{
			dictionary["LandlineNo"] = landlineNo
		}
		if lastModified != nil{
			dictionary["LastModified"] = lastModified
		}
		dictionary["LastModifiedBy"] = lastModifiedBy
		if logo != nil{
			dictionary["Logo"] = logo
		}
		if mobileNo != nil{
			dictionary["MobileNo"] = mobileNo
		}
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
		if taggedToName != nil{
			dictionary["TaggedToName"] = taggedToName
		}
		if taxType != nil{
			dictionary["Tax_Type"] = taxType
		}
		dictionary["TownID"] = townID
		dictionary["Transactional"] = transactional
		if type != nil{
			dictionary["Type"] = type
		}
		dictionary["VATCode"] = vATCode
		dictionary["VisitFrequency"] = visitFrequency
		if visitingCard != nil{
			dictionary["VisitingCard"] = visitingCard
		}
		dictionary["addressID"] = addressID
		dictionary["isActive"] = isActive
		dictionary["isAdminSuperAdmin"] = isAdminSuperAdmin
		dictionary["priviledgeID"] = priviledgeID
		if territoryCode != nil{
			dictionary["territoryCode"] = territoryCode
		}
		dictionary["territoryId"] = territoryID
		dictionary["verified"] = verified
		return dictionary
	}

}
