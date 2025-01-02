//
//  UpdateAttendanceController.swift
//  SuperSales
//
//  Created by Apple on 26/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class UpdateAttendanceController: BaseViewController {

    @IBOutlet var imgUser: UIImageView!
    
    @IBOutlet var btnSubtmit: UIButton!
    @IBOutlet var lblUserName: UILabel!
    
    @IBOutlet var tvReason: UITextView!
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblIN: UILabel!
    
    @IBOutlet var lblOut: UILabel!
    
    @IBOutlet var tfEndDate: UITextField!
    @IBOutlet var tfStartDate: UITextField!
    var attendanceobj:AttendanceUserHistory?
    var datePicker1:UIDatePicker! = UIDatePicker()
    var datePicker2:UIDatePicker! = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        // Do any additional setup after loading the view.
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
             NotificationCenter.default.addObserver(forName: Notification.Name("LoadUserAttendanceHistory"), object: nil, queue: OperationQueue.main) { (notify) in
                       print(notify.object as?  Dictionary<String,Any>)
              // self.loadData()
            
                   }
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(true)
           NotificationCenter.default.removeObserver(self, name: Notification.Name("LoadUserAttendanceHistory"), object: nil)
       }
    
    override func viewDidLayoutSubviews() {
        self.view .bringSubviewToFront(imgUser)
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2
        imgUser.layer.masksToBounds = true
    }

    //MARK: - Mathod
    func setUI(){
        
        
        self.tfEndDate.setCommonFeature()
        self.tfStartDate.setCommonFeature()
        
        
        self.dateFormatter.dateFormat = "hh:mm a"
        self.view.setShadow()
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        if #available(iOS 11.0, *) {
            self.navigationItem.backButtonTitle = " "
        } else {
            // Fallback on earlier versions
            self.navigationItem.backBarButtonItem?.title = " "
        }
        let user = self.activeuser
        self.lblUserName.textColor = UIColor.Appskybluecolor
      
        datePicker1.setCommonFeature()
        datePicker2.setCommonFeature()
        datePicker1.datePickerMode = .time
        datePicker2.datePickerMode = .time
        tfStartDate.inputView = datePicker1
        tfEndDate.inputView =  datePicker2
        tfStartDate.delegate = self
        tfEndDate.delegate = self
       
        self.lblUserName.font = UIFont.boldSystemFont(ofSize: 16)
        var strname = ""
        if let  firstname =  user?.firstName as? String{
            if(firstname.count > 0){
                strname.append(firstname)
            }
        }
        if let lastname = user?.lastName as? String{
            if(lastname.count > 0){
                strname.append(lastname)
            }
        }
        self.lblUserName.text = strname
        if(attendanceobj?.present == true){
            if let checkintime = attendanceobj?.checkInTime as? NSDate{
                tfStartDate.text = Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a", defaultTimeZone: true)// self.dateFormatter.string(from: datePicker1.date)
                    //Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a", defaultTimeZone: true)
                datePicker1.date = checkintime as Date
            }
            if let timein = attendanceobj?.timeIn as? NSDate{
                 tfStartDate.text = Utils.getDateWithAppendingDay(day: 0, date: timein as Date, format: "hh:mm a", defaultTimeZone: true)//self.dateFormatter.string(from: datePicker1.date)// Utils.getDateWithAppendingDay(day: 0, date: timein as Date, format: "hh:mm a", defaultTimeZone: true)
                datePicker1.date = timein as Date
            }
            tfEndDate.isHidden = true
            lblOut.isHidden = true
        }else{
            tfEndDate.isHidden = false
            lblOut.isHidden = false
            if let  checkintime = attendanceobj?.checkInTime as? NSDate{
                 tfStartDate.text = Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a", defaultTimeZone: true)//self.dateFormatter.string(from: datePicker1.date)//Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a", defaultTimeZone: true)
           
                datePicker1.date = checkintime as Date
            }
            
            if let timein = attendanceobj?.timeIn as? NSDate{
                 tfStartDate.text = Utils.getDateWithAppendingDay(day: 0, date: timein as Date, format: "hh:mm a", defaultTimeZone: true)//self.dateFormatter.string(from: datePicker1.date)// Utils.getDateWithAppendingDay(day: 0, date: timein as Date, format: "hh:mm a", defaultTimeZone: true)
                datePicker1.date =  timein as Date
            }
            
            if let checkout = attendanceobj?.checkOutTime as? NSDate{
                tfEndDate.text = Utils.getDateWithAppendingDay(day: 0, date: checkout as Date, format: "hh:mm a", defaultTimeZone: true) // self.dateFormatter.string(from: datePicker2.date)//Utils.getDateWithAppendingDay(day: 0, date: checkout as Date, format: "hh:mm a", defaultTimeZone: true)
                datePicker2.date = checkout as Date
            }
            
            if let timeout = attendanceobj?.timeOut as? NSDate{
                 tfEndDate.text = Utils.getDateWithAppendingDay(day: 0, date: timeout as Date, format: "hh:mm a", defaultTimeZone: true)//self.dateFormatter.string(from: datePicker2.date) //Utils.getDateWithAppendingDay(day: 0, date: timeout as Date, format: "hh:mm a", defaultTimeZone: true)
                datePicker2.date = timeout as Date
            }
            if(tfEndDate.text?.count == 0){
               
                    tfEndDate.isUserInteractionEnabled = false
             
            }
        }
        
        imgUser.backgroundColor = UIColor.clear
        imgUser.layer.borderColor = UIColor.white.cgColor
        imgUser.layer.borderWidth = 2.0
        if(self.activeuser?.picture?.count ?? 0 > 0){
            imgUser.sd_setImage(with: URL.init(string: self.activeuser?.picture ?? ""), placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
            print("image downloaded")
            }
        }else{
                
                self.imgUser.image = UIImage.init(named: "icon_placeholder_user")
            }

        print(self.attendanceobj?.attendanceDate)

        lblDate.text = Utils.getDateWithAppendingDay(day: 0, date: self.attendanceobj?.attendanceDate as! Date, format: "dd MMM, yyyy", defaultTimeZone: true
        )
        
        if((attendanceobj?.checkInTime == nil) && (attendanceobj?.checkOutTime == nil)){
            tfStartDate.isHidden = true
            tfEndDate.isHidden = true
            lblOut.isHidden = true
        }
        self.title = "Update Time Details"
        }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - IBAction
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
if(tvReason.text.count  == 0){
Utils.toastmsg(message:"Please enter reason",view: self.view)
            return
        }else if(datePicker1.date.isEndDateIsSmallerThanCurrent(checkendDate: datePicker2.date)){
            Utils.toastmsg(message:"CheckIn time should be lesser than equal to checkOut time",view: self.view)
            return
        }else{
    SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    var param = Common.returndefaultparameter()
    param["Reason"] = tvReason.text
    param["AttendanceID"] = self.attendanceobj?.entity_id
    if  let  checkintime = self.attendanceobj?.checkInTime as? NSDate{
    if let checkouttime = self.attendanceobj?.checkOutTime as? Date{
    param["UpdateCheckIn"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datePicker1.date, format: "yyyy/MM/dd HH:mm:ss",defaultTimeZone:true)
    param["UpdateCheckOut"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datePicker2.date, format: "yyyy/MM/dd HH:mm:ss",defaultTimeZone:true)
    }else if let checkouttime = self.attendanceobj?.checkOutTime as? Date{
    if(self.attendanceobj?.checkInTime == nil){
    param["UpdateCheckOut"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datePicker2.date, format: "yyyy/MM/dd HH:mm:ss",defaultTimeZone:true)
        }
    }else if let checkouttime = attendanceobj?.checkOutTime as? Date{
    if(self.attendanceobj?.checkOutTime == nil){
        param["UpdateCheckIn"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datePicker1.date, format: "yyyy/MM/dd HH:mm:ss",defaultTimeZone:true)
                }
    }else{
        param["UpdateCheckIn"] = Utils.getDateUTCWithAppendingDay(day: 0, date: datePicker1.date, format: "yyyy/MM/dd HH:mm:ss",defaultTimeZone:true)
    }
            }
            
print("parameter of update attendance = \(param)")
self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlUpdateAttendance, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
    SVProgressHUD.dismiss()
        //NotificationCenter.default.post(name: Notification.Name("LoadUserAttendanceHistory"), object: nil)
    NotificationCenter.default.post(name: Notification.Name.init("updateAttendanceRequestSent"), object: nil)
    
    if(status.lowercased() == Constant.SucessResponseFromServer){
        if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        print(message)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
           
            self.dismiss(animated: true, completion: nil)
        })
    }else if(error.code == 0){
      //  self.dismiss(animated: true, completion: nil)
                 if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
             }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
//        self.dismiss(animated: true, completion: nil)
              
             }
            }
        }
    }
}
extension UpdateAttendanceController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
           
       self.dateFormatter.dateFormat = "hh:mm a"
           if(textField == tfStartDate){
           
            print("in start =\(datePicker1.date)")

           }else if(textField == tfEndDate){
            
            print("in start = \(datePicker2.date)")
           }
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
            self.dateFormatter.dateFormat = "hh:mm a"
           if(textField == tfStartDate){
               textField.text = self.dateFormatter.string(from: datePicker1.date)
            print("in end = \(datePicker1.date)")
//            self.dateFormatter.dateFormat = "yyy/MM/dd hh:mm:ss"
//            let startDate = self.dateFormatter.date(from: textField.text)
           }else if(textField == tfEndDate){
            
               textField.text = self.dateFormatter.string(from: datePicker2.date)
            print("in end =  \(datePicker2.date)")
           }
       }
}
