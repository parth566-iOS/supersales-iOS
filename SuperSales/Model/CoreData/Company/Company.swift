//
//  Company.swift
//  SuperSales
//
//  Created by Apple on 23/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(Company)
class Company: NSManagedObject {
    
    
    @NSManaged var  autoLeaveUpdate:NSNumber?
    @NSManaged var  companyid:Int64
    @NSManaged var  createdBy:Int64
    @NSManaged var  endTime:NSDate?
    @NSManaged var  minimumWorkingTime:String?
    @NSManaged var  modifiedBy:Int64
    @NSManaged var  lastModifiedBy:Int64
    @NSManaged var  notificationLevel:NSNumber?
    @NSManaged var  payrollEnabled:NSNumber?
    @NSManaged var  saturdayPolicy:NSNumber?
    @NSManaged var  startTime:NSDate?
    @NSManaged var  trackingInteval:NSNumber?
    @NSManaged var  trackingStartTime:NSDate?
    @NSManaged var  trakingEndTime:NSDate?
    @NSManaged var  userid:Int64
    @NSManaged var  iD:Int64
    @NSManaged var  ownID:Int64
    @NSManaged var  companyTypeID:Int32
    @NSManaged var  isActive:Bool
    @NSManaged var  superSalesCustomerTagging:Bool
    //Location Type
    @NSManaged var  homeType:NSNumber?
    @NSManaged var   officeType:NSNumber?
    @NSManaged var   customerType:NSNumber?
    @NSManaged var   vendorType:NSNumber?
    @NSManaged var   travelLocalType:NSNumber?
    @NSManaged var   travelUpCountryType:NSNumber?

    @NSManaged var  workingDays:String?
    @NSManaged var  workingSaturday:String?
    
    
    class func entityName()->String{
        return "Company"
    }
    
    class func defaultMapping()->FEMMapping{
         let mapping = FEMMapping.init(entityName: self.entityName())
        var dic = CDHelper().mappingForClass(classname: Company.self)
        dic.removeValue(forKey: "autoLeaveUpdate")
        dic.removeValue(forKey: "companyid")
        dic.removeValue(forKey: "createdBy")
        dic.removeValue(forKey: "endTime")
        dic.removeValue(forKey: "modifiedBy")
        dic.removeValue(forKey: "notificationLevel")
        dic.removeValue(forKey: "saturdayPolicy")
        dic.removeValue(forKey: "officeType")
        dic.removeValue(forKey: "homeType")
        dic.removeValue(forKey: "customerType")
        dic.removeValue(forKey: "vendorType")
        dic.removeValue(forKey: "travelUpCountryType")
        dic.removeValue(forKey: "travelLocalType")
        dic.removeValue(forKey: "startTime")
        dic.removeValue(forKey: "trackingInteval")
        dic.removeValue(forKey: "trackingStartTime")
        dic.removeValue(forKey: "trakingEndTime")
        dic.removeValue(forKey: "userid")
        
        
        mapping.addAttribute(Mapping.boolAttributeFor(property:"autoLeaveUpdate",keyPath:"AutoLeaveUpdate"))
        mapping.addAttribute(Mapping.boolAttributeFor(property:"payrollEnabled",keyPath:"payrollEnabled"))
        mapping.addAttribute(Mapping.boolAttributeFor(property:"saturdayPolicy",keyPath:"saturdayPolicy"))
        mapping.addAttribute(Mapping.boolAttributeFor(property:"isActive",keyPath:"isActive"))
        mapping.addAttribute(Mapping.boolAttributeFor(property:"customerType",keyPath:"customerType"))
        mapping.addAttribute(Mapping.boolAttributeFor(property:"homeType",keyPath:"homeType"))
      mapping.addAttribute(Mapping.boolAttributeFor(property:"vendorType",keyPath:"vendorType"))
      mapping.addAttribute(Mapping.boolAttributeFor(property:"officeType",keyPath:"officeType"))
  mapping.addAttribute(Mapping.boolAttributeFor(property:"travelUpCountryType",keyPath:"travelUpCountryType"))
      mapping.addAttribute(Mapping.boolAttributeFor(property:"travelLocalType",keyPath:"travelLocalType"))
        mapping.addAttribute(Mapping.boolAttributeFor(property:"superSalesCustomerTagging",keyPath:"superSalesCustomerTagging"))
        mapping.addAttribute(Mapping.boolAttributeFor(property:"isFifteenMinTracking",keyPath:"isFifteenMinTracking"))
        mapping.addAttribute(Mapping.boolAttributeFor(property:"isShelfieAllowed",keyPath:"isShelfieAllowed"))
        mapping.addAttribute(Mapping.boolAttributeFor(property:"isActive",keyPath:"isActive"))
        mapping.addAttribute(Mapping.intAttributeFor(property:"companyid",keyPath:"companyid"))
      
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "createdBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "lastModifiedBy", keyPath: "LastModifiedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "modifiedBy", keyPath: "modifiedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "notificationLevel", keyPath: "notificationLevel"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "userid", keyPath: "userid"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
      
       mapping.addAttribute(Mapping.intAttributeFor(property: "ownerID", keyPath: "OwnerID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyTypeID", keyPath: "CompanyTypeID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "endTime", keyPath: "endTime"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "role_application_id", keyPath: "role.applicationID"))
        mapping.addRelationshipMapping(ManagerCoreData.defaultMapping(), forProperty: "manager" , keyPath: "Manager")
        mapping.addRelationshipMapping(PermanentAddresss.defaultMapping(), forProperty: "permanent_address", keyPath: "permanentAddress")
        mapping.addAttributes(from: dic)
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func getCompanyByID(companyID:NSNumber)-> Company?{
        if let outcome = Company.mr_find(byAttribute: "iD", withValue: companyID) as? Company{
            return outcome
        }else{
            let predicate = NSPredicate.init(format: "iD == %d",companyID.intValue)
            if let outcome =  Company.mr_findFirst(with: predicate){
                return outcome
            }else{
                return nil
            }
        }
    }
    class func getAll()->[Company]{
        return Company.mr_findAll() as? [Company] ?? [Company]()
    }
}
