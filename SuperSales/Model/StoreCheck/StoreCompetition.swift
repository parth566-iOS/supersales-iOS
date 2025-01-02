//
//  StoreCompetition.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
class StoreCompetition: NSObject {

//@property (nonatomic) NSInteger id;
//@property (nonatomic) NSInteger companyID;
//@property (nonatomic) NSInteger modifiedBy;
//@property (nonatomic) NSString *storeCompetition;
//@property (nonatomic) NSString *modifiedTime;
//@property (nonatomic) BOOL status;
////@property(nonatomic) NSMutableArray<AssignedActivity *><Optional> *assignedActivities;
//@property(nonatomic) NSMutableArray<Optional> *aryAssignedActivities;
//@property (nonatomic) NSArray<Optional> *storeJustificationIDList;
    var iD:NSNumber!
    var companyID:NSNumber!
     var modifiedBy:NSNumber?
    var storeCompetition:String?
    var modifiedTime:String?
    var status:Bool?
  
    var aryAssignedActivities:[AssignedActivity]? = [AssignedActivity]()
    var storeJustificationIDList:[StoreJustification]? = [StoreJustification]()
    
    func initwithdic(dict:[String:Any])->StoreCompetition{
      
        self.iD =  Common.returndefaultnsnumber(dic: dict, keyvalue: "id")
        self.companyID = Common.returndefaultnsnumber(dic: dict, keyvalue: "companyID")
        self.modifiedBy =  Common.returndefaultnsnumber(dic: dict , keyvalue: "modifiedBy")
        self.storeCompetition =  Common.returndefaultstring(dic: dict , keyvalue: "storeCompetition")
        self.modifiedTime =  Common.returndefaultstring(dic: dict, keyvalue: "modifiedTime")
        self.status =  Common.returndefaultbool(dic: dict, keyvalue: "status")
      //  self.storeJustificationIDList =  Common.returndefaultarray(dic: dict, keyvalue: "storeJustificationIDList") as? [StoreJustification]
        let arrJustification = dict["storeJustificationIDList"] as? [[String:Any]]
        if(arrJustification?.count ?? 0 > 0){
            for dic in arrJustification!{
                let assignactivity = StoreJustification().initwithdic(dict: dic)
                self.storeJustificationIDList?.append(assignactivity)
            }
        }
        
        let arrAssign = dict["assignedActivities"] as? [[String:Any]]
        if(arrAssign?.count ?? 0 > 0){
            for dic in arrAssign!{
                let assignactivity = AssignedActivity().initwithdic(dict: dic)
                self.aryAssignedActivities?.append(assignactivity)
            }
        }
        return self
    }
    
    
}
