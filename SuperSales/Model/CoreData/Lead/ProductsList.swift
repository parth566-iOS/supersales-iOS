//
//	ProductsList.swift
//
//	Create by Mukesh Yadav on 9/1/2020

import Foundation
import CoreData
import FastEasyMapping

@objc(ProductList)
class ProductsList : NSManagedObject{

	@NSManaged var rootClass : Lead!
	@NSManaged var budget : NSDecimalNumber?
	@NSManaged var categoryID : Int64
	@NSManaged var categoryType : Int64
	@NSManaged var leadID : Int64
    @NSManaged var leadStatusID : Int64
	@NSManaged var productID : Int64
	@NSManaged var productName : String!
     @NSManaged var subCategoryName : String!
     @NSManaged var categoryName : String!
	@NSManaged var quantity : Int64
	@NSManaged var subcategoryID : Int64
    @NSManaged var visitID : Int64
     @NSManaged var isnewproduct:Int16
    
    class func entityName()->String{
        return "ProductList"
    }
    
    class func defaultmapping()->FEMMapping{
     let mapping = FEMMapping.init(entityName: "ProductList")
     mapping.addAttribute(Mapping.intAttributeFor(property: "visitID", keyPath: "VisitID"))
     mapping.addAttribute(Mapping.intAttributeFor(property: "leadID", keyPath: "LeadID"))
     mapping.addAttribute(Mapping.intAttributeFor(property: "productID", keyPath: "ProductID"))
     mapping.addAttribute(Mapping.intAttributeFor(property: "quantity", keyPath: "Quantity"))
     mapping.addAttribute(Mapping.intAttributeFor(property: "categoryID", keyPath: "CategoryID"))
     mapping.addAttribute(Mapping.intAttributeFor(property: "subcategoryID", keyPath: "SubCategoryID"))//SubCategoryID
     mapping.addAttribute(Mapping.intAttributeFor(property: "budget", keyPath: "Budget"))
     mapping.addAttribute(Mapping.intAttributeFor(property: "leadStatusID", keyPath: "LeadStatusID"))
     mapping.addAttribute(Mapping.intAttributeFor(property: "categoryType", keyPath: "CategoryType"))
     mapping.addAttribute(Mapping.intAttributeFor(property: "isnewproduct", keyPath: "isNewProduct"))
    // mapping.addAttribute(Mapping.boolAttributeFor(property: "isNewProduct", keyPath: "isnewproduct"))
     mapping.addAttributes(from: ["productName":"ProductName","categoryName":"CategoryName","subCategoryName":"SubCategoryName"])//productName
     return mapping
    }

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
//		if rootClass != nil{
//			dictionary["rootClass"] = rootClass.toDictionary()
//		}n 
		dictionary["Budget"] = budget
		dictionary["CategoryID"] = categoryID
		dictionary["CategoryType"] = categoryType
		dictionary["LeadID"] = leadID
		dictionary["ProductID"] = productID
		if productName != nil{
			dictionary["productName"] = productName
		}
		dictionary["Quantity"] = quantity
     //if let strcubcategoruId = self.subCategoryID as? Int64{
     
		//dictionary["SubCategoryID"] = subCategoryID
//     }else{
//          dictionary["SubCategoryID"] = 0
//     }
		return dictionary
	}

    // MARK: Custom method
    class func getProductNameFromId(productID:NSNumber)->String{
        let product = ProductsList.mr_findFirst(byAttribute: "productID", withValue: productID)  ?? ProductsList()
        return product.productName ?? ""
    }
    
    class func getProductBy(productId:NSNumber)->ProductsList{
        return (ProductsList.mr_find(byAttribute: "productID", withValue: productId, andOrderBy: "productID", ascending:false) as? [ProductsList])?.first ?? ProductsList()
    }
}
