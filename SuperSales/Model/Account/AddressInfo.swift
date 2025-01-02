//
//  AddressInfo.swift
//  SuperSales
//
//  Created by Apple on 23/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class AddressInfo: NSObject {
    
    var address_id:NSInteger?
    var country:String?
    var state:String?
    var city:String?
    var addressLine1:String?
    var addressLine2:String?
    var pincode:String?
    var lat:String?
    var lng:String?
    var type:String?
    var verified:Bool?
    var last_modified_by:Int?
   
    
    func initWithdic(dic:[String:Any])->AddressInfo{
        
        self.address_id = Common.returndefaultNSInteger(dic: dic, keyvalue: "AddressID")
        self.country = Common.returndefaultstring(dic: dic, keyvalue: "Country")
        self.state = Common.returndefaultstring(dic: dic , keyvalue: "State")
        self.addressLine1 = Common.returndefaultstring(dic: dic , keyvalue: "AddressLine1")
        self.addressLine2 = Common.returndefaultstring(dic: dic , keyvalue: "AddressLine2")
        self.pincode = Common.returndefaultstring(dic: dic, keyvalue: "Pincode")
        self.city = Common.returndefaultstring(dic: dic, keyvalue: "City")
        self.lat = Common.returndefaultstring(dic:dic , keyvalue:"Lattitude")
        self.lng = Common.returndefaultstring(dic: dic , keyvalue: "Longitude")
        self.type = Common.returndefaultstring(dic: dic , keyvalue: "Type")
        self.verified = Common.returndefaultbool(dic: dic, keyvalue: "Verified")
        self.last_modified_by =  Common.returndefaultInteger(dic: dic, keyvalue: "LastModifiedBy")
        return self
    }
    
    func toDictionary()->[String:Any]{
        var dictionary:[String:Any] = [String:Any]()
        dictionary["AddressID"] = self.address_id
        dictionary["Country"] = self.country
        dictionary["State"] = self.state
        dictionary["City"] = self.city
        dictionary["AddressLine1"] = self.addressLine1
        dictionary["AddressLine2"] = self.addressLine2
        dictionary["Pincode"] = self.pincode
        dictionary["Lattitude"] = self.lat
        dictionary["Longitude"] = self.lng
        dictionary["Type"] = self.type // ?? ""
        dictionary["Verified"] = self.verified
        dictionary["LastModifiedBy"] = self.last_modified_by
        return dictionary
    }
    
    func addressString()->String{
        var strad = ""
        if let ad1 = self.addressLine1 as? String {
            strad.append("\(ad1),")
        }
        if let ad2 = self.addressLine2 as? String {
            strad.append("\(ad2),")
        }
      
        if let city = self.city as? String {
            strad.append("\(city),")
        }
        if let country = self.country as? String {
            strad.append(country)
        }
//        let str = String.init(format:"\(self.addressLine1) , \(self.addressLine2),\(self.city),\(self.country)")
        return strad
    }
}
