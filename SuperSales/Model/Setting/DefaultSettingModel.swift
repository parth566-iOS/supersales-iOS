//
//  DefaultSettingModel.swift
//  SuperSales
//
//  Created by Apple on 09/01/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
/*
 ["ClientAddress": {
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
 }, "LocationType": 1, "UserLocationType": 1, "CompanyID": 1198, "ID": 1380, "ClientVendorID": 0, "ModifiedBy": 0, "UserID": 8834, "AddressID": 1316201]
 var address_id:NSNumber!
 var client_name:String!
 var clientvendorid:NSNumber!
 var company_id:NSNumber!
 var locationtype:NSNumber!
 var modified_by:NSNumber!
 var user_id:NSNumber!
 var user_location_type:NSNumber!
 var clientaddress:AddressList?
 */

class DefaultSettingModel: NSObject {
    var id:NSNumber!
    var addressID:NSNumber!
    var clientName:String!
    var clientvendorid:NSNumber!
    var modifiedBy:NSNumber!
    var userID:NSNumber!
    var locationType:NSNumber!
    var userLocationType:NSNumber!
    var companyID:NSNumber!
    var type:NSNumber!
    var clientAddress:AddressListModel?
    
    func getdefaultSettingModelWithDic(dict:[String:Any])->DefaultSettingModel{
        self.id = Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
        self.addressID = Common.returndefaultnsnumber(dic: dict, keyvalue: "AddressID")
        self.clientvendorid = Common.returndefaultnsnumber(dic: dict, keyvalue: "ClientVendorID")
        self.modifiedBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "ModifiedBy")
        self.userID = Common.returndefaultnsnumber(dic: dict, keyvalue: "UserID")
        self.locationType = Common.returndefaultnsnumber(dic: dict, keyvalue: "LocationType")
        self.userLocationType = Common.returndefaultnsnumber(dic: dict, keyvalue: "UserLocationType")
        self.companyID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "CompanyID")
        if let customer = CustomerDetails.getCustomerByID(cid: clientvendorid){
            self.clientName = customer.name
        }else{
        self.clientName = Common.returndefaultstring(dic: dict, keyvalue: "ClientName")
        }
        self.clientAddress = AddressListModel().getaddressListModelWithDic(dict:Common.returndefaultdictionary(dic: dict, keyvalue: "ClientAddress"))
        return self
    }
}
