//
//  ActivityParticipant.swift
//  SuperSales
//
//  Created by mac on 16/06/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(ActivityParticipant)
class ActivityParticipant: NSManagedObject {
    @NSManaged var activityId:Int64
    @NSManaged var userId:Int64
    @NSManaged var createdby:Int64
    @NSManaged var customerName:String
    @NSManaged var customerMobile:Int64
    @NSManaged var createdTime:String
    @NSManaged var activitypaticipantid:Int64
    @NSManaged var customerId:Int64
    
    
    
    class func entityName()->String{
        return "ActivityParticipant"
    }
    
    class func defaultMapping()->FEMMapping{
         let mapping = FEMMapping.init(entityName: self.entityName())
        mapping.addAttribute(Mapping.intAttributeFor(property: "activitypaticipantid", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdby", keyPath: "CreatedBy"))
      //
       mapping.addAttribute(Mapping.intAttributeFor(property: "customerId", keyPath: "CustomerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property:"userId", keyPath: "UserID"))
        mapping.addAttribute(Mapping.intAttributeFor(property:"customerMobile", keyPath: "CustomerMobile"))
      //  customerI
        mapping.addAttribute(Mapping.intAttributeFor(property: "activityId", keyPath: "ActivityId"))
       
        
        mapping.addAttributes(from:["customerName":"CustomerName","createdTime":"CreatedTime"])//,"checkOutTime":"CheckOutTime","customerID":"customerID""customerMobile":"CustomerMobile",
        mapping.primaryKey = "activitypaticipantid"
        return mapping
    }
    
    class func getContext()->NSManagedObjectContext{
        //return NSManagedObjectContext.mr_default()
        return NSManagedObjectContext.mr_default()
    }
    
}
