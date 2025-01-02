//
//  ManagerHierachy.swift
//  SuperSales
//
//  Created by Apple on 10/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import Foundation
class ManagerHierachy: NSObject {
    
/*
 {
"Address_Verified" = 0;
ApplicationID = 0;
CompanyID = 0;
CountryCode = "+91";
DeviceType = 0;
DottedManagerID = 0;
EmailID = "";
EmailVerified = 0;
FirstName = Ashok;
Gender = M;
IsAllowApproveLeave = 1;
IsCheckInAllowedFromHome = 0;
IsFreeze = 0;
LastModifiedBy = 0;
LastName = Verma;
MobileNo1 = 9999991002;
MobileNo2 = 9999991002;
UserID = 8831;
basetowncityID = 0;
branchAddress =             {
 AddressID = 966264;
 AddressLine1 = "Friends Colony Babhai Naka Borivali";
 AddressLine2 = Mumbai;
 City = "Mumbai Suburban";
 Country = India;
 CustVenID = 0;
 LastModifiedBy = 0;
 Lattitude = "19.0759837";
 Longitude = "72.87765590000004";
 Pincode = 400070;
 State = Maharashtra;
 Verified = 0;
};
branchID = 539;
branchName = "Mumbai Branch";
confirmationDate = "2018/04/01 00:00:00";
customerOnline = 0;
departmentID = 109;
departmentName = department;
designationID = 0;
employeeCode = "";
gradelevelID = 0;
invalidLoginAttempt = 0;
isGeoFencing = 0;
isUserRelationshipManager = 0;
onlyBranchOrCompany = 0;
permAddressID = 0;
picture = "http://bigbangcommonservice.info:8080/mnt/data/pictures/883160cb24a33f537-1623925923latin_a.png";
role =             {
 applicationID = 2;
 desc = admin;
 id = 6;
};
roleId = 0;
tempAddressID = 0;
}
 
 **/
    
    var addressverified:Bool?
    var userID:NSNumber!
    var applicationID:NSNumber!
    var companyID:NSNumber!
    var countryCode :String?
    var role: Role?
    var picture:String?
    var firstName:String?
    var lastName:String?
    var mobileNo1:String?
    var email:String?
    
    
    func initwithdic(dict:[String:Any])->ManagerHierachy{
        self.addressverified = Common.returndefaultbool(dic: dict, keyvalue: "Address_Verified")
        self.userID = Common.returndefaultnsnumber(dic: dict, keyvalue: "UserID")
        self.applicationID =  Common.returndefaultnsnumber(dic: dict, keyvalue: "ApplicationID")
       
        self.companyID = Common.returndefaultnsnumber(dic: dict, keyvalue: "CompanyID")
        self.countryCode = Common.returndefaultstring(dic: dict, keyvalue: "CountryCode")
        self.picture = Common.returndefaultstring(dic: dict, keyvalue: "picture")
        self.firstName = Common.returndefaultstring(dic: dict, keyvalue: "FirstName")
        self.lastName = Common.returndefaultstring(dic: dict, keyvalue: "LastName")
        self.mobileNo1 = Common.returndefaultstring(dic: dict, keyvalue: "MobileNo1")
        self.email = Common.returndefaultstring(dic: dict, keyvalue: "EmailID")
        self.role =   Role.init(dictionary: Common.returndefaultdictionary(dic:dict,keyvalue: "role"))
       
 
        return self
    }
    
    
}
