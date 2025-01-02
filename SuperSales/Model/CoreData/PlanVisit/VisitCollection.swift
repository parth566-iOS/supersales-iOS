//
//  VisitCollection.swift
//  SuperSales
//
//  Created by Apple on 10/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(VisitCollection)
class VisitCollection: NSManagedObject {

    @NSManaged var iD:Int64
    @NSManaged var balanceValue:Double
    @NSManaged var collectionValue:Double
    @NSManaged var createdBy:Int64
    @NSManaged var followUpDate:String!
    @NSManaged var visitID:Int64
    @NSManaged var plannVisit:PlannVisit
    @NSManaged var modeOfPayment:Int16
    @NSManaged var referenceNo:String?
   
    
    class func entityName()->String{
        return "VisitCollection"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "VisitCollection")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "balanceValue", keyPath: "balanceValue"))
        mapping.addAttribute(Mapping.doubleAttributeFor(property: "collectionValue", keyPath: "collectionValue"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "visitID", keyPath: "visitID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "modeOfPayment", keyPath: "modeOfPayment"))
        mapping.addAttributes(from: ["followUpDate":"followUpDate","referenceNo":"referenceNo"])//,"referenceNo":"referenceNo","visitID":"visitID"
        mapping.primaryKey = "iD"
        return mapping
    }
    
   class func getVisitCollectionFromID(id:NSNumber)->VisitCollection?{
        if let  collection = VisitCollection.mr_findFirst(byAttribute: "visitID", withValue: id){
            return collection
        }else{
            return nil
        }
    }
}
