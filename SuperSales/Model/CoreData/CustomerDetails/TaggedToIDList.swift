//
//  TaggedToIDList.swift
//  SuperSales
//
//  Created by Apple on 10/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(TaggedToIDList)
class TaggedToIDList: NSManagedObject {
    
    @NSManaged var createdBy : Int
    @NSManaged var customerID : Int
    @NSManaged var iD : Int
    @NSManaged var taggedUserID : Int
    @NSManaged var taggedUserRoleID : Int
     @NSManaged var taggedUsersName : String
    
    class func entityName()->String{
        return "TaggedToIDList"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "TaggedToIDList")
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "customerID", keyPath: "CustomerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "taggedUserID", keyPath: "TaggedUserID"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "taggedUserRoleID", keyPath: "TaggedUserRoleID"))
        
        mapping.addAttributes(from: ["taggedUsersName":"TaggedUsersName"])
        
        mapping.primaryKey = "iD"
    return mapping
    }
}
