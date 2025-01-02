//
//  Outcomes.swift
//  SuperSales
//
//  Created by Apple on 10/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(Outcomes)
class Outcomes: NSManagedObject {
    
    @NSManaged var iD:Int64
    @NSManaged var companyID:Int64
    @NSManaged var createdBy:Int64
    @NSManaged var leadOutcomeIndexID:Int64
    @NSManaged var year:Int64
    @NSManaged var month:Int64
    @NSManaged var leadOutcomeClose:Int16
    @NSManaged var leadOutcomeCount:Int16
    @NSManaged var isShelf:Int16
    @NSManaged var leadOutcomeValue:String
    @NSManaged var outcomeType:Int16
    @NSManaged var customerType:String
    @NSManaged var customerSegment:String
    
    
    class func entityName()->String{
        return "Outcomes"
    }
    class func getContext()->NSManagedObjectContext{
        return NSManagedObjectContext.mr_default()
    }
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "Outcomes")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadOutcomeClose", keyPath: "LeadOutcomeClose"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "year", keyPath: "year"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "month", keyPath: "month"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadOutcomeCount", keyPath: "LeadOutcomeCount"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadOutcomeIndexID", keyPath: "LeadOutcomeIndexID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "outcomeType", keyPath: "outcomeType"))
     
        mapping.addAttribute(Mapping.intAttributeFor(property: "isShelf", keyPath: "isShelf"))
        
        mapping.addAttributes(from: ["customerSegment":"customerSegment","customerType":"customerType","leadOutcomeValue":"LeadOutcomeValue"])
      
       
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func getOutcomeFromID (leadSourceID:NSNumber)->String{
        if   let outcome = Outcomes.mr_findFirst(byAttribute: "leadOutcomeIndexID", withValue: leadSourceID){
            return outcome.leadOutcomeValue
        }else{
            let predicate = NSPredicate.init(format: "leadOutcomeIndexID == %d",leadSourceID.intValue)
            if let outcome =  Outcomes.mr_findFirst(with: predicate){
                return outcome.leadOutcomeValue
            }else{
                return ""
            }
        }
    }
    
    class func getOutcome(leadSourceID:NSNumber)->Outcomes?
    {
        if let outcome = Outcomes.mr_find(byAttribute: "leadOutcomeIndexID", withValue: leadSourceID) as? Outcomes{
            return outcome
        }else{
            let predicate = NSPredicate.init(format: "leadOutcomeIndexID == %d",leadSourceID.intValue)
            if let outcome =  Outcomes.mr_findFirst(with: predicate){
                return outcome
            }else{
                return nil
            }
        }
    }
    
    class func getAll()->[Outcomes]{
        
        /*
         +(NSMutableArray *)getAll{
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (leadOutcomeValue CONTAINS 'Auto Close')"];
         return [[Outcomes MR_findAllSortedBy:@"iD" ascending:YES withPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]] mutableCopy];
         //    return [[Outcomes MR_findAllSortedBy:@"iD" ascending:YES inContext:[NSManagedObjectContext MR_defaultContext]] mutableCopy];
         }
         */
//        let predicate = NSPredicate.init(format: "NOT (leadOutcomeValue CONTAINS %@)", argumentArray: ["Auto Close"])
//        return Outcomes.mr_findAllSorted(by: "iD", ascending: true, with: predicate) as? [Outcomes] ?? [Outcomes]()
        
        return Outcomes.mr_findAllSorted(by: "iD", ascending: true, in: NSManagedObjectContext.mr_default()) as? [Outcomes] ?? [Outcomes]()
    }
    
    class func getOutComeAccordingTocustomer(custSegment:String,custType:String)->[Outcomes]{
        var excludedOutcome = [Outcomes]()
        let allOutcome = self.getAll()
       /* for outcome in allOutcome{
            if(outcome.customerSegment.count == 0 && outcome.customerType.count == 0){
                return Outcomes.mr_findAllSorted(by: "iD", ascending: true, in: NSManagedObjectContext.mr_default()) as? [Outcomes] ?? [Outcomes]()
            }else{
                let arrOfSegment = outcome.customerSegment.split(separator: ",") as? [String] ?? [String]()
                let arrOfType = outcome.customerType.split(separator: ",") as? [String] ?? [String]()
                if(arrOfType.count == 1 && arrOfSegment.count == 1){
                    if((arrOfType.first == "0" || arrOfType.first == custType) && (arrOfSegment.first == "999999" || arrOfSegment.first == custSegment)){
                        excludedOutcome.append(outcome)
                    }else{
                       
                    }
                }else if(arrOfType.contains(custType) && arrOfSegment.contains(custSegment)){
                    excludedOutcome.append(outcome)
                }else{
                   
                }
                
            }
        }*/
        excludedOutcome = allOutcome.filter({ outcome in
            let strCustSeg = outcome.customerSegment as? String ?? String()
            let strCustType = outcome.customerType as? String ?? String()
            var  arrOfSeg1 =  strCustSeg.split(separator: ",") as? [Int] ?? [Int]()
            print(arrOfSeg1)
            let arrOfSeg = strCustSeg.split(separator: ",")
            let arrOfType = strCustType.split(separator: ",")
        
            return ((strCustType.contains(custType)) && (strCustSeg.contains(custSegment)) || (strCustType == "0" && strCustSeg == "999999"))
        })
        return excludedOutcome
    }
    

    
    class func isTrialSuccessful()-> Outcomes? {
        let predicate = NSPredicate(format: "leadOutcomeValue CONTAINS 'Trial Successful'")
        return Outcomes.mr_findFirst(with: predicate, sortedBy: "iD", ascending: true, in: NSManagedObjectContext.mr_default())
    }
}
