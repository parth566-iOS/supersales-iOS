//
//  promotion.swift
//  SuperSales
//
//  Created by Apple on 10/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import Foundation

@objcMembers public class Promotion : NSObject {
    
    var ID : Int
    var companyID : Int
    var promotionTitle : String?
    var contentURL1 : String?
    var contentURL1Caption : String?
    var contentURL2 : String?
    var contentURL2Caption : String?
    var contentURL3 : String?
    var contentURL3Caption : String?
    var promodescription : String?
    var startDate : String?
    var endDate : String?
    var promotionType :Int
    var createdBy : Int
    var lastModifiedBy : Int
     var isActive : Bool!
    var promotionUserList : Array<PromotionUser>
    open var promotionProductList: Array<PromotionProduct>
    var promotionCustomerList: Array<PromotionCustomer>
    open var flatPromotionSlabDetails: Array<Slab>
    open var freeBonusProductList:Array<FreeBonusProduct>
    
    var availableUserBudget: Int
    var usedUserBudget : Int
    var status:Int
    var justificationID:Int
    
    init(_ dic:[String:Any]) {
        self.ID = dic["ID"] as? Int ?? 0
        self.companyID = dic["companyID"] as? Int ?? 0
        self.promotionTitle = dic["promotionTitle"] as? String ?? ""
        self.promotionType = dic["promotionType"] as? Int ?? 0
        self.contentURL1 = dic["contentURL1"] as? String ?? ""
        self.contentURL1Caption = dic["contentURL1Caption"] as?
        String ?? ""
        self.contentURL2 = dic["contentURL2"] as? String ?? ""
        self.contentURL2Caption = dic["contentURL2Caption"] as?
            String ?? ""
        self.contentURL3 = dic["contentURL3"] as? String ?? ""
        self.contentURL3Caption = dic["contentURL3Caption"] as?
            String ?? ""
        self.promodescription = dic["description"] as? String ?? ""
        self.startDate = dic["startDate"] as? String ?? ""
        self.endDate = dic["endDate"] as? String ?? ""
        self.promotionType = dic["promotionType"] as? Int ?? 0
        self.createdBy = dic["createdBy"] as? Int ?? 0
        self.lastModifiedBy = dic["lastModifiedBy"] as? Int ?? 0
        self.isActive = dic["isActive"] as? Bool ?? false
        self.status = dic["status"] as? Int ?? 0
        self.justificationID = dic["justificationID"] as? Int ?? 0
        
        var proUserList = Array<Any>()
        
        for item in dic["promotionUserList"] as? [[String:Any]] ?? []{
            //Do stuff
            let promoUser = PromotionUser(item)
            proUserList.append(promoUser)
        }
        self.promotionUserList = proUserList as? [Promotion.PromotionUser] ?? [Promotion.PromotionUser]()
        //promotionProductList
        var proProductList = Array<Any>()
        
       
        for item in dic["promotionProductList"] as? [[String:Any]] ?? [] {
            //Do stuff
            let promoProduct = PromotionProduct(item )
            proProductList.append(promoProduct)
        }
        self.promotionProductList = proProductList as? [PromotionProduct] ?? [PromotionProduct]()
        /*
         var promotionCustomerList: Array<promotionCustomer>
         var freeBonusProductList: Array<freeBonusProduct>
         */
        var proCustomerList = Array<Any>()
        
        //        for Dictionary in Dic["promotionUSerList"] {
        //            let promoUser = promotionUser(Dictionary)
        //            proUserList.append(promoUser)
        //
        //        }
        for item in dic["promotionCustomerList"] as? [[String:Any]] ?? [] {
            //Do stuff
            let promoCustomer = PromotionCustomer(item )
            proCustomerList.append(promoCustomer)
        }
        self.promotionCustomerList = proCustomerList as? [Promotion.PromotionCustomer] ?? [Promotion.PromotionCustomer]()
        
        
    
    /* var freeBonusProductList: Array<freeBonusProduct>
     */
    var proBonusList = Array<Any>()

        if ((dic["flatPromotionSlabDetails"]) != nil) {
            for item in dic["flatPromotionSlabDetails"] as? [AnyObject] ?? [] {
                //Do stuff
                let freeBonuspro = Slab(item as? [String : Any] ?? [String:Any]())
                proBonusList.append(freeBonuspro)
            }
            
            self.flatPromotionSlabDetails = proBonusList as? [Slab] ?? [Slab]()
            
        }
        else{
            self.flatPromotionSlabDetails = proBonusList as? [Slab] ?? [Slab]()
        }
       
    var BonusProduct = Array<Any>()
        if((dic["freeBonusProductList"]) != nil){
            for item in dic["freeBonusProductList"] as? [AnyObject] ?? [] {
                //Do stuff
                let freeBonuspro = FreeBonusProduct(item as? [String : Any] ?? [String : Any]())
                      BonusProduct.append(freeBonuspro)
                
              
            }
            self.freeBonusProductList = BonusProduct as? [FreeBonusProduct] ?? [FreeBonusProduct]()
        }
        else{
            self.freeBonusProductList = BonusProduct as? [FreeBonusProduct] ?? [FreeBonusProduct]()
        }
        
    
/*
     var availableUserBudget: Int
     var usedUserBudger : Int
     */
        
        self.availableUserBudget = dic["availableUserBudget"] as? Int ?? 0
        self.usedUserBudget = dic["usedUserBudget"] as? Int ?? 0
       
    }

    /*
     "availableUserBudget": 0,
     "usedUserBudget": 0
     */
    
    struct PromotionUser {
        var ID :Int
        var promotionID :Int
        var comapnayID :Int
        var userID :Int
        var userName : String
        var branchName: String
        var promotionType :Int
        var createdBy :Int
        var isActive :Int
        
        init(_ dictionary: [String: Any]){
            self.ID = dictionary["ID"] as? Int ?? 0
             self.promotionID = dictionary["promotionID"] as? Int ?? 0
             self.comapnayID = dictionary["comapnayID"] as? Int ?? 0
             self.userID = dictionary["userID"] as? Int ?? 0
             self.userName = dictionary["userName"] as? String ?? ""
             self.branchName = dictionary["branchName"] as? String ?? ""
            self.promotionType = dictionary["promotionType"] as? Int ?? 0
            self.createdBy = dictionary["createdBy"] as? Int ?? 0
            self.isActive = dictionary["isActive"] as? Int ?? 0
        }
    }
    
    struct PromotionCustomer{
      
        var ID : Int
        var promotionID : Int
        var customrID : Int
        var companyID : Int
        var customerName : String
        var customerClass : Int
        var customerSegment : Int
        var promotionType : Int
        var createdBy : Int
        var isActive : Int
        var bySegmentClassOrID : Int
        init(_ dictionary:[String:Any]) {
            self.ID = dictionary["ID"] as? Int ?? 0
            self.promotionID = dictionary["promotionID"] as? Int  ?? 0
            self.customrID = dictionary["customrID"] as? Int ?? 0
            self.companyID = dictionary["companyID"] as? Int ?? 0
            self.customerName = dictionary["customerName"] as? String ?? ""
            self.customerClass = dictionary["customerClass"] as? Int ?? 0
            self.customerSegment = dictionary["customerSegment"] as? Int ?? 0
             self.promotionType = dictionary["promotionType"] as? Int ?? 0
            self.createdBy = dictionary["createdBy"] as? Int ?? 0
            self.isActive = dictionary["isActive"] as? Int ?? 0
            self.bySegmentClassOrID =  dictionary["bySegmentClassOrID"] as? Int ?? 0
        }
        
    }
    
        
    }


/*
 {
 "status": "Success",
 "message": "Promotion list retrieved!",
 "data": [
 {
 "ID": 47,
 "companyID": 107,
 "promotionTitle": "test",
 "contentURL1": "",
 "contentURL1Caption": "",
 "contentURL2": "",
 "contentURL2Caption": "",
 "contentURL3": "",
 "contentURL3Caption": "",
 "description": "svbg f bgh",
 "startDate": "2019/06/11 00:00:00",
 "endDate": "2020/03/20 00:00:00",
 "promotionType": 1,
 "createdBy": 0,
 "lastModifiedBy": 0,
 "isActive": 0,
 "promotionUserList": [
 {
 "ID": 42,
 "promotionID": 47,
 "companyID": 293,
 "userID": 0,
 "userName": "",
 "branchID": "A",
 "promotionType": 1,
 "createdBy": 0,
 "isActive": 0
 }
 ],
 "promotionProductList": [
 {
 "ID": 82,
 "promotionID": 47,
 "companyID": 293,
 "productID": 1001,
 "productName": "Prosdc",
 "productCategoryID": 524,
 "productCategoryName": "SDC",
 "productSubCategoryID": 0,
 "productSubCategoryName": "",
 "qtyEligibleForBonus": 0,
 "promotionType": 1,
 "createdBy": 0,
 "isActive": 0,
 "byCategoryOrID": 1
 }
 ],
 "promotionCustomerList": [
 {
 "ID": 56,
 "promotionID": 47,
 "companyID": 107,
 "customerID": 0,
 "customerName": "",
 "customerClass": 1,
 "customerSegment": 0,
 "promotionType": 1,
 "createdBy": 0,
 "isActive": 0,
 "bySegmentClassOrID": 1
 }
 ],
 "flatPromotionSlabDetails": [
 {
 "ID": 90,
 "promotionID": 47,
 "startSlabAmount": 1,
 "endSlabAmount": 43566565,
 "slabPercentage": 25,
 "flatPromotionType": 1
 }
 ],
 "availableUserBudget": 0,
 "usedUserBudget": 0,
 "status": 0
 }
 ]
 }
 
 */
/*
 
 "ID": 8,
 "companyID": 1,
 "promotionTitle": "Promotion Edit Test",
 "contentURL1": "http://52.39.243.16:8080/salespro/attachments/product/1/120231Textlocal_Messenging_Platform_-_Introduction.pdf",
 "contentURL1Caption": "PDF",
 "description": "This is just test",
 "startDate": "2019/01/01 00:00:00",
 "endDate": "2019/01/27 00:00:00",
 "promotionType": 2,
 "createdBy": 0,
 "lastModifiedBy": 0,
 "isActive": 0,
 "promotionUserList": [
 {
 "ID": 10,
 "promotionID": 8,
 "companyID": 19,
 "userID": 0,
 "userName": "",
 "branchID": "A",
 "promotionType": 2,
 "createdBy": 0,
 "isActive": 0
 }
 ],"promotionProductList": [
 {
 "ID": 37,
 "promotionID": 8,
 "companyID": 19,
 "productID": 986,
 "productName": "परल तत",
 "productCategoryID": 0,
 "productCategoryName": "",
 "productSubCategoryID": 0,
 "productSubCategoryName": "",
 "qtyEligibleForBonus": 4,
 "promotionType": 1,
 "createdBy": 0,
 "isActive": 0,
 "byCategoryOrID": 0
 }
 ],
 "promotionCustomerList": [
 {
 "ID": 23,
 "promotionID": 8,
 "companyID": 1,
 "customerID": 0,
 "customerName": "",
 "customerClass": 1,
 "customerSegment": 0,
 "promotionType": 1,
 "createdBy": 0,
 "isActive": 0,
 "bySegmentClassOrID": 0
 }
 ],
 "freeBonusProductList": [
 {
 "ID": 11,
 "promotionID": 8,
 "productID": 322,
 "freeProductQty": 1,
 "productName": "Vag Bakri"
 }
 ],
 "availableUserBudget": 0,
 "usedUserBudget": 0
 }
 ]
 }
 */
@objcMembers public class PromotionProduct:NSObject{
    
    var ID :Int
    var promotionID :Int
    var comapnayID :Int
    var productID :Int
    var productName : String
    var productCategoryName: String
    var productCategoryID :Int
    var productSubCategoryID :Int
    var productSubCategoryName: String
    var qtyEligibleForBonus :Int
    var promotionType :Int
    var createdBy :Int
    var isActive :Int
    var byCategoryOrID :Int
    
    init(_ dictionary:[String:Any]){
        self.ID = dictionary["ID"] as? Int ?? 0
        self.promotionID = dictionary["promotionID"] as? Int ?? 0
        self.comapnayID = dictionary["comapnayID"] as? Int ?? 0
        self.productID = dictionary["productID"] as? Int ?? 0
        self.productName = dictionary["productName"] as? String ?? " "
        self.productCategoryName = dictionary["productCategoryName"] as? String ?? ""
        self.productCategoryID = dictionary["productCategoryID"] as? Int ?? 0
        self.productSubCategoryID = dictionary["productSubCategoryID"] as? Int ?? 0
        self.productSubCategoryName = dictionary["productSubCategoryName"] as? String ?? ""
        self.qtyEligibleForBonus = dictionary["qtyEligibleForBonus"] as? Int ?? 0
        self.promotionType = dictionary["promotionType"] as? Int ?? 0
        self.createdBy = dictionary["createdBy"] as? Int ?? 0
        self.isActive = dictionary["isActive"] as? Int ?? 0
        self.byCategoryOrID = dictionary["byCategoryOrID"] as? Int ?? 0
    }
    
}

@objcMembers public class FreeBonusProduct:NSObject{
/*{
    ID: 19,
    promotionID: 72,
    productID: 1003,
    freeProductQty: 1,
    productName: "vf . fd . fdzz fd",
    }*/
    var ID : Int
    var promotionID : Int
    var productID : Int
    var productName : String
    var freeProductQty : Int
    init(_ dictionary:[String:Any]) {
        self.ID = dictionary["ID"] as? Int ?? 0
        self.promotionID = dictionary["promotionID"] as? Int  ?? 0
        self.productID = dictionary["productID"] as? Int ?? 0
        self.productName = dictionary["productName"] as? String ?? ""
        self.freeProductQty = dictionary["freeProductQty"] as? Int ?? 0
    }
    
}
@objcMembers public class Slab:NSObject{
    /*
     "ID": 11,
     "promotionID": 8,
     "productID": 322,
     "freeProductQty": 1,
     "productName": "Vag Bakri"
     */
    /*
     {
     ID = 103;
     endSlabAmount = 5494960;
     flatPromotionType = 1;
     promotionID = 57;
     slabPercentage = 89;
     startSlabAmount = 1;
     },
     
     */
    var ID : Int
    var promotionID : Int
    var productID : Int
    var productName : String
    var endSlabAmount : Int
    var flatPromotionType : Int
    var slabPercentage : Int
    var startSlabAmount : Int
    
    
    init(_ dictionary:[String:Any]) {
        self.ID = dictionary["ID"] as? Int ?? 0
        self.promotionID = dictionary["promotionID"] as? Int  ?? 0
        self.productID = dictionary["productID"] as? Int ?? 0
        self.productName = dictionary["productName"] as? String ?? ""
        self.endSlabAmount = dictionary["endSlabAmount"] as? Int ?? 0
        self.flatPromotionType = dictionary["flatPromotionType"] as? Int ?? 0
        self.slabPercentage = dictionary["slabPercentage"] as? Int ?? 0
        self.startSlabAmount = dictionary["startSlabAmount"] as? Int ?? 0
        
}
}
/*public struct Quizmodel{
    /**
     ["isActive": 1, "isQuizAvailable": 0, "option3": re, "applicationID": 2, "lastModifiedBy": 8830, "singleAnswerKey": 1, "quizID": 107, "createdByName": Deepak Shah ., "createdBy": 8830, "answer": 1000, "documentID": 206, "option1": fd, "lastModified": 2021/08/02 00:00:00, "createdTime": 2021/08/02 00:00:00, "companyID": 1198, "option4": fs, "option2": ew, "questionText": test]
     */
    let isActive:Bool
    let isQuizAvailable:Bool
    let option3:String
    let applicationId:Int
    let lastModifiedBy:Int
    let singleAnswerKey:Bool
    let quizID:NSNumber
    
    enum CodingKeys: String, CodingKey {
        
        
       
        
            case isActive
            case isQuizAvailable
            case option3
            case applicationId
            case lastModifiedBy
        }
}
extension Quizmodel:Decodable{
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let option3 = try values.decode(String.self, forKey: .option3)
        let isQuizAvailable = try values.decode(String.self, forKey: .isQuizAvailable)
        let isActive = try values.decode(String.self, forKey: .isActive)
        let applicationId = try values.decode(String.self, forKey: .applicationId)
        let lastModifiedBy = try values.decode(String.self, forKey: .lastModifiedBy)

            // Decode to `Location` struct, and then convert back to `CLLocation`.
            // It's very tricky
           // let locationModel = try values.decode(Quizmodel.self, forKey: .)
           // location = CLLocation(model: locationModel)
        self.init(isActive: isActive, isQuizAvailable: isQuizAvailable, option3: option3, applicationId: applicationId, lastModifiedBy: lastModifiedBy)
        }
}
*/
