//
//  AttendanceUserHistory.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(AttendanceUserHistory)
class AttendanceUserHistory: NSManagedObject {
 // swiftlint:disable Name Violation
    @NSManaged var checkOutAddress:String
    @NSManaged var checkInAddress:String
    @NSManaged var attendanceuser:AttendanceUser
    @NSManaged var updatedTimeIn:Date?
    @NSManaged var updatedTimeOut:Date?
    @NSManaged var checkInAttendanceType:Int16
    @NSManaged var checkOutAttendanceType:Int16
    @NSManaged var checkOutPhotoURL:String
    @NSManaged var checkInPhotoURL:String
    @NSManaged var totalWorkTime:String
    @NSManaged var totalTime:String
    @NSManaged var timeIn:NSDate?
    @NSManaged var timeOut:NSDate?
    @NSManaged var startTime:NSDate?
    @NSManaged var checkInClientName:String
    @NSManaged var checkOutClientName:String
    @NSManaged var clientName:String
    @NSManaged var reason:String
    @NSManaged var present:Bool
    @NSManaged var minEarly:Int64
    @NSManaged var minLate:Int64
    @NSManaged var modifiedBy:Int64
    @NSManaged var manualAttendance:String
    @NSManaged var manualApproved:Bool
    @NSManaged var longitude:Double
    @NSManaged var latitude:Double
    @NSManaged var leaveType:String
    @NSManaged var leaveDay:String
    @NSManaged var lastCheckOutKM:Double
    @NSManaged var late:Bool
    @NSManaged var internalBaseClassIdentifier:Int64
    @NSManaged var entity_id:Int64
    @NSManaged var endTime:Date?
    @NSManaged var early:Bool
    @NSManaged var companyID:Int64
    @NSManaged var checkOutTime:Date?
    @NSManaged var checkOutApproved:Bool
    @NSManaged var checkOutAddressID:Int64
    @NSManaged var checkInTime:NSDate?
    @NSManaged var checkInApproved:Bool
    @NSManaged var checkInAddressID:Int64
    @NSManaged var attendanceDate:NSDate
    
    
    class func entityName()->String{
        return "AttendanceUserHistory"
    }
    
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "AttendanceUserHistory")
        var dic = CDHelper().mappingForClass(classname: AttendanceUserHistory.self)
            dic.removeValue(forKey: "entity_id")
            dic.removeValue(forKey: "checkInAddressID")
            dic.removeValue(forKey: "checkInTime")
            dic.removeValue(forKey: "checkOutTime")
            dic.removeValue(forKey: "updatedTimeIn")
            dic.removeValue(forKey: "updatedTimeOut")
            dic.removeValue(forKey: "startTime")
            dic.removeValue(forKey: "endTime")
            dic.removeValue(forKey: "checkInApproved")
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
            dic.removeValue(forKey: "timeOut")
            dic.removeValue(forKey: "checkInAttendanceType")
            dic.removeValue(forKey: "checkOutAttendanceType")
            
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "attendanceDate", keyPath: "attendanceDate"))
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "timeIn", keyPath: "timeIn"))
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "timeOut", keyPath: "timeOut"))
          mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "updatedTimeIn", keyPath: "updatedTimeIn"))
        
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "updatedTimeOut", keyPath: "updatedTimeOut"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "checkInAttendanceType", keyPath: "checkInAttendanceType"))
        
     //   mapping.addAttribute(Mapping.intAttributeFor(property: "totalTime", keyPath: "totalTime"))
        
            mapping.addAttribute(Mapping.intAttributeFor(property: "checkOutAttendanceType", keyPath: "checkOutAttendanceType"))
            mapping.addAttribute(Mapping.intAttributeFor(property: "entity_id", keyPath: "id"))
             mapping.addAttribute(Mapping.intAttributeFor(property: "checkInAddressID", keyPath: "checkInAddressID"))
            
            mapping.addAttribute(Mapping.boolAttributeFor(property: "checkInApproved", keyPath: "checkInApproved"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "manualApproved", keyPath: "manualApproved"))
           
            
        mapping.addRelationshipMapping(AttendanceUser.defaultMapping(),forProperty: "attendanceuser", keyPath:"user")
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "checkInTime", keyPath: "checkInTime"))
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "checkOutTime", keyPath: "checkOutTime"))
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "endTime", keyPath: "endTime"))
             
        mapping.addAttributes(from: dic)
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getContext()->NSManagedObjectContext{
         return NSManagedObjectContext.mr_default()
    }
}
