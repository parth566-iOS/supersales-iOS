//
//  KYCDetailOFCustomer.swift
//  SuperSales
//
//  Created by mac on 15/04/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import CoreData
import FastEasyMapping

@objc(KYCDetailOFCustomer)
class KYCDetailOFCustomer: NSManagedObject {
  
    @NSManaged var iD : Int64
    @NSManaged var customerID : Int64
    @NSManaged var createdDate:String
    @NSManaged var modifiedDate:String
    @NSManaged var approvedStatusKyc1:Int16
    @NSManaged var approvedStatusKyc2:Int16
    @NSManaged var approvedStatusKyc3:Int16
    @NSManaged var createdBy : Int64
    @NSManaged var approvedBy : Int64
    @NSManaged var companyID : Int64
    @NSManaged var kyc1Number : String
    @NSManaged var kyc1Type : String
    @NSManaged var kyc1Url : String
    @NSManaged var kyc2Number : String
    @NSManaged var kyc2Type : String
    @NSManaged var kyc2Url : String
    @NSManaged var kyc3Number : String
    @NSManaged var kyc3Type : String
    @NSManaged var kyc3Url : String
    
    
    class func entityName()->String{
        return "KYCDetailOFCustomer"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "KYCDetailOFCustomer")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "id"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "customerID", keyPath: "customerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedStatusKyc1", keyPath: "approvedStatusKyc1"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedStatusKyc2", keyPath: "approvedStatusKyc2"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedStatusKyc3", keyPath: "approvedStatusKyc3"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "createdBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "approvedBy", keyPath: "approvedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "companyID"))
        mapping.addAttributes(from:["createdDate":"createdDate","modifiedDate":"modifiedDate","kyc1Type":"Kyc1Type","kyc1Url":"Kyc1Url","kyc1Number":"Kyc1Number","kyc2Type":"Kyc2Type","kyc2Url":"Kyc2Url","kyc2Number":"Kyc2Number","kyc3Type":"Kyc3Type","kyc3Url":"Kyc3Url","kyc3Number":"Kyc3Number"])
        
        mapping.primaryKey = "iD"
        return mapping
    }
}
