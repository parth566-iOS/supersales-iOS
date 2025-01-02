//
//  AttendanceHistoryViewController.swift
//  SuperSales
//
//  Created by Apple on 15/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import FastEasyMapping

class AttendanceHistoryViewController: BaseViewController {
    
    
    @IBOutlet var lblDay: UILabel!
    @IBOutlet var lblErrormsg: UILabel!
    @IBOutlet var btnApproval: UIButton!
    
    @IBOutlet weak var lblApprovalCount: UILabel!
    
    var datepickerAttendance:UIDatePicker!
    var selectedDate:Date!
    var selectedDateStr:String!
    
    @IBOutlet var btnSelectedDate: UIButton!
    
    var arrHistory:[AttendanceHistory] = [AttendanceHistory]()
    
    
    @IBOutlet var tblAttendance: UITableView!
    var approvalcount = 0
    override func viewDidLoad() {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            super.viewDidLoad()
            self.setUI()
       })
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          NotificationCenter.default.addObserver(forName: Notification.Name("LoadUserAttendanceHistory"), object: nil, queue: OperationQueue.main) { (notify) in
                   
            self.loadData()
         
                }
      
          
                  NotificationCenter.default.addObserver(forName: Notification.Name("updateAttendanceRequestSent"), object: nil, queue: OperationQueue.main) { (notify) in
                           
                        self.loadData()
                        
                }
           
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("LoadUserAttendanceHistory"), object: nil)
   
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateAttendanceRequestSent"), object: nil)
   

    }
    
    override func viewDidAppear(_ animated: Bool) {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        super.viewDidAppear(true)
        self.loadData()
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: Method
    func setUI(){
       
        datepickerAttendance = UIDatePicker.init()
        datepickerAttendance.setCommonFeature()
          
        datepickerAttendance = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: self.view.bounds.width, height: 200))
        datepickerAttendance.maximumDate = Date()
        self.salesPlandelegateObject = self
        selectedDate = Date()
        selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "yyyy/MM/dd", defaultTimeZone: true)
        btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "dd MMM,yyyy", defaultTimeZone: true), for: .normal)
        lblDay.text = Utils.getDateWithAppendingDayLang(day: 0, date: selectedDate, format: "EEE")
        tblAttendance.delegate = self
        tblAttendance.dataSource = self
        tblAttendance.tableFooterView = UIView()
        tblAttendance.separatorStyle = .none
      //tblAttendance.estimatedRowHeight = 360
     //tblAttendance.rowHeight = UITableView.automaticDimension
        
    }

    func loadData(){
       // let status = Date().isSameDayAs(date2: selectedDate)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        let mapping = AttendanceHistory.defaultMapping()
        let store = FEMManagedObjectStore.init(context: AttendanceHistory.getContext())
        store.saveContextOnCommit = false
        let deserializer = FEMDeserializer.init(store: store)
        var param = Common.returndefaultparameter()
        param["Date"] = selectedDateStr
        param["AdminID"] = self.activeuser?.userID
        print("parameter of history = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetAllAttendanceHistory, method: Apicallmethod.get) {(totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
    if(responseType == ResponseType.arr){
    let arrAttendance = arr as? [[String:Any]] ?? [[String:Any]]()
    self.arrHistory.removeAll()
    if(arrAttendance.count > 0){
    self.lblErrormsg.isHidden = true
    self.tblAttendance.isHidden =  false
                      
        self.approvalcount = 0
                for ath in arrAttendance{
                           let userData = ath  as? [AnyHashable: Any] ?? [:]
                           print(userData)
                           if let obj = deserializer.object(fromRepresentation: userData, mapping: mapping)
                           as? AttendanceHistory
                           {
                            var arrOfUserWithApprovalpendingRequest = [AttendanceUser]()
                            self.arrHistory.append(obj)
                            if((obj.manualAttendance?.count ?? 0 > 0) && (obj.manualApproved == true)){
                                
                               
                            }else if (((obj.checkInApproved == true) && (obj.checkInTime !=  nil)) && ((obj.checkOutApproved == true) && (obj.checkOutTime != nil))) {
                               
                                  
                                }else if(obj.leaveType?.lowercased() == "absent"){
                                
                                }
                                else if(((obj.checkInApproved == true) && (obj.checkInTime !=  nil)) && ((obj.checkOutApproved == true) && (obj.checkOutTime == nil))) {
                                  
                                }else{
                                    if let user = obj.attendanceuser{
                                        print(" \(user) and \(arrOfUserWithApprovalpendingRequest)" )
                                    if(!arrOfUserWithApprovalpendingRequest.contains(user)){
                                        self.approvalcount += 1
                                        arrOfUserWithApprovalpendingRequest.append(user)
                                    }
                                    }
                                    
                                }
                            }
                        }
        self.lblApprovalCount.text = String.init(format:"\(self.approvalcount)")
                    }else{
        self.lblErrormsg.isHidden = false
        self.lblErrormsg.text = "No attendance for this day"
    self.tblAttendance.isHidden =  true
                    }
                   
                }
              
            self.tblAttendance.reloadData()
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                
            }else{
               Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
        
    }
    
    func approveAttendance(attendanceobj:AttendanceHistory,status:Bool)->(){
        if(attendanceobj.attendanceuser?.entity_id == 0){
            attendanceobj.attendanceuser?.entity_id = Int(attendanceobj.attendanceuser?.userId ?? 0 )
        }
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["AttendanceID"] =  attendanceobj.entity_id
        param["UserID"] = self.activeuser?.userID
        param["CompanyID"] =  self.activeuser?.company?.iD
        param["MemberID"] = NSNumber.init(value:attendanceobj.attendanceuser?.entity_id ?? 0)
        param["Approve"] = NSNumber.init(value:status)
        param["IsPermanentLocation"] = NSNumber.init(value:false)
        param["TokenID"] =  self.activeuser?.securityToken
        print("parameter of approve = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveAttendance, method: Apicallmethod.post) { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                 NotificationCenter.default.post(name: Notification.Name("LoadUserAttendanceHistory"), object: nil)
                if(  tblAttendance.visibleCells.count > 0){
                self.tblAttendance.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                }
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
//                                self.navigationController?.popViewController(animated: true)
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                
            }else{
               Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
    }
    // MARK: IBAction
    
    @IBAction func btnDateClicked(_ sender: UIButton) {
       // Utils.addShadow(view: self.view)
          self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:datepickerAttendance, textfield: nil, withDateMonth: false)
    }

    @IBAction func btnApprovalClicked(_ sender: UIButton) {
     if let attendanceApprovalpList = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.ApprovalPendingList) as? ApprovalwaitingList{
self.navigationController?.pushViewController(attendanceApprovalpList, animated: true)
        }
    }
    
}
extension AttendanceHistoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.AttendaceCell, for: indexPath) as? AttendanceCell{
cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
if let attendace = arrHistory[indexPath.row] as? AttendanceHistory{
cell.vwbtnSelfie.isHidden = true
cell.btnSelfieCheckIn.isHidden = true
cell.btnSelfieCheckout.isHidden = true
cell.vwbtnSelifeCheckout.isHidden = true
 
cell.lbl2Title.isHidden = false


cell.vwNewCheckIn.isHidden = true
cell.vwNewCheckOut.isHidden = true
    
cell.setAttendanceHistorydata(attendance: attendace, indexpath: indexPath)
cell.btnSelfieCheckIn.addTarget(self, action: #selector(btnSelfieCheckInClicked), for: .touchUpInside)
cell.btnSelfieCheckout.addTarget(self, action: #selector(btnSelfieCheckOutClicked), for: .touchUpInside)
cell.btnAccept.addTarget(self, action: #selector(btnAcceptClicked), for: .touchUpInside)
cell.btnReject.addTarget(self, action: #selector(btnRejectClicked), for: .touchUpInside)
}
        else{
                print("Did not get cell \(indexPath.row)")
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let attendance = arrHistory[indexPath.row]
    let attendanceuser = attendance.attendanceuser
        
        if(attendance.leaveType?.lowercased() == "absent" || attendance.leaveType?.lowercased() == "holiday" || attendance.leaveType?.lowercased() == "paid leave"){
            if let  userhistory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceUserHistory) as? AttendanceUserHistoryController1{
            userhistory.user =  attendanceuser
                if(attendanceuser?.entity_id == 0){
                    userhistory.memberId = NSNumber.init(value:attendanceuser?.userId ?? 0)
                }else{
            userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
                }
            self.navigationController?.pushViewController(userhistory, animated: true)
                }
        }else if let manualattendance = attendance.manualAttendance as? String {
            if let  userhistory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceUserHistory) as? AttendanceUserHistoryController1{
            userhistory.user =  attendanceuser
                if(attendanceuser?.entity_id == 0){
                    userhistory.memberId = NSNumber.init(value:attendanceuser?.userId ?? 0)
                }else{
            userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
                }
                self.navigationController?.pushViewController(userhistory, animated: true)
            }
         /*   if(manualattendance.count > 0 ){
                if let  userhistory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceUserHistory) as? AttendanceUserHistoryController1{
                userhistory.user =  attendanceuser
                    if(attendanceuser?.entity_id == 0){
                        userhistory.memberId = NSNumber.init(value:attendanceuser?.userId ?? 0)
                    }else{
                userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
                    }
                self.navigationController?.pushViewController(userhistory, animated: true)
                    }
            }else{
                if let  userhistory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceUserHistory) as? AttendanceUserHistoryController1{
                userhistory.user =  attendanceuser
                    if(attendanceuser?.entity_id == 0){
                        userhistory.memberId = NSNumber.init(value:attendanceuser?.userId ?? 0)
                    }else{
                userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
                    }
                   
                self.navigationController?.pushViewController(userhistory, animated: true)
                    }*/
    
        }else{
            if let  userhistory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceUserHistory) as? AttendanceUserHistoryController1{
            userhistory.user =  attendanceuser
                if(attendanceuser?.entity_id == 0){
                    userhistory.memberId = NSNumber.init(value:attendanceuser?.userId ?? 0)
                }else{
            userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
                }
            self.navigationController?.pushViewController(userhistory, animated: true)
                }
        }
        
    
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
return UITableView.automaticDimension
    }
    
    //MARK: - Table methods
    @objc func btnSelfieCheckOutClicked(sender:UIButton)->(){
       
        let ato =  arrHistory[sender.tag]
        var photos:Array<IDMPhoto>? = Array()
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: ato.checkOutPhotoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
                 //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
        photo.caption = " "
        photos?.append(photo)
        let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: photos)
        browser.delegate = self
        browser.displayCounterLabel = true
        browser.displayActionButton = false
        browser.autoHideInterface = false
        browser.dismissOnTouch = false
        browser.displayArrowButton = false
        browser.displayActionButton = false
        browser.disableVerticalSwipe = true
        DispatchQueue.main.async {
        self.present(browser, animated: true, completion: nil)
    }
    }
    
    @objc func btnSelfieCheckInClicked(sender:UIButton){
        DispatchQueue.main.async {
            let ato =  self.arrHistory[sender.tag]
        var photos:Array<IDMPhoto>? = Array()
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string:ato.checkInPhotoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
        //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
        photo.caption = " "
        photos?.append(photo)
        let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: photos)
        browser.delegate = self
        browser.displayCounterLabel = true
        browser.displayActionButton = false
        browser.autoHideInterface = false
        browser.dismissOnTouch = false
        browser.displayArrowButton = false
        browser.displayActionButton = false
        browser.disableVerticalSwipe = true
        
            self.present(browser, animated: true, completion: nil)
        }
    }
    
    @objc func btnAcceptClicked(sender:UIButton){
        print("button accept \(sender.tag)")
        let ato =  arrHistory[sender.tag]
        let yesAction = UIAlertAction.init(title: "YES", style: .default) { (action) in
             self.approveAttendance(attendanceobj: ato, status: true)
        }
        let noAction = UIAlertAction.init(title: "NO", style: .default) { (action) in
            print("No Clicked")
        }
        Common.showalertWithAction(msg: "Are you sure you want to approve?", arrAction: [yesAction,noAction], view: self)
       
    }
    
    @objc func btnRejectClicked(sender:UIButton){
         print("button reject \(sender.tag)")
        let ato =  arrHistory[sender.tag]
        let yesAction = UIAlertAction.init(title: "YES", style: .default) { (action) in
             self.approveAttendance(attendanceobj: ato, status: false)
        }
        let noAction = UIAlertAction.init(title: "NO", style: .default) { (action) in
            print("No Clicked")
        }
        Common.showalertWithAction(msg: "Are you sure you want to reject?", arrAction: [yesAction,noAction], view: self)
    }
}
extension AttendanceHistoryViewController:BaseViewControllerDelegate{
    
    
    func datepickerSelectionDone(){
     //   Utils.removeShadow(view: self.view)
        
        
        /*
         selectedDate = Date()
         selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "yyyy/MM/dd")
         
         **/
       
        selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "yyyy/MM/dd", defaultTimeZone: true)
      
        btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "dd MMM,yyyy", defaultTimeZone: true), for: .normal)
        
       lblDay.text = Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "EEE", defaultTimeZone: true)
        
        selectedDate =  Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
        //Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
        print("Selected date = \(selectedDate)")
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        self.loadData()
      //  })
//    btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepickerAttendance.date), for: .normal)
//        lblDay.text = Utils.getDateWithAppendingDayLang(day: 0, date: datepickerAttendance.date, format: "EEE")
    }
    
    func cancelbtnTapped(){
      //  Utils.removeShadow(view: self.view)
      datepickerAttendance.removeFromSuperview()
    }
    
}
extension AttendanceHistoryViewController :IDMPhotoBrowserDelegate{
    
}
