//
//  StoreCompetitionJustification.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
class StoreCompetitionJustification: NSObject {

    var storeCompetitionID:NSNumber!
  
   
    var storeJustificationIDList:[NSNumber]?
    
    func initwithdic(dict:[String:Any])->StoreCompetitionJustification{
      
        self.storeCompetitionID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "StoreCompetitionID")
        self.storeJustificationIDList =  Common.returndefaultNSNumberArray(dic: dict, keyvalue: "StoreJustificationIDList")
        return self
    }
    
    
}
