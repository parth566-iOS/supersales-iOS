//
//  PermanentAddresss.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(PermanentAddresss)
class PermanentAddresss: NSManagedObject {

    @NSManaged var addressLine1:String
    @NSManaged var addressLine2:String
    @NSManaged var city:String
    @NSManaged var country:String
    @NSManaged var entity_id:NSNumber
    @NSManaged var lastmodified:NSDate
    @NSManaged var lastmodifiedby:NSNumber
    @NSManaged var latitude:NSNumber
    @NSManaged var longitude:NSNumber
    @NSManaged var pincode:String
    @NSManaged var state:String
    @NSManaged var verified:NSNumber
    @NSManaged var companyuser:NSSet
    
    
    
    class func entityName()->String{
        return "PermanentAddresss"
    }
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "PermanentAddresss")
        mapping.addAttributes(from: ["addressLine1"  : "addressLine1","addressLine2":"addressLine2","city":"City","country":"country"])
        mapping.primaryKey = "entity_id"
        return mapping
    }
}
