//
//  SubCategoryShare.swift
//  SuperSales
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class SubCategoryShare: NSObject {

    var iD:NSNumber?
    var categoryExpectedValue:NSNumber?
    var categoryInterested:Bool?
    var createdBy:NSNumber?
    var customerProfileID:NSNumber?
    var subCategoryID:NSNumber?
    
    func initwithdic(dict:[String:Any])->SubCategoryShare{
        self.iD = Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
        self.categoryExpectedValue = Common.returndefaultnsnumber(dic: dict, keyvalue: "categoryExpectedValue")
        self.categoryInterested =  Common.returndefaultbool(dic: dict, keyvalue: "categoryInterested")
        self.createdBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "createdBy")
         self.customerProfileID = Common.returndefaultnsnumber(dic: dict, keyvalue: "customerProfileID")
         self.subCategoryID = Common.returndefaultnsnumber(dic: dict, keyvalue: "subCategoryID")
        
        return self
    }
}
