//
//  CustomerHistoryResult.swift
//  SuperSales
//
//  Created by mac on 04/04/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import EVReflection
class CustomerHistoryResult: EVObject {
    var resultList:[result] = [result]()
    var topFiveOrderDataByCategoty:[orderbycategory] = [orderbycategory]()
    var topTenOrderDataByProduct:[orderByProduct] = [orderByProduct]()
}
class orderbycategory: EVObject {
    var subject:String = ""
    var totalPeriodQty:Int = 0
    var totalPeriodValue:Int = 0
    var lastThirthDayPeriodQty:Int = 0
    var lastThirthDayPeriodValue:Int = 0
}
class orderByProduct:EVObject{
    var subject:String = ""
    var totalPeriodQty:Int = 0
    var totalPeriodValue:Int = 0
    var lastThirthDayPeriodQty:Int = 0
    var lastThirthDayPeriodValue:Int = 0
}
class result: EVObject {
    var monthDoneVisit:Int = 0
    var montLeadGenerated:Int = 0
    var monthVisitReport:Int = 0
    var monthLeadUpdated:Int = 0
    var monthOrderCount:Int = 0
    var monthOrderValue:Int = 0
    var monthyear:String = ""
    var monthLeadWon:Int = 0
    var monthLeadLost:Int = 0
    var monthTotalDoneVsit:Int = 0
    var monthTotalReportVsit:Int = 0
    var monthTotalCount:Int = 0
    var monthTotalValue:Int = 0
    var monthTotalLeadWon:Int = 0
    var monthTotalLeadLost:Int = 0
    var monthTotalLeadGenerated:Int = 0
    var monthTotalLeadUpdated:Int = 0
    
    
    override public func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
      return  [(keyInObject: "monthyear",keyInResource: "month-year")]
      //  self.StatusType =
    }
}
