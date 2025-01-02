//
//  SOrder.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(SOrder)
class SOrder: NSManagedObject {
    
    @NSManaged var iD:Int64
    @NSManaged var seriesPostfix:Int64
    @NSManaged var seriesPrefix:String
    @NSManaged var customerID:Int64
    @NSManaged var customerName:String
    @NSManaged var leadID:Int64
    @NSManaged var visitID:Int64
    @NSManaged var editStatusID:Int16
    @NSManaged var leadSeriesPostfix:Int64
    @NSManaged var leadSeriesPrefix:String
    @NSManaged var proposalID:Int64
    @NSManaged var proposalSeriesPostfix:Int64
    @NSManaged var proposalSeriesPrefix:String
    @NSManaged var warranty:String
    @NSManaged var dealerCode:String
    @NSManaged var dealerCity:String
    @NSManaged var grossAmount:Double
    @NSManaged var statusID:Int16
    @NSManaged var localTaxID:Int16
    @NSManaged var localTaxSurcharge:Int64
    @NSManaged var localTaxValue:Double
    @NSManaged var netAmount:Double
    @NSManaged var tnc:String
    @NSManaged var deliveryDays:Int32
    @NSManaged var productDispatchedStatusID:Int64
    @NSManaged var approvedBy:Int64
    @NSManaged var approvedTo:Int64
    @NSManaged var desc:String
    @NSManaged var companyID:Int64
    @NSManaged var createdBy:Int64
    @NSManaged var createdTime:String
    @NSManaged var lastModifiedBy:Int64
    @NSManaged var lastModifiedTime:String
    @NSManaged var assignedBy:Int64
    @NSManaged var assignedTo:Int64
    @NSManaged var isActive:Int64
    @NSManaged var filterCategoryID:Int64
    @NSManaged var filterProduct:Int64
    @NSManaged var filterType:Int64
    @NSManaged var filterUser:Int64
    @NSManaged var fulfilledByID:Int64
    @NSManaged var sortType:Int64
    @NSManaged var totalQuantity:Int32
    @NSManaged var finalSalesAmount:Double
    @NSManaged var totalGrossAmount:Double
    @NSManaged var totalDiscount: Double
    @NSManaged var totalNetAmount:Double
    @NSManaged var totalTaxAmount:Double
    @NSManaged var flatPromotionPercentage:Float
    @NSManaged var isExceedsMaxDiscount:Bool
    @NSManaged var isPromotionApplied:Int16
    @NSManaged var promotionAmount:Double
    @NSManaged var promotionID:Int64
    @NSManaged var sOMadeBy:String
    @NSManaged var sOMadeFrom:String
    @NSManaged var promotionName:String
    @NSManaged var totalPromotionAmount:Double
    @NSManaged var soProductList:NSOrderedSet
    
    class func entityName()->String{
        return "SOrder"
    }
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "SOrder")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedBy", keyPath: "ApprovedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedTo", keyPath: "ApprovedTo"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "assignedBy", keyPath: "AssignedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "assignedTo", keyPath: "AssignedTo"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "customerID", keyPath:"CustomerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "filterType", keyPath: "FilterType"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "sortType", keyPath: "SortType"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "filterUser", keyPath:"FilterUser"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "filterProduct", keyPath:"FilterProduct"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "filterCategoryID", keyPath:"FilterCategoryID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "fulfilledByID", keyPath:"FulfilledByID"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "grossAmount", keyPath:"GrossAmount"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "grossAmount", keyPath: "GrossAmount"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isActive", keyPath: "IsActive"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadID", keyPath: "LeadID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitID", keyPath: "VisitID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadSeriesPostfix", keyPath: "LeadSeriesPostfix"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "localTaxID", keyPath: "LocalTaxID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "localTaxSurcharge", keyPath: "LocalTaxSurcharge"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "localTaxValue", keyPath: "LocalTaxValue"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "netAmount", keyPath: "NetAmount"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadSeriesPostfix", keyPath: "LeadSeriesPostfix"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "proposalID", keyPath: "ProposalID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "proposalSeriesPostfix", keyPath: "ProposalSeriesPostfix"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "deliveryDays", keyPath: "DeliveryDays"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "productDispatchedStatusID", keyPath: "ProductDispatchedStatusID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "totalQuantity", keyPath: "TotalQuantity"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "seriesPostfix", keyPath: "SeriesPostfix"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "statusID", keyPath: "StatusID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "editStatusID", keyPath: "EditStatusID"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "finalSalesAmount", keyPath: "finalSalesAmount"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "totalDiscount", keyPath: "totalDiscount"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "totalGrossAmount", keyPath: "totalGrossAmount"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "totalNetAmount", keyPath: "totalNetAmount"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "totalTaxAmount", keyPath: "totalTaxAmount"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "flatPromotionPercentage", keyPath: "FlatPromotionPercentage"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "isExceedsMaxDiscount", keyPath: "IsExceedsMaxDiscount"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isPromotionApplied", keyPath: "IsPromotionApplied"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "promotionAmount", keyPath: "PromotionAmount"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "promotionID", keyPath: "PromotionID"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "totalPromotionAmount", keyPath: "totalPromotionAmount"))
        
        mapping.addToManyRelationshipMapping(SOrderProducts.defaultMapping(), forProperty: "soProductList", keyPath: "Products")
        mapping.addAttributes(from:  ["desc":"Description","createdTime":"CreatedTime","lastModifiedTime":"LastModifiedTime","leadSeriesPrefix":"LeadSeriesPrefix","proposalSeriesPrefix":"ProposalSeriesPrefix","seriesPrefix":"SeriesPrefix","tnc":"TNC","dealerCode":"DealerCode","warranty":"Warranty","dealerCity":"DealerCity","customerName":"CustomerName","sOMadeBy":"SOMadeBy","sOMadeFrom":"SOMadeFrom","promotionName":"PromotionName"])
        
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
    
    class func getAll()->[SOrder]{
        let predicate = NSPredicate(format: "statusID != 7")
        return SOrder.mr_findAllSorted(by: "seriesPostfix", ascending: false, with: predicate) as? [SOrder] ?? [SOrder]()
    }
    
    class func getFilteredByAttribute(strAttributeName: String, withSortAttribute strType: String? = nil, withValue idsarr: [Int], withSortType isAsc: Bool) -> [SOrder] {
        let predicate = NSPredicate(format: "ANY %K IN %@", strAttributeName, idsarr)
        return SOrder.mr_findAllSorted(by: (strType != nil) ? strType! : "iD", ascending: (strType != nil) ? isAsc : false, with: predicate, in: NSManagedObjectContext.mr_default()) as? [SOrder] ?? [SOrder]()
    }
    
    class func getFilteredByAttributesComplex2(productIDs: [NSNumber]) -> [SOrder] {
        let predicate = NSPredicate(format: "productID IN %@", productIDs)
        let array = (SOrderProducts.mr_findAll(with: predicate, in: NSManagedObjectContext.mr_default()) as? [SOrderProducts] ?? [SOrderProducts]()).map {NSNumber(value: $0.salesOrderID)}
        print("Array:--\(array)")
        let predicate1 = NSPredicate(format: "ANY iD IN %@", array)
        print(predicate1)
        return SOrder.mr_findAll(with: predicate1, in: NSManagedObjectContext.mr_default()) as? [SOrder] ?? [SOrder]()
    }

    class func getSOByID(vID: NSNumber)->SOrder?{
        return SOrder.mr_findFirst(byAttribute: "iD", withValue: vID, in: NSManagedObjectContext.mr_default())
    }
}


@objc(SOrderProducts)
class SOrderProducts: NSManagedObject {
    @NSManaged var focQuantity:Int64
    @NSManaged var customerClass:Int16
    @NSManaged var categoryType:Int64
    @NSManaged var cGSTSurcharges:Double
    @NSManaged var cGSTTax:Double
    @NSManaged var cST:Double
    @NSManaged var cSTSurcharge:Double
    @NSManaged var discountType:Int16
    @NSManaged var discount:Double
    @NSManaged var discountA:Float
    @NSManaged var discountB:Float
    @NSManaged var discountC:Float
    @NSManaged var maxdiscount:Double
    @NSManaged var vATPercentage:Float
    @NSManaged var dispatchQuantity:Int32
    @NSManaged var exciseDuty:Double
    @NSManaged var exciseSurcharge:Double
    @NSManaged var gSTEnabled:Bool
    @NSManaged var iGSTSurcharges:Double
    @NSManaged var iGSTTax:Double
    @NSManaged var price:Double
    @NSManaged var productAmount:Double
    @NSManaged var productID:Int64
    @NSManaged var quantity:Int64
    @NSManaged var salesOrderID:Int64
    @NSManaged var serviceTax:Double
    @NSManaged var serviceTaxSurcharge:Double
    @NSManaged var sGSTSurcharges:Double
    @NSManaged var sGSTTax:Double
    @NSManaged var vAT:Float
    @NSManaged var vATAdditionalTax:Float
    @NSManaged var vATSurcharges:Double
    @NSManaged var serviceSurcharge:Float
    @NSManaged var name:String?
    @NSManaged var inclusiveExclusive:String?
    @NSManaged var vATFrom:String?
    @NSManaged var receivedQuantity:Int32
    @NSManaged var purhcaseOrderID:Int64
    @NSManaged var pOrder:Set<POrder>
    @NSManaged var sOrder:Set<SOrder>
    @NSManaged var isPromotional:Int16
    
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "SOrderProducts")
        mapping.addAttribute(Mapping.intAttributeFor(property: "categoryType", keyPath: "CategoryType"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "cGSTSurcharges", keyPath: "CGSTSurcharges"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "cGSTTax", keyPath: "CGSTTax"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "cST", keyPath: "CST"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "cSTSurcharge", keyPath: "CSTSurcharge"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "discount", keyPath: "Discount"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "discountA", keyPath: "DiscountA"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "discountB", keyPath: "DiscountB"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "discountC", keyPath: "DiscountC"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "maxdiscount", keyPath: "Maxdiscount"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "vATPercentage", keyPath: "VATPercentage"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "dispatchQuantity", keyPath: "DispatchQuantity"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "exciseDuty", keyPath: "ExciseDuty"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "exciseSurcharge", keyPath: "ExciseSurcharge"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "gSTEnabled", keyPath: "GSTEnabled"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "iGSTSurcharges", keyPath: "IGSTSurcharges"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "iGSTTax", keyPath: "IGSTTax"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "price", keyPath: "Price"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "productAmount", keyPath: "ProductAmount"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "productID", keyPath: "ProductID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "salesOrderID", keyPath: "SalesOrderID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "quantity", keyPath: "Quantity"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "serviceTax", keyPath: "ServiceTax"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "serviceTaxSurcharge", keyPath: "ServiceTaxSurcharge"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "sGSTSurcharges", keyPath: "SGSTSurcharges"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "sGSTTax", keyPath: "SGSTTax"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "vAT", keyPath: "VAT"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "vATAdditionalTax", keyPath: "VATAdditionalTax"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "vATSurcharges", keyPath: "VATSurcharges"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "serviceSurcharge", keyPath: "ServiceSurcharge"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "purhcaseOrderID", keyPath: "PurhcaseOrderID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "receivedQuantity", keyPath: "ReceivedQuantity"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "customerClass", keyPath: "CustomerClass"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "discountType", keyPath: "DiscountType"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "focQuantity", keyPath: "FOCQuantity"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isPromotional", keyPath: "IsPromotional"))
        mapping.addAttributes(from: ["name":"Name","inclusiveExclusive":"InclusiveExclusive","vATFrom":"VATFrom"])
        
        return mapping;
    }
}
