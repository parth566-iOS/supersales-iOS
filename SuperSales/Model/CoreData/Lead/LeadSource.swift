//
//  LeadSource.swift
//  SuperSales
//
//  Created by Apple on 10/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(LeadSource)
class LeadSource: NSManagedObject {
    
    
    
    @NSManaged var companyID:Int64
     @NSManaged var createdBy:Int64
     @NSManaged var iD:Int64
     @NSManaged var leadSourceIndex:Int64
     @NSManaged var leadSourceValue:String!
    
    
    
//LeadSource
    class func entityName()->String{
        return "LeadSource"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "LeadSource")
         mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "leadSourceIndex", keyPath: "LeadSourceIndex"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttributes(from: ["leadSourceValue":"LeadSourceValue"])
        mapping.primaryKey = "iD"
        return mapping
    }
    class func getAll()->[LeadSource]{
        return LeadSource.mr_findAll() as? [LeadSource] ?? [LeadSource]()
    }
    
    class func getLeadSourceFromLeadSourceID(leadsourceID:NSNumber)->String{
     
        if let leadsource =  LeadSource.mr_findFirst(byAttribute: "leadSourceIndex", withValue: leadsourceID){
            return leadsource.leadSourceValue
        }else{
            return " "
        }
    }
}
