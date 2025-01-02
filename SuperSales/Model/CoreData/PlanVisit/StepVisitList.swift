//
//  StepVisitList.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

@objc(StepVisitList)
class StepVisitList: NSManagedObject {
    

    @NSManaged var iD:Int32
    @NSManaged var companyID:Int32
    @NSManaged var menuID:Int32
    @NSManaged var menuIndex:Int32
    @NSManaged var menuOrder:Int16
    @NSManaged var mandatoryOrOptional:Bool
    @NSManaged var status:Bool
    @NSManaged var menuLocalText:String
    @NSManaged var customerType:String
    @NSManaged var customerSegment:String
    
    class func entityName()->String{
        return "StepVisitList"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "StepVisitList")
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath: "ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "companyID", keyPath: "companyID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "menuID", keyPath: "menuID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "menuIndex", keyPath: "menuIndex"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "menuOrder", keyPath: "menuOrder"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "mandatoryOrOptional", keyPath: "mandatoryOrOptional"))
        mapping.addAttribute(Mapping.boolAttributeFor(property: "status", keyPath: "status"))
        mapping.addAttributes(from: ["menuLocalText":"menuLocalText","customerSegment":"customerSegment","customerType":"customerType"])
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func getAll()->[StepVisitList]{
        return StepVisitList.mr_findAllSorted(by: "menuOrder", ascending: true) as? [StepVisitList] ?? [StepVisitList]()
    }
    
    class func getActiveVisitStep()->[StepVisitList]{

        var arrOfVisitStep = self.getAll()
        let activesetting = Utils().getActiveSetting()
        
        if(activesetting.storeCheckOwnBrand == 0 && activesetting.storeCheckCompetition == 0){
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 72
            }
            //arrAvoidablemenu.append(72)
        }
        if(activesetting.showShelfSpace == 0){
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 74
            }
        }
        if(activesetting.showProductDrive == 0){
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 73
            }
        }
        
        if(activesetting.customerProfileInUnplannedVisit == 0){
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 67
                
            }
        }
        if(activesetting.requireVisitCounterShare == 0){
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 66
                
            }
        }
        if(activesetting.requireVisitCollection == 0){
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 65
                
            }
        }
        if(activesetting.requirePromotionInSO == 0){
            arrOfVisitStep = arrOfVisitStep.filter{
                $0.menuID != 70
                
            }
        }
        
        //filter service visit as custom form is not developed yet
        arrOfVisitStep =  arrOfVisitStep.filter({ (step) -> Bool in
            step.menuIndex != 76
        })
//        if((visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory) && (self.activesetting.requireTempCustomerProfile == 1)){
//
//        }else{

      //  let arrOfVisitStep = self.getAll()
        return arrOfVisitStep
    }
//        let activesetting = Utils().getActiveSetting()
//       // var count  = 0
//        let group = DispatchGroup()
//        group.enter()
//        DispatchQueue.global(qos: .userInitiated).async {
//        if(activesetting.storeCheckOwnBrand == 0 && activesetting.storeCheckCompetition == 0){
//
//            arrOfVisitStep = arrOfVisitStep.filter{
//                $0.menuID != 72
//            }
//            //arrAvoidablemenu.append(72)
//        }
//
//        if(activesetting.showShelfSpace == 0){
//
//            arrOfVisitStep = arrOfVisitStep.filter{
//                $0.menuID != 74
//            }
//        }
//        if(activesetting.showProductDrive == 0){
//
//            arrOfVisitStep = arrOfVisitStep.filter{
//                $0.menuID != 73
//            }
//        }
//
//        if(activesetting.customerProfileInUnplannedVisit == 0){
//

//            arrOfVisitStep = arrOfVisitStep.filter{
//                $0.menuID != 67
//
//            }
//        }
//        if(activesetting.requireVisitCounterShare == 0){
//
//            arrOfVisitStep = arrOfVisitStep.filter{
//                $0.menuID != 66
//
//            }
//        }
//        if(activesetting.requireVisitCollection == 0){
//
//            arrOfVisitStep = arrOfVisitStep.filter{
//                $0.menuID != 65
//
//            }
//        }
//        if(activesetting.requirePromotionInSO == 0){
//
//            arrOfVisitStep = arrOfVisitStep.filter{
//                $0.menuID != 70
//
//            }
//        }
//        }
//
//        group.leave()
//
////        if((visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory) && (self.activesetting.requireTempCustomerProfile == 1)){
////
////        }else{
////            arrOfVisitStep = arrOfVisitStep.filter{
////                $0.menuID != 67
////            }
////        }
//       // semaphore.wait()
//        var filteredStepVisit = [StepVisitList]()
//        group.notify(queue: .main, execute: {
//            filteredStepVisit = arrOfVisitStep
//    })
//        return filteredStepVisit
//    }
}
