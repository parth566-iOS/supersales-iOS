//
//  DefaultSetting.swift
//  SuperSales
//
//  Created by Apple on 28/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping


@objc(DefaultSetting)
class DefaultSetting: NSManagedObject {

    var address_id:NSNumber!
    var client_name:String!
    var clientvendorid:NSNumber!
    var company_id:NSNumber!
    var locationtype:NSNumber!
    var modified_by:NSNumber!
    var user_id:NSNumber!
    var user_location_type:NSNumber!
    var clientaddress:AddressList?
   

    class func entityName()->String{
        return "DefaultSetting"
    }
    
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: self.entityName())
        mapping.addAttribute(Mapping.intAttributeFor(property: "user_id", keyPath: "UserID"))
        //mapping.addAttribute(Mapping.intAttributeFor(property: <#T##String#>, keyPath: <#T##String#>))
        mapping.addAttribute(Mapping.intAttributeFor(property: "company_id", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "address_id", keyPath: "AddressID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "clientvendorid", keyPath: "ClientVendorID"))
         mapping.addAttribute(Mapping.intAttributeFor(property: "locationtype", keyPath: "LocationType"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "modified_by", keyPath: "ModifiedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "user_location_type", keyPath: "UserLocationType"))
        mapping.addAttributes(from: ["client_name":"ClientName"])
    mapping.addRelationshipMapping(AddressList.defaultmapping(), forProperty: "clientaddress", keyPath: "ClientAddress")
        mapping.primaryKey = "clientvendorid"
        print("mapping = \(mapping)")
        return mapping
    }
    class func getAll()->[DefaultSetting]{
        print(DefaultSetting.mr_findAll())
        return DefaultSetting.mr_findAll() as? [DefaultSetting] ?? [DefaultSetting]()
    }
    class func getDefaultSetting()->DefaultSetting?{
   // DefaultSetting *defaultSetting = [DefaultSetting MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
      
        if let dsetting = DefaultSetting.mr_findFirst(in: NSManagedObjectContext.mr_default()) as? DefaultSetting{ //DefaultSetting.mr_findfirst(in:NSManagedObjectContext.mr_default()) as? DefaultSetting{
            //as? DefaultSetting{
//            if let defaultsetting = DefaultSetting.mr_findAll()?.first as? DefaultSetting{
//                print("address id = \(defaultsetting.address_id)")
//                //print(defaultsetting.userid)
//                print("Location  type in dafault setting = \(defaultsetting.location_type)")
//                }
         // print("location type in model  = \(dsetting.location_type)")
           return dsetting
        }
   else{
            return nil
        }
    }
}
