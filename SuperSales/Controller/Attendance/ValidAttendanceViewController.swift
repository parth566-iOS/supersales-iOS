//
//  ValidAttendanceViewController.swift
//  SuperSales
//
//  Created by mac on 07/05/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import MonthYearPicker
import SVProgressHUD

class ValidAttendanceViewController: BaseViewController {

    //MARK: Outlet
    @IBOutlet weak var lblErrorMsg: UILabel!
   
    @IBOutlet weak var tblValidAttendance: UITableView!
    
    @IBOutlet weak var btnSelectedDate: UIButton!
    
    
    @IBOutlet weak var lblUsername: UILabel!
    
    
    
    
    //MARK: Variable
    var datepickerAttendanceUserHistory:MonthYearPickerView!
    var selectedDate:Date!
    var selectedDateStr:String!
    var arrOFValidAttendance:[ValidAttendance] = [ValidAttendance]()
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadData()
    }

    //MARK: Method
    func setUI(){
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.title = "Valid Attendance"
        var strusername = ""
        if let firstname = self.activeuser?.firstName{
            strusername.append(firstname)
        }
        if let lastname = self.activeuser?.lastName{
            if(strusername.count > 0){
                strusername.append(" \(lastname)")
            }else{
                strusername.append(lastname)
            }
        }
        self.lblUsername.text = strusername
        self.lblErrorMsg.text = "Valid Attendance history fetched sucessfully"
      
        
        datepickerAttendanceUserHistory = MonthYearPickerView.init()
        
        datepickerAttendanceUserHistory = MonthYearPickerView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        datepickerAttendanceUserHistory.maximumDate = Date()
       
        selectedDate = Date()
        selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "yyyy/MM/dd", defaultTimeZone: true)
        btnSelectedDate.setTitle(Utils.getDateWithAppendingDay(day: 0, date: selectedDate, format: "MMM,yyyy", defaultTimeZone: true), for: .normal)
        
        self.salesPlandelegateObject = self
        tblValidAttendance.setCommonFeature()
        tblValidAttendance.delegate = self
        tblValidAttendance.dataSource = self
        tblValidAttendance.separatorStyle = .none
    }
    func popUpController(deviationID:Int,selectedDate:String)
    {

        let alertController = UIAlertController(title: "Request Deviation", message: nil, preferredStyle: UIAlertController.Style.alert)

//        let margin:CGFloat = 8.0
//        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 100.0)
//        let customView = UITextView(frame: rect)
//
//        customView.backgroundColor = UIColor.white
//        customView.font = UIFont(name: "Helvetica", size: 15)
//        customView.text = "Reason"
//        customView.delegate = self

        alertController.addTextField { (tfreason) in
            tfreason.placeholder = "Reason"
        }
        //  customView.backgroundColor = UIColor.greenColor()
        //alertController.view.addSubview(customView)

        let somethingAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in print("something")
            let textField = alertController.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text)")
            if(textField.text?.count == 0){
                Utils.toastmsg(message: "Please enter reason for request deviation", view: self.view)
            }else{
                self.requestDeviation(deviationId:deviationID, reson: textField.text ?? "", selectedDate: selectedDate)
            }

        })

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})

        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion:{})


    }
    //MARK: APICall
    func loadData(){
        SVProgressHUD.show()
      //  var param = Common.returndefaultparameter()
        var param = [String:Any]()
        param["MemberID"] = self.activeuser?.userID
        param["Month"] = selectedDate.getCurrentMonth()
        param["Year"] = selectedDate.getCurrentYear()
        param["CompanyID"] = self.activeuser?.company?.iD
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetValidAttendace, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let arrOfValidAttendance = arr as? [[String:Any]] ?? [[String:Any]]()
                print("arr is = \(arrOfValidAttendance)")
                if(arrOfValidAttendance.count > 0){
                    self.arrOFValidAttendance = [ValidAttendance]()
                    for dic in arrOfValidAttendance{
                        let validAttendanceobj = ValidAttendance.init(dictionary: dic as NSDictionary)
                        self.arrOFValidAttendance.append(validAttendanceobj)
                    }
                    self.tblValidAttendance.reloadData()
                    self.tblValidAttendance.isHidden = false
                    self.lblErrorMsg.isHidden =  true
                }else{
                    self.tblValidAttendance.isHidden = true
                    self.lblErrorMsg.isHidden = false
                }
            }else{
                if(error.code == 0){
                    Utils.toastmsg(message: message, view:self.view)
                }else{
                Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String
                                ?? "", view: self.view)
                }
            }
        }
    }
    func requestDeviation(deviationId:Int,reson:String,selectedDate:String){
        SVProgressHUD.show()
        var param =  Common.returndefaultparameter()
        param["ID"] = deviationId
        param["Description"] = reson
        param["UserID"] = self.activeuser?.userID
        param["CompanyID"] =  self.activeuser?.company?.iD
        self.dateFormatter.dateFormat = "yyyy/MM/dd"
//        param["MemberID"] = self.activeuser?.userID 
        param["Date"] = selectedDate//self.dateFormatter.date(from: selectedDate)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetValidAtteApprove, method: .post){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
            in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                Utils.toastmsg(message: message, view:self.view)
                self.loadData()
            }else{
                if(error.code == 0){
                    Utils.toastmsg(message: message, view:self.view)
                }else{
                Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String
                                ?? "", view: self.view)
                }
            }
        }
 
    }
    //MARK: IBAction
    
    
     @IBAction func btnSelectedDateClicked(_ sender: UIButton) {
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
extension ValidAttendanceViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOFValidAttendance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let validattendancecell = tableView.dequeueReusableCell(withIdentifier: "validattendancecell", for: indexPath) as? ValidAttendanceCell{
            validattendancecell.selectionStyle = .none
         
            validattendancecell.validatedelegate = self
            let selectedvalidattendance = arrOFValidAttendance[indexPath.row]
            print("valid attendance object = \(selectedvalidattendance)")
            self.dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
            let date  =  self.dateFormatter.date(from: selectedvalidattendance.date)//(selectedvalidattendance.date
            self.dateFormatter.dateFormat = "dd MMM EEE"
            validattendancecell.lblDate.text = self.dateFormatter.string(from: date ?? Date())
            validattendancecell.lblTotalVisitValue.text = String.init(format: "\(selectedvalidattendance.totalVisit)")
            if(selectedvalidattendance.status.lowercased() == "present"){
                validattendancecell.lblValidVisitValue.text  = String.init(format:"\(selectedvalidattendance.validVisit)")
                validattendancecell.btnDeviation.isHidden = true
                validattendancecell.lblUserFLetter.backgroundColor = .green
                validattendancecell.lblUserFLetter.text = "P"
            }else {
                
                
                if(selectedvalidattendance.deviationApproved ==  1){
                    validattendancecell.lblValidVisitValue.text  = String.init(format:"\(selectedvalidattendance.validVisit)")
                    validattendancecell.btnDeviation.isHidden = true
                    validattendancecell.lblUserFLetter.backgroundColor = UIColor.yellow
                    validattendancecell.lblUserFLetter.text = "D"
                }else{
                    validattendancecell.lblValidVisitValue.text  = String.init(format:"\(selectedvalidattendance.validVisit)")
                validattendancecell.btnDeviation.isHidden = false
                    validattendancecell.lblUserFLetter.backgroundColor = UIColor.red
                    if(selectedvalidattendance.status.lowercased() == "present"){
                    validattendancecell.lblUserFLetter.text = "P"
                    }else{
                        validattendancecell.lblUserFLetter.text = "A"
                    }
                }
            }
//            }else{
//                validattendancecell.lblValidVisitValue.text  = "P"
//                validattendancecell.btnDeviation.isHidden = true
//                validattendancecell.lblUserFLetter.backgroundColor = .green
//            }
            

            print(selectedvalidattendance)
            
            return validattendancecell
        }else{
        return UITableViewCell()
        }
    }
    
    
}
extension ValidAttendanceViewController:ValidAttendancellDelegate{
    func requestDevliationClicked(cell: ValidAttendanceCell) {  if let indexpath  =  tblValidAttendance.indexPath(for: cell) as? IndexPath{
        let selectedvalidattendance = arrOFValidAttendance[indexpath.row]
        self.dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        let date  =  self.dateFormatter.date(from: selectedvalidattendance.date)//(selectedvalidattendance.date
        self.dateFormatter.dateFormat = "yyyy/MM/dd"
        let strselecteddate =  self.dateFormatter.string(from: date ?? Date())
        
        self.popUpController(deviationID:selectedvalidattendance.id, selectedDate: strselecteddate)
    }
      
    }
    
    func viewvalidationClicked(cell: ValidAttendanceCell) {
        if let indexpath  =  tblValidAttendance.indexPath(for: cell) as? IndexPath{
            let selectedvalidattendance = arrOFValidAttendance[indexpath.row]
        if let reportview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ReportList) as? Reports{
            SVProgressHUD.show()
            selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerAttendanceUserHistory.date, format: "yyyy/MM/dd", defaultTimeZone: true)
            reportview.selectedUserID =  NSNumber.init(value:selectedvalidattendance.userID)
            Reports.selectedDate = selectedDateStr
            reportview.isFromValidAttendance = true
            reportview.isHome = false
            SVProgressHUD.dismiss()
            self.navigationController?.pushViewController(reportview, animated: true)
        }
        }
    }
    
    
}
extension ValidAttendanceViewController:BaseViewControllerDelegate{
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
extension ValidAttendanceViewController:UITextViewDelegate{
    
}
