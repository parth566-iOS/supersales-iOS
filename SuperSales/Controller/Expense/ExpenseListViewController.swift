//
//  ExpenseListViewController.swift
//  SuperSales
//
//  Created by Apple on 06/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import MonthYearPicker

class ExpenseListViewController: BaseViewController {
    
    var arrExpense:[UserExpense]! = [UserExpense]()
    var isMemberExpense:Bool!
    var datepickerExpense:MonthYearPickerView!
    var selectedDate:Date!
    var selectedDateStr:String!
    let refreshControl = UIRefreshControl.init()
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var btnDateMonth: UIButton!
    @IBOutlet weak var tblExpense: UITableView!
 //   @IBOutlet weak var btnAddExpense: UIButton!
    
    @IBOutlet weak var lblErrMsg: UILabel!
    override func viewDidLoad() {
        self.selectedDate = Date()
        DispatchQueue.main.async {
            super.viewDidLoad()
           
            self.setUI()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
        self.loadData()
        }
        if(arrExpense.count > 0 && tblExpense.visibleCells.count > 0){
        self.tblExpense.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    }
   
    // MARK: - Method
    func setUI(){
        if #available(iOS 10.0, *) {
           self.tblExpense.refreshControl = self.refreshControl
        } else {
           self.tblExpense.addSubview(self.refreshControl)
        }
self.refreshControl.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        tblExpense.estimatedRowHeight = 300.0
        tblExpense.rowHeight = UITableView.automaticDimension
        tblExpense.tableFooterView = UIView()
        tblExpense.separatorColor = UIColor.clear
        //selected_date = [NSDate date];
        tblExpense.delegate = self
        tblExpense.dataSource = self
        
        datepickerExpense = MonthYearPickerView.init()
 
        datepickerExpense = MonthYearPickerView.init(frame:CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        datepickerExpense.maximumDate = Date()
               self.salesPlandelegateObject = self
             
        selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "yyyy/MM/dd", defaultTimeZone: true)
        btnDateMonth.setTitleColor(UIColor.Appthemecolor, for: UIControl.State.normal)
        btnDateMonth.setrightImage()
               btnDateMonth.setTitle(Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "MMM,yyyy", defaultTimeZone: true), for: .normal)
        lblErrMsg.setMultilineLabel(lbl: lblErrMsg)
//        if(isMemberExpense){
//            btnAddExpense.isHidden = true
//        }else{
//            btnAddExpense.isHidden = false
//        }
       
    }
    
    //MARK: API Call
    @objc func loadData(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["Month"] = selectedDate.getCurrentMonth()
        param["Year"] = selectedDate.getCurrentYear()
       // param["Status"] = "All"
        var strurl = ""
        if(isMemberExpense){
            strurl = ConstantURL.kWSUrlGetMemberExpenses//
        }else{
            strurl = ConstantURL.kWSUrlGetUserExpenses
        }
     
        self.apihelper.getdeletejoinvisit(param: param, strurl:strurl, method: Apicallmethod.get) { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            self.refreshControl.endRefreshing()
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let arrOfExpense  = arr as? [[String:Any]] ?? [[String:Any]]()
                if(message.count > 0){
                lblErrMsg.text = message
                }else{
                    lblErrMsg.text = error.localizedDescription
                }
                self.arrExpense = [UserExpense]()
                if(arrOfExpense.count > 0){
                for expense in arrOfExpense{
                  //  let objexpense = UserExpense(dictionary: expense as NSDictionary)
                    let objexpense = UserExpense().initwithdic(dict: expense)
                    self.arrExpense.append(objexpense)
                }
                self.tblExpense.reloadData()
                    tblExpense.isHidden = false
                    lblErrMsg.isHidden = true
                }else{
                    self.tblExpense.reloadData()
                    tblExpense.isHidden = true
                    lblErrMsg.isHidden = false
                }
            }else if(error.code == 0){
                self.dismiss(animated: true, completion: nil)
                         if ( message.count > 0 ) {
                            Utils.toastmsg(message: message, view: self.view)
                }
                     }else{
                self.dismiss(animated: true, completion: nil)
                        Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                     
                     }
        }
    }
    
   
    // MARK: - IBAction
    
    
    @IBAction func btnMonthClicked(_ sender: UIButton) {
      
        self.openOnlyMonthDatePicker(view: self.view, dateType: .date, tag: 0, datepicker: datepickerExpense, textfield: nil, withDateMonth: true)
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
extension ExpenseListViewController:BaseViewControllerDelegate{
     func datepickerSelectionDone(){
        datepickerExpense.removeFromSuperview()
        /*
         selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "yyyy/MM/dd")
         btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendance.date, format: "dd MMM,yyyy"), for: .normal)
         
        lblDay.text = Utils.getDateWithAppendingDayLang(day: 0, date: selectedDate, format: "EEE")
         
         selectedDate =  Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
         
         selec_date = [Utils getDateWithAppendingMonth:1 Date:selected_date andFormat:@"yyyy/MM/dd"];
         selected_date = [Utils getDateFromString:selec_date];
         **/
    selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerExpense.date, format: "yyyy/MM/dd", defaultTimeZone: true)
        btnDateMonth.setTitle(Utils.getDateWithAppendingDay(day: 0, date: datepickerExpense.date, format: "MMM,yyyy", defaultTimeZone: true), for: .normal)
   
        
        
        selectedDate =  Utils.getDateFromString(date: selectedDateStr)
            //Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
        print(selectedDate)
        
        //Utils.getDateFromStringWithFormat(gmtDateString: selectedDateStr)
            self.loadData()
//Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepickerAttendance.date)         //btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepickerAttendanceUserHistory.date), for: .normal)
        }
    func cancelbtnTapped() {
           datepickerExpense.removeFromSuperview()
        }
}

extension ExpenseListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrExpense.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "expensecell", for: indexPath) as? ExpenseCell{
        
               if  let expense = arrExpense[indexPath.row] as? UserExpense{
                cell.vwParent.addBorders(edges: [.left,.top,.right,.bottom], color: UIColor.black, cornerradius: 3)
                
                self.dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
                let datestart = self.dateFormatter.date(from: expense.startDate)
                let dateend =  self.dateFormatter.date(from: expense.endDate)
                //2021/07/07 00:00:00
                self.dateFormatter.dateFormat = "dd/MM/yyyy"
                cell.selectionStyle = .none
                cell.lblTo.text = dateFormatter.string(from: dateend ?? Date())
                cell.lblFrom.text = dateFormatter.string(from: datestart ?? Date())
               var strreqamount = "Amount: "
                strreqamount.append(String(format:"%.2f",expense.totalExpenseRequested.doubleValue))
                cell.lblAmount.text = strreqamount
                cell.lblExpenseFrom.text = String.init(format:"\(expense.user.firstName ?? " ") \(expense.user.lastName ?? " ")")
              
               
                cell.btnWithdraw.tag = indexPath.row
                cell.btnReject.tag = indexPath.row
                cell.btnWithdraw.addTarget(self, action: #selector(withDrawOrAccept), for: UIControl.Event.touchUpInside)
                cell.btnReject.addTarget(self, action: #selector(rejectexpense), for: UIControl.Event.touchUpInside)
               
                
                if(self.activeuser?.userID == expense.user.userID){
                    cell.vwExpenseFrom.isHidden = false
                    cell.btnReject.isHidden = true
                    cell.btnWithdraw.isHidden = true
                    if(expense.status == "Pending"){
                        cell.btnReject.isHidden = true
                        cell.btnWithdraw.isHidden = false
                        cell.btnWithdraw.setTitle("Withdraw", for: UIControl.State.normal)
                        cell.btnWithdraw.setTitle("Withdraw", for: UIControl.State.selected)
                        cell.vwExpenseFrom.backgroundColor = UIColor.graphYellowColor//UIColor(red: 249.0/255.0, green: 212.0/255.0, blue: 92.0/255.0, alpha: 1.0)
                    }else if(expense.status == "Accept"){
                        
                        cell.vwExpenseFrom.backgroundColor = UIColor.graphGreenColor
                        
                        
                    }else if(expense.status == "Reject"){
                        cell.vwExpenseFrom.backgroundColor = UIColor.red
                    }else if(expense.status == "Withdraw"){
                        cell.vwExpenseFrom.backgroundColor = UIColor.gray
                    }else{
                        cell.vwExpenseFrom.backgroundColor = UIColor.systemOrange
                    }
                }else {
                    
                 if(expense.status == "Pending"){
                    cell.btnReject.isHidden = false
                    cell.btnWithdraw.isHidden = false
                    cell.btnWithdraw.setTitle("Accept", for: UIControl.State.normal)
                    cell.btnWithdraw.setTitle("Accept", for: UIControl.State.selected)
                    cell.btnReject.setTitle("Reject", for: UIControl.State.normal)
                    cell.btnReject.setTitle("Reject", for: UIControl.State.selected)
                    cell.vwExpenseFrom.backgroundColor =  UIColor.graphYellowColor//UIColor(red: 249.0/255.0, green: 212.0/255.0, blue: 92.0/255.0, alpha: 1.0)
                }else if(expense.status == "Accept"){
                    cell.btnReject.isHidden = true
                    cell.btnWithdraw.isHidden = true
                    cell.vwExpenseFrom.backgroundColor = UIColor.graphGreenColor//UIColor.green
                }else if(expense.status == "Reject"){
                    cell.btnReject.isHidden = true
                    cell.btnWithdraw.isHidden = true
                    cell.vwExpenseFrom.backgroundColor = UIColor.red
                }else if(expense.status == "Withdraw"){
                    cell.btnReject.isHidden = true
                    cell.btnWithdraw.isHidden = true
                    cell.vwExpenseFrom.backgroundColor = UIColor.gray
                }else{
                    cell.btnReject.isHidden = true
                    cell.btnWithdraw.isHidden = true
                    cell.vwExpenseFrom.backgroundColor = UIColor.orange
                }
                }
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let expense = arrExpense[indexPath.row]
            if let addexp = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.AddExpense) as? AddExpenseViewController{
                addexp.fromNotification = false
                addexp.iseditExpense = true
                addexp.editableExpense = expense
                self.navigationController?.pushViewController(addexp, animated: true)
            }
            
        
    }
    @objc func rejectexpense(sender:UIButton){
        let btnposition = sender.convert(CGPoint.zero, to: tblExpense)
        let yesaction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
        
            if let indexpath = self.tblExpense.indexPathForRow(at: btnposition) as? IndexPath{
            
        let userexpense = self.arrExpense[indexpath.row]
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            param["TransactionID"] = userexpense.transactionID
            param["isApproved"] = false
            param["ExpenseID"] = userexpense.expenseId
            //param["ExpenseJSON"] =
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveRejectExpense, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    self.arrExpense.remove(at: indexpath.row)
                    userexpense.status = "Reject"
                    
                    self.loadData()
                    if ( message.count > 0 ) {
                        Utils.toastmsg(message:message,view: self.view)
                  
                }
                    self.tblExpense.reloadData()
                }else if(error.code == 0){
                    self.dismiss(animated: true, completion: nil)
                             if ( message.count > 0 ) {
                
                                Utils.toastmsg(message:message,view: self.view)
                }
                         }else{
                    self.dismiss(animated: true, completion: nil)
                            Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view: self.view)
                           
                         }
            }
        }
        }
        let noaction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        Common.showalert(title: "SuperSales", msg: "Are you sure want to reject this expense", yesAction: yesaction, noAction: noaction, view: self)
    }
    @objc func withDrawOrAccept(sender:UIButton){
        let btnposition = sender.convert(CGPoint.zero, to: tblExpense)
        var message = ""
        
        if let indexpath = tblExpense.indexPathForRow(at: btnposition) as? IndexPath{
            let userexpense = self.arrExpense[indexpath.row]
            if(sender.currentTitle == "Withdraw"){
                message = "Are you sure you want to Withdraw Expense?"
               
            }else{
                message = "Are you sure you want to accept this expense request for requested amount?"
            }
            let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
            let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
//                let userexpense = self.editableExpense//self.arrExpense[indexpath.row]
//                SVProgressHUD.setDefaultMaskType(.black)
//                SVProgressHUD.show()
//                    var param = Common.returndefaultparameter()
//                param["TransactionID"] = userexpense?.transactionID
//                    param["isApproved"] = false
//                param["ExpenseID"] = userexpense?.expenseId
//                    //param["ExpenseJSON"] =
//                    self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlWithdrawExpense, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
//                        SVProgressHUD.dismiss()
//                        if(status.lowercased() == Constant.SucessResponseFromServer){
//
//        //                    self.arrExpense.remove(at: indexpath.row)
//        //                    userexpense.status = "Reject"
//        //
//        //                    self.loadData()
//                            if ( message.count > 0 ) {
//                                Utils.toastmsg(message:message,view: self.view)
//
//                        }
//                            self.navigationController?.popViewController(animated: true)
//                        }else if(error.code == 0){
//                            self.dismiss(animated: true, completion: nil)
//                                     if ( message.count > 0 ) {
//
//                                        Utils.toastmsg(message:message,view: self.view)
//                        }
//                                 }else{
//                            self.dismiss(animated: true, completion: nil)
//                                    Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view: self.view)
//
//                                 }
//                    }
//
            
              
       
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
                
        if(sender.currentTitle != "Withdraw"){
           
        var param = Common.returndefaultparameter()
        param["TransactionID"] = userexpense.transactionID
//                if(isaccept){
        param["isApproved"] = true
//                }else{
//                    param["isApproved"] = false
//                }
        param["ExpenseID"] = userexpense.expenseId
        //param["ExpenseJSON"] =
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveRejectExpense, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                self.arrExpense.remove(at: indexpath.row)
//                if(isaccept){
                userexpense.status = "Aceept"
//                }else{
//                    userexpense.status = "Reject"
//                }
                self.loadData()
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                 
                }
                self.tblExpense.reloadData()
            }else if(error.code == 0){
                self.dismiss(animated: true, completion: nil)
                         if ( message.count > 0 ) {
                            Utils.toastmsg(message:message,view: self.view)
                }
                     }else{
                self.dismiss(animated: true, completion: nil)
                        Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                     }
        }
            }
        else{
               
                var param = Common.returndefaultparameter()
                param["ExpenseID"] = userexpense.expenseId
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlWithdrawExpense, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        self.arrExpense.remove(at: indexpath.row)
                        userexpense.status = "Withdraw"
                        
                        self.arrExpense.insert(userexpense, at: indexpath.row)
                        if ( message.count > 0 ) {
                 
                            Utils.toastmsg(message:message,view: self.view)
                }
                        self.tblExpense.reloadData()
                    }else if(error.code == 0){
                        self.dismiss(animated: true, completion: nil)
                                 if ( message.count > 0 ) {
                   
                                    Utils.toastmsg(message:message,view: self.view)
                }
                             }else{
                        self.dismiss(animated: true, completion: nil)
                                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                             }
                }
            }
            }
          
            Common.showalert(title: "SuperSales", msg: message, yesAction: yesAction, noAction: noAction, view: self)
        }
        }
}
