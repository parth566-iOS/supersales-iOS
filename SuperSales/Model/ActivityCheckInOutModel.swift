//
//  ActivityCheckInCheckOutList.swift
//  SuperSales
//
//  Created by Apple on 18/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class ActivityCheckInOutModel: NSObject {

    var activityDate:String!
    var activityID:NSInteger!
    var checkInTime:String!
    var checkOutTime:String!
    var companyID:NSInteger!
    var createdBy:NSInteger!
    var createdByName:String!
    var createdTime:String!
    var id:NSInteger!
    var lastModifiedBy:NSInteger!
    var lattitude:String!
    var longitude:String!
    
    func initwithdic(dict:[String:Any])->ActivityCheckInOutModel{
        self.activityDate =  Common.returndefaultstring(dic: dict, keyvalue: "ActivityDate")
        self.activityID =  Common.returndefaultNSInteger(dic: dict, keyvalue: "ActivityID")
        self.checkInTime = Common.returndefaultstring(dic: dict, keyvalue: "CheckInTime")
        self.checkOutTime = Common.returndefaultstring(dic: dict, keyvalue: "CheckOutTime")
        self.companyID = Common.returndefaultNSInteger(dic: dict, keyvalue: "CompanyID")
        self.createdBy = Common.returndefaultNSInteger(dic: dict, keyvalue: "CreatedBy")
        self.createdByName = Common.returndefaultstring(dic: dict, keyvalue: "CreatedByName")
        self.createdTime = Common.returndefaultstring(dic: dict, keyvalue: "CreatedTime")
        self.id = Common.returndefaultNSInteger(dic: dict, keyvalue: "ID")
        self.lastModifiedBy = Common.returndefaultNSInteger(dic: dict, keyvalue: "LastModifiedBy")
        self.lattitude = Common.returndefaultstring(dic: dict, keyvalue: "Lattitude")
        self.longitude = Common.returndefaultstring(dic: dict, keyvalue: "Longitude")
        return self
    }
}
