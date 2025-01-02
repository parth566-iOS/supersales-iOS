//
//  AssignedActivity.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
class AssignedActivity: NSObject {

//    @property (nonatomic) NSInteger id;
//    @property (nonatomic) NSInteger companyID;
//    @property (nonatomic) NSInteger modifiedBy;
//    @property (nonatomic) NSString *storeCompetition;
//    @property (nonatomic) NSString *modifiedTime;
//    @property (nonatomic) BOOL status;
//    //@property(nonatomic) NSMutableArray<AssignedActivity *><Optional> *assignedActivities;
//    @property(nonatomic) NSMutableArray<Optional> *aryAssignedActivities;
//    @property (nonatomic) NSArray<Optional> *storeJustificationIDList;
    /*
     @property (nonatomic) NSInteger id;
     @property (nonatomic) NSInteger companyID;
     @property (nonatomic) NSInteger storeCompetitionID;
     @property (nonatomic) NSString *storeCompetitionName;
     @property (nonatomic) NSInteger storeActivityID;
     @property (nonatomic) NSString *storeActivityName;
     @property (nonatomic) NSString<Optional> *activitydescription;
     @property (nonatomic) BOOL checkAvailability;
     @property (nonatomic) BOOL inputQuantity;
     @property (nonatomic) NSInteger createdBy;
     @property (nonatomic) NSString *createdTime;
     @property (nonatomic) NSInteger lastModifiedBy;
     @property (nonatomic) NSString *lastModifiedTime;
     @property (nonatomic) BOOL isActive;
     @property (nonatomic) NSNumber<Optional> *justificationID;
     @property (nonatomic) NSString<Optional> *justificationName;
     @property (nonatomic) NSString<Optional> *activityImage;
     @property (nonatomic) NSNumber<Optional> *isYES;
     @property (nonatomic) NSNumber<Optional> *quantity;
     **/
    var iD:NSNumber!
    var companyID:NSNumber!
    var storeCompetitionID:NSNumber?
    var storeActivityID:NSNumber?
    var storeCompetitionName:String?
    var storeActivityName:String?
    var activitydescription:String?
    var modifiedTime:String?
    var checkAvailability:Bool?
    var inputQuantity:Bool?
    var createdBy:NSNumber?
    var createdTime:String?
    var lastModifiedBy:NSNumber?
    var lastModifiedTime:String?
     var isActive:Bool?
    var justificationID:NSNumber?
     var justificationName:String?
       var activityImage:String?
    var isYES:NSNumber?
    var quantity:NSNumber?
//    var aryAssignedActivities:[AssignedActivity]?
//    var storeJustificationIDList:[StoreJustification]?
    
    func initwithdic(dict:[String:Any])->AssignedActivity{
      
        self.iD =  Common.returndefaultnsnumber(dic: dict, keyvalue: "id")
        self.storeActivityID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "storeActivityID")
        self.companyID =  Common.returndefaultnsnumber(dic: dict , keyvalue: "companyID")
        self.storeCompetitionID =  Common.returndefaultnsnumber(dic: dict , keyvalue: "storeCompetitionID")
         self.storeActivityID =  Common.returndefaultnsnumber(dic: dict , keyvalue: "storeActivityID")
         self.storeCompetitionName =  Common.returndefaultstring(dic: dict , keyvalue: "storeCompetitionName")
         self.storeActivityName =  Common.returndefaultstring(dic: dict , keyvalue: "storeActivityName")
         self.storeActivityName =  Common.returndefaultstring(dic: dict , keyvalue: "storeActivityName")
         self.activitydescription =  Common.returndefaultstring(dic: dict , keyvalue: "activitydescription")
          self.modifiedTime =  Common.returndefaultstring(dic: dict , keyvalue: "modifiedTime")
        self.checkAvailability = Common.returndefaultbool(dic: dict, keyvalue: "checkAvailability")
         self.inputQuantity = Common.returndefaultbool(dic: dict, keyvalue: "inputQuantity")
         self.createdBy =  Common.returndefaultnsnumber(dic: dict , keyvalue: "createdBy")
          self.createdTime =  Common.returndefaultstring(dic: dict , keyvalue: "createdTime")
          self.lastModifiedBy =  Common.returndefaultnsnumber(dic: dict , keyvalue: "lastModifiedBy")
          self.lastModifiedTime =  Common.returndefaultstring(dic: dict , keyvalue: "lastModifiedTime")
         self.isActive = Common.returndefaultbool(dic: dict, keyvalue: "isActive")
         self.justificationID =  Common.returndefaultnsnumber(dic: dict , keyvalue: "justificationID")
          self.justificationName =  Common.returndefaultstring(dic: dict , keyvalue: "justificationName")
          self.activityImage =  Common.returndefaultstring(dic: dict , keyvalue: "activityImage")
          self.isYES =  Common.returndefaultnsnumber(dic: dict , keyvalue: "isYES")
          self.quantity =  Common.returndefaultnsnumber(dic: dict , keyvalue: "quantity")
//        let arrAssignedActivity = Common.returndefaultarray(dic: dict, keyvalue:    "aryAssignedActivities") as? [[String:Any]]
//        if(arrAssignedActivity?.count ?? 0 > 0){
//            for asact in  arrAssignedActivity!{
//                let actassign = AssignedActivity().initwithdic(dict: asact)
//                self.aryAssignedActivities?.append(actassign)
//            }
//        }
//        self.storeJustificationIDList =  Common.returndefaultarray(dic: dict, keyvalue: "storeJustificationIDList") as? [StoreJustification]
        return self
    }
    
    
}
