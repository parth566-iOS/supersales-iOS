//
//  VisitStock.swift
//  SuperSales
//
//  Created by Apple on 26/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class VisitStock: NSObject {
//    ID: 88433,
//    VisitID: 1918051,
//    visitSeriesPostfix: 0,
//    StockDate: "2020/03/26 00:00:00",
//    ProductID: 63428,
//    ProductName: "bed",
//    Quantity: 23,
//    CreatedBy: 13839,
//    CompanyID: 0,
//    CreatedByName: "krishna manager"
     var iD:NSNumber?
     var visitID:NSNumber?
     var visitSeriesPostfix:NSNumber?
     var stockDate:String?
     var productID:NSNumber?
     var productName:String?
     var quantity:NSNumber?
     var createdBy:NSNumber?
     var companyID:NSNumber?
     var createdByName:String?
    
    func initwithdic(dict:[String:Any])->VisitStock{
        self.iD = Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
        self.visitID = Common.returndefaultnsnumber(dic: dict, keyvalue: "VisitID")
        self.visitSeriesPostfix = Common.returndefaultnsnumber(dic: dict, keyvalue: "visitSeriesPostfix")
        self.productID = Common.returndefaultnsnumber(dic: dict, keyvalue: "ProductID")
        self.quantity = Common.returndefaultnsnumber(dic: dict, keyvalue: "Quantity")
        self.createdBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "CreatedBy")
        self.companyID = Common.returndefaultnsnumber(dic: dict, keyvalue: "CompanyID")
        self.stockDate = Common.returndefaultstring(dic: dict, keyvalue: "StockDate")
        self.productName =  Common.returndefaultstring(dic: dict, keyvalue: "ProductName")
        self.createdByName = Common.returndefaultstring(dic: dict, keyvalue: "CreatedByName")
        return self
    }
}
struct CategoryReport{
    var categoryID:NSNumber!
    var categoryName:String!
    
    mutating func initCatrgoryWithDic(dic:[String:Any])->CategoryReport{
        self.categoryID = Common.returndefaultnsnumber(dic: dic, keyvalue: "categoryID")
        self.categoryName = Common.returndefaultstring(dic: dic, keyvalue: "categoryName")
        return self
    }
}
struct CategoryDocument{
    var createdTime:String!
    var createdByName:String!
    var companyID:NSNumber!
    var categoryName:String!
    var isActive:NSNumber!
    var lastModifiedBy:NSNumber!
    var lastModified:String!
    var categoryID:NSNumber!
    var createdBy:NSNumber!
    var applicationID:NSNumber!
    
    
    mutating func initCategoryDocument(dic:[String:Any])->CategoryDocument{
        self.createdTime = Common.returndefaultstring(dic: dic, keyvalue: "createdTime")
        self.createdByName = Common.returndefaultstring(dic: dic, keyvalue: "createdByName")
        self.companyID = Common.returndefaultnsnumber(dic: dic, keyvalue: "companyID")
        self.categoryName = Common.returndefaultstring(dic: dic, keyvalue: "categoryName")
        self.isActive = Common.returndefaultnsnumber(dic: dic, keyvalue: "isActive")
        self.lastModifiedBy = Common.returndefaultnsnumber(dic: dic, keyvalue: "lastModifiedBy")
        self.lastModified = Common.returndefaultstring(dic: dic, keyvalue: "lastModified")
        self.categoryID = Common.returndefaultnsnumber(dic: dic, keyvalue: "categoryID")
        self.createdBy = Common.returndefaultnsnumber(dic: dic, keyvalue: "createdBy")
        self.applicationID = Common.returndefaultnsnumber(dic: dic, keyvalue: "applicationID")
      

     
       
       
        


        
       
        
  
       
        return self
    }
    /*
     ["createdTime": 2020/03/27 03:48:42, "createdByName": Deepak Shah ., "companyID": 1198, "categoryName": SuperSales Training Video, "isActive": 1, "lastModifiedBy": 8830, "lastModified": 2020/03/28 11:33:50, "categoryID": 87, "createdBy": 8830, "applicationID": 2]
     
     **/
}
struct Document{
    var documentID:NSNumber!
    var companyID:NSNumber!
    var applicationID:NSNumber!
    var categoryID:NSNumber!
    var accessToAll:NSNumber!
    var isQuizAvailable:NSNumber!
    var createdBy:NSNumber!
    var lastModifiedBy:NSNumber!
    var isActive:NSNumber!
    var userDocumentView:NSNumber!
    var documentUrl:String!
    var createdTime:String!
    var lastModified:String!
    var createdByName:String!
    var title:String!
    var categoryName:String!
    
    mutating func initDocumentWithDic(dic:[String:Any])->Document{
        self.categoryID = Common.returndefaultnsnumber(dic: dic, keyvalue: "categoryID")
        self.documentID = Common.returndefaultnsnumber(dic: dic, keyvalue: "documentID")
        self.companyID = Common.returndefaultnsnumber(dic: dic, keyvalue: "companyID")
        self.applicationID = Common.returndefaultnsnumber(dic: dic, keyvalue: "applicationID")
        self.categoryID = Common.returndefaultnsnumber(dic: dic, keyvalue: "categoryID")
        self.accessToAll = Common.returndefaultnsnumber(dic: dic, keyvalue: "accessToAll")
        self.isQuizAvailable = Common.returndefaultnsnumber(dic: dic, keyvalue: "isQuizAvailable")
        self.createdBy = Common.returndefaultnsnumber(dic: dic, keyvalue: "createdBy")
        self.lastModifiedBy = Common.returndefaultnsnumber(dic: dic, keyvalue: "lastModifiedBy")
        self.isActive = Common.returndefaultnsnumber(dic: dic, keyvalue: "isActive")
        self.userDocumentView = Common.returndefaultnsnumber(dic: dic, keyvalue: "userDocumentView")
        self.documentUrl = Common.returndefaultstring(dic: dic, keyvalue: "documentUrl")
        self.createdTime = Common.returndefaultstring(dic: dic, keyvalue: "createdTime")
        self.lastModified = Common.returndefaultstring(dic: dic, keyvalue: "lastModified")
        self.createdByName = Common.returndefaultstring(dic: dic, keyvalue: "createdByName")
        self.title = Common.returndefaultstring(dic: dic, keyvalue: "title")
        self.categoryName = Common.returndefaultstring(dic: dic, keyvalue: "categoryName")
        return self
    }
    
}
