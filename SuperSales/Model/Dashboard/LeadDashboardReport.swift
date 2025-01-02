//
//  LeadDashboardReport.swift
//  SuperSales
//
//  Created by Apple on 05/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class LeadDashboardReport: NSObject {
    var AssignedLead:NSInteger?
    var  CreatedBy:NSInteger?
    var  ForDate:String?
    var  UserName:String?
    var  CompanyID:NSInteger?
    var  GeneratedLead:NSInteger?
    var  UpdatedLead:NSInteger?
    var  UserID:NSInteger?
    var  UpdatedVisit:NSInteger?
    var  lowerHierarchyUsers:String?
    var  managerID:NSInteger?
    var  RoleID:NSInteger?
    var  ColorCode:NSInteger?
    var DottedManagerID:NSInteger?
    func initwithdict(dic:[String:Any])->LeadDashboardReport{
        
         self.AssignedLead =  Common.returndefaultInteger(dic: dic, keyvalue: "AssignedLead")
        self.CreatedBy =  Common.returndefaultInteger(dic: dic, keyvalue: "CreatedBy")
        self.ForDate =  Common.returndefaultstring(dic: dic, keyvalue: "ForDate")
        self.UserName = Common.returndefaultstring(dic: dic, keyvalue: "UserName")
        self.CompanyID =  Common.returndefaultInteger(dic: dic, keyvalue: "CompanyID")
         self.GeneratedLead =  Common.returndefaultInteger(dic: dic, keyvalue: "GeneratedLead")
        self.UpdatedLead =  Common.returndefaultInteger(dic: dic, keyvalue: "UpdatedLead")
//        self.MissedVisit =  Common.returndefaultInteger(dic: dic, keyvalue: "MissedVisit")
         self.UserID =  Common.returndefaultInteger(dic: dic, keyvalue: "UserID")
        self.UpdatedVisit =  Common.returndefaultInteger(dic: dic, keyvalue: "UpdatedVisit")
          self.lowerHierarchyUsers = Common.returndefaultstring(dic: dic, keyvalue: "lowerHierarchyUsers")
           self.RoleID =  Common.returndefaultInteger(dic: dic, keyvalue: "RoleID")
      self.managerID =  Common.returndefaultInteger(dic: dic, keyvalue: "managerID")
        self.ColorCode =  Common.returndefaultInteger(dic: dic, keyvalue: "ColorCode")
        self.DottedManagerID = Common.returndefaultInteger(dic: dic, keyvalue: "dottedManagerID")
        return self
    }
    
}
