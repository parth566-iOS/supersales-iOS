//
//  SelectedProduct.swift
//  SuperSales
//
//  Created by Apple on 01/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class SelectedProduct: NSObject {
    var productName:String?
    var subCategoryName:String?
    var categoryName:String?
    var productID:NSNumber?
    var productCatId:NSNumber?
    var productSubCatId:NSNumber?
//    var quantity:NSNumber?
//    var budget:NSNumber?
    var quantity:String? = "0.0"
    var budget:String? 
    var salesDiscount:String? = "0.0"
    var price:String? = "0.0"
    var maxdiscount:String? = "0.0"
    var leadId:String?
    
    //SalesOrder
    var taxType = ""
    var CGSTTax: Double = 0.0
    var SGSTTax: Double = 0.0
    var IGSTTax: Double = 0.0
    var disType: Int8? = 0
    var disInPerVal: Int8? = 0
    var customerClass: Int = 1
    var disA: Float = 0.0
    var disB: Float = 0.0
    var disC: Float = 0.0
    var isAllow: Bool = false
    var isFirstStep: Bool = false
    var isFOC: Bool = false
    var isVat: Bool = false
    var vatID: Int16? = 0
    var vATFrom: String? = ""
    var focQuantity: Int64 = 0
    var proDis: Double = 0.0
    var proAmt: Double = 0.0
    var proAftDisAmt: Double = 0.0
    var isExpand: Bool = false
    var isInclusive: String? = nil
    var netAmt: Double = 0.0
    var vATPercentage: Float = 0.0
    var proTax: Double = 0.0

   // var id:NSNumber?
    func initwithdic(dict:[String:Any])->SelectedProduct{
        self.productID = Common.returndefaultnsnumber(dic: dict, keyvalue: "ProductID")//ProductID
        self.productName = Common.returndefaultstring(dic: dict, keyvalue: "productName")
        self.categoryName = Common.returndefaultstring(dic: dict, keyvalue: "CategoryName")
        self.subCategoryName = Common.returndefaultstring(dic: dict, keyvalue: "SubCategoryName")
        if(self.productName?.count ?? 0 == 0){
           
            if(self.productID as? Int ?? 0 > 0){
                self.productName = Product.getProductName(productID: self.productID ?? 0)
              
            }
        }
       
        self.productCatId = Common.returndefaultnsnumber(dic: dict, keyvalue: "CategoryID")
        self.productSubCatId = Common.returndefaultnsnumber(dic: dict, keyvalue: "SubCategoryID")//SubCategoryID
        self.quantity = Common.returndefaultstring(dic: dict, keyvalue: "Quantity")
        self.budget = Common.returndefaultstring(dic: dict, keyvalue: "Budget")//Budget
        if(self.quantity == "0" || self.quantity == ""){
            let nsnumberquantity = dict["Quantity"] as? NSNumber ?? NSNumber.init(value: 0) 
            self.quantity = nsnumberquantity.stringValue
        }
        if(self.budget == "0" || self.budget == ""){
            let nsnumberbudget = dict["Budget"] as? NSNumber ?? NSNumber.init(value: 0)
            self.budget = nsnumberbudget.stringValue
        }
//        self.budget = Common.returndefaultnsnumber(dic: dict, keyvalue: "Budget")
//        self.quantity = Common.returndefaultnsnumber(dic: dict, keyvalue: "Quantity")
        self.salesDiscount = Common.returndefaultstring(dic: dict, keyvalue: "salesDiscount")
        self.price = Common.returndefaultstring(dic: dict, keyvalue: "Price")
        self.maxdiscount = Common.returndefaultstring(dic: dict, keyvalue: "Maxdiscount")
        self.leadId = Common.returndefaultstring(dic: dict, keyvalue: "LeadID")
        return self
    }
    func toDictionary()->[String:Any]{
        var dic = [String:Any]()
        dic["productName"] = self.productName ?? ""
        dic["ProductID"] = self.productID ?? 0
        if(self.productCatId == 0){
            dic["CategoryID"] = NSNumber.init(value:0)
        }else{
            dic["CategoryID"] = self.productCatId
            
        }
        if(self.productSubCatId == 0){
            dic["SubCategoryID"] = NSNumber.init(value:0)
        }else{
            dic["SubCategoryID"] = self.productSubCatId
            
        }
        if(self.quantity?.count == 0){
           dic["Quantity"] = "0"
        }else{
            dic["Quantity"] = self.quantity

        }
//        if(self.quantity == 0){
//           dic["Quantity"] = 0
//        }else{
//            dic["Quantity"] = self.quantity
//
//        }
//        if(self.budget == 0){
//           dic["Budget"] = 0
//        }else{
//            dic["Budget"] = self.budget
//
//        }
        if(self.budget?.count == 0){
           dic["Budget"] = "0"
        }else{
            dic["Budget"] = self.budget

        }
        if(self.salesDiscount?.count == 0){
                  dic["salesDiscount"] = "0"
               }else{
        dic["salesDiscount"] = self.salesDiscount
        }
        if(self.price?.count == 0){
                         dic["Price"] = "0"
                      }else{
        dic["Price"] =  self.price
        }
        if(self.maxdiscount?.count == 0){
        dic["Maxdiscount"] = "0"
        }else{
        dic["Maxdiscount"] = self.maxdiscount
        }
        if(self.leadId?.count == 0){
        dic["LeadId"] = "0"
        }else{
        dic["LeadId"] = self.leadId
        }
        return dic
    }
}
