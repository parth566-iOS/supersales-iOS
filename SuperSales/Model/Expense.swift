//
//  Expense.swift
//  SuperSales
//
//  Created by Apple on 07/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
//import EVReflection

class Expense: NSObject {
    var iD:NSNumber! 
    var userID:NSNumber!
    var billNo:String!
    var expenseType:String!
    var amountApproved:NSNumber!
    var amountRequested:NSNumber!
    var billAttachmentPath:String!
    var bilDate:String!
    var remark:String!
    
    func initwithdic(dict:[String:Any]) -> Expense {
        self.iD =  Common.returndefaultnsnumber(dic: dict, keyvalue: "id")
        self.userID = Common.returndefaultnsnumber(dic: dict, keyvalue: "userID")
        self.billNo = Common.returndefaultstring(dic: dict, keyvalue: "billNo")
        self.bilDate = Common.returndefaultstring(dic: dict, keyvalue: "billDate")
        self.expenseType = Common.returndefaultstring(dic: dict, keyvalue: "expenseType")
        self.amountApproved = Common.returndefaultnsnumber(dic: dict, keyvalue: "amountApproved")
        self.amountRequested = Common.returndefaultnsnumber(dic: dict, keyvalue: "amountRequested")
        self.billAttachmentPath = Common.returndefaultstring(dic: dict, keyvalue: "billAttachmentPath")
        self.remark = Common.returndefaultstring(dic: dict, keyvalue: "remarks")
        return self
    }
}
