//
//  LeadStatus.swift
//  SuperSales
//
//  Created by Apple on 09/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class LeadStatus: NSObject {
    var ID:Int!
    var LeadID:Int!
    var CreatedBy:Int!
    var InteractionTypeID:Int!
    var InteractionWith:Int!
    var OutcomeID:Int!
    func initWithdic(dict:[String:Any])->LeadStatus{
        return self
    }
}
