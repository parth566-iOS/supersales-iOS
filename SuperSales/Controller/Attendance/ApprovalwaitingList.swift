//
//  ApprovalwaitingList.swift
//  SuperSales
//
//  Created by Apple on 31/08/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import FastEasyMapping
import MonthYearPicker

class ApprovalwaitingList: BaseViewController {
    //MARK : Outlets
    private let refreshControl = UIRefreshControl()
    @IBOutlet var btnSelectedDate: UIButton!
    
    @IBOutlet weak var lblErromsg: UILabel!
    @IBOutlet var tblApproveAttendanceList: UITableView!
    var arrAttendanceUserHistory:[AttendanceUserHistory]! = [AttendanceUserHistory]()
    var selectedDate:Date!
    var selectedDateStr:String!
    var datepickerAttendance:MonthYearPickerView!
    
    //var arrHistory:[AttendanceHistory] = [AttendanceHistory]()
    @IBOutlet var lblErrormsg: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getPendingList()
    }
    // MARK: - Method
    func setUI(){
        self.title = "Attendance Approval"
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        datepickerAttendance = MonthYearPickerView.init()
       // datepickerAttendance.setCommonFeature()
        
        datepickerAttendance = MonthYearPickerView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        datepickerAttendance.maximumDate = Date()
        
        selectedDate = Date()
        
        
        selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "yyyy/MM/dd", defaultTimeZone: true)
        btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "MMM,yyyy", defaultTimeZone: true), for: .normal)
        tblApproveAttendanceList.delegate = self
        tblApproveAttendanceList.dataSource = self
        
        tblApproveAttendanceList.estimatedRowHeight = 88.0
        tblApproveAttendanceList.rowHeight = UITableView.automaticDimension
        self.salesPlandelegateObject = self
        //infinite scrolling
        if #available(iOS 10.0, *) {
            tblApproveAttendanceList.refreshControl = refreshControl
        } else {
            tblApproveAttendanceList.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    }
    // MARK: - Method
    @objc private func refreshWeatherData(_ sender: Any) {
        //        // Fetch Weather Data
        getPendingList()
    }
    //MARK: - API Call
    func getPendingList(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        let mapping = AttendanceUserHistory.defaultMapping()
        let store = FEMManagedObjectStore.init(context: AttendanceUserHistory.getContext())
        store.saveContextOnCommit = false
        let deserializer = FEMDeserializer.init(store: store)
        var param = Common.returndefaultparameter()
        
        param["Month"] = selectedDate.getCurrentMonth()
        
        param["Year"] = selectedDate.getCurrentYear()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetPendingAttendace, method: Apicallmethod.get){(totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            self.refreshControl.endRefreshing()
            SVProgressHUD.dismiss()
            print(responseType)
            if(status.lowercased() == Constant.SucessResponseFromServer){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                if(responseType == ResponseType.arr){
                    let arrAttendance = arr as? [[String:Any]] ?? [[String:Any]]()
                    self.arrAttendanceUserHistory.removeAll()
                    //self.arrAttendanceUserHistory.removeAll()
                    self.lblErromsg.text = "No attendance for this month"
                    if(arrAttendance.count > 0){
                        
                        self.lblErromsg.isHidden = true
                        
                        self.tblApproveAttendanceList.isHidden = false
                        self.tblApproveAttendanceList.separatorColor = UIColor.clear
                        //    self.approvalcount = 0
                        
                        for ath in arrAttendance{
                            let userData = ath  as? [AnyHashable: Any] ?? [:]
                            if let obj = deserializer.object(fromRepresentation: userData, mapping: mapping) as? AttendanceUserHistory{
                                self.arrAttendanceUserHistory.append(obj)
                                //    if(obj.manualApproved == false){
                                //        self.approvalcount += 1
                                //    }
                            }
                            
                        }
                    }else{
                        self.lblErromsg.isHidden = false
                        
                        
                        self.tblApproveAttendanceList.isHidden = true
                        //  self.lblerrormsg.text="No attendance for this  month"
                    }
                    self.tblApproveAttendanceList.reloadData()
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
    
    func approveAttendance(attendanceobj:AttendanceUserHistory,status:Bool)->(){
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["AttendanceID"] =  attendanceobj.entity_id
        param["UserID"] = self.activeuser?.userID
        param["CompanyID"] =  self.activeuser?.company?.iD
        param["MemberID"] = NSNumber.init(value:Int(attendanceobj.attendanceuser.userId) ?? attendanceobj.attendanceuser.entity_id)
        param["Approve"] = NSNumber.init(value:status)
        param["IsPermanentLocation"] = NSNumber.init(value:false)
        param["TokenID"] =  self.activeuser?.securityToken
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveAttendance, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            if(status.lowercased() == Constant.SucessResponseFromServer){
                //                 NotificationCenter.default.post(name: Notification.Name("LoadUserAttendanceHistory"), object: nil)
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                self.getPendingList()   //self.navigationController?.popViewController(animated: true)
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func btnDateClicked(_ sender: UIButton) {
        //self.openDatePicker(view: self.view , dateType: .date, tag: 0, datepicker:datepickerAttendanceUserHistory, textfield: nil, withDateMonth: false)
        self.openOnlyMonthDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:datepickerAttendance, textfield: nil, withDateMonth: true)
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
extension ApprovalwaitingList:BaseViewControllerDelegate{
    
    
    func datepickerSelectionDone(){
        datepickerAttendance.removeFromSuperview()
        selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "yyyy/MM/dd", defaultTimeZone: true)
        btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "MMM,yyyy", defaultTimeZone: true), for: .normal)
        
        
        selectedDate =  Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
        selectedDate =  Utils.getDateFromString(date: selectedDateStr) //Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
        print(selectedDate)
        self.getPendingList()
        btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:" MMM yyyy",date:datepickerAttendance.date), for: .normal)
        // lblDay.text = Utils.getDateWithAppendingDayLang(day: 0, date: datepickerAttendance.date, format: "EEE")
    }
    
    func cancelbtnTapped(){
        datepickerAttendance.removeFromSuperview()
    }
    
}
extension ApprovalwaitingList:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrAttendanceUserHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.AttendaceCell, for: indexPath) as? AttendanceCell{
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            // if let attendace = arrAttendanceUserHistory[indexPath.row] as? AttendanceUserHistory{
            if let attendace = arrAttendanceUserHistory[indexPath.row] as? AttendanceUserHistory{
                cell.vwbtnSelfie.isHidden = true
                cell.btnSelfieCheckIn.isHidden = true
                cell.btnSelfieCheckout.isHidden = true
                cell.vwbtnSelifeCheckout.isHidden = true
                cell.lbl2Title.isHidden = false
                cell.vwNewCheckIn.isHidden = true
                cell.vwNewCheckOut.isHidden = true
                
                
                //cell.setAttendanceHistorydata(attendance: attendace, indexpath: indexPath)
                
                cell.setPendingApprovalAttendance(attendance: attendace, indexpath: indexPath)
                cell.btnAccept.isHidden = false
                cell.btnReject.isHidden = false
                cell.stkbtn.isHidden = false
                cell.btnSelfieCheckIn.addTarget(self, action: #selector(btnSelfieCheckInClicked), for: .touchUpInside)
                cell.btnSelfieCheckout.addTarget(self, action: #selector(btnSelfieCheckOutClicked), for: .touchUpInside)
                cell.btnAccept.addTarget(self, action: #selector(btnAcceptClicked), for: .touchUpInside)
                cell.btnReject.addTarget(self, action: #selector(btnRejectClicked), for: .touchUpInside)
                
            }else{
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
        let attendance = arrAttendanceUserHistory[indexPath.row]
        if(attendance.checkInAttendanceType == 6 && attendance.checkOutAttendanceType == 6){
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
                    userdetail.attendanceCheckinDetail = attendance
                    userdetail.isFromHistory = false
                    // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
                    self.navigationController?.pushViewController(userdetail, animated: true)
                }else{
                    self.navigationController?.pushViewController(UIViewController(), animated: true)
                }
            }
        }else
        if let  userdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
            userdetail.attendanceCheckinDetail = attendance
            userdetail.isFromHistory = false
            // userhistory.memberId = NSNumber.init(value:attendanceuser?.entity_id ?? 0)
            self.navigationController?.pushViewController(userdetail, animated: true)
        }else{
            self.navigationController?.pushViewController(UIViewController(), animated: true)
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


}
extension ApprovalwaitingList :IDMPhotoBrowserDelegate{
    
}
