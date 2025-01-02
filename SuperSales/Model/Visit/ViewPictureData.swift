//
//  ViewPictureData.swift
//  SuperSales
//
//  Created by Apple on 29/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class ViewPictureData: NSObject {
//    @property(nonatomic,assign)int iD;
//    @property(nonatomic,assign)int visitID;
//    @property(nonatomic,strong)NSString *imagePath;
//    @property(nonatomic,assign)double lattitude;
//    @property(nonatomic,assign)double longitude;
//    @property(nonatomic,strong)NSString *timeStamp;
//    @property(nonatomic,assign)int companyID;
//    @property(nonatomic,assign)int createdBy;
//    @property(nonatomic,strong)NSString *addres;
     var iD:NSNumber?
       var visitID:NSNumber?
       var imagePath:String?
       var lattitude:NSNumber?
       var longitude:NSNumber?
       var companyID:NSNumber?
       var createdBy:NSNumber?
       var timeStamp:String?
       var addres:String?
    
       func initwithdic(dict:[String:Any])->ViewPictureData{
           self.iD = Common.returndefaultnsnumber(dic: dict, keyvalue: "ID")
           self.visitID = Common.returndefaultnsnumber(dic: dict, keyvalue: "VisitID")
         self.lattitude = Common.returndefaultnsnumber(dic: dict, keyvalue: "Lattitude")
           self.longitude = Common.returndefaultnsnumber(dic: dict, keyvalue: "Longitude")
         self.companyID = Common.returndefaultnsnumber(dic: dict, keyvalue: "CompanyID")
          self.createdBy = Common.returndefaultnsnumber(dic: dict, keyvalue: "CreatedBy")
           self.timeStamp = Common.returndefaultstring(dic: dict, keyvalue: "TimeStamp")
         self.imagePath = Common.returndefaultstring(dic: dict, keyvalue: "ImagePath")
          
         //  print(self.productName ?? "")
           return self
       }
}
