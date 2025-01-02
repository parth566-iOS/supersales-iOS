//
//  VisitStatusList.swift
//  SuperSales
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class VisitStatusList: NSObject {
    
    var loclID:Int?
    var iD:Int?
    var interactionID:Int?
    var InteractionWith:Int?
    var closevisitFlag:Int?
    var InteractionTime:String?
    var interactionwithName:String?
    var nextActionTime:String?
    var conclusion:String?
    var visitOutcomeID:Int?
    var visitOutcome2ID:Int?
    var visitOutcome3ID:Int?
    var visitOutcome4ID:Int?
    var visitOutcome5ID:Int?
    var visitTypeID:Int?
    var nextActionID:Int?
    var createdBy:Int?
    var createdTime:String?
    var CreatedByName:String?
    var updatedBy:Int?
    var expectedDate:String?
    var orderValue:NSNumber?
    
    func initwithDic(dict:[String:Any])->VisitStatusList{
        self.loclID = Common.returndefaultInteger(dic: dict, keyvalue: "ID")
        self.iD = Common.returndefaultInteger(dic: dict, keyvalue: "ID")
        self.updatedBy = Common.returndefaultInteger(dic: dict, keyvalue: "updatedBy")
        self.closevisitFlag =  Common.returndefaultInteger(dic: dict, keyvalue: "CloseVisitFlag")
        self.interactionID = Common.returndefaultInteger(dic: dict, keyvalue: "InteractionTypeID")
        self.InteractionWith = Common.returndefaultInteger(dic: dict, keyvalue: "InteractionWith")
        self.interactionwithName = Common.returndefaultstring(dic: dict , keyvalue: "InteractionWithName")
        self.InteractionTime = Common.returndefaultstring(dic: dict , keyvalue: "InteractionTime")
        self.visitOutcomeID = Common.returndefaultInteger(dic: dict , keyvalue: "VisitOutcomeID")
        self.visitOutcome2ID = Common.returndefaultInteger(dic: dict , keyvalue: "VisitOutcome2ID")
        self.visitOutcome3ID = Common.returndefaultInteger(dic: dict , keyvalue: "VisitOutcome3ID")
        self.visitOutcome4ID = Common.returndefaultInteger(dic: dict , keyvalue: "VisitOutcome4ID")
        self.visitOutcome5ID = Common.returndefaultInteger(dic: dict , keyvalue: "VisitOutcome5ID")
        self.visitTypeID = Common.returndefaultInteger(dic: dict , keyvalue: "VisitTypeID")
        self.nextActionID = Common.returndefaultInteger(dic: dict , keyvalue: "NextActionID")
        self.createdBy = Common.returndefaultInteger(dic: dict , keyvalue: "CreatedBy")
        self.nextActionTime = Common.returndefaultstring(dic: dict , keyvalue: "NextActionTime")
        self.conclusion = Common.returndefaultstring(dic: dict , keyvalue: "Conclusion")
        self.createdTime = Common.returndefaultstring(dic: dict , keyvalue: "CreatedTime")
        self.CreatedByName = Common.returndefaultstring(dic: dict , keyvalue: "CreatedByName")
        self.expectedDate = Common.returndefaultstring(dic: dict , keyvalue: "ExpectedDate")
        self.orderValue = Common.returndefaultnsnumber(dic: dict, keyvalue: "OrderValue")
        return self
    }
    
    

}
