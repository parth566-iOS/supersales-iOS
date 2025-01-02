//
//  LeadDetail.swift
//  SuperSales
//
//  Created by Apple on 05/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit
import CoreLocation

class LeadDetail: BaseViewController {
    
    
    @IBOutlet var btnRefresh: UIButton!
    
    @IBOutlet weak var vwCheckInDetail: UIView!
    @IBOutlet weak var lblCheckInDetail: UILabel!
    @IBOutlet weak var btnCheckIn: UIButton!
    
    @IBOutlet weak var targetview: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var lastLeadCheckinStatus = UserLatestActivityForLead.none
    
    var itemsvisitDetail:Array<String>!
    var arrOfLeadCheckinoption:[String]!
    var arrOfSelectedLeadCheckinoption:[String]! = [String]()
    var arrOfListInfluencer:[CustomerDetails]! = [CustomerDetails]()
    var arrOfSelectedInfluerncer:[CustomerDetails]! = [CustomerDetails]()
    var selectedInluencer:CustomerDetails!
    var carbonswipenavigationobj:CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var popup:CustomerSelection? = nil
    var lastcheckinStatus = UserLatestActivityForVisit.none
    var editLeaddic  = [String:Any]()
    var isHistory:Bool?
    //var isVisitPlanned:Bool!
    var visitType:VisitType!
    var redirectTo:Int!
    var selectedLeadCheckinOption:String!
    var lead:Lead!
    var currentCoordinate:CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setCheckinInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveLeadData(_:)), name: Notification.Name.init("updateLeadcheckinInfo"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updateLeadcheckinInfo"), object: nil)
    }
    
    @objc func onDidReceiveLeadData(_ notification:Notification) {
        // Do something now
        self.setCheckinInfo()
        
    }
    
    //MARK: - Method
    
    func finalLeadcheckout(){
        if(activesetting.customTagging == NSNumber.init(value: 3)){
            
            
            if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:lead?.customerID ?? 0)))){
                Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view:self.view)
                return
            }
            
        }
        if(self.activesetting.mandatoryLeadUpdateStatus == 1){
            if(lead.leadStatusList.count == 0){
                Utils.toastmsg(message:"Please update lead status to do Check-Out",view:self.view)
                return
            }
        }
        
        
        if(CLLocationCoordinate2DIsValid(currentCoordinate) ){
            
            if let lastcheckin =  lead.leadCheckInOutList[0] as? LeadCheckInOutList{
                LeadCheckinCheckout.verifyLeadCheckoutAddress = false
                LeadCheckinCheckout().checkoutLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: lead, cust: lastcheckin.checkInFrom , viewcontroller: self)
            }
        }else{
            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
            let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
            }
            Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
        }
    }
    
    
    
    // MARK: IBAction
    
    
    @IBAction func btnCheckInClicked(_ sender: UIButton) {
        currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate()
        if(sender.currentTitle == NSLocalizedString("CHECK_IN", comment: "")){
            if(Utils().CheckInPossible(view: self) ==  true){
                if(activesetting.customTagging == NSNumber.init(value: 3)){
                    
                    if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:lead?.customerID ?? 0)))){
                        Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view:self.view)
                        return
                    }
                    
                }
                
                if(CLLocationCoordinate2DIsValid(currentCoordinate)){
                    if((self.activesetting.influencerInLead == NSNumber.init(value:1)) && (lead.influencerID > 0)){
                        // let custPopup
                        self.popup =    Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                        self.popup?.modalPresentationStyle = .overCurrentContext
                        self.popup?.strTitle = "To"
                        self.popup?.nonmandatorydelegate = self
                        self.popup?.arrOfCustomerClass = arrOfLeadCheckinoption
                        self.popup?.arrOfSelectedClass = arrOfSelectedLeadCheckinoption
                        self.popup?.strLeftTitle = "OK"
                        self.popup?.strRightTitle = "Cancel"
                        self.popup?.parentViewOfPopup = self.view
                        self.popup?.selectionmode = SelectionMode.single
                        self.popup?.isSearchBarRequire = false
                        self.popup?.isFromSalesOrder =  false
                        self.popup?.viewfor = ViewFor.customerClass
                        self.popup?.isFilterRequire = false
                        Utils.addShadow(view: self.view)
                        
                        //Utils.addShadow(view: self.view.superview ?? self.view)
                        self.present(self.popup!, animated: false, completion: nil)
                        
                    }else{
                        LeadCheckinCheckout.verifyAddress = false
                        LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: lead, cust: "C", viewcontroller: self)
                    }
                }else{
                    
                    let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                    let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                    }
                    Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
                    
                }
                
                
            }else{
                
                
                /* if(self.activesetting.customTagging == 3){
                 if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:planvisit?.customerID ?? 0)))){
                 Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""))
                 return                    }
                 
                 }
                 if(self.activesetting.mandatoryPictureInVisit == 1){
                 if(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                 if(unplanvisit?.isPictureAvailable == 1){Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""))
                 return
                 }
                 }else{
                 if(planvisit?.isPictureAvailable == 1){Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""))
                 return
                 }
                 }
                 }
                 if (self.activesetting.mandatoryVisitReport == 1){
                 if (visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                 if (unplanvisit?.visitStatusList.count == 0){
                 Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""))
                 
                 return
                 }
                 }else{
                 if (planvisit?.visitStatusList.count == 0){
                 Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""))
                 return
                 }
                 }
                 }
                 
                 if ((self.activesetting.requireSOFromVisitBeforeCheckOut == 1) && (!(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory))) {
                 if let  collection =  planvisit?.visitCollection{
                 if let countershare =  planvisit?.visitCounterShare{
                 
                 }else if(self.activesetting.requireVisitCounterShare == 1){
                 Utils.toastmsg(message:NSLocalizedString("please_add_counter_share_in_this_visit_for_check_Out", comment: ""))
                 
                 return
                 }else{
                 
                 }
                 }
                 else{
                 if(self.activesetting.requireVisitCollection == 1) {
                 if let countershare =  planvisit?.visitCounterShare{
                 
                 }else {
                 Utils.toastmsg(message:NSLocalizedString("please_add_collection_in_this_visit_for_check_Out", comment: ""))
                 
                 return
                 }
                 }
                 }
                 
                 }*/
                
                
                
            }
        }else{
            self.finalLeadcheckout()
        }
    }
    
    // MARK: Method
    func setUI(){
        definesPresentationContext = true
        arrOfLeadCheckinoption = ["Customer","Influencer"]
        arrOfSelectedLeadCheckinoption = ["Customer"]
        
        if   let  firstinfluencerid = lead.influencerID as? Int64{
            if let secondinflencerid = lead.secondInfluencerID as? Int64{
                if(firstinfluencerid > 0 && secondinflencerid > 0){
                    
                    if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:lead?.influencerID ?? 0)){
                        arrOfListInfluencer.append(firstinfluencer)
                        self.arrOfSelectedInfluerncer.append(firstinfluencer)
                    }
                    if  let secondinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:lead?.secondInfluencerID ?? 0)){
                        arrOfListInfluencer.append(secondinfluencer)
                    }
                }
            }
        }
        btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""),  for: .normal)
        self.title = String.init(format:"Lead no: %d",lead.seriesPostfix )
        self.salesPlandelegateObject = self
        if(isHistory == true){
            self.vwCheckInDetail.isHidden = true
        }
        
        
        if(isHistory == true){
            self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        }else{
            self.setrightbtn(btnType: BtnRight.editMap, navigationItem: self.navigationItem)
        }
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        //        [_CustomerDetails isKeyCustomer:[NSNumber numberWithLongLong:_objLead.customerID]];
        //        isKeyCustomer = CustomerDetails().iskey
        var menu = Utils.getLeadMenu()
        //56
        if (self.activeuser?.role?.id == NSNumber.init(value:9)) {
            let exceptarr = [54,56,55,58,59]
            menu =  menu.filter{
                !exceptarr.contains($0)
            }
        }
        else if (self.activeuser?.role?.id == NSNumber.init(value:8)) {
            menu =  menu.filter{
                $0 != 54
            }
            
        }
        else if (self.activeuser?.role?.id == NSNumber.init(value:7) && self.activesetting.managerLeadsReassign == 0) {
            menu =  menu.filter{
                $0 != 54
            }
            
        }
        //        if (isKeyCustomer == false) {
        //            [menu removeObject:@55];
        //        }
        if (self.activesetting.leadCustomerProfile == false) {
            menu =  menu.filter{
                $0 != 60
            }
            //  [menu removeObject:@60];
        }
        let cmenus = CompanyMenus.getComapnyMenus(menu: menu as [NSNumber], sort: true)
        var detailscreens:[CompanyMenus] = [CompanyMenus]()
        for i in menu{
            for j in cmenus{
                if(j.menuID == i){
                    detailscreens.append(j)
                }
            }
        }
        let TitleOfDetailscreen = detailscreens.map{
            $0.menuLocalText
        }
        
        itemsvisitDetail = TitleOfDetailscreen as? Array<String>
        
        itemsvisitDetail.insert("Details", at: 0)
        itemsvisitDetail.insert("Past Interaction", at: itemsvisitDetail.count)
        //        if(lead.leadStatusList.count > 0){
        //            itemsvisitDetail.insert("Past Interaction", at: itemsvisitDetail.count)
        //        }
        carbonswipenavigationobj = CarbonTabSwipeNavigation(items:itemsvisitDetail, toolBar:toolbar , delegate:self)
        carbonswipenavigationobj.insert(intoRootViewController: self, andTargetView: targetview)
        self.style()
        //self.setCheckinInfo()
        carbonswipenavigationobj.setCurrentTabIndex(UInt(redirectTo), withAnimation: true)
    }
    
    func style(){
        
        
        let color:UIColor = UIColor.Appthemecolor
        
        let boldfont = UIFont.init(name: Common.kfontbold, size: 15)
        carbonswipenavigationobj.setIndicatorColor(UIColor.Appthemecolor)
        
        carbonswipenavigationobj.setSelectedColor(color, font: boldfont ?? UIFont.boldSystemFont(ofSize: 15))
        toolbar.barTintColor = UIColor.white
        // carbonswipenavigationobj.setTabExtraWidth(-10)
        //  carbonswipenavigationobj.carbonSegmentedControl?.setWidth((UIScreen.main.bounds.size.width)/2 , forSegmentAt: 0)
        
        //    ca
        
        
        //        for index in itemsvisitDetail! {
        //carbonswipenavigationobj.carbonSegmentedControl?.setWidth(CGFloat(200.0), forSegmentAt: (itemsvisitDetail?.firstIndex(of: index))!)
        //        }
        
        //UIFont.init(name: kFontMedium, size: 15)
        
        
        carbonswipenavigationobj.setNormalColor(UIColor.gray, font: boldfont ?? UIFont.boldSystemFont(ofSize: 15))
        carbonswipenavigationobj.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
        //        var width = 1.0
        //        if((itemsvisitDetail?.count)! > 2){
        //            width = Double((self.targetview.frame.size.width/2.0))
        //        }
        //        else{
        //            width=Double(Int(UIScreen.main.bounds.size.width) / ((itemsvisitDetail?.count)!))
        //        }
        //        for index in itemsvisitDetail!{
        //
        //          carbonswipenavigationobj.carbonSegmentedControl?.setWidth(CGFloat(width), forSegmentAt: (itemsvisitDetail?.firstIndex(of: index))!)
        //        }
    }
    
    func setCheckinInfo(){
        btnCheckIn.backgroundColor = UIColor.Appskybluecolor
        let (message,lastcheckinStatus) = Utils.latestCheckinDetailForLead(lead:lead)
        if(lastcheckinStatus == UserLatestActivityForLead.checkedIn){
            btnCheckIn.setTitle(NSLocalizedString("CHECK_OUT", comment:""), for: .normal)
            btnRefresh.setImage(UIImage.init(named: "icon_exit"), for: .normal)
        }else if(lastcheckinStatus == UserLatestActivityForLead.none){
            btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""), for: .normal)
            btnRefresh.setImage(UIImage.init(named:"icon_error"), for:.normal)
        }else{
            btnRefresh.setImage(UIImage.init(named: "icon_error"), for: .normal)
            btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""), for: .normal)
            
        }
        lblCheckInDetail.text = message
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
extension LeadDetail:BaseViewControllerDelegate{
    
    func menuitemTouched(item: UPStackMenuItem) {
        
        
    }
    
    func datepickerSelectionDone() {
        
        
    }
    
    
    func editiconTapped(sender:UIBarButtonItem){
        
        
        if let addleadobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.AddLead) as? AddLead{
            AddLead.isEditLead =  true
            
            AddLead.objLead = lead
            if(AddLead.isEditLead == true){
                LeadAddProduct.arrOfProduct = [SelectedProduct]()
                LeadAddProduct.arrOfProductDic = [[String:Any]]()
                if(LeadAddProduct.arrOfEditProduct.count == 0){
                    for product in AddLead.objLead.productList{
                        if let addedproduct = product as? ProductsList{
                            
                            
                            var dic = [String:Any]()
                            var subcatid = 0
                            var budget = 0
                            if  let subcat = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value:addedproduct.categoryID)){
                                subcatid = Int(subcat.iD)
                            }
                            if let pbudget = addedproduct.budget{
                                budget = Int(pbudget)
                            }
                            var strProductName = ""
                            if let productname = addedproduct.productName as? String{
                                if(productname.count > 0){
                                    let productName = productname
                                    strProductName.append(productName)
                                }else{
                                    
                                    if let subcatid = addedproduct.subcategoryID as? Int64 {
                                        if(subcatid > 0){
                                            let prosubcat = ProductSubCat.getSubCatName(subcatid: NSNumber.init(value:subcatid))
                                            if(prosubcat.count > 0){
                                                strProductName.append(("SubCat: \(prosubcat) \n"))
                                            }
                                        }
                                    }else{
                                        if let catid = addedproduct.categoryID as? Int64 {
                                            let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:catid))
                                            if(procatname.count > 0){
                                                strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                                            }
                                        }
                                    }
                                }
                            }else{
                                
                                if let catid = addedproduct.categoryID as? Int64 {
                                    let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:addedproduct.categoryID))
                                    if(procatname.count > 0){
                                        strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                                    }
                                }
                                
                            }
                            //
                            dic = ["productName":strProductName,"ProductID":addedproduct.productID,"CategoryID":addedproduct.categoryID,"SubCategoryID":subcatid,"Quantity":String.init(format:"\(addedproduct.quantity)") ,"Budget": String.init(format:"\(budget)")] as [String : Any]
                            let product = SelectedProduct().initwithdic(dict: dic)
                            LeadAddProduct.arrOfProduct.append(product)
                            LeadAddProduct.arrOfEditProduct.append(product)
                        }
                    }
                }else{
                    for product in AddLead.objLead.productList{
                        if let addedproduct = product as? ProductsList{
                            
                            
                            var dic = [String:Any]()
                            var subcatid = 0
                            var budget = 0
                            if  let subcat = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value:addedproduct.categoryID)){
                                subcatid = Int(subcat.iD)
                            }
                            if let pbudget = addedproduct.budget{
                                budget = Int(pbudget)
                            }
                            var strProductName = ""
                            if let productname = addedproduct.productName as? String{
                                if(productname.count > 0){
                                    let productName = productname
                                    strProductName.append(productName)
                                }else{
                                    
                                    if let subcatid = addedproduct.subcategoryID as? Int64 {
                                        if(subcatid > 0){
                                            let prosubcat = ProductSubCat.getSubCatName(subcatid: NSNumber.init(value:subcatid))
                                            if(prosubcat.count > 0){
                                                strProductName.append(("SubCat: \(prosubcat) \n"))
                                            }
                                        }
                                    }else{
                                        if let catid = addedproduct.categoryID as? Int64 {
                                            let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:catid))
                                            if(procatname.count > 0){
                                                strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                                            }
                                        }
                                    }
                                }
                            }else{
                                
                                if let catid = addedproduct.categoryID as? Int64 {
                                    let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:addedproduct.categoryID))
                                    if(procatname.count > 0){
                                        strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                                    }
                                }
                                
                            }
                            //
                            dic = ["productName":strProductName,"ProductID":addedproduct.productID,"CategoryID":addedproduct.categoryID,"SubCategoryID":subcatid,"Quantity":String.init(format:"\(addedproduct.quantity)") ,"Budget": String.init(format:"\(budget)")] as [String : Any]
                            let product = SelectedProduct().initwithdic(dict: dic)
                            LeadAddProduct.arrOfProduct.append(product)
                            
                        }
                    }
                }
                for prod in LeadAddProduct.arrOfProduct{
                    var dic = [String:Any]()
                    if(self.activesetting.leadProductPermission == 2){
                        dic["Budget"] = String.init(format:"%@",prod.price ?? 0)
                    }else{
                        dic["Budget"] = String.init(format:"%@",prod.budget ?? 0)
                    }
                    //dic["Budget"] = prod.budget
                    dic["CategoryID"] = prod.productCatId
                    dic["ProductID"] = prod.productID
                    dic["Quantity"] = prod.quantity
                    dic["SubCategoryID"] = prod.productSubCatId
                    //  print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
                    LeadAddProduct.arrOfProductDic.append(dic)
                }
                //  print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
                LeadSourceInfluencer.leadSourceIndex = AddLead.objLead.leadSourceID
                
                AddLeadFourthStep.leadNegotiationDone = NSNumber.init(value: AddLead.objLead.isNegotiationDone)
                AddLeadFourthStep.leadProposalGiven = NSNumber.init(value: AddLead.objLead.askedForProposal)
                AddLeadFourthStep.leadDemoDone = NSNumber.init(value: AddLead.objLead.isTrialDone)
                AddLeadFourthStep.leadQualified = NSNumber.init(value: AddLead.objLead.isLeadQualified)
                AddLeadFourthStep.isLead6Stage = NSNumber.init(value: AddLead.objLead.leadstage6)
                AddLeadFourthStep.isLead5Stage = NSNumber.init(value: AddLead.objLead.leadstage5)
                AddLeadFourthStep.nextActionDate = Utils.getDateBigFormatToCurrent(date: AddLead.objLead.nextActionTime, format:"yyyy/MM/dd HH:mm:ss")
                AddLeadFourthStep.originalAssignee =
                    NSNumber.init(value:AddLead.objLead.originalAssignee)
                AddLeadFourthStep.orderExpectedDate = Utils.getDateFromStringWithFormat(gmtDateString: AddLead.objLead.orderExpectedDate)// Utils.getDatestringWithGMT(gmtDateString: AddLead.objLead.orderExpectedDate, format: "yyyy/MM/dd HH:mm:ss")//Utils.getDateBigFormatToCurrent(date: AddLead.objLead.orderExpectedDate, format:"yyyy/MM/dd HH:mm:ss")//AddLead.objLead.orderExpectedDate
                AddLeadFourthStep.nextActionDate = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: AddLead.objLead.nextActionTime, format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/02 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format:"yyyy/MM/dd HH:mm:ss")
                AddLeadFourthStep.positivity = NSNumber.init(value: AddLead.objLead.customerOrientationID)
                // AddLeadFourthStep.customerOrientationID =  NSNumber.init(value:AddLead.objLead.customerOrientationID)
                AddLeadFourthStep.response = AddLead.objLead.response
                AddLeadFourthStep.remarks =  AddLead.objLead.remarks
                if(AddLead.objLead.reminder > 0){
                    AddLeadFourthStep.isReminderSelected = true
                }else{
                    AddLeadFourthStep.isReminderSelected = false
                }
                //                if isEditData = AddLead.LeadDic["addleadjson"] as? [String:Any]{
                //                self.editLeaddic = isEditData
                //               }
                self.editLeaddic["IsNegotiationDone"] = AddLeadFourthStep.leadNegotiationDone
                self.editLeaddic["AskedForProposal"] = AddLeadFourthStep.leadProposalGiven
                self.editLeaddic["IsTrialDone"] = AddLeadFourthStep.leadDemoDone
                self.editLeaddic["ProposalSubmitted"] = AddLeadFourthStep.leadProposalGiven
                self.editLeaddic["IsLeadQualified"] = AddLeadFourthStep.leadQualified
                self.editLeaddic["LeadSourceID"] = LeadSourceInfluencer.leadSourceIndex
                self.editLeaddic["LeadStage5"] = AddLeadFourthStep.isLead5Stage
                self.editLeaddic["LeadStage6"] = AddLeadFourthStep.isLead6Stage
                // self.editLeaddic["Remarks"] =
                
                
                AddLead.LeadDic["addleadjson"] = self.editLeaddic
                
            }
            self.navigationController?.pushViewController(addleadobj, animated: true)
        }
        
        //        if(visitType == VisitType.planedvisit || visitType == VisitType.manualvisit){
        //            if  let objplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddplanVisitView) as? AddPlanVisit{
        //            objplanvisit.isEdit = true
        //          //  objplanvisit.objVisit = planvisit
        //            self.navigationController?.pushViewController(objplanvisit, animated: true)
        //            }
        //
        //        }else if(visitType == VisitType.coldcallvisit){
        //            if let objunplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddUnplanVisitView) as? AddUnPlanVisit{
        //            objunplanvisit.isEdit = true
        //           // objunplanvisit.objunplanvisit = unplanvisit
        //            self.navigationController?.pushViewController(objunplanvisit, animated: true)
        //            }
        //
        //        }
    }
    
    func mapTapped(){
        if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
            
            map.isFromDashboard = false
            if  let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:lead.addressMasterID ?? 0)){
                let latdouble = address.lattitude.toDouble() ?? 0.00//Float(add?.lattitude ?? "0.0000")address.lattitude ?? 0.00 //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                
                let longdouble = address.longitude.toDouble() ?? 0.00
                    ?? 0.00
                map.lattitude = NSNumber.init(value:latdouble)
                map.longitude = NSNumber.init(value:longdouble)
                // map.longitude = NSNumber.init(value: Int(unplanvisit?.tempCustomerObj?.Longitude ?? "0") ?? 0)
                //            if let customer =  CustomerDetails().
                //            map.longitude = //NSNumber.init(value: lead.) //NSNumber.init(value:Int(objunplannedVisit?.tempCustomerObj.Longitude ?? "0") ?? 0)
                
            }else{
                
                map.lattitude = NSNumber.init(value:0)
                map.longitude = NSNumber.init(value:0)
            }
            map.isFromColdCall = false
            map.objLead = lead
            map.isFromVisitLeadDetail = true
            self.navigationController?.pushViewController(map, animated: true)
        }
    }
}
extension LeadDetail:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        var selectedstr = itemsvisitDetail![Int(arc4random_uniform(UInt32(index)))]
        selectedstr = itemsvisitDetail[Int(index)]
        if(selectedstr == "View Promotion"){
            if    let promotionContainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePromotion, classname: Constant.PromotionContainerView) as? PromotionContainer{
                // promotionContainer.objPlannedVisit = self.planvisit
                promotionContainer.visitType = visitType
                return promotionContainer
            }else{
                return UIViewController()
            }
        }else if(selectedstr == "Product Drive"){
            if  let productdrive = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePromotion, classname: Constant.ProductDriveView) as? ProductDriveListController{
                
                // productdrive.ObjVisit = self.planvisit
                return productdrive
            }else{
                return UIViewController()
            }
        }else if(selectedstr == "Visit Report"){
            
            
            if   let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
                visitReport.visitType  = visitType
                if(lead.leadStatusList.count > 0){
                    visitReport.isupdateReport =  true
                    
                }else{
                    visitReport.isupdateReport = false
                }
                
                //visitReport.planVisit = planvisit ?? PlannVisit()
                //visitReport.unplanVisit = unplanvisit ?? UnplannedVisit()
                
                return visitReport
            }else{
                return UIViewController()
            }
        }
        else if(selectedstr == "Add Picture"){
            if let addPicture = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddPicture) as? AddPicture{
                addPicture.visitType = visitType
                //            addPicture.planVisit = planvisit ?? PlannVisit()
                //            addPicture.unplanVisit = unplanvisit ??  UnplannedVisit()
                return addPicture
            }else{
                return UIViewController()
            }
        }
        else if(selectedstr == "Details"){
            if  let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSubDetail) as? LeadSubDetail{
                
                leadDetail.objLead = lead
                return leadDetail
            }else{
                return UIViewController()
            }
        }else if(selectedstr == "Past Interaction"){
            if  let leadStatus = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadPastInteraction) as? PastInteractionOfLeadUpdateStatus{
                leadStatus.objLead = lead
                return leadStatus
            }else{
                return UIViewController()
            }
        }else{
            if(self.activesetting.customTagging == NSNumber.init(value:1)){
                if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:lead?.customerID ?? 0)))){
                    Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view:self.view)
                    return UIViewController()
                }else{
                    if  let leadupdatestatus = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadStatusUpdate) as? UpdateLeadStatus{
                        leadupdatestatus.objLead = lead
                        leadupdatestatus.carbonswipenavigationobj = self.carbonswipenavigationobj
                        return leadupdatestatus
                    }else{
                        return UIViewController()
                        
                    }
                }
            }else{
                if  let leadupdatestatus = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadStatusUpdate) as? UpdateLeadStatus{
                    leadupdatestatus.objLead = lead
                    leadupdatestatus.carbonswipenavigationobj = self.carbonswipenavigationobj
                    return leadupdatestatus
                }else{
                    return UIViewController()
                    
                }
            }
            //            else{
            //                return UIViewController()
            //            }
        }
    }
    
    
    
    
}
extension LeadDetail:PopUpDelegateNonMandatory{
    
    func completionSelectedClass(arr: [String],recordno:Int,strTitle:String) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            
            self.arrOfSelectedLeadCheckinoption =  arr
            selectedLeadCheckinOption = arr.first
            
            if(selectedLeadCheckinOption == "Influencer" && (lead.influencerID > 0 && lead.secondInfluencerID > 0 )){
                //give options for select influencer
                self.popup =    Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = "Select Influencer"
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfList = self.arrOfListInfluencer
                self.popup?.arrOfSelectedSingleCustomer = self.arrOfSelectedInfluerncer
                self.popup?.strLeftTitle = "OK"
                self.popup?.strRightTitle = "Cancel"
                self.popup?.selectionmode = SelectionMode.single
                self.popup?.isSearchBarRequire = false
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.firstInfluencer
                self.popup?.parentViewOfPopup = self.view
                self.popup?.isFilterRequire = false
                self.present(self.popup!, animated: false, completion: nil)
            }else if(selectedLeadCheckinOption == "Influencer" && (lead.influencerID > 0 )){
                Utils.removeShadow(view: self.view)
                LeadCheckinCheckout.verifyAddress = false
                LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: lead, cust: "I", viewcontroller: self)
            }else{
                Utils.removeShadow(view: self.view)
                LeadCheckinCheckout.verifyAddress = false
                LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: lead, cust: "C", viewcontroller: self)
            }
            
            
            // classID =
        }
    }
    
    func completionfirstInfluencer(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print("selected influencer \(arr)")
        arrOfSelectedInfluerncer = arr
        selectedInluencer = arrOfSelectedInfluerncer.first
        Utils.removeShadow(view: self.view)
        if let selectedinfluencer = selectedInluencer as? CustomerDetails{
            if(selectedinfluencer.iD == lead.influencerID){
                LeadCheckinCheckout.verifyAddress = false
                LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: lead, cust: "I", viewcontroller: self)
            }else{
                LeadCheckinCheckout.verifyAddress = false
                LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: lead, cust: "I", viewcontroller: self)
            }
        }else{
            Utils.toastmsg(message:"Influencer is not mapped so you can't checked in",view:self.view)
        }
    }
    
    func completionsecondInfluencer(arr: [CustomerDetails]) {
        
        Utils.removeShadow(view: self.view)
        print("selected influencer \(arr)")
        arrOfSelectedInfluerncer = arr
        selectedInluencer = arrOfSelectedInfluerncer.first
        LeadCheckinCheckout.verifyAddress = false
        LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: lead, cust: "S", viewcontroller: self)
    }
    
}
