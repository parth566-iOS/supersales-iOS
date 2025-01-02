//
//  CustomerPopup.swift
//  SuperSales
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol CustomerPopUpDelegate {
    func customerHistoryWithResponse(name:String,dicdata:[String:Any])
}

class CustomerPopup: BaseViewController {
    var customerId:NSNumber!
    var isEdit:Bool!
    var parentViewOfPopup:UIView!
    @IBOutlet var vwTempView: UIView!
    
    @IBOutlet var lblCustomerName: UILabel!
    
    @IBOutlet var btnCustomerName: UIButton!
    
    @IBOutlet var imgDownArrow: UIImageView!
    
    @IBOutlet var btnSearchCustomer: UIButton!
    
    @IBOutlet var tfStartDate: UITextField!
    
    @IBOutlet var tfEndDate: UITextField!
    var delegate:CustomerPopUpDelegate?
    
    var calender:NSCalendar!
    var dayComponent:NSDateComponents!
    var nextDate:NSDate!
    var startDate:NSDate!
    var endDate:NSDate!
    var popup:CustomerSelection? = nil
    var arrOfSelectedSingleCustomer:[CustomerDetails]! = [CustomerDetails]()
    var arrOfCustomer:[CustomerDetails]! = [CustomerDetails]()
    var datePickerSD = UIDatePicker()
    var datePickerED = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        
//        nextDate = calender?.date(byAdding: dayComponent, to: Date(), options: 0)
//        startDate = calender?.date(bySettingHour: 0, minute: 0, second: 1, of: nextDate, options: NSCalendar.Options.Element)
       // nextdate = calender.date(bySettingHour: 0, minute: 0, second: 1, of: <#T##Date#>, options: <#T##NSCalendar.Options#>) as NSDate?
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Method
    func setUI(){
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        lblCustomerName.textColor = UIColor.black
        self.arrOfCustomer = CustomerDetails.getAllWithNoPending()
        calender = NSCalendar.current as NSCalendar
        dayComponent = NSDateComponents.init()
        dayComponent.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
        if let customerID =  customerId as? NSNumber{
            if let customer = CustomerDetails.getCustomerByID(cid: customerId){
                self.lblCustomerName.text = customer.name
            }
        }
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        self.tfStartDate.text = Utils.getDateWithAppendingmonthLang(month: -3, date: Date(), format: "dd-MM-yyyy")//self.dateFormatter.string(from: Date())
        self.tfEndDate.text =  self.dateFormatter.string(from: Date())
        datePickerSD.date = self.dateFormatter.date(from: self.tfStartDate.text!)!
        datePickerED.date = Date()
        tfStartDate.setCommonFeature()
        tfEndDate.setCommonFeature()
        datePickerSD.setCommonFeature()
        datePickerED.setCommonFeature()
        self.tfStartDate.inputView = datePickerSD
        self.tfEndDate.inputView =  datePickerED
        self.tfStartDate.delegate = self
        self.tfEndDate.delegate = self
        if(isEdit == false){
            btnCustomerName.isUserInteractionEnabled = false
            btnSearchCustomer.isUserInteractionEnabled = false
            lblCustomerName.isUserInteractionEnabled = false
            self.btnSearchCustomer.isHidden = true
            self.imgDownArrow.isHidden = true
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func selectCustomer(_ sender: UIButton) {
        self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        self.popup?.isFromSalesOrder =  false
        self.popup?.modalPresentationStyle = .overCurrentContext
        self.popup?.strTitle = ""
        self.popup?.nonmandatorydelegate = self
        self.popup?.arrOfList = self.arrOfCustomer ?? [CustomerDetails]()
        self.popup?.arrOfSelectedSingleCustomer = self.arrOfSelectedSingleCustomer ?? [CustomerDetails]()
        self.popup?.strLeftTitle = ""
        self.popup?.strRightTitle = ""
        self.popup?.selectionmode = SelectionMode.none
        //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
        self.popup?.isSearchBarRequire = false
        self.popup?.viewfor = ViewFor.customer
        self.popup?.isFilterRequire = false
        // popup?.showAnimate()
        self.present(self.popup!, animated: false, completion: nil)
    }
    
    @IBAction func selectSearch(_ sender: UIButton) {
        self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        self.popup?.isFromSalesOrder =  false
                      self.popup?.modalPresentationStyle = .overCurrentContext
                      self.popup?.strTitle = ""
                      self.popup?.nonmandatorydelegate = self
                      self.popup?.arrOfList = self.arrOfCustomer ?? [CustomerDetails]()
                      self.popup?.arrOfSelectedSingleCustomer = self.arrOfSelectedSingleCustomer ?? [CustomerDetails]()
                      self.popup?.strLeftTitle = "OK"
                      self.popup?.strRightTitle = "Cancel"
                      self.popup?.selectionmode = SelectionMode.none
                      //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                      self.popup?.isSearchBarRequire = true
                      self.popup?.viewfor = ViewFor.customer
                      self.popup?.isFilterRequire = false
                      // popup?.showAnimate()
                      self.present(self.popup!, animated: false, completion: nil)
    }
    
    @IBAction func closePopup(_ sender: UIButton) {
        Utils.removeShadow(view: parentViewOfPopup)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectOK(_ sender: UIButton) {
        if let customerID  =  customerId as? NSNumber{
            
        if(customerID .intValue > 0){
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            self.dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
            let ndate = calender.date(bySettingHour: 0, minute: 0, second: 1, of:  datePickerSD.date, options: []) ?? Date()
            // self.dateFormatter.dateFormat = "yyyy/MM/dd"
                //calender.date(bySettingHour: 0, minute: 0, second: 1, of: Date(), options: 0) as? NSDate
            let sdate = self.dateFormatter.string(from: ndate)
            print("Start Date::: %@",sdate)
            let dt1 = calender.date(bySettingHour: 23, minute: 59, second: 59, of: datePickerED.date, options: []) ?? Date()
                       
                           //calender.date(bySettingHour: 0, minute: 0, second: 1, of: Date(), options: 0) as? NSDate
            let edate = self.dateFormatter.string(from: dt1)
            print("End date :: %@",edate)
            if(ndate.compare(dt1) == .orderedDescending ){
                SVProgressHUD.dismiss()
               // self.view1.makeToast("Select Valid Date")
                Utils.toastmsg(message:"Select Valid Date",view:self.view)
                return
            }
            
            var objJson = [String:Any]()
            objJson["CustomerID"] =  customerId
            objJson["CreatedBy"] = self.activeuser?.userID
            objJson["CompanyID"] = self.activeuser?.company?.iD
            var objTime = [String:Any]()
            objTime["StartDate"] = sdate
            objTime["EndDate"] = edate
            var param = Common.returndefaultparameter()
            param["getjson"] = Common.json(from: objJson)
            param["gettime"] = Common.json(from:objTime)
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetCustomerHistoryReport, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                Utils.removeShadow(view: self.parentViewOfPopup)
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                if(responseType == ResponseType.dic){
                    let dic = arr as? [String:Any] ?? [String:Any]()
                    self.delegate?.customerHistoryWithResponse(name: self.lblCustomerName.text!, dicdata: dic)
                    Utils.removeShadow(view: self.parentViewOfPopup)
                    self.dismiss(animated: true, completion: nil)
                }
            } else if(error.code == 0){
                Utils.removeShadow(view: self.parentViewOfPopup)
                  self.dismiss(animated: true, completion: nil)
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view:self.view)
                   // self.view1.makeToast(message)
                }
                       }else{
                        Utils.removeShadow(view: self.parentViewOfPopup)
                  self.dismiss(animated: true, completion: nil)
                        Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String) ?? "" :error.localizedDescription,view:self.view)
                     //     self.view1.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                       }
                }
            //self.ap
        }else{
            Utils.toastmsg(message:"Select customer",view:self.view)
         
        }
        }else{
            Utils.toastmsg(message:"Select customer",view:self.view)
          
        }
    }
    /*
     @IBOutlet var closePopUp: CustomButton!
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CustomerPopup:PopUpDelegateNonMandatory{
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        if(arr.count > 0 ){
            lblCustomerName.text = arr.first?.name
            customerId =  NSNumber.init(value:arr.first?.iD ?? 0)
        }
    }
   
}
extension CustomerPopup:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.datePickerED.datePickerMode = .date
        self.datePickerSD.datePickerMode = .date
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        if(textField == tfStartDate){
            self.datePickerSD.date = self.dateFormatter.date(from: textField.text ?? "17-04-2020") ?? Date()
           

        }else if(textField == tfEndDate){
            self.datePickerED.date = self.dateFormatter.date(from: textField.text ?? "17-04-2020") ?? Date()

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         self.dateFormatter.dateFormat = "dd-MM-yyyy"
        if(textField == tfStartDate){
            textField.text = self.dateFormatter.string(from: datePickerSD.date)
        }else if(textField == tfEndDate){
            textField.text = self.dateFormatter.string(from: datePickerED.date)
        }
    }
}
