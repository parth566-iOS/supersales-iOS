//
//  VisitCounterShareSubCategoryList.swift
//  SuperSales
//
//  Created by Apple on 10/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping


@objc(VisitCounterShareSubCategoryList)
class VisitCounterShareSubCategoryList: NSManagedObject {

    @NSManaged var iD:Int64
    @NSManaged var counterShareID:Int64
    @NSManaged var subcategoryID:Int64
    @NSManaged var companyShareValue:Int64
    @NSManaged var createdBy:Int64
    @NSManaged var categoryList:NSSet
    
    
    class func entityName()->String{
        return "VisitCounterShareSubCategoryList"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "VisitCounterShareSubCategoryList")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "counterShareID", keyPath: "counterShareID"))
          mapping.addAttribute(Mapping.doubleAttributeFor(property: "subcategoryID", keyPath: "subcategoryID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "createdBy"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "companyShareValue", keyPath: "companyShareValue"))
        
        mapping.primaryKey = "iD"
        return mapping
    }
}
