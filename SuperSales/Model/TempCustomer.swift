//
//  TempCustomer.swift
//  SuperSales
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class TempCustomer: NSObject {
    var distributorID:Int?
    var distributorName:String?
    var TempCustomerID:Int?
    var CustomerName:String?
    var ContactFirstName:String?
    var ContactLastName:String?
    var MobileNo:String?
    var ContactNo:String?
    var AddressLine1:String?
    var AddressLine2:String?
    var EmailID:String?
    var CompanyTypeID:Int?
    var TempCustomerType:String?
    var Country:String?
    var City:String?
    var State:String?
    var Lattitude:String?
    var Longitude:String?
    var Pincode:String?
    var customerProfile:VisitTempCustomerProfile?
    
    func initwithdic(dict:[String:Any]) -> TempCustomer {
        self.TempCustomerID = Common.returndefaultInteger(dic: dict, keyvalue: "TempCustomerID")
        self.distributorID = Common.returndefaultInteger(dic: dict, keyvalue: "DistributorID")
        self.distributorName =  Common.returndefaultstring(dic: dict, keyvalue: "DistributorName")
        self.CustomerName =  Common.returndefaultstring(dic: dict, keyvalue: "CustomerName")
        self.ContactFirstName =  Common.returndefaultstring(dic: dict, keyvalue: "ContactFirstName")
        self.ContactLastName =  Common.returndefaultstring(dic: dict, keyvalue: "ContactLastName")
        self.MobileNo =  Common.returndefaultstring(dic: dict, keyvalue: "MobileNo")
        self.ContactNo =  Common.returndefaultstring(dic: dict, keyvalue: "ContactNo")
        self.AddressLine1 =  Common.returndefaultstring(dic: dict, keyvalue: "AddressLine1")
        self.AddressLine2 =  Common.returndefaultstring(dic: dict, keyvalue: "AddressLine2")
        self.EmailID = Common.returndefaultstring(dic: dict, keyvalue: "EmailID")
        self.CompanyTypeID = Common.returndefaultInteger(dic: dict, keyvalue: "CompanyTypeID")
        self.TempCustomerType = Common.returndefaultstring(dic: dict, keyvalue: "Type")
        self.Country = Common.returndefaultstring(dic: dict, keyvalue: "Country")
        self.City = Common.returndefaultstring(dic: dict, keyvalue: "City")
        self.State = Common.returndefaultstring(dic: dict, keyvalue: "State")
        self.Lattitude = Common.returndefaultstring(dic: dict, keyvalue: "Lattitude")
        self.Longitude = Common.returndefaultstring(dic: dict, keyvalue: "Longitude")
        self.Pincode = Common.returndefaultstring(dic: dict, keyvalue: "Pincode")
        self.customerProfile =  VisitTempCustomerProfile().initwithdic(dict: Common.returndefaultdictionary(dic: dict , keyvalue: "customerProfile"))
        return self
    }
}
