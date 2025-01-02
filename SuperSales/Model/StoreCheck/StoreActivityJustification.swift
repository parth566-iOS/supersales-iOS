//
//  StoreActivityJustification.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
class StoreActivityJustifiction: NSObject {


  
    var storeActivityID:NSNumber!
    
    var activitystoreJustificationIDList:[NSNumber]?
  
    func initwithdic(dict:[String:Any])->StoreActivityJustifiction{
       
        self.storeActivityID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "StoreActivityID")
        self.activitystoreJustificationIDList =  Common.returndefaultNSNumberArray(dic: dict, keyvalue: "StoreJustificationIDList") 
    
        return self
    }
    
    
}
