//
//  ManualAttendanceController.swift
//  SuperSales
//
//  Created by Apple on 15/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class ManualAttendanceController: BaseViewController {

    @IBOutlet var btnHalfDay: UIButton!
    
    @IBOutlet var btnManualDate: UIButton!
    
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet var tvReason: UITextView!
    var parentviewForpopup: UIView!
    var approvalobj:Notificationmodel?
     var datepicker:UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        self.setUI()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - Method
    func setUI(){
        self.view.setShadow()
        
        
        self.btnOK.setbtnFor(title: NSLocalizedString("Ok", comment: ""), type: Constant.kPositive)
        self.btnCancel.setbtnFor(title:NSLocalizedString("Cancel", comment: ""), type: Constant.kNutral)
        tvReason.setFlexibleHeight()
        self.salesPlandelegateObject =  self
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        datepicker = UIDatePicker.init()
        datepicker.setCommonFeature()
          
      //  datepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        datepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        print("\(view.frame.size.width) , width of picker = \(datepicker.frame.size.width)")
        btnHalfDay.setImage(UIImage.init(named: "icon_switch_unselected"), for: UIControl.State.normal)
        btnHalfDay.setImage(UIImage.init(named: "icon_switch_selected"), for: UIControl.State.highlighted)
        self.dateFormatter.dateFormat = "dd MMM , yyyy"
        btnManualDate.setTitle(self.dateFormatter.string(from: Date()), for: .normal)
    }
    
    
    //MARK: - Action
    
    @IBAction func btnManualdateClicked(_ sender: UIButton) {
        self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:datepicker, textfield: nil, withDateMonth: true)
        datepicker.maximumDate = Date()
    }
    
    @IBAction func btnHalfDayClicked(_ sender: UIButton) {
        print(sender.isSelected)
          print(sender.state)
        sender.isSelected = !sender.isSelected

//      print(sender.isSelected)
//        print(sender.state)
    }
    
    @IBAction func btnOkClicked(_ sender: UIButton) {
        let reason = tvReason.text.trimString
        if reason.isEmpty || reason == "" {
            Utils.toastmsg(message:"Please Enter Reason",view:self.view)
        }else{
            //api call for manual checkin
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            param["UserID"] = self.activeuser?.userID
            param["CompanyID"] = self.activeuser?.company?.iD
            param["Reason"] =  self.tvReason.text
            param["Date"] = Utils.getDateinstrwithaspectedFormat(givendate: datepicker.date, format: "yyyy/MM/dd", defaultTimZone: false)
            var strmanualattendancetype  = ""
            if(btnHalfDay.isSelected == true){
                strmanualattendancetype = "half"
            }else{
                strmanualattendancetype = "full"
            }
            param["ManualAttendanceType"] =  strmanualattendancetype
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlManualAttendance, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(message)
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
//                if ( message.count > 0 ) {
//                     Utils.toastmsg(message:message,view: self.view)
//                }
//                Utils.toastmsg(message:message, duration: 10, position: self.view.center)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    Utils.removeShadow(view: self.parentviewForpopup)
                    self.dismiss(animated: true) {
                        Utils.removeShadow(view: self.parentviewForpopup)
                        Utils.removeShadow(view: self.view)
                    }
                }
                }else if(error.code == 0){
               // self.dismiss(animated: true, completion: nil)
                         if  (message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                     }else{
              //  self.dismiss(animated: true, completion: nil)
                        Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                     }
                }
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: {
            Utils.removeShadow(view: self.parentviewForpopup)
        })
    }
}
extension ManualAttendanceController:BaseViewControllerDelegate{
    func datepickerSelectionDone(){
//           SalesPlanHome.selectedDate =  Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepicker.date)
btnManualDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM, yyyy",date:datepicker.date), for: .normal)
    }
    func cancelbtnTapped() {
              datepicker.removeFromSuperview()
           }
}
