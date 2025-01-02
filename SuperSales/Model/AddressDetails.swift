//
//  AddressDetails.swift
//  SuperSales
//
//  Created by Apple on 18/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class AddressDetails: NSObject {
    
    var addressLine1:String!
    var addressLine2:String!
    var addressMasterID:NSInteger!
    var city:String!
    var country:String!
    var createdTime:String!
    var lattitude:String!
    var longitude:String!
    var pincode:String!
    var state:String!
    var activitytype:NSInteger!
    var verified:Bool!
    
    func initWithdic(dict:[String:Any])->AddressDetails{
        self.addressMasterID = Common.returndefaultNSInteger(dic: dict , keyvalue: "AddressMasterID")
        self.activitytype =  Common.returndefaultNSInteger(dic: dict, keyvalue: "Type")
        self.verified = Common.returndefaultbool(dic: dict, keyvalue: "Verified")
        self.addressLine1 = Common.returndefaultstring(dic: dict, keyvalue: "AddressLine1")
        self.addressLine2 = Common.returndefaultstring(dic: dict, keyvalue: "AddressLine2")
        self.city = Common.returndefaultstring(dic: dict, keyvalue: "City")
        self.city = Common.returndefaultstring(dic: dict, keyvalue: "City")
        self.country = Common.returndefaultstring(dic: dict, keyvalue: "Country")
        self.createdTime = Common.returndefaultstring(dic: dict, keyvalue: "CreatedTime")
        self.lattitude = Common.returndefaultstring(dic: dict, keyvalue: "Lattitude")
        self.longitude = Common.returndefaultstring(dic: dict, keyvalue: "Longitude")
        self.pincode = Common.returndefaultstring(dic: dict, keyvalue: "Pincode")
        self.state = Common.returndefaultstring(dic: dict, keyvalue: "State")
       // self.activitytype = Common.returndefaultstring(dic: dict, keyvalue: "Type")
        
        return self
    }
}
