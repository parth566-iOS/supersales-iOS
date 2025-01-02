//
//  Manager.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(ManagerCoreData)
class ManagerCoreData: NSManagedObject {
    
    @NSManaged var emailVerified:NSNumber
    @NSManaged var entity_id:NSNumber
    @NSManaged var firstName:String
    @NSManaged var lastName:String
    @NSManaged var picture:String
    @NSManaged var invalidLoginAttempt:NSNumber
    @NSManaged var lastmodifiedby:NSNumber
    @NSManaged var companyuser:NSSet
    
    
    class func entityName()->String{
        return "Manager"
    }
    class func defaultMapping()->FEMMapping{
         let mapping = FEMMapping.init(entityName: "Manager")
        
        
        return mapping
    }
}


