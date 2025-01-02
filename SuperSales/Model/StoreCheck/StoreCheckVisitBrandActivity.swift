//
//  StoreCheckVisitBrandActivity.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
//import StoreActivityJustification

class StoreCheckVisitBrandActivity: NSObject {
/*
     @property (nonatomic) NSInteger id;
     @property (nonatomic) NSInteger visitID;
     @property (nonatomic) NSInteger companyID;
     @property (nonatomic) NSInteger storeConditionID;
     @property (nonatomic) NSInteger storeJustificationID;
     @property (nonatomic) NSString *activityImage;
     @property (nonatomic) long targetQuantity;
     @property (nonatomic) NSString *activityName;
     @property (nonatomic) NSString *conditionName;
     @property (nonatomic) NSString<Optional> *branddescription;
     @property (nonatomic) NSString *justificationName;
     @property (nonatomic) NSInteger modifiedBy;
     @property (nonatomic) NSArray<Optional> *storeActivityJustificationList;
     **/
    
    var iD:NSNumber!
    var visitID:NSNumber!
    var companyID:NSNumber!
    var storeConditionID:NSNumber?
    var storeJustificationID:NSNumber?
    var activityImage:String?
    var targetQuantity:NSNumber?
    var activityName:String?
    var conditionName:String?
    var branddescription:String?
    var justificationName:String?
    var modifiedBy:NSNumber!
    var storeActivityJustificationList:[StoreActivityJustifiction]?
    
    func initwithdic(dict:[String:Any])->StoreCheckVisitBrandActivity{
        self.iD = Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
        self.visitID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "visitID")
       
        self.companyID = Common.returndefaultnsnumber(dic: dict, keyvalue: "companyID")
        self.activityName =  Common.returndefaultstring(dic: dict, keyvalue: "activityName")
        self.conditionName = Common.returndefaultstring(dic: dict, keyvalue: "conditionName")
        self.modifiedBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "modifiedBy")
        self.branddescription =  Common.returndefaultstring(dic: dict, keyvalue: "description")
      
        self.justificationName =  Common.returndefaultstring(dic: dict, keyvalue: "justificationName")
       
        self.storeConditionID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "storeConditionID")
        self.storeJustificationID  = Common.returndefaultnsnumber(dic: dict, keyvalue: "storeJustificationID")
        self.targetQuantity =  Common.returndefaultnsnumber(dic: dict, keyvalue: "targetQuantity")
        
        self.justificationName =  Common.returndefaultstring(dic: dict, keyvalue: "justificationName")
        self.activityImage =  Common.returndefaultstring(dic: dict, keyvalue: "activityImage")
       
        let arractivityjustificationlist =  Common.returndefaultarray(dic: dict, keyvalue: "storeActivityJustificationList") as? [Any]
 
        return self
    }
    
    
}
