//
//  LeavesViewController.swift
//  SuperSales
//
//  Created by Apple on 06/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping
import  SVProgressHUD
import SDWebImage
import MonthYearPicker

class LeavesViewController: BaseViewController {

    @IBOutlet weak var btnAddLeave: UIButton!
    
    @IBOutlet weak var lblSickLeave: UILabel!
    
    @IBOutlet weak var lblOptionalLeave: UILabel!

    @IBOutlet weak var lblPaidLeave: UILabel!
    
    @IBOutlet weak var lblCausalLeave: UILabel!
    
    
    @IBOutlet weak var lblHoliday: UILabel!
    
    
    @IBOutlet weak var lblAbsent: UILabel!
    
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var tblAppliedLeave: UITableView!
    
    
    var datepickerLeave:MonthYearPickerView!
    var selectedDate:Date!
    var selectedDateStr:String!
    var memeberID:NSNumber!
    
    var arrOfLeaveBalance:[LeaveBalance]!
    var arrOfLeaveStatus:[LeaveStatus]! = [LeaveStatus]()
    let refreshControl = UIRefreshControl.init()
    

    override func viewDidLoad() {
        DispatchQueue.main.async {
        super.viewDidLoad()
        self.setUI()
        
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadData()
    }

    // MARK: - Method
    func setUI(){
        
        if #available(iOS 10.0, *) {
           self.tblAppliedLeave.refreshControl = self.refreshControl
        } else {
           self.tblAppliedLeave.addSubview(self.refreshControl)
        }
self.refreshControl.addTarget(self, action: #selector(self.getLeaveDataUserWise), for: .valueChanged)
        NotificationCenter.default.addObserver(self,selector: #selector(loadData),
                                               name:Notification.Name(ConstantURL.BALANCE_UPDATE_NOTIFICATION),
                                               object: nil)//UPDATE_DASHBOARD_SUMMARY
        //set multiline
        lblOptionalLeave.setMultilineLabel(lbl: lblOptionalLeave)
        lblPaidLeave.setMultilineLabel(lbl: lblPaidLeave)
        lblCausalLeave.setMultilineLabel(lbl: lblCausalLeave)
        lblAbsent.setMultilineLabel(lbl: lblAbsent)
        lblHoliday.setMultilineLabel(lbl: lblHoliday)
        
       
        lblSickLeave.text = String.init(format: "SICK LEAVE \n \("0.0 / 0.0")")
        lblOptionalLeave.text = String.init(format: "OPTIONAL LEAVE \n \("0.0 / 0.0")")
        lblPaidLeave.text = String.init(format: "PAID LEAVE \n \("0.0 / 0.0")")
        lblCausalLeave.text = String.init(format: "CASUAL LEAVE \n \("0.0 / 0.0")")
//        lblAbsent.text = String.init(format: "ABSENT \n \("0.0 / 0.0")")
        lblHoliday.text = String.init(format: "OPTIONAL HOLIDAY \n \("0.0 / 0.0")")
       
        tblAppliedLeave.setCommonFeature()
        tblAppliedLeave.delegate = self
        tblAppliedLeave.dataSource = self
        
        
        datepickerLeave = MonthYearPickerView.init()
 
        datepickerLeave = MonthYearPickerView.init(frame:CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        datepickerLeave.maximumDate = Date()
               self.salesPlandelegateObject = self
               selectedDate = Date()
               selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "yyyy/MM/dd", defaultTimeZone: true)
        if(self.memeberID == self.activeuser?.userID){
            btnAddLeave.isHidden = false
            btnAddLeave.isUserInteractionEnabled = true
        }else{
            self.title = "Leave Details"
            self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
            self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
            
            btnAddLeave.isHidden = true
            btnAddLeave.isUserInteractionEnabled = false
        }
    }
    @objc func getLeaveDataUserWise(){
        self.loadData()
    }
    func fillLeaveData(){
        for leave in self.arrOfLeaveBalance{
            let strbalanceleave = String.init(format: "%.1f / %.1f",leave.leaveBalance,leave.totalLeaves)
            if(leave.leaveType == "Sick Leave"){
                lblSickLeave.text = String.init(format: "SICK LEAVE \n \(strbalanceleave)")
            }else if(leave.leaveType == "Optional Leave"){
                lblOptionalLeave.text = String.init(format: "OPTIONAL LEAVE \n \(strbalanceleave)")
            }else if(leave.leaveType == "Paid Leave"){
                lblPaidLeave.text = String.init(format: "PAID LEAVE \n \(strbalanceleave)")
            }else if(leave.leaveType == "Casual Leave"){
                lblCausalLeave.text = String.init(format: "CASUAL LEAVE \n \(strbalanceleave)")
            }else if(leave.leaveType == "Optional holiday"){
                lblHoliday.text = String.init(format: "OPTIONAL HOLIDAY \n \(strbalanceleave)")
            }
            
        }
    }
    func createCSVFileForLeave(year:String)->Bool{
       var status = false
        var isDir:ObjCBool = true
       // var theProjectPath = ""
        var documentsDirectoryURL  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        documentsDirectoryURL =   documentsDirectoryURL.appendingPathComponent("SuperSales/Document")
       // var destinationurl = URL.init(string: documentsDirectoryURL)
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.absoluteString, isDirectory: &isDir) {
            do{
            try FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true)
            }catch(let errorinmakedir){
              print("error in creating directory")
            }
        }
        var arrOfLeaveContent = [[String:Any]]()
        let csvtitle = "\("Leave_"),\(year)\n\n"
        var csvString =  "\("Username"),\("StartDate"),\("Reason"),\("Leave Type"),\("Leave Status")\n\n"
        if(arrOfLeaveStatus.count > 0){
            for i in 0...arrOfLeaveStatus.count - 1 {
                //{"Username", "StartDate", "Reason", "Leave Type", "Leave Status"}
                if  let obj = i as? LeaveStatus{
                       var dct = Dictionary<String, AnyObject>()
                    var username = ""
                    if let fname = obj.leavestatususer.firstName{
                        username.append(fname)
                    }
                    if let lname = obj.leavestatususer.lastName{
                        if(username.count > 0){
                            username.append(" ")
                        }
                        username.append(lname)
                    }
                    dct.updateValue(username as AnyObject, forKey: "Username")
                    dct.updateValue(obj.date as AnyObject, forKey: "StartDate")
                    dct.updateValue(obj.reason as AnyObject, forKey: "Reason")
                    dct.updateValue(obj.type as AnyObject, forKey: "Leave Type")
                    dct.updateValue(obj.status as AnyObject, forKey: "Leave Status")
                arrOfLeaveContent.append(dct)
                }
                   }
           
                   
        }else{
            //fun writeToFile(_ path: String, atomically useAuxiliaryFile: Bool, encoding enc: UInt) throws or func writeToURL(_ url: NSURL, atomically useAuxiliaryFile: Bool, encoding enc: UInt) throws
            
        }
        for dct in arrOfLeaveContent {
            csvString = csvString.appending("\(String(describing: dct["EmpID"]!)) ,\(String(describing: dct["EmpName"]!))\n")
        }

        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("\(csvtitle).csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            status = true
        } catch {
            print("error creating file")
            status = false
        }
      /*   String startDate;
                File file;
        //        File exportDir = new File(Environment.getExternalStorageDirectory() + "/" + Constants.APP_NAME, "");

                File exportDir = new File(getActivity().getApplicationContext().getExternalFilesDir(null).getAbsolutePath() + "/" + Constants.APP_NAME, "");
                if (!exportDir.exists()) {
                    exportDir.mkdirs();
                }

                if (listLeaveHistory.size() > 0) {
                    file = new File(exportDir, "Leave_" + listLeaveHistory.get(0).getUser().getFirstname() + " " +
                            listLeaveHistory.get(0).getUser().getLastname() + "_" + year + ".csv");
                    try {
                        file.createNewFile();
                        CSVWriter csvWrite = new CSVWriter(new FileWriter(file));
                        String arrStrColmns[] = {"Username", "StartDate", "Reason", "Leave Type", "Leave Status"};
                        csvWrite.writeNext(arrStrColmns);
                        for (int i = 0; i < listLeaveHistory.size(); i++) {
                            startDate = gmtToLocal("" + listLeaveHistory.get(i).getDate());

                            String arrStr[] = {listLeaveHistory.get(0).getUser().getFirstname() + " " +
                                    listLeaveHistory.get(0).getUser().getLastname(), startDate,
                                    listLeaveHistory.get(i).getReason(), listLeaveHistory.get(i).getType(),
                                    listLeaveHistory.get(i).getStatus()};
                            csvWrite.writeNext(arrStr);
                        }
                        csvWrite.close();
                        result = 1;

                    } catch (Exception sqlEx) {
                        result = 0;
                        sqlEx.printStackTrace();
                    }
                } else {
                    file = new File(exportDir, "Leave_" + year + ".csv");
                    try {
                        file.createNewFile();
                        CSVWriter csvWrite = new CSVWriter(new FileWriter(file));
                        String arrStrColmns[] = {"Username", "StartDate", "Reason", "Leave Type", "Leave Status"};
                        csvWrite.writeNext(arrStrColmns);
                        csvWrite.close();
                        result = 1;
                    } catch (Exception e) {
                        e.printStackTrace();
                        result = 0;
                    }
                }
                return result;*/
         
        return status
    }
    // MARK: - APICall
    @objc func loadData(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["MemberID"] = self.memeberID ?? self.activeuser?.userID
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetLeaveBalance, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
             
          
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(arr)
                let arrOfBalance = arr as? [[String:Any]] ?? [[String:Any]]()
            /*
                 [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                     [_LeaveBalance MR_truncateAllInContext:localContext];
                     arr = [FEMDeserializer collectionFromRepresentation:arrList mapping:[_LeaveBalance defaultMapping] context:localContext];
                 } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                     if (_itemLoadedBlock) {
                         _itemLoadedBlock(arr,nil);
                     }
                 }];
                 
                 **/
                MagicalRecord.save { (localcontext) in
                    LeaveBalance.mr_truncateAll(in: localcontext)
                    let arr = FEMDeserializer.collection(fromRepresentation: arrOfBalance, mapping: LeaveBalance.defaultMapping(), context: localcontext)
                    localcontext.mr_saveToPersistentStoreAndWait()
                } completion: { (status, error) in
                    self.arrOfLeaveBalance = LeaveBalance.getAll()
                    self.fillLeaveData()
                }


                
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetLeaveStatus, method: Apicallmethod.get){
                    (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    self.refreshControl.endRefreshing()
                    SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                       
                        let arrOfLeaveStatus = arr as? [[String:Any]] ?? [[String:Any]]()
                        MagicalRecord.save { (localcontext) in
                            LeaveStatus.mr_truncateAll(in: localcontext)
                            let arr = FEMDeserializer.collection(fromRepresentation: arrOfLeaveStatus, mapping: LeaveStatus.defaultMapping(), context: localcontext)
                            localcontext.mr_saveToPersistentStoreAndWait()
                        } completion: { (status, error) in
                            self.arrOfLeaveStatus = LeaveStatus.getLeavesbyMember(memberID: (self.memeberID ?? self.activeuser?.userID) ?? NSNumber.init(value: 0))
                            if(self.arrOfLeaveStatus.count == 0){
                                self.lblError.isHidden = false
                                self.tblAppliedLeave.isHidden = true
                                self.tblAppliedLeave.isUserInteractionEnabled = false
                            }else{
                                self.lblError.isHidden = true
                                self.tblAppliedLeave.isHidden = false
                                self.tblAppliedLeave.isUserInteractionEnabled = true
                            }
                            self.tblAppliedLeave.reloadData()
                         
                        
                        }
                       
                        if(self.arrOfLeaveStatus.count == 0){
                            self.lblError.isHidden = false
                            self.tblAppliedLeave.isHidden = true
                            self.tblAppliedLeave.isUserInteractionEnabled = false
                        }else{
                            self.lblError.isHidden = true
                            self.tblAppliedLeave.isHidden = false
                            self.tblAppliedLeave.isUserInteractionEnabled = true
                        }
                        self.tblAppliedLeave.reloadData()
                        Utils.removeShadow(view: self.view)
                       //  Utils.toastmsg(message:message,view: self.view)
                    }else{
                        Utils.removeShadow(view: self.view)
                        Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view:self.view)
                    }
                }
            }else{
                
            }
        }
    }
    
    
    func approveLeave(leave:LeaveStatus , status:Bool){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["Approve"] = status
        param["TransactionID"] = leave.transactionID
        let leavedate = Utils.getDateUTCWithAppendingDay(day: 0, date: leave.date, format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)
        let arrOfDate = [leavedate]
        param["LeaveDates"] =  Common.json(from: arrOfDate)
        param["MemberID"] = leave.leavestatususer.entity_id
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
    func withdrawLeave(obj:LeaveStatus){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["Status"] = obj.status
        let leavedate = Utils.getDateUTCWithAppendingDay(day: 0, date: obj.date, format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)
        let arrOfDate = [leavedate]
        param["LeaveDates"] =  Common.json(from: arrOfDate)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlWithDrawLeave, method: Apicallmethod.post){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
       
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(message)
                Utils.toastmsg(message: message, view: self.view)
                self.loadData()
            }else{
                print(error.localizedDescription)
                Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view:self.view)
            }
        
        }
    }
    // MARK: - IBAction
        
    
    @IBAction func btnExportClicked(_ sender: UIButton) {
        
      //  let calender = Calendar.init
        let currentdate = Date()
        let currentyear =  currentdate.getCurrentYear()
        SVProgressHUD.show()
        if(self.createCSVFileForLeave(year: currentyear)){
            SVProgressHUD.dismiss()
            Utils.toastmsg(message: "Your file has been created successfully", view: self.view)
        }else{
            SVProgressHUD.dismiss()
            Utils.toastmsg(message: "Some error occurred while creating file", view: self.view)
        }
        
    }
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        self.openOnlyMonthDatePicker(view: self.view, dateType: .date, tag: 0, datepicker: datepickerLeave, textfield: nil, withDateMonth: true)
    }
    
    
    @IBAction func btnReloadClicked(_ sender: UIButton) {
        SVProgressHUD.show()
        self.arrOfLeaveStatus = LeaveStatus.getLeavesbyMember(memberID: self.memeberID ?? self.activeuser?.userID ?? NSNumber.init(value: 0))
        tblAppliedLeave.reloadData()
        SVProgressHUD.dismiss()
    }
    
    
    /*
    // MARK: - Navigation

     @IBAction func btnAddLeaveClicked(_ sender: UIButton) {
     }
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: IBAction
    @IBAction func btnAddLeaveClicked(_ sender: UIButton) {
        
        if  let applyleaveobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLeave
                                                           , classname: Constant.ApplyLeave) as? ApplyLeaveController{
         
            self.navigationController?.pushViewController(applyleaveobj, animated: true)
       }
        
    }
    

}
extension LeavesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfLeaveStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.LeaveCell, for: indexPath) as? LeaveStatusCell{
            cell.vwAccept.isHidden = true
            cell.vwReject.isHidden = true
            cell.selectionStyle = .none
            
            cell.delegate = self
            cell.contentView.backgroundColor = UIColor.lightBackgroundColor
            let selectedLeavestatus = self.arrOfLeaveStatus[indexPath.row]
          
            if(selectedLeavestatus.status.lowercased() == "pending"){
               
                if(selectedLeavestatus.leavestatususer.entity_id == self.activeuser?.userID?.int32Value){
                    cell.btnWithDraw.isHidden = false
                    cell.vwAccept.isHidden = true
                    cell.vwReject.isHidden = true
                }else{
                    cell.btnWithDraw.isHidden = true
                    cell.vwAccept.isHidden = false
                    cell.vwReject.isHidden = false
                }
            }else{
                if(selectedLeavestatus.leavestatususer.entity_id == self.activeuser?.userID?.int32Value){
                    if(selectedLeavestatus.status.lowercased() == "reject" || selectedLeavestatus.status.lowercased() == "withdrawn" || selectedLeavestatus.status.lowercased() ==  "cancelled"){
                cell.btnWithDraw.isHidden = true
                    }
                else{
                    if(selectedLeavestatus.leavestatususer.entity_id == self.activeuser?.userID?.int32Value){
                    cell.btnWithDraw.isHidden = false
                    }else{
                        cell.btnWithDraw.isHidden = true
                    }
//                    if(selectedLeavestatus.leavestatususer.entity_id == self.activeuser?.userID?.int32Value){
//                    cell.btnWithDraw.isHidden = false
//                    }else{
//                        cell.btnWithDraw.isHidden = true
//                    }
                }
                }else{
                    cell.btnWithDraw.isHidden = true
                }
                cell.vwAccept.isHidden = true
                cell.vwReject.isHidden = true
            }
            var username = ""
            if let fname = selectedLeavestatus.leavestatususer.firstName{
                username.append(fname)
            }
            if let lname = selectedLeavestatus.leavestatususer.lastName{
                if(username.count > 0){
                    username.append(" ")
                }
                username.append(lname)
            }
            cell.lblUserName.text = username
            cell.lblLeaveType.text = selectedLeavestatus.type
            cell.lblAppliedDate.text = Utils.getDateWithAppendingDay(day: 0, date: selectedLeavestatus.date, format: "dd MMM yyyy", defaultTimeZone: true)// [Utils getDateWithAppendingMonth:0 Date:leaveObj.date andFormat:@"dd MMM"]selectedLeavestatus.date
            cell.imgUser.makeImgRound()
            cell.imgUser.sd_setImage(with:  URL.init(string: (selectedLeavestatus.leavestatususer.picture?.replacingOccurrences(of: " ", with: "%20").trimString) as? String ?? "")  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
           
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
               cell.parentView.backgroundColor = UIColor.graphDarkCyanColor
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
        let selectedleavestatus =  self.arrOfLeaveStatus[indexPath.row]
        if let leaveDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLeave, classname: Constant.LeaveDetail) as? LeaveDetailController{
            leaveDetail.leaveobj = selectedleavestatus
            leaveDetail.fromNotification = false
            leaveDetail.modalPresentationStyle = .overCurrentContext
            leaveDetail.view.center = self.view.center
            Utils.addShadow(view: self.view)
            self.present(leaveDetail, animated: true, completion: nil)
        }
    }
    
}
extension LeavesViewController:BaseViewControllerDelegate{
    func datepickerSelectionDone(){
        datepickerLeave.removeFromSuperview()
        SVProgressHUD.show()
        let selectedmonth = datepickerLeave.date.getCurrentMonth()
        self.arrOfLeaveStatus = self.arrOfLeaveStatus.filter({ (obj) -> Bool in
            obj.date.getCurrentMonth() == selectedmonth
        })
        tblAppliedLeave.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func cancelbtnTapped() {
        datepickerLeave.removeFromSuperview()
        }
}
extension LeavesViewController:LeaveStatusDelegate{
    func withdrawClicked(cell: LeaveStatusCell) {
       
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
            if let selectedindexpath = self.tblAppliedLeave.indexPath(for: cell) as? IndexPath{
            let selectedleave = self.arrOfLeaveStatus[selectedindexpath.row]
            self.withdrawLeave(obj: selectedleave)
            }
        }
        Common.showalert(title: "SuperSales" , msg: "Are you sure you want to withdraw this leave", yesAction: yesAction, noAction: noAction, view: self)
    }
    
    func approvebtnClicked(cell: LeaveStatusCell) {
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
            if let selectedindexpath = self.tblAppliedLeave.indexPath(for: cell) as? IndexPath{
                let selectedleave = self.arrOfLeaveStatus[selectedindexpath.row]
                self.approveLeave(leave: selectedleave, status: true)
            }
        }
        Common.showalert(title: "SuperSales" , msg: "Are you sure you want to approve this leave", yesAction: yesAction, noAction: noAction, view: self)
    }
    
    func rejectClicked(cell: LeaveStatusCell) {
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
            if let selectedindexpath = self.tblAppliedLeave.indexPath(for: cell) as? IndexPath{
                let selectedleave = self.arrOfLeaveStatus[selectedindexpath.row]
                self.approveLeave(leave: selectedleave, status: false)
            }
        }
        Common.showalert(title: "SuperSales" , msg: "Are you sure you want to reject this leave", yesAction: yesAction, noAction: noAction, view: self)
    }
    
    
}
