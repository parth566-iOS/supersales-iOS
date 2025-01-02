//
//  LeaveListViewController.swift
//  SuperSales
//
//  Created by Apple on 06/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import MonthYearPicker
import SVProgressHUD
import FastEasyMapping

class LeaveListViewController: BaseViewController {

    @IBOutlet weak var lblSelectedMonth: UILabel!
    
    @IBOutlet weak var btnCalender: UIButton!
    
    @IBOutlet weak var tblteamAppliedLeave: UITableView!
    @IBOutlet weak var lblError: UILabel!
    
    var datepickerLeave:MonthYearPickerView!
    var selectedDate:Date! = Date()
    var selectedDateStr:String!
    
    var arrOfLeave:[Leave] = [Leave]()
    
    let refreshControl = UIRefreshControl.init()
    
    override func viewDidLoad() {
        
        DispatchQueue.main.async {
            super.viewDidLoad()
            self.selectedDate = Date()
           
            self.setUI()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        self.loadData()
    }
    
    //MARK: - Method
    func setUI(){
        selectedDate = Date()
        selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "yyyy/MM/dd", defaultTimeZone: true)
 lblSelectedMonth.text = Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "MMM,yyyy", defaultTimeZone: true)
        if #available(iOS 10.0, *) {
           self.tblteamAppliedLeave.refreshControl = self.refreshControl
        } else {
           self.tblteamAppliedLeave.addSubview(self.refreshControl)
        }
self.refreshControl.addTarget(self, action: #selector(self.getLeaveData), for: .valueChanged)
        datepickerLeave = MonthYearPickerView.init()
 
        datepickerLeave = MonthYearPickerView.init(frame:CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
       // datepickerLeave.maximumDate = Date()
               self.salesPlandelegateObject = self
            
       
        tblteamAppliedLeave.delegate = self
        tblteamAppliedLeave.dataSource = self
        tblteamAppliedLeave.setCommonFeature()
        if(BaseViewController.staticlowerUser.count == 0){
            lblError.text = "There are currently no users reporting to you"
            lblError.isHidden = false
            tblteamAppliedLeave.isHidden = true
        }else{
            lblError.isHidden = true
            tblteamAppliedLeave.isHidden = false
        }
             //  btnDateMonth.setTitle(Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "MMM,yyyy"), for: .normal)
    }
    
    
    @objc func getLeaveData(){
        self.loadData()
    }
    
    //MARK: - APICall
    func loadData(){
        var param = Common.returndefaultparameter()
        param["UserID"] =  self.activeuser?.userID
        param["StartMonth"] = selectedDate.getCurrentMonth()
        param["StartYear"] = selectedDate.getCurrentYear()
        param["EndMonth"] = selectedDate.getCurrentMonth()
        param["EndYear"] = selectedDate.getCurrentYear()
        param["Status"] = "All"
        SVProgressHUD.show()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetAllUserLeaves, method: Apicallmethod.get)
        { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            Utils.removeShadow(view: self.view)
            SVProgressHUD.dismiss()
            self.refreshControl.endRefreshing()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(arr)
                let arrofleave = arr as? [[String:Any]] ?? [[String:Any]]()
                MagicalRecord.save { (localcontext) in
                    Leave.mr_truncateAll(in: localcontext)
                    let arr = FEMDeserializer.collection(fromRepresentation: arrofleave, mapping: Leave.defaultMapping(), context: localcontext)
                    print(arr)
                    localcontext.mr_saveToPersistentStoreAndWait()
                } completion: { (status, error) in
self.arrOfLeave = Leave.getLeaveForMonth(date: self.selectedDate)
                    self.lblError.text = "No leaves are applied for selected month"
                    if(self.arrOfLeave.count > 0){
                        self.tblteamAppliedLeave.isHidden = false
                        self.lblError.isHidden = true
                    }else{
                        self.tblteamAppliedLeave.isHidden = true
                        self.lblError.isHidden = false
                    }
                    self.tblteamAppliedLeave.reloadData()
                }
                
                 Utils.toastmsg(message:message,view: self.view)
                
            }else{
                
            }
            
        }
    }
    
    func approveLeave(leave:Leave , status:Bool){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["Approve"] = status
        param["TransactionID"] = leave.transactionID
        let leavedate = Utils.getDateUTCWithAppendingDay(day: 0, date: leave.date, format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)
        let arrOfDate = [leavedate]
        param["LeaveDates"] =  Common.json(from: arrOfDate)
        param["MemberID"] = leave.leaveuser.entity_id
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveLeaves, method: Apicallmethod.post){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
       
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                Common.showalert(msg: message, view: self)
                self.loadData()
            }else{
                Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view:self.view)
            }
        }
        
    }
    
    // MARK: - IBAction
    
    @IBAction func btnCalenderClicked(_ sender: UIButton) {
        self.openOnlyMonthDatePicker(view: self.view, dateType: .date, tag: 0, datepicker: datepickerLeave, textfield: nil, withDateMonth: true)
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
extension LeaveListViewController:BaseViewControllerDelegate{
     func datepickerSelectionDone(){
        datepickerLeave.removeFromSuperview()
        /*
         selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "yyyy/MM/dd")
         btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "dd MMM,yyyy"), for: .normal)
         
        lblDay.text = Utils.getDateWithAppendingDayLang(day: 0, date: selectedDate, format: "EEE")
         
         selectedDate =  Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
         
         selec_date = [Utils getDateWithAppendingMonth:1 Date:selected_date andFormat:@"yyyy/MM/dd"];
         selected_date = [Utils getDateFromString:selec_date];
         **/
    selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerLeave.date, format: "yyyy/MM/dd", defaultTimeZone: true)
      //  btnDateMonth.setTitle(Utils.getDateWithAppendingDay(day: 0, date: datepickerLeave.date, format: "MMM,yyyy"), for: .normal)
        lblSelectedMonth.text = Utils.getDateWithAppendingDay(day: 0, date: datepickerLeave.date, format: "MMM,yyyy", defaultTimeZone: true)
        
        
        selectedDate =  Utils.getDateFromString(date: selectedDateStr)
            //Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
        print(selectedDate)
        self.loadData()
        //Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
           // self.loadData()
//Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepickerAttendance.date)         //btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepickerAttendanceUserHistory.date), for: .normal)
        }
    func cancelbtnTapped() {
        datepickerLeave.removeFromSuperview()
        }
}
extension LeaveListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfLeave.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.LeaveCell, for: indexPath) as? LeaveStatusCell{
            cell.delegate = self
            cell.btnWithDraw.isHidden = true
            cell.vwReject.isHidden = false
            cell.vwAccept.isHidden = false
            cell.selectionStyle = .none
     
            let selectedLeavestatus = self.arrOfLeave[indexPath.row]
         
            if(selectedLeavestatus.status.lowercased() == "pending"){
                cell.stkBtnAction.isHidden = false
            }else{
                cell.stkBtnAction.isHidden = true
            }
            var username = ""
            if let fname = selectedLeavestatus.leaveuser.firstName{
                username.append(fname)
            }
            if let lname = selectedLeavestatus.leaveuser.lastName{
                if(username.count > 0){
                    username.append(" ")
                }
                username.append(lname)
            }
            cell.lblUserName.text = username
            cell.lblLeaveType.text = selectedLeavestatus.type
            cell.lblAppliedDate.text = Utils.getDateWithAppendingDay(day: 0, date: selectedLeavestatus.date, format: "dd MMM yyyy", defaultTimeZone: true)// [Utils getDateWithAppendingMonth:0 Date:leaveObj.date andFormat:@"dd MMM"]selectedLeavestatus.date
            cell.imgUser.makeImgRound()
            cell.imgUser.sd_setImage(with:  URL.init(string: (selectedLeavestatus.leaveuser.picture?.replacingOccurrences(of: " ", with: "%20").trimString) as? String ?? "")  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
          
                if(err == nil){
                    cell.imgUser.image = img
//                    self.statusImage1 = img ?? UIImage()
//                    self.statusImg1 = IDMPhoto.init(url: urlofimage)
//                    let imggesture = UITapGestureRecognizer.init(target: self, action: #selector(self.img1Tapped))
//                    self.statusimg1.isUserInteractionEnabled = true
//                    self.statusimg1.addGestureRecognizer(imggesture)
                }else{
                    cell.imgUser.image = nil
                    cell.imgUser.image = UIImage.init(named: "icon_user_blue")
                }
            }
             if(selectedLeavestatus.status.lowercased() == "approved"){
                let color = UIColor().colorFromHexCode(rgbValue:0x4A9AA5)
                
                cell.parentView.backgroundColor = color// UIColor.graphDarkCyanColor
              //  cell.parentView.alpha =  0.5
            }else if(selectedLeavestatus.status.lowercased() == "pending"){
                cell.parentView.backgroundColor = UIColor.AppthemeAqvacolor
            }else if(selectedLeavestatus.status.lowercased() == "cancelled"){
                cell.parentView.backgroundColor = .red
            }else{
                cell.parentView.backgroundColor = UIColor.lightBackgroundColor
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedleave =  self.arrOfLeave[indexPath.row]
        if let leaveUserDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLeave, classname: Constant.Leaves) as? LeavesViewController{
            leaveUserDetail.memeberID = NSNumber.init(value:selectedleave.leaveuser.entity_id)
            self.navigationController?.pushViewController(leaveUserDetail, animated: true)
            
        }
    }
}
extension LeaveListViewController:LeaveStatusDelegate{
    func withdrawClicked(cell: LeaveStatusCell) {
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
            
        }
        Common.showalert(title: "SuperSales" , msg: "Are you sure you want to withdraw this leave", yesAction: yesAction, noAction: noAction, view: self)
    }
    
    func approvebtnClicked(cell: LeaveStatusCell) {
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
            if let selectedindexpath = self.tblteamAppliedLeave.indexPath(for: cell) as? IndexPath{
                let selectedleave = self.arrOfLeave[selectedindexpath.row]
                self.approveLeave(leave: selectedleave, status: true)
            }
        }
        Common.showalert(title: "SuperSales" , msg: "Are you sure you want to approve this leave", yesAction: yesAction, noAction: noAction, view: self)
    }
    
    func rejectClicked(cell: LeaveStatusCell) {
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
            if let selectedindexpath = self.tblteamAppliedLeave.indexPath(for: cell) as? IndexPath{
                let selectedleave = self.arrOfLeave[selectedindexpath.row]
            self.approveLeave(leave: selectedleave, status: false)
            }
        }
        Common.showalert(title: "SuperSales" , msg: "Are you sure you want to reject this leave", yesAction: yesAction, noAction: noAction, view: self)
    }
    
    
}
