//
//  BeatPlanListModel.swift
//  SuperSales
//
//  Created by Apple on 22/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import Foundation

class BeatPlan{
 
    var ApproveRejectBy:Int
    var ApprovedBy:Int
    var ApprovedTo:Int
    var territoryID:Int
    var LowerUsersBeat:Int
    var RejectMessage:String?
    var SeriesPostfix:Int
    var StartTime:String
    var UserID:Int
    var customer:CustomerModel?
    var ID:Int
    var BeatPlanID:String!
    var BeatPlanName:String!
    var BeatPlanDate:String!
    var NextActionTime:String!
    var CustomerID:Int
    var CompanyID:Int
   var AssigneeID:Int
   var assigneeName:String!
   var CreatedBy:Int
   var CreatedByName:String?
   var ModifiedTime:String!
   var TransactionID:String!
   var IsActive:Int
   var StatusID:Int

init(_ Dic:[String:Any]) {
    self.ID = Dic["ID"] as? Int ?? 0
    self.BeatPlanID = Dic["BeatPlanID"] as? String ?? ""
    self.BeatPlanName = Dic["BeatPlanName"] as? String ?? ""
    self.territoryID = Dic["territoryId"] as? Int ?? 0
    self.BeatPlanDate = Dic["BeatPlanDate"] as? String ?? ""
    self.NextActionTime = Dic["NextActionTime"] as? String ?? ""
    
    self.CustomerID = Dic["CustomerID"] as? Int ?? 0
    self.CompanyID = Dic["CompanyID"] as? Int ?? 0
    self.AssigneeID = Dic["AssigneeID"] as? Int ?? 0
    self.assigneeName = Dic["assigneeName"] as? String ?? ""
    self.CreatedBy = Dic["CreatedBy"] as? Int ?? 0
    self.CreatedByName = Dic["CreatedByName"] as? String ?? ""
    self.ModifiedTime = Dic["ModifiedTime"] as? String ?? ""
    self.TransactionID = Dic["TransactionID"] as? String ?? ""
    self.IsActive = Dic["IsActive"] as? Int ?? 0
    self.StatusID = Dic["StatusID"] as? Int ?? 0
    self.ApproveRejectBy = Dic["ApproveRejectBy"] as? Int ?? 0
     self.ApprovedBy = Dic["ApprovedBy"] as? Int ?? 0
     self.ApprovedTo = Dic["ApprovedTo"] as? Int ?? 0
     self.territoryID = Dic["territoryId"] as? Int ?? 0
     self.LowerUsersBeat = Dic["LowerUsersBeat"] as? Int ?? 0
    self.RejectMessage = Dic["RejectMessage"] as? String ?? ""
      self.SeriesPostfix = Dic["SeriesPostfix"] as? Int ?? 0
     self.StartTime = Dic["StartTime"] as? String ?? ""
      self.UserID = Dic["UserID"] as? Int ?? 0
    self.customer = CustomerModel(Dic["customer"] as? [String : Any] ?? [String:Any]())
    
    }
//    func filterBeatplanusingTerritoryID(tid:NSNumber)->[BeatPlan]{
//        var arrBeatPlan = [BeatPlan]()
//        if(self.territoryID == tid.intValue){
//            arrBeatPlan.append(self)
//        }
//        return arrBeatPlan
//    }
}

struct BeatPlanAssign {
    var BeatPlanDate:String!
    var NextActionTime:String!
    var selectedTerritory:Territory?
    var selectedBeatPlan:BeatPlan?
    var CreatedBy:Int!
    var AssigneeID:Int!
    var CompanyID:Int!
    var isSelected:Bool!
    init(_ Dic:[String:Any]) {
        self.BeatPlanDate = Dic["BeatPlanDate"] as? String
        self.NextActionTime = Dic["NextActionTime"] as? String
        self.selectedTerritory = Dic["selectedTerritory"] as? Territory 
        self.selectedBeatPlan = Dic["selectedBeatPlan"] as? BeatPlan 
        self.CreatedBy = Dic["CreatedBy"] as? Int
        self.AssigneeID = Dic["AssigneeID"] as? Int
        self.CompanyID = Dic["CompanyID"] as? Int
        self.isSelected = Dic["isSelected"] as? Bool 
    }
    
}

    final class BeatPlanListModel: NSObject {
    
    var ID:Int = 0
    var BeatPlanID:String!
    var BeatPlanName:String!
    var territoryID:Int
    var BeatPlanDate:String!
        var NextActionTime:String!
    var CustomerID:Int
    var CompanyID:Int
    var AssigneeID:Int
    var assigneeName:String!
    var CreatedBy:Int
    var CreatedByName:String!
    var ModifiedTime:String!
    var TransactionID:String!
    var IsActive:Int
    var StatusID:Int
    var Data:[String:Any]?
    
    
   
    
    init(Dic:[String:Any]){
        self.ID = Dic["ID"] as? Int ?? 0
        self.BeatPlanID = Dic["BeatPlanID"] as? String ?? ""
        self.BeatPlanName = Dic["BeatPlanName"] as? String ?? ""
        self.territoryID = Dic["territoryId"] as? Int ?? 0
        self.BeatPlanDate = Dic["BeatPlanDate"] as? String ?? ""
        self.NextActionTime = Dic["NextActionTime"] as? String ?? ""
        self.CustomerID = Dic["CustomerID"] as? Int ?? 0
        self.CompanyID = Dic["CompanyID"] as? Int ?? 0
        self.AssigneeID = Dic["AssigneeID"] as? Int ?? 0
        self.assigneeName = Dic["assigneeName"] as? String ?? ""
        self.CreatedBy = Dic["CreatedBy"] as? Int ?? 0
        self.CreatedByName = Dic["CreatedByName"] as? String ?? ""
        self.ModifiedTime = Dic["ModifiedTime"] as? String ?? ""
        self.TransactionID = Dic["TransactionID"] as? String ?? ""
        self.IsActive = Dic["IsActive"] as? Int ?? 0
        self.StatusID = Dic["StatusID"] as? Int ?? 0
        
    }
//    @objc(getObject:)
//    
//    func getObject(Dic:[String:Any]) -> _ObjCBeatPlanListModel {
//        self.ID = Dic["ID"] as? Int ?? 0
//        self.BeatPlanID = Dic["BeatPlanID"] as? String ?? ""
//        self.BeatPlanName = Dic["BeatPlanName"] as? String ?? ""
//        self.territoryID = Dic["territoryId] as? Int ?? 0
//        self.BeatPlanDate = Dic["BeatPlanDate"] as? String ?? ""
//        self.CustomerID = Dic["CustomerID"] as? Int ?? 0
//        self.CompanyID = Dic["CompanyID"] as? Int ?? 0
//        self.AssigneeID = Dic["AssigneeID"] as? Int ?? 0
//        self.assigneeName = Dic["assigneeName"] as? String ?? ""
//        self.CreatedBy = Dic["CreatedBy"] as? Int ?? 0
//        self.CreatedByName = Dic["CreatedByName"] as? String ?? ""
//        self.ModifiedTime = Dic["ModifiedTime"] as? String ?? ""
//        self.TransactionID = Dic["TransactionID"] as? String ?? ""
//        self.IsActive = Dic["IsActive"] as? Int ?? 0
//        self.StatusID = Dic["StatusID"] as? Int ?? 0
//        return self
//    }
    var Dic: [String:Any] {
        get {
            return self.Data ?? ["":""]
        }
        set {
            self.Data = Dic
        }
    
    }

}
class CustomerModel:NSObject{
   
    var Name:String
    var MobileNo:String
    var AddressList:[AddressDetailsInBeatPlan]
    init(_ dic:[String:Any]){
        self.Name = dic["Name"] as? String ?? ""
        self.MobileNo = dic["MobileNo"] as? String ?? ""
        let arrAddress =  dic["AddressList"] as? [[String:Any]] ?? [[String:Any]]()
        var addresslist  = [AddressDetailsInBeatPlan]()
        for add in arrAddress{
            let dicAdd =  add as? [String:Any] ?? [String:Any]()
            let a =  AddressDetailsInBeatPlan(dicAdd)
            addresslist.append(a)
        }
        self.AddressList = addresslist
    }
}
class AddressDetailsInBeatPlan: NSObject {
  
    var type:Int
    var State:String
    var City:String
    var AddressLine1:String
    var AddressLine2:String
    var Country:String
    
     init(_ dic:[String:Any]){
        self.type = dic["Type"] as? Int ?? 0
        self.State = dic["State"] as? String ?? ""
        self.City = dic["State"] as? String ?? ""
        self.AddressLine1 = dic["AddressLine1"] as? String ?? ""
        self.AddressLine2 = dic["AddressLine2"] as? String ?? ""
        self.Country = dic["Country"] as? String ?? ""
    }
}
//@objc class BeatPlanListModelSalesPlan:NSObject{
//    var ID:Int = 0
//    var BeatPlanID:String!
//    var BeatPlanName:String!
//    var territoryID:Int
//    var BeatPlanDate:String!
//    var CustomerID:Int
//    var CompanyID:Int
//    var AssigneeID:Int
//    var assigneeName:String!
//    var CreatedBy:Int
//    var CreatedByName:String!
//    var ModifiedTime:String!
//    var TransactionID:String!
//    var IsActive:Int
//    var StatusID:Int
//
//    init(_ Dic:[String:Any]) {
//        self.ID = Dic["ID"] as? Int ?? 0
//        self.BeatPlanID = Dic["BeatPlanID"] as? String ?? ""
//        self.BeatPlanName = Dic["BeatPlanName"] as? String ?? ""
//        self.territoryID = Dic["territoryId] as? Int ?? 0
//        self.BeatPlanDate = Dic["BeatPlanDate"] as? String ?? ""
//        self.CustomerID = Dic["CustomerID"] as? Int ?? 0
//        self.CompanyID = Dic["CompanyID"] as? Int ?? 0
//        self.AssigneeID = Dic["AssigneeID"] as? Int ?? 0
//        self.assigneeName = Dic["assigneeName"] as? String ?? ""
//        self.CreatedBy = Dic["CreatedBy"] as? Int ?? 0
//        self.CreatedByName = Dic["CreatedByName"] as? String ?? ""
//        self.ModifiedTime = Dic["ModifiedTime"] as? String ?? ""
//        self.TransactionID = Dic["TransactionID"] as? String ?? ""
//        self.IsActive = Dic["IsActive"] as? Int ?? 0
//        self.StatusID = Dic["StatusID"] as? Int ?? 0
//
//    }
//
//}

/*
 {
 ID: 106,
 BeatPlanID: "BB-1",
 BeatPlanName: "BB-1 NAME",
 territoryID: 0,
 BeatPlanDate: "2019/04/24 00:00:00",
 CustomerID: 0,
 CompanyID: 71,
 AssigneeID: 89,
 assigneeName: "ETest4z Kaushik",
 CreatedBy: 86,
 CreatedByName: "કૌશિક સોલંકી",
 ModifiedTime: "2019/04/24 00:00:00",
 TransactionID: "COBPA1556096926959C",
 IsActive: 1,
 StatusID: 1,
 },
 */
