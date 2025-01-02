//
//  Dashboard.swift
//  SuperSales
//
//  Created by Apple on 29/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import CarbonKit

class Dashboard: BaseViewController {

   
  
    //import KeyedDecodingContainer

    
          // swiftlint:disable line_length
        var cell:SalesPlanCell!
        @IBOutlet weak var btnSelectedDate: UIButton!
        
        @IBOutlet weak var tblSalesPlan: UITableView!
        var isOnHome:Bool!
        var toolbarMenus = [MenuTabs]()
        var toolbarItemOfSalesPlan = [String]()
        
       
        @IBOutlet var tabbar: UITabBar!
        var carbonTabSwipeNavigationSalesPlan:CarbonTabSwipeNavigation?
        @IBOutlet weak var toolbar: UIToolbar!
        
        let activeAccount = Utils().getActiveAccount()
        var selectedDate:String!
        var selectedUserID:NSNumber!
        var aVisitsFlwups:[PlannVisit]! = [PlannVisit]()
        var aVisitsFlwupscoldcall:[UnplannedVisit]! = [UnplannedVisit]()
        var aVisitsFlwupsBeatPlan:[BeatPlan]! = [BeatPlan]()
        var aVisitsFlwupsActivity:[Activity]! = [Activity]()
        var aBeatPlanVisitList:[Any]! =  [Any]()
        var arrSalesplanmodel:[SalesPlanModel] = [SalesPlanModel]()
    
        var arrLowerLevelUser = [CompanyUsers]()
       
        
        @IBOutlet weak var btnCheckIn: UIButton!
        @IBOutlet weak var lblCheckInDetail: UILabel!
        @IBOutlet weak var imgCheckInInfo: UIImageView!
        
        @IBOutlet weak var vwCheckInInfo: UIView!
        
        @IBOutlet weak var vwForTeam: UIView!
        
        @IBOutlet weak var vwDateSelection: UIView!
        @IBOutlet weak var vwTargetView: UIView!
        
        //Bottom menu
         let baseviewcontrollerobj = BaseViewController()
         //   static var blurEffectView:UIView!
            
        //    var items:[CompanyMenus]!
        //    var VC : MenuViewController!
            var sideMenus:[CompanyMenus]!
            var companyMenus:[CompanyMenus]!
            var temp:[UPStackMenuItem]!
            var arrOfBottomTabBar:[MenuTabs]!
            var arrTabbarItem:[UITabBarItem]!
        //   @IBOutlet weak var tabBar: UITabBar!
             var titlesOfButtons:[String]!//= ["Visits","Leads","Ordres"]
        
        var datepicker:UIDatePicker!
        var recordtillbeatplanInt:Int =  0
        var currentplanedvisitno = 0
        var currentunplanedvisitno = 0
        var currentactivityplanvisitno = 0
        var currentbeatplanvisitno = 0
        
        //Select user ::
        
          var arrOfUserExceptExecutive:[CompanyUsers]!
          var arrOfSelectedExecutive:[CompanyUsers]!
          var popup:CustomerSelection!
          var selectedUser:CompanyUsers!
          var selectedUserIDSalesplan:NSNumber = 0
         @IBOutlet var vwUserSelection: UIView!
        @IBOutlet var lblSelectedUser: UILabel!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
        //    toolbarMenus = MenuTabs.getTabMenus(menu:[NSNumber.init(value:0),NSNumber.init(value:1),NSNumber.init(value:2)],sort:true)
            toolbarMenus =  MenuTabs.getTabMenus(menu:[NSNumber.init(value:3),NSNumber.init(value:4),NSNumber.init(value:5),NSNumber.init(value:6),NSNumber.init(value:22)],sort:true)
            for tbm in toolbarMenus{
                print(tbm.menuLocalText)
            }
            self.setUI()
            self.setData()
            if let  selectedUserID = activeAccount?.userID{
                self.selectedUserID = selectedUserID
            }else{
                self.selectedUserID = NSNumber.init(value: 0)
            }
            self.apihelper.loadAttendanceHistory(memberid: self.selectedUserID , month: "01", year: "2020") { (arr,status,message,error,responseType) in
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
               
            
            if(self.lowerUser?.count ?? 0 > 0 ){
                 arrLowerLevelUser = self.lowerUser!
               
            }else{
                //self.fetchuser()
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
            Location.sharedInsatnce.startLocationManager()
            sideMenus = [CompanyMenus]()
            sideMenus = self.createUPStackMenuItems(isFromHome: true)
            
            temp = [UPStackMenuItem]()
           
            for tempitem in sideMenus{
                print("\(tempitem.menuID) , \(tempitem.menuLocalText ?? "" )")
                let upstackmenu = UPStackMenuItem.init(image: CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16))
                upstackmenu?.isUserInteractionEnabled = true
                temp.append(upstackmenu ?? UPStackMenuItem())
            }
            self.initbottomMenu(menus: temp, control: self)
              //self.getVisitFollowupList()
            self.getDailyReportData()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.salesPlandelegateObject = self
            self.navigationController!.isNavigationBarHidden = false
            if(self.activeuser?.role?.id == NSNumber.init(value: 8)){
                tabbar.isHidden = true
                 toolbar.isHidden = true
                self.tabBarController?.navigationItem.title = NSLocalizedString("Sales-Plan-small",  comment: "")
            }else{
                tabbar.isHidden = false
                toolbar.isHidden = true
                tabbar.delegate = self
                self.tabBarController?.navigationItem.title = "Dashboard"
               
            }
self.setrightbtn(btnType: BtnRight.home, navigationItem: self.tabBarController!.navigationItem)
   //         self.setrightbtn(btnType: BtnRight.others,navigationItem: self.tabBarController!.navigationItem)
        }
        

        func setUI(){
        
        vwForTeam.addBorders(edges: [.top,.bottom], color: UIColor.black, cornerradius: 0)
        vwCheckInInfo.addBorders(edges: [.top,.bottom], color: UIColor.black, cornerradius: 0)
         vwDateSelection.addBorders(edges: [.top,.bottom], color: UIColor.black, cornerradius: 0)
            
       // self.tabBarHome.isHidden = true
            if((self.activeuser?.role?.id == NSNumber.init(value: 7)) || (self.activeuser?.role?.id == NSNumber.init(value: 5))){
                //
                self.toolbar.isHidden = false
                self.vwForTeam.isHidden = false
                self.vwUserSelection.isHidden = false
                if(self.activeuser?.role?.id == NSNumber.init(value: 5)){
                    self.vwCheckInInfo.isHidden = true
                }
                self.tabBarItem.title = "Dashboard"
            }else if(self.activeuser?.role?.id == NSNumber.init(value: 9)){
                self.istabBarpresent = true
                self.vwForTeam.isHidden = true
                self.toolbar.isHidden = false
                self.vwUserSelection.isHidden = true
                self.vwCheckInInfo.isHidden = true
                  self.tabBarItem.title = "Dashboard"
            }
            else
                {
                    //role 8
                self.istabBarpresent = true
                self.vwForTeam.isHidden = true
                self.toolbar.isHidden = true
    //                  self.tabBarItem.title = "Dashboard"
                }
       
        Common.setTitleOfView(color:UIColor.white, viewController: self)
            self.setleftbtn(btnType: BtnLeft.menu,navigationItem: self.navigationItem)
          
            btnCheckIn.layer.cornerRadius = 5
            btnCheckIn.backgroundColor = UIColor.Appthemebluecolor
            tblSalesPlan.delegate = self
            tblSalesPlan.dataSource = self
            tblSalesPlan.separatorColor = .clear
            tblSalesPlan.tableFooterView = UIView()
            datepicker = UIDatePicker.init()
            datepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 285, width: view.frame.size.width, height: 200))
            //datepicker.frame =
                    companyMenus = [CompanyMenus]()
                    temp = [UPStackMenuItem]()
                    companyMenus = baseviewcontrollerobj.createUPStackMenuItems(isFromHome: true)
                    for tempitem in companyMenus{
                    print("\(tempitem.menuID) , \(tempitem.menuLocalText ?? "" )")
                    let upstackmenu = UPStackMenuItem.init(image:  CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16))
                    temp.append(upstackmenu ?? UPStackMenuItem())
                    }
                    arrTabbarItem = [UITabBarItem]()
                    arrOfBottomTabBar = MenuTabs.getTabMenus(menu: [NSNumber.init(value: 0),NSNumber.init(value: 1),NSNumber.init(value: 2)], sort: true)
                    titlesOfButtons = arrOfBottomTabBar.map{ $0.menuLocalText }
            baseviewcontrollerobj.initbottomMenu(menus:temp , control: self)
            tblSalesPlan.estimatedRowHeight =  30
            tblSalesPlan.rowHeight = UITableView.automaticDimension
            
            toolbarItemOfSalesPlan = ["VISITS","LEADS","ORDERS"]
            
            carbonTabSwipeNavigationSalesPlan = CarbonTabSwipeNavigation(items:toolbarItemOfSalesPlan, toolBar:self.toolbar , delegate:self)
          
                 //carbonTabSwipeNavigationSalesPlan.insert(intoRootViewController: self, andTargetView: self.vwTargetView)

                self.style()
        }
        
        func style(){
            
        }
        func setData(){
    //        self.setrightbtn(btnType: BtnRight.others,navigationItem: self.navigationController!.navigationItem)
            selectedDate =  Utils().getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:Date())
            btnSelectedDate.setTitle(Utils().getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:Date()), for: .normal)
           
        }
        
        // MARK: -APICall
//    func getAllData(){
//        aBeatPlanVisitList.removeAll()
//        SVProgressHUD.show()
//    }
    func getDailyReportData(){
             SVProgressHUD.show(withStatus: "Loading")
            
        self.apihelper.getDailySalesPlanDetail(selecteduserID: SalesPlanHome.selectedUserID.stringValue, selectedDate: SalesPlanHome.selectedDate) { (arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
        self.aBeatPlanVisitList.removeAll()
        if(status.lowercased() == Constant.SucessResponseFromServer){
            let arrVisitFollowUpList = arr as? [[String:Any]] ?? [[String:Any]]()
            if(arrVisitFollowUpList.count > 0){
                self.arrSalesplanmodel = [SalesPlanModel]()
                for spm in arrVisitFollowUpList{
    let salespmodel = SalesPlanModel().initWithdic(dict:spm)
    self.arrSalesplanmodel.append(salespmodel)
                }
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
    self.aBeatPlanVisitList.append(objVisit)
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
            self.tblSalesPlan.reloadData()
                    }
                    else if(error.code == 0){
            //self.fetchActivityFollowUps()
                        self.view.makeToast(message)
                    }else{
                        
                self.tabBarController?.selectedViewController?.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                    }
                }
        }
        func  getVisitFollowupList(){
            aBeatPlanVisitList.removeAll()
            SVProgressHUD.show()
            
            self.apihelper.getVisitFollowUps(selecteduserID: selectedUserID.stringValue, selectedDate: selectedDate) { (arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
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
                                     dicVisit["CustomerName"] = "Customer Not Mapped"
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
                                self.aBeatPlanVisitList.append(objVisit)
                                if let objVisit =  objVisit  as? PlannVisit{
                                self.aVisitsFlwups.append(objVisit)
                                }
                               
                            }else{
            
            let objcoldcall = UnplannedVisit().initwithdic(dict: dicVisit)
            dicVisit["visitType"] = VisitType.coldcallvisit
            self.aBeatPlanVisitList.append(objcoldcall)
            self.aVisitsFlwupscoldcall.append(objcoldcall)
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
                    self.view.makeToast(message)
                }else{
                    
            self.tabBarController?.selectedViewController?.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription) //self.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                }
            }
        }
        
        func fetchActivityFollowUps(){
            SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            let acticityjson = ["CreatedBy":selectedUserID,"CompanyID":self.activeuser?.company?.iD ?? 0] as [String : Any]
            param["getactivityjson"] = Common.json(from: acticityjson)
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
           
            param["gettime"] = Common.json(from: ["EndDate":strenddate])
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetActivityfollowups, method: Apicallmethod.get) { (arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() ==  Constant.SucessResponseFromServer){
                    if(responseType == ResponseType.arr){
                    let arrOfActivityVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                        self.aVisitsFlwupsActivity.removeAll()
                    if(arrOfActivityVisit.count > 0){
                        for actv in arrOfActivityVisit{
                            let activityvisitobj = Activity().initwithdic(dict: actv)
                            var activity = actv
                        activity["visitType"] = VisitType.activityvisit
                            
                self.aBeatPlanVisitList.append(activityvisitobj)
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
            SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            let beatplanjson = ["CreatedBy":selectedUserID,"CompanyID":self.activeuser?.company?.iD ?? 0] as [String : Any]
            param["getBeatPlanjson"] = Common.json(from: beatplanjson)
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
            
            param["gettime"] = Common.json(from: ["EndDate":strenddate])
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetBeatplanFollowupForSalesPlan, method: Apicallmethod.get) { (arr,status,message,error,responseType) in
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
                                self.aBeatPlanVisitList.append(beatplanvisitobj)
                                self.aVisitsFlwupsBeatPlan.append(beatplanvisitobj)
                            }
                            
                        }
                    }else{
                        print(arr)
                    }
                    
                     self.tblSalesPlan.reloadData()
                    self.fetchLeads()
                }
                else if(error.code == 0){
                     self.tblSalesPlan.reloadData()
                       self.fetchLeads()
                        self.view.makeToast(message)
                }else{
                       self.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                    }
              
            }
            
        }
        
        func fetchLeads(){
            SVProgressHUD.show()
                   var param = Common.returndefaultparameter()
            let beatplanjson = ["CreatedBy":selectedUserID,"CompanyID":self.activeuser?.company?.iD ?? 0] as [String : Any]
            param["getleadjson"] = Common.json(from: beatplanjson)
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
            
            param["gettime"] = Common.json(from: ["EndDate":strenddate])
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetLeadFollowUps, method: Apicallmethod.get) { (arr,status,message,error,responseType) in
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
                        self.view.makeToast(message)
                }else{
                       self.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                    }
            }
        }
        
        //fetch user
        
    //    func fetchuser()->[CompanyUsers]{
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
    //                  self.view.makeToast(message)
    //            }
    //        }
    //        }
    //        return self.arrLowerLevelUser
    //    }
        // MARK: - IBAction
        
        @IBAction func btnSelectUserClicked(_ sender: UIButton) {
            
         self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                           self.popup.modalPresentationStyle = .overCurrentContext
                           self.popup.strTitle = "Select User"
                           self.popup.nonmandatorydelegate = self
                           self.popup.arrOfExecutive = self.arrOfUserExceptExecutive
                           self.popup.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [CompanyUsers]()
                           self.popup.strLeftTitle = "OK"
                           self.popup.strRightTitle = "cancel"
                           self.popup.selectionmode = SelectionMode.single
                           //popup.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                           self.popup.isSearchBarRequire = false
                           self.popup.viewfor = ViewFor.companyuser
                           self.popup.isFilterRequire = false
                           // popup.showAnimate()
                           self.present(self.popup, animated: false, completion: nil)
            
            
            
        }
        @IBAction func btnDateClicked(_ sender: UIButton) {
    //        sender.isUserInteractionEnabled = false
         
            self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:datepicker, textfield: nil)
             datepicker?.minimumDate = Date()
             //  self.datepicker?.minimumDate =  Date()
        }
        
        @IBAction func btnCheckInClicked(_ sender: UIButton) {
            
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
    extension Dashboard:BaseViewControllerDelegate{
        func editiconTapped() {
            
        }
        
        
        @objc func menuitemTouched(item: UPStackMenuItem,companymenu:CompanyMenus) {
            
            print(companymenu)
            print(companymenu.menuID)
            print(companymenu)
            
               if(companymenu.menuID == 32){
                   //add manualvisit
                   if  let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView) as? AddJoinVisitViewController{
                   
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
               }else if(companymenu.menuID == 504){
                   //kpi data
               }else if(companymenu.menuID == 30){
                   //Direct Visit Check-IN
                   if let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView) as? AddJoinVisitViewController{
                   
                   addjointvisit.visitType = VisitType.directvisitcheckin
                  
                   self.navigationController!.pushViewController(addjointvisit, animated: true)
                   }
               }else if(companymenu.menuID == 23){
                   if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
                   as? Leadselection{
                   addplanvisit.selectionFor = SelectionOf.visit
                   self.navigationController!.pushViewController(addplanvisit, animated: true)
                   }
               }else if(companymenu.menuID == 24){
                if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView) as? Leadselection{
                        newlead.selectionFor = SelectionOf.lead
                   
                       self.navigationController!.pushViewController(newlead, animated: true)
               }
               }else if(companymenu.menuID == 0){
                if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
                as? Leadselection{
                addplanvisit.selectionFor = SelectionOf.visit
                self.navigationController!.pushViewController(addplanvisit, animated: true)
                }
               }else if(companymenu.menuID == 22){
                if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                    self.navigationController?.pushViewController(attendance, animated: true)
                }
               }
              // let selectedcompanyid = CompanyMenus.
               else if(item.title.lowercased() == "visit"){
                   
                  if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
                   as? Leadselection{
                   addplanvisit.selectionFor = SelectionOf.visit
                   self.navigationController!.pushViewController(addplanvisit, animated: true)
                   }
             
               }else if(item.title.lowercased() == "new beat route"){
                   
               }else if(item.title.lowercased() == "lead"){
                   if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView) as? Leadselection{
                   newlead.selectionFor = SelectionOf.lead
              
                  self.navigationController!.pushViewController(newlead, animated: true)
                   }
               }else if(item.title.lowercased() == "new order"){
                   
               }else if(item.title.lowercased() == "new cold call"){
                   if let addcoldvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit , classname: Constant.AddUnplanVisitView) as? AddUnPlanVisit{
                   self.navigationController!.pushViewController(addcoldvisit, animated: true)
                   }
                   
               }else if(item.title.lowercased() == "beat plan"){
                   if let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView{
                   self.navigationController!.pushViewController(beatplancontainer, animated: true)
                   }
               }
        }
        
        func datepickerSelectionDone(){
         selectedDate =  Utils().getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepicker.date)
     btnSelectedDate.setTitle(Utils().getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepicker.date), for: .normal)
             //self.getVisitFollowupList()
            self.getDailyReportData()
        }
        
         func cancelbtnTapped() {
            datepicker.removeFromSuperview()
        }
        
    }
    extension Dashboard:UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrSalesplanmodel.count
          //  return aBeatPlanVisitList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            cell = tableView.dequeueReusableCell(withIdentifier: Constant.SalesPlanCell, for: indexPath) as? SalesPlanCell
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.vwTitleInfo.tag = indexPath.row
            gesture.numberOfTapsRequired = 1
            cell.vwTitleInfo.addGestureRecognizer(gesture)
                    cell.btnVisitDetail.tag = indexPath.row
                    cell.btnVisitReport.tag = indexPath.row
                    cell.btnVisitCheckin.tag = indexPath.row
            let model = arrSalesplanmodel[indexPath.row]
            let modelType = model.detailType
                      
                        if(modelType == 1){
                            //attendance type
                            return cell
                        }else if(modelType == 2){
                            //visit planned
                cell.setPlannedVisitData(visit: model)
                            return cell
                        }else if(modelType == 3){
                            //lead
                            return cell
                        }else if(modelType == 4){
                            //Activity
                            return cell
                        }else if(modelType == 5){
                            // unplaned visit
    cell.setUnplanVisitSalesData(model: model)
                            return cell
                        }else if(modelType == 6){
                            // beat plan
                            return cell
                        
        }else if(modelType == 7){
                            // visit collection
                            return cell
        }else if(modelType == 8){
                            // Cold call
                            return cell
        }
                        
            /*let obj = aBeatPlanVisitList[indexPath.row]
                    if(type(of: obj) == PlannVisit.self){
                        //plan visit
                   // let visitobj = aVisitsFlwups[currentplanedvisitno]
                    //cell.setVisitData(visit:visitobj)
                        let plannedVisit = obj as? PlannVisit ?? PlannVisit.mr_createEntity()
                        //cell.setPlannedVisitData(visit: <#T##SalesPlanModel#>)
            //cell.setVisitData(visit:plannedVisit!)
                        
                    cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
                    cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
                    cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
                        
                        return cell
                    
                    }
                    //else if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.coldcallvisit){
                    else  if(type(of: obj) == UnplannedVisit.self){
                        //unplanvisit
                         let visitobj = obj as? UnplannedVisit ?? UnplannedVisit()
                            // aVisitsFlwupscoldcall[currentunplanedvisitno]
                      //  cell.setUnplanVisitData(visit: visitobj)
                        let coldcallvisit = visitobj
                        print(coldcallvisit.customerName)
                        cell.setUnplanVisitData(visit: coldcallvisit)
                        
                        cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
                        cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
                        cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
                        currentunplanedvisitno += 1
                      return cell
                    }
                    //else if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.beatplan){
                    else if(type(of: obj) == BeatPlan.self){
                        //beat visit
                       // let beatvisit = aVisitsFlwupsBeatPlan[currentbeatplanvisitno]
                     //   cell.setBeatplanVisitData(bvisit: beatvisit)
                        let beatVisit = obj as? BeatPlan ?? BeatPlan([:])
                        cell.setBeatplanVisitData(bvisit: beatVisit)
                        cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
                        cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
                        cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
                        return cell
                    }
                    //else if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.activityvisit){
                    else  if(type(of: obj) == Activity.self){
                        //Activity
                   //    let activityvisit = aVisitsFlwupsActivity[currentactivityplanvisitno]
                    //cell.setActivityVisitData(activityvisit:activityvisit)
                        
                       let avisit = obj as? Activity ?? Activity()
                        cell.setActivityVisitData(activityvisit:avisit)
                        //cell.lblCompanyName.text = activityvisit.ActivityTypeName
                        cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
                        cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
                        cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
                        return cell
                    }*/else{
                        return cell
                        }
          /*  cell = tableView.dequeueReusableCell(withIdentifier: Constant.SalesPlanCell, for: indexPath) as? SalesPlanCell
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.vwTitleInfo.tag = indexPath.row
            gesture.numberOfTapsRequired = 1
            cell.vwTitleInfo.addGestureRecognizer(gesture)
            cell.btnVisitDetail.tag = indexPath.row
            cell.btnVisitReport.tag = indexPath.row
            cell.btnVisitCheckin.tag = indexPath.row
    //       let dic = aBeatPlanVisitList[indexPath.row]
    //        print(dic)
    //        print(dic["visitType"] ?? VisitType.planedvisitHistory)
    //        if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.planedvisit){
            let obj = aBeatPlanVisitList[indexPath.row]
            if(type(of: obj) == PlannVisit.self){
                //plan visit
           // let visitobj = aVisitsFlwups[currentplanedvisitno]
            //cell.setVisitData(visit:visitobj)
                let plannedVisit = obj as? PlannVisit ?? PlannVisit.mr_createEntity()
        cell.setVisitData(visit:plannedVisit!)
                
            cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
            cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
            cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
                
                return cell
            
            }
            //else if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.coldcallvisit){
            else  if(type(of: obj) == UnplannedVisit.self){
                //unplanvisit
                 let visitobj = obj as? UnplannedVisit ?? UnplannedVisit()
                    // aVisitsFlwupscoldcall[currentunplanedvisitno]
              //  cell.setUnplanVisitData(visit: visitobj)
                let coldcallvisit = visitobj
                print(coldcallvisit.customerName)
                cell.setUnplanVisitData(visit: coldcallvisit)
                
                cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
                cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
                cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
                currentunplanedvisitno += 1
              return cell
            }
            //else if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.beatplan){
            else if(type(of: obj) == BeatPlan.self){
                //beat visit
               // let beatvisit = aVisitsFlwupsBeatPlan[currentbeatplanvisitno]
             //   cell.setBeatplanVisitData(bvisit: beatvisit)
                let beatVisit = obj as? BeatPlan ?? BeatPlan([:])
                cell.setBeatplanVisitData(bvisit: beatVisit)
                cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
                cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
                cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
                return cell
            }
            //else if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.activityvisit){
            else  if(type(of: obj) == Activity.self){
                //Activity
           //    let activityvisit = aVisitsFlwupsActivity[currentactivityplanvisitno]
            //cell.setActivityVisitData(activityvisit:activityvisit)
                
               let avisit = obj as? Activity ?? Activity()
                cell.setActivityVisitData(activityvisit:avisit)
                //cell.lblCompanyName.text = activityvisit.ActivityTypeName
                cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
                cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
                cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
                return cell
            }else{
                return cell
            }*/
        }
        @objc func visitdetailTapped(sender:UIButton)->(){
            let obj = aBeatPlanVisitList[sender.tag]
            if(type(of: obj) == PlannVisit.self){
                if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
            let planvisit = obj as? PlannVisit
            visitDetail.visitType = VisitType.planedvisit
          
            visitDetail.planvisit = planvisit
            visitDetail.redirectTo = 0
        self.navigationController?.pushViewController(visitDetail, animated: true)
            }
            }else if(type(of: obj) == UnplannedVisit.self){
        if  let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                let unplanvisit = obj as? UnplannedVisit  ?? UnplannedVisit()
                visitDetail.visitType = VisitType.coldcallvisit
                
                visitDetail.unplanvisit = unplanvisit
                visitDetail.redirectTo = 0
            self.navigationController?.pushViewController(visitDetail, animated: true)
        }
            }
        }
        
        @objc func visitReportTapped(sender:UIButton)->(){
            let obj = aBeatPlanVisitList[sender.tag]
            if(type(of: obj) == PlannVisit.self){
                if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                let planvisit = obj as? PlannVisit
                visitDetail.visitType = VisitType.planedvisit
                
                visitDetail.planvisit = planvisit
                visitDetail.redirectTo = 1
                self.navigationController?.pushViewController(visitDetail, animated: true)
                }
            }else if(type(of: obj) == UnplannedVisit.self){
                if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                let unplanvisit = obj as? UnplannedVisit
                visitDetail.visitType = VisitType.coldcallvisit
                
                visitDetail.unplanvisit = unplanvisit
                visitDetail.redirectTo = 1
                self.navigationController?.pushViewController(visitDetail, animated: true)
                }
            }
            
        }
        @objc func visitCheckinTapped(sender:UIButton)->(){
            let obj = aBeatPlanVisitList[sender.tag]
            if(type(of: obj) == PlannVisit.self ){
                if  let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                let planvisit = obj as? PlannVisit
                visitDetail.visitType = VisitType.planedvisit
                
                visitDetail.planvisit = planvisit
                visitDetail.redirectTo = 0
                self.navigationController?.pushViewController(visitDetail, animated: true)
                }
            }else if(type(of: obj) == UnplannedVisit.self){
                if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                let unplanvisit = obj as? UnplannedVisit
                visitDetail.visitType = VisitType.coldcallvisit
                
                visitDetail.unplanvisit = unplanvisit
                visitDetail.redirectTo = 0
                self.navigationController?.pushViewController(visitDetail, animated: true)
                }
            }
            
        }
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            
            // handling code
            cell =  tblSalesPlan.cellForRow(at: IndexPath.init(row: (sender.view?.tag)!, section: 0)) as? SalesPlanCell
           
            print("\(sender.view?.tag ?? 0) \(cell.isexpand ?? false)")
            if(cell.isexpand == true){
                cell.isexpand = false
            }else if(cell.isexpand == false){
                cell.isexpand = true
            }
           DispatchQueue.main.async {
            self.tblSalesPlan.reloadRows(at: [IndexPath.init(row: (sender.view?.tag)!, section: 0)], with: UITableView.RowAnimation.fade)
            }
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
               return  UITableView.automaticDimension
           }
           
           func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
               return 100
           }
        
    }
    extension Dashboard:UITabBarDelegate{
        
    }

    extension Dashboard:CarbonTabSwipeNavigationDelegate{
        func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
            return UIViewController()
        }
    }

    extension  Dashboard:PopUpDelegateNonMandatory{
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        arrOfSelectedExecutive =  arr
        selectedUser = arrOfSelectedExecutive.first
       // tfSelectUser.text = String.init(format: "%@ %@", selectedUser.firstName,selectedUser.lastName)
        selectedUserIDSalesplan = selectedUser.entity_id
        lblSelectedUser.text = String.init(format: "%@ %@", selectedUser.firstName,selectedUser.lastName)
    }
    }





