//
//  StoreCheckVisitCompetitionActivity.swift
//  SuperSales
//
//  Created by Apple on 09/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
class StoreCheckVisitCompetitionActivity: NSObject {

    /*
     @property (nonatomic) NSInteger id;
     @property (nonatomic) NSInteger visitID;
     @property (nonatomic) NSInteger companyID;
     @property (nonatomic) NSInteger storeCompetitionActivityID;
     @property (nonatomic) NSInteger storeJustificationID;
     @property (nonatomic) BOOL checkAvailability;
     @property (nonatomic) NSInteger targetQuantity;
     @property (nonatomic) NSString<Optional> *competitiondescription;
     @property (nonatomic) NSString *activityName;
     @property (nonatomic) NSString *activityImage;
     @property (nonatomic) NSString *competitionName;
     @property (nonatomic) NSString<Optional> *justificationName;
     @property (nonatomic) NSInteger modifiedBy;
     **/
    var id:NSNumber!
    var visitID:NSNumber?
    var companyID:NSNumber?
    var storeCompetitionActivityID:NSNumber?
    var storeJustificationID:NSNumber?
    var checkAvailability:Bool?
    var targetQuantity:NSNumber?
    var competitiondescription:String?
    var activityName:String?
    var activityImage:String?
     var competitionName:String?
     var justificationName:String?
    var modifiedBy:NSNumber?
   
    var storeJustificationIDList:[StoreJustification]?
    
    func initwithdic(dict:[String:Any])->StoreCheckVisitCompetitionActivity{
      
        self.id =  Common.returndefaultnsnumber(dic: dict, keyvalue: "id")
        self.visitID = Common.returndefaultnsnumber(dic: dict, keyvalue: "visitID")
         self.companyID = Common.returndefaultnsnumber(dic: dict, keyvalue: "companyID")
         self.storeCompetitionActivityID = Common.returndefaultnsnumber(dic: dict, keyvalue: "storeCompetitionActivityID")
         self.storeJustificationID = Common.returndefaultnsnumber(dic: dict, keyvalue: "storeJustificationID")
        self.checkAvailability =  Common.returndefaultbool(dic: dict, keyvalue: "checkAvailability")
         self.targetQuantity = Common.returndefaultnsnumber(dic: dict, keyvalue: "targetQuantity")
        self.competitiondescription = Common.returndefaultstring(dic: dict, keyvalue: "description")
         self.activityName = Common.returndefaultstring(dic: dict, keyvalue: "activityName")
         self.activityImage = Common.returndefaultstring(dic: dict, keyvalue: "activityImage")
        self.competitionName = Common.returndefaultstring(dic: dict, keyvalue: "competitionName")
        self.justificationName = Common.returndefaultstring(dic: dict, keyvalue: "justificationName")
        
         self.modifiedBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "modifiedBy")
        self.storeJustificationIDList =  Common.returndefaultarray(dic: dict, keyvalue: "StoreJustificationIDList") as? [StoreJustification]
        return self
    }
    
    
}
