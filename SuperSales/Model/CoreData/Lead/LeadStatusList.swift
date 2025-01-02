//
//  LeadStatusList.swift
//  SuperSales
//
//  Created by Apple on 09/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(LeadStatusList)
class LeadStatusList: NSManagedObject {
    
    @NSManaged var iD : Int64
    @NSManaged var leadID : Int64
    @NSManaged var createdBy : Int64
    @NSManaged var interactionTypeID : Int64
    @NSManaged var interactionWith : Int64
    @NSManaged var outcomeID : Int64
    @NSManaged var leadTypeID : Int64
    @NSManaged var customerOrientationID : Int64
    @NSManaged var nextActionID : Int64
    @NSManaged var proposalSubmitted : Int64
    @NSManaged var productList : NSOrderedSet
    @NSManaged var isLeadQualified : Int64
    @NSManaged var isTrialDone : Int64
    @NSManaged var isNegotiationDone : Int64
    @NSManaged var reminder : Int64
    @NSManaged var orderLostReasonID : Int64
    @NSManaged var leadForceCheckOut : Int64
    @NSManaged var imageLattitude : String
    @NSManaged var imageLongitude : String
    @NSManaged var interactionTime : String
    @NSManaged var orderExpectedDate : String
    @NSManaged var nextActionTime : String
    @NSManaged var reminderTime : String
    @NSManaged var orderLostTo : String
    @NSManaged var createdTime : String
    @NSManaged var remarks : String
    @NSManaged var imagePath : String
    @NSManaged var imagePath2 : String
    @NSManaged var imagePath3 : String
    @NSManaged var imagePath4 : String
    @NSManaged var imagePath5 : String
    @NSManaged var leadAttachementPath:String
    @NSManaged var imageTimeStamp : String
    @NSManaged var statusFrom : String
    @NSManaged var preCustomerOrientationID:Int64
    @NSManaged var preIsLeadQualified:Int64
    @NSManaged var preInteractionWith:Int64
    @NSManaged var preIsNegotiationDone:Int64
    @NSManaged var preIsTrialDone:Int64
    @NSManaged var preLeadStage5:Int64
    @NSManaged var preLeadStage6:Int64
    @NSManaged var preLeadTypeID:Int64
    @NSManaged var preNextActionID:Int64
    @NSManaged var preNextActionTime:String
    @NSManaged var preOrderExpectedDate:String
    @NSManaged var preProposalSubmitted:Int64
    @NSManaged var preReminder:Int64
    @NSManaged var preRemarks:String
    @NSManaged var leadstage5:Int64
    @NSManaged var leadstage6:Int64
    @NSManaged var leadPreviousProductsList:NSOrderedSet
 //   @NSManaged var productList:NSOrderedSet
  
   
//
//    PreCustomerOrientationID = 1;
//      PreInteractionWith = 0;
//      PreIsLeadQualified = 0;
//      PreIsNegotiationDone = 0;
//      PreIsTrialDone = 0;
//      PreLeadStage5 = 0;
//      PreLeadStage6 = 0;
//      PreLeadTypeID = 2;
//      PreNextActionID = 1;
//      PreNextActionTime = "2022/04/22 13:52:00";
//      PreOrderExpectedDate = "2022/04/28 04:30:00";
//      PreProposalSubmitted = 0;
//      PreReminder = 0;
//      ProposalSubmitted = 0;
    
    
    class func entityName()->String{
        return "LeadStatusList"
    }
    
    class func defaultmapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "LeadStatusList")
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "preCustomerOrientationID", keyPath:"PreCustomerOrientationID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "preInteractionWith", keyPath:"PreInteractionWith"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "preIsLeadQualified", keyPath:"PreIsLeadQualified"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "preIsNegotiationDone", keyPath:"PreIsNegotiationDone"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "preIsTrialDone", keyPath:"PreIsTrialDone"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "preLeadStage5", keyPath:"PreLeadStage5"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "preLeadStage6", keyPath:"PreLeadStage6"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "preLeadTypeID", keyPath:"PreLeadTypeID"))
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "preNextActionID", keyPath:"PreNextActionID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "preProposalSubmitted", keyPath:"PreProposalSubmitted"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "preReminder", keyPath:"PreReminder"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadstage6", keyPath:"LeadStage6"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadstage5", keyPath:"LeadStage5"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "proposalSubmitted", keyPath:"ProposalSubmitted"))
        
        
        
        mapping.addAttribute(Mapping.intAttributeFor(property: "iD", keyPath:"ID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadID", keyPath:"LeadID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "createdBy", keyPath:"CreatedBy"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "interactionTypeID", keyPath:"InteractionTypeID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "interactionWith", keyPath:"InteractionWith"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "outcomeID", keyPath:"OutcomeID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadTypeID", keyPath:"LeadTypeID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "customerOrientationID", keyPath:"CustomerOrientationID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "nextActionID", keyPath:"NextActionID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "proposalSubmitted", keyPath:"ProposalSubmitted"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isLeadQualified", keyPath:"IsLeadQualified"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isTrialDone", keyPath:"IsTrialDone"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "isNegotiationDone", keyPath:"IsNegotiationDone"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "reminder", keyPath:"Reminder"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "orderLostReasonID", keyPath:"OrderLostReasonID"))
        mapping.addAttribute(Mapping.intAttributeFor(property: "leadForceCheckOut", keyPath:"LeadForceCheckOut"))
//        mapping.addAttribute(Mapping.doubleAttributeFor(property: "imageLattitude", keyPath: "ImageLattitude"))
//        mapping.addAttribute(Mapping.doubleAttributeFor(property: "imageLongitude", keyPath: "ImageLongitude"))
        mapping.addToManyRelationshipMapping(ProductsList.defaultmapping(), forProperty: "productList", keyPath: "StatusProductsList")
        mapping.addToManyRelationshipMapping(ProductsList.defaultmapping(), forProperty: "leadPreviousProductsList", keyPath: "leadPreviousProductsList")
        mapping.addAttributes(from: ["interactionTime": "Int64eractionTime","orderExpectedDate":"OrderExpectedDate","nextActionTime":"NextActionTime","reminderTime":"ReminderTime","orderLostTo":"OrderLostTo","createdTime":"CreatedTime","remarks":"Remarks","imagePath":"ImagePath","imagePath2":"ImagePath2","imagePath3":"ImagePath3","imagePath4":"ImagePath4","imagePath5":"ImagePath5","imageTimeStamp":"ImageTimeStamp","statusFrom":"StatusFrom","imageLattitude":"ImageLattitude","imageLongitude":"ImageLongitude","preOrderExpectedDate":"PreOrderExpectedDate","preNextActionTime":"PreNextActionTime","preRemarks":"PreRemarks","leadAttachementPath":"leadAttachementPath"])
        mapping.primaryKey = "iD"
        return mapping
    }
    
    class func getAll()->[LeadStatusList]{
        return LeadStatusList.mr_findAllSorted(by: "iD", ascending: true) as? [LeadStatusList] ?? [LeadStatusList()]
    }
    
    class func getLeadStatusById(leadId:NSNumber)->LeadStatusList{
        return (LeadStatusList.mr_find(byAttribute: "leadID", withValue: leadId, andOrderBy: "iD", ascending: false) as? [LeadStatusList])?.first ?? LeadStatusList()
        
    }
}
