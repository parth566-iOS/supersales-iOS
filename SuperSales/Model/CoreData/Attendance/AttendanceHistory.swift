//
//  AttendanceHistory.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping


@objc(AttendanceHistory)
class AttendanceHistory: NSManagedObject {

    @NSManaged var checkInConnectionType : Int
    @NSManaged var checkOutConnectionType : Int
    @NSManaged var createdBy : Int
    @NSManaged var attendanceDate : NSDate?
    @NSManaged var attendanceType : Int
    @NSManaged var checkInAddress : String!
    @NSManaged var checkInAddressID : Int
    @NSManaged var checkInApproved : Bool
    @NSManaged var checkInAttendanceType : Int16
    @NSManaged var checkInPhotoURL : String!
    @NSManaged var checkInTime : Date?
    @NSManaged var checkOutAddress : String!
    @NSManaged var checkOutAddressID : Int
    @NSManaged var checkOutApproved : Bool
    @NSManaged var checkOutAttendanceType : Int16
    @NSManaged var checkOutClientId : Int
    @NSManaged var checkOutPhotoURL : String!
    @NSManaged var checkOutTime : NSDate!
    @NSManaged var checkinLattitude : Double//String
    @NSManaged var checkinLongitude : Double
    @NSManaged var checkoutLattitude : Double
    @NSManaged var checkoutLongitude : Double
    @NSManaged var clientId : Int
    @NSManaged var companyID : Int
    @NSManaged var early : Bool
    @NSManaged var entity_id : Int
    @NSManaged var isApprovalRequired : Bool
    @NSManaged var late : Bool
    @NSManaged var latitude : Int
    @NSManaged var leaveTypeID : Int
    @NSManaged var leaveDay:String?
    @NSManaged var leaveType:String?
    @NSManaged var longitude : Int
    @NSManaged var manualApproved : Bool
    @NSManaged var minEarly : Int
    @NSManaged var minLate : Int
    @NSManaged var modifiedBy : Int
    @NSManaged var present : Bool
    @NSManaged var totalTime : String?
    @NSManaged var manualAttendance:String?
    @NSManaged var attendanceuser : AttendanceUser?
    @NSManaged var userID : Int
    @NSManaged var timeIn : NSDate?
    @NSManaged var timeOut : NSDate?
    @NSManaged var updatedTimeIn : NSDate?
    @NSManaged var updatedTimeOut : NSDate?
    
    
    class func entityName()->String{
        return "AttendanceHistory"
    }
    
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "AttendanceHistory")
        var dic = CDHelper().mappingForClass(classname: AttendanceHistory.self)
        dic.removeValue(forKey: "entity_id")
        dic.removeValue(forKey: "checkInAddressID")
        dic.removeValue(forKey: "checkInTime")
        dic.removeValue(forKey: "checkOutTime")
        dic.removeValue(forKey: "updatedTimeIn")
        dic.removeValue(forKey: "updatedTimeOut")
        dic.removeValue(forKey: "startTime")
        dic.removeValue(forKey: "endTime")
        dic.removeValue(forKey: "checkInApproved")
        dic.removeValue(forKey: "checkOutApproved")
        dic.removeValue(forKey: "checkOutAddressID")
        dic.removeValue(forKey: "companyID")
        dic.removeValue(forKey: "checkInAddressID")
        dic.removeValue(forKey: "early")
        dic.removeValue(forKey: "internalBaseClassIdentifier")
        dic.removeValue(forKey: "late")
        dic.removeValue(forKey: "latitude")
        dic.removeValue(forKey: "longitude")
        dic.removeValue(forKey: "manualApproved")
        dic.removeValue(forKey: "minEarly")
        dic.removeValue(forKey: "minLate")
        dic.removeValue(forKey: "modifiedBy")
        dic.removeValue(forKey: "present")
        dic.removeValue(forKey: "attendanceDate")
        dic.removeValue(forKey: "longitude")
        dic.removeValue(forKey: "timeIn")
        dic.removeValue(forKey: "timeIn")
        dic.removeValue(forKey: "timeOut")
        dic.removeValue(forKey: "checkInAttendanceType")
        dic.removeValue(forKey: "checkOutAttendanceType")
        
    mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "attendanceDate", keyPath: "attendanceDate"))
      mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "updatedTimeIn", keyPath: "updatedTimeIn"))
        
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "updatedTimeOut", keyPath: "updatedTimeOut"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "checkInAttendanceType", keyPath: "checkInAttendanceType"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "checkOutAttendanceType", keyPath: "checkOutAttendanceType"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "entity_id", keyPath: "id"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "checkInAddressID", keyPath: "checkInAddressID"))
        
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "checkinLattitude", keyPath: "checkinLattitude"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "checkinLongitude", keyPath: "checkinLongitude"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "checkoutLattitude", keyPath: "checkoutLattitude"))
         mapping.addAttribute(Mapping.doubleAttributeFor(property: "checkoutLongitude", keyPath: "checkoutLongitude"))
       
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "checkInTime", keyPath: "checkInTime"))
        
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "timeIn", keyPath: "timeIn"))
        
        
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "timeOut", keyPath: "timeOut"))
        
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "checkOutTime", keyPath: "checkOutTime"))
        
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "checkInTime", keyPath: "checkInTime"))
        
        
        mapping.addAttribute(Mapping.boolAttributeFor(property: "checkInApproved", keyPath: "checkInApproved"))
         mapping.addAttribute(Mapping.boolAttributeFor(property: "checkOutApproved", keyPath: "checkOutApproved"))
         mapping.addAttribute(Mapping.boolAttributeFor(property: "manualApproved", keyPath: "manualApproved"))
      //  mapping.addAttributes(from: ["checkinLattitude":"CheckinLattitude","checkinLongitude":"CheckinLongitude","checkoutLattitude":"CheckoutLattitude","checkoutLongitude":"CheckoutLongitude"])
    mapping.addRelationshipMapping(AttendanceUser.defaultMapping(),forProperty: "attendanceuser", keyPath:"user")
        
        mapping.addAttributes(from: dic)
         
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func getAll()->[AttendanceHistory]{
        return AttendanceHistory.mr_findAllSorted(by: "entity_id", ascending: false) as? [AttendanceHistory] ?? [AttendanceHistory]()
       
    }

class func getLatestAttendanceForDate(date:Date,userID:NSNumber)->AttendanceHistory?{
// AttendanceHistory.mr_findAllSorted(by: "entity_id", ascending: false)
  //[[AttendanceHistory MR_findAllSortedBy:@"entity_id" ascending:NO inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
    let arrOfLastAttendance = AttendanceHistory.mr_findAllSorted(by: "entity_id", ascending: false, in: NSManagedObjectContext.mr_default())
if(arrOfLastAttendance?.count ?? 0 > 0){
    let lastAttendance = AttendanceHistory.mr_findAllSorted(by: "entity_id", ascending: false)?.first as? AttendanceHistory //first
    
    print("in attendance type  for database = \(lastAttendance?.checkInAttendanceType)")
    print("out attendance type for database  = \(lastAttendance?.checkOutAttendanceType)")
  
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "dd/MM/YYYY"
    
    print("Attedace date in data = \(lastAttendance?.attendanceDate)")
   
    if(date.dateCompareValue() == (lastAttendance?.attendanceDate as! Date).dateCompareValue()){
    let user = lastAttendance!.attendanceuser
        if(user?.entity_id == 0){
            user?.entity_id = Int(user?.userId ?? 0)
        }
   
    if(NSNumber.init(value: user?.entity_id ?? 0)  == userID){
        print("checkin type = \(lastAttendance?.checkInAttendanceType) ,  checkout type = \(lastAttendance?.checkOutAttendanceType) before green method")
    return  lastAttendance
    }
}else{
    print(date.dateCompareValue())
    print((lastAttendance?.attendanceDate as! Date).dateCompareValue())
}
       // }
        
      return  nil
}
else
{
   return nil
}
    }
    
    class func deleteRecord(id:NSNumber){
        let predicate = NSPredicate.init(format: "entity_id = \(id)")
        AttendanceHistory.mr_deleteAll(matching: predicate)
    }
    
    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
}
