//
//  VisitCounterShare.swift
//  SuperSales
//
//  Created by Apple on 10/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(VisitCounterShare)
class VisitCounterShare: NSManagedObject {

    @NSManaged var iD:Int64
    @NSManaged var visitID:Int64
    @NSManaged var companySegmentShareValue:Int64
    @NSManaged var companyShareValue:Int64
    @NSManaged var competitorName:String!
    @NSManaged var competitorShare:Int64
    @NSManaged var competitorName2:String!
    @NSManaged var competitorShare2:Int64
    @NSManaged var createdBy:Int64
    @NSManaged var createdTime:String!
    @NSManaged var plannVisit:PlannVisit
    @NSManaged var counterShareSubCategoryList:NSOrderedSet
 
    class func entityName()->String{
        return "VisitCounterShare"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "VisitCounterShare")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitID", keyPath: "visitID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companySegmentShareValue", keyPath: "companySegmentShareValue"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyShareValue", keyPath: "companyShareValue"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "competitorShare", keyPath: "competitorShare"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "competitorShare2", keyPath: "competitorShare2"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "createdBy"))
        mapping.addAttributes(from: ["competitorName": "competitorName","createdTime":"createdTime","competitorName2": "competitorName2"])
        mapping.addToManyRelationshipMapping(VisitCounterShareSubCategoryList.defaultmapping(), forProperty: "counterShareSubCategoryList", keyPath: "counterShareSubCategoryList")
        mapping.primaryKey = "iD"
        return mapping
    }
    
    func getVisitCounterShareFromID(visitID:NSNumber)->VisitCounterShare?{
        if let countershare = VisitCounterShare.mr_find(byAttribute: "visitID", withValue: visitID, andOrderBy: "iD", ascending: false)?.first as? VisitCounterShare   {
            return countershare
        }else{
            return nil
        }
    }
}
