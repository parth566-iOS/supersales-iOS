//
//  VisitStatusList.swift
//  SuperSales
//
//  Created by Apple on 10/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping



@objc(VisitStatus)
class VisitStatus: NSManagedObject {

    @NSManaged var conclusion:String!
    @NSManaged var createdBy:Int64
    @NSManaged var createdByName:String!
    @NSManaged var createdTime:String!
    @NSManaged var expectedDate:String!
    @NSManaged var iD:Int64
    @NSManaged var interactionTime:String!
    @NSManaged var interactionTypeID:Int64
    @NSManaged var interactionWith:Int64
    @NSManaged var interactionWithName:String!
    @NSManaged var nextActionID:Int64
    @NSManaged var nextActionTime:String!
    @NSManaged var orderValue:Double
    @NSManaged var visitID:Int64
    @NSManaged var visitOutcomeID:Int64
    @NSManaged var visitOutcome2ID:Int64
    @NSManaged var visitOutcome3ID:Int64
    @NSManaged var visitOutcome4ID:Int64
    @NSManaged var visitOutcome5ID:Int64
    @NSManaged var visitTypeID:Int64
    @NSManaged var updatedBy:Int64
    @NSManaged var plannVisit:PlannVisit
   
    
    class func entityName()->String{
        return "VisitStatus"
    }
    
    class func defaultmapping() -> FEMMapping {
    let mapping = FEMMapping.init(entityName: "VisitStatus")
    mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "visitID", keyPath: "VisitID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "interactionTypeID", keyPath: "InteractionTypeID"))
    mapping.addAttribute(Mapping.intAttributeFor(property: "interactionWith", keyPath: "InteractionWith"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitOutcomeID", keyPath: "VisitOutcomeID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitOutcome2ID", keyPath: "VisitOutcome2ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitOutcome3ID", keyPath: "VisitOutcome3ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitOutcome4ID", keyPath: "VisitOutcome4ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitOutcome5ID", keyPath: "VisitOutcome5ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "nextActionID", keyPath: "NextActionID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "updatedBy", keyPath: "UpdatedBy"))
         mapping.addAttribute(Mapping.doubleAttributeFor(property: "orderValue", keyPath: "OrderValue"))
        mapping.addAttributes(from: ["interactionWithName": "InteractionWithName","interactionTime":"InteractionTime","nextActionTime":"NextActionTime","conclusion":"Conclusion","createdByName":"CreatedByName","createdTime":"CreatedTime","expectedDate":"ExpectedDate"])
        
        mapping.primaryKey = "iD"
        return mapping
    }

class func getvisitstatus(visitID:NSNumber)->VisitStatus?{
  if  let  status =  VisitStatus.mr_find(byAttribute: "visitID", withValue: visitID)?.first as? VisitStatus{
        return status
    }else{
        return nil
    }
    }

}
