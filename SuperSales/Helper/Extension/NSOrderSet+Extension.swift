//
//  NSOrderSet.swift
//  SuperSales
//
//  Created by Apple on 05/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import Foundation
import UIKit

extension NSOrderedSet{
    func isordersetNotNil(value:NSOrderedSet)->Bool{
        if(type(of: value) == NSOrderedSet.self){
            return true
        
        }else{
              return false
        }
    }
}
