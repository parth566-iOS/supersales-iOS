//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 3/1/2020

import Foundation
import CoreData
import FastEasyMapping

@objc(Contact)

class Contact : NSManagedObject{
     // swiftlint:disable line_length
//    static let entity:String! = "Contact"
	@NSManaged var companyID : Int
	@NSManaged var createdBy : Int
	@NSManaged var createdTime : String!
	@NSManaged var customerID : Int
	@NSManaged var customerJoinDate : String!
//    @NSManaged var customerVendor : CustomerVendor!
	@NSManaged var desc : String!
	@NSManaged var designation : String!
	@NSManaged var emailID : String!
	@NSManaged var favourableID : Int64
	@NSManaged var firstName : String!
	@NSManaged var iD : Int64
	@NSManaged var isActive : Bool
	@NSManaged var keyRole : String!
	@NSManaged var lastModifiedBy : Int
	@NSManaged var lastName : String!
	@NSManaged var mobile : String!


   
    class func entityName()->String{
        return "Contact"
    }
    
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "Contact")
      
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "customerID", keyPath: "CustomerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "isActive", keyPath: "IsActive"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "favourableID", keyPath: "FavourableID")) //mapping.addAttribute(Mapping.doubleAttributeFor(property: "favourableID", keyPath: "FavourableID"))
        mapping.addAttributes(from: ["firstName":"FirstName","lastName":"LastName","designation":"Designation","keyRole":"KeyRole","mobile":"Mobile","emailID":"EmailID","customerJoinDate":"CustomerJoinDate","createdTime":"CreatedTime","desc":"Description","type":"CustomerVendor.Type"])
        mapping.primaryKey = "iD"
        
        return mapping
    }
    
    class func getContext()->NSManagedObjectContext{
    return NSManagedObjectContext.mr_default()
}
    class func getAll()->[Contact]{
        let arrContact = (Contact.mr_findAllSorted(by: "firstName", ascending: true) as? [Contact])
        
        return arrContact ?? [Contact]()
    }
    
    class func getContactsUsingCustomerID(customerId:NSNumber)->[Contact]{
        let arrOfContact = Contact.mr_find(byAttribute: "customerID", withValue: customerId) as? [Contact] ?? [Contact]()
        return arrOfContact
    }
    
    class func getContactFromID(contactID:NSNumber)->Contact?{
        if let contact = Contact.mr_findFirst(byAttribute: "iD", withValue: contactID){
            return contact
        }else{
            return nil
        }
    }
//    class getContactsUsingCustomerID (customerId:NSNumer)
//    ->[Contact] {
//    let arrOfContact = Contact.mr
//    return [Contact]()
//    }
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	/*init(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)	{
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)!
		super.init(entity: entity, insertIntoManagedObjectContext: context)
		if let companyIDValue = dictionary["CompanyID"] as? Int{
			companyID = companyIDValue
		}
		if let createdByValue = dictionary["CreatedBy"] as? Int{
			createdBy = createdByValue
		}
		if let createdTimeValue = dictionary["CreatedTime"] as? String{
			createdTime = createdTimeValue
		}
		if let customerIDValue = dictionary["CustomerID"] as? Int{
			customerID = customerIDValue
		}
		if let customerJoinDateValue = dictionary["CustomerJoinDate"] as? String{
			customerJoinDate = customerJoinDateValue
		}
//        if let customerVendorData = dictionary["CustomerVendor"] as? [String:Any]{
//            customerVendor = CustomerVendor(fromDictionary: customerVendorData, context:context)
//        }
		if let descriptionFieldValue = dictionary["Description"] as? String{
			desc = descriptionFieldValue
		}
		if let designationValue = dictionary["Designation"] as? String{
			designation = designationValue
		}
		if let emailIDValue = dictionary["EmailID"] as? String{
			emailID = emailIDValue
		}
		if let favourableIDValue = dictionary["FavourableID"] as? Int{
			favourableID = favourableIDValue
		}
		if let firstNameValue = dictionary["FirstName"] as? String{
			firstName = firstNameValue
		}
		if let iDValue = dictionary["ID"] as? Int{
			iD = iDValue
		}
		if let isActiveValue = dictionary["IsActive"] as? Bool{
			isActive = isActiveValue
		}
		if let keyRoleValue = dictionary["KeyRole"] as? String{
			keyRole = keyRoleValue
		}
		if let lastModifiedByValue = dictionary["LastModifiedBy"] as? Int{
			lastModifiedBy = lastModifiedByValue
		}
		if let lastNameValue = dictionary["LastName"] as? String{
			lastName = lastNameValue
		}
		if let mobileValue = dictionary["Mobile"] as? String{
			mobile = mobileValue
		}
	}*/

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		dictionary["CompanyID"] = companyID
		dictionary["CreatedBy"] = createdBy
		if createdTime != nil{
			dictionary["CreatedTime"] = createdTime
		}
		dictionary["CustomerID"] = customerID
		if customerJoinDate != nil{
			dictionary["CustomerJoinDate"] = customerJoinDate
		}
//        if customerVendor != nil{
//            dictionary["CustomerVendor"] = customerVendor.toDictionary()
//        }
		if desc != nil{
			dictionary["Description"] = description
		}
		if designation != nil{
			dictionary["Designation"] = designation
		}
		if emailID != nil{
			dictionary["EmailID"] = emailID
		}
		dictionary["FavourableID"] = favourableID
		if firstName != nil{
			dictionary["FirstName"] = firstName
		}
		dictionary["ID"] = iD
		dictionary["IsActive"] = isActive
		if keyRole != nil{
			dictionary["KeyRole"] = keyRole
		}
		dictionary["LastModifiedBy"] = lastModifiedBy
		if lastName != nil{
			dictionary["LastName"] = lastName
		}
		if mobile != nil{
			dictionary["Mobile"] = mobile
		}
		return dictionary
	}

}
