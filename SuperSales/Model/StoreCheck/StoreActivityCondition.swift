//
//  StoreActivityCondition.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//


import Foundation
class StoreActivityCondition: NSObject {

    var storeActivityID:NSNumber!
  
   
    var activitystoreConditionIDList:[NSNumber]?
    
    func initwithdic(dict:[String:Any])->StoreActivityCondition{
      
        self.storeActivityID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "StoreActivityID")
self.activitystoreConditionIDList =  Common.returndefaultNSNumberArray(dic: dict, keyvalue: "StoreConditionIDList") 
        return self
    }
    
    
}
