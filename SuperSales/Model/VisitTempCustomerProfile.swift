//
//  VisitTempCustomerProfile.swift
//  SuperSales
//
//  Created by Apple on 20/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class VisitTempCustomerProfile: NSObject {
 
    var iD:NSNumber?
    var companyProductValue:NSNumber?
    var companySegmentProductValue:NSNumber?
    var competitor1:String?
    var competitor2:String?
    var createdBy:NSNumber?
    var interestedinCompanyProduct:Bool?
    var sellingCompanyProduct:Bool?
    var sellingCompanySegmentProduct:Bool?
    var tempCustomerID:NSNumber?
    var interestedinCompanySegmentProduct:Bool?
    var orderExpectedDate:String?
    var subCategoryShareList:[SubCategoryShare]?
    
    func initwithdic(dict:[String:Any]) -> VisitTempCustomerProfile {
        self.iD = Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
        self.companyProductValue = Common.returndefaultnsnumber(dic: dict, keyvalue: "companyProductValue")
        self.companySegmentProductValue = Common.returndefaultnsnumber(dic: dict, keyvalue: "companySegmentProductValue")
        self.competitor1 = Common.returndefaultstring(dic: dict, keyvalue: "competitor1")
         self.competitor2 = Common.returndefaultstring(dic: dict, keyvalue: "competitor2")
        self.createdBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "createdBy")
        self.interestedinCompanyProduct = Common.returndefaultbool(dic: dict, keyvalue: "interestedinCompanyProduct")
        self.interestedinCompanySegmentProduct = Common.returndefaultbool(dic: dict, keyvalue: "interestedinCompanySegmentProduct")
        self.orderExpectedDate = Common.returndefaultstring(dic: dict, keyvalue: "orderExpectedDate")
        self.sellingCompanyProduct = Common.returndefaultbool(dic: dict, keyvalue: "sellingCompanyProduct")
        self.sellingCompanySegmentProduct = Common.returndefaultbool(dic: dict, keyvalue: "sellingCompanySegmentProduct")
        self.tempCustomerID = Common.returndefaultnsnumber(dic: dict, keyvalue: "TempCustomerID")
        var arrSubCatshareList = [SubCategoryShare]()
        let arrOfSubCatshareList =  Common.returndefaultdictionary(dic: dict, keyvalue: "subCategoryShareList")
        if(arrOfSubCatshareList.count > 0){
            
            for (key, value) in arrOfSubCatshareList{
                let status = SubCategoryShare().initwithdic(dict: [key:value])
                arrSubCatshareList.append(status)
            }
        }
        self.subCategoryShareList = arrSubCatshareList
        return self
    }

}
