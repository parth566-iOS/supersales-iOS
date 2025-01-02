//
//  LeaveBalance.swift
//  SuperSales
//
//  Created by mac on 01/02/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(LeaveBalance)
class LeaveBalance: NSManagedObject {
    @NSManaged var leaveType:String!
    @NSManaged var companyID:Int32
    @NSManaged var leaveBalance:Float
    @NSManaged var leavesTaken:Float
    @NSManaged var modifiedBy:Int32
    @NSManaged var userID:Int32
    @NSManaged var totalLeaves:Float
    
    class func entityName()->String{
        return "LeaveBalance"
    }
    
    class func defaultMapping()->FEMMapping{
         let mapping = FEMMapping.init(entityName: self.entityName())
        var dic = CDHelper().mappingForClass(classname: LeaveBalance.self)
       
        dic.removeValue(forKey: "companyID")
        dic.removeValue(forKey: "leaveBalance")
        dic.removeValue(forKey: "leavesTaken")
        dic.removeValue(forKey: "modifiedBy")
        dic.removeValue(forKey: "user_id")
        dic.removeValue(forKey: "totalLeaves")
       
        
        
        
        mapping.addAttribute(Mapping.intAttributeFor(property:"companyID",keyPath:"CompanyID"))
      
       
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "modifiedBy", keyPath: "ModifiedBy"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "leaveBalance", keyPath: "LeaveBalance"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "leavesTaken", keyPath: "LeavesTaken"))
        mapping.addAttribute(Mapping.floatAttributeFor(property: "totalLeaves", keyPath: "TotalLeaves"))
     
        mapping.addAttributes(from: dic)
        mapping.primaryKey = "iD"
        return mapping
    }
    
//    class func getCompanyByID(companyID:NSNumber)-> Company?{
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
//    }
    class func getAll()->[LeaveBalance]{
        return LeaveBalance.mr_findAll() as? [LeaveBalance] ?? [LeaveBalance]()
    }
}
