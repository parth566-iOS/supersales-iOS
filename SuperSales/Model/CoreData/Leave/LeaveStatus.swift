//
//  LeaveStatus.swift
//  SuperSales
//
//  Created by mac on 01/02/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(LeaveStatus)

class LeaveStatus: NSManagedObject {

    @NSManaged var appliedOn:Date!
    @NSManaged var approvedBy:Int32
    @NSManaged var approvedOn:Date!
    @NSManaged var date:Date!
    @NSManaged var companyID:Int32
    @NSManaged var entity_id:Int32
    @NSManaged var leaveDay:String!
    @NSManaged var modifiedBy:Int32
    @NSManaged var reason:String!
    @NSManaged var status:String!
    @NSManaged var transactionID:String!
    @NSManaged var type:String!
    @NSManaged var medicalCerti:String!
    @NSManaged var leavestatususer:LeaveStatusUser
    
    class func entityName()->String{
        return "LeaveStatus"
    }
    
    class func defaultMapping()->FEMMapping{
         let mapping = FEMMapping.init(entityName: self.entityName())
        var dic = CDHelper().mappingForClass(classname: LeaveStatus.self)
       
        dic.removeValue(forKey: "companyID")
        dic.removeValue(forKey: "entity_id")
        dic.removeValue(forKey: "appliedOn")
        dic.removeValue(forKey: "approvedOn")
        dic.removeValue(forKey: "approvedBy")
        dic.removeValue(forKey: "date")
        dic.removeValue(forKey: "modifiedBy")
//        dic.removeValue(forKey: "medicalCerti")
       
        
        
        
        mapping.addAttribute(Mapping.intAttributeFor(property:"companyID",keyPath:"companyID"))
//        mapping.addAttribute(Mapping.intAttributeFor(property: "medicalCerti", keyPath: "medicalCerti"))
       
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedBy", keyPath: "approvedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "entity_id", keyPath: "leaveID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "modifiedBy", keyPath: "modifiedBy"))
        
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "appliedOn", keyPath: "appliedOn"))
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "approvedOn", keyPath: "approvedOn"))
        mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "date", keyPath: "date"))
     
        mapping.addRelationship(FEMRelationship.init(property: "leavestatususer", keyPath: "user", mapping: LeaveStatusUser.defaultMapping()))
        mapping.addAttributes(from: dic)
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getLeavesbyMember(memberID:NSNumber)-> [LeaveStatus]{
        let predicate = NSPredicate.init(format: "self.leavestatususer.entity_id == %d", memberID .int32Value) 
        let arr = LeaveStatus.mr_findAll(with: predicate, in: NSManagedObjectContext.mr_default()) as? [LeaveStatus] ?? [LeaveStatus]()
        let sortedArray = arr.sorted(by: { (obj1, obj2) -> Bool in
            obj1.date > obj2.date
        })
        return sortedArray
//        if let outcome = Company.mr_find(byAttribute: "iD", withValue: companyID) as? Company{
//            return outcome
//        }else{
//            let predicate = NSPredicate.init(format: "iD == %d",companyID.intValue)
//            if let outcome =  Company.mr_findFirst(with: predicate){
//                return outcome
//            }else{
//                return nil
//            }
//        }
    }
    
    class func getLeaveStatusByID(statusid:NSNumber)->LeaveStatus?{
        if let leavestatus = LeaveStatus.mr_findFirst(byAttribute: "entity_id", withValue: statusid, in: NSManagedObjectContext.mr_default()){
            return leavestatus
        }else{
            return nil
        }
    }
    class func getAll()->[LeaveStatus]{
        return LeaveStatus.mr_findAll() as? [LeaveStatus] ?? [LeaveStatus]()
    }
}
