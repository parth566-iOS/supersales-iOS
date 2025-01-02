//
//	SubCategory.swift
//
//	Create by Mukesh Yadav on 7/1/2020

import Foundation
import CoreData
import FastEasyMapping

@objc(ProductSubCat)
class ProductSubCat : NSManagedObject{
    
 static let entity:String! = "ProductSubCat"   //let entity:String! = "ProductSubCat"
	@NSManaged var rootClass : ProdCategory!
	@NSManaged var cGSTSurcharges : Int64
    @NSManaged var cGSTTax : Double
	@NSManaged var cST : Int64
	@NSManaged var cSTSurcharge : Int64
	@NSManaged var categoryType : Int64
	@NSManaged var companyID : Int64
	@NSManaged var createdBy : Int64
	@NSManaged var exciseDuty : Int64
	@NSManaged var exciseSurcharge : Int64
	@NSManaged var gSTEnabled : Int64
	@NSManaged var iD : Int64
	@NSManaged var iGSTSurcharges : Int64
    @NSManaged var iGSTTax : Double
    @NSManaged var isActive : Bool
	@NSManaged var lastModifiedBy : Int64
	@NSManaged var name : String!
	@NSManaged var sGSTSurcharges : Int64
    @NSManaged var sGSTTax : Double
	@NSManaged var serviceSurcharge : Int64
	@NSManaged var serviceTax : Float
	@NSManaged var superCatID : Int64
	@NSManaged var userID : Int64
    @NSManaged var vAT : Float
	@NSManaged var vATAdditionalTax : Int64
	@NSManaged var vATCode : Int16
	@NSManaged var vATSurcharges : Int64
	@NSManaged var maxdata : Int64

    class func entityName()->String{
        return "ProductSubCat"
    }
    
    class func defaultmapping()->FEMMapping{
        
        let mapping = FEMMapping.init(entityName: "ProductSubCat")
        mapping.addAttribute(Mapping.intAttributeFor(property: "categoryType", keyPath: "CategoryType"))
        // mapping.addAttributes(from: ["companyID"])
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "cST", keyPath: "CST"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "CGSTTax", keyPath: "CGSTTax"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "cSTSurcharge", keyPath: "CSTSurcharge"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "exciseDuty", keyPath: "ExciseDuty"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "exciseSurcharge", keyPath: "ExciseSurcharge"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "isActive", keyPath: "IsActive"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "user_ID", keyPath: "User_ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "maxdata", keyPath: "maxdata"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "superCatID", keyPath: "SuperCatID"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "serviceSurcharge", keyPath: "ServiceSurcharge"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "serviceTax", keyPath: "ServiceTax"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "vAT" , keyPath: "VAT"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "vATAdditionalTax" , keyPath: "VATAdditionalTax"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "vATCode", keyPath: "VATCode"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "vATSurcharges", keyPath: "VATSurcharges"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "cGSTSurcharges", keyPath: "CGSTSurcharges"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "gSTEnabled", keyPath: "GSTEnabled"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "iGSTSurcharges", keyPath: "IGSTSurcharges"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "iGSTTax", keyPath: "IGSTTax"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "sGSTSurcharges", keyPath: "SGSTSurcharges"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "sGSTTax", keyPath: "SGSTTax"))
        mapping.addAttributes(from: ["name":"Name"])
        mapping.primaryKey = "iD"
        return mapping
    }//

    
    // MARK: - (Custom method)
    class func getAll()->[ProductSubCat]{
        let predicate = NSPredicate.init(format: "isActive = 1", [])
        return ProductSubCat.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [ProductSubCat] ?? [ProductSubCat]()
    }
    
    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
    
    class func getSubProductFromCategoryID(categoryID:NSNumber)->[ProductSubCat]{
      //  var arrOfSubCat = ProductSubCat.mr_find(byAttribute: "superCatID", withValue: categoryID, andOrderBy: "iD", ascending: true)
//        let predicate = NSPredicate.init(format: "isActive = 1", argumentArray: [])
        /* var filteredArray = arrayOfUsers.filter( { (user: UserDetails) -> Bool in
        return user.userID == "1"
    })*/
       // var arrFilterSubCat  = arrOfSubCat?.filter({(subCat:ProductSubCat)-> Int64 in return (subCat.isActive == 1) })
      //  let filteredArray = arrOfSubCat.filter() { $0.isActive == 1 }
        var filteredArray = ProductSubCat.mr_find(byAttribute: "superCatID", withValue: categoryID , andOrderBy: "iD", ascending: true) as? [ProductSubCat] ?? [ProductSubCat]()
        if(filteredArray.count > 0){
//            var filterdActiveArray = filteredArray
//        for i in 0...filteredArray.count - 1 {
//            print("i = \(i) , count = \(filteredArray.count - 1)")
//            let subcat = filterdActiveArray[i]
//            if(subcat.isActive != true){
//                filterdActiveArray.remove(at: i)
//            }
//        }
//            filteredArray = filterdActiveArray
            filteredArray = filteredArray.compactMap { (temp) -> ProductSubCat? in
            return temp
            }.filter { (aUser) -> Bool in
                return aUser.isActive == true
          }//Product
        }
        
        return filteredArray
    }
    
    class func getSubCatProduct(subcatid:NSNumber)->ProductSubCat?{
        //.mr_findFirst
        if let subcat = ProductSubCat.mr_findFirst(byAttribute: "iD",withValue:subcatid){
            return subcat
            
        } else{
            return nil
        }
    }
    
    class func getSubCatName(subcatid:NSNumber)->String{
        let subcat = ProductSubCat.mr_findFirst(byAttribute: "iD",withValue:subcatid)
        return subcat?.name ?? ""
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
