//
//  LeadCheckInOutList.swift
//  SuperSales
//
//  Created by Apple on 09/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(LeadCheckInOutList)
class LeadCheckInOutList: NSManagedObject {
    
    @NSManaged var addressMasterID : Int64
    @NSManaged var approvedBy : Int64
    @NSManaged var approvedTo : Int64
    @NSManaged var checkInCheckOutStatusID : Int64
    @NSManaged var companyID : Int64
    @NSManaged var createdBy : Int64
    @NSManaged var customerID : Int64
    @NSManaged var iD : Int64
    @NSManaged var lastModifiedBy : Int64
    @NSManaged var statusID : Int64
    @NSManaged var leadID : Int64
    @NSManaged var manualCheckInStatusID : Int16
    @NSManaged var manualCheckOutStatusID : Int16
    @NSManaged var leadManualCheckIn : Int16
    @NSManaged var leadManualCheckOut : Int16
    @NSManaged var lattitude : String
    @NSManaged var longitude : String
    @NSManaged var kM : Double
    @NSManaged var lastCheckOutKM : Double
    @NSManaged var checkInTime : String
    @NSManaged var checkOutTime : String
    @NSManaged var createdTime : String
    @NSManaged var leadDate : String
    @NSManaged var checkInFrom : String
    
    
    class func entityName()->String{
        return "LeadCheckInOutList"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "LeadCheckInOutList")
        mapping.addAttribute(Mapping.intAttributeFor(property: "addressMasterID", keyPath: "AddressMasterID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedBy", keyPath: "ApprovedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedTo", keyPath: "ApprovedTo"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "checkInCheckOutStatusID", keyPath: "CheckInCheckOutStatusID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "customerID", keyPath: "CustomerID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "statusID", keyPath: "StatusID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "leadID", keyPath: "LeadID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "manualCheckInStatusID", keyPath: "ManualCheckInStatusID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "manualCheckOutStatusID", keyPath: "ManualCheckOutStatusID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadManualCheckIn", keyPath: "LeadManualCheckIn"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "leadManualCheckOut", keyPath: "LeadManualCheckOut"))
//         mapping.addAttribute(Mapping.doubleAttributeFor(property: "lattitude", keyPath: "Lattitude"))
//         mapping.addAttribute(Mapping.doubleAttributeFor(property: "longitude", keyPath: "Longitude"))
         mapping.addAttribute(Mapping.doubleAttributeFor(property: "kM", keyPath: "KM"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "lastCheckOutKM", keyPath: "LastCheckOutKM"))
        mapping.addAttributes(from: ["checkInTime":     "CheckInTime","checkOutTime":"CheckOutTime","createdTime":"CreatedTime","leadDate":"LeadDate","checkInFrom":"CheckInFrom","lattitude":"Lattitude","longitude":"Longitude"])
        mapping.primaryKey = "iD"
        return mapping
    }
    
    // MARK: Custom Method
    func getLeadCheckinoutFromId(leadId:NSNumber)->LeadCheckInOutList?{
        /*
         if let checkout = VisitCheckInOutList.mr_find(byAttribute: "visitID", withValue: visitID)?.first as? VisitCheckInOutList{
                   
                   return checkout
         **/
        if let leadcheckinout =  LeadCheckInOutList.mr_find(byAttribute: "leadID", withValue: leadId)?.last as? LeadCheckInOutList{
           return leadcheckinout
        }else{
            return nil
        }
  
    }
    
    class func getLeadCheckinoutFromIdForUser(leadId:NSNumber,createdBy:NSNumber)->LeadCheckInOutList?{
         let predicate = NSPredicate.init(format: String(format:"leadID == %@ && createdBy == %@", arguments: [leadId,createdBy]), [])
         if let leadchicho = (LeadCheckInOutList.mr_findAllSorted(by: "iD", ascending: false, with: predicate) as? [LeadCheckInOutList])?.last as? LeadCheckInOutList?{
        return leadchicho
        }else{
            return nil
        }
    }
    
    class func getListOfCheckinOutList(leadID:NSNumber)->[LeadCheckInOutList]{
        let predicate = NSPredicate.init(format: String(format: "leadID == %@ && (statusID != 3 && manualCheckInStatusID != 3 && manualCheckOutStatusID != 3) ",arguments: [leadID]), [])
         let arrLeadCheckinOutList  = LeadCheckInOutList.mr_findAllSorted(by: "iD", ascending: false, with: predicate) as? [LeadCheckInOutList] ?? [LeadCheckInOutList]()
        return arrLeadCheckinOutList
    }
    class func getLeadCheckInOutUsingDate(leadID:NSNumber,cby:String)-> LeadCheckInOutList?{
       let predicate = NSPredicate.init(format: "leadID = %@ && checkInTime contains[cd] %@", leadID,cby)
        if let checkout = LeadCheckInOutList.mr_findAllSorted(by: "iD", ascending: false, with: predicate)?.last as? LeadCheckInOutList{
            return checkout
        }else{
            return nil
        }
    }
}
