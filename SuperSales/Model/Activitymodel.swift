//
//  Activity.swift
//  SuperSales
//
//  Created by Apple on 05/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
//import AddressDetails

class Activitymodel: NSObject {
    var activityTypeID:Int?
    var activityTypeName:String?
    var addressMasterID:Int?
    var checkInTime:String?
    var checkOutTime:String?
    var companyID:Int?
    var createdBy:Int?
    var createdTime:String?
    var activitydescription:String?
    var ID:Int?
    var isActive:Bool!
    var modifiedBy:NSInteger!
    var nextActionTime:String!
    var noOfParticipants:NSNumber!
    var originalNextActionTime:String!
    var lastModifiedTime:String!
    var picture1:String!
    var picture2:String!
    var picture3:String!
    var picture4:String!
    var picture5:String!
    var statusDescription:String!
    var imageLattitude:String!
    var imageLongitude:String!
    var imageTimeStamp:String!
    var addressDetails:AddressDetails!
    var activityCheckInCheckOutList:[ActivityCheckInOutModel]!
    var checkInOutLattitude:NSNumber!
    var customerID:NSNumber!
    
//    @property(nonatomic) NSString *ActivityTypeName;
//    @property (nonatomic) NSInteger AddressMasterID;
//    @property(nonatomic) NSString<Optional> *CheckInTime;
//    @property(nonatomic) NSString<Optional> *CheckOutTime;
//    @property(nonatomic) NSInteger CompanyID;
//    @property(nonatomic) NSInteger CreatedBy;
//    @property (nonatomic) NSString *CreatedTime;
//    @property(nonatomic) NSString<Optional> *Description;
//    @property(nonatomic) NSInteger ID;
//    @property(nonatomic) BOOL IsActive;
//    @property(nonatomic) NSString *LastModifiedTime;
//    @property(nonatomic) NSInteger ModifiedBy;
//    @property(nonatomic) NSString *NextActionTime;
//    @property(nonatomic) NSInteger NoOfParticipants;
//    @property(nonatomic) NSString *OriginalNextActionTime;
//    @property(nonatomic) NSString *Picture1;
//    @property(nonatomic) NSString *Picture2;
//    @property(nonatomic) NSString *Picture3;
//    @property(nonatomic) NSString *Picture4;
//    @property(nonatomic) NSString *Picture5;
//    @property(nonatomic) NSString<Optional> *StatusDescription;
//    @property(nonatomic) NSString<Optional> *ImageLattitude;
//    @property(nonatomic) NSString<Optional> *ImageLongitude;
//    @property(nonatomic) NSString<Optional> *ImageTimeStamp;
//    
//    @property(nonatomic) AddressDetails *AddressDetails;
//    @property(nonatomic) NSMutableArray<ActivityCheckInOutModel *><Optional> *ActivityCheckInCheckOutList;
    
    func initwithdic(dict:[String:Any])->Activitymodel{
        self.ID = Common.returndefaultInteger(dic: dict, keyvalue: "ID")
        self.companyID = Common.returndefaultInteger(dic: dict , keyvalue: "CompanyID")
        self.activityTypeID = Common.returndefaultInteger(dic: dict, keyvalue: "ActivityTypeID")
        self.activityTypeName = Common.returndefaultstring(dic: dict, keyvalue: "ActivityTypeName")
        self.createdTime = Common.returndefaultstring(dic: dict, keyvalue: "CreatedTime")
        self.addressMasterID = Common.returndefaultInteger(dic: dict, keyvalue: "AddressMasterID")
        self.activitydescription = Common.returndefaultstring(dic: dict, keyvalue: "Description")
        self.checkInTime = Common.returndefaultstring(dic: dict, keyvalue: "CheckInTime")
        self.checkOutTime = Common.returndefaultstring(dic: dict, keyvalue: "CheckOutTime")
        self.nextActionTime = Common.returndefaultstring(dic: dict, keyvalue: "NextActionTime")
        self.originalNextActionTime = Common.returndefaultstring(dic: dict, keyvalue: "OriginalNextActionTime")
        self.noOfParticipants = Common.returndefaultnsnumber(dic: dict, keyvalue: "NoOfParticipants")
        self.customerID = Common.returndefaultnsnumber(dic: dict, keyvalue: "customerID")
        self.picture1 = Common.returndefaultstring(dic: dict, keyvalue: "Picture1")
        self.picture2 = Common.returndefaultstring(dic: dict, keyvalue: "Picture2")
        self.picture3 = Common.returndefaultstring(dic: dict, keyvalue: "Picture3")
        self.picture4 = Common.returndefaultstring(dic: dict, keyvalue: "Picture4")
        //(dic: dict, keyvalue: "Picture4")
        self.picture5 = Common.returndefaultstring(dic: dict, keyvalue: "Picture5")
        self.statusDescription = Common.returndefaultstring(dic: dict, keyvalue: "StatusDescription")
        let dicOfAddressActivity = dict["AddressDetails"] as? [String:Any] ?? [String:Any]()
        self.addressDetails = AddressDetails().initWithdic(dict: dicOfAddressActivity)
//        if(arrOfAddresslist?.count ?? 0 > 0){
//            for i in 0...((arrOfAddresslist?.count  ?? 0) - 1){
//                if  let dicactivitycheckin = arrOfAddresslist?[i]{
//                    let activityadd = AddressDetails().initWithdic(dict: dicactivitycheckin)//ActivityCheckInOutModel().initwithdic(dict: dicactivitycheckin)
//                self.addressDetails.append(activityadd)
//                }
//            }
//        }
        let arrOfCheckinlist = dict["ActivityCheckInCheckOutList"] as? [[String:Any]]
        self.activityCheckInCheckOutList = [ActivityCheckInOutModel]()
        if(arrOfCheckinlist?.count ?? 0 > 0){
            for i in 0...((arrOfCheckinlist?.count  ?? 0) - 1){
                if  let dicactivitycheckin = arrOfCheckinlist?[i]{
                let activitycheckin = ActivityCheckInOutModel().initwithdic(dict: dicactivitycheckin)
                self.activityCheckInCheckOutList.append(activitycheckin)
                }
            }
        }
        return self
}

}
struct ActivityType {

    var activityType:String
    var activityTypeIndex:NSNumber
    var companyId:NSNumber
    var createdBy:NSNumber
    var activityId:NSNumber
    
    
    mutating func setdata(activityId:NSNumber,companyId:NSNumber,index:NSNumber,activitytype:String,createdby:NSNumber)->ActivityType{
        var dic = [String:Any]()
        dic["ID"]  = activityId
        dic["ActivityType"] = activitytype
        dic["ActivityTypeIndex"] =  index
        dic["CompanyID"] = companyId
        dic["CreatedBy"] = createdby
        self.activityId = Common.returndefaultnsnumber(dic: dic, keyvalue: "ID")
        self.activityType = Common.returndefaultstring(dic: dic, keyvalue: "ActivityType")
        self.activityTypeIndex = Common.returndefaultnsnumber(dic: dic, keyvalue: "ActivityTypeIndex")
        self.companyId =  Common.returndefaultnsnumber(dic: dic, keyvalue: "CompanyID")
        self.createdBy = Common.returndefaultnsnumber(dic: dic, keyvalue: "CreatedBy")
        return self
    }
    
}
