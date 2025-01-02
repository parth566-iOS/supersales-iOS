//
//  AttendanceCell.swift
//  SuperSales
//
//  Created by Apple on 16/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class AttendanceCell: UITableViewCell {
    
    @IBOutlet var imgCalender: UIImageView!
    
    @IBOutlet weak var vwCustomDetail: UIView!
    @IBOutlet var vwNewCheckOut: UIView!
    @IBOutlet var vwNewCheckIn: UIView!
    
    @IBOutlet var lblNewCheckInTitle: UILabel!
    @IBOutlet var lblNewCheckoutTitle: UILabel!
    
    @IBOutlet var lblDateForApproval: UILabel!
    
    @IBOutlet var lblNewCheckOut: UILabel!
    
    @IBOutlet var lblNewCheckIn: UILabel!
    
    @IBOutlet var vwParent: UIView!
    
    @IBOutlet var lblUserName: UILabel!
    
    @IBOutlet var lbl1Title: UILabel!
    @IBOutlet var lbl1: UILabel!
    
    @IBOutlet var lbl2Title: UILabel!
    @IBOutlet var lbl2: UILabel!
    
    @IBOutlet var btnAccept: UIButton!
    
    
    @IBOutlet var btnSelfieCheckout: UIButton!
    @IBOutlet var btnSelfieCheckIn: UIButton!
    @IBOutlet var btnReject: UIButton!
    
    @IBOutlet var stkbtn: UIStackView!
    
    @IBOutlet var vwcheckin: UIView!
    
    
    @IBOutlet var lblTotalTimeTitle: UILabel!
    
    @IBOutlet var lblTotalTimeValue: UILabel!
    
    
    @IBOutlet var btnUpdateTime: UIButton!
    
    @IBOutlet var vwbtnSelfie: UIView!
    
    @IBOutlet var vwCheckout: UIView!
    
    @IBOutlet var vwbtnSelifeCheckout: UIView!
    
    //  @IBOutlet weak var lbl1WidthConstant: NSLayoutConstraint!
    
    @IBOutlet var vwWeeklyTotal: UIView?
    
    @IBOutlet var lblWeeklyTotalHour: UILabel?
    @IBOutlet weak var cnstStkBtnAttendance: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTotalTimeTitle.textColor = UIColor.lightGray
        self.lblTotalTimeValue.textColor = UIColor.graphGreenColor
        self.vwParent.addBorders(edges: [.top,.right,.bottom,.left], color: UIColor.gray, cornerradius: 3)
        self.lblTotalTimeValue.setMultilineLabel(lbl: self.lblTotalTimeValue)
        
        // Initialization code
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblNewCheckOut.text = ""
        self.lbl2.text = ""
        self.lbl1.text = ""
        self.lblNewCheckIn.text = ""
        
        //self.imgContact.backgroundColor = UIColor.red
        // Clear all content based views and their actions here
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func  visibilestkbtn(visibility:Bool){
        if(visibility == true){
            
            self.cnstStkBtnAttendance.constant = 0
            
        }else{
//            self.btnAccept.isHidden = false
//            self.btnReject.isHidden = false
            
            self.cnstStkBtnAttendance.constant = 40
            
        }
    }
    
    func setAttendanceHistorydata(attendance:AttendanceHistory,indexpath:IndexPath)->(){
        print("Attendance = \(attendance)")
        self.vwCustomDetail.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEBF5FF)
        // self lbl1 text when its not approved
        if((attendance.manualAttendance?.count ?? 0 > 0) && (attendance.manualApproved == true)){
            self.visibilestkbtn(visibility: true)
            
        }else if (((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime != nil))) {
            self.visibilestkbtn(visibility: true)
            
        }else if(attendance.leaveType?.lowercased() == "absent"){
            self.visibilestkbtn(visibility: true)
        }else if(attendance.leaveType?.lowercased() == "holiday"){
            self.visibilestkbtn(visibility: true)
        }
        else if(((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime == nil))) {
            self.visibilestkbtn(visibility: true)
        }else{
            self.visibilestkbtn(visibility: false)
        }
        //        if(attendance.leaveType?.lowercased() == "absent"){
        //            self.visibilestkbtn(visibility: true)
        //            }else
        //        if(attendance.manualAttendance?.count  == 0){
        //        if(attendance.checkInApproved ==  true  && attendance.checkOutApproved ==  true){
        //            self.visibilestkbtn(visibility: true)
        //        }else{
        //            self.visibilestkbtn(visibility: false)
        //        }
        //        }else{
        //            if(attendance.manualApproved){
        //                self.visibilestkbtn(visibility: true)
        //            }else{
        //                self.visibilestkbtn(visibility: false)
        //            }
        //        }
        self.lbl1.textAlignment = .left
        //        self.vwParent.addBorders(edges: [.top,.right,.bottom,.left], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 5.0)
        self.contentView.addBorders(edges: [.top,.right,.bottom,.left], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 5.0)
        self.btnAccept.tag =  indexpath.row
        self.btnReject.tag = indexpath.row
        self.btnSelfieCheckout.tag = indexpath.row
        self.btnSelfieCheckIn.tag = indexpath.row
        
        if let customer = attendance.attendanceuser as? AttendanceUser{
            self.lblUserName.text = String.init(format:"\(customer.firstName ?? "") \(customer.lastName ?? "")") //"rtdber" //attendace?.attendanceDate
        }else{
            self.lblUserName.text = String.init(format:"")
        }
        
        if(attendance.checkInPhotoURL.count > 0){
            self.btnSelfieCheckIn.isHidden = false
            self.vwbtnSelfie.isHidden = false
        }
        if(attendance.checkOutPhotoURL.count > 0){
            self.btnSelfieCheckout.isHidden = false
            self.vwbtnSelifeCheckout.isHidden = false
        }
        if(attendance.manualAttendance?.count ?? 0 > 0){
            self.lbl2Title.isHidden = true
            self.lbl2.isHidden = true
            self.lbl1Title.isHidden = true
            
            let strleaveday = attendance.manualAttendance == "full" ? "Full ":"Half"
            self.lbl1.text = String.init(format:"Manual: \(strleaveday) day")
            
            self.vwNewCheckIn.isHidden = true
            self.vwNewCheckOut.isHidden = true
            
            
            
            if let tTime = attendance.totalTime{
                //  if let tTime = attendance.totalTime{
                if(tTime.count > 0){
                    
                    self.lblTotalTimeTitle.isHidden = false
                    self.lblTotalTimeValue.isHidden = false
                    self.lblTotalTimeValue.text = String.init(format:"\(tTime) Hours")
                }else{
                    self.lblTotalTimeValue.text = String.init(format:"\("0:00") Hours")
                }
            }else{
                self.lblTotalTimeTitle.isHidden = true
                self.lblTotalTimeValue.isHidden = true
            }
            if(attendance.manualApproved ==  false){
                
                self.lbl1.textColor =  Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                self.lbl2.textColor = Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                self.lblNewCheckOut.textColor = Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                
                
                
            }else{
                self.lbl1.textColor = UIColor.black //UIColor.gray
            }
            //}
        }else if(attendance.leaveType?.count ?? 0 > 0){
            self.lbl2Title.isHidden = true
            self.lbl1Title.isHidden = true
            self.lbl2.isHidden = true
            vwcheckin.isHidden = false
            
            
            
            let strleaveday = attendance.leaveDay == "full" ? "Full day":"Half day"
            
            self.vwNewCheckIn.isHidden = true
            self.vwNewCheckOut.isHidden = true
            if(attendance.leaveType?.lowercased() == "absent"){
                self.lbl1.textColor = UIColor.red
            }else if(attendance.leaveType?.lowercased() == "manual"){
                self.lbl1.textColor = UIColor.lightGray
            }else{
                
                self.lbl1.textColor = UIColor.systemBlue
                //Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
            }
            self.lbl1.text = String.init(format:"\(attendance.leaveType ?? "") \(":") \(strleaveday)",[])
            self.lblTotalTimeTitle.isHidden = true
            self.lblTotalTimeValue.isHidden = true
            
        }else{
            self.lbl2Title.isHidden = false
            self.lbl1Title.isHidden = false
            self.lbl2.isHidden = true
            
            if let  tTime = attendance.totalTime as? String{
                if(attendance.totalTime?.count ?? 0 > 0){
                    
                    self.lblTotalTimeTitle.isHidden = false
                    self.lblTotalTimeValue.isHidden = false
                    self.lblTotalTimeValue.text = String.init(format:"\(tTime) Hours")
                }else{
                    self.lblTotalTimeTitle.isHidden = true
                    self.lblTotalTimeValue.isHidden = true
                }
            }else{
                self.lblTotalTimeTitle.isHidden = true
                self.lblTotalTimeValue.isHidden = true
            }
            if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                self.lbl1.textColor = UIColor.black
                
            }else{
                
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                
            }
            if(attendance.checkOutApproved == true){
                self.lbl2.textColor = UIColor.black
            }else{
                self.lbl2.textColor = UIColor.systemBlue
            }
            if let timeIn =  attendance.timeIn as? NSDate{
             
                
                if let checkintime = attendance.checkInTime as? NSDate{
                    print("checkin time = \(checkintime) , time in = \(timeIn)")
                    if(checkintime == timeIn){
                        self.vwNewCheckIn.isHidden = true
                     
                    }else{
                        self.vwNewCheckIn.isHidden = false
                       
                    }
                }
            }else if let timeIn =  attendance.timeIn as? NSDate{
                
                if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                    if(timeIn == updatedTimeIn){
                        self.vwNewCheckIn.isHidden = true
                       
                    }else{
                        self.vwNewCheckIn.isHidden = false
                       
                    }
                }
            }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                if let checkintime = attendance.checkInTime as? NSDate {
                    if(updatedTimeIn == checkintime){
                        self.vwNewCheckIn.isHidden = true
                      
                    }else{
                        self.vwNewCheckIn.isHidden = false
                      
                    }
                }
            }else{
                self.vwNewCheckIn.isHidden = true
               // self.vwNewCheckOut.isHidden = true
            }
            if let timeOut =  attendance.timeOut as? NSDate{
                if let checkouttime = attendance.checkOutTime as? NSDate{
                    if(timeOut == checkouttime){
                    
                        self.vwNewCheckOut.isHidden = true
                    }else{
                      
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let timeOut =  attendance.timeOut{
                if let updatedTimeOut = attendance.updatedTimeOut{
                    if(timeOut == updatedTimeOut){
                     
                        self.vwNewCheckOut.isHidden = true
                    }else{
                     
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let updatedTimeOut =   attendance.updatedTimeOut{
                if let checkouttime = attendance.checkOutTime{
                    if(updatedTimeOut == checkouttime){
                    
                        self.vwNewCheckOut.isHidden = true
                    }else{
                        
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else{
             
                self.vwNewCheckOut.isHidden = false
            }
            if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                self.lbl1.textColor = UIColor.black
            }else{
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
            }
            if let checkintime = attendance.checkInTime as? NSDate{
                let oldtimeIn = Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a", defaultTimeZone: true)
                //    let oldtimeIn
                self.lbl1.text = oldtimeIn
                self.lblNewCheckIn.text =  oldtimeIn
                if(attendance.checkInApproved ==  true){
                    if let timein = attendance.timeIn as? NSDate{
                        if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                            self.lbl1.textColor =  UIColor.black//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        }else{
                            self.lbl1.textColor = UIColor.systemBlue
                        }
                        
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lbl1.text = newTimeIn
                    }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lblNewCheckIn.text = checkintime
                    }
                }else{
                    if let timein = attendance.timeIn as? NSDate{
                        if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                            self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        }else{
                            self.lbl1.textColor = UIColor.black
                        }
                        //                    if(attendance.timeIn.isempty){
                        //                        print("its empty")
                        //                    }
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a", defaultTimeZone: true)
                        //  self.lblNewCheckIn.text = newTimeIn
                        self.lbl1.text = newTimeIn
                    }else if let updatedTimeIn = attendance.updatedTimeIn as NSDate?{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lbl1.text = checkintime
                        // self.lblNewCheckIn.text = checkintime
                    }
                }
                
            }else{
                if(attendance.updatedTimeIn != nil){
                    //self.lbl1.textColor =  UIColor.systemBlue//Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                    if let updatedTime = attendance.updatedTimeIn{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedTime as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lbl1.text = updatedtime
                    }
                    //self.lblNewCheckIn.text = updatedtime
                }
            }
            
            if let checkouttime = attendance.checkOutTime {
                let oldtimeOut =// Utils.getDateWithAppendingDay:0
                    Utils.getDateWithAppendingDay(day: 0, date: checkouttime as Date, format: "hh:mm a", defaultTimeZone: true)
                self.vwCheckout.isHidden = false
                self.lbl2.isHidden = false
                self.lbl2.text = oldtimeOut
                if(attendance.checkOutApproved == true && attendance.manualAttendance?.count == 0 && attendance.leaveType?.count == 0){
                    self.lblNewCheckOut.text = oldtimeOut
                }else{
                self.lblNewCheckOut.text =  ""//oldtimeOut
                }
                if(attendance.checkOutApproved ==  true){
                    if let timeout = attendance.timeOut as? NSDate{
                        //if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                        //        self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        //    }else{
                        //self.lbl1.textColor = UIColor.black
                        //    }
                        
                        //if(attendance.timeIn.isempty){
                        //print("its empty")
                        //}
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = newTimeOut
                        //     self.lblNewCheckOut.text = newTimeOut never do this uncomment
                        
                    }
                    else if let updatedTimeOut = attendance.updatedTimeOut as NSDate?{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.vwCheckout.isHidden = false
                        
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = checkouttime
                        
                        self.lblNewCheckOut.text = checkouttime
                        
                    }
                }else{
                    if let timeout = attendance.timeOut as? NSDate{
                        //    if(attendance.checkOutApproved == false || attendance.manualApproved ==  false){
                        //
                        //        self.lbl2.textColor =    UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        //
                        //        }else{
                        //        self.lbl2.textColor = UIColor.black
                        //        }
                        
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lblNewCheckOut.text = newTimeOut
                        print("in user history Time out = \(newTimeOut)")
                    }else if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a", defaultTimeZone: true)
                       
                        self.lbl2.text =  checkouttime
                       
                    }
                    
                    
                }
                
            }else{
                if(attendance.updatedTimeOut != nil){
                    //    if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                    //    self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                    //            }else{
                    //    self.lbl2.textColor = UIColor.systemBlue
                    //            }
                    if let updatedTimeOut = attendance.updatedTimeOut{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = updatedtime
                        //    self.lblNewCheckOut.text =   updatedtime
                        //        print("in user history updated Time Out = \(updatedtime)")
                    }
                }
            }
            if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                self.lbl1.textColor = UIColor.black
                
            }else{
                
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                
            }
            
          /*  if let checkintime = attendance.checkInTime as NSDate?{
                let oldtimeIn = Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a")
                //    if(attendance.checkInApproved == true || attendance.manualApproved == true){
                //    self.lbl1.textColor = UIColor.black
                //            }else{
                //    self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                //            }
                self.lbl1.text = oldtimeIn
                self.lblNewCheckIn.text = oldtimeIn
                if(attendance.checkInApproved ==  true){
                    if let timein = attendance.timeIn{
                        //if(attendance.checkInApproved == true || attendance.manualApproved == true){
                        //    self.lbl1.textColor = UIColor.black
                        //}else{
                        //    self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        //}
                        
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a")
                        
                        self.lbl1.text = newTimeIn
                        
                    }else if let updatedTimeIn = attendance.updatedTimeIn{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a")
                        self.lblNewCheckIn.text = checkintime
                    }
                }else{
                    if let timein = attendance.timeIn{
                        //if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                        //self.lbl1.textColor = UIColor.black
                        //}else{
                        //self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        //}
                        
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a")
                        
                        self.lblNewCheckIn.text = newTimeIn
                        self.lbl1.text = newTimeIn
                    }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a")
                        self.lblNewCheckIn.text = checkintime
                        // self.lbl1.text = checkintime
                    }
                }
                
            }else{
                if(attendance.updatedTimeIn != nil){
                    if let updatedTime = attendance.updatedTimeIn as? Date{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedTime, format: "hh:mm a")
                        print("updated time from server = \(updatedtime)")
                        self.lbl1.text = updatedtime
                        print("updated time in for attendance history = \(updatedtime)")
                    }
                }
            }
            
            if let checkouttime = attendance.checkOutTime{
                let oldtimeOut =
                Utils.getDateWithAppendingDay(day: 0, date: checkouttime as Date, format: "hh:mm a")
                self.vwCheckout.isHidden = false
                self.lbl2.isHidden = false
                //if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                //self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                //        }else{
                //self.lbl2.textColor = UIColor.systemBlue
                //        }
                self.lbl2.text = oldtimeOut
                self.lblNewCheckOut.text =  oldtimeOut
                
                if(attendance.checkOutApproved ==  true){
                    
                    if let timeout = attendance.timeOut as? NSDate{
                        //    if(attendance.checkOutApproved == false || attendance.manualApproved ==  false){
                        //
                        //    self.lbl2.textColor =   UIColor.systemBlue
                        //
                        //            }else{
                        //    self.lbl2.textColor = UIColor.black
                        //            }
                        //    if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                        //    self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                        //            }else{
                        //    self.lbl2.textColor = UIColor.systemBlue
                        //            }
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a")
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = newTimeOut
                        print("new time out = \(newTimeOut)")
                    }else if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a")
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = checkouttime
                        print("checkout time = \(checkouttime)")
                    }
                }else{
                    if let timeout = attendance.timeOut as? NSDate{
                        //                            if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                        //                            self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                        //                                    }else{
                        //                            self.lbl2.textColor = UIColor.systemBlue
                        //                                    }
                        //
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a")
                        self.lblNewCheckOut.text = newTimeOut
                    }else if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a")
                        self.lblNewCheckOut.text = checkouttime
                    }
                }
                
            }else{
                if(attendance.updatedTimeOut != nil){
                    //        if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                    //        self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                    //                }else{
                    //        self.lbl2.textColor = UIColor.systemBlue
                    //                }
                    if let updatedoutTime = attendance.updatedTimeOut as? Date{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedoutTime, format: "hh:mm a")
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                      //  self.lbl2.text = "test"
                        self.lblNewCheckOut.text = updatedtime
                    }
                }
            }*/
            
        }
        
        
        
        //self.contentView.layoutIfNeeded()
        
    }
    
    func setPendingApprovalAttendance(attendance:AttendanceUserHistory,indexpath:IndexPath)->(){
        self.lblDateForApproval.isHidden = false
        self.imgCalender.isHidden = true
        self.lblTotalTimeTitle.isHidden = false
        self.lblTotalTimeValue.isHidden = false
        
        self.lblDateForApproval.text = Utils.getDateWithAppendingDay(day: 0, date: attendance.attendanceDate as Date , format:  "dd MMM EEE", defaultTimeZone: true)
        /*if((attendance.manualAttendance.count ?? 0 > 0) && (attendance.manualApproved == true)){
         self.visibilestkbtn(visibility: true)
         
         }else if(((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime != nil))){
         self.visibilestkbtn(visibility: true)
         
         }else if(attendance.leaveType.lowercased() == "absent"){
         self.visibilestkbtn(visibility: true)
         }else{
         self.visibilestkbtn(visibility: false)
         
         }*/
        /*if(attendance.checkInApproved ==  true  && attendance.checkOutApproved ==  true){
            self.visibilestkbtn(visibility: true)
        }else{
            self.visibilestkbtn(visibility: false)
        }*/
        
        if((attendance.manualAttendance.count ?? 0 > 0) && (attendance.manualApproved == true)){
            self.visibilestkbtn(visibility: true)
            
        }else if (((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime != nil))) {
            self.visibilestkbtn(visibility: true)
            
        }else if(attendance.leaveType.lowercased() == "absent"){
            self.visibilestkbtn(visibility: true)
        }else if(attendance.leaveType.lowercased() == "holiday"){
            self.visibilestkbtn(visibility: true)
        }
        else if(((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime == nil))) {
            self.visibilestkbtn(visibility: true)
        }else{
            self.visibilestkbtn(visibility: false)
        }
        self.lbl1.textAlignment = .left
        self.vwParent.addBorders(edges: [.top,.right,.bottom,.left], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 5.0)
        self.btnAccept.tag =  indexpath.row
        self.btnReject.tag = indexpath.row
        self.btnSelfieCheckout.tag = indexpath.row
        self.btnSelfieCheckIn.tag = indexpath.row
        
        if let customer = attendance.attendanceuser as? AttendanceUser{
            self.lblUserName.text = String.init(format:"\(customer.firstName ?? "") \(customer.lastName ?? "")") //"rtdber" //attendace?.attendanceDate
        }else{
            self.lblUserName.text = String.init(format:"")
        }
        
        if(attendance.checkInPhotoURL.count > 0){
            self.btnSelfieCheckIn.isHidden = false
            self.vwbtnSelfie.isHidden = false
        }
        if(attendance.checkOutPhotoURL.count > 0){
            self.btnSelfieCheckout.isHidden = false
            self.vwbtnSelifeCheckout.isHidden = false
        }
        if(attendance.manualAttendance.count ?? 0 > 0){
            self.lbl2Title.isHidden = true
            self.lbl2.isHidden = true
            self.lbl1Title.isHidden = true
            
            
            
            let strleaveday = attendance.manualAttendance == "full" ? "Full ":"Half"
            self.lbl1.text = String.init(format:"Manual: \(strleaveday) day")
            
            self.vwNewCheckIn.isHidden = true
            self.vwNewCheckOut.isHidden = true
            
            
            
            if let tTime = attendance.totalTime as? String{
                if(tTime.count > 0){
                    
                    self.lblTotalTimeTitle.isHidden = false
                    self.lblTotalTimeValue.isHidden = false
                    self.lblTotalTimeValue.text = String.init(format:"\(tTime) Hours")
                }else{
                    self.lblTotalTimeValue.text = String.init(format:"\("0:00") Hours")
                }
            }else{
                self.lblTotalTimeTitle.isHidden = true
                self.lblTotalTimeValue.isHidden = true
            }
            if(attendance.manualApproved ==  false){
                
                self.lbl1.textColor =  UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                self.lbl2.textColor = UIColor.systemBlue //Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                self.lblNewCheckOut.textColor =  UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                
                
            }else{
                self.lbl1.textColor =  UIColor.gray
                
            }
            //}
        }else if(attendance.leaveType.count ?? 0 > 0){
            self.lbl2Title.isHidden = true
            self.lbl1Title.isHidden = true
            self.lbl2.isHidden = true
            vwcheckin.isHidden = false
            print(attendance.manualApproved)
            
            
            let strleaveday = attendance.leaveDay == "full" ? "Full day":"Half day"
            //  self.lbl1Title.text = ""
            self.vwNewCheckIn.isHidden = true
            self.vwNewCheckOut.isHidden = true
            if(attendance.leaveType.lowercased() == "absent"){
                self.lbl1.textColor = UIColor.red
            }else if(attendance.leaveType.lowercased() == "manual"){
                self.lbl1.textColor = UIColor.lightGray
            }else{
                
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                
            }
            self.lbl1.text = String.init(format:"\(attendance.leaveType ?? "") \(":") \(strleaveday)",[])
            self.lblTotalTimeTitle.isHidden = true
            self.lblTotalTimeValue.isHidden = true
            
        }else{
            self.lbl2Title.isHidden = false
            self.lbl1Title.isHidden = false
            self.lbl2.isHidden = true
            
            
            if let  tTime = attendance.totalTime as? Int64{
                if(tTime > 0){
                    
                    self.lblTotalTimeTitle.isHidden = false
                    self.lblTotalTimeValue.isHidden = false
                    self.lblTotalTimeValue.text = String.init(format:"\(tTime) Hours")
                }else{
                    self.lblTotalTimeTitle.isHidden = true
                    self.lblTotalTimeValue.isHidden = true
                }
            }else{
                self.lblTotalTimeTitle.isHidden = true
                self.lblTotalTimeValue.isHidden = true
            }
            if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                self.lbl1.textColor = UIColor.black
                self.lbl2.textColor = UIColor.black
            }else{
                
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                self.lbl2.textColor = UIColor.systemBlue
            }
            
            if let timeIn =  attendance.timeIn{
                if let checkintime = attendance.checkInTime{
                    if(checkintime == timeIn){
                        self.vwNewCheckIn.isHidden = true
                        // self.vwNewCheckOut.isHidden = true
                    }else{
                        self.vwNewCheckIn.isHidden = false
                        //  self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let timeIn =  attendance.timeIn{
                if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                    if(timeIn == updatedTimeIn){
                        self.vwNewCheckIn.isHidden = true
                        // self.vwNewCheckOut.isHidden = true
                    }else{
                        self.vwNewCheckIn.isHidden = false
                        //  self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                if let checkintime = attendance.checkInTime as? NSDate{
                    if(updatedTimeIn == checkintime){
                        self.vwNewCheckIn.isHidden = true
                        // self.vwNewCheckOut.isHidden = true
                    }else{
                        self.vwNewCheckIn.isHidden = false
                        // self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else{
                self.vwNewCheckIn.isHidden = true
               // self.vwNewCheckOut.isHidden = true
            }
            if let timeOut =  attendance.timeOut as? NSDate{
                if let checkouttime = attendance.checkOutTime as? NSDate{
                    if(timeOut == checkouttime){
                        // self.vwNewCheckIn.isHidden = true
                        self.vwNewCheckOut.isHidden = true
                    }else{
                        //   self.vwNewCheckIn.isHidden = false
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let timeOut =  attendance.timeOut as? NSDate{
                if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                    if(timeOut == updatedTimeOut){
                        //   self.vwNewCheckIn.isHidden = true
                        self.vwNewCheckOut.isHidden = true
                    }else{
                        //     self.vwNewCheckIn.isHidden = false
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let updatedTimeOut = attendance.updatedTimeOut{
                if let checkouttime = attendance.checkOutTime{
                    if(updatedTimeOut == checkouttime){
                       // self.vwNewCheckIn.isHidden = true
                        self.vwNewCheckOut.isHidden = true
                    }else{
                        
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else{
               // self.vwNewCheckIn.isHidden = true
                self.vwNewCheckOut.isHidden = true
            }
            if let checkintime = attendance.checkInTime as NSDate?{
                
                
                let oldtimeIn = Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a", defaultTimeZone: true)
                self.lbl1.text = oldtimeIn
                self.lblNewCheckIn.text =  oldtimeIn
                if(attendance.checkInApproved ==  true){
                    if let timein = attendance.timeIn as? NSDate{
                        if(attendance.manualApproved ==  false){
                            
                            self.lbl1.textColor =    UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                            
                        }else{
                            self.lbl1.textColor = UIColor.black
                        }
                        
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a", defaultTimeZone: true)
                        
                        self.lbl1.text = newTimeIn
                    }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a", defaultTimeZone: true)
                        
                        self.lbl1.text = checkintime
                    }
                }else{
                    if let timein = attendance.timeIn as? NSDate{
                        
                        if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                            self.lbl1.textColor =  UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        }else{
                            self.lbl1.textColor = UIColor.black
                        }
                        
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a", defaultTimeZone: true)
                        
                        self.lblNewCheckIn.text = newTimeIn
                    }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lblNewCheckIn.text = checkintime
                    }
                }
                
                
            }else{
                if(attendance.updatedTimeIn != nil){
                    
                    if let updatedTime = attendance.updatedTimeIn{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedTime, format: "hh:mm a", defaultTimeZone:true)
                        if(attendance.manualApproved == true || attendance.checkInApproved == true){
                            self.lbl1.textColor = UIColor.black
                        }else{
                            self.lbl1.textColor =  UIColor.systemBlue//Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                        }
                        self.lbl1.text = updatedtime
                    }
                }
            }
            
            if let checkouttime = attendance.checkOutTime as? NSDate{
                let oldtimeOut =
                    Utils.getDateWithAppendingDay(day: 0, date: checkouttime as Date, format: "hh:mm a", defaultTimeZone: true)
                self.vwCheckout.isHidden = false
                self.lbl2.isHidden = false
                self.lbl2.text = oldtimeOut
                if(attendance.checkOutApproved == true && attendance.manualAttendance.count == 0 && attendance.leaveType.count == 0){
                    self.lblNewCheckOut.text = oldtimeOut
                }else{
                self.lblNewCheckOut.text =  ""//oldtimeOut
                }
                
                if(attendance.checkOutApproved ==  true){
                    self.lbl2.isHidden = true
                    if let timeout = attendance.timeOut as? NSDate{
                        if(attendance.checkOutApproved == false || attendance.manualApproved ==  false){
                            self.lbl2.textColor =   UIColor.systemBlue
                        }else{
                            self.lbl2.textColor = UIColor.black
                        }
                        
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = newTimeOut
                        
                    }else if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = checkouttime
                        
                    }
                }else{
                    if let timeout = attendance.timeOut as? NSDate{
                        if(attendance.checkOutApproved == false || attendance.manualApproved ==  false){
                            self.lbl2.textColor =   UIColor.systemBlue
                        }else{
                            self.lbl2.textColor = UIColor.black
                        }
                        
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lblNewCheckOut.text = newTimeOut
                    }else if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lblNewCheckOut.text = checkouttime
                    }
                }
                
            }else{
                if(attendance.updatedTimeOut != nil){
                    //            if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                    //            self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                    //                    }else{
                    //            self.lbl2.textColor = UIColor.systemBlue
                    //                    }
                    if let updatedTimeOut = attendance.updatedTimeOut{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut, format: "hh:mm a", defaultTimeZone: true)
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = updatedtime
                        print("updated time  = \(updatedtime)")
                    }
                }
            }
            
        }
        
        
        self.lblTotalTimeTitle.isHidden = true
        self.lblTotalTimeValue.isHidden = true
        self.btnUpdateTime.isHidden = true
        if((attendance.manualApproved ==  true) || (attendance.checkInApproved == true && attendance.checkInTime != nil)){
            self.lbl1.textColor = UIColor.black
        }else{
            self.lbl1.textColor = UIColor.Appskybluecolor
            
        }
    }
    
    
    
    func setAttendanceUserHistorydata(attendance:AttendanceUserHistory,indexpath:IndexPath)->(){
        self.vwCustomDetail.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEBF5FF)
        // lblNewCheckOut worng when attendance is not approved
        self.vwNewCheckOut.isHidden  = true
        print("attendance detail of user  = \(attendance)")
        /* if((attendance.manualAttendance.count ?? 0 > 0) && (attendance.manualApproved == true)){
         
         self.visibilestkbtn(visibility: true)
         }else if(((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime != nil))){
         
         self.visibilestkbtn(visibility: true)
         }else if(attendance.leaveType.lowercased() == "absent"){
         
         self.visibilestkbtn(visibility: true)
         }else{
         
         self.visibilestkbtn(visibility: false)
         }*/
        
        
       /*recently commented  if((attendance.manualAttendance.count ?? 0 > 0) && (attendance.manualApproved == true)){
            self.visibilestkbtn(visibility: true)
            
        }else if (((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime != nil))) {
            self.visibilestkbtn(visibility: true)
            
        }else if(attendance.leaveType.lowercased() == "absent"){
            self.visibilestkbtn(visibility: true)
        }else if(attendance.leaveType.lowercased() == "holiday"){
            self.visibilestkbtn(visibility: true)
        }
        else if(((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime == nil))) {
            self.visibilestkbtn(visibility: true)
        }else{
            self.visibilestkbtn(visibility: false)
        }*/
        /**
         if((attendance.manualAttendance?.count ?? 0 > 0) && (attendance.manualApproved == true)){
             self.visibilestkbtn(visibility: true)
             
         }else if (((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime != nil))) {
             self.visibilestkbtn(visibility: true)
             
         }else if(attendance.leaveType?.lowercased() == "absent"){
             self.visibilestkbtn(visibility: true)
         }else if(attendance.leaveType?.lowercased() == "holiday"){
             self.visibilestkbtn(visibility: true)
         }
         else if(((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime == nil))) {
             self.visibilestkbtn(visibility: true)
         }else{
             self.visibilestkbtn(visibility: false)
         }
         
         
         
         */
        if((attendance.manualAttendance.count ?? 0 > 0) && (attendance.manualApproved == true)){
            self.visibilestkbtn(visibility: true)
            
        }else if (((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime != nil)) ) {
         
            self.visibilestkbtn(visibility: true)
            
        }else if(attendance.leaveType.lowercased() == "absent"){
            self.visibilestkbtn(visibility: true)
        }else if(attendance.leaveType.lowercased() == "holiday"){
            self.visibilestkbtn(visibility: true)
        }
        else if(((attendance.checkInApproved == true) && (attendance.checkInTime !=  nil)) && ((attendance.checkOutApproved == true) && (attendance.checkOutTime == nil))) {
            self.visibilestkbtn(visibility: true)
        }else{
            self.visibilestkbtn(visibility: false)
        }
        
        
        
        self.btnUpdateTime.isHidden = true
        print("btn update icon will hide")
        self.vwParent.addBorders(edges: [.top,.right,.bottom,.left], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 5.0)
        self.vwWeeklyTotal?.addBorders(edges: [.top,.right,.bottom,.left], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 5.0)
        self.lblWeeklyTotalHour?.textAlignment = .right
        self.lblWeeklyTotalHour?.text = "Weekly Total"
        self.btnAccept.tag =  indexpath.row
        self.btnReject.tag = indexpath.row
        self.btnSelfieCheckout.tag = indexpath.row
        self.btnSelfieCheckIn.tag = indexpath.row
        if(attendance.checkInApproved == true && attendance.checkOutApproved == true && attendance.manualAttendance.count == 0 && attendance.leaveType.count == 0){
            self.btnUpdateTime.isHidden = false
            print("btn update icon will show")
        }
        if(attendance.totalTime.count > 0){
          
            self.lblTotalTimeTitle.isHidden = false
            self.lblTotalTimeValue.isHidden = false
            self.lblTotalTimeValue.text = String.init(format:"\(attendance.totalTime) Hours")
        }else{
            self.lblTotalTimeValue.text = ""
            if(attendance.checkInApproved){
                if(attendance.checkInApproved == false){
                    print(attendance)
                   
                }
            }
            
        }
        if let customer = attendance.attendanceuser as? AttendanceUser{
            
            self.lblUserName.text = String.init(format:"\(customer.firstName ) \(customer.lastName)")
        }else{
            self.lblUserName.text = String.init(format:"")
        }
        // if let date = attendance.attendanceDate{
        let date = attendance.attendanceDate
        let dateformatter  = DateFormatter.init()
        
        dateformatter.dateFormat = "dd MMM EEE"
        
        self.lblUserName.text = dateformatter.string(from: date as Date) ?? String.init(format:"")
        
        
        if(attendance.checkInPhotoURL.count > 0){
            self.btnSelfieCheckIn.isHidden = false
            self.vwbtnSelfie.isHidden = false
        }
        if(attendance.checkOutPhotoURL.count > 0){
            self.btnSelfieCheckout.isHidden = false
            self.vwbtnSelifeCheckout.isHidden = false
        }
        if(attendance.manualAttendance.count ?? 0 > 0){
            
            self.lbl2Title.isHidden = true
            self.lbl1Title.isHidden = true
            self.lbl1.textColor =  UIColor.gray
            let strleaveday = attendance.manualAttendance == "full" ? "Full ":"Half"
//               self.lbl1.textColor = UIColor.blue
            self.lbl1.text = String.init(format:"Manual: \(strleaveday) day")
             self.lbl1.textColor =  UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
            self.vwNewCheckIn.isHidden = true
            self.vwNewCheckOut.isHidden = true
            
            
            if(attendance.manualApproved ==  false){
                
                if(attendance.totalTime.count  > 0){
                    
                    self.lblTotalTimeTitle.isHidden = false
                    self.lblTotalTimeValue.isHidden = false
                    self.lblTotalTimeValue.text = String.init(format:"\(attendance.totalTime) Hours")
                }else{
                    //                        self.lblTotalTimeValue.text = String.init(format:"\("0:00") Hours")
                    self.lblTotalTimeTitle.isHidden = true
                    self.lblTotalTimeValue.isHidden = true
                }
            }else{
                self.visibilestkbtn(visibility: true)
//                self.btnAccept.isHidden = true
//                self.btnReject.isHidden = true
            }
            
        }else if(attendance.leaveType.count ?? 0 > 0){
            self.lbl2Title.isHidden = true
            self.lbl1Title.isHidden = true
            vwcheckin.isHidden = false
            self.visibilestkbtn(visibility: true)
//            self.btnAccept.isHidden = true
//            self.btnReject.isHidden = true
            let strleaveday = attendance.leaveDay == "full" ? "Full day":"Half day"
            //   self.lbl1Title.text = ""
            self.vwNewCheckIn.isHidden = true
            self.vwNewCheckOut.isHidden = true
            if(attendance.leaveType.lowercased().contains("absent")){
                self.lbl1.textColor = UIColor.red
            }else if(attendance.leaveType.lowercased().contains("manual")){
                self.lbl1.textColor = UIColor.Appskybluecolor
            }else{
                
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
            }
            self.lbl1.text = String.init(format:"\(attendance.leaveType ?? "") \(":") \(strleaveday)",[])
            self.lblTotalTimeTitle.isHidden = true
            self.lblTotalTimeValue.isHidden = true
            
        }else{
            self.lbl2Title.isHidden = false
            self.lbl1Title.isHidden = false
            if(attendance.checkInApproved == true && attendance.checkOutApproved == true && attendance.manualAttendance.count == 0 && attendance.leaveType.count == 0){
                self.btnUpdateTime.isHidden = false
            }
            if(attendance.totalTime.count  > 0){
                
                self.lblTotalTimeTitle.isHidden = false
                self.lblTotalTimeValue.isHidden = false
                self.lblTotalTimeValue.text = String.init(format:"\(attendance.totalTime) Hours")
            }else{
                
                self.lblTotalTimeTitle.isHidden = true
                self.lblTotalTimeValue.isHidden = true
            }
            if(attendance.checkInApproved ==  true  && attendance.checkOutApproved ==  true){
             self.visibilestkbtn(visibility: true)
             }else{
             self.visibilestkbtn(visibility: false)
             }

            if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                self.lbl1.textColor = UIColor.black
            }else{
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
            }
            
            if(attendance.checkOutApproved == true){
                self.lbl2.textColor = UIColor.black
            }else{
                self.lbl2.textColor = UIColor.systemBlue
            }
            if let timeIn =  attendance.timeIn as? NSDate{
                if let checkintime = attendance.checkInTime as? NSDate{
                    print("checkin time = \(checkintime) , time in = \(timeIn)")
                    if(checkintime == timeIn){
                        self.vwNewCheckIn.isHidden = true
                       
                    }else{
                        self.vwNewCheckIn.isHidden = false
                     
                    }
                }
            }else if let timeIn =  attendance.timeIn as? NSDate{
                if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                    if(timeIn == updatedTimeIn){
                        if let timeOut = attendance.timeIn as? NSDate{
                            if let updatedTimeOut = attendance.updatedTimeIn as? NSDate{
                                if(timeOut == updatedTimeOut){
                                    self.vwNewCheckIn.isHidden = true
                                }else{
                                    self.vwNewCheckIn.isHidden = false
                                }
                            }
                        }else{
                            self.vwNewCheckIn.isHidden = true
                        }
                        
                       
                    }else{
                        self.vwNewCheckIn.isHidden = false
                       
                    }
                }
            }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                if let checkintime = attendance.checkInTime as? NSDate {
                    if(updatedTimeIn == checkintime){
                        self.vwNewCheckIn.isHidden = true
                        
                    }else{
                        self.vwNewCheckIn.isHidden = false
                       
                    }
                }
            }else{
                self.vwNewCheckIn.isHidden = true
             
            }
            if let timeOut =  attendance.timeOut as? NSDate{
                if let checkouttime = attendance.checkOutTime as? NSDate{
                    if(timeOut == checkouttime){
                    
                        self.vwNewCheckOut.isHidden = true
                    }else{
                       
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let timeOut =  attendance.timeOut as? NSDate{
                if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                    if(timeOut == updatedTimeOut){
                       
                        self.vwNewCheckOut.isHidden = true
                    }else{
                       
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }
            else if let updatedTimeOut = attendance.updatedTimeOut{
                if let checkouttime = attendance.checkOutTime {
                    if(updatedTimeOut == checkouttime){
                     
                        self.vwNewCheckOut.isHidden = true
                    }
                    else{
                       
                        self.vwNewCheckOut.isHidden =  false
                    }
                }else{
                    self.vwNewCheckOut.isHidden =  false
                }
            }else{
              
                self.vwNewCheckOut.isHidden = false
            }
            if let checkintime = attendance.checkInTime as? NSDate{
                let oldtimeIn = Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a", defaultTimeZone: true)
                //    let oldtimeIn
                self.lbl1.text = oldtimeIn
                self.lblNewCheckIn.text =  oldtimeIn
                if(attendance.checkInApproved ==  true){
                    if let timein = attendance.timeIn as? NSDate{
                        if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                            self.lbl1.textColor =  UIColor.black//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        }else{
                            self.lbl1.textColor = UIColor.systemBlue
                        }
                        
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lbl1.text = newTimeIn
                    }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lblNewCheckIn.text = checkintime
                    }
                }else{
                    if let timein = attendance.timeIn as? NSDate{
                        if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                            self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        }else{
                            self.lbl1.textColor = UIColor.black
                        }
                        
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a", defaultTimeZone: true)
                        //  self.lblNewCheckIn.text = newTimeIn
                        self.lbl1.text = newTimeIn
                    }else if let updatedTimeIn = attendance.updatedTimeIn as NSDate?{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lbl1.text = checkintime
                        if(attendance.manualApproved == false || attendance.checkInApproved ==  false){
                            if let timein = attendance.checkInTime as? NSDate{
//                                if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
//                                    self.lbl1.textColor =  UIColor.black//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
//                                }else{
//                                    self.lbl1.textColor = UIColor.systemBlue
//                                }
                                
                                let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a", defaultTimeZone: true)
                               
                            self.lblNewCheckIn.text = newTimeIn
                            }
                        }
                    }
                }
                
            }else{
                if(attendance.updatedTimeIn != nil){
                    //self.lbl1.textColor =  UIColor.systemBlue//Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                    if let updatedTime = attendance.updatedTimeIn{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedTime, format: "hh:mm a", defaultTimeZone: true)
                        self.lbl1.text = updatedtime
                    }
                    //self.lblNewCheckIn.text = updatedtime
                }
            }
            
            if let checkouttime = attendance.checkOutTime {
                let oldtimeOut =// Utils.getDateWithAppendingDay:0
                    Utils.getDateWithAppendingDay(day: 0, date: checkouttime as Date, format: "hh:mm a", defaultTimeZone: true)
                self.vwCheckout.isHidden = false
                self.lbl2.isHidden = false
                self.lbl2.text = oldtimeOut
//                if(attendance.checkOutApproved == true && attendance.manualAttendance.count == 0 && attendance.leaveType.count == 0 ){
//                    print(oldtimeOut)
//                    self.lblNewCheckOut.text = oldtimeOut
//                }else{
//                self.lblNewCheckOut.text =  ""//oldtimeOut
//                }
                if(attendance.checkOutApproved ==  true){
                    if let timeout = attendance.timeOut as? NSDate{
                        //if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                        //        self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        //    }else{
                        //self.lbl1.textColor = UIColor.black
                        //    }
                        
                        //if(attendance.timeIn.isempty){
                        //print("its empty")
                        //}
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = newTimeOut
                        //     self.lblNewCheckOut.text = newTimeOut never do this uncomment
                        
                    }
                    else if let updatedTimeOut = attendance.updatedTimeOut as NSDate?{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.vwCheckout.isHidden = false
                        
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = checkouttime
                        
                        self.lblNewCheckOut.text = checkouttime
                        
                    }
                }else{
                    if let timeout = attendance.timeOut as? NSDate{
                        //    if(attendance.checkOutApproved == false || attendance.manualApproved ==  false){
                        //
                        //        self.lbl2.textColor =    UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        //
                        //        }else{
                        //        self.lbl2.textColor = UIColor.black
                        //        }
                        
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a", defaultTimeZone: true)
                        self.lblNewCheckOut.text = newTimeOut
                        print("in user history Time out = \(newTimeOut)")
                    }else if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a", defaultTimeZone: true)
                        //    self.lblNewCheckOut.text = checkouttime
                        self.lbl2.text =  checkouttime
                        // if(attendance.checkOutApproved == false){
                        //        self.lblNewCheckOut.text = checkouttime
                        //        print("in user history updated Time Out = \(checkouttime)")
                        //}
                    }
                    
                    
                }
                
            }else{
                if(attendance.updatedTimeOut != nil){
                    //    if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                    //    self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                    //            }else{
                    //    self.lbl2.textColor = UIColor.systemBlue
                    //            }
                    if let updatedTimeOut = attendance.updatedTimeOut{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut, format: "hh:mm a", defaultTimeZone: true)
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = updatedtime
                        //    self.lblNewCheckOut.text =   updatedtime
                        //        print("in user history updated Time Out = \(updatedtime)")
                    }
                }
            }
            if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                self.lbl1.textColor = UIColor.black
                
            }else{
                
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                
            }
        }


/*
        
        self.lbl1.textAlignment = .left
        //        self.vwParent.addBorders(edges: [.top,.right,.bottom,.left], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 5.0)
     //   self.contentView.addBorders(edges: [.top,.right,.bottom,.left], color: .gray, inset: CGFloat(0), thickness: 1.0, cornerradius: 5.0)
        self.btnAccept.tag =  indexpath.row
        self.btnReject.tag = indexpath.row
        self.btnSelfieCheckout.tag = indexpath.row
        self.btnSelfieCheckIn.tag = indexpath.row
        
        if let customer = attendance.attendanceuser as? AttendanceUser{
            self.lblUserName.text = String.init(format:"\(customer.firstName ?? "") \(customer.lastName ?? "")") //"rtdber" //attendace?.attendanceDate
        }else{
            self.lblUserName.text = String.init(format:"")
        }
        
        if(attendance.checkInPhotoURL.count > 0){
            self.btnSelfieCheckIn.isHidden = false
            self.vwbtnSelfie.isHidden = false
        }
        if(attendance.checkOutPhotoURL.count > 0){
            self.btnSelfieCheckout.isHidden = false
            self.vwbtnSelifeCheckout.isHidden = false
        }
        if(attendance.manualAttendance.count ?? 0 > 0){
            self.lbl2Title.isHidden = true
            self.lbl2.isHidden = true
            self.lbl1Title.isHidden = true
            
            let strleaveday = attendance.manualAttendance == "full" ? "Full ":"Half"
            self.lbl1.text = String.init(format:"Manual: \(strleaveday) day")
            
            self.vwNewCheckIn.isHidden = true
            self.vwNewCheckOut.isHidden = true
            
            
            
            if let tTime = attendance.totalTime as? String{
                //  if let tTime = attendance.totalTime{
                if(tTime.count > 0){
                    
                    self.lblTotalTimeTitle.isHidden = false
                    self.lblTotalTimeValue.isHidden = false
                    self.lblTotalTimeValue.text = String.init(format:"\(tTime) Hours")
                }else{
                    self.lblTotalTimeValue.text = String.init(format:"\("0:00") Hours")
                }
            }else{
                self.lblTotalTimeTitle.isHidden = true
                self.lblTotalTimeValue.isHidden = true
            }
            if(attendance.manualApproved ==  false){
                
                self.lbl1.textColor =  Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                self.lbl2.textColor = Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                self.lblNewCheckOut.textColor = Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                
                
                
            }else{
                self.lbl1.textColor = UIColor.black //UIColor.gray
            }
            //}
        }else if(attendance.leaveType.count ?? 0 > 0){
            self.lbl2Title.isHidden = true
            self.lbl1Title.isHidden = true
            self.lbl2.isHidden = true
            vwcheckin.isHidden = false
            
            
            
            let strleaveday = attendance.leaveDay == "full" ? "Full day":"Half day"
            
            self.vwNewCheckIn.isHidden = true
            self.vwNewCheckOut.isHidden = true
            if(attendance.leaveType.lowercased() == "absent"){
                self.lbl1.textColor = UIColor.red
            }else if(attendance.leaveType.lowercased() == "manual"){
                self.lbl1.textColor = UIColor.lightGray
            }else{
                
                self.lbl1.textColor = UIColor.systemBlue
                //Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
            }
            self.lbl1.text = String.init(format:"\(attendance.leaveType ?? "") \(":") \(strleaveday)",[])
            self.lblTotalTimeTitle.isHidden = true
            self.lblTotalTimeValue.isHidden = true
            
        }else{
            self.lbl2Title.isHidden = false
            self.lbl1Title.isHidden = false
            self.lbl2.isHidden = true
            
            if let  tTime = attendance.totalTime as? String{
                if(attendance.totalTime.count ?? 0 > 0){
                    
                    self.lblTotalTimeTitle.isHidden = false
                    self.lblTotalTimeValue.isHidden = false
                    self.lblTotalTimeValue.text = String.init(format:"\(tTime) Hours")
                }else{
                    self.lblTotalTimeTitle.isHidden = true
                    self.lblTotalTimeValue.isHidden = true
                }
            }else{
                self.lblTotalTimeTitle.isHidden = true
                self.lblTotalTimeValue.isHidden = true
            }
            if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                self.lbl1.textColor = UIColor.black
                
            }else{
                
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                
            }
            if(attendance.checkOutApproved == true){
                self.lbl2.textColor = UIColor.black
            }else{
                self.lbl2.textColor = UIColor.systemBlue
            }
            if let timeIn =  attendance.timeIn as? NSDate{
                
                
                if let checkintime = attendance.checkInTime as? NSDate{
                    if(checkintime == timeIn){
                        self.vwNewCheckIn.isHidden = true
                        // self.vwNewCheckOut.isHidden = true
                    }else{
                        self.vwNewCheckIn.isHidden = false
                        // self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let timeIn =  attendance.timeIn as? NSDate{
                
                if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                    if(timeIn == updatedTimeIn){
                        self.vwNewCheckIn.isHidden = true
                        // self.vwNewCheckOut.isHidden = true
                    }else{
                        self.vwNewCheckIn.isHidden = false
                        //  self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                if let checkintime = attendance.checkInTime as? NSDate {
                    if(updatedTimeIn == checkintime){
                        self.vwNewCheckIn.isHidden = true
                        //   self.vwNewCheckOut.isHidden = true
                    }else{
                        self.vwNewCheckIn.isHidden = false
                        //    self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else{
                self.vwNewCheckIn.isHidden = true
                self.vwNewCheckOut.isHidden = true
            }
            if let timeOut =  attendance.timeOut as? NSDate{
                if let checkouttime = attendance.checkOutTime as? NSDate{
                    if(timeOut == checkouttime){
                        // self.vwNewCheckIn.isHidden = true
                        self.vwNewCheckOut.isHidden = true
                    }else{
                        //  self.vwNewCheckIn.isHidden = false
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let timeOut =  attendance.timeOut{
                if let updatedTimeOut = attendance.updatedTimeOut{
                    if(timeOut as Date == updatedTimeOut){
                        //  self.vwNewCheckIn.isHidden = true
                        self.vwNewCheckOut.isHidden = true
                    }else{
                        // self.vwNewCheckIn.isHidden = false
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else if let updatedTimeOut =   attendance.updatedTimeOut{
                if let checkouttime = attendance.checkOutTime{
                    if(updatedTimeOut == checkouttime){
                        // self.vwNewCheckIn.isHidden = true
                        self.vwNewCheckOut.isHidden = true
                    }else{
                        
                        self.vwNewCheckOut.isHidden =  false
                    }
                }
            }else{
                //     self.vwNewCheckIn.isHidden = true
                self.vwNewCheckOut.isHidden = true
            }
            if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                self.lbl1.textColor = UIColor.black
            }else{
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
            }
            if let checkintime = attendance.checkInTime as? NSDate{
                let oldtimeIn = Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a")
                //    let oldtimeIn
                self.lbl1.text = oldtimeIn
                self.lblNewCheckIn.text =  oldtimeIn
                if(attendance.checkInApproved ==  true){
                    if let timein = attendance.timeIn as? NSDate{
                        if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                            self.lbl1.textColor =  UIColor.black//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        }else{
                            self.lbl1.textColor = UIColor.systemBlue
                        }
                        
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a")
                        self.lbl1.text = newTimeIn
                    }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a")
                        self.lblNewCheckIn.text = checkintime
                    }
                }else{
                    if let timein = attendance.timeIn as? NSDate{
                        if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                            self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        }else{
                            self.lbl1.textColor = UIColor.black
                        }
                        //                    if(attendance.timeIn.isempty){
                        //                        print("its empty")
                        //                    }
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a")
                        //  self.lblNewCheckIn.text = newTimeIn
                        self.lbl1.text = newTimeIn
                    }else if let updatedTimeIn = attendance.updatedTimeIn as NSDate?{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a")
                        self.lbl1.text = checkintime
                        // self.lblNewCheckIn.text = checkintime
                    }
                }
                
            }else{
                if(attendance.updatedTimeIn != nil){
                    //self.lbl1.textColor =  UIColor.systemBlue//Common().UIColorFromRGB(rgbValue:0x3DA1C9)
                    if let updatedTime = attendance.updatedTimeIn{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedTime as Date, format: "hh:mm a")
                        self.lbl1.text = updatedtime
                    }
                    //self.lblNewCheckIn.text = updatedtime
                }
            }
            
            if let checkouttime = attendance.checkOutTime {
                let oldtimeOut =// Utils.getDateWithAppendingDay:0
                Utils.getDateWithAppendingDay(day: 0, date: checkouttime as Date, format: "hh:mm a")
                self.vwCheckout.isHidden = false
                self.lbl2.isHidden = false
                self.lbl2.text = oldtimeOut
                self.lblNewCheckOut.text =  oldtimeOut
                
                if(attendance.checkOutApproved ==  true){
                    if let timeout = attendance.timeOut as? NSDate{
                        //if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                        //        self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        //    }else{
                        //self.lbl1.textColor = UIColor.black
                        //    }
                        
                        //if(attendance.timeIn.isempty){
                        //print("its empty")
                        //}
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a")
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = newTimeOut
                        //     self.lblNewCheckOut.text = newTimeOut never do this uncomment
                        
                    }
                    else if let updatedTimeOut = attendance.updatedTimeOut as NSDate?{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a")
                        self.vwCheckout.isHidden = false
                        
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = checkouttime
                        
                        self.lblNewCheckOut.text = checkouttime
                        
                    }
                }else{
                    if let timeout = attendance.timeOut as? NSDate{
                        //    if(attendance.checkOutApproved == false || attendance.manualApproved ==  false){
                        //
                        //        self.lbl2.textColor =    UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        //
                        //        }else{
                        //        self.lbl2.textColor = UIColor.black
                        //        }
                        
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a")
                        self.lblNewCheckOut.text = newTimeOut
                        print("in user history Time out = \(newTimeOut)")
                    }else if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a")
                        //    self.lblNewCheckOut.text = checkouttime
                        self.lbl2.text =  checkouttime
                        // if(attendance.checkOutApproved == false){
                        //        self.lblNewCheckOut.text = checkouttime
                        //        print("in user history updated Time Out = \(checkouttime)")
                        //}
                    }
                    
                    
                }
                
            }else{
                if(attendance.updatedTimeOut != nil){
                    //    if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                    //    self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                    //            }else{
                    //    self.lbl2.textColor = UIColor.systemBlue
                    //            }
                    if let updatedTimeOut = attendance.updatedTimeOut{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a")
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = updatedtime
                        //    self.lblNewCheckOut.text =   updatedtime
                        //        print("in user history updated Time Out = \(updatedtime)")
                    }
                }
            }
            if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                self.lbl1.textColor = UIColor.black
                
            }else{
                
                self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                
            }
            */
          /*  if let checkintime = attendance.checkInTime as NSDate?{
                let oldtimeIn = Utils.getDateWithAppendingDay(day: 0, date: checkintime as Date, format: "hh:mm a")
                //    if(attendance.checkInApproved == true || attendance.manualApproved == true){
                //    self.lbl1.textColor = UIColor.black
                //            }else{
                //    self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                //            }
                self.lbl1.text = oldtimeIn
                self.lblNewCheckIn.text = oldtimeIn
                if(attendance.checkInApproved ==  true){
                    if let timein = attendance.timeIn{
                        //if(attendance.checkInApproved == true || attendance.manualApproved == true){
                        //    self.lbl1.textColor = UIColor.black
                        //}else{
                        //    self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        //}
                        
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a")
                        
                        self.lbl1.text = newTimeIn
                        
                    }else if let updatedTimeIn = attendance.updatedTimeIn{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a")
                        self.lblNewCheckIn.text = checkintime
                    }
                }else{
                    if let timein = attendance.timeIn{
                        //if(attendance.manualApproved ==  true || attendance.checkInApproved == true){
                        //self.lbl1.textColor = UIColor.black
                        //}else{
                        //self.lbl1.textColor = UIColor.systemBlue//Common().UIColorFromRGB(rgbValue: 0x3DA1C9)
                        //}
                        
                        let newTimeIn =  Utils.getDateWithAppendingDay(day: 0, date:timein as Date, format: "hh:mm a")
                        
                        self.lblNewCheckIn.text = newTimeIn
                        self.lbl1.text = newTimeIn
                    }else if let updatedTimeIn = attendance.updatedTimeIn as? NSDate{
                        let checkintime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeIn as Date, format: "hh:mm a")
                        self.lblNewCheckIn.text = checkintime
                        // self.lbl1.text = checkintime
                    }
                }
                
            }else{
                if(attendance.updatedTimeIn != nil){
                    if let updatedTime = attendance.updatedTimeIn as? Date{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedTime, format: "hh:mm a")
                        print("updated time from server = \(updatedtime)")
                        self.lbl1.text = updatedtime
                        print("updated time in for attendance history = \(updatedtime)")
                    }
                }
            }
            
            if let checkouttime = attendance.checkOutTime{
                let oldtimeOut =
                Utils.getDateWithAppendingDay(day: 0, date: checkouttime as Date, format: "hh:mm a")
                self.vwCheckout.isHidden = false
                self.lbl2.isHidden = false
                //if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                //self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                //        }else{
                //self.lbl2.textColor = UIColor.systemBlue
                //        }
                self.lbl2.text = oldtimeOut
                self.lblNewCheckOut.text =  oldtimeOut
                
                if(attendance.checkOutApproved ==  true){
                    
                    if let timeout = attendance.timeOut as? NSDate{
                        //    if(attendance.checkOutApproved == false || attendance.manualApproved ==  false){
                        //
                        //    self.lbl2.textColor =   UIColor.systemBlue
                        //
                        //            }else{
                        //    self.lbl2.textColor = UIColor.black
                        //            }
                        //    if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                        //    self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                        //            }else{
                        //    self.lbl2.textColor = UIColor.systemBlue
                        //            }
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a")
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = newTimeOut
                        print("new time out = \(newTimeOut)")
                    }else if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a")
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                        self.lbl2.text = checkouttime
                        print("checkout time = \(checkouttime)")
                    }
                }else{
                    if let timeout = attendance.timeOut as? NSDate{
                        //                            if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                        //                            self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                        //                                    }else{
                        //                            self.lbl2.textColor = UIColor.systemBlue
                        //                                    }
                        //
                        let newTimeOut =  Utils.getDateWithAppendingDay(day: 0, date:timeout as Date, format: "hh:mm a")
                        self.lblNewCheckOut.text = newTimeOut
                    }else if let updatedTimeOut = attendance.updatedTimeOut as? NSDate{
                        let checkouttime = Utils.getDateWithAppendingDay(day: 0, date: updatedTimeOut as Date, format: "hh:mm a")
                        self.lblNewCheckOut.text = checkouttime
                    }
                }
                
            }else{
                if(attendance.updatedTimeOut != nil){
                    //        if(attendance.checkOutApproved == true || attendance.manualApproved ==  true){
                    //        self.lbl2.textColor =  UIColor.black // UIColor.systemBlue
                    //                }else{
                    //        self.lbl2.textColor = UIColor.systemBlue
                    //                }
                    if let updatedoutTime = attendance.updatedTimeOut as? Date{
                        let updatedtime = Utils.getDateWithAppendingDay(day: 0, date: updatedoutTime, format: "hh:mm a")
                        self.vwCheckout.isHidden = false
                        self.lbl2.isHidden = false
                      //  self.lbl2.text = "test"
                        self.lblNewCheckOut.text = updatedtime
                    }
                }
            }*/
            
       // }
        
        
        
        
    }
    
}
