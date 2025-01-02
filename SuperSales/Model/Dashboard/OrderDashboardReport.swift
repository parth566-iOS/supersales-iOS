//
//  OrderDashboardReport.swift
//  SuperSales
//
//  Created by Apple on 05/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class OrderDashboardReport: NSObject {
        
        var  GeneratedSalesOrder:NSInteger?
        var  CreatedBy:NSInteger?
        var  ForDate:String?
        var  UserName:String?
        var  CompanyID:NSInteger?
        var  UserID:NSInteger?
        var  TotalAmount:Double?
        var  lowerHierarchyUsers:String?
        var  managerID:NSInteger?
        var  RoleID:NSInteger?
        var  ColorCode:NSInteger?
    var DottedManagerID:NSInteger?
    
        func initwithdict(dic:[String:Any])->OrderDashboardReport{
             self.GeneratedSalesOrder =  Common.returndefaultInteger(dic: dic, keyvalue: "GeneratedSalesOrder")
            self.CreatedBy =  Common.returndefaultInteger(dic: dic, keyvalue: "CreatedBy")
            self.ForDate =  Common.returndefaultstring(dic: dic, keyvalue: "ForDate")
            self.UserName = Common.returndefaultstring(dic: dic, keyvalue: "UserName")
            self.CompanyID =  Common.returndefaultInteger(dic: dic, keyvalue: "CompanyID")
             self.UserID =  Common.returndefaultInteger(dic: dic, keyvalue: "UserID")
             self.TotalAmount =  Common.returndefaultdouble(dic: dic, keyvalue: "TotalAmount")
             self.UserID =  Common.returndefaultInteger(dic: dic, keyvalue: "UserID")
             self.lowerHierarchyUsers = Common.returndefaultstring(dic: dic, keyvalue: "lowerHierarchyUsers")
            self.RoleID =  Common.returndefaultInteger(dic: dic, keyvalue: "RoleID")
            self.managerID =  Common.returndefaultInteger(dic: dic, keyvalue: "managerID")
            self.ColorCode =  Common.returndefaultInteger(dic: dic, keyvalue: "ColorCode")
            self.DottedManagerID = Common.returndefaultInteger(dic: dic, keyvalue: "dottedManagerID")
            return self
        }
}
