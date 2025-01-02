//
//  BeatPlanContainer.swift
//  
//
//  Created by Apple on 13/02/20.
//

import UIKit
import CarbonKit
import SVProgressHUD
import MonthYearPicker

class BeatPlanContainerView: BaseViewController {

    func getBeatPlanList(userID: Int, selectedMonth: String, selectedYear: String) {
        print("delegate method called")
    }
    
    @IBOutlet weak var lblSelectedUserName: UILabel!
    @IBOutlet weak var lblSelectedtime: UILabel!
    
    var itemsbeatplanDetail:[String]!
    @IBOutlet weak var targetview: UIView!
    
    @IBOutlet weak var toolbar: UIToolbar!
     var selectedIndex:Int! = 0
    var selectedstr:String!
    var selectedUserIDForBeatPlan:NSNumber!
    var nameOfMonth:String!
    var nameOfYear :String!
    var datepicker:MonthYearPickerView!
    var strselectedDate:String!
   
    var selectedUser:CompanyUsers!
    var selectedUserID:NSNumber = 0
    
    //var arrOfBeatPlan:[BeatPlanListModel]!
    
    var carbonswipenavigationobj:CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
   
    var arrOfUserExceptExecutive:[CompanyUsers]!
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var popup:CustomerSelection? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animate:Bool){
        super.viewDidAppear(true)
        Common.skipVisitSelection = true
    }
    
    // MARK: Method
    
    func setUI(){
        itemsbeatplanDetail = ["List View","Calender View"]
        self.title = "Assign Beat Plan List"
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.homeedit, navigationItem: self.navigationItem)
        self.salesPlandelegateObject = self
      
        
        datepicker = MonthYearPickerView.init()
       // datepicker.setCommonFeature()
        datepicker = MonthYearPickerView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 250, width: view.frame.size.width, height: 200))
        datepicker.date = Date()
        self.dateFormatter.dateFormat = "MM"
        nameOfMonth = self.dateFormatter.string(from: datepicker.date)
        self.dateFormatter.dateFormat = "yyyy"
        nameOfYear = self.dateFormatter.string(from: datepicker.date)
        self.dateFormatter.dateFormat = "MMM,yyyy"
        lblSelectedtime.text = self.dateFormatter.string(from: datepicker.date)
        selectedUser = CompanyUsers().getUser(userId: self.activeuser?.userID ?? 0)
        lblSelectedUserName.text =  String.init(format: "%@ %@", selectedUser.firstName ,selectedUser.lastName)
        self.arrOfSelectedExecutive = [selectedUser]
        selectedUserID = self.activeuser?.userID ?? 0
        if(self.activeuser?.role?.id == 8){
            selectedUserID = self.activeuser?.userID ?? 0
            lblSelectedUserName.text =  String.init(format: "%@ %@", self.activeuser?.firstName ?? "",self.activeuser?.lastName ?? "" )
//            self.loadBeatID(userId: selectedUserID)
//            if(self.activesetting.territoryMandatoryInBeatPlan == true){
//                arrTerriotaryFromAPI = Territory.getTerritoryUsingPredicate(predicate: NSPredicate.init(format: "territoryUserId = '%d'", selectedUserID.intValue))
//                let defaultterritory = Territory.mr_createEntity()
//                defaultterritory?.iD = 0
//                defaultterritory?.territoryCode = ""
//                defaultterritory?.territoryName = "All Territory"
//                
//                //  defaultterritory.
//                arrTerriotaryFromAPI.insert(defaultterritory!, at: 0)
//                territoryPicker.dataSource =  arrTerriotaryFromAPI.map({
//                    String.init(format: "%@|%@", $0.territoryCode,$0.territoryName)
//                })
//                
//                territoryPicker.reloadAllComponents()
            }
        else{
            if(BaseViewController.staticlowerUser.count == 0){
            DispatchQueue.global(qos: .background).async {
            self.fetchuser{
                (arrOfuser,error) in
                
            }
            }
            }
        }
        carbonswipenavigationobj = CarbonTabSwipeNavigation(items:itemsbeatplanDetail, toolBar:toolbar,delegate:self)
        
        carbonswipenavigationobj.insert(intoRootViewController: self, andTargetView: targetview)
        self.style()
       
    }
    
    func datepickerSelectionDone(){
        datepicker.removeFromSuperview()
        
        strselectedDate =  Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepicker.date)
        self.dateFormatter.dateFormat = "MMM,yyyy"
        lblSelectedtime.text = self.dateFormatter.string(from: datepicker.date)
       
     
        
       self.dateFormatter.dateFormat = "MM"
         nameOfMonth = self.dateFormatter.string(from: datepicker.date)
         self.dateFormatter.dateFormat = "yyyy"
         nameOfYear = self.dateFormatter.string(from: datepicker.date)
//        if(self.selectedIndex == 0){
//
//        let beatPlanListObj = self.carbonswipenavigationobj.viewControllers[self.selectedIndex] as? BeatPlanList
//            beatPlanListObj?.userIDForBeatPlantList = selectedUserID
//            beatPlanListObj?.strselectedMonth = nameOfMonth
//            beatPlanListObj?.strselectedyear = nameOfYear
//
//            beatPlanListObj?.getBeatPlanList(userID:self.selectedUserID, selectedMonth: self.nameOfMonth, selectedYear: self.nameOfYear, updateClendar: false)
//
//        }else{
            let beatPlanListObj = self.carbonswipenavigationobj.viewControllers[0] as? BeatPlanList
                beatPlanListObj?.userIDForBeatPlantList = selectedUserID
                beatPlanListObj?.strselectedMonth = nameOfMonth
                beatPlanListObj?.strselectedyear = nameOfYear
            beatPlanListObj?.getBeatPlanList(userID:self.selectedUserID, selectedMonth: self.nameOfMonth, selectedYear: self.nameOfYear, updateClendar: true)
        BeatPlanListCalender.calendar.select(datepicker.date)
        BeatPlanListCalender.calendar.reloadData()
     //   }
        //btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepicker.date), for: .normal)
      //  self.getVisitFollowupList()
        
    }
    
    func style(){
        
        let color:UIColor = UIColor.Appthemecolor
        
        let boldfont = UIFont.init(name: Common.kfontbold, size: 15)
        carbonswipenavigationobj.setIndicatorColor(UIColor.Appthemecolor)
        
        carbonswipenavigationobj.setSelectedColor(color, font: boldfont ?? UIFont.boldSystemFont(ofSize: 15))
        toolbar.barTintColor = UIColor.white
        // carbonswipenavigationobj.setTabExtraWidth(-10)
        
            carbonswipenavigationobj.carbonSegmentedControl?.setWidth((UIScreen.main.bounds.size.width)/2 , forSegmentAt: 0)
        var width = 1.0
      //  let targetviewwidth = self.targetView.frame.size.width
        if((itemsbeatplanDetail?.count)! > 3){
            width = Double((self.targetview.frame.size.width/3.0))
        }
        else{
            width=Double(Int(UIScreen.main.bounds.size.width) / ((itemsbeatplanDetail?.count)!))
            print("count of header is = \(itemsbeatplanDetail.count) items \(itemsbeatplanDetail) width = \(width)")
        }
        for index in itemsbeatplanDetail! {
          //  print(items?.firstIndex(of: index));
          carbonswipenavigationobj.carbonSegmentedControl?.setWidth(CGFloat(width), forSegmentAt: (itemsbeatplanDetail?.firstIndex(of: index))!)
        }
        //    ca
        
        
        //        for index in itemsvisitDetail! {
        //carbonswipenavigationobj.carbonSegmentedControl?.setWidth(CGFloat(200.0), forSegmentAt: (itemsvisitDetail?.firstIndex(of: index))!)
        //        }
        
        //UIFont.init(name: kFontMedium, size: 15)
        
        
        carbonswipenavigationobj.setNormalColor(UIColor.gray, font: boldfont ?? UIFont.boldSystemFont(ofSize: 15))
        carbonswipenavigationobj.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
        toolbar.barTintColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: IBAction
    
    @IBAction func btnPlusClicked(_ sender: UIButton) {
        if  let assignbeatplan = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.AssignBeatPlanView) as? AssignBeatPlan{
            Common.skipVisitSelection = false
        assignbeatplan.strselectedmonth = nameOfMonth
        assignbeatplan.strselectedyear = nameOfYear
    self.navigationController?.pushViewController(assignbeatplan, animated: true)
        }
    }
    
    
    @IBAction func btnCalenderTapped(_ sender: UIButton) {
         self.openOnlyMonthDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:datepicker, textfield: nil, withDateMonth: true)
    }
    
    @IBAction func btnSelectUserClicked(_ sender: UIButton) {
        if(self.activeuser?.role?.id == 8){
            lblSelectedUserName.text = String.init(format: "%@ %@", arguments: [self.activeuser?.firstName ?? "    ",self.activeuser?.lastName ?? ""])
        }
            arrOfUserExceptExecutive = [CompanyUsers]()
//            arrOfUserExceptExecutive = BaseViewController.staticlowerUser.filter{
//                $0.role_id.intValue <=  8
//            }
            arrOfUserExceptExecutive = BaseViewController.staticlowerUser
            if let currentuserid = self.activeuser?.userID{
                if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                    if(!(self.arrOfUserExceptExecutive.contains(currentuser))){
               arrOfUserExceptExecutive.append(currentuser)
                    }
                    if(self.arrOfSelectedExecutive.count == 0){
                        self.arrOfSelectedExecutive = [currentuser]
                    }
                }
            }
            if(arrOfUserExceptExecutive.count == 0){
                Utils.toastmsg(message:"No Executive reporting to you",view:self.view)
            }else{
//                self.arrOfUserExceptExecutive = self.arrOfUserExceptExecutive.sort{
//                    $0.firstName < $1.firstName
//                }
                let sortedUserarr = self.arrOfUserExceptExecutive.sorted { (user1, user2) -> Bool in
                    user1.firstName < user2.firstName
                }
                self.arrOfUserExceptExecutive = sortedUserarr
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.isFromSalesOrder =  false
                self.popup?.modalPresentationStyle = .overCurrentContext
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
                // popup?.showAnimate()
                self.popup?.parentViewOfPopup = self.view
                Utils.addShadow(view: self.view)
                self.present(self.popup!, animated: false, completion: nil)
            }
        }

}

extension BeatPlanContainerView:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        selectedstr = itemsbeatplanDetail?[Int(index)]
        selectedIndex = Int(index)
      
      
        if(selectedstr == "List View"){
       
           if let beatPlanListObj =
            Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanListView) as? BeatPlanList{
            //beatPlanListObj.delegate = self
            beatPlanListObj.userIDForBeatPlantList = selectedUserID
            beatPlanListObj.strselectedMonth = nameOfMonth
            beatPlanListObj.strselectedyear = nameOfYear
           // beatPlanListObj.strselectedyear =
            return beatPlanListObj
           }else{
            return UIViewController()
            }
          
            
        }else if(selectedstr == "Calender View"){
            if let beatPlanListObj =
             Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanListCelander) as? BeatPlanListCalender{
             //beatPlanListObj.delegate = self
             beatPlanListObj.userIDForBeatPlantList = selectedUserID
             beatPlanListObj.strselectedMonth = nameOfMonth
             beatPlanListObj.strselectedyear = nameOfYear
            // beatPlanListObj.strselectedyear =
             return beatPlanListObj
            }else{
             return UIViewController()
             }
        }else{
            return UIViewController()
        }
    }
    
    
}
extension BeatPlanContainerView:BaseViewControllerDelegate{
    func editiconTapped(sender:UIBarButtonItem) {
        if let editbeatplan = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.EditAssignBeatPlan) as? EditAssignBeatPlan{
        Common.skipVisitSelection = false
        editbeatplan.selectedUserID = self.selectedUserID
       editbeatplan.selectedTimeText = lblSelectedtime.text
        editbeatplan.strSelectedMonth = nameOfMonth
        editbeatplan.strSelectedYear = nameOfYear
        editbeatplan.strSelectedUser = lblSelectedUserName.text
        self.navigationController?.pushViewController(editbeatplan, animated: true)
        }
        
    }
    
    func cancelbtnTapped() {
        datepicker.removeFromSuperview()
        
    }
    
}
extension BeatPlanContainerView:PopUpDelegateNonMandatory{
   
    
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        arrOfSelectedExecutive =  arr
        selectedUser = arrOfSelectedExecutive.first
        lblSelectedUserName.text = String.init(format: "%@ %@", selectedUser.firstName,selectedUser.lastName)
        selectedUserID = selectedUser.entity_id
        if(selectedIndex == 0){
         //   SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            
        let beatPlanListObj = self.carbonswipenavigationobj.viewControllers[selectedIndex] as? BeatPlanList
            beatPlanListObj?.userIDForBeatPlantList = selectedUserID
            beatPlanListObj?.strselectedMonth = nameOfMonth
            beatPlanListObj?.strselectedyear = nameOfYear
            beatPlanListObj?.getBeatPlanList(userID:selectedUserID, selectedMonth: nameOfMonth, selectedYear: nameOfYear, updateClendar: false)
        }else{
            let beatPlanListObj = self.carbonswipenavigationobj.viewControllers[selectedIndex] as? BeatPlanList
                beatPlanListObj?.userIDForBeatPlantList = selectedUserID
                beatPlanListObj?.strselectedMonth = nameOfMonth
                beatPlanListObj?.strselectedyear = nameOfYear
                beatPlanListObj?.getBeatPlanList(userID:selectedUserID, selectedMonth: nameOfMonth, selectedYear: nameOfYear, updateClendar: true)
        }
//        self.loadBeatID(userId: selectedUserID)
//        if(self.activesetting.territoryMandatoryInBeatPlan == true){
//            arrTerriotaryFromAPI = Territory.getTerritoryUsingPredicate(predicate: NSPredicate.init(format: "territoryUserId = %d", selectedUserID.intValue))
//            let defaultterritory = Territory.mr_createEntity()
//            defaultterritory?.iD = 0
//            defaultterritory?.territoryCode = ""
//            defaultterritory?.territoryName = "All Territory"
//
//            //  defaultterritory.
//            arrTerriotaryFromAPI.insert(defaultterritory!, at: 0)
//
//            territoryPicker.dataSource =  arrTerriotaryFromAPI.map({
//                String.init(format: "%@|%@", $0.territoryCode,$0.territoryName)
//            })
//            if(territoryPicker.dataSource.count > 0 && arrTerriotaryFromAPI.count > 0){
//                selectedterritoryID = arrTerriotaryFromAPI.first?.iD ?? 0
//            }else{
//                selectedterritoryID = 0
//            }
//
//            territoryPicker.reloadAllComponents()
        //}
    }
    
    
    
}
