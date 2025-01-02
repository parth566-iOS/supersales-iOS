//
//  ActivityCheckinCheckout.swift
//  SuperSales
//
//  Created by Apple on 12/05/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import CoreData
import FastEasyMapping


@objc(ActivityCheckinCheckout)
class ActivityCheckinCheckout: NSManagedObject {
    
    @NSManaged var activityID:Int64
    @NSManaged var createdBy:Int64
    @NSManaged var checkInTime:String
    @NSManaged var checkOutTime:String
    @NSManaged var createdByName:String
    @NSManaged var lattitude:String
    @NSManaged var companyID:Int64
    @NSManaged var longitude:String
    @NSManaged var lastModifiedBy:Int64
    @NSManaged var createdTime:String
    @NSManaged var iD:Int64
    @NSManaged var activityDate:String
    
    class func entityName()->String{
        return "ActivityCheckinCheckout"
    }
    
    class func defaultMapping()->FEMMapping{
         let mapping = FEMMapping.init(entityName: self.entityName())
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "activityID", keyPath: "ActivityID"))
//        mapping.addAttribute(Mapping.doubleAttributeFor(property: "longitude", keyPath: "Longitude"))
//        mapping.addAttribute(Mapping.doubleAttributeFor(property: "lattitude", keyPath: "Lattitude"))
  //      mapping.addAttribute(Mapping.intAttributeFor(property: "modifiedBy", keyPath: "ModifiedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
    //   mapping.addAttribute(Mapping.intAttributeFor(property: "lastmodifiedBy", keyPath: "LastModifiedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
 
        mapping.addAttributes(from:["checkInTime":"CheckInTime","checkOutTime":"CheckOutTime","createdTime":"CreatedTime","createdByName":"CreatedByName","activityDate":"ActivityDate","longitude":"Longitude","lattitude":"Lattitude"])
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func getAll()->[ActivityCheckinCheckout]{
        return ActivityCheckinCheckout.mr_findAll() as? [ActivityCheckinCheckout] ?? [ActivityCheckinCheckout]()
    }
    
    class func getAllForActivity(visitID:NSNumber)->[ActivityCheckinCheckout]{
        return ActivityCheckinCheckout.mr_find(byAttribute: "activityID", withValue: visitID) as? [ActivityCheckinCheckout] ?? [ActivityCheckinCheckout]()
    }
    
    func getVisitcheckinoutFromID(visitID: NSNumber) -> ActivityCheckinCheckout?{
        if   let outcome = ActivityCheckinCheckout.mr_findFirst(byAttribute: "iD", withValue: visitID){
            return outcome
        }else{
            return nil
        }
    }
    
    func getActivitycheckinoutFromID(visitID:NSNumber)->ActivityCheckinCheckout?{
  
        if let checkout = ActivityCheckinCheckout.mr_find(byAttribute: "activityID", withValue: visitID, andOrderBy: "iD", ascending: false, in: NSManagedObjectContext.mr_default()) as? [ActivityCheckinCheckout]{
//            print("checkin time in visitcheckinoutlist = \(checkout.last?.checkInTime)")
//            print("checkout time in visitcheckinoutlist = \(checkout.last?.checkOutTime)")
            return checkout.first
            
          
        }else{
            return nil
        }
       
    }
    
    class func getListOfCheckinOutList(leadID:NSNumber)->[ActivityCheckinCheckout]{
        let predicate = NSPredicate.init(format: String(format: "activityID == %@  ",arguments: [leadID]), [])
         let arrLeadCheckinOutList  = ActivityCheckinCheckout.mr_findAllSorted(by: "iD", ascending: false, with: predicate) as? [ActivityCheckinCheckout] ?? [ActivityCheckinCheckout]()
        return arrLeadCheckinOutList
    }
    
    class func getActivityCheckInOutUsingDate(activityID:NSNumber,cby:String)-> ActivityCheckinCheckout?{
       let predicate = NSPredicate.init(format: "activityID = %@ && checkInTime contains[cd] %@", activityID,cby)
        if let checkout = ActivityCheckinCheckout.mr_findAllSorted(by: "iD", ascending: false, with: predicate)?.last as? ActivityCheckinCheckout{
            return checkout
        }else{
            return nil
        }
    }
}
