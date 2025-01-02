//
//  LeaveBalanceUpdateController.swift
//  SuperSales
//
//  Created by Apple on 20/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import FastEasyMapping


class LeaveBalanceUpdateController: BaseViewController {
    
    @IBOutlet weak var lblSickLeave: UILabel!
    
    @IBOutlet weak var lblOptionalLeave: UILabel!

    @IBOutlet weak var lblPaidLeave: UILabel!
    
    @IBOutlet weak var lblCausalLeave: UILabel!
    
    
    @IBOutlet weak var lblHoliday: UILabel!
    
    
    @IBOutlet weak var lblAbsent: UILabel!
    
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var tblLeaveBalance: UITableView!
    
    
   // var datepickerLeave:MonthYearPickerView!
    var selectedDate:Date!
    var selectedDateStr:String!
    var memeberID:NSNumber!
    var arrOfLeaveBalance:[LeaveBalance]!
    var arrOfLeaveStatus:[LeaveStatus]! = [LeaveStatus]()
    
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
        super.viewDidLoad()
        self.setUI()
        self.loadData()
        }
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Method
    func setUI(){
        NotificationCenter.default.addObserver(self,selector: #selector(loadData),
                                               name:Notification.Name(ConstantURL.BALANCE_UPDATE_NOTIFICATION),
                                               object: nil)
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
        lblAbsent.text = String.init(format: "ABSENT \n \("0.0 / 0.0")")
        lblHoliday.text = String.init(format: "HOLIDAY \n \("0.0 / 0.0")")
       
//        tblAppliedLeave.setCommonFeature()
//        tblAppliedLeave.delegate = self
//        tblAppliedLeave.dataSource = self
        
        
//        datepickerLeave = MonthYearPickerView.init()
//
//        datepickerLeave = MonthYearPickerView.init(frame:CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
//        datepickerLeave.maximumDate = Date()
//               self.salesPlandelegateObject = self
               selectedDate = Date()
               selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "yyyy/MM/dd", defaultTimeZone: true)
        if(self.memeberID == self.activeuser?.userID){
//            btnAddLeave.isHidden = false
//            btnAddLeave.isUserInteractionEnabled = true
        }else{
            self.title = "Leave Details"
            self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
            self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
            
//            btnAddLeave.isHidden = true
//            btnAddLeave.isUserInteractionEnabled = false
        }
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
            }
            
        }
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
//                                self.tblAppliedLeave.isHidden = true
//                                self.tblAppliedLeave.isUserInteractionEnabled = false
                            }else{
                                self.lblError.isHidden = true
//                                self.tblAppliedLeave.isHidden = false
//                                self.tblAppliedLeave.isUserInteractionEnabled = true
                            }
                        //    self.tblAppliedLeave.reloadData()
                         
                        
                        }
                       
                        if(self.arrOfLeaveStatus.count == 0){
                            self.lblError.isHidden = false
//                            self.tblAppliedLeave.isHidden = true
//                            self.tblAppliedLeave.isUserInteractionEnabled = false
                        }else{
                            self.lblError.isHidden = true
//                            self.tblAppliedLeave.isHidden = false
//                            self.tblAppliedLeave.isUserInteractionEnabled = true
                        }
                      //  self.tblAppliedLeave.reloadData()
                         Utils.toastmsg(message:message,view: self.view)
                    }else{
                        
                        Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view:self.view)
                    }
                }
            }else{
                
            }
        }
    }
    
    
    //MARK: - IBAction
    
    @IBAction func btnExportToExcellClicked(_ sender: UIButton) {
        
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
