//
//  UnplannedVisit.swift
//  SuperSales
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class UnplannedVisit: NSObject {

    var localID:Int?
    var sereiesPrefix:String?
    var seriesPostfix:NSNumber?
    var customerID:NSNumber?
    var tempCustomerID:NSNumber?
    var contactID:NSNumber?
    var nextActionID:NSNumber?
    var NextActionTime:String?
    var visitTypeID:NSNumber?
    var visitStatusID:NSNumber?
    var addressMasterID:NSNumber?
    var originalAssignee:NSNumber?
    var assignedTime:String?
    var reAssigned:NSNumber?
    var assignedBy:NSNumber?
    var companyID:NSNumber?
    var createdBy:NSNumber?
    var createdTime:String?
    var lastModifiedBy:NSNumber?
    var lastModifiedTime:String?
    var isActive:NSNumber!
    var productList:[SelectedProduct]!//[VisitProduct]!
    var conclusion:String!
    var tempCustomerObj:TempCustomer?
    var visitStatusList:[VisitStatusList]!
    var checkInList:[CheckInData]!
    var originalNextActionID:NSNumber!
    var originalNextActionTime:String!
    var CustomerDetails:CustomerVendorResult!
    var customerName:String!
    var contactName:String!
    var checkinTime:String!
    var checkoutTime:String!
    var leadID:NSNumber!
    var visitManualCheckIn:NSNumber!
    var visitManualCheckOut:NSNumber!
    var mannualCheckInStatusID:NSNumber!
    var mannualCheckOutStatusID:NSNumber!
    var createdByName:String!
    var products:String!
    var customerLocalID:NSInteger! = 0
    var checkInType:NSInteger! = 0
    var checkInAttendanceType:NSInteger! = 0
    var checkOutAttendanceType:NSInteger!
    var latitude:Double!
    var longitude:Double!
    var checkInAddress:String!
    var checkOutAddress:String!
    var checkInApproved:Bool!//
    var checkOutApproved:Bool!
    var distance:String!
    var addressLocalID:NSInteger!
    var minutes:String!
    var outcome:String! = ""
    var isFromMovement:Bool!
    var checkInLeadList:[CheckInData]!
    var textType:String! = ""
    var isManual:Bool!
    var productCategoryName:String! = ""
    var reassigneeName:String! = ""
    var contactMobileNo:String! = ""
    var isPictureAvailable:Int! = 0
    
    func initwithdic(dict:[String:Any])->UnplannedVisit{
        self.localID = Common.returndefaultInteger(dic: dict, keyvalue: "ID")
        self.sereiesPrefix = Common.returndefaultstring(dic: dict, keyvalue: "SeriesPrefix")
        self.seriesPostfix = Common.returndefaultnsnumber(dic: dict , keyvalue: "SeriesPostfix")
        self.customerID = Common.returndefaultnsnumber(dic: dict, keyvalue: "CustomerID")
        self.tempCustomerID = Common.returndefaultnsnumber(dic: dict, keyvalue: "TempCustomerID")
        self.contactID = Common.returndefaultnsnumber(dic: dict, keyvalue: "ContactID")
        self.customerName =  Common.returndefaultstring(dic: dict, keyvalue: "CustomerName")
        self.checkinTime =  Common.returndefaultstring(dic: dict, keyvalue: "CheckInTime")
        self.checkoutTime =  Common.returndefaultstring(dic: dict, keyvalue: "CheckOutTime")
        self.conclusion = Common.returndefaultstring(dic: dict, keyvalue: "Conclusion")
        self.productCategoryName = Common.returndefaultstring(dic: dict, keyvalue: "ProductCategoryName")
        self.nextActionID = Common.returndefaultnsnumber(dic: dict, keyvalue: "NextActionID")
        self.NextActionTime = Common.returndefaultstring(dic: dict, keyvalue: "NextActionTime")
        self.visitTypeID = Common.returndefaultnsnumber(dic: dict, keyvalue: "VisitTypeID")
        self.visitStatusID = Common.returndefaultnsnumber(dic: dict, keyvalue: "VisitStatusID")
        self.addressMasterID = Common.returndefaultnsnumber(dic: dict, keyvalue: "addressMasterID")
        self.originalAssignee = Common.returndefaultnsnumber(dic: dict, keyvalue: "OriginalAssignee")
        self.assignedTime =  Common.returndefaultstring(dic: dict, keyvalue: "AssignedTime")
        self.reassigneeName =  Common.returndefaultstring(dic: dict, keyvalue: "RessigneeName")
        self.reAssigned =  Common.returndefaultnsnumber(dic: dict, keyvalue: "ReAssigned")
        self.assignedBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "AssignedBy")
        self.companyID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "CompanyID")
        self.createdBy =  Common.returndefaultnsnumber(dic: dict, keyvalue: "CreatedBy")
        self.createdTime = Common.returndefaultstring(dic: dict, keyvalue: "CreatedTime")
        self.lastModifiedBy =  Common.returndefaultnsnumber(dic: dict, keyvalue: "LastModifiedBy")
        self.lastModifiedTime = Common.returndefaultstring(dic: dict, keyvalue: "LastModifiedTime")
        self.isActive =  Common.returndefaultnsnumber(dic: dict, keyvalue: "IsActive")
        self.createdByName =  Common.returndefaultstring(dic: dict, keyvalue: "CreatedByName")
        self.contactName =  Common.returndefaultstring(dic: dict, keyvalue: "ContactName")
        self.contactMobileNo =  Common.returndefaultstring(dic: dict, keyvalue: "ContactMobileNo")
        self.isPictureAvailable =  Common.returndefaultInteger(dic: dict, keyvalue: "isPictureAvailable")
        var arrProduct = [SelectedProduct]()
        let arrOfProduct =  dict["ProductsList"] as? [[String:Any]] ?? [[String:Any]]()
        if(arrOfProduct.count > 0){
            
//        for [String:Any] in arrOfProduct{
//            let product = VisitProduct().initwithdic(dict: [key:value])
//            arrProduct.append(product)
//        }
            for dic in arrOfProduct{
                let product = SelectedProduct().initwithdic(dict: dic)//VisitProduct().initwithdic(dict: dic)
                arrProduct.append(product)
            }
        }
        self.productList = arrProduct
        
        var arrStatusList = [VisitStatusList]()
        let arrOfStatusList =  dict["VisitStatusList"] as? [[String:Any]] ?? [[String:Any]]()
        if(arrOfStatusList.count > 0){
            for status in arrOfStatusList{
                let vstatus = VisitStatusList().initwithDic(dict:status)
                arrStatusList.append(vstatus)
            }
//        for (key, value) in arrOfStatusList{
//            let status = VisitStatusList().initwithDic(dict: [key:value])
//            arrStatusList.append(status)
//        }
        }
        self.visitStatusList = arrStatusList
        
        let arrOfCheckinList =  dict["VisitCheckInCheckOutList"] as? [[String:Any]] ?? [[String:Any]]()
        var arrCheckinList = [CheckInData]()
        if(arrOfCheckinList.count > 0){
        
//        for (key, value) in arrOfCheckinList{
//            let status = CheckInData().initwithdic(dict: [key:value])
//            arrCheckinList.append(status)
//        }
            for dic in arrOfCheckinList{
                let status = CheckInData().initwithdic(dict: dic)
                         arrCheckinList.append(status)
            }
        }
        self.checkInList = arrCheckinList
        
        
        self.CustomerDetails = CustomerVendorResult().initwithdic(dict:dict["CustomerDetails"] as? [String : Any] ?? [String:Any]())
        self.tempCustomerObj =  TempCustomer().initwithdic(dict: dict["tempCustomerObj"] as? [String : Any] ?? [String:Any]())
        
        self.originalNextActionTime =  Common.returndefaultstring(dic: dict, keyvalue: "OriginalNextActionTime")
        
        return self
    }
    
}
