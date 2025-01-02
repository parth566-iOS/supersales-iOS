//
//  CompanyUsers.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(CompanyUsers)
class CompanyUsers: NSManagedObject {
      // swiftlint:disable Name violation
    
    @NSManaged var deviceID:String
    @NSManaged var emailID:String
    @NSManaged var emailVerified:NSNumber
    @NSManaged var entity_id:NSNumber
    @NSManaged var firstName:String
    @NSManaged var invalidLoginAttempt:NSNumber
    @NSManaged var lastModifiedBy:NSNumber
    @NSManaged var lastName:String
    @NSManaged var mobileNo1:String
    @NSManaged var mobileNo2:String
    @NSManaged var otp:String
    @NSManaged var otpGenerateTime:Date
    @NSManaged var password:String
    @NSManaged var picture:String?
    @NSManaged var role_application_id:NSNumber
    @NSManaged var role_id:NSNumber
    @NSManaged var role_desc:String
    @NSManaged var manager:ManagerCoreData
    @NSManaged var permanent_address:PermanentAddres
    

    
    class func entityName()->String{
        return "CompanyUsers"
    }
    class func defaultMapping()->FEMMapping{
         let mapping = FEMMapping.init(entityName: self.entityName())
        var dic = CDHelper().mappingForClass(classname: CompanyUsers.self)
        dic.removeValue(forKey: "entity_id")
          dic.removeValue(forKey: "invalidLoginAttempt")
          dic.removeValue(forKey: "lastModifiedBy")
          dic.removeValue(forKey: "otpGenerateTime")
          dic.removeValue(forKey: "role_application_id")
         dic.removeValue(forKey: "role_id")
         dic.removeValue(forKey: "emailVerified")
        
      mapping.addAttribute(Mapping.dateTimeAttributeFor(property: "otpGenerateTime", keyPath: "otpGenerateTime"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "entity_id", keyPath: "UserID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
      
       mapping.addAttribute(Mapping.boolAttributeFor(property: "emailVerified", keyPath: "EmailVerified"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "role_id", keyPath: "role.id"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "role_desc", keyPath: "role.desc"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "role_application_id", keyPath: "role.applicationID"))
        mapping.addRelationshipMapping(ManagerCoreData.defaultMapping(), forProperty: "manager" , keyPath: "Manager")
        mapping.addRelationshipMapping(PermanentAddresss.defaultMapping(), forProperty: "permanent_address", keyPath: "permanentAddress")
        mapping.addAttributes(from: dic)
        mapping.primaryKey = "entity_id"
        return mapping
    }
    
    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
    
    func getUser(userId:NSNumber)->CompanyUsers?{
        let arrcustomer = (CompanyUsers.mr_find(byAttribute: "entity_id", withValue: userId) as? [CompanyUsers])
        if(arrcustomer?.count ?? 0 > 0){
        return arrcustomer?.first
    }else{
    return nil
    }
    }
    
    func getRoleIDFromUserId(userID:NSNumber)->NSNumber?{
        if let  user =  CompanyUsers.mr_findFirst(byAttribute: "entity_id", withValue: userID){
            return user.role_id
        }else{
            return nil
        }
    }
    
    func getFilteredUserByIDs(arrOfId:[NSNumber])->[CompanyUsers]{
       var companyUsers = [CompanyUsers]()
        for int in arrOfId{
            if let companyu = self.getUser(userId:int){
                print(companyu.role_id)
            companyUsers.append(companyu)
            }
        }
       
        return companyUsers
    }
    
    class func getAll()->[SOrder]{
        let predicate = NSPredicate(format: "statusID != 7")
        return SOrder.mr_findAllSorted(by: "seriesPostfix", ascending: false, with: predicate) as? [SOrder] ?? [SOrder]()
    }
    
   
    class func getFilteredUserUpper(roleId: NSNumber) -> [CompanyUsers]{
        let predicate = NSPredicate(format: "role_id <= %@",roleId)
        return CompanyUsers.mr_findAllSorted(by: "firstName", ascending: true, with: predicate) as? [CompanyUsers] ?? [CompanyUsers]()
    }
}
