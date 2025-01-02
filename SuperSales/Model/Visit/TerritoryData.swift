//
//  TerritoryData.swift
//  SuperSales
//
//  Created by Apple on 27/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class TerritoryData: NSObject {
//    @property(nonatomic,assign)int companyID;
//    @property(nonatomic,assign)int createdBy;
//    @property(nonatomic,strong)NSString *createdByName;
//    @property(nonatomic,strong)NSString *createdTime;
//    @property(nonatomic,strong)NSString *endDate;
//    @property(nonatomic,assign)int iD;
//    @property(nonatomic,strong)NSString *startDate;
//    @property(nonatomic,assign)int visitID;
    
    var ID:NSNumber?
    var visitID:NSNumber?
    var companyID:NSNumber?
    var createdBy:NSNumber?
    var createdByName:String?
    var createdTime:String?
    var endDate:String?
    var startDate:String?
    var aryTertiaryProductList:[TertiaryProductList]? =  [TertiaryProductList]()

    func initwithdic(dict:[String:Any])->TerritoryData{
        self.ID = Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
        self.visitID = Common.returndefaultnsnumber(dic: dict, keyvalue: "VisitID")
        self.companyID = Common.returndefaultnsnumber(dic: dict, keyvalue: "CompanyID")
        self.createdBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "CreatedBy")
        self.createdByName = Common.returndefaultstring(dic: dict, keyvalue: "CreatedByName")
        self.createdTime = Common.returndefaultstring(dic: dict, keyvalue: "CreatedTime")
        self.endDate = Common.returndefaultstring(dic: dict, keyvalue: "EndDate")
        self.startDate = Common.returndefaultstring(dic: dict, keyvalue: "StartDate")
        let arrProduct =  Common.returndefaultarray(dic: dict , keyvalue: "tertiaryProductList")
        var arrtProduct = [TertiaryProductList]()
        for product in arrProduct{
            let prod = TertiaryProductList().initwithdic(dict: product as! [String : Any])
            
            arrtProduct.append(prod)
        }
        self.aryTertiaryProductList =  arrtProduct
        return self
    }
}
