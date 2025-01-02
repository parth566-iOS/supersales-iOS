//
//  ShelfSpaceModel.swift
//  SuperSales
//
//  Created by Apple on 04/07/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import Foundation
struct ShelfSpaceModel {
    /*
     ["shelfSpacePicture": , "ID": 33, "positionID": 1, "companyID": 107, "positionName": Front, "totalBreadth": 700, "totalWidth": 800, "modifiedTime": 2019/07/04 00:00:00, "givenWidth": 500, "givenBreadth": 500, "modifiedBy": 293, "visitID": 2953, "isActive": 1]
     */
    var ID:Int
    var companyID:Int
    var positionName:String!
    var totalBreadth:Double
    var totalWidth:Double
    var modifiedTime:String!
    var givenWidth:Double
    var givenBreath:Double
    var modifiedBy:Int
    var VisitID:Int
    var isActive:Int
    var shelfSpacePicture:String!
    init(dic:[String:Any]) {
        print(dic)
        self.ID = dic["ID"] as? Int ?? 0
        self.totalWidth = dic["totalWidth"] as? Double ?? 0
        self.positionName = dic["positionName"] as? String ?? ""
        
        self.totalBreadth = dic["totalBreadth"] as? Double ?? 0
        self.modifiedTime = dic["modifiedTime"] as? String ?? ""
        self.shelfSpacePicture = dic["shelfSpacePicture"] as? String ?? ""
         self.companyID = dic["companyID"] as? Int ?? 0
         self.givenWidth = dic["givenWidth"] as? Double ?? 0
         self.givenBreath = dic["givenBreath"] as? Double ?? 0
         self.modifiedBy = dic["modifiedBy"] as? Int ?? 0
        self.VisitID = dic["visitID"] as? Int ?? 0
        self.isActive = dic["isActive"] as? Int ?? 0
        
    }
}
