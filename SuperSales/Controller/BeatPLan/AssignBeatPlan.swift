//
//  AssignBeatPlan.swift
//  SuperSales
//
//  Created by Apple on 28/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD

class AssignBeatPlan: BaseViewController {
    // swiftlint: disable line_length
    @IBOutlet weak var tfStartDate: UITextField!
    
    @IBOutlet weak var tfEndDate: UITextField!
    @IBOutlet weak var vwSelectUser:UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tfSelectUser: UITextField!
    var strselectedmonth:String!
    var strselectedyear:String!
    
    var selectedRecord:Int = 0
    var selectedUser:CompanyUsers!
    var arrOfUserExceptExecutive:[CompanyUsers]! = [CompanyUsers]()
    var popup:CustomerSelection? = nil
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOfBeatPlan:[BeatPlan]!
    var beatForSelectedBeatPlan:[BeatPlan]!
    var arrOfTableBeatPlan:[BeatPlanAssign]! = [BeatPlanAssign]()
    var arrOfSelectedTableBeatPlan:[BeatPlanAssign]! = [BeatPlanAssign]()
    var startDate:Date!
    var endDate:Date!
    var startDatedatepicker:UIDatePicker!
    var endDatePicker:UIDatePicker!
    var selectedUserID:NSNumber = 0
    var isBeatsFiltered = false
    var arrTerriotaryFromAPI = [Territory]()
    var territoryPicker = DropDown()
    var beatIDPicker = DropDown()
    var selectedterritoryID:Int32 = 0
    var selectedBeatID = 0
    var tableViewHeight: CGFloat {
        tblBeatPlan.layoutIfNeeded()
        return tblBeatPlan.contentSize.height
    }
    var cell:BeatPlanAssignCell!
    var arrOfdicBeatPaln = [[String:Any]]()
    @IBOutlet weak var heightTblBeatPlan: NSLayoutConstraint!
    
    @IBOutlet weak var tblBeatPlan: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tblBeatPlan.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblBeatPlan.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    
    
    // MARK: - Method

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){

            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.heightTblBeatPlan.constant = newsize.height
            }
        }
    }
    
    

    func setUI(){
        
        
        
        tfStartDate.setCommonFeature()
        tfEndDate.setCommonFeature()
        tfSelectUser.setCommonFeature()
        
        btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        beatForSelectedBeatPlan = [BeatPlan]()
        arrOfBeatPlan = [BeatPlan]()
        selectedUser =  CompanyUsers().getUser(userId: self.activeuser?.userID ?? 0)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.title = "Assign Beat Plan"
        
        self.salesPlandelegateObject = self
        startDatedatepicker = UIDatePicker()
        endDatePicker = UIDatePicker()
        startDatedatepicker.minimumDate = Date.yesterday
        endDatePicker.minimumDate = Date()
        startDatedatepicker.setCommonFeature()
        endDatePicker.setCommonFeature()
   
        startDatedatepicker.date = Date.yesterday
        endDatePicker.date = Date()
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        tfStartDate.delegate = self
        tfEndDate.delegate = self
        tfStartDate.inputView = startDatedatepicker
        tfEndDate.inputView = endDatePicker
        tfSelectUser.delegate = self
//        if(self.activeuser?.role?.id == 8){
//            selectedUserID = self.activeuser?.userID ?? 0
//            tfSelectUser.text =  String.init(format: "%@ %@", self.activeuser?.firstName ?? "",self.activeuser?.lastName ?? "" )
//             self.arrOfBeatPlan = [BeatPlan]()
//           //self.tfSelectUser.text = "Select Sales Person"
//          //  self.loadBeatID(userId: selectedUserID)
//         //   if(self.activesetting.territoryMandatoryInBeatPlan == true){
//
//           // }
//        }else{
//            self.fetchuser{
//                (arrOfuser,error) in
//                self.arrOfUserExceptExecutive = BaseViewController.staticlowerUser
//                if(self.arrOfUserExceptExecutive.count == 1){
//                    self.selectedUser = self.arrOfUserExceptExecutive.first
//                    self.tfSelectUser.text = String.init(format: "%@ %@", self.selectedUser.firstName,self.selectedUser.lastName)
//                    self.displayBeat()
//                }
//            }
//        }
       // DispatchQueue.global(qos: .background).async {
        if(BaseViewController.staticlowerUser.count == 0){
        self.fetchuser{
            (arrOfuser,error) in
            self.arrOfUserExceptExecutive = [CompanyUsers]()
//                arrOfUserExceptExecutive = BaseViewController.staticlowerUser.filter{
//                    $0.role_id.intValue <=  8
//                }
            
            
            
            self.arrOfUserExceptExecutive = BaseViewController.staticlowerUser
            if(self.arrOfUserExceptExecutive.count == 0){
                self.vwSelectUser.isHidden = true
            }else{
                self.vwSelectUser.isHidden = false
            }
        if let currentuserid = self.activeuser?.userID{
            if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                if(!(self.arrOfUserExceptExecutive.contains(currentuser))){
            

                self.arrOfUserExceptExecutive.append(currentuser)
                }
                if(self.arrOfSelectedExecutive.count == 0){
                    self.arrOfSelectedExecutive = [currentuser]
                }
            }
        }
            self.arrOfUserExceptExecutive = self.arrOfUserExceptExecutive.filter({ (user) -> Bool in
                user.role_id != 9
            })
            if(self.arrOfUserExceptExecutive.count == 1){
                self.selectedUser = self.arrOfUserExceptExecutive.first
                self.tfSelectUser.text = String.init(format: "%@ %@", self.selectedUser.firstName,self.selectedUser.lastName)
                
                self.displayBeat()
            }else if(self.activeuser?.role?.id == 8 && self.arrOfUserExceptExecutive.count == 1){
                self.selectedUserID = self.activeuser?.userID ?? 0
                self.tfSelectUser.text =  String.init(format: "%@ %@", self.activeuser?.firstName ?? "",self.activeuser?.lastName ?? "" )
                self.arrOfBeatPlan = [BeatPlan]()
                self.displayBeat()
                           //self.tfSelectUser.text = "Select Sales Person"
                          //  self.loadBeatID(userId: selectedUserID)
            }else{
                self.tfSelectUser.text = "Select Sales Person"
            }
        //}
        }
        }
        else{
            self.arrOfUserExceptExecutive = BaseViewController.staticlowerUser
//            if(self.arrOfUserExceptExecutive.count == 0){
//                self.vwSelectUser.isHidden = true
//            }else{
//                self.vwSelectUser.isHidden = false
//            }
        if let currentuserid = self.activeuser?.userID{
            if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                if(!(self.arrOfUserExceptExecutive.contains(currentuser))){
            

                self.arrOfUserExceptExecutive.append(currentuser)
                }
                if(self.arrOfSelectedExecutive.count == 0){
                    self.arrOfSelectedExecutive = [currentuser]
                }
            }
        }
            self.arrOfUserExceptExecutive = self.arrOfUserExceptExecutive.filter({ (user) -> Bool in
                user.role_id != 9
            })
            if(self.arrOfUserExceptExecutive.count == 1){
                self.selectedUser = self.arrOfUserExceptExecutive.first
                self.tfSelectUser.text = String.init(format: "%@ %@", self.selectedUser.firstName,self.selectedUser.lastName)
                
                self.displayBeat()
            }else if(self.activeuser?.role?.id == 8 && self.arrOfUserExceptExecutive.count == 1){
                self.selectedUserID = self.activeuser?.userID ?? 0
                self.tfSelectUser.text =  String.init(format: "%@ %@", self.activeuser?.firstName ?? "",self.activeuser?.lastName ?? "" )
                self.arrOfBeatPlan = [BeatPlan]()
                self.displayBeat()
                        
            }else{
                self.tfSelectUser.text = "Select Sales Person"
            }
        //}
        }
        
        arrTerriotaryFromAPI = Territory.getTerritoryUsingPredicate(predicate: NSPredicate.init(format: "territoryUserId = '%d'", selectedUserID.intValue))
        let defaultterritory = Territory.mr_createEntity()
        defaultterritory?.iD = 0
        defaultterritory?.territoryCode = ""
        defaultterritory?.territoryName = "All Territory"
        defaultterritory?.territoryUserName = ""
        defaultterritory?.modifiedTime = ""
       
        territoryPicker.dataSource =  arrTerriotaryFromAPI.map({
           String.init(format: "%@ | %@", $0.territoryCode,$0.territoryName)
        })
        
//       var territoryName =  arrTerriotaryFromAPI.map{
//            $.territoryName
//
//        }
        if(!territoryPicker.dataSource.contains("All Territory")){
        territoryPicker.dataSource.insert("All Territory", at: 0)
       // territoryPicker.dataSource.append("All Territory")
        arrTerriotaryFromAPI.insert(defaultterritory!, at: 0)
        }
        territoryPicker.reloadAllComponents()
        startDate = Date()
        endDate = Date()
        tfStartDate.text =  Utils.getDateWithAppendingDay(day: 0, date: startDatedatepicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)//dateFormatter.string(from: startDate)
        tfEndDate.text = Utils.getDateWithAppendingDay(day: 0, date: endDatePicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
           
        tfStartDate.setrightImage(img: UIImage.init(named: "icon_calender")!)
        tfEndDate.setrightImage(img: UIImage.init(named: "icon_calender")!)
        tfSelectUser.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tblBeatPlan.delegate = self
        tblBeatPlan.dataSource = self
        tblBeatPlan.separatorColor = UIColor.clear
        if(self.activeuser?.role?.id == 8){
            tfSelectUser.text = String.init(format: "%@ %@", arguments: [self.activeuser?.firstName ?? "    ",self.activeuser?.lastName ?? ""])
        }
    }
    func getDateArray(){
        if(selectedUserID == 0){
            Utils.toastmsg(message:"Please Select User",view: self.view)
        }else{
            if(arrOfBeatPlan.count > 0){
                SVProgressHUD.show(withStatus: "Calculating Days")
                arrOfTableBeatPlan = [BeatPlanAssign]()
                self.dateFormatter.dateFormat = "dd-MM-yyyy"
                let sd = self.dateFormatter.date(from: self.tfStartDate.text ?? "")
                let ld = self.dateFormatter.date(from: self.tfEndDate.text ?? "")
                let strstartdate = self.dateFormatter.string(from: sd ?? Date())
                let strenddate = self.dateFormatter.string(from: ld ?? Date())
                let startDate = self.dateFormatter.date(from: strstartdate)
                let endDate = self.dateFormatter.date(from: strenddate)
                let calender = Calendar.init(identifier: Calendar.Identifier.gregorian)
                var dic = [String:Any]()
                let daycomponents = calender.dateComponents([.day], from: startDate ?? Date(), to: endDate ?? Date())
//                if((self.beatForSelectedBeatPlan.count > 0) && (isBeatsFiltered == true)){
//                    dic["selectedBeatPlan"] = self.beatForSelectedBeatPlan.first
//                }else if((isBeatsFiltered == false) &&  (arrOfBeatPlan.count > 0 )){
//                     dic["selectedBeatPlan"] = self.arrOfBeatPlan.first
//                }else{
                    var dicForSelectedBeatPlan = [String:Any]()
                    dicForSelectedBeatPlan["BeatPlanName"] = "Select Beat ID"
                    dicForSelectedBeatPlan["BeatPlanID"] =  NSNumber.init(value:0)
                    dic["selectedBeatPlan"] = dicForSelectedBeatPlan
              //  }
                
      //  if(self.activesetting.territoryMandatoryInBeatPlan ==  true  && self.arrTerriotaryFromAPI.count > 0){
                if(self.arrTerriotaryFromAPI.count > 0){
                dic["selectedTerritory"] =  self.arrTerriotaryFromAPI.first
                }
                dic["CreatedBy"] = self.activeuser?.userID
                dic["AssigneeID"] = self.selectedUserID
                dic["CompanyID"] = self.activeuser?.company?.iD
                dic["isSelected"] =  false
                //                        daycomponents
                if(daycomponents.day ?? 0 > 0){
                    for i in 0...daycomponents.day! - 1{
                        var newcomponents = DateComponents()
                        newcomponents.day = i
                        let date = calender.date(byAdding: newcomponents, to: startDate!)
                        dic["BeatPlanDate"] =  self.dateFormatter.string(from: date!)
                        var beatplanassignobj =  BeatPlanAssign.init(dic)
                        self.dateFormatter.dateFormat = String("yyyy'\'/MM'\'/dd' hh:mm:ss")
                        beatplanassignobj.BeatPlanDate =  self.dateFormatter.string(from: date!)
                        if(arrTerriotaryFromAPI.count > 0){
                            beatplanassignobj.selectedTerritory = arrTerriotaryFromAPI.first
                        }
        self.arrOfTableBeatPlan.append(beatplanassignobj)
                        
                        //let obj =
                    }
                    self.dateFormatter.dateFormat = "dd-MM-yyyy"
                    let lld = self.dateFormatter.date(from: tfEndDate.text ?? "")
                    self.dateFormatter.dateFormat = String("yyyy'\'/MM'\'/dd' hh:mm:ss")
                    dic["BeatPlanDate"] = self.dateFormatter.string(from:lld ?? Date())
                    let obj = BeatPlanAssign.init(dic)
                    if(arrTerriotaryFromAPI.count > 0){
                        dic["selectedTerritory"] = arrTerriotaryFromAPI.first
                    }
                    arrOfTableBeatPlan.append(obj)
                    
                }else{
                    if(tfEndDate.text == tfStartDate.text){
                    self.dateFormatter.dateFormat = "dd-MM-yyyy"
                    let lld = self.dateFormatter.date(from: tfEndDate.text ?? "")
                    self.dateFormatter.dateFormat = String("yyyy'\'/MM'\'/dd' hh:mm:ss")
                    dic["BeatPlanDate"] = self.dateFormatter.string(from:lld ?? Date())
                    let obj = BeatPlanAssign.init(dic)
                    if(arrTerriotaryFromAPI.count > 0){
                        dic["selectedTerritory"] = arrTerriotaryFromAPI.first
                    }
                    arrOfTableBeatPlan.append(obj)
                    }
                }
               
                tblBeatPlan.reloadData()
//                if(arrOfBeatPlan.count > 0 ){
//
//                  //  self.tblBeatPlan.isScrollEnabled = false
//
//                tblBeatPlan.translatesAutoresizingMaskIntoConstraints = false
//                self.heightTblBeatPlan.constant = tableViewHeight
//                }
              //  print(heightTblBeatPlan.constant)
                SVProgressHUD.dismiss()
            }else {
                // Utils.toastmsg(message:"You have not BeatIds")
            }
        }
    }

    func setValidation()->Bool{
        
        if(selectedUserID == 0){
            Utils.toastmsg(message:"Please select the user",view: self.view)
            return false
        }else if(arrOfSelectedTableBeatPlan.count == 0){
            Utils.toastmsg(message:"Please select atleast one date/beat",view: self.view)
            return false
        }else if(Utils.getNSDateWithAppendingDay(day: 0, date1: endDatePicker.date, format: "yyyy/MM/dd").compare(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd")) == .orderedAscending){
            Utils.toastmsg(message:"Enter valid Activity date",view: self.view)
            return false
        }else{
           
            let arrofselectedBeatPlan = arrOfSelectedTableBeatPlan.map {
                $0.selectedBeatPlan
            }
            let unselectedbeatarr =  arrofselectedBeatPlan.filter{
                ($0?.BeatPlanID == "0") || ($0?.BeatPlanID == "")
            }
            if(unselectedbeatarr.count == 0){
                print("count of beat plan = \(arrOfSelectedTableBeatPlan.count)")
                arrOfdicBeatPaln = [[String:Any]]()
            for beatplanassign in 0...arrOfSelectedTableBeatPlan.count-1{
               
                
                let beatplan =
                   arrOfSelectedTableBeatPlan[beatplanassign]
                print("selected beat plan \(beatplan.selectedBeatPlan?.BeatPlanID)")
                arrOfSelectedTableBeatPlan.remove(at: beatplanassign)
                var bp = [String:Any]()
                self.dateFormatter.dateFormat = "yyyy'\'/MM'\'/dd' hh:mm:ss"
                
                let dt = self.dateFormatter.date(from: beatplan.BeatPlanDate)
//                self.dateFormatter.locale =  NSLocale.init(localeIdentifier: "UTC") as Locale
//                self.dateFormatter.timeZone =  NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
                self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let strDate  = self.dateFormatter.string(from: dt!)
                bp["AssigneeID"] = beatplan.AssigneeID
                bp["BeatPlanDate"] = strDate
                bp["territoryId"] = beatplan.selectedTerritory?.iD
                bp["CompanyID"] = beatplan.CompanyID
                bp["BeatPlanID"] = beatplan.selectedBeatPlan?.BeatPlanID
                bp["CreatedBy"] = beatplan.CreatedBy
                bp["isSelected"] = beatplan.isSelected
                arrOfSelectedTableBeatPlan.insert(beatplan, at: beatplanassign)
                arrOfdicBeatPaln.insert(bp, at: beatplanassign)
            }
             return true
            }else{
                Utils.toastmsg(message:"select beat",view: self.view)
                return false
                
            }
        }
    }
    
    func getBeatDatafor(territory:Territory)->[BeatPlan]{
        let territoryID = NSNumber.init(value: territory.iD)
        print(territoryID)
        if(territory.territoryCode.count > 0){
            isBeatsFiltered = true
            beatForSelectedBeatPlan = [BeatPlan]()
//            for beatplan in arrOfBeatPlan{
//
//                if let territoryidinbeatplan = beatplan.BeatPlanID{
//                    let intterritoryidinbeatplan = Int(beatplan.territoryID)
//                print("beat plan id = \(intterritoryidinbeatplan) , territory id = \(territoryID.intValue)")
//                if(intterritoryidinbeatplan == territoryID.intValue){
//                    print("territory id of beat = \(intterritoryidinbeatplan), territory ID = \(territoryID.intValue)")
//
//                    beatForSelectedBeatPlan.append(beatplan)
//                }else{
//                    print("territory id of beat = \(intterritoryidinbeatplan), territory ID = \(territoryID.intValue) , beat plan id = \(intterritoryidinbeatplan)")
//
//                }
//                }
//            }
           // print("\(territory.territoryCode),\(territory.territoryId)")
          //  beatForSelectedBeatPlan = BeatPlan.filterBeatplanusingTerritoryID(tid:territoryID)
                /*arrOfBeatPlan.filter{
                NSNumber.init(value: $0.territoryID) == territoryID
              //  $0.territoryID == territory.iD
            }*/
            beatForSelectedBeatPlan = arrOfBeatPlan.filter{
                NSNumber.init(value: $0.territoryID) == territoryID

            }
           return beatForSelectedBeatPlan
        }else{
            isBeatsFiltered = false
            return arrOfBeatPlan
        }
    }
    
    func displayBeat(){
        selectedUserID = selectedUser.entity_id
        self.arrOfBeatPlan = [BeatPlan]()
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        let sd = self.dateFormatter.date(from: self.tfStartDate.text ?? "")
        let ld = self.dateFormatter.date(from: self.tfEndDate.text ?? "")
        let strstartdate = self.dateFormatter.string(from: sd ?? Date())
        let strenddate = self.dateFormatter.string(from: ld ?? Date())

       print("end date = \(strenddate)")
        print("start date = \(strstartdate)")
        if ((strenddate > strstartdate)||(strenddate == strstartdate)) {
         
        self.loadBeatID(userId: selectedUserID)
        if(self.activesetting.territoryMandatoryInBeatPlan == true){
        arrTerriotaryFromAPI = Territory.getTerritoryUsingPredicate(predicate: NSPredicate.init(format: "territoryUserId = %d", selectedUserID.intValue))
            let defaultterritory = Territory.mr_createEntity()

            defaultterritory?.iD = 0
            defaultterritory?.territoryCode = ""
            defaultterritory?.territoryName = "All Territory"
            defaultterritory?.territoryUserName = ""
            defaultterritory?.modifiedTime = ""

              territoryPicker.dataSource =  arrTerriotaryFromAPI.map({
     
                 String.init(format: "%@ | %@", $0.territoryCode,$0.territoryName)
              })
            if(!territoryPicker.dataSource.contains("All Territory")){
            territoryPicker.dataSource.insert("All Territory", at: 0)
            arrTerriotaryFromAPI.insert(defaultterritory!, at: 0)
            }
            if(territoryPicker.dataSource.count > 0 && arrTerriotaryFromAPI.count > 0){
                selectedterritoryID = arrTerriotaryFromAPI.first?.iD ?? 0
            }else{
                selectedterritoryID = 0
            }
            
            territoryPicker.reloadAllComponents()
            tblBeatPlan.reloadData()
            if(arrOfBeatPlan.count > 0 ){
                
                //  self.tblBeatPlan.isScrollEnabled = false
                
                tblBeatPlan.translatesAutoresizingMaskIntoConstraints = false
                self.heightTblBeatPlan.constant = tableViewHeight
            }
             self.getDateArray()
        }
        }else{
            self.tblBeatPlan.isHidden = true
        }
    }
    // MARK: APICalling
    func loadBeatID(userId:NSNumber)->(){
        let beatplandic = ["CompanyID":self.activeuser?.company?.iD,"UserID":selectedUserID]
        var param = Common.returndefaultparameter()
        param["getUploadBeatPlanDetailsJson"] = Common.json(from: beatplandic)
        self.apihelper.getdeletejoinvisit(param:param , strurl: ConstantURL.kWSUrlGetUploadBeatPlanDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(arr)
                if(responseType == ResponseType.arr){
                    self.arrOfTableBeatPlan = [BeatPlanAssign]()
                    let   arrofbeat = arr as? [Any] ?? [Any]()
                    self.arrOfBeatPlan = [BeatPlan]()
                for beat in arrofbeat{
                    let dicBeat = beat as? [String : Any] ?? [String:Any]()
                    let instancebeatplan = BeatPlan.init(dicBeat)
                  
                    self.arrOfBeatPlan.append(instancebeatplan)
                }
                    
                    //rejected beat plan
                    let rejectedBeatPlan = self.arrOfBeatPlan.filter{
                        $0.StatusID != 3
                    }
                    
                    //pendinf beat plan
                    let pendingBeatPlan = self.arrOfBeatPlan.filter{
                        $0.StatusID != 1
                    }
                    
                    if(rejectedBeatPlan.count > 0){
                        // var temport = self.arrOfBeatPlan
                        if(self.arrOfBeatPlan.count > 0){
                            self.arrOfBeatPlan = self.arrOfBeatPlan.filter{
                                $0.StatusID != 3
                            }
           
                        }
                       // self.arrOfBeatPlan = temport
                        }
                    
                    if(pendingBeatPlan.count > 0){
                        // var temport = self.arrOfBeatPlan
                        if(self.arrOfBeatPlan.count > 0){
                            self.arrOfBeatPlan = self.arrOfBeatPlan.filter{
                                $0.StatusID != 1
                            }
           
                        }
                       // self.arrOfBeatPlan = temport
                        }
                    }
                    if(self.arrOfBeatPlan.count > 0){
                       
                        self.dateFormatter.dateFormat = "dd-MM-yyyy"
                        let sd = self.dateFormatter.date(from: self.tfStartDate.text ?? "")
                        let ld = self.dateFormatter.date(from: self.tfEndDate.text ?? "")
                        let strstartdate = self.dateFormatter.string(from: sd ?? Date())
                        let strenddate = self.dateFormatter.string(from: ld ?? Date())
                        let startDate = self.dateFormatter.date(from: strstartdate)
                        let endDate = self.dateFormatter.date(from: strenddate)
                        let calender = Calendar.init(identifier: Calendar.Identifier.gregorian)
                        var dic = [String:Any]()
                        let daycomponents = calender.dateComponents([.day], from: startDate ?? Date(), to: endDate ?? Date())
//                        if((self.beatForSelectedBeatPlan.count > 0) && (self.isBeatsFiltered == true)){
//                            dic["selectedBeatPlan"] = self.beatForSelectedBeatPlan.first
//                        }else if((self.isBeatsFiltered == false) &&  (self.arrOfBeatPlan.count > 0 )){
//                            dic["selectedBeatPlan"] = self.arrOfBeatPlan.first
//                        }else{
                           
                            var dicForSelectedBeatPlan = [String:Any]()
                            dicForSelectedBeatPlan["BeatPlanName"] = "Select Beat ID"
                            dicForSelectedBeatPlan["BeatPlanID"] =  NSNumber.init(value:0)
                            dicForSelectedBeatPlan["selectedBeatPlan"] = dicForSelectedBeatPlan
                            dicForSelectedBeatPlan["CompanyID"] = self.activeuser?.company?.iD
                            dicForSelectedBeatPlan["AssigneeID"] = self.selectedUser.entity_id
                            dicForSelectedBeatPlan["ID"] = 0
                        dic["selectedBeatPlan"] =  BeatPlan.init(dicForSelectedBeatPlan)
                      //  }
                  //  if(self.activesetting.territoryMandatoryInBeatPlan ==  true  && self.arrTerriotaryFromAPI.count > 0){
                        if(self.arrTerriotaryFromAPI.count > 0){
                        dic["selectedTerritory"] =  self.arrTerriotaryFromAPI.first
                        }
                        dic["CreatedBy"] = self.activeuser?.userID
                        dic["AssigneeID"] = self.selectedUserID
                        dic["CompanyID"] = self.activeuser?.company?.iD
                        dic["isSelected"] =  false
//                        daycomponents
                        if(daycomponents.day ?? 0 > 0){
                            for day in 0...daycomponents.day! - 1{
                            var newcomponents = DateComponents()
                            newcomponents.day = day
                            let date = calender.date(byAdding: newcomponents, to: startDate!)
                            dic["BeatPlanDate"] =  self.dateFormatter.string(from: date!)
                                var beatplanassignobj =  BeatPlanAssign.init(dic)
                                self.dateFormatter.dateFormat = String.init(format:"yyyy'\'/MM'\'/dd' hh:mm:ss")
                                beatplanassignobj.BeatPlanDate =  self.dateFormatter.string(from: date!)
                                if(self.arrTerriotaryFromAPI.count > 0){
                                    dic["selectedTerritory"] = self.arrTerriotaryFromAPI.first
                                             }
                                self.arrOfTableBeatPlan.append(beatplanassignobj)
                                
                            //let obj =
                            }
                           
                           
                        }
                        self.dateFormatter.dateFormat = "dd-MM-yyyy"
                        let lld = self.dateFormatter.date(from: self.tfEndDate.text ?? "")
                        //"yyyy\/MM\/dd hh:mm:ss"
                        self.dateFormatter.dateFormat = String.init(format:"yyyy'\'/MM'\'/dd' hh:mm:ss")
                        dic["BeatPlanDate"] = self.dateFormatter.string(from:lld ?? Date())
                        let obj = BeatPlanAssign.init(dic)
                        if(self.arrTerriotaryFromAPI.count > 0){
                            dic["selectedTerritory"] = self.arrTerriotaryFromAPI.first
                        }
                        self.arrOfTableBeatPlan.append(obj)
                       
                       
                        if(self.arrOfBeatPlan.count > 0 ){
                          
                           // self.heightTblBeatPlan.constant = self.tableViewHeight
                            self.tblBeatPlan.translatesAutoresizingMaskIntoConstraints = false
                            self.tblBeatPlan.isScrollEnabled = false
                            
                        }else{
                            Utils.toastmsg(message:"You have not BeatIds",view: self.view)
                        }
                      //  print(self.heightTblBeatPlan.constant)
                        self.isBeatsFiltered  = false
                        
                        self.beatIDPicker.dataSource = self.arrOfBeatPlan.map{
                            String.init(format:"%@ | %@", $0.BeatPlanID , $0.BeatPlanName)
                        }
                        if(self.beatIDPicker.dataSource.count > 0){
                            self.selectedBeatID =  self.arrOfBeatPlan.first?.ID ?? 0
                        }else{
                            self.selectedBeatID = 0
                        }
                        self.tblBeatPlan.reloadData()
                    }else{
                        Utils.toastmsg(message:"You have not BeatIds",view: self.view)
                        self.tblBeatPlan.reloadData()
                    }
                    
                
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
            Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view: self.view)
            }
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
    
    // MARK: IBAction
    

    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        arrOfSelectedTableBeatPlan =  arrOfTableBeatPlan.filter{
            $0.isSelected == true
        }
        
       
    if(self.setValidation() == true){
    SVProgressHUD.show(withStatus: "Assigning Beat")
    var param = Common.returndefaultparameter()
    param["assignBeatJson"] = Common.json(from: arrOfdicBeatPaln)
    param["AssigneeID"] = selectedUserID
    print("parameter of assign beat plan = \(param)")
    self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlEditBeatPlanList, method: .post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
    SVProgressHUD.dismiss()
    if(status.lowercased() == Constant.SucessResponseFromServer){
        let dicVisit = arr as? [String:Any] ?? [String:Any]()
//        MagicalRecord.save({ (localContext) in
//        let arrvisit = FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
//            print(arrvisit)
//
//        }, completion: { (contextdidsave, error) in
//            print("\(contextdidsave) , error = \(error)")
//            print(PlannVisit.getAll().first?.customerName)
//        })
    NotificationCenter.default.post(name: Notification.Name("updateBeatPlanCall"), object:["userId":self.selectedUserID, "selectedMonth":self.strselectedmonth,"selectedYear":self.strselectedyear])
    self.navigationController?.popViewController(animated: true)
                }else if(error.code == 0){
                   if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                }else{
               Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view: self.view)
                }
                
            }
        }
    }
    
    @objc func btnDateTapped(_ sender:UIButton){
        print(sender.isSelected)
        let isSelected = !sender.isSelected
        sender.isSelected = isSelected
        selectedRecord = sender.tag
        let indexpath = IndexPath.init(row: sender.tag, section: 0)
        cell = tblBeatPlan.cellForRow(at: indexpath) as? BeatPlanAssignCell
        var beatassignplan = arrOfTableBeatPlan[indexpath.row]
        arrOfTableBeatPlan.remove(at: selectedRecord)
        beatassignplan.isSelected = sender.isSelected
        print(sender.isSelected)
        
//        if((self.beatForSelectedBeatPlan.count > 0) && (isBeatsFiltered == true)){
//            beatassignplan.selectedBeatPlan = self.beatForSelectedBeatPlan.first
//        }else if((isBeatsFiltered == false) &&  (arrOfBeatPlan.count > 0 )){
//
//             beatassignplan.selectedBeatPlan = self.arrOfBeatPlan.first
//        }
        //else{
//            var dicForSelectedBeatPlan = [String:Any]()
//        dicForSelectedBeatPlan["BeatPlanName"] = "Select Beat ID"
//        dicForSelectedBeatPlan["BeatPlanID"] =  NSNumber.init(value:0)
//        
//        beatassignplan.selectedBeatPlan = BeatPlan.init(dicForSelectedBeatPlan)//dicForSelectedBeatPlan
      //  }
  //  if(self.activesetting.territoryInCustomer == true){
        if(arrTerriotaryFromAPI.count > 0){
    beatassignplan.selectedTerritory =  arrTerriotaryFromAPI.first
        }
    //    }
        arrOfTableBeatPlan.insert(beatassignplan, at: selectedRecord)
        if(cell.btnDate.isSelected == true){
            cell.btnDate.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
        }else{
             cell.btnDate.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
        }
      
        
    }
    @objc func btnBeatTapped(_ sender:UIButton){
        selectedRecord = sender.tag
        
        let selectedbeat = arrOfTableBeatPlan[selectedRecord]
        var territory:Territory?
        if let selectedterritory = selectedbeat.selectedTerritory as? Territory{
         territory = selectedbeat.selectedTerritory
        }else {
            if(arrTerriotaryFromAPI.count > 0){
                territory = arrTerriotaryFromAPI.first
            }
        }
//
       popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        popup?.modalPresentationStyle = .overCurrentContext
        popup?.mandatorydelegate = self
        popup?.isFromSalesOrder =  false
        popup?.strTitle = ""
        popup?.isSearchBarRequire = true
        popup?.viewfor = ViewFor.beatplan
        popup?.arrOfBeatPlan = self.getBeatDatafor(territory: territory ?? Territory())
        popup?.strLeftTitle = ""
        popup?.strRightTitle = ""
        popup?.selectionmode = SelectionMode.none
        popup?.arrOfSelectedBeatPlan = [BeatPlan]()
        popup?.isFilterRequire = false
        popup?.isSearchBarRequire = true
        // popup?.showAnimate()
        popup?.parentViewOfPopup = self.view
        Utils.addShadow(view: self.view)
        self.present(popup!, animated: false, completion: nil)
        
    }
    @objc func btnTerritoryTapped(_ sender:UIButton){
        print("btn selected = \(sender.isSelected)")
        selectedRecord = sender.tag
        let isSelected = !sender.isSelected
        sender.isSelected = isSelected
        print("btn selected = \(sender.isSelected) after change ")
        if(sender.isSelected == true){
        territoryPicker.anchorView = sender
        let cell = tblBeatPlan.cellForRow(at: IndexPath.init(item: selectedRecord, section: 0)) as? BeatPlanAssignCell
        territoryPicker.selectionAction = {(index,item) in
            var beatplan = self.arrOfTableBeatPlan[self.selectedRecord]
            self.arrOfTableBeatPlan.remove(at: self.selectedRecord)
            let selectedterritory = self.arrTerriotaryFromAPI[index]
            beatplan.selectedTerritory = selectedterritory
            self.selectedterritoryID =  selectedterritory.iD
            cell?.btnSelectTerritory.setTitle(item, for: .selected)
            
            let selectedbeat = beatplan.selectedBeatPlan
            if(selectedbeat?.BeatPlanID.count ?? 0 > 0){
                cell?.btnBeatplanDetail.isHidden = false
            }else{
                cell?.btnBeatplanDetail.isHidden = true
            }
            let selectedTerritory = self.arrTerriotaryFromAPI[index]
            let sourceOfbeatTitle = self.getBeatDatafor(territory: selectedTerritory)
            self.beatIDPicker.dataSource = sourceOfbeatTitle.map{
                String.init(format:"%@ | %@", $0.BeatPlanID , $0.BeatPlanName)
            }
            if(sourceOfbeatTitle.count > 0){
               
         
            var dicForSelectedBeatPlan = [String:Any]()
            dicForSelectedBeatPlan["BeatPlanName"] = "Select Beat ID"
            dicForSelectedBeatPlan["BeatPlanID"] =  NSNumber.init(value:0)
            
//            beatassignplan.selectedBeatPlan = BeatPlan.init(dicForSelectedBeatPlan)
                let firstbeat = BeatPlan.init(dicForSelectedBeatPlan)//sourceOfbeatTitle.first
                beatplan.selectedBeatPlan = firstbeat
                var beatDetail = ""
               
                if(firstbeat.BeatPlanID.count > 0){
                    beatDetail.append(String.init(format:"%@ |",firstbeat.BeatPlanID ?? ""))
                    beatDetail.append(String.init(format:"%@",firstbeat.BeatPlanName ?? "Select Beat ID"))
                    cell?.btnBeatplanDetail.isHidden = false
                }else{
                   // print("beat plan name = \(firstbeat.BeatPlanName ?? "no value")")
                    beatDetail.append(String.init(format:"%@",firstbeat.BeatPlanName ?? "Select Beat ID"))
                    cell?.btnBeatplanDetail.isHidden = true
                }
                cell?.btnSelectBeat.setTitle(beatDetail, for: .normal)
            }else{
                cell?.btnBeatplanDetail.isHidden = true
                cell?.btnSelectBeat.setTitle("", for: .normal)
            }
            self.arrOfTableBeatPlan.insert(beatplan, at: self.selectedRecord)
        }
        territoryPicker.show()
        
    }
        else{

        }
    }
   @objc func btnBeatplanDetailTapped(_ sender:UIButton){
    print(sender.isSelected)
    selectedRecord = sender.tag
    let isSelected = !sender.isSelected
    sender.isSelected = isSelected
    let selectedbeatplan = arrOfTableBeatPlan[selectedRecord]
    cell = tblBeatPlan.cellForRow(at: IndexPath.init(row: selectedRecord, section: 0)) as? BeatPlanAssignCell
    if(arrOfBeatPlan.count > 0){
       if let beatplandetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanDetailView) as? BeatPlanDetail{
        Common.skipVisitSelection = false
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: selectedbeatplan.BeatPlanDate)
        beatplandetail.selectedDate = dateFormatter.string(from: date ?? Date()) //cell.btnDate.currentTitle
        beatplandetail.strbeatplanname = selectedbeatplan.selectedBeatPlan?.BeatPlanName
        beatplandetail.strbeatplanID = selectedbeatplan.selectedBeatPlan?.BeatPlanID
    self.navigationController?.pushViewController(beatplandetail, animated: true)
        }
    }
    }
}
extension AssignBeatPlan:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfStartDate){
            startDatedatepicker.date = startDate
            
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            startDatedatepicker.datePickerMode = .date
            startDatedatepicker.date = self.dateFormatter.date(from: tfStartDate.text!)!
            return true
           
        }else if(textField == tfEndDate){
            endDatePicker.date = endDate
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            endDatePicker.datePickerMode = .date
            endDatePicker.date = self.dateFormatter.date(from: tfEndDate.text!)!
           
             return true
        }else{
            if(self.activeuser?.role?.id == 8){
                tfSelectUser.text = String.init(format: "%@ %@", arguments: [self.activeuser?.firstName ?? "    ",self.activeuser?.lastName ?? ""])
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
                 
                    Utils.toastmsg(message:"No Executive reporting to you",view: self.view)
                }else{
                  
                    let sortedUserarr = self.arrOfUserExceptExecutive.sorted { (user1, user2) -> Bool in
                        user1.firstName < user2.firstName
                    }
                    self.arrOfUserExceptExecutive = sortedUserarr
                    self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                    self.popup?.modalPresentationStyle = .overCurrentContext
                    self.popup?.isFromSalesOrder =  false
                    self.popup?.strTitle = "Select Sales Person"
                    self.popup?.nonmandatorydelegate = self
                    self.popup?.arrOfExecutive = self.arrOfUserExceptExecutive
                    self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [self.arrOfUserExceptExecutive[0]]
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
           // }
            return false
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.dateFormatter.dateFormat = "dd-MM-YYYY"
        if(textField == tfStartDate){
            startDatedatepicker.date =  dateFormatter.date(from: tfStartDate.text ?? "28-01-2023") ?? Date.yesterday
            //datepicker.reloadInputViews()
        }else if(textField == tfEndDate){
            endDatePicker.date = dateFormatter.date(from: tfEndDate.text ?? "") ?? Date()
           // datepicker.reloadInputViews()
        }
}
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfStartDate){
            dateFormatter.dateFormat = "dd-MM-yyyy"
            startDate = startDatedatepicker.date
            tfStartDate.text = dateFormatter.string(from: startDatedatepicker.date)
            self.getDateArray()
        }else if(textField == tfEndDate){
//
                tfSelectUser.isUserInteractionEnabled = true
                dateFormatter.dateFormat = "dd-MM-yyyy"
                endDate = endDatePicker.date
                tfEndDate.text =  dateFormatter.string(from: endDatePicker.date)
                self.getDateArray()
//            
        }
    }

}
extension AssignBeatPlan:PopUpDelegateNonMandatory{
    
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        arrOfSelectedExecutive =  arr
        selectedUser = arrOfSelectedExecutive.first
        tfSelectUser.text = String.init(format: "%@ %@", selectedUser.firstName,selectedUser.lastName)
        print(Utils.getNSDateWithAppendingDay(day: 0, date1: endDatePicker.date, format: "yyyy/MM/dd"))
        print(Utils.getNSDateWithAppendingDay(day: 0, date1: startDatedatepicker.date, format: "yyyy/MM/dd"))
      //  if(!(Utils.getNSDateWithAppendingDay(day: 0, date1: endDatePicker.date, format: "yyyy/MM/dd").compare(Utils.getNSDateWithAppendingDay(day: 0, date1: startDatedatepicker.date, format: "yyyy/MM/dd")) == .orderedAscending)){
//        let order = (Utils.getNSDateWithAppendingDay(day: 0, date1: endDatePicker.date, format: "yyyy/MM/dd")).compare(Utils.getNSDateWithAppendingDay(day: 0, date1: startDatedatepicker.date, format: "yyyy/MM/dd"))
//        print(order)
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        var startdate = Date()
        var enddate = Date()
        if let strStartDate = tfStartDate.text{
            startdate = self.dateFormatter.date(from: strStartDate) ?? Date()
        }
        if let strEndDate = tfEndDate.text {
             enddate = self.dateFormatter.date(from: strEndDate) ?? Date()
        }
        
        
        if(!(enddate.compare(startdate)  == .orderedAscending)){
        if(arrOfBeatPlan.count > 0){
            for i in 0...arrOfTableBeatPlan.count - 1 {
                var mutbeat = arrOfTableBeatPlan[i]
                mutbeat.isSelected = false
                arrOfTableBeatPlan.remove(at: i)
                arrOfTableBeatPlan.insert(mutbeat, at: i)
            }
        }
            self.displayBeat()
        }else{
            Utils.toastmsg(message:"Please select valid date",view: self.view)
        }
       
        self.tblBeatPlan.reloadData()
    }
    
   
    
    
}
extension AssignBeatPlan:PopUpDelegateMandatory{
    func completionSelectedDocument(arr: [Document]) {
        
    }
    
    
    func completionSelectedBeatPlan(arr:[BeatPlan]){
        Utils.removeShadow(view: self.view)
        selectedBeatID =  Int(arr.first?.BeatPlanID ?? "") ?? 0
        print(selectedRecord)
        var beatDetail = ""
        cell = tblBeatPlan.cellForRow(at: IndexPath.init(item: selectedRecord, section: 0)) as? BeatPlanAssignCell
        if  let firstbeat = arr.first{
        
        if(firstbeat.BeatPlanID.count > 0){
            beatDetail.append(String.init(format:"%@ | ",firstbeat.BeatPlanID ?? ""))
            beatDetail.append(String.init(format:"%@",firstbeat.BeatPlanName ?? "Select Beat ID"))
        
        }else{
           
            beatDetail.append(String.init(format:"%@",firstbeat.BeatPlanName ?? "Select Beat ID"))
        }
        
        }
       // arrOfBeatPlan =
//        print(selectedbeat.BeatPlanDate)
        cell.btnSelectBeat.setTitle(beatDetail, for: .normal)
        var beat = arrOfTableBeatPlan[selectedRecord]
        arrOfTableBeatPlan.remove(at: selectedRecord)
        beat.selectedBeatPlan = BeatPlan.init([String : Any]())
        if(arrOfBeatPlan.count > 0){
            cell.btnBeatplanDetail.isHidden = false
            let selectedbeat = arr.first


            beat.selectedBeatPlan = selectedbeat
            print("selected beat = \(beat.selectedBeatPlan?.BeatPlanID)")
           
        }else{
             cell.btnBeatplanDetail.isHidden = true
        }
        
         arrOfTableBeatPlan.insert(beat, at: selectedRecord)
//        tblBeatPlan.layoutIfNeeded()
//        tblBeatPlan.reloadRows(at: [IndexPath.init(item: selectedRecord, section: 0)], with: .none)
    }
}
extension AssignBeatPlan:BaseViewControllerDelegate{
  
    func datepickerSelectionDone() {
          self.view.endEditing(true)
    }
    
    func cancelbtnTapped() {
        tfEndDate.resignFirstResponder()
        tfStartDate.resignFirstResponder()
    }
}
extension AssignBeatPlan:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrOfBeatPlan.count > 0) ? arrOfTableBeatPlan.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell =  tableView.dequeueReusableCell(withIdentifier: Constant.BeatplanAssignCell, for: indexPath) as? BeatPlanAssignCell
        cell.btnBeatplanDetail.isHidden = true
        let beat = arrOfTableBeatPlan[indexPath.row]
        cell.btnDate.tag = indexPath.row
        cell.btnBeatplanDetail.tag = indexPath.row
        cell.btnSelectTerritory.tag = indexPath.row
        cell.btnSelectBeat.tag = indexPath.row
        cell.btnSelectTerritory.tintColor = UIColor.clear
        cell.btnSelectBeat.tintColor = UIColor.clear
        cell.btnBeatplanDetail.tintColor = UIColor.clear
        cell.btnSelectBeat.contentHorizontalAlignment = .left
        cell.btnSelectTerritory.contentHorizontalAlignment = .left
        cell.btnSelectBeat.setrightImage()
        cell.btnSelectTerritory.setrightImage()
        self.dateFormatter.dateFormat =  "yyyy'\'/MM'\'/dd' hh:mm:ss"
        let d = self.dateFormatter.date(from: beat.BeatPlanDate)
        
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        cell.btnDate.setTitle(self.dateFormatter.string(from: d ?? Date()), for: .normal)
        
        cell.btnDate.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
        cell.btnDate.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
        if(beat.isSelected){
            cell.btnDate.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
            cell.btnDate.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
        }else{
            cell.btnDate.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
            cell.btnDate.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
        }
        cell.btnSelectTerritory.setTitleColor(UIColor.black, for: .selected)
//        cell.btnDate.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 25, bottom: 0, right: 0)
//        cell.btnDate.titleLabel?.textAlignment = .left
//        cell.btnDate.contentHorizontalAlignment = .left
        
       
       // scanBarCodeButton.frame = CGRectMake(center, 10.0, fieldWidth, 40.0)
//        scanBarCodeButton.setImage(UIImage(named: "BarCodeIcon.png"), for: UIControlStateNormal)
//        scanBarCodeButton.setTitle("Scan the Barcode", for: UIControlStateNormal)
       // cell.btnDate.imageRect(forContentRect: CGRect.init(x: -100, y: 0, width: 42, height: 42))
        cell.btnDate.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 42.0, bottom: 0.0, right: 0.0)
        cell.btnDate.imageEdgeInsets = UIEdgeInsets(top:0.0, left: -82, bottom: 0.0, right: 0.0)
        cell.btnDate.contentHorizontalAlignment = .left
        if(self.activesetting.territoryMandatoryInBeatPlan == true){
            cell.lblTerritoryTitle.isHidden = false
            cell.btnSelectTerritory.isHidden = false
            var territoryTitle = ""
            if(arrTerriotaryFromAPI[0].territoryCode.count > 0){
                territoryTitle.append(String.init(format: "%@ | ",arrTerriotaryFromAPI[0].territoryCode))
            }else{
                territoryTitle.append(String.init(format: " %@",arrTerriotaryFromAPI[0].territoryName))
            }
            cell.btnSelectTerritory.setTitle(territoryTitle,for: .normal)
           
            territoryPicker.bottomOffset = CGPoint.init(x: 0, y: 0)
           
        }else{
            cell.lblTerritoryTitle.isHidden = true
            cell.btnSelectTerritory.isHidden = true
        }
        
        cell.btnDate.addTarget(self, action: #selector(btnDateTapped), for: .touchUpInside)
        cell.btnSelectBeat.addTarget(self, action: #selector(btnBeatTapped), for: .touchUpInside)
        cell.btnSelectTerritory.addTarget(self, action: #selector(btnTerritoryTapped), for: .touchUpInside)
        cell.btnBeatplanDetail.addTarget(self, action: #selector(btnBeatplanDetailTapped), for: .touchUpInside)
        var beatDetail = ""
        if(beat.selectedBeatPlan?.BeatPlanID.count ?? 0 > 0){
            beatDetail.append(String.init(format:"%@ | ",beat.selectedBeatPlan?.BeatPlanID ?? ""))
            beatDetail.append(String.init(format:"%@",beat.selectedBeatPlan?.BeatPlanName ?? "Select Beat ID"))
        }else{
         
            beatDetail.append(String.init(format:"%@",beat.selectedBeatPlan?.BeatPlanName ?? "Select Beat ID"))
        }
        cell.btnSelectBeat.setTitle( beatDetail, for: .normal)
//        let sourceofbeat = self.getBeatDatafor(territory: beat.selectedTerritory)BeatPlanName
      
      //  cell.btnSelectBeat.setTitle(String.init(format:"%@ | %@",beat.selectedBeatPlan?.BeatPlanID ?? "" ,beat.selectedBeatPlan?.BeatPlanName ?? "bname"), for: .normal)
        if(beat.selectedBeatPlan?.BeatPlanID.count ?? 0 > 0){
            cell.btnBeatplanDetail.isHidden = false
        }
        else{
            cell.btnBeatplanDetail.isHidden = true
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
