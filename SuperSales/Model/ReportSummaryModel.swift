//
//  ReportSummaryModel.swift
//  SuperSales
//
//  Created by mac on 08/03/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import EVReflection
class ReportSummaryModel: EVObject {
   /*
     
     {"attendanceMTDDaysPresent":0,"attendanceLastMonthDaysPresent":0,"visitTodayBeat":"","visitYesterdayBeat":"","VisitTodayDone":0,"VisitYesterdayDone":3,"VisitMTDDone":4,"VisitMTDUniqueDone":4,"VisitLastMonthDone":21,"VisitTodayUpdated":0,"VisitYesterdayUpdated":2,"VisitMTDUpdated":3,"VisitMTDUniqueUpdated":2,"VisitLastMonthUpdated":2,"VisitTodayMissed":0,"VisitYesterdayMissed":1,"VisitMTDMissed":1,"VisitMTDUniqueMissed":0,"VisitLastMonthMissed":4,"VisitTodayProductive":0,
     "VisitYesterdayProductive":0,"VisitMTDProductive":0,"VisitMTDUniqueProductive":0,"VisitLastMonthProductive":0,"OrderTodayCount":0,"OrderTodayUniqueRetailer":0,"OrderTodayValue":0.0,"OrderYesterdayCount":0,"OrderYesterdayUniqueRetailer":0,"OrderYesterdayValue":0.0,"OrderMTDCount":0,"OrderMTDUniqueRetailer":0,"OrderMTDValue":0.0,"OrderLastMonthCount":0,"OrderLastMonthUniqueRetailer":0,"OrderLastMonthValue":0.0,"mtdOrderCategory":[],"LeadTodayGenerated":0,"LeadYesterdayGenerated":5,"LeadMTDGenerated":6,"LeadLastMonthGenerated":1,"LeadTodayAssigned":0,"LeadYesterdayAssigned":0,"LeadMTDAssigned":0,"LeadLastMonthAssigned":0,"LeadTodayUpdated":0,"LeadYesterdayUpdated":4,"LeadMTDUpdated":6,"LeadLastMonthUpdated":1,"LeadTodayWon":0,"LeadYesterdayWon":0,"LeadMTDWon":0,"LeadLastMonthWon":0,"LeadTodayLost":0,"LeadYesterdayLost":0,"LeadMTDLost":0,"LeadLastMonthLost":0}
     **/
    var attendanceYesterdayIn:String?
    var attendanceYesterdayOut:String?
    var attendanceTodayOut:String?
    var attendanceTodayIn:String?
    var LeadLastMonthWon:Int = 0
    var LeadTodayUpdated:Int = 0
    var LeadYesterdayUpdated:Int = 0
    var LeadTodayLost:Int = 0
    var LeadYesterdayLost:Int = 0
    var LeadMTDWon:Int = 0
//    var attendanceMTDHourWorked:Int = 0
//    var attendanceLastMonthHourWorked:Int = 0
    var attendanceMTDHourWorked:String?
    var attendanceLastMonthHourWorked:String?
    var attendanceMTDDaysPresent:Int = 0
    var attendanceLastMonthDaysPresent:Int = 0
    var visitTodayBeat:String!
    var visitYesterdayBeat:String!
    var VisitTodayDone:Int = 0
    var VisitYesterdayDone:Int = 0
    var VisitMTDDone:Int = 0
    var VisitMTDUniqueDone:Int = 0
    var VisitLastMonthDone:Int = 0
    var VisitTodayUpdated:Int = 0
    var VisitYesterdayUpdated:Int = 0
    var VisitMTDUpdated:Int = 0
    var VisitMTDUniqueUpdated:Int = 0
    var VisitLastMonthUpdated:Int = 0
    var VisitTodayMissed:Int = 0
    var VisitYesterdayMissed:Int = 0
    var VisitMTDMissed:Int = 0
    var VisitMTDUniqueMissed:Int = 0
    var VisitLastMonthMissed:Int = 0
    var VisitTodayProductive:Int = 0
    
    var VisitYesterdayProductive:Int = 0
    var VisitMTDProductive:Int = 0
    var VisitMTDUniqueProductive:Int = 0
    var VisitLastMonthProductive:Int = 0
    var OrderTodayCount:Int = 0
    var OrderTodayUniqueRetailer:Int = 0
    var OrderTodayValue:Float = 0.0
    var OrderYesterdayCount:Int = 0
    var OrderYesterdayUniqueRetailer:Int = 0
    var OrderYesterdayValue:Int = 0
    var OrderLastMonthCount:Int = 0
    var OrderLastMonthUniqueRetailer:Int = 0
    var OrderMTDCount:Int = 0
    var OrderMTDUniqueRetailer:Int = 0
    var OrderMTDValue:Int = 0
    var OrderLastMonthValue:Int = 0
    var mtdOrderCategory:[mtdOrderCategoryObject] = [mtdOrderCategoryObject]()
    var LeadTodayGenerated:Int = 0
    var LeadYesterdayGenerated:Int = 0
    var LeadMTDGenerated:Int = 0
    var LeadMTDAssigned:Int = 0
    var LeadLastMonthGenerated:Int = 0
    var LeadLastMonthAssigned:Int = 0
    var LeadTodayAssigned:Int = 0
    var LeadYesterdayAssigned:Float = 0.0
    var LeadMTDUpdated:Int = 0
    var LeadLastMonthUpdated:Int = 0
    var LeadTodayWon:Int = 0
    var LeadYesterdayWon:Int = 0
    var LeadMTDLost:Int = 0
    var LeadLastMonthLost:Int = 0
  
    
}

class mtdOrderCategoryObject:EVObject
{
    var orderTotal:Int = 0
    var uniqueRetailer:Int = 0
    var CategoryName:String!
    var orderCount:Int = 0
}
