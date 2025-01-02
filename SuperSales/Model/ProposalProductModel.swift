//
//  ProposalProduct.swift
//  
//
//  Created by Apple on 03/04/21.
//
import UIKit

class ProposalProductModel: NSObject {
    var CGSTSurcharges:NSNumber!
    var CGSTTax:NSNumber!
    var CST:NSNumber!
    var CSTSurcharge:NSNumber!
    var CategoryType:NSNumber!
    var Discount:NSNumber!
    var ExciseDuty:NSNumber!
    var ExciseSurcharge:NSNumber!
    var GSTEnabled:NSNumber!
    var IGSTSurcharges:NSNumber!
    var IGSTTax:NSNumber!
    var  Price:NSNumber!
    var ProductAmount:NSNumber!
    var ProductID:NSNumber!
    var ProposalID:NSNumber!
    var Quantity:NSNumber!
    var Name:String!
    var SGSTSurcharges:NSNumber!
    var SGSTTax:NSNumber!
    var ServiceTax:NSNumber!
    var ServiceTaxSurcharge:NSNumber!
    var  VAT:NSNumber!
    var VATAdditionalTax:NSNumber!
  
    var VATSurcharge:NSNumber!
   
    
    func initWithdict(dic:[String:Any])->ProposalProductModel{
        self.CGSTSurcharges = Common.returndefaultnsnumber(dic: dic, keyvalue: "CGSTSurcharges")
        self.CGSTTax = Common.returndefaultnsnumber(dic: dic, keyvalue: "CGSTTax")
        self.CST = Common.returndefaultnsnumber(dic: dic, keyvalue: "CST")
        self.CSTSurcharge = Common.returndefaultnsnumber(dic: dic, keyvalue: "CSTSurcharge")
        self.CategoryType = Common.returndefaultnsnumber(dic: dic, keyvalue: "CategoryType")
        self.Discount = Common.returndefaultnsnumber(dic: dic, keyvalue: "Discount")
        self.ExciseDuty = Common.returndefaultnsnumber(dic: dic, keyvalue: "ExciseDuty")
        self.ExciseSurcharge = Common.returndefaultnsnumber(dic: dic, keyvalue: "ExciseSurcharge")
        self.Name = Common.returndefaultstring(dic: dic, keyvalue: "Name")
        self.GSTEnabled = Common.returndefaultnsnumber(dic: dic, keyvalue: "GSTEnabled")
        self.IGSTSurcharges = Common.returndefaultnsnumber(dic: dic, keyvalue: "IGSTSurcharges")
        self.IGSTTax = Common.returndefaultnsnumber(dic: dic, keyvalue: "IGSTTax")
        self.GSTEnabled = Common.returndefaultnsnumber(dic: dic, keyvalue: "GSTEnabled")
        self.Price = Common.returndefaultnsnumber(dic: dic, keyvalue: "Price")
        self.ProductAmount = Common.returndefaultnsnumber(dic: dic, keyvalue: "ProductAmount")
        self.ProductID = Common.returndefaultnsnumber(dic: dic, keyvalue: "ProductID")
        self.ProposalID = Common.returndefaultnsnumber(dic: dic, keyvalue: "ProposalID")
        self.Quantity = Common.returndefaultnsnumber(dic: dic, keyvalue: "Quantity")
        self.SGSTSurcharges = Common.returndefaultnsnumber(dic: dic, keyvalue: "SGSTSurcharges")
        self.SGSTTax = Common.returndefaultnsnumber(dic: dic, keyvalue: "SGSTTax")
        self.ServiceTax = Common.returndefaultnsnumber(dic: dic, keyvalue: "ServiceTax")
        self.ServiceTaxSurcharge = Common.returndefaultnsnumber(dic: dic, keyvalue: "ServiceTaxSurcharge")
        self.VAT = Common.returndefaultnsnumber(dic: dic, keyvalue: "VAT")
        self.VATAdditionalTax = Common.returndefaultnsnumber(dic: dic, keyvalue: "VATAdditionalTax")
      
        self.VATSurcharge = Common.returndefaultnsnumber(dic: dic, keyvalue: "VATSurcharge")
      
        return self
    }
}

class Movementmodel:NSObject{
    /*
     IsManual = 0;
     KM = 0;
     LastCheckOutKM = 0;
     checkInCustomerName = "Office CheckIn";
     checkInLatitude = "23.0123724";
     checkInLongitude = "72.51137780000001";
     checkInTime = "2021/04/01 04:45:01";
     checkOutAddress = "";
     checkOutCustomerName = "";
     checkOutLangitude = 0;
     checkOutLatitude = 0;
     chekInAddress = "Prahlad Nagar Chinar Bungalows Prahlad Nagar Chinar Bungalows Prahlad Nagar, \nAhmedabad, \nAhmedabad, \nGujarat, \nIndia";
     companyID = 1198;
     customerID = 0;
     description = "";
     detailType = 1;
     isFeedBackAvailable = 0;
     isPictureAvailable = 0;
     isStockAvailable = 0;
     isTertiaryAvailable = 0;
     kms = 0;
     lastKms = 0;
     moduleID = 0;
     modulePrimaryID = 0;
     movementDate = "2021/04/01 00:00:00";
     nextActionID = 0;
     outcome = "";
     userID = 8834;
     **/
    var ismanual:Bool!
    var km:NSNumber!
    var lastCheckOutKM:NSNumber!
    var checkInCustomerName:String!
    var checkInLatitude:NSNumber!
    var checkInLongitude:NSNumber!
    var checkInTime:String!
    var checkOutTime:String!
    var checkOutAddress:String!
    var checkOutCustomerName:String!
    var checkOutLongitude:NSNumber!
    var checkOutLatitude:NSNumber!
    var chekInAddress:String!
    var companyID:NSNumber!
    var customerID:NSNumber!
    var prodescription:String!
    var detailType:NSNumber!
    var isFeedBackAvailable:Bool!
    var isPictureAvailable:Bool!
    var isStockAvailable:Bool!
    var isTertiaryAvailable:Bool!
    var kms:NSNumber!
    var lastKms:NSNumber!
    var moduleID:NSNumber!
    var modulePrimaryID:NSNumber!
    var movementDate:String!
    var nextActionID:NSNumber!
    var outcome:String!
    var userID:NSNumber!
    
     func initWithdict(dic:[String:Any])->Movementmodel{
        self.ismanual = Common.returndefaultbool(dic: dic, keyvalue: "ismanual")
         self.moduleID = Common.returndefaultnsnumber(dic: dic, keyvalue: "moduleID")
         self.modulePrimaryID = Common.returndefaultnsnumber(dic: dic, keyvalue: "modulePrimaryID")
        self.km = Common.returndefaultnsnumber(dic: dic, keyvalue: "KM")
        self.lastCheckOutKM = Common.returndefaultnsnumber(dic: dic, keyvalue: "LastCheckOutKM")
        self.checkInCustomerName = Common.returndefaultstring(dic: dic, keyvalue: "checkInCustomerName")
         
        self.checkInLatitude = Common.returndefaultnsnumber(dic: dic, keyvalue: "checkInLatitude")
        self.checkInLongitude = Common.returndefaultnsnumber(dic: dic, keyvalue: "checkInLongitude")
        self.checkInTime = Common.returndefaultstring(dic: dic, keyvalue: "checkInTime")
        self.checkOutTime = Common.returndefaultstring(dic: dic, keyvalue: "checkOutTime")
        self.checkOutAddress = Common.returndefaultstring(dic: dic, keyvalue: "checkOutAddress")
        self.checkOutCustomerName = Common.returndefaultstring(dic: dic, keyvalue: "checkOutCustomerName")
        self.checkOutLongitude = Common.returndefaultnsnumber(dic: dic, keyvalue: "checkOutLangitude")
        self.checkOutLatitude = Common.returndefaultnsnumber(dic: dic, keyvalue: "checkOutLatitude")
        self.chekInAddress = Common.returndefaultstring(dic: dic, keyvalue: "chekInAddress")
        self.companyID = Common.returndefaultnsnumber(dic: dic, keyvalue: "companyID")
        self.customerID = Common.returndefaultnsnumber(dic: dic, keyvalue: "customerID")
        self.prodescription = Common.returndefaultstring(dic: dic, keyvalue: "description")
        self.detailType = Common.returndefaultnsnumber(dic: dic, keyvalue: "detailType")
        self.isFeedBackAvailable = Common.returndefaultbool(dic: dic, keyvalue: "isFeedBackAvailable")
        self.isPictureAvailable = Common.returndefaultbool(dic: dic, keyvalue: "isPictureAvailable")
        self.isStockAvailable = Common.returndefaultbool(dic: dic, keyvalue: "isStockAvailable")
        self.isTertiaryAvailable = Common.returndefaultbool(dic: dic, keyvalue: "isTertiaryAvailable")
        self.kms = Common.returndefaultnsnumber(dic: dic, keyvalue: "kms")
        self.lastKms = Common.returndefaultnsnumber(dic: dic, keyvalue: "lastKms")
        self.kms = Common.returndefaultnsnumber(dic: dic, keyvalue: "kms")
        self.movementDate = Common.returndefaultstring(dic: dic, keyvalue: "movementDate")
        self.outcome = Common.returndefaultstring(dic: dic, keyvalue: "outcome")
       
        self.nextActionID = Common.returndefaultnsnumber(dic: dic, keyvalue: "nextActionID")
        self.userID  = Common.returndefaultnsnumber(dic: dic, keyvalue: "userID")
        return self
        
    }
}
