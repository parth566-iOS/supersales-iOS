//
//  TertiaryProductList.swift
//  SuperSales
//
//  Created by Apple on 28/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class TertiaryProductList: NSObject {
   
    var iD:NSNumber?
    var productID:NSNumber?
    var productName:String?
    var quantity:NSNumber?
  
    func initwithdic(dict:[String:Any])->TertiaryProductList{
        self.iD = Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
        self.productID = Common.returndefaultnsnumber(dic: dict, keyvalue: "ProductID")
        self.quantity = Common.returndefaultnsnumber(dic: dict, keyvalue: "Quantity")
        self.productName = Common.returndefaultstring(dic: dict, keyvalue: "ProductName")
       
//        print(self.productName ?? "")
        return self
    }
}
