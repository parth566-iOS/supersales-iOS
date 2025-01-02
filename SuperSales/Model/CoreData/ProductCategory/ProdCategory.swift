//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 7/1/2020

import Foundation
import CoreData
import FastEasyMapping

@objc(ProdCategory)
class ProdCategory : NSManagedObject{

    static let entity:String! = "ProdCategory"
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
	@NSManaged var isActive : Int64
	@NSManaged var lastModifiedBy : Int64
	@NSManaged var name : String!
	@NSManaged var sGSTSurcharges : Int64
    @NSManaged var sGSTTax : Double
	@NSManaged var serviceSurcharge : Int64
	@NSManaged var serviceTax : Float
	@NSManaged var superCatID : Int64
	@NSManaged var userID : Int64
    @NSManaged var vAT : Double
	@NSManaged var vATAdditionalTax : Int64
	@NSManaged var vATCode : Int16
	@NSManaged var vATSurcharges : Int64
	@NSManaged var maxdata : Int64
    @NSManaged var productSubCategory : NSOrderedSet


    class func entityName()->String{
        return "ProdCategory"
    }
    
    class func defaultmapping()->FEMMapping{
         let mapping = FEMMapping.init(entityName: "ProdCategory")
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "categoryType", keyPath: "CategoryType"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "vAT", keyPath: "VAT"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "vATSurcharges", keyPath: "VATSurcharges"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "vATAdditionalTax", keyPath: "VATAdditionalTax"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "vATCode", keyPath: "VATCode"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "exciseDuty", keyPath: "ExciseDuty"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "exciseSurcharge", keyPath: "ExciseSurcharge"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "serviceTax", keyPath: "ServiceTax"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "serviceSurcharge", keyPath: "ServiceSurcharge"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "cST", keyPath: "CST"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "cSTSurcharge", keyPath: "CSTSurcharge"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "superCatID", keyPath: "SuperCatID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "userID", keyPath: "UserID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isActive", keyPath: "IsActive"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "maxdata", keyPath: "maxdata"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
    //mapping.addRelationshipMapping(ProductSubCat.defaultmapping(), forProperty: "productSubCategory", keyPath: "subCategory")
        mapping.addToManyRelationshipMapping(ProductSubCat.defaultmapping(), forProperty: "productSubCategory", keyPath: "subCategory")
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "cGSTSurcharges", keyPath: "CGSTSurcharges"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "cGSTTax", keyPath: "CGSTTax"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "gSTEnabled", keyPath: "GSTEnabled"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "iGSTSurcharges", keyPath: "IGSTSurcharges"))
    mapping.addAttribute(Mapping.doubleAttributeFor(property: "iGSTTax", keyPath: "IGSTTax"))
    mapping.addAttribute(Mapping.doubleAttributeFor(property: "sGSTSurcharges", keyPath: "SGSTSurcharges"))
    mapping.addAttribute(Mapping.doubleAttributeFor(property: "sGSTTax", keyPath: "SGSTTax"))
        mapping.addAttributes(from: ["name":"Name"])
        mapping.primaryKey = "iD"
        
        return mapping
    }
    
    // MARK: Custom Method
   class func getAll()->[ProdCategory]{
    
        let predicate = NSPredicate.init(format: "isActive = 1 ", argumentArray: nil)
        return ProdCategory.mr_findAllSorted(by: "name", ascending: true, with: predicate) as? [ProdCategory] ?? [ProdCategory]()
    }
    
    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
    
    class func getProductByCatID(catId:NSNumber)->ProdCategory?{
        if   let productcategory = ProdCategory.mr_findFirst(byAttribute: "iD", withValue: catId){
            //ProdCategory.mr_findFirst(byAttribute: "iD", withValue: catId, in: AppDelegate().managedcontextobjectappdelegate)
        return productcategory
        }else{
            return nil
        }
    }
    
    class func getproductBysuperCatID(supercatId:NSNumber)->ProdCategory
    {
         let productcategory = ProdCategory.mr_findFirst(byAttribute: "superCatID", withValue: supercatId)
     
        return productcategory ?? ProdCategory()
    }
    
    class func getCategoryName(catId:NSNumber)->String{
       
        let productcategory = ProdCategory.mr_findFirst(byAttribute: "iD", withValue: catId)
        return productcategory?.name ?? ""
        //return productcategory.name //?? ""
    }
    
   
    /**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
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
//        if productSubCategory != nil{
//            let dictionaryElements = NSMutableOrderedSet()//[[String:Any]]()
//            for subCategoryElement in ProdCategory {
//                dictionaryElements.add(subCategoryElement)
//               // dictionaryElements.append((subCategoryElement as! ProductSubCat).toDictionary())
//            }
//            dictionary["subCategory"] = dictionaryElements
//        }
		return dictionary
	}

}
