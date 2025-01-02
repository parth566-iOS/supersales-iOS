//
//  ShelfSpacePosition.swift
//  SuperSales
//
//  Created by Apple on 01/07/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import Foundation

struct ShelfSpacePosition {
    var ID : Int
    var Name : String!
    
    init(_ dictionary: [String: Any]){
        self.ID = dictionary["ID"] as? Int ?? 0
        self.Name = dictionary["Name"] as? String ?? ""
    }
}
