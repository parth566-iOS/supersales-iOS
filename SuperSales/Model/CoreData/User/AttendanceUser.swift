//
//  AttendanceUser.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(AttendanceUser)
class AttendanceUser: NSManagedObject {
   // swiftlint:disable Name Violation
    @NSManaged  var companyId:Int64
    @NSManaged var desc:String
    @NSManaged var deviceid:String
    @NSManaged var emailID:String
    @NSManaged var entity_id:Int
    @NSManaged var firstName:String
    @NSManaged var lastName:String
    @NSManaged var picture:String
    @NSManaged var userImagePath:String
    @NSManaged var roleId:Int64
    @NSManaged var userId:Int64
    @NSManaged var attendanceHistory:NSSet
    @NSManaged var attendanceUserHistory:NSSet
    
    class func entityName()->String{
        return "AttendanceUser"
    }
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "AttendanceUser")
        var dict = CDHelper().mappingForClass(classname: AttendanceUser.self)
        dict.removeValue(forKey: "entity_id")
        dict.removeValue(forKey: "companyId")
        dict.removeValue(forKey: "roleId")
        dict.removeValue(forKey: "userId")
     //   dict.removeobject
        mapping.addAttribute(Mapping.intAttributeFor(property: "entity_id", keyPath: "userId"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyId", keyPath: "companyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "roleId", keyPath: "role"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "userId", keyPath: "userId"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "userId", keyPath: "id"))
        
        mapping.addAttributes(from:dict)
        mapping.primaryKey = "iD"
        return mapping
    }
}

