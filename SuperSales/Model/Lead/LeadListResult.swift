//
//  LeadListResult.swift
//  SuperSales
//
//  Created by Apple on 09/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class LeadListResult: NSObject {
    var ID:Int!
    var CustomerID:Int!
    var KeyCustomer:Bool!
    var ContactID:Int!
    var LeadSourceID:Int!
    var LeadTypeID:Int!
    var OrderExpectedDate:String!
    var Response:String!
    var CustomerOrientationID:Int!
    var AskedForProposal:Int!
    var NextActionID:Int!
    var NextActionTime:String!
    var Reminder:Int!
    var ReminderTime:String!
    var Remarks:String!
    var ProposalSubmitted:Int!
    var IsLeadQualified:Int!
    var IsTrialDone:Int!
    var IsNegotiationDone:Int!
    var AddressMasterID:Int!
    var OriginalNextActionID:Int!
    
    
    var OriginalNextActionTime:String!
    
    var OriginalAssignee:Int!
    
    var CustomerName:String!
    var OriginalAssigneeName:String!
    var ReAssigned:Int!
    var AssignedBy:Int!
    var CompanyID:Int!
    var CreatedBy:Int!
    var LastModifiedBy:Int!
    var IsActive:Int!
    var aProductsList:[SalesPlanProductsList]!
    var CreatedTime:String!
    var aLeadStatusList:[LeadStatus]!
    var SeriesPrefix:String!
    var SeriesPostfix:Int!
    var LeadStatusID:Int!
    var ContactMobileNo:String!
    var ContactName:String!
    
    func initWithdic(dict:[String:Any])->LeadListResult{
self.ID = Common.returndefaultInteger(dic: dict, keyvalue: "ID")
self.CustomerID = Common.returndefaultInteger(dic: dict, keyvalue: "CustomerID")
self.KeyCustomer = Common.returndefaultbool(dic: dict, keyvalue: "KeyCustomer")
self.ContactID =  Common.returndefaultInteger(dic: dict, keyvalue: "ContactID")
self.LeadSourceID = Common.returndefaultInteger(dic: dict, keyvalue: "LeadSourceID")
self.LeadTypeID =  Common.returndefaultInteger(dic: dict, keyvalue: "LeadTypeID")
self.OrderExpectedDate = Common.returndefaultstring(dic: dict, keyvalue: "OrderExpectedDate")
self.CustomerOrientationID = Common.returndefaultInteger(dic: dict, keyvalue: "CustomerOrientationID")
self.AskedForProposal = Common.returndefaultInteger(dic: dict, keyvalue: "AskedForProposal")
self.NextActionID = Common.returndefaultInteger(dic: dict, keyvalue: "NextActionID")
self.NextActionTime = Common.returndefaultstring(dic: dict, keyvalue: "NextActionTime")
self.Reminder = Common.returndefaultInteger(dic: dict, keyvalue: "Reminder")
self.ReminderTime = Common.returndefaultstring(dic: dict, keyvalue: "ReminderTime")
self.Remarks = Common.returndefaultstring(dic: dict, keyvalue: "Remarks")
self.ProposalSubmitted = Common.returndefaultInteger(dic: dict, keyvalue: "ProposalSubmitted")
self.IsLeadQualified = Common.returndefaultInteger(dic: dict, keyvalue: "IsLeadQualified")
self.IsTrialDone = Common.returndefaultInteger(dic: dict, keyvalue: "IsTrialDone")
self.IsNegotiationDone = Common.returndefaultInteger(dic: dict, keyvalue: "IsNegotiationDone")
self.LeadStatusID = Common.returndefaultInteger(dic: dict , keyvalue: "LeadStatusID")
self.AddressMasterID = Common.returndefaultInteger(dic: dict, keyvalue: "AddressMasterID")
self.OriginalAssignee = Common.returndefaultInteger(dic: dict, keyvalue: "OriginalAssignee")
self.OriginalAssigneeName = Common.returndefaultstring(dic: dict, keyvalue: "OriginalAssigneeName")
self.ReAssigned =  Common.returndefaultInteger(dic: dict, keyvalue: "ReAssigned")
self.AssignedBy = Common.returndefaultInteger(dic: dict, keyvalue: "AssignedBy")
self.CompanyID = Common.returndefaultInteger(dic: dict, keyvalue: "CompanyID")
self.CreatedBy =  Common.returndefaultInteger(dic: dict, keyvalue: "CreatedBy")
self.LastModifiedBy = Common.returndefaultInteger(dic: dict, keyvalue: "LastModifiedBy")
self.IsActive = Common.returndefaultInteger(dic: dict, keyvalue: "IsActive")
self.aProductsList = [SalesPlanProductsList]()
//        for dic in Common.return{
//
//        }
self.CreatedTime = Common.returndefaultstring(dic: dict, keyvalue: "CreatedTime")
//self.aLeadStatusList = [LeadStatus]()
self.SeriesPrefix = Common.returndefaultstring(dic: dict, keyvalue: "SeriesPrefix")
self.SeriesPostfix = Common.returndefaultInteger(dic: dict, keyvalue: "SeriesPostfix")
self.OriginalNextActionID = Common.returndefaultInteger(dic: dict, keyvalue: "OriginalNextActionID")
        
self.OriginalNextActionTime = Common.returndefaultstring(dic: dict, keyvalue: "OriginalNextActionTime")
        
self.CustomerName = Common.returndefaultstring(dic: dict, keyvalue: "CustomerName")
        
self.ContactMobileNo = Common.returndefaultstring(dic: dict, keyvalue: "ContactMobileNo")
        
self.ContactName = Common.returndefaultstring(dic: dict, keyvalue: "ContactName")
        
return self
    }
}
