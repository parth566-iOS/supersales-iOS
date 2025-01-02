//
//	Category.swift
//
//	Create by Mukesh Yadav on 8/1/2020

import Foundation
import CoreData

@objc(Category)
class Category : NSManagedObject{

	@NSManaged var product : Product!
	@NSManaged var cGSTSurcharges : Int
	@NSManaged var cGSTTax : Int
	@NSManaged var cST : Int
	@NSManaged var cSTSurcharge : Int
	@NSManaged var categoryType : Int
	@NSManaged var companyID : Int
	@NSManaged var createdBy : Int
	@NSManaged var exciseDuty : Int
	@NSManaged var exciseSurcharge : Int
	@NSManaged var gSTEnabled : Int
	@NSManaged var iD : Int
	@NSManaged var iGSTSurcharges : Int
	@NSManaged var iGSTTax : Int
	@NSManaged var isActive : Int
	@NSManaged var lastModifiedBy : Int
	@NSManaged var name : String!
	@NSManaged var sGSTSurcharges : Int
	@NSManaged var sGSTTax : Int
	@NSManaged var serviceSurcharge : Int
	@NSManaged var serviceTax : Float
	@NSManaged var superCatID : Int
	@NSManaged var userID : Int
	@NSManaged var vAT : Int
	@NSManaged var vATAdditionalTax : Int
	@NSManaged var vATCode : Int
	@NSManaged var vATSurcharges : Int
	@NSManaged var maxdata : Int


	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
//        if rootClass != nil{
//            dictionary["rootClass"] = rootClass.toDictionary()
//        }
		dictionary["CGSTSurcharges"] = cGSTSurcharges
		dictionary["CGSTTax"] = cGSTTax
		dictionary["CST"] = cST
		dictionary["CSTSurcharge"] = cSTSurcharge
		dictionary["CategoryType"] = categoryType
		dictionary["CompanyID"] = companyID
		dictionary["CreatedBy"] = createdBy
		dictionary["ExciseDuty"] = exciseDuty
		dictionary["ExciseSurcharge"] = exciseSurcharge
		dictionary["GSTEnabled"] = gSTEnabled
		dictionary["ID"] = iD
		dictionary["IGSTSurcharges"] = iGSTSurcharges
		dictionary["IGSTTax"] = iGSTTax
		dictionary["IsActive"] = isActive
		dictionary["LastModifiedBy"] = lastModifiedBy
		if name != nil{
			dictionary["Name"] = name
		}
		dictionary["SGSTSurcharges"] = sGSTSurcharges
		dictionary["SGSTTax"] = sGSTTax
		dictionary["ServiceSurcharge"] = serviceSurcharge
		dictionary["ServiceTax"] = serviceTax
		dictionary["SuperCatID"] = superCatID
		dictionary["UserID"] = userID
		dictionary["VAT"] = vAT
		dictionary["VATAdditionalTax"] = vATAdditionalTax
		dictionary["VATCode"] = vATCode
		dictionary["VATSurcharges"] = vATSurcharges
		dictionary["maxdata"] = maxdata
		return dictionary
	}

}
