//
//  Untitled.swift
//  SuperSales
//
//  Created by APPLE on 30/12/24.
//  Copyright © 2024 Bigbang. All rights reserved.
//


struct APIResponseShiftTiming: Codable {
    var status: String?
    var data: ShiftTiming?
    var message: String?

}

struct ShiftTiming: Codable {
    var dayOfMonthUptoWhichLocked: Int?
    var shiftID: Int?
    var shiftName: String?
    var currentOrPreviousMonth:Int?
    var isLockManualAttendance:Int?
    var shiftStartTime:String?
    var shiftEndTime:String?
    var lastDateUptoWhichSubmit:Int?
    var aftermidnightMaxAllowedTime:String?
    var aftermidnightCheckOutAllow:Bool?

}


struct APIResponseCompanyLeaves: Codable {
    var status: String?
    var data: ObjOfCompanyLeaves?
    var message: String?

}

struct ObjOfCompanyLeaves: Codable {
    var CompanyLeaves: [CompanyLeave]?
    var AutoLeaveUpdate:Bool?
    var CompanyLeaveNoticePrior: [String]?
}

struct CompanyLeave :Codable {
    var companyId: Int?
    var leaveType: String?
    var leaveTypeID: Int?
    var noOfLeaves:Double?
    var leaveUpdateCyle:String?
    var active:Bool?
    var modifiedBy:Int?
    var carryForward:Int?
    var priorNoticeDay:Int?
    var isRequireApproval:Int?
    var maxCarryForward:String?
    var leaveUpdateCycleSyear:String?
    var isAllowLeaveBackDay:Int?
    var allowTillDayOfMonth:Int?
    var noOfLeavesSyear:Double?
    var cycleSameAsFyear:Int?
    var allowHalfDay:Int?
    var allowMaxLeavesInOneTime:Int?
    var SLWithCLClubMinCLApply:Int?
    var PLWithCLClubMinCLApply:Int?
    var PLWithSLClubMinPLApply:Int?
    var shiftID:Int?
    
}

struct APIResponseCompanyHolidays: Codable {
    var status: String?
    var data: [CompanyHolidays]?
    var message: String?

}

struct CompanyHolidays: Codable {
    var holidayId:Int?
    var holidayDate:String?
    var holidayName:String?
    var branchID:Int?
    var IsMandatory:Int?
    var IsNationalHoliday:Int?
    var branchName:String?
    var shiftID:Int?
}
