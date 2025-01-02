//
//  VisitDetail.swift
//  SuperSales
//
//  Created by Apple on 28/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit
import CoreLocation
import SVProgressHUD

class VisitDetail: BaseViewController {
    
    var lastcheckinStatus = UserLatestActivityForVisit.none
    
    @IBOutlet weak var vwCheckInDetail: UIView!
    @IBOutlet weak var lblCheckInDetail: UILabel!
    
    @IBOutlet weak var btnCheckIn: UIButton!
    var itemsvisitDetail:Array<String>!
    
    public static var carbonswipenavigationobj:CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    @IBOutlet weak var targetview: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var btnRefresh: UIButton!
    var isHistory:Bool?
    //var isVisitPlanned:Bool!
    var visitType:VisitType!
    var redirectTo:Int!
    var planvisit:PlannVisit?
    var unplanvisit:UnplannedVisit?
    var detailscreens:[CompanyMenus]!
    var address:AddressList?
    var arrvisitStep:[StepVisitList]!
    //  var aryMandatoryMenuIDs:[Int32]! =  [Int32]()
    var arrSelectedVisitStep:[StepVisitList]! = [StepVisitList]()
    var arrofmandatoryStep:[StepVisitList]! = [StepVisitList]()
    var popup:CustomerSelection? = nil
    
    @IBOutlet var vwCheckinHrightConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setleftbtn(btnType: BtnLeft.back, navigationItem:self.navigationItem)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name.init("updatecheckinInfo"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setCheckinInfo()
        self.arrvisitStep = StepVisitList.getActiveVisitStep()
       
        if(self.activesetting.visitStepsRequired == NSNumber.init(value:1)){
            if(activesetting.storeCheckOwnBrand?.intValue == 0 && activesetting.storeCheckCompetition?.intValue == 0){
                
                arrvisitStep = arrvisitStep.filter{
                    $0.menuIndex != 72
                }
                //arrAvoidablemenu.append(72)
            }
            
            if(activesetting.showShelfSpace?.intValue == 0){
                
                arrvisitStep = arrvisitStep.filter{
                    $0.menuIndex != 74
                }
            }
            if(activesetting.showProductDrive?.intValue == 0){
                
                arrvisitStep = arrvisitStep.filter{
                    $0.menuIndex != 73
                }
            }
            
            if(activesetting.customerProfileInUnplannedVisit?.intValue == 0){
                
                arrvisitStep = arrvisitStep.filter{
                    $0.menuIndex != 67
                    
                }
            }
//            if(activesetting.mandatoryVisitReport?.intValue == 0){
//                arrvisitStep = arrvisitStep.filter{
//                    $0.menuIndex != 35
//
//                }
//            }
            if(activesetting.requireVisitCounterShare?.intValue == 0){
                
                arrvisitStep = arrvisitStep.filter{
                    $0.menuIndex != 66
                    
                }
            }
            if(activesetting.requireVisitCollection?.intValue == 0){
                
                arrvisitStep = arrvisitStep.filter{
                    $0.menuIndex != 65
                    
                }
            }
            if(activesetting.requirePromotionInSO?.intValue == 0){
                
                arrvisitStep = arrvisitStep.filter{
                    $0.menuIndex != 70
                    
                }
            }
            
          
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updatecheckinInfo"), object: nil)
    }
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        self.setCheckinInfo()
        
    }
    // MARK: Method
    
    
    func setUI(){
        self.title = "Visit Report"
        self.salesPlandelegateObject = self
        var strnt = ""
        if(visitType == VisitType.planedvisit || visitType == VisitType.manualvisit){
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.originalNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
               strnt = strn
            }
            self.dateFormatter.dateFormat =  "yyyy/MM/dd HH:mm:ss"
            let date = self.dateFormatter.date(from: strnt) ?? Date()
            let strnextactionDate =  self.dateFormatter.string(from: date)
          
            if(self.activesetting.allowEditVisitDataForPreviousDate == NSNumber.init(value: 0)){

                if(date.isEndDateIsSmallerThanCurrent(checkendDate: Date())){
                    print("it's smaller")
                    if(visitType == VisitType.planedvisit){
                                          vwCheckInDetail.isHidden = true
                                          vwCheckinHrightConstant.constant = 0
                                          }
                }else{
                 print("it's elder")
                    if(visitType == VisitType.manualvisit){
                        vwCheckInDetail.isHidden = true
                        vwCheckinHrightConstant.constant = 0
                    }
                }
            }else{
                if(visitType == VisitType.planedvisitHistory || visitType == VisitType.coldcallvisitHistory || visitType == VisitType.manualvisit){
                    
                    vwCheckInDetail.isHidden = true
                    vwCheckinHrightConstant.constant = 0
                }else{
                    vwCheckInDetail.isHidden = false
                    vwCheckinHrightConstant.constant = 48
                }
            }
        }else    if(visitType == VisitType.planedvisitHistory || visitType == VisitType.coldcallvisitHistory || visitType == VisitType.manualvisit){
            
            vwCheckInDetail.isHidden = true
            vwCheckinHrightConstant.constant = 0
        }else{
            vwCheckInDetail.isHidden = false
            vwCheckinHrightConstant.constant = 48
        }
       
        address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:planvisit?.addressMasterID ?? 0))
        var menu = Utils.getVisitMenu()
        //remove reassign , close visit ,google map,edit customer,edit visit,add territory , give feedback
        let avoidablemenu = [43,36,44,46,45]
        menu = menu.filter{
            !avoidablemenu.contains($0)
        }
        
        let closeandreassignmenu = [50,51,503,42,49,41]
        menu = menu.filter{
            !closeandreassignmenu.contains($0)
        }
        if(self.activesetting.storeCheckOwnBrand == 0 && self.activesetting.storeCheckCompetition == 0){
            menu = menu.filter{
                $0 != 72
            }
        }
        
        let extractplanvisitmenu = [73,74,44,36,42,65,66,72,70,67,37,71] //remove company stock,76 =>custom form
        
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            menu = menu.filter{
                !extractplanvisitmenu.contains($0)
                
            }
        }
        
        if(self.activesetting.showShelfSpace == 0){
            menu = menu.filter{
                $0 != 74
            }
        }
        if(self.activesetting.showProductDrive == 0){
            menu = menu.filter{
                $0 != 73
            }
        }
        
        if(self.activesetting.customerProfileInUnplannedVisit == 0){
            menu = menu.filter{
                $0 != 67
                
            }
        }
        if(self.activesetting.requireVisitCounterShare == 0){
            menu = menu.filter{
                $0 != 66
                
            }
        }
        if(self.activesetting.requireVisitCollection == 0){
            menu = menu.filter{
                $0 != 65
                
            }
        }
        if(self.activesetting.requirePromotionInSO == 0){
            menu = menu.filter{
                $0 != 70
                
            }
        }
        
        if((visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory) && (self.activesetting.requireTempCustomerProfile == 1)){
            
        }else{
            menu = menu.filter{
                $0 != 67
            }
        }
        
        let cmenus = CompanyMenus.getComapnyMenus(menu: menu as [NSNumber], sort: true)
        detailscreens = [CompanyMenus]()
        
        for i in menu{
            for j in cmenus{
                if(j.menuID == i){
                    detailscreens.append(j)
//                    print(j.menuLocalText)
//                    print(j.menuID)
                }
            }
        }
        
        let TitleOfDetailscreen = detailscreens.map{
            $0.menuLocalText
        }
        
        itemsvisitDetail = TitleOfDetailscreen as? Array<String>
        itemsvisitDetail.insert("Details", at: 0)
        
        
        if((visitType == VisitType.planedvisit) || (visitType == VisitType.planedvisitHistory) || (visitType == VisitType.manualvisit)){
            
            self.title = String.init(format:"%@ %lld",NSLocalizedString("visit_no", comment:""),(planvisit?.seriesPostfix ?? 0) )
            
            
            
        }
        if((visitType == VisitType.coldcallvisit)||(visitType == VisitType.coldcallvisitHistory)){
            self.title = String.init(format: "%@ %@",NSLocalizedString("visit_no", comment:""),(unplanvisit?.seriesPostfix ?? 0))
            
            
            let (message,lastcheckinStatus) =  Utils.latestCheckinDetailForUnPlanedVisit(visit: unplanvisit!)
            if(lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
                btnCheckIn.setTitle(NSLocalizedString("CHECK_OUT", comment:""),  for: .normal)
                
            }else{
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""),  for: .normal)
            }
            lblCheckInDetail.text = message
            
        }
        if(visitType == VisitType.planedvisitHistory || visitType == VisitType.coldcallvisitHistory){
            
        }else{
            self.setrightbtn(btnType: BtnRight.editMap, navigationItem: self.navigationItem)
        }
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        
        
        
        btnCheckIn.backgroundColor = UIColor.Appskybluecolor
        
        VisitDetail.carbonswipenavigationobj = CarbonTabSwipeNavigation(items:itemsvisitDetail, toolBar:toolbar , delegate:self)
        VisitDetail.carbonswipenavigationobj.insert(intoRootViewController: self, andTargetView: targetview)
        self.style()
        VisitDetail.carbonswipenavigationobj.setCurrentTabIndex(UInt(redirectTo), withAnimation: true)
     
       
      //  plandate < createddate
      
    }
    
    func setCheckinInfo(){
        SVProgressHUD.dismiss()
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            
            let (message,lastcheckinStatus) = Utils.latestCheckinDetailForUnPlanedVisit(visit: unplanvisit!)
            if(lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
                if(self.activesetting.disableCheckoutInVisit == NSNumber.init(value: 1)){
                    btnCheckIn.setTitle(NSLocalizedString("CHECKED_IN", comment:""), for: .normal)
                }else{
                btnCheckIn.setTitle(NSLocalizedString("CHECK_OUT", comment:""), for: .normal)
                }
                btnRefresh.setImage(UIImage.init(named: "icon_exit"), for: .normal)
            }
            else if(lastcheckinStatus == UserLatestActivityForVisit.none){
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""), for: .normal)
                btnRefresh.setImage(UIImage.init(named:"icon_error"), for:.normal)
            }else{
                btnRefresh.setImage(UIImage.init(named: "icon_error"), for: .normal)
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""), for: .normal)
            }
            lblCheckInDetail.text = message
            
        }else{
            let (message,lastcheckinStatus) =  Utils.latestCheckinDetailForPlanedVisit(visit: planvisit!)
            if(lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
                if(self.activesetting.disableCheckoutInVisit == NSNumber.init(value: 1)){
                    btnCheckIn.setTitle(NSLocalizedString("CHECKED_IN", comment:""), for: .normal)
                }else{
                btnCheckIn.setTitle(NSLocalizedString("CHECK_OUT", comment:""), for: .normal)
                }
           
                btnRefresh.setImage(UIImage.init(named: "icon_exit"), for: .normal)
            }else if(lastcheckinStatus == UserLatestActivityForVisit.none){
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""), for: .normal)
                btnRefresh.setImage(UIImage.init(named:"icon_error"), for:.normal)
            }else{
                btnRefresh.setImage(UIImage.init(named: "icon_error"), for: .normal)
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""), for: .normal)
                //  btnCheckIn.setImage(UIImage.init(named:"icon_error"), for:.normal)
            }
            print("Message of checkin \(message) checkin object = \(planvisit?.checkInOutData) , status = \(lastcheckinStatus), count = \(planvisit?.checkInOutData.count)")
            lblCheckInDetail.text = message
            
        }
    }
    
    func checkCheckInGreen(){
        btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x2A718E)
        if(visitType == VisitType.planedvisit){
            // if(Utils)
        }

    }
    func style(){
        
        let color:UIColor = UIColor.Appthemecolor
        
        let boldfont = UIFont.init(name: Common.kfontbold, size: 15)
        VisitDetail.carbonswipenavigationobj.setIndicatorColor(UIColor.Appthemecolor)
        
        VisitDetail.carbonswipenavigationobj.setSelectedColor(color, font: boldfont ?? UIFont.boldSystemFont(ofSize: 15))
        toolbar.barTintColor = UIColor.white
        // carbonswipenavigationobj.setTabExtraWidth(-10)
        //  VisitDetail.carbonswipenavigationobj.carbonSegmentedControl?.setWidth((UIScreen.main.bounds.size.width)/2 , forSegmentAt: 0)
        
        //    ca
        
        
        //        for index in itemsvisitDetail! {
        //carbonswipenavigationobj.carbonSegmentedControl?.setWidth(CGFloat(200.0), forSegmentAt: (itemsvisitDetail?.firstIndex(of: index))!)
        //        }
        
        //UIFont.init(name: kFontMedium, size: 15)
        
        
        VisitDetail.carbonswipenavigationobj.setNormalColor(UIColor.gray, font: boldfont ?? UIFont.boldSystemFont(ofSize: 15))
        VisitDetail.carbonswipenavigationobj.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
    }
    
    func isPictureavailable(activeplanVisit:PlannVisit,completion: @escaping (_ picstatus:Bool)->()){
        let group = DispatchGroup()
        var availabale = false
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["VisitID"] =  activeplanVisit.iD
        group.enter()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetVisitUploadImages, method: Apicallmethod.get) {
           
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
               
                if(responseType == ResponseType.arr){
                    let arrofpicturedata = arr as? [[String:Any]] ?? [[String:Any]]()
                   
                    if(arrofpicturedata.count > 0){
                        availabale = true
                    }else{
                        availabale = false
                    }
                    group.leave()
                }else if (responseType == ResponseType.arrOfAny){
                    if let arrofany = arr as? [Any]{
                        if(arrofany.count > 0){
                            availabale = true
                            group.leave()
                        }else{
                            availabale = false
                            group.leave()
                        }
                    }else{
                        availabale = false
                        group.leave()
                    }
                }else if(error.code == 0){
                  
                    availabale =  false
                    
                    
                    group.leave()
                    
                }else{
                  
                    availabale =  false
                    
                    Utils.toastmsg(message:"Error while checking picture",view: self.view)
                    group.leave()
                    
                }
            }
            
            
        }
        // Notify Completion of tasks on main thread.
        group.notify(queue: .main) {
        if(availabale == false){
            completion(availabale)
        }else{
            completion(availabale)
        }
        }
        
    }
    
    func isFeedbackAvailable(planvisit:PlannVisit,completion:@escaping(_ feedbackstatus:Bool)->()){
        let group = DispatchGroup()
        var availabale = false
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        //                        if(visitType == VisitType.coldcallvisit){
        //                        param["VisitTypeID"] = "2"
        //                        }else{
        param["VisitTypeID"] = "1"
        // }
        //                        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
        //                            param["visitId"] = unplanvisit.localID
        //                            param["CustomerID"] =  unplanvisit.customerID
        //                            if(unplanvisit.customerID!.intValue ?? 0 > 0){
        //                                if   let customer = CustomerDetails.getCustomerByID(cid: unplanvisit.customerID ?? 0){
        //                                    param["CustomerName"] = customer.name
        //                            }else{
        //                            param["CustomerName"] = ""
        //                            }
        //                            }else{
        //                                 param["CustomerName"] = ""
        //                            }
        //                        }else{
        param["visitId"] =  planvisit.iD
        param["CustomerID"] = NSNumber.init(value:planvisit.customerID)
        if(planvisit.customerID ?? 0 > 0){
            if   let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planvisit.customerID ?? 0)){
                param["CustomerName"] = customer.name
            }else{
                param["CustomerName"] = ""
            }
        }else{
            param["CustomerName"] = ""
        }
        // }
        group.enter()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetUserFeedback, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
                if(responseType ==  ResponseType.arr){
                    let arrOfFeedback = arr as? [[String:Any]] ?? [[String:Any]]()
                    var arrFeedBack:[Feedback] = [Feedback]()
                    for feed in  arrOfFeedback{
                        let feedback  = Feedback().initwithdic(dic: feed)
                        arrFeedBack.append(feedback)
                    }
                    if(arrOfFeedback.count > 0){
                       
                        let firstfeedback = arrFeedBack.first
                        if(firstfeedback?.userAnswerValue?.count ?? 0 > 0){
                            availabale = true
                            
                        }else{
                            availabale = false
                            
                        }
                       
                        
                        group.leave()
                        
                        
                    }else{
                        availabale = false
                        group.leave()
                    }
                    
                    //                                    }else{
                    //                                        isToast = true
                    //                                    Utils.toastmsg(message:"Please give feedback",view: self.view)
                    //                                    return
                    //                                    }
                    
                }else{
                    
                    if ( message.count > 0 ) {
                        Utils.toastmsg(message:message,view: self.view)
                        
                    }
                    availabale = false
                    group.leave()
                }
                
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                }
                availabale = false
                group.leave()
            }else{
                availabale = false
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                group.leave()
                
            }
            // Notify Completion of tasks on main thread.
            group.notify(queue: .main) {
            if(availabale == false){
                completion(availabale)
            }else{
                completion(availabale)
            }
            }
        }
    }
    
    func isTerritoryAvailable(planvisit:PlannVisit,completion:@escaping(_ territorystatus:Bool)->()){
        let group1 = DispatchGroup()
        var availabale = false
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
//            if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
//                param["getVisitTertiaryJson"] = Common.returnjsonstring(dic: ["VisitID":unplanVisit?.localID ?? 0])
//                   }else{
        param["getVisitTertiaryJson"] =  Common.returnjsonstring(dic: ["VisitID":planvisit.iD ?? 0])
            ///     }
        group1.enter()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetVisitTertiary, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
//                self.arrTerritory.removeAll()
                        if(status.lowercased() == Constant.SucessResponseFromServer){
                        if(responseType == ResponseType.arr){
                            let arrOfTerritory =  arr as? [[String:Any]] ?? [[String:Any]]()
                            if(arrOfTerritory.count > 0){
                                availabale = true
                                group1.leave()
//                                    for territory in arrOfTerritory{
//                                        let territ = TerritoryData().initwithdic(dict: territory)
//
//                                        self.arrTerritory.append(territ)
//                                    }
                            }else{
                                availabale = false
                                group1.leave()
                            }
                        }else{
                           if let arrofter = arr as? [Any]{
                            if(arrofter.count > 0){
                                    availabale = true
                                    group1.leave()
                                }else{
                                    availabale = false
                                    group1.leave()
                                }
                           }else{
                            availabale = false
                            group1.leave()
                           }
                        }
                        //  self.tblTertiaryListing.reloadData()
//                            if ( message.count > 0 ) {
//                         Utils.toastmsg(message:message,view: self.view)
//                    }
                        }
                            else if(error.code == 0){
                                
                            Utils.toastmsg(message:"Error while checking territory",view: self.view)
                        //  self.tblTertiaryListing.reloadData()
                
            group1.leave()
                            }else{
                                group1.leave()
                            }
        }
        group1.notify(queue: .main) {
        if(availabale == false){
            completion(availabale)
        }else{
            completion(availabale)
        }
        }
    }
        
    
    
    func finalcheckout(){
        /*
         let arrofmandatorystepID = arrofmandatoryStep.map {
         return $0.menuIndex
         }
         if(visitType == VisitType.planedvisit && (!(visitType == VisitType.planedvisitHistory))){
         if(self.activesetting.customTagging == 3){
         if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:activeplanVisit?.customerID ?? 0)))){
         Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view: self.view)
         return
         
         }
         
         }
         }
         if(self.activesetting.mandatoryPictureInVisit == 1 && (arrofmandatorystepID.contains(38))){
         if(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
         if(activeunplanVisit?.isPictureAvailable ==  1){
         Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
         return
         }
         }else{
         if(activeplanVisit?.isPictureAvailable == 1){
         Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
         return
         }
         }
         }
         if(self.activesetting.mandatoryVisitReport == 1  && (arrofmandatorystepID.contains(35))){
         if (visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
         if (activeunplanVisit?.visitStatusList.count == 0){
         Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
         
         return
         }
         }else{
         if (activeplanVisit?.visitStatusList.count == 0){
         Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
         return
         }
         }
         }
         
         if((self.activesetting.requireSOFromVisitBeforeCheckOut == 1) && (!(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory)) && (arrofmandatorystepID.contains(65))) {
         if let collection = activeplanVisit.visitCounterShare as? VisitCounterShare{
         
         }else{
         Utils.toastmsg(message:NSLocalizedString("please_add_collection_in_this_visit_for_check_Out", comment: ""),view: self.view)
         return
         }
         }
         if(self.activesetting.requireVisitCounterShare == NSNumber.init(value: 1) && (arrofmandatorystepID.contains(66))){
         if let countershare = activeplanVisit?.visitCounterShare {
         
         }else{
         Utils.toastmsg(message:NSLocalizedString("please_add_counter_share_in_this_visit_for_check_Out", comment: ""),view: self.view)
         return
         }
         }
         **/
        let arrofmandatorystepID = arrofmandatoryStep.map {
            return $0.menuIndex
        }
        if(visitType == VisitType.planedvisit && (!(visitType == VisitType.planedvisitHistory))){
            if(self.activesetting.customTagging == 3){
                if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:planvisit?.customerID ?? 0)))){
                    Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view: self.view)
                    return
                    
                }
                
            }
        }// && (arrofmandatorystepID.contains(38) Grishma said to remove it
        if(self.activesetting.mandatoryPictureInVisit == 1 ){
            if(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                if(unplanvisit?.isPictureAvailable ==  1){
                    
                }else{
                    Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
                    return
                }
            }else{
                if let planVisit = planvisit as? PlannVisit{
                    self.isPictureavailable(activeplanVisit: planVisit, completion: { (picstatus) in
                        if(picstatus){
                            
                        }else{
                          //  Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
                            return
                        }
                    })
                    
                    
                }
                
                
            }
        }// && (arrofmandatorystepID.contains(35) Grishma said to remove it
//        12
        if(self.activesetting.mandatoryVisitReport == 1  && (self.activesetting.visitStepsRequired == NSNumber.init(value: 0))){
                if (visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                    if (planvisit?.visitStatusList.count == 0){
                        Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
                        
                        return
                    }
                }else{
                    if (planvisit?.visitStatusList.count == 0){
                        Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
                        return
                    }
                }
            }
        if((self.activesetting.requireSOFromVisitBeforeCheckOut == 1) && (!(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory)) && self.activesetting.visitStepsRequired == NSNumber.init(value: 0)){
            /*if(self.activesetting.requireVisitCounterShare == NSNumber.init(value: 1)){
            if let countershare = planvisit?.visitCounterShare {
                
            }else{
                Utils.toastmsg(message:NSLocalizedString("please_add_counter_share_in_this_visit_for_check_Out", comment: ""),view: self.view)
                return
            }
        }
             else if(self.activesetting.requireVisitCollection == NSNumber.init(value: 1)){
                if let countershare = planvisit?.visitCollection as? VisitCollection {
                    
                }else{
                    Utils.toastmsg(message:NSLocalizedString("please_add_collection_in_this_visit_for_check_Out", comment: ""),view: self.view)
                    return
                }
                }
            else
                */
                
                
                if let order = Utils.getorderByVisitId(visitID: NSNumber.init(value: planvisit?.iD ?? 0)){
               
            }else{
             
                Utils.toastmsg(message:"Please add sales order",view: self.view)
              
                return
            }
           
        }
        if(self.activesetting.visitStepsRequired == NSNumber.init(value: 0)){
            
            if(self.activesetting.requireVisitCounterShare == NSNumber.init(value: 1)){
                if let countershare = planvisit?.visitCounterShare {
                    
                }else{
                    Utils.toastmsg(message:NSLocalizedString("please_add_counter_share_in_this_visit_for_check_Out", comment: ""),view: self.view)
                    return
                }
            }
        }
       
       
      
        
        if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
            
            if((CLLocationCoordinate2DIsValid(currentCoordinate)) && currentCoordinate.latitude != 0.0 && currentCoordinate.longitude != 0.0 ){
                VisitCheckinCheckout.verifyCheckoutAddress = false
                VisitCheckinCheckout().checkForVisit(visitType: visitType, planvisit: planvisit ?? PlannVisit(), unplanvisit: unplanvisit ?? UnplannedVisit(), viewcontroller: self) { territorystatus in
                    if(territorystatus){
                        VisitCheckinCheckout().checkout(visitstatus:0,lat:NSNumber.init(value: currentCoordinate.latitude) ,long:NSNumber.init(value:currentCoordinate.longitude), isVisitPlanned: self.visitType, objplannedVisit: self.planvisit ?? PlannVisit() ,objunplannedVisit: self.unplanvisit ?? UnplannedVisit(),viewcontroller:self,addressID: NSNumber.init(value: 0))
                    }else{
                        Utils.toastmsg(message: "something went wrong, please try again", view: self.view)
                    }
                }
               
                
            }
            
        }else{
            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
            let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
            }
            Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
            
        }
    }
    
    func visitStepsStatusCheck(){
        
        // Create Group
        let group = DispatchGroup()
//        self.arrvisitStep.sort { (step1, step2) -> Bool in
//            step1.menuIndex < step2.menuIndex
//        }
        arrvisitStep.sort { (s1, s2) -> Bool in
            s1.menuOrder < s2.menuOrder
        }
        
        for visitStepsData in self.arrvisitStep{
            
            group.enter()
            //  if(visitStepsData.mandatoryOrOptional == true){
            if(visitStepsData.menuIndex == 35){
                if(visitType == VisitType.coldcallvisit){
                    if(unplanvisit?.visitStatusList.count ?? 0 > 0){
                        //   aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                        self.arrSelectedVisitStep.append(visitStepsData)
                        group.leave()
                    }else{
                        group.leave()
                    }
                }else{
                    if(planvisit?.visitStatusList.count ?? 0  > 0){
                        //     aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                        self.arrSelectedVisitStep.append(visitStepsData)
                        group.leave()
                    }else{
                        group.leave()
                    }
                }
            }else if(visitStepsData.menuIndex == 36){
                if(visitType == VisitType.planedvisit){
                    if let order = Utils.getorderByVisitId(visitID: NSNumber.init(value: planvisit?.iD ?? 0)){
                        print(order.customerName)
                        self.arrSelectedVisitStep.append(visitStepsData)
                        group.leave()
                    }else{
                        group.leave()
                    }
                }else{
                    group.leave()
                }
            }else if(visitStepsData.menuIndex == 38){
                if(visitType == VisitType.coldcallvisit){
                    if(unplanvisit?.isPictureAvailable == 1){
                        //   aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                        self.arrSelectedVisitStep.append(visitStepsData)
                        group.leave()
                    }else{
                        group.leave()
                    }
                }else{
                    if let planVisit =  planvisit{
                        self.isPictureavailable(activeplanVisit: planVisit, completion: { (picstatus) in
                            if(picstatus){
                                self.arrSelectedVisitStep.append(visitStepsData)
                                group.leave()
                            }else{
                                group.leave()
                            }
                        })
                        
                    }else{
                        group.leave()
                    }
                }
                
            }
            else if (visitStepsData.menuIndex == 39){
                if(visitType == VisitType.coldcallvisit){
                    group.leave()
                    //                        if(unplanvisit.isPictureAvailable == 1){
                    //                         //   aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                    //                            arrSelectedVisitStep.append(visitStepsData)
                    //                        }else{
                    //
                    //                        }
                }else{
                    if let planVisit = planvisit as? PlannVisit{
                        self.isFeedbackAvailable(planvisit: planVisit) { (feedbackstatus) in
                            if(feedbackstatus){
                                group.leave()
                                self.arrSelectedVisitStep.append(visitStepsData)
                            }else{
                                group.leave()
                            }
                        }
                    }else{
                        group.leave()
                    }
                    
                    
                }
            }else if (visitStepsData.menuIndex == 40){
                if(visitType == VisitType.coldcallvisit){
                    group.leave()
                    
                }else{
                    var para = Common.returndefaultparameter()
                    
                    var getvisitjson = [String:Any]()
                    if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                        getvisitjson["VisitID"] = unplanvisit?.localID
                    }else{
                        getvisitjson["VisitID"] = planvisit?.iD
                    }
                    para["getVisitStockJson"] =  Common.json(from: getvisitjson)
                    SVProgressHUD.setDefaultMaskType(.black)
                    SVProgressHUD.show()
                    self.apihelper.getdeletejoinvisit(param: para, strurl: ConstantURL.kWSUrlGetVisitStock, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                        SVProgressHUD.dismiss()
                        
                        
                        if(status.lowercased() == Constant.SucessResponseFromServer){
                            print(arr)
                            
                            if(responseType == ResponseType.arr){
                                let arrOfStock = arr as? [[String:Any]] ?? [[String:Any]]()
                                if(arrOfStock.count > 0){
                                    self.arrSelectedVisitStep.append(visitStepsData)
                                    group.leave()
                                    //
                                }else{
                                    group.leave()
                                }
                            }else{
                                group.leave()
                            }
                        }else if(error.code == 0){
                            if ( message.count > 0 ) {
                                Utils.toastmsg(message:message,view: self.view)
                                group.leave()
                            }else{
                                Utils.toastmsg(message:"Error while Checking stock",view: self.view)
                                group.leave()
                            }
                        }else{
                            Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "Error while Checking stock",view: self.view)
                            group.leave()
                        }
                    }
                    //                        if(activeplanVisit.isStockAvailable == 1){
                    //                          //  aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                    //                            arrSelectedVisitStep.append(visitStepsData)
                    //                        }
                }
            }else if (visitStepsData.menuIndex == 41){
                if(visitType == VisitType.coldcallvisit){
                    group.leave()
                    
                }else{
                    if let planVisit = planvisit as? PlannVisit{
                     self.isTerritoryAvailable(planvisit: planVisit) { (territorystatus) in
                        if(territorystatus){
                            self.arrSelectedVisitStep.append(visitStepsData)
                                                  group.leave()
                        }else{
                                                  group.leave()
                        }
                        }
                    }else{
                        group.leave()
                    }
//                   // if(planvisit?.isTertiaryAvailable == 1){
//                        //  aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
//                        self.arrSelectedVisitStep.append(visitStepsData)
//                        group.leave()
//                    }else{
                        
                  //  }
                }
            }else if (visitStepsData.menuIndex == 65){
                if(visitType == VisitType.coldcallvisit){
                    group.leave()
                    //                        if(unplanvisit?.collection.count ?? 0 > 0){
                    //                         //   aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                    //                            arrSelectedVisitStep.append(visitStepsData)
                    //                        }else{
                    //
                    //                        }
                }else{
                    if let collection = planvisit?.visitCollection{
                        //     aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                        self.arrSelectedVisitStep.append(visitStepsData)
                        group.leave()
                    }else{
                        group.leave()
                    }
                }
            }else if (visitStepsData.menuIndex == 66){
                if(visitType == VisitType.coldcallvisit){
                    group.leave()
                    //                        if(unplanvisit?.collection.count ?? 0 > 0){
                    //                         //   aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                    //                            arrSelectedVisitStep.append(visitStepsData)
                    //                        }else{
                    //
                    //                        }
                }else{
                    if let countershare = planvisit?.visitCounterShare{
                        //     aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                        self.arrSelectedVisitStep.append(visitStepsData)
                        group.leave()
                    }else{
                        group.leave()
                    }
                }
            }else if (visitStepsData.menuIndex == 72){
                
                //Store check
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
                var param = Common.returndefaultparameter()
//                if(StoreCheckContainer.visitType == VisitType.coldcallvisit){
//                    param["VisitID"] = StoreCheckContainer.unplanVisit?.localID
//                    param["CustomerID"] =  StoreCheckContainer.unplanVisit?.customerID
//                }else{
//                    param["VisitID"] = StoreCheckContainer.planVisit?.iD
//                    param["CustomerID"] =  StoreCheckContainer.planVisit?.customerID
//                }
                if let planvisit = planvisit as? PlannVisit{
                    param["VisitID"] = planvisit.iD
                    param["CustomerID"] =  planvisit.customerID
                }else{
                    param["VisitID"] = unplanvisit?.localID
                    param["CustomerID"] =  unplanvisit?.customerID
                }
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetStoreCheckData, method: Apicallmethod.get){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    StoreCheckContainer.storeCheckBrandActivityList.removeAll()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        //print(arr)
                        SVProgressHUD.dismiss()
                        if(responseType ==  ResponseType.dic){
                            
                            let dicresponse = arr as? [String:Any] ?? [String:Any]()
                            StoreCheckContainer.visitBrandActivityExists =  Common.returndefaultbool(dic: dicresponse, keyvalue: "visitBrandActivityExists")
                            StoreCheckContainer.visitCompetitionExists = Common.returndefaultbool(dic: dicresponse, keyvalue: "visitCompetitionExists")
                            if((StoreCheckContainer.visitBrandActivityExists == false) || (StoreCheckContainer.visitCompetitionExists == false) ){
                                group.leave()
                                //                                        isToast = true
                                //                                        Utils.toastmsg(message:"Please add Store check",view: self.view)
                                //                                        return
                            }else{
                                self.arrSelectedVisitStep.append(visitStepsData)
                                group.leave()
                            }
                        }else{
                            group.leave()
                        }
                    }else{
                        group.leave()
                        SVProgressHUD.dismiss()
                    }
                }
                
                
                
            }
            else if(visitStepsData.menuIndex == 74){
                
                //Shelf Space
                var arrOfShelfSpace =  [ShelfSpaceModel]()
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
                var param = Common.returndefaultparameter()
                if((visitType == VisitType.coldcallvisit) || (visitType == VisitType.coldcallvisitHistory)){
                    param["VisitID"] = unplanvisit?.localID
                }else{
                    param["VisitID"] = planvisit?.iD
                }
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetShelfSpaceList1, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                    
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        print(responseType)
                        arrOfShelfSpace.removeAll()
                        if(responseType == ResponseType.arr){
                            let arrofshelfspce = arr as? [[String:Any]] ?? [[String:Any]]()
                            for sh in arrofshelfspce{
                                let shelfspace = ShelfSpaceModel.init(dic: sh)
                                arrOfShelfSpace.append(shelfspace)
                            }
                            // self.tblShelfSpace.reloadData()
                            if(arrofshelfspce.count == 0){
                                print("group is leaving 1")
                                group.leave()
                                //                                    isToast = true
                                //                                    Utils.toastmsg(message:"Please add Shelf space",view: self.view)
                                //                                    return
                            }else{
                                let shelfspacebyvisitid = arrOfShelfSpace.filter{
                                    $0.VisitID == self.planvisit?.iD ?? 0
                                }
                                if(shelfspacebyvisitid.count > 0){
                                    self.arrSelectedVisitStep.append(visitStepsData)
                                    print("group is leaving 2")
                                    group.leave()
                                }else{
                                    print("group is leaving 3")
                                    group.leave()
                                    //                                        isToast = true
                                    //                                        Utils.toastmsg(message:"Please add Shelf space",view: self.view)
                                    //                                        return
                                }
                            }
                        }else{
                            group.leave()
                        }
                    }else{
                        print("group is leaving 4")
                        group.leave()
                        SVProgressHUD.dismiss()
                    }
                }
            }else{
                print("group is leaving 5 , \(visitStepsData.menuIndex)")
                group.leave()
            }
        }
        
        // Notify Completion of tasks on main thread.
        group.notify(queue: .main) {
            // Update UI
            print("group is notfied \(self.arrSelectedVisitStep.count)" )
            if  let popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection{
                popup.isFromSalesOrder =  false
                popup.modalPresentationStyle = .overCurrentContext
                popup.strTitle = "Visit Steps"
                popup.nonmandatorydelegate = self
                popup.arrOfVisitStep = self.arrvisitStep
                popup.arrOfMandatoryStep =  self.arrofmandatoryStep
                popup.arrOfSelectedVisitStep = self.arrSelectedVisitStep ?? [StepVisitList]() //arrSelectedVisitStep
                popup.arrOfDisableVisitStep = self.arrSelectedVisitStep ?? [StepVisitList]()
                popup.strLeftTitle = "OK"
                popup.strRightTitle = "CANCEL"
                popup.selectionmode = SelectionMode.multiple
                
                popup.isSearchBarRequire = false
                popup.viewfor = ViewFor.visitStep
                popup.isFilterRequire = false
                // popup.showAnimate()
                popup.parentViewOfPopup = self.view
                
                Utils.addShadow(view: self.view)
                
                self.present(popup, animated: false, completion: nil)
                
                
            }
            
        }
        
    
    
    }
    // MARK: -IBAction
    
    
    @IBAction func btnCheckInClicked(_ sender: UIButton) {
        // if(visitType == VisitType.planedvisit){
        //plan visit check in
        if(sender.currentTitle == NSLocalizedString("CHECK_IN", comment: "")){
            //  if(visitType == VisitType.planedvisit){
            if(Utils().FirstCheckInAttendance(view: self) ==  true){
                if(activesetting.customTagging == NSNumber.init(value: 3)){
                    
                    if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
                        if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:planvisit?.customerID ?? 0)))){
                            Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view: self.view)
                            return
                        }
                    }
                }
                
                
                if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
                    //          CLLocationCoordinate2DIsValid(currentCoordinate)
                    if(CLLocationCoordinate2DIsValid(currentCoordinate)){
                        var visitID = NSNumber.init(value: 0)
                        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory ){
                            visitID = NSNumber.init(value:planvisit?.iD ?? 0)
                        }else{
                            visitID = NSNumber.init(value: unplanvisit?.localID ?? 0)
                        }
                        VisitCheckinCheckout.verifyAddress = false
                        VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: currentCoordinate.latitude) ,long:NSNumber.init(value:currentCoordinate.longitude), isVisitPlanned: visitType, objplannedVisit: planvisit ?? PlannVisit() ,objunplannedVisit: unplanvisit ?? UnplannedVisit(), visitid: visitID,viewcontroller:self, addressID: NSNumber.init(value: 0))
                    }else{
                        if let topview = UIApplication.shared.keyWindow?.rootViewController{
                            topview.view.makeToast("not get valid location \(currentCoordinate.latitude) , \(currentCoordinate.longitude)")
                        }
                    }
                    
                }
                else{
                    let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                    let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                    }
                    Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
                    
                }
                
                
                //                }else{
                //                    //un plan visit checkin
                //                }
            }else{
                
                
            }
        }
        else if(sender.currentTitle == NSLocalizedString("CHECKED_IN", comment: "")){
            
        }else{
            if(self.activesetting.visitStepsRequired ==  1 && visitType == VisitType.planedvisit){
                
               
                arrvisitStep.sort { (s1, s2) -> Bool in
                    s1.menuOrder < s2.menuOrder
                }
                arrSelectedVisitStep = [StepVisitList]()
                
                
               
                if let selectedcustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: planvisit?.customerID ?? 0)) as?  CustomerDetails{
                    
                    Utils().filterStepAccordingToCustTypeCustSegment(arrOfVisitStep: arrvisitStep, customer: selectedcustomer) { arrOffilteredStep in
                        self.arrvisitStep = arrOffilteredStep
                    }

                }
                if(arrvisitStep.count == 0){
                    self.finalcheckout()
                    return
                }
                arrofmandatoryStep = arrvisitStep.filter{
                    $0.mandatoryOrOptional == true
                }
                
                print("count of man step = \(arrofmandatoryStep.count)")
                
              
                    if let selectedcustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: planvisit?.customerID ?? 0)) as?  CustomerDetails{
                        let companytypeid = NSNumber.init(value:selectedcustomer.companyTypeID)
                        let segment = NSNumber.init(value:selectedcustomer.segmentID)
                        
                        for stepvisit in arrofmandatoryStep{
                            if let visitStatusType = stepvisit.customerType as? String{
                                if let visitStatusSegment = stepvisit.customerSegment as? String{
                                    if(visitStatusType.lowercased() == "off" || visitStatusSegment.lowercased() == "off"){
                                        arrofmandatoryStep =    arrofmandatoryStep.filter{
                                            $0 != stepvisit
                                        }
                                    }else{
                                        let arrOfKYCType = visitStatusType.components(separatedBy: ",")
                                        let arrOfKYCSegment = visitStatusSegment.components(separatedBy: ",")
                                        if(arrOfKYCType.contains(companytypeid.stringValue) && arrOfKYCSegment.contains(segment.stringValue)){
                                            print("type of customer = \(companytypeid) , segment of customer = \(segment) , arr of type = \(arrOfKYCType) , arr of segment = \(arrOfKYCSegment) name of step is = \(stepvisit.menuLocalText), \(visitStatusType) , \(visitStatusSegment) \(arrOfKYCType.contains(companytypeid.stringValue)) , \(arrOfKYCSegment.contains(segment.stringValue))")
                                        }else{
                                            print("type of customer = \(companytypeid) , segment of customer = \(segment) , arr of type = \(arrOfKYCType) , arr of segment = \(arrOfKYCSegment) name of step is = \(stepvisit.menuLocalText), \(visitStatusType) , \(visitStatusSegment) \(arrOfKYCType.contains(companytypeid.stringValue)) , \(arrOfKYCSegment.contains(segment.stringValue)) not done")
                                            arrofmandatoryStep =    arrofmandatoryStep.filter{
                                                $0 != stepvisit
                                            }
                                        }
                                        
                                     
                                       
                                    }
                                }
                            }
                        }
                    
                    }
                
                print("count of man step = \(arrofmandatoryStep.count)")
            //    arrofmandatoryStep.contains(arrOfNonMandatoryStep)
                
                
                //                    if(self.activesetting.mandatoryVisitReport == 1){
                //                        if (visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                //                            if (unplanvisit?.visitStatusList.count == 0){
                //                                Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
                //
                //                                return
                //                            }
                //                        }else{
                //                            return
                //                        }
                self.visitStepsStatusCheck()
            }
            
            
            else{
                self.finalcheckout()
            }
            
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
        
    }

}

extension VisitDetail:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        var selectedmenu = CompanyMenus()
        print(Int(index))
        let  selectedstr = itemsvisitDetail[Int(index)]
        if(Int(index) > 0){
            selectedmenu = detailscreens[Int(index)-1]
            print(selectedmenu.menuID)
            print(selectedmenu.menuLocalText)
            if selectedmenu.menuID == 37 {
                let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "UpdateSalesOrder") as! UpdateSalesOrder
                vc.customerID = planvisit?.customerID ?? 0
                return vc
            }else if(selectedmenu.menuID == 74){
                //shelf space list
                if  let shelfspacelist =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.ShelfSpaceList) as? ShelfSpaceController{
                    shelfspacelist.visitType = self.visitType
                    shelfspacelist.ObjVisitForShelfSpace = planvisit ?? PlannVisit()
                    shelfspacelist.ObjUnPlannedVisitForSpace = unplanvisit ??
                        UnplannedVisit()
                    return shelfspacelist
                }else{
                    return UIViewController()
                }
            }else if(selectedmenu.menuID == 35){
                //visit report
                if  let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
                    visitReport.isFromVisit = true
                    visitReport.visitType  = visitType
                    if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
                        let visitreportList =  planvisit?.visitStatusList
                        if(visitreportList?.count ?? 0 > 0){
                            visitReport.isupdateReport = true
                            visitReport.planVisit = planvisit
                            visitReport.latestvisitreport = visitreportList?.lastObject as? VisitStatus
                        }else{
                            visitReport.isupdateReport = false
                            visitReport.planVisit = planvisit
                        }
                        return visitReport
                    }else if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory ){
                        let unplanvisitreportList =  unplanvisit?.visitStatusList
                        if(unplanvisitreportList?.count ?? 0 > 0){
                            visitReport.isupdateReport = true
                            visitReport.unplanvisitReport = unplanvisitreportList?.last
                        }else{
                            visitReport.isupdateReport = false
                        }
                    }
                    visitReport.planVisit = planvisit ?? PlannVisit()
                    visitReport.unplanVisit = unplanvisit ??
                        UnplannedVisit()
                    
                    return visitReport
                }else{
                    return UIViewController()
                }
            }else if(selectedmenu.menuID == 38){
                if  let addPicture = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddPicture) as? AddPicture{
                    addPicture.visitType = visitType
                    addPicture.planVisit = planvisit ?? PlannVisit()
                    addPicture.unplanVisit = unplanvisit ??  UnplannedVisit()
                    return addPicture
                }else{
                    return UIViewController()
                }
            }
            //        else if(selectedmenu.menuID == 45){
            //            //view feedback
            //
            //            if  let viewfeedback = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.ViewFeedBack) as? ViewFeedback{
            //                       viewfeedback.visitType = visitType
            //                       viewfeedback.planVisit = planvisit ?? PlannVisit()
            //                       viewfeedback.unplanVisit = unplanvisit ??  UnplannedVisit()
            //                       return viewfeedback
            //                           }else{
            //                                         return UIViewController()
            //                                     }
            //        }
            else if(selectedmenu.menuID == 39){
                if  let viewfeedback = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.ViewFeedBack) as? ViewFeedback{
                    viewfeedback.visitType = visitType
                    viewfeedback.planVisit = planvisit ?? PlannVisit()
                    viewfeedback.unplanVisit = unplanvisit ??  UnplannedVisit()
                    return viewfeedback
                }else{
                    return UIViewController()
                }
            }else if(selectedmenu.menuID == 65){
                //65
                if let visitColelction = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitCollection) as? AddVisitCollection{
                    if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                        
                    }else{
                        visitColelction.planvisit = self.planvisit
                        // if(planvisit?.visitCollection.count ?? 0 > 0){
                        if  let  collection = planvisit?.visitCollection{
                            visitColelction.isEditCollection = true
                            visitColelction.collectionList =  collection
                        }else{
                            visitColelction.isEditCollection = false
                        }
                    }
                    return visitColelction
                }else{
                    return UIViewController()
                }
            }else if(selectedmenu.menuID == 72){
                //
                if  let storecheck = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.StoreCheckContainer) as? StoreCheckContainer{
                    StoreCheckContainer.visitType = visitType
                    StoreCheckContainer.planVisit = planvisit ?? PlannVisit()
                    StoreCheckContainer.unplanVisit = unplanvisit ??  UnplannedVisit()
                    return storecheck
                }else{
                    return UIViewController()
                }
            }else if(selectedmenu.menuID == 71){
                
                if   let viewCompanyStock = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.ViewCompanyStock) as? ViewCompanyStock{
                    
                    return viewCompanyStock
                }else{
                    return UIViewController()
                }
            }else if(selectedmenu.menuID == 70){
                if   let promotionContainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePromotion, classname: Constant.PromotionContainerView) as? PromotionContainer{
                    promotionContainer.objPlannedVisit = self.planvisit
                    promotionContainer.visitType = visitType
                    return promotionContainer
                }else{
                    return UIViewController()
                }
            }else if(selectedmenu.menuID == 47){
                if   let viewterritory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.ViewTerritory) as? ViewTerritory{
                    viewterritory.visitType = visitType
                    viewterritory.planVisit = planvisit ?? PlannVisit()
                    viewterritory.unplanVisit = unplanvisit ??  UnplannedVisit()
                    
                    return viewterritory
                }else{
                    return UIViewController()
                }
                
            }else if(selectedmenu.menuID == 45){
                //view feedback
                if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetail) as? VisitSubDetail{
                    visitDetail.visitType = visitType
                    visitDetail.planVisit = planvisit ?? PlannVisit()
                    visitDetail.unplanVisit = unplanvisit ??
                        UnplannedVisit()
                    return visitDetail
                }else{
                    return UIViewController()
                }
            }
            else if(selectedmenu.menuID == 40){
                //update stock
                if  let updateStock =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitUpdateStock) as? UpdateStock{
                    updateStock.visitType = self.visitType
                    updateStock.planvisit = planvisit ?? PlannVisit()
                    updateStock.unplanvisit = unplanvisit ?? UnplannedVisit()
                    return updateStock
                }else{
                    return UIViewController()
                }
            }else if(selectedmenu.menuID == 66){
                if  let visitCountershare = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitCountershare) as? AddVisitCounterShare{
                    visitCountershare.planvisitobj = planvisit
                    if let countershare = planvisit?.visitCounterShare{
                        visitCountershare.counterShare = countershare
                        visitCountershare.isEdit = true
                    }else{
                        visitCountershare.isEdit = false
                    }
                    visitCountershare.visitType = visitType
                    return visitCountershare
                }else{
                    return UIViewController()
                }
            }
            else if(selectedmenu.menuID == 65){
                //collection
                if  let visitCountershare = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitCountershare) as? AddVisitCounterShare{
                    visitCountershare.visitType = visitType
                    visitCountershare.planvisitobj = planvisit
                    return visitCountershare
                }else{
                    return UIViewController()
                }
            }else if(selectedmenu.menuID == 73){
                if let productdrive = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePromotion, classname: Constant.ProductDriveView) as? ProductDriveListController
                {
                    productdrive.ObjVisit = self.planvisit
                    return productdrive
                }else{
                    return UIViewController()
                }
                
            }
            else if(selectedstr == "Customer Profile"){
                if let customerProfile = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitCustomerProfile) as? VisitCustomerProfile{
                    
                    return customerProfile
                }else{
                    return UIViewController()
                }
            }else if(selectedmenu.menuID == 76){
                //shelf space list
                if let visitCustomForm =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitCustomForm) as? VisitCustomForm{
                    //                    shelfspacelist.visitType = self.visitType
                    //                    shelfspacelist.ObjVisitForShelfSpace = planvisit ?? PlannVisit()
                    //                    shelfspacelist.ObjUnPlannedVisitForSpace = unplanvisit ??
                    //                        UnplannedVisit()
                    return visitCustomForm
                }else{
                    return UIViewController()
                }
            }
            else{
                //        if  let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetail) as? VisitSubDetail{
                //                    visitDetail.visitType = visitType
                //                    visitDetail.planVisit = planvisit ?? PlannVisit()
                //                    visitDetail.unplanVisit = unplanvisit ??
                //                        UnplannedVisit()
                //                    return visitDetail
                //                        }else{
                return UIViewController()
                //}
            }
            
            
            
        }
        else{
            if(selectedstr == "Details"){
                if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetail) as? VisitSubDetail{
                    visitDetail.visitType = visitType
                    visitDetail.planVisit = planvisit ?? PlannVisit()
                    visitDetail.unplanVisit = unplanvisit ??
                        UnplannedVisit()
                    return visitDetail
                }else{
                    return UIViewController()
                }
            }else{
                //  if let visitDetail =   Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetail) as? VisitSubDetail{
                //  visitDetail.visitType = visitType
                //  visitDetail.planVisit = planvisit ?? PlannVisit()
                //  visitDetail.unplanVisit = unplanvisit ?? UnplannedVisit()
                //   return visitDetail
                //  }else{
                return UIViewController()
                // }
            }
        }
    }
}

extension VisitDetail:BaseViewControllerDelegate{
    
    func menuitemTouched(item: UPStackMenuItem) {
        
        
    }
    
    func datepickerSelectionDone() {
        
        
    }
    
    
    func editiconTapped(sender:UIBarButtonItem){
        
        if(visitType == VisitType.planedvisit || visitType == VisitType.manualvisit){
            let objplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddplanVisitView) as! AddPlanVisit
            objplanvisit.isEdit = true
            objplanvisit.objVisit = planvisit
            self.navigationController?.pushViewController(objplanvisit, animated: true)
            
        }else if(visitType == VisitType.coldcallvisit){
            let objunplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddUnplanVisitView) as! AddUnPlanVisit
            objunplanvisit.isEdit = true
            objunplanvisit.objunplanvisit = unplanvisit
            self.navigationController?.pushViewController(objunplanvisit, animated: true)
            
        }
    }
    
    func mapTapped(){
        let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as! GoogleMap
        if(visitType == VisitType.coldcallvisit){
            map.isFromColdCall = true
            map.unplanvisit = unplanvisit
            map.isFromDashboard = false
            map.lattitude = NSNumber.init(value: Int(unplanvisit?.tempCustomerObj?.Lattitude ?? "0") ?? 0)//NSNumber.init(coder:Int(objunplannedVisit?.tempCustomerObj.Lattitude ?? "0") ?? 0)
            map.longitude = NSNumber.init(value: Int(unplanvisit?.tempCustomerObj?.Longitude ?? "0") ?? 0) //NSNumber.init(value:Int(objunplannedVisit?.tempCustomerObj.Longitude ?? "0") ?? 0)
        }else if(visitType == VisitType.planedvisit){
            map.planvisit = planvisit
            map.isFromColdCall = false
            map.isFromDashboard = false
            if  let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:planvisit?.addressMasterID ?? 0)){
                let latdouble = address.lattitude.toDouble() ?? 0.00//Float(add?.lattitude ?? "0.0000")address.lattitude ?? 0.00 //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                
                let longdouble = address.longitude.toDouble() ?? 0.00
                    ?? 0.00
                map.isFromVisitLeadDetail = true
                map.lattitude = NSNumber.init(value:latdouble)
                map.longitude = NSNumber.init(value:longdouble)
            }else{
                map.lattitude = NSNumber.init(value:0)
                map.longitude = NSNumber.init(value:0)
            }
        }
        self.navigationController?.pushViewController(map, animated: true)
    }
}
extension VisitDetail:PopUpDelegateNonMandatory{
    /*
     let arrmandatoryVisitStep =  arrvisitStep.filter { (visitstep) -> Bool in
     visitstep.mandatoryOrOptional ==  true && visitstep.status == false
     }
     
     **/
    func completionSelectedVisitStep(arr:[StepVisitList]){
        
        
        
        Utils.removeShadow(view: self.view)
        
        arrSelectedVisitStep =  arr
        let group = DispatchGroup()
        var isToast = false
        let activeplanVisit =  planvisit
        arrofmandatoryStep.sorted { (stepvisit1, stepvisit2) -> Bool in
            stepvisit1.menuOrder < stepvisit2.menuOrder
        }
    
       
        
        if let planvisit =  activeplanVisit {
        
            if  let selectedCustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planvisit.customerID ?? 0)) as? CustomerDetails{
                let companytypeid = NSNumber.init(value:selectedCustomer.companyTypeID)
                let segment = NSNumber.init(value:selectedCustomer.segmentID)
                var display = 0
        for stepvisit in arrofmandatoryStep{
            group.enter()
            print("type list = \(stepvisit.customerType) ,segment list = \(stepvisit.customerSegment) , company type id = \(companytypeid) , segment = \(segment) and step name = \(stepvisit.menuLocalText) , \(stepvisit.menuOrder)")
            if let visitStatusType = stepvisit.customerType as? String{
                if let visitStatusSegment = stepvisit.customerSegment as? String{
                    if(visitStatusType.lowercased() == "off" || visitStatusSegment.lowercased() == "off"){
                        group.leave()
                    }else{
                        let arrOfKYCType = visitStatusType.components(separatedBy: ",")
                        let arrOfKYCSegment = visitStatusSegment.components(separatedBy: ",")
                       
            if(arrOfKYCType.contains(companytypeid.stringValue) && arrOfKYCSegment.contains(segment.stringValue) || (visitStatusType == "999999" && visitStatusSegment == "0")){
            switch stepvisit.menuIndex {
            case 35:
                    
                    //visit report.
                    
                    if let planvisit =  activeplanVisit {
                        
                        if(planvisit.visitStatusList.count == 0){
                            isToast = true
                            if(display == 0){
                                display += 1
                            Utils.toastmsg(message:"Please add visit report",view: self.view)
                            }
                            group.leave()
                            return
                        }else{
                            group.leave()
                        }
                        
                    }else{
                        group.leave()
                    }
                
               break
            case 36:
                    if let planvisit =  activeplanVisit {
                      
                        
                        
                        if let order = Utils.getorderByVisitId(visitID: NSNumber.init(value: planvisit.iD ?? 0)){
                            print(order)
                            group.leave()
                        }else{
                            isToast = true
                            if(display == 0){
                                display += 1
                            Utils.toastmsg(message:"Please add sales order",view: self.view)
                            }
                            group.leave()
                            return
                        }
                    }else{
                        group.leave()
                    }
                            
            break
            case 38:
                    ////Add picture
                    if let planvisit =  activeplanVisit {
                        SVProgressHUD.setDefaultMaskType(.black)
                        SVProgressHUD.show()
                        var param = Common.returndefaultparameter()
                        param["VisitID"] =  activeplanVisit?.iD
                        param["VisitID"] = planvisit.iD
                        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetVisitUploadImages, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                            SVProgressHUD.dismiss()
                            if(status.lowercased() == Constant.SucessResponseFromServer){
                                if(responseType == ResponseType.arr){
                                    let arrofpicturedata = arr as? [[String:Any]] ?? [[String:Any]]()
                                    
                                    if(arrofpicturedata.count > 0){
                                        group.leave()
                                    }else{
                                        isToast = true
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please add picture",view: self.view)
                                        }
                                        group.leave()
                                        
                                        return
                                    }
                                }else if(responseType == ResponseType.arrOfAny){
                                    if let arrofanypic = arr as? [Any]{
                                        if(arrofanypic.count > 0){
                                            
                                        }else{
                                            isToast = true
                                            if(display == 0){
                                                display += 1
                                            Utils.toastmsg(message:"Please add picture",view: self.view)
                                            }
                                        }
                                        group.leave()
                                        
                                        return
                                    }else{
                                        isToast = true
                                        if(display == 0){
                                            display += 1
                                        Utils.toastmsg(message:"Please add picture",view: self.view)
                                        }
                                        group.leave()
                                        return
                                    }
                                }else if(error.code == 0){
                                    isToast = true
                                    Utils.toastmsg(message:"Error while checking picture",view: self.view)
                                 
                                  
                                    group.leave()
                                    return
                                   // }
                                    
                                }else{
                                    isToast = true
                                    Utils.toastmsg(message:"Error while checking picture",view: self.view)
                                    group.leave()
                                    return
                                    // Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                                }
                            }
                            
                            
                        }
                    }else{
                        group.leave()
                    }
                
        break
        case 39:
                    ////feed back
                    if let planVisit = planvisit as? PlannVisit{
                        self.isFeedbackAvailable(planvisit: planVisit) { (feedbackstatus) in
                            if(feedbackstatus){
                                group.leave()
                            }else{
                                isToast = true
                                if(display == 0){
                                    display += 1

                                Utils.toastmsg(message:"Please give feedback",view: self.view)
                                }
                                group.leave()
                                return
                            }
                        }
                    }else{
//                        isToast = true
//                        Utils.toastmsg(message:"Please give feedback",view: self.view)
                        group.leave()
                       // return
                    }
                    
        break
        case 40:
                    ///update stock
                    if let planvisit =  activeplanVisit {
                        var para = Common.returndefaultparameter()
                        
                        var getvisitjson = [String:Any]()
                        //                        if(activeVisitType == VisitType.coldcallvisit || activeVisitType == VisitType.coldcallvisitHistory){
                        //                            getvisitjson["VisitID"] = unplanvisit?.localID
                        //                        }else{
                        getvisitjson["VisitID"] = activeplanVisit?.iD
                        // }
                        para["getVisitStockJson"] =  Common.json(from: getvisitjson)
                        SVProgressHUD.setDefaultMaskType(.black)
                        SVProgressHUD.show()
                        self.apihelper.getdeletejoinvisit(param: para, strurl: ConstantURL.kWSUrlGetVisitStock, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                            SVProgressHUD.dismiss()
                            
                            
                            if(status.lowercased() == Constant.SucessResponseFromServer){
                                print(arr)
                                
                                if(responseType == ResponseType.arr){
                                    let arrOfStock = arr as? [[String:Any]] ?? [[String:Any]]()
                                    if(arrOfStock.count > 0){
                                        group.leave()
                                    }else{
                                        isToast = true
                                        if(display == 0){
                                            display += 1

                                        Utils.toastmsg(message:"Please update stock",view: self.view)
                                        }
                                        group.leave()
                                        return
                                    }
                                }else{
//                                    isToast = true
//                                    Utils.toastmsg(message:"Please update stock",view: self.view)
                                    group.leave()
//                                    return
                                }
                            }else if(error.code == 0){
//                                if ( message.count > 0 ) {
//                                    Utils.toastmsg(message:message,view: self.view)
//                                    //  group.leave()
//                                }else{
                                    Utils.toastmsg(message:"Error while Checking stock",view: self.view)
                                group.leave()
                                return
                                    //  group.leave()
                                
                            }else{
                               
                                Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "Error while Checking stock",view: self.view)
                                group.leave()
                                return
                            }
                    }
                        //                        if (planvisit.isStockAvailable == 1){
                        //
                        //                        }else{
                        //                            isToast = true
                        //                            Utils.toastmsg(message:"Please update stock",view: self.view)
                        //                            return
                        //                        }
                    }
        break
        case 41:
                    ////territery
                    if let planVisit =  activeplanVisit {
                      
                         self.isTerritoryAvailable(planvisit: planVisit) { (territorystatus) in
                            if(territorystatus){
                               
                                                      group.leave()
                            }else{
                                isToast = true
                                if(display == 0){
                                    display += 1
                                Utils.toastmsg(message:"Please add Tertiary",view: self.view)
                                }
                            group.leave()
                         
                            return
                            }
                            }
                    }else{
                        group.leave()
                    }
                          
                        //}
                    
        break
        case 65:
                    // collection
                    if let planvisit =  activeplanVisit {
                        if let collection  = planvisit.visitCollection as? VisitCollection{
                            group.leave()
                        }else{
                            isToast = true
                            if(display == 0){
                                display += 1
                            Utils.toastmsg(message:" Please add collection",view: self.view)
                            }
                            group.leave()
                            return
                        }
                    }else{
                        group.leave()
                    }
                    
        break
        case 66:
                    //counter share
                    if let planvisit =  activeplanVisit {
                        if let collection  = planvisit.visitCounterShare as? VisitCounterShare{
                            group.leave()
                        }else{
                            if(activesetting.requireVisitCounterShare?.intValue == 1){
                            isToast = true
                                if(display == 0){
                                    display += 1
                            Utils.toastmsg(message:"Please add countershare",view: self.view)
                                }
                            group.leave()
                            return
                            }else{
                                group.leave()
                            }
                        }
                    }else{
                        group.leave()
                    }
                    
        break
        case  72:
                    //Store check
                    SVProgressHUD.setDefaultMaskType(.black)
                    SVProgressHUD.show()
                    var param = Common.returndefaultparameter()
//            if(StoreCheckContainer.visitType == VisitType.coldcallvisit){
//                param["VisitID"] = StoreCheckContainer.unplanVisit?.localID
//                param["CustomerID"] =  StoreCheckContainer.unplanVisit?.customerID
//            }else{
//                param["VisitID"] = StoreCheckContainer.planVisit?.iD
//                param["CustomerID"] =  StoreCheckContainer.planVisit?.customerID
//            }
            if let unPlanvisit =  unplanvisit  as? UnplannedVisit{
                param["VisitID"] = unPlanvisit.localID
                param["CustomerID"] =  unPlanvisit.customerID
            }else{
                param["VisitID"] = planvisit.iD
                param["CustomerID"] =  planvisit.customerID
            }
                    self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetStoreCheckData, method: Apicallmethod.get){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                        StoreCheckContainer.storeCheckBrandActivityList.removeAll()
                        if(status.lowercased() == Constant.SucessResponseFromServer){
                            //print(arr)
                            SVProgressHUD.dismiss()
                            if(responseType ==  ResponseType.dic){
                                
                                let dicresponse = arr as? [String:Any] ?? [String:Any]()
                                StoreCheckContainer.visitBrandActivityExists =  Common.returndefaultbool(dic: dicresponse, keyvalue: "visitBrandActivityExists")
                                StoreCheckContainer.visitCompetitionExists = Common.returndefaultbool(dic: dicresponse, keyvalue: "visitCompetitionExists")
                                if((StoreCheckContainer.visitBrandActivityExists == false) || (StoreCheckContainer.visitCompetitionExists == false) ){
                                    isToast = true
                                    if(display == 0){
                                        display += 1
                                    Utils.toastmsg(message:"Please add Store check",view: self.view)
                                    }
                                    group.leave()
                                    return
                                }else{
                                    group.leave()
                                }
                            }
                        }else{
                            group.leave()
                            Utils.toastmsg(message:"Error while checking store",view:self.view)
                            SVProgressHUD.dismiss()
                        }
                    }
                    
        break
        case  74:
                    //Shelf Space
                    var arrOfShelfSpace =  [ShelfSpaceModel]()
                    SVProgressHUD.setDefaultMaskType(.black)
                    SVProgressHUD.show()
                    var param = Common.returndefaultparameter()
                    //                    if((activeVisitType == VisitType.coldcallvisit) || (activeVisitType == VisitType.coldcallvisitHistory)){
                    //                            param["VisitID"] = unplanvisit?.localID
                    //                        }else{
                    param["VisitID"] = activeplanVisit?.iD
                    //   }
                    self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetShelfSpaceList1, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                        SVProgressHUD.dismiss()
                        
                        if(status.lowercased() == Constant.SucessResponseFromServer){
                            print(responseType)
                            arrOfShelfSpace.removeAll()
                            if(responseType == ResponseType.arr){
                                let arrofshelfspce = arr as? [[String:Any]] ?? [[String:Any]]()
                                for sh in arrofshelfspce{
                                    let shelfspace = ShelfSpaceModel.init(dic: sh)
                                    arrOfShelfSpace.append(shelfspace)
                                }
                                // self.tblShelfSpace.reloadData()
                                if(arrofshelfspce.count == 0){
                                    isToast = true
                                    if(display == 0){
                                        display += 1
                                    Utils.toastmsg(message:"Please add Shelf space",view: self.view)
                                    }
                                    group.leave()
                                    return
                                }else{
                                    if let activeplanvisitid = activeplanVisit?.iD{
                                        let shelfspacebyvisitid = arrOfShelfSpace.filter { (shelfspace) -> Bool in
                                            shelfspace.VisitID == activeplanvisitid
                                        }
                                        if(shelfspacebyvisitid.count > 0){
                                            group.leave()
                                        }else{
                                            isToast = true
                                            if(display == 0){
                                                display += 1
                                            Utils.toastmsg(message:"Please add Shelf space",view: self.view)
                                            }
                                            group.leave()
                                            return
                                        }
                                    }else{
//                                        isToast = true
//                                        Utils.toastmsg(message:"Please add Shelf space",view: self.view)
                                        group.leave()
//                                        return
                                    }
                                }
                            }
                        }else{
                            group.leave()
                            SVProgressHUD.dismiss()
                        }
                    }
                    
                
               
            
            default:
                group.enter()
            Utils.toastmsg(message:"all mandatory steps are not finished yet",view:self.view)
            group.leave()
            }
                
            }
            else{
                group.leave()
                
            }
                    }
                    
                    
                }else{
                    group.leave()
                    
                }}else{
                    group.leave()
                }
            
        }
        }
        }
        group.notify(queue: .main) {
        if(isToast == false){
            self.finalcheckout()
            
        }
        }
      
    }
    
}
