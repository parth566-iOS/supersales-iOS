//
//  SalesPlanModel.swift
//  SuperSales
//
//  Created by Apple on 16/07/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class SalesPlanModel: NSObject {
    var moduleID:NSNumber!
    var lowerUsersBeat:NSNumber!
    var nextActionID:NSNumber!
    var checkOutLangitude:NSNumber!
    var checkOutLatitude:NSNumber!
    var isActive:NSNumber!
    var balanceValue:NSNumber!
    var checkInCustomerName:String!
    var userID:NSNumber!
    var checkInLatitude:NSNumber!
    var kms:NSNumber!
    var nextActionTime:String!
    var isManual:Bool! //IsManual
    var modeOfPayment:NSNumber!
    //var assigneeID:NSNumber!
    var referenceNo:String!
    var checkInLongitude:NSNumber!
    var customerID:NSNumber!
    var territoryID:NSNumber!
    var visitID:NSNumber!
    var isCheckedIn:Bool!
    var collectionValue:NSNumber!
    var companyID:NSNumber!
    var statusID:NSNumber!
    var modulePrimaryID:NSNumber!
    var isPictureAvailable:Bool!
    var isStockAvailable:Bool!
    var isFeedBackAvailable:Bool!
    var isTertiaryAvailable:Bool!
    var assigneeID:NSNumber! //AssigneeID
   
    var contactID:NSNumber!
    var addressID:NSNumber!
    var detailType:NSNumber!
    var customerMobileNumber:String?
    var checkInTime:String?
    var checkOutTime:String?
    var chekInAddress:String?
    var beatPlanName:String?
    var beatPlanID:String?
    var transactionID:String?
    var modelDescription:String?
    
    func initWithdic(dict:[String:Any])->SalesPlanModel{
        self.customerMobileNumber = Common.returndefaultstring(dic: dict, keyvalue: "customerMobileNumber")
        self.detailType = Common.returndefaultnsnumber(dic: dict, keyvalue: "detailType")
        self.lowerUsersBeat = Common.returndefaultnsnumber(dic: dict, keyvalue: "lowerUsersBeat")
        self.addressID = Common.returndefaultnsnumber(dic: dict, keyvalue: "addressID")
        self.contactID = Common.returndefaultnsnumber(dic: dict, keyvalue: "contactID")
        self.isTertiaryAvailable = Common.returndefaultbool(dic: dict, keyvalue: "isTertiaryAvailable")
         self.isFeedBackAvailable = Common.returndefaultbool(dic: dict, keyvalue: "isFeedBackAvailable")
        self.assigneeID = Common.returndefaultnsnumber(dic: dict, keyvalue: "AssigneeID")
        
         self.isStockAvailable = Common.returndefaultbool(dic: dict, keyvalue: "isStockAvailable")
        self.isPictureAvailable = Common.returndefaultbool(dic: dict, keyvalue: "isPictureAvailable")
         self.modulePrimaryID = Common.returndefaultnsnumber(dic: dict, keyvalue: "modulePrimaryID")
        self.statusID = Common.returndefaultnsnumber(dic: dict, keyvalue: "statusID")
        self.companyID = Common.returndefaultnsnumber(dic: dict, keyvalue: "companyID")
        self.collectionValue = Common.returndefaultnsnumber(dic: dict, keyvalue: "collectionValue")
        self.isCheckedIn = Common.returndefaultbool(dic: dict, keyvalue: "isCheckedIn")
        self.visitID = Common.returndefaultnsnumber(dic: dict, keyvalue: "visitID")
        self.territoryID = Common.returndefaultnsnumber(dic: dict, keyvalue: "territoryId")
        self.customerID = Common.returndefaultnsnumber(dic: dict, keyvalue: "customerID")
        self.checkInLongitude = Common.returndefaultnsnumber(dic: dict, keyvalue: "checkInLongitude")
        self.modelDescription = Common.returndefaultstring(dic: dict, keyvalue: "description")
        self.referenceNo = Common.returndefaultstring(dic: dict, keyvalue: "referenceNo")
        self.modeOfPayment = Common.returndefaultnsnumber(dic: dict, keyvalue: "modeOfPayment")
        self.isManual = Common.returndefaultbool(dic: dict, keyvalue: "IsManual")
        self.nextActionTime = Common.returndefaultstring(dic: dict, keyvalue: "nextActionTime")
        self.kms = Common.returndefaultnsnumber(dic: dict, keyvalue: "kms")
        self.checkInLatitude = Common.returndefaultnsnumber(dic: dict, keyvalue: "checkInLatitude")
        self.userID = Common.returndefaultnsnumber(dic: dict, keyvalue: "userID")
         self.checkInCustomerName = Common.returndefaultstring(dic: dict, keyvalue: "checkInCustomerName")
        self.balanceValue = Common.returndefaultnsnumber(dic: dict, keyvalue: "balanceValue")
         self.isActive = Common.returndefaultnsnumber(dic: dict, keyvalue: "isActive")
         self.checkOutLatitude = Common.returndefaultnsnumber(dic: dict, keyvalue: "checkOutLatitude")
        self.checkOutLangitude = Common.returndefaultnsnumber(dic: dict, keyvalue: "checkOutLangitude")
         self.nextActionID = Common.returndefaultnsnumber(dic: dict, keyvalue: "nextActionID")
      self.lowerUsersBeat = Common.returndefaultnsnumber(dic: dict, keyvalue: "lowerUsersBeat")
        self.moduleID = Common.returndefaultnsnumber(dic: dict, keyvalue: "moduleID")
        self.checkInTime = Common.returndefaultstring(dic: dict, keyvalue: "checkInTime")
        self.checkOutTime = Common.returndefaultstring(dic: dict, keyvalue: "checkOutTime")
        self.chekInAddress = Common.returndefaultstring(dic: dict, keyvalue: "chekInAddress")
        self.beatPlanName = Common.returndefaultstring(dic: dict, keyvalue: "BeatPlanName")
        self.beatPlanID = Common.returndefaultstring(dic: dict, keyvalue: "BeatPlanID")
        self.transactionID = Common.returndefaultstring(dic: dict, keyvalue: "TransactionID")
    return self
    }
}
