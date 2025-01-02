//
//  Proposal.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(Proposl)
class Proposl: NSManagedObject {
    
    @NSManaged var approvedBy:Int64
    @NSManaged var approvedTo:Int64
    @NSManaged var assignedBy:Int64
    @NSManaged var assignedTo:Int64
    @NSManaged var companyID:Int64
    @NSManaged var createdBy:Int64
    @NSManaged var createdTime:String
    @NSManaged var customerID:Int64
    @NSManaged var customerName:String
    @NSManaged var desc:String
   @NSManaged var filterCategoryID:Int64
   @NSManaged var filterProduct:Int64
   @NSManaged var filterType:Int64
   @NSManaged var filterUser:Int64
   @NSManaged var grossAmount:Double
   @NSManaged var gSTEnabled:Bool
   @NSManaged var iD:Int64
   @NSManaged var isActive:Int64
   @NSManaged var lastModifiedBy:Int64
   @NSManaged var lastModifiedTime:String
   @NSManaged var leadID:Int64
   @NSManaged var leadSeriesPostfix:Int64
   @NSManaged var leadSeriesPrefix:String
   @NSManaged var localTaxID:Int16
   @NSManaged var localTaxSurcharge:Int64
   @NSManaged var localTaxValue:Double
   @NSManaged var netAmount:Double
   @NSManaged var seriesPostfix:Int64
   @NSManaged var seriesPrefix:String
   @NSManaged var sortType:Int64
   @NSManaged var statusID:Int16
   @NSManaged var productList:NSOrderedSet
   
   

   
   
   class func entityName()->String{
       return "Proposl"
   }
   class func defaultMapping()->FEMMapping{
       let mapping = FEMMapping.init(entityName: "Proposl")
       mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))

       mapping.addAttribute(Mapping.intAttributeFor(property: "approvedTo", keyPath: "ApprovedTo"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "assignedBy", keyPath: "AssignedBy"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "assignedTo", keyPath: "AssignedTo"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "customerID", keyPath: "CustomerID"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "filterType", keyPath: "FilterType"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "sortType", keyPath: "SortType"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "filterUser", keyPath: "FilterUser"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "filterProduct", keyPath: "FilterProduct"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "filterCategoryID", keyPath: "FilterCategoryID"))
       
       mapping.addAttribute(Mapping.doubleAttributeFor(property: "grossAmount", keyPath: "GrossAmount"))
       mapping.addAttribute(Mapping.boolAttributeFor(property: "gSTEnabled", keyPath: "GSTEnabled"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "isActive", keyPath: "IsActive"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "leadID", keyPath: "LeadID"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "leadSeriesPostfix", keyPath: "LeadSeriesPostfix"))
       mapping.addAttribute(Mapping.boolAttributeFor(property: "localTaxID", keyPath: "LocalTaxID"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "localTaxSurcharge", keyPath: "LocalTaxSurcharge"))
       mapping.addAttribute(Mapping.doubleAttributeFor(property: "localTaxValue", keyPath: "LocalTaxValue"))
       mapping.addAttribute(Mapping.doubleAttributeFor(property: "netAmount", keyPath: "NetAmount"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "seriesPostfix", keyPath: "SeriesPostfix"))
       mapping.addAttribute(Mapping.intAttributeFor(property: "statusID", keyPath: "StatusID"))
       
       mapping.addToManyRelationshipMapping(ProposlProduct.defaultMapping(), forProperty: "productList", keyPath: "Products")
       mapping.addAttributes(from:  ["desc":"Description","createdTime":"CreatedTime","lastModifiedTime":"LastModifiedTime","leadSeriesPrefix":"LeadSeriesPrefix","seriesPrefix":"SeriesPrefix","customerName":"CustomerName"])

       return mapping
   }
   
   class func getContext()->NSManagedObjectContext{
       return NSManagedObjectContext.mr_default()
   }
   
   class func getAll() ->[Proposl]{
       return Proposl.mr_findAllSorted(by: "seriesPostfix", ascending: false, in: NSManagedObjectContext.mr_default()) as? [Proposl] ?? [Proposl]()
   }
}
