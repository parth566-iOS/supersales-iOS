//
//  AttendanceLocation.swift
//  SuperSales
//
//  Created by Apple on 28/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class AttendanceLocation: NSObject {

    var key:NSNumber!
    var location:String!
    
    func initWithDic(dic:[String:Any])->AttendanceLocation{
        self.key = Common.returndefaultnsnumber(dic: dic, keyvalue: "key")
        self.location = Common.returndefaultstring(dic: dic, keyvalue: "Location")
        
        return self
        
    }
}
