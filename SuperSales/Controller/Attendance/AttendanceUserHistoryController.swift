//
//  AttendanceUserHistoryController.swift
//  SuperSales
//
//  Created by Apple on 16/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import MonthYearPicker
import FastEasyMapping

struct workinghours{
    var date:NSDate
    var hours:String
}
class AttendanceUserHistoryController: BaseViewController {
    
    private let refreshControl = UIRefreshControl()
    @IBOutlet var btnSelectedDate: UIButton!
    @IBOutlet var lblUserName: UILabel!
    
    @IBOutlet var lblerrormsg: UILabel!
    @IBOutlet var lblTotalhour: UILabel!
    @IBOutlet var tblAttendanceHistory: UITableView!
    var arrOfTotalWorkingHour:[workinghours]! = [workinghours]()
    var displayedhour = 0
    var affOfWorkingHoursSectionwise:[String:[AttendanceUserHistory]]!
    var figuresByDay = [(key: String, value: [AttendanceUserHistory])]()
    var data = [AttendanceUserHistory]()
    var keys = [String]()
    var memberId:NSNumber!
    var datepickerAttendanceUserHistory:MonthYearPickerView!
//    var dateForObj:NSDate!
    var selectedDate:Date!
    var selectedDateStr:String!
    var arrAttendanceUserHistory:[AttendanceUserHistory]! = [AttendanceUserHistory]()
    var totalhoursvalue = "0"
    var totalweekhours = "0"
    var totalweeksecond = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            super.viewDidAppear(true)
            self.loadData()
        })
    }
    
    //MARK: - Method
    func setUI(){
        selectedDate = Date()
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.title = "Attendance History"
        let user = self.activeuser
        //  self.lblUserName.textColor = UIColor.Appskybluecolor
        self.lblUserName.font = UIFont.boldSystemFont(ofSize: 17)
        var strname = ""
        if let  firstname =  user?.firstName as? String{
            if(firstname.count > 0){
                strname.append(firstname)
            }
        }
        if let lastname = user?.lastName as? String{
            if(lastname.count > 0){
                strname.append(String.init(format: " \(lastname)"))
            }
        }
        self.lblUserName.text = strname
        //String.init(format:"\(user?.firstName) \(user?.lastName)",[])
        tblAttendanceHistory.delegate = self
        tblAttendanceHistory.dataSource = self
    
        
        datepickerAttendanceUserHistory = MonthYearPickerView.init()
        
        datepickerAttendanceUserHistory = MonthYearPickerView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        datepickerAttendanceUserHistory.maximumDate = Date()
        self.salesPlandelegateObject = self
        selectedDate = Date()
        selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "yyyy/MM/dd", defaultTimeZone: true)
        btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "MMM,yyyy", defaultTimeZone: true), for: .normal)
        //infinite scrolling
        if #available(iOS 10.0, *) {
            tblAttendanceHistory.refreshControl = refreshControl
        } else {
            tblAttendanceHistory.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        //        // Fetch Weather Data
        loadData()
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
        print("parameter of attendance user history = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetAttendanceHistory, method: Apicallmethod.get){(totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                self.refreshControl.endRefreshing()
                if(responseType == ResponseType.arr){
                    let arrAttendance = arr as? [[String:Any]] ?? [[String:Any]]()
                    self.arrAttendanceUserHistory.removeAll()
                    if(arrAttendance.count > 0){
                        self.lblerrormsg.isHidden = true
                        self.tblAttendanceHistory.isHidden = false
                        self.tblAttendanceHistory.separatorColor = UIColor.clear
                        
                        var totalSeconds = 0
                        
                        for i in 0...arrAttendance.count - 1{
                            let ath =  arrAttendance[i]
                            let userData = ath  as? [AnyHashable: Any] ?? [:]
                            if let obj = deserializer.object(fromRepresentation: userData, mapping: mapping) as? AttendanceUserHistory{
                               
                                self.arrAttendanceUserHistory.append(obj)
                                totalSeconds += Int(Utils.minutesSecondsToSeconds(totalTime: obj.totalTime))
                               
                                self.dateFormatter.dateFormat = "EEE"
                                let weekhours = "0"
                                // if let date = obj.attendanceDate{
                                let date = obj.attendanceDate
                                let day = self.dateFormatter.string(from: date as Date)
                                
                                print("day = \(day)")
                                
                                /* if(indexPath.row == 0){
                                 //        displayedhour = 0
                                 //        cell.vwWeeklyTotal?.isHidden = false
                                 if((attendace.manualApproved && attendace.manualAttendance.count > 0) || (attendace.checkInApproved && (attendace.checkInTime != nil)) || (attendace.checkOutApproved && (attendace.checkOutTime != nil)) || (attendace.checkInApproved && (attendace.updatedTimeIn != nil)) || ((attendace.checkOutTime != nil) && (attendace.updatedTimeOut != nil))){
                                 totalweeksecond  += Int(Utils.minutesSecondsToSeconds(totalTime: attendace.totalTime))
                                 }
                                 // if(attendance.approval)
                                 self.totalweekhours = Utils.secondsToMinutesSeconds(seconds:self.totalweeksecond)
                                 //cell.lblWeeklyTotalHour?.text = String.init(format:"Weekly Total \(self.totalweekhours) Hours")
                                 }else if(day == "Sun"){
                                 // displayedhour += 1
                                 // cell.vwWeeklyTotal?.isHidden = false
                                 
                                 self.totalweekhours = Utils.secondsToMinutesSeconds(seconds:self.totalweeksecond)
                                 //        cell.lblWeeklyTotalHour?.text = String.init(format:"Weekly Total \(self.totalweekhours) Hours")
                                 totalweeksecond = 0
                                 }
                                 else{
                                 //  displayedhour += 1
                                 //  cell.vwWeeklyTotal?.isHidden = true
                                 
                                 // cell.lblWeeklyTotalHour?.text = String.init(format:"Weekly Total \(totalweekhours) Hours")
                                 if((attendace.manualApproved && attendace.manualAttendance.count > 0) || (attendace.checkInApproved && (attendace.checkInTime != nil)) || (attendace.checkOutApproved && (attendace.checkOutTime != nil)) || (attendace.checkInApproved && (attendace.updatedTimeIn != nil)) || ((attendace.checkOutTime != nil) && (attendace.updatedTimeOut != nil))){
                                 totalweeksecond  += Int(Utils.minutesSecondsToSeconds(totalTime: attendace.totalTime))
                                 }
                                 // self.totalweekhours = Utils.secondsToMinutesSeconds(seconds:self.totalweeksecond)
                                 }*/
                                
                                
                                // print("seconds  = \(self.totalweeksecond) , total time  = \(obj.totalTime) , \(obj.totalWorkTime), object = \(obj), int = \(Int(Utils.minutesSecondsToSeconds(totalTime: obj.totalTime)) )")
                                
                            }
                        }
                        self.totalhoursvalue =  Utils.secondsToMinutesSeconds(seconds: totalSeconds)
                        
                        
                        self.dateFormatter.dateFormat = "EEE"
                     
                        self.arrOfTotalWorkingHour = [workinghours]()
                        
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
                        
                        
                    }else{
                        self.lblerrormsg.isHidden = false
                        self.tblAttendanceHistory.isHidden = true
                        self.lblerrormsg.text="No attendance for this  month"
                    }
                    // self.lblTotalhr.text =
                    
                    print(self.totalhoursvalue)
                    self.lblTotalhour.text = String.init(format: "∑ \(self.totalhoursvalue) hrs")
                    
                    /* for objAttendance in self.arrAttendanceUserHistory{
                     //            if(){
                     //
                     //            }
                     //   dateformatter.dateFormat = "dd MMM EEE"
                     self.dateFormatter.dateFormat = "EEE"
                     let weekhours = "0"
                     if let date = objAttendance.attendanceDate{
                     
                     }
                     }*/
                    /*
                     data = mappedData.reduce([String: [Model]]()) { (result, element) -> [String: [Model]] in
                     
                     **/
                    self.data = self.arrAttendanceUserHistory.reduce([AttendanceUserHistory]()) { (result, element) ->  [AttendanceUserHistory] in
                        
                        var res = result
                        var weekhours = "0"
                        if let atte =  element as? AttendanceUserHistory{
                          
                            
                            self.dateFormatter.dateFormat = "EEE"
                            let day = self.dateFormatter.string(from: atte.attendanceDate as Date)
                           
                            if(day == "SUN"){
                                self.keys.append("Weely Total")
                                weekhours = "0"
                                if(atte.totalTime.count > 0){
                                    weekhours += atte.totalTime
                                }
                            }else{
                                if(atte.totalTime.count > 0){
                                    weekhours += atte.totalTime
                                }
                                
                            }
                        }
                        
                        return res
                    }
                    
                    
                    self.tblAttendanceHistory.reloadData()
                    self.tblAttendanceHistory.tableHeaderView?.reloadInputViews()
                }
            }else if(error.code == 0){
                self.refreshControl.endRefreshing()
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                
            }else{
                self.refreshControl.endRefreshing()
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
        
    }
    
    
    @objc func btnSelfieCheckOutClicked(sender:UIButton)->(){
        DispatchQueue.main.async {
            let ato =  self.arrAttendanceUserHistory[sender.tag]
//        var photos:Array<IDMPhoto>? = Array()
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: ato.checkOutPhotoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
        //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
        photo.caption = " "
//        photos?.append(photo)
       
        let browser:IDMPhotoBrowser = IDMPhotoBrowser(photos: [photo])
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
    
    @objc func btnSelfieCheckInClicked(sender:UIButton){
        DispatchQueue.main.async {
            let ato =  self.arrAttendanceUserHistory[sender.tag]
//        var photos:Array<IDMPhoto>? = Array()
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: ato.checkInPhotoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
        //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
        photo.caption = " "
//        photos?.append(photo)
        
        let browser:IDMPhotoBrowser = IDMPhotoBrowser(photos: [photo])
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
    @objc func btnUpdateClicked(sender:UIButton){
        
        let ato =  arrAttendanceUserHistory[sender.tag]
        
        if let  updateDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.UpdateAttendanceDetail) as? UpdateAttendanceController{
            updateDetail.attendanceobj = ato
            updateDetail.modalPresentationStyle = .overCurrentContext
            self.present(updateDetail, animated: true, completion: nil) //self.navigationController?.pushViewController(manualvisit, animated: true)
        }
        
    }
    func isentryOfSelf(attendanceUser:AttendanceUser)->Bool{
      
        if(attendanceUser.entity_id == 0){
            attendanceUser.entity_id = Int(attendanceUser.userId ?? 0)
        }
        if(attendanceUser.entity_id == self.activeuser?.userID?.intValue){
            return true
        }else{
            return false
        }
    }
    //MARK: - IBAction
    @IBAction func btnDateClicked(_ sender: UIButton) {
        //  Utils.addShadow(view: self.view)
        // self.openDatePicker(view: self.view , dateType: .date, tag: 0, datepicker:datepickerAttendanceUserHistory, textfield: nil, withDateMonth: false)
        self.openOnlyMonthDatePicker(view: self.view, dateType: .date, tag: 0, datepicker: datepickerAttendanceUserHistory, textfield: nil, withDateMonth: true)
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

extension AttendanceUserHistoryController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Weekly Total:"
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        return view
    }
    //
    //
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let headerview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tblAttendanceHistory.frame.size.width, height: 50))
    //        headerview.backgroundColor = UIColor.purple
    //        return  headerview
    //    }
    //
    
    //  func tableview
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
                cell.btnAccept.isHidden = true
                cell.btnReject.isHidden = true
                cell.setAttendanceUserHistorydata(attendance: attendace, indexpath: indexPath)
                cell.stkbtn.isHidden = true
                // cell.cnstStkBtnAttendance.constant = 0
                
                cell.btnUpdateTime.tag = indexPath.row
                cell.btnSelfieCheckIn.addTarget(self, action: #selector(btnSelfieCheckInClicked), for: .touchUpInside)
                cell.btnSelfieCheckout.addTarget(self, action: #selector(btnSelfieCheckOutClicked), for: .touchUpInside)
                cell.btnUpdateTime.addTarget(self, action: #selector(btnUpdateClicked), for: .touchUpInside)
                cell.btnUpdateTime.isUserInteractionEnabled = true
                
                
                //        if((self.activeuser?.role?.id == 5) || (self.activeuser?.role?.id == 6)){
                cell.visibilestkbtn(visibility: true)
                
                self.dateFormatter.dateFormat = "EEE"
                
                
                let date = attendace.attendanceDate
                let day = self.dateFormatter.string(from: date as Date)
                
          
                self.dateFormatter.dateFormat = "EEE"
                
                
                if(indexPath.row == 0){
                    displayedhour = 0
                   
                    let arrofworking = self.arrOfTotalWorkingHour.filter{
                        $0.date == date
                    }
                    let arrOFHours = self.arrOfTotalWorkingHour.map{
                        $0.hours
                    }
                    let selectedworkinghours  =  arrofworking.first
                    print("\(arrOFHours) , value = \(arrOFHours[Int(displayedhour)]) for record = \(indexPath.row) and displayed record = \(displayedhour)")
                  
                    cell.lblWeeklyTotalHour?.text = String.init(format:"Weekly Total \(arrOFHours[Int(indexPath.row)]) Hours")
                   
                    cell.vwWeeklyTotal?.isHidden = false
                }else
                if(day == "Sun"){
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
                
               
                    
                    print("\(arrOFHours) , value = \(arrOFHours[Int(displayedhour)]) for record = \(indexPath.row) and displayed record = \(displayedhour)")
                        cell.lblWeeklyTotalHour?.text = String.init(format:"Weekly Total \(arrOFHours[Int(indexPath.row)]) Hours")
             
                    
                }else{
                    cell.vwWeeklyTotal?.isHidden = true
                }
                
                
                
                /*
                 if(day == "Sun"){
                 print("Week hours  = \(weekhours) , count of section = \(self.arrOfTotalWorkingHour.count) , total seconds  = \(totalweeksecond)")
                 //  self.affOfWorkingHoursSectionwise.
                 self.arrOfTotalWorkingHour.append(String.init(format:"\(totalweeksecond)"))
                 totalweeksecond = 0
                 
                 }else{
                 totalweeksecond  += Int(Utils.minutesSecondsToSeconds(totalTime: obj.totalTime))
                 print("seconds  = \(totalweeksecond) , total time  = \(obj.totalTime) , \(obj.totalWorkTime), object = \(obj), int = \(Int(Utils.minutesSecondsToSeconds(totalTime: obj.totalTime)) )")
                 
                 }
                 
                 
                 
                 
                 **/
                //        var nextatte = AttendanceUserHistory()
                //        if(indexPath.row < arrAttendanceUserHistory.count - 1){
                //            print("current record  = \(indexPath.row) , record in array = \(arrAttendanceUserHistory.count - 1)")
                //            nextatte = arrAttendanceUserHistory[indexPath.row + 1]
                //        }
                //        cell.vwWeeklyTotal.addBorders(edges: UIRectEdge.all, color: UIColor.gray, cornerradius: 5)
                //        if(indexPath.row == 0){
                //            cell.vwWeeklyTotal.isHidden = false
                //        }else if let nate = nextatte as? AttendanceUserHistory{
                //            self.dateFormatter.dateFormat = "EEE"
                //            let day =  self.dateFormatter.string(from: nate.attendanceDate as Date)
                //            print("day is  = \(day)")
                //            if(day == "SUN"){
                //                cell.vwWeeklyTotal.isHidden = false
                //            }else{
                //                cell.vwWeeklyTotal.isHidden = true
                //            }
                //        }else{
                //            cell.vwWeeklyTotal.isHidden = true
                //        }
                // }
            }else{
                
            }
            cell.contentView.layoutSubviews()
            cell.contentView.layoutIfNeeded()
            return cell
        }else{
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let attendance = arrAttendanceUserHistory[indexPath.row]
        print(attendance.checkInApproved)
        print(attendance.checkOutApproved)
        let attendanceuser = attendance.attendanceuser
        /* if(attendance.leaveType.lowercased() == "absent" || attendance.leaveType.lowercased() == "holiday" || attendance.leaveType.lowercased() == "paid leave"){
         
         }else if let manualattendance = attendance.manualAttendance as? String {
         if(manualattendance.count > 0){
         
         }else if((attendance.checkInApproved == true) && (attendance.checkOutApproved == true)){
         if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
         userdetail.isFromHistory = true
         userdetail.attendanceCheckinDetail = attendance
         // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
         self.navigationController?.pushViewController(userdetail, animated: true)
         }
         }else{
         if let updatetimein = attendance.updatedTimeIn as? NSDate {
         if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
         userdetail.isFromHistory = true
         userdetail.attendanceCheckinDetail = attendance
         // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
         self.navigationController?.pushViewController(userdetail, animated: true)
         }
         }else
         if let updatedtimeout =  attendance.updatedTimeOut as? NSDate{
         if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
         userdetail.isFromHistory = true
         userdetail.attendanceCheckinDetail = attendance
         // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
         self.navigationController?.pushViewController(userdetail, animated: true)
         }
         
         }
         if let checkintime = attendance.checkInTime as? NSDate{
         if let updatedtime = attendance.updatedTimeIn as? NSDate{
         if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
         self.navigationController?.pushViewController(updateDetailview, animated: true)
         }
         }
         }
         if let checkouttime = attendance.checkOutTime as? NSDate{
         if let updatedtimeout = attendance.updatedTimeOut as? NSDate{
         if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
         self.navigationController?.pushViewController(updateDetailview, animated: true)
         }
         
         }
         }
         }
         
         }else if((attendance.checkInApproved == true) && (attendance.checkOutApproved == true)){
         if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
         userdetail.isFromHistory = true
         userdetail.attendanceCheckinDetail = attendance
         // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
         self.navigationController?.pushViewController(userdetail, animated: true)
         }
         }
         else{
         if let updatetimein = attendance.updatedTimeIn as? NSDate {
         if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
         userdetail.isFromHistory = true
         userdetail.attendanceCheckinDetail = attendance
         // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
         self.navigationController?.pushViewController(userdetail, animated: true)
         }
         }
         if let updatedtimeout =  attendance.updatedTimeOut as? NSDate{
         if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
         userdetail.isFromHistory = true
         userdetail.attendanceCheckinDetail = attendance
         // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
         self.navigationController?.pushViewController(userdetail, animated: true)
         }
         
         }
         if let checkintime = attendance.checkInTime as? NSDate{
         if let updatedtime = attendance.updatedTimeIn as? NSDate{
         if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
         self.navigationController?.pushViewController(updateDetailview, animated: true)
         }
         }
         }
         if let checkouttime = attendance.checkOutTime as? NSDate{
         if let updatedtimeout = attendance.updatedTimeOut as? NSDate{
         if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
         self.navigationController?.pushViewController(updateDetailview, animated: true)
         }
         
         }
         }
         }*/
        if(attendance.leaveType.lowercased() == "absent" || attendance.leaveType.lowercased() == "casual leave" || attendance.leaveType.lowercased() == "holiday" || attendance.leaveType.lowercased() == "paid leave" || attendance.manualAttendance.count > 0 || attendance.leaveDay.count > 0){
            
        }else if((attendance.checkInApproved == true) && (attendance.checkOutApproved == true)){
            if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                userdetail.isFromHistory = true
                userdetail.attendanceCheckinDetail = attendance
                // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
                self.navigationController?.pushViewController(userdetail, animated: true)
            }
        }else if(attendance.checkInAttendanceType == 6 && attendance.checkOutAttendanceType == 6){
            if(!self.isentryOfSelf(attendanceUser: attendanceuser)){
            if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
                updateDetailview.attendanceCheckinDetail = attendance
                
                self.navigationController?.pushViewController(updateDetailview, animated: true)
            }
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
                if(!self.isentryOfSelf(attendanceUser: attendanceuser)){
                if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
                    
                    updateDetailview.attendanceCheckinDetail = attendance
                    self.navigationController?.pushViewController(updateDetailview, animated: true)
                }
                }
            }else{
                if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                    userdetail.isFromHistory = true
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
                
                if(!self.isentryOfSelf(attendanceUser: attendanceuser)){
                    
                
                if let updateDetailview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetailUpdateRequest) as? AttendanceDetailUpdateRequestView{
                    
                    updateDetailview.attendanceCheckinDetail = attendance
                    self.navigationController?.pushViewController(updateDetailview, animated: true)
                }
                }
            }else{
                if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                    userdetail.isFromHistory = true
                    userdetail.attendanceCheckinDetail = attendance
                    // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
                    self.navigationController?.pushViewController(userdetail, animated: true)
                }
            }
        }else{
            if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
                userdetail.isFromHistory = true
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
extension AttendanceUserHistoryController:BaseViewControllerDelegate{
    func datepickerSelectionDone(){
         Utils.removeShadow(view: self.view)
        datepickerAttendanceUserHistory.removeFromSuperview()
        selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendanceUserHistory.date, format: "yyyy/MM/dd", defaultTimeZone: true)
        
        btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendanceUserHistory.date, format: "dd MMM,yyyy", defaultTimeZone: true), for: .normal)
        
        selectedDate =  Utils.getDateFromString(date: selectedDateStr)
        
        self.loadData()
        btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"MMM yyyy",date:datepickerAttendanceUserHistory.date), for: .normal)
    }
    func cancelbtnTapped() {
        //    Utils.removeShadow(view: self.view)
        datepickerAttendanceUserHistory.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
        
    }
}
extension AttendanceUserHistoryController :IDMPhotoBrowserDelegate{
    func photoBrowserDidFinishModalPresentation(_ photoBrowser: IDMPhotoBrowser!) {
        self.dismiss(animated: true, completion: nil)
    }
}
