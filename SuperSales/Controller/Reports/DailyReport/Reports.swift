//
//  Reports.swift
//  SuperSales
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import CarbonKit
import FastEasyMapping
import CoreData

protocol ReportsDelegate {
    func setData()
}
class Reports: BaseViewController {
    
    //Bottom menu
    let baseviewcontrollerobj = BaseViewController()
    let activeUser = Utils().getActiveAccount()
    var
    dicResult:[String:Any] = [String:Any]()
    var stritemforreport = [String]()
    @IBOutlet var vwSelectUser: UIView!
    var delegateReport:ReportsDelegate?
    var selectedUser:CompanyUsers?
    var selectedUserID:NSNumber = 0
    var sideMenus:[CompanyMenus]!
    var companyMenus:[CompanyMenus]!
    var temp:[UPStackMenuItem]!
    var arrOfBottomTabBar:[MenuTabs]!
    var arrTabbarItem:[UITabBarItem]!
    //   @IBOutlet weak var tabBar: UITabBar!
    var titlesOfButtons:[String]!//= ["Visits","Leads","Ordres"]
    var isHome:Bool!
    var datepicker:UIDatePicker!
    static var selectedDate:String!
    var arrOfExecutive:[CompanyUsers]? =  [CompanyUsers]()
    var arrOfUserExceptExecutive:[CompanyUsers]!
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrLowerLevelUser = [CompanyUsers]()
    var role_id = NSNumber.init(value:0)
    
    var popup:CustomerSelection? = nil
    var isFromValidAttendance:Bool!
    
    @IBOutlet var toolbar: UIToolbar!
    
    
    @IBOutlet var targetView: UIView!
    
    @IBOutlet var btnSelectedDate: UIButton!
    
    @IBOutlet var lblSelectedUser: UILabel!
    
    @IBOutlet var btnSelectUser: UIButton!
    var itemForReport = [MenuTabs]()
    var arrSummary:[[String:Any]] = [[String:Any]]()
    var arrVisit:[[String:Any]] = [[String:Any]]()
    var arrAttendance:[[String:Any]] = [[String:Any]]()
    var arrLead:[[String:Any]] = [[String:Any]]()
    var arrMoment:[[String:Any]] = [[String:Any]]()
    var dicVisit:[String:Any] = [String:Any]()
    var dicAttendance:[String:Any] = [String:Any]()
    var dicLead:[String:Any] = [String:Any]()
    var dicMoment:[String:Any] = [String:Any]()
    var arrMissedLead:[[String:Any]] = [[String:Any]]()
    public static var carbonTabSwipeNavigation:CarbonTabSwipeNavigation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reports"
        self.setUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        //        NotificationCenter.default.addObserver(forName: Notification.Name(Constant.kCurrentDateChange), object: nil, queue: OperationQueue.main) { (notify) in
        //
        //            self.setDateData()
        //
        //      }
        //        selectedUserID.intValue > 0 ? (selectedUser = CompanyUsers().getUser(userId: self.selectedUserID)):(selectedUser = CompanyUsers().getUser(userId:self.activeuser?.userID ?? 0))
        if(selectedUserID.intValue > 0 ){
            selectedUser = CompanyUsers().getUser(userId: self.selectedUserID)
        }else if let user = CompanyUsers().getUser(userId:self.activeuser?.userID ?? 0){
            selectedUser = user
        }else{
            print("not get user ")
        }
        if let user = selectedUser{
            lblSelectedUser.text = String.init(format:"\(user.firstName) \(user.lastName)")
            selectedUserID = user.entity_id
            self.arrOfSelectedExecutive = [user]
        }
        if(isHome !=  false){
            self.setrightbtn(btnType: BtnRight.none,navigationItem: self.tabBarController!.navigationItem)
            self.tabBarController?.navigationItem.title = "Sales Report"
        }else{
            //  self.tabBarController?.navigationItem.title = "Reports"
            self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
            self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("getDailyReports"), object: nil, queue: OperationQueue.main) { (notify) in
            self.getDailyReports()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //        NotificationCenter.default.removeObserver(self, name: Notification.Name(Constant.kCurrentDateChange), object: nil)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("getDailyReports"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //  self.setDateData()
        
        
        self.getDailyReports()
        
    }
    
    //MARK: - Method
    func setDateData(){
        
        
        btnSelectedDate.setAttributedTitle(NSAttributedString.init(string: Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:Date()), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]), for: UIControl.State.normal)
        //        datepicker.date = Date()
        //        Reports.selectedDate = Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepicker.date)
        if(isFromValidAttendance == false){
            datepicker.date = Date()
            Reports.selectedDate = Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepicker.date)
        }
        //btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepicker.date), for: .normal)
        
    }
    func setUI(){
        if(selectedUserID.intValue == 0){
            selectedUserID = self.activeUser?.userID ?? NSNumber.init(value: 0)
        }
        Reports.selectedDate = Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:Date())
        self.parentviewController = self
        self.salesPlandelegateObject = self
        baseviewcontrollerobj.salesPlandelegateObject = self
        
        sideMenus = [CompanyMenus]()
        companyMenus = [CompanyMenus]()
        temp = [UPStackMenuItem]()
        sideMenus = self.createUPStackMenuItems(isFromHome: true, view: self)
        datepicker = UIDatePicker.init()
        datepicker.setCommonFeature()
        datepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 240, width: view.frame.size.width, height: 200))
        datepicker.maximumDate = Date()
        temp = [UPStackMenuItem]()
        
        for tempitem in sideMenus {
            print("\(tempitem.menuID) , \(tempitem.menuLocalText ?? "" )")
            if  let upstackmenu = UPStackMenuItem.init(image: CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16)){
                upstackmenu.isUserInteractionEnabled = true
                temp.append(upstackmenu )
            }
        }
        
        
        self.arrOfExecutive =  BaseViewController.staticlowerUser
        if(self.arrOfExecutive?.count ?? 0 > 0){
            for exec in self.arrOfExecutive ?? [CompanyUsers](){
                if(exec.entity_id == self.activeuser?.userID){
                    self.arrOfSelectedExecutive.append(exec)
                }
            }
        }
        if(BaseViewController.staticlowerUser?.count ?? 0 > 0 ) {
            arrLowerLevelUser = BaseViewController.staticlowerUser!
            if let  roleid = CompanyUsers().getRoleIDFromUserId(userID: self.activeUser?.userID ?? 0){
                role_id = roleid
            }
            itemForReport = Utils.getSubMenuSettings(roleid: role_id)
            
            
        }else {
            if let  roleid = CompanyUsers().getRoleIDFromUserId(userID: self.activeUser?.userID ?? 0){
                role_id = roleid
                itemForReport = Utils.getSubMenuSettings(roleid: role_id)
            }
            //        itemForReport = Utils.getSubMenuSettings(roleid: role_id)
            if(BaseViewController.staticlowerUser.count == 0){
                DispatchQueue.global(qos: .background).async {
                    self.fetchuser{
                        (arrOfuser,error) in
                        
                    }
                }
            }
        }
        if(itemForReport.count > 0){
            itemForReport = itemForReport.filter{
                
                $0.menuID != 15
            }
        }
        if let menusummary = MenuTabs.getTabMenus(menu: [NSNumber.init(value: 23)], sort: true) as? [MenuTabs]{
            if(menusummary.count > 0){
                itemForReport.insert(menusummary.first!, at: 0)
            }
        }
        
        
        let dictionary: [String: Any] = [
            "ID": NSNumber(value: 510),
            "menuID": NSNumber(value: 505),
            "companyID": NSNumber(value: 0),
            "menuValue": "salesReportMissedLead",
            "menuLocalText": "Missed Lead",
            "isVisible": true
        ]
        let context = MenuTabs.getContext()
        self.appendToCoreDataMenuArray(from: dictionary, to: &itemForReport, context: context)
        
        //        itemForReport.append(MenuTabs.init)
        /*
         static let entity:String! = "CompanyMenus"
         @NSManaged var iD : Int32
         @NSManaged var companyID : Int32
         @NSManaged var isVisible : Bool
         @NSManaged var menuID : Int32
         @NSManaged var menuLocalText : String!
         @NSManaged var menuValue : String!
         **/
        stritemforreport = itemForReport.map{
            //print("\($0.menuID) , \($0.menuLocalText)")
            
            $0.menuLocalText
        }
        
        selectedUserID.intValue > 0 ? ( selectedUser = CompanyUsers().getUser(userId: self.selectedUserID)):(selectedUser = CompanyUsers().getUser(userId:self.activeuser?.userID ?? 0))
        
        
        if(stritemforreport.count > 0){
            Reports.carbonTabSwipeNavigation = CarbonTabSwipeNavigation.init(items: stritemforreport, toolBar: toolbar, delegate: self)
            Reports.carbonTabSwipeNavigation?.setNormalColor(.white , font: UIFont.boldSystemFont(ofSize: 16));
            Reports.carbonTabSwipeNavigation.setSelectedColor(.Appthemebluecolor,font: UIFont.boldSystemFont(ofSize: 16))
            
            Reports.carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: targetView)
            Reports.carbonTabSwipeNavigation.setCurrentTabIndex(UInt(0), withAnimation: true)
            
        }else{
            Utils.toastmsg(message:"Menus not available",view: self.view)
        }
        
        
        toolbar.barTintColor = UIColor.init(red: 0/255.0, green: 193/255.0, blue: 216/255.0, alpha: 1)
        if let user = selectedUser{
            lblSelectedUser.text = String.init(format:"\(user.firstName) \(user.lastName)")
            selectedUserID = user.entity_id
            self.arrOfSelectedExecutive = [user]
        }
        if( self.activeuser?.role?.id == NSNumber.init(value:8) ){
            self.vwSelectUser.isHidden = true
        }else{
            self.vwSelectUser.isHidden = false
        }
        // btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:Date()), for: .normal)
        self.setDateData()
        companyMenus = baseviewcontrollerobj.createUPStackMenuItems(isFromHome: true, view: self)
        if(temp.count > 0){
            baseviewcontrollerobj.initbottomMenu(menus:temp , control: self)
        }
        
        
    }
    func appendToCoreDataMenuArray(from dictionary: [String: Any], to menuArray: inout [MenuTabs], context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "MenuTabs", in: context) else {
            print("Failed to create entity description")
            return
        }
        
        let menuTabs = MenuTabs(entity: entity, insertInto: context)
        
        menuTabs.iD = dictionary["ID"] as? Int32 ?? 0
        menuTabs.menuID = dictionary["menuID"] as? Int32 ?? 0
        menuTabs.companyID = dictionary["companyID"] as? Int32 ?? 0
        menuTabs.menuValue = dictionary["menuValue"] as? String ?? ""
        menuTabs.menuLocalText = dictionary["menuLocalText"] as? String ?? ""
        menuTabs.isVisible = dictionary["isVisible"] as? Bool ?? false
        
        menuArray.append(menuTabs)
        
    }
    func setRefresh(){
        
        
        //        if let selectedin = Reports.carbonTabSwipeNavigation.carbonSegmentedControl?.selectedSegmentIndex{
        //            print(selectedin)
        //            let selectedMenu = itemForReport[selectedin]
        //            if(selectedMenu.menuID == 7){
        if let summary = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ReportSummary) as? ReportSummary{
            summary.fillData(summaryData: arrSummary)
            
            if(arrSummary.count > 0){
                ReportSummary.objReportSummary = ReportSummaryModel.init(dictionary: arrSummary.first! as NSDictionary)
                NotificationCenter.default.post(name: NSNotification.Name(ConstantURL.UPDATE_DASHBOARD_SUMMARY), object: nil)
            }
            
            summary.tblReportSummary?.reloadData()
            
            
        }
        if let moment = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardReportMoment) as? DRMovement{
            if let user = selectedUser{
                moment.selectedroleid = user.role_id
            }
            DRMovement.arrMoment = [Any]()
            DRMovement.arrActualMoment = [Any]()
            moment.fillData(visits: arrVisit, attendance: arrAttendance, leads: arrLead, moments: arrMoment)
            moment.tblMoment?.reloadData()
            
        }
        
        
        if   let objmissedvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardMissedVisit) as?    DRMissedVisit{
            let mapping = PlannVisit.defaultmapping()
            let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
            store.saveContextOnCommit =  false
            let deseralizer = FEMDeserializer.init(store: store)
            let arrmissvisit = dicResult["NewMissVisitList"] as? [[String:Any]] ?? [[String:Any]]()
            DRMissedVisit.arrMissedVisits.removeAll()
            DRMissedVisit.arrMissedVisits = [Any]()
            if(arrmissvisit.count > 0){
                
                for omv in arrmissvisit{
                    if let ivisitType = omv["VisitTypeID"] as? Int
                        
                        
                    {
                        if(ivisitType == 1){
                            let objvisit = deseralizer.object(fromRepresentation: omv, mapping: mapping)
                            DRMissedVisit.arrMissedVisits.append(objvisit)
                        }else{
                            let visit = UnplannedVisit().initwithdic(dict: omv)
                            DRMissedVisit.arrMissedVisits.append(visit)
                            
                        }
                    }
                }
            }else{
                DRMovement.arrMoment.removeAll()
                
                
            }
            
            
        }
        
        //            }else if(selectedMenu.menuID == 9){
        //visit update
        
        if let visitupdate = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardVisitUpdate) as? DRVisitUpdate{ //Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardVisitUpdate) as? DRVisitUpdate{
            let mapping = PlannVisit.defaultmapping()
            let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
            store.saveContextOnCommit =  false
            let deseralizer = FEMDeserializer.init(store: store)
            let arrmissvisit = dicResult["NewVisitStatusList"] as? [[String:Any]] ?? [[String:Any]]()
            DRVisitUpdate.aVisitupdate = [Any]()
            DRVisitUpdate.aVisitupdate.removeAll()
            if(arrmissvisit.count > 0){
                
                for omv in arrmissvisit{
                    if let ivisitType = omv["VisitTypeID"] as? Int {
                        
                        
                        
                        if(ivisitType == 1){
                            let objvisit = deseralizer.object(fromRepresentation: omv, mapping: mapping)
                            DRVisitUpdate.aVisitupdate.append(objvisit)
                        }else{
                            let visit = UnplannedVisit().initwithdic(dict: omv)
                            DRVisitUpdate.aVisitupdate.append(visit)
                            
                        }
                    }
                }
            }else{
                DRVisitUpdate.aVisitupdate = [Any]()
                //visitupdate
                
            }
            // visitupdate.tblVisitUpdate.reloadData()
        }
        //            }else if(selectedMenu.menuID == 10){
        if let salesorder = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardSalesOrderList) as? DRSalesOrder{
            //Reports.carbonTabSwipeNavigation.viewControllers[10] as? DRSalesOrder{
            print("view of sales order")
            let mapping = SOrder.defaultMapping()
            let store = FEMManagedObjectStore.init(context: SOrder.getContext())
            store.saveContextOnCommit = false
            let ldeserialiser = FEMDeserializer.init(store: store)
            let arrstatusupdatedlead = dicResult["NewSalesOrder"] as? [[String:Any]] ?? [[String:Any]]()
            salesorder.aNewOrders = [SOrder]()
            if(arrstatusupdatedlead.count > 0){
                let orders = ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [SOrder] ?? [SOrder]()
                salesorder.aNewOrders = orders
            }
            // salesorder.tblSOList.reloadData()
        }
        //            }else if(selectedMenu.menuID == 11){ƒ
        if  let objleadstatus = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardLeadStatusList) as? DRLeadStatus{
            //Reports.carbonTabSwipeNavigation.viewControllers[11]  as? DRLeadStatus {
            let mapping = Lead.defaultmapping()
            let store = FEMManagedObjectStore.init(context: Lead.getContext())
            store.saveContextOnCommit = false
            let ldeserialiser = FEMDeserializer.init(store: store)
            let arrstatusupdatedlead = dicResult["StatusUpdateLead"] as? [[String:Any]] ?? [[String:Any]]()
            DRLeadStatus.aLeadStatusListing = [Lead]()
            if(arrstatusupdatedlead.count > 0){
                let leads =
                
                ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead] //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                DRLeadStatus.aLeadStatusListing = leads
            }else{
                DRLeadStatus.aLeadStatusListing = [Lead]()
            }
            //  objleadstatus.tblLeadStatus.reloadData()
        }
        //            }else if(selectedMenu.menuID == 12){
        if let  leadassignlist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardLeadAssign) as? DRLeadAssign{
            //Reports.carbonTabSwipeNavigation.viewControllers[12]  as? DRLeadAssign{
            let mapping = Lead.defaultmapping()
            let store = FEMManagedObjectStore.init(context: Lead.getContext())
            store.saveContextOnCommit = false
            let ldeserialiser = FEMDeserializer.init(store: store)
            let arrstatusupdatedlead = dicResult["AssignedLead"] as? [[String:Any]] ?? [[String:Any]]()
            DRLeadAssign.arrLeadAssign = [Lead]()
            if(arrstatusupdatedlead.count > 0){
                let leads = ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead]
                //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                DRLeadAssign.arrLeadAssign = leads
            }else{
                DRLeadAssign.arrLeadAssign = [Lead]()
            }
            // leadassignlist.tblLeadAssign.reloadData()
        }
        //            }
        //            else if(selectedMenu.menuID == 13){
        if let  leadlist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardLeadList) as? DRLeadCreated{
            //Reports.carbonTabSwipeNavigation.viewControllers[13]  as? DRLeadCreated{
            let mapping = Lead.defaultmapping()
            let store = FEMManagedObjectStore.init(context: Lead.getContext())
            store.saveContextOnCommit = false
            let ldeserialiser = FEMDeserializer.init(store: store)
            let arrstatusupdatedlead = dicResult["NewLead"] as? [[String:Any]] ?? [[String:Any]]()
            DRLeadCreated.aNewLeads = [Lead]()
            if(arrstatusupdatedlead.count > 0){
                let leads = ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead]
                //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                DRLeadCreated.aNewLeads = leads
            }else{
                DRLeadCreated.aNewLeads = [Lead]()
            }
            //  leadlist.tblLeadList.reloadData()
        }
        //            }else if(selectedMenu.menuID == 14){
        //drproposal
        
        if let drproposal = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardProposalList) as? DRProposal{
            //Reports.carbonTabSwipeNavigation.viewControllers[14]  as? DRProposal{
            let arrProposale = dicResult["NewProposal"] as? [[String:Any]] ?? [[String:Any]]()
            DRProposal.arrProposal = [Proposal]()
            if(arrProposale.count > 0){
                for pro in arrProposale{
                    let proposal = Proposal().initWithdict(dic: pro)
                    DRProposal.arrProposal.append(proposal)
                }
            }else{
                DRProposal.arrProposal = [Proposal]()
            }
            //  drproposal.tblProposal.reloadData()
        }
        //            }else if(selectedMenu.menuID == 16){
        if let visits = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardReportVisit) as? DRVisit{
            //Reports.carbonTabSwipeNavigation.viewControllers[16]  as? DRVisit{
            let mapping = PlannVisit.defaultmapping()
            let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
            store.saveContextOnCommit =  false
            let deseralizer = FEMDeserializer.init(store: store)
            let arrmissvisit = dicResult["VisitList"] as? [[String:Any]] ?? [[String:Any]]()
            DRVisit.aVisits = [Any]()
            if let user = selectedUser{
                visits.selectedroleid = user.role_id
            }
            DRVisit.aVisits.removeAll()
            if(arrmissvisit.count > 0){
                
                for omv in arrmissvisit{
                    if let ivisitType = omv["VisitTypeID"] as? Int {
                        
                        
                        if(ivisitType == 1){
                            let objvisit = deseralizer.object(fromRepresentation: omv, mapping: mapping)
                            
                            DRVisit.aVisits.append(objvisit)
                            
                        }else{
                            let visit = UnplannedVisit().initwithdic(dict: omv)
                            DRVisit.aVisits.append(visit)
                            
                        }
                    }
                }
            }else{
                DRVisit.aVisits = [Any]()
            }
            let arrActivity = dicResult["ActivityList"] as? [[String:Any]] ?? [[String:Any]]()
            if(arrActivity.count > 0){
                for act in arrActivity{
                    DRVisit.aVisits.append(Activitymodel().initwithdic(dict: act))
                    
                }
            }
            //   visits.tblVisitReport.reloadData()
            
        }
        //            }else{
        if  let coldcall = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardColdCallList) as? DRColdCall{
            //Reports.carbonTabSwipeNavigation.viewControllers[17] as? DRColdCall{
            let arrcoldcall = dicResult["NewColdCall"] as? [[String:Any]] ?? [[String:Any]]()
            DRColdCall.aColdCallListing = [UnplannedVisit]()
            if(arrcoldcall.count > 0){
                for cce in arrcoldcall{
                    let coldcallvisit = UnplannedVisit().initwithdic(dict: cce)
                    DRColdCall.aColdCallListing.append(coldcallvisit)
                }
            }
            // coldcall.aColdCallListing = arrcoldcall
            //  coldcall.tblColdCallList.reloadData()
            // coldcall.
        }
        //  }
        
        // }
        if let navigation = Reports.carbonTabSwipeNavigation{
            if let selectedin = Reports.carbonTabSwipeNavigation.carbonSegmentedControl?.selectedSegmentIndex{
                print(selectedin)
                let selectedMenu = itemForReport[selectedin]
                if(selectedMenu.menuID == 7){
                    if let moment = Reports.carbonTabSwipeNavigation.viewControllers[NSNumber.init(value:selectedin)] as? DRMovement{
                        if let user = selectedUser{
                            moment.selectedroleid = user.role_id
                        }
                        moment.fillData(visits: arrVisit, attendance: arrAttendance, leads: arrLead, moments: arrMoment)
                        moment.tblMoment?.reloadData()
                        
                    }
                }else
                if(selectedMenu.menuID == 8){
                    if let moment = Reports.carbonTabSwipeNavigation.viewControllers[NSNumber.init(value:selectedin)] as? DRMissedVisit{
                        let mapping = PlannVisit.defaultmapping()
                        let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                        store.saveContextOnCommit =  false
                        let deseralizer = FEMDeserializer.init(store: store)
                        let arrmissvisit = dicResult["NewMissVisitList"] as? [[String:Any]] ?? [[String:Any]]()
                        DRMissedVisit.arrMissedVisits.removeAll()
                        DRMissedVisit.arrMissedVisits = [Any]()
                        if(arrmissvisit.count > 0){
                            
                            for omv in arrmissvisit{
                                if let ivisitType = omv["VisitTypeID"] as? Int
                                    
                                    
                                {
                                    if(ivisitType == 1){
                                        let objvisit = deseralizer.object(fromRepresentation: omv, mapping: mapping)
                                        DRMissedVisit.arrMissedVisits.append(objvisit)
                                    }else{
                                        let visit = UnplannedVisit().initwithdic(dict: omv)
                                        DRMissedVisit.arrMissedVisits.append(visit)
                                        
                                    }
                                }
                            }
                        }else{
                            DRMissedVisit.arrMissedVisits.removeAll()
                        }
                        moment.tblMissedVisit.reloadData()
                    }
                }else if(selectedMenu.menuID == 9){
                    if let visitupdate = Reports.carbonTabSwipeNavigation.viewControllers[NSNumber.init(value:selectedin)] as? DRVisitUpdate{
                        let mapping = PlannVisit.defaultmapping()
                        let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                        store.saveContextOnCommit =  false
                        let deseralizer = FEMDeserializer.init(store: store)
                        let arrmissvisit = dicResult["NewVisitStatusList"] as? [[String:Any]] ?? [[String:Any]]()
                        DRVisitUpdate.aVisitupdate = [Any]()
                        DRVisitUpdate.aVisitupdate.removeAll()
                        if(arrmissvisit.count > 0){
                            
                            for omv in arrmissvisit{
                                if let ivisitType = omv["VisitTypeID"] as? Int {
                                    
                                    
                                    
                                    if(ivisitType == 1){
                                        let objvisit = deseralizer.object(fromRepresentation: omv, mapping: mapping)
                                        DRVisitUpdate.aVisitupdate.append(objvisit)
                                    }else{
                                        let visit = UnplannedVisit().initwithdic(dict: omv)
                                        DRVisitUpdate.aVisitupdate.append(visit)
                                        
                                    }
                                }
                            }
                        }else{
                            DRVisitUpdate.aVisitupdate = [Any]()
                            //visitupdate
                            
                        }
                        visitupdate.tblVisitUpdate.reloadData()
                    }
                    
                }else if(selectedMenu.menuID == 10){
                    if let salesorder = Reports.carbonTabSwipeNavigation.viewControllers[NSNumber.init(value:selectedin)] as? DRSalesOrder{
                        let mapping = SOrder.defaultMapping()
                        let store = FEMManagedObjectStore.init(context: SOrder.getContext())
                        store.saveContextOnCommit = false
                        let ldeserialiser = FEMDeserializer.init(store: store)
                        let arrstatusupdatedlead = dicResult["NewSalesOrder"] as? [[String:Any]] ?? [[String:Any]]()
                        salesorder.aNewOrders = [SOrder]()
                        if(arrstatusupdatedlead.count > 0){
                            let orders = ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [SOrder] ?? [SOrder]()
                            salesorder.aNewOrders = orders
                        }
                        salesorder.tblSOList.reloadData()
                    }
                }else if(selectedMenu.menuID == 11){
                    if let objleadstatus = Reports.carbonTabSwipeNavigation.viewControllers[NSNumber.init(value:selectedin)] as? DRLeadStatus{
                        let mapping = Lead.defaultmapping()
                        let store = FEMManagedObjectStore.init(context: Lead.getContext())
                        store.saveContextOnCommit = false
                        let ldeserialiser = FEMDeserializer.init(store: store)
                        let arrstatusupdatedlead = dicResult["StatusUpdateLead"] as? [[String:Any]] ?? [[String:Any]]()
                        DRLeadStatus.aLeadStatusListing = [Lead]()
                        if(arrstatusupdatedlead.count > 0){
                            let leads =
                            
                            ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead] //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                            DRLeadStatus.aLeadStatusListing = leads
                        }else{
                            DRLeadStatus.aLeadStatusListing = [Lead]()
                        }
                        objleadstatus.tblLeadStatus.reloadData()
                    }
                }else if(selectedMenu.menuID == 12){
                    if let  leadassignlist = Reports.carbonTabSwipeNavigation.viewControllers[selectedin]  as? DRLeadAssign{
                        let mapping = Lead.defaultmapping()
                        let store = FEMManagedObjectStore.init(context: Lead.getContext())
                        store.saveContextOnCommit = false
                        let ldeserialiser = FEMDeserializer.init(store: store)
                        let arrstatusupdatedlead = dicResult["AssignedLead"] as? [[String:Any]] ?? [[String:Any]]()
                        DRLeadAssign.arrLeadAssign = [Lead]()
                        if(arrstatusupdatedlead.count > 0){
                            let leads = ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead]
                            //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                            DRLeadAssign.arrLeadAssign = leads
                        }else{
                            DRLeadAssign.arrLeadAssign = [Lead]()
                        }
                        leadassignlist.tblLeadAssign.reloadData()
                    }
                }
                else if(selectedMenu.menuID == 13){
                    if let  leadlist = Reports.carbonTabSwipeNavigation.viewControllers[selectedin]  as? DRLeadCreated{
                        let mapping = Lead.defaultmapping()
                        let store = FEMManagedObjectStore.init(context: Lead.getContext())
                        store.saveContextOnCommit = false
                        let ldeserialiser = FEMDeserializer.init(store: store)
                        let arrstatusupdatedlead = dicResult["NewLead"] as? [[String:Any]] ?? [[String:Any]]()
                        DRLeadCreated.aNewLeads = [Lead]()
                        if(arrstatusupdatedlead.count > 0){
                            let leads = ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead]
                            //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                            DRLeadCreated.aNewLeads = leads
                        }else{
                            DRLeadCreated.aNewLeads = [Lead]()
                        }
                        leadlist.tblLeadList.reloadData()
                    }
                }else if(selectedMenu.menuID == 14){
                    //drproposal
                    
                    if let drproposal = Reports.carbonTabSwipeNavigation.viewControllers[selectedin]  as? DRProposal{
                        let arrProposale = dicResult["NewProposal"] as? [[String:Any]] ?? [[String:Any]]()
                        DRProposal.arrProposal = [Proposal]()
                        if(arrProposale.count > 0){
                            for pro in arrProposale{
                                let proposal = Proposal().initWithdict(dic: pro)
                                DRProposal.arrProposal.append(proposal)
                            }
                        }else{
                            DRProposal.arrProposal = [Proposal]()
                        }
                        //  drproposal.tblProposal.reloadData()
                    }
                }else if(selectedMenu.menuID == 16){
                    if let visits = Reports.carbonTabSwipeNavigation.viewControllers[selectedin]  as? DRVisit{
                        let mapping = PlannVisit.defaultmapping()
                        let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                        store.saveContextOnCommit =  false
                        let deseralizer = FEMDeserializer.init(store: store)
                        let arrmissvisit = dicResult["VisitList"] as? [[String:Any]] ?? [[String:Any]]()
                        DRVisit.aVisits = [Any]()
                        if let user = selectedUser{
                            visits.selectedroleid = user.role_id
                        }
                        DRVisit.aVisits.removeAll()
                        if(arrmissvisit.count > 0){
                            
                            for omv in arrmissvisit{
                                if let ivisitType = omv["VisitTypeID"] as? Int {
                                    
                                    
                                    if(ivisitType == 1){
                                        let objvisit = deseralizer.object(fromRepresentation: omv, mapping: mapping)
                                        
                                        DRVisit.aVisits.append(objvisit)
                                        
                                    }else{
                                        let visit = UnplannedVisit().initwithdic(dict: omv)
                                        DRVisit.aVisits.append(visit)
                                        
                                    }
                                }
                            }
                        }else{
                            DRVisit.aVisits = [Any]()
                        }
                        let arrActivity = dicResult["ActivityList"] as? [[String:Any]] ?? [[String:Any]]()
                        if(arrActivity.count > 0){
                            for act in arrActivity{
                                DRVisit.aVisits.append(Activitymodel().initwithdic(dict: act))
                                
                            }
                        }
                        visits.tblVisitReport.reloadData()
                        
                    }
                }else if(selectedMenu.menuID == 505){
                    if let  leadlist = Reports.carbonTabSwipeNavigation.viewControllers[selectedin]  as? DRMissedLead{
                        let mapping = Lead.defaultmapping()
                        let store = FEMManagedObjectStore.init(context: Lead.getContext())
                        store.saveContextOnCommit = false
                        let ldeserialiser = FEMDeserializer.init(store: store)
                        let arrstatusupdatedlead = dicResult["NewMissLeadList"] as? [[String:Any]] ?? [[String:Any]]()
                        DRMissedLead.aNewLeads = [Lead]()
                        if(arrstatusupdatedlead.count > 0){
                            let leads = ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead]
                            //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                            DRMissedLead.aNewLeads = leads
                        }else{
                            DRMissedLead.aNewLeads = [Lead]()
                        }
                        leadlist.tblMissedLead.reloadData()
                    }
                }else{
                    if  let coldcall =  Reports.carbonTabSwipeNavigation.viewControllers[selectedin] as? DRColdCall{
                        let arrcoldcall = dicResult["NewColdCall"] as? [[String:Any]] ?? [[String:Any]]()
                        DRColdCall.aColdCallListing = [UnplannedVisit]()
                        if(arrcoldcall.count > 0){
                            for cce in arrcoldcall{
                                let coldcallvisit = UnplannedVisit().initwithdic(dict: cce)
                                DRColdCall.aColdCallListing.append(coldcallvisit)
                            }
                        }
                        // coldcall.aColdCallListing = arrcoldcall
                        coldcall.tblColdCallList.reloadData()
                    }
                }
            }
        }
        SVProgressHUD.dismiss()
    }
    
    func getDailyReports(){
        if let menusummary = MenuTabs.getTabMenus(menu: [NSNumber.init(value: 23)], sort: true) as? [MenuTabs]{
            //            if(menusummary.count > 0){
            //        itemForReport.insert(menusummary.first!, at: 0)
            //            }
        }else{
            SVProgressHUD.show()
        }
        var param = Common.returndefaultparameter()
        let strDate = String.init(format: "%@ 18:29:00", Reports.selectedDate)
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
        
        param["gettime"] = Common.json(from: ["EndDate":strDate])
        param["getjson"] = Common.json(from:["CreatedBy": selectedUserID ?? self.activeUser?.userID,"CompanyID":self.activeuser?.company?.iD,"companyID":self.activeUser?.company?.iD])
        print(param)
        self.dicResult = [String:Any]()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetDailyReport, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            print(status)
            if(status.lowercased() == Constant.SucessResponseFromServer){
                if(responseType == ResponseType.dic){
                    self.dicResult = arr as? [String:Any] ?? [String:Any]()
                    self.arrSummary = self.dicResult["summaryList"] as? [[String:Any]] ?? [[String:Any]]()
                    self.arrAttendance = self.dicResult["NewAttendanceList"] as? [[String:Any]] ?? [[String:Any]]()
                    
                    self.arrVisit = self.dicResult["NewVisitList"] as? [[String:Any]] ?? [[String:Any]]()
                    
                    self.arrLead = self.dicResult["NewVisitList"] as? [[String:Any]] ?? [[String:Any]]()
                    self.dicAttendance =  self.dicResult["NewAttendanceList"] as? [String:Any] ?? [String:Any]()
                    self.dicLead = self.dicResult["NewVisitList"] as? [String:Any] ?? [String:Any]()
                    self.dicVisit = self.dicResult["NewVisitList"] as? [String:Any] ?? [String:Any]()
                    self.arrMoment =
                    self.dicResult["movementList"] as? [[String:Any]] ?? [[String:Any]]()
                    self.dicMoment  = self.dicResult["movementList"] as? [String:Any] ?? [String:Any]()
                    self.arrMissedLead = self.dicResult["NewMissLeadList"] as? [[String:Any]] ?? [[String:Any]]()
                    if(self.dicAttendance.keys.count > 0){
                        self.arrAttendance.append(self.dicAttendance)
                        
                    }
                    
                    if(self.dicLead.keys.count > 0){
                        self.arrLead.append(self.dicLead)
                    }
                    
                    if(self.dicVisit.keys.count > 0){
                        self.arrVisit.append(self.dicVisit)
                    }
                    if(self.dicMoment.keys.count > 0){
                        self.arrMoment.append(self.dicMoment)
                    }
                    
                    /*let dicAttendance =  self.dicResult["NewAttendanceList"] as? [[String:Any]] ?? [[String:Any]]()
                     
                     if(dicAttendance.count > 0){
                     let fAttendance = dicAttendance.first
                     if let fcheckintime = fAttendance?["checkInTime"] as? String{
                     
                     if(fcheckintime.count > 0 ){
                     let mapping = AttendanceHistory.defaultMapping()
                     let store = FEMManagedObjectStore.init(context: AttendanceHistory.getContext())
                     
                     store.saveContextOnCommit = false
                     let deserialiser = FEMDeserializer.init(store: store)
                     let ath = deserialiser.collection(fromRepresentation: dicAttendance, mapping: mapping).first
                     
                     // arrAttendance
                     // self.arrAttendance.append(              FEMDeserializer.collection(fromRepresentation: dicAttendance, mapping: mapping) as? AttendanceHistory ?? AttendanceHistory())
                     
                     // let ath = FEMDeserializer.
                     //  print(self.arrAttendance)
                     for ate in self.arrAttendance{
                     print(ate)
                     }
                     
                     }
                     
                     }
                     if let fupdatedtime = fAttendance?["updatedTimeIn"] as? String{
                     if(fupdatedtime.count > 0){
                     
                     }
                     }
                     }*/
                    
                    self.setRefresh()
                    //                self.delegate?.customerHistoryWithResponse(name: self.lblCustomerName.text!, dicdata: dic)
                    //                self.dismiss(animated: true, completion: nil)
                }else{
                    SVProgressHUD.dismiss()
                }
            } else if(error.code == 0){
                SVProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                }
            }else{
                SVProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func selectuser(_ sender: UIButton) {
        
        if(self.activeuser?.role?.id == 8){
            lblSelectedUser.text = String.init(format: "%@ %@", arguments: [self.activeuser?.firstName ?? "    ",self.activeuser?.lastName ?? ""])
        }else{
            arrOfUserExceptExecutive = [CompanyUsers]()
            arrOfUserExceptExecutive = BaseViewController.staticlowerUser
            /*{
             $0.role_id.intValue <=  8
             }*/
            if let currentuserid = self.activeuser?.userID{
                if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                    if(!(self.arrOfExecutive?.contains(currentuser) ?? false)){
                        self.arrOfExecutive?.append(currentuser)
                    }
                    if(!(self.arrOfUserExceptExecutive?.contains(currentuser) ?? false)){
                        self.arrOfUserExceptExecutive?.append(currentuser)
                    }
                }
            }
            if((self.arrOfExecutive?.count ?? 0 > 0) && (self.arrOfSelectedExecutive.count == 0)){
                for exec in self.arrOfExecutive ?? [CompanyUsers](){
                    if(exec.entity_id == self.activeuser?.userID){
                        self.arrOfSelectedExecutive.append(exec)
                    }
                }
            }
            if(arrOfUserExceptExecutive.count == 0){
                Utils.toastmsg(message:"No Executive reporting to you",view: self.view)
            }else{
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.isFromSalesOrder =  false
                self.popup?.strTitle = "Select User"
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfExecutive = self.arrOfUserExceptExecutive
                self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [CompanyUsers]()
                self.popup?.strLeftTitle = "OK"
                self.popup?.strRightTitle = "Cancel"
                self.popup?.selectionmode = SelectionMode.single
                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = false
                self.popup?.viewfor = ViewFor.companyuser
                self.popup?.isFilterRequire = false
                self.popup?.parentViewOfPopup =  self.view
                Utils.addShadow(view: self.view)
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
            }
        }
        
    }
    
    
    
    @IBAction func btnDateClicked(_ sender: UIButton) {
        
        self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:datepicker, textfield: nil, withDateMonth: false)
    }
    
}



extension Reports:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    
    @objc func menuitemTouched(item: UPStackMenuItem,companymenu:CompanyMenus) {
        
        print(companymenu)
        print(companymenu.menuID)
        print(companymenu)
        
        if(companymenu.menuID == 32){
            //add manualvisit
            if  let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
                Common.skipVisitSelection = false
                
                addjointvisit.visitType = VisitType.manualvisit
                
                self.navigationController!.pushViewController(addjointvisit, animated: true)
            }
            
            
        }else if(companymenu.menuID == 29){
            if let addunplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddUnplanVisitView) as? AddUnPlanVisit{
                
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
                
                self.navigationController!.pushViewController(newlead, animated: true)
            }
        }else if(companymenu.menuID == 24){
            if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                newlead.selectionFor = SelectionOf.lead
                
                self.navigationController!.pushViewController(newlead, animated: true)
            }
        }else if(companymenu.menuID == 0){
            if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                newlead.selectionFor = SelectionOf.visit
                
                self.navigationController!.pushViewController(newlead, animated: true)
            }
        }else if(companymenu.menuID == 22){
            if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                self.navigationController?.pushViewController(attendance, animated: true)
            }
        }          // let selectedcompanyid = CompanyMenus.
        else if(companymenu.menuID == 18){
            if let objexcel = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ExcelReport) as? ExcelReport{
                self.navigationController?.pushViewController(objexcel, animated: true)
            }
        }
        else if(item.title.lowercased() == "visit"){
            
            if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                newlead.selectionFor = SelectionOf.visit
                
                self.navigationController!.pushViewController(newlead, animated: true)
            }
            
        }else if(item.title.lowercased() == "new beat route"){
            
        }else if(item.title.lowercased() == "lead"){
            if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                newlead.selectionFor = SelectionOf.lead
                
                self.navigationController!.pushViewController(newlead, animated: true)
            }
        }else if(item.title.lowercased() == "beat plan"){
            if let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView{
                self.navigationController!.pushViewController(beatplancontainer, animated: true)
            }
        }else if(companymenu.menuID == 25){
            print("Sales Order")
            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    func datepickerSelectionDone(){
        SVProgressHUD.show()
        Utils.removeShadow(view: self.view)
        datepicker.removeFromSuperview()
        Reports.selectedDate = Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepicker.date)
        //btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepicker.date), for: .normal)
        btnSelectedDate.setAttributedTitle(NSAttributedString.init(string: Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepicker.date), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]), for: UIControl.State.normal)
        //        btnSelectedDate.setTitleColor(UIColor.Appthemebluecolor, for: UIControl.State.normal)
        //        btnSelectedDate.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.getDailyReports()
        Reports.carbonTabSwipeNavigation.setCurrentTabIndex(UInt(0), withAnimation: true)
        
        //        if(screenselection == Dashboardscreen.salesplan){
        //         self.getVisitFollowupList()
        //        }else if(screenselection == Dashboardscreen.dashboardvisit){
        //            self.getvisitForDashboard()
        //        }else if(screenselection == Dashboardscreen.dashboardlead){
        //            self.getLeadForDashoard()
        //        }else if(screenselection == Dashboardscreen.dashboardorder){
        //            self.getOrderForDashoard()
        //        }
        
    }
    
    func cancelbtnTapped() {
        Utils.removeShadow(view: self.view)
        datepicker.removeFromSuperview()
    }
    
}


// MARK: Carbondelegate
extension Reports:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController
    {
        print(itemForReport[Int(index)])
        
        let selectedMenu = itemForReport[Int(index)]
        print(selectedMenu)
        
        
        if(selectedMenu.menuID == 23){
            if let summary = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ReportSummary) as? ReportSummary{
                summary.fillData(summaryData: arrSummary)
                if(arrSummary.count > 0){
                    ReportSummary.objReportSummary = ReportSummaryModel.init(dictionary: arrSummary.first! as NSDictionary)
                }
                summary.tblReportSummary?.reloadData()
                
                
                return summary
            }else{
                return UIViewController()
            }
        }else
        
        if(selectedMenu.menuID == 7){
            
            if  let moment =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardReportMoment) as? DRMovement{
                if let user = selectedUser{
                    moment.selectedroleid = user.role_id
                }
                moment.fillData(visits: arrVisit, attendance: arrAttendance, leads: arrLead, moments: arrMoment)
                moment.tblMoment?.reloadData()
                return moment
            }else{
                return UIViewController()
            }
        }else if(selectedMenu.menuID == 8){
            if let missedvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardMissedVisit) as? DRMissedVisit{
                let mapping = PlannVisit.defaultmapping()
                let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                store.saveContextOnCommit =  false
                let deseralizer = FEMDeserializer.init(store: store)
                let arrmissvisit = dicResult["NewMissVisitList"] as? [[String:Any]] ?? [[String:Any]]()
                DRMissedVisit.arrMissedVisits = [Any]()
                if(arrmissvisit.count > 0){
                    
                    
                    for omv in arrmissvisit{
                        if let ivisitType = omv["VisitTypeID"] as? Int {
                            
                            
                            
                            if(ivisitType == 1){
                                let objvisit = deseralizer.object(fromRepresentation: omv, mapping: mapping)
                                DRMissedVisit.arrMissedVisits.append(objvisit)
                            }else{
                                let visit = UnplannedVisit().initwithdic(dict: omv)
                                DRMissedVisit.arrMissedVisits.append(visit)
                                
                            }
                        }
                    }
                }else{
                    DRMissedVisit.arrMissedVisits.removeAll()
                }
                //missedvisit.tblMissedVisit.reloadData()
                print(DRMissedVisit.arrMissedVisits.count)
                return missedvisit
            }else{
                return UIViewController()
            }
            
        }else if(selectedMenu.menuID == 9){
            if let visitupdate = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardVisitUpdate) as? DRVisitUpdate{
                let mapping = PlannVisit.defaultmapping()
                let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                store.saveContextOnCommit =  false
                let deseralizer = FEMDeserializer.init(store: store)
                let arrmissvisit = dicResult["NewVisitStatusList"] as? [[String:Any]] ?? [[String:Any]]()
                DRVisitUpdate.aVisitupdate = [Any]()
                DRVisitUpdate.aVisitupdate.removeAll()
                if(arrmissvisit.count > 0){
                    
                    for omv in arrmissvisit{
                        if let ivisitType = omv["VisitTypeID"] as? Int {
                            
                            
                            
                            if(ivisitType == 1){
                                let objvisit = deseralizer.object(fromRepresentation: omv, mapping: mapping)
                                DRVisitUpdate.aVisitupdate.append(objvisit)
                            }else{
                                let visit = UnplannedVisit().initwithdic(dict: omv)
                                DRVisitUpdate.aVisitupdate.append(visit)
                                
                            }
                        }
                    }
                }else{
                    DRVisitUpdate.aVisitupdate = [Any]()
                }
                
                //visitupdate.tblVisitUpdate.reloadData()
                return visitupdate
            }else{
                return UIViewController()
            }
            
        }else if(selectedMenu.menuID == 11){
            if let leadstatuslist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardLeadStatusList) as? DRLeadStatus{
                let mapping = Lead.defaultmapping()
                let store = FEMManagedObjectStore.init(context: Lead.getContext())
                store.saveContextOnCommit = false
                let ldeserialiser = FEMDeserializer.init(store: store)
                let arrstatusupdatedlead = dicResult["StatusUpdateLead"] as? [[String:Any]] ?? [[String:Any]]()
                DRLeadStatus.aLeadStatusListing = [Lead]()
                if(arrstatusupdatedlead.count > 0){
                    let leads =
                    
                    ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead] //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                    DRLeadStatus.aLeadStatusListing = leads
                }else{
                    DRLeadStatus.aLeadStatusListing = [Lead]()
                    
                }
                // leadstatuslist.tblLeadStatus.reloadData()
                return leadstatuslist
            }else{
                return UIViewController()
            }
        }else if(selectedMenu.menuID == 12){
            if let leadassign = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardLeadAssign) as? DRLeadAssign{
                let mapping = Lead.defaultmapping()
                let store = FEMManagedObjectStore.init(context: Lead.getContext())
                store.saveContextOnCommit = false
                let ldeserialiser = FEMDeserializer.init(store: store)
                let arrstatusupdatedlead = dicResult["AssignedLead"] as? [[String:Any]] ?? [[String:Any]]()
                DRLeadAssign.arrLeadAssign = [Lead]()
                if(arrstatusupdatedlead.count > 0){
                    let leads = ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead]
                    //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                    DRLeadAssign.arrLeadAssign = leads
                }else{
                    DRLeadAssign.arrLeadAssign = [Lead]()
                }
                //leadassign.tblLeadAssign.reloadData()
                return leadassign
            }else{
                return UIViewController()
            }
        }else if(selectedMenu.menuID == 13){
            if let leadstatuslist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardLeadList) as? DRLeadCreated{
                let mapping = Lead.defaultmapping()
                let store = FEMManagedObjectStore.init(context: Lead.getContext())
                store.saveContextOnCommit = false
                let ldeserialiser = FEMDeserializer.init(store: store)
                let arrstatusupdatedlead = dicResult["NewLead"] as? [[String:Any]] ?? [[String:Any]]()
                DRLeadCreated.aNewLeads = [Lead]()
                if(arrstatusupdatedlead.count > 0){
                    let leads =
                    
                    ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead]
                    //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                    DRLeadCreated.aNewLeads = leads
                }else{
                    
                }
                //leadstatuslist.tblLeadList.reloadData()
                return leadstatuslist
            }else{
                return UIViewController()
            }
        }else if(selectedMenu.menuID == 14){
            if let drproposal = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardProposalList) as? DRProposal{
                let arrProposale = dicResult["NewProposal"] as? [[String:Any]] ?? [[String:Any]]()
                DRProposal.arrProposal = [Proposal]()
                if(arrProposale.count > 0){
                    
                    for pro in arrProposale{
                        let proposal = Proposal().initWithdict(dic: pro)
                        DRProposal.arrProposal.append(proposal)
                    }
                }else{
                    DRProposal.arrProposal = [Proposal]()
                }
                //drproposal.tblProposal.reloadData()
                // drproposal.arrProposal =
                return drproposal
            }else{
                return UIViewController()
            }
        }else if(selectedMenu.menuID == 10){
            if let sorder = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardSalesOrderList) as? DRSalesOrder{
                
                let mapping = SOrder.defaultMapping()
                let store = FEMManagedObjectStore.init(context: SOrder.getContext())
                store.saveContextOnCommit = false
                let ldeserialiser = FEMDeserializer.init(store: store)
                let arrstatusupdatedlead = dicResult["NewSalesOrder"] as? [[String:Any]] ?? [[String:Any]]()
                sorder.aNewOrders = [SOrder]()
                if(arrstatusupdatedlead.count > 0){
                    let orders = ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [SOrder] ?? [SOrder]()
                    sorder.aNewOrders = orders
                }
                
                return sorder
            }else{
                return UIViewController()
            }
        }else if(selectedMenu.menuID == 16){
            if let visits = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardReportVisit) as? DRVisit{
                let mapping = PlannVisit.defaultmapping()
                let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                store.saveContextOnCommit =  false
                let deseralizer = FEMDeserializer.init(store: store)
                let arrmissvisit = dicResult["VisitList"] as? [[String:Any]] ?? [[String:Any]]()
                DRVisit.aVisits = [Any]()
                if let user = selectedUser{
                    visits.selectedroleid = user.role_id
                }
                DRVisit.aVisits.removeAll()
                if(arrmissvisit.count > 0){
                    
                    for omv in arrmissvisit{
                        if let ivisitType = omv["VisitTypeID"] as? Int {
                            
                            
                            
                            if(ivisitType == 1){
                                let objvisit = deseralizer.object(fromRepresentation: omv, mapping: mapping)
                                DRVisit.aVisits.append(objvisit)
                                if let checkouttime = omv["CheckOutTime"] {
                                    if let checkintime = omv["CheckInTime"]{
                                        //   visits.atempData.append()
                                        //                            omv["CheckInTime"] = checkintime
                                        //                            omv["CheckOutTime"] = checkouttime
                                    }
                                }
                            }else{
                                let visit = UnplannedVisit().initwithdic(dict: omv)
                                DRVisit.aVisits.append(visit)
                                
                            }
                        }
                    }
                }else{
                    DRVisit.aVisits = [Any]()
                }
                let arrActivity = dicResult["ActivityList"] as? [[String:Any]] ?? [[String:Any]]()
                if(arrActivity.count > 0){
                    for act in arrActivity{
                        DRVisit.aVisits.append(Activitymodel().initwithdic(dict: act))
                        
                    }
                }
                //visits.tblVisitReport.reloadData()
                return visits
            }else{
                return UIViewController()
            }
        }else if(selectedMenu.menuID == 505){
            if let leadstatuslist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardMissedLead) as? DRMissedLead{
                let mapping = Lead.defaultmapping()
                let store = FEMManagedObjectStore.init(context: Lead.getContext())
                store.saveContextOnCommit = false
                let ldeserialiser = FEMDeserializer.init(store: store)
                let arrstatusupdatedlead = dicResult["NewMissLeadList"] as? [[String:Any]] ?? [[String:Any]]()
                DRMissedLead.aNewLeads = [Lead]()
                if(arrstatusupdatedlead.count > 0){
                    let leads =
                    
                    ldeserialiser.collection(fromRepresentation: arrstatusupdatedlead , mapping: mapping) as? [Lead]
                    //ldeserialiser.object(fromRepresentation: arrstatusupdatedlead, mapping: mapping)
                    DRMissedLead.aNewLeads = leads
                }else{
                    
                }
                //leadstatuslist.tblLeadList.reloadData()
                return leadstatuslist
            }else{
                return UIViewController()
            }
        }else {
            if  let coldcall =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.DashboardColdCallList) as? DRColdCall{
                let arrcoldcall = dicResult["NewColdCall"] as? [[String:Any]] ?? [[String:Any]]()
                //  coldcall.aColdCallListing = arrcoldcall
                DRColdCall.aColdCallListing = [UnplannedVisit]()
                if(arrcoldcall.count > 0){
                    for cce in arrcoldcall{
                        let coldcallvisit = UnplannedVisit().initwithdic(dict: cce)
                        DRColdCall.aColdCallListing.append(coldcallvisit)
                    }
                }
                //coldcall.tblColdCallList.reloadData()
                return coldcall
            }else{
                return UIViewController()
            }
        }
        
    }
}

extension Reports:PopUpDelegateNonMandatory{
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        arrOfSelectedExecutive =  arr
        selectedUser = arrOfSelectedExecutive.first
        if let user = selectedUser{
            lblSelectedUser.text = String.init(format: "%@ %@", user.firstName,user.lastName)
            selectedUserID = user.entity_id
            print(user.role_id)
        }
        self.getDailyReports()
        if(stritemforreport.count > 0){
            Reports.carbonTabSwipeNavigation.setCurrentTabIndex(UInt(0), withAnimation: true)
        }
    }
}
