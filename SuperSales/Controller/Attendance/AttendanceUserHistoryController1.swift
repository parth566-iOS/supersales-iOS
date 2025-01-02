//
//  AttendanceUserHistoryController1.swift
//  SuperSales
//
//  Created by Apple on 15/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import MonthYearPicker
import FastEasyMapping

class AttendanceUserHistoryController1: BaseViewController {
    let refreshControl = UIRefreshControl.init()
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblTotalhr: UILabel!
    var user:AttendanceUser!
    var memberId:NSNumber!
    @IBOutlet var btnSelectedDate: UIButton!
    @IBOutlet var tblAttendanceUserHistory: UITableView!
    var arrOfTotalWorkingHour:[workinghours]! = [workinghours]()
    var displayedhour = 0
    var arrAttendanceUserHistory:[AttendanceUserHistory]! = [AttendanceUserHistory]()
    var datepickerAttendanceUserHistory:MonthYearPickerView!
    var selectedDate:Date!
    var selectedDateStr:String!
    var totalminute = 0
    var totalhoursvalue = "0"
    var totalweekhours = "0"
    var totalweeksecond = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
             NotificationCenter.default.addObserver(forName: Notification.Name("LoadUserAttendanceHistory"), object: nil, queue: OperationQueue.main) { (notify) in
                       print(notify.object as?  Dictionary<String,Any>)
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
    //MARK: - IBAction
    
    @IBAction func btnDateClicked(_ sender: UIButton) {
        self.openOnlyMonthDatePicker(view: self.view, dateType: .date, tag: 0, datepicker: datepickerAttendanceUserHistory, textfield: nil, withDateMonth: true)
        //  self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:datepickerAttendanceUserHistory, textfield: nil, withDateMonth: false)
    }
    
   
       @objc func btnSelfieCheckOutClicked(sender:UIButton)->(){
          
           let ato =  arrAttendanceUserHistory[sender.tag]
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
          
           let ato =  arrAttendanceUserHistory[sender.tag]
           var photos:Array<IDMPhoto>? = Array()
           let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: ato.checkInPhotoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
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
       
       @objc func btnAcceptClicked(sender:UIButton){
           print("button accept \(sender.tag)")
           let ato =  arrAttendanceUserHistory[sender.tag]
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
           let ato =  arrAttendanceUserHistory[sender.tag]
           let yesAction = UIAlertAction.init(title: "YES", style: .default) { (action) in
                self.approveAttendance(attendanceobj: ato, status: false)
           }
           let noAction = UIAlertAction.init(title: "NO", style: .default) { (action) in
               print("No Clicked")
           }
           Common.showalertWithAction(msg: "Are you sure you want to reject?", arrAction: [yesAction,noAction], view: self)
         
       }
    @objc func btnUpdateClicked(sender:UIButton){
         
        let ato =  arrAttendanceUserHistory[sender.tag]
        
               if let  updateDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.UpdateAttendanceDetail) as? UpdateAttendanceController{
                updateDetail.attendanceobj = ato
                                  updateDetail.modalPresentationStyle = .overCurrentContext
                                 self.present(updateDetail, animated: true, completion: nil)
                             }
          
    }
    func approveAttendance(attendanceobj:AttendanceUserHistory,status:Bool)->(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["AttendanceID"] =  attendanceobj.entity_id
        param["UserID"] = self.activeuser?.userID
        param["CompanyID"] =  self.activeuser?.company?.iD
        param["MemberID"] = self.memberId// NSNumber.init(value:attendanceobj.attendanceuser.entity_id ?? 0)
        param["Approve"] = NSNumber.init(value:status)
        param["IsPermanentLocation"] = NSNumber.init(value:false)
        param["TokenID"] =  self.activeuser?.securityToken
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveAttendance, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let topRow = IndexPath(row: 0,
                                           section: 0)
                if(self.tblAttendanceUserHistory.visibleCells.count > 0){
                self.tblAttendanceUserHistory.scrollToRow(at: topRow, at: UITableView.ScrollPosition.top, animated: true)
                }
         /*   self.tableView.scrollToRow(at: topRow,
                                               at: .top,
                                               animated: true)*/
                
                 NotificationCenter.default.post(name: Notification.Name("LoadUserAttendanceHistory"), object: nil)
                                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                //self.navigationController?.popViewController(animated: true)
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                
            }else{
               Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
    }
    
    //MARK: - Method
    func setUI(){
        self.tblAttendanceUserHistory.addPullToRefresh {
            self.loadData()
        }
        self.salesPlandelegateObject =  self
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.title = "Attendance History"
        
        self.lblUserName.textColor = UIColor.Appskybluecolor
        self.lblUserName.font = UIFont.boldSystemFont(ofSize: 16)
        self.lblUserName.text = String.init(format:"\(user.firstName) \(user.lastName)",[])
        tblAttendanceUserHistory.delegate = self
        tblAttendanceUserHistory.dataSource = self
        datepickerAttendanceUserHistory = MonthYearPickerView.init()
       
        
        
//        datepickerAttendanceUserHistory = UIDatePicker.init()
//        datepickerAttendanceUserHistory.setCommonFeature()
               
        datepickerAttendanceUserHistory = MonthYearPickerView.init(frame:CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
                 datepickerAttendanceUserHistory.maximumDate = Date()
               self.salesPlandelegateObject = self
               selectedDate = Date()
               selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "yyyy/MM/dd", defaultTimeZone: true)
               btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "MMM,yyyy", defaultTimeZone: true), for: .normal)
      }
    
    func loadData(){
           let status = Date().isSameDayAs(date2: selectedDate)
           SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
           let mapping = AttendanceUserHistory.defaultMapping()
           let store = FEMManagedObjectStore.init(context: AttendanceUserHistory.getContext())
           store.saveContextOnCommit = false
           let deserializer = FEMDeserializer.init(store: store)
           var param = Common.returndefaultparameter()
           param["MemberID"] = memberId
        param["Month"] = selectedDate.getCurrentMonth()
        param["Year"] = selectedDate.getCurrentYear()
        print("parameter = \(param)")
           self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetAttendanceHistory, method: Apicallmethod.get) {(totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
               SVProgressHUD.dismiss()
               if(status.lowercased() == Constant.SucessResponseFromServer){
                   self.tblAttendanceUserHistory.pullToRefreshView.stopAnimating()
                   print(responseType)
                   if(responseType == ResponseType.arr)
                   {
                    
       let arrAttendance = arr as? [[String:Any]] ?? [[String:Any]]()
                       self.arrAttendanceUserHistory.removeAll()
                    var totalSeconds = 0
                       if(arrAttendance.count > 0){
 //self.lblErrormsg.isHidden = true
//            self.tblAttendance.isHidden =  false
                           self.tblAttendanceUserHistory.separatorColor = UIColor.clear
                           
                         
                  
                   for ath in arrAttendance{
                    let userData = ath  as? [AnyHashable: Any] ?? [:]
                    print("userdata = \(ath)")
                              if let obj = deserializer.object(fromRepresentation: userData, mapping: mapping)
                              as? AttendanceUserHistory
                              {
                               self.arrAttendanceUserHistory.append(obj)
                                totalSeconds += Int(Utils.minutesSecondsToSeconds(totalTime: obj.totalTime))
                           
//                                var numberTotalTime =  NSNumber.init(value: 0)
//                                if let myInteger = Int(obj.totalTime as? String ?? "") {
//                                    let myNumber = NSNumber(value:myInteger)
//                                    numberTotalTime = myNumber
//
//                                }else{
//                                    numberTotalTime =   NSNumber.init(value: 0)
//                                }
//                                print("\(Int(obj.totalTime)),\(obj.totalTime) ,\(obj.totalWorkTime),\(Int(obj.totalWorkTime))")
//                                self.totalminute += numberTotalTime.intValue
  //  self.totalminute += Int(obj.totalTime) ?? 0
                                
                                var isSundayComeonce = 0
                                var arrOfSundayNo = [Int]()
                                for i in 0...self.arrAttendanceUserHistory.count - 1 {
                                 //   if(i < self.arrAttendanceUserHistory.count){
                                    if  let obj =  self.arrAttendanceUserHistory[i] as? AttendanceUserHistory{
                                        self.dateFormatter.dateFormat = "EEE"
                                        
                                        let date = obj.attendanceDate
                                        let day = self.dateFormatter.string(from: date as Date)
                                        if(day == "Sun"){
                                            
                                            arrOfSundayNo.append(i)
                                            print("sunday's record = \(arrOfSundayNo)")
                                            if((obj.manualApproved && obj.manualAttendance.count > 0) || (obj.checkInApproved && (obj.checkInTime != nil)) || (obj.checkOutApproved && (obj.checkOutTime != nil)) || (obj.checkInApproved && (obj.updatedTimeIn != nil)) || ((obj.checkOutTime != nil) && (obj.updatedTimeOut != nil))){
                                                self.totalweeksecond  += Int(Utils.minutesSecondsToSeconds(totalTime: obj.totalTime))
                                            }
                                            self.totalweekhours = Utils.secondsToMinutesSeconds(seconds:self.totalweeksecond)
                                            if(isSundayComeonce == 0 && self.arrOfTotalWorkingHour.count > 0){
                                                isSundayComeonce = 1
                                                self.arrOfTotalWorkingHour.remove(at: 0)
                                                self.arrOfTotalWorkingHour.insert(workinghours.init(date: obj.attendanceDate, hours: self.totalweekhours), at: 0)
                                                self.arrOfTotalWorkingHour.insert(workinghours.init(date: obj.attendanceDate, hours: self.totalweekhours), at: i)
                                            }else{
                                                isSundayComeonce = isSundayComeonce + 1
                                                if(self.arrOfTotalWorkingHour.count > arrOfSundayNo[isSundayComeonce - 1]){
                                                self.arrOfTotalWorkingHour.remove(at: arrOfSundayNo[isSundayComeonce - 1])
                                                }
                                                self.arrOfTotalWorkingHour.insert(workinghours.init(date: obj.attendanceDate, hours: self.totalweekhours), at: arrOfSundayNo[isSundayComeonce - 1])
                                                print("after sunday replace = \(self.arrOfTotalWorkingHour) , \(arrOfSundayNo[isSundayComeonce - 1]) , \(obj.attendanceDate) , \(self.totalweekhours) , \(i)")
                                            self.arrOfTotalWorkingHour.insert(workinghours.init(date: obj.attendanceDate, hours: self.totalweekhours), at: i)
                                            }
                                         
                                            self.totalweeksecond = 0
                                            
                                        }else{
                                            if(self.arrOfTotalWorkingHour.count == 0){
                                                arrOfSundayNo.append(i)
                                            }
                                            if((obj.manualApproved && obj.manualAttendance.count > 0) || (obj.checkInApproved && (obj.checkInTime != nil)) || (obj.checkOutApproved && (obj.checkOutTime != nil)) || (obj.checkInApproved && (obj.updatedTimeIn != nil)) || ((obj.checkOutTime != nil) && (obj.updatedTimeOut != nil))){
                                                self.totalweeksecond  += Int(Utils.minutesSecondsToSeconds(totalTime: obj.totalTime))
                                            }
                                            if(i == self.arrAttendanceUserHistory.count - 1){
                                                self.totalweekhours = Utils.secondsToMinutesSeconds(seconds:self.totalweeksecond)
                                              
                                                self.arrOfTotalWorkingHour.insert(workinghours.init(date: obj.attendanceDate, hours: self.totalweekhours), at: i)
                                                if(arrOfSundayNo.count > 0){
                                                if(self.arrOfTotalWorkingHour.count > arrOfSundayNo[arrOfSundayNo.count - 1]){
                                                self.arrOfTotalWorkingHour.remove(at: arrOfSundayNo[arrOfSundayNo.count - 1])
                                                }
                                                self.arrOfTotalWorkingHour.insert(workinghours.init(date: obj.attendanceDate, hours: self.totalweekhours), at: arrOfSundayNo[arrOfSundayNo.count - 1])
                                                print("after sunday replace = \(self.arrOfTotalWorkingHour) , \(arrOfSundayNo[arrOfSundayNo.count - 1]) , \(obj.attendanceDate) , \(self.totalweekhours) , \(i)")
                                                }
                                            self.arrOfTotalWorkingHour.insert(workinghours.init(date: obj.attendanceDate, hours: self.totalweekhours), at: i)
                                               
                                            }else{
                                                self.arrOfTotalWorkingHour.insert(workinghours.init(date: obj.attendanceDate, hours: self.totalweekhours), at: i)
                                            }
                                         
                                        }
                                        
                                    }
                                    //}
                                }
                                
                                
                               }
                           }
                           
                           
                           
                           
                           
                           
                           
                          /*
                           
                           
                           for i in 0...self.arrAttendanceUserHistory.count - 1 {
                             if  let obj =  self.arrAttendanceUserHistory[i] as? AttendanceUserHistory{
                               self.dateFormatter.dateFormat = "EEE"
                              
                               let date = obj.attendanceDate
                               let day = self.dateFormatter.string(from: date as Date)
                               if(day == "Sun"){
                                
                                 //  self.affOfWorkingHoursSectionwise.
                                //   self.totalweekhours = Utils.secondsToMinutesSeconds(seconds:self.totalweeksecond)
                                   if((obj.manualApproved && obj.manualAttendance.count > 0) || (obj.checkInApproved && (obj.checkInTime != nil)) || (obj.checkOutApproved && (obj.checkOutTime != nil)) || (obj.checkInApproved && (obj.updatedTimeIn != nil)) || ((obj.checkOutTime != nil) && (obj.updatedTimeOut != nil))){
                                       self.totalweeksecond  += Int(Utils.minutesSecondsToSeconds(totalTime: obj.totalTime))
                                   }
                                   self.totalweekhours = Utils.secondsToMinutesSeconds(seconds:self.totalweeksecond)
                                   self.arrOfTotalWorkingHour.append(workinghours.init(date: obj.attendanceDate, hours: self.totalweekhours))
                                  // self.arrOfTotalWorkingHour.append({obj.attendanceDate:String.init(format:"\(self.totalweekhours)"}))
                                  
                                   self.totalweeksecond = 0
                                   
                               }else{
                                   if((obj.manualApproved && obj.manualAttendance.count > 0) || (obj.checkInApproved && (obj.checkInTime != nil)) || (obj.checkOutApproved && (obj.checkOutTime != nil)) || (obj.checkInApproved && (obj.updatedTimeIn != nil)) || ((obj.checkOutTime != nil) && (obj.updatedTimeOut != nil))){
                                       self.totalweeksecond  += Int(Utils.minutesSecondsToSeconds(totalTime: obj.totalTime))
                                   }
                                   if(i == self.arrAttendanceUserHistory.count - 1){
                                       self.totalweekhours = Utils.secondsToMinutesSeconds(seconds:self.totalweeksecond)
                                       self.arrOfTotalWorkingHour.append(workinghours.init(date: obj.attendanceDate, hours: self.totalweekhours))
                                      // self.arrOfTotalWorkingHour.append({obj.attendanceDate:String.init(format:"\(self.totalweekhours)"}))
                                   }
                                
                               }
                             
                           }
                           }
                           
*/
                           
                           
                           
                           print(self.totalhoursvalue)
                           self.lblTotalhr.text = String.init(format: "∑ \(self.totalhoursvalue) hrs")
                       }else{
                           
                          
                       }
//                   }
//              }
                      print("seconds = \(totalSeconds)")
                      self.totalhoursvalue =  Utils.secondsToMinutesSeconds(seconds: totalSeconds)
                    self.lblTotalhr.text = String.init(format: "∑ \(self.totalhoursvalue) hrs", [])
                       self.tblAttendanceUserHistory.reloadData()
                   }
               }else if(error.code == 0){
                   if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                   self.tblAttendanceUserHistory.pullToRefreshView.stopAnimating()
               }else{
                   self.tblAttendanceUserHistory.pullToRefreshView.stopAnimating()
                  Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
               }
           }
           
           
       }

}
extension AttendanceUserHistoryController1:BaseViewControllerDelegate{
     func datepickerSelectionDone(){
        datepickerAttendanceUserHistory.removeFromSuperview()
        /*
         selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "yyyy/MM/dd")
         btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "dd MMM,yyyy"), for: .normal)
         
        lblDay.text = Utils.getDateWithAppendingDayLang(day: 0, date: selectedDate, format: "EEE")
         
         selectedDate =  Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
         
         selec_date = [Utils getDateWithAppendingMonth:1 Date:selected_date andFormat:@"yyyy/MM/dd"];
         selected_date = [Utils getDateFromString:selec_date];
         **/
    selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendanceUserHistory.date, format: "yyyy/MM/dd", defaultTimeZone: true)
    btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendanceUserHistory.date, format: "MMM,yyyy", defaultTimeZone: true), for: .normal)
   
        
        
        selectedDate =  Utils.getDateFromString(date: selectedDateStr)
            //Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
        print(selectedDate)
        
        //Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
            self.loadData()
//Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepickerAttendance.date)         //btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepickerAttendanceUserHistory.date), for: .normal)
        }
    func cancelbtnTapped() {
           datepickerAttendanceUserHistory.removeFromSuperview()
        }
}

extension AttendanceUserHistoryController1:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAttendanceUserHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.AttendaceCell, for: indexPath) as? AttendanceCell{
                 cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
    if let attendace = arrAttendanceUserHistory[indexPath.row] as? AttendanceUserHistory{
        cell.vwbtnSelfie.isHidden = true
        cell.btnSelfieCheckIn.isHidden = true
        cell.btnSelfieCheckout.isHidden = true
        cell.vwbtnSelifeCheckout.isHidden = true
        cell.lbl2.isHidden = true
        cell.lbl2Title.isHidden = false
        cell.setAttendanceUserHistorydata(attendance: attendace, indexpath: indexPath)
        cell.btnUpdateTime.isHidden = true
                     cell.btnSelfieCheckIn.addTarget(self, action: #selector(btnSelfieCheckInClicked), for: .touchUpInside)
                     cell.btnSelfieCheckout.addTarget(self, action: #selector(btnSelfieCheckOutClicked), for: .touchUpInside)
                     cell.btnAccept.addTarget(self, action: #selector(btnAcceptClicked), for: .touchUpInside)
                     cell.btnReject.addTarget(self, action: #selector(btnRejectClicked), for: .touchUpInside)
        cell.btnUpdateTime.addTarget(self, action: #selector(btnUpdateClicked), for: .touchUpInside)
        let date = attendace.attendanceDate
        let day = self.dateFormatter.string(from: date as Date)
        
        print("day = \(day)")
        self.dateFormatter.dateFormat = "EEE"
        
        if(indexPath.row == 0){
            displayedhour = 0
            cell.vwWeeklyTotal?.isHidden = false
            let arrofworking = self.arrOfTotalWorkingHour.filter{
                $0.date == date
            }
            let arrOFHours = self.arrOfTotalWorkingHour.map{
                $0.hours
            }
            let selectedworkinghours  =  arrofworking.first
           
          //  if let hour = selectedworkinghours?.hours as? String{
                cell.lblWeeklyTotalHour?.text = String.init(format:"Weekly Total \(arrOFHours[Int(displayedhour)]) Hours")
              //  cell.lblWeeklyTotalHour?.text = String.init(format:"Weekly Total \(hour) Hours")
          //  }
          
        }else if(day == "Sun"){
            if(displayedhour < arrOfTotalWorkingHour.count - 1){
                displayedhour += 1
                
            }
            cell.vwWeeklyTotal?.isHidden = false
            
            let arrofworking = self.arrOfTotalWorkingHour.filter{
                $0.date == date
            }
            let arrOFHours = self.arrOfTotalWorkingHour.map{
                $0.hours
            }
            let selectedworkinghours  =  arrofworking.first
            print(selectedworkinghours)
       //     if let hour = selectedworkinghours?.hours as? String{
            print("\(selectedworkinghours) , value = \(arrOFHours[Int(indexPath.row)])")
                cell.lblWeeklyTotalHour?.text = String.init(format:"Weekly Total \(arrOFHours[Int(displayedhour)]) Hours")
               // cell.lblWeeklyTotalHour?.text = String.init(format:"Weekly Total \(hour) Hours")
         //   }
        
            
        }else{
            cell.vwWeeklyTotal?.isHidden = true
        }
        
        
                  }else{
                     print("Did not get cell \(indexPath.row)")
                 }
            
            
            
            
                 return cell
             }else{
                 return UITableViewCell()
             }
      /*  if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.VisitListCell, for: indexPath) as? VisitCell{
                   let attendace = arrAttendanceUserHistory[indexPath.row] as? AttendanceHistory
                   if let customer = attendace?.attendanceuser as? AttendanceUser{
                    if let checkintime = attendace?.attendanceDate as? NSDate{
                               let oldtimeIn =
                                   // Utils.getDateWithAppendingDay:0
                                   Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "dd MMM EEE")
                    cell.lblCustomerName.text = oldtimeIn
                    }
                    print(String.init(format:"\(customer.firstName ?? "") \(customer.lastName ?? "")")) //"rtdber" //attendace?.attendanceDate
                   }else{
                       cell.lblCustomerName.text = String.init(format:"")
                   }
               
                   return cell
               }else{
                   return UITableViewCell()
               }*/
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let attendance = arrAttendanceUserHistory[indexPath.row]
   
  /*  if(attendance.leaveType.lowercased() == "absent" || attendance.leaveType.lowercased() == "holiday" || attendance.leaveType.lowercased() == "paid leave"){
            
    }else if let manualattendance = attendance.manualAttendance as? String {
        if(manualattendance.count > 0){
            if(attendance.manualApproved  == nil){
                
            }else{
            if let approval = attendance.manualApproved as? Bool{
                if(approval == true){
                    
                }else{
            if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                              userdetail.attendanceCheckinDetail = attendance
                userdetail.isFromHistory = false
            self.navigationController?.pushViewController(userdetail, animated: true)
            }
            }
            }
            }
        }else if((attendance.checkInApproved == true) || (attendance.checkOutApproved == true)){
if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                  userdetail.attendanceCheckinDetail = attendance
    userdetail.isFromHistory = false
self.navigationController?.pushViewController(userdetail, animated: true)
    }
}    else{
if let updatetimein = attendance.updatedTimeIn as? NSDate {
    if let checkintime = attendance.checkInTime as? NSDate{
       
             if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
                updateDetailview.attendanceCheckinDetail = attendance
                
self.navigationController?.pushViewController(updateDetailview, animated: true)
            }
             else{
    
                if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                            userdetail.attendanceCheckinDetail = attendance
                    userdetail.isFromHistory = false
self.navigationController?.pushViewController(userdetail, animated: true)
            }
             }
    }else
if let updatedtimeout =  attendance.updatedTimeOut as? NSDate{
    if let checkouttime = attendance.checkOutTime as? NSDate{
       
            if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
                updateDetailview.attendanceCheckinDetail = attendance
self.navigationController?.pushViewController(updateDetailview, animated: true)
        }
           
    }else{
    
                    if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
            userdetail.attendanceCheckinDetail = attendance
                        userdetail.isFromHistory = false
                                          // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
self.navigationController?.pushViewController(userdetail, animated: true)
                }
    }
            }

        
    }else if((attendance.checkInApproved == true) && (attendance.checkOutApproved == true)){
             if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                userdetail.isFromHistory = false
              userdetail.attendanceCheckinDetail = attendance
             // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
self.navigationController?.pushViewController(userdetail, animated: true)
              }
    }
    else{
        if let updatetimein = attendance.updatedTimeIn as? NSDate {
            if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                userdetail.isFromHistory = false
                        userdetail.attendanceCheckinDetail = attendance
                       // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
self.navigationController?.pushViewController(userdetail, animated: true)
        }
        }
            if let updatedtimeout =  attendance.updatedTimeOut as? NSDate{
if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
    userdetail.isFromHistory = false
                                    userdetail.attendanceCheckinDetail = attendance
                                    // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
self.navigationController?.pushViewController(userdetail, animated: true)
        }
           
        }
        if let checkintime = attendance.checkInTime as? NSDate{
            if let updatedtime = attendance.updatedTimeIn as? NSDate{
                 if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
                    
                       updateDetailview.attendanceCheckinDetail = attendance
self.navigationController?.pushViewController(updateDetailview, animated: true)
                }
            }
        }
        if let checkouttime = attendance.checkOutTime as? NSDate{
            if let updatedtimeout = attendance.updatedTimeOut as? NSDate{
                if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
                    
                       updateDetailview.attendanceCheckinDetail = attendance
self.navigationController?.pushViewController(updateDetailview, animated: true)
            }
               
        }
        }
        }
    
}
    }*/
        let attendanceuser = attendance.attendanceuser
        if(attendanceuser.entity_id == 0){
            attendanceuser.entity_id = Int(attendanceuser.userId)
        }
        print(attendance)
        
        if(attendance.leaveType.lowercased() == "absent" || attendance.leaveType.lowercased() == "holiday" || attendance.leaveType.lowercased() == "paid leave" || (attendance.manualAttendance.count > 0 && attendance.manualApproved == true)){
                  
          }else if((attendance.checkInApproved == true) && (attendance.checkOutApproved == true)){
            if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
               userdetail.isFromHistory = false
             userdetail.attendanceCheckinDetail = attendance
            // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
self.navigationController?.pushViewController(userdetail, animated: true)
             }
          }else if(attendance.checkInAttendanceType == 6 && attendance.checkOutAttendanceType == 6){
            if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
               updateDetailview.attendanceCheckinDetail = attendance
               
self.navigationController?.pushViewController(updateDetailview, animated: true)
          }
          }else if let updatedtimeout =  attendance.updatedTimeOut as? NSDate{
            var view = "Detail"
            if let checkintime = attendance.checkInTime as? NSDate{
                if let updatedtime = attendance.updatedTimeIn as? NSDate{
                    view = "Update"
                    
                }
            }
            if let checkouttime = attendance.checkOutTime as? NSDate{
                if let updatedtimeout = attendance.updatedTimeOut as? NSDate{
                    view =  "Update"
                   
                   
            }
          }
            if(view == "Update"){
                if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
                    
                       updateDetailview.attendanceCheckinDetail = attendance
self.navigationController?.pushViewController(updateDetailview, animated: true)
            }
            }else{
                if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                   userdetail.isFromHistory = false
                 userdetail.attendanceCheckinDetail = attendance
                // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
    self.navigationController?.pushViewController(userdetail, animated: true)
                 }
            }
          }else if let updatedtimein =  attendance.updatedTimeIn as? NSDate{
            var view = "Detail"
            if let checkintime = attendance.checkInTime as? NSDate{
                if let updatedtime = attendance.updatedTimeIn as? NSDate{
                    view = "Update"
                    
                }
            }
            if let checkouttime = attendance.checkOutTime as? NSDate{
                if let updatedtimeout = attendance.updatedTimeOut as? NSDate{
                    view =  "Update"
                   
                   
            }
          }
            if(view == "Update"){
                if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
                    
                       updateDetailview.attendanceCheckinDetail = attendance
self.navigationController?.pushViewController(updateDetailview, animated: true)
            }
            }else{
                if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                   userdetail.isFromHistory = false
                 userdetail.attendanceCheckinDetail = attendance
                // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
    self.navigationController?.pushViewController(userdetail, animated: true)
                 }
            }
    }else{
        if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
           userdetail.isFromHistory = false
         userdetail.attendanceCheckinDetail = attendance
        // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
self.navigationController?.pushViewController(userdetail, animated: true)
         }
    }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    

}
extension AttendanceUserHistoryController1 :IDMPhotoBrowserDelegate{
    
}
