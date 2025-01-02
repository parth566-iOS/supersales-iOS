//
//  Justification.swift
//  SuperSales
//
//  Created by Apple on 15/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit

class Justification: NSObject {
    var iD:Int!
    var strJustification:String!
    
    init(_ dictionary:[String:Any]) {
        self.iD = dictionary["ID"] as? Int ?? 1
        self.strJustification = dictionary["Justification"] as? String ?? " "
    }
   
}
