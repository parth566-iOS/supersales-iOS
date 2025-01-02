//
//  Sync.swift
//  SuperSales
//
//  Created by Apple on 30/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import FastEasyMapping
import Alamofire

class Sync:  BaseViewController{
    
    static var isFromDashboard:Bool!
    // let apihelper = ApiHelper()
    
    private var isWaiting = false {
        didSet {
            self.updateUI()
        }
    }
    var isrollback = false
    let group = DispatchGroup()
    var arrRequest:[DataRequest]! = [DataRequest]()
    let op1 = BlockOperation()
    let op2 = BlockOperation()
    let radQueue = OperationQueue()
    //    var lowerUser:[CompanyUsers]! = [CompanyUsers]()
    //    var lowerExecutiveUser:[CompanyUsers]!  = [CompanyUsers]()
    //
    
    @IBOutlet weak var lblDataSync: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.lblDataSync.setMultilineLabel(lbl: self.lblDataSync)
        self.navigationController?.isNavigationBarHidden = true
        let arr = self.jsonFromFile()
        let array:[String:Any] = arr["data"] as? [String : Any] ?? [String:Any]()
        let menulist = array["menuList"] ?? [[String:Any]]()
        MagicalRecord.save({ (localcontext) in
            CompanyMenus.mr_truncateAll(in: localcontext)
            FEMDeserializer.collection(fromRepresentation: menulist as? [[String:Any]] ?? [[String:Any]]() , mapping: CompanyMenus.defaultMapping() , context: localcontext)
            
        }) { (status, error) in
            print("error is \(String(describing: error?.localizedDescription))")
        }
        
        let tabList = array["tabList"] ?? [[String:Any]]()
        //        print(tabList)
        MagicalRecord.save({ (localcontext) in
            FEMDeserializer.collection(fromRepresentation: tabList as? [[String:Any]] ?? [[String:Any]]() , mapping: MenuTabs.defaultMapping() , context: localcontext)
        }) { (status, error) in
            print("error is \(String(describing: error?.localizedDescription))")
            
        }
        Common.setTitleOfView(color:UIColor.white, viewController: self)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.titleView?.isHidden = true
        
        
        self.makeArrOFAPICallRequest()
        self.loadDataAfterLogin()
        // Do any additional setup after loading the view.
    }
    func makeArrOFAPICallRequest(){
        //add default setting api call
        var param = [String:Any]()
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
        
        let defaultsettingrequest = Common.returnRequest(url: ConstantURL.kWSUrlGetSetting, method: Apicallmethod.get, param: param)
        arrRequest.insert(defaultsettingrequest, at: 0)
        var param1 = Common.returndefaultparameter()
        let getContactAPIRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetAllContact, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getContactAPIRequest, at: 1)
        let getVendorDataRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetAllVendor, method: Apicallmethod.get, param: param1)
        
        arrRequest.insert(getVendorDataRequest, at: 2)
        
        
        var dicActivity = [String:Any]()
        dicActivity["CompanyID"] = activeUser?.company?.iD//self.activeuser?.company?.iD
        dicActivity["CreatedBy"] = activeUser?.userID// self.activeuser?.userID
        param1["getPlannedActivityjson"] = Common.returnjsonstring(dic: dicActivity)
        
        let getAllActivityRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetPlannedActivity, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getAllActivityRequest, at: 3)
        
        
        var  param2 = Common.returndefaultparameter()
        param2["PageNo"] = 1
        param2["PageSize"] = Constant.CustomerPageSize
        
        let getAllCustomerRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetAllTaggedCustomer, method: Apicallmethod.get, param: param2)
        arrRequest.insert(getAllCustomerRequest, at: 4)
        
        param2["PageNo"] = 1
        param2["PageSize"] = Constant.ProductCategoryPageSize
        param2["get_ProductCategory"] = Common.returnjsondata()
        
        let getAllProductCatRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetProductCategory, method: Apicallmethod.get, param: param2)
        arrRequest.insert(getAllProductCatRequest, at: 5)
        
        var  param3 = Common.returndefaultparameter()
        
        
        param3["getcustomersegmentjson"] = Common.returnjsondata()
        let getAllCustSegmentRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetCustomerSegment, method: Apicallmethod.get, param: param3)
        arrRequest.insert(getAllCustSegmentRequest, at: 6)
        
        var  param4 = Common.returndefaultparameter()
        param4["getsyncproposalsjson"] = Common.returnjsondata()
        
        let getAllProposalRequest = Common.returnRequest(url: ConstantURL.kWSURLGetSyncProposals, method: Apicallmethod.get, param: param4)
        arrRequest.insert(getAllProposalRequest, at: 7)
        
        
        
        
        var  param5 = Common.returndefaultparameter()
        param5["PageNo"] = 1
        param5["PageSize"] = Constant.SOPageSize
        param5["getsyncsalesordersjson"] = Common.returnjsondata()
        
        let getAllSalesOrderRequest = Common.returnRequest(url: ConstantURL.kWSURLGetSyncSalesOrders, method: Apicallmethod.get, param: param5)
        arrRequest.insert(getAllSalesOrderRequest, at: 8)
        
        // let activeUser = Utils().getActiveAccount()
        
        let getAllUserRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetCompanyUsers, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getAllUserRequest, at: 9)
        
        
        
        
        
        
        
        var  param6 = Common.returndefaultparameter()
        
        param6["getvisitOutcomejson"] = Common.returnjsondata()
        
        let getAllVisitOutcomeRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetVisitOutcome, method: Apicallmethod.get, param: param6)
        arrRequest.insert(getAllVisitOutcomeRequest, at: 10)
        
        
        
        var  param7 = Common.returndefaultparameter()
        
        param7["getleadSourcejson"] = Common.returnjsondata()
        
        let getAllLeadSourceRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetLeadSource, method: Apicallmethod.get, param: param7)
        arrRequest.insert(getAllLeadSourceRequest, at: 11)
        
        
        
        
        
        var  param8 = Common.returndefaultparameter()
        
        param8["getleadOutcomejson"] = Common.returnjsondata()
        
        let getAllLeadOutcomeRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetLeadOutCome, method: Apicallmethod.get, param: param8)
        arrRequest.insert(getAllLeadOutcomeRequest, at: 12)
        
        
        
        var  param9 = Common.returndefaultparameter()
        
        param9["getsyncleadsjson"] = Common.returnjsondata()
        
        let getAllLeadRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetSyncLeads, method: Apicallmethod.get, param: param9)
        arrRequest.insert(getAllLeadRequest, at: 13)
        
        
        var  param10 = Common.returndefaultparameter()
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
        param10["getPlannedVisitsJson"] = strjson
        
        let getAllMAppedVisitRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetMappedPlannedVisits, method: Apicallmethod.get, param: param10)
        arrRequest.insert(getAllMAppedVisitRequest, at: 14)
        
        
        var  param11 = Common.returndefaultparameter()
        param11["PageNo"] = 1
        param11["PageSize"] = Constant.ProductPageSize
        param11["get_SyncProduct"] = Common.returnjsondata()
        
        
        let getAllSyncProductRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetSyncProduct, method: Apicallmethod.get, param: param11)
        arrRequest.insert(getAllSyncProductRequest, at: 15)
        
        
        
        let getAllCustVendSettingRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetCustomerVendorSettings, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getAllCustVendSettingRequest, at: 16)
        
        
        let getAttendanceDetailRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetAttendanceDetails, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getAttendanceDetailRequest, at: 17)
        
        let getJointVisitsFromManagerRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetJointVisitsForManagerLogin, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getJointVisitsFromManagerRequest, at: 18)
        
        
        let getMetadataVatCodesRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetMetadataVATCodes, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getMetadataVatCodesRequest, at: 19)
        
        let getCompanySettingRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetCompanyMenuSetting, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getCompanySettingRequest, at: 20)
        
        let getStepVisitRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetStepVisitList, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getStepVisitRequest, at: 21)
        
        let getCompanyInfoRequest = Common.returnRequest(url: ConstantURL.kWSURLGetCompanyInfo, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getCompanyInfoRequest, at: 22)
        
        let getTerritoryRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetTerritory, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getTerritoryRequest, at: 23)
        
        let getTypeAndSegmentRequest = Common.returnRequest(url: ConstantURL.kWSUrlGetTypeAndSegmentSetting, method: Apicallmethod.get, param: param1)
        arrRequest.insert(getTypeAndSegmentRequest, at: 24)
        
        var param12 = Common.returndefaultparameter()
        param12["userid"] = activeUser?.userID?.stringValue
        param12["companyid"] = activeUser?.company?.iD?.stringValue
        param12["rolelevel"] = NSNumber.init(value: 9)
        
        let getarrOfLowerUser = Common.returnRequest(url: ConstantURL.kWSUrlgetLowerHeirarchy, method: Apicallmethod.get, param: param12)
        arrRequest.insert(getarrOfLowerUser, at: 25)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController!.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        if let navigation = self.navigationController{
            navigation.isNavigationBarHidden = true
        }else{
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    func loadDataAfterLogin(){
        self.oldProjectMethod()
       //   self.editedmethod()
        //   self.originalmethod()
        
    }
    func editedmethod(){
        
        
     
            if(Sync.isFromDashboard == false){
                SVProgressHUD.show(withStatus: "Syncing")
            }
            self.isWaiting = true
            //Utils.addShadow(view: self.view)
        
        self.group.enter()
        self.apihelper.getCustomerVendorSettings(urlstring: ConstantURL.kWSUrlGetCustomerVendorSettings,compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("CustomerVendorSettings \(totalpages)");
                
                
            }else{
                self.rollbackoprations(error: error, message: message)
                
            }
        } )
        self.group.enter()
        APICallDefaultSetting(apirequest: self.arrRequest[0]){
            
            (setting:Setting,error:NSError) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                
                print("get all default setting  \(self.isrollback)")
                setting.salesOrderLoadPage = 1
                
            }else{
                
                self.isrollback = true
                print("cancelling request \(self.isrollback)")
                for request in self.arrRequest {
                    request.cancel()
                }
                if let topController = UIApplication.shared.keyWindow?.rootViewController {
                    
                    topController.view.makeToast(error.localizedDescription)
                    
                }
                if(Sync.isFromDashboard!)
                {
                    SVProgressHUD.dismiss()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.navigationController?.popViewController(animated: true)
                    print(error.localizedDescription)
                }
                
            }
            
            
            
        }
        
        self.group.enter()
        
        
        self.apihelper.getAllContact(completion: {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                
                print("get all contact \(self.isrollback)")
                
                
            }else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        
        self.group.enter()
        // APIcall(apirequest:self.arrRequest[2]){(
        self.apihelper.getAllVendor(completion: {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,reponseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                
                print("get all vendor \(self.isrollback)")
                
            }
            else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        
        self.group.enter()
        self.apihelper.getAllActivity(completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,reponseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                //                                                                 print("Activity list = \(totalpages)")
                
                print("get all activity")
                
            }
            else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        //new API made by backend developer as response  structure is not common
        self.apihelper.getTaggedCustomerList(pageno: 1 , pagesize: Constant.CustomerPageSize, completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("get all customer \(totalpages)")
                
                
                
                
            }
            
            else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        self.apihelper.getproductcategory(jsonstring: Common.returnjsondata(), pageno: 1, pagesize: Constant.ProductCategoryPageSize, completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("product category list \(totalpages)")
                
            }
            else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        self.apihelper.loadGetCustomerSegment(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("Customer Segment \(totalpages)");
                
                
            }                                                                                 else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
       // self.group.enter()
        //            self.apihelper.loadGetSyncPO(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        //               DispatchQueue.main.async{
//                            self.group.leave()
//                           }
        //                if(error.code == 0){
        //                    print("purchase order \(totalpages)");
        //
        //                }else{
        //                    self.rollbackoprations(error: error, message: message)
        //                }
        //            })
        
        self.group.enter()
        self.apihelper.loadGetSyncProposal(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                
                print("proposal list\(totalpages)")
                
                
                
            } else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        
        //loadGetSyncSO
        self.group.enter()
        self.apihelper.loadGetSyncSO(pageno:1,pagesize:Constant.SOPageSize,compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("Sales order \(totalpages)");
                
            } else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        self.apihelper.loadUserListWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                
                print("user list \(totalpages)")
                
                //
            }else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        self.apihelper.loadVisitOutComeWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                
                print("visit outcome list \(totalpages)")
                
            }
            else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        self.apihelper.loadLeadSourceWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                
                print("Lead source list \(totalpages)")
                
                
            }
            else{
                
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        self.apihelper.loadLeadOutComeWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            
            in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("Lead outcome list \(totalpages)");
                
                
                
            }else{
                
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        self.apihelper.getSyncedLead(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                
                print("synced Lead  list \(totalpages)")
                
            }else{
                
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        self.apihelper.getMappedPlannedVisit(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("Mapped plan visit list \(totalpages)")
                
                
            }else{
                
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        self.apihelper.getSyncronisedProduct(pageno: 1, pagesize: Constant.ProductPageSize, compeletion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("syncronised product list \(totalpages)");
                
                
                
            }else{
                
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        
        self.group.enter()
        self.apihelper.getAttendanceDetails(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("Attendance Detail\(totalpages)");
                
            }else{
                self.rollbackoprations(error: error, message: message)
                
            }
        })
        self.group.enter()
        self.apihelper.getJointVisitsForManagerLogin(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("Joint VisitsFor ManagerLogin \(totalpages)");
                
                
            } else{
                self.rollbackoprations(error: error, message: message)
                
            }
        } )
        self.group.enter()
        self.apihelper.getMetadataVATCodes(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("Metadata VATCodes\(totalpages)");
                
            } else{
                self.rollbackoprations(error: error, message: message)
                
            }
        } )
        self.group.enter()
        self.apihelper.getCompanyMenuSetting(completionresponse: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("Company Menu Setting\(totalpages)")
                
                
            }  else{
                self.rollbackoprations(error: error, message: message)
                
            }
        } )
        self.group.enter()
        self.apihelper.getStepVisitList(compeletion: {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                print("Step Visit \(totalpages)");
                if(Utils().getActiveSetting().visitStepsRequired == NSNumber.init(value: 1)) {                                                                                                                                                     print("Visit Step\(totalpages)")
                    
                }    else{
                    print()
                    
                };
                
            } else{
                self.rollbackoprations(error: error, message: message)
                
            }
            
        })
        self.group.enter()
        self.apihelper.loadCompanyInfoWithBlock(compeletion:{
                                                    (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                    
                                                    DispatchQueue.main.async{
                                                        self.group.leave()
                                                    }
                                                    if(error.code == 0){
                                                        let carrt = arr as? [String:Any] ?? [String:Any]()
                                                        print("Company information \(totalpages) , \(arr)");
                                                        MagicalRecord.save({ (localcontext) in
                                                            Company.mr_truncateAll(in: localcontext)
                                                            FEMDeserializer.object(fromRepresentation: carrt, mapping: Company.defaultMapping(), context: localcontext)
                                                            
                                                            
                                                        }) { (status, error) in
                                                            print("compay information saved")
                                                        }
                                                        
                                                        //                                                                                                                                                                                             UserDefaults.standard.set(currentversion, forKey: "currentVersion")
                                                        //                                                                                                                                                                                            UserDefaults.standard.synchronize();                                                                                                                                                     print("Company Info\(totalpages)")
                                                        
                                                        
                                                        
                                                    }                                                                                                                                                         else{
                                                        //            UserDefaults.standard.set(currentversion, forKey: "currentVersion")
                                                        //            UserDefaults.standard.synchronize();
                                                        
                                                        self.rollbackoprations(error: error, message: message)
                                                    }                                                                                                                                                           })
        self.group.enter()
        self.apihelper.loadTerritory(compeletion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                        DispatchQueue.main.async{
                                            self.group.leave()
                                        }
                                        if(error.code == 0){
                                            print("Territory information \(totalpages)");
                                            
                                            /*Utils.removeShadow(view: self.view)
                                             
                                             /*let param = Common.returndefaultparameter();                                                       apicall(url: ConstantURL.kWSUrlGetMenuSetting, param: param, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                             if(error.code == 0){
                                             print("response of menu setting = \(totalpages) and response type  = \(responseType)")
                                             //compeletion((setting:setting,NSError.init(domain: "", code: 0, userInfo: [String:Any]())))
                                             
                                             
                                             
                                             }else{
                                             let arr1 = [String:Any]()
                                             let setting = Setting.init(arrtionary: arr1)
                                             let errorOfApi = NSError.init(domain: "default", code: 0, userInfo: ["localisedescription":error])
                                             //compeletion((setting:setting,error:errorOfApi))
                                             }
                                             }   */                                                                                                              //print("All territory\(totalpages)");
                                             if(Sync.isFromDashboard == true){
                                             self.navigationController?.popViewController(animated: true)
                                             }else{
                                             SVProgressHUD.dismiss();             let userdefault = UserDefaults.standard
                                             userdefault.setValue(true, forKey: Constant.kIsSyncDone)
                                             
                                             userdefault.synchronize()
                                             AppDelegate.shared.rootViewController.switchToMainScreen()
                                             }*/
                                            
                                            
                                            
                                        } else{
                                            self.rollbackoprations(error: error, message: message)
                                            
                                        }                               })
        
        self.group.enter()
        self.apihelper.getLowerHierarchyUser { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            if(error.code == 0){
                let arrOfUser = arr as? [[String:Any]] ?? [[String:Any]]()
                var arrId:[NSNumber] = [self.activeuser?.userID ?? NSNumber.init(value:0)]
                if(arrOfUser.count > 0){
                    
                    for item in arrOfUser{
                        arrId.append(NSNumber.init(value: (item["id"] as? Int ?? 0)))
                    }
                    //    print(arrOfUser["id"])
                    BaseViewController.staticlowerUser = [CompanyUsers]()
                    
                    self.lowerExecutiveUser = [CompanyUsers]()
                    for user in BaseViewController.staticlowerUser{
                        print("role id = \(user.role_id.intValue) at edited method")
                    }
                    BaseViewController.staticlowerUser = BaseViewController.staticlowerUser.filter{
                        $0.role_id.intValue <=  8
                    }
                    //  self.lowerExecutiveUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrexecutiveId)
                    BaseViewController.staticlowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                    self.lowerUser = [CompanyUsers]()
                    self.lowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                }
            }else{
                self.rollbackoprations(error: error, message: message)
            }
        }
        
        self.group.enter()
        self.apihelper.getdeletejoinvisit(param:Common.returndefaultparameter() , strurl: ConstantURL.kWSUrlGetTypeAndSegmentSetting, method: Apicallmethod.get) {(totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            DispatchQueue.main.async{
                self.group.leave()
            }
            
            if(error.code == 0){
                //print("response type = \(responseType) , and result = \(arr) for setting");
                let dicofTypeandSegmentSetting = arr as? [String:Any] ?? [String:Any]()
                Utils.setDefultvalue(key: Constant.kSettingTypeAndSegment, value: dicofTypeandSegmentSetting)
            }else{
                self.rollbackoprations(error: error, message: message)
            }
        }
        
        
        
        
        
        
        
        // self.group.wait()
        self.group.notify(queue: .main, execute: {
            if(!self.isrollback){
                self.isWaiting = false
            }
        })
    }
    
    func oldProjectMethod(){
        if(Sync.isFromDashboard == false){
            SVProgressHUD.show(withStatus: "Syncing")
        }
        Utils.addShadow(view: self.view)
        self.apihelper.getCustomerVendorSettings(urlstring: ConstantURL.kWSUrlGetCustomerVendorSettings,compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                                                                    if(error.code == 0){
                                                                                                                        //
                                                                                                                        print("CustomerVendorSettings \(totalpages)");
            

        self.apihelper.getDefaultSetting {
            (setting:Setting,error:NSError) in
            
            
            if(error.code == 0){
            
                print("get default setting")
                setting.salesOrderLoadPage = 1
                

                self.apihelper.getAllContact(completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                    if(error.code == 0){

                        self.apihelper.getAllVendor(completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,reponseType) in

                            if(error.code == 0){
                                

                                self.apihelper.getAllActivity(completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,reponseType) in

                                    if(error.code == 0){
                                        //
                                        //                                        //new API made by backend developer as response  structure is not common

                                        self.apihelper.getTaggedCustomerList(pageno: 1 , pagesize: Constant.CustomerPageSize, completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                            if(error.code == 0){
                                                

                                                self.apihelper.getproductcategory(jsonstring: Common.returnjsondata(), pageno: 1, pagesize: Constant.ProductCategoryPageSize, completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                    if(error.code == 0){
                                                    
                                                        self.apihelper.loadGetCustomerSegment(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                      
                                                            if(error.code == 0){
                                                                //
                                                                print("Customer Segment \(totalpages)");
                                                                //                                                                self.apihelper.loadGetSyncPO(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                //                                                                    if(error.code == 0){
                                                                //                                                                        print("purchase order \(totalpages)");
                                                                
                                                                
                                                                

                                                                self.apihelper.loadGetSyncProposal(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                    if(error.code == 0){
                                                                        //
                                                                        print("proposal list\(totalpages)")
                                                                        
                                                                        
                                                                        //loadGetSyncSO

                                                                        self.apihelper.loadGetSyncSO(pageno:1,pagesize:Constant.SOPageSize,compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                            if(error.code == 0){
                                                                                //
                                                                                print("Sales order \(totalpages)");

                                                                                self.apihelper.loadUserListWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                                    if(error.code == 0){
                                                                                        //
                                                                                        print("user list \(totalpages)")

                                                                                        self.apihelper.loadVisitOutComeWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                                            if(error.code == 0){
                                                                                                //
                                                                                                print("visit outcome list \(totalpages)")
                                                                                                

                                                                                                
                                                                                                self.apihelper.loadLeadSourceWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                                                    if(error.code == 0){
                                                                                                        

                                                                                                        self.apihelper.loadLeadOutComeWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
                                                                                                            
                                                                                                            in
                                                                                      
                                                                        if(error.code == 0){
                                                                                                                

                                                                                                                self.apihelper.getSyncedLead(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
                                                                                                                    in
                                                                                  
                                                                                                                    if(error.code == 0){
                                                                                                   

                                                                                                                        
                                                                                                                        self.apihelper.getMappedPlannedVisit(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
                                                                                                                            in

                                                                                                                            if(error.code == 0){
                                                                                                                                //
                                                                                                                                print("Mapped plan visit list \(totalpages)")

                                                                                                                                
                                                                                                                                self.apihelper.getSyncronisedProduct(pageno: 1, pagesize: Constant.ProductPageSize, compeletion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                                                                                    if(error.code == 0){
                                                                                                                                        //
                                    print("syncronised product list \(totalpages)");
                            
                                                                                                                                                                                     self.apihelper.getAttendanceDetails(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                                                                                                    if(error.code == 0){
                                                                                                                                                        
                                                                                                                                                        print("Attendance Detail\(totalpages)");

                                                                                                                                                        self.apihelper.getJointVisitsForManagerLogin(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                                                                                                            if(error.code == 0){
                                                                                                                                                                //
                                                                                                                                                                print("Joint VisitsFor ManagerLogin \(totalpages)");

                                                                                                                                                                self.apihelper.getMetadataVATCodes(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                                                    if(error.code == 0){
                                                                                                                                                                        
                                                                                                                                                                        print("Metadata VATCodes\(totalpages)");

                                                                                                                                                                        self.apihelper.getCompanyMenuSetting(completionresponse: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
//
                                                                                                                                                                            if(error.code == 0){
                                                                                                                                                                                
                                                                                                                                                                                print("Company Menu Setting\(totalpages)")

                                                                                                                                                                                self.apihelper.getStepVisitList(compeletion: {
                                                                                                                                                                                                                    (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                                                                                                                                                                    if(error.code == 0){
                                                                                                                                                                                                                        
                                                                                                                                                                                                                        
                                                                                                                                                                                                                        print("Step Visit \(totalpages)");
                                                                                                                                                                                                                        if(Utils().getActiveSetting().visitStepsRequired == NSNumber.init(value: 1)) {                                                                                                                                                     print("Visit Step\(totalpages)")
                                                                                                                                                                                                                            
                                                                                                                                                                                                                        }    else{
                                                                                                                                                                                                                            print()                                                                                                                                                     };

                                                                                                                                                                                                                        self.apihelper.loadCompanyInfoWithBlock(compeletion:{
                                                                                                                                                                                                                                                                    (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                                                     if(error.code == 0){
                                                             
                                                                                                                                                                                                                                                                        let carrt = arr as? [String:Any] ?? [String:Any]()
                                                                                                                                                                                                                                                                        print("Company information \(totalpages) , \(arr)");
                                                                                                                                                                                                                                                                        MagicalRecord.save({ (localcontext) in
                                                                                                                                                                                                                                                                            Company.mr_truncateAll(in: localcontext)
                                                                                                                                                                                                                                                                            FEMDeserializer.object(fromRepresentation: carrt, mapping: Company.defaultMapping(), context: localcontext)
                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                        }) { (status, error) in
                                                                                                                                                                                                                                                                            print("compay information saved")
                                                                                                                                                                                                                                                                        }
                                                                                                                                                                                                            self.apihelper.loadTerritory(compeletion:
                                                                                                                                                                                                                                            { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                                                                                                                                                            if(error.code == 0){
                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                print("Territory information \(totalpages)");
                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                let param = Common.returndefaultparameter();
                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                self.apihelper.getdeletejoinvisit(param:param , strurl: ConstantURL.kWSUrlGetTypeAndSegmentSetting, method: Apicallmethod.get) {(totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                    if(error.code == 0){
                                                                                                                                                                                                                                                                                        print("response type = \(responseType)  for setting");
                                                                                                                                                                                                                                                                                        let dicofTypeandSegmentSetting = arr as? [String:Any] ?? [String:Any]()
                                                                                                                                                                                                                                                                                        Utils.setDefultvalue(key: Constant.kSettingTypeAndSegment, value: dicofTypeandSegmentSetting)
                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                     var param = Common.returndefaultparameter()
                                                                                                                                                                                                                                                                                        let activeUser = Utils().getActiveAccount()
                                                                                                                                                                                                                                                                                        param["userid"] = activeUser?.userID?.stringValue
                                                                                                                                                                                                                                                                                        param["companyid"] = activeUser?.company?.iD?.stringValue
                                                                                                                                                                                                                                                                                        param["rolelevel"] = NSNumber.init(value: 9)
                                                                                                                                                                                                                                                                                        apicall(url: ConstantURL.kWSUrlgetLowerHeirarchy , param: param, method: Apicallmethod.get) {                                                                                                                     (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in

                                                                                                                                                                                                                                                                                            print("get lower user api called");                                                                                                                                                                                                          if(error.code == 0){
                                                                                                                                                                                                                                                                                                let arrOfUser = arr as? [[String:Any]] ?? [[String:Any]]()
                                                                                                                                                                                                                                                                                                var arrId:[NSNumber] = [self.activeuser?.userID ?? NSNumber.init(value:0)]
                                                                                                                                                                                                                                                                                                print("get user information");                                                                                                                                                                                                                    if(arrOfUser.count > 0){
                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                for item in arrOfUser{
                                                                                                                                                                                                                                                                                                    arrId.append(NSNumber.init(value: (item["id"] as? Int ?? 0)))
                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                BaseViewController.staticlowerUser = [CompanyUsers]()
                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                self.lowerExecutiveUser = [CompanyUsers]()
                                                                                                                                                                                                                                                                                                for user in BaseViewController.staticlowerUser{
                                                                                                                                                                                                                                                                                                    print("role id = \(user.role_id.intValue) at edited method")
                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                BaseViewController.staticlowerUser = BaseViewController.staticlowerUser.filter{
                                                                                                                                                                                                                                                                                                    $0.role_id.intValue <=  8
                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                BaseViewController.staticlowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                                                                                                                                                                                                                                                                                                self.lowerUser = [CompanyUsers]()
                                                                                                                                                                                                                                                                                                self.lowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                print("group is notified");                                                                                                                                                                 Utils.removeShadow(view: self.view);                          if(Sync.isFromDashboard == true){
                                                                                                                                                                                                                                                                                                    SVProgressHUD.dismiss();                                                                                                                                                                                       self.navigationController?.popViewController(animated: true)
                                                                                                                                                                                                                                                                                                    }else{
                                                                                                                                                                                                                                                                                                        SVProgressHUD.dismiss();
                                                                                                                                                                                                                                                                                                        let userdefault = UserDefaults.standard
                                                                                                                                                                                                                                                                                                        userdefault.setValue(true, forKey: Constant.kIsSyncDone)
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                        userdefault.synchronize()
                                                                                                                                                                                                                                                                                                        AppDelegate.shared.rootViewController.switchToMainScreen()
                                                                                                                                                                                                                                                                                                    }

                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            else{
                                                                                                                                                                                                                                                                                print("error in \(error.localizedDescription) for get lower user")
                                                                                                                                                                                                                                                                                                self.rollbackoprations(error: error, message: message)                                                                                                                                                                                              }                                                                                        }
                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                    }else{
                                                                                                                                                                                                                                                                                        print("error in \(error.localizedDescription) for setting");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                        self.rollbackoprations(error: error, message: message)                             }
                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                            } else{
                                                                           
                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                self.rollbackOperation(error: error, message: message)
                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                        })
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                    }                                                                                                                                                         else{
                                                                                                                                                                                                                                                                        //            UserDefaults.standard.set(currentversion, forKey: "currentVersion")
                                                                                                                                                                                                                                                                        //            UserDefaults.standard.synchronize();
                                                                                                                                                                                                                                                                        self.rollbackOperation(error: error, message: message);
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                    }                                                                                                                                                           })                                                                                               } else{
                                                                                                                                                                                                                                                                        self.rollbackOperation(error: error, message: message)
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                    }                                           })
                                                                                                                                                                                
                                                                                                                                                                            }  else{
                                                                                                                                                                                self.rollbackOperation(error: error, message: message)
                                                              
                                                                                                                                                                                
                                                                                                                                                                            }
                                                                                                                                                                        } )
                                                                                                                                                                    } else{
                                                                                                                                            self.rollbackOperation(error: error, message: message)
                                                                                                                                                                    }
                                                                                                                                                                } )
                                                                                                                                                            } else{
                                                                                                                                                                self.rollbackOperation(error: error, message: message)
                                                                                                                                         
                                                                                                                                                            }
                                                                                                                                                        } )
                                                                                                                                                    }else{
                                                                                                                                                        self.rollbackOperation(error: error, message: message)
                                                                                                                                                                                                                   
                                                                                                                                                    }
                                                                                                                                                })
                                                                                                                                                                     
                                                                                                                                        
                                                                                                                                    }else{
                                                                                                                                        
                                                                                                                                        self.rollbackOperation(error: error, message: message)
                                                                                                                                    }
                                                                                                                                })
                                                                                                                                
                                                                                                                            }else{
                                                                                                                                
                                                                                                                                self.rollbackOperation(error: error, message: message)             }
                                                                                                                        })
                                                                                                                    }else{
                                                                                                                        
                                                                                                                        self.rollbackOperation(error: error, message: message)
                                                                                                                        
                                                                                                                    }
                                                                                                                })
                                                                                                                
                                                                                                                
                                                                                                            }else{
                                                                                                                
                                                                                                                                
                                                                                                                self.rollbackOperation(error: error, message: message)
                                                                                                                
                                                                                                            }
                                                                                                        })
                                                                                                        
                                                                                                    }
                                                                                                    else{
                                                               
                                                                                                        self.rollbackOperation(error: error, message: message)
                                                                                                        
                                                                                                    }
                                                                                                })
                                                                                            }
                                                                                            else{
                                                                                
                                                                                                self.rollbackOperation(error: error, message: message)
                                                                                            }
                                                                                        })
                                                                                        //
                                                                                    }else{
                                                                                
                                                                                        self.rollbackOperation(error: error, message: message)
                                                                                    }
                                                                                })
                                                                            } else{
                                                                         
                                                                                self.rollbackOperation(error: error, message: message)                                      }
                                                                        })
                                                                    } else{
                                                                      
                                                                        self.rollbackOperation(error: error, message: message)
                                                                    }
                                                                })
                                                                
                                                                
                                                            }                                                                                 else{
                                                        
                                                                self.rollbackOperation(error: error, message: message)                                                      }
                                                        })
                                                    }
                                                    else{
                                                       
                                                        self.rollbackOperation(error: error, message: message)
                                                    }
                                                })
                                                
                                            }
                                            
                                            else{
                                          
                                                self.rollbackOperation(error: error, message: message)
                                            }
                                        })
                                    }
                                    else{
                                    
                                        self.rollbackOperation(error: error, message: message)
                                    }
                                })
                            }
                            else{
                               
                                self.rollbackOperation(error: error, message: message)
                                
                            }
                        })
                        
                    }else{
                     
                        self.rollbackOperation(error: error, message: message)
                        
                    }
                })
                
            }else{
              
                if let topController = UIApplication.shared.keyWindow?.rootViewController {
                    
                    topController.view.makeToast(error.localizedDescription)
                    
                }
                if(Sync.isFromDashboard!)
                {
                    SVProgressHUD.dismiss()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.navigationController?.popViewController(animated: true)
                    print(error.localizedDescription)
                }
            }
            
            
            
        }
                                                                                                                    }else{
                                                                                                                        self.rollbackOperation(error: error, message: message)

                                                                                                                        
                                                                                                                    }
                                                                                                                } )
        
        
    }
    func originalmethod(){
        if(Sync.isFromDashboard == false){
            SVProgressHUD.show(withStatus: "Syncing")
        }
        Utils.addShadow(view: self.view)
        DispatchQueue.main.async{
            
            self.apihelper.getDefaultSetting {
                (setting:Setting,error:NSError) in
                
                if(error.code == 0){
                    
                    print("get default setting")
                    setting.salesOrderLoadPage = 1
                    
            
                    
                    
                }else{
                    if let topController = UIApplication.shared.keyWindow?.rootViewController {
                        
                        topController.view.makeToast(error.localizedDescription)
                        
                    }
                    if(Sync.isFromDashboard!)
                    {
                        SVProgressHUD.dismiss()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.navigationController?.popViewController(animated: true)
                        print(error.localizedDescription)
                    }
                }
                
                //loadGetAllContact
                
            }
            
            
            self.apihelper.getAllContact(completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
              
                if(error.code == 0){
                    
                    print("get all contact")
                    self.apihelper.getAllVendor(completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,reponseType) in
                       
                        if(error.code == 0){
                            
                            print("get all vendor")
                            self.apihelper.getAllActivity(completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,reponseType) in
                            
                                if(error.code == 0){
                                    //                                                                 print("Activity list = \(totalpages)")
                                    
                                    print("get all activity")
                                    //new API made by backend developer as response  structure is not common
                                    self.apihelper.getTaggedCustomerList(pageno: 1 , pagesize: Constant.CustomerPageSize, completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                    
                                        if(error.code == 0){
                                            print("get all customer \(totalpages)")
                                            //        if let fisrtCustomer = arr[0] as? [String:Any]{
                                            //            let arrOfadd: [[String:Any]] = fisrtCustomer["AddressList"] as? [[String:Any]]{
                                            //                print("arr Of Address = \(arrOfadd)")
                                            //            }
                                            //        }
                                            self.apihelper.getproductcategory(jsonstring: Common.returnjsondata(), pageno: 1, pagesize: Constant.ProductCategoryPageSize, completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                           
                                                if(error.code == 0){
                                                    print("product category list \(totalpages)")
                                                    self.apihelper.loadGetCustomerSegment(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                     
                                                        if(error.code == 0){
                                                            print("Customer Segment \(totalpages)");
                                                            //                                                            self.apihelper.loadGetSyncPO(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                        //                                        if(error.code == 0){
                                                            //                                                                    print("purchase order \(totalpages)");
                                                            self.apihelper.loadGetSyncProposal(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                               
                                                                if(error.code == 0){
                                                                    
                                                                    print("proposal list\(totalpages)")
                                                                    
                                                                    
                                                                    //loadGetSyncSO
                                                                    
                                                                    self.apihelper.loadGetSyncSO(pageno:1,pagesize:Constant.SOPageSize,compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                     
                                                                        if(error.code == 0){
                                                                            print("Sales order \(totalpages)");
                                                                            self.apihelper.loadUserListWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                              
                                                                                if(error.code == 0){
                                                                                    
                                                                                    print("user list \(totalpages)")
                                                                                    self.apihelper.loadVisitOutComeWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    if(error.code == 0){
                                                                                            
                    print("visit outcome list \(totalpages)")
                    self.apihelper.loadLeadSourceWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                              
                                                                                                if(error.code == 0){
                                                                                                    
                                                                                                    print("Lead source list \(totalpages)")
                                                                                                    self.apihelper.loadLeadOutComeWithBlock(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
                                                                                                        
                                                                                                        in
                                                            
                                                                                                        if(error.code == 0){
                                                                                                            print("Lead outcome list \(totalpages)");
                                                                                                            self.apihelper.getSyncedLead(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
                                                                                                                in
                                                                                                                
                                                                                                                if(error.code == 0){
                                                                                                                    
                                                                                                                    print("synced Lead  list \(totalpages)")
                                                                                                                    self.apihelper.getMappedPlannedVisit(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
                                                                                                                        in
                                                                                                                        
                                                                                                                        if(error.code == 0){
                                                                                                                            print("Mapped plan visit list \(totalpages)")
                                                                                                                            self.apihelper.getSyncronisedProduct(pageno: 1, pagesize: Constant.ProductPageSize, compeletion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                
                                                                                                                                if(error.code == 0){
                                                                                                                                    print("syncronised product list \(totalpages)");
                                                                                                        self.apihelper.getCustomerVendorSettings(urlstring: ConstantURL.kWSUrlGetCustomerVendorSettings,compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                           
                                                                                                                                        if(error.code == 0){
                                                                                                                                            print("CustomerVendorSettings \(totalpages)");
                                                                                                                                            self.apihelper.getAttendanceDetails(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                                
                                                                                                                                                if(error.code == 0){
                                                                                                                                                    print("Attendance Detail\(totalpages)");
                                                                                                                                                    self.apihelper.getJointVisitsForManagerLogin(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                                        
                                                                                                                                                        if(error.code == 0){
                                                                                                                                                            print("Joint VisitsFor ManagerLogin \(totalpages)");
                                                                                                                                                            
                                                                                                                                                            self.apihelper.getMetadataVATCodes(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                                                
                                                                                                                                                                if(error.code == 0){
                                                                                                                                                                    print("Metadata VATCodes\(totalpages)");
                                                                                                                                                                    self.apihelper.getCompanyMenuSetting(completionresponse: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                                                        
                                                                                                                                                                        if(error.code == 0){
                                                                                                                                                                            print("Company Menu Setting\(totalpages)")
                                                                                                                                                                            self.apihelper.getStepVisitList(compeletion: {
                                                                                                                                                                                                                (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                if(error.code == 0){
                                                                                                                                                                                                                    print("Step Visit \(totalpages)");
                                                                                                                                                                                                                    if(Utils().getActiveSetting().visitStepsRequired == NSNumber.init(value: 1)) {                                                                                                                                                     print("Visit Step\(totalpages)")
                                                                                                                                                                                                                        
                                                                                                                                                                                                                    }    else{
                                                                                                                                                                                                                        print()                                                                                                                                                     };
                                                                                                                                                                                                                    self.apihelper.loadCompanyInfoWithBlock(compeletion:{
                                                                                                                                                                                                                                                                (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                                                                                                                   //  let currentversion = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
                                                                                                                                                                                                                                                                if(error.code == 0){
                                                                                                                                                                                                                                                                    let carrt = arr as? [String:Any] ?? [String:Any]()
                                                                                                                                                                                                                                                                    print("Company information \(totalpages),\(arr)");
                                                                                                                                                                                                                                                                    MagicalRecord.save({ (localcontext) in
                                                                                                                                                                                                                                                                        Company.mr_truncateAll(in: localcontext)
                                                                                                                                                                                                                                                                        FEMDeserializer.object(fromRepresentation: carrt, mapping: Company.defaultMapping(), context: localcontext)
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                    }) { (status, error) in
                                                                                                                                                                                                                                                                        print("compay information saved")
                                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                                    self.apihelper.loadTerritory(compeletion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                          
                                                                                                                                                                                                                                                                                                    if(error.code == 0){
                                                                                                                                                                                                                                                                                                        print("Territory information \(totalpages)");
                                                                                                                                                                                                                                                                                                        if(Sync.isFromDashboard == true){
                                                                                                                                                                                                                                                                                                            self.navigationController?.popViewController(animated: true)
                                                                                                                                                                                                                                                                                                        }else{
                                                                                                                                                                                                                                                                                                            SVProgressHUD.dismiss();             let userdefault = UserDefaults.standard
                                                                                                                                                                                                                                                                                                            userdefault.setValue(true, forKey: Constant.kIsSyncDone)
                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                            userdefault.synchronize()
                                                                                                                                                                                                                                                                                                            AppDelegate.shared.rootViewController.switchToMainScreen()
                                                                                                                                                                                                                                                                                                        }               
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                        /*self.apihelper.getLowerHierarchyUser { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                         if(error.code == 0){
                                                                                                                                                                                                                                                                                                         let arrOfUser = arr as? [[String:Any]] ?? [[String:Any]]()
                                                                                                                                                                                                                                                                                                         var arrId:[NSNumber] = [self.activeuser?.userID ?? NSNumber.init(value:0)]
                                                                                                                                                                                                                                                                                                         if(arrOfUser.count > 0){
                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                         for item in arrOfUser{
                                                                                                                                                                                                                                                                                                         arrId.append(NSNumber.init(value: (item["id"] as? Int ?? 0)))
                                                                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                                                                         //    print(arrOfUser["id"])
                                                                                                                                                                                                                                                                                                         Utils.removeShadow(view: self.view)
                                                                                                                                                                                                                                                                                                         BaseViewController.staticlowerUser = [CompanyUsers]()
                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                         self.lowerExecutiveUser = [CompanyUsers]()
                                                                                                                                                                                                                                                                                                         for user in BaseViewController.staticlowerUser{
                                                                                                                                                                                                                                                                                                         print("role id = \(user.role_id.intValue)")
                                                                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                                                                         BaseViewController.staticlowerUser = BaseViewController.staticlowerUser.filter{
                                                                                                                                                                                                                                                                                                         $0.role_id.intValue <=  8
                                                                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                         BaseViewController.staticlowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                                                                                                                                                                                                                                                                                                         self.lowerUser = [CompanyUsers]()
                                                                                                                                                                                                                                                                                                         self.lowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                                                                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                                                                         if(Sync.isFromDashboard == true){
                                                                                                                                                                                                                                                                                                         self.navigationController?.popViewController(animated: true)
                                                                                                                                                                                                                                                                                                         }else{
                                                                                                                                                                                                                                                                                                         SVProgressHUD.dismiss();             let userdefault = UserDefaults.standard
                                                                                                                                                                                                                                                                                                         userdefault.setValue(true, forKey: Constant.kIsSyncDone)
                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                         userdefault.synchronize()
                                                                                                                                                                                                                                                                                                         AppDelegate.shared.rootViewController.switchToMainScreen()
                                                                                                                                                                                                                                                                                                         }                                                                                                                                                                                                                                         }else{
                                                                                                                                                                                                                                                                                                         self.rollbackOperation(error: error, message: message)
                                                                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                                                                         }*/
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                    } else{
                                                                                                                                                                                                                                                                                                        self.rollbackOperation(error: error, message: message)
                                                                                                                                                                                                                                                                                                    }                               })
                                                                                                                                                                                                                                                                    //                                                                                                                                                                                             UserDefaults.standard.set(currentversion, forKey: "currentVersion")
                                                                                                                                                                                                                                                                    //                                                                                                                                                                                            UserDefaults.standard.synchronize();                                                                                                                                                     print("Company Info\(totalpages)")
                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                }                                                                                                                                                         else{
                                                                                                                                                                                                                                                                    //            UserDefaults.standard.set(currentversion, forKey: "currentVersion")
                                                                                                                                                                                                                                                                    //            UserDefaults.standard.synchronize();
                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                    self.rollbackOperation(error: error, message: message)                                                                                                                                                    }                                                                                                                                                           })                                                                                               } else{
                                                                                                                                                                                                                                                                        self.rollbackOperation(error: error, message: message)
                                                                                                                                                                                                                                                                    }                                           })
                                                                                                                                                                            
                                                                                                                                                                        }  else{
                                                                                                                                                                            self.rollbackOperation(error: error, message: message)
                                                                                                                                                                        }
                                                                                                                                                                    } )
                                                                                                                                                                } else{
                                                                                                                                                                    self.rollbackOperation(error: error, message: message)
                                                                                                                                                                }
                                                                                                                                                            } )
                                                                                                                                                        } else{
                                                                                                                                                            self.rollbackOperation(error: error, message: message)
                                                                                                                                                        }
                                                                                                                                                    } )
                                                                                                                                                }else{
                                                                                                                                                    self.rollbackOperation(error: error, message: message)
                                                                                                                                                }
                                                                                                                                            })
                                                                                                                                            
                                                                                                                                        }else{
                                                                                                                                            self.rollbackOperation(error: error, message: message)
                                                                                                                                        }
                                                                                                                                    } )
                                                                                                                                    
                                                                                                                                    
                                                                                                                                }else{
                                                                                                                                    
                                                                                                                                    self.rollbackOperation(error: error, message: message)
                                                                                                                                }
                                                                                                                            })
                                                                                                                            
                                                                                                                        }else{
                                                                                                                            
                                                                                                                            self.rollbackOperation(error: error, message: message)             }
                                                                                                                    })
                                                                                                                }else{
                                                                                                                    
                                                                                                                    self.rollbackOperation(error: error, message: message)
                                                                                                                    
                                                                                                                }
                                                                                                            })
                                                                                                            
                                                                                                            
                                                                                                        }else{
                                                                                                            
                                                                                                            self.rollbackOperation(error: error, message: message)
                                                                                                            
                                                                                                        }
                                                                                                    })
                                                                                                    
                                                                                                }
                                                                                                else{
                                                                                                    
                                                                                                    self.rollbackOperation(error: error, message: message)
                                                                                                    
                                                                                                }
                                                                                            })
                                                                                        }
                                                                                        else{
                                                                                            self.rollbackOperation(error: error, message: message)
                                                                                        }
                                                                                    })
                                                                                    //
                                                                                }else{
                                                                                    self.rollbackOperation(error: error, message: message)
                                                                                }
                                                                            })
                                                                        } else{
                                                                            self.rollbackOperation(error: error, message: message)                                      }
                                                                    })
                                                                } else{
                                                                    self.rollbackOperation(error: error, message: message)
                                                                }
                                                            })
                                                            //                                                                }else{
                                                            //                                                                    self.rollbackOperation(error: error, message: message)
                                                            //                                                                }
                                                            //                                                            })
                                                            
                                                        }                                                                                 else{
                                                            self.rollbackOperation(error: error, message: message)                                                      }
                                                    })
                                                }
                                                else{
                                                    self.rollbackOperation(error: error, message: message)
                                                }
                                            })
                                            
                                        }
                                        
                                        else{
                                            self.rollbackOperation(error: error, message: message)
                                        }
                                    })
                                }
                                else{
                                    self.rollbackOperation(error: error, message: message)
                                }
                            })
                        }
                        else{
                            self.rollbackOperation(error: error, message: message)
                            
                        }
                    })
                    
                }else{
                    self.rollbackOperation(error: error, message: message)
                    
                }
            })
            
            
            
            
            //            self.op2.addExecutionBlock {
            //
            //
            //                                Utils.removeShadow(view: self.view)
            //                                if(Sync.isFromDashboard == true){
            //                                    self.navigationController?.popViewController(animated: true)
            //                                }else{
            //                                    SVProgressHUD.dismiss();
            //                                    let userdefault = UserDefaults.standard
            //                                    userdefault.setValue(true, forKey: Constant.kIsSyncDone)
            //
            //                                    userdefault.synchronize()
            //
            //                                    AppDelegate.shared.rootViewController.switchToMainScreen()
            //                                }
            //                            }
            //            self.op2.addDependency(self.op1)
            
        }
        
    }
    private func updateUI() {
        print("waiting status = \(self.isWaiting)")
        if self.isWaiting {
            
            //            self.startTimeInterval = Date().timeIntervalSinceReferenceDate
            //                  self.label.text = "Waiting for APIs"
            //                  self.activityIndicatorView.startAnimating()
            
        } else {
            Utils.removeShadow(view: self.view)
            if(Sync.isFromDashboard == true){
                self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.dismiss();
                let userdefault = UserDefaults.standard
                userdefault.setValue(true, forKey: Constant.kIsSyncDone)
                
                userdefault.synchronize()
                
                AppDelegate.shared.rootViewController.switchToMainScreen()
            }
            //          let delta = Date().timeIntervalSinceReferenceDate - self.startTimeInterval! // Don't use force casting in production
            //          self.label.text = "Responses received in \(delta)"
            //          self.activityIndicatorView.stopAnimating()
        }
    }
    func rollbackoprations(error:Error,message:String){
        print("roll backing")
        isrollback = true
        
        for request in arrRequest {
            print("\(request) is cancelling")
            request.cancel()
        }
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            if(message.count == 0 ){
                if(error.localizedDescription.lowercased().contains("could not be serialized because of")){
                    topController.view.makeToast("Some thing went wrong please try again")
                }else{
                    topController.view.makeToast(error.localizedDescription)
                }
            }else{
                topController.view.makeToast(message)
            }
        }
        if(Sync.isFromDashboard!)
        {
            SVProgressHUD.dismiss()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.navigationController?.popViewController(animated: true)
            print(error.localizedDescription)
        }
    }
    func rollbackOperation(error:Error,message:String){
        //        AlamofireAppManager.shared.request
        //op1.cancel()
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            if(message.count == 0){
                if(error.localizedDescription.lowercased().contains("could not be serialized because of")){
                    topController.view.makeToast("Some thing went wrong please try again")
                }else{
                    topController.view.makeToast(error.localizedDescription)
                }
            }else{
                topController.view.makeToast(message)
            }
        }
        if(Sync.isFromDashboard!)
        {
            SVProgressHUD.dismiss()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.navigationController?.popViewController(animated: true)
            print(error.localizedDescription)
        }
    }
    func jsonFromFile()->Dictionary<String, Any>{
        let path = Bundle.main.path(forResource: "Menus", ofType: "json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                // do stuff
                return jsonResult as? [String:Any] ?? [String:Any]()
            }
        } catch {
            // handle error
        }
        return  [String:Any]()
    }
    
    
    //    let operation1 = BlockOperation {
    //       let group = DispatchGroup()
    //    group.enter()
    //       func query(artist: artist) {artists in
    //          //do stuff with artists
    //          group.leave()
    //       }
    //    group.enter()
    //       func query(track: track) { tracks in
    //          //do stuff with tracks
    //         group.leave()
    //       }
    //    group.enter()
    //       func query(album: album) { albums in
    //          //do stuff with albums
    //          group.leave()
    //       }
    //    group.wait()
    //    //this operation won't return until we have artists, tracks and albums
    //    }
    //    let operation2 = BlockOperation {
    //       print("yay")
    //       // Now, operation2 will fire off once operation1 has completed, with results for artists, tracks and albums
    //    }
    //    operation2.addDependency(operation1)
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
