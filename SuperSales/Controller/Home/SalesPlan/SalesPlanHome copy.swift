//
//  SalesPlan.swift
//  SuperSales
//
//  Created by Apple on 28/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
//import KeyedDecodingContainer

class SalesPlanHome: BaseViewController {
    var cell:SalesPlanCell!
    @IBOutlet weak var btnSelectedDate: UIButton!
    
    @IBOutlet weak var tblSalesPlan: UITableView!
    var isOnHome:Bool!
    var toolbarMenus = [MenuTabs]()
    var sideMenus:[CompanyMenus]!
    var temp:[UPStackMenuItem]!
    let activeAccount = Utils().getActiveAccount()
    var selectedDate:String!
    var selectedUserID:String!
    var aVisitsFlwups:[PlannVisit]! = [PlannVisit]()
    var aVisitsFlwupscoldcall:[UnplannedVisit]! = [UnplannedVisit]()
    var aVisitsFlwupsBeatPlan:[BeatPlan]! = [BeatPlan]()
    var aVisitsFlwupsActivity:[Activity]! = [Activity]()
    var aBeatPlanVisitList:[[String:Any]]! =  [[String:Any]]()
   
    var arrLowerLevelUser = [CompanyUsers]()
    @IBOutlet weak var tabBarHome: UITabBar!
    
    @IBOutlet weak var btnCheckIn: UIButton!
    @IBOutlet weak var lblCheckInDetail: UILabel!
    @IBOutlet weak var imgCheckInInfo: UIImageView!
    
    @IBOutlet weak var vwCheckInInfo: UIView!
    
    @IBOutlet weak var vwForTeam: UIView!
    
    @IBOutlet weak var vwDateSelection: UIView!
    @IBOutlet weak var vwTargetView: UIView!
    var datepicker:UIDatePicker!
    var recordtillbeatplanInt:Int =  0
    var currentplanedvisitno = 0
    var currentunplanedvisitno = 0
    var currentactivityplanvisitno = 0
    var currentbeatplanvisitno = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbarMenus =  MenuTabs.getTabMenus(menu:[NSNumber.init(value:3),NSNumber.init(value:4),NSNumber.init(value:5),NSNumber.init(value:6),NSNumber.init(value:22)],sort:true)
        self.salesPlandelegateObject = self
        self.setUI()
        self.setData()
        selectedUserID = activeAccount.userID?.stringValue
        if(self.lowerUser?.count ?? 0 > 0 ){
             arrLowerLevelUser = self.lowerUser!
           
        }else{
            //self.fetchuser()
        }
        self.apihelper.loadAttendanceHistory(member_id: activeAccount.userID! , month: "01", year: "2020") { (arr,status,message,error,responseType) in
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
         self.getVisitFollowupList()
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
            let upstackmenu = UPStackMenuItem.init(image: UIImage.init(named: "icon_plus_addproduct"), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16))
            upstackmenu?.isUserInteractionEnabled = true
            temp.append(upstackmenu ?? UPStackMenuItem())
        }
        self.initbottomMenu(menus: temp, control: self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController!.isNavigationBarHidden = false
    }
    
    func setUI(){
    self.title = NSLocalizedString("Sales-Plan-small",  comment: "")
    vwForTeam.addBorders(edges: [.top,.bottom], color: UIColor.black, cornerradius: 0)
    vwCheckInInfo.addBorders(edges: [.top,.bottom], color: UIColor.black, cornerradius: 0)
     vwDateSelection.addBorders(edges: [.top,.bottom], color: UIColor.black, cornerradius: 0)
    self.tabBarHome.isHidden = true
        if((self.activeuser.role?.id == NSNumber.init(value: 7)) || (self.activeuser.role?.id == NSNumber.init(value: 5))){
    self.vwForTeam.isHidden = false
            if(self.activeuser.role?.id == NSNumber.init(value: 5)){
                self.vwCheckInInfo.isHidden = true
            }
        }else if(self.activeuser.role?.id == NSNumber.init(value: 9)){
            self.istabBarpresent = false
             self.vwForTeam.isHidden = true
            self.vwCheckInInfo.isHidden = true
        }
        else
            {
           self.istabBarpresent = true
            self.vwForTeam.isHidden = true
            }
   
    Common.setTitleOfView(color:UIColor.white, viewController: self)
        self.setleftbtn(btnType: BtnLeft.menu,navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.others,navigationItem: self.navigationItem)
        btnCheckIn.layer.cornerRadius = 5
        btnCheckIn.backgroundColor = UIColor.Appthemebluecolor
        tblSalesPlan.delegate = self
        tblSalesPlan.dataSource = self
        tblSalesPlan.separatorColor = .clear
        tblSalesPlan.tableFooterView = UIView()
        datepicker = UIDatePicker.init()
        datepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 285, width: view.frame.size.width, height: 200))
        //datepicker.frame =
    }
    
    func setData(){
        selectedDate =  Utils().getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:Date())
        btnSelectedDate.setTitle(Utils().getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:Date()), for: .normal)
       
    }
    //MARK: -APICall
    func  getVisitFollowupList(){
        SVProgressHUD.show()
        self.apihelper.getVisitFollowUps(selecteduserID: selectedUserID, selectedDate: selectedDate) { (arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(error.code == 0){
                  let arrVisitFollowUpList = arr as? [[String:Any]] ?? [[String:Any]]()
                let mapping = PlannVisit.defaultmapping()
                let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                store.saveContextOnCommit = false
                let deserialiser = FEMDeserializer.init(store: store)
                if(arrVisitFollowUpList.count > 0){
                    self.aVisitsFlwups.removeAll()
                
                    for dic in arrVisitFollowUpList{
                        var dicVisit = dic  
                    //    let dictVisit =
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
                        let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId ))
                            if(companyuser.entity_id.intValue > 0){
                            let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                dicVisit["RessigneeName"] = reassignUserName
                                }else{
                dicVisit["RessigneeName"] = ""
                                }
                            }else{
                           dicVisit["RessigneeName"] = ""
                            }
                          
                            let objVisit = deserialiser.object(fromRepresentation: dicVisit, mapping: mapping)
                             dicVisit["visitType"] = VisitType.planedvisit
                        self.aBeatPlanVisitList.append(dicVisit)
                            self.aVisitsFlwups.append(objVisit as! PlannVisit)
                           
                        }else{
                            let objcoldcall = UnplannedVisit().initwithdic(dict: dicVisit)
                       dicVisit["visitType"] = VisitType.coldcallvisit
                            self.aBeatPlanVisitList.append(dicVisit)
                        self.aVisitsFlwupscoldcall.append(objcoldcall)
                        }
                    }
//                    self.currentRecord =  currentRecord + self.aVisitsFlwups.count
//                    self.currentRecord =  currentRecord + self.aVisitsFlwupscoldcall.count
                    self.fetchActivityFollowUps()
                    self.tblSalesPlan.reloadData()
                }else{
                     self.fetchActivityFollowUps()
                }
            }else{
                  self.fetchActivityFollowUps()
            UIApplication.shared.windows.first?.makeToast(message)
            }
        }
    }
    func fetchActivityFollowUps(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        let acticityjson = ["CreatedBy":selectedUserID,"CompanyID":self.activeuser.company?.iD ?? 0] as [String : Any]
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
                        
            self.aBeatPlanVisitList.append(activity)
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
                self.view.makeToast(message)
            }
        }
    }
    
    func fetchBeatPlanFoolowup(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        let beatplanjson = ["CreatedBy":selectedUserID,"CompanyID":self.activeuser.company?.iD ?? 0] as [String : Any]
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
                self.aBeatPlanVisitList.append(beatplanvisit)
                            self.aVisitsFlwupsBeatPlan.append(beatplanvisitobj)
                        }
                        
                    }
                }else{
                    print(arr)
                }
                 self.tblSalesPlan.reloadData()
            }
            else{
                self.view.makeToast(message)
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
//                   UIApplication.shared.windows.first?.makeToast(message)
//            }
//        }
//        }
//        return self.arrLowerLevelUser
//    }
    // MARK: - IBAction
    
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
extension SalesPlanHome:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    
    @objc func menuitemTouched(item: UPStackMenuItem) {
        
        if(item.title.lowercased() == "visit"){
            
            let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: "leadselection")
                as! Leadselection
            addplanvisit.selectionFor = SelectionOf.visit
//    UIApplication.shared.keyWindow?.addSubview(addplanvisit.view)
        //    self.present(addplanvisit, animated: false, completion: nil)
self.navigationController!.pushViewController(addplanvisit, animated: true)
        }else if(item.title.lowercased() == "new beat route"){
            
        }else if(item.title.lowercased() == "lead"){
            let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: "leadselection") as! Leadselection
            newlead.selectionFor = SelectionOf.lead
//          self.present(newlead, animated: false, completion: nil)
            self.navigationController!.pushViewController(newlead, animated: true)
        }else if(item.title.lowercased() == "new order"){
            
        }else if(item.title.lowercased() == "new cold call"){
            let addcoldvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit , classname: Constant.AddUnplanVisitView)
            self.navigationController!.pushViewController(addcoldvisit, animated: true)
            
        }
    }
    
    func datepickerSelectionDone(){
     selectedDate =  Utils().getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepicker.date)
 btnSelectedDate.setTitle(Utils().getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepicker.date), for: .normal)
         self.getVisitFollowupList()
        
    }
    
     func cancelbtnTapped() {
        datepicker.removeFromSuperview()
    }
    
}
extension SalesPlanHome:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aBeatPlanVisitList.count
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
        let dic = aBeatPlanVisitList[indexPath.row]
        print(dic["visitType"] ?? VisitType.planedvisitHistory)
        if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.planedvisit){
        
            //plan visit
        let visitobj = aVisitsFlwups[currentplanedvisitno]
        cell.setVisitData(visit:visitobj)
        cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
        cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
        cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
            
            return cell
        
        }
        else if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.coldcallvisit){
            //unplanvisit
             let visitobj = aVisitsFlwupscoldcall[currentunplanedvisitno]
            cell.setUnplanVisitData(visit: visitobj)
            cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
            cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
            cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
          return cell
        }else if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.beatplan){
            //beat visit
            let beatvisit = aVisitsFlwupsBeatPlan[currentbeatplanvisitno]
            cell.setBeatplanVisitData(bvisit: beatvisit)
            
            cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
            cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
            cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
            return cell
        }else if(dic["visitType"] as? VisitType  ?? VisitType.planedvisitHistory ==  VisitType.activityvisit){
            //Activity
           let activityvisit = aVisitsFlwupsActivity[currentactivityplanvisitno]
        cell.setActivityVisitData(activityvisit:activityvisit)
            //cell.lblCompanyName.text = activityvisit.ActivityTypeName
            cell.btnVisitDetail.addTarget(self, action: #selector(visitdetailTapped(sender:)), for: .touchUpInside)
            cell.btnVisitReport.addTarget(self, action: #selector(visitReportTapped(sender:)), for: .touchUpInside)
            cell.btnVisitCheckin.addTarget(self, action: #selector(visitCheckinTapped(sender:)), for: .touchUpInside)
            return cell
        }else{
            return cell
        }
    }
    @objc func visitdetailTapped(sender:UIButton)->(){
        let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as! VisitDetail
        visitDetail.visitType = VisitType.planedvisit
      
        visitDetail.planvisit = aVisitsFlwups[sender.tag];
        visitDetail.redirectTo = 0
        self.navigationController?.pushViewController(visitDetail, animated: true)
    }
    @objc func visitReportTapped(sender:UIButton)->(){
        let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as! VisitDetail
         visitDetail.visitType = VisitType.planedvisit
      //  visitDetail.isVisitPlanned = true
        visitDetail.planvisit = aVisitsFlwups[sender.tag];
        visitDetail.redirectTo = 1
        self.navigationController?.pushViewController(visitDetail, animated: true)
    }
    @objc func visitCheckinTapped(sender:UIButton)->(){
        let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as! VisitDetail
         visitDetail.visitType = VisitType.planedvisit
      //  visitDetail.isVisitPlanned = true
        visitDetail.planvisit = aVisitsFlwups[sender.tag];
        visitDetail.redirectTo = 0
            
            self.navigationController?.pushViewController(visitDetail, animated: true)
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
