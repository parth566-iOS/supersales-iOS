//
//  POrder.swift
//  SuperSales
//
//  Created by Apple on 11/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(POrder)
class POrder: NSManagedObject {

    class func entityName()->String{
        return "POrder"
    }
    class func defaultMapping()->FEMMapping{
        let mapping = FEMMapping.init(entityName: "POrder")
        
        return mapping
    }
}
