//
//  MetadataVATCodes.swift
//  
//
//  Created by Apple on 11/01/20.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(MetadataVATCodes)
class MetadataVATCodes: NSManagedObject {

    @NSManaged var iD:Int16
    @NSManaged var tAXPercentage:Float
    @NSManaged var vATCode:String
    @NSManaged var tAXName:String
    @NSManaged var inclusiveExclusive:String
    
    class func entityName()->String{
        return "MetadataVATCodes"
    }
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "MetadataVATCodes")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
         mapping.addAttribute(Mapping.floatAttributeFor(property: "tAXPercentage", keyPath: "TAXPercentage"))
        mapping.addAttributes(from: ["vATCode": "VATCode","tAXName":"TAXName","inclusiveExclusive":"InclusiveExclusive"])
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func getAll()->[MetadataVATCodes]{
        //, in: AppDelegate().managedcontextobjectappdelegate
        return MetadataVATCodes.mr_findAllSorted(by: "iD", ascending: true) as? [MetadataVATCodes] ?? [MetadataVATCodes]()
    }
    
    class func getVatPerFromID(ID: NSNumber) -> MetadataVATCodes?{
        return MetadataVATCodes.mr_findFirst(byAttribute: "iD", withValue: ID, in: NSManagedObjectContext.mr_default())
    }
}
