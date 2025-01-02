//
//  CompanyStock.swift
//  SuperSales
//
//  Created by Apple on 08/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
class CompanyStock{
    
    var  productID:NSNumber?
    var  availableStock:NSNumber?
    var  onHandStock:NSNumber?
    var  shipperStock:NSNumber?
    
    
    func initwithdic(dic:[String:Any])->CompanyStock{
        self.productID = Common.returndefaultnsnumber(dic: dic, keyvalue: "ProductID")
        self.availableStock = Common.returndefaultnsnumber(dic: dic, keyvalue: "AvailableStock")
        self.onHandStock = Common.returndefaultnsnumber(dic: dic, keyvalue: "OnHandStock")
        self.shipperStock = Common.returndefaultnsnumber(dic: dic, keyvalue: "ShipperStock")
        return self
    }
}
