//
//  AddressListModel.swift
//  SuperSales
//
//  Created by Apple on 09/01/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
/*
 {
     AddressID = 1316201;
     AddressLine1 = "FOOD STORY,  Shop No. 10";
     AddressLine2 = "Rudraksha Apartment,  Jodhpur Gam Rd,  Opposite Lotus School,  Jodhpur Village,  Ahmedabad";
     City = Ahmedabad;
     Country = India;
     CustVenID = 0;
     LastModifiedBy = 0;
     Lattitude = "23.018576";
     Longitude = "72.5214004";
     Pincode = 380015;
     State = Gujarat;
     Verified = 0;
 }
 **/
class AddressListModel: NSObject {
    var addressId:NSNumber!
    var addressLine1:String!
    var addressLine2:String!
    var city:String!
    var country:String!
    var custVenID:NSNumber!
    var lastModifiedBy:NSNumber!
    var lattitude:String!
    var longitude:String!
    var dlattitude:NSNumber!
    var dlongitude:NSNumber!
    var pincode:NSNumber!
    
    var verified:NSNumber!
    var state:String!
    var type:String!
    func getaddressListModelWithDic(dict:[String:Any])->AddressListModel{
        self.addressId = Common.returndefaultnsnumber(dic: dict, keyvalue: "AddressID")
        self.addressLine1 = Common.returndefaultstring(dic: dict, keyvalue: "AddressLine1")
        self.addressLine2 = Common.returndefaultstring(dic: dict, keyvalue: "AddressLine2")
        self.city = Common.returndefaultstring(dic: dict, keyvalue: "City")
        self.country = Common.returndefaultstring(dic: dict, keyvalue: "Country")
        self.type = Common.returndefaultstring(dic: dict, keyvalue: "Type")
        self.custVenID = Common.returndefaultnsnumber(dic: dict, keyvalue: "CustVenID")
        self.lastModifiedBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "LastModifiedBy")
        self.lattitude = Common.returndefaultstring(dic: dict, keyvalue: "Lattitude")
        self.longitude = Common.returndefaultstring(dic: dict, keyvalue: "Longitude")
        self.dlattitude = Common.returndefaultnsnumber(dic: dict, keyvalue: "Lattitude")
        self.dlongitude = Common.returndefaultnsnumber(dic: dict, keyvalue: "Longitude")
       
        self.state = Common.returndefaultstring(dic: dict, keyvalue: "State")
        self.pincode = Common.returndefaultnsnumber(dic: dict, keyvalue: "Pincode")
        self.verified = Common.returndefaultnsnumber(dic: dict, keyvalue: "Verified")
        
        return self
    }
}
