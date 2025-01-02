//
//  SalesPlanProductsList.swift
//  SuperSales
//
//  Created by Apple on 09/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class SalesPlanProductsList: NSObject {
    var ID:Int!
    var LeadID:Int!
    var LeadStatusID:Int!
    var ProductID:Int!
    var Quantity:Int!
    var Budget:NSNumber!
    var ProductName:String!
    
    func initWithDictionary(dict:[String:Any])->SalesPlanProductsList{
        self.LeadID = Common.returndefaultInteger(dic: dict, keyvalue: "LeadID")
        self.LeadStatusID = Common.returndefaultInteger(dic: dict, keyvalue: "LeadStatusID")
        self.ProductID = Common.returndefaultInteger(dic: dict, keyvalue: "ProductID")
        self.Quantity = Common.returndefaultInteger(dic: dict, keyvalue: "Quantity")
        self.Budget = Common.returndefaultnsnumber(dic: dict, keyvalue: "Budget")
        self.ProductName = Common.returndefaultstring(dic: dict, keyvalue: "ProductName")
        return self
    }
}
