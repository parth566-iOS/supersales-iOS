//
//  SalesPlan.swift
//  SuperSales
//
//  Created by Apple on 28/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import CarbonKit
import CoreLocation
import FastEasyMapping
import LMGeocoder

//import KeyedDecodingContainer
protocol SalesPlanHomedelegate {
    func dateselectionsalesplandone(date:Date)
    // func showCameraPicker()
}

class SalesPlanHome: BaseViewController {
    // swiftlint:disable line_length
    //   typealias compeletionblock = (visitType:VisitType)
    var activeVisitType = VisitType.planedvisit
    var activeplanvisit:PlannVisit! = PlannVisit()
    var activeunplanvisit:UnplannedVisit! = UnplannedVisit()
    var salesdelegate:SalesPlanHomedelegate?
    var cell:SalesPlanCell!
    @IBOutlet weak var btnSelectedDate: UIButton!
    @IBInspectable var defaultIndex: Int = 0
    @IBOutlet var btnChangeLocation: UIButton!
    @IBOutlet weak var tblSalesPlan: UITableView!
    var isOnHome:Bool!
    var toolbarMenus = [MenuTabs]()
    var toolbarItemOfSalesPlan = [String]()
    var selectedindex = 0
    @IBOutlet var toolbarSalesplan: UIToolbar!
    var currentCoordinate:CLLocationCoordinate2D! = CLLocationCoordinate2D()
    var carbonTabSwipeNavigationSalesPlan:CarbonTabSwipeNavigation?
    
    var arrexpandecell = [IndexPath]()
    let activeAccount = Utils().getActiveAccount()
    static var selectedDate:String!
    static var selectedUserID:NSNumber!
    var aVisitsFlwups:[PlannVisit]! = [PlannVisit]()
    var aVisitsFlwupscoldcall:[UnplannedVisit]! = [UnplannedVisit]()
    var aVisitsFlwupsBeatPlan:[BeatPlan]! = [BeatPlan]()
    var aVisitsFlwupsActivity:[Activitymodel]! = [Activitymodel]()
    var aBeatplanvisitList:[Any]! =  [Any]()
    var arrOldSalesplanmodalAll:[SalesPlanModel] = [SalesPlanModel]()
    var arrSalesplanmodelAll:[SalesPlanModel] = [SalesPlanModel]()
    var arrSalesplanmodelForDisplay:[SalesPlanModel] = [SalesPlanModel]()
    var arrLowerLevelUser = [CompanyUsers]()
    var expandedIndex:IndexPath! = IndexPath.init(row: 0, section: 0)
    
    @IBOutlet weak var btnCheckIn: UIButton!
    @IBOutlet weak var lblCheckInDetail: UILabel!
    @IBOutlet weak var imgCheckInInfo: UIImageView!
    
    @IBOutlet weak var vwCheckInInfo: UIView!
    
    @IBOutlet weak var vwForTeam: UIView!
    
    @IBOutlet weak var vwDateSelection: UIView!
    @IBOutlet weak var vwTargetView: UIView!
    
    @IBOutlet weak var vwDailySalesPlan: UIView!
    
    @IBOutlet weak var btnDailySalesplan: UIButton!
    //Bottom menu
    let baseviewcontrollerobj = BaseViewController()
    //   static var blurEffectView:UIView!
    
    
    var sideMenus:[CompanyMenus]!
    var companyMenus:[CompanyMenus]!
    var temp:[UPStackMenuItem]!
    var arrOfBottomTabBar:[MenuTabs]!
    var arrTabbarItem:[UITabBarItem]!
    //   @IBOutlet weak var tabBar: UITabBar!
    
    
    var datepicker:UIDatePicker!
    var recordtillbeatplanInt:Int =  0
    var currentplanedvisitno = 0
    var currentunplanedvisitno = 0
    var currentactivityplanvisitno = 0
    var currentbeatplanvisitno = 0
    var reloadTappedStatus =  false
    //Select user ::
    
    var arrOfUserExceptExecutive:[CompanyUsers]!
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var popup:CustomerSelection?
    var selectedUser:CompanyUsers!
    @IBOutlet var vwUserSelection: UIView!
    @IBOutlet var lblSelectedUser: UILabel!
    
    var arrOfExecutive:[CompanyUsers]? =  [CompanyUsers]()
    
    //screen selection
    static var screenselection:Dashboardscreen!
    // graph
    
    //    @IBOutlet var btnLevelBack: UIButton!
    //
    //    @IBOutlet var vwGraphIndicator: UIView!
    //    @IBOutlet var lbl1Indicator: UILabel!
    //
    //    @IBOutlet var lbl1Title: UILabel!
    //
    //    @IBOutlet var lbl2Indicator: UILabel!
    //
    //    @IBOutlet var lbl2Title: UILabel!
    //
    //    @IBOutlet var lbl3Indicator: UILabel!
    //    @IBOutlet var lbl3Title: UILabel!
    //
    //    @IBOutlet var stkGraph: UIStackView!
    var isHome:Bool!
    var arrVisits:[[String:Any]]?
    var arrLeads:[[String:Any]]?
    var arrOrders:[[String:Any]]?
    var createdBy:NSNumber?
    var listReport:[VisitDashboardReport]?
    var levelReport:[VisitDashboardReport]?
    var listLeadReport:[LeadDashboardReport]?
    var levelLeadReport:[LeadDashboardReport]?
    var listOrderReport:[OrderDashboardReport]?
    var levelOrderReport:[OrderDashboardReport]?
    // var aryMandatoryMenuIDs:[Int32]! =  [Int32]()
    var arrSelectedVisitStep:[StepVisitList]! = [StepVisitList]()
    var arrofmandatoryStep:[StepVisitList]! = [StepVisitList]()
    var arrvisitStep:[StepVisitList]!
    
    var hidesalesorder = false
    //For Lead checkin
    var selectedlead = Lead()
    var arrOfListInfluencer:[CustomerDetails]! = [CustomerDetails]()
    var arrOfSelectedInfluerncer:[CustomerDetails]! = [CustomerDetails]()
    var arrOfLeadCheckinoption:[String]! = [String]()
    var arrOfSelectedLeadCheckinoption:[String]! = [String]()
    var selectedLeadCheckinOption:String! = String()
    var selectedInluencer:CustomerDetails!
    var selectedplanvisit:PlannVisit!
    
    @IBOutlet var lblPlanned: UILabel!
    
    @IBOutlet var lblRupees: UILabel!
    
    @IBOutlet var lblOrders: UILabel!
    
    
    
    // MARK: - View Cycle
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SVProgressHUD.show()
        print("view did load of dashboard")
        // hidesalesorder = true
        Location.sharedInsatnce.startLocationManager()
        if let  currentCoordinate1 = Location.sharedInsatnce.getCurrentCoordinate(){
            currentCoordinate = currentCoordinate1
        }else if((CLLocationCoordinate2DIsValid(Location.currentLocationcoordinate ?? CLLocationCoordinate2D())) && (Location.currentLocationcoordinate?.latitude != 0.0 && Location.currentLocationcoordinate?.longitude != 0.0)){
            if let sharedcoordinate = Location.currentLocationcoordinate{
                currentCoordinate = sharedcoordinate
            }
        }else{
            currentCoordinate = CLLocationCoordinate2D()
            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
            let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
            }
            Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
        }
        self.parentviewController = self
        reloadTappedStatus = false
        
        //    toolbarMenus = MenuTabs.getTabMenus(menu:[NSNumber.init(value:0),NSNumber.init(value:1),NSNumber.init(value:2)],sort:true)
        // toolbarMenus =  MenuTabs.getTabMenus(menu:[NSNumber.init(value:3),NSNumber.init(value:4),NSNumber.init(value:5),NSNumber.init(value:6),NSNumber.init(value:22)],sort:true)
        toolbarMenus =  MenuTabs.getTabMenus(menu:[3,4,5,6,22],sort:true)
        
        
        
        if let  selectedUserID = activeAccount?.userID{
            SalesPlanHome.self.selectedUserID = selectedUserID
        }else{
            SalesPlanHome.selectedUserID = NSNumber.init(value: 0)
        }
        self.setUI()
        self.setData()
        self.apihelper.loadAttendanceHistory(memberid: SalesPlanHome.selectedUserID , month: "01", year: "2020") { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                print(arr)
                let arrHistory = arr as? [[String:Any]] ?? [[String:Any]]()
                if(arrHistory.count > 0){
                    
                }else{
                    
                }
            }else{
                print(message)
            }
        }
        
        
        if(BaseViewController.staticlowerUser?.count ?? 0 > 0 ){
            arrLowerLevelUser = BaseViewController.staticlowerUser!
            //self.getDailyReport()
        }else{
            //  DispatchQueue.global(qos: .background).async {
            if(BaseViewController.staticlowerUser.count == 0){
                DispatchQueue.global(qos: .background).async {
                    self.fetchuser{
                        (arrOfuser,error) in
                        
                    }
                }
            }
            //  }
        }
        
        
        //  print(self.getLatestCheckinDetail())
        
        //        let attendan =  self.getLatestCheckinDetail()
        //        print(attendan)
        //        let btnClose:UIButton = UIButton()
        //        btnClose.setImage(UIImage.init(named: "icon_close_gray"), for: .normal)
        //        btnClose.frame = CGRect.init(x:0,y:0,width:50,height:50)
        //        btnClose.center = self.view.center
        //        self.view.addSubview(btnClose)
        //        btnClose.addTarget(self, action: #selector(btnCloseTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
        //  btnClose.isUserInteractionEnabled = true
        
        //        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped))
        //        gesture.numberOfTapsRequired = 1
        //        self.view.addGestureRecognizer(gesture)
    }
    
    
    //    @objc func btnCloseTapped(){
    //
    //    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("view did appear of dashboard")
        
        self.setData()
        
        
        if let  currentCoordinate1 = Location.sharedInsatnce.getCurrentCoordinate(){
            currentCoordinate = currentCoordinate1
        }else if((CLLocationCoordinate2DIsValid(Location.currentLocationcoordinate ?? CLLocationCoordinate2D())) && (Location.currentLocationcoordinate?.latitude != 0.0 && Location.currentLocationcoordinate?.longitude != 0.0)){
            if let sharedcoordinate = Location.currentLocationcoordinate{
                currentCoordinate = sharedcoordinate
            }
        }else{
            currentCoordinate = CLLocationCoordinate2D()
            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
            let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
            }
            Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
        }
        if(Sync.isFromDashboard == true){
            // Utils.toastmsg(message:"Sync Compeleted")
            Sync.isFromDashboard = false
            Utils.toastmsg(message:"Sync Compeleted",view:self.view)
            
        }
        
        
        sideMenus = [CompanyMenus]()
        if let isonhome = self.isOnHome{
            sideMenus = self.createUPStackMenuItems(isFromHome: isonhome, view: self)
        }else{
            sideMenus = self.createUPStackMenuItems(isFromHome: true, view: self)
        }
        
        
        temp = [UPStackMenuItem]()
        
        for tempitem in sideMenus{
            
            let upstackmenu = UPStackMenuItem.init(image: CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: String.init(format:" \(tempitem.menuLocalText ?? "") "), font: UIFont.boldSystemFont(ofSize: 16))
            
            upstackmenu?.isUserInteractionEnabled = true
            temp.append(upstackmenu ?? UPStackMenuItem())
        }
        //        let arrtemp = temp.sort{
        //            $0.menuID < $1.menuID
        //        }
        //        temp = temp.sorted(by: { (item0, item1) -> Bool in
        //            return $0.menu < item1
        //        })
        if(SalesPlanHome.screenselection == Dashboardscreen.dashboardvisit || SalesPlanHome.screenselection == Dashboardscreen.dashboardlead || SalesPlanHome.screenselection == Dashboardscreen.dashboardorder){
            
        }else{
            
            
            //self.getVisitFollowupList()
            tblSalesPlan.tableFooterView?.isHidden = true
        }
        self.setCheckinInfo()
        if(arrexpandecell.count > 0){
            arrexpandecell.removeAll()
        }
        self.arrvisitStep = StepVisitList.getActiveVisitStep()
        
        if(self.activesetting.visitStepsRequired == NSNumber.init(value:1)){
            if(activesetting.storeCheckOwnBrand?.intValue == 0 && activesetting.storeCheckCompetition?.intValue == 0){
                
                arrvisitStep = arrvisitStep.filter{
                    $0.menuIndex != 72
                }
                
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
            if(activesetting.mandatoryVisitReport?.intValue == 0){
                arrvisitStep = arrvisitStep.filter{
                    $0.menuIndex != 35
                    
                }
            }
            arrvisitStep.sort { (s1, s2) -> Bool in
                s1.menuOrder < s2.menuOrder
            }
            //            if let selectedcustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: activeplanvisit.customerID ?? 0)) as?  CustomerDetails{
            //
            //                arrvisitStep =   Utils().filterStepAccordingToCustTypeCustSegment(arrOfVisitStep: arrvisitStep, customer: selectedcustomer)
            //            }
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //   self.salesPlandelegateObject = self
        SVProgressHUD.show()
        NotificationCenter.default.addObserver(forName: Notification.Name(Constant.kCurrentDateChange), object: nil, queue: OperationQueue.main) { (notify) in
            
            self.setData()
            
        }
        self.navigationController!.isNavigationBarHidden = false
        if(self.activeuser?.role?.id == NSNumber.init(value: 8)){
            SalesPlanHome.screenselection = Dashboardscreen.salesplan
            self.tabBarController?.navigationItem.title = NSLocalizedString("Sales-Plan-small",  comment: "")
        }else{
            self.tabBarController?.navigationItem.title = "Dashboard"
        }
        
        if(isHome != false){
            
            toolbarSalesplan.isHidden = false
            
            self.vwUserSelection.isHidden = true
            if(SalesPlanHome.screenselection ==  Dashboardscreen.dashboardorder || SalesPlanHome.screenselection == Dashboardscreen.salesplan){
                
                if((SalesPlanHome.screenselection == Dashboardscreen.salesplan) && (isHome == true)){
                    self.vwCheckInInfo.isHidden = true
                    toolbarSalesplan.isHidden = true
                    self.vwForTeam.isHidden = true
                    self.vwDailySalesPlan.isHidden = true
                    self.getDailyReportData()
                }
            }else{
                
            }
            if(self.activeuser?.role?.id == NSNumber.init(value: 8)){
                
                toolbarSalesplan.isHidden = true
                //screenselection = Dashboardscreen.salesplan
                
                self.tabBarController?.navigationItem.title = NSLocalizedString("Sales-Plan-small",  comment: "")
            }else{
                toolbarSalesplan.isHidden = false
                self.tabBarController?.navigationItem.title = "Dashboard"
                
            }
            if let tabbarcontroller = self.tabBarController{
                if(SalesPlanHome.screenselection ==  Dashboardscreen.salesplan && self.activeuser?.role?.id?.intValue ?? 0 < 8){
                    
                    self.setrightbtn(btnType: BtnRight.home, navigationItem: tabbarcontroller.navigationItem)
                    
                }else{
                    self.reloadTappedStatus = false
                    self.setrightbtn(btnType: BtnRight.others,navigationItem: tabbarcontroller.navigationItem)
                }
            }else{
                self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
            }
            if(self.activeuser?.role?.id == NSNumber.init(value: 8)){
                self.setrightbtn(btnType: BtnRight.others, navigationItem: self.navigationItem)
            }
        }else{
            self.title = "Sales Plan"
            
            self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
            
            
            toolbarSalesplan.isHidden = true
            self.vwForTeam.isHidden =  true
            self.vwDailySalesPlan.isHidden = true
            self.vwCheckInInfo.isHidden = true
            self.vwUserSelection.isHidden = false
            selectedindex = 3
            self.getDailyReportData()
            
            self.setleftbtn(btnType: BtnLeft.menu, navigationItem: self.navigationItem)
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name.init("updatecheckinInfo"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showCameraPicker(_:)), name: Notification.Name.init("cameraAction"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAttendanceInfo(_:)), name: Notification.Name.init("updateplancheckinInfo"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name.init("updateLeadcheckinInfo"), object: nil)
        
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name("updateActivityCheckinInfo"), object: nil, queue: OperationQueue.main) { [self] (notify) in
            
            self.getDailyReportData()
            
            
            self.tblSalesPlan.reloadData()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constant.kCurrentDateChange), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updatecheckinInfo"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("cameraAction"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updateLeadcheckinInfo"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updateplancheckinInfo"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updateActivityCheckinInfo"), object: nil)
        
        
    }
    
    @objc func updateAttendanceInfo(_ notification:Notification) {
        self.setCheckinInfo()
    }
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        // SalesPlanCell.CheckinCompletionBlock(notification.userInfo?["visitId"])
        if(arrexpandecell.count > 0){
            arrexpandecell.removeAll()
        }
        self.getDailyReportData()
        //        if let visitid = notification.userInfo?["visitId"] as? Int{
        //
        //            if let visit = PlannVisit.getVisit(visitID: NSNumber.init(value:visitid)) as? PlannVisit{
        //                if  let lastvisitcheckin = visit.checkInOutData.lastObject as? VisitCheckInOutList{
        //                    print(lastvisitcheckin)
        //
        //                }
        //            }
        //        }else{
        //            self.getDailyReportData()
        //        }
        
        tblSalesPlan.reloadData()
    }
    // MARK: - Method
    
    
    func setUI(){
        //        for cust in CustomerDetails.getAllCustomers(){
        //            if let customer = cust as? CustomerDetails {
        //            for add in customer.addressList{
        //                if  let address =  add as? AddressList{
        //
        //                    print("Customer address = \(cust.addressList) on dashboard , address  = \(address) ,  lattitude = \(address.lattitude) , Longitude = \(address.longitude)")
        //            }
        //                }
        //            }
        //        }
        if(arrexpandecell.count > 0){
            arrexpandecell.removeAll()
        }
        SVProgressHUD.setDefaultMaskType(.black)
        // For Lead Checkin
        arrOfLeadCheckinoption = ["Customer","Influencer"]
        arrOfSelectedLeadCheckinoption = ["Customer"]
        datepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 234, width: view.frame.size.width, height: 200))
        datepicker.setCommonFeature()
        self.setData()
        let attrs = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.Appskybluecolor,
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        let buttonTitleStr = NSMutableAttributedString(string:"Change Location", attributes:attrs)
        btnChangeLocation.setAttributedTitle(buttonTitleStr, for: UIControl.State.normal)
        self.salesPlandelegateObject = self
        vwForTeam.addBorders(edges: [.top,.bottom], color: UIColor.black, cornerradius: 0)
        vwCheckInInfo.addBorders(edges: [.top,.bottom], color: UIColor.black, cornerradius: 0)
        vwDateSelection.addBorders(edges: [.top,.bottom], color: UIColor.black, cornerradius: 0)
        if let  selectedUser = CompanyUsers().getUser(userId: self.activeuser?.userID ?? 0){
            lblSelectedUser.text = String.init(format: "%@ %@", selectedUser.firstName,selectedUser.lastName)
        }else{
            lblSelectedUser.text =  ""
        }
        //self.tabBarHome.isHidden = true
        if((self.activeuser?.role?.id == NSNumber.init(value: 7)) || (self.activeuser?.role?.id == NSNumber.init(value: 5)) || (self.activeuser?.role?.id  == NSNumber.init(value: 6))){
            //
            // self.toolbar.isHidden = false
            
            
            if(isHome != false){
                
                SalesPlanHome.screenselection = Dashboardscreen.dashboardvisit
                // self.vwCheckInInfo.isHidden = true
            }
            self.vwUserSelection.isHidden = false
            if((self.activeuser?.role?.id == NSNumber.init(value: 5)) || (self.activeuser?.role?.id == NSNumber.init(value: 6))){
                // if(self.isHome == false){
                self.vwCheckInInfo.isHidden = true
                // }
            }
            self.tabBarItem.title = "Dashboard"
        }else if(self.activeuser?.role?.id == NSNumber.init(value: 9)){
            self.istabBarpresent = true
            self.vwForTeam.isHidden = true
            self.vwDailySalesPlan.isHidden = true
            SalesPlanHome.screenselection = Dashboardscreen.salesreport
            
            self.vwCheckInInfo.isHidden = true
            self.vwUserSelection.isHidden = true
            self.tabBarItem.title = "Dashboard"
        }else if(self.activeuser?.role?.id == NSNumber.init(value: 8)){
            //            if(isOnHome){
            self.setrightbtn(btnType: BtnRight.others, navigationItem: self.navigationItem)
            //            }else{
            //                self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
            //            }
            SalesPlanHome.screenselection = Dashboardscreen.salesplan
            self.vwForTeam.isHidden = true
            self.vwDailySalesPlan.isHidden = true
        }
        else
        {
            //role 8
            if(SalesPlanHome.screenselection == Dashboardscreen.salesplan){
                self.istabBarpresent = false
            }else{
                
                self.istabBarpresent = true
            }
            self.vwForTeam.isHidden = true
            
            self.vwDailySalesPlan.isHidden = true
            self.vwUserSelection.isHidden = true
            //  screenselection = Dashboardscreen.salesplan
            self.tabBarItem.title = "Plan"
        }
        
        Common.setTitleOfView(color:UIColor.white, viewController: self)
        self.setleftbtn(btnType: BtnLeft.menu,navigationItem: self.navigationItem)
        //   baseviewcontrollerobj.setleftbtn(btnType: BtnLeft.menu,navigationItem: self.navigationItem)
        
        btnCheckIn.layer.cornerRadius = 5
        btnCheckIn.backgroundColor = UIColor.Appskybluecolor
        tblSalesPlan.delegate = self
        tblSalesPlan.dataSource = self
        tblSalesPlan.separatorColor = .clear
        if(SalesPlanHome.screenselection == Dashboardscreen.salesplan){
            tblSalesPlan.tableFooterView = UIView()
        }else{
            tblSalesPlan.tableFooterView?.isHidden = true
        }
        
        
        if #available(iOS 13.4, *) {
            datepicker.frame = CGRect(x: 0, y: self.view.frame.size.height - 234, width: self.view.bounds.width, height: 250.0)
            
            
            
        }
        companyMenus = [CompanyMenus]()
        temp = [UPStackMenuItem]()
        //  companyMenus = baseviewcontrollerobj.createUPStackMenuItems(isFromHome: true, view: self)
        
        
        tblSalesPlan.estimatedRowHeight =  30
        tblSalesPlan.rowHeight = UITableView.automaticDimension
        
        // toolbarItemOfSalesPlan = ["Visits","Leads","Orders"]
        arrOfBottomTabBar = MenuTabs.getTabMenus(menu: [ 0, 1, 2], sort: true)
        arrOfBottomTabBar  = arrOfBottomTabBar.filter({ (menu) -> Bool in
            menu.isVisible == true
        })
        
        toolbarItemOfSalesPlan = arrOfBottomTabBar.map{
            $0.menuLocalText
        }
        
        if(SalesPlanHome.screenselection == Dashboardscreen.dashboardvisit || SalesPlanHome.screenselection == Dashboardscreen.dashboardlead || SalesPlanHome.screenselection == Dashboardscreen.dashboardorder){
            carbonTabSwipeNavigationSalesPlan = CarbonTabSwipeNavigation(items:toolbarItemOfSalesPlan, toolBar:toolbarSalesplan , delegate:self)
            
            carbonTabSwipeNavigationSalesPlan?.insert(intoRootViewController: self, andTargetView: vwTargetView)
        }
        self.style()
        //carbonTabSwipeNavigationSalesPlan.insert(intoRootViewController: self, andTargetView: self.vwTargetView)
        self.arrOfExecutive =  BaseViewController.staticlowerUser
        
        if(self.arrOfExecutive?.count ?? 0 > 0){
            for exec in self.arrOfExecutive ?? [CompanyUsers](){
                if(exec.entity_id == self.activeuser?.userID){
                    
                    self.arrOfSelectedExecutive.append(exec)
                    
                }
            }
        }
        
        
        
        //  arrOfExecutive = BaseViewController.staticlowerUser
        //        if(arrOfLowerLevelExecutive?.count ?? 0 > 0){
        //            vwUserSelection.isHidden = false
        //        }else{
        //             vwUserSelection.isHidden = true
        //        }
        //        popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        //        popup.selectionmode =  SelectionMode.single
        //        popup.modalPresentationStyle = .overCurrentContext
        //        popup.nonmandatorydelegate = self
        //        popup.strTitle = "Select User"
        //        popup.strRightTitle = "CANCEL"
        //        popup.strLeftTitle = "OK"
        //        popup.arrOfExecutive = arrOfLowerLevelExecutive
        //        popup.arrOfSelectedExecutive = [CompanyUsers]()
        //        popup.isFilterRequire = false
        //        popup.viewfor = ViewFor.companyuser
        //        popup.isSearchBarRequire = false
        //         // popup.showAnimate()
        //        //  self.popoverPresentationController =  popup
        //        self.present(popup, animated: true, completion: nil)
        
        
        
        //if(AttendanceCheckInCheckOut().isableToLogin(add: AttendanceViewController.selectedLocation ?? CLLocation())){
        //            btnChangeLocation.isHidden = true
        //        }else{
        //           btnChangeLocation.isHidden = false
        //        }
        //        self.setgraphdata()
        
        
        if let isonhome = self.isOnHome{
            companyMenus = baseviewcontrollerobj.createUPStackMenuItems(isFromHome: isonhome, view: self)
        }else{
            companyMenus = baseviewcontrollerobj.createUPStackMenuItems(isFromHome: true, view: self)
        }
        
        for tempitem in companyMenus{
            
            let upstackmenu = UPStackMenuItem.init(image:  CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16))
            temp.append(upstackmenu ?? UPStackMenuItem())
        }
        arrTabbarItem = [UITabBarItem]()
        // arrOfBottomTabBar = MenuTabs.getTabMenus(menu: [NSNumber.init(value: 0),NSNumber.init(value: 1),NSNumber.init(value: 2)], sort: true)
        
        
        
        baseviewcontrollerobj.salesPlandelegateObject = self
        if(temp.count > 0){
            baseviewcontrollerobj.initbottomMenu(menus:temp , control: self)
        }
        self.lblCheckInDetail.textColor =  BaseViewController.blackuniversalcolor
        let attrsbtn = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.Appskybluecolor,
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        let buttonDailyTitleStr =
        NSMutableAttributedString(string:"Daily Sales Plan", attributes:attrsbtn)//NSLocalizedString("Daily Sales Plan", comment: "")
        btnDailySalesplan.setAttributedTitle(buttonDailyTitleStr, for: UIControl.State.normal)
    }
    
    func setCheckinInfo(){
        self.lblCheckInDetail.setMultilineLabel(lbl: self.lblCheckInDetail)
        // add clickable action
        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(checkinTapped))
        tapgesture.numberOfTouchesRequired = 1
        tapgesture.numberOfTapsRequired = 1
        self.lblCheckInDetail.isUserInteractionEnabled = true
        self.lblCheckInDetail.addGestureRecognizer(tapgesture)
        self.btnCheckIn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        if let attendance = AttendanceHistory.getLatestAttendanceForDate(date: Date(), userID: self.activeuser?.userID ?? 0) as? AttendanceHistory
        {
            
            imgCheckInInfo.image = UIImage.init(named: "icon_exit")
            
            
            if let checkintime = attendance.checkInTime as? Date{
                
                self.lblCheckInDetail.text = "Attendance checkedin at \(Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a", defaultTimeZone: true))"
                btnCheckIn.setTitle(NSLocalizedString("CHECK_OUT_Cap", comment: ""), for: UIControl.State.normal)
                btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x23A6FF)//UIColor.systemBlue
            }else if let updatedCheckinTime = attendance.updatedTimeIn as? Date{
                
                self.lblCheckInDetail.text = "Attendance checkedin at \(Utils.getDateWithAppendingDay(day: 0, date: updatedCheckinTime as Date, format: "hh:mm a", defaultTimeZone: true))"
                btnCheckIn.setTitle(NSLocalizedString("CHECK_OUT_Cap", comment: ""), for: UIControl.State.normal)
                btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x23A6FF) //UIColor.systemBlue
            }else if let timeIn = attendance.timeIn as? Date{
                
                self.lblCheckInDetail.text = "Attendance checkedin at \(Utils.getDateWithAppendingDay(day: 0, date: timeIn as Date, format: "hh:mm a", defaultTimeZone: true))"
                btnCheckIn.setTitle(NSLocalizedString("CHECK_OUT_Cap", comment: ""), for: UIControl.State.normal)
                btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x23A6FF)//UIColor.systemBlue
            }
            
            
            
            if let checkouttime = attendance.checkOutTime as? Date{
                
                self.lblCheckInDetail.text = "Attendance Checked out for today."
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN_Cap", comment: ""), for: UIControl.State.normal)
                btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x0F8A14)//UIColor.green
                
                //  UIImage.init(named: "icon_exit")
            }else if let updatedCheckoutTime = attendance.updatedTimeOut as? Date{
                
                self.lblCheckInDetail.text = "Attendance Checked out for today."
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN_Cap", comment: ""), for: UIControl.State.normal)
                btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x0F8A14)
                
                
            }else if let timeOut = attendance.timeOut as? Date{
                
                self.lblCheckInDetail.text = "Attendance Checked out for today."
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN_Cap", comment: ""), for: UIControl.State.normal)
                btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x0F8A14)//UIColor.green
                
            }
            
            
            
            if(self.lblCheckInDetail.text?.count == 0){
                self.btnCheckIn.setTitle(NSLocalizedString("CHECK_IN_Cap", comment: ""), for: UIControl.State.normal)
                self.btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x0F8A14)//UIColor.green
                imgCheckInInfo.image = UIImage.init(named: "icon_error")
                self.lblCheckInDetail.text = "Attendance not Checked in for today"
            }
            
        }
        else
        {
            self.btnCheckIn.setTitle(NSLocalizedString("CHECK_IN_Cap", comment: ""), for: UIControl.State.normal)
            self.btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x0F8A14)//UIColor.green
            imgCheckInInfo.image = UIImage.init(named: "icon_error")
            self.lblCheckInDetail.text = "Attendance not Checked in for today"
        }
        
    }
    
    func style(){
        let color:UIColor = UIColor.Appskybluecolor//Common().UIColorFromRGB(rgbValue: 0xFFDCD62)
        let font = UIFont.init(name: Common.kfontbold, size: 16)
        carbonTabSwipeNavigationSalesPlan?.toolbar.backgroundColor = UIColor.attendanceBGColor
        
        carbonTabSwipeNavigationSalesPlan?.setSelectedColor(color, font: font ?? UIFont.boldSystemFont(ofSize: 16))
        carbonTabSwipeNavigationSalesPlan?.carbonSegmentedControl?.setWidth((UIScreen.main.bounds.size.width)/2 , forSegmentAt: 0)
        
        self.toolbarSalesplan.barTintColor = UIColor.white
        //    ca
        var width = 1.0
        //  let targetviewwidth = self.targetView.frame.size.width
        if((toolbarItemOfSalesPlan.count) > 3){
            width = Double((self.vwTargetView.frame.size.width/3.0))
        }
        else{
            if(toolbarItemOfSalesPlan.count > 0){
                width = Double(Int(UIScreen.main.bounds.size.width) / toolbarItemOfSalesPlan.count)
            }
        }
        for index in toolbarItemOfSalesPlan {
            //  print(items?.firstIndex(of: index));
            carbonTabSwipeNavigationSalesPlan?.carbonSegmentedControl?.setWidth(CGFloat(width), forSegmentAt: (toolbarItemOfSalesPlan.firstIndex(of: index))!)
        }
        let boldfont = UIFont.init(name: Common.kFontMedium, size: 16)
        
        carbonTabSwipeNavigationSalesPlan?.setNormalColor(UIColor.gray, font: boldfont ?? UIFont.boldSystemFont(ofSize: 16))
        carbonTabSwipeNavigationSalesPlan?.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
    }
    
    
    
    
    
    func setData(){
        
        SalesPlanHome.selectedDate =  Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:Date())
        datepicker.date = Date()
        btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:Date()), for: .normal)
        self.setCheckinInfo()
        if(self.reloadTappedStatus){
            self.getDataFromBackend()
        }else{
            self.getDailyReportData()
        }
        self.salesdelegate?.dateselectionsalesplandone(date: datepicker.date)
    }
    
    func getColdCallVisitDetail(id:NSNumber,compeletion: @escaping (ResponseBlock) -> Void){
        //ConstantURL.kWSUrlGetUnPlannedVisits
        var coldCallparam = Common.returndefaultparameter()
        
        var coldcalldic = [String:Any]()
        coldcalldic["CreatedBy"] = self.activeuser?.userID
        coldcalldic["ID"] = id
        coldcalldic["CompanyID"] = self.activeuser?.company?.iD
        coldCallparam["getUnPlannedVisitsJson"] = Common.returnjsonstring(dic: coldcalldic)
        self.apihelper.getdeletejoinvisit(param: coldCallparam, strurl: ConstantURL.kWSUrlGetUnPlannedVisits, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(arr)
                
                compeletion((totalpages,pagesavailable,lastsynctime,arr ,status,message,error: Common.returnnoerror(),responseType))
            } else if(error.code == 0){
                self.dismiss(animated: true, completion: nil)
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                }
                let dicJointVisitList = arr as? [String:Any] ?? [String:Any]()
                compeletion((totalpages,pagesavailable,lastsynctime,dicJointVisitList,status ,message,error: Common.returnnoerror(),responseType))
            }else{
                compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
                self.dismiss(animated: true, completion: nil)
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
    }
    
    func checkinbtnAction(){
        if( AttendanceViewController.tarvelAddress.count == 0 && (AttendanceCheckInCheckOut.defaultsetting.locationType == 4 || AttendanceCheckInCheckOut.defaultsetting.locationType == 7 )){
            self.getCurrentAddress{ (address) in
                SVProgressHUD.dismiss()
                if let ate = AttendanceHistory.getLatestAttendanceForDate(date: Date() ,userID:self.activeuser?.userID ?? 0){
                    
                    //    if let ate = AttendanceHistory.getAll().first{
                    // if(ate.checkInAttendanceType > 0 && ate.checkOutAttendanceType == 0){
                    if(self.btnCheckIn.currentTitle?.lowercased() == "check-in"){
                        //print("attendance checkin time = \(ate.updatedTimeIn)")
                        //print("attendance checkout time = \(ate.updatedTimeOut)")
                        AttendanceCheckInCheckOut.verifycheckinAdd = false
                        AttendanceCheckInCheckOut().checkinClicked(tag: 0, tflocationText: "office", viewController: self)
                    }else{
                        //            btnCheckIn.setTitle("Check-In" , for:.normal)
                        //            btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x114763)
                        AttendanceCheckInCheckOut.verifycheckoutAdd = false
                        AttendanceCheckInCheckOut().checkOutClicked(tag: 0, tflocationText: "office", viewController: self)
                    }
                }else{
                    AttendanceCheckInCheckOut.verifycheckinAdd = false
                    AttendanceCheckInCheckOut().checkinClicked(tag: 0, tflocationText: "office", viewController: self)
                }
            }
        }else{
            if let ate = AttendanceHistory.getLatestAttendanceForDate(date: Date() ,userID:self.activeuser?.userID ?? 0){
                
                //    if let ate = AttendanceHistory.getAll().first{
                // if(ate.checkInAttendanceType > 0 && ate.checkOutAttendanceType == 0){
                if(btnCheckIn.currentTitle?.lowercased() == "check-in"){
                    //print("attendance checkin time = \(ate.updatedTimeIn)")
                    //print("attendance checkout time = \(ate.updatedTimeOut)")
                    AttendanceCheckInCheckOut.verifycheckinAdd = false
                    AttendanceCheckInCheckOut().checkinClicked(tag: 0, tflocationText: "office", viewController: self)
                }else{
                    //            btnCheckIn.setTitle("Check-In" , for:.normal)
                    //            btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x114763)
                    AttendanceCheckInCheckOut.verifycheckoutAdd = false
                    AttendanceCheckInCheckOut().checkOutClicked(tag: 0, tflocationText: "office", viewController: self)
                }
            }else{
                AttendanceCheckInCheckOut.verifycheckinAdd = false
                AttendanceCheckInCheckOut().checkinClicked(tag: 0, tflocationText: "office", viewController: self)
            }
        }
    }
    
    @objc func checkinTapped(){
        print("btn tapped")
        if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
            print("get conteoller")
            self.navigationController?.pushViewController(attendance, animated: true)
            print("navigation done")
        }
        
    }
    
    func getCurrentAddress(completion:@escaping ((String) -> Void)){
        if let locationcoordinate = Location.sharedInsatnce.currentLocation{
            let coordinate = Location.sharedInsatnce.currentLocation.coordinate
            LMGeocoder.sharedInstance().cancelGeocode()
            LMGeocoder.sharedInstance().reverseGeocodeCoordinate(coordinate, service: LMGeocoderServiceGoogle, alternativeService: LMGeocoderServiceApple) { (results, error) in
                if((results?.count ?? 0 > 0) && (error == nil) ){
                    let address =  results?.first
                    
                    if(address?.formattedAddress?.count ?? 0 > 0){
                        if let addressline = address?.formattedAddress{
                            // print(addressline)
                            
                            
                            AttendanceViewController.tarvelAddress = addressline
                            completion(addressline)
                        }else{
                            var addressline = ""
                            
                            if let ad = address?.streetNumber{
                                
                                addressline.append(ad)
                            }
                            // neighborhood
                            if let adneighbourhood = address?.neighborhood{
                                if(addressline.count > 0){
                                    addressline.append(" , ")
                                }
                                addressline.append(adneighbourhood)
                            }
                            if let ad1 = address?.subLocality{
                                if(addressline.count > 0){
                                    addressline.append(" , ")
                                }
                                addressline.append(ad1)
                            }
                            if let ad2 = address?.locality{
                                if(addressline.count > 0){
                                    addressline.append(" , ")
                                }
                                addressline.append(ad2)
                            }
                            if let adcountry = address?.country{
                                if(addressline.count > 0){
                                    addressline.append(" , ")
                                }
                                addressline.append(adcountry)
                            }
                            AttendanceViewController.tarvelAddress = addressline
                            completion(addressline)
                            // self.strCurrentAddress =  "not get address"
                        }
                        
                    }
                    
                    else{
                        //self.lblAddress.text = "-"
                        if let lastLocation = Location.sharedInsatnce.currentLocation as? CLLocation{
                            self.getAddressFromLocation (location:lastLocation) {
                                (address,error)
                                in
                                var strAddress =  ""
                                if let strad1 = address["address1"] as? String{
                                    if(strad1.count > 0){
                                        strAddress.append(String.init(format:"\(strad1),"))
                                    }
                                }
                                if let strad2 = address["address2"] as? String{
                                    if(strad2.count > 0){
                                        strAddress.append(String.init(format:"\(strad2),"))
                                    }
                                }
                                
                                if let strcity = address["city"] as? String{
                                    if(strcity.count > 0){
                                        strAddress.append(String.init(format:"\(strcity),"))
                                    }
                                }
                                
                                
                                if let strstate = address["state"] as? String{
                                    if(strstate.count > 0){
                                        strAddress.append(String.init(format:"\(strstate),"))
                                    }
                                }
                                
                                if let strcountry = address["country"] as? String{
                                    if(strcountry.count > 0){
                                        strAddress.append(String.init(format:"\(strcountry),"))
                                    }
                                }
                                
                                if let strpincode = address["pincode"] as? String{
                                    if(strpincode.count > 0){
                                        strAddress.append(String.init(format:"\(strpincode),"))
                                    }
                                }
                                AttendanceViewController.tarvelAddress  = strAddress
                                completion(strAddress)
                                //        AttendanceViewController.tarvelAddress =  self.strCurrentAddress
                            }
                            
                            
                        }
                        
                    }
                }
            }
        }else{
            completion("")
            Common.showalert(msg: "We can not get your current location please check your gps", view: self)
        }
    }
    
    func getDataFromBackend(){
        self.arrSalesplanmodelAll = [SalesPlanModel]()
        // self.dateFormatter.dateFormat = ""
        let pendingvistOfchekout = PlannVisit.getPendingCheckOutVisitForSelectedDate(date: datepicker.date)
        let pendingleadOfCheckout = Lead.getPendingCheckOutLeadForToday()
        
        if(pendingvistOfchekout.count > 0){
            
            for visit in pendingvistOfchekout{
                let arrOfvisitID =  self.arrSalesplanmodelAll.map{
                    $0.modulePrimaryID
                }
                
                //&& (visit.visitStatusList.count > 0)
                //(
                if(!arrOfvisitID.contains(NSNumber.init(value:visit.iD)) && (visit.reAssigned == SalesPlanHome.selectedUserID.int64Value)){
                    print("arr of visit id = \(arrOfvisitID) and visit  id = \(visit.iD)")
                    var dic = [String:Any]()
                    dic["TransactionID"] = ""
                    dic["BeatPlanID"] = ""
                    dic["BeatPlanName"] = ""
                    dic["checkOutTime"] = visit.checkOutTime
                    dic["checkInTime"] = visit.checkInTime
                    dic["moduleID"] = NSNumber.init(value: 0)
                    dic["lowerUsersBeat"] = NSNumber.init(value: 0)
                    dic["nextActionID"] = NSNumber.init(value:visit.nextActionID)
                    dic["checkOutLangitude"] = NSNumber.init(value: 0)
                    dic["checkOutLatitude"] = NSNumber.init(value: 0)
                    dic["isActive"] = visit.isActive
                    dic["balanceValue"] = NSNumber.init(value: 0)
                    dic["checkInCustomerName"] = visit.customerName
                    dic["userID"] =  self.activeuser?.userID
                    dic["checkInLatitude"] = NSNumber.init(value: 0)
                    dic["kms"] = NSNumber.init(value: 0)
                    dic["nextActionTime"] = visit.nextActionTime
                    if(visit.isManual == 1){
                        dic["IsManual"] =  true
                    }else{
                        dic["IsManual"] = false
                    }
                    if let collection = visit.visitCollection as? VisitCollection{
                        dic["modeOfPayment"] = NSNumber.init(value: collection.modeOfPayment)
                        dic["referenceNo"] = collection.referenceNo
                        dic["collectionValue"] =  collection.collectionValue
                    }else{
                        dic["modeOfPayment"] = NSNumber.init(value: 0)
                        dic["referenceNo"] = NSNumber.init(value: 0)
                        dic["collectionValue"] = NSNumber.init(value: 0)
                    }
                    dic["description"] =  visit.description
                    dic["checkInLongitude"] = NSNumber.init(value: 0)
                    dic["customerID"] =  visit.customerID
                    dic["territoryId"] =  NSNumber.init(value: 0)
                    dic["visitID"] = NSNumber.init(value:visit.iD)
                    if let  (message,latestvisitcheckinactivity)  = Utils.latestCheckinDetailForPlanedVisit(visit: visit) as? (String,UserLatestActivityForVisit){
                        if(latestvisitcheckinactivity  == UserLatestActivityForVisit.checkedIn) {
                            dic["isCheckedIn"] = true
                            if let lastcheckin = visit.checkInOutData.firstObject as? VisitCheckInOutList{
                                
                                
                            }
                        }else{
                            dic["isCheckedIn"] = false
                        }
                        
                    }
                    dic["companyID"] = self.activeuser?.company?.iD
                    dic["statusID"]  = NSNumber.init(value: 0)
                    dic["modulePrimaryID"] = visit.iD
                    if(visit.isPictureAvailable > 0){
                        dic["isPictureAvailable"] = true
                    }else{
                        dic["isPictureAvailable"] = false
                    }
                    dic["isStockAvailable"] = NSNumber.init(value: 0)//visit.isStockAvailable
                    dic["AssigneeID"] =  visit.originalAssignee
                    dic["isFeedBackAvailable"] = NSNumber.init(value: 0)//visit.isFeedBackAvailable
                    dic["isTertiaryAvailable"] =  NSNumber.init(value: 0)
                    dic["contactID"] =  NSNumber.init(value:visit.contactID)
                    dic["addressID"] =  visit.addressMasterID
                    dic["detailType"] = NSNumber.init(value:2)
                    if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: visit.customerID)) as? CustomerDetails{
                        dic["customerMobileNumber"] = customer.mobileNo
                        
                        let permenentAdd = customer.addressList.filter { (add) -> Bool in
                            
                            (add as? AddressList)?.type == "1"
                        }
                        var straddress = ""
                        if(permenentAdd.count > 0){
                            let permenentaddress = permenentAdd.first as? AddressList
                            straddress  = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:permenentaddress?.addressID ?? 0) ?? NSNumber.init(value: 0)
                            ) ?? ""
                        }
                        dic["chekInAddress"] = straddress
                    }else{
                        dic["customerMobileNumber"] = "0"
                        
                    }
                    let salespmodel = SalesPlanModel().initWithdic(dict:dic)
                    if(salespmodel.detailType == 2){
                        if let objVisit = PlannVisit.getVisit(visitID: NSNumber.init(value:visit.iD)) as? PlannVisit{
                            
                        }else{
                            self.getplanvisitDetial(visitId: salespmodel.modulePrimaryID, ForAction: "", model: salespmodel)
                        }
                    }
                    self.arrSalesplanmodelAll.append(salespmodel)
                }else{
                    //  print("visit = \(visit.reAssigned) , sales plan = \(SalesPlanHome.selectedUserID.int64Value) , \(visit.visitStatusList.count) , visit id = \(visit.iD), reassigned id = \(visit.reAssigned) , selecteduser id = \(SalesPlanHome.selectedUserID.int64Value) , and count of status list = \(visit.visitStatusList.count)")
                }
            }
        }
        
        if(pendingleadOfCheckout.count > 0){
            
            for lead in pendingvistOfchekout{
                let arrOfleadID =  self.arrSalesplanmodelAll.map{
                    $0.modulePrimaryID
                }
                
                // && (lead.visitStatusList.count > 0)
                if(!arrOfleadID.contains(NSNumber.init(value:lead.iD)) && (lead.reAssigned == SalesPlanHome.selectedUserID.int64Value)){
                    print("arr of lead id = \(arrOfleadID) and lead id = \(lead.iD)")
                    var dic = [String:Any]()
                    dic["TransactionID"] = ""
                    dic["BeatPlanID"] = ""
                    dic["BeatPlanName"] = ""
                    dic["checkOutTime"] = lead.checkOutTime
                    dic["checkInTime"] = lead.checkInTime
                    dic["moduleID"] = NSNumber.init(value: 0)
                    dic["lowerUsersBeat"] = NSNumber.init(value: 0)
                    dic["nextActionID"] = NSNumber.init(value:lead.nextActionID)
                    dic["checkOutLangitude"] = NSNumber.init(value: 0)
                    dic["checkOutLatitude"] = NSNumber.init(value: 0)
                    dic["isActive"] = lead.isActive
                    dic["balanceValue"] = NSNumber.init(value: 0)
                    dic["checkInCustomerName"] = lead.customerName
                    dic["userID"] =  self.activeuser?.userID
                    dic["checkInLatitude"] = NSNumber.init(value: 0)
                    dic["kms"] = NSNumber.init(value: 0)
                    dic["nextActionTime"] = lead.nextActionTime
                    if(lead.isManual == 1){
                        dic["IsManual"] =  true
                    }else{
                        dic["IsManual"] = false
                    }
                    if let collection = lead.visitCollection as? VisitCollection{
                        dic["modeOfPayment"] = NSNumber.init(value: collection.modeOfPayment)
                        dic["referenceNo"] = collection.referenceNo
                        dic["collectionValue"] =  collection.collectionValue
                    }else{
                        dic["modeOfPayment"] = NSNumber.init(value: 0)
                        dic["referenceNo"] = NSNumber.init(value: 0)
                        dic["collectionValue"] = NSNumber.init(value: 0)
                    }
                    dic["description"] =  lead.description
                    dic["checkInLongitude"] = NSNumber.init(value: 0)
                    dic["customerID"] =  lead.customerID
                    dic["territoryId"] =  NSNumber.init(value: 0)
                    dic["visitID"] = NSNumber.init(value:lead.iD)
                    if let  (message,latestvisitcheckinactivity)  = Utils.latestCheckinDetailForPlanedVisit(visit: lead) as? (String,UserLatestActivityForVisit){
                        if(latestvisitcheckinactivity  == UserLatestActivityForVisit.checkedIn) {
                            dic["isCheckedIn"] = true
                            if let lastcheckin = lead.checkInOutData.firstObject as? LeadCheckInOutList{
                                
                                
                            }
                            
                        }else{
                            dic["isCheckedIn"] = false
                        }
                        
                    }
                    dic["companyID"] = self.activeuser?.company?.iD
                    dic["statusID"]  = NSNumber.init(value: 0)
                    dic["modulePrimaryID"] = lead.iD
                    if(lead.isPictureAvailable > 0){
                        dic["isPictureAvailable"] = true
                    }else{
                        dic["isPictureAvailable"] = false
                    }
                    dic["isStockAvailable"] = NSNumber.init(value: 0)// lead.isStockAvailable
                    dic["AssigneeID"] =  lead.originalAssignee
                    dic["isFeedBackAvailable"] = NSNumber.init(value: 0)//lead.isFeedBackAvailable
                    dic["isTertiaryAvailable"] = NSNumber.init(value: 0)// lead.isTertiaryAvailable
                    dic["contactID"] =  NSNumber.init(value:lead.contactID)
                    dic["addressID"] =  lead.addressMasterID
                    dic["detailType"] = NSNumber.init(value:3)
                    if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: lead.customerID)) as? CustomerDetails{
                        dic["customerMobileNumber"] = customer.mobileNo
                        let permenentAdd = customer.addressList.filter { (add) -> Bool in
                            
                            (add as? AddressList)?.type == "1"
                        }
                        var straddress = ""
                        if(permenentAdd.count > 0){
                            let permenentaddress = permenentAdd.first as? AddressList
                            straddress  = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:permenentaddress?.addressID ?? 0) ?? NSNumber.init(value: 0)
                            ) ?? ""
                        }
                        dic["chekInAddress"] = straddress
                    }else{
                        dic["customerMobileNumber"] = NSNumber.init(value: 0)
                    }
                    let salespmodel = SalesPlanModel().initWithdic(dict:dic)
                    self.arrSalesplanmodelAll.append(salespmodel)
                }else{
                    print("arr of lead id = \(arrOfleadID) and lead id = \(lead.iD)")
                }
            }
        }
    }
    //    func setgraphdata(){
    //        btnLevelBack.isHidden = true
    //        if(screenselection ==  Dashboardscreen.dashboardvisit){
    //            lbl1Indicator.backgroundColor = UIColor.green
    //            lbl1Title.text = "Done"
    //            lbl2Indicator.backgroundColor = UIColor.yellow
    //            lbl2Title.text = "Missed"
    //            lbl3Indicator.backgroundColor = UIColor.red
    //            lbl3Title.text = "Updated"
    //        }else if (screenselection == Dashboardscreen.dashboardlead){
    //            lbl1Indicator.backgroundColor = UIColor.blue
    //            lbl1Title.text = "Assigned"
    //            lbl2Indicator.backgroundColor = UIColor.green
    //            lbl2Title.text = "Added"
    //            lbl3Indicator.backgroundColor = UIColor.yellow
    //            lbl3Title.text = "Updated"
    //        }else{
    //            vwGraphIndicator.isHidden = true
    //            btnLevelBack.isHidden = true
    //             lbl1Indicator.isHidden = true
    //              lbl1Title.isHidden = true
    //              lbl2Indicator.isHidden = true
    //              lbl2Title.isHidden = true
    //            lbl3Indicator.isHidden = true
    //            lbl3Title.isHidden = true
    //        }
    //    }
    
    //    func showGraphIndicator(show:Bool){
    //      //  vwGraphIndicator.isHidden = show
    //      //  stkGraph.isHidden = show
    //        btnLevelBack.isHidden  = true
    //        lbl1Indicator.isHidden = show
    //        lbl1Title.isHidden = show
    //        lbl2Indicator.isHidden = show
    //        lbl2Title.isHidden = show
    //        lbl3Indicator.isHidden = show
    //        lbl3Title.isHidden = show
    //
    //    }
    
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
                    availabale = false
                    group1.leave()
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
    
    func finalCheckout(visitType:VisitType){
        let arrofmandatorystepID = arrofmandatoryStep.map {
            return $0.menuIndex
        }
        if(visitType == VisitType.planedvisit && (!(visitType == VisitType.planedvisitHistory))){
            if(self.activesetting.customTagging == 3){
                if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:activeplanvisit?.customerID ?? 0)))){
                    Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view: self.view)
                    return
                    
                }
                
            }
        }
        if(self.activesetting.mandatoryPictureInVisit == 1 && (arrofmandatorystepID.contains(38))){
            if(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                if(activeunplanvisit?.isPictureAvailable ==  1){
                    Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
                    return
                }
            }else{
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
                var param = Common.returndefaultparameter()
                if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
                    param["VisitID"] =  activeplanvisit.iD
                }else{
                    param["VisitID"] = activeunplanvisit.localID
                }
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetVisitUploadImages, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        if(responseType == ResponseType.arr){
                            let arrofpicturedata = arr as? [[String:Any]] ?? [[String:Any]]()
                            
                            if(arrofpicturedata.count > 0){
                                //                self.arrSelectedVisitStep.append(visitStepsData)
                                //   group.leave()
                            }else{
                                Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
                                return
                                
                            }
                        }else if(error.code == 0){
                            
                            
                            // Utils.toastmsg(message:"Error while checking picture",view: self.view)
                            //return
                            
                            
                        }else{
                            //   group.leave()
                            Utils.toastmsg(message:"Error while checking picture",view: self.view)
                            
                        }
                    }else{
                        //   group.leave()
                    }
                    
                    
                }
                //                    if(activeplanvisit?.isPictureAvailable == 1){
                //                        Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
                //                        return
                //                    }
            }
        }
        if(self.activesetting.mandatoryVisitReport == 1  && (arrofmandatorystepID.contains(35))){
            if (visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                if (activeunplanvisit?.visitStatusList.count == 0){
                    Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
                    
                    return
                }
            }else{
                if (activeplanvisit?.visitStatusList.count == 0){
                    Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
                    return
                }
            }
        }
        if(self.activesetting.mandatoryVisitReport == 1  && (self.activesetting.visitStepsRequired == NSNumber.init(value: 0))){
            if (visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                if (activeunplanvisit?.visitStatusList.count == 0){
                    Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
                    
                    return
                }
            }else{
                if (activeplanvisit?.visitStatusList.count == 0){
                    Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
                    return
                }
            }
        }
        
        if((self.activesetting.requireSOFromVisitBeforeCheckOut == 1) && (!(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory)) && (arrofmandatorystepID.contains(65))  && self.activesetting.visitStepsRequired == NSNumber.init(value: 0) ) {
            if let countershare = activeplanvisit?.visitCollection as? VisitCollection {
                
            }else{
                Utils.toastmsg(message:NSLocalizedString("please_add_collection_in_this_visit_for_check_Out", comment: ""),view: self.view)
                return
            }
        }
        /* if(self.activesetting.visitStepsRequired == NSNumber.init(value: 0)){
         if(self.activesetting.requireVisitCounterShare == NSNumber.init(value: 1) && (arrofmandatorystepID.contains(66))){
         if let countershare = activeplanvisit?.visitCounterShare {
         
         }else{
         Utils.toastmsg(message:NSLocalizedString("please_add_counter_share_in_this_visit_for_check_Out", comment: ""),view: self.view)
         return
         }
         }
         }*/
        VisitCheckinCheckout.verifyCheckoutAddress = false
        VisitCheckinCheckout().checkForVisit(visitType:visitType,planvisit: activeplanvisit, unplanvisit: activeunplanvisit, viewcontroller: self.parent ?? self) { (status) in
            if(status){
                VisitCheckinCheckout().checkout(visitstatus:0,lat:NSNumber.init(value: self.currentCoordinate.latitude) ,long:NSNumber.init(value:self.currentCoordinate.longitude), isVisitPlanned: visitType, objplannedVisit: self.activeplanvisit  ,objunplannedVisit: self.activeunplanvisit,viewcontroller:self.parent ?? self, addressID: NSNumber.init(value:0))
            }else{
                // Utils.toastmsg(message: "something went worng, please try again", view: self.view)
            }
        }
    }
    
    // MARK: -APICall
    func getDailyReportData(){
        SVProgressHUD.show(withStatus: "Loading")
        
        self.apihelper.getDailySalesPlanDetail(selecteduserID: SalesPlanHome.selectedUserID.stringValue, selectedDate: SalesPlanHome.selectedDate) { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            self.aBeatplanvisitList.removeAll()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                SVProgressHUD.dismiss()
                let arrVisitFollowUpList = arr as? [[String:Any]] ?? [[String:Any]]()
                
                self.arrSalesplanmodelAll = [SalesPlanModel]()
                if(arrVisitFollowUpList.count > 0){
                    for spm in arrVisitFollowUpList{
                        let salespmodel = SalesPlanModel().initWithdic(dict:spm)
                        self.arrSalesplanmodelAll.append(salespmodel)
                        if(salespmodel.detailType == 2){
                            //                            if let objVisit = PlannVisit.getVisit(visitID: salespmodel.modulePrimaryID) as? PlannVisit{
                            //
                            //                            }else{
                            self.getplanvisitDetial(visitId: salespmodel.modulePrimaryID, ForAction: "", model: salespmodel)
                            //  }
                        }
                        if(salespmodel.detailType == 3){
                            if let objLead = Lead.getLeadByID(Id: salespmodel.modulePrimaryID.intValue) as? Lead{
                                
                            }else{
                                self.getLeadDetailsFor(model: salespmodel, leadId:salespmodel.modulePrimaryID, ForAction: "")
                            }
                        }
                    }
                    
                }
                
                var pendingvistOfchekout = PlannVisit.getPendingCheckOutVisitForSelectedDate(date: datepicker.date)
                //var pendingvistOfchekout = PlannVisit.getPendingCheckOutVisitForToday()
                var pendingleadOfCheckout = Lead.getPendingCheckOutLeadForToday()
                pendingvistOfchekout = pendingvistOfchekout.filter({ visit in
                    if let nextAction = visit.createdTime{
                        //                    dateFormatter.dateFormat = "dd-MM-yyyy"
                        //                    let nextactionDate = dateFormatter.date(from: nextAction)
                        //                        let nextactionDate  =  Utils.getDateBigFormatToDefaultFormat(date: nextAction ?? "2021/10/18 10:18:18", format: "yyyy/MM/dd")
                        let createdDate = Utils.getDateBigFormatToDefaultFormat(date: nextAction ?? "2021/10/18 10:18:18", format: "yyyy/MM/dd")
                        if(createdDate == SalesPlanHome.selectedDate){
                            return  true
                        }else{
                            return  false
                        }
                    }else{
                        return  false
                    }
                })
                if(pendingvistOfchekout.count > 0){
                    
                    for visit in pendingvistOfchekout{
                        let arrOfvisitID =  self.arrSalesplanmodelAll.map{
                            $0.modulePrimaryID
                        }
                        
                        
                        if(!arrOfvisitID.contains(NSNumber.init(value:visit.iD)) && (visit.reAssigned == SalesPlanHome.selectedUserID.int64Value)){
                            print("arr of visit id = \(arrOfvisitID) and visit  id = \(visit.iD)")
                            var dic = [String:Any]()
                            dic["TransactionID"] = ""
                            dic["BeatPlanID"] = ""
                            dic["BeatPlanName"] = ""
                            dic["checkOutTime"] = visit.checkOutTime
                            dic["checkInTime"] = visit.checkInTime
                            dic["moduleID"] = NSNumber.init(value: 0)
                            dic["lowerUsersBeat"] = NSNumber.init(value: 0)
                            dic["nextActionID"] = NSNumber.init(value:visit.nextActionID)
                            dic["checkOutLangitude"] = NSNumber.init(value: 0)
                            dic["checkOutLatitude"] = NSNumber.init(value: 0)
                            dic["isActive"] = visit.isActive
                            dic["balanceValue"] = NSNumber.init(value: 0)
                            dic["checkInCustomerName"] = visit.customerName
                            dic["userID"] =  self.activeuser?.userID
                            dic["checkInLatitude"] = NSNumber.init(value: 0)
                            dic["kms"] = NSNumber.init(value: 0)
                            dic["nextActionTime"] = visit.nextActionTime
                            if(visit.isManual == 1){
                                dic["IsManual"] =  true
                            }else{
                                dic["IsManual"] = false
                            }
                            if let collection = visit.visitCollection as? VisitCollection{
                                dic["modeOfPayment"] = NSNumber.init(value: collection.modeOfPayment)
                                dic["referenceNo"] = collection.referenceNo
                                dic["collectionValue"] =  collection.collectionValue
                            }else{
                                dic["modeOfPayment"] = NSNumber.init(value: 0)
                                dic["referenceNo"] = NSNumber.init(value: 0)
                                dic["collectionValue"] = NSNumber.init(value: 0)
                            }
                            dic["description"] =  visit.description
                            dic["checkInLongitude"] = NSNumber.init(value: 0)
                            dic["customerID"] =  visit.customerID
                            dic["territoryId"] =  NSNumber.init(value: 0)
                            dic["visitID"] = NSNumber.init(value:visit.iD)
                            if let  (message,latestvisitcheckinactivity)  = Utils.latestCheckinDetailForPlanedVisit(visit: visit) as? (String,UserLatestActivityForVisit){
                                if(latestvisitcheckinactivity  == UserLatestActivityForVisit.checkedIn) {
                                    dic["isCheckedIn"] = true
                                    if let lastcheckin = visit.checkInOutData.firstObject as? VisitCheckInOutList{
                                        
                                        
                                    }
                                }else{
                                    dic["isCheckedIn"] = false
                                }
                                
                            }
                            dic["companyID"] = self.activeuser?.company?.iD
                            dic["statusID"]  = NSNumber.init(value: 0)
                            dic["modulePrimaryID"] = visit.iD
                            if(visit.isPictureAvailable > 0){
                                dic["isPictureAvailable"] = true
                            }else{
                                dic["isPictureAvailable"] = false
                            }
                            dic["isStockAvailable"] = NSNumber.init(value: 0)//visit.isStockAvailable
                            dic["AssigneeID"] =  visit.originalAssignee
                            dic["isFeedBackAvailable"] = NSNumber.init(value: 0)//visit.isFeedBackAvailable
                            dic["isTertiaryAvailable"] =  NSNumber.init(value: 0)//visit.isTertiaryAvailable
                            dic["contactID"] =  NSNumber.init(value:visit.contactID)
                            dic["addressID"] =  visit.addressMasterID
                            dic["detailType"] = NSNumber.init(value:2)
                            if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: visit.customerID)) as? CustomerDetails{
                                dic["customerMobileNumber"] = customer.mobileNo
                                
                                let permenentAdd = customer.addressList.filter { (add) -> Bool in
                                    
                                    (add as? AddressList)?.type == "1"
                                }
                                var straddress = ""
                                if(permenentAdd.count > 0){
                                    let permenentaddress = permenentAdd.first as? AddressList
                                    straddress  = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:permenentaddress?.addressID ?? 0) ?? NSNumber.init(value: 0)
                                    ) ?? ""
                                }
                                dic["chekInAddress"] = straddress
                            }else{
                                dic["customerMobileNumber"] = "0"
                                
                            }
                            let salespmodel = SalesPlanModel().initWithdic(dict:dic)
                            if(salespmodel.detailType == 2){
                                if let objVisit = PlannVisit.getVisit(visitID: NSNumber.init(value:visit.iD)) as? PlannVisit{
                                    
                                }else{
                                    self.getplanvisitDetial(visitId: salespmodel.modulePrimaryID, ForAction: "", model: salespmodel)
                                }
                            }
                            self.arrSalesplanmodelAll.append(salespmodel)
                        }else{
                            
                        }
                    }
                }
                pendingleadOfCheckout = pendingleadOfCheckout.filter({ lead in
                    if let nextAction = lead.createdTime{
                        //                    dateFormatter.dateFormat = "dd-MM-yyyy"
                        //                    let nextactionDate = dateFormatter.date(from: nextAction)
                        //                        let nextactionDate  =  Utils.getDateBigFormatToDefaultFormat(date: nextAction ?? "2021/10/18 10:18:18", format: "yyyy/MM/dd")
                        let createdDate = Utils.getDateBigFormatToDefaultFormat(date: nextAction ?? "2021/10/18 10:18:18", format: "yyyy/MM/dd")
                        if(createdDate == SalesPlanHome.selectedDate){
                            return  true
                        }else{
                            return  false
                        }
                    }else{
                        return  false
                    }
                })
                if(pendingleadOfCheckout.count > 0){
                    
                    for lead in pendingleadOfCheckout{
                        let arrOfleadID =  self.arrSalesplanmodelAll.map{
                            $0.modulePrimaryID
                        }
                        
                        // && (lead.visitStatusList.count > 0)
                        if(!arrOfleadID.contains(NSNumber.init(value:lead.iD)) && (lead.reAssigned == SalesPlanHome.selectedUserID.int64Value)){
                            print("arr of lead id = \(arrOfleadID) and lead id = \(lead.iD)")
                            var dic = [String:Any]()
                            
                            dic["TransactionID"] = ""
                            dic["BeatPlanID"] = ""
                            dic["BeatPlanName"] = ""
                            if let latestleadcheckindata = lead.leadCheckInOutList.firstObject as? LeadCheckInOutList{
                                dic["checkOutTime"] = latestleadcheckindata.checkOutTime
                                
                                dic["checkInTime"] = latestleadcheckindata.checkInTime
                            }else{
                                dic["checkOutTime"] = ""
                                
                                dic["checkInTime"] = ""
                            }
                            dic["moduleID"] = NSNumber.init(value: 0)
                            dic["lowerUsersBeat"] = NSNumber.init(value: 0)
                            dic["nextActionID"] = NSNumber.init(value:lead.nextActionID)
                            dic["checkOutLangitude"] = NSNumber.init(value: 0)
                            dic["checkOutLatitude"] = NSNumber.init(value: 0)
                            dic["isActive"] = lead.isActive
                            dic["balanceValue"] = NSNumber.init(value: 0)
                            dic["checkInCustomerName"] = lead.customerName
                            dic["userID"] =  self.activeuser?.userID
                            dic["checkInLatitude"] = NSNumber.init(value: 0)
                            dic["kms"] = NSNumber.init(value: 0)
                            dic["nextActionTime"] = lead.nextActionTime
                            //                            if(lead.isManual == 1){
                            //                                dic["IsManual"] =  true
                            //                            }else{
                            dic["IsManual"] = false
                            // }
                            //                            if let collection = lead.visitCollection as? VisitCollection{
                            //                                dic["modeOfPayment"] = NSNumber.init(value: collection.modeOfPayment)
                            //                                dic["referenceNo"] = collection.referenceNo
                            //                                dic["collectionValue"] =  collection.collectionValue
                            //                            }else{
                            dic["modeOfPayment"] = NSNumber.init(value: 0)
                            dic["referenceNo"] = NSNumber.init(value: 0)
                            dic["collectionValue"] = NSNumber.init(value: 0)
                            //   }
                            dic["description"] =  lead.description
                            dic["checkInLongitude"] = NSNumber.init(value: 0)
                            dic["customerID"] =  lead.customerID
                            dic["territoryId"] =  NSNumber.init(value: 0)
                            dic["visitID"] = NSNumber.init(value:lead.iD)
                            if let  (message,latestvisitcheckinactivity)  = Utils.latestCheckinDetailForLead(lead: lead) as? (String,UserLatestActivityForLead){
                                if(latestvisitcheckinactivity  == UserLatestActivityForLead.checkedIn) {
                                    dic["isCheckedIn"] = true
                                    if let lastcheckin = lead.leadCheckInOutList.firstObject as? LeadCheckInOutList{
                                        
                                        
                                    }
                                    
                                }else{
                                    dic["isCheckedIn"] = false
                                }
                                
                            }
                            dic["companyID"] = self.activeuser?.company?.iD
                            dic["statusID"]  = NSNumber.init(value: 0)
                            dic["modulePrimaryID"] = lead.iD
                            //                            if(lead.isPictureAvailable > 0){
                            //                                dic["isPictureAvailable"] = true
                            //                            }else{
                            //                                dic["isPictureAvailable"] = false
                            //                            }
                            dic["isPictureAvailable"] = false
                            dic["isStockAvailable"] = NSNumber.init(value: 0)
                            dic["AssigneeID"] =  lead.originalAssignee
                            dic["isFeedBackAvailable"] = NSNumber.init(value: 0)
                            dic["isTertiaryAvailable"] =  NSNumber.init(value: 0)
                            dic["contactID"] =  NSNumber.init(value:lead.contactID)
                            dic["addressID"] =  lead.addressMasterID
                            dic["detailType"] = NSNumber.init(value:3)
                            if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: lead.customerID)) as? CustomerDetails{
                                dic["customerMobileNumber"] = customer.mobileNo
                                let permenentAdd = customer.addressList.filter { (add) -> Bool in
                                    
                                    (add as? AddressList)?.type == "1"
                                }
                                var straddress = ""
                                if(permenentAdd.count > 0){
                                    let permenentaddress = permenentAdd.first as? AddressList
                                    straddress  = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:permenentaddress?.addressID ?? 0) ?? NSNumber.init(value: 0)
                                    ) ?? ""
                                }
                                dic["chekInAddress"] = straddress
                            }else{
                                dic["customerMobileNumber"] = NSNumber.init(value: 0)
                            }
                            let salespmodel = SalesPlanModel().initWithdic(dict:dic)
                            self.arrSalesplanmodelAll.append(salespmodel)
                        }else{
                            print("arr of lead id = \(arrOfleadID) and lead id = \(lead.iD)")
                        }
                    }
                }
                
                //array2.filter{ !array1.contains($0) }
                /* if(arrOldSalesplanmodalAll.count > 0){
                 var arrremovedmodel = [SalesPlanModel]()
                 arrremovedmodel = self.arrOldSalesplanmodalAll.filter{
                 !self.arrSalesplanmodelAll.contains($0)
                 
                 }
                 for model in arrremovedmodel{
                 
                 if((model.detailType == 2  || model.detailType == 3 || model.detailType == 4 || model.detailType == 5 || model.detailType == 6) && model.isCheckedIn == true && model.checkOutTime?.count == 0 && (!arrSalesplanmodelAll.contains(model)) ){
                 let checkintimedate = Utils.getDateBigFormatToDefaultFormat(date: model.checkInTime ?? "12/10/2021 10:10:10", format: "dd MM yyyy")
                 if(checkintimedate == SalesPlanHome.selectedDate){
                 self.arrSalesplanmodelAll.append(model)
                 if(model.detailType == 2){
                 if let objVisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                 
                 }else{
                 self.getplanvisitDetial(visitId: model.modulePrimaryID, ForAction: "")
                 }
                 
                 }
                 }
                 }
                 }
                 }*/
                
                self.arrSalesplanmodelForDisplay = [SalesPlanModel]()
                self.arrSalesplanmodelAll = self.unique(source: self.arrSalesplanmodelAll)
                
                if(self.isHome != false){
                    if(self.reloadTappedStatus == false){
                        
                        self.arrSalesplanmodelAll = self.arrSalesplanmodelAll.filter{
                            
                            return  $0.detailType.intValue != 5
                            
                        }
                        
                        self.arrSalesplanmodelForDisplay =   self.arrSalesplanmodelAll
                        
                    }else{
                        self.arrSalesplanmodelForDisplay = self.arrSalesplanmodelAll
                    }
                    
                }
                if(SalesPlanHome.screenselection == Dashboardscreen.salesplan){
                    self.arrSalesplanmodelForDisplay = self.arrSalesplanmodelAll
                    
                }
                /*   let mapping = PlannVisit.defaultmapping()
                 let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                 store.saveContextOnCommit = false
                 let deserialiser = FEMDeserializer.init(store: store)
                 self.aVisitsFlwups.removeAll()
                 if(arrVisitFollowUpList.count > 0){
                 
                 
                 for dic in arrVisitFollowUpList{
                 var dicVisit = dic
                 let visitTypeId:Int = dicVisit["VisitTypeID"] as? Int ?? 10
                 //if(visitTypeId == 1){
                 if(visitTypeId == 1){
                 let customerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: (dicVisit["CustomerID"] as? Int ?? 0)))
                 
                 if(customerName.count > 0){
                 dicVisit["CustomerName"] = customerName
                 }else{
                 dicVisit["CustomerName"] = " "
                 }
                 let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
                 if(reassignedId > 0){
                 if let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId)){
                 
                 let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                 dicVisit["RessigneeName"] = reassignUserName
                 }
                 }else{
                 dicVisit["RessigneeName"] = ""
                 }
                 for int in  dicVisit.keys{
                 print(int)
                 print(dicVisit[int] ?? "")
                 print(type(of: dicVisit[int]))
                 }
                 
                 let objVisit = deserialiser.object(fromRepresentation: dicVisit, mapping: mapping)
                 dicVisit["visitType"] = VisitType.planedvisit
                 self.aBeatplanvisitList.append(objVisit)
                 if let objVisit =  objVisit  as? PlannVisit{
                 self.aVisitsFlwups.append(objVisit)
                 }
                 
                 }else{
                 
                 
                 }
                 }
                 
                 //self.fetchActivityFollowUps()
                 
                 }else{
                 
                 //self.fetchActivityFollowUps()
                 }*/
                
                
                arrSalesplanmodelForDisplay = arrSalesplanmodelForDisplay.sorted(by: { (model1, model2) -> Bool in
                    model1.nextActionTime.compare(model2.nextActionTime) == .orderedAscending
                })
                
                
                //arrSalesplanmodelForDisplay.sorted(by: { $0.compare($1) == .orderedDescending })
                SVProgressHUD.dismiss()
                self.tblSalesPlan.reloadData()
            }
            else if(error.code == 0){
                SVProgressHUD.dismiss()
                self.tblSalesPlan.makeToast(message)
            }else{
                SVProgressHUD.dismiss()
                if(message.count > 0){
                    self.tblSalesPlan.makeToast(message)
                }else{
                    self.tblSalesPlan.makeToast(error.localizedDescription)
                }
                //  self.tabBarController?.selectedViewController?.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
            }
        }
    }
    func  getVisitFollowupList(){
        
        SVProgressHUD.show(withStatus: "Loading")
        
        self.apihelper.getVisitFollowUps(selecteduserID: SalesPlanHome.selectedUserID.stringValue, selectedDate: SalesPlanHome.selectedDate) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            self.aBeatplanvisitList.removeAll()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let arrVisitFollowUpList = arr as? [[String:Any]] ?? [[String:Any]]()
                let mapping = PlannVisit.defaultmapping()
                let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                store.saveContextOnCommit = false
                let deserialiser = FEMDeserializer.init(store: store)
                self.aVisitsFlwups.removeAll()
                if(arrVisitFollowUpList.count > 0){
                    
                    
                    for dic in arrVisitFollowUpList{
                        var dicVisit = dic  
                        //let dictVisit =
                        let visitTypeId:Int = dicVisit["VisitTypeID"] as? Int ?? 10
                        if(visitTypeId == 1){
                            let customerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: (dicVisit["CustomerID"] as? Int ?? 0)))
                            
                            if(customerName.count > 0){
                                dicVisit["CustomerName"] = customerName
                            }else{
                                dicVisit["CustomerName"] = " "
                            }
                            let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
                            if(reassignedId > 0){
                                if let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId)){
                                    
                                    let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                                    dicVisit["RessigneeName"] = reassignUserName
                                }
                            }else{
                                dicVisit["RessigneeName"] = ""
                            }
                            for int in  dicVisit.keys{
                                print(int)
                                print(dicVisit[int] ?? "")
                                print(type(of: dicVisit[int]))
                            }
                            
                            let objVisit = deserialiser.object(fromRepresentation: dicVisit, mapping: mapping)
                            dicVisit["visitType"] = VisitType.planedvisit
                            self.aBeatplanvisitList.append(objVisit)
                            if let objVisit =  objVisit  as? PlannVisit{
                                self.aVisitsFlwups.append(objVisit)
                            }
                            
                        }else{
                            
                            
                        }
                    }
                    
                    self.fetchActivityFollowUps()
                    
                }else{
                    
                    self.fetchActivityFollowUps()
                }
                self.tblSalesPlan.reloadData()
            }
            else if(error.code == 0){
                self.fetchActivityFollowUps()
                self.tblSalesPlan.makeToast(message)
            }else{
                
                self.tabBarController?.selectedViewController?.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription) //Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription
            }
        }
    }
    
    func fetchActivityFollowUps(){
        SVProgressHUD.show(withStatus: "Loading")
        var param = Common.returndefaultparameter()
        let acticityjson = ["CreatedBy":SalesPlanHome.selectedUserID,"CompanyID":self.activeuser?.company?.iD ?? 0] as [String : Any]
        param["getactivityjson"] = Common.json(from: acticityjson)
        let strDate = String.init(format: "%@ 18:29:00", SalesPlanHome.selectedDate)
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
        
        param["gettime"] = Common.json(from: ["EndDate":strenddate])
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetActivityfollowups, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() ==  Constant.SucessResponseFromServer){
                if(responseType == ResponseType.arr){
                    let arrOfActivityVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                    self.aVisitsFlwupsActivity.removeAll()
                    if(arrOfActivityVisit.count > 0){
                        for actv in arrOfActivityVisit{
                            let activityvisitobj = Activitymodel().initwithdic(dict: actv)
                            var activity = actv
                            activity["visitType"] = VisitType.activityvisit
                            
                            self.aBeatplanvisitList.append(activityvisitobj)
                            self.aVisitsFlwupsActivity.append(activityvisitobj)
                            
                        }
                        self.recordtillbeatplanInt = (self.aVisitsFlwups.count + self.aVisitsFlwupscoldcall.count+self.aVisitsFlwupsActivity.count)
                        // currentRecord =  currentRecord + self.aVisitsFlwupsActivity.count
                        self.fetchBeatPlanFoolowup()
                    }else{
                        
                        self.fetchBeatPlanFoolowup()
                    }
                }else{
                    self.fetchBeatPlanFoolowup()
                }
                self.tblSalesPlan.reloadData()
                
            }
            else{
                self.fetchBeatPlanFoolowup()
                self.tabBarController?.selectedViewController?.view?.makeToast(message)
            }
        }
    }
    
    func fetchBeatPlanFoolowup(){
        SVProgressHUD.show(withStatus: "Loading")
        var param = Common.returndefaultparameter()
        let beatplanjson = ["CreatedBy":SalesPlanHome.selectedUserID,"CompanyID":self.activeuser?.company?.iD ?? 0] as [String : Any]
        param["getBeatPlanjson"] = Common.json(from: beatplanjson)
        let strDate = String.init(format: "%@ 18:29:00", SalesPlanHome.selectedDate)
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
        
        param["gettime"] = Common.json(from: ["EndDate":strenddate])
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetBeatplanFollowupForSalesPlan, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() ==  Constant.SucessResponseFromServer){
                if(responseType == ResponseType.arr){
                    let arrOFBeatVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                    self.aVisitsFlwupsBeatPlan.removeAll()
                    if(arrOFBeatVisit.count > 0){
                        for bpv in arrOFBeatVisit{
                            let beatplanvisitobj = BeatPlan.init(bpv)
                            
                            var beatplanvisit = bpv
                            beatplanvisit["visitType"] = VisitType.beatplan
                            self.aBeatplanvisitList.append(beatplanvisitobj)
                            self.aVisitsFlwupsBeatPlan.append(beatplanvisitobj)
                        }
                        
                    }
                }else{
                    print(arr)
                }
                
                //
                self.tblSalesPlan.reloadData()
                self.fetchLeads()
            }
            else if(error.code == 0){
                self.tblSalesPlan.reloadData()
                self.fetchLeads()
                self.tblSalesPlan.makeToast(message)
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
            
        }
        
    }
    
    
    func fetchLeads(){
        SVProgressHUD.show(withStatus:"Loading")
        var param = Common.returndefaultparameter()
        let beatplanjson = ["CreatedBy":SalesPlanHome.selectedUserID,"CompanyID":self.activeuser?.company?.iD ?? 0] as [String : Any]
        param["getleadjson"] = Common.json(from: beatplanjson)
        let strDate = String.init(format: "%@ 18:29:00", SalesPlanHome.selectedDate)
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
        
        param["gettime"] = Common.json(from: ["EndDate":strenddate])
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetLeadFollowUps, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() ==  Constant.SucessResponseFromServer){
                print(responseType)
                if(responseType == ResponseType.arr){
                    if  let arrOfLead = arr as? [String:Any] {
                        print(arrOfLead)
                    }
                }
                self.tblSalesPlan.reloadData()
            }else if(error.code == 0){
                self.tblSalesPlan.reloadData()
                self.tblSalesPlan.makeToast(message)
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
    }
    
    func getLeadDetailsFor(model:SalesPlanModel,leadId:NSNumber,ForAction:String){
        var jsonlead = [String:Any]()
        jsonlead["ID"] = leadId
        jsonlead["CompanyID"] = self.activeuser?.company?.iD
        jsonlead["CreatedBy"] = self.activeuser?.userID
        var param = Common.returndefaultparameter()
        param["getleadjson"] = Common.returnjsonstring(dic: jsonlead)
        //        RestAPIManager.httpRequest("getalead", .get
        //                                   , parameters: param, isTeamWorkUrl: true, isFull: false) { [self] response, status, error in
        //            if let res = response as? [String: Any]{
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetLeadDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
                let arrLead = arr as? [String:Any] ?? [String:Any]()
                MagicalRecord.save({ (localContext) in
                    let arrlead = FEMDeserializer.collection(fromRepresentation: [arrLead], mapping: Lead.defaultmapping(), context: localContext)
                    print(arrlead)
                    
                }, completion: { (contextdidsave, error) in
                    
                    if let objLead  = Lead.getLeadByID(Id: leadId.intValue) as? Lead{
                        //   planvisit = planvisit1
                        if(ForAction == "LeadDetail"){
                            //                            if(model.isCheckedIn){
                            //
                            //                            }else{
                            //
                            //                            }
                            self.selectedlead =  objLead
                            
                            if   let  firstinfluencerid = objLead.influencerID as? Int64{
                                if let secondinflencerid = objLead.secondInfluencerID as? Int64{
                                    
                                    
                                    if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.influencerID ?? 0)){
                                        self.arrOfListInfluencer.append(firstinfluencer)
                                        self.arrOfSelectedInfluerncer.append(firstinfluencer)
                                    }
                                    if  let secondinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.secondInfluencerID ?? 0)){
                                        self.arrOfListInfluencer.append(secondinfluencer)
                                    }
                                }
                                //            }else{
                                //                if(arrOfListInfluencer.count == 0){
                                //                if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.influencerID ?? 0)){
                                //                  arrOfListInfluencer.append(firstinfluencer)
                                //              self.arrOfSelectedInfluerncer.append(firstinfluencer)
                                //                        }
                                //                }
                                //            }
                            }
                            
                            if( model.checkInTime?.count ?? 0 > 0){
                                if(self.selectedlead.leadCheckInOutList.count > 0){
                                    if let lastcheckin =  objLead.leadCheckInOutList[0] as? LeadCheckInOutList{
                                        LeadCheckinCheckout.verifyLeadCheckoutAddress = false
                                        LeadCheckinCheckout().checkoutLead(leadstatus: 0, lat: NSNumber.init(value:self.currentCoordinate.latitude), long: NSNumber.init(value:self.currentCoordinate.longitude), objlead: objLead, cust: lastcheckin.checkInFrom , viewcontroller: self)
                                    }
                                }else{
                                    Utils.toastmsg(message: "Please relog in or sync", view: self.view)
                                }
                            }else if((model.checkInTime?.count == 0) && (self.arrOfListInfluencer.count == 0)){
                                LeadCheckinCheckout.verifyAddress = false
                                
                                LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:self.currentCoordinate.latitude), long: NSNumber.init(value:self.currentCoordinate.longitude), objlead: objLead, cust: "C" , viewcontroller: self.parent ?? self)
                            }else{
                                
                                
                                if((self.activesetting.influencerInLead == NSNumber.init(value:1)) && (objLead.influencerID > 0)){
                                    // let custPopup
                                    self.popup =    Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                                    self.popup?.isFromSalesOrder =  false
                                    self.popup?.modalPresentationStyle = .overCurrentContext
                                    self.popup?.strTitle = "To"
                                    self.popup?.nonmandatorydelegate = self
                                    self.popup?.arrOfCustomerClass = self.arrOfLeadCheckinoption
                                    self.popup?.arrOfSelectedClass = self.arrOfSelectedLeadCheckinoption
                                    self.popup?.strLeftTitle = "OK"
                                    self.popup?.strRightTitle = "Cancel"
                                    self.popup?.parentViewOfPopup = self.view
                                    self.popup?.selectionmode = SelectionMode.single
                                    self.popup?.isSearchBarRequire = false
                                    self.popup?.viewfor = ViewFor.customerClass
                                    self.popup?.isFilterRequire = false
                                    Utils.addShadow(view: self.view)
                                    
                                    //Utils.addShadow(view: self.view.superview ?? self.view)
                                    self.present(self.popup!, animated: false, completion: nil)
                                    
                                }else{
                                    LeadCheckinCheckout.verifyAddress = false
                                    
                                    LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:self.currentCoordinate.latitude), long: NSNumber.init(value:self.currentCoordinate.longitude), objlead: objLead, cust: "C" , viewcontroller: self.parent ?? self)
                                }
                            }
                        }
                        else if(ForAction == "Detail"){
                            if   let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail
                            {
                                leadDetail.redirectTo = 0
                                leadDetail.lead = objLead //arrOfplanvisit[indexPath.row]
                                //                                if let status =  visitDetail.planvisit?.visitStatusID {
                                //                                    if(status == 3){
                                //                                        visitDetail.visitType = VisitType.manualvisit
                                //                                    }else{
                                //                                        visitDetail.visitType = VisitType.planedvisit
                                //                                    }
                                //
                                //                                }else{
                                //                                    visitDetail.visitType = VisitType.planedvisit
                                //                                }
                                self.navigationController?.pushViewController(leadDetail, animated: true)
                            }
                        }else if(ForAction == "Checkin"){
                            self.selectedlead =  objLead
                            
                            if   let  firstinfluencerid = objLead.influencerID as? Int64{
                                if let secondinflencerid = objLead.secondInfluencerID as? Int64{
                                    
                                    
                                    if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.influencerID ?? 0)){
                                        self.arrOfListInfluencer.append(firstinfluencer)
                                        self.arrOfSelectedInfluerncer.append(firstinfluencer)
                                    }
                                    if  let secondinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.secondInfluencerID ?? 0)){
                                        self.arrOfListInfluencer.append(secondinfluencer)
                                    }
                                }
                                //            }else{
                                //                if(arrOfListInfluencer.count == 0){
                                //                if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.influencerID ?? 0)){
                                //                  arrOfListInfluencer.append(firstinfluencer)
                                //              self.arrOfSelectedInfluerncer.append(firstinfluencer)
                                //                        }
                                //                }
                                //            }
                            }
                            
                            if( model.checkInTime?.count ?? 0 > 0){
                                if(self.selectedlead.leadCheckInOutList.count > 0){
                                    if let lastcheckin =  objLead.leadCheckInOutList[0] as? LeadCheckInOutList{
                                        LeadCheckinCheckout.verifyLeadCheckoutAddress = false
                                        LeadCheckinCheckout().checkoutLead(leadstatus: 0, lat: NSNumber.init(value:self.currentCoordinate.latitude), long: NSNumber.init(value:self.currentCoordinate.longitude), objlead: objLead, cust: lastcheckin.checkInFrom , viewcontroller: self)
                                    }
                                }else{
                                    Utils.toastmsg(message: "Please relog in or sync", view: self.view)
                                }
                                
                            }else if((model.checkInTime?.count == 0) && (self.arrOfListInfluencer.count == 0)){
                                LeadCheckinCheckout.verifyAddress = false
                                
                                LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:self.currentCoordinate.latitude), long: NSNumber.init(value:self.currentCoordinate.longitude), objlead: objLead, cust: "C" , viewcontroller: self.parent ?? self)
                            }else{
                                
                                
                                if((self.activesetting.influencerInLead == NSNumber.init(value:1)) && (objLead.influencerID > 0)){
                                    // let custPopup
                                    self.popup =    Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                                    self.popup?.isFromSalesOrder =  false
                                    self.popup?.modalPresentationStyle = .overCurrentContext
                                    self.popup?.strTitle = "To"
                                    self.popup?.nonmandatorydelegate = self
                                    self.popup?.arrOfCustomerClass = self.arrOfLeadCheckinoption
                                    self.popup?.arrOfSelectedClass = self.arrOfSelectedLeadCheckinoption
                                    self.popup?.strLeftTitle = "OK"
                                    self.popup?.strRightTitle = "Cancel"
                                    self.popup?.parentViewOfPopup = self.view
                                    self.popup?.selectionmode = SelectionMode.single
                                    self.popup?.isSearchBarRequire = false
                                    self.popup?.viewfor = ViewFor.customerClass
                                    self.popup?.isFilterRequire = false
                                    Utils.addShadow(view: self.view)
                                    
                                    //Utils.addShadow(view: self.view.superview ?? self.view)
                                    self.present(self.popup!, animated: false, completion: nil)
                                    
                                }else{
                                    LeadCheckinCheckout.verifyAddress = false
                                    
                                    LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:self.currentCoordinate.latitude), long: NSNumber.init(value:self.currentCoordinate.longitude), objlead: objLead, cust: "C" , viewcontroller: self.parent ?? self)
                                }
                            }
                        }else if(ForAction == "Report"){
                            if  let leadupdatestatus = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadStatusUpdate) as? UpdateLeadStatus{
                                if let leadobj = Lead.getLeadByID(Id: leadId.intValue){
                                    leadupdatestatus.objLead = leadobj
                                }
                                self.navigationController?.pushViewController(leadupdatestatus, animated: true)
                            }
                        }else  if(ForAction == "Order"){
                            if let leadobj = Lead.getLeadByID(Id: leadId.intValue){
                                if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                                    
                                    guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: leadobj.customerID ?? 0)), cust.statusID == 2 else {
                                        Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""),view:self.view)
                                        return
                                    }
                                    vc.lead = leadobj
                                    self.navigationController!.pushViewController(vc, animated: true)
                                }
                                
                            }
                        }
                    }else{
                        self.tblSalesPlan.makeToast("can not get lead detail")
                    }
                })
            }else {
                Utils.toastmsg(message:error.localizedDescription,view:self.view)
            }
        }
    }
    func getActivityDetail(activityId:NSNumber,ForAction:String,model:SalesPlanModel){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        var dicActivity = [String:Any]()
        dicActivity["CompanyID"] = self.activeuser?.company?.iD
        dicActivity["CreatedBy"] = self.activeuser?.userID
        dicActivity["ID"] = activityId
        param["getPlannedActivityjson"] = Common.returnjsonstring(dic: dicActivity)
        //        param["PageNo"] = ActivityList.activityPageNo
        //        param["PageSize"] = ActivityList.activityPagesize
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetPlannedActivity, method: Apicallmethod.get)
        { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                let arrOfActivity = arr as? [[String:Any]] ?? [[String:Any]]()
                var mutArrOfActivity = [[String:Any]]()
                
                for activity in arrOfActivity{
                    print("dic of Activity  = \(activity)")
                    
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
                if let activityfromdatabase = Activity().getActivityFromId(userID: activityId){
                    if(ForAction == "Detail" || ForAction == "Report"){
                        if let activitydetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityDetail) as? ActivityDetail{//arrActivity[indexPath.row]
                            
                            activitydetail.activitymodelInDetail = activityfromdatabase
                            
                            
                            //activitydetail.activitymodelInDetail =  activity//arrActivity[indexPath.row]
                            self.navigationController?.pushViewController(activitydetail, animated: true)
                            
                        }
                    }else{
                        if(model.checkInTime?.count ?? 0 > 0){
                            ActivityCheckinCheckoutClass().activityCheckout(lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), viewcontroller: self, activityID:model.modulePrimaryID)
                        }else{
                            //                    ActivityCheckinCheckoutClass().activityCheckin(lat: NSNumber.init(value: currentCoordinate.latitude), long: NSNumber.init(value: currentCoordinate.longitude), viewcontroller: self, activityID: NSNumber.init(value:aid))
                            
                            ActivityCheckinCheckoutClass().activityCheckin(lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), viewcontroller: self, activityID: model.modulePrimaryID)
                        }
                    }
                }
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
    }
    func getplanvisitDetial(visitId:NSNumber,ForAction:String, model:SalesPlanModel ) {
        /*
         visitStepsStatusCheck(visitType:
         NSMutableDictionary *jsonParameter = [NSMutableDictionary new];
         [jsonParameter setObject:@(account.company_info.company_id) forKey:@"CompanyID"];
         [jsonParameter setObject:@(obj.user_id) forKey:@"CreatedBy"];
         [jsonParameter setObject:@(objPlan.iD) forKey:@"ID"];
         
         NSMutableDictionary *maindict = [NSMutableDictionary new];
         [maindict setObject:[jsonParameter rs_jsonStringWithPrettyPrint:YES] forKey:@"getPlannedVisitsJson"];
         [maindict setObject:account.securityToken forKey:@"TokenID"];
         [maindict setObject:@(account.user_id) forKey:@"UserID"];
         [maindict setObject:@(account.company_info.company_id) forKey:@"CompanyID"];
         [maindict setObject:APPLICATION_TEAMWORK forKey:@"Application"];
         **/
        var param = Common.returndefaultparameter()
        let json = ["CompanyID":self.activeuser?.company?.iD,"ID":visitId,"CreatedBy":self.activeuser?.userID]
        param["getPlannedVisitsJson"] =  Common.json(from: json)
        var planvisit:PlannVisit?
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetPlannedVisits, method: Apicallmethod.get){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() ==  Constant.SucessResponseFromServer){
                let  arrVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                
                MagicalRecord.save({ (localContext) in
                    let arrvisit = FEMDeserializer.collection(fromRepresentation: arrVisit, mapping: PlannVisit.defaultmapping(), context: localContext)
                    print(arrvisit)
                    
                }, completion: { (contextdidsave, error) in
                    
                    if let planvisit1  = PlannVisit.getVisit(visitID: visitId) as? PlannVisit{
                        self.activeplanvisit = planvisit1
                        planvisit = planvisit1
                        if(ForAction == "Detail"){
                            if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
                            {
                                visitDetail.redirectTo = 0
                                visitDetail.planvisit = planvisit1 //arrOfplanvisit[indexPath.row]
                                if let status =  visitDetail.planvisit?.visitStatusID {
                                    if(status == 3){
                                        visitDetail.visitType = VisitType.manualvisit
                                    }else{
                                        visitDetail.visitType = VisitType.planedvisit
                                    }
                                    
                                }else{
                                    visitDetail.visitType = VisitType.planedvisit
                                }
                                self.navigationController?.pushViewController(visitDetail, animated: true)
                            }
                        }else if(ForAction == "Checkin"){
                            if   let   objVisit = planvisit1 as? PlannVisit{
                                let (message,lastcheckinStatus) = Utils.latestCheckinDetailForPlanedVisit(visit: objVisit)
                                
                                if(lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
                                    SVProgressHUD.show()
                                    
                                    if(self.activesetting.visitStepsRequired ==  1 && self.arrvisitStep.count > 0){
                                        
                                        
                                        self.arrofmandatoryStep = self.arrvisitStep.filter{
                                            $0.mandatoryOrOptional == true
                                        }
                                        
                                        self.visitStepsStatusCheck(visitType: VisitType.planedvisit,planvisit: objVisit ,unplanvisit: UnplannedVisit(), model: model)
                                        
                                    }
                                    else{
                                        //check out
                                        self.finalCheckout(visitType:VisitType.planedvisit)
                                    }
                                }else{
                                    
                                    //check in
                                    VisitCheckinCheckout.verifyAddress = false
                                    VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: self.currentCoordinate.latitude) ,long:NSNumber.init(value:self.currentCoordinate.longitude), isVisitPlanned: VisitType.planedvisit, objplannedVisit: objVisit  ,objunplannedVisit:  UnplannedVisit(), visitid: NSNumber.init(value:objVisit.iD) ,viewcontroller:self.parent ?? self, addressID: NSNumber.init(value:0))
                                }
                            }
                        }else if(ForAction == "Report"){
                            let planvisit = planvisit1
                            if  let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
                                let visitreportList =  planvisit.visitStatusList
                                visitReport.visitType =  VisitType.planedvisit
                                visitReport.isFromVisit = false
                                if(visitreportList.count ?? 0 > 0){
                                    visitReport.isupdateReport = true
                                    visitReport.planVisit = planvisit
                                    
                                    visitReport.latestvisitreport = visitreportList.lastObject as? VisitStatus
                                }else{
                                    visitReport.isupdateReport = false
                                    visitReport.planVisit = planvisit
                                }
                                self.navigationController?.pushViewController(visitReport, animated: true)
                            }
                        }else  if(ForAction == "Order"){
                            if let planvisit = PlannVisit.getVisit(visitID:visitId) as? PlannVisit{
                                if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                                    
                                    guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: planvisit.customerID ?? 0)), cust.statusID == 2 else {
                                        Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""),view:self.view)
                                        return
                                    }
                                    vc.objVisit = planvisit
                                    
                                    self.navigationController!.pushViewController(vc, animated: true)
                                }
                            }
                        }
                        
                    }else{
                        print("not get visit ")
                        self.tblSalesPlan.makeToast("Please relogin first")
                    }
                })
                
            }else{
                
            }
            
        }
        
    }
    func unique<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    // MARK: - Dashboard's api
    //    func getvisitForDashboard(){
    //       SVProgressHUD.show(withStatus: "Loading")
    //
    //        self.apihelper.getVisitDashboard(strurl: ConstantURL.kWSUrlGetVisitReportForDay, selecteduserID: selectedUserID.stringValue, selectedDate: selectedDate) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
    //            SVProgressHUD.dismiss()
    //                if(status.lowercased() == Constant.SucessResponseFromServer){
    //                    print(responseType)
    //                      SVProgressHUD.dismiss()
    //                    if(responseType == ResponseType.arr){
    //                        self.arrVisits =  arr as? [[String:Any]] ?? [[String:Any]]()
    //
    //                        self.itemclick(userid: self.activeuser?.userID ?? 0)
    //                        if(BaseViewController.staticlowerUser.count == 0){
    //                            self.fetchuser{
    //        (arrOfuser,error) in
    //
    //    }
    //                        }
    //                    }
    //                }else if(error.code == 0){
    //
    //                         Utils.toastmsg(message:message,view: self.view)
    //                    }else{
    //
    //                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)  //Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription
    //                    }
    //        }
    //
    //    }
    
    //    func getLeadForDashoard(){
    //       SVProgressHUD.show(withStatus: "Loading")
    //              
    //        self.apihelper.getVisitDashboard(strurl: ConstantURL.kWSUrlGetLeadReportForDay, selecteduserID: selectedUserID.stringValue, selectedDate: selectedDate) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
    //                  SVProgressHUD.dismiss()
    //                if(status.lowercased() == Constant.SucessResponseFromServer){
    //                    print(responseType)
    //                       SVProgressHUD.dismiss()
    //                    if(responseType == ResponseType.arr){
    //                        self.arrLeads =  arr as? [[String:Any]] ?? [[String:Any]]()
    //                         self.itemclick(userid: self.activeuser?.userID ?? 0)
    //                        if(BaseViewController.staticlowerUser.count == 0){
    //                            self.fetchuser{
    //        (arrOfuser,error) in
    //
    //    }
    //                        }
    //                    }
    //                }else if(error.code == 0){
    //                        
    //                         Utils.toastmsg(message:message,view: self.view)
    //                    }else{
    //                      
    //                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)  //Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription
    //                    }
    //        }
    //    }
    
    //    func getOrderForDashoard(){
    //SVProgressHUD.show(withStatus: "Loading")
    //        self.apihelper.getVisitDashboard(strurl: ConstantURL.kWSUrlGetOrderReportForDay, selecteduserID: selectedUserID.stringValue, selectedDate: selectedDate) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
    //                        SVProgressHUD.dismiss()
    //                if(status.lowercased() == Constant.SucessResponseFromServer){
    //                    print(responseType)
    //                   
    //                    if(responseType == ResponseType.arr){
    //                        self.arrOrders =  arr as? [[String:Any]] ?? [[String:Any]]()
    //                         self.itemclick(userid: self.activeuser?.userID ?? 0)
    //                        if(BaseViewController.staticlowerUser.count == 0){
    //                            self.fetchuser{
    //        (arrOfuser,error) in
    //        
    //    }
    //                        }
    //                    }
    //                }else if(error.code == 0){
    //                 
    //                         Utils.toastmsg(message:message,view: self.view)
    //                    }else{
    //                  
    //                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)  //Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription
    //                    }
    //        }
    //    }
    //fetch user
    
    //    func fetchuser()->[CompanyUsers]{
    //        SVProgressHUD.setDefaultMaskType(.black)
    //        SVProgressHUD.show()
    //        apihelper.getLowerHierarchyUser { (arr,message,error,responseType) in
    //            SVProgressHUD.dismiss()
    //            if(error.code == 0){
    //                let arrOfUser = arr as? [String:Any] ?? [String:Any]()
    //                if(arrOfUser.count > 0){
    //                self.arrLowerLevelUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrOfUser["id"] as! [String])
    //                print(self.arrLowerLevelUser)
    //
    //
    //
    //            }else{
    //
    //                   Utils.toastmsg(message:message,view: self.view)
    //            }
    //        }
    //        }
    //        return self.arrLowerLevelUser
    //    }
    // MARK: - IBAction
    
    
    @IBAction func btnChangeLocationClicked(_ sender: UIButton) {
        if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
            self.navigationController?.pushViewController(attendance, animated: true)
        }
    }
    
    
    @IBAction func btnSelectUserClicked(_ sender: UIButton){
        self.arrOfExecutive =  BaseViewController.staticlowerUser
        
        if let currentuserid = self.activeuser?.userID{
            if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                if(!(self.arrOfExecutive?.contains(currentuser) ?? false)){
                    self.arrOfExecutive?.append(currentuser)
                }
            }
        }
        self.arrOfExecutive =  self.arrOfExecutive?.filter({ (companyuser) -> Bool in
            companyuser.role_id != 9
        })
        if((self.arrOfExecutive?.count ?? 0 > 0) && (self.arrOfSelectedExecutive.count == 0)){
            for exec in self.arrOfExecutive ?? [CompanyUsers](){
                if(exec.entity_id == self.activeuser?.userID){
                    self.arrOfSelectedExecutive.append(exec)
                }
            }
        }
        let sortedUserarr = self.arrOfExecutive?.sorted { (user1, user2) -> Bool in
            user1.firstName < user2.firstName
        }
        self.arrOfExecutive = sortedUserarr
        self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        self.popup?.isFromSalesOrder =  false
        self.popup?.modalPresentationStyle = .overCurrentContext
        self.popup?.strTitle = "Select User"
        self.popup?.nonmandatorydelegate = self
        
        self.popup?.arrOfExecutive = self.arrOfExecutive
        self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [CompanyUsers]()
        self.popup?.strLeftTitle = "OK"
        self.popup?.strRightTitle = "Cancel"
        self.popup?.selectionmode = SelectionMode.single
        self.popup?.isSearchBarRequire = false
        self.popup?.viewfor = ViewFor.companyuser
        self.popup?.isFilterRequire = false
        // popup.showAnimate()
        
        self.popup?.parentViewOfPopup = self.view
        Utils.addShadow(view: self.view)
        self.present(self.popup!, animated: false, completion: nil)
    }
    
    @IBAction func btnDailySalesPlanClicked(_ sender: UIButton) {
        if let navigation  = self.navigationController as? UINavigationController{
            
            //open visit list
            if  let salesplan = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardSalesPlan) as? SalesPlanHome{
                salesplan.isOnHome = false
                salesplan.isHome = false
                SalesPlanHome.screenselection =  Dashboardscreen.salesplan
                navigation.pushViewController(salesplan, animated: true)
                
            }
            
        }
    }
    @IBAction func btnDateClicked(_ sender: UIButton) {
        //        sender.isUserInteractionEnabled = false
        //  self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:datepickerAttendanceUserHistory, textfield: nil)
        
        self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:datepicker, textfield: nil, withDateMonth: false)
        if(SalesPlanHome.screenselection == Dashboardscreen.salesplan ||  SalesPlanHome.screenselection == nil){
            datepicker.minimumDate = Date()
        }else{
            datepicker.maximumDate = Date()
        }
        
    }
    
    @IBAction func btnCheckInClicked(_ sender: UIButton) {
        
        let dicdefaultSetting = Utils.getDefaultDicValue(key: Constant.kUserDefault)
        if(dicdefaultSetting.keys.count == 0){
            
            AttendanceCheckInCheckOut().loadDefaultSetting(view: self, completion: {_ in
                SVProgressHUD.show()
                self.checkinbtnAction()
            })
            
        }else{
            AttendanceCheckInCheckOut.defaultsetting = DefaultSettingModel().getdefaultSettingModelWithDic(dict: dicdefaultSetting)
            SVProgressHUD.show()
            self.checkinbtnAction()
        }
        
    }
    
    //    @IBAction func btnBackClicked(_ sender: UIButton) {
    //        if(screenselection == Dashboardscreen.dashboardvisit){
    //        let report = levelReport?.first
    //            createdBy = NSNumber.init(value:report?.managerID ?? 0)
    //        if(CompanyUsers().getUser(userId: createdBy ?? 0)?.role_id == NSNumber.init(value:6)){
    //            self.itemclick(userid: self.activeuser?.userID ?? 0)
    //        }else{
    //            self.itemclick(userid: createdBy ?? 0)
    //        }
    //        }else if(screenselection == Dashboardscreen.dashboardlead){
    //            let leadreport = levelLeadReport?.first
    //            createdBy = NSNumber.init(value:leadreport?.managerID ?? 0)
    //            if(CompanyUsers().getUser(userId: createdBy ?? 0)?.role_id == NSNumber.init(value:6)){
    //                self.itemclick(userid: self.activeuser?.userID ?? 0)
    //            }else{
    //                self.itemclick(userid: createdBy ?? 0)
    //            }
    //        }else if(screenselection == Dashboardscreen.dashboardorder){
    //            let orderreport = levelOrderReport?.first
    //            createdBy = NSNumber.init(value:orderreport?.managerID ?? 0)
    //            if(CompanyUsers().getUser(userId: createdBy ?? 0)?.role_id == NSNumber.init(value:6)){
    //                self.itemclick(userid: self.activeuser?.userID ?? 0)
    //            }else{
    //                self.itemclick(userid: createdBy ?? 0)
    //            }
    //        }
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SalesPlanHome:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    
    @objc func menuitemTouched(item: UPStackMenuItem,companymenu:CompanyMenus) {
        
        
        DispatchQueue.main.async{
            if(companymenu.menuID == 32){
                //add manualvisit
                if  let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
                    Common.skipVisitSelection = false
                    
                    addjointvisit.visitType = VisitType.manualvisit
                    
                    self.navigationController!.pushViewController(addjointvisit, animated: true)
                }
                
                
            }else if(companymenu.menuID == 29){
                if let addunplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddUnplanVisitView) as? AddUnPlanVisit {
                    
                    self.navigationController!.pushViewController(addunplanvisit, animated: true)
                }
            }else if(companymenu.menuID == 31){
                //corporate meeting
            }else if(companymenu.menuID == 33){
                //beat plan
                let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView
                self.navigationController!.pushViewController(beatplancontainer!, animated: true)
            }else if(companymenu.menuID == 28){
                if let addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddplanVisitView) as? AddPlanVisit{
                    //    self.dismiss(animated: false) {
                    self.navigationController!.pushViewController(addplanvisit, animated: true)
                }
                //plan a visit
            }else if(companymenu.menuID == 26){
                //Add Activity
                if let addActivity = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.AddActivity) as? AddActivity{
                    
                    self.navigationController?.pushViewController(addActivity, animated: true)
                }
            }else if(companymenu.menuID == 504){
                //kpi data
            }else if(companymenu.menuID == 30){
                //Direct Visit Check-IN
                if let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
                    Common.skipVisitSelection = false
                    
                    addjointvisit.visitType = VisitType.directvisitcheckin
                    
                    self.navigationController!.pushViewController(addjointvisit, animated: true)
                    
                }
            }else if(companymenu.menuID == 23){
                if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                    newlead.selectionFor = SelectionOf.visit
                    DispatchQueue.main.async{
                        self.navigationController?.pushViewController(newlead, animated: true)
                    }
                }
                //            if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname:Constant.VisitSelectionView)
                //                as? VisitSelectionViewController{
                //                // addplanvisit.selectionFor = SelectionOf.visit
                //                self.navigationController!.pushViewController(addplanvisit, animated: true)
                //            }
            }else if(companymenu.menuID == 24){
                if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                    newlead.selectionFor = SelectionOf.lead
                    DispatchQueue.main.async{
                        self.navigationController!.pushViewController(newlead, animated: true)
                    }
                }
            }else if(companymenu.menuID == 0){
                if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                    newlead.selectionFor = SelectionOf.visit
                    DispatchQueue.main.async{
                        self.navigationController!.pushViewController(newlead, animated: true)
                    }
                }
                //            if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname:Constant.VisitSelectionView)
                //                as? VisitSelectionViewController{
                //                // addplanvisit.selectionFor = SelectionOf.visit
                //                self.navigationController!.pushViewController(addplanvisit, animated: true)
                //            }
            }else if(companymenu.menuID == 22){
                if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                    DispatchQueue.main.async{
                        self.navigationController?.pushViewController(attendance, animated: true)
                    }
                }
            }          // let selectedcompanyid = CompanyMenus.
            else if(companymenu.menuID == 18){
                if let objexcel = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ExcelReport) as? ExcelReport{
                    DispatchQueue.main.async{
                        self.navigationController?.pushViewController(objexcel, animated: true)
                    }
                }
            }
            else if(item.title.lowercased() == "visit"){
                if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                    newlead.selectionFor = SelectionOf.visit
                    DispatchQueue.main.async{
                        self.navigationController!.pushViewController(newlead, animated: true)
                    }
                }
                //            if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname:Constant.VisitSelectionView)
                //                as? VisitSelectionViewController{
                //                //   addplanvisit.selectionFor = SelectionOf.visit
                //                self.navigationController!.pushViewController(addplanvisit, animated: true)
                //            }
                
            }else if(item.title.lowercased() == "new beat route"){
                
            }else if(item.title.lowercased() == "lead"){
                if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                    newlead.selectionFor = SelectionOf.lead
                    DispatchQueue.main.async{
                        self.navigationController!.pushViewController(newlead, animated: true)
                    }
                }
            }else if(item.title.lowercased() == "beat plan"){
                if let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView{
                    DispatchQueue.main.async{
                        self.navigationController!.pushViewController(beatplancontainer, animated: true)
                    }
                }
            }else if(companymenu.menuID == 25){
                print("Sales Order")
                if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                    DispatchQueue.main.async{
                        self.navigationController!.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func datepickerSelectionDone(){
        datepicker.removeFromSuperview()
        Utils.removeShadow(view: self.view)
        SalesPlanHome.selectedDate =  Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepicker.date)
        btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepicker.date), for: .normal)
        
        if(SalesPlanHome.screenselection == Dashboardscreen.salesplan || SalesPlanHome.screenselection == nil ){
            self.getDailyReportData()
            
            
        }
        carbonTabSwipeNavigationSalesPlan?.setCurrentTabIndex(0, withAnimation: true)
        if(selectedindex == 0){
            NotificationCenter.default.post(name: Notification.Name("DashboardUpdated"), object:[])
            
            if let dashvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardVisit ) as? DashboardVisit
            {
                self.salesdelegate?.dateselectionsalesplandone(date: datepicker.date)
                //dashvisit.getvisitForDashboard()
            }
        }else if(selectedindex == 1){
            NotificationCenter.default.post(name: Notification.Name("DashboardLeadUpdated"), object:[])
            
            
            //            if let dashlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardLead ) as? DashboardLead
            //            {
            //dashlead.getLeadForDashoard()
            self.salesdelegate?.dateselectionsalesplandone(date: datepicker.date)
            // }
        }else if(selectedindex == 2){
            NotificationCenter.default.post(name: Notification.Name("DashboardOrderUpdated"), object:[])
            //   if let dashorder = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardOrder) as? DashboardOrders
            //{
            self.salesdelegate?.dateselectionsalesplandone(date: datepicker.date)
            // }
        }else{
            self.salesdelegate?.dateselectionsalesplandone(date: datepicker.date)
        }
        //            if(screenselection == Dashboardscreen.dashboardvisit){
        //            if let dashvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardVisit ) as? DashboardVisit
        //                       {
        //            dashvisit.getvisitForDashboard()
        //            }
        //        }else if(screenselection == Dashboardscreen.dashboardlead){
        //            if let dashlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardLead ) as? DashboardLead{
        //            dashlead.getLeadForDashoard()
        //            }
        //        }else if(screenselection == Dashboardscreen.dashboardorder){
        //            self.getOrderForDashoard()
        //        }
        
    }
    
    func cancelbtnTapped() {
        Utils.removeShadow(view: self.view)
        datepicker.removeFromSuperview()
    }
    
    
    
    func reloadTapped(){
        self.reloadTappedStatus  = true
        
        self.arrSalesplanmodelForDisplay = self.arrSalesplanmodelAll
        print("count = \(self.arrSalesplanmodelForDisplay.count)")
        
        self.tblSalesPlan.reloadData()
        if(SalesPlanHome.screenselection == Dashboardscreen.salesplan || SalesPlanHome.screenselection == nil ){
            self.getDailyReportData()
            
        }
        if(selectedindex == 0){
            NotificationCenter.default.post(name: Notification.Name("DashboardUpdated"), object:[])
            
            if let dashvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardVisit ) as? DashboardVisit
            {
                self.salesdelegate?.dateselectionsalesplandone(date: datepicker.date)
                //dashvisit.getvisitForDashboard()
            }
        }else if(selectedindex == 1){
            NotificationCenter.default.post(name: Notification.Name("DashboardLeadUpdated"), object:[])
            
            
            //            if let dashlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardLead ) as? DashboardLead
            //            {
            //dashlead.getLeadForDashoard()
            self.salesdelegate?.dateselectionsalesplandone(date: datepicker.date)
            // }
        }else if(selectedindex == 2){
            NotificationCenter.default.post(name: Notification.Name("DashboardOrderUpdated"), object:[])
            //   if let dashorder = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardOrder) as? DashboardOrders
            //{
            self.salesdelegate?.dateselectionsalesplandone(date: datepicker.date)
            // }
        }else{
            self.salesdelegate?.dateselectionsalesplandone(date: datepicker.date)
        }
    }
    func notificationTapped() {
        
        
        if let notificationcontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.NotificationContainer) as? NotificationContainer {
            self.navigationController?.pushViewController(notificationcontainer, animated: true)
        }
        
        print("notification tapped")
        
    }
    
    
    func syncTapped(){
        if  let syncvc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: "syncvc") as? Sync{
            Sync.isFromDashboard = true
            self.navigationController?.pushViewController(syncvc, animated: true)
        }
    }
    
    @objc func  showCameraPicker(_ notification:Notification) {
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.delegate = self //parentviewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            //       self.present(picker, animated: true, completion: nil)
            self.present(picker, animated: true) {
            }
        }
        //     present(picker, animated: true, completion: nil)
    }
}

extension SalesPlanHome:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(SalesPlanHome.screenselection == Dashboardscreen.salesplan || SalesPlanHome.screenselection == nil){
            
            return self.arrSalesplanmodelForDisplay.count
            // return aBeatplanvisitList.count
        }else if(SalesPlanHome.screenselection == Dashboardscreen.dashboardvisit){
            return levelReport?.count ?? 0
        }else if(SalesPlanHome.screenselection == Dashboardscreen.dashboardlead){
            return levelLeadReport?.count ?? 0
        }else if(SalesPlanHome.screenselection == Dashboardscreen.dashboardorder){
            return levelOrderReport?.count ?? 0
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(SalesPlanHome.screenselection == Dashboardscreen.salesplan || SalesPlanHome.screenselection == nil){
            cell = tableView.dequeueReusableCell(withIdentifier: Constant.SalesPlanCell, for: indexPath) as? SalesPlanCell
            
            
            cell.salesplandelegate = self
            // cell.vwTitleInfo.setShadow()
            cell.vwTitleInfo.tag = indexPath.row
            cell.btnLocation.tag = indexPath.row
            cell.btnVisitDetail.tag = indexPath.row
            cell.btnVisitReport.tag = indexPath.row
            cell.btnVisitCheckin.tag = indexPath.row
            cell.btnOrderFrom.tag = indexPath.row
            let model = self.arrSalesplanmodelForDisplay[indexPath.row]
            let modelType = model.detailType
            if(self.arrexpandecell.contains(indexPath) && modelType == 2 || modelType == 3){
                cell.lblCompanyName.isUserInteractionEnabled = true
                cell.lblCompanyName.tag = indexPath.row
                cell.lblCompanyName.contentHuggingPriority(for: NSLayoutConstraint.Axis(rawValue: 100)!)
                let gestureCustName = UITapGestureRecognizer.init(target:self , action: #selector(custNameTapped(_:)))
                cell.lblCompanyName.addGestureRecognizer(gestureCustName)
                
            }else{
                cell.lblCompanyName.isUserInteractionEnabled = false
            }
            
            if(modelType == 1){
                //attendance type
                
                
                cell.vwBtnWhatsApp.isHidden = true
                cell.vwBtnWhatsApp.isUserInteractionEnabled = false
                
                
                cell.vwTitleInfo.setShadow()
                cell.setColdCallData(model: model, expaned: expandedIndex, currentindexpath: indexPath)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
                
                gesture.numberOfTouchesRequired = 1
                cell.vwTitleInfo.isUserInteractionEnabled = true
                // cell.vwTitleInfo.tag
                cell.vwTitleInfo.addGestureRecognizer(gesture)
                
                if(self.arrexpandecell.contains(indexPath)){
                    cell.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
                    cell.lblIndicator.backgroundColor = UIColor.white
                    cell.lblIndicator.textColor = UIColor.graphYellowColor
                    cell.vwTitleInfo.backgroundColor =  UIColor.graphYellowColor
                    cell.lblCompanyName.textColor = UIColor.white
                    cell.lblTime.textColor = UIColor.white
                    cell.vwContactInfo.isHidden = false
                    cell.vwLocationInfo.isHidden = false
                    cell.stackDetailInfo.isHidden = true
                }else{
                    cell.vwTitleInfo.setShadow()
                    cell.lblIndicator.backgroundColor = UIColor.graphYellowColor
                    cell.lblIndicator.textColor = UIColor.white
                    cell.vwTitleInfo.backgroundColor = UIColor.white
                    cell.lblCompanyName.textColor = UIColor.black
                    cell.lblTime.textColor = UIColor.black
                    cell.vwContactInfo.isHidden = true
                    cell.vwLocationInfo.isHidden = true
                    cell.stackDetailInfo.isHidden = true
                }
                
                
                return cell
            }else if(modelType == 2){
                //visit planned
                print(indexPath.row)
                cell.vwTitleInfo.setShadow()
                
                cell.vwBtnWhatsApp.isHidden = false
                cell.vwBtnWhatsApp.isUserInteractionEnabled = true
                cell.setPlannedVisitData(visit: model ,expaned:expandedIndex , currentindexpath:indexPath){(visttype) in
                    
                }
                if(self.arrexpandecell.contains(indexPath)){
                    self.cell.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
                    //                    self.cell.vwTitleInfo.setShadow()
                    self.cell.lblIndicator.backgroundColor = UIColor.white
                    self.cell.lblIndicator.textColor = UIColor.graphDarkCyanColor
                    self.cell.vwTitleInfo.backgroundColor =  UIColor.graphDarkCyanColor
                    self.cell.lblCompanyName.textColor = UIColor.white
                    self.cell.lblTime.textColor = UIColor.white
                    self.cell.btnEditCustomer.isHidden = false
                    self.cell.vwContactInfo.isHidden = false
                    self.cell.vwLocationInfo.isHidden = false
                    self.cell.stackDetailInfo.isHidden = false
                    self.cell.contentView.layoutIfNeeded()
                    let attrs = [
                        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                        
                        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
                    let buttonplandetailStr = NSMutableAttributedString(string:self.cell.lblCompanyName.text ?? "", attributes:attrs)
                    self.cell.lblCompanyName.attributedText = buttonplandetailStr
                }
                
                else{
                    //   self.isexpand = false
                    self.cell.vwParentView.setShadow()
                    self.cell.lblIndicator.backgroundColor = UIColor.graphDarkCyanColor
                    self.cell.lblIndicator.textColor = UIColor.white
                    self.cell.vwTitleInfo.backgroundColor = UIColor.white
                    self.cell.lblCompanyName.textColor = UIColor.black
                    self.cell.lblTime.textColor = UIColor.black
                    self.cell.vwContactInfo.isHidden = true
                    self.cell.vwLocationInfo.isHidden = true
                    self.cell.stackDetailInfo.isHidden = true
                    self.cell.btnEditCustomer.isHidden = true
                }
                
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
                //gesture.numberOfTapsRequired = 1
                gesture.numberOfTouchesRequired = 1
                cell.vwTitleInfo.isUserInteractionEnabled = true
                
                cell.vwTitleInfo.addGestureRecognizer(gesture)
                if let visit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                    if let lateststatus = visit.visitStatusList.firstObject as? VisitStatus{
                        if let nextAction = lateststatus.nextActionTime{
                            //                    dateFormatter.dateFormat = "dd-MM-yyyy"
                            //                    let nextactionDate = dateFormatter.date(from: nextAction)
                            let nextactionDate  =  Utils.getDateBigFormatToDefaultFormat(date: nextAction ?? "2021/10/18 10:18:18", format: "yyyy/MM/dd")
                            
                            if(nextactionDate == SalesPlanHome.selectedDate){
                                var strnt = ""
                                if let strn = Utils.getDateBigFormatToDefaultFormat(date: lateststatus.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                                    strnt = strn
                                }
                                let dateFormater = DateFormatter()
                                dateFormater.dateFormat =  "yyyy/MM/dd HH:mm:ss"
                                
                                cell.lblTime.text = (lateststatus.nextActionTime?.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a"): ""
                            }
                        }
                    }
                    if  let lastvisitcheckin = visit.checkInOutData.firstObject as? VisitCheckInOutList{
                        print(lastvisitcheckin.checkOutTime)
                        
                        self.dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
                        let dateoflastcheckin = self.dateFormatter.date(from: lastvisitcheckin.checkInTime)
                        let date  = Utils.getDateBigFormatToDefaultFormat(date: lastvisitcheckin.checkInTime, format: "yyyy/MM/dd")//Utils.getDatestringWithGMT(gmtDateString: lastvisitcheckin.checkInTime, format: "yyyy/mm/dd")
                        
                        if(date == SalesPlanHome.selectedDate){
                            
                            if let  checkout = lastvisitcheckin.checkOutTime as? String{
                                print("date is = \(date) and selected date is = \(SalesPlanHome.selectedDate) and check in time = \(lastvisitcheckin.checkInTime) ,  checkout time = \(checkout)")
                                
                                tblSalesPlan.beginUpdates()
                                
                                tblSalesPlan.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                                self.arrSalesplanmodelForDisplay.remove(at: indexPath.row)
                                tblSalesPlan.reloadData()
                                tblSalesPlan.endUpdates()
                                
                            }
                            else  if(lastvisitcheckin.checkInTime?.count ?? 0 > 0){
                                //  self.btnVisitDetail.setTitle("Check-out", for: .normal)
                                cell.lblCheckinTitle.text =  "Checkout"
                                cell.lblCheckin.isHidden = false
                                cell.btnCall.isHidden = true
                                var strcheckin = ""
                                if let strn = Utils.getDateBigFormatToDefaultFormat(date: lastvisitcheckin.checkInTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                                    strcheckin = strn
                                }
                                cell.lblCheckin.text =  String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: strcheckin, format: "hh:mm a"))")
                                
                                // self.lblCheckin.text = model.checkInTime
                            }else{
                                // self.btnVisitDetail.setTitle("Check-in", for: .normal)
                                cell.lblCheckinTitle.text =  "Checkin"
                                cell.lblCheckin.isHidden = true
                                cell.btnCall.isHidden =  false
                            }
                            
                            
                        }else{
                            cell.lblCheckinTitle.text =  "Checkin"
                            cell.lblCheckin.isHidden = true
                            cell.btnCall.isHidden =  false
                        }
                        
                    }
                }
                if(hidesalesorder){
                    cell.stkForOrder.isHidden = true
                }
                return cell
            }else if(modelType == 3){
                //lead
                cell.vwTitleInfo.setShadow()
                cell.vwBtnWhatsApp.isHidden = false
                cell.vwBtnWhatsApp.isUserInteractionEnabled = true
                
                cell.setLeadPlanData(model: model,expaned:expandedIndex , currentindexpath:indexPath)
                
                
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
                //gesture.numberOfTapsRequired = 1
                gesture.numberOfTouchesRequired = 1
                cell.vwTitleInfo.isUserInteractionEnabled = true
                
                cell.vwTitleInfo.addGestureRecognizer(gesture)
                if(self.arrexpandecell.contains(indexPath)){
                    cell.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
                    cell.lblIndicator.backgroundColor = UIColor.white
                    cell.lblIndicator.textColor = UIColor.graphDarkVioletColor
                    cell.vwTitleInfo.backgroundColor =  UIColor.graphDarkVioletColor
                    cell.lblCompanyName.textColor = UIColor.white
                    cell.lblTime.textColor = UIColor.white
                    
                    cell.vwContactInfo.isHidden = false
                    cell.vwLocationInfo.isHidden = false
                    cell.stackDetailInfo.isHidden = false
                    self.cell.btnEditCustomer.isHidden = false
                    let attrs = [
                        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                        
                        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
                    let buttonplandetailStr = NSMutableAttributedString(string:self.cell.lblCompanyName.text ?? "", attributes:attrs)
                    self.cell.lblCompanyName.attributedText = buttonplandetailStr
                }else{
                    cell.vwTitleInfo.setShadow()
                    cell.lblIndicator.backgroundColor = UIColor.graphDarkVioletColor
                    cell.lblIndicator.textColor = UIColor.white
                    cell.vwTitleInfo.backgroundColor = UIColor.white
                    cell.lblCompanyName.textColor = UIColor.black
                    cell.lblTime.textColor = UIColor.black
                    cell.vwContactInfo.isHidden = true
                    cell.vwLocationInfo.isHidden = true
                    cell.stackDetailInfo.isHidden = true
                    self.cell.btnEditCustomer.isHidden = true
                }
                if(hidesalesorder){
                    cell.stkForOrder.isHidden = true
                }
                return cell
            }else if(modelType == 4){
                //Activity
                cell.vwBtnWhatsApp.isHidden = true
                cell.vwBtnWhatsApp.isUserInteractionEnabled = false
                cell.vwTitleInfo.setShadow()
                cell.setActivityPlanData(model: model,expaned:expandedIndex , currentindexpath:indexPath)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
                //gesture.numberOfTapsRequired = 1
                gesture.numberOfTouchesRequired = 1
                cell.vwTitleInfo.isUserInteractionEnabled = true
                
                cell.vwTitleInfo.addGestureRecognizer(gesture)
                if(self.arrexpandecell.contains(indexPath)){
                    cell.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
                    if(model.checkInTime?.count ?? 0 > 0){
                        cell.lblCheckin.isHidden = false
                        cell.btnCall.isHidden = true
                    }
                    else{
                        cell.btnCall.isHidden = false
                        cell.lblCheckin.isHidden = true
                    }
                    cell.lblIndicator.backgroundColor = UIColor.white
                    cell.lblIndicator.textColor = UIColor.graphBlueColor
                    cell.vwTitleInfo.backgroundColor =  UIColor.graphBlueColor
                    cell.lblCompanyName.textColor = UIColor.white
                    cell.lblTime.textColor = UIColor.white
                    
                    cell.vwContactInfo.isHidden = false
                    cell.vwLocationInfo.isHidden = false
                    cell.stackDetailInfo.isHidden = false
                }else{
                    if(model.checkInTime?.count ?? 0 > 0){
                        cell.lblCheckin.isHidden = false
                    }
                    else{
                        cell.btnCall.isHidden = false
                    }
                    cell.vwTitleInfo.setShadow()
                    cell.lblIndicator.backgroundColor = UIColor.graphBlueColor
                    cell.lblIndicator.textColor = UIColor.white
                    cell.vwTitleInfo.backgroundColor = UIColor.white
                    cell.lblCompanyName.textColor = UIColor.black
                    cell.lblTime.textColor = UIColor.black
                    cell.vwContactInfo.isHidden = true
                    cell.vwLocationInfo.isHidden = true
                    cell.stackDetailInfo.isHidden = true
                }
                if(hidesalesorder){
                    cell.stkForOrder.isHidden = true
                }
                return cell
            }else if(modelType == 5){
                // unplaned visit
                cell.vwBtnWhatsApp.isHidden = true
                cell.vwBtnWhatsApp.isUserInteractionEnabled = false
                cell.vwTitleInfo.setShadow()
                cell.setUnplanVisitSalesData(model: model, expaned: expandedIndex, currentindexpath: indexPath)
                // cell.setunplanvisitSalesData(model: model,expaned:expandedIndex , currentindexpath:indexPath)
                
                if(model.isCheckedIn){
                    cell.lblCheckinTitle.text = "Checkout"
                }else{
                    cell.lblCheckinTitle.text = "Checkin"
                }
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
                //gesture.numberOfTapsRequired = 1
                gesture.numberOfTouchesRequired = 1
                cell.vwTitleInfo.isUserInteractionEnabled = true
                
                cell.vwTitleInfo.addGestureRecognizer(gesture)
                if(self.arrexpandecell.contains(indexPath)){
                    cell.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
                    cell.lblIndicator.backgroundColor = UIColor.white
                    cell.lblIndicator.textColor = UIColor.UnPlannedVisitIndicationcolor
                    cell.vwTitleInfo.backgroundColor =  UIColor.UnPlannedVisitIndicationcolor
                    cell.lblCompanyName.textColor = UIColor.white
                    cell.lblTime.textColor = UIColor.white
                    cell.vwContactInfo.isHidden = false
                    cell.vwLocationInfo.isHidden = false
                    cell.stackDetailInfo.isHidden = false
                }else{
                    cell.vwTitleInfo.setShadow()
                    cell.lblIndicator.backgroundColor = UIColor.UnPlannedVisitIndicationcolor
                    cell.lblIndicator.textColor = UIColor.white
                    cell.vwTitleInfo.backgroundColor = UIColor.white
                    cell.lblCompanyName.textColor = UIColor.black
                    cell.lblTime.textColor = UIColor.black
                    cell.vwContactInfo.isHidden = true
                    cell.vwLocationInfo.isHidden = true
                    cell.stackDetailInfo.isHidden = true
                }
                if(hidesalesorder){
                    cell.stkForOrder.isHidden = true
                }
                return cell
            }else if(modelType == 6){
                // beat plan
                
                cell.vwTitleInfo.setShadow()
                cell.setBeatPlanSalesData(model: model,expaned:expandedIndex , currentindexpath:indexPath)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
                //gesture.numberOfTapsRequired = 1
                gesture.numberOfTouchesRequired = 1
                cell.vwTitleInfo.isUserInteractionEnabled = true
                
                cell.vwTitleInfo.addGestureRecognizer(gesture)
                let gesturebeatplanDetail = UITapGestureRecognizer(target: self, action: #selector(self.handleBeatPlanTap(_:)))
                cell.lblAddressVisit.tag = indexPath.row
                gesturebeatplanDetail.numberOfTapsRequired = 1
                cell.lblAddressVisit.addGestureRecognizer(gesturebeatplanDetail)
                cell.lblAddressVisit.isUserInteractionEnabled = true
                //cell.setBeatplanvisitData(bvisit: beatVisit)
                if(self.arrexpandecell.contains(indexPath)){
                    cell.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
                    cell.lblIndicator.backgroundColor = UIColor.white
                    cell.lblIndicator.textColor = UIColor.graphYellowColor
                    cell.vwTitleInfo.backgroundColor =  UIColor.graphYellowColor
                    cell.lblCompanyName.textColor = UIColor.white
                    cell.lblTime.textColor = UIColor.white
                    cell.vwContactInfo.isHidden = false
                    cell.vwLocationInfo.isHidden = false
                    cell.stackDetailInfo.isHidden = true
                    self.cell.btnEditCustomer.isHidden = false
                }else{
                    cell.vwTitleInfo.setShadow()
                    cell.lblIndicator.backgroundColor = UIColor.graphYellowColor
                    cell.lblIndicator.textColor = UIColor.white
                    cell.vwTitleInfo.backgroundColor = UIColor.white
                    cell.lblCompanyName.textColor = UIColor.black
                    cell.lblTime.textColor = UIColor.black
                    cell.vwContactInfo.isHidden = true
                    cell.vwLocationInfo.isHidden = true
                    cell.stackDetailInfo.isHidden = true
                    self.cell.btnEditCustomer.isHidden = true
                }
                if(hidesalesorder){
                    cell.stkForOrder.isHidden = true
                }
                return cell
            }else if(modelType == 7){
                //collection
                cell.vwBtnWhatsApp.isHidden = true
                cell.vwBtnWhatsApp.isUserInteractionEnabled = false
                if let visitcollectcell = tableView.dequeueReusableCell(withIdentifier: Constant.VisitCollectionCell, for: indexPath) as? VisitCollectionCell{
                    visitcollectcell.selectionStyle
                    = UITableViewCell.SelectionStyle.none
                    
                    visitcollectcell.vwTitleInfo.setShadow()
                    
                    visitcollectcell.setCollectionData(obj: model,expaned:expandedIndex , currentindexpath:indexPath)
                    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCollectionTap(_:)))
                    //gesture.numberOfTapsRequired = 1
                    gesture.numberOfTouchesRequired = 1
                    visitcollectcell.vwTitleInfo.isUserInteractionEnabled = true
                    
                    visitcollectcell.vwTitleInfo.addGestureRecognizer(gesture)
                    
                    
                    if(self.arrexpandecell.contains(indexPath)){
                        visitcollectcell.vwParentView.setShadow()
                        visitcollectcell.lblIndicator.backgroundColor = UIColor.white
                        visitcollectcell.lblIndicator.textColor = UIColor.darkblueColor //UIColor.CollectionIndicaationcolor
                        visitcollectcell.vwTitleInfo.backgroundColor =  UIColor.darkblueColor //UIColor.CollectionIndicaationcolor
                        visitcollectcell.lblCompanyName.textColor = UIColor.white
                        visitcollectcell.lblTime.textColor = UIColor.white
                        visitcollectcell.vwCollection.isHidden = false
                        visitcollectcell.vwBalance.isHidden = false
                        visitcollectcell.vwCollectionPaymentmode.isHidden = false
                        // self.vwRefferance.isHidden = false
                        if let refferancevalue = model.referenceNo{
                            if(refferancevalue.count > 0){
                                visitcollectcell.vwRefferance.isHidden = false
                            }else{
                                visitcollectcell.vwRefferance.isHidden = true
                            }
                        }
                        self.contentView.layoutIfNeeded()
                    }else{
                        visitcollectcell.vwTitleInfo.setShadow()
                        visitcollectcell.lblIndicator.backgroundColor = UIColor.darkblueColor //UIColor.CollectionIndicaationcolor
                        visitcollectcell.lblIndicator.textColor = UIColor.white
                        visitcollectcell.vwTitleInfo.backgroundColor = UIColor.white
                        visitcollectcell.lblCompanyName.textColor = UIColor.black
                        visitcollectcell.lblTime.textColor = UIColor.black
                        visitcollectcell.vwCollection.isHidden = true
                        visitcollectcell.vwBalance.isHidden = true
                        visitcollectcell.vwCollectionPaymentmode.isHidden = true
                        visitcollectcell.vwRefferance.isHidden = true
                    }
                    // visit collection
                    
                    return visitcollectcell
                }else{
                    if(hidesalesorder){
                        cell.stkForOrder.isHidden = true
                    }
                    return cell
                }
            }else if(modelType == 8){
                // Cold calling
                return UITableViewCell()
                //                cell.setColdCallData(model: model,expaned:expandedIndex , currentindexpath:indexPath)
                //                if(hidesalesorder){
                //                    cell.stkForOrder.isHidden = true
                //                }
                //                return cell
            }
            else{
                if(hidesalesorder){
                    cell.stkForOrder.isHidden = true
                }
                return cell
            }
            
            
        }else if(SalesPlanHome.screenselection == Dashboardscreen.dashboardvisit){
            if let dashboardvisitcell = tableView.dequeueReusableCell(withIdentifier: "threelblhorizontal", for: indexPath) as? ThreeLblHorizontalCell{
                
                if let visitreport =  levelReport?[indexPath.row] as? VisitDashboardReport{
                    dashboardvisitcell.lbl1.text = visitreport.UserName
                    //  dashboardvisitcell.detailTextLabel?.text = String.init(format:"%@",visitreport?.PlannedVisit ?? "0")
                    dashboardvisitcell.setDashboardVisitData(report: visitreport, indexpath: indexPath)
                }
                
                
                
                return dashboardvisitcell
            }else{
                return cell
            }
        }else if(SalesPlanHome.screenselection == Dashboardscreen.dashboardlead){
            if let dashboardleadcell = tableView.dequeueReusableCell(withIdentifier: "threelblhorizontal", for: indexPath) as? ThreeLblHorizontalCell{
                
                if let leadreport =  levelLeadReport?[indexPath.row] as? LeadDashboardReport{
                    dashboardleadcell.lbl1.text = leadreport.UserName
                    //  dashboardvisitcell.detailTextLabel?.text = String.init(format:"%@",visitreport?.PlannedVisit ?? "0")
                    dashboardleadcell.setDashboardLeadData(leadReport: leadreport, indexpath: indexPath)
                }
                
                
                
                return dashboardleadcell
            }else{
                return cell
            }
        }else if(SalesPlanHome.screenselection == Dashboardscreen.dashboardorder){
            if let dashboardordercell = tableView.dequeueReusableCell(withIdentifier: "threelblhorizontal", for: indexPath) as? ThreeLblHorizontalCell{
                
                if let orderreport =  levelOrderReport?[indexPath.row] as? OrderDashboardReport{
                    dashboardordercell.lbl1.text = orderreport.UserName
                    //  dashboardvisitcell.detailTextLabel?.text = String.init(format:"%@",visitreport?.PlannedVisit ?? "0")
                    dashboardordercell.setDashboardOrderData(orderReport: orderreport, indexpath: indexPath)
                }
                
                
                
                return dashboardordercell
            }else{
                return cell
            }
        }else{
            if(hidesalesorder){
                cell.stkForOrder.isHidden = true
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        expandedIndex =  indexPath
        //        if(screenselection == Dashboardscreen.salesplan || screenselection == nil){
        //           // expandedIndex =  indexPath
        //            
        //            DispatchQueue.main.async {
        //              self.tblSalesPlan.reloadData()
        //             //   self.tblSalesPlan.reloadRows(at: [self.expandedIndex], with: UITableView.RowAnimation.fade)
        //            }
        //            }
        
        //        if(screenselection == Dashboardscreen.dashboardvisit){
        //            if let report = levelReport?[indexPath.row] as? VisitDashboardReport{
        //                if(report.ColorCode == NSInteger.init(CGFloat(2))){
        //                    self.itemclick(userid: NSNumber.init(value:report.UserID ?? 0))
        //                }else{
        //                    if let reportview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ReportList) as? Reports{
        //                        reportview.isHome = false
        //                self.navigationController?.pushViewController(reportview, animated: true)
        //                    }
        //
        //                }
        //            }
        //        }else
        //        if(screenselection == Dashboardscreen.dashboardlead){
        //            if let leadReport = levelLeadReport?[indexPath.row] as? LeadDashboardReport{
        //                if(leadReport.ColorCode == NSInteger.init(CGFloat(2))){
        //                    self.itemclick(userid: NSNumber.init(value:leadReport.UserID ?? 0))
        //                }else{
        //                    if let reportview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ReportList) as? Reports{
        //                          reportview.isHome = false
        //                self.navigationController?.pushViewController(reportview, animated: true)
        //                    }
        //
        //                }
        //            }
        //        }else
        //        if(screenselection == Dashboardscreen.dashboardorder){
        //            if let orderReport = levelOrderReport?[indexPath.row] as? OrderDashboardReport{
        //                if(orderReport.ColorCode == NSInteger.init(CGFloat(2))){
        //                    self.itemclick(userid: NSNumber.init(value:orderReport.UserID ?? 0))
        //                }else{
        //                    if let reportview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ReportList) as? Reports{
        //                          reportview.isHome = false
        //                self.navigationController?.pushViewController(reportview, animated: true)
        //                    }
        //
        //                }
        //            }
        //        }
    }
    
    
    /*  @objc func visitdetailTapped(sender:UIButton)->(){
     let model = self.arrSalesplanmodelForDisplay[sender.tag]
     if(model.detailType == 3){
     
     // Lead
     if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
     if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
     
     if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
     
     if(leadobj.influencerID > 0){
     
     }else{
     leadobj.influencerID =  0
     }
     if(leadobj.secondInfluencerID > 0){
     
     }else{
     leadobj.secondInfluencerID = 0
     }
     leadDetail.lead = leadobj
     }
     leadDetail.isHistory = false
     leadDetail.redirectTo =  0
     // leadDetail.lead =   arrOfLead[indexPath.row]
     //        visitDetail.planvisit = arrOfplanvisit[indexPath.row]
     //        if(visitDetail.planvisit?.visitStatusID == 3){
     //            visitDetail.visitType = VisitType.manualvisit
     //        }else{
     //            visitDetail.visitType = VisitType.planedvisit
     //        }
     self.navigationController?.pushViewController(leadDetail, animated: true)
     }
     }else{
     self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Detail")
     //  self.tblSalesPlan.makeToast("Please relogin firstdata of this lead is not synced yet")
     }
     }else if(model.detailType == 2){
     // plan visit
     if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
     {
     visitDetail.redirectTo =  0
     if let objVisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
     visitDetail.planvisit = objVisit //arrOfplanvisit[indexPath.row]
     if let status =  visitDetail.planvisit?.visitStatusID {
     if(status == 3){
     visitDetail.visitType = VisitType.manualvisit
     }else{
     visitDetail.visitType = VisitType.planedvisit
     }
     
     }else{
     visitDetail.visitType = VisitType.planedvisit
     }
     self.navigationController?.pushViewController(visitDetail, animated: true)
     }else{
     self.getplanvisitDetial(visitId: model.modulePrimaryID,ForAction:"Detail")
     
     
     if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
     visitDetail.planvisit = planvisit //arrOfplanvisit[indexPath.row]
     if let status =  visitDetail.planvisit?.visitStatusID {
     if(status == 3){
     visitDetail.visitType = VisitType.manualvisit
     }else{
     visitDetail.visitType = VisitType.planedvisit
     }
     
     }else{
     visitDetail.visitType = VisitType.planedvisit
     }
     self.navigationController?.pushViewController(visitDetail, animated: true)
     }else{
     
     }
     
     }
     
     
     }
     
     }else if(model.detailType == 4){
     //Activity Detail
     //   if let objActivity = Activity().getActivityFromId(userID: model.modulePrimaryID) as? Activity{
     
     
     
     MagicalRecord.save({ (localcontext) in
     
     
     //                 FEMDeserializer.collection(fromRepresentation: [dicResponse], mapping: Activity.defaultMapping(), context: localcontext)
     //                if let activity = Activity().getActivityFromId(userID: NSNumber.init(value:self.activitymodel?.activityId ?? 0)) as? Activity{
     //
     //
     //                }
     let context = Activity.getContext()
     context.mr_saveToPersistentStore { (status, error) in
     if(error ==  nil){
     
     }
     }
     
     localcontext.mr_save({ (localcontext) in
     print("saving")
     })
     }, completion: { (status, error) in
     print(status)
     print(error?.localizedDescription ?? "")
     if let objActivity = Activity().getActivityFromId(userID: model.modulePrimaryID ?? NSNumber.init(value:0)) as? Activity{
     // if let objActivity = Activity().getActivityFromId(userID: model.modulePrimaryID){
     //PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
     if let activityDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityDetail) as? ActivityDetail{
     print("count of checkin \(objActivity.activityCheckInCheckOutList.count) , \(objActivity)")
     activityDetail.activitymodelInDetail = objActivity
     self.navigationController?.pushViewController(activityDetail, animated: true)
     }
     }
     })
     }else if(model.detailType == 5){
     self.getColdCallVisitDetail(id: model.modulePrimaryID){  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
     let arrOFunplanvisit = arr as? [[String:Any]] ?? [[String:Any]]()
     if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
     {
     visitDetail.redirectTo =  0
     visitDetail.visitType = VisitType.coldcallvisit
     //let unplanvisitobj = UnplannedVisit().initwithdic(dict: dic)
     let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
     //    if let unplanvisitDic = unplanvisitdic{
     let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
     visitDetail.unplanvisit =  unplanvisitobj
     //}
     self.navigationController?.pushViewController(visitDetail, animated: true)
     }
     }
     }
     }
     
     
     
     @objc func visitReportTapped(sender:UIButton)->(){
     let model = self.arrSalesplanmodelForDisplay[sender.tag]
     if(model.detailType == 3){
     /*
      if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
      if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
      
      if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
      
      if(leadobj.influencerID > 0){
      
      }else{
      leadobj.influencerID =  0
      }
      if(leadobj.secondInfluencerID > 0){
      
      }else{
      leadobj.secondInfluencerID = 0
      }
      leadDetail.lead = leadobj
      }
      leadDetail.isHistory = false
      leadDetail.redirectTo =  0
      // leadDetail.lead =   arrOfLead[indexPath.row]
      //        visitDetail.planvisit = arrOfplanvisit[indexPath.row]
      //        if(visitDetail.planvisit?.visitStatusID == 3){
      //            visitDetail.visitType = VisitType.manualvisit
      //        }else{
      //            visitDetail.visitType = VisitType.planedvisit
      //        }
      self.navigationController?.pushViewController(leadDetail, animated: true)
      }
      }else{
      self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Detail")
      //  self.tblSalesPlan.makeToast("Please relogin firstdata of this lead is not synced yet")
      }
      
      **/
     if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
     //Lead
     if  let leadupdatestatus = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadStatusUpdate) as? UpdateLeadStatus{
     if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
     
     
     if(leadobj.influencerID > 0){
     
     }else{
     leadobj.influencerID =  0
     }
     if(leadobj.secondInfluencerID > 0){
     
     }else{
     leadobj.secondInfluencerID = 0
     }
     
     leadupdatestatus.objLead = leadobj
     }
     self.navigationController?.pushViewController(leadupdatestatus, animated: true)
     }
     }else{
     self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Report")
     // self.tblSalesPlan.makeToast("Please relogin firstdata of this lead is not synced yet")
     }
     
     }else if(model.detailType == 2){
     //plan visit
     if  let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
     if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
     let visitreportList =  planvisit.visitStatusList
     visitReport.visitType =  VisitType.planedvisit
     visitReport.isFromVisit = false
     if(visitreportList.count ?? 0 > 0){
     visitReport.isupdateReport = true
     visitReport.planVisit = planvisit
     visitReport.latestvisitreport = visitreportList.lastObject as? VisitStatus
     }else{
     visitReport.isupdateReport = false
     visitReport.planVisit = planvisit
     }
     self.navigationController?.pushViewController(visitReport, animated: true)
     }else{
     self.getplanvisitDetial(visitId: model.modulePrimaryID,ForAction:"Report")
     
     }
     }
     }else if(model.detailType == 4){
     //Activity Report
     // if let objActivity = Activity().getActivityFromId(userID: model.modulePrimaryID) as? Activity{
     if let activity =  Activity().getActivityFromId(userID: model.modulePrimaryID) as? Activity{
     if(activity.statusDescription.count > 0){
     Utils.toastmsg(message:"Report is already submitted.", duration: 2.0, position: CGPoint.init(x: self.view.center.x, y: self.view.center.y + self.view.center.y/2 ))
     
     }else{
     if let activityReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityReport) as? ActivityReport{
     activityReport.activityId = model.modulePrimaryID
     activityReport.activitymodel = activity
     self.navigationController?.pushViewController(activityReport, animated: true)
     }
     }
     }
     }else if(model.detailType == 5){
     self.getColdCallVisitDetail(id: model.modulePrimaryID){  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
     let arrOFunplanvisit = arr as? [[String:Any]] ?? [[String:Any]]()
     if  let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
     let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
     if  let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
     as? UnplannedVisit{
     let visitreportList =  unplanvisitobj.visitStatusList
     visitReport.visitType =  VisitType.coldcallvisit
     visitReport.isFromVisit = false
     if(visitreportList?.count ?? 0 > 0){
     visitReport.isupdateReport = true
     visitReport.unplanvisit = unplanvisitobj
     visitReport.unplanvisitReport = visitreportList?.last as? VisitStatusList
     }else{
     visitReport.isupdateReport = false
     visitReport.unplanvisit = unplanvisitobj
     }
     }
     self.navigationController?.pushViewController(visitReport, animated: true)
     }else{
     self.tblSalesPlan.makeToast("Please relogin once")
     }
     
     
     //                if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
     //                  {
     //            visitDetail.redirectTo =  0
     //            visitDetail.visitType = VisitType.coldcallvisit
     //    //let unplanvisitobj = UnplannedVisit().initwithdic(dict: dic)
     //        let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
     //     //    if let unplanvisitDic = unplanvisitdic{
     //        let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
     //            visitDetail.unplanvisit =  unplanvisitobj
     //         //}
     //        self.navigationController?.pushViewController(visitDetail, animated: true)
     //                }
     
     }
     /*  let obj = aBeatplanvisitList[sender.tag]
      if  let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
      visitReport.isHome =  false
      if(type(of: obj) == PlannVisit.self){
      let planvisit = obj as? PlannVisit
      visitReport.visitType  = VisitType.planedvisit
      let visitreportList =  planvisit?.visitStatusList
      if(visitreportList?.count ?? 0 > 0){
      visitReport.isupdateReport = true
      visitReport.planVisit = planvisit
      visitReport.latestvisitreport = visitreportList?.lastObject as? VisitStatus
      }else{
      visitReport.isupdateReport = false
      visitReport.planVisit = planvisit
      }
      self.navigationController?.pushViewController(visitReport, animated: true)
      }else if(type(of: obj) == UnplannedVisit.self){
      let unplanvisit = obj as? UnplannedVisit
      visitReport.visitType  = VisitType.coldcallvisit
      visitReport.unplanvisit = unplanvisit
      self.navigationController?.pushViewController(visitReport, animated: true)
      
      }
      
      }*/
     //        if(type(of: obj) == PlannVisit.self){
     //            if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
     //            let planvisit = obj as? PlannVisit
     //            visitDetail.visitType = VisitType.planedvisit
     //
     //            visitDetail.planvisit = planvisit
     //            visitDetail.redirectTo = 1
     //            self.navigationController?.pushViewController(visitDetail, animated: true)
     //            }
     //        }else if(type(of: obj) == UnplannedVisit.self){
     //            if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
     //            let unplanvisit = obj as? UnplannedVisit
     //            visitDetail.visitType = VisitType.coldcallvisit
     //
     //            visitDetail.unplanvisit = unplanvisit
     //            visitDetail.redirectTo = 1
     //            self.navigationController?.pushViewController(visitDetail, animated: true)
     //            }
     //      }
     
     }
     }
     @objc func orderFromClickedTapped(sender:UIButton){
     let model = self.arrSalesplanmodelForDisplay[sender.tag]
     if(model.detailType == 2){
     // plan visit
     
     if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
     if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
     
     guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: planvisit.customerID ?? 0)), cust.statusID == 2 else {
     Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""))
     return
     }
     vc.objVisit = planvisit
     
     self.navigationController!.pushViewController(vc, animated: true)
     }
     }else{
     self.getplanvisitDetial(visitId: model.modulePrimaryID, ForAction: "Order")
     }
     
     }else if(model.detailType == 3){
     //Lead
     
     
     
     if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
     if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
     
     guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: leadobj.customerID ?? 0)), cust.statusID == 2 else {
     Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""))
     return
     }
     vc.lead = leadobj
     self.navigationController!.pushViewController(vc, animated: true)
     }}else{
     self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Order")
     //  self.tblSalesPlan.makeToast("Please Relogin first ,")
     }
     
     
     }else if(model.detailType == 4){
     //activity
     }else if(model.detailType == 5){
     //cold call
     }
     
     
     }
     @objc func visitCheckinTapped(sender:UIButton){
     print("btn check in tapped ")
     let model = self.arrSalesplanmodelForDisplay[sender.tag]
     if((CLLocationCoordinate2DIsValid(currentCoordinate)) && (currentCoordinate.latitude != 0.0 && currentCoordinate.longitude != 0.0)){
     
     if(model.detailType == 2){
     
     
     if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID){
     
     
     
     
     //
     //                    let (message,lastcheckinStatus) = Utils.latestCheckinDetailForPlanedVisit(visit: planvisit)
     //                        print("message = \(message)")
     //                        if(lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
     if( model.checkInTime?.count ?? 0 > 0){
     
     //                            let arrOfVisitCheckinOut = objVisit.checkInOutData.array
     //                        if(arrOfVisitCheckinOut.count  >  0){
     arrvisitStep = StepVisitList.getAll()
     if(self.activesetting.visitStepsRequired ==  1 && arrvisitStep.count > 0){
     
     
     arrofmandatoryStep = arrvisitStep.filter{
     $0.mandatoryOrOptional == true
     }
     self.visitStepsStatusCheck(visitType: VisitType.planedvisit,planvisit: planvisit,unplanvisit: UnplannedVisit()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       )
     if  let popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection{
     popup.isFromSalesOrder =  false
     popup.modalPresentationStyle = .overCurrentContext
     popup.strTitle = "Visit Steps"
     popup.nonmandatorydelegate = self
     popup.arrOfVisitStep = arrvisitStep
     popup.arrOfSelectedVisitStep = arrSelectedVisitStep ?? [StepVisitList]() //arrSelectedVisitStep
     popup.arrOfDisableVisitStep = arrSelectedVisitStep ?? [StepVisitList]()
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
     else{
     //check out
     VisitCheckinCheckout().checkout(visitstatus:0,lat:NSNumber.init(value: currentCoordinate.latitude) ,long:NSNumber.init(value:currentCoordinate.longitude), isVisitPlanned: VisitType.planedvisit, objplannedVisit: planvisit  ,objunplannedVisit: UnplannedVisit(),viewcontroller:self.parent ?? self)
     }
     
     }else{
     
     //check in
     VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: currentCoordinate.latitude) ,long:NSNumber.init(value:currentCoordinate.longitude), isVisitPlanned: VisitType.planedvisit, objplannedVisit: planvisit  ,objunplannedVisit:  UnplannedVisit(), visitid: NSNumber.init(value:planvisit.iD) ,viewcontroller:self.parent ?? self, addressID: NSNumber.init(value:0))
     }
     
     
     
     }else{
     self.getplanvisitDetial(visitId: model.modulePrimaryID, ForAction: "Checkin")
     }
     }else 
     if(model.detailType == 3){
     
     self.arrOfListInfluencer = [CustomerDetails]()
     if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
     
     selectedlead =  leadobj
     
     if   let  firstinfluencerid = leadobj.influencerID as? Int64{
     if let secondinflencerid = leadobj.secondInfluencerID as? Int64{
     
     
     if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.influencerID ?? 0)){
     arrOfListInfluencer.append(firstinfluencer)
     self.arrOfSelectedInfluerncer.append(firstinfluencer)
     }
     if  let secondinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.secondInfluencerID ?? 0)){
     arrOfListInfluencer.append(secondinfluencer)
     }
     }
     //            }else{
     //                if(arrOfListInfluencer.count == 0){
     //                if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.influencerID ?? 0)){
     //                  arrOfListInfluencer.append(firstinfluencer)
     //              self.arrOfSelectedInfluerncer.append(firstinfluencer)
     //                        }
     //                }
     //            }
     }
     let arrOfLeadCheckinOut = leadobj.leadCheckInOutList.array
     if( model.checkInTime?.count ?? 0 > 0 && arrOfLeadCheckinOut.count > 0){
     
     
     //                        if(arrOfLeadCheckinOut.count  ==  0){
     if let lastcheckin =  leadobj.leadCheckInOutList[0] as? LeadCheckInOutList{
     LeadCheckinCheckout().checkoutLead(status: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: leadobj, cust: lastcheckin.checkInFrom , viewcontroller: self.parent ?? self)
     }
     
     //  }
     /*else{
      Utils.toastmsg(message:"Please do relog-in first")
      }*/
     }else if((model.checkInTime?.count == 0) && (arrOfListInfluencer.count == 0)){
     LeadCheckinCheckout().checkinLead(status: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: leadobj, cust: "C" , viewcontroller: self.parent ?? self)
     }else{
     
     
     if((self.activesetting.influencerInLead == NSNumber.init(value:1)) && (leadobj.influencerID > 0)){
     // let custPopup
     self.popup =    Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
     self.popup?.modalPresentationStyle = .overCurrentContext
     self.popup?.isFromSalesOrder =  false
     self.popup?.strTitle = "To"
     self.popup?.nonmandatorydelegate = self
     self.popup?.arrOfCustomerClass = arrOfLeadCheckinoption
     self.popup?.arrOfSelectedClass = arrOfSelectedLeadCheckinoption
     self.popup?.strLeftTitle = "OK"
     self.popup?.strRightTitle = "Cancel"
     self.popup?.parentViewOfPopup = self.view
     self.popup?.selectionmode = SelectionMode.single
     self.popup?.isSearchBarRequire = false
     self.popup?.viewfor = ViewFor.customerClass
     self.popup?.isFilterRequire = false
     Utils.addShadow(view: self.view)
     
     //Utils.addShadow(view: self.view.superview ?? self.view)
     self.present(self.popup!, animated: false, completion: nil)
     
     }else{
     LeadCheckinCheckout().checkinLead(status: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: leadobj, cust: "C" , viewcontroller: self.parent ?? self)
     }
     }
     
     }else{
     self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Checkin")
     //  self.tblSalesPlan.makeToast("Please Relogin first ,")
     }
     
     }else if(model.detailType == 5){
     self.getColdCallVisitDetail(id: model.modulePrimaryID){  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
     let arrOFunplanvisit = arr as? [[String:Any]] ?? [[String:Any]]()
     
     
     let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
     //    if let unplanvisitDic = unplanvisitdic{
     if  let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
     as? UnplannedVisit{
     
     
     let (message,lastcheckinStatus) = Utils.latestCheckinDetailForUnPlanedVisit(visit: unplanvisitobj) //Utils.latestCheckinDetailForPlanedVisit(visit: objVisit)
     
     if(lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
     VisitCheckinCheckout().checkout(visitstatus: 0, lat: NSNumber.init(value: self.currentCoordinate.latitude), long: NSNumber.init(value:self.currentCoordinate.longitude), isVisitPlanned: VisitType.coldcallvisit, objplannedVisit: PlannVisit() , objunplannedVisit: unplanvisitobj, viewcontroller: self.parent ?? self)
     //  VisitCheckinCheckout().checkout(visitstatus:0,lat:NSNumber.init(value: self.currentCoordinate.latitude) ,long:NSNumber.init(value:self.currentCoordinate.longitude), isVisitPlanned: VisitType.coldcallvisit, objplannedVisit: PlannVisit()  ,objunplannedVisit: unplanvisitobj, visitid: model.modulePrimaryID ,viewcontroller:self.parent ?? self, addressID: NSNumber.init(value:0))
     }else{
     VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: self.currentCoordinate.latitude) ,long:NSNumber.init(value:self.currentCoordinate.longitude), isVisitPlanned: VisitType.coldcallvisit, objplannedVisit: PlannVisit()  ,objunplannedVisit: unplanvisitobj, visitid: model.modulePrimaryID ,viewcontroller:self.parent ?? self, addressID: NSNumber.init(value:0))
     }
     }
     }
     //   VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: currentCoordinate.latitude) ,long:NSNumber.init(value:currentCoordinate.longitude), isVisitPlanned: VisitType.coldcallvisit, objplannedVisit: PlannVisit()  ,objunplannedVisit:  UnplannedVisit(), visitid: model.modulePrimaryID ,viewcontroller:self.parent ?? self, addressID: NSNumber.init(value:0))
     }
     
     
     else if(model.detailType == 4){
     
     //Activity().getActivityFromId(userID: model.modulePrimaryID){
     print("activity id = \(model.modulePrimaryID)")
     if let activity = Activity().getActivityFromId(userID: model.modulePrimaryID){
     
     if(model.checkInTime?.count ?? 0 > 0){
     ActivityCheckinCheckoutClass().activityCheckout(lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), viewcontroller: self, activityID:model.modulePrimaryID)
     }else{
     //                    ActivityCheckinCheckoutClass().activityCheckin(lat: NSNumber.init(value: currentCoordinate.latitude), long: NSNumber.init(value: currentCoordinate.longitude), viewcontroller: self, activityID: NSNumber.init(value:aid))
     
     ActivityCheckinCheckoutClass().activityCheckin(lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), viewcontroller: self, activityID: model.modulePrimaryID)
     }
     }else{
     self.tblSalesPlan.makeToast("Please Relogin first")
     }
     
     
     
     }else{
     if(currentCoordinate.latitude == 0 || currentCoordinate.longitude == 0 ){
     self.tblSalesPlan.makeToast("Please check your GPS and refresh the location")
     let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
     let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
     UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
     
     }
     Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
     }else{
     
     }
     }
     
     }
     else{
     print("not get proper lat long  \(currentCoordinate.latitude) , \(currentCoordinate.longitude) , sahred = \(Location.currentLocationcoordinate)")
     }
     
     }
     
     */
    
    
    @objc func custNameTapped(_ sender: UITapGestureRecognizer){
        
        let model = arrSalesplanmodelForDisplay[sender.view?.tag ?? 0]
        var custId = NSNumber.init(value: 0)
        var custName = ""
        if(model.detailType == 2){
            //visit
            if let visit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                custId =  NSNumber.init(value: visit.customerID)
                custName = visit.customerName ?? ""
            }
        }else if(model.detailType ==  3){
            //Lead
            custName = model.checkInCustomerName
            custId = model.customerID
            
        }else {
            if let selectedCustomer = CustomerDetails.getCustomerByID(cid: model.customerID) as? CustomerDetails{
                custId = model.customerID
                custName = selectedCustomer.name
            }else   if let visit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                custId =  NSNumber.init(value: visit.customerID)
                custName = visit.customerName ?? ""
            }
        }
        if let customerhistory  = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistory) as? CustomerHistoryContainer{
            if let lblCust = sender.view as? UILabel{
                customerhistory.customerName = custName
            }
            customerhistory.isEdit = false
            customerhistory.customerID = custId
            if CustomerDetails.getCustomerByID(cid: customerhistory.customerID) != nil{
                self.navigationController?.pushViewController(customerhistory, animated: true)
            }
            else{
                Utils.toastmsg(message:"Customer is not mapped so you can't view customer history",view:self.view)
            }
        }
    }
    func visitStepsStatusCheck(visitType:VisitType,planvisit:PlannVisit,unplanvisit:UnplannedVisit,model:SalesPlanModel){
        // Create Group
        let group = DispatchGroup()
        self.arrvisitStep.sort { (step1, step2) -> Bool in
            step1.menuIndex < step2.menuIndex
        }
        
        for visitStepsData in self.arrvisitStep{
            group.enter()
            
            if(visitStepsData.menuIndex == 35){
                //report
                if(visitType == VisitType.coldcallvisit){
                    if(unplanvisit.visitStatusList.count ?? 0 > 0){
                        //   aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                        self.arrSelectedVisitStep.append(visitStepsData)
                        group.leave()
                    }else{
                        group.leave()
                    }
                }else{
                    if(planvisit.visitStatusList.count ?? 0  > 0){
                        //     aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                        self.arrSelectedVisitStep.append(visitStepsData)
                        group.leave()
                    }else{
                        group.leave()
                    }
                }
            }else if(visitStepsData.menuIndex == 36){
                //sales order
                if(visitType == VisitType.planedvisit){
                    if let order = Utils.getorderByVisitId(visitID: NSNumber.init(value: planvisit.iD ?? 0)){
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
                //pivture
                if(visitType == VisitType.coldcallvisit){
                    if(self.activeunplanvisit.isPictureAvailable == 1){
                        //   aryMandatoryMenuIDs.append(visitStepsData.menuIndex)
                        self.arrSelectedVisitStep.append(visitStepsData)
                        group.leave()
                    }else{
                        group.leave()
                    }
                }else{
                    SVProgressHUD.setDefaultMaskType(.black)
                    SVProgressHUD.show()
                    var param = Common.returndefaultparameter()
                    param["VisitID"] =  activeplanvisit.iD
                    self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetVisitUploadImages, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                        SVProgressHUD.dismiss()
                        if(status.lowercased() == Constant.SucessResponseFromServer){
                            if(responseType == ResponseType.arr){
                                let arrofpicturedata = arr as? [[String:Any]] ?? [[String:Any]]()
                                
                                if(arrofpicturedata.count > 0){
                                    self.arrSelectedVisitStep.append(visitStepsData)
                                    group.leave()
                                }else{
                                    group.leave()
                                    //                    isToast = true
                                    //                    Utils.toastmsg(message:"Please add picture",view: self.view)
                                    //                    return
                                }
                            }else if(error.code == 0){
                                group.leave()
                                
                                // Utils.toastmsg(message:"Error while checking picture",view: self.view)
                                //return
                                
                                
                            }else{
                                group.leave()
                                Utils.toastmsg(message:"Error while checking picture",view: self.view)
                                
                            }
                        }else{
                            group.leave()
                        }
                        
                        
                    }
                    
                }
            }else if (visitStepsData.menuIndex == 39){
                if(visitType == VisitType.coldcallvisit){
                    group.leave()
                    
                }else{
                    SVProgressHUD.setDefaultMaskType(.black)
                    SVProgressHUD.show()
                    var param = Common.returndefaultparameter()
                    if(visitType == VisitType.coldcallvisit){
                        param["VisitTypeID"] = "2"
                    }else{
                        param["VisitTypeID"] = "1"
                    }
                    if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                        param["visitId"] = unplanvisit.localID
                        param["CustomerID"] =  unplanvisit.customerID
                        if(unplanvisit.customerID!.intValue ?? 0 > 0){
                            if   let customer = CustomerDetails.getCustomerByID(cid: unplanvisit.customerID ?? 0){
                                param["CustomerName"] = customer.name
                            }else{
                                param["CustomerName"] = ""
                            }
                        }else{
                            param["CustomerName"] = ""
                        }
                    }else{
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
                    }
                    
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
                                        self.arrSelectedVisitStep.append(visitStepsData)
                                    }else{
                                        
                                        
                                    }
                                    group.leave()
                                    
                                    
                                    
                                    
                                }else{
                                    group.leave()
                                    //
                                }
                                
                                
                            }else{
                                group.leave()
                            }
                            
                        }else if(error.code == 0){
                            
                            group.leave()
                        }else{
                            Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                            group.leave()
                        }
                    }
                }
            }else if (visitStepsData.menuIndex == 40){
                if(visitType == VisitType.coldcallvisit){
                    group.leave()
                    
                }else{
                    var para = Common.returndefaultparameter()
                    
                    var getvisitjson = [String:Any]()
                    if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                        getvisitjson["VisitID"] = unplanvisit.localID
                    }else{
                        getvisitjson["VisitID"] = planvisit.iD
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
                                    
                                }else{
                                    group.leave()
                                }
                            }else{
                                group.leave()
                            }
                        }else if(error.code == 0){
                            
                            Utils.toastmsg(message:"Error while Checking stock",view: self.view)
                            group.leave()
                            
                        }else{
                            Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "Error while Checking stock",view: self.view)
                            group.leave()
                        }
                    }
                    
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
                    if let collection = planvisit.visitCollection{
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
                    if let countershare = planvisit.visitCounterShare{
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
                //                        if(StoreCheckContainer.visitType == VisitType.coldcallvisit){
                //                            param["VisitID"] = StoreCheckContainer.unplanVisit?.localID
                //                            param["CustomerID"] =  StoreCheckContainer.unplanVisit?.customerID
                //                            }else{
                //                                param["VisitID"] = StoreCheckContainer.planVisit?.iD
                //                                param["CustomerID"] =  StoreCheckContainer.planVisit?.customerID
                //                            }
                if let planvisit = activeplanvisit as? PlannVisit{
                    param["VisitID"] = planvisit.iD
                    param["CustomerID"] = planvisit.customerID
                }else{
                    param["VisitID"] = activeunplanvisit.localID
                    param["CustomerID"] = activeunplanvisit.customerID
                    
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
                
                
                
            }else if(visitStepsData.menuIndex == 74){
                
                //Shelf Space
                var arrOfShelfSpace =  [ShelfSpaceModel]()
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
                var param = Common.returndefaultparameter()
                if((visitType == VisitType.coldcallvisit) || (visitType == VisitType.coldcallvisitHistory)){
                    param["VisitID"] = self.activeunplanvisit?.localID
                }else{
                    param["VisitID"] = self.activeplanvisit?.iD
                }
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetShelfSpaceList1, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                    
                    if(status.lowercased() == Constant.SucessResponseFromServer)
                    {
                        SVProgressHUD.dismiss()
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
                                
                            }else{
                                let shelfspacebyvisitid = arrOfShelfSpace.filter{
                                    $0.VisitID == self.activeplanvisit?.iD ?? 0
                                }
                                if(shelfspacebyvisitid.count > 0){
                                    self.arrSelectedVisitStep.append(visitStepsData)
                                    print("group is leaving 2")
                                    group.leave()
                                }else{
                                    print("group is leaving 3")
                                    group.leave()
                                    
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
                print("\(visitStepsData.menuIndex)")
                group.leave()
            }
        }
        
        
        // Notify Completion of tasks on main thread.
        group.notify(queue: .main) {
            // Update UI
            print("group is notfied \(self.arrSelectedVisitStep.count)" )
            print("count of man step = \(self.arrofmandatoryStep.count)")
            
            
            if let selectedcustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: planvisit.customerID ?? 0)) as?  CustomerDetails{
                let companytypeid = NSNumber.init(value:selectedcustomer.companyTypeID)
                let segment = NSNumber.init(value:selectedcustomer.segmentID)
                for stepvisit in  self.arrofmandatoryStep{
                    if let visitStatusType = stepvisit.customerType as? String{
                        if let visitStatusSegment = stepvisit.customerSegment as? String{
                            if(visitStatusType.lowercased() == "off" || visitStatusSegment.lowercased() == "off"){
                                self.arrofmandatoryStep  =   self.arrofmandatoryStep.filter{
                                    $0 != stepvisit
                                }
                                //as grishma said so
                                self.arrvisitStep.filter{
                                    $0 != stepvisit
                                }
                            }else{
                                let arrOfKYCType = visitStatusType.components(separatedBy: ",")
                                let arrOfKYCSegment = visitStatusSegment.components(separatedBy: ",")
                                if(arrOfKYCType.contains(companytypeid.stringValue) && arrOfKYCSegment.contains(segment.stringValue)){
                                    print("type of customer = \(companytypeid) , segment of customer = \(segment) , arr of type = \(arrOfKYCType) , arr of segment = \(arrOfKYCSegment) name of step is = \(stepvisit.menuLocalText), \(visitStatusType) , \(visitStatusSegment) \(arrOfKYCType.contains(companytypeid.stringValue)) , \(arrOfKYCSegment.contains(segment.stringValue))")
                                }else{
                                    print("type of customer = \(companytypeid) , segment of customer = \(segment) , arr of type = \(arrOfKYCType) , arr of segment = \(arrOfKYCSegment) name of step is = \(stepvisit.menuLocalText), \(visitStatusType) , \(visitStatusSegment) \(arrOfKYCType.contains(companytypeid.stringValue)) , \(arrOfKYCSegment.contains(segment.stringValue)) not done")
                                    self.arrofmandatoryStep =    self.arrofmandatoryStep.filter{
                                        $0 != stepvisit
                                    }
                                    
                                    //as grishma said so
                                    self.arrvisitStep.filter{
                                        $0 != stepvisit
                                    }
                                    
                                }
                                
                                
                                
                            }
                        }
                    }
                }
                
            }
            
            
            if  let popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection{
                popup.isFromSalesOrder =  false
                popup.modalPresentationStyle = .overCurrentContext
                popup.strTitle = "Visit Steps"
                popup.nonmandatorydelegate = self
                popup.arrOfVisitStep = self.arrvisitStep
                popup.arrOfMandatoryStep = self.arrofmandatoryStep
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
                SVProgressHUD.dismiss()
                
                
                
            }
        }
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        
        print("sender satte  is = \(sender.state)")
        if sender.state == UIGestureRecognizer.State.ended {
            
            
            let indexpath =  IndexPath.init(row: sender.view?.tag ?? 0, section: 0)
            if let tappedCell = tblSalesPlan.cellForRow(at: indexpath) as? SalesPlanCell{
                //do what you want to cell here
                
                tappedCell.isexpand = !tappedCell.isexpand
                if(arrexpandecell.contains(indexpath)){
                    print(arrexpandecell)
                    arrexpandecell =   arrexpandecell.filter{
                        $0 != indexpath
                    }
                }else{
                    arrexpandecell.append(indexpath)
                }
                // tblSalesPlan.reloadData()
                //                    var arrOfIndexpath = [IndexPath]()
                //                    arrOfIndexpath.append(indexpath)
                tblSalesPlan.reloadData()
                //                    tblSalesPlan.beginUpdates()
                //                    tblSalesPlan.reloadRows(at: arrOfIndexpath, with: .fade)
                //                    tblSalesPlan.endUpdates()
                
                
            }
        }
        //}
    }
    @objc func handleBeatPlanTap(_ sender: UITapGestureRecognizer) {
        if let viewtag = sender.view?.tag as? Int{
            let model = self.arrSalesplanmodelForDisplay[viewtag]
            if let beatplandetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanDetailView) as? BeatPlanDetail{
                beatplandetail.selectedDate = model.beatPlanID
                //   beatplandetail.selectedDate = model.BeatPlanDate
                beatplandetail.strbeatplanname = model.beatPlanName
                beatplandetail.strbeatplanID = model.beatPlanID
                self.navigationController?.pushViewController(beatplandetail, animated: true)
            }
        }
    }
    
    @objc func handleCollectionTap(_ sender: UITapGestureRecognizer) {
        
        // handling code
        
        if sender.state == UIGestureRecognizer.State.ended {
            let indexpath =  IndexPath.init(row: sender.view?.tag ?? 0, section: 0)
            if let tappedCell = tblSalesPlan.cellForRow(at: indexpath) as? VisitCollectionCell{
                //do what you want to cell here
                
                tappedCell.isexpand = !tappedCell.isexpand
                if(arrexpandecell.contains(indexpath)){
                    arrexpandecell =   arrexpandecell.filter{
                        $0 != indexpath
                    }
                }else{
                    arrexpandecell.append(indexpath)
                }
                // tblSalesPlan.reloadData()
                tblSalesPlan.reloadRows(at: [indexpath], with: .none)
            }
        }
    }
    //
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if(indexPath ==  expandedIndex){
        //            return 30
        //        }else{
        return  UITableView.automaticDimension
        //}
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension SalesPlanHome:UITabBarDelegate{
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //        SVProgressHUD.show(withStatus: "Loading")
        //        print(item.title ?? "uhbbhjj")
        //        if(item.title == "VISITS"){
        //            screenselection = Dashboardscreen.dashboardvisit
        //              self.showGraphIndicator(show: false)
        //            self.getvisitForDashboard()
        //            tblSalesPlan.tableFooterView?.isHidden = true
        //        }else if(item.title == "LEADS"){
        //             screenselection = Dashboardscreen.dashboardlead
        //             self.showGraphIndicator(show: false)
        //            self.getLeadForDashoard()
        //            tblSalesPlan.tableFooterView?.isHidden = true
        //        }else if(item.title == "ORDERS"){
        //            screenselection = Dashboardscreen.dashboardorder
        //            self.getOrderForDashoard()
        //            self.showGraphIndicator(show: true)
        //            tblSalesPlan.tableFooterView?.isHidden = true
        //        }
        //
        //       // tblSalesPlan.reloadData()
        //        self.setgraphdata()
        //        vwGraphIndicator.isHidden = false
        //
        //
    }
    //  func
}

extension SalesPlanHome:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        selectedindex = Int(index)
        if(index == 0){
            if let dashvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardVisit ) as? DashboardVisit
            {
                //                dashvisit.selectedUserID =  SalesPlanHome.selectedUserID
                //                dashvisit.selectedDate = SalesPlanHome.selectedDate
                
                return dashvisit
            }else {
                return UIViewController()
            }
        }else if(index == 1){
            if let dashlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardLead ) as? DashboardLead
            {
                //                        dashlead.selectedUserID =  selectedUserID
                //                        dashlead.selectedDate = selectedDate
                return dashlead
            }else {
                return UIViewController()
            }
        }else if(index == 2){
            if let dashorder = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardOrder) as? DashboardOrders
            {
                //                        dashorder.selectedUserID =  selectedUserID
                //                        dashorder.selectedDate = selectedDate
                return dashorder
            }else{
                return UIViewController()
            }
        }else {
            return UIViewController()
            
        }
    }
    
}

extension SalesPlanHome:PopUpDelegateNonMandatory{
    /*
     let arrmandatoryVisitStep =  arrvisitStep.filter { (visitstep) -> Bool in
     visitstep.mandatoryOrOptional ==  true && visitstep.status == false
     }
     
     **/
    func completionSelectedVisitStep(arr:[StepVisitList]){
        Utils.removeShadow(view: self.view)
        
        arrSelectedVisitStep =  arr
        
        var isToast = false
        let group = DispatchGroup()
        arrofmandatoryStep.sorted { (stepvisit1, stepvisit2) -> Bool in
            stepvisit1.menuOrder < stepvisit2.menuOrder
        }
        if let planvisit =  activeplanvisit {
            if  let selectedCustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planvisit.customerID ?? 0)) as? CustomerDetails{
                let companytypeid = NSNumber.init(value:selectedCustomer.companyTypeID)
                let segment = NSNumber.init(value:selectedCustomer.segmentID)
                var display = 0
                for stepvisit in arrofmandatoryStep{
                    group.enter()
                    if let visitStatusType = stepvisit.customerType as? String{
                        if let visitStatusSegment = stepvisit.customerSegment as? String{
                            if(visitStatusType.lowercased() == "off" || visitStatusSegment.lowercased() == "off"){
                                group.leave()
                            }else{
                                let arrOfKYCType = visitStatusType.components(separatedBy: ",")
                                let arrOfKYCSegment = visitStatusSegment.components(separatedBy: ",")
                                //  if(arrOfKYCType.contains(self.customerSegmentIndex.stringValue)){
                                if(arrOfKYCType.contains(companytypeid.stringValue) && arrOfKYCSegment.contains(segment.stringValue)){
                                    
                                    switch stepvisit.menuIndex {
                                        
                                    case 35:
                                        //visit report.
                                        
                                        if let planvisit =  activeplanvisit {
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
                                        
                                    case  36:
                                        
                                        if let planvisit =  activeplanvisit {
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
                                        
                                        if let planvisit =  activeplanvisit {
                                            SVProgressHUD.setDefaultMaskType(.black)
                                            SVProgressHUD.show()
                                            var param = Common.returndefaultparameter()
                                            param["VisitID"] =  activeplanvisit.iD
                                            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetVisitUploadImages, method: Apicallmethod.get) {
                                                (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
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
                                                    }else if(error.code == 0){
                                                        group.leave()
                                                        if(display == 0){
                                                            display += 1
                                                            Utils.toastmsg(message:"Please add picture",view: self.view)
                                                            
                                                        }
                                                        return
                                                        
                                                        
                                                    }else{
                                                        group.leave()
                                                        if(display == 0){
                                                            display += 1
                                                            Utils.toastmsg(message:"Error while checking picture",view: self.view)
                                                        }
                                                        return
                                                        
                                                    }
                                                }else{
                                                    group.leave()
                                                }
                                                
                                                
                                            }
                                        }else{
                                            group.leave()
                                        }
                                        
                                        break
                                        
                                    case 39:
                                        ////feed back
                                        
                                        if let planvisit =  activeplanvisit {
                                            SVProgressHUD.setDefaultMaskType(.black)
                                            SVProgressHUD.show()
                                            var param = Common.returndefaultparameter()
                                            
                                            param["VisitTypeID"] = "1"
                                            
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
                                                                isToast = true
                                                                if(display == 0){
                                                                    display += 1
                                                                    Utils.toastmsg(message:"Please give feedback",view: self.view)
                                                                }
                                                                group.leave()
                                                                return
                                                            }else{
                                                                group.leave()
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                        }else{
                                                            group.leave()
                                                            
                                                            //
                                                        }
                                                        
                                                        //                                    }else{
                                                        //                                        isToast = true
                                                        //                                    Utils.toastmsg(message:"Please give feedback",view: self.view)
                                                        //                                    return
                                                        //                                    }
                                                        
                                                    }else{
                                                        
                                                        if ( message.count > 0 ) {
                                                            // Utils.toastmsg(message:message,view: self.view)
                                                            
                                                        }
                                                        group.leave()
                                                        return
                                                    }
                                                    
                                                }else if(error.code == 0){
                                                    
                                                    if ( message.count > 0 ) {
                                                        if(display == 0){
                                                            display += 1
                                                            Utils.toastmsg(message:"Error while checking Feedback",view: self.view)
                                                        }
                                                    }
                                                    group.leave()
                                                    return
                                                }else{
                                                    Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                                                    group.leave()
                                                    return
                                                }
                                                
                                            }
                                        }else{
                                            group.leave()
                                        }
                                        
                                        
                                        break
                                        
                                    case 40:
                                        ///update stock
                                        
                                        if let planvisit =  activeplanvisit {
                                            var para = Common.returndefaultparameter()
                                            
                                            var getvisitjson = [String:Any]()
                                            if(activeVisitType == VisitType.coldcallvisit || activeVisitType == VisitType.coldcallvisitHistory){
                                                getvisitjson["VisitID"] = activeunplanvisit.localID
                                            }else{
                                                getvisitjson["VisitID"] = activeplanvisit.iD
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
                                                        isToast = true
                                                        if(display == 0){
                                                            display += 1
                                                            Utils.toastmsg(message:"Error while Checking stock",view: self.view)
                                                            
                                                        }
                                                        group.leave()
                                                        return
                                                    }
                                                }else if(error.code == 0){
                                                    
                                                    
                                                    Utils.toastmsg(message:"Error while Checking stock",view: self.view)
                                                    
                                                    group.leave()
                                                }else{
                                                    Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "Error while Checking stock",view: self.view)
                                                    group.leave()
                                                }
                                            }
                                            
                                        }else{
                                            group.leave()
                                        }
                                        break
                                        
                                    case 41:
                                        ////territery
                                        
                                        if let planvisit =  activeplanvisit {
                                            if let planVisit = planvisit as? PlannVisit{
                                                self.isTerritoryAvailable(planvisit: planVisit) { (territorystatus) in
                                                    if(territorystatus){
                                                        // self.arrSelectedVisitStep.append(visitStepsData)
                                                        group.leave()
                                                    }else{
                                                        isToast = true
                                                        if(display == 0){
                                                            display += 1
                                                            Utils.toastmsg(message:" Please add Territory",view: self.view)
                                                        }
                                                        group.leave()
                                                        return
                                                        
                                                    }
                                                }
                                            }else{
                                                group.leave()
                                            }
                                            
                                        }else{
                                            group.leave()
                                        }
                                        break
                                        
                                    case 65:
                                        // collection
                                        
                                        if let planvisit =  activeplanvisit {
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
                                        
                                        if let planvisit =  activeplanvisit {
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
                                        
                                    case 72:
                                        //Store check
                                        
                                        SVProgressHUD.setDefaultMaskType(.black)
                                        SVProgressHUD.show()
                                        var param1 = Common.returndefaultparameter()
                                        
                                        if let planvisit = activeplanvisit as? PlannVisit{
                                            param1["VisitID"] = planvisit.iD
                                            param1["CustomerID"] = planvisit.customerID
                                        }else{
                                            param1["VisitID"] = activeunplanvisit.localID
                                            param1["CustomerID"] = activeunplanvisit.customerID
                                            
                                        }
                                        self.apihelper.getdeletejoinvisit(param: param1, strurl: ConstantURL.kWSUrlGetStoreCheckData, method: Apicallmethod.get){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
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
                                                }else{
                                                    group.leave()
                                                }
                                            }else{
                                                Utils.toastmsg(message:"Error while checking stock",view: self.view)
                                                group.leave()
                                                SVProgressHUD.dismiss()
                                            }
                                        }
                                        
                                        break
                                        
                                    case 74:
                                        //Shelf Space
                                        
                                        var arrOfShelfSpace =  [ShelfSpaceModel]()
                                        SVProgressHUD.setDefaultMaskType(.black)
                                        SVProgressHUD.show()
                                        var param2 = Common.returndefaultparameter()
                                        if((activeVisitType == VisitType.coldcallvisit) || (activeVisitType == VisitType.coldcallvisitHistory)){
                                            param2["VisitID"] = self.activeunplanvisit?.localID
                                        }else{
                                            param2["VisitID"] = self.activeplanvisit?.iD
                                        }
                                        self.apihelper.getdeletejoinvisit(param: param2, strurl: ConstantURL.kWSUrlGetShelfSpaceList1, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
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
                                                        let shelfspacebyvisitid = arrOfShelfSpace.filter { (shelfspace) -> Bool in
                                                            shelfspace.VisitID == self.activeplanvisit.iD
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
                                                    }
                                                }else{
                                                    group.leave()
                                                }
                                            }else{
                                                Utils.toastmsg(message:"Error while checking shelfspace",view: self.view)
                                                group.leave()
                                                SVProgressHUD.dismiss()
                                            }
                                        }
                                        
                                    default:
                                        
                                        Utils.toastmsg(message:"all mandatory steps are not finished yet",view:self.view)
                                        group.leave()
                                    }}else{
                                        group.leave()
                                    }}}else{
                                        group.leave()
                                    }
                        
                        
                        
                    }
                    
                }
                
            }
            
            
            // Notify Completion of tasks on main thread.
            group.notify(queue: .main){
                
                if(isToast == false){
                    self.finalCheckout(visitType: VisitType.planedvisit)
                    
                }
            }
        }
        
    }
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        arrOfSelectedExecutive =  arr
        selectedUser = arrOfSelectedExecutive.first
        // tfSelectUser.text = String.init(format: "%@ %@", selectedUser.firstName,selectedUser.lastName)
        SalesPlanHome.selectedUserID =  selectedUser.entity_id
        lblSelectedUser.text = String.init(format: "%@ %@", selectedUser.firstName,selectedUser.lastName)
        self.getDailyReportData()
    }
    
    func completionSelectedClass(arr: [String],recordno:Int,strTitle:String) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            
            self.arrOfSelectedLeadCheckinoption =  arr
            selectedLeadCheckinOption = arr.first
            
            if(selectedLeadCheckinOption == "Influencer" && (selectedlead.influencerID > 0 && selectedlead.secondInfluencerID > 0 )){
                //give options for select influencer
                self.popup =    Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = "Select Influencer"
                self.popup?.isFromSalesOrder =  false
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfList = self.arrOfListInfluencer
                self.popup?.arrOfSelectedSingleCustomer = self.arrOfSelectedInfluerncer
                self.popup?.strLeftTitle = "OK"
                self.popup?.strRightTitle = "Cancel"
                self.popup?.selectionmode = SelectionMode.single
                self.popup?.isSearchBarRequire = false
                self.popup?.viewfor = ViewFor.firstInfluencer
                self.popup?.parentViewOfPopup = self.view
                self.popup?.isFilterRequire = false
                self.present(self.popup!, animated: false, completion: nil)
            }else if(selectedLeadCheckinOption == "Influencer" && (selectedlead.influencerID > 0 )){
                Utils.removeShadow(view: self.view)
                LeadCheckinCheckout.verifyAddress = false
                
                LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: selectedlead, cust: "I", viewcontroller: self.parent ?? self)
            }else{
                Utils.removeShadow(view: self.view)
                LeadCheckinCheckout.verifyAddress = false
                
                LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: selectedlead, cust: "C", viewcontroller: self.parent ?? self)
            }
            
            
            // classID =
        }
    }
    
    func completionfirstInfluencer(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print("selected influencer \(arr)")
        arrOfSelectedInfluerncer = arr
        selectedInluencer = arrOfSelectedInfluerncer.first
        
        if(selectedInluencer.iD == selectedlead.influencerID){
            LeadCheckinCheckout.verifyAddress = false
            
            LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: selectedlead, cust: "I", viewcontroller: self.parent ?? self)
        }else{
            LeadCheckinCheckout.verifyAddress = false
            
            LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: selectedlead, cust: "I", viewcontroller: self.parent ?? self)
        }
    }
    
    func completionsecondInfluencer(arr: [CustomerDetails]) {
        
        Utils.removeShadow(view: self.view)
        print("selected influencer \(arr)")
        arrOfSelectedInfluerncer = arr
        selectedInluencer = arrOfSelectedInfluerncer.first
        LeadCheckinCheckout.verifyAddress = false
        
        LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: selectedlead, cust: "S", viewcontroller: self.parent ?? self)
    }
}

extension SalesPlanHome :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true
                       , completion:   nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        SVProgressHUD.show()
        AttendanceCheckInCheckOut.isSelefieAvailbalecheckincheckout = true
        //if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        // {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            
            
            AttendanceCheckInCheckOut.selfieImagecheckincheckout = chosenImage
            print(AttendanceCheckInCheckOut.isCheckInAtcheckincheckout)
            
            if((AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 4)) || (AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 7))){
                // self.userCheckIn(status: true, viewController: viewController)
                if(btnCheckIn.currentTitle?.lowercased() == "check-in"){
                    AttendanceCheckInCheckOut.verifycheckinAdd = false
                    AttendanceCheckInCheckOut().userCheckIn(status: true, viewController: self)
                }else{
                    AttendanceCheckInCheckOut.verifycheckoutAdd = false
                    AttendanceCheckInCheckOut().userCheckIn(status: false, viewController: self)
                }
            }else{
                if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                    if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                        if(btnCheckIn.currentTitle?.lowercased() == "check-in"){
                            AttendanceCheckInCheckOut.verifycheckinAdd = false
                            AttendanceCheckInCheckOut().userCheckIn(status: true, viewController: self)
                        }else{
                            AttendanceCheckInCheckOut.verifycheckoutAdd = false
                            AttendanceCheckInCheckOut().userCheckIn(status: false, viewController: self)
                        }
                    }else{
                        if(btnCheckIn.currentTitle?.lowercased() == "check-in"){
                            if(AttendanceCheckInCheckOut.verifycheckinAdd){
                                AttendanceCheckInCheckOut().displayAlert(displayview:self)
                            }else{
                                AttendanceCheckInCheckOut().userCheckIn(status: true, viewController: self)
                            }
                        }else{
                            if(AttendanceCheckInCheckOut.verifycheckoutAdd){
                                AttendanceCheckInCheckOut().displayAlert(displayview:self)
                            }else{
                                AttendanceCheckInCheckOut().userCheckIn(status: false, viewController: self)
                            }
                        }
                        
                    }
                }else{
                    if(btnCheckIn.currentTitle?.lowercased() == "check-in"){
                        AttendanceCheckInCheckOut.verifycheckinAdd = false
                        AttendanceCheckInCheckOut().userCheckIn(status: true, viewController: self)
                    }else{
                        AttendanceCheckInCheckOut.verifycheckoutAdd = false
                        AttendanceCheckInCheckOut().userCheckIn(status: false, viewController: self)
                    }
                }
                
            }
            
            // AttendanceCheckInCheckOut().checkinClicked(tag: 0, tflocationText: "office", viewController: self)
        }else{
            Utils.toastmsg(message:"image does not capture propelry, please try again",view:self.view)
        }
        
        
        
        picker.dismiss(animated:true, completion: nil)
        
    }
    
}
extension SalesPlanHome:SalesPlanCellDelegate{
    
    //    @available(iOS 10.0, *)
    func iconWhatsAppClicked(cell: SalesPlanCell) {
        var strcontactno = ""
        if let strcontact = cell.lblContactPersonName.text{
            strcontactno.append(strcontact)
        }
        // let urlWhats = "whatsapp://phone_number=\(strcontactno)"
        let appName = "whatsapp"
        let appScheme = "\(appName)://send?text=fddfds"
        var appUrl = URL.init(string: appScheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)//URL(string: appScheme)
        
        
        // let url : NSString = "whatsapp://send?phone=\(strcontactno)" as NSString
        let url : NSString = "whatsapp://send?phone=\(strcontactno)&abid=\(strcontactno)&text=hi" as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        appUrl = searchURL as URL
        //str.stringByAddingPercentEncodingWithAllowedCharacters(NSCha‌​racterSet.URLQueryAl‌​lowedCharacterSet()
        if UIApplication.shared.canOpenURL(searchURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open((appUrl ?? URL.init(string: ""))! as URL)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL((appUrl  ?? URL.init(string: ""))!)
            }
            let urlWhats = "https://api.whatsapp.com/send?phone=\(strcontactno)&text=\("")"
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL) {
                        UIApplication.shared.openURL(whatsappURL)
                    } else {
                        Utils.toastmsg(message: "Can not open whatsapp with this number", view: self.view)
                        //                        print("Install Whatsapp")
                    }
                }
            }
        } else {
            Utils.toastmsg(message: "Please install Whatsapp", view: self.view)
            print("App not installed")
        }
        
        /*if let url = URL(string: "whatsapp://\(cell.lblContactPersonName.text ?? "")"), UIApplication.shared.canOpenURL(url) {
         if #available(iOS 10, *) {
         UIApplication.shared.open(url)
         } else {
         UIApplication.shared.openURL(url)
         }
         }else{
         Utils.toastmsg(message: "whatsapp have not this number ", view: self.view)
         }*/
        // self.view.makeToast("WhatsApp icon clicked")
    }
    func iconMapClicked(cell: SalesPlanCell) {
        // self.view.makeToast("map icon clicked")
        // let selectedcustomer =  cell.
        var objcustomer = CustomerDetails()
        var lat = NSNumber.init(value:0)
        var long = NSNumber.init(value:0)
        var customername = ""
        if let indexpath = tblSalesPlan.indexPath(for: cell){
            let selectedModel = arrSalesplanmodelForDisplay[indexpath.row]
            if let address =  AddressList().getAddressByAddressId(aId: selectedModel.addressID) as? AddressList{
                lat = NSNumber.init(value: address.lattitude.toDouble())
                long = NSNumber.init(value:address.longitude.toDouble())
                customername =  selectedModel.checkInCustomerName
            }
        }
        if let mapobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
            mapobj.lattitude = lat
            mapobj.longitude = long
            mapobj.custname = customername
            mapobj.isFromDashboard = true
            self.navigationController?.pushViewController(mapobj, animated: true)
        }
    }
    
    func iconCallClicked(cell: SalesPlanCell) {
        if let url = URL(string: "tel://\(cell.lblContactPersonName.text ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        //self.view.makeToast("call icon clicked")
    }
    
    func visitDetailTapped(cell:SalesPlanCell)->(){
        if let indexPath = tblSalesPlan.indexPath(for: cell){
            let model = self.arrSalesplanmodelForDisplay[indexPath.row]
            
            
            if(model.detailType == 4){
                //Activity Detail
                //   if let objActivity = Activity().getActivityFromId(userID: model.modulePrimaryID) as? Activity{
                
                
                
                MagicalRecord.save({ (localcontext) in
                    
                    
                    //                 FEMDeserializer.collection(fromRepresentation: [dicResponse], mapping: Activity.defaultMapping(), context: localcontext)
                    //                if let activity = Activity().getActivityFromId(userID: NSNumber.init(value:self.activitymodel?.activityId ?? 0)) as? Activity{
                    //
                    //
                    //                }
                    let context = Activity.getContext()
                    context.mr_saveToPersistentStore { (status, error) in
                        if(error ==  nil){
                            
                        }
                    }
                    
                    localcontext.mr_save({ (localcontext) in
                        print("saving")
                    })
                    localcontext.mr_saveToPersistentStoreAndWait()
                }, completion: { (status, error) in
                    print(status)
                    print(error?.localizedDescription ?? "")
                    if let objActivity = Activity().getActivityFromId(userID: model.modulePrimaryID ?? NSNumber.init(value:0)) as? Activity{
                        // if let objActivity = Activity().getActivityFromId(userID: model.modulePrimaryID){
                        //PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                        if let activityDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityDetail) as? ActivityDetail{
                            print("count of checkin \(objActivity.activityCheckInCheckOutList.count) , \(objActivity)")
                            activityDetail.activitymodelInDetail = objActivity
                            self.navigationController?.pushViewController(activityDetail, animated: true)
                        }else{
                            self.getActivityDetail(activityId:model.modulePrimaryID ?? NSNumber.init(value:0), ForAction: "Detail", model: model)
                        }
                    }
                })
            }else if(model.detailType == 5){
                self.getColdCallVisitDetail(id: model.modulePrimaryID){  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    let arrOFunplanvisit = arr as? [[String:Any]] ?? [[String:Any]]()
                    if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
                    {
                        visitDetail.redirectTo =  0
                        visitDetail.visitType = VisitType.coldcallvisit
                        //let unplanvisitobj = UnplannedVisit().initwithdic(dict: dic)
                        let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
                        //    if let unplanvisitDic = unplanvisitdic{
                        let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
                        self.activeunplanvisit = unplanvisitobj
                        visitDetail.unplanvisit =  unplanvisitobj
                        //}
                        self.navigationController?.pushViewController(visitDetail, animated: true)
                    }
                }
            }else{
                if let indexPath = tblSalesPlan.indexPath(for: cell) as? IndexPath{
                    let model = self.arrSalesplanmodelForDisplay[indexPath.row]
                    if let selectedCustomer = CustomerDetails.getCustomerByID(cid: model.customerID) as? CustomerDetails{
                        if(model.detailType == 3){
                            
                            // Lead
                            if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
                                if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
                                    
                                    if let leadobj = Lead.getLeadByID(Id: Int(leadobj.iD)){
                                        
                                        if(leadobj.influencerID > 0){
                                            
                                        }else{
                                            leadobj.influencerID =  0
                                        }
                                        if(leadobj.secondInfluencerID > 0){
                                            
                                        }else{
                                            leadobj.secondInfluencerID = 0
                                        }
                                        leadDetail.lead = leadobj
                                    }
                                    leadDetail.isHistory = false
                                    leadDetail.redirectTo =  0
                                    // leadDetail.lead =   arrOfLead[indexPath.row]
                                    //        visitDetail.planvisit = arrOfplanvisit[indexPath.row]
                                    //        if(visitDetail.planvisit?.visitStatusID == 3){
                                    //            visitDetail.visitType = VisitType.manualvisit
                                    //        }else{
                                    //            visitDetail.visitType = VisitType.planedvisit
                                    //        }
                                    self.navigationController?.pushViewController(leadDetail, animated: true)
                                }
                            }else{
                                self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Detail")
                                //  self.tblSalesPlan.makeToast("Please relogin firstdata of this lead is not synced yet")
                            }
                        }else if(model.detailType == 2){
                            // plan visit
                            if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
                            {
                                visitDetail.redirectTo =  0
                                if let objVisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                                    visitDetail.planvisit = objVisit //arrOfplanvisit[indexPath.row]
                                    if let status =  visitDetail.planvisit?.visitStatusID {
                                        if(status == 3){
                                            visitDetail.visitType = VisitType.manualvisit
                                        }else{
                                            visitDetail.visitType = VisitType.planedvisit
                                        }
                                        
                                    }else{
                                        visitDetail.visitType = VisitType.planedvisit
                                    }
                                    self.navigationController?.pushViewController(visitDetail, animated: true)
                                }else{
                                    self.getplanvisitDetial(visitId: model.modulePrimaryID,ForAction:"Detail", model: model)
                                    
                                    
                                    if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                                        visitDetail.planvisit = planvisit //arrOfplanvisit[indexPath.row]
                                        if let status =  visitDetail.planvisit?.visitStatusID {
                                            if(status == 3){
                                                visitDetail.visitType = VisitType.manualvisit
                                            }else{
                                                visitDetail.visitType = VisitType.planedvisit
                                            }
                                            
                                        }else{
                                            visitDetail.visitType = VisitType.planedvisit
                                        }
                                        self.navigationController?.pushViewController(visitDetail, animated: true)
                                    }else{
                                        
                                    }
                                    
                                }
                                
                                
                            }
                            
                        }
                    }else{
                        Utils().getCustomerDetail(cid: model.customerID) { (status) in
                            if(model.detailType == 3){
                                
                                // Lead
                                if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
                                    if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
                                        
                                        if let leadobj = Lead.getLeadByID(Id: Int(leadobj.iD)){
                                            
                                            if(leadobj.influencerID > 0){
                                                
                                            }else{
                                                leadobj.influencerID =  0
                                            }
                                            if(leadobj.secondInfluencerID > 0){
                                                
                                            }else{
                                                leadobj.secondInfluencerID = 0
                                            }
                                            leadDetail.lead = leadobj
                                        }
                                        leadDetail.isHistory = false
                                        leadDetail.redirectTo =  0
                                        // leadDetail.lead =   arrOfLead[indexPath.row]
                                        //        visitDetail.planvisit = arrOfplanvisit[indexPath.row]
                                        //        if(visitDetail.planvisit?.visitStatusID == 3){
                                        //            visitDetail.visitType = VisitType.manualvisit
                                        //        }else{
                                        //            visitDetail.visitType = VisitType.planedvisit
                                        //        }
                                        self.navigationController?.pushViewController(leadDetail, animated: true)
                                    }
                                }else{
                                    self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Detail")
                                    //  self.tblSalesPlan.makeToast("Please relogin firstdata of this lead is not synced yet")
                                }
                            }else if(model.detailType == 2){
                                // plan visit
                                if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
                                {
                                    visitDetail.redirectTo =  0
                                    if let objVisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                                        visitDetail.planvisit = objVisit //arrOfplanvisit[indexPath.row]
                                        if let status =  visitDetail.planvisit?.visitStatusID {
                                            if(status == 3){
                                                visitDetail.visitType = VisitType.manualvisit
                                            }else{
                                                visitDetail.visitType = VisitType.planedvisit
                                            }
                                            
                                        }else{
                                            visitDetail.visitType = VisitType.planedvisit
                                        }
                                        self.navigationController?.pushViewController(visitDetail, animated: true)
                                    }else{
                                        self.getplanvisitDetial(visitId: model.modulePrimaryID,ForAction:"Detail", model: model)
                                        
                                        
                                        if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                                            visitDetail.planvisit = planvisit //arrOfplanvisit[indexPath.row]
                                            if let status =  visitDetail.planvisit?.visitStatusID {
                                                if(status == 3){
                                                    visitDetail.visitType = VisitType.manualvisit
                                                }else{
                                                    visitDetail.visitType = VisitType.planedvisit
                                                }
                                                
                                            }else{
                                                visitDetail.visitType = VisitType.planedvisit
                                            }
                                            self.navigationController?.pushViewController(visitDetail, animated: true)
                                        }else{
                                            
                                        }
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func visitReportTapped(cell:SalesPlanCell)->(){
        if let indexPath = tblSalesPlan.indexPath(for: cell) as? IndexPath{
            let model = self.arrSalesplanmodelForDisplay[indexPath.row]
            if(model.detailType == 3){
                /*
                 if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
                 if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
                 
                 if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
                 
                 if(leadobj.influencerID > 0){
                 
                 }else{
                 leadobj.influencerID =  0
                 }
                 if(leadobj.secondInfluencerID > 0){
                 
                 }else{
                 leadobj.secondInfluencerID = 0
                 }
                 leadDetail.lead = leadobj
                 }
                 leadDetail.isHistory = false
                 leadDetail.redirectTo =  0
                 // leadDetail.lead =   arrOfLead[indexPath.row]
                 //        visitDetail.planvisit = arrOfplanvisit[indexPath.row]
                 //        if(visitDetail.planvisit?.visitStatusID == 3){
                 //            visitDetail.visitType = VisitType.manualvisit
                 //        }else{
                 //            visitDetail.visitType = VisitType.planedvisit
                 //        }
                 self.navigationController?.pushViewController(leadDetail, animated: true)
                 }
                 }else{
                 self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Detail")
                 //  self.tblSalesPlan.makeToast("Please relogin firstdata of this lead is not synced yet")
                 }
                 
                 **/
                if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
                    //Lead
                    if  let leadupdatestatus = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadStatusUpdate) as? UpdateLeadStatus{
                        if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
                            
                            
                            if(leadobj.influencerID > 0){
                                
                            }else{
                                leadobj.influencerID =  0
                            }
                            if(leadobj.secondInfluencerID > 0){
                                
                            }else{
                                leadobj.secondInfluencerID = 0
                            }
                            
                            leadupdatestatus.objLead = leadobj
                        }
                        self.navigationController?.pushViewController(leadupdatestatus, animated: true)
                    }
                }else{
                    self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Report")
                    // self.tblSalesPlan.makeToast("Please relogin firstdata of this lead is not synced yet")
                }
                
            }else if(model.detailType == 2){
                //plan visit
                if  let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
                    if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                        let visitreportList =  planvisit.visitStatusList
                        visitReport.visitType =  VisitType.planedvisit
                        visitReport.isFromVisit = false
                        if(visitreportList.count ?? 0 > 0){
                            visitReport.isupdateReport = true
                            visitReport.planVisit = planvisit
                            visitReport.latestvisitreport = visitreportList.lastObject as? VisitStatus
                        }else{
                            visitReport.isupdateReport = false
                            visitReport.planVisit = planvisit
                        }
                        self.navigationController?.pushViewController(visitReport, animated: true)
                    }else{
                        self.getplanvisitDetial(visitId: model.modulePrimaryID,ForAction:"Report", model: model)
                        
                    }
                }
            }else
            {
                if let indexPath = self.tblSalesPlan.indexPath(for: cell) as? IndexPath{
                    let model = self.arrSalesplanmodelForDisplay[indexPath.row]
                    if let selectedCustomer = CustomerDetails.getCustomerByID(cid: model.customerID) as? CustomerDetails{
                        
                        
                        if(model.detailType == 4){
                            //Activity Report
                            // if let objActivity = Activity().getActivityFromId(userID: model.modulePrimaryID) as? Activity{
                            if let activity =  Activity().getActivityFromId(userID: model.modulePrimaryID) as? Activity{
                                if(activity.statusDescription.count > 0){
                                    Utils.toastmsg(message:"Report is already submitted.",view: self.view)
                                    
                                }else{
                                    if let activityReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityReport) as? ActivityReport{
                                        activityReport.activityId = model.modulePrimaryID
                                        activityReport.activitymodel = activity
                                        self.navigationController?.pushViewController(activityReport, animated: true)
                                    }
                                }
                            }else{
                                self.getActivityDetail(activityId:model.modulePrimaryID ?? NSNumber.init(value:0), ForAction: "Report", model: model)
                            }
                        }else if(model.detailType == 5){
                            self.getColdCallVisitDetail(id: model.modulePrimaryID){  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                let arrOFunplanvisit = arr as? [[String:Any]] ?? [[String:Any]]()
                                if  let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
                                    let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
                                    if  let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
                                            as? UnplannedVisit{
                                        let visitreportList =  unplanvisitobj.visitStatusList
                                        visitReport.visitType =  VisitType.coldcallvisit
                                        visitReport.isFromVisit = false
                                        if(visitreportList?.count ?? 0 > 0){
                                            visitReport.isupdateReport = true
                                            visitReport.unplanVisit = unplanvisitobj
                                            self.activeunplanvisit = unplanvisitobj
                                            visitReport.unplanvisitReport = visitreportList?.last as? VisitStatusList
                                        }else{
                                            visitReport.isupdateReport = false
                                            visitReport.unplanVisit = unplanvisitobj
                                        }
                                    }
                                    self.navigationController?.pushViewController(visitReport, animated: true)
                                }else{
                                    self.tblSalesPlan.makeToast("Please relogin once")
                                }
                                
                                
                                //                if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
                                //                  {
                                //            visitDetail.redirectTo =  0
                                //            visitDetail.visitType = VisitType.coldcallvisit
                                //    //let unplanvisitobj = UnplannedVisit().initwithdic(dict: dic)
                                //        let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
                                //     //    if let unplanvisitDic = unplanvisitdic{
                                //        let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
                                //            visitDetail.unplanvisit =  unplanvisitobj
                                //         //}
                                //        self.navigationController?.pushViewController(visitDetail, animated: true)
                                //                }
                                
                            }
                            /*  let obj = aBeatplanvisitList[sender.tag]
                             if  let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
                             visitReport.isHome =  false
                             if(type(of: obj) == PlannVisit.self){
                             let planvisit = obj as? PlannVisit
                             visitReport.visitType  = VisitType.planedvisit
                             let visitreportList =  planvisit?.visitStatusList
                             if(visitreportList?.count ?? 0 > 0){
                             visitReport.isupdateReport = true
                             visitReport.planVisit = planvisit
                             visitReport.latestvisitreport = visitreportList?.lastObject as? VisitStatus
                             }else{
                             visitReport.isupdateReport = false
                             visitReport.planVisit = planvisit
                             }
                             self.navigationController?.pushViewController(visitReport, animated: true)
                             }else if(type(of: obj) == UnplannedVisit.self){
                             let unplanvisit = obj as? UnplannedVisit
                             visitReport.visitType  = VisitType.coldcallvisit
                             visitReport.unplanvisit = unplanvisit
                             self.navigationController?.pushViewController(visitReport, animated: true)
                             
                             }
                             
                             }*/
                            //        if(type(of: obj) == PlannVisit.self){
                            //            if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                            //            let planvisit = obj as? PlannVisit
                            //            visitDetail.visitType = VisitType.planedvisit
                            //
                            //            visitDetail.planvisit = planvisit
                            //            visitDetail.redirectTo = 1
                            //            self.navigationController?.pushViewController(visitDetail, animated: true)
                            //            }
                            //        }else if(type(of: obj) == UnplannedVisit.self){
                            //            if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                            //            let unplanvisit = obj as? UnplannedVisit
                            //            visitDetail.visitType = VisitType.coldcallvisit
                            //
                            //            visitDetail.unplanvisit = unplanvisit
                            //            visitDetail.redirectTo = 1
                            //            self.navigationController?.pushViewController(visitDetail, animated: true)
                            //            }
                            //      }
                            
                        }
                    }else{
                        Utils().getCustomerDetail(cid: model.customerID) { (status) in
                            if(model.detailType == 4){
                                //Activity Report
                                // if let objActivity = Activity().getActivityFromId(userID: model.modulePrimaryID) as? Activity{
                                if let activity =  Activity().getActivityFromId(userID: model.modulePrimaryID) as? Activity{
                                    if(activity.statusDescription.count > 0){
                                        Utils.toastmsg(message:"Report is already submitted.",view: self.view)
                                        
                                    }else{
                                        if let activityReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityReport) as? ActivityReport{
                                            activityReport.activityId = model.modulePrimaryID
                                            activityReport.activitymodel = activity
                                            self.navigationController?.pushViewController(activityReport, animated: true)
                                        }
                                    }
                                }else{
                                    self.getActivityDetail(activityId:model.modulePrimaryID ?? NSNumber.init(value:0), ForAction: "Report", model: model)
                                }
                            }else if(model.detailType == 5){
                                self.getColdCallVisitDetail(id: model.modulePrimaryID){  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                    let arrOFunplanvisit = arr as? [[String:Any]] ?? [[String:Any]]()
                                    if  let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
                                        let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
                                        if  let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
                                                as? UnplannedVisit{
                                            let visitreportList =  unplanvisitobj.visitStatusList
                                            visitReport.visitType =  VisitType.coldcallvisit
                                            visitReport.isFromVisit = false
                                            if(visitreportList?.count ?? 0 > 0){
                                                visitReport.isupdateReport = true
                                                visitReport.unplanVisit = unplanvisitobj
                                                self.activeunplanvisit = unplanvisitobj
                                                visitReport.unplanvisitReport = visitreportList?.last as? VisitStatusList
                                            }else{
                                                visitReport.isupdateReport = false
                                                visitReport.unplanVisit = unplanvisitobj
                                            }
                                        }
                                        self.navigationController?.pushViewController(visitReport, animated: true)
                                    }else{
                                        self.tblSalesPlan.makeToast("Please relogin once")
                                    }
                                    
                                    
                                    //                if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
                                    //                  {
                                    //            visitDetail.redirectTo =  0
                                    //            visitDetail.visitType = VisitType.coldcallvisit
                                    //    //let unplanvisitobj = UnplannedVisit().initwithdic(dict: dic)
                                    //        let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
                                    //     //    if let unplanvisitDic = unplanvisitdic{
                                    //        let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
                                    //            visitDetail.unplanvisit =  unplanvisitobj
                                    //         //}
                                    //        self.navigationController?.pushViewController(visitDetail, animated: true)
                                    //                }
                                    
                                }
                                /*  let obj = aBeatplanvisitList[sender.tag]
                                 if  let visitReport = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitReport) as? VisitReport{
                                 visitReport.isHome =  false
                                 if(type(of: obj) == PlannVisit.self){
                                 let planvisit = obj as? PlannVisit
                                 visitReport.visitType  = VisitType.planedvisit
                                 let visitreportList =  planvisit?.visitStatusList
                                 if(visitreportList?.count ?? 0 > 0){
                                 visitReport.isupdateReport = true
                                 visitReport.planVisit = planvisit
                                 visitReport.latestvisitreport = visitreportList?.lastObject as? VisitStatus
                                 }else{
                                 visitReport.isupdateReport = false
                                 visitReport.planVisit = planvisit
                                 }
                                 self.navigationController?.pushViewController(visitReport, animated: true)
                                 }else if(type(of: obj) == UnplannedVisit.self){
                                 let unplanvisit = obj as? UnplannedVisit
                                 visitReport.visitType  = VisitType.coldcallvisit
                                 visitReport.unplanvisit = unplanvisit
                                 self.navigationController?.pushViewController(visitReport, animated: true)
                                 
                                 }
                                 
                                 }*/
                                //        if(type(of: obj) == PlannVisit.self){
                                //            if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                                //            let planvisit = obj as? PlannVisit
                                //            visitDetail.visitType = VisitType.planedvisit
                                //
                                //            visitDetail.planvisit = planvisit
                                //            visitDetail.redirectTo = 1
                                //            self.navigationController?.pushViewController(visitDetail, animated: true)
                                //            }
                                //        }else if(type(of: obj) == UnplannedVisit.self){
                                //            if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                                //            let unplanvisit = obj as? UnplannedVisit
                                //            visitDetail.visitType = VisitType.coldcallvisit
                                //
                                //            visitDetail.unplanvisit = unplanvisit
                                //            visitDetail.redirectTo = 1
                                //            self.navigationController?.pushViewController(visitDetail, animated: true)
                                //            }
                                //      }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    func iconEditCustomerClicked(cell:SalesPlanCell){
        if let indexPath = tblSalesPlan.indexPath(for: cell) as? IndexPath{
            let model = self.arrSalesplanmodelForDisplay[indexPath.row]
            if let selectedCustomer = CustomerDetails.getCustomerByID(cid: model.customerID) as? CustomerDetails{
                if let customerviewobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                    customerviewobj.selectedCustomer =  selectedCustomer
                    customerviewobj.isVendor = false
                    customerviewobj.isEditCustomer = true
                    customerviewobj.isFromColdCallVisit = false
                    self.navigationController?.pushViewController(customerviewobj, animated: true)
                }
            }else{
                Utils().getCustomerDetail(cid: model.customerID) { (status) in
                    if let selectedCustomer = CustomerDetails.getCustomerByID(cid: model.customerID) as? CustomerDetails{
                        if let customerviewobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                            customerviewobj.selectedCustomer =  selectedCustomer
                            customerviewobj.isVendor = false
                            customerviewobj.isEditCustomer = true
                            customerviewobj.isFromColdCallVisit = false
                            self.navigationController?.pushViewController(customerviewobj, animated: true)
                        }
                    }
                }
            }
        }
    }
    func orderFromClickedTapped(cell:SalesPlanCell){
        if let indexPath = self.tblSalesPlan.indexPath(for: cell) as? IndexPath{
            let model = self.arrSalesplanmodelForDisplay[indexPath.row]
            if(model.detailType == 2 || model.detailType == 3){
                if let selectedCustomer = CustomerDetails.getCustomerByID(cid: model.customerID) as? CustomerDetails{
                    
                    if(model.detailType == 2){
                        // plan visit
                        
                        if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                                
                                guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: planvisit.customerID ?? 0)), cust.statusID == 2 else {
                                    Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""),view:self.view)
                                    return
                                }
                                vc.objVisit = planvisit
                                
                                self.navigationController!.pushViewController(vc, animated: true)
                            }
                        }else{
                            self.getplanvisitDetial(visitId: model.modulePrimaryID, ForAction: "Order", model: model)
                        }
                        
                    }else if(model.detailType == 3){
                        //Lead
                        
                        
                        
                        if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
                            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                                
                                guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: leadobj.customerID ?? 0)), cust.statusID == 2 else {
                                    Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""),view:self.view)
                                    return
                                }
                                vc.lead = leadobj
                                self.navigationController!.pushViewController(vc, animated: true)
                            }}else{
                                self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Order")
                                //  self.tblSalesPlan.makeToast("Please Relogin first ,")
                            }
                        
                        
                    }
                }else{
                    Utils().getCustomerDetail(cid: model.customerID) { (status) in
                        if(model.detailType == 2){
                            // plan visit
                            
                            if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                                if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                                    
                                    guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: planvisit.customerID ?? 0)), cust.statusID == 2 else {
                                        Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""),view:self.view)
                                        return
                                    }
                                    vc.objVisit = planvisit
                                    
                                    self.navigationController!.pushViewController(vc, animated: true)
                                }
                            }else{
                                self.getplanvisitDetial(visitId: model.modulePrimaryID, ForAction: "Order", model: model)
                            }
                            
                        }else if(model.detailType == 3){
                            //Lead
                            
                            
                            
                            if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
                                if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                                    
                                    guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: leadobj.customerID ?? 0)), cust.statusID == 2 else {
                                        Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""),view:self.view)
                                        return
                                    }
                                    vc.lead = leadobj
                                    self.navigationController!.pushViewController(vc, animated: true)
                                }}else{
                                    self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Order")
                                    //  self.tblSalesPlan.makeToast("Please Relogin first ,")
                                }
                            
                            
                        }
                    }
                }
                
            }
            else if(model.detailType == 4){
                //activity
            }else if(model.detailType == 5){
                //cold call
            }
        }
        
    }
    
    func visitCheckinTapped(cell:SalesPlanCell){
        print("btn check in tapped")
        if let indexPath = tblSalesPlan.indexPath(for: cell) as? IndexPath{
            let model = self.arrSalesplanmodelForDisplay[indexPath.row]
            if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
                if((CLLocationCoordinate2DIsValid(currentCoordinate)) && (currentCoordinate.latitude != 0.0 && currentCoordinate.longitude != 0.0)){
                    
                    if(model.detailType == 2){
                        
                        
                        if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID){
                            //                        selectedplanvisit = planvisit
                            activeVisitType = VisitType.planedvisit
                            activeplanvisit = planvisit
                            let (message,lastcheckinStatus) =  Utils.latestCheckinDetailForPlanedVisit(visit: planvisit)
                            if(model.isCheckedIn || lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
                                
                                
                                if(cell.lblCheckinTitle.text?.lowercased() == "checkout"){
                                    arrSelectedVisitStep = [StepVisitList]()
                                    
                                    
                                    if(self.activesetting.visitStepsRequired ==  1 && arrvisitStep.count > 0){
                                        if let selectedcustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: planvisit.customerID ?? 0)) as?  CustomerDetails{
                                            
                                            Utils().filterStepAccordingToCustTypeCustSegment(arrOfVisitStep: arrvisitStep, customer: selectedcustomer) { arrOffilteredStep in
                                                self.arrvisitStep = arrOffilteredStep
                                            }
                                            
                                        }
                                        if(arrvisitStep.count == 0){
                                            self.finalCheckout(visitType: VisitType.planedvisit)
                                            return
                                        }
                                        
                                        self.visitStepsStatusCheck(visitType: VisitType.planedvisit,planvisit: planvisit,unplanvisit: UnplannedVisit(), model: model)
                                        
                                        arrofmandatoryStep = arrvisitStep.filter{
                                            $0.mandatoryOrOptional == true
                                        }
                                        
                                        if let visit = planvisit as? PlannVisit{
                                            if let selectedcustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: visit.customerID)) as?  CustomerDetails{
                                                let companytypeid = NSNumber.init(value:selectedcustomer.companyTypeID)
                                                let segment = NSNumber.init(value:selectedcustomer.segmentID)
                                                for stepvisit in arrofmandatoryStep{
                                                    if let visitStatusType = stepvisit.customerType as? String{
                                                        if let visitStatusSegment = stepvisit.customerSegment as? String{
                                                            if(visitStatusType.lowercased() == "off" || visitStatusSegment.lowercased() == "off"){
                                                                arrofmandatoryStep.filter{
                                                                    $0 != stepvisit
                                                                }
                                                                
                                                                //as grishma said so
                                                                arrvisitStep.filter{
                                                                    $0 != stepvisit
                                                                }
                                                            }else{
                                                                let arrOfKYCType = visitStatusType.components(separatedBy: ",")
                                                                let arrOfKYCSegment = visitStatusSegment.components(separatedBy: ",")
                                                                print("arr of kyc = \(arrOfKYCType) and \(companytypeid) , arr of segment = \(arrOfKYCSegment) and \(segment) , visitstatus type = \(visitStatusType) , visitstatussegment = \(visitStatusSegment)")
                                                                if(arrOfKYCType.contains(companytypeid.stringValue) && arrOfKYCSegment.contains(segment.stringValue) || (visitStatusType == "999999" && visitStatusSegment == "0")){
                                                                    
                                                                }else{
                                                                    arrofmandatoryStep.filter{
                                                                        $0 != stepvisit
                                                                    }
                                                                    //as grishma said so
                                                                    arrvisitStep.filter{
                                                                        $0 != stepvisit
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                    else{
                                        //check out
                                        self.finalCheckout(visitType: VisitType.planedvisit)
                                    }
                                    
                                }else{
                                    Utils.toastmsg(message: "You are already Checked in , please checkout first", view: self.view)
                                }
                            }else{
                                
                                //check in
                                VisitCheckinCheckout.verifyAddress = false
                                VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: currentCoordinate.latitude) ,long:NSNumber.init(value:currentCoordinate.longitude), isVisitPlanned: VisitType.planedvisit, objplannedVisit: planvisit  ,objunplannedVisit:  UnplannedVisit(), visitid: NSNumber.init(value:planvisit.iD) ,viewcontroller:self, addressID: NSNumber.init(value:0))
                                
                                
                                
                            }
                            
                            
                            
                        }else{
                            self.getplanvisitDetial(visitId: model.modulePrimaryID, ForAction: "Checkin", model: model)
                        }
                        
                    }else if(model.detailType == 3){
                        
                        self.arrOfListInfluencer = [CustomerDetails]()
                        if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
                            if(model.isCheckedIn && leadobj.leadCheckInOutList.count == 0){
                                self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Checkin")
                            }else{
                                selectedlead =  leadobj
                                
                                if   let  firstinfluencerid = leadobj.influencerID as? Int64{
                                    if let secondinflencerid = leadobj.secondInfluencerID as? Int64{
                                        
                                        
                                        if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.influencerID ?? 0)){
                                            arrOfListInfluencer.append(firstinfluencer)
                                            self.arrOfSelectedInfluerncer.append(firstinfluencer)
                                        }
                                        if  let secondinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.secondInfluencerID ?? 0)){
                                            arrOfListInfluencer.append(secondinfluencer)
                                        }
                                    }
                                    //            }else{
                                    //                if(arrOfListInfluencer.count == 0){
                                    //                if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.influencerID ?? 0)){
                                    //                  arrOfListInfluencer.append(firstinfluencer)
                                    //              self.arrOfSelectedInfluerncer.append(firstinfluencer)
                                    //                        }
                                    //                }
                                    //            }
                                }
                                //                    let arrOfLeadCheckinOut = leadobj.leadCheckInOutList.array
                                //                    if( model.checkInTime?.count ?? 0 > 0 && arrOfLeadCheckinOut.count > 0){
                                
                                let (message,lastcheckinLeadStatus) =  Utils.latestCheckinDetailForLead(lead:selectedlead)
                                if(model.isCheckedIn || lastcheckinLeadStatus == UserLatestActivityForLead.checkedIn){
                                    
                                    
                                    
                                    if let lastcheckin =  leadobj.leadCheckInOutList[0] as? LeadCheckInOutList{
                                        LeadCheckinCheckout.verifyLeadCheckoutAddress = false
                                        LeadCheckinCheckout().checkoutLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: leadobj, cust: lastcheckin.checkInFrom , viewcontroller:  self)
                                    }
                                    
                                    //  }
                                    /*else{
                                     Utils.toastmsg(message:"Please do relog-in first")
                                     }*/
                                }else if((model.checkInTime?.count == 0) && (arrOfListInfluencer.count == 0)){
                                    LeadCheckinCheckout.verifyAddress = false
                                    
                                    LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: leadobj, cust: "C" , viewcontroller:  self)
                                }else{
                                    
                                    
                                    if((self.activesetting.influencerInLead == NSNumber.init(value:1)) && (leadobj.influencerID > 0)){
                                        // let custPopup
                                        self.popup =    Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                                        self.popup?.modalPresentationStyle = .overCurrentContext
                                        self.popup?.isFromSalesOrder =  false
                                        self.popup?.strTitle = "To"
                                        self.popup?.nonmandatorydelegate = self
                                        self.popup?.arrOfCustomerClass = arrOfLeadCheckinoption
                                        self.popup?.arrOfSelectedClass = arrOfSelectedLeadCheckinoption
                                        self.popup?.strLeftTitle = "OK"
                                        self.popup?.strRightTitle = "Cancel"
                                        self.popup?.parentViewOfPopup = self.view
                                        self.popup?.selectionmode = SelectionMode.single
                                        self.popup?.isSearchBarRequire = false
                                        self.popup?.viewfor = ViewFor.customerClass
                                        self.popup?.isFilterRequire = false
                                        Utils.addShadow(view: self.view)
                                        
                                        //Utils.addShadow(view: self.view.superview ?? self.view)
                                        self.present(self.popup!, animated: false, completion: nil)
                                        
                                    }else{
                                        LeadCheckinCheckout.verifyAddress = false
                                        
                                        LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: leadobj, cust: "C" , viewcontroller: self)
                                    }
                                }
                            }
                        }else{
                            self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Checkin")
                            //  self.tblSalesPlan.makeToast("Please Relogin first ,")
                        }
                        
                    }else if(model.detailType == 5){
                        activeVisitType = VisitType.coldcallvisit
                        self.getColdCallVisitDetail(id: model.modulePrimaryID){  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                            let arrOFunplanvisit = arr as? [[String:Any]] ?? [[String:Any]]()
                            
                            
                            let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
                            //    if let unplanvisitDic = unplanvisitdic{
                            if  let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
                                    as? UnplannedVisit{
                                
                                self.activeunplanvisit = unplanvisitobj
                                let (message,lastcheckinStatus) = Utils.latestCheckinDetailForUnPlanedVisit(visit: unplanvisitobj) //Utils.latestCheckinDetailForPlanedVisit(visit: objVisit)
                                
                                if(lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
                                    self.finalCheckout(visitType: VisitType.coldcallvisit)
                                    
                                }else{
                                    self.activeunplanvisit = unplanvisitobj
                                    VisitCheckinCheckout.verifyAddress = false
                                    VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: self.currentCoordinate.latitude) ,long:NSNumber.init(value:self.currentCoordinate.longitude), isVisitPlanned: VisitType.coldcallvisit, objplannedVisit: PlannVisit()  ,objunplannedVisit: unplanvisitobj, visitid: model.modulePrimaryID ,viewcontroller:self.parent ?? self, addressID: NSNumber.init(value:0))
                                }
                            }
                        }
                        //   VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: currentCoordinate.latitude) ,long:NSNumber.init(value:currentCoordinate.longitude), isVisitPlanned: VisitType.coldcallvisit, objplannedVisit: PlannVisit()  ,objunplannedVisit:  UnplannedVisit(), visitid: model.modulePrimaryID ,viewcontroller:self.parent ?? self, addressID: NSNumber.init(value:0))
                    }
                    
                    
                    else if(model.detailType == 4){
                        
                        //Activity().getActivityFromId(userID: model.modulePrimaryID){
                        print("activity id = \(model.modulePrimaryID)")
                        if let activity = Activity().getActivityFromId(userID: model.modulePrimaryID){
                            
                            if(model.checkInTime?.count ?? 0 > 0){
                                ActivityCheckinCheckoutClass().activityCheckout(lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), viewcontroller: self, activityID:model.modulePrimaryID)
                            }else{
                                //                    ActivityCheckinCheckoutClass().activityCheckin(lat: NSNumber.init(value: currentCoordinate.latitude), long: NSNumber.init(value: currentCoordinate.longitude), viewcontroller: self, activityID: NSNumber.init(value:aid))
                                
                                ActivityCheckinCheckoutClass().activityCheckin(lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), viewcontroller: self, activityID: model.modulePrimaryID)
                            }
                        }else{
                            self.getActivityDetail(activityId:model.modulePrimaryID ?? NSNumber.init(value:0), ForAction: "Checkin",model:model)
                        }
                        
                        
                        
                    }else{
                        if(currentCoordinate.latitude == 0 || currentCoordinate.longitude == 0 ){
                            self.tblSalesPlan.makeToast("Please check your GPS and refresh the location")
                            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                            let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                                
                            }
                            Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
                        }else{
                            
                        }
                    }
                    
                }
                else{
                    print("not get proper lat long  \(currentCoordinate.latitude) , \(currentCoordinate.longitude) , sahred = \(Location.currentLocationcoordinate)")
                    if(CLLocationCoordinate2DIsValid(Location.currentLocationcoordinate ?? CLLocationCoordinate2D()) && (Location.currentLocationcoordinate?.latitude != 0.0 && Location.currentLocationcoordinate?.longitude != 0.0)){
                        //currentCoordinate = Location.currentLocationcoordinate
                        if(model.detailType == 2){
                            
                            
                            if let planvisit = PlannVisit.getVisit(visitID: model.modulePrimaryID){
                                //                        selectedplanvisit = planvisit
                                activeplanvisit = planvisit
                                let (message,lastcheckinStatus) =  Utils.latestCheckinDetailForPlanedVisit(visit: planvisit)
                                if(model.isCheckedIn || lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
                                    
                                    
                                    if(cell.lblCheckinTitle.text?.lowercased() == "checkout"){
                                        arrSelectedVisitStep = [StepVisitList]()
                                        
                                        
                                        if(self.activesetting.visitStepsRequired ==  1 && arrvisitStep.count > 0){
                                            
                                            
                                            arrofmandatoryStep = arrvisitStep.filter{
                                                $0.mandatoryOrOptional == true
                                            }
                                            
                                            self.visitStepsStatusCheck(visitType: VisitType.planedvisit,planvisit: planvisit,unplanvisit: UnplannedVisit(), model: model)
                                            /*    if  let popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection{
                                             popup.isFromSalesOrder =  false
                                             popup.modalPresentationStyle = .overCurrentContext
                                             popup.strTitle = "Visit Steps"
                                             popup.nonmandatorydelegate = self
                                             popup.arrOfVisitStep = arrvisitStep
                                             popup.arrOfSelectedVisitStep = arrSelectedVisitStep ?? [StepVisitList]() //arrSelectedVisitStep
                                             popup.arrOfDisableVisitStep = arrSelectedVisitStep ?? [StepVisitList]()
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
                                             }*/
                                        }
                                        else{
                                            //check out
                                            self.finalCheckout(visitType: VisitType.planedvisit)
                                        }
                                    }else{
                                        Utils.toastmsg(message: "You are already Checked in , please checkout first", view: self.view)
                                    }
                                }else{
                                    
                                    //check in
                                    VisitCheckinCheckout.verifyAddress = false
                                    VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: currentCoordinate.latitude) ,long:NSNumber.init(value:currentCoordinate.longitude), isVisitPlanned: VisitType.planedvisit, objplannedVisit: planvisit  ,objunplannedVisit:  UnplannedVisit(), visitid: NSNumber.init(value:planvisit.iD) ,viewcontroller:self, addressID: NSNumber.init(value:0))
                                }
                                
                                
                                
                            }else{
                                self.getplanvisitDetial(visitId: model.modulePrimaryID, ForAction: "Checkin", model: model)
                            }
                            
                        }else if(model.detailType == 3){
                            
                            self.arrOfListInfluencer = [CustomerDetails]()
                            if let leadobj = Lead.getLeadByID(Id: model.modulePrimaryID.intValue){
                                if(model.isCheckedIn && leadobj.leadCheckInOutList.count == 0){
                                    self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Checkin")
                                }else{
                                    selectedlead =  leadobj
                                    
                                    if   let  firstinfluencerid = leadobj.influencerID as? Int64{
                                        if let secondinflencerid = leadobj.secondInfluencerID as? Int64{
                                            
                                            
                                            if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.influencerID ?? 0)){
                                                arrOfListInfluencer.append(firstinfluencer)
                                                self.arrOfSelectedInfluerncer.append(firstinfluencer)
                                            }
                                            if  let secondinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.secondInfluencerID ?? 0)){
                                                arrOfListInfluencer.append(secondinfluencer)
                                            }
                                        }
                                        //            }else{
                                        //                if(arrOfListInfluencer.count == 0){
                                        //                if let firstinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:leadobj.influencerID ?? 0)){
                                        //                  arrOfListInfluencer.append(firstinfluencer)
                                        //              self.arrOfSelectedInfluerncer.append(firstinfluencer)
                                        //                        }
                                        //                }
                                        //            }
                                    }
                                    //                    let arrOfLeadCheckinOut = leadobj.leadCheckInOutList.array
                                    //                    if( model.checkInTime?.count ?? 0 > 0 && arrOfLeadCheckinOut.count > 0){
                                    
                                    let (message,lastcheckinLeadStatus) =  Utils.latestCheckinDetailForLead(lead:selectedlead)
                                    if(model.isCheckedIn || lastcheckinLeadStatus == UserLatestActivityForLead.checkedIn){
                                        
                                        
                                        
                                        if let lastcheckin =  leadobj.leadCheckInOutList[0] as? LeadCheckInOutList{
                                            LeadCheckinCheckout.verifyLeadCheckoutAddress = false
                                            LeadCheckinCheckout().checkoutLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: leadobj, cust: lastcheckin.checkInFrom , viewcontroller:  self)
                                        }
                                        
                                        //  }
                                        /*else{
                                         Utils.toastmsg(message:"Please do relog-in first")
                                         }*/
                                    }else if((model.checkInTime?.count == 0) && (arrOfListInfluencer.count == 0)){
                                        LeadCheckinCheckout.verifyAddress = false
                                        
                                        LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: leadobj, cust: "C" , viewcontroller:  self)
                                    }else{
                                        
                                        
                                        if((self.activesetting.influencerInLead == NSNumber.init(value:1)) && (leadobj.influencerID > 0)){
                                            // let custPopup
                                            self.popup =    Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                                            self.popup?.modalPresentationStyle = .overCurrentContext
                                            self.popup?.isFromSalesOrder =  false
                                            self.popup?.strTitle = "To"
                                            self.popup?.nonmandatorydelegate = self
                                            self.popup?.arrOfCustomerClass = arrOfLeadCheckinoption
                                            self.popup?.arrOfSelectedClass = arrOfSelectedLeadCheckinoption
                                            self.popup?.strLeftTitle = "OK"
                                            self.popup?.strRightTitle = "Cancel"
                                            self.popup?.parentViewOfPopup = self.view
                                            self.popup?.selectionmode = SelectionMode.single
                                            self.popup?.isSearchBarRequire = false
                                            self.popup?.viewfor = ViewFor.customerClass
                                            self.popup?.isFilterRequire = false
                                            Utils.addShadow(view: self.view)
                                            
                                            //Utils.addShadow(view: self.view.superview ?? self.view)
                                            self.present(self.popup!, animated: false, completion: nil)
                                            
                                        }else{
                                            LeadCheckinCheckout.verifyAddress = false
                                            
                                            LeadCheckinCheckout().checkinLead(leadstatus: 0, lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), objlead: leadobj, cust: "C" , viewcontroller: self)
                                        }
                                    }
                                }
                            }else{
                                self.getLeadDetailsFor(model: model, leadId: model.modulePrimaryID, ForAction: "Checkin")
                                //  self.tblSalesPlan.makeToast("Please Relogin first ,")
                            }
                            
                        }else if(model.detailType == 5){
                            self.getColdCallVisitDetail(id: model.modulePrimaryID){  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                                let arrOFunplanvisit = arr as? [[String:Any]] ?? [[String:Any]]()
                                
                                
                                let unplanvisitdic = arrOFunplanvisit.first as? [String:Any] ?? [String:Any]()
                                //    if let unplanvisitDic = unplanvisitdic{
                                if  let unplanvisitobj = UnplannedVisit().initwithdic(dict: unplanvisitdic)
                                        as? UnplannedVisit{
                                    
                                    
                                    let (message,lastcheckinStatus) = Utils.latestCheckinDetailForUnPlanedVisit(visit: unplanvisitobj) //Utils.latestCheckinDetailForPlanedVisit(visit: objVisit)
                                    
                                    if(lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
                                        self.finalCheckout(visitType: VisitType.coldcallvisit)
                                        
                                    }else{
                                        VisitCheckinCheckout.verifyAddress = false
                                        VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: self.currentCoordinate.latitude) ,long:NSNumber.init(value:self.currentCoordinate.longitude), isVisitPlanned: VisitType.coldcallvisit, objplannedVisit: PlannVisit()  ,objunplannedVisit: unplanvisitobj, visitid: model.modulePrimaryID ,viewcontroller:self.parent ?? self, addressID: NSNumber.init(value:0))
                                    }
                                }
                            }
                            //   VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: currentCoordinate.latitude) ,long:NSNumber.init(value:currentCoordinate.longitude), isVisitPlanned: VisitType.coldcallvisit, objplannedVisit: PlannVisit()  ,objunplannedVisit:  UnplannedVisit(), visitid: model.modulePrimaryID ,viewcontroller:self.parent ?? self, addressID: NSNumber.init(value:0))
                        }
                        
                        
                        else if(model.detailType == 4){
                            
                            //Activity().getActivityFromId(userID: model.modulePrimaryID){
                            print("activity id = \(model.modulePrimaryID)")
                            if let activity = Activity().getActivityFromId(userID: model.modulePrimaryID){
                                
                                if(model.checkInTime?.count ?? 0 > 0){
                                    ActivityCheckinCheckoutClass().activityCheckout(lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), viewcontroller: self, activityID:model.modulePrimaryID)
                                }else{
                                    //                    ActivityCheckinCheckoutClass().activityCheckin(lat: NSNumber.init(value: currentCoordinate.latitude), long: NSNumber.init(value: currentCoordinate.longitude), viewcontroller: self, activityID: NSNumber.init(value:aid))
                                    
                                    ActivityCheckinCheckoutClass().activityCheckin(lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value:currentCoordinate.longitude), viewcontroller: self, activityID: model.modulePrimaryID)
                                }
                            }else{
                                self.getActivityDetail(activityId:model.modulePrimaryID ?? NSNumber.init(value:0), ForAction: "Checkin",model:model)
                            }
                            
                            
                            
                        }else{
                            if(currentCoordinate.latitude == 0 || currentCoordinate.longitude == 0 ){
                                self.tblSalesPlan.makeToast("Please check your GPS and refresh the location")
                                let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                                let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                                    
                                }
                                Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
                            }else{
                                
                            }
                        }
                    }
                }
                
            }
        }
    }
    
}
