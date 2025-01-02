//
//  NotificationData.swift
//  SuperSales
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class NotificationData: NSObject {
    
    var companyID:Int!
    var iD:NSNumber!
    var assignBy:NSNumber!
    var assignTo:NSNumber!
    var attendanceID:NSNumber!
    var addressID:NSNumber!
    var message:String!
    var seriesPostFix:NSNumber!
    var seriesPrefix:String!
    var statusID:Int!
    var checkInCheckOutStatusID:Int!
    var checkInID:NSNumber!
    var manualCheckInStatusID:Int!
    var transactionID:String!
    var updateList:String!
    var firstName:String!
    var lastName:String!
    var picture:String!
    var oldMobileNo:String!
    var newmobileNo:String!
    var userLattitude:NSNumber!
    var userLongitude:NSNumber!
    var customerLattitude:NSNumber!
    var customerLongitude:NSNumber!
    var approvedTo:NSNumber!
    var memberID:NSNumber!
    var totalVisit:NSNumber!
    var vID:NSNumber!
    var validVisit:NSNumber!
    var date:String!
    var presence:String!
    
    func initwithdic(dict:[String:Any])->NotificationData{
        self.companyID =  Common.returndefaultInteger(dic: dict, keyvalue: "CompanyID")
        self.iD =  Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
         self.assignBy =  Common.returndefaultnsnumber(dic: dict, keyvalue: "AssignBy")
         self.assignTo =  Common.returndefaultnsnumber(dic: dict, keyvalue: "AssignTo")
        self.addressID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "AddressID")
        self.approvedTo =  Common.returndefaultnsnumber(dic: dict, keyvalue: "ApprovedTo")
        self.attendanceID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "AttendanceID")
        self.message = Common.returndefaultstring(dic: dict, keyvalue: "message")
        self.seriesPrefix = Common.returndefaultstring(dic: dict, keyvalue: "SeriesPrefix")
        self.statusID =  Common.returndefaultInteger(dic: dict, keyvalue: "StatusID")
        self.checkInCheckOutStatusID = Common.returndefaultInteger(dic: dict, keyvalue: "CheckInCheckOutStatusID")
        self.checkInID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "CheckInID")
        self.manualCheckInStatusID = Common.returndefaultInteger(dic: dict, keyvalue: "ManualCheckInStatusID")
        self.transactionID = Common.returndefaultstring(dic: dict, keyvalue: "TransactionID")
        self.updateList = Common.returndefaultstring(dic: dict, keyvalue: "UpdateList")
          self.firstName = Common.returndefaultstring(dic: dict, keyvalue: "FirstName")
          self.lastName = Common.returndefaultstring(dic: dict, keyvalue: "LastName")
           self.picture = Common.returndefaultstring(dic: dict, keyvalue: "Picture")
        self.date = Common.returndefaultstring(dic: dict, keyvalue: "Date")
        self.presence = Common.returndefaultstring(dic: dict, keyvalue: "Presence")
        
        self.oldMobileNo = Common.returndefaultstring(dic: dict, keyvalue: "OldMobileNo")
        self.newmobileNo = Common.returndefaultstring(dic: dict, keyvalue: "NewMobileNo")
        self.userLattitude =  Common.returndefaultnsnumber(dic: dict, keyvalue: "UserLattitude")
         self.userLongitude =  Common.returndefaultnsnumber(dic: dict, keyvalue: "UserLongitude")
         self.customerLattitude =  Common.returndefaultnsnumber(dic: dict, keyvalue: "CustomerLattitude")
        self.userLattitude =  Common.returndefaultnsnumber(dic: dict, keyvalue: "UserLattitude")
         self.userLongitude =  Common.returndefaultnsnumber(dic: dict, keyvalue: "UserLongitude")
         self.totalVisit =  Common.returndefaultnsnumber(dic: dict, keyvalue: "totalVisit")
         self.vID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "vID")
        self.validVisit =  Common.returndefaultnsnumber(dic: dict, keyvalue: "validVisit")
        self.memberID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "MemberID")
        //memberID
        return self
    }
}
