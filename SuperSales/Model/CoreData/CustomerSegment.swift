//
//  CustomerSegment.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(CustomerSegment)
class CustomerSegment: NSManagedObject {

    @NSManaged var companyID:Int64
    @NSManaged var createdBy:Int64
    @NSManaged var iD:Int64
    @NSManaged var customerSegmentIndexID:Int64
    @NSManaged var customerSegmentValue:String
    @NSManaged var customerType:String
    
    class func entityName()->String{
        return "CustomerSegment"
    }
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "CustomerSegment")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "customerSegmentIndexID", keyPath: "CustomerSegmentIndexID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttributes(from: ["customerSegmentValue" : "CustomerSegmentValue","customerType":"customerType"])
        mapping.primaryKey = "iD"
        return mapping
    }
    /*
     ["ID":NSNumber.init(value: 0),"CompanyID":Utils().getActiveAccount()?.company?.iD ?? NSNumber.init(value: 0),"CustomerSegmentValue":"Default Customer Segment","CustomerSegmentIndexID":NSNumber.init(value: 0),"CreatedBy":NSNumber.init(value: 0)]
     
     **/
    class func getAll()->[CustomerSegment]{
        //[[CustomerSegment MR_findAllSortedBy:@"iD" ascending:YES inContext:[NSManagedObjectContext MR_defaultContext]] mutableCopy];
     // return  CustomerSegment.mr_findAllSorted(by: "iD", ascending: true, in:AppDelegate.shared.managedObjectContext) as? [CustomerSegment] ?? [CustomerSegment]()
        return CustomerSegment.mr_findAllSorted(by: "iD", ascending: true) as? [CustomerSegment] ?? [CustomerSegment]()
    }
    
    class func getSegmentById(segmentID:NSNumber)->CustomerSegment?{
        if let customersegment = ((CustomerSegment.mr_find(byAttribute: "iD", withValue: segmentID) as? [CustomerSegment])?.first){
            return customersegment
        }else{
            return nil
        }
    }
}
