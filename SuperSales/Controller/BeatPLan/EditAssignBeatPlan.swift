//
//  EditAssignBeatPlan.swift
//  SuperSales
//
//  Created by Apple on 09/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD


class EditAssignBeatPlan: BaseViewController {
     // swiftlint:disable line_length
    var selectedRecord:Int = 0
    var strSelectedMonth:String!
    var strSelectedYear:String!
    var strSelectedUser:String!
    var selectedTimeText:String!
     var cell:BeatPlanAssignCell!
     var selectedUserID:NSNumber!
    var arrOfdicBeatPaln:[[String:Any]] = [[String:Any]]()
    var popup:CustomerSelection? = nil
    @IBOutlet weak var tblEditAssignBeatPlan: UITableView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblUserMonth: UILabel!
    var arreditAssignData:[BeatPlan]! = [BeatPlan]()
    var datepicker:UIDatePicker!
     var selectedBeatID = 0
    var arrOfBeatPlan:[BeatPlan]! = [BeatPlan]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    // MARK: API Calling
    func loadBeatID(userId:NSNumber)->(){
        let beatplandic = ["CompanyID":self.activeuser?.company?.iD,"UserID":selectedUserID]
        var param = Common.returndefaultparameter()
        param["getUploadBeatPlanDetailsJson"] = Common.json(from: beatplandic)
        self.apihelper.getdeletejoinvisit(param:param , strurl: ConstantURL.kWSUrlGetUploadBeatPlanDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(arr)
                if(responseType == ResponseType.arr){
                    
                   
                    self.arrOfBeatPlan.removeAll()
                    if let   arrofbeat = arr as? [Any]{
                    for beat in arrofbeat{
                        let instancebeatplan = BeatPlan.init(beat as? [String : Any] ?? [String:Any]())
                        self.arrOfBeatPlan.append(instancebeatplan)
                    }
//                        let rejectedBeatPlan = self.arrOfBeatPlan.filter{
//                           $0.StatusID != 2
//                        }
//                        self.arrOfBeatPlan = self.arrOfBeatPlan.filter{
//                            $0.StatusID != 2
//                        }
                        
//                        if(rejectedBeatPlan.count > 0){
//                          //  let closeandreassignmenu = [50,51,503,42,49,41]
//                            //                            menu = menu.filter{
//                            //                                !closeandreassignmenu.contains($0)
//                            //                            }
//
//                            self.arrOfBeatPlan = self.arrOfBeatPlan.filter{
//                                !rejectedBeatPlan.contains($0)
//                            }
//
////                            self.arrOfBeatPlan = self.arrOfBeatPlan.filter({ (<#BeatPlan#>) -> Bool in
////                                <#code#>
////                            })
////                            for rbeat in 0...rejectedBeatPlan.count-1{
////                            for beat in 0...self.arrOfBeatPlan.count-1{
//
////                                let rejectedbeat =  zip(self.arrOfBeatPlan, rejectedBeatPlan).enumerated().filter() {
////                                    $0.BeatPlanID == $1.BeatPlanID
////                                }
//                                //let closeandreassignmenu = [50,51,503,42,49,41]
//                                //                            menu = menu.filter{
//                                //                                !closeandreassignmenu.contains($0)
//                                //                            }
//
//
//
////                                self.arrOfBeatPlan = self.arrOfBeatPlan.filter{
////                                    !rejectedBeatPlan.contains($0)
////                                }
//
//
//

////                                    if(self.arrOfBeatPlan[beat].BeatPlanID == rejectedBeatPlan[rbeat].BeatPlanID){
////                                        self.arrOfBeatPlan.remove(at: beat)
////                                    }
////                                }
////                            }
////                        }
//                    }
                    
//                    if(self.arrOfBeatPlan.count > 0){
//                        self.dateFormatter.dateFormat = "dd-MM-yyyy"
//                        let sd = self.dateFormatter.date(from: self.tfStartDate.text ?? "")
//                        let ld = self.dateFormatter.date(from: self.tfEndDate.text ?? "")
//                        let strstartdate = self.dateFormatter.string(from: sd ?? Date())
//                        let strenddate = self.dateFormatter.string(from: ld ?? Date())
//                        let startDate = self.dateFormatter.date(from: strstartdate)
//                        let endDate = self.dateFormatter.date(from: strenddate)
//                        let calender = Calendar.init(identifier: Calendar.Identifier.gregorian)
//                        var dic = [String:Any]()
//                        let daycomponents = calender.dateComponents([.day], from: startDate ?? Date(), to: endDate ?? Date())
//                        if((self.beatForSelectedBeatPlan.count > 0) && (self.isBeatsFiltered == true)){
//                            dic["selectedBeatPlan"] = self.beatForSelectedBeatPlan.first
//                        }else if((self.isBeatsFiltered == false) &&  (self.arrOfBeatPlan.count > 0 )){
//                            dic["selectedBeatPlan"] = self.arrOfBeatPlan.first
//                        }else{
//
//                            var dicForSelectedBeatPlan = [String:Any]()
//                            dicForSelectedBeatPlan["BeatPlanName"] = ""
//                            dicForSelectedBeatPlan["BeatPlanID"] =  NSNumber.init(value:0)
//                            dicForSelectedBeatPlan["selectedBeatPlan"] = dicForSelectedBeatPlan
//                            dicForSelectedBeatPlan["CompanyID"] = self.activeuser.company?.iD
//                            dicForSelectedBeatPlan["AssigneeID"] = self.selectedUser.entity_id
//                            dicForSelectedBeatPlan["ID"] = 0
//                        }
//                        if(self.activesetting.territoryMandatoryInBeatPlan ==  true  && self.arrTerriotaryFromAPI.count > 0){
//                            dic["selectedTerritory"] =  self.arrTerriotaryFromAPI.first
//                        }
//                        dic["CreatedBy"] = self.activeuser.userID
//                        dic["AssigneeID"] = self.selectedUserID
//                        dic["CompanyID"] = self.activeuser.company?.iD
//                        dic["isSelected"] =  false
//                        //                        daycomponents
//                        if(daycomponents.day ?? 0 > 0){
//                            for i in 0...daycomponents.day! - 1{
//                                var newcomponents = DateComponents()
//                                newcomponents.day = i
//                                let date = calender.date(byAdding: newcomponents, to: startDate!)
//                                dic["BeatPlanDate"] =  self.dateFormatter.string(from: date!)
//                                var beatplanassignobj =  BeatPlanAssign.init(dic)
//                                self.dateFormatter.dateFormat = String.init(format:"yyyy'\'/MM'\'/dd' hh:mm:ss")
//                                beatplanassignobj.BeatPlanDate =  self.dateFormatter.string(from: date!)
//                                self.arrOfTableBeatPlan.append(beatplanassignobj)
//
//                                //let obj =
//                            }
//
//
//                        }
//                        self.dateFormatter.dateFormat = "dd-MM-yyyy"
//                        let lld = self.dateFormatter.date(from: self.tfEndDate.text ?? "")
//                        //"yyyy\/MM\/dd hh:mm:ss"
//                        self.dateFormatter.dateFormat = String.init(format:"yyyy'\'/MM'\'/dd' hh:mm:ss")
//                        dic["BeatPlanDate"] = self.dateFormatter.string(from:lld ?? Date())
//                        let obj = BeatPlanAssign.init(dic)
//                        self.arrOfTableBeatPlan.append(obj)
//
//                        self.tblBeatPlan.reloadData()
//                        if(self.arrOfBeatPlan.count > 0 ){
//
//                            // self.heightTblBeatPlan.constant = self.tableViewHeight
//                            self.tblBeatPlan.translatesAutoresizingMaskIntoConstraints = false
//                            self.tblBeatPlan.isScrollEnabled = false
//
//                        }else{
//                            Utils.toastmsg(message:"You have not BeatIds")
//                        }
//                        //  print(self.heightTblBeatPlan.constant)
//                        self.isBeatsFiltered  = false
//
//                        self.beatIDPicker.dataSource = self.arrOfBeatPlan.map{
//                            String.init(format:"%@ | %@", $0.BeatPlanID , $0.BeatPlanName)
//                        }
//                        if(self.beatIDPicker.dataSource.count > 0){
//                            self.selectedBeatID =  self.arrOfBeatPlan.first?.ID ?? 0
//                        }else{
//                            self.selectedBeatID = 0
//                        }
//                    }else{
//                        Utils.toastmsg(message:"You have not BeatIds")
//                        self.tblBeatPlan.reloadData()
//                    }
                    
                }
                }
            }else if(error.code == 0){
                   
                        if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                    }else{
             
           Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                    }
            
    }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadBeatID(userId: selectedUserID)
    }
    // MARK: Method
    func setUI(){
        self.lblUserName.text = strSelectedUser
        
        btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        self.lblUserMonth.text = selectedTimeText
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        arreditAssignData = BeatPlanList.globalLimitBeatArr
        self.title = "Edit Assign Beat"
        self.salesPlandelegateObject = self
        tblEditAssignBeatPlan.separatorColor =  UIColor.clear
        tblEditAssignBeatPlan.delegate = self
        tblEditAssignBeatPlan.dataSource = self
        datepicker = UIDatePicker.init()
        datepicker.setCommonFeature()
        datepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 215, width: view.frame.size.width, height: 200))
    }
    
    // MARK: IBAction
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        for beatplanassign in 0...arreditAssignData.count-1{
            let beatplan = arreditAssignData[beatplanassign]
         
            var bp = [String:Any]()
            print(beatplan.BeatPlanDate)
            self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//            self.dateFormatter.locale =  NSLocale.init(localeIdentifier: "UTC") as Locale
//            self.dateFormatter.timeZone =  NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
            let dt = self.dateFormatter.date(from: beatplan.BeatPlanDate)
            
            self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let strDate  = self.dateFormatter.string(from: dt!)
            bp["AssigneeID"] = beatplan.AssigneeID
            bp["BeatPlanDate"] = strDate
            bp["territoryId"] = beatplan.territoryID
            bp["CompanyID"] = beatplan.CompanyID
            bp["BeatPlanID"] = beatplan.BeatPlanID
            bp["CreatedBy"] = beatplan.CreatedBy
            bp["ID"] = beatplan.ID
         
            arrOfdicBeatPaln.insert(bp, at: beatplanassign)
        }
        var param = Common.returndefaultparameter()
        param["AssigneeID"] = self.activeuser?.userID
        param["assignBeatJson"] = Common.json(from: arrOfdicBeatPaln)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlEditBeatPlanList, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                  NotificationCenter.default.post(name: Notification.Name("updateBeatPlanCall"), object:["userId":self.selectedUserID, "selectedMonth":self.strSelectedMonth,"selectedYear":self.strSelectedYear])
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.navigationController?.popViewController(animated: true)
                }
            }else{
                
            }
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        }
    }
    
    @objc func btnDateTapped(_ sender:UIButton){
        
        let isSelected = !sender.isSelected
        sender.isSelected = isSelected
        selectedRecord = sender.tag
        print(selectedRecord)
        let indexpath = IndexPath.init(row: sender.tag, section: 0)
        cell = tblEditAssignBeatPlan.cellForRow(at: indexpath) as? BeatPlanAssignCell
        let dt =  self.dateFormatter.date(from: cell.btnSelectTerritory.currentTitle ?? "")
       datepicker.date = dt ?? Date()
        
       self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker: datepicker, textfield: nil, withDateMonth: false)
        
    }
    
    @objc func btnterritoryTapped(_ sender:UIButton){
        selectedRecord = sender.tag
        
       // let selectedbeat = arreditAssignData[selectedRecord]
     //   let territory = selectedbeat.selectedTerritory
        
       popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        popup?.modalPresentationStyle = .overCurrentContext
        popup?.isFromSalesOrder =  false
        popup?.mandatorydelegate = self
        popup?.strTitle = ""
        popup?.isSearchBarRequire = true
        popup?.viewfor = ViewFor.beatplan
        popup?.arrOfBeatPlan = arrOfBeatPlan
            /*arrOfBeatPlan.map{
             String.init(format:"%@ | %@", $0.BeatPlanID , $0.BeatPlanName)
        }*/
            //self.getBeatDatafor(territory: territory ?? Territory())
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
    
    @objc func btndeleteTapped(_ sender:UIButton){
        selectedRecord = sender.tag
        let alert:UIAlertController = UIAlertController.init(title: "SuperSales", message: "Are you sure you want to delete this assign beat plan record?", preferredStyle: UIAlertController.Style.alert)
        let noAction:UIAlertAction = UIAlertAction.init(title: "NO", style: UIAlertAction.Style.default, handler: nil)
        let yesAction:UIAlertAction = UIAlertAction.init(title: "YES", style: UIAlertAction.Style.destructive) { (yesAction) in
            

            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var param =  Common.returndefaultparameter()
            let selectedBeat = self.arreditAssignData[self.selectedRecord]
            let param1 = [["ID":selectedBeat.ID,"TransactionID":selectedBeat.TransactionID]] as [[String : Any]]
            param["deleteBeatPlanJson"] = Common.json(from: param1)
            param["AssigneeID"] = self.activeuser?.userID
            print("parameter of delete beat plan \(param)")
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlDeleteBeatPlan, method: Apicallmethod.post, compeletion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                 if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    NotificationCenter.default.post(name: Notification.Name("updateBeatPlanCall"), object:["userId":self.selectedUserID, "selectedMonth":self.strSelectedMonth,"selectedYear":self.strSelectedYear])
                   self.navigationController?.popViewController(animated: true)
                }else if(error.code == 0){
                      
                            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                        }else{
                
               Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                        }
               
            })
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    @objc func btnBeatplanDetailTapped(_ sender:UIButton){
        print(sender.isSelected)
        selectedRecord = sender.tag
        let isSelected = !sender.isSelected
        sender.isSelected = isSelected
        let selectedbeatplan = arreditAssignData[selectedRecord]
     
        if(arrOfBeatPlan.count > 0){
            if   let beatplandetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanDetailView) as? BeatPlanDetail{
         if  let  cell = tblEditAssignBeatPlan.cellForRow(at: IndexPath.init(row: selectedRecord, section: 0)) as? BeatPlanAssignCell{
            beatplandetail.selectedDate = cell.btnDate.currentTitle
        }
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let date = dateFormatter.date(from: selectedbeatplan.BeatPlanDate)
                beatplandetail.selectedDate = dateFormatter.string(from: date ?? Date())
            beatplandetail.strbeatplanname = selectedbeatplan.BeatPlanName
            beatplandetail.strbeatplanID = selectedbeatplan.BeatPlanID
            self.navigationController?.pushViewController(beatplandetail, animated: true)
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

}
extension EditAssignBeatPlan:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arreditAssignData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        cell =  tableView.dequeueReusableCell(withIdentifier: Constant.BeatplanAssignCell, for: indexPath) as?BeatPlanAssignCell
        cell.btnDate.setImage(UIImage.init(named: "icon_delete"), for: .normal)
     //   cell.contentView.backgroundColor = UIColor.init(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1.0)
        cell.lblTerritoryTitle.text = "Next Action Date"
        let beat = arreditAssignData[indexPath.row]
        cell.btnDate.tag = indexPath.row
        cell.btnBeatplanDetail.tag = indexPath.row
        cell.btnSelectTerritory.tag = indexPath.row
        cell.btnSelectBeat.tag = indexPath.row
        cell.btnSelectTerritory.tintColor = UIColor.clear
        cell.btnSelectBeat.tintColor = UIColor.clear
        cell.btnBeatplanDetail.tintColor = UIColor.clear
        cell.btnSelectBeat.contentHorizontalAlignment = .left
        cell.btnSelectBeat.setrightImage()
        
        self.dateFormatter.dateFormat =  "yyyy/MM/dd HH:mm:ss"
        let date = self.dateFormatter.date(from: beat.BeatPlanDate)
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
    cell.btnSelectTerritory.setTitle(self.dateFormatter.string(from: date ?? Date()), for: .normal)
         cell.btnSelectTerritory.setTitleColor(UIColor.black, for: .selected)
        
        cell.btnSelectBeat.setTitle(String.init(format:"%@ | %@",beat.BeatPlanID ,beat.BeatPlanName), for: .normal)
        cell.btnDate.addTarget(self, action: #selector(btndeleteTapped), for: .touchUpInside)
         cell.btnSelectBeat.addTarget(self, action: #selector(btnterritoryTapped), for: .touchUpInside)
        cell.btnSelectTerritory.addTarget(self, action: #selector(btnDateTapped), for: .touchUpInside)
         cell.btnBeatplanDetail.addTarget(self, action: #selector(btnBeatplanDetailTapped), for: .touchUpInside)
        
        return cell
    }
    
    
}
extension EditAssignBeatPlan:BaseViewControllerDelegate{
    func datepickerSelectionDone() {
     
      //  selectedRecord = sender.tag
    let indexpath = IndexPath.init(row: selectedRecord, section: 0)
    cell = tblEditAssignBeatPlan.cellForRow(at: indexpath) as? BeatPlanAssignCell
    let selectedbeatplan = arreditAssignData[selectedRecord]
    arreditAssignData.remove(at: selectedRecord)
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        cell.btnSelectTerritory.setTitle(self.dateFormatter.string(from: datepicker.date), for: .normal)
        cell.btnSelectTerritory.setTitle(self.dateFormatter.string(from: datepicker.date), for: .selected)
        let dt = self.dateFormatter.date(from: cell.btnSelectTerritory.currentTitle!)
         self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        selectedbeatplan.BeatPlanDate = self.dateFormatter.string(from: dt ?? Date())
   
    arreditAssignData.insert(selectedbeatplan, at: selectedRecord)
       self.view.endEditing(true)
    }
    
//    func cancelbtnTapped() {
//        tfEndDate.resignFirstResponder()
//        tfStartDate.resignFirstResponder()
//    }
    
    func cancelbtnTapped() {
        datepicker.removeFromSuperview()
    }
}

extension EditAssignBeatPlan:PopUpDelegateMandatory{

        func completionSelectedBeatPlan(arr:[BeatPlan]){
            Utils.removeShadow(view: self.view)
        selectedBeatID =  Int(arr.first?.BeatPlanID ?? "0") ?? 0
        print(selectedRecord)
        cell = tblEditAssignBeatPlan.cellForRow(at: IndexPath.init(item: selectedRecord, section: 0)) as? BeatPlanAssignCell
        
        
        
        // arrOfBeatPlan =
        //        print(selectedbeat.BeatPlanDate)
        cell.btnSelectBeat.setTitle(String.init(format:"%@ | %@",(arr.first?.BeatPlanID)!,(arr.first?.BeatPlanName)!), for: .normal)
        let beat = arreditAssignData[selectedRecord]
        arreditAssignData.remove(at: selectedRecord)
        
        if(arrOfBeatPlan.count > 0){
            cell.btnBeatplanDetail.isHidden = false
            let selectedbeat = arr.first
            
            beat.BeatPlanID = selectedbeat?.BeatPlanID
            beat.BeatPlanName = selectedbeat?.BeatPlanName
            print("beat ID = \(beat.BeatPlanID)")
            print("ID = \(selectedbeat?.BeatPlanID)")
            print("beat name  = \(beat.BeatPlanName)")
            print("Name = \(selectedbeat?.BeatPlanName)")
     
        }else{
            cell.btnBeatplanDetail.isHidden = true
        }
        arreditAssignData.insert(beat, at: selectedRecord)
        //        tblBeatPlan.layoutIfNeeded()
        //        tblBeatPlan.reloadRows(at: [IndexPath.init(item: selectedRecord, section: 0)], with: .none)
    }
    
    func completionSelectedDocument(arr: [Document]) {
        
    }
}
