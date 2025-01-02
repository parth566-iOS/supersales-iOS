//
//  TerritoryData.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(Territory)
class Territory: NSManagedObject {
    
   // static let entity:String! = "Territory"
    @NSManaged var iD:Int32
    @NSManaged var companyId:Int64
    @NSManaged var modifiedBy:Int64
    @NSManaged var modifiedTime:String
    @NSManaged var status:Int64
    @NSManaged var territoryCode:String
    @NSManaged var territoryId:Int64
    @NSManaged var territoryUserMobile:Int64
    @NSManaged var territoryUserName:String
    @NSManaged var territoryName:String
    
    //Territory
    class func entityName()->String{
        return "Territory"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "Territory")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyId", keyPath: "companyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "modifiedBy", keyPath: "modifiedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "status", keyPath: "status"))
        
        //mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "territoryId))
        mapping.addAttribute(Mapping.intAttributeFor(property: "territoryUserId", keyPath: "territoryUserID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "territoryUserMobile", keyPath: "territoryUserMobile"))
        
        mapping.addAttributes(from: ["modifiedTime":"modifiedTime","territoryCode":"territoryCode","territoryName":"territoryName","territoryUserName":"territoryUserName"])
    
        mapping.primaryKey = "iD"
        return mapping
    }
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        //        if rootClass != nil{
        //            dictionary["rootClass"] = rootClass.toDictionary()
        //        }
        dictionary["ID"] = iD
        dictionary["companyId"] = companyId
        dictionary["modifiedBy"] = modifiedBy
        dictionary["territoryId"] = iD
        //dictionary["territoryUserID"] = territoryUserId
        dictionary["territoryUserMobile"] = territoryUserMobile
        dictionary["modifiedTime"] = modifiedTime
        dictionary["territoryCode"] = territoryCode
        dictionary["territoryName"] = territoryName
        dictionary["territoryUserName"] = territoryUserName
       
        return dictionary
    }
    class func getAll()->[Territory]{
       //[[Territory MR_findAllSortedBy:@"iD" ascending:YES inContext:[NSManagedObjectContext MR_defaultContext]] mutableCopy];
      //  Territory.mr_findAllSorted(by: "iD", ascending: true, in: AppDelegate().)
        return Territory.mr_findAllSorted(by: "iD", ascending: true) as? [Territory] ?? [Territory]()
    }
    
    class func getTerritoryUsingPredicate(predicate:NSPredicate)->[Territory]{
        return Territory.mr_findAllSorted(by: "iD", ascending: true, with: predicate) as? [Territory] ?? [Territory]()
    }
    
    class func getTerritory(territotryID:NSNumber)->Territory?
{
        if let territory = (Territory.mr_find(byAttribute: "iD", withValue: territotryID) as? [Territory])?.first{
        return territory
    }else{
        return nil
    }
}
    
}
