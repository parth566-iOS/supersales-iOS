//
//  LeaveUser.swift
//  SuperSales
//
//  Created by mac on 02/02/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(LeaveUser)
class LeaveUser: NSManagedObject {
    @NSManaged var companyId:Int32
    @NSManaged var desc:String!
    @NSManaged var deviceid:String!
    @NSManaged var emailID:String!
    @NSManaged var entity_id:Int32
    @NSManaged var firstName:String!
    @NSManaged var lastName:String!
    @NSManaged var picture:String?
    @NSManaged var roleId:Int32
    @NSManaged var leave:Leave
    
    
    class func entityName()->String{
        return "LeaveUser"
    }
    
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: self.entityName())
        var dic = CDHelper().mappingForClass(classname: LeaveUser.self)
       
       
        dic.removeValue(forKey: "entity_id")
        dic.removeValue(forKey: "companyId")
        dic.removeValue(forKey: "roleId")
        
        mapping.addAttribute(Mapping.intAttributeFor(property:"entity_id",keyPath:"id"))
        mapping.addAttribute(Mapping.intAttributeFor(property:"companyId",keyPath:"companyId"))
        mapping.addAttribute(Mapping.intAttributeFor(property:"roleId",keyPath:"roleId"))
        mapping.addAttributes(from: dic)
      //  mapping.addAttributes(from: ["firstName":"firstname","lastName":"lastname","picture":"userImagePath","desc":"desc"])
      
        return mapping
    }
    class func getAll()->[LeaveUser]{
        return LeaveUser.mr_findAll() as? [LeaveUser] ?? [LeaveUser]()
    }
}
