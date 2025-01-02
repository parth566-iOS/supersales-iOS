//
//  DocumentReport.swift
//  SuperSales
//
//  Created by mac on 02/02/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import Foundation
import EVReflection
//
class DocumentReportModel : EVObject {
    var userID:Int = 0
    var createdTime:String!
    var viewStatus:Bool = false
    var createdBy:Int = 0
    var lastModifiedBy:Int = 0
    var applicationID:Int = 0
    var userName:String!
    var documentID:Int = 0
    var lastModified:Date = Date()
    var companyID:Int = 0
    var documentViewID:Int = 0
    var isActive:Int = 0
}
