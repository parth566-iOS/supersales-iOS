//
//  Notification.swift
//  SuperSales
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class Notificationmodel: NSObject {
    
    
    var companyID:Int!
    var iD:NSNumber!
    var lastModified:String!
    var notified:Bool!
    var status:Int!
    var transactionID:String!
    var type:Int!
    var userID:Int!
    var isShelf:Int!
    var message:String!
    var data:NotificationData!
    var data1:[String:Any]!
    var isAddressFromHere:Bool!
//    var userLattitude:String?
//    var userLongitude:String?
    var userLattitude:NSNumber!
    var userLongitude:NSNumber!
    var customerLattitude:NSNumber!
    var customerLongitude:NSNumber!
    
    func initwithdic(dict:[String:Any])->Notificationmodel{
 self.companyID = Common.returndefaultInteger(dic: dict, keyvalue: "CompanyID")
 self.iD =  Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
 self.lastModified =  Common.returndefaultstring(dic: dict, keyvalue: "LastModified")
 self.notified =  Common.returndefaultbool(dic: dict, keyvalue: "Notified")
 self.status =  Common.returndefaultInteger(dic: dict, keyvalue: "Status")
 self.transactionID =  Common.returndefaultstring(dic: dict, keyvalue: "TransactionID")
 self.type = Common.returndefaultInteger(dic: dict, keyvalue: "Type")
 self.userID = Common.returndefaultInteger(dic: dict, keyvalue: "UserID")
 self.isShelf =  Common.returndefaultInteger(dic: dict, keyvalue: "isShelf")
 self.message = Common.returndefaultstring(dic: dict, keyvalue: "message")
 self.data = NotificationData().initwithdic(dict: Common.returndefaultdictionary(dic: dict, keyvalue: "data"))
 self.data1 = Common.returndefaultdictionary(dic: dict, keyvalue: "data")
 self.isAddressFromHere =  Common.returndefaultbool(dic: dict, keyvalue: "isAddressFromHere")
 self.userLattitude =  Common.returndefaultnsnumber(dic: dict, keyvalue: "UserLattitude")
 self.userLongitude =  Common.returndefaultnsnumber(dic: dict, keyvalue: "UserLongitude")
 self.customerLattitude =  Common.returndefaultnsnumber(dic: dict, keyvalue: "CustomerLattitude")
 self.customerLongitude =  Common.returndefaultnsnumber(dic: dict, keyvalue: "CustomerLongitude")
 
 return self
    }
}
