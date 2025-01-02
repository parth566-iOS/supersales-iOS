//
//  ExcelReport.swift
//  SuperSales
//
//  Created by Apple on 01/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import MonthYearPicker


class ExcelReport: BaseViewController, BaseViewControllerDelegate {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tfReportType: UITextField!
    
    @IBOutlet weak var tfStartDate: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfEndDate: UITextField!
    
    @IBOutlet weak var vwStartDate: UIView!
    var datepickerLeave:MonthYearPickerView!
    @IBOutlet weak var vwEndDate: UIView!
    
    @IBOutlet weak var vwReportType: UIView!
    
    @IBOutlet weak var vwSelectSalesPerson: UIView!
    
    @IBOutlet weak var lblSelectedSalesPerson: UILabel!
    @IBOutlet weak var vwQuiz: UIView!
    
    @IBOutlet weak var vwsortBy: UIView!
    @IBOutlet weak var btnDate: UIButton!
    
    @IBOutlet weak var lblStartDate: UILabel!
    
    @IBOutlet weak var btnSalesperson: UIButton!
    
    @IBOutlet weak var btnSelectDocument: UIButton!
    
    @IBOutlet weak var tfDocumentType: UITextField!
    
    
    @IBOutlet weak var tblSelectedDocument: UITableView!
    
    
    @IBOutlet weak var tblSelectedDocumentHeight: NSLayoutConstraint!
    
    var tableViewHeight: CGFloat {
        tblSelectedDocument.layoutIfNeeded()
        return tblSelectedDocument.contentSize.height
    }
    
    let baseviewcontrollerobj = BaseViewController()
    var startDate:Date!
    var endDate:Date!
    var startDatedatepicker:UIDatePicker!
    var endDatePicker:UIDatePicker!
    var popup:CustomerSelection? = nil
    var reportType = 0
    var intDaterUser = 1
    var arrReportType = ["Cold Call", "Lead", "Proposal", "Sales Order", "Purchase Order","Invoice", "Sales Report", "Expense", "Visit", "Visit Stock","Visit Tertiary", "Document Quiz Report", "Customer/Vendor", "Feedback", "Attendance Report","Leave Report","Attendance Log Report","Tracking Report","Daily Movement Report","Activity Report"]
    
    var arrOfSelectedClass = [String]()
    var arrOfCat:[CategoryReport] = [CategoryReport]()
    var arrOfDocument:[Document] = [Document]()
    var arrOfSelectedDocument = [Document]()
    var isDocAvailable:Bool = false
    var userID = NSNumber.init(value: 0)
    var arrOfExecutive = [CompanyUsers]()
    var arrOfSelectedExecutive  = [CompanyUsers]()
    var arrOfCategoryName:[String] = [String]()
    var arrOfSelectedCategoryName:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Method
    func setUI(){
        // disable background while loading
        SVProgressHUD.setDefaultMaskType(.black)
        
        self.title = "Report"
        self.salesPlandelegateObject =  self
        baseviewcontrollerobj.setleftbtn(btnType: BtnLeft.menu, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.salesPlandelegateObject = self
        baseviewcontrollerobj.setparentview(control: self)
        baseviewcontrollerobj.salesPlandelegateObject = self
        startDatedatepicker = UIDatePicker()
        endDatePicker = UIDatePicker()
        startDatedatepicker.maximumDate = Date()
        endDatePicker.maximumDate = Date()
        startDatedatepicker.setCommonFeature()
        endDatePicker.setCommonFeature()
        
        startDatedatepicker.date = Date()
        endDatePicker.date = Date()
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        tfStartDate.delegate = self
        tfEndDate.delegate = self
        tfReportType.delegate = self
        tfEmail.delegate = self
        tfDocumentType.delegate = self
        
        tfStartDate.setCommonFeature()
        tfEndDate.setCommonFeature()
        tfReportType.setCommonFeature()
        tfEmail.setCommonFeature()
        tfDocumentType.setCommonFeature()
        
        
        
        //        tfStartDate.textRect(forBounds:bounds.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)))
        tfStartDate.inputView = startDatedatepicker
        tfEndDate.inputView = endDatePicker
        startDate = Utils.getNSDateWithAppendingDay(day: 0, date1: startDatedatepicker.date, format: "yyyy-MM-dd")//Date()
        endDate = Utils.getNSDateWithAppendingDay(day:  1 , date1: endDatePicker.date, format: "yyyy-MM-dd")
        /*
         startDt = [Utils getNSDateWithAppendingDay:-1 Date:datePicker.date andFormat:@"yyyy-MM-dd"];
         txtStartDate.text = [Utils getDateWithAppendingDay:0 Date:startDt andFormat:@"dd-MM-yyyy"];
         endDt = [Utils getNSDateWithAppendingDay:0 Date:datePicker.date andFormat:@"yyyy-MM-dd"];
         txtEndDate.text = [Utils getDateWithAppendingDay:0 Date:endDt andFormat:@"dd-MM-yyyy"];
         **/
        tfStartDate.text =  Utils.getDateWithAppendingDay(day: -1, date: startDatedatepicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)//dateFormatter.string(from: startDate)
        tfEndDate.text = Utils.getDateWithAppendingDay(day: 0, date: endDatePicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
        tfEmail.text = self.activeuser?.emailID
        tfEmail.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        
        tfStartDate.setrightImage(img: UIImage.init(named: "icon_calender")!)
        tfEndDate.setrightImage(img: UIImage.init(named: "icon_calender")!)
        tfReportType.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfDocumentType.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        //vwStartDate.setShadow()
        
        btnDate.isSelected = true
        vwsortBy.setShadow()
        vwStartDate.setShadow()
        vwEndDate.setShadow()
        vwReportType.setShadow()
        tfReportType.text =  arrReportType.first
        reportType = 0
        vwQuiz.isHidden = true
        vwSelectSalesPerson.isHidden = true
        btnSelectDocument.contentHorizontalAlignment =  .left
        
        let attributedcustomerHistory = NSAttributedString.init(string: "Select Document", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        self.btnSelectDocument.setAttributedTitle(attributedcustomerHistory, for: .normal)
        
        //        DispatchQueue.global(qos: .background).async {
        if(BaseViewController.staticlowerUser.count == 0){
            DispatchQueue.global(qos: .background).async {
                self.fetchuser{
                    (arrOfuser,error) in
                    self.arrOfExecutive = BaseViewController.staticlowerUser
                    if let currentuserid = self.activeuser?.userID{
                        if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                            if(!(self.arrOfExecutive.contains(currentuser))){
                                self.arrOfExecutive.append(currentuser)
                            }
                           
                        }
                    }

                }
            }
        }
        self.arrOfExecutive = BaseViewController.staticlowerUser
        if let currentuserid = self.activeuser?.userID{
            if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                if(!(self.arrOfExecutive.contains(currentuser))){
                    self.arrOfExecutive.append(currentuser)
                }
               
            }
        }
        //}
        arrOfCategoryName = arrOfCat.map({
            $0.categoryName
        })
        //        arrOfCategoryName = arrOfCat.map{
        //
        //        }
        tblSelectedDocument.delegate = self
        tblSelectedDocument.dataSource = self
        tblSelectedDocument.tableFooterView = UIView()
        tblSelectedDocument.separatorColor = UIColor.clear
        tblSelectedDocumentHeight.constant =  tableViewHeight
        tblSelectedDocument.isUserInteractionEnabled = false
        tblSelectedDocument.reloadData()
        datepickerLeave = MonthYearPickerView.init()
        
        datepickerLeave = MonthYearPickerView.init(frame:CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        
        datepickerLeave.maximumDate = Date()
    }
    
    func datepickerSelectionDone(){
        Utils.removeShadow(view: self.view)
        datepickerLeave.removeFromSuperview()
    }
    
    func cancelbtnTapped() {
        datepickerLeave.removeFromSuperview()
    }
    
    func updateConstraints(){
        tblSelectedDocument.layoutIfNeeded()
        tblSelectedDocumentHeight.constant =  tableViewHeight
        tblSelectedDocument.reloadData()
    }
    
    func checkValidation()->Bool{
        let calender = Calendar.init(identifier: .gregorian)
        let component = calender.dateComponents([.day] , from: startDate, to: endDate)
        if(startDate.isEndDateIsSmallerThanCurrent(firstDate: startDate, seconddate: endDate) && reportType != 12){
            Utils.toastmsg(message:"You can't select Start date after End date",view: self.view)
            return false
        }
        if(reportType == 11){
            
            if(component.day ?? 0 > 30){
                Utils.toastmsg(message:"You can generate 30 days document quiz report at a time",view: self.view)
                return false
            }
            if(!isDocAvailable){
                Utils.toastmsg(message:"Please select document",view: self.view)
                return false
            }
        }
        if(reportType == 6){
            if(component.day ?? 0 > 7){
                Utils.toastmsg(message:"You can generate only one week daily report at a time",view: self.view)
                return false
            }
        }
        if(reportType ==  18){
            if(component.day ?? 0 > 31){
                Utils.toastmsg(message:"You can generate only 30 days Visit distance report at a time",view: self.view)
                return false
            }
            
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            if(self.dateFormatter.string(from: endDate) == self.dateFormatter.string(from: Date())){
                Utils.toastmsg(message:"You can't generate today's date daily movement Report",view: self.view)
                return false
            }
            
        }
        if(reportType == 11){
            if(component.day ?? 0 > 30){
                Utils.toastmsg(message:"You can generate 30 days document quiz report at a time",view: self.view)
                return false
            }
            
            if(!isDocAvailable){
                Utils.toastmsg(message:"Please select document",view: self.view)
                return false
            }
        }
        if(reportType == 18 && userID == 0){
            Utils.toastmsg(message:"Please select user",view: self.view)
            return false
        }
        if(reportType == 17){
            if(component.day ?? 0 > 7){
                Utils.toastmsg(message:"You can generate only one week tracking report at a time",view: self.view)
                return false
            }
        }
        if(self.tfEmail.text?.count == 0){
            
            Utils.toastmsg(message:"Please enter email address",view: self.view)
            return false
        }else if(!(Utils.validateEmail(email: tfEmail.text ?? ""))){
            
            Utils.toastmsg(message:"Please enter valid email address",view: self.view)
            return false
        }
        else{
            return true
        }
    }
    
    func getCategoryList(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        let param = Common.returndefaultparameter()
//        print("paramaeter of Report = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetCategoryList, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                var arrOfCategory = arr as? [[String:Any]] ?? [[String:Any]]()
                let dicOfcat = ["categoryID":NSNumber.init(value: 0),"categoryName":"Latest"] as [String : Any]
                arrOfCategory.insert(dicOfcat, at: 0)
                for cat in arrOfCategory{
                    let catid = NSNumber.init(value:cat["categoryID"] as? Int ?? 0)
                    let catReport = CategoryReport.init(categoryID: catid, categoryName: cat["categoryName"] as? String ?? "")// CategoryReport().initCatrgoryWithDic(dic: cat)
                    self.arrOfCat.append(catReport)
                }
                self.arrOfCategoryName = self.arrOfCat.map({
                    $0.categoryName
                })
                if(self.arrOfCat.count == 0){
                    self.tfReportType.text = "No Document Category"
                }
                if let catname = self.arrOfCat.first?.categoryName as? String{
                    self.tfDocumentType.text = catname
                    self.getDocumentList(catId: self.arrOfCat.first?.categoryID ?? NSNumber.init(value: 0))
                }
                
                self.tfReportType.isUserInteractionEnabled = false
                
            }else if(error.code == 0){
                
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
                
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
    }
    func getDocumentList(catId:NSNumber){
        var param = Common.returndefaultparameter()
        param["CategoryID"] = catId
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        print("paramaeter of Report = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetDocumentList, method: Apicallmethod.get)
        { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            self.tfReportType.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let arrOfDoc = arr as? [[String:Any]] ?? [[String:Any]]()
                
                if(arrOfDoc.count == 0){
                    Utils.toastmsg(message:"No document found",view: self.view)
                }else{
                    self.arrOfDocument = [Document]()
                    for cat in arrOfDoc{
                        let catid = NSNumber.init(value:cat["categoryID"] as? Int ?? 0)
                        let catReport = Document.init(documentID:cat["documentID"] as? NSNumber ?? NSNumber.init(value:0), categoryID: catid, isQuizAvailable:cat["isQuizAvailable"] as? NSNumber ?? NSNumber.init(value:0), title:cat["title"] as? String ?? "", categoryName: cat["categoryName"]  as? String ?? "")// CategoryReport().initCatrgoryWithDic(dic: cat)
                        
                        self.arrOfDocument.append(catReport)
                    }
                }
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
    func generateExpenseReport(){
        SVProgressHUD.showInfo(withStatus: "Generating Expense Report")
        var param = Common.returndefaultparameter()
        param["ReportTypeID"] = reportType
        param["EmailID"] = tfEmail.text
        param["StartDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: startDate, format: "yyyy/MM/dd", defaultTimeZone: true))
        param["EndDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: endDate, format: "yyyy/MM/dd", defaultTimeZone: true))
        param["SortType"] = NSNumber.init(value: intDaterUser)
        param["CreatedBy"] = self.activeuser?.userID
        print("paramaeter of Report = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSURLGenerateExpenseReportForDates, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                Utils.toastmsg(message:"Expense report will be sent to your email address",view: self.view)
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
    func generateDocQuizReport(){
        //kWSURLGenerateQuizReport
        SVProgressHUD.showInfo(withStatus: "Generating Doc Quiz Report")
        var param = Common.returndefaultparameter()
        param["UserID"] = self.activeuser?.userID
        param["ReportTypeID"] = reportType
        param["EmailID"] = tfEmail.text
        param["StartDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: startDate, format: "yyyy/MM/dd", defaultTimeZone: true))
        param["EndDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: endDate, format: "yyyy/MM/dd", defaultTimeZone: true))
        param["SortType"] = NSNumber.init(value: intDaterUser)
        var docSelectedDoc = [[String:Any]]()
        for doc in arrOfSelectedDocument{
            var dic = [String:Any]()
            dic["documentID"] =  doc.documentID
            dic["title"] = doc.title
            dic["isQuizAvailable"] = doc.isQuizAvailable
            docSelectedDoc.append(dic)
        }
        var param1  = [String:Any]()
        param1["docSelectedDoc"] = docSelectedDoc
        param1["EmailID"] = tfEmail.text
        param1["companyID"] = self.activeuser?.company?.iD
        param["QuizJSON"] = Common.returnjsonstring(dic: param1)
        print("paramaeter of Report = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSURLGenerateQuizReport, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                Utils.toastmsg(message:"Customer/Vendor report will be sent to your email address",view:self.view)
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
    func generateCustomerVendorReport(){
        //kWSURLGenerateCustomerVendorReport
        SVProgressHUD.showInfo(withStatus: "Generating Customer/Vendor Report")
        var param = Common.returndefaultparameter()
        param["ReportTypeID"] = reportType
        param["Email"] = tfEmail.text
        param["StartDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: startDate, format: "yyyy/MM/dd", defaultTimeZone: true))
        param["EndDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: endDate, format: "yyyy/MM/dd", defaultTimeZone: true))
        param["SortType"] = NSNumber.init(value: intDaterUser)
        print("paramaeter of Report = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSURLGenerateCustomerVendorReport, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                Utils.toastmsg(message:"Customer/Vendor report will be sent to your email address",view:self.view)
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
    func generateFeedbackReport(){
        //kWSURLGenerateFeedbackReport
        SVProgressHUD.showInfo(withStatus: "Generating Feedback Report")
        var param = Common.returndefaultparameter()
        param["ReportTypeID"] = reportType
        param["Email"] = tfEmail.text
        param["StartDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: startDate, format: "yyyy/MM/dd", defaultTimeZone: true))
        param["EndDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: endDate, format: "yyyy/MM/dd", defaultTimeZone: true))
        param["SortType"] = NSNumber.init(value: intDaterUser)
        print("paramaeter of Report = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSURLGenerateFeedbackReport, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                Utils.toastmsg(message:"Feedback report will be sent to your email address",view:self.view)
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
    func generateReport(){
        SVProgressHUD.showInfo(withStatus: "Generating Report")
        var param = [String:Any]()
        param["ReportTypeID"] = reportType + 1
        param["Email"] = tfEmail.text
        param["EmailID"] = tfEmail.text
        param["StartDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: startDate, format: "yyyy/MM/dd", defaultTimeZone: true))
        param["EndDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: endDate, format: "yyyy/MM/dd", defaultTimeZone: true))
        param["SortType"] = NSNumber.init(value: intDaterUser)
        param["CreatedBy"] = self.activeuser?.userID
        param["CompanyID"] = self.activeuser?.company?.iD
        var timeObj = [String:Any]()
        if(self.reportType == 18){
            param["ReportTypeID"] = 28
        }
        if(self.reportType == 19){
            param["ReportTypeID"] = 25
        }
        if(self.reportType == 15){
            let calender = Calendar.current
            let dateComponent = calender.dateComponents([.day,.year,.month], from: self.startDate)
            timeObj["Month"] = dateComponent.month
            timeObj["Year"] = dateComponent.year
        }else{
            timeObj["StartDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: self.startDate, format: "yyyy/MM/dd", defaultTimeZone: true))
            timeObj["EndDate"] = String.init(format:"%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: self.endDate, format: "yyyy/MM/dd", defaultTimeZone: true))
            timeObj["UserID"] = self.activeuser?.userID
        }
        var mainparam = Common.returndefaultparameter()
        mainparam["getjson"] = Common.returnjsonstring(dic: param)
        mainparam["gettime"] = Common.returnjsonstring(dic: timeObj)
        print("paramaeter of Report = \(mainparam)")
        self.apihelper.getdeletejoinvisit(param: mainparam, strurl: ConstantURL.kWSURLGenerateExcelReport, method: Apicallmethod.get) {  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print("report type = \(self.reportType)")
                if(message.count > 0){
                    if ( message.count > 0 ) {
                         Utils.toastmsg(message:message,view: self.view)
                    }
                }else{
                    if (self.reportType == 0){
                        Utils.toastmsg(message:"ColdCall report will be sent to your email address",view:self.view)
                        //[self.view makeToast:@"ColdCall report will be sent to your email address"];
                    }else if (self.reportType == 1){
                        Utils.toastmsg(message:"Lead report will be sent to your email address",view:self.view)
                        //[self.view makeToast:@"Lead report will be sent to your email address"];
                    }else if (self.reportType == 2){
                        Utils.toastmsg(message:"Proposal report will be sent to your email address",view:self.view)
                        // [self.view makeToast:@"Proposal report will be sent to your email address"];
                    }else if (self.reportType == 3){
                        Utils.toastmsg(message:"Sales Order report will be sent to your email address",view:self.view)
                        //  [self.view makeToast:@"Sales Order report will be sent to your email address"];
                    }else if (self.reportType == 4){
                        Utils.toastmsg(message:"Purchase Order report will be sent to your email address",view:self.view)
                        //   [self.view makeToast:@"Purchase Order report will be sent to your email address"];
                    }else if (self.reportType == 5){
                        Utils.toastmsg(message:"Invoice report will be sent to your email address",view:self.view)
                    }else if (self.reportType == 6){
                        Utils.toastmsg(message:"Daily report will be sent to your email address",view:self.view)
                    }else if (self.reportType == 8){
                        Utils.toastmsg(message:"Visit report will be sent to your email address",view:self.view)
                    }else if (self.reportType == 9){
                        Utils.toastmsg(message:"Visit Stock report will be sent to your email address",view:self.view)
                    }else if (self.reportType == 10){
                        Utils.toastmsg(message:"Visit Tertiary report will be sent to your email address",view:self.view)
                    }else if (self.reportType == 14){
                        Utils.toastmsg(message:"Attendance report will be sent to your email address",view:self.view)
                    }else if (self.reportType == 15){
                        Utils.toastmsg(message:"Leave report will be sent to your email address",view:self.view)
                    }else if (self.reportType == 16){
                        Utils.toastmsg(message:"Attendance Log report will be sent to your email address",view:self.view)
                    }else if (self.reportType == 17){
                        Utils.toastmsg(message:"Tracking report will be sent to your email address",view:self.view)
                    }else if (self.reportType == 28){
                        Utils.toastmsg(message:"Visit Distance report will be sent to your email address",view:self.view)
                    }else if (self.reportType == 19){
                        Utils.toastmsg(message:"Activity report will be sent to your email address",view:self.view)
                    }
                }
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
    
    
    
    // MARK: - IBAction
    
    
    @IBAction func btnDocumentClicked(_ sender: UIButton) {
        // self.getDocumentList(catId: arrOfCat.first?.categoryID ?? NSNumber.init(value: 0))
        if(self.arrOfDocument.count == 0){
            Utils.toastmsg(message:"No Document Found",view:self.view)
        }else{
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.isFromSalesOrder =  false
            self.popup?.strTitle = "Select Document"
            self.popup?.mandatorydelegate = self
            self.popup?.parentViewOfPopup = self.view
            self.popup?.arrOfDocument = self.arrOfDocument
            self.popup?.arrOfSelectedDocument = self.arrOfSelectedDocument
            self.popup?.strLeftTitle = "OK"
            self.popup?.strRightTitle = "Cancel"
            self.popup?.selectionmode = SelectionMode.multiple
            self.popup?.isSearchBarRequire = false
            self.popup?.parentViewOfPopup = self.view
            self.popup?.viewfor = ViewFor.document
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            Utils.addShadow(view: self.view)
            self.present(self.popup!, animated: false, completion: nil)
            
        }
    }
    
    @IBAction func btnDateClicked(_ sender: UIButton) {
        intDaterUser = 1
        btnDate.isSelected = true
        btnSalesperson.isSelected  = false
    }
    
    @IBAction func btnSelectSalesPersonClicked(_ sender: UIButton) {
        if(BaseViewController.staticlowerUser.count > 0){
            
//            arrOfExecutive = BaseViewController.staticlowerUser.filter({ (user) -> Bool in
//                return user.entity_id != self.activeuser?.userID
//            })
            
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.parentViewOfPopup = self.view
            self.popup?.isFromSalesOrder =  false
            self.popup?.strTitle = "Select Sales Person"
            self.popup?.nonmandatorydelegate = self
            self.popup?.arrOfExecutive = arrOfExecutive//self.arrOfExecutive
            self.popup?.arrOfSelectedExecutive = arrOfSelectedExecutive//[String]()
            self.popup?.strLeftTitle = "OK"
            self.popup?.strRightTitle = "CANCEL"
            self.popup?.selectionmode = SelectionMode.single
            self.popup?.isSearchBarRequire = false
            self.popup?.viewfor = ViewFor.companyuser
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            self.popup?.parentViewOfPopup = self.view
            
            Utils.addShadow(view: self.view)
            self.present(self.popup!, animated: false, completion: nil)
        }else{
            Utils.toastmsg(message:"No user to assign",view:self.view)
        }
    }
    
    
    @IBAction func btnSalespersonClicked(_ sender: UIButton) {
        intDaterUser = 2
        
        btnDate.isSelected = false
        
        btnSalesperson.isSelected  = true
    }
    @IBAction func btnCreateClicked(_ sender: UIButton) {
        
        if(self.checkValidation()){
            if(reportType == 7){
                self.generateExpenseReport()
            } else if (reportType == 11){
                //generate Document Quiz report
                self.generateDocQuizReport()
            } else if (reportType == 12){
                //generate Customer/Vendor report
                self.generateCustomerVendorReport()
            } else if (reportType == 13){
                //generate Feedback report
                self.generateFeedbackReport()
            } else{
                self.generateReport()
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
extension ExcelReport:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfStartDate){
            if(reportType == 15){
                tfStartDate.inputView = datepickerLeave
                datepickerLeave.date = startDate
                var selectedDateStr = ""
                // self.openOnlyMonthDatePicker(view: self.view, dateType: .date, tag: 0, datepicker: datepickerAttendanceUserHistory, textfield: nil, withDateMonth: true)
                self.openOnlyMonthDatePicker(view: self.view, dateType: .date, tag: 0, datepicker: datepickerLeave, textfield: nil, withDateMonth: true)
                datepickerLeave.removeFromSuperview()
                
                selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerLeave.date, format: "yyyy/MM/dd", defaultTimeZone: true)
                textField.text = Utils.getDateWithAppendingDay(day: 0, date: datepickerLeave.date, format: "MMM,yyyy", defaultTimeZone: true)
                
                
                
                startDate =  Utils.getDateFromString(date: selectedDateStr)
            }else{
                tfStartDate.inputView = startDatedatepicker
                startDatedatepicker.date = startDate
                
                self.dateFormatter.dateFormat = "dd-MM-yyyy"
                startDatedatepicker.datePickerMode = .date
                startDatedatepicker.date = self.dateFormatter.date(from: tfStartDate.text!)!
                
                textField.text = dateFormatter.string(from: startDatedatepicker.date)
            }
            return true
            
        }else if(textField == tfEndDate){
            endDatePicker.date = endDate
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            endDatePicker.datePickerMode = .date
            endDatePicker.date = self.dateFormatter.date(from: tfEndDate.text!)!
            
            return true
        }else if(textField ==  tfReportType){
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.isFromSalesOrder =  false
            self.popup?.strTitle = "Select Report Type"
            self.popup?.nonmandatorydelegate = self
            self.popup?.parentViewOfPopup = self.view
            self.popup?.arrOfCustomerClass = self.arrReportType
            self.popup?.arrOfSelectedClass = self.arrOfSelectedClass
            self.popup?.strLeftTitle = ""
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.isSearchBarRequire = false
            self.popup?.parentViewOfPopup = self.view
            self.popup?.viewfor = ViewFor.customerClass
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            Utils.addShadow(view: self.view)
            self.present(self.popup!, animated: false, completion: nil)
            return false
            
        }else if(textField == tfDocumentType){
            
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.parentViewOfPopup = self.view
            self.popup?.isFromSalesOrder =  false
            self.popup?.strTitle = "Select Document Category"
            self.popup?.nonmandatorydelegate = self
            self.popup?.arrOfCustomerClass =  arrOfCategoryName  //BaseViewController.staticlowerUser//self.arrOfExecutive
            self.popup?.arrOfSelectedClass = arrOfSelectedCategoryName//arrOfSelectedExecutive//[String]()
            self.popup?.strLeftTitle = ""
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            self.popup?.isSearchBarRequire = false
            self.popup?.viewfor = ViewFor.customerClass
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            self.popup?.parentViewOfPopup = self.view
            
            Utils.addShadow(view: self.view)
            self.present(self.popup!, animated: false, completion: nil)
            return false
        }else if(textField == tfEmail){
            return true
        }else {
            return false
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == tfStartDate){
            if(reportType == 15){
                self.dateFormatter.dateFormat = "MMM,yyyy"
            }else{
                self.dateFormatter.dateFormat = "dd-MM-yyyy"
            }
            startDatedatepicker.date =  dateFormatter.date(from: tfStartDate.text ?? "") ?? Date()
            //datepicker.reloadInputViews()
        }else if(textField == tfEndDate){
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            endDatePicker.date = dateFormatter.date(from: tfEndDate.text ?? "") ?? Date()
            // datepicker.reloadInputViews()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfStartDate){
            if(reportType == 15){
                Utils.removeShadow(view: self.view)
                toolBar.removeFromSuperview()
                dateFormatter.dateFormat = "MMM,yyyy"
                startDate =     datepickerLeave.date
                tfStartDate.text = dateFormatter.string(from: datepickerLeave.date)
            }else{
                dateFormatter.dateFormat = "dd-MM-yyyy"
                startDate = startDatedatepicker.date
                tfStartDate.text = dateFormatter.string(from: startDatedatepicker.date)
            }
            
        }else if(textField == tfEndDate){
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            endDate = endDatePicker.date
            tfEndDate.text =  dateFormatter.string(from: endDatePicker.date)
            
            //
        }
    }
    
    
    
    
    func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
        return tableView.contentSize.height
    }
    
}

extension ExcelReport:PopUpDelegateMandatory{
    
    func completionSelectedBeatPlan(arr: [BeatPlan]) {
        
    }
    
    
    func completionSelectedDocument(arr:[Document]){
        isDocAvailable = true
        arrOfSelectedDocument = arr
        
        tblSelectedDocument.reloadData()
        self.updateConstraints()
    }
    
}
extension ExcelReport:PopUpDelegateNonMandatory{
    func completionSelectedClass(arr: [String], recordno: Int , strTitle:String) {
        Utils.removeShadow(view: self.view)
        if(strTitle == "Select Document Category"){
            arrOfSelectedCategoryName = arr
            tfDocumentType.text = arrOfSelectedCategoryName.first
            let selectedCat = arrOfCat[0]
            self.getDocumentList(catId: selectedCat.categoryID)
        }else{
            if let selectedreportType =  arr.first as? String{
                tfReportType.text = selectedreportType
                
                if((selectedreportType ==  "Attendance Log Report") || (selectedreportType ==  "Customer Report")){
                    vwSelectSalesPerson.isHidden = true
                    vwsortBy.isHidden = true
                }
            }
            reportType = recordno 
            print("report type = \(tfReportType.text) and record no = \(reportType)")
            switch reportType {
                
            case 11:
                //Document Quiz
                vwQuiz.isHidden = false
                vwEndDate.isHidden = false
                vwStartDate.isHidden = false
                vwsortBy.isHidden = true
                self.getCategoryList()
                break
                
                
                
            case 10:
                vwQuiz.isHidden = true
                vwEndDate.isHidden = false
                vwStartDate.isHidden = false
                vwSelectSalesPerson.isHidden = true
                vwsortBy.isHidden = false
                
                break
                
            case 12:
                vwQuiz.isHidden = true
                vwEndDate.isHidden = false
                vwStartDate.isHidden = false
                vwSelectSalesPerson.isHidden = true
                vwsortBy.isHidden = true
                break
                
            case 13:
                vwQuiz.isHidden = true
                vwSelectSalesPerson.isHidden = true
                vwEndDate.isHidden = false
                vwStartDate.isHidden = false
                vwsortBy.isHidden = false
                break
                
            case 14:
                vwQuiz.isHidden = true
                vwEndDate.isHidden = false
                vwStartDate.isHidden = false
                vwSelectSalesPerson.isHidden = true
                vwsortBy.isHidden = false
                break
                
                
            case 15:
                // Leave Report
                //  Select month and year
                self.lblStartDate.text = "Select Month and Year"
                
                //  var  selectedDateStr =  ""
                //  selectedDateStr =  Utils.getDateWithAppendingDay(day: 0, date: datepickerLeave.date, format: "yyyy/MM/dd")
                tfStartDate.text = Utils.getDateWithAppendingDay(day: 0, date: datepickerLeave.date, format: "MMM,yyyy", defaultTimeZone: true)
                
                dateFormatter.dateFormat = "MMM,yyyy"
                startDate = Date()
                vwQuiz.isHidden = true
                vwEndDate.isHidden = true
                vwStartDate.isHidden = false
                vwSelectSalesPerson.isHidden = true
                vwsortBy.isHidden = true
                break
                
            case 16:
                vwQuiz.isHidden = true
                vwEndDate.isHidden = false
                vwStartDate.isHidden = false
                vwSelectSalesPerson.isHidden = true
                vwsortBy.isHidden = true
                break
                
            case 17:
                // Tracking Report
                
                vwSelectSalesPerson.isHidden = true
                vwsortBy.isHidden = true
                vwQuiz.isHidden = true
                break
                
            case 18:
                vwQuiz.isHidden = true
                vwEndDate.isHidden = false
                vwStartDate.isHidden = false
                vwSelectSalesPerson.isHidden = false
                vwsortBy.isHidden = true
                break
            default:
                vwQuiz.isHidden = true
                vwEndDate.isHidden = false
                vwStartDate.isHidden = false
                vwSelectSalesPerson.isHidden = true
                vwsortBy.isHidden = false
                break
            }
            if(reportType ==  15){
                tfStartDate.inputView = datepickerLeave
            }else{
                tfStartDate.inputView = startDatedatepicker
                self.dateFormatter.dateFormat = "dd-MM-yyyy"
                tfStartDate.text = Utils.getDateWithAppendingDay(day: 0, date: startDatedatepicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
            }
        }
    }
    
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        arrOfSelectedExecutive =  arr
        if let selectedUser = arr.first{
            self.userID = selectedUser.entity_id
            lblSelectedSalesPerson.text = String.init(format: "Sales Person: %@ %@", selectedUser.firstName,selectedUser.lastName)
        }
        
    }
    
    
    
    
}
extension ExcelReport:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return   arrOfSelectedDocument.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: "selectedDocumentCell", for: indexPath) as? UITableViewCell{
            
            let selectedDoc = arrOfSelectedDocument[indexPath.row]
            
            cell.textLabel?.text = selectedDoc.title
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
}
