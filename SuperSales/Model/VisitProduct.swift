//
//  VisitProduct.swift
//  SuperSales
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class VisitProduct: NSObject {

    var visitID:Int?
    var productID:Int?
    var productName:String?
    var quantity:Int?
    var budget:NSNumber?
    var categoryType:Int?
    
    func initwithdic(dict:[String:Any])->VisitProduct{
        self.visitID = Common.returndefaultInteger(dic: dict, keyvalue: "VisitID")
        self.productID = Common.returndefaultInteger(dic: dict, keyvalue: "ProductID")
        self.productName = Common.returndefaultstring(dic: dict, keyvalue: "ProductName")
        self.quantity = Common.returndefaultInteger(dic: dict, keyvalue: "Quantity")
        self.budget = Common.returndefaultnsnumber(dic: dict, keyvalue: "Budget")
        self.categoryType = Common.returndefaultInteger(dic: dict, keyvalue: "CategoryType")
        
        return self
    }
}
