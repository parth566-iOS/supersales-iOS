//
//  StoreCheckBrandActivity.swift
//  SuperSales
//
//  Created by Apple on 08/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
class StoreCheckBrandActivity: NSObject {

    
    var iD:NSNumber!
    var storeActivityID:NSNumber!
    var storeActivityName:String?
    var companyID:NSNumber!
    var startDate:String?
    var endDate:String?
    var createdBy:NSNumber!
    var createdTime:String?
    var lastModifiedBy:NSNumber?
    var lastModifiedTime:String?
    var isActive:Bool!
    var storeConditionID:NSNumber?
    var storeConditionName:String?
    var targetQuantity:NSNumber?
     var userQuantity:String?
     var activitydescription:String?
    var justificationID:NSNumber?
     var justificationName:String?
      var activityImage:String?
    var storeJustificationIDList:[StoreJustification]?
    var storeConditionIDList:[StoreCondition]?
    
    func initwithdic(dict:[String:Any])->StoreCheckBrandActivity{
        self.iD = Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
        self.storeActivityID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "storeActivityID")
        self.storeActivityName =  Common.returndefaultstring(dic: dict , keyvalue: "storeActivityName")
        self.companyID = Common.returndefaultnsnumber(dic: dict, keyvalue: "companyID")
        self.startDate =  Common.returndefaultstring(dic: dict, keyvalue: "startDate")
        self.endDate = Common.returndefaultstring(dic: dict, keyvalue: "endDate")
        self.createdBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "createdBy")
        self.createdTime =  Common.returndefaultstring(dic: dict, keyvalue: "createdTime")
        self.lastModifiedBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "lastModifiedBy")
        self.lastModifiedTime =  Common.returndefaultstring(dic: dict, keyvalue: "lastModifiedTime")
        self.isActive = Common.returndefaultbool(dic: dict, keyvalue: "isActive")
        self.storeConditionID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "storeConditionID")
        self.storeConditionName = Common.returndefaultstring(dic: dict, keyvalue: "storeConditionName")
        self.targetQuantity =  Common.returndefaultnsnumber(dic: dict, keyvalue: "targetQuantity")
        self.userQuantity = Common.returndefaultstring(dic: dict, keyvalue: "userQuantity")
        self.activitydescription =  Common.returndefaultstring(dic: dict, keyvalue: "activitydescription")
        self.justificationID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "justificationID")
        self.justificationName =  Common.returndefaultstring(dic: dict, keyvalue: "justificationName")
        self.activityImage =  Common.returndefaultstring(dic: dict, keyvalue: "activityImage")
        self.storeJustificationIDList =  Common.returndefaultarray(dic: dict, keyvalue: "storeJustificationIDList") as? [StoreJustification]
        self.storeConditionIDList =  Common.returndefaultarray(dic: dict, keyvalue: "storeConditionIDList") as? [StoreCondition]
        return self
    }
    
    
}
