//
//  AttendanceDetailUpdateRequestView.swift
//  SuperSales
//
//  Created by Apple on 08/11/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit
import SVProgressHUD

class AttendanceDetailUpdateRequestView: BaseViewController {
   // let account = Utils().getActiveAccount()
    @objc open var  attendanceCheckinDetail: AttendanceUserHistory?
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUserImage: UILabel!
    @IBOutlet weak var btnApproveRequest: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblDateValue: UILabel!
    @IBOutlet weak var lblNewTimeInTitle: UILabel!
    @IBOutlet weak var txtNewTimeIn: UITextField!
 
    @IBOutlet weak var lblNewTimeOutTitle: UILabel!
    @IBOutlet weak var txtTimeOut: UITextField!
    
    @IBOutlet weak var lblOldTimeInTitle: UILabel!
    @IBOutlet weak var txtOldTimeIn: UITextField!
    
    @IBOutlet weak var lblOldTimeOutTitle: UILabel!
    @IBOutlet weak var txtOldTimeOut: UITextField!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnRejectRequestButton: UIButton!
    
   
    @IBOutlet weak var lblReason: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ATTENDANCE DETAILS"
        // Do any additional setup after loading the view.
        self.setData()
        //self.showNavBar1()
    }
    
    func setData()  {
        if #available(iOS 11.0, *) {
            self.navigationItem.backButtonTitle = " "
        } else {
            // Fallback on earlier versions
            self.navigationItem.backBarButtonItem?.title = " "
        }
        
        
        txtNewTimeIn.setCommonFeature()
        txtTimeOut.setCommonFeature()
        txtOldTimeIn.setCommonFeature()
        txtOldTimeOut.setCommonFeature()
        
        
        
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.lblReason.setMultilineLabel(lbl: self.lblReason)
        self.btnApproveRequest.layer.cornerRadius = 10;
        self.btnRejectRequestButton.layer.cornerRadius = 10;
        if let reason = attendanceCheckinDetail?.reason{
          
        self.lblReason.text = reason
        }
        let user = attendanceCheckinDetail?.attendanceuser
        //_AttendanceUser
        let firstName = user?.firstName ?? " "
        let middleSpace = " "
        let lastName = user?.lastName ?? " "
        let fullName = "\(firstName)\(middleSpace)\(lastName)"
        self.lblUserName.text = fullName
        
        
        //Set Title
        self.btnApproveRequest.setTitle("Accept", for: .normal)
        self.btnRejectRequestButton.setTitle("Reject", for: .normal)
        
        //Set Time
        let formater:DateFormatter = DateFormatter.init()
        formater.dateFormat = "dd MMM, yyyy"
        if let attendancedate = attendanceCheckinDetail?.attendanceDate as? Date{
        self.lblDateValue.text = formater.string(from: (attendancedate))
        }
        formater.dateFormat = "hh:mm a"
    
        if(attendanceCheckinDetail?.checkInApproved == true){
          
            self.txtNewTimeIn.textColor = .black
            
        }else{
            
             self.txtNewTimeIn.textColor =  UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
            
        }
        if(attendanceCheckinDetail?.checkInTime != nil){
            self.txtOldTimeIn.text = formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date)
            self.txtNewTimeIn.text =  formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date)
        }else{
             self.txtOldTimeIn.text = ""
        }
        
        if(attendanceCheckinDetail?.timeOut != nil){
            self.txtOldTimeOut.text = formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date)
            self.txtTimeOut.text =  formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date)
        }else{
             self.txtOldTimeOut.text = ""
        }
        if(attendanceCheckinDetail?.checkOutTime != nil){
            self.txtOldTimeOut.text = formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date)
            self.txtOldTimeOut.text =  formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date)
        }else{
             self.txtOldTimeOut.text = ""
        }
    if(attendanceCheckinDetail?.updatedTimeIn != nil){
        self.txtNewTimeIn.text =  formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date)
    }else{
        if(attendanceCheckinDetail?.checkInApproved == true){
            if(attendanceCheckinDetail?.timeIn != nil){
                self.txtNewTimeIn.text =  formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date)
            
        }
        }else{
            if(attendanceCheckinDetail?.checkInTime != nil){
                self.txtNewTimeIn.text =  formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date)
            }else{
                 self.txtNewTimeIn.text = ""
            }
        
        }
        }
    
//        if(attendanceCheckinDetail?.checkInTime  == nil && attendanceCheckinDetail?.timeIn == nil && attendanceCheckinDetail?.updatedTimeIn == nil){
//
//            self.txtNewTimeIn.text = ""
//        }
     
        if( self.txtOldTimeIn.text?.count ?? 0 > 0){
            self.txtOldTimeIn.isHidden = false;
            self.lblOldTimeInTitle.isHidden = false;
        }else{
            self.txtOldTimeIn.isHidden = true;
            self.lblOldTimeInTitle.isHidden = true;
        }
        if(self.txtNewTimeIn.text?.count ?? 0 > 0){
            self.txtNewTimeIn.isHidden = false
            self.lblNewTimeInTitle.isHidden = false
        }else{
            self.txtNewTimeIn.isHidden = true
            self.lblNewTimeInTitle.isHidden = true
        }
    if(attendanceCheckinDetail?.checkOutApproved == true){
       
        self.txtTimeOut.textColor = .black
        
        }else{
        
          self.txtTimeOut.textColor =  UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
     
        }
        if(attendanceCheckinDetail?.updatedTimeOut != nil){
           
            self.txtTimeOut.text =  formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date)
           }else{
            if(attendanceCheckinDetail?.checkOutApproved == true){
                if(attendanceCheckinDetail?.timeOut != nil){
                    self.txtTimeOut.text =  formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date)
                }
        
               else if(attendanceCheckinDetail?.checkOutTime != nil){
                self.txtTimeOut.text =  formater.string(from: (attendanceCheckinDetail?.checkOutTime)!)
                }else{
                    self.txtTimeOut.text = ""
                }
        }
        }
//        if(attendanceCheckinDetail?.checkOutTime  == nil && attendanceCheckinDetail?.timeOut == nil && attendanceCheckinDetail?.updatedTimeOut == nil){
//            self.txtTimeOut.text = ""
//            self.txtOldTimeOut.text = ""
//        }
//        if(attendanceCheckinDetail?.timeOut == nil){
//            self.txtOldTimeOut.text = ""
//        }
        if( self.txtTimeOut.text?.count ?? 0 > 0){
            self.txtTimeOut.isHidden = false;
            self.lblNewTimeOutTitle.isHidden = false;
        }else{
            self.txtTimeOut.isHidden = true;
            self.lblNewTimeOutTitle.isHidden = true;
        }
        if(self.txtOldTimeOut.text?.count ?? 0 > 0){
            self.txtOldTimeOut.isHidden = false
            self.lblOldTimeOutTitle.isHidden = false
        }else{
            self.txtOldTimeOut.isHidden = true
            self.lblOldTimeOutTitle.isHidden = true
        }
        //set round image of user
self.imgUser.layer.cornerRadius = self.imgUser.frame.size.height/2.0;

self.imgUser.clipsToBounds = true;
       
            if(user?.userImagePath == nil){
                self.lblUserImage.isHidden = false;

                self.lblUserImage.textColor = .white
                self.lblUserImage.font = UIFont.boldSystemFont(ofSize: 25)
                self.lblUserImage.text = String(user?.firstName.prefix(1) ?? "T").capitalized

self.imgUser.backgroundColor = Common().UIColorFromRGB(rgbValue: 0x2A718E)
                    //RGB(227, 237, 250);

self.imgUser.image = nil;
            }else{
self.lblUserImage.isHidden = true;
let strForUser = user?.userImagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
print("picture user url = \(strForUser)")
self.imgUser.sd_setImage(with: URL.init(string: strForUser ?? "gdfd"), placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
print("image downloaded")
// self.imgUser.image = nil
}
            }
           // self.imgUser.setImageWith(URL.init(string: strForUserPicture ?? "")!, placeholderImage: UIImage.init(imageLiteralResourceName: "User_default_icon_grey"))
            
            
    if(attendanceCheckinDetail?.checkOutApproved == true && attendanceCheckinDetail?.checkInApproved == true){
            self.btnRejectRequestButton.isHidden = true
            self.btnApproveRequest.isHidden = true
        }else{
            self.btnRejectRequestButton.isHidden = false
            self.btnApproveRequest.isHidden = false
        }
    }
    @IBAction func btnAcceptClicked(_ sender: UIButton) {
            self.changetheStatus(status: true)
    }
    
    @IBAction func btnRejectClicked(_ sender: UIButton) {
        self.changetheStatus(status: false)
    }
    
    func changetheStatus(status:Bool){
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["AttendanceID"] =  self.attendanceCheckinDetail?.entity_id
        param["UserID"] = self.activeuser?.userID
        param["CompanyID"] =  self.activeuser?.company?.iD
        param["MemberID"] = NSNumber.init(value:self.attendanceCheckinDetail?.attendanceuser.entity_id ?? 0)
        param["Approve"] = NSNumber.init(value:status)
        param["IsPermanentLocation"] = NSNumber.init(value:false)
        param["TokenID"] =  self.activeuser?.securityToken
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveAttendance, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                 NotificationCenter.default.post(name: Notification.Name("LoadUserAttendanceHistory"), object: nil)
                                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                                self.navigationController?.popViewController(animated: true)
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                
            }else{
               Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
//        if(Helper.isReachable()){
//            var paradict:[String:Any] = [:]
//            paradict["AttendanceID"] =  self.attendanceCheckinDetail?.entity_id
//            paradict["UserID"] =   account?.user_id
//            paradict["CompanyID"] =  NSNumber.init(integerLiteral:account?.company_info.company_id ?? 1)
//            paradict["MemberID"] =
//                self.attendanceCheckinDetail?.attendanceuser.entity_id
//            paradict["Approve"] = NSNumber.init(value: status)
//            paradict["IsPermanentLocation"] = NSNumber.init(value: false)
//            paradict["TokenID"] = account?.securityToken
//
//
//
//            let str = kBaseTeamworkURL + "approveAttendance"
//            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
//            callAPIPost(methodName: "POST", url: str  , parameter: paradict) { (status, result) in
//                if(status.lowercased() == "success"){
//                    SVProgressHUD.dismiss()
//                    do{
//                        //here dataResponse received from a network request
//
//                        print(result )
//                        let resultModel = Result(result as! [String : Any])
//
//                        print(resultModel)
//                        if(resultModel.status.lowercased() == "success" ){
//                            //[[NSNotificationCenter defaultCenter] postNotificationName:LOAD_USER_ATTENDANCE_HISTORY object:nil];
//                            NotificationCenter.default.post(name: Notification.Name(LOAD_USER_ATTENDANCE_HISTORY), object: nil)
//                            Utils.toastmsg(message:resultModel.message)
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                        else{
//                            self.showAlert(withMessage: "SomeThing Went Wrong")
//
//                        }
//                    }
//                }else if(status.lowercased() == "Invalid Token"){
//                     let resultModel = Result(result as! [String : Any])
//                    SVProgressHUD.dismiss()
//                    Utils.toastmsg(message:resultModel.message)
//                    AppDelegate().window.makeToast(resultModel.message)
//                    AppDelegate().logout()
//                    //                    [[AppDelegate appDelegate].window makeToast:result[@"message"]];
//                    //                    [[AppDelegate appDelegate] logout];
//                }
//                else if (status == "false"){
//                    SVProgressHUD.dismiss()
//                    Utils.toastmsg(message:NSLocalizedString("internet-failure", comment: ""))
//                }
//                else{
//                    SVProgressHUD.dismiss()
//                    Utils.toastmsg(message:"SomeThing Went Wrong Please try again")
//                }
//            }
//
//        }else{
//            Utils.toastmsg(message:"Internet - failure")
//           // self.showAlert(withInternetMessage:NSLocalizedString("internet-failure", comment: ""))
//        }
      
        
    }

}
