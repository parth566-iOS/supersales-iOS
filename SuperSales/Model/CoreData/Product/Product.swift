//
//	RootClass.swift
//
//	Create by Mukesh Yadav on 8/1/2020

import Foundation
import CoreData
import FastEasyMapping

@objc(Product)
class Product : NSManagedObject{

	@NSManaged var barCode : String?
//	@NSManaged var category : Category!
	@NSManaged var closingInventory : Int64
	@NSManaged var companyID : Int64
	@NSManaged var companyTypeID : Int64
	@NSManaged var createdBy : Int64
	@NSManaged var deliveryPeriod : Int64
    @NSManaged var discountA : Float
    @NSManaged var discountB : Float
    @NSManaged var discountC : Float
	//@NSManaged var distributorMaxDiscount : Int
//	@NSManaged var hSNCode : String!
	@NSManaged var isActive : Int64
//	@NSManaged var loyaltyPoint : Int
	@NSManaged var maxdiscount : Double
	@NSManaged var openingInventory : Int64
	@NSManaged var price : Double
	@NSManaged var productCatId : Int64
	@NSManaged var productCode : String?
	@NSManaged var productDriveFlag : Int64
	@NSManaged var productId : Int64
	@NSManaged var productName : String?
	@NSManaged var productSubCatId : Int64
	@NSManaged var purchaseDiscount : Double
	@NSManaged var salesDiscount : Double
	@NSManaged var specifications : String?
	@NSManaged var specifications2 : String?
	@NSManaged var specifications3 : String?
	@NSManaged var specifications4 : String?
	@NSManaged var unitConversion : String?
	@NSManaged var unitConversionRate : Int64
	@NSManaged var unitOfMeasure : String?
    @NSManaged var productPath : String?
    @NSManaged var productPath2 : String?
	@NSManaged var userID : Int64
    

    
   

    class func entityName()->String{
        return "Product"
    }
    
    class func defaultmapping()->FEMMapping{
        
        let mapping = FEMMapping.init(entityName: "Product")
          mapping.addAttribute(Mapping.intAttributeFor(property: "productId", keyPath: "ProductId"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "productCatId", keyPath: "ProductCatId"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "productSubCatId", keyPath: "ProductSubCatId"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "openingInventory", keyPath: "OpeningInventory"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "closingInventory", keyPath: "ClosingInventory"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "price", keyPath: "Price"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "salesDiscount", keyPath: "SalesDiscount"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "deliveryPeriod", keyPath: "DeliveryPeriod"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "user_ID", keyPath: "User_ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyTypeID", keyPath: "CompanyTypeID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
         mapping.addAttribute(Mapping.doubleAttributeFor(property: "purchaseDiscount", keyPath: "PurchaseDiscount"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "isActive", keyPath: "IsActive"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "discountA", keyPath: "DiscountA"))
         mapping.addAttribute(Mapping.floatAttributeFor(property: "discountB", keyPath: "DiscountB"))
         mapping.addAttribute(Mapping.floatAttributeFor(property: "discountC", keyPath: "DiscountC"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "productDriveFlag", keyPath: "ProductDriveFlag"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "maxdiscount", keyPath: "Maxdiscount"))
        mapping.addAttributes(from: ["productName": "ProductName","specifications":"Specifications","specifications2":"Specifications2","specifications3":"Specifications3","specifications4":"Specifications4","barCode":"BarCode","unitOfMeasure":"UnitOfMeasure","productPath":"ProductPath","productPath2":"ProductPath2"])
        mapping.primaryKey = "productId"
        return mapping
    }
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if barCode != nil{
			dictionary["BarCode"] = barCode
		}
//        if category != nil{
//            dictionary["Category"] = category.toDictionary()
//        }
		dictionary["ClosingInventory"] = closingInventory
		dictionary["CompanyID"] = companyID
		dictionary["CompanyTypeID"] = companyTypeID
		dictionary["CreatedBy"] = createdBy
		dictionary["DeliveryPeriod"] = deliveryPeriod
		dictionary["DiscountA"] = discountA
		dictionary["DiscountB"] = discountB
		dictionary["DiscountC"] = discountC
//        dictionary["DistributorMaxDiscount"] = distributorMaxDiscount
//        if hSNCode != nil{
//            dictionary["HSNCode"] = hSNCode
//        }
		dictionary["IsActive"] = isActive
		//dictionary["LoyaltyPoint"] = loyaltyPoint
		dictionary["Maxdiscount"] = maxdiscount
		dictionary["OpeningInventory"] = openingInventory
		dictionary["Price"] = price
		dictionary["ProductCatId"] = productCatId
		if productCode != nil{
			dictionary["ProductCode"] = productCode
		}
		dictionary["ProductDriveFlag"] = productDriveFlag
		dictionary["ProductId"] = productId
		if productName != nil{
			dictionary["ProductName"] = productName
		}
		dictionary["ProductSubCatId"] = productSubCatId
		dictionary["PurchaseDiscount"] = purchaseDiscount
		dictionary["SalesDiscount"] = salesDiscount
		if specifications != nil{
			dictionary["Specifications"] = specifications
		}
		if specifications2 != nil{
			dictionary["Specifications2"] = specifications2
		}
		if specifications3 != nil{
			dictionary["Specifications3"] = specifications3
		}
		if specifications4 != nil{
			dictionary["Specifications4"] = specifications4
		}
		if unitConversion != nil{
			dictionary["UnitConversion"] = unitConversion
		}
		dictionary["UnitConversionRate"] = unitConversionRate
		if unitOfMeasure != nil{
			dictionary["UnitOfMeasure"] = unitOfMeasure
		}
		dictionary["User_ID"] = userID
		return dictionary
	}
    // MARK: Custome method
    class func getAll()->[Product]{

        let predicate = NSPredicate.init(format: "isActive = 1", [] )
        return Product.mr_findAllSorted(by: "productName", ascending: true, with: predicate) as? [Product] ?? [Product]()
    }
    
    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
    class func getProductUsingPredicate(predicate:NSPredicate)->[Product]{
        // return [[Product MR_findAllSortedBy:@"productName" ascending:YES withPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]] mutableCopy];
        return Product.mr_findAllSorted(by: "productName", ascending: true, with: predicate) as? [Product] ?? [Product]()
        //return Product.mr_findAllSorted(by: "productName", ascending: true, with: predicate, in: AppDelegate.shared.managedObjectContext) as? [Product] ?? [Product]()
    }
    
    class func getProductIdFromCategoryID(catID:NSNumber)->[Product]{
        /*
         NSMutableArray *array = [[Product MR_findByAttribute:@"productCatId" withValue:productCategoryID inContext:[NSManagedObjectContext MR_defaultContext]] mutableCopy];
         NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:[array valueForKey:@"productId"]];
         NSSet *uniqueStates = [orderedSet set];
         
         return [NSMutableArray arrayWithArray:[uniqueStates allObjects]];
         
         */
        let arrProduct = Product.mr_find(byAttribute: "productCatId", withValue: catID) as? [Product] ?? [Product]()
        
        return arrProduct
    }
    
    class func getProduct(productID:NSNumber)->Product?{
        if let product =  (Product.mr_find(byAttribute: "productId", withValue: productID, andOrderBy: "productId", ascending:false) as? [Product])?.first as? Product{
            return product
        }else{
            return nil
        }
        
    }
    
    class func getProductName(productID:NSNumber)->String{
        
       /* if let product = self.getProduct(productID: productID) as? Product{
            if(product.productName?.count ?? 0 > 0){
                return product.productName ?? ""
            }else if(product.productSubCatId > 0){
                if let subcat = ProductSubCat.getSubCatName(subcatid: NSNumber.init(value:product.productSubCatId)) as? String{
                    return String.init(format:"SubCat: \(subcat)")
                }else{
                    return " "
                }
            }else{
                if let catname = ProdCategory.getCategoryName(catId: NSNumber.init(value: product.productCatId)) as? String{
                    return String.init(format:"Cat: \(catname)")
                }else{
                    return " "
                }
            }
      
        }else{
            return " "
        }*/
        if(productID.intValue > 0){
            if let product = self.getProduct(productID: productID) as? Product{
                return product.productName ?? ""
            }else{
                return ""
            }
        }else{
            return ""
        }
    }
    
    
    class func getProductFromBarcode(barcode:String)->Product?{
        if let product = Product.mr_find(byAttribute: "barCode", withValue: barcode)?.first as? Product{
            return product
        }else{
            return nil
        }
        
    }
}
