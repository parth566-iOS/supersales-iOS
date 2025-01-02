//
//  Proposal.swift
//  SuperSales
//
//  Created by Apple on 21/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class Proposal: NSObject {
    var ApprovedBy:NSNumber!
    var ApprovedTo:NSNumber!
    var AssignedBy:NSNumber!
    var AssignedTo:NSNumber!
    var CompanyID:NSNumber!
    var CreatedBy:NSNumber!
    var CreatedTime:String!
    var CustomerDetails:CustomerDetails!
    var CustomerID:NSNumber!
    var CustomerName:String!
    var ProposalDescription:String!
    var FilterCategoryID:NSNumber!
    var FilterProduct:NSNumber!
    var FilterType:NSNumber!
    var FilterUser:NSNumber!
    var GSTEnabled:NSNumber!
    var GrossAmount:NSNumber!
    var ID:NSNumber!
    var IsActive:NSNumber!
    var LastModifiedBy:NSNumber!
    var LastModifiedTime:String!
    var LeadID:NSNumber!
    var LeadSeriesPostfix:NSNumber!
    var LocalTaxID:NSNumber!
    var LocalTaxSurcharge:NSNumber!
    var LocalTaxValue:NSNumber!
    var NetAmount:NSNumber!
    var Products:[ProposalProductModel]!
    var SeriesPostfix:NSNumber!
    var SeriesPrefix:String!
    var SortType:NSNumber!
    var StatusID:NSNumber!
    
    func initWithdict(dic:[String:Any])->Proposal{
        self.ApprovedBy = Common.returndefaultnsnumber(dic: dic, keyvalue: "ApprovedBy")
        self.ApprovedTo = Common.returndefaultnsnumber(dic: dic, keyvalue: "ApprovedTo")
        self.AssignedBy = Common.returndefaultnsnumber(dic: dic, keyvalue: "AssignedBy")
        self.AssignedTo = Common.returndefaultnsnumber(dic: dic, keyvalue: "AssignedTo")
        self.CompanyID = Common.returndefaultnsnumber(dic: dic, keyvalue: "CompanyID")
        self.CreatedBy = Common.returndefaultnsnumber(dic: dic, keyvalue: "CreatedBy")
        self.CreatedTime = Common.returndefaultstring(dic: dic, keyvalue: "CreatedTime") //Common.returndefaultnsnumber(dic: dic, keyvalue: "CreatedBy")
       // self.CustomerDetails = //CustomerDetails().initWithdict(dic:dic["CustomerDetails"])
      //  self.CustomerDetails = CustomerDetail()
        self.CustomerID =  Common.returndefaultnsnumber(dic: dic, keyvalue: "CustomerID")
        self.CustomerName = Common.returndefaultstring(dic: dic, keyvalue: "CustomerName")
        self.ProposalDescription = Common.returndefaultstring(dic: dic, keyvalue: "ProposalDescription")
        self.FilterCategoryID = Common.returndefaultnsnumber(dic: dic, keyvalue: "FilterCategoryID")
        self.FilterProduct = Common.returndefaultnsnumber(dic: dic, keyvalue: "FilterProduct")
        self.FilterType = Common.returndefaultnsnumber(dic: dic, keyvalue: "FilterType")
        self.FilterUser = Common.returndefaultnsnumber(dic: dic, keyvalue: "FilterUser")
        self.GSTEnabled = Common.returndefaultnsnumber(dic: dic, keyvalue: "GSTEnabled")
        self.GrossAmount = Common.returndefaultnsnumber(dic: dic, keyvalue: "GrossAmount")
        self.ID = Common.returndefaultnsnumber(dic: dic, keyvalue: "ID")
        self.IsActive = Common.returndefaultnsnumber(dic: dic, keyvalue: "IsActive")
        self.LastModifiedBy = Common.returndefaultnsnumber(dic: dic, keyvalue: "LastModifiedBy")
        self.LastModifiedTime = Common.returndefaultstring(dic: dic, keyvalue: "LastModifiedTime")
        self.LeadID = Common.returndefaultnsnumber(dic: dic, keyvalue: "LeadID")
        self.LeadSeriesPostfix = Common.returndefaultnsnumber(dic: dic, keyvalue: "LeadSeriesPostfix")
        self.LocalTaxID = Common.returndefaultnsnumber(dic: dic, keyvalue: "LocalTaxID")
        self.LocalTaxSurcharge = Common.returndefaultnsnumber(dic: dic, keyvalue: "LocalTaxSurcharge")
        self.LocalTaxValue = Common.returndefaultnsnumber(dic: dic, keyvalue: "LocalTaxValue")
        self.NetAmount = Common.returndefaultnsnumber(dic: dic, keyvalue: "NetAmount")
        self.Products = [ProposalProductModel]()
        let arrProduct = dic["Products"] as? [[String:Any]] ?? [[String:Any]]()
        
        if(arrProduct.count > 0){
            for pro in arrProduct{
                let proposalpromodel = ProposalProductModel().initWithdict(dic:pro)
                self.Products.append(proposalpromodel)
                
            }
        }
        self.SeriesPostfix = Common.returndefaultnsnumber(dic: dic, keyvalue: "SeriesPostfix")
        self.SeriesPrefix = Common.returndefaultstring(dic: dic, keyvalue: "SeriesPrefix")
        self.SortType = Common.returndefaultnsnumber(dic: dic, keyvalue: "SortType")
        self.StatusID = Common.returndefaultnsnumber(dic: dic, keyvalue: "StatusID")
        return self
    }
}
