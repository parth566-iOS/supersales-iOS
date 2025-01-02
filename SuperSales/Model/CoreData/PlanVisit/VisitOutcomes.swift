//
//  VisitOutcomes.swift
//  SuperSales
//
//  Created by Apple on 10/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping


@objc(VisitOutcomes)
class VisitOutcomes: NSManagedObject {

    @NSManaged var iD:Int64
    @NSManaged var companyID:Int64
    @NSManaged var createdBy:Int64
    @NSManaged var visitOutcomeIndexID:Int64
    @NSManaged var visitOutcomeValue:String
    @NSManaged var customerSegment:String
    @NSManaged var customerType:String
    @NSManaged var visitOutcomeCloseByOtp:Bool
    @NSManaged var visitClose:Bool
    
    class func entityName()->String{
        return "VisitOutcomes"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "VisitOutcomes")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "CompanyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath: "CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "visitOutcomeIndexID", keyPath: "VisitOutcomeIndexID"))
       
        mapping.addAttribute(Mapping.boolAttributeFor(property: "visitOutcomeCloseByOtp", keyPath: "VisitOutcomeCloseByOtp"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "visitClose", keyPath: "VisitClose"))
        mapping.addAttributes(from: ["customerType":"customerType","visitOutcomeValue":"VisitOutcomeValue","customerSegment":"customerSegment"])
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func getAll()->[VisitOutcomes]{
        return VisitOutcomes.mr_findAllSorted(by: "iD", ascending: true) as? [VisitOutcomes] ?? [VisitOutcomes]()
//        [[VisitOutcomes MR_findAllSortedBy:@"iD" ascending:YES inContext:[NSManagedObjectContext MR_defaultContext]] mutableCopy];
    }
    
    class func getVisitOutComeAccordingTocustomer(custSegment:String,custType:String)->[VisitOutcomes]{
        var excludedOutcome = [VisitOutcomes]()
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
        
            return ((strCustType.contains(custType)) && (strCustSeg.contains(custSegment)) || (strCustType == "0" && strCustSeg == "999999") || ((arrOfType.count == 1 && (arrOfType.first == "" || arrOfType.first ?? "" == custType)) && (arrOfSeg.count == 1 && (arrOfSeg.first == "" || arrOfSeg.first ?? "" == custSegment))))
        })
        return excludedOutcome
    }
    class func outcomeshouldcloseVisit(id:Int64)->Bool{
        if let outcome = VisitOutcomes.mr_find(byAttribute: "iD", withValue: id)?.first as? VisitOutcomes{
            return outcome.visitClose
        }else{
            return false
        }
    }
    
    class func getVisitOutcome(visitOutcomeIndexID:Int64)->VisitOutcomes{
        return VisitOutcomes.mr_find(byAttribute: "visitOutcomeIndexID", withValue: visitOutcomeIndexID)?.first as? VisitOutcomes ?? VisitOutcomes()
    }
    
    class func getOutcomeFromOutcomeID(leadSourceID:NSNumber)->String{
        if let leadoutcome = VisitOutcomes.mr_findFirst(byAttribute: "visitOutcomeIndexID", withValue: leadSourceID){
            return leadoutcome.visitOutcomeValue
        }else{
            return ""
        }
    }
}
