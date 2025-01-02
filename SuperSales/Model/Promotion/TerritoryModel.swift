//
//  Territory.swift
//  SuperSales
//
//  Created by Apple on 27/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import Foundation

struct TerritoryModel{
    
    var ID:Int!
    var companyID:Int!
    var modifiedBy:Int!
    var modifiedTime:String!
    var status:Int!
    var territoryUserMobile:Int!
    var territoryUserID:Int!
    var territoryCode:String!
    var territoryName:String!
    var territoryUserName:String!
    
    init(_ Dictionary:[String:Any]) {
        self.ID = Dictionary["ID"] as? Int ?? 0
         self.companyID = Dictionary["companyID"] as? Int ?? 0
        self.modifiedBy = Dictionary["modifiedBy"] as? Int ?? 0
         self.status = Dictionary["status"] as? Int ?? 0
         self.territoryUserMobile = Dictionary["territoryUserMobile"] as? Int ?? 0
         self.territoryUserID = Dictionary["territoryUserID"] as? Int ?? 0
         self.modifiedTime = Dictionary["modifiedTime"] as? String ?? " "
          self.territoryCode = Dictionary["territoryCode"] as? String ?? " "
          self.territoryName = Dictionary["territoryName"] as? String ?? " "
          self.territoryUserName = Dictionary["territoryUserName"] as? String ?? " "
        
    }
  /*  ID = 24;
    companyID = 107;
    modifiedBy = 293;
    modifiedTime = "2019/06/27 00:00:00";
    status = 1;
    territoryCode = te2;
    territoryName = baroda;
    territoryUserID = 296;
    territoryUserMobile = 8888888833;
    territoryUserName = "krishna Slaes Executive";*/
}
