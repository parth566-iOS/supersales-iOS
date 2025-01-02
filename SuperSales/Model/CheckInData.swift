//
//  CheckInData.swift
//  SuperSales
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class CheckInData: NSObject {
    var iD:Int?
    var visitDate:String?
    var visitID:Int?
    var companyID:Int?
    var checkInTime:String?
    var checkOutTime:String?
    var lattitude:String?
    var longitude:String?
    var checkInCheckOutStatusID:Int?
    var createdBy:Int?
    var createdTime:String?
    var approvedBy:Int?
    var approvedTo:Int?
    var lastModifiedBy:Int?
    var customerId:Int?
    var addressMasterID:Int?
    var statusID:Int?
    var km:NSNumber?
    
    
    func initwithdic(dict:[String:Any]) -> CheckInData {
        self.iD = Common.returndefaultInteger(dic: dict, keyvalue: "ID")
        self.visitID = Common.returndefaultInteger(dic: dict, keyvalue: "VisitID")
        self.visitDate =   Common.returndefaultstring(dic: dict, keyvalue: "VisitDate")
        self.companyID =  Common.returndefaultInteger(dic: dict, keyvalue: "CompanyID")
        self.checkInTime =  Common.returndefaultstring(dic: dict, keyvalue: "CheckInTime")
        self.checkOutTime =  Common.returndefaultstring(dic: dict, keyvalue: "CheckOutTime")
        self.lattitude =  Common.returndefaultstring(dic: dict, keyvalue: "Lattitude")
        self.longitude = Common.returndefaultstring(dic: dict, keyvalue: "Longitude")
        self.checkInCheckOutStatusID = Common.returndefaultInteger(dic: dict, keyvalue: "CheckInCheckOutStatusID")
        self.createdBy = Common.returndefaultInteger(dic: dict, keyvalue: "CreatedBy")
        self.createdTime = Common.returndefaultstring(dic: dict, keyvalue: "CreatedTime")
        self.approvedBy =  Common.returndefaultInteger(dic: dict, keyvalue: "ApprovedBy")
        self.approvedTo =  Common.returndefaultInteger(dic: dict, keyvalue: "ApprovedTo")
        self.lastModifiedBy =  Common.returndefaultInteger(dic: dict, keyvalue: "LastModifiedBy")
        self.customerId =  Common.returndefaultInteger(dic: dict, keyvalue: "CustomerID")
        self.addressMasterID =  Common.returndefaultInteger(dic: dict, keyvalue: "AddressMasterID")
        self.statusID =  Common.returndefaultInteger(dic: dict, keyvalue: "StatusID")
        self.km =  Common.returndefaultnsnumber(dic: dict, keyvalue: "KM")
        
        return self
    }
}
