//
//  ApplyLeaveController.swift
//  SuperSales
//
//  Created by Apple on 20/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import MobileCoreServices
import UniformTypeIdentifiers
import Alamofire
import ObjectMapper

class ApplyLeaveController: BaseViewController {

    @IBOutlet weak var stckViewForLeaveType: UIStackView!
    
    @IBOutlet weak var stckViewForholiday: UIStackView!
    @IBOutlet weak var txtholidayName: UITextField!
    @IBOutlet weak var btnDeleteCerti: UIButton!
    @IBOutlet weak var btnCertiView: UIButton!
    @IBOutlet weak var lblCertiLink: UILabel!
    @IBOutlet weak var stckViewCerti: UIStackView!
    @IBOutlet weak var btnMedicalCerti: UIButton!
    @IBOutlet weak var stckMedicalView: UIStackView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var stkLeaveType: UIStackView!
    @IBOutlet weak var tfLeaveType: UITextField!
    
    @IBOutlet weak var tfHoiday: UITextField!
    @IBOutlet weak var stkOptionalHoliday: UIStackView!
    
    @IBOutlet weak var stkLeaveFromTill: UIStackView!
    @IBOutlet weak var lblFromTitle: UILabel!
    
    @IBOutlet weak var tfTillDate: UITextField!
    @IBOutlet weak var tfFromDate: UITextField!
    @IBOutlet weak var vwFrom: UIView!
    @IBOutlet weak var vwTill: UIView!
    
    @IBOutlet weak var tvReason: KTextView!
    
    @IBOutlet weak var btnHalfDay: UIButton!
    @IBOutlet weak var btnFullDay: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    var datepicker1:UIDatePicker! = UIDatePicker()
    var datepicker2:UIDatePicker! = UIDatePicker()
    var popup:CustomerSelection?
    var arrLeaveType = [String]()//Common.LeaveType
    var arrOfSelectedLeaveType = [String]()
    var arrOfSelectedHoliday = [String]()
    let account = Utils().getActiveAccount()
    let setting = Utils().getActiveSetting()
    var shiftID:Int = 0
    var arrOfHoliday:[String] = []
    var isHoliday = false
    var arrOfHoildayObj = [CompanyHolidays]()
    var medialCerti:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Method
    func setUI() {
        let title = "Add Medical Certificate"
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.btnMedicalCerti.setAttributedTitle(attributedTitle, for: .normal)
        let userDefaults = UserDefaults.standard
        
        if let shiftID = userDefaults.value(forKey: Constant.kUserShiftTiming) as? Int {
            self.shiftID = shiftID
        }
        
        var username = ""
        if let firstname = self.activeuser?.firstName{
            username.append(firstname)
        }
        if let lastname = self.activeuser?.lastName{
            username.append(lastname)
        }
        self.txtholidayName.addBorders(edges: [.bottom], color: UIColor.black, cornerradius: 0)
        self.tfLeaveType.addBorders(edges: [.bottom], color: UIColor.black, cornerradius: 0)
        self.tfTillDate.addBorders(edges: [.bottom], color: UIColor.black, cornerradius: 0)
        self.tfFromDate.addBorders(edges: [.bottom], color: UIColor.black, cornerradius: 0)
        self.getDynamicLeaveType() {
            self.getCompanyHoliday()
        }
        // self.tfLeaveType.setBottomBorder(tf: self.tfLeaveType, color: UIColor.black)
        // self.tvReason.setFlexibleHeight()
        
        self.lblUserName.text = username
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        self.btnSubmit.cornerRadius = 5.0
        self.title = "Apply Leaves"
        
        self.tfFromDate.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        self.tfTillDate.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        self.tfLeaveType.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        self.txtholidayName.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        //        self.tfLeaveType.text = arrLeaveType.first
        if LeavesType.SICK_LEAVE.rawValue.lowercased() == self.tfLeaveType.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
            self.stckMedicalView.isHidden = false
        }else {
            self.stckMedicalView.isHidden = true
        }
        
        if LeavesType.HOLIDAY.rawValue.lowercased() == self.tfLeaveType.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) || LeavesType.PUBLIC_HOLIDAY.rawValue.lowercased() == self.tfLeaveType.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
            self.stckViewForholiday.isHidden = false
        }else {
            self.stckViewForholiday.isHidden = true
        }
        
        self.tfTillDate.delegate = self
        self.tfLeaveType.delegate = self
        self.txtholidayName.delegate = self
        self.tfFromDate.delegate = self
        
        self.tfTillDate.setCommonFeature()
        self.tfLeaveType.setCommonFeature()
        self.tfFromDate.setCommonFeature()
        
        
        
        datepicker2.date = Date()
        datepicker1.date = Date()
        datepicker2.setCommonFeature()
        datepicker1.setCommonFeature()
        datepicker1.datePickerMode = .date
        datepicker2.datePickerMode  = .date
        
        self.dateFormatter.dateFormat = "dd MMM, yyyy"
        tfFromDate.text = self.dateFormatter.string(from: Date())
        tfTillDate.text = self.dateFormatter.string(from: Date())
        tvReason.delegate = self
        
        tvReason.placeholder = "Reason"
        tfFromDate.inputView = datepicker1
        tfTillDate.inputView = datepicker2
        //        btnFullDay.titleLabel?.textColor = UIColor.white
        //        btnFullDay.titleLabel?.text = "Full Day"
        //        btnHalfDay.titleLabel?.text = "Half Day"
        //        btnHalfDay.titleLabel?.textColor  = UIColor.gray
        //        btnFullDay.titleLabel?.textColor  = UIColor.gray
        //        btnFullDay.backgroundColor = UIColor.white
        //        btnHalfDay.backgroundColor = UIColor.white
        self.setViewAsperLeaveType(string: "full")
        
        
    }
    
    
    func setViewAsperLeaveType(string:String){
        if(string == "full"){
            btnFullDay.isSelected = true
           // btnFullDay.backgroundColor = UIColor.Appskybluecolor
            btnFullDay.setTitleColor(UIColor.white, for: .normal)
            btnFullDay.layer.cornerRadius = 5
            btnHalfDay.backgroundColor = UIColor.white
            btnHalfDay.setTitleColor(UIColor.gray, for: .normal)
    
            
            lblFromTitle.text = "FROM"
            vwTill.isHidden = false
            vwFrom.isHidden = false
        }else{
          //  btnHalfDay.backgroundColor = UIColor.Appskybluecolor
            btnHalfDay.setTitleColor(UIColor.white, for: .normal)
            btnHalfDay.layer.cornerRadius = 25
            
            btnFullDay.backgroundColor = UIColor.white
            btnFullDay.setTitleColor(UIColor.gray, for: .normal)
            
            lblFromTitle.text = "DATE"
            vwTill.isHidden = true
            vwFrom.isHidden = false
        }
    }
    //MARK: - APICall
    func getDynamicLeaveTypes(){
        SVProgressHUD.show()
        let param = Common.returndefaultparameter()
        
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetDynamicLeaveType, method: Apicallmethod.post
        ){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                // print(arr)
                let arrOfLeaveType = arr as? [[String:Any]] ?? [[String:Any]]()
                var leavetypestr = [String]()
                for leave in arrOfLeaveType{
                    // let dicleavetype = leave[1]
                    print(leave)
                    leavetypestr.append(leave["Leave_Type"] as? String ?? "")
                }
                self.arrLeaveType = leavetypestr
                self.arrLeaveType =  self.arrLeaveType.filter({
                    ($0.lowercased() != "compensatory off") && ($0.lowercased() != "optional holiday")
                })
            }else{
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view:self.view)
                    //   self.view1.makeToast(message)
                }else{
                    Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view:self.view)
                }
            }
        }
    }
    
    func getDynamicLeaveType(completion : (()->Void)? = nil) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = [String: Any]()
        param["TokenID"] = account?.securityToken
        param["UserID"] = account?.userID
        param["CompanyID"] = account?.company?.iD
        param["Application"] = "Application"
        param["ShiftID"] = self.shiftID
        
        RestAPIManager.httpRequests(ConstantURL.getCompanyLeaves, .get, parameters: param, isTeamWorkUrl: true,isMappFromModel: true) { (resp:APIResponseCompanyLeaves)  in
            SVProgressHUD.dismiss()
            if let resp = resp as? APIResponseCompanyLeaves {
                self.arrLeaveType =  resp.data?.CompanyLeaves?.filter{ $0.active == true }.compactMap{$0.leaveType} ?? []
                self.tfLeaveType.text = self.arrLeaveType.first
                completion?()
            }else {
                Utils.toastmsg(message:resp.message ?? "",view:self.view)
                completion?()
            }
        }
    }
    
    func getCompanyHoliday() {
      
        var param = [String: Any]()
        param["TokenID"] = account?.securityToken
        param["UserID"] = account?.userID
        param["CompanyID"] = account?.company?.iD
        param["Application"] = "Application"
        param["ShiftID"] = self.shiftID
        param["BranchID"] = self.account?.branchID
        param["isPublicholiday"] = 1
        
        RestAPIManager.httpRequests(ConstantURL.getCompanyHolidays, .get, parameters: param, isTeamWorkUrl: true,isMappFromModel: true) { (resp:APIResponseCompanyHolidays)  in
            if let resp = resp as? APIResponseCompanyHolidays {
                self.arrOfHoildayObj = resp.data ?? []
                self.arrOfHoliday =  resp.data?.compactMap{$0.holidayName} ?? []
                self.txtholidayName.text = self.arrOfHoliday.first
            }else {
                Utils.toastmsg(message:resp.message ?? "",view:self.view)
              
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        let leaveReason = self.tvReason.text.trimString
        if(btnFullDay.isSelected && datepicker1.date.isEndDateIsSmallerThanCurrent(firstDate: datepicker1.date, seconddate: datepicker2.date)){
            Common.showalert(msg: "Not Allowed to apply leave after prior period", view: self)
            return
        }else if leaveReason.isEmpty || leaveReason == ""{
            Common.showalert(msg: "Please enter reason", view: self)
            return
        }else{
            
            var param = Common.returndefaultparameter()
            param["Reason"] = leaveReason
            switch self.tfLeaveType.text?.lowercased().trimString {
            case  LeavesType.SICK_LEAVE.rawValue.lowercased().trimString:
                param["Type"] = "1"
                
            case  LeavesType.OPTIONAL_LEAVE.rawValue.lowercased().trimString:
                param["Type"] = "2"
                
            case  LeavesType.PAID_LEAVE.rawValue.lowercased().trimString:
                param["Type"] = "3"
                
            case  LeavesType.CASUAL_LEAVE.rawValue.lowercased().trimString:
                param["Type"] = "4"
                
            case  LeavesType.HOLIDAY.rawValue.lowercased().trimString:
                param["Type"] = "5"
                
            case  LeavesType.ABSENT_WITHOUT_LEAVE.rawValue.lowercased().trimString:
                param["Type"] = "6"
                
            case  LeavesType.PUBLIC_HOLIDAY.rawValue.lowercased().trimString:
                param["Type"] = "7"
                
            case  LeavesType.COMPENSATORY_OFF.rawValue.lowercased().trimString:
                param["Type"] = "8"
                
            case  LeavesType.MATERNITY_LEAVE.rawValue.lowercased().trimString:
                param["Type"] = "9"
                
                
            case  LeavesType.PATERNITY_LEAVE.rawValue.lowercased().trimString:
                param["Type"] = "10"
                
            default:
                break
            }
            
            var leaveType = self.tfLeaveType.text?.lowercased().trimString
            
            if leaveType  == LeavesType.OPTIONAL_LEAVE.rawValue.lowercased().trimString || leaveType == LeavesType.PAID_LEAVE.rawValue.lowercased().trimString || leaveType == LeavesType.CASUAL_LEAVE.rawValue.lowercased().trimString {
                
                if(btnHalfDay.isSelected) {
                    param["StartDate"] = Utils.getDateWithAppendingDay(day: 0, date: datepicker1.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                    param["EndDate"] =  Utils.getDateWithAppendingDay(day: 0, date: datepicker1.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                    param["LeaveDay"] = "half"
                    param["medicalCerti"] = ""
                }
                else {
                    param["StartDate"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datepicker1.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                    param["EndDate"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datepicker2.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                    param["LeaveDay"] = "full"
                    param["medicalCerti"] = ""
                }
            }
            
            
            if leaveType == LeavesType.PATERNITY_LEAVE.rawValue.lowercased().trimString || leaveType == LeavesType.MATERNITY_LEAVE.rawValue.lowercased().trimString {
                
                param["StartDate"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datepicker1.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                param["EndDate"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datepicker2.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                param["medicalCerti"] = ""
                param["LeaveDay"] = "full"
            }
            
            if leaveType == LeavesType.COMPENSATORY_OFF.rawValue.lowercased().trimString {
                param["StartDate"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datepicker1.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                param["EndDate"] = ""
                param["LeaveDay"] = "full"
                param["medicalCerti"] = ""
            }
            
            if leaveType == LeavesType.PUBLIC_HOLIDAY.rawValue.lowercased().trimString {
                if let holiday = self.arrOfHoildayObj.first(where: { $0.holidayName == self.txtholidayName.text }) {
                    param["StartDate"] = holiday.holidayDate
                    param["EndDate"] =  holiday.holidayDate
                    param["medicalCerti"] = ""
                    param["LeaveDay"] = "full"
                }
            }
            
            if leaveType == LeavesType.SICK_LEAVE.rawValue.lowercased().trimString {
                
                param["StartDate"] =  Utils.getDateUTCWithAppendingDay(day: 0, date: datepicker1.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                param["EndDate"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datepicker2.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                param["medicalCerti"] = self.medialCerti
                param["LeaveDay"] = "full"
                
                if self.setting.RequireMedicalInSL == 1 {
                    let strtDate = Utils.getDateUTCWithAppendingDay(day: 0, date: datepicker1.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                    let endDate = Utils.getDateUTCWithAppendingDay(day: 0, date: datepicker2.date, format: "yyyy/MM/dd hh:mm:ss", defaultTimeZone: false)
                    let outputDateFormat = "yyyy/MM/dd HH:mm:ss"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = outputDateFormat
                    
                    let strtFormattedDate = dateFormatter.date(from: strtDate) ?? Date()
                    let endFormattedDate = dateFormatter.date(from: endDate) ?? Date()
                    if (Utils.numberOfDaysBetween(strtFormattedDate, endFormattedDate) >= Int(self.setting.MinSLReqForMedical ?? 0)) {
                        if self.medialCerti == nil || self.medialCerti == "" {
                            Utils.toastmsg(message: "Please upload medical certificate for sick leave", view: self.view)
                        }else {
                            //API Call
                            self.apiCallApplyLeave(param: param)
                        }
                    }else {
                        //API Call
                        self.apiCallApplyLeave(param: param)
                    }
                }else {
                    //API Call
                    self.apiCallApplyLeave(param: param)
                }
            }else {
                self.apiCallApplyLeave(param: param)
            }
        }
    }
    
    func apiCallApplyLeave(param:[String:Any]) {
        SVProgressHUD.show()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApplyLeave, method: Apicallmethod.post) {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            Utils.removeShadow(view: self.view)
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let okAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                   
                }
                Common.showalertWithAction(msg: message, arrAction: [okAction], view: self)
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.dismiss()
                Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String) ?? "" :error.localizedDescription,view:self.view)
            }
        }
    }
    
    @IBAction func btnFullDayClicked(_ sender: UIButton) {
        btnFullDay.isSelected = true
        btnHalfDay.isSelected = false
       // sender.isSelected = true
        self.setViewAsperLeaveType(string: "full")
    }
    
    @IBAction func btnHalfDayClicked(_ sender: UIButton) {
        btnHalfDay.isSelected = true
        btnFullDay.isSelected = false
       // sender.isSelected = true
        self.setViewAsperLeaveType(string: "half")
    }
    
    @IBAction func btnViewCertiTapped(_ sender: UIButton) {
        self.openURLInBrowser(urlString: self.lblCertiLink.text ?? "")
    }
    
    @IBAction func btnDeleteCertiTapped(_ sender: UIButton) {
        Common.showalert(title: "Supersales", msg: "Are you sure you want to delete this file?", yesAction: UIAlertAction.init(title: "YES", style: UIAlertAction.Style.destructive, handler: { (action) in
            
            self.stckViewCerti.isHidden = true
            self.lblCertiLink.text = ""
        }),
        noAction: UIAlertAction.init(title: "NO", style: UIAlertAction.Style.default, handler: nil),
        view: self)
    }
    
    @IBAction func btnAddMedicalCertiTapped(_ sender: UIButton) {
        self.stckViewCerti.isHidden = false
        let actionSheet = UIAlertController(title: "Add Attachment", message: nil, preferredStyle: .actionSheet)
        
        // Capture Picture Action
        actionSheet.addAction(UIAlertAction(title: "Capture Picture", style: .default, handler: { _ in
            self.capturePictureTapped()
        }))
        
        // Choose From Documents Action
        actionSheet.addAction(UIAlertAction(title: "Choose From Documents", style: .default, handler: { _ in
            self.chooseDocumentTapped()
        }))
        
        // Cancel Action
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        // Present action sheet
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func chooseDocumentTapped() {
        var types: [String] = []

        if #available(iOS 14.0, *) {
            types = [UTType.spreadsheet.identifier,UTType.pdf.identifier,UTType.png.identifier,UTType.jpeg.identifier,UTType.image.identifier]
        } else {
            types =
            [kUTTypePDF as String,
             kUTTypeImage as String,
             kUTTypeSpreadsheet as String,
             kUTTypePNG as String,
             kUTTypeJPEG as String
            ]
        }
        let documentPicker: UIDocumentPickerViewController

        documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    func capturePictureTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
}
extension ApplyLeaveController:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfLeaveType){
            self.isHoliday = false
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = "Select Leave Type"
            self.popup?.isFromSalesOrder =  false
            self.popup?.nonmandatorydelegate = self
            self.popup?.parentViewOfPopup = self.contentView
            self.popup?.arrOfCustomerClass = arrLeaveType
            self.popup?.arrOfSelectedClass = arrOfSelectedLeaveType
            self.popup?.strLeftTitle = ""
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.isSearchBarRequire = false
            self.popup?.viewfor = ViewFor.customerClass
            
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            //self.present(self.popup!, animated: false, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(self.popup!, animated: true, completion: {
                
            })
            
            return false
            
        }else if(textField == tfFromDate){
            datepicker1.date = self.dateFormatter.date(from: tfFromDate.text ?? "")!
        }else if(textField == tfTillDate){
            datepicker2.date =  self.dateFormatter.date(from: tfTillDate.text ?? "")!
        }else if textField == self.txtholidayName {
            self.isHoliday = true
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = "Select Holiday"
            self.popup?.isFromSalesOrder =  false
            self.popup?.nonmandatorydelegate = self
            self.popup?.parentViewOfPopup = self.contentView
            self.popup?.arrOfCustomerClass = self.arrOfHoliday
            self.popup?.arrOfSelectedClass = arrOfSelectedHoliday
            self.popup?.strLeftTitle = ""
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.isSearchBarRequire = false
            self.popup?.viewfor = ViewFor.customerClass
            
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            //self.present(self.popup!, animated: false, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(self.popup!, animated: true, completion: {
                
            })
            
            return false
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfFromDate){
            self.dateFormatter.dateFormat = "dd MMM, yyyy"
            tfFromDate.text = self.dateFormatter.string(from: datepicker1.date)
        }else if(textField == tfTillDate){
            self.dateFormatter.dateFormat = "dd MMM, yyyy"
            tfTillDate.text = self.dateFormatter.string(from: datepicker2.date)
        }
    }
}
extension ApplyLeaveController:PopUpDelegateNonMandatory{
    func completionSelectedClass(arr: [String], recordno: Int , strTitle:String) {
        
        var strselectedexpense = ""
        if let string = arr.first{
            strselectedexpense =  string
        }
        if self.isHoliday {
            self.txtholidayName.text = strselectedexpense
        }else {
            if LeavesType.SICK_LEAVE.rawValue.lowercased() == self.tfLeaveType.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                self.stckMedicalView.isHidden = false
                self.stckViewCerti.isHidden = true
            }else {
                self.stckMedicalView.isHidden = true
            }
            
            if LeavesType.HOLIDAY.rawValue.lowercased() == self.tfLeaveType.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) || LeavesType.PUBLIC_HOLIDAY.rawValue.lowercased() == self.tfLeaveType.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                self.stckViewForholiday.isHidden = false
                self.stkLeaveFromTill.isHidden = true
                self.stckViewForLeaveType.isHidden = true
                
            }else {
                self.stckViewForholiday.isHidden = true
                self.stckViewForLeaveType.isHidden = false
                self.stkLeaveFromTill.isHidden = false
            }
            self.tfLeaveType.text = strselectedexpense
        }
        
    }
}
extension ApplyLeaveController:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.setFlexibleHeight()
        return true
    }
}
extension ApplyLeaveController:UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UIDocumentPickerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        self.uploadImage(img: selectedImage) { imgUrl in
            if let imgUrl = imgUrl {
                self.medialCerti = imgUrl
                self.lblCertiLink.text = self.medialCerti
            }
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else {
            print("No file selected")
            return
        }
        
        let isAccessing = selectedURL.startAccessingSecurityScopedResource()
        defer { if isAccessing { selectedURL.stopAccessingSecurityScopedResource() } }
        self.uploadFile(with: selectedURL) { docUrl in
            self.medialCerti = docUrl
            self.lblCertiLink.text = self.medialCerti
        }
    }
    
    //MARK: -UploadImage
    func uploadImage(img:UIImage,isAttchment:Bool = false,completion: @escaping (_ imgUrl:String?) -> Void)  {
        SVProgressHUD.show()
        self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl:isAttchment ? ConstantURL.kWSUrlUploadAttachment : ConstantURL.kWSUrlUploadImage, img: img, imgparamname: isAttchment ? "File" : "Image", param: Common.returndefaultparameter()) {  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if isAttchment {
                if(status == Constant.SucessResponseFromServer){
                    if let imagepath = arr as? String{
                        completion(imagepath)
                    }
                }
            }else {
                if(status.lowercased() == Constant.SucessResponseFromServer) {
                    if let dic = arr as? [String:Any]{
                        let image = dic["filePath"] as? String ?? ""
                        completion(image)
                    }
                }
            }
        }
    }
    
    func uploadFile(with url: URL, completion: @escaping (_ imgUrl: String?) -> Void) {
        guard let fileData = try? Data(contentsOf: url) else {
            print("Failed to read file data from URL: \(url)")
            completion(nil)
            return
        }
        let parameters: [String: Any] = Common.returndefaultparameter()
        
        guard let uploadURL = URL(string: ConstantURL.kWSUrlUploadAttachment) else {
            print("Invalid URL")
            return
        }
        
        
        let boundary = "Boundary-\(UUID().uuidString)"

        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileData, withName: "File", fileName: url.lastPathComponent, mimeType: self.determineMimeType(for: url))
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)

            }
        } , to: uploadURL){ result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (dataResponse) in
                    var dict:[String:AnyObject]?
                    do{
                        dict = try  JSONSerialization.jsonObject(with: dataResponse.data!, options: []) as? [String:AnyObject]
                        completion(dict?["data"] as? String ?? "")
                    }catch{
                        print(error.localizedDescription)
                    }

                })
            case .failure(let error):
                print("Upload failed with error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func determineMimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension.lowercased()
        switch pathExtension {
        case ".pdf":
            return "application/pdf"
        case ".xlsx":
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case ".png":
            return "image/png"
        case ".jpg", "jpeg":
            return "image/jpeg"
        default:
            return "application/octet-stream" // Default MIME type
        }
    }
    
}

enum LeavesType:String {
    
    case SICK_LEAVE = "Sick Leave"
    case OPTIONAL_LEAVE = "Optional Leave"
    case PAID_LEAVE = "Paid Leave"
    case CASUAL_LEAVE = "Casual Leave"
    case HOLIDAY = "Holiday"
    case ABSENT_WITHOUT_LEAVE = "Absent"
    /**
     * PUBLIC_HOLIDAY is also called optional holiday
     */
    case PUBLIC_HOLIDAY = "Optional holiday"
    case COMPENSATORY_OFF = "Compensatory Off"
    case MATERNITY_LEAVE = "Maternity leave"
    case PATERNITY_LEAVE = "Paternity leave"
    
}
