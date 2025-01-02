//
//  UserExpense.swift
//  SuperSales
//
//  Created by Apple on 07/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
//import EVReflection

class UserExpense: NSObject {
    var startDate:String!
    var endDate:String!
    var fromLocation:String!
    var toLocation:String!
    var totalExpenseRequested:NSNumber!
    var createdOn:String!
    var companyID:NSNumber!
    var expenseId:NSNumber!
    var totalExpenseApproved:NSNumber?
    var requesterComment:String!
    var approvedBy:Manager!
    var lastUpdatedBy:NSNumber!
    var lastUpdated:String!
    var customerName:String!
    var customerID:NSNumber!
    var transactionID:String!
    var user:DataUser!
    var status:String!
    var expenseDetailsList:[Expense]!
    var approverComment:String! = ""
    
    func initwithdic(dict:[String:Any]) -> UserExpense {
        self.expenseId = Common.returndefaultnsnumber(dic: dict, keyvalue: "expenseId")
        self.transactionID = Common.returndefaultstring(dic: dict, keyvalue: "transactionID")
        self.customerID = Common.returndefaultnsnumber(dic: dict, keyvalue: "customerID")
        self.startDate = Common.returndefaultstring(dic: dict, keyvalue: "startDate")
         self.endDate = Common.returndefaultstring(dic: dict, keyvalue: "endDate")
        self.fromLocation = Common.returndefaultstring(dic: dict, keyvalue: "fromLocation")
         self.toLocation = Common.returndefaultstring(dic: dict, keyvalue: "toLocation")
        self.totalExpenseApproved = Common.returndefaultnsnumber(dic: dict, keyvalue: "totalExpenseApproved")
        self.requesterComment = Common.returndefaultstring(dic: dict, keyvalue: "requesterComment")
        self.totalExpenseRequested = Common.returndefaultnsnumber(dic: dict, keyvalue: "totalExpenseRequested")
         self.lastUpdatedBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "lastUpdatedBy")
        self.lastUpdated = Common.returndefaultstring(dic: dict, keyvalue: "lastUpdated")
        self.customerName = Common.returndefaultstring(dic: dict, keyvalue: "CustomerName")
        self.customerID = Common.returndefaultnsnumber(dic: dict, keyvalue: "CustomerID")
        self.status = Common.returndefaultstring(dic: dict, keyvalue: "status")
        self.approverComment = Common.returndefaultstring(dic: dict, keyvalue: "approverComment")
      //  ""
        self.approvedBy = Manager.init(dictionary: dict["approvedBy"] as? [String : Any] ?? [String:Any]())
        self.user = DataUser.init(dictionary: dict["user"] as? [String:Any] ?? [String:Any]())
       //expenseDetailsList
        var expenseDetailsList = [Expense]()
        let arrOfexpenseDetailsList =  Common.returndefaultarray(dic: dict, keyvalue: "expenseDetailsList")
        if(arrOfexpenseDetailsList.count > 0){
            for dic in arrOfexpenseDetailsList{
//            for (key, value) in arrOfexpenseDetailsList{
                let status = Expense().initwithdic(dict: dic as? [String : Any] ?? [String:Any]())
                expenseDetailsList.append(status)
            }
        }
        self.expenseDetailsList = expenseDetailsList
        return self
    }

}
