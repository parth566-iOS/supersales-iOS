//
//  AttendanceDetailViewController.swift
//  SuperSales
//
//  Created by Apple on 15/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD


class AttendanceDetailViewController: BaseViewController {
    @objc open var  attendanceCheckinDetail: AttendanceUserHistory?
    
    @IBOutlet weak var imgUser: UIImageView!
    var isFromHistory:Bool!
    @IBOutlet var stkCheckInOutRequest: UIStackView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblCheckedIndate: UILabel!
    
    @IBOutlet weak var lblRequestType: UILabel!
    
    @IBOutlet weak var lblOutTime: UILabel!
    
    @IBOutlet weak var lblINTime: UILabel!
    
    @IBOutlet weak var lblCheckINDate: UILabel!
    
    //button accept reject
    
    @IBOutlet weak var btnReject: UIButton!
    
    @IBOutlet weak var btnAccept: UIButton!
    //height for accpt reject button
    
    @IBOutlet weak var stkAttendanceType: UIStackView!
    
 
    
    @IBOutlet weak var stkBtnAcceptReject: UIStackView!
 
    @IBOutlet weak var cnstAcceptbtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblCheckInAddress: UILabel!
    
    @IBOutlet weak var lblCheckOutAddress: UILabel!
    @IBOutlet weak var vStackAddress: UIStackView!
    
    @IBOutlet weak var cnstRejectbtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblimageTitle: UILabel!
    
    @IBOutlet weak var cnstInImageHeight: NSLayoutConstraint?
    
    @IBOutlet weak var imgOutTravel: UIImageView!
    @IBOutlet weak var cnstInImageWidth: NSLayoutConstraint!
    
    @IBOutlet weak var cnstOutImageWidth: NSLayoutConstraint!
    @IBOutlet weak var imgInTravel: UIImageView!
    @IBOutlet weak var cnstOutImageHeight: NSLayoutConstraint?
    
    @IBOutlet weak var outTimeNotForManual: UILabel!
    @IBOutlet weak var inTimeNotForManual: UILabel!
    
    @IBOutlet var stkInTimeTitle: UIStackView!
    
    
    @IBOutlet var stkOutTimeTitle: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.salesPlandelegateObject =  self
        self.title = "Attendance Details"
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setData()
        
    }
    func isentryOfSelf()->Bool{
        let attendanceUser = attendanceCheckinDetail?.attendanceuser
        if(attendanceUser?.entity_id == 0){
            attendanceUser?.entity_id = Int(attendanceUser?.userId ?? 0)
        }
        if(attendanceUser?.entity_id == self.activeuser?.userID?.intValue){
            return true
        }else{
            return false
        }
    }
    func setData(){
        let attendanceUser = attendanceCheckinDetail?.attendanceuser
        if(attendanceUser?.entity_id == 0){
            attendanceUser?.entity_id = Int(attendanceUser?.userId ?? 0)
         
        }
        self.lblRequestType.setMultilineLabel(lbl: self.lblRequestType)
        self.lblINTime.setMultilineLabel(lbl: self.lblINTime)
        //set multiline to description
        //            self.inTimeNotForManual.numberOfLines = 0;
        //            self.inTimeNotForManual.lineBreakMode = .byWordWrapping
        //            self.inTimeNotForManual.preferredMaxLayoutWidth = self.inTimeNotForManual.frame.size.width
      //  self.inTimeNotForManual.setMultilineLabel(lbl: self.inTimeNotForManual)
       // self.outTimeNotForManual.setMultilineLabel(lbl: self.outTimeNotForManual)
        //        self.inTimeNotForManual.layoutIfNeeded()
        //        self.inTimeNotForManual.sizeToFit()
        //        self.outTimeNotForManual.layoutIfNeeded()
        //        self.outTimeNotForManual.sizeToFit()
        
        let formater:DateFormatter = DateFormatter.init()
        let user = attendanceCheckinDetail?.attendanceuser               //_AttendanceUser
        let firstName = user?.firstName ?? " "
        let middleSpace = " "
        let lastName = user?.lastName ?? " "
        let fullName = "\(firstName)\(middleSpace)\(lastName)"
        self.lblUserName.text = fullName
        self.lblRequestType.font = UIFont.systemFont(ofSize: 25)
        formater.dateFormat = "dd MMM, yyyy"
        if(attendanceCheckinDetail?.manualAttendance.count ?? 0 > 0){
            //            if (!IsEmpty(attendanceCheckinDetail?.manualAttendance)) {
            
            
            self.lblCheckedIndate.textAlignment = .right
            self.lblCheckedIndate.text = formater.string(from: (attendanceCheckinDetail?.attendanceDate)! as Date)
            
            self.lblRequestType.text = "MANUAL REQUEST"
            self.lblINTime.text = (attendanceCheckinDetail?.manualAttendance)! + " Day"
            self.lblOutTime.text = " "
            self.lblCheckINDate.isHidden = true
            self.inTimeNotForManual.text = attendanceCheckinDetail?.reason
            self.outTimeNotForManual.text = " "
        }else{
            self.lblCheckINDate.isHidden = false
            self.lblCheckINDate.textAlignment = .left
            if let updatedTime = attendanceCheckinDetail?.attendanceDate{
                self.lblCheckINDate.text = formater.string(from: updatedTime as Date)
            }
            self.lblCheckedIndate.text = " "
            self.lblINTime.text = "IN:"
            self.lblOutTime.text = "OUT:"
            if(attendanceUser?.entity_id == 0){
                if(attendanceUser?.userId == self.activeuser?.userID?.int64Value){
                     self.stkInTimeTitle.isHidden = true
                     self.stkOutTimeTitle.isHidden = true
                 }
            }
            else if(attendanceUser?
                    .entity_id == self.activeuser?.userID?.intValue){
                self.stkInTimeTitle.isHidden = true
                self.stkOutTimeTitle.isHidden = true
            }else{
                self.stkInTimeTitle.isHidden = false
                self.stkOutTimeTitle.isHidden = false
            }
            
            //self.inTimeNotForManual.text
            if (attendanceCheckinDetail?.checkInAttendanceType == 0) {
                //                    if(attendanceCheckinDetail.checkInTime){
                //                    if ((!(IsEmpty(attendanceCheckinDetail?.checkInTime))) || (!(IsEmpty(attendanceCheckinDetail?.endTime)))){
                if(attendanceCheckinDetail?.checkInTime !=  nil || attendanceCheckinDetail?.endTime != nil){
                    //
                    //
                    var strForIn = NSMutableAttributedString.init(attributedString: NSAttributedString.init(string: " "))
                    if(attendanceCheckinDetail?.checkInApproved == true ){
                        strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Auto CheckIn"))
                    }else{
                        if(!self.isentryOfSelf()){
                        strForIn =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string:"In"))
                        }else{
                            strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Auto CheckIn"))
                        }
                    }
                   
                self.inTimeNotForManual.isHidden =  false
                    
                    if(attendanceCheckinDetail?.timeIn  != nil){
                        
                        formater.dateFormat = "hh:mm a"
                        
                        strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                        
                        if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                            
                            //  strForIn.append(NSAttributedString.init(string:Utils.getDateWithAppendingDay(day: 0, date: (attendanceCheckinDetail?.updatedTimeIn) as Date, format: "hh:mm a"),attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                            if(self.isentryOfSelf()){
                                strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                            }else{
                            
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                        }
                        if(attendanceCheckinDetail?.checkInApproved == true){
                            if(attendanceCheckinDetail?.checkOutApproved == true){
                                
                                self.inTimeNotForManual.attributedText  = strForIn
                            }else{
                                self.lblINTime.text?.append(contentsOf: "Auto CheckIn")
                            }
                        }else{
                            
                            self.lblINTime.text?.append(contentsOf: "Auto CheckIn")
                            
                        }
                        
                        
                    }else if(attendanceCheckinDetail?.checkInTime != nil){
                        
                        formater.dateFormat = "hh:mm a"
                        strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                        if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                            if(self.isentryOfSelf()){
                                strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                            }else{
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                        }
                        
                        self.inTimeNotForManual.attributedText =  strForIn
                        if(attendanceCheckinDetail?.checkInApproved == true){
                            if(attendanceCheckinDetail?.checkOutApproved == true){
                                self.inTimeNotForManual.attributedText  = strForIn
                            }else{
                                self.lblINTime.text?.append(contentsOf: "Auto CheckIn")
                            }
                        }else{
                            
                            self.lblINTime.text?.append(contentsOf: "Auto CheckIn")
                            
                        }
                    }else   if(attendanceCheckinDetail?.updatedTimeIn  != nil){
                        
                        
                        formater.dateFormat = "hh:mm a"
                        strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                        // strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                        if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                            
                            
                            if(self.isentryOfSelf()){
                                strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                            }else{
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                        }
                        self.inTimeNotForManual.attributedText =  strForIn
                        if(attendanceCheckinDetail?.checkInApproved == true){
                            if(attendanceCheckinDetail?.checkOutApproved == true){
                                self.inTimeNotForManual.attributedText  = strForIn
                            }else{
                                self.lblINTime.text?.append(contentsOf: "Auto CheckIn")
                            }
                        }else{
                            
                            self.lblINTime.text?.append(contentsOf: "Auto CheckIn")
                        }
                    }else{
                        self.inTimeNotForManual.attributedText =  strForIn
                    }
                }
                else{
                    self.inTimeNotForManual.text = " "
                    self.inTimeNotForManual.isHidden = true
                    //tvInTimeTitle.setVisibility(View.INVISIBLE);
                }
            }else if(attendanceCheckinDetail?.checkInAttendanceType == 1){
                
                let strForIn = NSMutableAttributedString.init(string: " ", attributes: [:])
                if(attendanceCheckinDetail?.checkInApproved == true){
                    if(attendanceCheckinDetail?.checkOutApproved == true){
                        strForIn.append(NSAttributedString.init(string: "Office CheckIn", attributes: [:]))//"Office CheckIn"
                    }else{
                        if(!self.isentryOfSelf()){
                        strForIn.append(NSAttributedString.init(string: "In", attributes: [:]))// "In"
                        }else{
                            strForIn.append(NSAttributedString.init(string: "Office CheckIn", attributes: [:]))
                        }
                    }
                }else{
                    if(!self.isentryOfSelf()){
                    strForIn.append(NSAttributedString.init(string: "In", attributes: [:]))//"In"
                    }else{
                        strForIn.append(NSAttributedString.init(string: "Office CheckIn", attributes: [:]))
                    }
                }
                if(attendanceCheckinDetail?.timeIn != nil){
                    formater.dateFormat = "hh:mm a"
                    strForIn.append(NSAttributedString.init(string: "\n", attributes: [:]))
                    strForIn.append(NSAttributedString.init(string: "\n", attributes: [:]))//("\n")
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(attendanceUser?.entity_id == self.activeuser?.userID?.intValue){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }//strForIn.appending()
                    }
                    self.inTimeNotForManual.attributedText  = strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved ==     true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                           
                            self.lblINTime.text?.append(contentsOf: "Office CheckIn")
                        
                        }
                    }else{
                       
                        self.lblINTime.text?.append(contentsOf: "Office CheckIn")
                       
                    }
                }else if(attendanceCheckinDetail?.checkInTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText  = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Office")
                           
                        }
                    }else{
                        if(self.isentryOfSelf()){
                            self.stkInTimeTitle.isHidden = true
                        }else{
                        self.lblINTime.text?.append(contentsOf: "Office")
                        }
                    }
                }else if(attendanceCheckinDetail?.updatedTimeIn != nil){
                    formater.dateFormat = "hh:mm a"
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    
                    }
                    //strForIn.append(NSAttributedString.init(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date),attributes: [:])
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            if(self.isentryOfSelf()){
                                self.stkInTimeTitle.isHidden = true
                            }else{
                            self.lblINTime.text?.append(contentsOf: "Office")
                            }
                        }
                    }else{
                        if(self.isentryOfSelf()){
                            self.stkInTimeTitle.isHidden = true
                        }else{
                        self.lblINTime.text?.append(contentsOf: "Office")
                        }
                    }
                }else{
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText  = strForIn
                        }else{
                            if(self.isentryOfSelf()){
                                self.stkInTimeTitle.isHidden = true
                            }else{
                            self.lblINTime.text?.append(contentsOf: "Office")
                            }
                        }
                    }else{
                        if(self.isentryOfSelf()){
                            self.stkInTimeTitle.isHidden = true
                        }else{
                        self.lblINTime.text?.append(contentsOf: "Office")
                        }
                        
                    }
                }
                // self.inTimeNotForManual.text  = "Office CheckIn";
            }
            
            else if (attendanceCheckinDetail?.checkInAttendanceType == 3) {
                
                
                
                // var strForIn = NSAttributedString(" ")
                let strForIn = NSMutableAttributedString.init(string: " ", attributes: [:])
                //" "
                if(attendanceCheckinDetail?.checkInApproved == true){
                    if(attendanceCheckinDetail?.checkOutApproved == true){
                        strForIn.append(NSAttributedString.init(string: "Vendor CheckIn", attributes: [:]))//"Vendor CheckIn"
                    }else{
                        if(!self.isentryOfSelf()){
                        strForIn.append(NSAttributedString.init(string: "In", attributes: [:]))
                        }else{
                            strForIn.append(NSAttributedString.init(string: "Vendor CheckIn", attributes: [:]))
                        }
                    }
                }else{
                    if(!self.isentryOfSelf()){
                    strForIn.append(NSAttributedString.init(string: "In", attributes: [:]))
                    }else{
                        strForIn.append(NSAttributedString.init(string: "Vendor CheckIn", attributes: [:]))
                    }
                }
                if(attendanceCheckinDetail?.timeIn != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if(((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true))  ){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                      
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    
                    //      let redGenreText = defaultGenreText.applying(attributes: [NSAttributedString.Key.foregroundColor : UIColor.red], toRangesMatching: "Required")
                    //   strForIn = strForIn.
                    self.inTimeNotForManual.attributedText = strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Vendor")
                        }
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Vendor")
                        
                    }
                    
                }else if(attendanceCheckinDetail?.checkInTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                      
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    //strForIn.appending(formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date))
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Vendor")
                        }
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Vendor")
                        
                    }
                }else if(attendanceCheckinDetail?.updatedTimeIn != nil){
                    
                    
                    formater.dateFormat = "hh:mm a"
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                       
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    
                    //strForIn.appending(formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date))
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        self.inTimeNotForManual.attributedText = strForIn
                    }else{
                        self.inTimeNotForManual.attributedText = strForIn
                        self.lblINTime.text?.append(contentsOf: "Vendor")
                        
                    }
                }else{
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Vendor")
                        }
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Vendor")
                        
                    }
                }
                var Instr = self.inTimeNotForManual.text
                Instr?.append("\n")
                Instr?.append(attendanceCheckinDetail?.clientName ?? " ")
                self.inTimeNotForManual.text = Instr
                
            }
            else if (attendanceCheckinDetail?.checkInAttendanceType == 2) {
                // self.inTimeNotForManual.text  = "Customer CheckIn";
                //3
                var strForIn = NSMutableAttributedString.init(string: " ", attributes: [:])
                if(attendanceCheckinDetail?.checkInApproved == true){
                    if(attendanceCheckinDetail?.checkOutApproved == true){
                        strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Customer CheckIn"))
                    }else{
                        if(!self.isentryOfSelf()){
                        strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "In"))
                        }else{
                            strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Customer CheckIn"))
                    }
                    }
                }else{
                    if(!self.isentryOfSelf()){
                    strForIn =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "In"))
                    }else{
                        strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Customer CheckIn"))
                    }
                }
                if(attendanceCheckinDetail?.timeIn != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    
                    //strForIn.appending(formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date))
                    self.inTimeNotForManual.attributedText = strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Customer ")
                        }
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Customer ")
                        
                    }
                    
                }else if(attendanceCheckinDetail?.checkInTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                            
                        
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    } //strForIn.appending(formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date))
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Customer ")
                        }
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Customer ")
                        
                    }
                }else if(attendanceCheckinDetail?.updatedTimeIn != nil){
                    
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    //strForIn.appending(formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date))
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Customer ")
                        }
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Customer ")
                        
                    }
                }else{
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Customer ")
                        }
                        
                        
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Customer ")
                        
                    }
                }
                
                var Instr = self.inTimeNotForManual.text
                Instr?.append("\n")
               // Instr?.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.clientName ?? " ")), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                Instr?.append(attendanceCheckinDetail?.clientName ?? " ")
                
                self.inTimeNotForManual.text = Instr
                
                
            } else if (attendanceCheckinDetail?.checkInAttendanceType == 4) {
                
                var strForIn = NSMutableAttributedString.init(string: " ", attributes: [:])
                if(attendanceCheckinDetail?.checkInApproved == true){
                    if(attendanceCheckinDetail?.checkOutApproved == true){
                        strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Travel Local CheckIn"))
                        //"Travel Local CheckIn"
                    }else{
                        if(!self.isentryOfSelf()){
                        strForIn =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "In"))//"In"
                        }else{
                            strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Travel Local CheckIn"))
                        }
                    }
                }else{
                    if(!self.isentryOfSelf()){
                    strForIn =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "In"))
                    }else{
                        strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Travel Local CheckIn"))
                    }
                }
                
                if(attendanceCheckinDetail?.timeIn != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    
                    self.inTimeNotForManual.attributedText = strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Travel Local")
                        }
                    }else{
                        self.inTimeNotForManual.text = self.inTimeNotForManual.text?.appending("\n In")
                        // self.inTimeNotForManual.text  = "In"
                        
                        self.lblINTime.text?.append(contentsOf: "Travel Local")
                        
                    }
                    
                    
                    
                }else if(attendanceCheckinDetail?.checkInTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "           ", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if((attendanceCheckinDetail?.checkOutApproved == true) && (!self.isentryOfSelf())){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Travel Local")
                        }
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Travel Local")
                        
                    }
                }else if(attendanceCheckinDetail?.updatedTimeIn != nil){
                    
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Travel Local")
                        }
                    }else{
                        
                        self.inTimeNotForManual.attributedText = strForIn
                        
                        self.lblINTime.text?.append(contentsOf: "Travel Local")
                        
                    }
                    
                }else{
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Travel Local")
                        }
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Travel Local")
                        
                    }
                }
            } else if (attendanceCheckinDetail?.checkInAttendanceType == 7) {
                //  self.inTimeNotForManual.text  = "Travel Upcountry CheckIn";
              
                var strForIn = NSMutableAttributedString.init(string: " ", attributes: [:])
                if(attendanceCheckinDetail?.checkInApproved == true){
                    if(attendanceCheckinDetail?.checkOutApproved == true){
                        strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Travel Upcountry CheckIn"))//"Travel Upcountry CheckIn"
                    }else{
                        if(!self.isentryOfSelf()){
                        strForIn =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "In"))//"In"
                        }else{
                            strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Travel Upcountry CheckIn"))
                        }
                    }
                }else{
                    if(!self.isentryOfSelf()){
                    strForIn =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "In"))
                    }else{
                        strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Travel Upcountry CheckIn"))
                    }
                }
                
                if(attendanceCheckinDetail?.timeIn != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                   strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                  
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{

                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{


                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    self.inTimeNotForManual.attributedText = strForIn
                  
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        if(attendanceCheckinDetail?.checkOutApproved == true){
                            self.inTimeNotForManual.attributedText = strForIn
                        }else{
                            self.lblINTime.text?.append(contentsOf: "Travel Upcountry")
                        }
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Travel Upcountry")
                        
                    }
                    
                }else if(attendanceCheckinDetail?.checkInTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                
                     
                     
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    } //strForIn.appending(formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date))
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        self.inTimeNotForManual.attributedText = strForIn
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Travel Upcountry")
                    }
                }else if(attendanceCheckinDetail?.updatedTimeIn != nil){
                    
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    } //strForIn.appending(formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date))
                    self.inTimeNotForManual.attributedText =  strForIn
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        self.inTimeNotForManual.attributedText = strForIn
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Travel Upcountry")
                        
                    }
                }else{
                    
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        self.inTimeNotForManual.attributedText = strForIn
                    }else{
                        
                        self.lblINTime.text?.append(contentsOf: "Travel Upcountry")
                        
                    }
                }
                
            } else if (attendanceCheckinDetail?.checkInAttendanceType == 8) {
                //  self.inTimeNotForManual.text  = "Home CheckIn";
                
                var strForIn = NSMutableAttributedString.init(string: " ", attributes: [:])
                if(attendanceCheckinDetail?.checkInApproved == true){
                    if(attendanceCheckinDetail?.checkOutApproved == true){
                        strForIn = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Home CheckIn"))//"Home CheckIn"
                    }else{
                        strForIn =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "In"))//"In"
                    }
                }else{
                    strForIn =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "In"))//"In"
                }
                if(attendanceCheckinDetail?.timeIn != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    //strForIn.appending(formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date))
                    self.inTimeNotForManual.attributedText = strForIn
                    
                    
                }else if(attendanceCheckinDetail?.checkInTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    
                    //strForIn.appending(formater.string(from: (attendanceCheckinDetail?.checkInTime)! as Date))
                    self.inTimeNotForManual.attributedText =  strForIn
                }else if(attendanceCheckinDetail?.updatedTimeIn != nil){
                    
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForIn.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        if(self.isentryOfSelf()){
                            strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForIn.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    //strForIn.appending(formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date))
                    self.inTimeNotForManual.attributedText =  strForIn
                }else{
                    self.inTimeNotForManual.attributedText =  strForIn
                }
                
                if(attendanceCheckinDetail?.checkInApproved == true){
                    self.inTimeNotForManual.attributedText = strForIn
                }else{
                    
                    self.lblINTime.text?.append(contentsOf: "Home")
                    
                }
                
                
                self.inTimeNotForManual.text = self.inTimeNotForManual.text
            } else {
                self.inTimeNotForManual.isHidden = true
                // tvInTimeTitle.setVisibility(View.INVISIBLE);
            }
            
            //                self.inTimeNotForManual.numberOfLines = 0;
            //                self.inTimeNotForManual.lineBreakMode = .byWordWrapping
            //                self.inTimeNotForManual.preferredMaxLayoutWidth = self.inTimeNotForManual.frame.size.width
            //
            //                self.outTimeNotForManual.numberOfLines = 0;
            //                self.outTimeNotForManual.lineBreakMode = .byWordWrapping
            //                self.outTimeNotForManual.preferredMaxLayoutWidth = self.outTimeNotForManual.frame.size.width
            
            if (attendanceCheckinDetail?.checkInAttendanceType == 0) {
                if ((attendanceCheckinDetail?.checkOutTime != nil) || (attendanceCheckinDetail?.timeOut  != nil)){
                    //                self.outTimeNotForManual.text = "Auto CheckOut";
                self.outTimeNotForManual.isHidden =  false;
                 //   self.vwOutTimeNotForManual.isHidden = false
                    
                    var strForOut = NSMutableAttributedString.init(attributedString: NSAttributedString.init(string: " "))
                    
                    
                    if(attendanceCheckinDetail?.checkOutApproved == true){
                        if(attendanceCheckinDetail?.checkInApproved == true){
                            strForOut = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Auto CheckOut"))//"Auto CheckOut"
                        }else{
                            strForOut =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Out"))//"Out"
                            self.lblOutTime.text?.append(contentsOf: "Auto")
                        }
                    }else{
                        strForOut =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Out"))//"Out"
                        
                        self.lblOutTime.text?.append(contentsOf: "Auto")
                        
                    }
                    
                    if(attendanceCheckinDetail?.timeOut != nil){
                        
                        formater.dateFormat = "hh:mm a"
                        strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                        strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                        if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                            
                            if(self.isentryOfSelf()){
                                strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                            }else{
                            
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                            }
                        }
                        //                            strForOut = strForOut.appending("\n")
                        //                            strForOut = strForOut.appending("\n")
                        // strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date))
                        self.outTimeNotForManual.attributedText  = strForOut
                        
                        
                    }else if(attendanceCheckinDetail?.checkOutTime != nil){
                        
                        formater.dateFormat = "hh:mm a"
                        
                        strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                        strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                        if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                            
                            
                            if(self.isentryOfSelf()){
                                strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                            }else{
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                            }
                        }
                        
                        self.outTimeNotForManual.attributedText =  strForOut
                    }else if(attendanceCheckinDetail?.updatedTimeOut != nil){
                        
                        formater.dateFormat = "hh:mm a"
                        
                        strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                        strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                        if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                            
                            if(self.isentryOfSelf()){
                                strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeIn)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                            }else{
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                            }
                        }
                        //     strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date))
                        self.outTimeNotForManual.attributedText =  strForOut
                    }else{
                        self.outTimeNotForManual.attributedText =  strForOut
                    }
                    //  tvOutTimeTitle.setText("Auto CheckOut");
                }
                else{
                 //   self.vwOutTimeNotForManual.isHidden = true
                    self.outTimeNotForManual.isHidden = true;
                    // tvOutTimeTitle.setVisibility(View.INVISIBLE);
                }
            } else if (attendanceCheckinDetail?.checkOutAttendanceType == 1) {
                //  self.outTimeNotForManual.text = "Office CheckOut";
                
                var strForOut = NSMutableAttributedString.init(attributedString: NSAttributedString.init(string: " "))
                if(attendanceCheckinDetail?.checkOutApproved == true){
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        strForOut = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Office CheckOut"))//"Office CheckOut"
                    }else{
                        strForOut =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Office CheckOut"))//"Out"
                        self.lblOutTime.text?.append(contentsOf: "Office")
                        
                    }
                }else{
                    strForOut =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Out"))//"Out"
                    self.lblOutTime.text?.append(contentsOf: "Office")
                }
                if(attendanceCheckinDetail?.timeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    
                    self.outTimeNotForManual.attributedText  = strForOut
                    
                    
                }else if(attendanceCheckinDetail?.checkOutTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    self.outTimeNotForManual.attributedText =  strForOut
                }else if(attendanceCheckinDetail?.updatedTimeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkInApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    self.outTimeNotForManual.attributedText =  strForOut
                }else{
                    self.outTimeNotForManual.attributedText =  strForOut
                }
            }
            /*else if(attendanceCheckinDetail?.checkOutAttendanceType == 2){
             self.lblOutTime.text = " "
             self.outTimeNotForManual.text  = " "
             }*/
            else if (attendanceCheckinDetail?.checkOutAttendanceType == 3) {
                //  self.outTimeNotForManual.text = "Vendor CheckOut";
                
                var strForOut = NSMutableAttributedString.init(attributedString: NSAttributedString.init(string: " "))
                if(attendanceCheckinDetail?.checkOutApproved == true){
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        strForOut.append(NSAttributedString.init(string: "Vendor CheckOut", attributes: [:]))
                    }else{
                        if(!self.isentryOfSelf()){
                        strForOut.append(NSAttributedString.init(string: "Out", attributes: [:]))
                        }else{
                            strForOut.append(NSAttributedString.init(string: "Vendor CheckOut", attributes: [:]))
                        }
                        self.lblOutTime.text?.append(contentsOf: "Vendor")
                    }
                }else{
                    if(!self.isentryOfSelf()){
                    strForOut =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Out"))
                    }else{
                        strForOut.append(NSAttributedString.init(string: "Vendor CheckOut", attributes: [:]))
                    }
                    self.lblOutTime.text?.append(contentsOf: "Vendor")
                }
                if(attendanceCheckinDetail?.timeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    
                    //                   strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date))
                    self.outTimeNotForManual.attributedText =  strForOut
                    
                    
                }else if(attendanceCheckinDetail?.checkOutTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                    
                    if(self.isentryOfSelf()){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    //strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.checkOutTime)!))
                    self.outTimeNotForManual.attributedText =  strForOut
                }else if(attendanceCheckinDetail?.updatedTimeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                       
                            
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    //strForOut = strForOut.appending("\n")
                    
                    //strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date))
                    self.outTimeNotForManual.attributedText =  strForOut
                }
                    self.outTimeNotForManual.attributedText =  strForOut
                
                
                var Instr = self.outTimeNotForManual.text
                Instr?.append("\n")
                Instr?.append(attendanceCheckinDetail?.checkOutClientName ?? " ")
                
                self.outTimeNotForManual.text = Instr
        }
            else if (attendanceCheckinDetail?.checkOutAttendanceType == 2) {
                //self.outTimeNotForManual.text = "Customer CheckOut";
                //3
                var strForOut = NSMutableAttributedString.init(attributedString: NSAttributedString.init(string: " "))
                if(attendanceCheckinDetail?.checkOutApproved == true){
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        strForOut.append(NSAttributedString.init(string: "Customer CheckOut", attributes: [:]))
                    }else{
                        if(!self.isentryOfSelf()){
                        strForOut.append(NSAttributedString.init(string: "Out", attributes: [:]))
                        }else{
                            strForOut.append(NSAttributedString.init(string: "Customer CheckOut", attributes: [:]))
                        }
                        self.lblOutTime.text?.append(contentsOf: "Customer")
                    }
                }else{
                    if(!self.isentryOfSelf()){
                    strForOut =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Out"))
                    }else{
                        strForOut.append(NSAttributedString.init(string: "Customer CheckOut", attributes: [:]))
                    }
                    self.lblOutTime.text?.append(contentsOf: "Customer")
                }
                if(attendanceCheckinDetail?.timeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                            }
                    }
                    //strForOut = strForOut.appending("\n")
                    
                    //strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date))
                    self.outTimeNotForManual.attributedText  = strForOut
                    
                    
                }else if(attendanceCheckinDetail?.checkOutTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    //strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.checkOutTime)!))
                    self.outTimeNotForManual.attributedText =  strForOut
                }else if(attendanceCheckinDetail?.updatedTimeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    //           strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date))
                    self.outTimeNotForManual.attributedText =  strForOut
                }else{
                    self.outTimeNotForManual.attributedText =  strForOut
                }
                var Instr = self.outTimeNotForManual.text
                Instr?.append("\n")
                Instr?.append(attendanceCheckinDetail?.checkOutClientName ?? " ")
                
                self.outTimeNotForManual.text = Instr
            } else if (attendanceCheckinDetail?.checkOutAttendanceType == 4) {
                
                var strForOut = NSMutableAttributedString.init(attributedString: NSAttributedString.init(string: " "))
             
                if(attendanceCheckinDetail?.checkOutApproved == true){
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        strForOut.append(NSAttributedString.init(string: "Travel Local CheckOut", attributes: [:]))
                    }else{
                        if(!self.isentryOfSelf()){
                        strForOut.append(NSAttributedString.init(string: "Out", attributes: [:]))
                        }else{
                            strForOut.append(NSAttributedString.init(string: "Travel Local CheckOut", attributes: [:]))
                        }
                        self.lblOutTime.text?.append(contentsOf: "Travel Local")
                    }
                }else{
                    if(!self.isentryOfSelf()){
                    strForOut =  NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Out"))
                    }else{
                        strForOut.append(NSAttributedString.init(string: "Travel Local CheckOut", attributes: [:]))
                    }
                    self.lblOutTime.text?.append(contentsOf: "Travel Local")
                }
                if(attendanceCheckinDetail?.timeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    //strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date))
                    self.outTimeNotForManual.attributedText =  strForOut
                    
                    
                }else if(attendanceCheckinDetail?.checkOutTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    
                    //     strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.checkOutTime)!))
                    self.outTimeNotForManual.attributedText =  strForOut
                }else if(attendanceCheckinDetail?.updatedTimeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    //strForOut = strForOut.appending(formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date))
                    self.outTimeNotForManual.attributedText =  strForOut
                }else{
                    self.outTimeNotForManual.attributedText =  strForOut
                }
            } else if (attendanceCheckinDetail?.checkOutAttendanceType == 7) {
                //  self.outTimeNotForManual.text = "Travel Upcountry CheckOut";
                
                var strForOut = NSMutableAttributedString.init(attributedString: NSAttributedString.init(string: " "))
                if(attendanceCheckinDetail?.checkOutApproved == true){
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        strForOut.append(NSAttributedString.init(string: "Travel Upcountry CheckOut", attributes: [:]))
                    }else{
                        if(!self.isentryOfSelf()){
                        strForOut.append(NSAttributedString.init(string: "Out", attributes: [:]))
                        }else{
                            strForOut.append(NSAttributedString.init(string: "Travel Upcountry CheckOut", attributes: [:]))
                        }
                        self.lblOutTime.text?.append(contentsOf: "Travel Upcountry")
                    }
                }else{
                    if(!self.isentryOfSelf()){
                    strForOut = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Out"))
                    }else{
                        strForOut.append(NSAttributedString.init(string: "Travel Upcountry CheckOut", attributes: [:]))
                    }
                    self.lblOutTime.text?.append(contentsOf: "Travel Upcountry")
                }
                
                if(attendanceCheckinDetail?.timeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    self.outTimeNotForManual.attributedText =  strForOut
                    
                    
                }else if(attendanceCheckinDetail?.checkOutTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                       
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    self.outTimeNotForManual.attributedText =  strForOut
                }else if(attendanceCheckinDetail?.updatedTimeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    self.outTimeNotForManual.attributedText =  strForOut
                }else{
                    self.outTimeNotForManual.attributedText =  strForOut
                }
            } else if (attendanceCheckinDetail?.checkOutAttendanceType  == 8) {
                //  self.outTimeNotForManual.text = "Home CheckOut";
                
                var strForOut = NSMutableAttributedString.init(attributedString: NSAttributedString.init(string: " "))
                if(attendanceCheckinDetail?.checkOutApproved == true){
                    if(attendanceCheckinDetail?.checkInApproved == true){
                        strForOut.append(NSAttributedString.init(string: "Home CheckOut", attributes: [:]))
                    }else{
                        
                        if(!self.isentryOfSelf()){
                        strForOut.append(NSAttributedString.init(string: "Out", attributes: [:]))
                        }else{
                            strForOut.append(NSAttributedString.init(string: "Home CheckOut", attributes: [:]))
                        }
                        self.lblOutTime.text?.append(contentsOf: "HomeTravel")
                    }
                }else{
                    if(!self.isentryOfSelf()){
                    strForOut = NSMutableAttributedString.init(attributedString:NSAttributedString.init(string: "Out"))
                    }else{
                        strForOut.append(NSAttributedString.init(string: "Home CheckOut", attributes: [:]))
                    }
                    self.lblOutTime.text?.append(contentsOf: "HomeTravel")
                }
                if(attendanceCheckinDetail?.timeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        
                        
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.timeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    self.outTimeNotForManual.attributedText =  strForOut
                    
                    
                }else if(attendanceCheckinDetail?.checkOutTime != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.checkOutTime)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                    }
                    }
                    self.outTimeNotForManual.attributedText =  strForOut
                }else if(attendanceCheckinDetail?.updatedTimeOut != nil){
                    
                    formater.dateFormat = "hh:mm a"
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    
                    strForOut.append(NSAttributedString.init(attributedString: NSAttributedString.init(string: "\n", attributes: [:])))
                    if((attendanceCheckinDetail?.checkOutApproved == true) || (attendanceCheckinDetail?.manualApproved == true)){
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                    }else{
                        
                        if(self.isentryOfSelf()){
                            strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
                        }else{
                        strForOut.append(NSAttributedString.init(string: formater.string(from: (attendanceCheckinDetail?.updatedTimeOut)! as Date), attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor]))
                        }
                    }
                    self.outTimeNotForManual.attributedText =  strForOut
                }else{
                    self.outTimeNotForManual.attributedText =  strForOut
                }
                
            } else {
              self.outTimeNotForManual.isHidden = false
                //  tvOutTimeTitle.setVisibility(View.INVISIBLE);
            }
            
            if ((((attendanceCheckinDetail?.checkInTime) != nil) || ((attendanceCheckinDetail?.checkOutTime) != nil)) && (((attendanceCheckinDetail?.updatedTimeIn) != nil) || ((attendanceCheckinDetail?.updatedTimeOut) != nil))) {
                
                if(attendanceCheckinDetail?.checkInApproved == true  && attendanceCheckinDetail?.checkOutApproved == true){
                    self.lblRequestType.text = ""
                    
                }else if(attendanceCheckinDetail?.checkInApproved == true){
                    self.lblRequestType.text = "CheckOut Request"
                }else if(attendanceCheckinDetail?.checkOutApproved == true){
                    self.lblRequestType.text  = "CheckIn Request"
                }else{
                    self.lblRequestType.text = "CheckInOut Request"
                }
                
            }else if((((attendanceCheckinDetail?.checkInTime) != nil) && ((attendanceCheckinDetail?.checkOutTime) != nil)) || (((attendanceCheckinDetail?.updatedTimeIn) != nil) && ((attendanceCheckinDetail?.updatedTimeOut) != nil))) {
                if(attendanceCheckinDetail?.checkInApproved == true  && attendanceCheckinDetail?.checkOutApproved == true){
                    self.lblRequestType.text = ""
                }else if(attendanceCheckinDetail?.checkInApproved == true){
                    self.lblRequestType.text = "CheckOut Request"
                }else if(attendanceCheckinDetail?.checkOutApproved == true){
                    self.lblRequestType.text  = "CheckIn Request"
                }else{
                    self.lblRequestType.text = "CheckInOut Request"
                }
            }else if(((attendanceCheckinDetail?.checkInTime) != nil) || ((attendanceCheckinDetail?.updatedTimeIn) != nil)) {
                if(attendanceCheckinDetail?.checkInApproved == true){
                    self.lblRequestType.text = ""
                }else{
                    self.lblRequestType.text = "CheckIn Request"
                    
                    self.lblOutTime.isHidden = true
                    self.stkOutTimeTitle.isHidden = true
                    
                }
                
            }else{
                if(attendanceCheckinDetail?.checkOutApproved == true){
                    self.lblRequestType.text = ""
                }else{
                    self.lblRequestType.text  = "CheckOut Request"
                    self.lblINTime.isHidden = true
                    self.stkInTimeTitle.isHidden = true
                }
            }
            
            
        
        
        
      
        
        //For Approve Reject button Visible
        if(self.activeuser?.role?.id == 5 || self.activeuser?.role?.id  == 6 || self.activeuser?.role?.id  == 7 || self.activeuser?.role?.id  == 8){
            /*if(attendanceCheckinDetail?.manualAttendance == nil){
             if((attendanceCheckinDetail?.checkInApproved == true) && (attendanceCheckinDetail?.checkOutApproved == true)){
             
             btnAccept.isHidden = true
             btnReject.isHidden = true
             
             stkCheckInOutRequest.isHidden = true
             
             }else{
             btnAccept.isHidden = false
             btnReject.isHidden = false
             }
             }else{
             if((attendanceCheckinDetail?.manualApproved)!){
             btnAccept.isHidden = true
             btnReject.isHidden = true
             stkCheckInOutRequest.isHidden = true
             stkInTimeTitle.isHidden = true
             stkOutTimeTitle.isHidden = true
             stkBtnAcceptReject.isHidden = true
             }else{
             //cnstAcceptbtnHeight.constant = 40
             if((attendanceCheckinDetail?.checkInApproved == true) && (attendanceCheckinDetail?.checkInApproved == true)){
             btnAccept.isHidden = true
             btnReject.isHidden = true
             stkCheckInOutRequest.isHidden = true
             stkInTimeTitle.isHidden = true
             stkOutTimeTitle.isHidden = true
             stkBtnAcceptReject.isHidden = true
             }else{
             btnAccept.isHidden = false
             btnReject.isHidden = false
             stkBtnAcceptReject.isHidden = false
             }
             }
             }*/
            /*if(attendanceCheckinDetail?.manualAttendance == nil){
             if((attendanceCheckinDetail?.checkInApproved == true) && (attendanceCheckinDetail?.checkInApproved == true)){
             btnAccept.isHidden = true
             btnReject.isHidden = true
             stkCheckInOutRequest.isHidden = true
             stkInTimeTitle.isHidden = true
             stkOutTimeTitle.isHidden = true
             stkBtnAcceptReject.isHidden = true
             }else{
             btnAccept.isHidden = false
             btnReject.isHidden = false
             stkBtnAcceptReject.isHidden = false
             }
             }else
             if let manualattendance  = attendanceCheckinDetail?.manualAttendance as? String{
             if(manualattendance.count == 0){
             if((attendanceCheckinDetail?.checkInApproved == true) && (attendanceCheckinDetail?.checkInApproved == true)){
             btnAccept.isHidden = true
             btnReject.isHidden = true
             stkCheckInOutRequest.isHidden = true
             stkInTimeTitle.isHidden = true
             stkOutTimeTitle.isHidden = true
             stkBtnAcceptReject.isHidden = true
             }else{
             btnAccept.isHidden = false
             btnReject.isHidden = false
             stkBtnAcceptReject.isHidden = false
             }
             }else{
             if let manualstatus =  attendanceCheckinDetail?.manualApproved as? Bool{
             if(!manualstatus){
             btnAccept.isHidden = true
             btnReject.isHidden = true
             stkCheckInOutRequest.isHidden = true
             stkInTimeTitle.isHidden = true
             stkOutTimeTitle.isHidden = true
             stkBtnAcceptReject.isHidden = true
             }else{
             btnAccept.isHidden = false
             btnReject.isHidden = false
             stkBtnAcceptReject.isHidden = false
             }
             }else{
             
             }
             }
             }*/
            
            print("Detail = \(attendanceCheckinDetail)")
            if((attendanceCheckinDetail?.manualAttendance.count ?? 0 > 0) && (attendanceCheckinDetail?.manualApproved == true)){
                self.visibilestkbtn(visibility: true)
                
            }else if (((attendanceCheckinDetail?.checkInApproved == true) && (attendanceCheckinDetail?.checkInTime !=  nil) ) && ((attendanceCheckinDetail?.checkOutApproved == true) && (attendanceCheckinDetail?.checkOutTime != nil))) {
                self.visibilestkbtn(visibility: true)
                
            }else if(attendanceCheckinDetail?.leaveType.lowercased() == "absent"){
                self.visibilestkbtn(visibility: true)
            }else if(attendanceCheckinDetail?.leaveType.lowercased() == "holiday"){
                self.visibilestkbtn(visibility: true)
            }
            else if(((attendanceCheckinDetail?.checkInApproved == true) && (attendanceCheckinDetail?.checkInTime !=  nil)) && ((attendanceCheckinDetail?.checkOutApproved == true) && (attendanceCheckinDetail?.checkOutTime == nil))) {
                self.visibilestkbtn(visibility: true)
            }else if((attendanceCheckinDetail?.checkInApproved == true) && (attendanceCheckinDetail?.checkOutApproved == true) && (attendanceCheckinDetail?.manualAttendance.count ?? 0 == 0 )){
                self.visibilestkbtn(visibility: true)
            }else if((attendanceCheckinDetail?.manualAttendance.count ?? 0 > 0  && attendanceCheckinDetail?.manualApproved == true)){
                self.visibilestkbtn(visibility: true)
            }else{
                self.visibilestkbtn(visibility: false)
            }
            
        }
        
        if (attendanceCheckinDetail?.checkInPhotoURL ==  nil) {
            self.cnstInImageHeight?.constant = 0
            self.imgInTravel.image = nil;
        }else{
            self.cnstInImageHeight?.constant = 100
            //(self.view.frame.size.width - 10) / 2;
            self.cnstInImageWidth?.constant = 100
            //(self.view.frame.size.width - 10) / 2;
            let strForCheckOut = attendanceCheckinDetail?.checkInPhotoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print("picture  checkout url = \(strForCheckOut)")
            
            self.imgInTravel.sd_setImage(with: URL.init(string: strForCheckOut ?? "56tr"), placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                print("image downloaded")
                if(err !=  nil){
                    self.imgInTravel.image = nil
                    // Utils.toastmsg(message:err?.localizedDescription)
                }
            }
            //              self.imgInTravel.setImageWith(URL.init(string: strForCheckOut!)!, placeholderImage: UIImage.init(imageLiteralResourceName: "User_default_icon_grey"))
            self.imgInTravel.clipsToBounds = true;
            //               self.cnstInImageHeight?.constant = (self.view.frame.size.width - 10) / 2.0 ;
            self.imgInTravel.layer.cornerRadius = 50 //self.imgInTravel.frame.size.width / 2.0;
            print(self.imgInTravel.layer.cornerRadius)
            let tapRecogniser = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTapInImageTouch(_:)))
            self.imgInTravel.isUserInteractionEnabled = true
            self.imgInTravel.addGestureRecognizer(tapRecogniser)
            
        }
        if (attendanceCheckinDetail?.checkOutPhotoURL == nil) {
            self.cnstOutImageHeight?.constant = 0
            self.imgOutTravel.image = nil
        }else{
            
            let strForCheckin = attendanceCheckinDetail?.checkOutPhotoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            self.imgOutTravel.sd_setImage(with: URL.init(string: strForCheckin ?? " "), placeholderImage: UIImage.init(named: "tg76"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                print("image downloaded")
                if(err !=  nil){
                    self.imgOutTravel.image = nil
                    //Utils.toastmsg(message:err?.localizedDescription)
                }
            }
            self.imgOutTravel.clipsToBounds = true;
            self.imgOutTravel.layer.cornerRadius = 50
            print(self.imgOutTravel.layer.cornerRadius)
            self.imgOutTravel.clipsToBounds = true
            let taponRecogniser = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTapOutImageTouch(_:)))
            self.imgOutTravel.isUserInteractionEnabled = true
            self.imgOutTravel.addGestureRecognizer(taponRecogniser)
        }
        
        self.btnAccept.layer.cornerRadius = 10;
        self.btnReject.layer.cornerRadius = 10;
        //            self.lblCheckOutAddress.numberOfLines = 0
        //            self.lblCheckOutAddress.preferredMaxLayoutWidth = self.lblCheckOutAddress.frame.size.width
        //            self.lblCheckOutAddress.lineBreakMode = .byWordWrapping
        
        //            self.lblCheckInAddress.numberOfLines = 0
        //            self.lblCheckInAddress.preferredMaxLayoutWidth = self.lblCheckInAddress.frame.size.width
        //            self.lblCheckInAddress.lineBreakMode = .byWordWrapping
//        self.lblCheckInAddress.setMultilineLabel(lbl: self.lblCheckInAddress)
//        self.lblCheckOutAddress.setMultilineLabel(lbl: self.lblCheckOutAddress)
        
        if(self.attendanceCheckinDetail?.checkInAddress.count ?? 0 > 0){
            var checkInTitle = " "
            
            if((self.attendanceCheckinDetail?.checkInAttendanceType == 1)||(self.attendanceCheckinDetail?.checkInAttendanceType == 4)){
                checkInTitle = "CheckIn Add:"
            }else{
                //                if(self.lblUserName.text?.count ?? 0 > 0){
                //                    checkInTitle = self.lblUserName.text ?? " "
                //                    checkInTitle.append("\n")
                //            }
                checkInTitle.append("CheckIn Add:")
            }
            if(self.attendanceCheckinDetail?.checkInApproved == true){
                checkInTitle = "CheckIn Add:"
            }else{
                checkInTitle = "CheckIn Address:"
            }
            let totalAddressCheckIn = "\(checkInTitle) \(self.attendanceCheckinDetail?.checkInAddress ?? " ")"
            self.lblCheckInAddress.text = totalAddressCheckIn
        }
        else{
            self.lblCheckInAddress.text = " "
        }
        
        if(self.attendanceCheckinDetail?.checkOutAddress.count ?? 0 > 0){
            
            var checkOutTitle = " "
            
            if((self.attendanceCheckinDetail?.checkInAttendanceType == 1)||(self.attendanceCheckinDetail?.checkInAttendanceType == 4)){
                checkOutTitle = "CheckOut Add:"
            }else{
                //                if(self.lblUserName.text?.count ?? 0 > 0){
                //                    checkOutTitle = self.lblUserName.text ?? " "
                //                    checkOutTitle.append("\n")
                //                }
                checkOutTitle.append("CheckOut Add:")
            }
            if(self.attendanceCheckinDetail?.checkInApproved == true){
                checkOutTitle = "CheckOut Add:"
            }else{
                checkOutTitle = "CheckOut Address:"
            }
            //        let checkOutTitle = "CheckOut Add:"
            let totalAddressCheckOut = "\(checkOutTitle) \(self.attendanceCheckinDetail?.checkOutAddress ?? " ")"
            self.lblCheckOutAddress.text = totalAddressCheckOut
            //self.attendanceCheckinDetail?.checkInAddressID
        }else{
            self.lblCheckOutAddress.text = " "
        }
        if((self.attendanceCheckinDetail?.manualAttendance.count ?? 0 > 0) && (self.attendanceCheckinDetail?.manualApproved == true)){
            
            self.btnAccept.isHidden = true
            self.btnReject.isHidden = true
        }else if(((self.attendanceCheckinDetail?.checkInApproved == true) && (self.attendanceCheckinDetail?.checkInTime !=  nil)) && ((self.attendanceCheckinDetail?.checkOutApproved == true) && (self.attendanceCheckinDetail?.checkOutTime != nil))){
            
            self.btnAccept.isHidden = true
            self.btnReject.isHidden = true
        }else if(self.attendanceCheckinDetail?.leaveType.lowercased() == "absent"){
            
            self.btnAccept.isHidden = true
            self.btnReject.isHidden = true
        }else{
            
            self.btnAccept.isHidden = false
            self.btnReject.isHidden = false
        }
        if(isFromHistory == true){
            self.btnAccept.isHidden = true
            self.btnReject.isHidden = true
            self.lblRequestType.text = ""
        }
    }
        
        //set round image of user
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.height/2.0;
        
        self.imgUser.clipsToBounds = true;
        if (user?.picture == nil) {
            if(user?.userImagePath == nil){
                self.lblimageTitle.isHidden = false;
                
                self.lblimageTitle.textColor = .white
                self.lblimageTitle.font = UIFont.boldSystemFont(ofSize: 25)
                self.lblimageTitle.text = String(user?.firstName.prefix(1) ?? "T").capitalized
                
                self.imgUser.backgroundColor = Common().UIColorFromRGB(rgbValue: 0x2A718E)
                //RGB(227, 237, 250);
                
                self.imgUser.image = nil;
            }else{
                self.lblimageTitle.isHidden = true;
                let strForUser = user?.userImagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                print("picture user url = \(strForUser)")
                self.imgUser.sd_setImage(with: URL.init(string: strForUser ?? "gdfd"), placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                    print("image downloaded")
                    // self.imgUser.image = nil
                }
                //  self.imgUser.setImageWith(URL.init(string: strForUser ?? " ")!, placeholderImage: UIImage.init(imageLiteralResourceName: "User_default_icon_grey"))
            }
            
            
            
        }else{
            self.lblimageTitle.isHidden = true;
            let strForUserPicture = user?.picture.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            self.imgUser.sd_setImage(with: URL.init(string: strForUserPicture ?? "h56"), placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                print("image downloaded")
                //  self.imgUser.image = nil
            }
            //                self.imgUser.setImageWith(URL.init(string: strForUserPicture ?? " ")!, placeholderImage: UIImage.init(imageLiteralResourceName: "User_default_icon_grey"))
            
        }
        stkAttendanceType.layoutSubviews()
        stkAttendanceType.layoutIfNeeded()
        if(isFromHistory == true){
            stkInTimeTitle.isHidden = true
            stkOutTimeTitle.isHidden = true
            self.btnAccept.isHidden = true
            self.btnReject.isHidden = true
            self.lblRequestType.text = ""
        }
        
    }
    /*
     else if(((self.attendanceCheckinDetail?.checkInApproved == true) && (self.attendanceCheckinDetail?.checkInTime !=  nil))){
     self.btnAccept.isHidden = true
     self.btnReject.isHidden = true
     }else if(((self.attendanceCheckinDetail?.checkOutApproved == true) && (self.attendanceCheckinDetail?.checkOutTime != nil))){
     self.btnAccept.isHidden = true
     self.btnReject.isHidden = true
     }
     **/
    
    
    
    func  visibilestkbtn(visibility:Bool){
        if(visibility == true){
            stkInTimeTitle.isHidden = true
            stkOutTimeTitle.isHidden = true
            self.btnAccept.isHidden = true
            self.btnReject.isHidden = true
            stkBtnAcceptReject.isHidden = true
        }else{
            let attendanceUser = attendanceCheckinDetail?.attendanceuser
            if(attendanceUser?.entity_id == 0){
                if(attendanceUser?.userId == self.activeuser?.userID?.int64Value){
                     self.stkInTimeTitle.isHidden = true
                     self.stkOutTimeTitle.isHidden = true
                    stkBtnAcceptReject.isHidden = true
                 }
            }
            else if(attendanceUser?
                    .entity_id == self.activeuser?.userID?.intValue){
                self.stkInTimeTitle.isHidden = true
                self.stkOutTimeTitle.isHidden = true
                stkBtnAcceptReject.isHidden = true
            }else{
                self.stkInTimeTitle.isHidden = false
                self.stkOutTimeTitle.isHidden = false
                stkBtnAcceptReject.isHidden = false
            }
           
            
        }
        if(isFromHistory == true){
            stkInTimeTitle.isHidden = true
            stkOutTimeTitle.isHidden = true
            self.btnAccept.isHidden = true
            self.btnReject.isHidden = true
            self.lblRequestType.text = ""
        }
    }
    
    func changetheStatus(status:Bool){
        if(self.attendanceCheckinDetail?.attendanceuser.entity_id == 0){
            self.attendanceCheckinDetail?.attendanceuser.entity_id = Int(self.attendanceCheckinDetail?.attendanceuser.userId ?? 0 )
        }
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
        print("parameter of approval request = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveAttendance, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
         
            if(status.lowercased() == Constant.SucessResponseFromServer){
                SVProgressHUD.dismiss()
                NotificationCenter.default.post(name: Notification.Name("LoadUserAttendanceHistory"), object: nil)
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else if(error.code == 0){
                SVProgressHUD.dismiss()
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                
            }else{
                SVProgressHUD.dismiss()
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
        
        //            if(Helper.isReachable()){
        //                var paradict:[String:Any] = [:]
        //                paradict["AttendanceID"] =  self.attendanceCheckinDetail?.entity_id
        //                paradict["UserID"] =   account?.user_id
        //                paradict["CompanyID"] =  NSNumber.init(integerLiteral:account?.company_info.company_id ?? 1)
        //                 paradict["MemberID"] =
        //                    self.attendanceCheckinDetail?.attendanceuser?.entity_id
        //                paradict["Approve"] = NSNumber.init(value: status)
        //                paradict["IsPermanentLocation"] = NSNumber.init(value: false)
        //                paradict["TokenID"] = account?.securityToken
        //
        //
        //
        //                let str = kBaseTeamworkURL + "approveAttendance"
        //                SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        //                callAPIPost(methodName: "POST", url: str  , parameter: paradict) { (status, result) in
        //                    if(status.lowercased() == "success"){
        //                        SVProgressHUD.dismiss()
        //                        do{
        //                            //here dataResponse received from a network request
        //
        //                            print(result )
        //                            let resultModel = Result(result as! [String : Any])
        //
        //                            print(resultModel)
        //                    if(resultModel.status.lowercased() == "success" ){
        //
        //                NotificationCenter.default.post(name: Notification.Name(LOAD_USER_ATTENDANCE_HISTORY), object: nil)
        //                Utils.toastmsg(message:resultModel.message)
        //                self.navigationController?.popViewController(animated: true)
        //                    }else if(status.lowercased() == "Invalid Token"){
        //                        SVProgressHUD.dismiss()
        //                        Utils.toastmsg(message:resultModel.message)
        //                    AppDelegate().window.makeToast(resultModel.message)
        //                        AppDelegate().logout()
        //    //                    [[AppDelegate appDelegate].window makeToast:result[@"message"]];
        //    //                    [[AppDelegate appDelegate] logout];
        //                    }
        //                else{
        //                        self.showAlert(withMessage: "SomeThing Went Wrong")
        //
        //                                        }
        //                                    }
        //                                }
        //                                else if (status == "false"){
        //                                     SVProgressHUD.dismiss()
        //                                    Utils.toastmsg(message:NSLocalizedString("internet-failure", comment: ""))
        //                                }
        //                                else{
        //                                     SVProgressHUD.dismiss()
        //                                    Utils.toastmsg(message:"SomeThing Went Wrong Please try again")
        //                                }
        //                            }
        //
        //                        }else{
        //
        //                            self.showAlert(withInternetMessage:NSLocalizedString("internet-failure", comment: ""))
        //                        }
    }
    @objc func handleTapInImageTouch(_ sender: UITapGestureRecognizer? = nil){
        
        var photos:Array<IDMPhoto>? = Array()
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: attendanceCheckinDetail?.checkInPhotoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
        //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
        photo.caption = " "
        photos?.append(photo)
        let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: photos)
        browser.delegate = self
        browser.displayCounterLabel = true
        browser.displayActionButton = false
        browser.autoHideInterface = false
        browser.dismissOnTouch = false
        browser.displayArrowButton = false
        browser.displayActionButton = false
        browser.disableVerticalSwipe = true
        DispatchQueue.main.async {
            self.present(browser, animated: true, completion: nil)
        }
    }
    @objc func handleTapOutImageTouch(_ sender: UITapGestureRecognizer? = nil){
        
        var photos:Array<IDMPhoto>? = Array()
        let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: attendanceCheckinDetail?.checkOutPhotoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
        //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
        photo.caption = " "
        photos?.append(photo)
        let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: photos)
        browser.delegate = self
        browser.displayCounterLabel = true
        browser.displayActionButton = false
        browser.autoHideInterface = false
        browser.dismissOnTouch = false
        browser.displayArrowButton = false
        browser.displayActionButton = false
        browser.disableVerticalSwipe = true
        DispatchQueue.main.async {
            self.present(browser, animated: true, completion: nil)
        }
    }
    
    //MARK: - IBAction
    @IBAction func btnAcceptClicked(_ sender: UIButton) {
        self.changetheStatus(status: true)
    }
    
    @IBAction func btnRejectClicked(_ sender: UIButton){
        self.changetheStatus(status: false)
    }
}

extension AttendanceDetailViewController:BaseViewControllerDelegate{
    
}

extension AttendanceDetailViewController :IDMPhotoBrowserDelegate{
    
}
