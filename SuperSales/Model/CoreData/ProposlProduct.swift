//
//  ProposlProduct.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping


@objc(ProposlProduct)
class ProposlProduct: NSManagedObject {
    @NSManaged var categoryType:Int64
    @NSManaged var cGSTSurcharges: Double
    @NSManaged var cGSTTax: Double
    @NSManaged var cST: Double
    @NSManaged var cSTSurcharge: Double
    @NSManaged var discount: Double
    @NSManaged var exciseDuty:Double
    @NSManaged var exciseSurcharge:Double
    @NSManaged var gSTEnabled: Bool
    @NSManaged var iGSTSurcharges: Double
    @NSManaged var iGSTTax: Double
    @NSManaged var price: Double
    @NSManaged var productAmount: Double
    @NSManaged var productID: Int64
    @NSManaged var proposalID: Int64
    @NSManaged var quantity: Int64
    @NSManaged var serviceTax: Double
    @NSManaged var serviceTaxSurcharge: Double
    @NSManaged var sGSTSurcharges: Double
    @NSManaged var sGSTTax: Double
    @NSManaged var vAT: Float
    @NSManaged var vATAdditionalTax: Float
    @NSManaged var vATSurcharges: Double
//     @property (nullable, nonatomic, retain) NSSet<Proposl *> *proposal;
     
    
    class func entityName()->String{
        return "ProposlProduct"
    }
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "ProposlProduct")
        mapping.addAttribute(Mapping.intAttributeFor(property: "categoryType", keyPath: "CategoryType"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "cGSTSurcharges", keyPath: "CGSTSurcharges"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "cGSTTax", keyPath: "CGSTTax"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "cST", keyPath: "CST"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "cSTSurcharge", keyPath: "CSTSurcharge"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "discount", keyPath: "Discount"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "exciseDuty", keyPath: "ExciseDuty"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "exciseSurcharge", keyPath: "ExciseSurcharge"))
            mapping.addAttribute(Mapping.boolAttributeFor(property: "gSTEnabled", keyPath: "GSTEnabled"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "iGSTSurcharges", keyPath: "IGSTSurcharges"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "iGSTTax", keyPath: "IGSTTax"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "price", keyPath: "Price"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "productAmount", keyPath: "ProductAmount"))
            mapping.addAttribute(Mapping.intAttributeFor(property: "productID", keyPath: "ProductID"))
            mapping.addAttribute(Mapping.intAttributeFor(property: "proposalID", keyPath: "ProposalID"))
            mapping.addAttribute(Mapping.intAttributeFor(property: "quantity", keyPath: "Quantity"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "serviceTax", keyPath: "ServiceTax"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "serviceTaxSurcharge", keyPath: "ServiceTaxSurcharge"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "sGSTSurcharges", keyPath: "SGSTSurcharges"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "sGSTTax", keyPath: "SGSTTax"))
            mapping.addAttribute(Mapping.floatAttributeFor(property: "vAT", keyPath: "VAT"))
            mapping.addAttribute(Mapping.floatAttributeFor(property: "vATAdditionalTax", keyPath: "VATAdditionalTax"))
            mapping.addAttribute(Mapping.doubleAttributeFor(property: "vATSurcharges", keyPath: "VATSurcharges"))

        return mapping
    }
}
