//
//  Entitlement.swift
//  SuperSales
//
//  Created by Apple on 11/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import Foundation

struct Entitlement{
 // swiftlint:disable line_length
    var ID:Int
    var userID:Int
    var promotionID:Int
    var promotionTitle:String?
    var companyID:Int
    var customerID:Int
    var entitlementDesc:String?
    var isOTPGenerated:Int
    var isOTPConfirmed:Int
    var isEntitlementReceived:Int
    var createdBy:Int
    var createdTime:String
    var lastModifiedBy:Int
    
    init(_ dic:[String:Any]) {
        
        self.ID = dic["ID"] as? Int ?? 0
        self.userID = dic["userID"] as? Int ?? 0
        self.promotionID = dic["promotionID"] as? Int ?? 0
        self.promotionTitle = dic["promotionTitle"] as? String ?? ""
        self.companyID = dic["CompanyID"] as? Int ?? 0
        self.customerID = dic["CustomerID"] as? Int ?? 0
        self.entitlementDesc = dic["entitlementDesc"] as? String ?? ""
        self.isOTPConfirmed = dic["isOTPConfirmed"] as? Int ?? 0
        self.isOTPGenerated = dic["isOTPGenerated"] as? Int ?? 0
        self.isEntitlementReceived = dic["isEntitlementReceived"] as? Int ?? 0
        self.createdBy = dic["createdBy"] as? Int ?? 0
        self.createdTime = dic["createdTime"] as? String ?? ""
        self.lastModifiedBy = dic["lastModifiedBy"] as? Int ?? 0
        
    }
    
}
