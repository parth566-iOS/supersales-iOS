//
//  CustomerVendorResult.swift
//  SuperSales
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class CustomerVendorResult: NSObject {
    
    var ID:Int?
    var Name:String?
    var MobileNo:String?
    var LandlineNo:String?
    var EmailID:String?
    var OwnerID:Int?
    var CompanyTypeID:Int?
    var CreatedBy:Int?
    var CompanyID:Int?
    var customerType:String?
    var Description:String?
    var Logo:String?
    var CreatedTime:String?
    var LastModified:String?
    var Tax_Type:String?
    var TaggedToName:String?
    var TaggedStatus:String?
    var LastModifiedBy:Int?
    var TaggedToID:Int?
    var TaggedRole:Int?
    var KeyCustomerVendor:Bool?
    var Transactional:Bool?
    var isActive:Bool?
    var aryAddressList:[[String:Any]]?
    
    func initwithdic(dict:[String:Any]) -> CustomerVendorResult {
        self.ID = Common.returndefaultInteger(dic: dict, keyvalue: "ID")
        self.Name = Common.returndefaultstring(dic: dict, keyvalue: "Name")
        self.MobileNo = Common.returndefaultstring(dic: dict, keyvalue: "MobileNo")
        self.LandlineNo =  Common.returndefaultstring(dic: dict, keyvalue: "LandlineNo")
        self.EmailID =  Common.returndefaultstring(dic: dict, keyvalue: "EmailID")
        self.customerType = Common.returndefaultstring(dic: dict, keyvalue: "Type")
        self.Description = Common.returndefaultstring(dic: dict, keyvalue: "Description")
        self.Logo = ""
        self.Tax_Type = Common.returndefaultstring(dic: dict, keyvalue: "TaxType")
        self.OwnerID = Common.returndefaultInteger(dic: dict, keyvalue: "OwnerID")
        self.CompanyTypeID = Common.returndefaultInteger(dic: dict, keyvalue: "CompanyTypeID")
        self.CreatedBy = Common.returndefaultInteger(dic: dict, keyvalue: "CreatedBy")
        self.CompanyID = Common.returndefaultInteger(dic: dict, keyvalue: "CompanyID")
        self.TaggedToID = Common.returndefaultInteger(dic: dict, keyvalue: "TaggedTo")
        self.TaggedRole =  Common.returndefaultInteger(dic: dict, keyvalue: "TaggedRoleID")
        self.TaggedToName = ""
        self.TaggedStatus = ""
        self.Transactional = Common.returndefaultbool(dic: dict, keyvalue: "Transactional")
        self.isActive = Common.returndefaultbool(dic: dict, keyvalue: "IsActive")
        self.CreatedTime = ""
        self.LastModified = ""
        self.aryAddressList = dict["AddressList"] as? [[String:Any]] ?? [[String:Any]]()
        return self
    }
}
