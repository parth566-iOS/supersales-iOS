//
//  VisitCheckInOutList.swift
//  SuperSales
//
//  Created by Apple on 10/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping


@objc(VisitCheckInOutList)
class VisitCheckInOutList: NSManagedObject {

    @NSManaged var addressMasterID:Int64
    @NSManaged var approvedBy:Int64
    @NSManaged var approvedTo:Int64
    @NSManaged var checkInCheckOutStatusID:Int64
    @NSManaged var checkInTime:String!
    @NSManaged var checkOutTime:String!
    @NSManaged var companyID:Int64
    @NSManaged var createdBy:Int64
    @NSManaged var createdByName:String!
    @NSManaged var createdTime:String!
    @NSManaged var customerID:Int64
    @NSManaged var iD:Int64
    @NSManaged var lastModifiedBy:Int64
    @NSManaged var lattitude:String
    @NSManaged var longitude:String
    @NSManaged var manualCheckInStatusID:Int16
    @NSManaged var manualCheckOutStatusID:Int16
    @NSManaged var statusID:Int64
     @NSManaged var visitDate:String!
     @NSManaged var visitID:Int64
     @NSManaged var visitManualCheckIn:Int16
     @NSManaged var visitManualCheckOut:Int16
    @NSManaged var kM:Double
    @NSManaged var lastCheckOutKM:Double
    @NSManaged var plannVisit:NSSet
    
   
    
    class func entityName()->String{
        return "VisitCheckInOutList"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "VisitCheckInOutList")
         mapping.addAttribute(Mapping.intAttributeFor(property: "ID", keyPath: "iD"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "addressMasterID", keyPath: "AddressMasterID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedBy", keyPath: "ApprovedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedTo", keyPath: "ApprovedTo"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "checkInCheckOutStatusID", keyPath: "CheckInCheckOutStatusID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "customerID", keyPath: "CustomerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "statusID", keyPath: "StatusID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitID", keyPath: "VisitID"))
//        mapping.addAttribute(Mapping.doubleAttributeFor(property: "lattitude", keyPath: "Lattitude"))
//          mapping.addAttribute(Mapping.doubleAttributeFor(property: "longitude", keyPath: "Lattitude"))
        
          mapping.addAttribute(Mapping.doubleAttributeFor(property: "kM", keyPath: "KM"))
          mapping.addAttribute(Mapping.doubleAttributeFor(property: "lastCheckOutKM", keyPath: "LastCheckOutKM"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "manualCheckInStatusID", keyPath: "ManualCheckInStatusID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "manualCheckOutStatusID", keyPath: "ManualCheckOutStatusID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitManualCheckIn", keyPath: "VisitManualCheckIn"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitManualCheckOut", keyPath: "VisitManualCheckOut"))
        mapping.addAttributes(from: ["checkInTime": "CheckInTime","checkOutTime":"CheckOutTime","createdByName":"CreatedByName","createdTime":"CreatedTime","visitDate":"VisitDate","lattitude":"Lattitude","longitude":"Longitude"])
        
        mapping.primaryKey = "iD"
        return mapping
    }
    
//    func getAllCheckinOutList(visitID:NSNumber)->[VisitCheckInOutList]{
//          let arrcheckinoutlist =  VisitCheckInOutList.mr_find(byAttribute: "visitID", withValue: visitID, in: AppDelegate.shared.managedObjectContext) as? VisitCheckInOutList ?? VisitCheckInOutList()
//        return [arrcheckinoutlist]
//       
//    }
    
   class func getAll()->[VisitCheckInOutList]{
         return VisitCheckInOutList.mr_findAll() as? [VisitCheckInOutList] ?? [VisitCheckInOutList]()
    }
    
    func getVisitcheckinoutFromID(visitID:NSNumber)->VisitCheckInOutList?{
      //  if let checkout = VisitCheckInOutList.mr_find(byAttribute: "visitID", withValue: visitID)?.first as? VisitCheckInOutList{
        //if let checkout = VisitCheckInOutList.mr_findFirst(byAttribute: "visitID", withValue: visitID) as? VisitCheckInOutList{
        //true
        if let checkout = VisitCheckInOutList.mr_find(byAttribute: "visitID", withValue: visitID, andOrderBy: "iD", ascending: false, in: NSManagedObjectContext.mr_default()) as? [VisitCheckInOutList]{
            print("checkin time in visitcheckinoutlist = \(checkout.last?.checkInTime)")
            print("checkout time in visitcheckinoutlist = \(checkout.last?.checkOutTime)")
            return checkout.last
            
         
        }else{
            return nil
        }
       
    }
    
    func getAllForVisit(visitID:NSNumber)->[VisitCheckInOutList]{
        return VisitCheckInOutList.mr_find(byAttribute: "visitID", withValue: visitID) as? [VisitCheckInOutList] ?? [VisitCheckInOutList]()
    }
    
    func getVisitCheckInOutListFromID(visitby:NSNumber,cby:NSNumber)-> VisitCheckInOutList?{
       let predicate = NSPredicate.init(format: "visitID = %@ && createdBy = %@", visitby,cby)
        if let checkout = VisitCheckInOutList.mr_findAllSorted(by: "iD", ascending: false, with: predicate)?.first as? VisitCheckInOutList{
            return checkout
        }else{
            return nil
        }
    }
    
    func getVisitCheckInOutUsingDate(visitby:NSNumber,cby:String)-> VisitCheckInOutList?{
       let predicate = NSPredicate.init(format: "visitID = %@ && checkInTime contains[cd] %@", visitby,cby)
        if let checkout = VisitCheckInOutList.mr_findAllSorted(by: "iD", ascending: false, with: predicate)?.last as? VisitCheckInOutList{
            return checkout
        }else{
            return nil
        }
    }
}
