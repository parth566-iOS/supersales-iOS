//
//  ColdCall.swift
//  SuperSales
//
//  Created by Apple on 28/07/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(ColdCall)
class ColdCall: NSManagedObject {
    @NSManaged var id:Int64
    @NSManaged var interactionId:Int64
    @NSManaged var isActive:Int16
    @NSManaged  var lastmodifiedBy:Int64
    @NSManaged var lastmodifiedTime:Date!
    @NSManaged var productcatId:Int64
    @NSManaged var remarks:String!
    @NSManaged var seriespostfix:Int64
    @NSManaged var seriesprefix:String!
    @NSManaged var customerName:String!
    @NSManaged var customerMobile:String!
    @NSManaged var createdby:Int64
    @NSManaged var actionneeded:String!
    
    class func entityName()->String{
        return "ColdCall"
    }
    
    class func defaultMapping()->FEMMapping{
         let mapping = FEMMapping.init(entityName: self.entityName())
        mapping.addAttribute(Mapping.intAttributeFor(property: "id", keyPath: "id"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "interactionId", keyPath: "interactionId"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "isActive", keyPath: "isActive"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastmodifiedBy", keyPath: "lastmodifiedBy"))
        
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "lastmodifiedTime", keyPath: "lastmodifiedTime"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "productcatId", keyPath: "productcatId"))
       
        mapping.addAttribute(Mapping.intAttributeFor(property: "seriespostfix", keyPath: "seriespostfix"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdby", keyPath: "createdby"))
        mapping.addAttributes(from:["remarks":"remarks","seriesprefix":"seriesprefix","customerName":"customerName","customerMobile":"customerMobile","actionneeded":"actionneeded"])
        mapping.primaryKey = "id"
        return mapping
    }
    
    class func getAll()->[ColdCall]{
        return ColdCall.mr_findAll() as? [ColdCall] ?? [ColdCall]()
    }
}
