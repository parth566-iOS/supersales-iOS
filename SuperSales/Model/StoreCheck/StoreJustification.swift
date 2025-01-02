//
//  StoreJustification.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
class StoreJustification: NSObject {

//@property (nonatomic) NSInteger id;
//@property (nonatomic) NSInteger companyID;
//@property (nonatomic) NSInteger modifiedBy;
//@property (nonatomic) NSString *storeJustification;
//@property (nonatomic) NSString *modifiedTime;
//@property (nonatomic) BOOL status;
    var iD:NSNumber!
    var companyID:NSNumber!
    var modifiedBy:NSNumber?
    var storeJustification:String!
    var modifiedTime:String?
    var status:Bool?
  
    var aryAssignedActivities:[AssignedActivity]?
    var storeJustificationIDList:[StoreJustification]?
    
    func initwithdic(dict:[String:Any])->StoreJustification{
      
        self.iD =  Common.returndefaultnsnumber(dic: dict, keyvalue: "id")
          self.companyID =  Common.returndefaultnsnumber(dic: dict , keyvalue: "companyID")
             self.modifiedBy =  Common.returndefaultnsnumber(dic: dict , keyvalue: "modifiedBy")
              self.storeJustification =  Common.returndefaultstring(dic: dict , keyvalue: "storeJustification")
              self.modifiedTime =  Common.returndefaultstring(dic: dict , keyvalue: "modifiedTime")
             self.status = Common.returndefaultbool(dic: dict, keyvalue: "status")
        self.storeJustificationIDList =  Common.returndefaultarray(dic: dict, keyvalue: "storeJustificationIDList") as? [StoreJustification]
        return self
    }
    
    
}
