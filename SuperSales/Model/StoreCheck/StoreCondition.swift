//
//  StoreCondition.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
class StoreCondition: NSObject {

//    @property (nonatomic) NSInteger id;
//    @property (nonatomic) NSInteger companyID;
//    @property (nonatomic) NSInteger modifiedBy;
//    @property (nonatomic) NSString *storeCompetition;
//    @property (nonatomic) NSString *modifiedTime;
//    @property (nonatomic) BOOL status;
//    //@property(nonatomic) NSMutableArray<AssignedActivity *><Optional> *assignedActivities;
//    @property(nonatomic) NSMutableArray<Optional> *aryAssignedActivities;
//    @property (nonatomic) NSArray<Optional> *storeJustificationIDList;
    var iD:NSNumber!
    var companyID:NSNumber!
    var modifiedBy:NSNumber?
    var storeCondition:String?
    var modifiedTime:String?
    var status:Bool?
  
    var aryAssignedActivities:[AssignedActivity]?
    var storeJustificationIDList:[StoreJustification]! = [StoreJustification]()
    
    func initwithdic(dict:[String:Any])->StoreCondition{
      
        self.iD =  Common.returndefaultnsnumber(dic: dict, keyvalue: "id")
        self.storeJustificationIDList =  Common.returndefaultarray(dic: dict, keyvalue: "storeJustificationIDList") as? [StoreJustification]
        self.companyID =  Common.returndefaultnsnumber(dic: dict , keyvalue: "companyID")
        self.modifiedBy =  Common.returndefaultnsnumber(dic: dict , keyvalue: "modifiedBy")
         self.storeCondition =  Common.returndefaultstring(dic: dict , keyvalue: "storeCondition")
         self.modifiedTime =  Common.returndefaultstring(dic: dict , keyvalue: "modifiedTime")
        self.status = Common.returndefaultbool(dic: dict, keyvalue: "status")
        return self
    }
    
    
}
