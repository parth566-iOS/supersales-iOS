//
//  VisitReport.swift
//  SuperSales
//
//  Created by Apple on 03/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import Foundation

class VisitDashboardReport: NSObject {
   
    var  CreatedBy:NSInteger?
    var  ForDate:String?
    var  UserName:String?
    var  CompanyID:NSInteger?
    var  ActualVisit:NSInteger?
    var  PlannedVisit:NSInteger?
    var  MissedVisit:NSInteger?
    var  UserID:NSInteger?
    var  UpdatedVisit:NSInteger?
    var  lowerHierarchyUsers:String?
    var  managerID:NSInteger?
    var  RoleID:NSInteger?
    var  ColorCode:NSInteger?
    var DottedManagerID:NSInteger?
    
    func initwithdict(dic:[String:Any])->VisitDashboardReport{
        self.CreatedBy =  Common.returndefaultInteger(dic: dic, keyvalue: "CreatedBy")
        self.ForDate =  Common.returndefaultstring(dic: dic, keyvalue: "ForDate")
        self.UserName = Common.returndefaultstring(dic: dic, keyvalue: "UserName")
        self.CompanyID =  Common.returndefaultInteger(dic: dic, keyvalue: "CompanyID")
         self.ActualVisit =  Common.returndefaultInteger(dic: dic, keyvalue: "ActualVisit")
        self.PlannedVisit =  Common.returndefaultInteger(dic: dic, keyvalue: "PlannedVisit")
        self.MissedVisit =  Common.returndefaultInteger(dic: dic, keyvalue: "MissedVisit")
         self.UserID =  Common.returndefaultInteger(dic: dic, keyvalue: "UserID")
        self.UpdatedVisit =  Common.returndefaultInteger(dic: dic, keyvalue: "UpdatedVisit")
          self.lowerHierarchyUsers = Common.returndefaultstring(dic: dic, keyvalue: "lowerHierarchyUsers")
        self.DottedManagerID = Common.returndefaultInteger(dic: dic, keyvalue: "dottedManagerID")
           self.RoleID =  Common.returndefaultInteger(dic: dic, keyvalue: "RoleID")
      self.managerID =  Common.returndefaultInteger(dic: dic, keyvalue: "managerID")
        self.ColorCode =  Common.returndefaultInteger(dic: dic, keyvalue: "ColorCode")
        return self
    }
    
    
    
}
