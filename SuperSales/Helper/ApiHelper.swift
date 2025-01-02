//
//  ApiHelper.swift
//  SuperSales
//
//  Created by Apple on 30/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import MagicalRecord
import FastEasyMapping

class ApiHelper: NSObject {
    // swiftlint:disable line_length
    // swiftlint:disable file_length
    // swiftlint:disable type_body_length
    
    var isSettingChanged = false
    var isLeadSource = false
    var isLeadOutcomes = false
    var isVisitOutcomes = false
    var isCompanySettingChanged = false
    var isProfileChanged = false
    var isCustomerVendorSettingsChanged = false
    var isCustomerVendorSettingChanged = false
    
    var array = [String]()
    var arrLead = [[String:Any]]()
    var arrVisit = [[String:Any]]()
    var arrProduct = [[String:Any]]()
    var arrProductCatgory = [[String:Any]]()
    var arrPropsal = [[String:Any]]()
    var arrSO = [[String:Any]]()
    var arrPO = [[String:Any]]()
    var arrBeatPlan = [[String:Any]]()
    var arrBeatPlanAssign = [[String:Any]]()
    var arrCompanyUsers = [String]()
    var arrContact = [String]()
    var arrCustomer = [String]()
    
    public typealias SettingBlock = (setting: Setting,error:NSError)
    let activeUser = Utils().getActiveAccount()
    let activeSetting = Utils().getActiveSetting()
    var pageCurrent = 1
    var pagesAvailable = 0
    var methodAPICall = Apicallmethod.get
    var lowerUser:[CompanyUsers]! = [CompanyUsers]()
    var lowerExecutiveUser:[CompanyUsers]! = [CompanyUsers]()
    
    // MARK:  Method
    func deletevisit(customerID:NSNumber){
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName:  "PlannVisit")
        // fetchrequest.predicate =
        fetchrequest.predicate = NSPredicate.init(format: "customerID == %@", customerID.stringValue as CVarArg)
        let context = PlannVisit.getContext()
        
        do{
            let array = try context.fetch(fetchrequest) as [PlannVisit]
            for lead in array {
                context.delete(lead)
            }
            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVF\(customerID.stringValue)")])
            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVS\(customerID.stringValue)")])
            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVM\(customerID.stringValue)")])
            context.mr_saveToPersistentStore { (status, error) in
                //print("context saved")
            }
        }catch{
            
        }
    }
    
    func deletelead(customerID:NSNumber){
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName:  "Lead")
        // fetchrequest.predicate =
        fetchrequest.predicate = NSPredicate.init(format: "customerID == %@", customerID.stringValue as CVarArg)
        let context = Lead.getContext()
        
        do{
            let array = try context.fetch(fetchrequest) as [PlannVisit]
            for lead in array {
                context.delete(lead)
            }
            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVF\(customerID.stringValue)")])
            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVS\(customerID.stringValue)")])
            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVM\(customerID.stringValue)")])
            context.mr_saveToPersistentStore { (status, error) in
                //print("context saved")
            }
        }catch{
            
        }
    }
    
    //For getting Cold call Detail
    func getColdCallDetailWithId(coldcallId:NSNumber)->[String:Any]{
        var coldCallparam = Common.returndefaultparameter()
        var coldcallDic = [String:Any]()
        var coldcalldic = [String:Any]()
        coldcalldic["CreatedBy"] = self.activeUser?.userID
        coldcalldic["ID"] = coldcallId
        coldcalldic["CompanyID"] = self.activeUser?.company?.iD
        coldCallparam["getUnPlannedVisitsJson"] = Common.returnjsonstring(dic: coldcalldic)
        self.getdeletejoinvisit(param: coldCallparam, strurl: ConstantURL.kWSUrlGetUnPlannedVisits, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                //print(arr)
                if let arrofcoldcall  = arr as? [[String:Any]]{
                    if(arrofcoldcall.count > 0){
                        coldcallDic = arrofcoldcall.first as? [String:Any] ?? [String:Any]()
                    }
                }
                // compeletion((totalpages,pagesavailable,lastsynctime,arr ,status,message,error: Common.returnnoerror(),responseType))
            } else if(error.code == 0){
                
                let dicJointVisitList = arr as? [String:Any] ?? [String:Any]()
                //  compeletion((totalpages,pagesavailable,lastsynctime,dicJointVisitList,status ,message,error: Common.returnnoerror(),responseType))
            }else{
                //  compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
                
            }
        }
        return coldcallDic
    }
    
    func getstorecheckdata()->(Bool,String){
        var statusofapi = false
        var msg = ""
        
        var param = Common.returndefaultparameter()
        if(StoreCheckContainer.visitType == VisitType.coldcallvisit){
            param["VisitID"] = StoreCheckContainer.unplanVisit?.localID
            param["CustomerID"] =  StoreCheckContainer.unplanVisit?.customerID
        }else{
            param["VisitID"] = StoreCheckContainer.planVisit?.iD
            param["CustomerID"] =  StoreCheckContainer.planVisit?.customerID
        }
        self.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetStoreCheckData, method: Apicallmethod.get){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            StoreCheckContainer.storeCheckBrandActivityList.removeAll()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                //print(arr)
                if(responseType ==  ResponseType.dic){
                    let dicresponse = arr as? [String:Any] ?? [String:Any]()
                    StoreCheckContainer.visitBrandActivityExists =  Common.returndefaultbool(dic: dicresponse, keyvalue: "visitBrandActivityExists")
                    StoreCheckContainer.visitCompetitionExists = Common.returndefaultbool(dic: dicresponse, keyvalue: "visitCompetitionExists")
                    //print(dicresponse["storeCheckBrandActivityList"] ?? "")
                    if let arrActivity = dicresponse["storeCheckVisitBrandActivityList"] as? [[String:Any]]{
                        StoreCheckContainer.storeCheckVisitBrandActivityList = [StoreCheckVisitBrandActivity]()
                        if(arrActivity.count > 0){
                            for brandactivity in arrActivity{
                                let actibrand = StoreCheckVisitBrandActivity().initwithdic(dict: brandactivity)
                                StoreCheckContainer.storeCheckVisitBrandActivityList.append(actibrand)
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    if  let arrBrandActivityList = dicresponse["storeCheckBrandActivityList"] as? [[String:Any]]{
                        StoreCheckContainer.storeCheckBrandActivityList = [StoreCheckBrandActivity]()
                        if(arrBrandActivityList.count > 0){
                            for brandactivity in arrBrandActivityList{
                                //print("brandactivity = \(brandactivity)")
                                let actibrand = StoreCheckBrandActivity().initwithdic(dict: brandactivity)
                                //print("target quantity = \(actibrand.targetQuantity)")
                                StoreCheckContainer.storeCheckBrandActivityList.append(actibrand)
                            }
                            
                        }
                        //storeCheckVisitBrandActivityList
                        
                    }
                    if let arrstoreactivityjustificationlist =      dicresponse["storeActivityJustificationList"] as? [[String:Any]]{
                        if(arrstoreactivityjustificationlist.count > 0){
                            //  self.storeCheckActivityJustificationList = [StoreActivityJustifiction]()
                            for actjust in arrstoreactivityjustificationlist{
                                let actjust = StoreActivityJustifiction().initwithdic(dict: actjust)
                                StoreCheckContainer.storeCheckActivityJustificationList.append(actjust)
                            }
                            
                        }
                    }
                    
                    //print("\(StoreCheckContainer.visitBrandActivityExists),\(StoreCheckContainer.visitCompetitionExists)")
                    if let arrstoreconditionlist = dicresponse["storeConditionList"] as? [[String:Any]]{
                        if(arrstoreconditionlist.count > 0){
                            StoreCheckContainer.storeConditionList = [StoreCondition]()
                            for actstrcon in arrstoreconditionlist{
                                let actjust = StoreCondition().initwithdic(dict: actstrcon)
                                StoreCheckContainer.storeConditionList.append(actjust)
                            }
                            
                        }
                    }
                    if let arrstorejustificationlist = dicresponse["storeJustificationList"] as? [[String:Any]]{
                        if(arrstorejustificationlist.count > 0){
                            StoreCheckContainer.storeJustificationList = [StoreJustification]()
                            for actstrcon in arrstorejustificationlist{
                                let actjust = StoreJustification().initwithdic(dict: actstrcon)
                                StoreCheckContainer.storeJustificationList.append(actjust)
                            }
                            
                        }
                    }
                    if let arrstoreCompetitionJustificationList = dicresponse["storeCompetitionJustificationList"] as? [[String:Any]]{
                        if(arrstoreCompetitionJustificationList.count > 0){
                            // self.storeCompetitionJustificationList = [StoreCompetitionJustification]()
                            for actstrcon in arrstoreCompetitionJustificationList{
                                let actjust = StoreCompetitionJustification().initwithdic(dict: actstrcon)
                                StoreCheckContainer.storeCompetitionJustificationList.append(actjust)
                            }
                            //  //print(self.storeCompetitionJustificationList.count)
                        }
                    }
                    
                    if let arrstoreActivityConditionList = dicresponse["storeActivityConditionList"] as? [[String:Any]]{
                        if(arrstoreActivityConditionList.count > 0){
                            // self.storeActivityConditionList = [StoreActivityCondition]()
                            for actstrcon in arrstoreActivityConditionList{
                                let actjust = StoreActivityCondition().initwithdic(dict: actstrcon)
                                StoreCheckContainer.storeActivityConditionList.append(actjust)
                            }
                            
                        }
                    }
                    //                        if let arrstoreCompetitionList = dicresponse["storeCompetitionList"] as? [[String:Any]]{
                    //                            //print(arrstoreCompetitionList.count)
                    //            if(arrstoreCompetitionList.count > 0){
                    //                StoreCheckContainer.storeCompetitionList = [StoreCompetition]()
                    //            for actstrcon in arrstoreCompetitionList{
                    //                let actjust = StoreCompetition().initwithdic(dict: actstrcon)
                    //                 //                                       StoreCheckContainer.storeCompetitionList.append(actjust)
                    //                //print("count = \(StoreCheckContainer.storeCompetitionList.count) in container")
                    //                                                       }
                    //                //print("count = \(StoreCheckContainer.storeCompetitionList.count) after for loop ")
                    //
                    //                                                   }
                    //                                               }
                    if let arrsstoreCheckVisitCompetitionActivityList = dicresponse["storeCheckVisitCompetitionActivityList"] as? [[String:Any]]{
                        if(arrsstoreCheckVisitCompetitionActivityList.count > 0){
                            StoreCheckContainer.storeCheckVisitCompetitionActivityList = [StoreCheckVisitCompetitionActivity]()
                            for actstrcon in arrsstoreCheckVisitCompetitionActivityList{
                                let actjust = StoreCheckVisitCompetitionActivity().initwithdic(dict: actstrcon)
                                StoreCheckContainer.storeCheckVisitCompetitionActivityList.append(actjust)
                            }
                            
                            
                        }
                        
                    }
                    
                    /* self.storeCheckVisitCompetitionActivityList = [mutArrStoreVisitCompetitionActivityList mutableCopy];
                     self.storeCompetitionList = [NSMutableArray new];
                     for (NSDictionary *dict in [[result valueForKey:@"data"] valueForKey:@"storeCompetitionList"]) {
                     StoreCompetition *objS = [[StoreCompetition alloc] initWithDictionary:dict error:nil];
                     objS.aryAssignedActivities = [NSMutableArray arrayWithArray:[AssignedActivity arrayOfModelsFromDictionaries:dict[@"assignedActivities"] error:nil]];
                     if (objS.aryAssignedActivities.count>0) {
                     [self.storeCompetitionList addObject:objS];
                     }
                     **/
                    if let arrstoreCompetitionList = dicresponse["storeCompetitionList"] as? [[String:Any]]{
                        StoreCheckContainer.storeCompetitionList = [StoreCompetition]()
                        for dic in arrstoreCompetitionList{
                            let objsc = StoreCompetition().initwithdic(dict: dic)
                            let arrassignactivity = dic["assignedActivities"] as? [[String:Any]]
                            objsc.aryAssignedActivities = [AssignedActivity]()
                            if(arrassignactivity?.count ?? 0 > 0){
                                //
                                
                                for act in arrassignactivity!{
                                    objsc.aryAssignedActivities?.append(AssignedActivity().initwithdic(dict:act))
                                }
                            }
                            
                            if(objsc.aryAssignedActivities?.count ?? 0 > 0){
                                StoreCheckContainer.storeCompetitionList.append(objsc)
                            }
                            StoreCheckCompetition.mutCompetitionList = StoreCheckContainer.storeCompetitionList.filter{
                                return  $0.storeJustificationIDList?.count ?? 0 > 0
                            }
                            
                            print("count of competition = \(StoreCheckContainer.storeCompetitionList.count) api response")
                        }
                    }
                    
                    //Activity-Justification Mapping
                    if(StoreCheckContainer.storeCheckActivityJustificationList.count > 0 && StoreCheckContainer.storeCheckBrandActivityList.count > 0){
                        for i in 0...StoreCheckContainer.storeCheckActivityJustificationList.count - 1{
                            for j in 0...StoreCheckContainer.storeCheckBrandActivityList.count - 1{
                                let activityjustification = StoreCheckContainer.storeCheckActivityJustificationList[i]
                                let brandactivity = StoreCheckContainer.storeCheckBrandActivityList[j]
                                var arrjsutification = [StoreJustification]()
                                if(activityjustification.storeActivityID == brandactivity.storeActivityID){
                                    if(activityjustification.activitystoreJustificationIDList?.count ?? 0 > 0){
                                        for l in 0...activityjustification.activitystoreJustificationIDList!.count - 1{
                                            if(activityjustification.activitystoreJustificationIDList?.count ?? 0 > 0){
                                                
                                                for k in 0...StoreCheckContainer.storeJustificationList.count - 1{
                                                    let just = StoreCheckContainer.storeJustificationList[k]
                                                    if(just.iD == activityjustification.activitystoreJustificationIDList![l]){
                                                        arrjsutification.append(just)
                                                    }
                                                }
                                            }
                                        }
                                        brandactivity.storeJustificationIDList = arrjsutification
                                    }
                                }
                            }
                        }
                    }
                    //Competition-Justification Mapping
                    if(StoreCheckContainer.storeCompetitionJustificationList.count > 0 && StoreCheckContainer.storeCompetitionList.count > 0 ){
                        for i in 0...StoreCheckContainer.storeCompetitionJustificationList.count - 1 {
                            for j in 0...StoreCheckContainer.storeCompetitionList.count - 1 {
                                let competitionJustification = StoreCheckContainer.storeCompetitionJustificationList[i]
                                let competition = StoreCheckContainer.storeCompetitionList[j]
                                var   arrjustification = [StoreJustification]()
                                if(competitionJustification.storeCompetitionID == competition.iD){
                                    if(competitionJustification.storeJustificationIDList?.count ?? 0 > 0){
                                        for l in 0...competitionJustification.storeJustificationIDList!.count - 1 {
                                            for k in 0...StoreCheckContainer.storeJustificationList.count - 1{
                                                let objjustification  = StoreCheckContainer.storeJustificationList[k]
                                                if(competitionJustification.storeJustificationIDList?.count ?? 0 > 0){
                                                    if(objjustification.iD == competitionJustification.storeJustificationIDList![l]){
                                                        arrjustification.append(objjustification)
                                                    }
                                                }
                                            }
                                            competition.storeJustificationIDList = arrjustification
                                        }
                                    }
                                }
                            }
                        }
                    }
                    ///Activity - Condition Mapping
                    if(StoreCheckContainer.storeCheckActivityJustificationList.count > 0 && StoreCheckContainer.storeCheckBrandActivityList.count > 0 ){
                        for i in 0...StoreCheckContainer.storeCheckActivityJustificationList.count - 1 {
                            for j in 0...StoreCheckContainer.storeCheckBrandActivityList.count - 1{
                                let activityCondition = StoreCheckContainer.storeActivityConditionList[i]
                                let activity = StoreCheckContainer.storeCheckBrandActivityList[j]
                                var arrCondition = [StoreCondition]()
                                if(activityCondition.storeActivityID == activity.storeActivityID){
                                    if(activityCondition.activitystoreConditionIDList?.count ?? 0 > 0){
                                        for l in 0...activityCondition.activitystoreConditionIDList!.count-1 {
                                            for k in 0...StoreCheckContainer.storeConditionList.count - 1{
                                                let objStoreCondition = StoreCheckContainer.storeConditionList[k]
                                                if(objStoreCondition.iD == activityCondition.activitystoreConditionIDList![l]){
                                                    arrCondition.append(objStoreCondition)
                                                }
                                            }
                                            
                                        }
                                        activity.storeConditionIDList =  arrCondition
                                    }
                                }
                            }
                        }
                    }
                    // StoreCheckBrand().setUI()
                    
                    //    mutActivityList =
                    
                    StoreCheckBrand.mutActivityList =
                    StoreCheckContainer.storeCheckBrandActivityList.filter{
                        //print("image =  \($0.activityImage)")
                        //print("justi = \($0.activitydescription)")
                        return ($0.storeConditionIDList?.count ?? 0 > 0 && $0.storeJustificationIDList?.count ?? 0 > 0)
                    }
                    print("brand activity count = \(StoreCheckBrand.mutActivityList.count) in api response")
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "StoreDataUpdate"), object: nil)
                    statusofapi =  true
                    msg = message
                    Utils.toastmsg(message: message, view: UIView())
                    
                }
            }
            else if(error.code == 0){
                
                statusofapi =  false
                msg = message
                Utils.toastmsg(message: message, view: UIView())
            }else{
                statusofapi =  false
                msg = error.localizedDescription
                Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String
                               ?? "", view: UIView())
            }
        }
        return(statusofapi,msg)
    }
    //for getting attendance history
    func loadAttendanceHistory(memberid:NSNumber,month:String,year:String,completionresponse: @escaping (ResponseBlock) -> Void){
        var param = Common.returndefaultparameter()
        param["MemberID"] = memberid.stringValue
        param["AdminID"] = activeUser?.userID?.stringValue
        param["Month"] =  month
        param["Year"] =  year
        // kWSUrlGetAttendanceHistory
        apicall(url: ConstantURL.kWSUrlGetAttendanceHistory, param: param, method: Apicallmethod.get, completion:  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                
                let arrOfAttendance = arr as? [String:Any] ?? [String:Any]()
                if(arrOfAttendance.count > 0){
                    completionresponse((totalpages,pagesavailable,lastsynctime,arrOfAttendance,status,message :message,error:Common.returnnoerror(),ResponseType.dic))
                }
            }else{
                completionresponse((totalpages,pagesavailable,lastsynctime,[[:]],status,error.localizedDescription,error,ResponseType.none))
            }
        })
    }
    
    //for getting setting
    func getDefaultSetting(compeletion:@escaping (SettingBlock)-> Void){
        var param:[String:Any]!
        param = [String:Any]()
        let activeUser = Utils().getActiveAccount()
        if(activeUser?.userID?.intValue ?? 0 > 0){
            
            do {
                let datajson = try  JSONSerialization.data(withJSONObject: ["CompanyID":activeUser?.company?.iD], options: JSONSerialization.WritingOptions.prettyPrinted)
                let strjson = String.init(data: datajson, encoding: .utf8)
                param["get_Settings"] = strjson
                param["UserID"] = activeUser?.userID?.stringValue ?? 0
                param["TokenID"] = activeUser?.securityToken ?? 0
                param["Application"] = ConstantURL.APPLICATIONSUPERSALESPRO
                
                
            }catch{
                
            }
        }else{
            Login().logout()
        }
        
        
        apicall(url: ConstantURL.kWSUrlGetSetting, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                let setting = Setting.init(dictionary: (arr as? [String : Any] ?? [String:Any]()) )
                //dic["SalesOrderLoadPage"] = 1
                
                let userdefault = UserDefaults.standard
                print("arr of setting =  api helper :: \(arr)")
                userdefault.setValue(arr, forKey: Constant.kUserSetting)
                userdefault.synchronize()
                
                compeletion((setting:setting,NSError.init(domain: "", code: 0, userInfo: [String:Any]())))
                
            }else{
                let dic1 = [String:Any]()
                let setting = Setting.init(dictionary: dic1)
                let errorOfApi = NSError.init(domain: "default", code: 0, userInfo: ["localisedescription":error])
                compeletion((setting:setting,error:errorOfApi))
            }
        }
    }
    
    func filterNotifications(dict:[String:Any]){
        if let type = dict["Type"] as? Int{
            //print("type of push notification  = \(type)")
            switch type {
                
            case 15:
                Login().logout()
                break
                
            case 155: break
            case 152: break
                
                
            case 136:
                
                if let strTransaction = dict["TransactionID"] as? String{
                    if(strTransaction.contains("TIA")){
                        let dicData = dict["data"] as? [String:Any]
                        let isApprove = dicData?["Approve"] as! Bool
                        if(isApprove == false){
                            if let strcheckin = dicData?["CheckInOutType"] as? String{
                                if((strcheckin == "CheckIn") || (strcheckin == "checkout")){
                                    //  AttendanceHistory.deleteRecord(id: NSNumber.init(value: dict["AttendanceID"] as? Int ?? 0))
                                    let attendanceContext = AttendanceHistory.getContext()
                                    attendanceContext.delete(NSManagedObject.mr_findFirstOrCreate(byAttribute: "entity_id", withValue: NSNumber.init(value: dict["AttendanceID"] as? Int ?? 0)))
                                }
                            }
                        }
                        
                    }
                }
                
                break
                
                
            case 125:
                let message =  dict["message"] as? String ?? ""
                if(message.contains("unplanned visit")){
                    
                }else{
                    if let strTransaction = dict["TransactionID"] as? String{
                        let str2  = strTransaction.substring(from: 3)
                        let dicdata = dict["data"] as? [String:Any] ?? [String:Any]()
                        let assigneeStatus = dicdata["AssigneeStatus"] as? Int  ?? 0
                        if( (strTransaction.contains("VTC") || ((strTransaction.contains("VTA")) &&  (assigneeStatus) == 3 ) || ((strTransaction.contains("VTR")) &&  (assigneeStatus) == 3 ) )){
                            
                            array = array.filter{
                                $0 != strTransaction
                            }
                            let exceptarr = [String.init(format: "VTO\(str2)"),String.init(format: "VTU\(str2)"),String.init(format: "VUS\(str2)"),String.init(format: "VTA\(str2)"),String.init(format: "VTR\(str2)"),String.init(format: "ACK\(str2)")]
                            array = array.filter({ (str) -> Bool in
                                return !(exceptarr.contains(str))
                            })
                            let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName:  "PlannVisit")
                            // fetchrequest.predicate =
                            fetchrequest.predicate = NSPredicate.init(format: "iD == %@", str2 as CVarArg)
                            let context = PlannVisit.getContext()
                            let result = PlannVisit.getVisitByPredicate(predicate: NSPredicate.init(format: "iD == %@", argumentArray: [str2 as CVarArg]))
                            
                            print("delelte visits %@",result)
                            if(result.count > 0 ){
                                for visit in result{
                                    context.delete(visit)
                                }
                                context.mr_saveToPersistentStore { (status, error) in
                                    if(error ==  nil){
                                        print("context did saved \(status)")
                                        
                                        //   self.navigationController?.popViewController(animated: true)
                                    }else{
                                        
                                        
                                    }
                                }
                            }
                            do{
                                let array = try context.fetch(fetchrequest) as [PlannVisit]
                                for lead in array {
                                    context.delete(lead)
                                }
                                Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVF\(str2)")])
                                Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVS\(str2)")])
                                Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVM\(str2)")])
                                context.mr_saveToPersistentStore { (status, error) in
                                    //print("context saved")
                                }
                            }catch{
                                
                            }
                        }else{
                            array = array.filter{
                                $0 != strTransaction
                            }
                            let exceptarr = [String.init(format: "VTO\(str2)"),String.init(format: "VTU\(str2)"),String.init(format: "VUS\(str2)"),String.init(format: "VTA\(str2)"),String.init(format: "VTR\(str2)"),String.init(format: "ACK\(str2)")]
                            array = array.filter({ (str) -> Bool in
                                return !(exceptarr.contains(str))
                            })
                            
                            
                            arrVisit.append(["ID" : str2])
                            var exist =  false
                            for dic in arrVisit{
                                if let leadID = dic["ID"] as? String{
                                    
                                    
                                    if(leadID.contains(str2)){
                                        exist = true
                                    }
                                }
                                
                            }
                            if(exist == false){
                                arrVisit.append(["ID": str2])
                            }
                        }
                    }
                    
                    
                }
                
                break
                
            case 126:
                let message =  dict["message"] as? String ?? ""
                if(message.contains("unplanned visit")){
                    
                }else{
                    if let strTransaction = dict["TransactionID"] as? String{
                        
                        
                        let dicdata = dict["data"] as? [String:Any] ?? [String:Any]()
                        let str2 = dicdata["CheckInID"] as? String ?? ""
                        array = array.filter{
                            $0 != strTransaction
                        }
                        
                        let exceptarr = [String.init(format: "VTO\(str2)"),String.init(format: "VTU\(str2)"),String.init(format: "VUS\(str2)"),String.init(format: "VTA\(str2)"),String.init(format: "VTR\(str2)"),String.init(format: "ACK\(str2)")]
                        array = array.filter({ (str) -> Bool in
                            return !(exceptarr.contains(str))
                        })
                        var exist =  false
                        for dic in arrVisit{
                            if let leadID = dic["ID"] as? String{
                                
                                
                                if(leadID.contains(str2)){
                                    exist = true
                                }
                            }
                            
                        }
                        if(exist == false){
                            arrVisit.append(["ID": str2])
                        }
                    }
                    
                }
                
                break
                
            case 154:
                break
                
            case 107:
                if let strTransaction = dict["TransactionID"] as? String{
                    if((strTransaction.contains("LDC")) || (strTransaction.contains("LDD")) ){
                        let str2  = strTransaction.substring(from: 3)
                        array = array.filter{
                            $0 != strTransaction
                        }
                        let exceptarr = [String.init(format: "LDU\(str2)"),String.init(format: "LDA\(str2)"),String.init(format: "LUS\(str2)"),String.init(format: "ALK\(str2)")]
                        array = array.filter({ (str) -> Bool in
                            return !(exceptarr.contains(str))
                        })
                        
                        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName:  "Lead")
                        // fetchrequest.predicate =
                        fetchrequest.predicate = NSPredicate.init(format: "iD == %@", str2 as CVarArg)
                        let context = Lead.getContext()
                        
                        do{
                            let array = try context.fetch(fetchrequest) as [Lead]
                            for lead in array {
                                context.delete(lead)
                            }
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "LRF\(str2)")])
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "LRS\(str2)")])
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "LRM\(str2)")])
                            context.mr_saveToPersistentStore { (status, error) in
                                //print("context saved")
                            }
                        }catch{
                            
                        }
                        
                    }else{
                        array = array.filter{
                            $0 != strTransaction
                        }
                        if((strTransaction.contains("LUS")) ){
                            let dicdata = dict["data"] as? [String:Any] ?? [String:Any]()
                            let str2  = dicdata["LeadID"] as? String ?? ""
                            
                            let exceptarr = [String.init(format: "LDU\(str2)"),String.init(format: "LDA\(str2)"),String.init(format: "LUS\(str2)"),String.init(format: "ALK\(str2)")]
                            array = array.filter({ (str) -> Bool in
                                return !(exceptarr.contains(str))
                            })
                            
                            var exist =  false
                            for dic in arrLead{
                                if let leadID = dic["ID"] as? String{
                                    
                                    
                                    if(leadID.contains(str2)){
                                        exist = true
                                    }
                                }
                                
                            }
                            if(exist == false){
                                arrLead.append(["ID": str2])
                            }
                        }else{
                            let str2  = strTransaction.substring(from: 3)
                            
                            let exceptarr = [String.init(format: "LDU\(str2)"),String.init(format: "LDA\(str2)"),String.init(format: "LUS\(str2)"),String.init(format: "ALK\(str2)")]
                            array = array.filter({ (str) -> Bool in
                                return !(exceptarr.contains(str))
                            })
                            arrLead.append(["ID" : str2])
                            var exist =  false
                            for dic in arrLead{
                                if let leadID = dic["ID"] as? String{
                                    
                                    
                                    if(leadID.contains(str2)){
                                        exist = true
                                    }
                                }
                                
                            }
                            if(exist == false){
                                arrLead.append(["ID": str2])
                            }
                        }
                    }
                }
                
                break
                
            case 143:
                break
                
            case 128:
                if let strTransaction = dict["TransactionID"] as? String{
                    let dictdata = dict["data"] as? [String:Any] ?? [String:Any]()
                    let str2  = dictdata["CheckInID"] as? String ?? String()
                    
                    array = array.filter{
                        $0 != strTransaction
                    }
                    let exceptarr = [String.init(format: "LDU\(str2)"),String.init(format: "LDA%\(str2)"),String.init(format: "LUS\(str2)"),String.init(format: "ALK\(str2)"),String.init(format: "ALO\(str2)")]
                    array = array.filter({ (str) -> Bool in
                        return !(exceptarr.contains(str))
                    })
                    var exist =  false
                    for dic in arrLead{
                        if let visitID = dic["ID"] as? String{
                            if(visitID.contains(str2)){
                                exist = true
                            }
                        }
                        
                    }
                    if(exist == false){
                        arrLead.append(["ID": str2])
                    }
                    
                }
                
                break
                
            case 101:
                // Add/Update/Delete Product Category
                if let strTransaction = dict["TransactionID"] as? String{
                    let str2  = strTransaction.substring(from: 3)
                    array = array.filter{
                        $0 != strTransaction
                    }
                    if(strTransaction.contains("PCD")){
                        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "ProdCategory")
                        fetchrequest.predicate = NSPredicate.init(format: "iD == %@", str2 as CVarArg)
                        
                        let context = ProdCategory.getContext()
                        
                        do{
                            let array = try context.fetch(fetchrequest) as [ProdCategory]
                            for lead in array {
                                lead.isActive = 0
                            }
                            
                            context.mr_saveToPersistentStore { (status, error) in
                                //print("context saved")
                            }
                        }catch{
                            
                        }
                    }else{
                        
                        var exist =  false
                        for dic in arrProductCatgory{
                            if let visitID = dic["ID"] as? String{
                                if(visitID.contains(str2)){
                                    exist = true
                                }
                            }
                            
                        }
                        if(exist == false){
                            arrProductCatgory.append(["ID": str2])
                        }
                    }
                }
                /* {
                 // Add/Update/Delete Product Category
                 if ([dict[@"TransactionID"] containsString:@"PCD"]) {
                 NSString *str2 = [dict[@"TransactionID"] substringFromIndex:3];
                 [array removeObject:dict[@"TransactionID"]];
                 
                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProdCategory"];
                 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"iD == %@", str2]];
                 NSManagedObjectContext * context = [_ProdCategory getContext];
                 NSError* error = nil;
                 NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
                 NSLog(@"Product Category Deleted Successful:::::%@",results);
                 for (_ProdCategory *objVisit in results) {
                 //                    [context deleteObject:objVisit];
                 [objVisit setIsActive:0];
                 }
                 [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                 NSLog(@"Context Did Saved::%d",contextDidSave);
                 }];
                 }else{
                 [array removeObject:dict[@"TransactionID"]];
                 if (![[aryProductCategory valueForKey:@"ID"] containsObject:[dict[@"TransactionID"] substringFromIndex:3]]) {
                 [aryProductCategory addObject:@{@"ID": [dict[@"TransactionID"] substringFromIndex:3]}];
                 }
                 }
                 }*/
                break
                
            case 102:
                // Add/Update/Delete Product SubCategory
                if let strTransaction = dict["TransactionID"] as? String{
                    let str2  = strTransaction.substring(from: 3)
                    array = array.filter{
                        $0 != strTransaction
                    }
                    if(strTransaction.contains("PSD")){
                        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "ProductSubCat")
                        fetchrequest.predicate = NSPredicate.init(format: "iD == %@", str2 as CVarArg)
                        
                        let context = ProductSubCat.getContext()
                        
                        do{
                            let array = try context.fetch(fetchrequest) as [ProductSubCat]
                            for subcat in array {
                                subcat.isActive =  false
                            }
                            
                            context.mr_saveToPersistentStore { (status, error) in
                                //print("context saved")
                            }
                        }catch{
                            
                        }
                    }else{
                        
                        var exist =  false
                        for dic in arrProductCatgory{
                            if let visitID = dic["ID"] as? String{
                                if(visitID.contains(str2)){
                                    exist = true
                                }
                            }
                            
                        }
                        if(exist == false){
                            arrProductCatgory.append(["ID": str2])
                        }
                    }
                }
                
                break
                
            case 103:
                // Add/Update/Delete Product
                
                if let strTransaction = dict["TransactionID"] as? String{
                    let str2  = strTransaction.substring(from: 3)
                    array = array.filter{
                        $0 != strTransaction
                    }
                    if(strTransaction.contains("PRD")){
                        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Product")
                        fetchrequest.predicate = NSPredicate.init(format: "productId == %@", str2 as CVarArg)
                        
                        let context = Product.getContext()
                        
                        do{
                            let array = try context.fetch(fetchrequest) as [Product]
                            for lead in array {
                                lead.isActive = 0
                            }
                            
                            context.mr_saveToPersistentStore { (status, error) in
                                //print("context saved")
                            }
                        }catch{
                            
                        }
                    }else{
                        
                        var exist =  false
                        for dic in arrProduct{
                            if let visitID = dic["ProductId"] as? String{
                                if(visitID.contains(str2)){
                                    exist = true
                                }
                            }
                            
                        }
                        if(exist == false){
                            arrProduct.append(["ProductId": str2])
                            //print("product \(str2) added and count is \(arrProduct.count)")
                        }
                    }
                }
                /*{
                 // Add/Update/Delete Product
                 if ([dict[@"TransactionID"] containsString:@"PRD"]) {
                 NSString *str2 = [dict[@"TransactionID"] substringFromIndex:3];
                 [array removeObject:dict[@"TransactionID"]];
                 
                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Product"];
                 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"productId == %@", str2]];
                 NSManagedObjectContext * context = [_Product getContext];
                 NSError* error = nil;
                 NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
                 NSLog(@"Product Deleted Successful:::::%@",results);
                 for (_Product *objProduct in results) {
                 [objProduct setIsActive:0];
                 }
                 [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                 NSLog(@"Context Did Saved::%d",contextDidSave);
                 }];
                 }else{
                 [array removeObject:dict[@"TransactionID"]];
                 if (![[aryProduct valueForKey:@"ProductId"] containsObject:[dict[@"TransactionID"] substringFromIndex:3]]) {
                 [aryProduct addObject:@{@"ProductId": [dict[@"TransactionID"] substringFromIndex:3]}];
                 }
                 }
                 }*/
                break
            case 114: //Configuration.-> get updates
                break
            case 115: //Permission.-> get updates
                break
            case 116: //Taxation.-> get updates
                break
                
            case 117: //Template.-> get updates
                if let strTransaction = dict["TransactionID"] as? String{
                    
                    
                    if((strTransaction.contains("SCF")) || (strTransaction.contains("SAS")) || (strTransaction.contains("SPM")) || (strTransaction.contains("STX")) || (strTransaction.contains("STL"))){
                        isSettingChanged = true
                    }
                }
                break
                
            case 131:
                //Update Attendance Setting
                if let strTransaction = dict["TransactionID"] as? String{
                    
                    
                    if(strTransaction.contains("TWC")){
                        isCompanySettingChanged = true
                    }
                    
                }
                
                
                break
                /*{ //Update Attendance Setting
                 if ([dict[@"TransactionID"] containsString:@"TWC"]) {
                 isCompanySettingChanged = YES;
                 }
                 }
                 break;
                 case 127: {
                 if ([dict[@"TransactionID"] containsString:@"ILS"] || [dict[@"TransactionID"] containsString:@"ULS"] || [dict[@"TransactionID"] containsString:@"DLS"]) {
                 isLeadSource = YES;
                 }else if ([dict[@"TransactionID"] containsString:@"ILO"] || [dict[@"TransactionID"] containsString:@"ULO"] || [dict[@"TransactionID"] containsString:@"DLO"]){
                 isLeadOutcomes = YES;
                 }else{
                 isVisitOutcomes = YES;
                 }
                 }*/
            case 127:
                if let strTransaction = dict["TransactionID"] as? String{
                    
                    
                    if(strTransaction.contains("ILS") || strTransaction.contains("ULS") || strTransaction.contains("DLS")){
                        isLeadSource  = true
                    }else if((strTransaction.contains("ILO")) || strTransaction.contains("ULO") || strTransaction.contains("DLO")){
                        isLeadOutcomes = true
                    }else{
                        isVisitOutcomes = true
                    }
                    
                }
                
                break
            case 78:
                if(isCustomerVendorSettingChanged == false){
                    isCustomerVendorSettingChanged = true
                    let dictdata = dict["data"] as? [String:Any] ?? [String:Any]()
                    let custapproval = dictdata["PrivilegeID"] as? NSNumber
                    let activesetting = Utils().getActiveSetting()
                    activesetting.customerApproval = custapproval
                    //    Utils.setDefultvalue(key: Constant.kSyncTime, value: Utils.getDateWithAppendingDay(day: 0, date: Date(), format: "yyyy/MM/dd HH:mm:ss"))
                    Utils.setDefultvalue(key: Constant.kUserSetting, value: activesetting.toDictionary())
                    // Setting.shared
                }
                /*{
                 if (!isCustomerVendorSettingChanged){
                 isCustomerVendorSettingChanged = YES;
                 Setting *set = ACTIVE_SETTING;
                 set.customerApproval = [NULL_TO_NIL(dict[@"data"][@"PrivilegeID"]) intValue];
                 [SettingManager Instance].activeSetting = set;
                 }
                 }*/
                break
            case 75:
                // Reject Customer
                let dicdata = dict["data"] as? [String:Any] ?? [String:Any]()
                let customerID = dicdata["CustomerID"] as? NSNumber ?? NSNumber.init(value: 0)
                self.deletelead(customerID: customerID)
                self.deletevisit(customerID: customerID)
                let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName:  "CustomerDetails")
                // fetchrequest.predicate =
                fetchrequest.predicate = NSPredicate.init(format: "iD == %@", customerID as CVarArg)
                let context = CustomerDetails.getContext()
                
                do{
                    let array = try context.fetch(fetchrequest) as [PlannVisit]
                    for lead in array {
                        context.delete(lead)
                    }
                    
                    context.mr_saveToPersistentStore { (status, error) in
                        //print("context saved")
                    }
                }catch{
                    
                }
                /*{// Reject Customer
                 [self deleteVisit:[dict[@"data"][@"CustomerID"] integerValue]];
                 [self deleteLead:[dict[@"data"][@"CustomerID"] integerValue]];
                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[_CustomerDetails entityName]];
                 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"iD == %@", dict[@"data"][@"CustomerID"]]];
                 NSManagedObjectContext *context = [_CustomerDetails getContext];
                 NSError* error = nil;
                 NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
                 NSLog(@"Customer Deleted Successful:::::%@",results);
                 for (_CustomerDetails *obj in results) {
                 [context deleteObject:obj];
                 }
                 [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                 NSLog(@"Customer Context Did Saved::%d",contextDidSave);
                 }];
                 }*/
                break
            case 43: // ack_update_customer
                break
            case 48: // Customer Add, Update
                break
            case 140:// Customer Add, Update
                break
            case 80:
                // Add/Update Customer
                let dictData = dict["data"] as? [String:Any] ?? [String:Any]()
                let str2 = dictData["CustomerID"] as? String  ?? ""
                var exist =  false
                for diccust in arrCustomer{
                    
                    if(diccust.contains(str2)){
                        exist = true
                    }
                    
                    
                }
                if(exist == false){
                    arrCustomer.append(str2)
                    ////print("product \(str2) added and count is \(arrCustomer.count)")
                }
                /*{// Add/Update Customer
                 NSLog(@"Customer::::%@",dict[@"data"]);
                 if (![aryCustomer containsObject:dict[@"data"][@"CustomerID"]])
                 [aryCustomer addObject:dict[@"data"][@"CustomerID"]];
                 }*/
                break
            case 50:
                // Add/Update Contact
                let dictData = dict["data"] as? [String:Any] ?? [String:Any]()
                let str2 = dictData["ContactID"] as? String  ?? ""
                var exist =  false
                for dic in arrContact{
                    
                    if(dic.contains(str2)){
                        exist = true
                    }
                    
                    
                }
                if(exist == false){
                    arrContact.append(str2)
                    //print("contact \(str2) added and count is \(arrContact.count)")
                }
                /*{// Add/Update Contact
                 if (![aryContact containsObject:dict[@"data"][@"ContactID"]])
                 [aryContact addObject:dict[@"data"][@"ContactID"]];
                 }*/
                break
            case 19:  // Add User(When new user join company)
                break
            case 53:  // Update User(When user member has been updated.)
                break
            case 83:  // Update User(When user member has been updated.)
                break
            case 24:  // Change Mobile{
                break
            case 47:
                // Update company details
                let str2 = self.activeUser?.userID as? String ?? ""
                let message =  dict["message"] as? String ?? ""
                if(message.contains("Your mobile number change request has been approved")){
                    isProfileChanged = true
                    
                    var exist =  false
                    for dic in arrCompanyUsers{
                        
                        if(dic.contains(str2)){
                            exist = true
                        }
                        
                        
                    }
                    if(exist == false){
                        arrCompanyUsers.append(str2)
                        //print("contact \(str2) added and count is \(arrContact.count)")
                    }
                }else{
                    isProfileChanged = true
                    var exist =  false
                    for dic in arrCompanyUsers{
                        
                        if(dic.contains(str2)){
                            exist = true
                        }
                        
                        
                    }
                    if(exist == false){
                        arrCompanyUsers.append(str2)
                        //print("contact \(str2) added and count is \(arrContact.count)")
                    }
                    
                }
                /*{ // Update company details
                 Account *account = ACTIVE_ACCOUNT;
                 if ([dict[@"message"] containsString:@"Your mobile number change request has been approved"]) {
                 isProfileChanged = YES;
                 if (![aryCompanyUsers containsObject:@(account.user_id)])
                 [aryCompanyUsers addObject:@(account.user_id)];
                 }else{
                 isProfileChanged = YES;
                 if (![aryCompanyUsers containsObject:dict[@"data"][@"ID"]])
                 [aryCompanyUsers addObject:dict[@"data"][@"ID"]];
                 }
                 }*/
                break
            case 82:
                break
            case 86:
                // Update company details
                let dictData = dict["data"] as? [String:Any] ?? [String:Any]()
                let str2 = dictData["UserID"] as? String  ?? ""
                isProfileChanged = true
                var exist =  false
                for dic in arrCompanyUsers{
                    
                    if(dic.contains(str2)){
                        exist = true
                    }
                    
                    
                }
                if(exist == false){
                    arrCompanyUsers.append(str2)
                    //print("contact \(str2) added and count is \(arrContact.count)")
                }
                
                break
                
            case 31:// Remove User(When user left company)
                let dictdata = dict["data"] as? [String:Any] ?? [String:Any]()
                let str2 = dictdata["ID"]
                let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "CompanyUsers")
                fetchrequest.predicate = NSPredicate.init(format: "entity_id == %@", str2 as! CVarArg)
                
                let context = CompanyUsers.getContext()
                
                do{
                    let array = try context.fetch(fetchrequest) as [CompanyUsers]
                    for lead in array {
                        context.delete(lead)
                    }
                    
                    context.mr_saveToPersistentStore { (status, error) in
                        //print("context saved")
                    }
                }catch{
                    
                }
                /*{// Remove User(When user left company)
                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CompanyUsers"];
                 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"entity_id == %@", dict[@"data"][@"ID"]]];
                 NSManagedObjectContext * context = [_CompanyUsers getContext];
                 NSError* error = nil;
                 NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
                 NSLog(@"Company User Deleted Successful:::::%@",results);
                 for (_CompanyUsers *objUser in results) {
                 [context deleteObject:objUser];
                 }
                 [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                 NSLog(@"Company User Context Did Saved::%d",contextDidSave);
                 }];
                 }*/
                break
            case 108:// Add,remove,assign Proposal
                if let strTransaction = dict["TransactionID"] as? String{
                    let str2  = strTransaction.substring(from: 3)
                    array = array.filter{
                        $0 != strTransaction
                    }
                    let exceptarr = [String.init(format: "DPA\(str2)"),
                                     String.init(format: "PRR\(str2)"),
                                     String.init(format: "PRP\(str2)"),
                                     String.init(format: "PRA\(str2)"),
                                     String.init(format: "PRO\(str2)"),
                                     String.init(format: "PRU\(str2)")]
                    array = array.filter({ (str) -> Bool in
                        return !(exceptarr.contains(str))
                    })
                    if((strTransaction.contains("DPA"))||(strTransaction.contains("PRR"))){
                        
                        
                        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Proposl")
                        fetchrequest.predicate = NSPredicate.init(format: "iD == %@", str2 as CVarArg)
                        
                        let context = Proposl.getContext()
                        
                        do{
                            let array = try context.fetch(fetchrequest) as [CompanyUsers]
                            for lead in array {
                                context.delete(lead)
                            }
                            
                            context.mr_saveToPersistentStore { (status, error) in
                                //print("context saved")
                            }
                        }catch{
                            
                        }
                    }else{
                        var exist =  false
                        for dic in arrPropsal{
                            if let visitID = dic["ID"] as? String{
                                if(visitID.contains(str2)){
                                    exist = true
                                }
                            }
                            
                        }
                        if(exist == false){
                            arrPropsal.append(["ID":str2])
                            //print("contact \(str2) added and count is \(arrContact.count)")
                        }
                    }
                }
                /*{// Add,remove,assign Proposal
                 if ([dict[@"TransactionID"] containsString:@"DPA"] || [dict[@"TransactionID"] containsString:@"PRR"]) {
                 NSString *str2 = [dict[@"TransactionID"] substringFromIndex:3];
                 [array removeObject:dict[@"TransactionID"]];
                 [array removeObject:FormatString(@"DPA%@", str2)];
                 [array removeObject:FormatString(@"PRR%@", str2)];
                 [array removeObject:FormatString(@"PRP%@", str2)];
                 [array removeObject:FormatString(@"PRA%@", str2)];
                 [array removeObject:FormatString(@"PRO%@", str2)];
                 [array removeObject:FormatString(@"PRU%@", str2)];
                 
                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Proposl"];
                 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"iD == %@", str2]];
                 NSManagedObjectContext * context = [_Proposal getContext];
                 NSError* error = nil;
                 NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
                 NSLog(@"Delete proposal:::::%@",results);
                 for (_Proposal *objProposal in results) {
                 [context deleteObject:objProposal];
                 }
                 [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                 NSLog(@"Context Did Saved::%d",contextDidSave);
                 }];
                 }else{
                 [array removeObject:dict[@"TransactionID"]];
                 //                NSString *str = dict[@"TransactionID"];
                 NSString *str2 = [dict[@"TransactionID"] substringFromIndex:3];
                 [array removeObject:dict[@"TransactionID"]];
                 [array removeObject:FormatString(@"DPA%@", str2)];
                 [array removeObject:FormatString(@"PRR%@", str2)];
                 [array removeObject:FormatString(@"PRP%@", str2)];
                 [array removeObject:FormatString(@"PRA%@", str2)];
                 [array removeObject:FormatString(@"PRO%@", str2)];
                 [array removeObject:FormatString(@"PRU%@", str2)];
                 
                 if (![[aryProposal valueForKey:@"ID"] containsObject:str2]) {
                 [aryProposal addObject:@{@"ID": str2}];
                 }
                 }
                 }*/
                break
            case 151:
                if let strTransaction = dict["TransactionID"] as? String{
                    let str2  = strTransaction.substring(from: 3)
                    array = array.filter{
                        $0 != strTransaction
                    }
                    let exceptarr = [String.init(format: "SOR\(str2)"),String.init(format: "CSA\(str2)")]
                    array = array.filter({ (str) -> Bool in
                        return !(exceptarr.contains(str))
                    })
                    if((strTransaction.contains("SOR"))||(strTransaction.contains("CSA"))){
                        
                        
                        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "SOrder")
                        fetchrequest.predicate = NSPredicate.init(format: "iD == %@", str2 as CVarArg)
                        
                        let context = SOrder.getContext()
                        
                        do{
                            let array = try context.fetch(fetchrequest) as [SOrder]
                            for lead in array {
                                context.delete(lead)
                            }
                            
                            context.mr_saveToPersistentStore { (status, error) in
                                //print("context saved")
                            }
                        }catch{
                            
                        }
                    }else{
                        var exist =  false
                        for dic in arrSO{
                            if let visitID = dic["ID"] as? String{
                                if(visitID.contains(str2)){
                                    exist = true
                                }
                            }
                            
                        }
                        if(exist == false){
                            arrSO.append(["ID":str2])
                            //print("contact \(str2) added and count is \(arrContact.count)")
                        }
                    }
                }
                break
            case 109:// Add,remove,assign sales Order
                if let strTransaction = dict["TransactionID"] as? String{
                    let str2  = strTransaction.substring(from: 3)
                    array = array.filter{
                        $0 != strTransaction
                    }
                    let exceptarr = [String.init(format: "SOR\(str2)"),String.init(format: "CSA\(str2)")]
                    array = array.filter({ (str) -> Bool in
                        return !(exceptarr.contains(str))
                    })
                    if((strTransaction.contains("SOR"))||(strTransaction.contains("CSA"))){
                        
                        
                        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "SOrder")
                        fetchrequest.predicate = NSPredicate.init(format: "iD == %@", str2 as CVarArg)
                        
                        let context = SOrder.getContext()
                        
                        do{
                            let array = try context.fetch(fetchrequest) as [SOrder]
                            for lead in array {
                                context.delete(lead)
                            }
                            
                            context.mr_saveToPersistentStore { (status, error) in
                                //print("context saved")
                            }
                        }catch{
                            
                        }
                    }else{
                        var exist =  false
                        for dic in arrSO{
                            if let visitID = dic["ID"] as? String{
                                if(visitID.contains(str2)){
                                    exist = true
                                }
                            }
                            
                        }
                        if(exist == false){
                            arrSO.append(["ID":str2])
                            //print("contact \(str2) added and count is \(arrContact.count)")
                        }
                    }
                }
                /*{// Add,remove,assign sales Order
                 if ([dict[@"TransactionID"] containsString:@"SOR"] || [dict[@"TransactionID"] containsString:@"CSA"]) {
                 NSString *str2 = [dict[@"TransactionID"] substringFromIndex:3];
                 [array removeObject:dict[@"TransactionID"]];
                 [array removeObject:FormatString(@"SOR%@", str2)];
                 [array removeObject:FormatString(@"CSA%@", str2)];
                 [array removeObject:FormatString(@"SOP%@", str2)];
                 [array removeObject:FormatString(@"SOA%@", str2)];
                 [array removeObject:FormatString(@"SOU%@", str2)];
                 [array removeObject:FormatString(@"SAA%@", str2)];
                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SOrder"];
                 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"iD == %@", str2]];
                 NSManagedObjectContext * context = [_SOrder getContext];
                 NSError* error = nil;
                 NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
                 NSLog(@"Delete Sales Order:::::%@",results);
                 for (_SOrder *objSO in results) {
                 [context deleteObject:objSO];
                 }
                 [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                 NSLog(@"Context Did Saved::%d",contextDidSave);
                 }];
                 }else{
                 [array removeObject:dict[@"TransactionID"]];
                 //                NSString *str = dict[@"TransactionID"];
                 NSString *str2 = [dict[@"TransactionID"] substringFromIndex:3];
                 [array removeObject:dict[@"TransactionID"]];
                 [array removeObject:FormatString(@"SOR%@", str2)];
                 [array removeObject:FormatString(@"CSA%@", str2)];
                 [array removeObject:FormatString(@"SOP%@", str2)];
                 [array removeObject:FormatString(@"SOA%@", str2)];
                 [array removeObject:FormatString(@"SOU%@", str2)];
                 [array removeObject:FormatString(@"SAA%@", str2)];
                 if (![[arySO valueForKey:@"ID"] containsObject:str2]) {
                 [arySO addObject:@{@"ID": str2}];
                 }
                 }
                 }*/
                break
            case 120:// Cancel Sales Order
                if let strTransaction = dict["TransactionID"] as? String{
                    let str2  = strTransaction.substring(from: 3)
                    array = array.filter{
                        $0 != strTransaction
                    }
                    let exceptarr = [String.init(format: "SOR\(str2)"),String.init(format: "CSA\(str2)"),String.init(format: "SOP\(str2)"),String.init(format: "SOA\(str2)"),String.init(format: "SOU\(str2)"),String.init(format: "CSP\(str2)")]
                    array = array.filter({ (str) -> Bool in
                        return !(exceptarr.contains(str))
                    })
                    if((strTransaction.contains("CSA"))){
                        
                        
                        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "SOrder")
                        fetchrequest.predicate = NSPredicate.init(format: "iD == %@", str2 as CVarArg)
                        
                        let context = SOrder.getContext()
                        
                        do{
                            let array = try context.fetch(fetchrequest) as [SOrder]
                            for lead in array {
                                context.delete(lead)
                            }
                            
                            context.mr_saveToPersistentStore { (status, error) in
                                //print("context saved")
                            }
                        }catch{
                            
                        }
                    }
                }
                /*{
                 // Cancel Sales Order
                 if ([dict[@"TransactionID"] containsString:@"CSA"]) {
                 NSString *str2 = [dict[@"TransactionID"] substringFromIndex:3];
                 [array removeObject:dict[@"TransactionID"]];
                 [array removeObject:FormatString(@"SOR%@", str2)];
                 [array removeObject:FormatString(@"CSA%@", str2)];
                 [array removeObject:FormatString(@"SOP%@", str2)];
                 [array removeObject:FormatString(@"SOA%@", str2)];
                 [array removeObject:FormatString(@"SOU%@", str2)];
                 [array removeObject:FormatString(@"CSP%@", str2)];
                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SOrder"];
                 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"iD == %@", str2]];
                 NSManagedObjectContext * context = [_SOrder getContext];
                 NSError* error = nil;
                 NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
                 NSLog(@"Delete Sales Order:::::%@",results);
                 for (_SOrder *objSO in results) {
                 [context deleteObject:objSO];
                 }
                 [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                 NSLog(@"Context Did Saved::%d",contextDidSave);
                 }];
                 }
                 }*/
                
                break
            case 164:
                //print("Response of assign beat plan \(dict)")
                
                break
                
            case 153:
                
                if let strTransaction = dict["TransactionID"] as? String{
                    let str2  = strTransaction.substring(from: 3)
                    array = array.filter{
                        $0 != strTransaction
                    }
                    if((strTransaction.contains("RMV")) || (strTransaction.contains("VTD"))){
                        
                        let exceptarr = [String.init(format: "RMV\(str2)"),String.init(format: "AMV\(str2)"),String.init(format: "PMV\(str2)")]
                        array = array.filter({ (str) -> Bool in
                            return !(exceptarr.contains(str))
                        })
                    }else{
                        array = array.filter{
                            $0 != strTransaction
                        }
                        let exceptarr = [String.init(format: "RMV\(str2)"),String.init(format: "VTU\(str2)"),String.init(format: "AMV\(str2)"),String.init(format: "VTA\(str2)"),String.init(format: "PMV\(str2)")]
                        array = array.filter({ (str) -> Bool in
                            return !(exceptarr.contains(str))
                        })
                        var exist =  false
                        for dic in arrVisit{
                            if let visitID = dic["ID"] as? String{
                                if(visitID.contains(str2)){
                                    exist = true
                                }
                            }
                            
                        }
                        if(exist == false){
                            arrVisit.append(["ID": str2])
                        }
                        
                        
                    }
                }
                break
                
            case 124:
                //update visit stock data
                
                NotificationCenter.default.post(name: Notification.Name("updateVisitStockData"), object: nil)
                if let strTransaction = dict["TransactionID"] as? String{
                    if((strTransaction.contains("VTO")) || (strTransaction.contains("VTA"))){
                        
                        array = array.filter{
                            $0 != strTransaction
                        }
                        
                        let str2  = strTransaction.substring(from: 3)
                        let exceptarr = [String.init(format: "VTO\(str2)"),String.init(format: "VTU\(str2)"),String.init(format: "VUS\(str2)"),String.init(format: "VTA\(str2)"),String.init(format: "VTR\(str2)"),String.init(format: "ACK\(str2)")]
                        array = array.filter({ (str) -> Bool in
                            return !(exceptarr.contains(str))
                        })
                        
                        var exist =  false
                        for dic in arrVisit{
                            if let visitID = dic["ID"] as? String{
                                if(visitID.contains(str2)){
                                    exist = true
                                }
                            }
                            
                        }
                        if(exist == false){
                            arrVisit.append(["ID": str2])
                        }
                        
                        
                        
                        
                    }
                }
                break
            default:
                //print("notification without type")
                break
            }
        }
    }
    
    func fetchMissedNotificationDataFromCommon(){
        if((arrCompanyUsers.count > 0) || (arrCustomer.count > 0) || (arrContact.count > 0) || (isProfileChanged ==  true)){
            var param = Common.returndefaultparameter()
            param["getCustomerJson"] = Common.json(from: arrCustomer)
            param["getContactJson"] = Common.json(from: arrContact)
            param["getUserJson"] = Common.json(from: arrCompanyUsers)
            if(isProfileChanged){
                param["UserProfileID"] = self.activeUser?.userID
            }
            self.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetMissedData, method: Apicallmethod.get) { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                //print(arr)
                if let dic = arr as? [String:Any]{
                    
                    
                    // New User List
                    if let arrOFnewUser = dic["NewUserList"] as? [[String:Any]]{
                        if(arrOFnewUser.count > 0){
                            MagicalRecord.save { (localcontext) in
                                FEMDeserializer.collection(fromRepresentation: arrOFnewUser, mapping: CompanyUsers.defaultMapping(), context: localcontext)
                            } completion: { (status, error) in
                                //print("New Users Saved.")
                            }
                            
                        }
                    }
                    
                    // New Customer List
                    if let arrOFnewCustomer = dic["NewCustomerList"] as? [[String:Any]]{
                        if(arrOFnewCustomer.count > 0){
                            MagicalRecord.save { (localcontext) in
                                FEMDeserializer.collection(fromRepresentation: arrOFnewCustomer, mapping: CustomerDetails.defaultmapping() , context: localcontext)
                                
                            } completion: { (status, error) in
                                //print("New customer Saved.")
                                //                        for cust in CustomerDetails.getAllCustomers(){
                                //                            for add in cust.addressList{
                                //                                if  let address =  add as? AddressList{
                                //
                                //                            //print("Customer address = \(cust.addressList)")
                                //                            }
                                //                                }
                                //                        }
                            }
                            
                        }
                        let setting = Utils().getActiveSetting()
                        for cust in arrOFnewCustomer{
                            if(setting.customTagging == 3){
                                let tagstatus = cust["TaggedStatus"] as? String ?? ""
                                if(tagstatus == "none"){
                                    let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Contact")
                                    fetchrequest.predicate = NSPredicate.init(format: "CustomerID == %@", cust["ID"] as! CVarArg)
                                    
                                    let context = Contact.getContext()
                                    
                                    do{
                                        let array = try context.fetch(fetchrequest) as [Lead]
                                        for lead in array {
                                            context.delete(lead)
                                        }
                                        
                                        context.mr_saveToPersistentStore { (status, error) in
                                            //print("context saved")
                                        }
                                    }catch{
                                        
                                    }
                                }else{
                                    var diclist = [[String:Any]]()
                                    let ContcatList = cust["CustomerContactList"] as? [[String:Any]] ?? [[String:Any]]()
                                    for i in 0...ContcatList.count{
                                        let custcont = ContcatList[i]
                                        var custcont1 = custcont
                                        custcont1["CustomerVendor.Type"] = "U"
                                        
                                        diclist.insert(custcont1, at: i)
                                    }
                                    MagicalRecord.save { (localcontext) in
                                        FEMDeserializer.collection(fromRepresentation: diclist , mapping: Contact.defaultMapping(), context: localcontext)
                                    } completion: { (status, error) in
                                        //print("New Contact saved")
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    //NEW Contact List
                    var diclist = [[String:Any]]()
                    let ContcatList = dic["NewContactList"] as? [String:Any] ?? [String:Any]()
                    for key in ContcatList.keys{
                        let arrContact = ContcatList[key] as? [[String:Any]] ?? [[String:Any]]()
                        for i in 0...arrContact.count-1 {
                            let custcont = arrContact[i]
                            var custcont1 = custcont
                            custcont1["CustomerVendor.Type"] = key
                            
                            diclist.insert(custcont1, at: i)
                        }
                    }
                    MagicalRecord.save { (localcontext) in
                        FEMDeserializer.collection(fromRepresentation: diclist , mapping: Contact.defaultMapping(), context: localcontext)
                    } completion: { (status, error) in
                        //print("New Contact saved")
                    }
                    
                    //update change mobile number
                    let dicprofile = dic["NewUserProfile"] as? [String:Any] ?? [String:Any]()
                    if(!dicprofile.isEmpty){
                        self.isProfileChanged = false
                        let acaccount = Utils().getActiveAccount()
                        let tempaccount = DataUser.init(dictionary: dicprofile)
                        tempaccount.securityToken = acaccount?.securityToken
                        Utils.setDefultvalue(key: Constant.kCurrentUser, value: tempaccount.toDictionary())
                        //print("Account Saved Successful")
                    }
                    self.fetchMissedNotificationData()
                }
            }
            
        }else{
            self.fetchMissedNotificationData()
        }
    }
    
    func fetchMissedNotificationData(){
        if((arrLead.count > 0) || (arrVisit.count > 0) || (arrProductCatgory.count > 0) || (arrProduct.count > 0 ) || (arrPO.count > 0) || (arrPropsal.count > 0) || (arrSO.count > 0) || (isCompanySettingChanged == true) || (isSettingChanged == true) || (isVisitOutcomes ==  true) || (isLeadOutcomes == true) || (arrBeatPlanAssign.count  > 0 )){
            
            var param = Common.returndefaultparameter()
            param["getVisitJson"] =  Common.json(from: arrVisit)
            param["getLeadJson"] = Common.json(from: arrLead)
            param["getProductCategoryJson"] = Common.json(from: arrProductCatgory)
            param["getProductJson"] = Common.json(from: arrProduct)
            param["getPRoposalJson"] = Common.json(from: arrPropsal)
            param["getSalesOrderJson"] = arrSO.rs_jsonString(withPrettyPrint: true)
            param["getPurchaseOrderJson"] = Common.json(from: arrPO)
            if(isSettingChanged == true){
                param["getSettingJson"] = Common.returnjsonstring(dic: ["CompanyID":self.activeUser?.company?.iD])
                
            }else{
                param["getSettingJson"] = Common.returnjsonstring(dic: [:])
            }
            if(isCompanySettingChanged){
                param["getCompanyInfoJson"] = Common.returnjsonstring(dic: ["CompanyID":self.activeUser?.company?.iD])
            }
            if(isLeadSource){
                param["getLeadSourceJson"] = Common.returnjsonstring(dic: ["CompanyID":self.activeUser?.company?.iD])
            }else{
                param["getLeadSourceJson"] = Common.returnjsonstring(dic: [:])
            }
            //getLeadOutComeJson
            if(isLeadOutcomes){
                param["getLeadOutComeJson"] = Common.returnjsonstring(dic: ["CompanyID":self.activeUser?.company?.iD])
            }else{
                param["getLeadOutComeJson"] = Common.returnjsonstring(dic: [:])
            }
            if(isVisitOutcomes){
                param["getVisitOutComeJson"] = Common.returnjsonstring(dic: ["CompanyID":self.activeUser?.company?.iD])
            }else{
                param["getVisitOutComeJson"] = Common.returnjsonstring(dic: [:])
            }
            
            apicall(url: ConstantURL.kWSUrlGetMissedNotificationData, param: param, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                if(error.code == 0){
                    self.isSettingChanged = false
                    self.isCompanySettingChanged = false
                    let dicres = arr as? [String:Any] ?? [String:Any]()
                    
                    //NEW Visit
                    let arrVisitList  =  dicres["NewVisitList"] as? [[String:Any]] ?? [[String:Any]]()
                    if(arrVisitList.count > 0){
                        var mutarr = [[String:Any]]()
                        for visit in arrVisitList{
                            let customerID = NSNumber.init(value: visit["CustomerID"] as? Int ?? 0)
                            var dic = [String:Any]()
                            dic = visit
                            if let strcustname = CustomerDetails.getCustomerNameByID(cid: customerID) as? String{
                                dic["CustomerName"] = strcustname
                            }else{
                                dic["CustomerName"] = "Customer Not Mapped"
                            }
                            let companyuerID = NSNumber.init(value: visit["ReAssigned"] as? Int ?? 0)
                            var strreassigned = ""
                            if let companyuser = CompanyUsers().getUser(userId: companyuerID){
                                strreassigned = String.init(format: "\(companyuser.firstName) \(companyuser.lastName)")
                            }
                            dic["RessigneeName"] =  strreassigned
                            mutarr.append(dic)
                            
                            let dicID = dic["ID"]
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVF\(dicID)")])
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVS\(dicID)")])
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "PVM\(dicID)")])
                            
                            //create reminder
                            let setting = Utils().getActiveSetting()
                            if(Utils.isAlaramPossible(dict: visit)){
                                var dateForReminder =  Utils.getDateFromStringWithFormat(gmtDateString: visit["NextActionTime"] as? String ?? "")
                                if(dateForReminder ==  nil){
                                    dateForReminder = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: visit["NextActionTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format: "yyyy/MM/dd HH:mm:ss")
                                }
                                dateForReminder = dateForReminder.addingTimeInterval(-(Double((60) * (setting.visitReminderFirst  as! Int))))
                                if(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd HH:mm:ss").compare(dateForReminder) == .orderedAscending){
                                    var customername = ""
                                    if let customerid = CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:visit["CustomerID"] as? Int ?? 0)){
                                        customername = customerid
                                    }
                                    var visitprefixno = ""
                                    if let VisitNo = visit["SeriesPrefix"] as? String{
                                        visitprefixno = VisitNo
                                    }
                                    var visitpostfixno = ""
                                    if let VisitNo = visit["SeriesPostfix"] as? String{
                                        visitpostfixno = VisitNo
                                    }
                                    var strNetActionTime = ""
                                    if let strnextActionTime  = visit["NextActionTime"] as? String{
                                        //Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:dt[@"NextActionTime"] andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"hh:mm a"]
                                        if let strnt = Utils.getDateBigFormatToDefaultFormat(date: strnextActionTime, format: "yyyy/MM/dd HH:mm:ss"){
                                            strNetActionTime = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a")
                                        }
                                    }
                                    Utils.scheduleAlarm(title: "Planned Visit Next Action Reminder", category: "Visit", message: String.init(format: "Your next action for Customer \(customername) for Planned Visit No. \(visitprefixno)\(visitpostfixno) is at \(strNetActionTime)"), date: dateForReminder, userInfo: ["EventID":String.init(format: "PVF\(visit["ID"])")])
                                    
                                }
                                
                                if(setting.visitReminder == 2){
                                    
                                    var dateForReminder =  Utils.getDateFromStringWithFormat(gmtDateString: visit["NextActionTime"] as? String ?? "")
                                    if(dateForReminder ==  nil){
                                        dateForReminder = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: visit["NextActionTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format: "yyyy/MM/dd HH:mm:ss")
                                    }
                                    dateForReminder = dateForReminder.addingTimeInterval(-(Double((60) * (setting.visitReminderFirst  as! Int))))
                                    if(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd HH:mm:ss").compare(dateForReminder) == .orderedAscending){
                                        var customername = ""
                                        if let customerid = CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:visit["CustomerID"] as? Int ?? 0)){
                                            customername = customerid
                                        }
                                        var visitprefixno = ""
                                        if let VisitNo = visit["SeriesPrefix"] as? String{
                                            visitprefixno = VisitNo
                                        }
                                        var visitpostfixno = ""
                                        if let VisitNo = visit["SeriesPostfix"] as? String{
                                            visitpostfixno = VisitNo
                                        }
                                        var strNetActionTime = ""
                                        if let strnextActionTime  = visit["NextActionTime"] as? String{
                                            //Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:dt[@"NextActionTime"] andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"hh:mm a"]
                                            if let strnt = Utils.getDateBigFormatToDefaultFormat(date: strnextActionTime, format: "yyyy/MM/dd HH:mm:ss"){
                                                strNetActionTime = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a")
                                            }
                                        }
                                        Utils.scheduleAlarm(title: "Planned Visit Next Action Reminder", category: "Visit", message: String.init(format: "Your next action for Customer \(customername) for Planned Visit No. \(visitprefixno)\(visitpostfixno) is at \(strNetActionTime)"), date: dateForReminder, userInfo: ["EventID":String.init(format: "PVS\(visit["ID"])")])
                                    }
                                }
                                dateForReminder =  Utils.getDateFromStringWithFormat(gmtDateString: visit["NextActionTime"] as? String ?? "")
                                if(dateForReminder ==  nil){
                                    dateForReminder = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: visit["NextActionTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format: "yyyy/MM/dd HH:mm:ss")
                                }
                                dateForReminder = dateForReminder.addingTimeInterval((Double((60) * (setting.visitReminderFirst  as! Int))))
                                if(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd HH:mm:ss").compare(dateForReminder) == .orderedAscending){
                                    
                                    var customername = ""
                                    if let customerid = CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:visit["CustomerID"] as? Int ?? 0)){
                                        customername = customerid
                                    }
                                    var visitprefixno = ""
                                    if let VisitNo = visit["SeriesPrefix"] as? String{
                                        visitprefixno = VisitNo
                                    }
                                    var visitpostfixno = ""
                                    if let VisitNo = visit["SeriesPostfix"] as? String{
                                        visitpostfixno = VisitNo
                                    }
                                    var strNetActionTime = ""
                                    if let strnextActionTime  = visit["NextActionTime"] as? String{
                                        //Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:dt[@"NextActionTime"] andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"hh:mm a"]
                                        if let strnt = Utils.getDateBigFormatToDefaultFormat(date: strnextActionTime, format: "yyyy/MM/dd HH:mm:ss"){
                                            strNetActionTime = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a")
                                        }
                                    }
                                    
                                    
                                    Utils.scheduleAlarm(title: "Planned Visit Next Action Reminder", category: "Visit", message: String.init(format: "Your next action for Customer \(customername) for Planned Visit No. \(visitprefixno)\(visitpostfixno) is at \(strNetActionTime)"), date: dateForReminder, userInfo: ["EventID":String.init(format: "PVM\(visit["ID"])")])
                                }
                            }
                            
                        }
                        MagicalRecord.save { (localcontext) in
                            let arr = FEMDeserializer.collection(fromRepresentation: mutarr, mapping: PlannVisit.defaultmapping(), context: localcontext)
                            // //print("data for saving is \(mutarr), in database =  \(arr)")
                        } completion: { (status, error) in
                            
                            ////print("missed visit saved")
                        }
                        
                    }
                    
                    //NEW LEAD
                    let arrLeadList  =  dicres["NewLead"] as? [[String:Any]] ?? [[String:Any]]()
                    if(arrLeadList.count > 0){
                        var mutarr = [[String:Any]]()
                        for lead in arrLeadList{
                            let customerID = NSNumber.init(value: lead["CustomerID"] as? Int ?? 0)
                            var dic = [String:Any]()
                            dic = lead
                            if let strcustname = CustomerDetails.getCustomerNameByID(cid: customerID) as? String{
                                dic["CustomerName"] = strcustname
                            }else{
                                dic["CustomerName"] = "Customer Not Mapped"
                            }
                            let companyuerID = NSNumber.init(value: lead["ReAssigned"] as? Int ?? 0)
                            var strreassigned = ""
                            if let companyuser = CompanyUsers().getUser(userId: companyuerID){
                                strreassigned = String.init(format: "\(companyuser.firstName) \(companyuser.lastName)")
                            }
                            dic["RessigneeName"] =  strreassigned
                            mutarr.append(dic)
                            let dicID = dic["ID"]
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "LNF\(dicID)")])
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "LNS\(dicID)")])
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "LNM\(dicID)")])
                            
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "LRF\(dicID)")])
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "LRS\(dicID)")])
                            Utils.cancelAlaram(userInfo: ["EventID":String.init(format: "LRM\(dicID)")])
                            
                            //create reminder
                            let setting = Utils().getActiveSetting()
                            if(Utils.isAlaramPossible(dict: lead)){
                                var dateForReminder =  Utils.getDateFromStringWithFormat(gmtDateString: lead["NextActionTime"] as? String ?? "")
                                if(dateForReminder ==  nil){
                                    dateForReminder = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: lead["NextActionTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format: "yyyy/MM/dd HH:mm:ss")
                                }
                                dateForReminder = dateForReminder.addingTimeInterval(-(Double((60) * (setting.visitReminderFirst  as! Int))))
                                if(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd HH:mm:ss").compare(dateForReminder) == .orderedAscending){
                                    var customername = ""
                                    if let customerid = CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:lead["CustomerID"] as? Int ?? 0)){
                                        customername = customerid
                                    }
                                    var visitprefixno = ""
                                    if let VisitNo = lead["SeriesPrefix"] as? String{
                                        visitprefixno = VisitNo
                                    }
                                    var visitpostfixno = ""
                                    if let VisitNo = lead["SeriesPostfix"] as? String{
                                        visitpostfixno = VisitNo
                                    }
                                    var strNetActionTime = ""
                                    if let strnextActionTime  = lead["NextActionTime"] as? String{
                                        //Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:dt[@"NextActionTime"] andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"hh:mm a"]
                                        if let strnt = Utils.getDateBigFormatToDefaultFormat(date: strnextActionTime, format: "yyyy/MM/dd HH:mm:ss"){
                                            strNetActionTime = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a")
                                        }
                                    }
                                    Utils.scheduleAlarm(title: "Lead Next Action Reminder", category: "Lead", message: String.init(format: "Your next action for Customer \(customername) for Lead No. \(visitprefixno)\(visitpostfixno) is at \(strNetActionTime)"), date: dateForReminder, userInfo: ["EventID":String.init(format: "LNF\(lead["ID"])")])
                                }
                                
                                
                                if(setting.leadReminder == 2){
                                    
                                    var dateForReminder =  Utils.getDateFromStringWithFormat(gmtDateString: lead["NextActionTime"] as? String ?? "")
                                    if(dateForReminder ==  nil){
                                        dateForReminder = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:lead["NextActionTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format: "yyyy/MM/dd HH:mm:ss")
                                    }
                                    dateForReminder = dateForReminder.addingTimeInterval(-(Double((60) * (setting.visitReminderFirst  as! Int))))
                                    if(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd HH:mm:ss").compare(dateForReminder) == .orderedAscending){
                                        var customername = ""
                                        if let customerid = CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:lead["CustomerID"] as? Int ?? 0)){
                                            customername = customerid
                                        }
                                        var visitprefixno = ""
                                        if let VisitNo = lead["SeriesPrefix"] as? String{
                                            visitprefixno = VisitNo
                                        }
                                        var visitpostfixno = ""
                                        if let VisitNo = lead["SeriesPostfix"] as? String{
                                            visitpostfixno = VisitNo
                                        }
                                        var strNetActionTime = ""
                                        if let strnextActionTime  = lead["NextActionTime"] as? String{
                                            //Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:dt[@"NextActionTime"] andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"hh:mm a"]
                                            if let strnt = Utils.getDateBigFormatToDefaultFormat(date: strnextActionTime, format: "yyyy/MM/dd HH:mm:ss"){
                                                strNetActionTime = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a")
                                            }
                                        }
                                        Utils.scheduleAlarm(title: "Lead Next Action Reminder", category: "Lead", message: String.init(format: "Your next action for Customer \(customername) for Lead No. \(visitprefixno)\(visitpostfixno) is at \(strNetActionTime)"), date: dateForReminder, userInfo: ["EventID":String.init(format: "LNS\(lead["ID"])")])
                                    }
                                }
                                
                                dateForReminder =  Utils.getDateFromStringWithFormat(gmtDateString: lead["NextActionTime"] as? String ?? "")
                                if(dateForReminder ==  nil){
                                    dateForReminder = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: lead["NextActionTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format: "yyyy/MM/dd HH:mm:ss")
                                }
                                dateForReminder = dateForReminder.addingTimeInterval((Double((60) * (setting.visitReminderFirst  as! Int))))
                                if(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd HH:mm:ss").compare(dateForReminder) == .orderedAscending){
                                    var customername = ""
                                    if let customerid = CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:lead["CustomerID"] as? Int ?? 0)){
                                        customername = customerid
                                    }
                                    var visitprefixno = ""
                                    if let VisitNo = lead["SeriesPrefix"] as? String{
                                        visitprefixno = VisitNo
                                    }
                                    var visitpostfixno = ""
                                    if let VisitNo = lead["SeriesPostfix"] as? String{
                                        visitpostfixno = VisitNo
                                    }
                                    var strNetActionTime = ""
                                    if let strnextActionTime  = lead["NextActionTime"] as? String{
                                        //Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:dt[@"NextActionTime"] andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"hh:mm a"]
                                        if let strnt = Utils.getDateBigFormatToDefaultFormat(date: strnextActionTime, format: "yyyy/MM/dd HH:mm:ss"){
                                            strNetActionTime = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a")
                                        }
                                    }
                                    Utils.scheduleAlarm(title: "Lead Next Action Reminder", category: "Lead", message: String.init(format: "Your next action for Customer \(customername) for Lead No. \(visitprefixno)\(visitpostfixno) is at \(strNetActionTime)"), date: dateForReminder, userInfo: ["EventID":String.init(format: "LNM\(lead["ID"])")])
                                }
                                
                                
                                // add Reminder time to reminder
                                let dtreminder = lead["Reminder"] as? Int ?? 0
                                if((setting.leadReminder == 1) && (dtreminder == 1)){
                                    var dateForReminder =  Utils.getDateFromStringWithFormat(gmtDateString: lead["ReminderTime"] as? String ?? "")
                                    if(dateForReminder ==  nil){
                                        dateForReminder = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: lead["ReminderTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format: "yyyy/MM/dd HH:mm:ss")
                                    }
                                    dateForReminder = dateForReminder.addingTimeInterval(-(Double((60) * (setting.visitReminderFirst  as! Int))))
                                    if(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd HH:mm:ss").compare(dateForReminder) == .orderedAscending){
                                        Utils.scheduleAlarm(title: "Lead Next Action Reminder", category: "Lead Reminder", message: String.init(format: "Your Reminder for Customer  \(CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:lead["CustomerID"] as? Int ?? 0))) for Lead No. \(lead["SeriesPrefix"])\(lead["SeriesPostfix"]) is at \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: lead["NeatActionTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "hh:mm a"))"), date: dateForReminder, userInfo: ["EventID":String.init(format: "LRF\(lead["ID"])")])
                                    }
                                    
                                    if(setting.leadReminder == 2){
                                        
                                        var dateForReminder =  Utils.getDateFromStringWithFormat(gmtDateString: lead["ReminderTime"] as? String ?? "")
                                        if(dateForReminder ==  nil){
                                            dateForReminder = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:lead["ReminderTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format: "yyyy/MM/dd HH:mm:ss")
                                        }
                                        dateForReminder = dateForReminder.addingTimeInterval(-(Double((60) * (setting.visitReminderFirst  as! Int))))
                                        if(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd HH:mm:ss").compare(dateForReminder) == .orderedAscending){
                                            Utils.scheduleAlarm(title: "Lead  Reminder", category: "Lead", message: String.init(format: "Your Reminder for Customer \(CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:lead["CustomerID"] as? Int ?? 0))) for Lead No. \(lead["SeriesPrefix"])\(lead["SeriesPostfix"]) is at \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: lead["NeatActionTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "hh:mm a"))"), date: dateForReminder, userInfo: ["EventID":String.init(format: "LRS\(lead["ID"])")])
                                        }
                                    }
                                    
                                    dateForReminder =  Utils.getDateFromStringWithFormat(gmtDateString: lead["Reminder"] as? String ?? "")
                                    if(dateForReminder ==  nil){
                                        dateForReminder = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: lead["ReminderTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format: "yyyy/MM/dd HH:mm:ss")
                                    }
                                    dateForReminder = dateForReminder.addingTimeInterval((Double((60) * (setting.visitReminderFirst  as! Int))))
                                    if(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd HH:mm:ss").compare(dateForReminder) == .orderedAscending){
                                        Utils.scheduleAlarm(title: "Lead  Reminder", category: "Lead", message: String.init(format: "Your Reminder for Customer \(CustomerDetails.getCustomerNameByID(cid: NSNumber.init(value:lead["CustomerID"] as? Int ?? 0))) for Lead No. \(lead["SeriesPrefix"])\(lead["SeriesPostfix"]) is at \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: lead["NeatActionTime"] as? String ?? "2000/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2000/10/10 10:10:10", format: "hh:mm a"))"), date: dateForReminder, userInfo: ["EventID":String.init(format: "LRM\(lead["ID"])")])
                                    }
                                }
                            }
                            
                        }
                        MagicalRecord.save { (localcontext) in
                            print("arr of lead = \(mutarr)")
                            FEMDeserializer.collection(fromRepresentation: mutarr, mapping: Lead.defaultmapping(), context: localcontext)
                            
                            
                        } completion: { (status, error) in
                            
                            //print("missed Lead saved")
                        }
                        
                        
                    }
                    // New Lead Outcomes
                    let arrnewLeadOutcome  =  dicres["NewLeadOutComeList"] as? [[String:Any]] ?? [[String:Any]]()
                    
                    if (arrnewLeadOutcome.count>0) {
                        MagicalRecord.save { (localcontext) in
                            Outcomes.mr_truncateAll(in: localcontext)
                            FEMDeserializer.collection(fromRepresentation: arrnewLeadOutcome , mapping: Outcomes.defaultmapping(), context: localcontext)
                        } completion: { (status, error) in
                            
                            //print("all lead outcome saved :)")
                            for user in Outcomes.getAll(){
                                //print("lead outcome name of \(user.leadOutcomeValue) total lead outcomes \(Outcomes.getAll().count) , id = \(user.leadOutcomeIndexID)")
                            }
                        }
                        
                        
                    }
                    
                    // New Lead Sources
                    let arrnewLeadSource  =  dicres["NewLeadSourceList"] as? [[String:Any]] ?? [[String:Any]]()
                    
                    if (arrnewLeadSource.count>0) {
                        MagicalRecord.save { (localcontext) in
                            LeadSource.mr_truncateAll(in: localcontext)
                            FEMDeserializer.collection(fromRepresentation: arrnewLeadSource , mapping: LeadSource.defaultmapping(), context: localcontext)
                        } completion: { (status, error) in
                            //print("Lead source Saved.")
                        }
                        
                        
                    }
                    
                    // New Visit Outcomes
                    let arrnewVisitOutcome  =  dicres["NewVisitOutComeList"] as? [[String:Any]] ?? [[String:Any]]()
                    
                    if (arrnewVisitOutcome.count>0) {
                        MagicalRecord.save { (localcontext) in
                            VisitOutcomes.mr_truncateAll(in: localcontext)
                            FEMDeserializer.collection(fromRepresentation: arrnewVisitOutcome, mapping: VisitOutcomes.defaultmapping(), context: localcontext)
                        } completion: { (status, error) in
                            //print("Visit Outcomes Saved.")
                        }
                        
                        
                    }
                    
                    // New Product List
                    let arrnewProduct  =  dicres["NewProductList"] as? [[String:Any]] ?? [[String:Any]]()
                    if(arrnewProduct.count > 0){
                        MagicalRecord.save { (localcontext) in
                            FEMDeserializer.collection(fromRepresentation: arrnewProduct, mapping: Product.defaultmapping(), context: localcontext)
                        } completion: { (status, error) in
                            //print("new product saved ")
                        }
                        
                    }
                    
                    
                    
                    // New Product Category List
                    let arrnewProductCategory  =  dicres["NewProductCategoryList"] as? [[String:Any]] ?? [[String:Any]]()
                    
                    if (arrnewProductCategory .count>0) {
                        
                        
                        var arrCat = [[String:Any]]()
                        var arrSubCat = [[String:Any]]()
                        for dicProdcat in arrnewProductCategory{
                            if(dicProdcat.keys.contains("SuperCatID")){
                                if((dicProdcat["SuperCatID"] as? Int ?? 0 ) == 0){
                                    arrCat.append(dicProdcat)
                                }else{
                                    arrSubCat.append(dicProdcat)
                                }
                            }else{
                                arrCat.append(dicProdcat)
                            }
                            
                        }
                        if(arrSubCat.count > 0){
                            MagicalRecord.save { (locacontext) in
                                FEMDeserializer.collection(fromRepresentation: arrSubCat, mapping: ProductSubCat.defaultmapping(), context: locacontext)
                            } completion: { (status, error) in
                                //print("New Product Sub Category List Saved.")
                            }
                            
                        }
                        if(arrCat.count > 0){
                            MagicalRecord.save { (locacontext) in
                                FEMDeserializer.collection(fromRepresentation: arrCat, mapping: ProdCategory.defaultmapping(), context: locacontext)
                            } completion: { (status, error) in
                                //print("New Product Category List Saved.")
                            }
                            
                        }
                    }
                    
                    
                    
                    
                    // Updated Setting
                    if let arrSetting  =  dicres["NewSettings"] as? [String:Any]{
                        let SOloadValue = Utils().getActiveSetting().salesOrderLoadPage
                        let customerApproval = Utils().getActiveSetting().customerApproval
                        let setting = Setting.init(dictionary: arrSetting)
                        setting.salesOrderLoadPage = SOloadValue
                        setting.customerApproval = customerApproval
                        Utils.setDefultvalue(key: Constant.kUserSetting, value: setting.toDictionary())
                    }
                    
                    
                    
                    // Updated Setting
                    if let newcompanysetting = dicres["NewCompanysDetails"] as? [String:Any]{
                        MagicalRecord.save { (localcontext) in
                            //                            FEMDeserializer.collection(fromRepresentation: newcompanysetting, mapping: Company.defaultMapping(), context: localcontext)
                            FEMDeserializer.object(fromRepresentation: newcompanysetting, mapping: Company.defaultMapping(), context: localcontext)
                        } completion: { (status, error) in
                            //print("Company Setting Saved.")
                        }
                        
                    }
                    
                    
                    // New Proposal List
                    let arrProposal = dicres["NewProposalList"] as? [[String:Any]] ?? [[String:Any]]()
                    if(arrProposal.count > 0){
                        MagicalRecord.save { (localcontext) in
                            FEMDeserializer.collection(fromRepresentation: arrProposal, mapping: Proposl.defaultMapping(), context: localcontext)
                        } completion: { (status, error) in
                            //print("New Proposal List Saved.")
                        }
                    }
                    
                    
                    
                    // New Sales Order List
                    let arrSalesOrder = dicres["NewSalesOrderList"] as? [[String:Any]] ?? [[String:Any]]()
                    
                    if (arrSalesOrder.count>0) {
                        var mutarr = [[String:Any]]()
                        for var dic in arrSalesOrder{
                            let customerID = NSNumber.init(value: dic["CustomerID"] as? Int ?? 0)
                            //                            var dic = [String:Any]()
                            if(Utils.isCustomerMapped(cid: customerID)){
                                if let strcustname = CustomerDetails.getCustomerNameByID(cid: customerID){
                                    dic["CustomerName"] = strcustname
                                }else{
                                    dic["CustomerName"] = "Customer Not Mapped"
                                }
                            }else{
                                dic["CustomerName"] =  ""
                            }
                            mutarr.append(dic)
                        }
                        
                        
                        MagicalRecord.save { (localcontext) in
                            FEMDeserializer.collection(fromRepresentation: mutarr, mapping: SOrder.defaultMapping(), context: localcontext)
                        } completion: { (status, error) in
                            //print("New Sales Order List Saved")
                        }
                        
                        
                    }
                }
            }
        }
        
    }
    //for companymenu setting
    func getCompanyMenuSetting(completionresponse: @escaping (ResponseBlock) -> Void){
        var param:[String:Any]!
        param = Common.returndefaultparameter()
        apicall(url: ConstantURL.kWSUrlGetCompanyMenuSetting, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                
                let dicMenu = arr as? [String:Any] ?? [String:Any]()
                print("manu and tab = \(dicMenu)")
                let mns = dicMenu["menuList"] as? [[String:Any]] ?? [[String:Any]]()
                //print("arr of menu list  = \(mns)")
                var menus:NSMutableArray? =  [[String:Any]]() as? NSMutableArray
                if(mns.count > 0){
                    menus = NSMutableArray.init(array: mns)
                    
                    menus?.add(
                        ["ID":NSNumber.init(value: 504) ,
                         "menuID":NSNumber.init(value: 503),
                         "companyID":NSNumber.init(value: 0),
                         "menuValue":"mainGoogleMap",
                         "menuLocalText":"Google Map",
                         "isVisible":true])
                }
                
                let setting = Utils().getActiveSetting()
                // [menus addObject:@{@"ID":@505,@"menuID":@504,@"companyID":@0,@"menuValue":@"plusKPIdata",@"menuLocalText":@"KPI data",@"isVisible":@true}];
                if(setting.showKPIOnSplashScreen == NSNumber.init(value: 1)){
                    menus?.add(
                        ["ID":NSNumber.init(value: 505),
                         "menuID":NSNumber.init(value: 504),
                         "companyID":NSNumber.init(value: 0),
                         "menuValue":"plusKPIdata",
                         "menuLocalText":"KPI data",
                         "isVisible":true])
                }
                
                MagicalRecord.save({ (localContext) in
                    CompanyMenus.mr_truncateAll(in: localContext)
                    FEMDeserializer.collection(fromRepresentation: menus as? [[String:Any]] ?? [[String:Any]]() , mapping: CompanyMenus.defaultMapping() , context: localContext)
                }, completion: { (contextdidsave, error) in
                    //print("Menu Saved")
                    //print("error is \(String(describing: error?.localizedDescription))")
                })
                let tab = dicMenu["tabList"] as? [[String:Any]] ?? [[String:Any]]()//Common.nullToNil(value: dicMenu["tabList"])
                var tabs : NSMutableArray? = [[String:Any]]() as? NSMutableArray
                if(tab.count > 0){
                    tabs = NSMutableArray.init(array: tab)
                    MagicalRecord.save({ (localContext) in
                        MenuTabs.mr_truncateAll(in: localContext)
                        
                        
                        ////print()
                        FEMDeserializer.collection(fromRepresentation: tabs as? [[String:Any]] ?? [[String:Any]]() , mapping: MenuTabs.defaultMapping() , context: localContext)
                    }, completion: { (contextdidsave, error) in
                        if(error?.localizedDescription.count ?? 0 == 0 ){
                            completionresponse((totalpages,pagesavailable,lastsynctime,mns  ,status,"menu tabs sucessfully saved",Common.returnnoerror(),ResponseType.arr))
                            //print(MenuTabs.getAll())
                        }else{
                            completionresponse((totalpages,pagesavailable,lastsynctime,[[:]],status,"",error as NSError? ?? Common.returnnoerror(),ResponseType.none))
                        }
                        //print("Tab Saved")
                        
                    })
                    
                }
                
            }else{
                //print(error.localizedDescription)
                completionresponse((totalpages,pagesavailable,lastsynctime,[[:]],status,error.localizedDescription,error,responseType:ResponseType.none))
            }
        }
    }
    
    //get user
    func getUser(completion: @escaping (ResponseBlockstr) -> Void){
        let param = Common.returndefaultparameter()
        //print("parameter of get user = \(param)")
        //        apicall(url: ConstantURL.kWSUrlGetUser , param: param, method: Apicallmethod.get) {
        //            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        RestAPIManager.httpRequest(ConstantURL.kWSRESTUrlGetUser, .get, parameters: param, isTeamWorkUrl: false) { (response, sucess, error) in
            
            if(sucess){
                
                let dic = response as? [String:Any] ?? [String:Any]()
                let activieaccount = Utils().getActiveAccount()
                
                let securityToken = activieaccount?.securityToken
                self.isSettingChanged = false
                var updatedDic = [String:Any]()
                let dicUser = dic["User"] as? [String:Any] ?? [String:Any]()
                let dicRole = dicUser["role"] as? [String:Any] ?? [String:Any]()
                updatedDic["roleId"] = dicRole["id"]
                let dicCompany = dicUser["company"] as? [String:Any] ?? [String:Any]()
                updatedDic["CompanyID"] = dicCompany["ID"]
                
                updatedDic["Address_Verified"] = dicUser["Address_Verified"]
                updatedDic["ApplicationID"] =  dicUser["ApplicationID"]
                updatedDic["CountryCode"] =  dicUser["CountryCode"]
                updatedDic["DeviceID"] =  dicUser["DeviceID"]
                updatedDic["DeviceType"] =  dicUser["DeviceType"]
                updatedDic["DottedManagerID"] =  dicUser["DottedManagerID"]
                updatedDic["EmailID"] =  dicUser["EmailID"]
                updatedDic["EmailVerified"] =  dicUser["EmailVerified"]
                updatedDic["FirstName"] =  dicUser["FirstName"]
                updatedDic["Gender"] =  dicUser["Gender"]
                updatedDic["IsAllowApproveLeave"] =  dicUser["IsAllowApproveLeave"]
                updatedDic["IsCheckInAllowedFromHome"] =  dicUser["IsCheckInAllowedFromHome"]
                updatedDic["IsFreeze"]  =  dicUser["IsFreeze"]
                updatedDic["JoiningDate"] =  dicUser["JoiningDate"]
                updatedDic["LastModified"] =  dicUser["LastModified"]
                updatedDic["LastModifiedBy"] =  dicUser["LastModifiedBy"]
                updatedDic["LastName"] =  dicUser["LastName"]
                updatedDic["Manager"] =  dicUser["Manager"] as? [String:Any]
                updatedDic["MobileNo1"] =  dicUser["MobileNo1"]
                updatedDic["MobileNo2"]  =  dicUser["MobileNo2"]
                updatedDic["SecurityToken"] =  dicUser["SecurityToken"]
                updatedDic["UserID"] =  dicUser["UserID"]
                updatedDic["applicationGcmID"]  =  dicUser["applicationGcmID"]
                updatedDic["basetowncityID"] =  dicUser["basetowncityID"]
                updatedDic["branchAddress"] =  dicUser["branchAddress"]
                updatedDic["branchID"] =  dicUser["branchID"]
                updatedDic["company"] =  dicUser["company"]
                updatedDic["departmentID"] =  dicUser["departmentID"]
                updatedDic["designationID"] =  dicUser["designationID"]
                updatedDic["employeeCode"]  =  dicUser["employeeCode"]
                updatedDic["gradelevelID"] =  dicUser["gradelevelID"]
                updatedDic["invalidLoginAttempt"] =  dicUser["invalidLoginAttempt"]
                updatedDic["isGeoFencing"] =  dicUser["isGeoFencing"]
                updatedDic["otpGenerateTime"] =  dicUser["otpGenerateTime"]
                updatedDic["permanentAddress"]  =  dicUser["permanentAddress"]
                updatedDic["picture"] =  dicUser["picture"]
                updatedDic["role"] =  dicUser["role"]
                //                updatedDic["roleId"] =  dicUser["roleId"]
                updatedDic["otpGenerateTime"] =  dicUser["otpGenerateTime"]
                updatedDic["temporaryAddress"]  =  dicUser["temporaryAddress"]
                //print("updated dic = \(updatedDic)")
                let user = DataUser.init(dictionary: updatedDic)
                user.securityToken = securityToken
                let dicofuser = user.toDictionary()
                //print("dic = \(dicofuser) updated dic = \(updatedDic)")
                Utils.setDefultvalue(key: Constant.kCurrentUser, value:dicofuser)
                
                
                
            }else{
                completion(("get some error",false))
                // completion((totalpages,pagesavailable,lastsynctime,[[:]],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    
    func getMissedNotifications(completion: @escaping (ResponseBlock) -> Void){
        var param = Common.returndefaultparameter()
        //56 new reporting memeber,68 Document assigned,69 document removed,81 sales person address change,129 Missed users checkin checkout list,130 Daily Sales Plan,132 Update Leave balance,133 Apply leave,134 withdraw leave,135 update attendance check in checkout approval,137 Attendance checkin checkout request  --- Approval,138 Leave acknowledgement [ approve or reject leave],139 // Manual Attendance  request ---- Approval,160 Send log file,146 auto checkin , 147 auto checkout,144   //Tracking provide current location,145 //Tracking update current location,148  //Called from tracking scheduler If tracking is Miss,ed,149 //Missed users checkin list for attendance,150 Create Beat Plan,156 customer visit reminder,163 Assign Beat Plan Approval and Notification,167 //Approval for working hours,165  //Notification for SUPERTRADE_DISTRIBUTOR_ADD_SALES,166 //Notification for SUPERTRADE_RETAILER_PURCHASE_RETURN,168 //notification for max hour approval,169 //Notification for SUPERTRADE_RETAILER_PARTIAL_PURCHASE_REQUEST,170: //Notification for SUPERTRADE_DISTRIBUTOR_PARTIAL_PURCHASERETUN_REQUEST, 171: //Notification for SUPERTRADE_DISTRIBUTOR_SALES_RETURN, 172: //Notification for SUPERTRADE_DISTRIBUTOR_ADD_PO, 173: //Notification for SUPERTRADE_DISTRIBUTOR_ADD_PURCHASE, 174: //Notification for SUPERTRADE_DISTRIBUTOR_PURCHASE_RETURN,180: //Valid Attendance  --- Approval,183 travel request,184 Travel Claim,185 Travel Request Approval,186 Travel Claim Approval
        param["Type"] = "15,19,24,25,27,28,29,30,31,32,42,43,44,47,48,50,51,52,53,56,57,58,61,62,68,69,75,78,79,80,81,82,83,86,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,163,164,165,166,167,168,169,170,171,172,173,174,180,183,184,185,186"
        param["LastSynchTime"] =  Utils.getDefaultStringValue(key: Constant.kSyncTime)
        //print("paramaeter for  missed notification = \(param)")
        apicall(url: ConstantURL.kWSUrlGetNotifications , param: param, method: Apicallmethod.get) {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                //print(responseType)
                //print("response of missed notification = \(arr)")
                let dic = arr as? [[String:Any]] ?? [[String:Any]]()
                
                if let lastsynctime = lastsynctime {
                    let dateformatter = DateFormatter.init()
                    dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                    Utils.setDefultvalue(key: Constant.kSyncTime, value: Utils.getDateinstrwithaspectedFormat(givendate: Utils.getDateFromStringWithFormat(gmtDateString: lastsynctime).addingTimeInterval(-10), format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: true))
                    //print("last sync time is  = \(lastsynctime) in default = \(Utils.getDefaultStringValue(key: Constant.kSyncTime))")
                    
                    self.array = [String]()
                    for noti in dic{
                        self.array.append(noti["TransactionID"] as! String)
                    }
                    
                    
                    for noti in dic{
                        
                        self.filterNotifications(dict: noti)
                    }
                    self.fetchMissedNotificationDataFromCommon()
                }
            }else{
                completion((totalpages,pagesavailable,lastsynctime,[[:]],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    //get lower hierarchy users
    func getLowerHierarchyUser(completion: @escaping (ResponseBlock) -> Void){
        var param = Common.returndefaultparameter()
        let activeUser = Utils().getActiveAccount()
        param["userid"] = activeUser?.userID?.stringValue
        param["companyid"] = activeUser?.company?.iD?.stringValue
        param["rolelevel"] = NSNumber.init(value: 9)
        apicall(url: ConstantURL.kWSUrlgetLowerHeirarchy , param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                //print(arr)
                let arrOflowerHierachyCustomer = arr as? [[String:Any]] ?? [[String:Any]]()
                let arrOfUser = arr as? [[String:Any]] ?? [[String:Any]]()
                let activeuser = Utils().getActiveAccount()
                
                var arrId:[NSNumber] = [activeuser?.userID ?? NSNumber.init(value:0)]
                if(arrOfUser.count > 0){
                    
                    for item in arrOfUser{
                        arrId.append(NSNumber.init(value: (item["id"] as? Int ?? 0)))
                    }
                    //    print(arrOfUser["id"])
                    BaseViewController.staticlowerUser = [CompanyUsers]()
                    
                    self.lowerExecutiveUser = [CompanyUsers]()
                    for user in BaseViewController.staticlowerUser{
                        print("role id = \(user.role_id.intValue) at apihelper file")
                    }
                    BaseViewController.staticlowerUser = BaseViewController.staticlowerUser.filter{
                        $0.role_id.intValue <=  8
                    }
                    //  self.lowerExecutiveUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrexecutiveId)
                    BaseViewController.staticlowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                    self.lowerUser = [CompanyUsers]()
                    self.lowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                    completion((totalpages,pagesavailable,lastsynctime,arrOflowerHierachyCustomer,status,"",Common.returnnoerror(),ResponseType.arr))
                }
            }else{
                completion((totalpages,pagesavailable,lastsynctime,[[:]],status,error.localizedDescription,error,ResponseType.none))
            }
        }
    }
    //get All Contact
    func getAllContact(completion: @escaping (ResponseBlock) -> Void){
        let param = Common.returndefaultparameter()
        apicall(url: ConstantURL.kWSUrlGetAllContact , param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            let dicOfContact = arr as? [String:Any]
            if(error.code == 0){
                
                var arrList = [[String:Any]]()
                if(dicOfContact?.keys.count ?? 0 > 0){
                    let keys: Array<String> = Array<String>((dicOfContact?.keys)!)
                    for key in keys{
                        let arrOfs = dicOfContact?[key] as? [[String:Any]] ?? [[String:Any]]()
                        if(arrOfs.count > 0){
                            for int in 0...(arrOfs.count-1){
                                let dic = NSMutableDictionary.init(dictionary: arrOfs[int])
                                dic.addEntries(from: ["type":key])
                                arrList.append(dic as? [String : Any] ?? [String:Any]())
                            }
                        }
                        
                    }
                    
                }
                
                
                
                
                
                
                if(arrList.count > 0){
                    MagicalRecord.save({ (localcontext) in
                        Contact.mr_truncateAll(in: localcontext)
                        //print(arrList.first ?? ["":""])
                        /*          for (key, value) in arrList.first ?? ["":""]{
                         //print("key is  = \(arrList.first?[key] ?? "gvrvr")")
                         //print("Type of key is = \(type(of: value))")
                         }*/
                        FEMDeserializer.collection(fromRepresentation: arrList, mapping: Contact.defaultMapping(), context: localcontext)
                        //print(type(of: arrList))
                        localcontext.mr_save({ (localcontext) in
                            //print("saving")
                        }, completion: { (status, error) in
                            //print("saved")
                        })
                    }, completion: { (status, error) in
                        //print(Contact.getAll().count)
                        //print(error?.localizedDescription ?? "no error in cotact saving")
                        
                    })
                }
                completion((totalpages,pagesavailable,lastsynctime,arrList,status,message,error: Common.returnnoerror(),ResponseType.arr))
            }else{
                completion((totalpages,pagesavailable,lastsynctime,[[:]],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    
    //get Activity List
    func getAllActivity(completion: @escaping (ResponseBlock) -> Void){
        var param = Common.returndefaultparameter()
        var dicActivity = [String:Any]()
        dicActivity["CompanyID"] = self.activeUser?.company?.iD//self.activeuser?.company?.iD
        dicActivity["CreatedBy"] = self.activeUser?.userID// self.activeuser?.userID
        param["getPlannedActivityjson"] = Common.returnjsonstring(dic: dicActivity)
        self.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetPlannedActivity, method: Apicallmethod.get)
        { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                
                let arrOfActivity = arr as? [[String:Any]] ?? [[String:Any]]()
                var mutArrOfActivity = [[String:Any]]()
                
                for activity in arrOfActivity{
                    //print("dic of Activity  = \(activity)")
                    
                    if let dicOfAddress = activity["AddressDetails"] as? [String:Any]{
                        var mutdicadd = dicOfAddress
                        mutdicadd["AddressID"] = 0
                        let addtype = mutdicadd["Type"] as? NSNumber
                        mutdicadd["Type"] = addtype?.stringValue
                        var editedAct = activity
                        editedAct["AddressDetails"] = mutdicadd
                        mutArrOfActivity.append(editedAct)
                    }
                    
                    
                }
                
                MagicalRecord.save { (localcontext) in
                    Activity.mr_truncateAll(in: localcontext)
                    let act =  FEMDeserializer.collection(fromRepresentation:  mutArrOfActivity, mapping: Activity.defaultMapping(), context: localcontext)
                    //print("activity = \(act) ")
                    
                    
                    
                    for activity in Activity.getAll(){
                        if  let visitcheckinoutlistobj = ActivityCheckinCheckout().getActivitycheckinoutFromID(visitID: NSNumber.init(value:activity.activityId)) as? ActivityCheckinCheckout{
                            //print("counts of checkin before add check in activity \(activity.activityCheckInCheckOutList.count) object  =  \(visitcheckinoutlistobj) checkin time = \(visitcheckinoutlistobj.checkInTime)")
                            //                                let mutableCheckinList = activity.activityCheckInCheckOutList as! NSMutableOrderedSet
                            //                                activity.activityCheckInCheckOutList = mutableCheckinList
                        }
                        
                        activity.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                            if(error == nil){
                                //print("checkin data saved sucessfully , count \(activity.activityCheckInCheckOutList.count) for activity of  customer   =  \(activity.activityId)")
                                
                                
                                
                                
                            }else{
                                //print(error?.localizedDescription ?? "")
                            }
                        })
                    }
                    localcontext.mr_saveToPersistentStoreAndWait()
                } completion: { (status, error) in
                    //print("New Activity Saved. and total activity is \(Activity.getAll().count)")
                    for activity in Activity.getAll(){
                        if  let visitcheckinoutlistobj = ActivityCheckinCheckout().getActivitycheckinoutFromID(visitID: NSNumber.init(value:activity.activityId)) as? ActivityCheckinCheckout{
                            //print("counts of checkin before add check in activity \(activity.activityCheckInCheckOutList.count) object  =  \(visitcheckinoutlistobj) checkin time = \(visitcheckinoutlistobj.checkInTime)")
                            let mutableCheckinList = activity.activityCheckInCheckOutList as! NSMutableOrderedSet
                            activity.activityCheckInCheckOutList = mutableCheckinList
                        }
                        
                        activity.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                            if(error == nil){
                                //print("checkin data saved sucessfully , count \(activity.activityCheckInCheckOutList.count) for activity  \(activity.customerName)")
                            }else{
                                //print(error?.localizedDescription ?? "")
                            }
                        })
                    }
                    
                }
                
                completion((totalpages,pagesavailable,lastsynctime,arrOfActivity,status,message,error: Common.returnnoerror(),ResponseType.arr))
                
            }else{
                completion((totalpages,pagesavailable,lastsynctime,[[:]],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    
    //get All Vendor
    func getAllVendor(completion: @escaping (ResponseBlock) -> Void){
        let param = Common.returndefaultparameter()
        apicall(url: ConstantURL.kWSUrlGetAllVendor , param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            //print(arr)
            
            let arrOfVendor = arr as? [[String:Any]] ?? [[String:Any]]()
            if(error.code == 0){
                if(arrOfVendor.count > 0){
                    MagicalRecord.save({ (localContext) in
                        Vendor.mr_truncateAll(in: localContext)
                        
                        FEMDeserializer.collection(fromRepresentation: arrOfVendor, mapping: Vendor.defaultmapping(), context: localContext)
                        localContext.mr_save({ (localContext) in
                            //print("saving")
                        }, completion: { (status, error) in
                            //print("saved")
                        })
                    }, completion: { (status, error) in
                        //getAll
                        
                        //print("all vendor fetched")
                    })
                    
                }
                completion((totalpages,pagesavailable,lastsynctime,arrOfVendor,status,message,error: Common.returnnoerror(),ResponseType.arr))
            }else{
                completion((totalpages,pagesavailable,lastsynctime,[[:]],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    
    //get tagged customer list
    func getTaggedCustomerList(pageno:NSNumber,pagesize:NSNumber,completion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        param["PageNo"] = pageno
        param["PageSize"] = pagesize
        
        apicallCustomerList(url: ConstantURL.kWSUrlGetAllTaggedCustomer , param: param, method: Apicallmethod.get) { (totalRecords,totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            //print(arr)
            //print(error)
            if(error.code == 0){
                //print(arr)
                
                let arrOfTaggedCustomer = arr as? [[String:Any]] ?? [[String:Any]]()
                
                
                print("array of customer = \(arrOfTaggedCustomer)")
                
                //           var  noOfTotalCustomer  = 0
                //            if(totalpages == 1){
                //                noOfTotalCustomer = arrOfTaggedCustomer.count
                //            }else if (totalpages > 1){
                //                noOfTotalCustomer = totalpages
                //            }
                let noOfTotalCustomer  = totalRecords
                let noOFCustomer = Utils.getDefaultIntValue(key: Constant.kNoOfCustomer)
                Utils.setDefultvalue(key: Constant.kTotalCustomer, value: totalRecords)
                
                print("arr of customer count = \(arrOfTaggedCustomer.count) , no of total customer = \(noOfTotalCustomer) , no of customer = \(noOFCustomer)")
                if((arrOfTaggedCustomer.count > 0) && ((noOfTotalCustomer < noOFCustomer) || noOFCustomer == 0)){
                    MagicalRecord.save({ (localcontext) in
                        if(pageno == 1){
                            CustomerDetails.mr_truncateAll(in: localcontext)
                        }
                        /*'Unacceptable type of value for ordered to-many relationship: property = "addressList"; desired type = NSOrderedSet; given type = __NSArrayM;*/
                        
                        
                        FEMDeserializer.collection(fromRepresentation: arrOfTaggedCustomer, mapping: CustomerDetails.defaultmapping(), context: localcontext)
                        
                        
                        localcontext.mr_save({ (localcontext) in
                            //print("saving")
                        }, completion: { (status, error) in
                            //print("saved")
                        })
                        
                        
                        
                    }, completion: { (status, error) in
                        
                        if(error?.localizedDescription == ""){
                            print("tagged customer saved sucessfully total customer = \(CustomerDetails.getAllCustomers().count)")
                            
                        }else{
                            //print(error?.localizedDescription ?? "")
                        }
                        
                    })
                    
                    // if(pageno.intValue < totalpages){
                    
                    //    if(noOfCustomer < CustomerDetails.getAllCustomers().count && noOfCustomer > Constant.kNoOFCustomerLimit){
                    print("page is available for tagged customer api \(pagesavailable)")
                    self.getTaggedCustomerList(pageno: NSNumber.init(value: pageno.intValue + 1),pagesize: pagesize , completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                        completion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
                    })
                    
                    //  }
                    
                }
                else{
                    print("count is not ok = ")
                    completion((totalpages,pagesavailable,lastsynctime,arrOfTaggedCustomer,status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.arr))
                }
                //   }
                
                
            }else{
                completion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    
    //get product category
    func  getproductcategory(jsonstring:String,pageno:NSNumber,pagesize:NSNumber,completion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        param["PageNo"] = pageno
        param["PageSize"] = pagesize
        param["get_ProductCategory"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetProductCategory , param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                //print(arr)
                let arrProductCat = arr as? [[String:Any]] ?? [[String:Any]]()
                //print(arrProductCat)
                print("array of product cat = \(arrProductCat.count) for page no  = \(pageno) , \(pagesavailable),\(totalpages) , records in one page = \(pagesize)")
                if(arrProductCat.count > 0){
                    MagicalRecord.save({ (localcontext) in
                        if (pageno==1){
                            ProdCategory.mr_truncateAll(in: localcontext)
                        }
                        FEMDeserializer.collection(fromRepresentation: arrProductCat , mapping: ProdCategory.defaultmapping(), context: localcontext)
                        localcontext.mr_save({ (localcontext) in
                            //print("saving")
                        }, completion: { (status, error) in
                            //print("saved")
                        })
                    },completion:{
                        (status, error) in
                        //print("\(status) and error ,\(String(describing: error?.localizedDescription))")
                        
                        if(error == nil){
                            
                        }else{
                            
                        }
                        
                    })
                    
                    if(pageno.intValue < totalpages){
                        print("page is available for tagged customer api \(pagesavailable)")
                        self.getproductcategory(jsonstring:"",pageno:NSNumber.init(value: pageno.intValue + 1),pagesize: pagesize , completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                            //   self.getTaggedCustomerList(pageno: NSNumber.init(value: pageno.intValue + 1),pagesize: pagesize , completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                            completion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
                        })
                        //                self.getTaggedCustomerList(pageno: NSNumber.init(value: pageno.intValue + 1),pagesize: pagesize , completion: {
                        //                    nil
                        //                })
                    }else{
                        
                    }
                    /*
                     'Unacceptable type of value for attribute: property = "vAT"; desired type = NSNumber; given type = __NSSingleObjectArrayI; value = (
                     0
                     ).'
                     */
                    
                }
                completion((totalpages,pagesavailable,lastsynctime,arrProductCat,status,message,error: Common.returnnoerror(),ResponseType.arr))
            }else{
                completion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    
    func getSyncronisedProduct(pageno:NSNumber,pagesize:NSNumber,compeletion: @escaping (ResponseBlock)-> Void){
        var  param = Common.returndefaultparameter()
        param["PageNo"] = pageno
        param["PageSize"] = pagesize
        param["get_SyncProduct"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetSyncProduct, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                
                let arrProduct = arr as? [[String:Any]] ?? [[String:Any]]()
                print("array of product sync = \(arrProduct.count) for page no  = \(pageno) , \(pagesavailable),\(totalpages) , records in one page = \(pagesize)")
                //print(arrProduct)
                if(arrProduct.count > 0){
                    MagicalRecord.save({ (localcontext) in
                        if (pageno==1){
                            Product.mr_truncateAll(in: localcontext)
                        }
                        FEMDeserializer.collection(fromRepresentation: arrProduct, mapping: Product.defaultmapping(), context: localcontext)
                        localcontext.mr_save({ (localcontext) in
                            //print("saving")
                        }, completion: { (status, error) in
                            //print("saved")
                        })
                    },completion:{
                        (status, error) in
                        //print("\(status) and error ,\(String(describing: error?.localizedDescription))")
                        //print("All Product  Fetched")
                        //print(Product.getAll())
                        
                        
                    })
                    if(pageno.intValue < totalpages){
                        print("page is available for tagged customer api \(pagesavailable)")
                        self.getSyncronisedProduct(pageno: NSNumber.init(value: pageno.intValue + 1),pagesize: pagesize , compeletion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                            //   completion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
                            //     })
                            //                self.getTaggedCustomerList(pageno: NSNumber.init(value: pageno.intValue + 1),pagesize: pagesize , completion: {
                            //                    nil
                        })
                    }else{
                        
                    }
                }
                compeletion((totalpages,pagesavailable,lastsynctime,arrProduct,status,message,error: Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    
    func getSyncedLead(compeletion: @escaping (ResponseBlock) -> Void){
        var param = Common.returndefaultparameter()
        param["getsyncleadsjson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetSyncLeads, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                
                let arrLead = arr as? [[String:Any]] ?? [[String:Any]]()
                let arrLeadSynced = [[String:Any]]()
                //print("array of lead = \(arrLead)")
                //    //print(arrLeadSynced)
                let arrOfCustomer = CustomerDetails.getAllCustomers()
                //                if(arrOfCustomer.count > 0){
                //                    for customerdetail in arrOfCustomer{
                //                        //print(customerdetail.name)
                //                    }
                //                }
                if(arrLead.count > 0){
                    
                    for dict in arrLead{
                        //                    let dictsynced = dict
                        //  //print(dictsynced)
                        //customer not saved yet
                        //              let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: (dict["CustomerID"] as? Int ?? 0)))
                        //
                        //                    dictsynced["CustomerName"] =  strCustomerName
                        //                    arrLeadSynced.append(dictsynced )
                        
                        Utils.cancelAlaram(userInfo: ["EventID":"LRM\(dict["ID"] ?? "")"])
                        Utils.cancelAlaram(userInfo: ["EventID":"LRS\(dict["ID"] ?? "")"])
                        Utils.cancelAlaram(userInfo: ["EventID":"LRF\(dict["ID"] ?? "")"])
                        Utils.cancelAlaram(userInfo: ["EventID":"LMM\(dict["ID"] ?? "")"])
                        Utils.cancelAlaram(userInfo: ["EventID":"LNS\(dict["ID"] ?? "")"])
                        Utils.cancelAlaram(userInfo: ["EventID":"LNF\(dict["ID"] ?? "")"])
                        Utils.cancelAlaram(userInfo: ["EventID":"LND\(dict["ID"] ?? "")"])
                        
                        let setting = Utils().getActiveSetting()
                        
                        
                        
                        if(setting.leadReminder == NSNumber.init(value: 2)){
                            
                        }
                    }
                }
                MagicalRecord.save({ (localContext) in
                    Lead.mr_truncateAll(in: localContext)
                    
                    //                for lead in arrLead{
                    //
                    //                    if let arrProduct = lead["ProductsList"] as? [[String:Any]]{
                    //                    for product in arrProduct{
                    //                        //print("product  = \(product) , type of subcategory = \(type(of: product["SubCategoryID"]))")
                    //                    }
                    //                    }
                    //                }
                    print("arr of lead = \(arrLead)")
                    FEMDeserializer.collection(fromRepresentation: arrLead, mapping: Lead.defaultmapping(), context: localContext)
                }, completion: { (status, error) in
                    if(error == nil){
                        //print("All Lead Fetch Sucessfully")
                    }else{
                        //print(error?.localizedDescription ?? Common.returnnoerror())
                    }
                })
                compeletion((totalpages,pagesavailable,lastsynctime,arrLead,status,message,error: Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        
    }
    // MARK: Visit API
    func getMappedPlannedVisit(compeletion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        var strjson = String()
        
        if(activeUser?.userID?.intValue ?? 0 > 0){
            do{
                let jsondata = try JSONSerialization.data(withJSONObject: ["CreatedBy":activeUser?.userID?.stringValue,"CompanyID":activeUser?.company?.iD?.stringValue], options: [])
                strjson = String.init(data: jsondata, encoding: String.Encoding.utf8) ?? ""
            }catch{
                
            }
        }else{
            //  Login().logout()
        }
        param["getPlannedVisitsJson"] = strjson
        apicall(url: ConstantURL.kWSUrlGetMappedPlannedVisits, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                let arrPlanVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                //     //print(arrPlanVisit)
                if(arrPlanVisit.count > 0){
                    for dictvisit in arrPlanVisit{
                        if(Utils.isAlaramPossible(dict: dictvisit)){
                            var date = dictvisit["NextActionTime"] as? Date ?? Date()
                            if(date == Date()){
                                
                                var strnt = ""
                                if let strn = Utils.getDateBigFormatToDefaultFormat(date: dictvisit["NextActionTime"] as? String ?? "2020/02/12", format: "yyyy/MM/dd HH:mm:ss") as? String{
                                    strnt = strn
                                }
                                date = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: strnt, format: "dd-MM-yyyy, hh:mm a"), format: "yyyy/MM/dd HH:mm:ss")
                            }
                            // date = date.addingTimeInterval(60 * (Utils().getActiveSetting().visitReminderFirst?)?.intValue ?? 0 ?? 0)
                            //  if(Utils.get)
                            
                        }
                    }
                    //    if(self.activeSetting.visitTobeDownloadedUponLogin == 1){
                    MagicalRecord.save({ (localContext) in
                        PlannVisit.mr_truncateAll(in: localContext)
                        /*
                         'NSInvalidArgumentException', reason: 'Unacceptable type of value for ordered to-many relationship: property = "checkInOutData"; desired type = NSOrderedSet; given type = __NSArrayM;
                         */
                        FEMDeserializer.collection(fromRepresentation: arrPlanVisit, mapping: PlannVisit.defaultmapping(), context: localContext)
                        
                    }, completion: { (status, error) in
                        
                        //             //print("New plan visit Saved. and total activity is \(PlannVisit.getAll().count)")
                    })
                }
                //}
                
                compeletion((totalpages,pagesavailable,lastsynctime,arrPlanVisit,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    //swiftlint:disable function_parameter_count
    func getVisitForListingWithFilter(visitType:String,filteruser:String,filterProduct:String,filteredCustomerId:String,filterCatagroyID:String,filterType:String,sortType:String,statrtTime:String,endTime:String,compeletion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        var strjson = String()
        var strUrl = ""
        if(activeUser?.userID?.intValue ?? 0 > 0){
            do{
                var jsondata:Data
                if(statrtTime.count > 0){
                    
                    
                    jsondata = try JSONSerialization.data(withJSONObject: ["CreatedBy":activeUser?.userID?.stringValue,"CompanyID":activeUser?.company?.iD?.stringValue,"FilterUser":filteruser,"FilterProduct":filterProduct,"CustomerID":filteredCustomerId,"FilterCategoryID":filterCatagroyID,"SortType":sortType,"FilterType":filterType,"StartDate":statrtTime,"EndDate":endTime], options: [])
                    strjson = String.init(data: jsondata, encoding: String.Encoding.utf8) ?? ""
                }else{
                    jsondata = try JSONSerialization.data(withJSONObject: ["CreatedBy":activeUser?.userID?.stringValue,"CompanyID":activeUser?.company?.iD?.stringValue,"FilterUser":filteruser,"FilterProduct":filterProduct,"CustomerID":filteredCustomerId,"FilterCategoryID":filterCatagroyID,"SortType":sortType,"FilterType":filterType], options: [])
                    strjson = String.init(data: jsondata, encoding: String.Encoding.utf8) ?? ""
                }
                if(visitType == "unplanned"){
                    param["getUnPlannedVisitsJson"] = strjson
                    strUrl = ConstantURL.kWSUrlGetUnPlannedVisits
                }else if(visitType == "closeunplanned"){
                    param["getUnPlannedVisitsClosedJson"] = strjson
                    strUrl = ConstantURL.kWSUrlGetUnPlannedVisitsClose
                }else if(visitType == "closeplanned"){
                    param["getPlannedVisitsClosedJson"] = strjson
                    strUrl = ConstantURL.kWSUrlGetPlannedVisitsClose
                }else if(visitType == "coldcallvisitDetail"){
                    param["getUnPlannedVisitsJson"] = strjson
                    strUrl = ConstantURL.kWSUrlGetUnPlannedVisits
                }else{
                    strUrl = ConstantURL.kWSUrlGetNotifications
                }
                param["PageNo"] = pageCurrent
                param["PageNumber"] = pagesAvailable
                param["PageSize"] = "20"
                param["LastSynchTime"] = ""
            }catch{
                //print("got an error")
            }
        }else{
            //   Login().logout()
        }
        apicall(url: strUrl, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                
                let arrOfUnplannedVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                var arrUnplannedvisitlist = [UnplannedVisit]()
                if((visitType == "unplanned")||(visitType == "closeunplanned")){
                    for dic in arrOfUnplannedVisit {
                        let unplanvisitobj =
                        
                        UnplannedVisit().initwithdic(dict: dic)
                        arrUnplannedvisitlist.append(unplanvisitobj)
                    }
                    compeletion((totalpages,pagesavailable,lastsynctime,arrUnplannedvisitlist,status,message,Common.returnnoerror(),ResponseType.arr))
                    
                    
                }else if(visitType == "coldcallvisitDetail"){
                    //print(arr)
                }else{
                    // getPlannedVisitsClosedJson
                    let arrOfPlannedVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                    var  aVisits = [PlannVisit]()
                    
                    //                    self.pagesAvailable = [request.responseData["pagesAvailable"] intValue];
                    //                    self.totalRecords = [request.responseData[@"totalRecords"] intValue];
                    //                    self.status = YES;
                    //                    self.message = request.responseData[@"message"];
                    let mapping = PlannVisit.defaultmapping()
                    let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                    store.saveContextOnCommit = false
                    let deserializer = FEMDeserializer.init(store: store)
                    let arrplanvisithistory = deserializer.collection(fromRepresentation: arrOfPlannedVisit, mapping: mapping) as? [PlannVisit] ?? [PlannVisit]()
                    aVisits.append(contentsOf: arrplanvisithistory)
                    
                    compeletion((totalpages,pagesavailable,lastsynctime,aVisits,status,message: message,error: Common.returnnoerror(),ResponseType.arr))
                }
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        
    }
    
    func getNotificationsList(type:String,compeletion:@escaping (ResponseBlock)-> Void){
        var param = Common.returndefaultparameter()
        param["Type"] = type
        param["LastSynchTime"] = ""
        param["PageSize"] = "20"
        param["PageNumber"] = pageCurrent
        apicall(url: ConstantURL.kWSUrlGetNotifications, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                let arrNotification = arr as? [[String:Any]] ?? [[String:Any]]()
                compeletion((totalpages,pagesavailable,lastsynctime,arrNotification,status,message,error: Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    
    func getJointVisitList(currentPage:Int,compeletion: @escaping (ResponseBlock) -> Void){
        var param = Common.returndefaultparameter()
        param["PageNo"] = currentPage
        param["PageSize"] = "20"
        apicall(url: ConstantURL.kWSUrlGetJointVisitList, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                let arrJointVisitList = arr as? [[String:Any]] ?? [[String:Any]]()
                compeletion((totalpages,pagesavailable,lastsynctime,arrJointVisitList,status,message ,error: Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    
    func getdeletejoinvisit(param:[String:Any],strurl:String,method:Apicallmethod,compeletion: @escaping (ResponseBlock) -> Void){
        apicall(url: strurl, param: param, method: method) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                //print(responseType)
                var dicJointVisitList:[String:Any]
                var arrJointVisitList:[[String:Any]]
                if(responseType == ResponseType.arr){
                    arrJointVisitList = arr as? [[String:Any]] ?? [[String:Any]]()
                    compeletion((totalpages,pagesavailable,lastsynctime,arrJointVisitList ,status,message,error: Common.returnnoerror(),responseType))
                }else if(responseType == ResponseType.string){
                    let strresult =  arr as? String ?? String()
                    compeletion((totalpages,pagesavailable,lastsynctime,strresult ,status,message,error: Common.returnnoerror(),responseType))
                }else{
                    dicJointVisitList = arr as? [String:Any] ?? [String:Any]()
                    compeletion((totalpages,pagesavailable,lastsynctime,dicJointVisitList,status ,message,error: Common.returnnoerror(),responseType))
                }
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    
    //    func getdeletejoinvisit(param:[String:Any],strurl:String,method:Apicallmethod,compeletion: @escaping (ResponseBlock) -> Void){
    
    
    //checkin
    func checkin(lat:NSNumber,long:NSNumber,visitID:NSNumber,id:Int,compeletion: @escaping (ResponseBlock) -> Void){
        //kWSUrlVisitCheckInLattitude
        var param = Common.returndefaultparameter()
        let dicvisit = ["VisitID":visitID,"CreatedBy":activeUser?.userID,"CompanyID":activeUser?.company?.iD,"Lattitude":lat,"Longitude":long,"StatusID":NSNumber.init(value: 1),"CheckInCheckOutStatusID":NSNumber.init(value: 0)]
        param["visitCheckInJson"] = Common.returnjsonstring(dic: dicvisit as [String : Any])
        //print("parameter for checkin = \(param)")
        
        
        apicall(url: ConstantURL.kWSUrlVisitCheckIn, param: param, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                if(responseType == ResponseType.dic){
                    let dicOfAttendance = arr as? [String:Any] ?? [String:Any]()
                    compeletion((totalpages,pagesavailable,lastsynctime,dicOfAttendance,status,message: message,error:Common.returnnoerror(),responseType: responseType))
                }else{
                    let arrOfAttendance = arr as? [[String:Any]] ?? [[String:Any]]()
                    compeletion((totalpages,pagesavailable,lastsynctime,arrOfAttendance,status,message: message,error:Common.returnnoerror(),responseType:responseType))
                }
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? message,error: error,ResponseType.none))
            }
        }
    }
    
    func checkout(visitType:VisitType,lat:NSNumber,long:NSNumber,visitID:NSNumber,id:Int,compeletion: @escaping (ResponseBlock) -> Void){
        //kWSUrlVisitCheckIn
        var param = Common.returndefaultparameter()
        var dicvisit = ["VisitID":visitID,"CreatedBy":activeUser?.userID,"CompanyID":activeUser?.company?.iD,"Lattitude":lat,"Longitude":long,"CheckInCheckOutStatusID":NSNumber.init(value: 0)]
        if(Utils().getActiveSetting().closeVisitUpon == 1){
            dicvisit["CloseVisitFlag"] = 1
        }else if(Utils().getActiveSetting().closeVisitUpon == 2){
            if let planvisit = PlannVisit.getVisit(visitID: visitID){
                if(planvisit.visitStatusList.count > 0){
                    dicvisit["CloseVisitFlag"] = 1
                }else{
                    dicvisit["CloseVisitFlag"] = 0
                }
            }
            
        }else if(Utils().getActiveSetting().closeVisitUpon == 5){
            if let planvisit = PlannVisit.getVisit(visitID: visitID){
                if(planvisit.visitStatusList.count > 0){
                    if let status = planvisit.visitStatusList.firstObject as?  VisitStatus{
                        if(status.visitOutcomeID > 0 && VisitOutcomes.outcomeshouldcloseVisit(id: status.visitOutcomeID)){
                            dicvisit["CloseVisitFlag"] = 1
                        }else if(status.visitOutcome2ID > 0 && VisitOutcomes.outcomeshouldcloseVisit(id: status.visitOutcome2ID)){
                            dicvisit["CloseVisitFlag"] = 1
                        }else if(status.visitOutcome3ID > 0 && VisitOutcomes.outcomeshouldcloseVisit(id: status.visitOutcome3ID)){
                            dicvisit["CloseVisitFlag"] = 1
                        }else if(status.visitOutcome4ID > 0 && VisitOutcomes.outcomeshouldcloseVisit(id: status.visitOutcome4ID)){
                            dicvisit["CloseVisitFlag"] = 1
                        }else if(status.visitOutcome5ID > 0 && VisitOutcomes.outcomeshouldcloseVisit(id: status.visitOutcome5ID)){
                            dicvisit["CloseVisitFlag"] = 1
                        }else{
                            dicvisit["CloseVisitFlag"] = 0
                        }
                    }
                }}
        }else{
            dicvisit["CloseVisitFlag"] = 0
        }
        param["visitCheckOutJson"] = Common.returnjsonstring(dic: dicvisit as [String : Any])
        print("parameter for checkout = \(param)")
        apicall(url: ConstantURL.kWSUrlVisitCheckOut, param: param, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                if(responseType == ResponseType.dic){
                    let dicOfAttendance = arr as? [String:Any] ?? [String:Any]()
                    
                    compeletion((totalpages,pagesavailable,lastsynctime,dicOfAttendance,status,message: message,error:Common.returnnoerror(),responseType: responseType))
                }else{
                    let arrOfAttendance = arr as? [[String:Any]] ?? [[String:Any]]()
                    compeletion((totalpages,pagesavailable,lastsynctime,arrOfAttendance,status,message: message,error:Common.returnnoerror(),responseType:responseType))
                }
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? message,error: error,ResponseType.none))
            }
        }
    }
    
    func
    addunplanVisitpostWithMultipartBody(fullUrl:String,img:UIImage,imgparamname:String,param:[String:Any],compeletion: @escaping (ResponseBlock) -> Void){
        postWithMultipartBody(fullUrl: fullUrl, img: img, imgparamname: imgparamname, param: param){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            //print("url is \(fullUrl)")
            //print("error is \(error)")
            compeletion((totalpages,pagesavailable,lastsynctime,arr,status,error.localizedRecoverySuggestion ?? message,error: error,responseType))
            if(error.code == 0){
                
            }else{
                //print("error description = \(error.localizedDescription)")
            }
        }
        
    }
    
    func addCustomerWithMultipartBody(fullUrl:String,arrimg:[UIImage],arrimgparamname:[String],param:[String:Any],compeletion: @escaping (ResponseBlock) -> Void){
        postWithMultipartBodyWithImgArr(fullUrl: fullUrl, arrimg: arrimg, arrimgparamname: arrimgparamname, param: param) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            //print("url is \(fullUrl)")
            //print("error is \(error)")
            compeletion((totalpages,pagesavailable,lastsynctime,arr,status,error.localizedRecoverySuggestion ?? message,error: error,responseType))
            if(error.code == 0){
                
            }else{
                //print("error description = \(error.localizedDescription)")
            }
        }
        /*postWithMultipartBody(fullUrl: fullUrl, img: img, imgparamname: imgparamname, param: param){
         (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
         //print("url is \(fullUrl)")
         //print("error is \(error)")
         compeletion((arr,status,error.localizedRecoverySuggestion ?? message,error: error,responseType))
         if(error.code == 0){
         
         }else{
         //print("error description = \(error.localizedDescription)")
         }
         }*/
        
    }
    
    // MARK: Promotion
    
    /* let account = Utils().getActiveAccount()
     
     let param = NSMutableDictionary()
     var strUrl:String = ""
     
     if(selecedstrForList == "Promotion"){
     
     strUrl = kBaseTeamworkURL + KWSUrlAvailablePromotionList
     }
     else{
     strUrl = kBaseTeamworkURL + KWSUrlAvailableEntitlementList
     }
     
     if(objPlannedVisit == nil){
     param.setObject(ObjUnplannedVisit?.customerID ?? 1 , forKey: "CustomerID" as NSCopying)
     }
     else{
     param.setObject(objPlannedVisit?.customerID ?? 1 , forKey: "CustomerID" as NSCopying)
     }
     // param.setObject(ObjVisit?.customerID ?? 1 , forKey: "CustomerID" as NSCopying)
     //print(param)
     
     /*   callAPIget(methodName: "get" , url: kBaseTeamworkURL + KWSUrlAvailablePromotionList, parameter: param as! [String : Any],completionHandler: (status,result),{
      
      })*/
     
     callAPIget(methodName: "get", url:strUrl , parameter: param as! [String : Any]) { (status, result) in
     SVProgressHUD.dismiss()
     //print(status)
     //            if(status){
     if(status.lowercased() == "success"){
     self.tblPromotionList.pullToRefreshView.stopAnimating()
     do{
     //here dataResponse received from a network request
     
     //print(result )
     let resultModel = Result(result as! [String : Any])
     
     //print(resultModel)
     if(resultModel.status.lowercased() == "success" ){
     
     //  if(resultModel.data != nil){
     if(self.selecedstrForList == "Promotion"){
     let arrOfPromo = NSMutableArray()
     for Dictionary in resultModel.data {
     let promo = promotion.init(Dictionary)
     arrOfPromo.add(promo)
     //arrOfPromo.append(promo)
     }
     self.promoData = arrOfPromo
     }
     else{
     var arrOfEntitle = NSMutableArray()
     for Dictionary in resultModel.data {
     let entitle = Entitlement.init(Dictionary)
     arrOfEntitle.add(entitle)
     }
     self.entitleMentData = arrOfEntitle
     }
     self.tblPromotionList.reloadData()
     
     // }
     //                        else{
     //                            self.showAlert(withMessage: "No Data Found")
     //                        }
     }
     else{
     self.showAlert(withMessage: "SomeThing Went Wrong")
     
     }
     }
     }
     else if (status == "false"){
     
     }
     else{
     self.tblPromotionList.pullToRefreshView.stopAnimating()
     self.showAlert(withMessage: "SomeThing Went Wrong Please try again")
     }
     
     }*/
    
    func getPromotionList(strurl:String,customerId:NSNumber,compeletion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        param["CustomerID"] = customerId
        apicall(url: strurl, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                if(responseType == ResponseType.arr){
                    let arrVisitPromotionList = arr as? [[String:Any]] ?? [[String:Any]]()
                    compeletion((totalpages,pagesavailable,lastsynctime,arrVisitPromotionList,status ,message,error: Common.returnnoerror(),ResponseType.arr))
                }else if(responseType == ResponseType.dic){
                    let dicPromotion = arr as? [String:Any] ?? [String:Any]()
                    compeletion((totalpages,pagesavailable,lastsynctime,dicPromotion,status ,message,error: Common.returnnoerror(),ResponseType.dic))
                }else{
                    let arrVisitPromotionList = arr as? [Any] ?? [Any]()
                    compeletion((totalpages,pagesavailable,lastsynctime,arrVisitPromotionList,status ,message,error: Common.returnnoerror(),ResponseType.arrOfAny))
                }
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        
    }
    // MARK: Dashboard
    func getVisitDashboard(strurl:String,selecteduserID:String,selectedDate:String,compeletion: @escaping (ResponseBlock) -> Void){
        
        var  param = Common.returndefaultparameter()
        
        var commonjson = ["CreatedBy":selecteduserID,"CompanyID":activeUser?.company?.iD?.stringValue ?? 0] as [String : Any]
        
        // param["getvisitjson"] =  Common.returnjsonstring(dic: commonjson)
        let strDate = String.init(format: "%@ 18:29:00", selectedDate)
        let calender = NSCalendar.current
        let dayComponent = NSDateComponents.init()
        let second = NSTimeZone.local.secondsFromGMT()
        dayComponent.timeZone = NSTimeZone.init(forSecondsFromGMT: second) as TimeZone
        let dateformater = DateFormatter()
        dateformater.locale = NSLocale.init(localeIdentifier: "en_EN") as Locale
        dateformater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let startdate = dateformater.date(from: strDate)
        let nextdate = calender.date(byAdding: dayComponent as DateComponents, to: startdate!)
        let enddate = calender.date(bySettingHour: 23, minute: 59, second: 59, of: nextdate!)
        let strenddate = dateformater.string(from: enddate!)
        commonjson["EndDate"] = strenddate
        param["getjson"] = Common.returnjsonstring(dic: commonjson)
        apicall(url: strurl , param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                let arrVisitFollowUpList = arr as? [[String:Any]] ?? [[String:Any]]()
                compeletion((totalpages,pagesavailable,lastsynctime,arrVisitFollowUpList,status ,message,error: Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.arr))
            }
        }
        
        
    }
    
    // MARK: SalesPlan
    
    func getVisitFollowUps(selecteduserID:String,selectedDate:String,compeletion: @escaping (ResponseBlock) -> Void){
        
        var  param = Common.returndefaultparameter()
        
        let commonjson = ["CreatedBy":selecteduserID,"CompanyID":activeUser?.company?.iD?.stringValue ?? 0] as [String : Any]
        
        param["getvisitjson"] =  Common.returnjsonstring(dic: commonjson)
        let strDate = String.init(format: "%@ 18:29:00", selectedDate)
        let calender = NSCalendar.current
        let dayComponent = NSDateComponents.init()
        let second = NSTimeZone.local.secondsFromGMT()
        dayComponent.timeZone = NSTimeZone.init(forSecondsFromGMT: second) as TimeZone
        let dateformater = DateFormatter()
        dateformater.locale = NSLocale.init(localeIdentifier: "en_EN") as Locale
        dateformater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let startdate = dateformater.date(from: strDate)
        let nextdate = calender.date(byAdding: dayComponent as DateComponents, to: startdate!)
        let enddate = calender.date(bySettingHour: 23, minute: 59, second: 59, of: nextdate!)
        let strenddate = dateformater.string(from: enddate!)
        let dictime = ["EndDate":strenddate]
        param["gettime"] = Common.returnjsonstring(dic: dictime)
        apicall(url: ConstantURL.kWSUrlGetVisitFollowUps , param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                let arrVisitFollowUpList = arr as? [[String:Any]] ?? [[String:Any]]()
                compeletion((totalpages,pagesavailable,lastsynctime,arrVisitFollowUpList,status ,message,error: Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.arr))
            }
        }
        
        
    }
    func getDailySalesPlanDetail(selecteduserID:String,selectedDate:String,compeletion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        
        var commonjson = ["CreatedBy":selecteduserID,"CompanyID":activeUser?.company?.iD?.stringValue ?? 0] as [String : Any]
        let visitjson = ["CreatedBy":selecteduserID,"CompanyID":activeUser?.company?.iD?.stringValue ?? 0,"VisitTypeID":"0"] as [String : Any]
        param["getvisitjson"] =  Common.returnjsonstring(dic: visitjson)
        param["AllVisitDetailsFlag"] = true
        param["getactivityjson"] = Common.json(from: commonjson)
        param["getleadjson"] = Common.json(from: commonjson)
        param["isCallFromIos"] =  true
        param["getBeatPlanjson"] = Common.json(from: commonjson)
        let strDate = String.init(format: "%@ 18:29:00", selectedDate)
        let calender = NSCalendar.current
        let dayComponent = NSDateComponents.init()
        let second = NSTimeZone.local.secondsFromGMT()
        dayComponent.timeZone = NSTimeZone.init(forSecondsFromGMT: second) as TimeZone
        let dateformater = DateFormatter()
        dateformater.locale = NSLocale.init(localeIdentifier: "en_EN") as Locale
        dateformater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let startdate = dateformater.date(from: strDate)
        let nextdate = calender.date(byAdding: dayComponent as DateComponents, to: startdate!)
        let enddate = calender.date(bySettingHour: 18, minute: 29, second: 00, of: nextdate!)
        let strenddate = dateformater.string(from: enddate!)
        let dictime = ["EndDate":strenddate]
        param["gettime"] = Common.returnjsonstring(dic: dictime)
        let strDate1 = String.init(format: "%@ 18:29:00", selectedDate)
        let dayComponent1 = NSDateComponents.init()
        let second1 = NSTimeZone.local.secondsFromGMT()
        dayComponent1.timeZone = NSTimeZone.init(forSecondsFromGMT: second1) as TimeZone
        
        dateformater.locale = NSLocale.init(localeIdentifier: "en_EN") as Locale
        dateformater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let startdate1 = dateformater.date(from: strDate1)
        let nextdate1 = calender.date(byAdding: dayComponent1 as DateComponents, to: startdate1!)
        let enddate1 = calender.date(bySettingHour: 18, minute: 29, second: 00, of: nextdate1!)
        let strenddate1 = dateformater.string(from: enddate1!)
        commonjson["EndDate"] = strenddate1
        commonjson["createdBy"] = selecteduserID
        param["getjson"] = Common.returnjsonstring(dic: commonjson)
        
        apicall(url: ConstantURL.kWSUrlGetDailyPlan , param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                //print(responseType)
                let arrVisitFollowUpList = arr as? [[String:Any]] ?? [[String:Any]]()
                compeletion((totalpages,pagesavailable,lastsynctime,arrVisitFollowUpList,status ,message,error: Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.arr))
            }
        }
        
    }
    
    
    func loadLeadOutComeWithBlock(compeletion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        
        param["getleadOutcomejson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetLeadOutCome, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                let arrLeadOutcome = arr as? [[String:Any]] ?? [[String:Any]]()
                //print(arrLeadOutcome)
                if(arrLeadOutcome.count > 0){
                    print(arrLeadOutcome.first)
                    
                    MagicalRecord.save({ (localContext) in
                        Outcomes.mr_truncateAll(in: localContext)
                        print("arr of lead outcomes = \(arrLeadOutcome)")
                        FEMDeserializer.collection(fromRepresentation: arrLeadOutcome, mapping: Outcomes.defaultmapping(), context: localContext)
                    }, completion: { (status, error) in
                        print("all lead outcome saved :) \(arrLeadOutcome.count) , \(Outcomes.getAll().count)")
                        
                    })
                }
                compeletion((totalpages,pagesavailable,lastsynctime,arrLeadOutcome,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    
    func loadLeadSourceWithBlock(compeletion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        
        param["getleadSourcejson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetLeadSource, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                let arrLeadSource = arr as? [[String:Any]] ?? [[String:Any]]()
                //print(arrLeadSource)
                if(arrLeadSource.count > 0){
                    MagicalRecord.save({ (localContext) in
                        LeadSource.mr_truncateAll(in: localContext)
                        
                        FEMDeserializer.collection(fromRepresentation: arrLeadSource, mapping: LeadSource.defaultmapping(), context: localContext)
                        
                    }, completion: { (status, error) in
                        //print("all lead source )")//LeadSourceValue
                    })
                }
                compeletion((totalpages,pagesavailable,lastsynctime,arrLeadSource,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    
    func loadVisitOutComeWithBlock(compeletion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        
        param["getvisitOutcomejson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetVisitOutcome, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responeType) in
            
            if(error.code == 0){
                let arrVisitOutcome = arr as? [[String:Any]] ?? [[String:Any]]()
                print("array of outcome  = \(arrVisitOutcome)")
                if(arrVisitOutcome.count > 0){
                    
                    MagicalRecord.save({ (localContext) in
                        VisitOutcomes.mr_truncateAll(in: localContext)
                        
                        FEMDeserializer.collection(fromRepresentation: arrVisitOutcome, mapping: VisitOutcomes.defaultmapping(), context: localContext)
                        
                    }, completion: { (status, error) in
                        //print("all visit outcome")
                    })
                    
                }
                compeletion((totalpages,pagesavailable,lastsynctime,arrVisitOutcome,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    
    func loadUserListWithBlock(compeletion: @escaping (ResponseBlock) -> Void){
        
        let  param = Common.returndefaultparameter()
        
        
        apicall(url: ConstantURL.kWSUrlGetCompanyUsers, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                let arrCompanyUser = arr as? [[String:Any]] ?? [[String:Any]]()
                //print(arrCompanyUser)
                
                if(arrCompanyUser.count > 0){
                    MagicalRecord.save({ (localContext) in
                        CompanyUsers.mr_truncateAll(in: localContext)
                        
                        FEMDeserializer.collection(fromRepresentation: arrCompanyUser, mapping: CompanyUsers.defaultMapping(), context: localContext)
                    }, completion: { (status, error) in
                        //print("all company users )")
                    })
                }
                compeletion((totalpages,pagesavailable,lastsynctime,arrCompanyUser,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    
    func loadGetSyncProposal(compeletion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        param["getsyncproposalsjson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSURLGetSyncProposals, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                let arrProposal = arr as? [[String:Any]] ?? [[String:Any]]()
                //print(arrProposal)
                if(arrProposal.count > 0){
                    MagicalRecord.save({ (localContext) in
                        Proposl.mr_truncateAll(in: localContext)
                        
                        FEMDeserializer.collection(fromRepresentation: arrProposal, mapping: Proposl.defaultMapping(), context: localContext)
                    }, completion: { (status, error) in
                        //print("all Proposal )")
                    })
                }
                compeletion((totalpages,pagesavailable,lastsynctime,arrProposal,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    
    func loadGetSyncSO(pageno:NSNumber,pagesize:NSNumber,compeletion: @escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        param["PageNo"] = pageno
        param["PageSize"] = pagesize
        param["getsyncsalesordersjson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSURLGetSyncSalesOrders, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,reponseType) in
            
            if(error.code == 0){
                let arrSalesOrder = arr as? [[String:Any]] ?? [[String:Any]]()
                //print(arrSalesOrder)
                
                if(arrSalesOrder.count > 0){
                    MagicalRecord.save({ (localContext) in
                        SOrder.mr_truncateAll(in: localContext)
                        
                        FEMDeserializer.collection(fromRepresentation: arrSalesOrder, mapping: SOrder.defaultMapping(), context: localContext)
                    }, completion: { (status, error) in
                        //print("all Sales order )")
                    })
                }
                compeletion((totalpages,pagesavailable,lastsynctime,arrSalesOrder,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    /*  func loadGetSyncPO(compeletion:@escaping (ResponseBlock) -> Void){
     var  param = Common.returndefaultparameter()
     param["getSyncPurchaseOrder"] = Common.returnjsondata()
     apicall(url: ConstantURL.kWSURLGetSyncPurchaseOrder, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
     
     if(error.code == 0){
     let arrPurchaseOrder = arr as? [[String:Any]] ?? [[String:Any]]()
     //print(arrPurchaseOrder)
     
     if(arrPurchaseOrder.count > 0){
     MagicalRecord.save({ (localContext) in
     POrder.mr_truncateAll(in: localContext)
     
     FEMDeserializer.collection(fromRepresentation: arrPurchaseOrder, mapping: SOrder.defaultMapping(), context: localContext)
     }, completion: { (status, error) in
     //print("all Sales order )")
     })
     }
     compeletion((totalpages,pagesavailable,lastsynctime,arrPurchaseOrder,status,message,Common.returnnoerror(),ResponseType.arr))
     }else{
     compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
     }
     }
     // return strjson
     }*/
    
    func loadGetCustomerSegment(compeletion:@escaping (ResponseBlock) -> Void){
        var  param = Common.returndefaultparameter()
        param["getcustomersegmentjson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetCustomerSegment, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                var arrCustomerSegment = arr as? [[String:Any]] ?? [[String:Any]]()
                print("arr of segment = \(arrCustomerSegment)")
                
                arrCustomerSegment.insert(["ID":NSNumber.init(value: 0),"CompanyID":Utils().getActiveAccount()?.company?.iD ?? NSNumber.init(value: 0),"CustomerSegmentValue":"Default Customer Segment","CustomerSegmentIndexID":NSNumber.init(value: 0),"customerType": "0","CreatedBy":NSNumber.init(value: 0)], at: 0)
                if(arrCustomerSegment.count > 0){
                    MagicalRecord.save({ (localContext) in
                        CustomerSegment.mr_truncateAll(in: localContext)
                        
                        FEMDeserializer.collection(fromRepresentation: arrCustomerSegment, mapping: CustomerSegment.defaultMapping(), context: localContext)
                    }, completion: { (status, error) in
                        print("all Customer Segment  \(CustomerSegment.getAll()) in database count = \(CustomerSegment.getAll().count)")
                    })
                }
                compeletion((totalpages,pagesavailable,lastsynctime,arrCustomerSegment,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    
    func getAttendanceDetails(compeletion:@escaping (ResponseBlock) -> Void){
        let  param = Common.returndefaultparameter()
        // param["getcustomersegmentjson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetAttendanceDetails, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                //print(responseType)
                let dicAttendanceDetails = arr as? [String:Any] ?? [String:Any]()
                
                //print("Attendance History = \(dicAttendanceDetails)")
                //print("Type of Attendance History = \(type(of: dicAttendanceDetails))")
                //print("Type of data = \(type(of: [dicAttendanceDetails]))")
                if(dicAttendanceDetails.keys.count > 0){
                    MagicalRecord.save({ (localContext) in
                        AttendanceHistory.mr_truncateAll(in: localContext)
                        FEMDeserializer.collection(fromRepresentation: [dicAttendanceDetails] , mapping: AttendanceHistory.defaultMapping(), context: localContext)
                    },
                                       completion: { (status, error) in
                        //print("Attendance Detail  Saved")
                    })
                    
                }
                compeletion((totalpages,pagesavailable,lastsynctime,dicAttendanceDetails,status,message,Common.returnnoerror(),ResponseType.arr))
            }
            else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
            
        }
    }
    
    func getCustomerVendorSettings(urlstring:String,compeletion: @escaping (ResponseBlock) -> Void){
        let  param = Common.returndefaultparameter()
        
        apicall(url: urlstring, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                if(responseType == ResponseType.dic){
                    let dicCustomerVendorSettings = arr as? [String:Any] ?? [String:Any]()
                    if let noOfCust = dicCustomerVendorSettings["noOfCustomer"] as? Int{
                        Utils.setDefultvalue(key: Constant.kNoOfCustomer, value: noOfCust)
                    }
                    compeletion((totalpages,pagesavailable,lastsynctime,dicCustomerVendorSettings,status,message,Common.returnnoerror(),ResponseType.dic))
                }else{
                    let arrresponse = arr as? [[String:Any]] ?? [[String:Any]]()
                    compeletion((totalpages,pagesavailable,lastsynctime,arrresponse,status,message,Common.returnnoerror(),ResponseType.arr))
                }
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    
    func getJointVisitsForManagerLogin(compeletion: @escaping (ResponseBlock) -> Void){
        let  param = Common.returndefaultparameter()
        // param["getcustomersegmentjson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetJointVisitsForManagerLogin, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                let arrJointVisitsForManagerLogin = arr as? [[String:Any]] ?? [[String:Any]]()
                
                if(arrJointVisitsForManagerLogin.count > 0){
                    MagicalRecord.save({ (localcontext) in
                        FEMDeserializer.collection(fromRepresentation: arrJointVisitsForManagerLogin, mapping: PlannVisit.defaultmapping(), context: localcontext)
                    }, completion: { (status, error) in
                        //       //print("New plan visit Saved. and total activity is \(PlannVisit.getAll().count)")
                        
                    })
                }
                //print(arrJointVisitsForManagerLogin)
                
                compeletion((totalpages,pagesavailable,lastsynctime,arrJointVisitsForManagerLogin,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,message,Common.returnnoerror(),ResponseType.arr))
                
                //                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    
    func getMetadataVATCodes(compeletion:@escaping (ResponseBlock) -> Void){
        let  param = Common.returndefaultparameter()
        // param["getcustomersegmentjson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetMetadataVATCodes, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                let arrMetadataVATCodes = arr as? [[String:Any]] ?? [[String:Any]]()
                
                MagicalRecord.save({ (localContext) in
                    MetadataVATCodes.mr_truncateAll(in: localContext)
                    
                    FEMDeserializer.collection(fromRepresentation: arrMetadataVATCodes , mapping: MetadataVATCodes.defaultMapping(), context: localContext)
                    
                }, completion: { (status, error) in
                    
                })
                
                
                //print(arrMetadataVATCodes)
                compeletion((totalpages,pagesavailable,lastsynctime,arrMetadataVATCodes,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
    }
    
    func getStepVisitList(compeletion:@escaping (ResponseBlock) -> Void){
        
        let  param = Common.returndefaultparameter()
        // param["getcustomersegmentjson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetStepVisitList, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,reponseType) in
            if(error.code == 0){
                let arrStepVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                if(arrStepVisit.count > 0){
                    MagicalRecord.save({ (localContext) in
                        StepVisitList.mr_truncateAll(in: localContext)
                        print("arr of visit steps = \(arrStepVisit)")
                        FEMDeserializer.collection(fromRepresentation: arrStepVisit , mapping: StepVisitList.defaultmapping(), context: localContext)
                        
                    }, completion: { (status, error) in
                        //print("all Step visit = \(StepVisitList.getAll()) )")
                    })
                }
                //print(arrStepVisit)
                compeletion((totalpages,pagesavailable,lastsynctime,arrStepVisit,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
        
    }
    //kWSURLGetCompanyInfo
    func loadCompanyInfoWithBlock(compeletion:@escaping (ResponseBlock) -> Void){
        
        let  param = Common.returndefaultparameter()
        // param["getcustomersegmentjson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSURLGetCompanyInfo, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                let arrCustomerVendorSettings = arr as? [String:Any] ?? [String:Any]()
                //print(arrCustomerVendorSettings)
                
                compeletion((totalpages,pagesavailable,lastsynctime,arrCustomerVendorSettings,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
        
    }
    ////Territory
    
    func loadTerritory(compeletion:@escaping (ResponseBlock) -> Void){
        
        let  param = Common.returndefaultparameter()
        // param["getcustomersegmentjson"] = Common.returnjsondata()
        apicall(url: ConstantURL.kWSUrlGetTerritory, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                let arrOfTerritory = arr as? [[String:Any]] ?? [[String:Any]]()
                
                if(arrOfTerritory.count > 0){
                    MagicalRecord.save({ (localContext) in
                        Territory.mr_truncateAll(in: localContext)
                        FEMDeserializer.collection(fromRepresentation: arrOfTerritory , mapping:
                                                    Territory.defaultmapping(), context: localContext)
                        
                    }, completion: { (status, error) in
                        //print("arr of territory = \(arrOfTerritory)")
                        for user in Territory.getAll(){
                            //print("name of territory \(user.territoryUserName) and total territory \(Territory.getAll().count) id is \(user.territoryCode)")
                            if let tID = user.iD as? Int32 {
                                //print("territory ID = \(tID) ,name of territory \(user.territoryUserName) ")
                            }
                        }
                    })
                }
                compeletion((totalpages,pagesavailable,lastsynctime,arrOfTerritory,status,message,Common.returnnoerror(),ResponseType.arr))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
        
    }
    
    //send OTp
    func sendOTP(mobileNo:String,compeletion:@escaping (ResponseBlock) -> Void){
        
        var  param = Common.returndefaultparameter()
        param["CustomerMobileNo"] = mobileNo
        apicall(url: ConstantURL.kWSUrlForSendOTP, param: param, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                let dicCustomerVendorSettings = arr as? [String:Any] ?? [String:Any]()
                //print(dicCustomerVendorSettings)
                
                compeletion((totalpages,pagesavailable,lastsynctime,dicCustomerVendorSettings,status,message,Common.returnnoerror(),ResponseType.dic))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
        
    }
    
    //verify OTP
    func verifyOTP(mobileNo:String,OTP:String,compeletion:@escaping (ResponseBlock) -> Void){
        
        var  param = Common.returndefaultparameter()
        param["CustomerMobileNo"] = mobileNo
        param["Otp"] = OTP
        apicall(url: ConstantURL.kWSUrlForVerifyOTP, param: param, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                let dicCustomerVendorSettings = arr as? [String:Any] ?? [String:Any]()
                //print(dicCustomerVendorSettings)
                
                compeletion((totalpages,pagesavailable,lastsynctime,dicCustomerVendorSettings,status,message,Common.returnnoerror(),ResponseType.dic))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
    }
    // return strjson
    
    
    func getCustomerDetail(cid:NSNumber){
        
        var param = Common.returndefaultparameter()
        param["CustomerID"] =  cid
        self.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetCustomerDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                var custdic = arr as? [String:Any] ?? [String:Any]()
                let arrOfAdd = custdic["AddressList"] as? [[String:Any]] ?? [[String:Any]]()
                let dicOfAdd = arrOfAdd.first as? [String:Any] ?? [String:Any]()
                let customerID = custdic["ID"] as? Int
                let type = custdic["Type"] as? String
                let nsnumCustomerID = NSNumber.init(value: customerID ?? 0)
                var nsnumContactID = NSNumber.init(value:  0)
                if((type == "U") && (nsnumCustomerID.intValue > 0)){
                    MagicalRecord.save { (localcontext) in
                        
                        FEMDeserializer.object(fromRepresentation: custdic, mapping: CustomerDetails.defaultmapping(), context: localcontext)
                        FEMDeserializer.object(fromRepresentation: dicOfAdd, mapping: AddressList.defaultmapping(), context: localcontext)
                        localcontext.mr_saveToPersistentStore { (status, error
                        ) in
                            print(error?.localizedDescription ?? "gbdfgdfgb")
                            print("after saving persistant")
                            if let customer = CustomerDetails.getCustomerByID(cid:nsnumCustomerID) as? CustomerDetails{
                                
                                
                                print("address = \(customer.addressList)" )
                                if  let adlist = customer.addressList{
                                    for add in adlist{
                                        if let address = add as? AddressList{
                                            print("late = \(address.lattitude) , long = \(address.longitude) , address = \(address)")
                                        }
                                    }
                                }
                            }
                            //        if let lastContact =  CustomerDetails.mr_findAll()?.last as? CustomerDetails{
                            //                                                print(lastContact.name)
                            //                                                print(lastContact.iD)
                            //            self.getAllContactDetail(custID: NSNumber.init(value:lastContact.iD))
                            //
                            //                                            }
                        }
                        
                    } completion: { (status , error) in
                        let strAdd =      AddressList().getAddressStringByAddressId(aId:NSNumber.init(value:dicOfAdd["AddressID"] as? Int ?? 0))
                        //    print("string address = \(strAdd) ,  dic of address = \(dicOfAdd)")
                        let arrOFContact = Contact.getContactsUsingCustomerID(customerId: nsnumCustomerID)
                        if(arrOFContact.count > 0){
                            nsnumContactID = NSNumber.init(value:arrOFContact.first?.iD ?? 0)
                        }
                        
                        
                        
                        
                        
                        if let lastContact =  CustomerDetails.mr_findAll()?.last as? CustomerDetails{
                            let arrOFContact = Contact.getContactsUsingCustomerID(customerId: nsnumCustomerID)
                            if(arrOFContact.count > 0){
                                nsnumContactID = NSNumber.init(value:arrOFContact.first?.iD ?? 0)
                            }
                            
                        }
                    }
                }
                else if((type == "V") && (nsnumCustomerID.intValue > 0)){
                    MagicalRecord.save { (localcontext) in
                        
                        FEMDeserializer.object(fromRepresentation: custdic, mapping: Vendor.defaultmapping(), context: localcontext)
                        FEMDeserializer.object(fromRepresentation: dicOfAdd, mapping: AddressList.defaultmapping(), context: localcontext)
                        localcontext.mr_saveToPersistentStore { (status, error
                        ) in
                            print(error?.localizedDescription ?? "gbdfgdfgb")
                            print("after saving persistant")
                            
                        }
                        
                    } completion: { (status , error) in
                        
                    }
                }else{
                    if ( message.count > 0 ) {
                        
                    }
                }
                
            }else{
                
            }
        }
    }
    //update entitlement Status
    func updateEntitlementStatus(entitlementID:NSNumber,status:Int,compeletion:@escaping (ResponseBlock) -> Void){
        
        var  param = Common.returndefaultparameter()
        param["EntitlementID"] = entitlementID
        param["IsReceived"] = status
        apicall(url: ConstantURL.kWSUrlForEntitlementStatus, param: param, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
                
                if(responseType == ResponseType.arr){
                    let  arrJointVisitList = arr as? [[String:Any]] ?? [[String:Any]]()
                    compeletion((totalpages,pagesavailable,lastsynctime,arrJointVisitList,status ,message,error: Common.returnnoerror(),responseType))
                }else{
                    let  dicJointVisitList = arr as? [String:Any] ?? [String:Any]()
                    compeletion((totalpages,pagesavailable,lastsynctime,dicJointVisitList,status ,message,error: Common.returnnoerror(),responseType))
                }
                
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[:],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
            }
        }
        // return strjson
        
    }
    
    
}
