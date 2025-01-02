//
//  CustomerPotential.swift
//  SuperSales
//
//  Created by mac on 27/04/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import Foundation
import EVReflection

class CustomerPotential:EVObject{
    var iD:Int = 0
    
//    var productId = 0
    var productId1 = 0
    var productId2:Int = 0
    var productId3 = 0
    var productId4 = 0
    var productId5:Int = 0
    var productId6:Int = 0
    var productId7 = 0
    
   
    var totalHighPotentialSites = 0
    var totalSites = 0
    
//    var interestLevel = 0
    var interestLevel1 = 0
    var interestLevel2 = 0
    var interestLevel3 = 0
    var interestLevel4 = 0
    var interestLevel5 = 0
    var interestLevel6 = 0
    var interestLevel7 = 0
    
   
    
    
   
//    var pitched = ""
    var pitched1 = ""
    var pitched2 = ""
    var pitched3 = ""
    var pitched4 = ""
    var pitched5 = ""
    var pitched6 = ""
    var pitched7 = ""
   
//    var categoryId = 0
    var categoryId1 = 0
    var categoryId2 = 0
    var categoryId3 = 0
    var categoryId4 = 0
    var categoryId5 = 0
    var categoryId6 = 0
    var categoryId7 = 0
   
//    var subcategoryId = 0
    var subcategoryId1 = 0
    var subcategoryId2 = 0
    var subcategoryId3 = 0
    var subcategoryId4 = 0
    var subcategoryId5 = 0
    var subcategoryId6 = 0
    var subcategoryId7 = 0
    var totalTurnOver = 0
    
    
   
    
   
  
   
    var teamSize = 0
    var companyID = 0
    
   
    var customerID = 0
    var segmentTurnOver = 0
    
    
//    var productName = ""
    var product1Name = ""
    var product2Name = ""
    var product3Name = ""
    var product4Name = ""
    var product5Name = ""
    var product6Name = ""
    var product7Name = ""
    
    
    
    override public func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
        return  [(keyInObject: "iD",keyInResource: "ID"),
//                 (keyInObject: "productId",keyInResource: "ProductId"),
                 (keyInObject: "productId1",keyInResource: "ProductId1"),
                 (keyInObject: "productId2",keyInResource: "ProductId2"),
                 (keyInObject: "productId3",keyInResource: "ProductId3")
                 ,(keyInObject: "productId4",keyInResource: "ProductId4"),
                 (keyInObject: "productId5",keyInResource: "ProductId5"),
               (keyInObject: "productId6",keyInResource: "ProductId6"),
               (keyInObject: "productId7",keyInResource: "ProductId7"),
                 
//               (keyInObject: "subcategoryId",keyInResource: "SubcategoryId"),
                 
                 (keyInObject: "subcategoryId1",keyInResource: "SubcategoryId1"),
                 (keyInObject: "subcategoryId2",keyInResource: "SubcategoryId2"),
                 (keyInObject: "subcategoryId3",keyInResource: "SubcategoryId3"),
                 (keyInObject: "subcategoryId4",keyInResource: "SubcategoryId4"),
                 (keyInObject: "subcategoryId5",keyInResource: "SubcategoryId5"),
                 (keyInObject: "subcategoryId6",keyInResource: "SubcategoryId6"),
                 (keyInObject: "subcategoryId7",keyInResource: "SubcategoryId7"),
                 
//                 (keyInObject: "interestLevel",keyInResource: "InterestLevel"),
                 (keyInObject: "interestLevel1",keyInResource: "InterestLevel1"),
                 (keyInObject: "interestLevel2",keyInResource: "InterestLevel2"),
                 (keyInObject: "interestLevel3",keyInResource: "InterestLevel3"),
                 (keyInObject: "interestLevel4",keyInResource: "InterestLevel4"),
                 (keyInObject: "interestLevel5",keyInResource: "InterestLevel5"),
                 (keyInObject: "interestLevel6",keyInResource: "InterestLevel6"),
                 (keyInObject: "interestLevel7",keyInResource: "InterestLevel7"),
                 
//                 (keyInObject: "categoryId",keyInResource: "CategoryId"),
                 (keyInObject: "categoryId1",keyInResource: "CategoryId1"),
                 (keyInObject: "categoryId2",keyInResource: "CategoryId2"),
                 (keyInObject: "categoryId3",keyInResource: "CategoryId3"),
                 (keyInObject: "categoryId4",keyInResource: "CategoryId4"),
                 (keyInObject: "categoryId5",keyInResource: "CategoryId5"),
                 (keyInObject: "categoryId6",keyInResource: "CategoryId6"),
                 (keyInObject: "categoryId7",keyInResource: "CategoryId7"),
                 
                
                 
                 
                
               
                
                
//                 (keyInObject: "pitched",keyInResource: "Pitched"),
                 (keyInObject: "pitched1",keyInResource: "Pitched1"),
                 (keyInObject: "pitched2",keyInResource: "Pitched2"),
                 (keyInObject: "pitched3",keyInResource: "Pitched3"),
                 (keyInObject: "pitched4",keyInResource: "Pitched4"),
                 (keyInObject: "pitched5",keyInResource: "Pitched5"),
                 (keyInObject: "pitched6",keyInResource: "Pitched6"),
                 (keyInObject: "pitched7",keyInResource: "Pitched7"),
                
                 
               
                 (keyInObject: "teamSize",keyInResource: "TeamSize"),(keyInObject: "companyID",keyInResource: "CompanyID"),(keyInObject: "customerID",keyInResource: "CustomerID"),(keyInObject: "segmentTurnOver",keyInResource: "SegmentTurnOver"),(keyInObject: "totalSites",keyInResource: "TotalSites"),(keyInObject: "totalHighPotentialSites",keyInResource: "TotalHighPotentialSites") ,(keyInObject: "totalTurnOver",keyInResource: "TotalTurnOver")]
      //  self.StatusType =subcategoryId5
    }
}

class PotentialProduct:EVObject{
    var ProductID = 0
    var CategoryID = 0
    var SubCategoryID = 0
    var Budget = 0
    var pitched = ""
    var interestLevel = 0
    var productName = ""
    var Quantity = 0
    override public func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
        return  [(keyInObject: "ProductID",keyInResource: "productId"),(keyInObject: "CategoryID",keyInResource: "categoryId"),(keyInObject: "pitched",keyInResource: "Pitched"),(keyInObject: "SubCategoryID",keyInResource: "subcategoryId")]
    }
}
