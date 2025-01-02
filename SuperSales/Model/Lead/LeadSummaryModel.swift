//
//  LeadSummary.swift
//  SuperSales
//
//  Created by mac on 05/03/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import EVReflection

class LeadSummaryModel: EVObject {
   
    var LeadStageNegotiationTotalCount:Int = 0
    var LeadChanceToWinLessThan81To100Count:Int = 0
    var LeadChanceToWinLessThan20Amount:Int = 0
    var LeadChanceToWinLessThan20Count:Int = 0
    var LeadChanceToWinLessThan21To40Amount:Int = 0
    var LeadChanceToWinLessThan21To40Count:Int = 0
    var LeadChanceToWinLessThan41To60Amount:Int = 0
    var LeadChanceToWinLessThan41To60Count:Int = 0
    var LeadChanceToWinLessThan61To80Amount:Int = 0
    var LeadChanceToWinLessThan61To80Count:Int = 0
    var LeadChanceToWinLessThan81To100Amount:Int = 0
    var LeadLastMonthAssigned:Int = 0
    var LeadLastMonthCancelled:Int = 0
    var LeadLastMonthGenerated:Int = 0
    var LeadLastMonthLost:Int = 0
    var LeadLastMonthPostponed:Int = 0
    var LeadLastMonthUpdated:Int = 0
    var LeadLastMonthWon:Int = 0
    var LeadMTDAssigned:Int = 0
    var LeadMTDCancelled:Int = 0
    var LeadMTDGenerated:Int = 0
    var LeadMTDPostponed:Int = 0
    var LeadMTDLost:Int = 0
    var LeadMTDUpdated:Int = 0
    var LeadMTDWon:Int = 0
    var LeadOrderExpectedGtNextMonthAmount:Int = 0
    var LeadOrderExpectedGtNextMonthCount:Int = 0
    var LeadOrderExpectedLtPreviousMonthAmount:Int = 0
    var LeadOrderExpectedLtPreviousMonthCount:Int = 0
    var LeadOrderExpectedNextMonthAmount:Int = 0
    var LeadOrderExpectedNextMonthCount:Int = 0
    var LeadOrderExpectedPreviousMonthAmount:Int = 0
    var LeadOrderExpectedPreviousMonthCount:Int = 0
    var LeadOrderExpectedThisMonthAmount:Int = 0
    var LeadOrderExpectedThisMonthCount:Int = 0
    var LeadOrderExpectedTotalAmount:Int = 0
    var LeadOrderExpectedTotalCount:Int = 0
    var LeadStage5DisplayText:String!
    var LeadStage5TotalAmount:Int = 0
    var LeadStage5TotalCount:Int = 0
    
    var LeadStage6DisplayText:String!
    var LeadStage6TotalAmount:Int = 0
    var LeadStage6TotalCount:Int = 0
    
    var LeadStageNegotiationDisplayText:String!
    var LeadStageNegotiationTotalAmount:Int = 0
    var LeadStageNoneTotalAmount:Int = 0
    
    var LeadStageNoneTotalCount:Int = 0
    var LeadStageQualifiedDisplayText:String!
    var LeadStageQualifiedTotalAmount:Int = 0
    var LeadStageQualifiedTotalCount:Int = 0
    var LeadStageTrialTotalAmount:Int = 0
    var LeadStageTrialTotalCount:Int = 0
    var LeadYTDAssigned:Int  = 0
    var LeadYTDCancelled:Int = 0
    var LeadYTDGenerated:Int = 0
    var LeadYTDLost:Int = 0
    var LeadYTDPostponed:Int = 0
    var LeadYTDUpdated:Int = 0
    var LeadYTDWon:Int = 0
    
    var LeadLastMonthWonValue:Int = 0
    var LeadMTDWonValue:Int = 0
    var LeadYTDWonValue:Int = 0
    
    
    var LeadMTDLostValue:Int = 0
    var LeadLastMonthLostValue:Int = 0
    var LeadYTDLostValue:Int = 0
//    var LeadStageTrialDisplayText
    
    //LeadOrderExpectedTotalCount
    
  //  var LeadStageQualifiedDisplayText:String!
    var LeadStageTrialDisplayText:String!
   
   
    
    
//    var LeadYTDAssigned:Int = 0
//    var LeadStageNegotiationTotalAmount:Int = 0
    var byLeadSourceList:[LeadSourceModel] = [LeadSourceModel]()
    var byLeadProductCategoryList:[LeadProductCatrgoryModel] = [LeadProductCatrgoryModel]()
    var byLeadStatusList:[LeadStatusModel] = [LeadStatusModel]()
    
    
    
}
class LeadSourceModel:EVObject{
    var  Amount:Int = 0
    var  Count:Int = 0
    var LeadSourceID:Int = 0
    var Source:String!
}
class LeadProductCatrgoryModel:EVObject{
    var  Amount:Int = 0
    var  Count:Int = 0
    var CategoryID:Int = 0
    var ProductCategory:String!
}
class LeadStatusModel:EVObject{
    var  Amount:Int = 0
    var  Count:Int = 0
    var LeadTypeID:Int = 0
    var StatusType:String!
    
    override public func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
      return  [(keyInObject: "StatusType",keyInResource: "Type")]
      //  self.StatusType =
    }
    
}
