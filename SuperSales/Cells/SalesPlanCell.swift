//
//  SalesPlanCell.swift
//  SuperSales
//
//  Created by Apple on 29/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
protocol SalesPlanCellDelegate{
    
    func iconEditCustomerClicked(cell:SalesPlanCell)
    func iconCallClicked(cell:SalesPlanCell)
    func iconWhatsAppClicked(cell:SalesPlanCell)
    func iconMapClicked(cell:SalesPlanCell)
    func visitDetailTapped(cell:SalesPlanCell)
    func visitCheckinTapped(cell:SalesPlanCell)
    func visitReportTapped(cell:SalesPlanCell)
    func orderFromClickedTapped(cell:SalesPlanCell)
}
class SalesPlanCell: UITableViewCell {
    
    
    
    
    var salesplandelegate:SalesPlanCellDelegate?
    // swiftlint:disable line_length
    typealias CheckinCompletionBlock = (VisitType) -> Void
    
    var checkinCompeletionBlock:CheckinCompletionBlock!
    @IBOutlet weak var vwBtnWhatsApp: UIView!
    @IBOutlet var vwParentView: UIView!
    
    @IBOutlet var widthForViewConstant: NSLayoutConstraint!
    //  @IBOutlet weak var vwContactInfo: UIStackView!
    
    @IBOutlet weak var vwContactInfo: UIView!
    @IBOutlet weak var vwLocationInfo: UIView!
    
    
    // @IBOutlet weak var vwbtnCallWidth: NSLayoutConstraint!
    @IBOutlet weak var vwbtnLocationWidth: NSLayoutConstraint!
    @IBOutlet weak var vwbtnLocation: UIView!
    //    @IBOutlet var btnLocation: UIImageView!
    
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnWhatsapp: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblAddressVisit: UILabel!
    
    @IBOutlet weak var vwLblLocation: UIView!
    @IBOutlet weak var stackDetailInfo: UIView!
    
    @IBOutlet weak var stkForOrder: UIStackView!
    // @IBOutlet weak var stackDetailInfo: UIStackView!
    
    //  @IBOutlet weak var vwLocationInfo: UIStackView!
    
    
    
    @IBOutlet weak var btnEditCustomer: UIButton!
    @IBOutlet weak var vwbtnCall: UIView!
    //  @IBOutlet weak var btnCall: UIImageView!
    
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet var lblCheckin: UILabel!
    
    // @IBOutlet weak var vwImgContact: UIView!
    @IBOutlet var lblCheckinTitle: UILabel!
    //  @IBOutlet weak var imgType: UIImageView!
    
    @IBOutlet weak var vwTitleInfo: UIView!
    @IBOutlet weak var stackTitleInfo: UIStackView!
    @IBOutlet weak var vwIndication: UIView!
    @IBOutlet weak var imgExpantion: UIImageView!
    @IBOutlet weak var lblIndicator: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblContactPersonName: UILabel!
    var isexpand:Bool! = false
    
    @IBOutlet weak var btnVisitReport: UIButton!
    
    @IBOutlet weak var btnVisitCheckin: UIButton!
    
    @IBOutlet weak var btnVisitDetail: UIButton!
    
    
    @IBOutlet var lblReportTitle: UILabel!
    
    
    
    @IBOutlet weak var btnOrderFrom: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblCheckin.isHidden = true
        self.btnLocation.isHidden = false
        self.btnCall.isHidden = false
        //        self.btnLocation.isHidden = false
        //        self.btnCall.isHidden = false
        
        self.vwbtnCall.isHidden = false
        self.vwbtnLocation.isHidden = false
        self.lblCheckinTitle.text = "Checkin"
        self.lblIndicator.text = ""
        self.lblReportTitle.text = ""
        self.lblCompanyName.text = ""
        
        //self.btnCall.backgroundColor = UIColor.red
        // Clear all content based views and their actions here
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.lblIndicator.layer.cornerRadius = self.lblIndicator.frame.size.width/2
        self.lblIndicator.layer.masksToBounds = true
        
        // Initialization code
        self.lblCheckin.isHidden = true
        self.btnCall.isHidden = true
        self.btnEditCustomer.isHidden = true
    }
    
    func setPlannedVisitData(visit:SalesPlanModel , expaned:IndexPath ,currentindexpath:IndexPath,compeletion:@escaping CheckinCompletionBlock){
        self.lblCheckinTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblCheckinTitle.layoutIfNeeded()
        if(self.stkForOrder.isHidden){
            
            let widthconstranint = self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            NSLayoutConstraint.activate([widthconstranint])
            //widthForViewConstant.constant >= 100
        }else{
            //  self.lblCheckinTitle.widthAnchor.constraint(equalToConstant: 40)
            let widthconstranint = self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            NSLayoutConstraint.activate([widthconstranint])
            //widthForViewConstant.constant >= 40
        }
        if(visit.isCheckedIn){
            self.vwBtnWhatsApp.isHidden = true
            self.vwBtnWhatsApp.isUserInteractionEnabled = false
            self.btnLocation.isUserInteractionEnabled = false
            self.lblCheckin.isHidden = false
        }else{
            self.vwBtnWhatsApp.isUserInteractionEnabled = true
            self.btnLocation.isUserInteractionEnabled = true
            self.lblCheckin.isHidden = true
        }
        checkinCompeletionBlock = compeletion
        self.vwLocationInfo.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xF2F2F7)
        self.lblIndicator.text = "V"
        self.imgExpantion.image = UIImage.init(named: "icon_right_green")
        self.lblIndicator.textColor = UIColor.graphDarkCyanColor
        self.vwIndication.backgroundColor = UIColor.graphDarkCyanColor
        
        self.lblCompanyName.text = visit.checkInCustomerName
        self.lblReportTitle.text = "Report"
        var strnt = ""
        self.stkForOrder.isHidden = false
        if let planvisit = PlannVisit.getVisit(visitID: visit.modulePrimaryID){
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: planvisit.originalNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                strnt = strn
            }
            let dateFormater = DateFormatter()
            dateFormater.dateFormat =  "yyyy/MM/dd HH:mm:ss"
            let date = dateFormater.date(from: strnt)
            self.lblTime.text = (visit.nextActionTime?.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a"): ""
        }else{
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: visit.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                strnt = strn
            }
            let dateFormater = DateFormatter()
            dateFormater.dateFormat =  "yyyy/MM/dd HH:mm:ss"
            let date = dateFormater.date(from: strnt)
            self.lblTime.text = (visit.nextActionTime?.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a"): ""
        }
        
        
        self.lblContactPersonName.text = String.init(format:"\(visit.customerMobileNumber ?? "")")
        let strAddress = visit.chekInAddress  ?? ""//""
        let attrs = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.black] as [NSAttributedString.Key : Any]
        let buttonplandetailStr = NSMutableAttributedString(string:strAddress, attributes:attrs)
        self.lblAddressVisit.attributedText = buttonplandetailStr
        self.lblAddressVisit.setMultilineLabel(lbl: self.lblAddressVisit)
        //    self.lblAddressVisit.text = strAddress
        self.lblAddressVisit.setMultilineLabel(lbl: self.lblAddressVisit)
        
        
        
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    func setBeatPlanSalesData(model:SalesPlanModel, expaned:IndexPath ,currentindexpath:IndexPath)->(){
        if(self.stkForOrder.isHidden){
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            //widthForViewConstant.constant >= 100
        }else{
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            //widthForViewConstant.constant >= 40
        }
        
        
        self.vwLocationInfo.backgroundColor = UIColor.clear
        self.vwbtnLocation.isHidden = true
        self.vwbtnCall.isHidden = true
        //   self.vwbtnCallWidth.constant = 0
        self.vwbtnLocationWidth.constant = 0
        
        self.lblTime.text = "10:00 AM"
        self.lblIndicator.text = "B"
        
        self.imgExpantion.image = UIImage.init(named: "icon_right_yellow")
        self.lblIndicator.textColor = UIColor.graphYellowColor
        self.vwIndication.backgroundColor = UIColor.graphYellowColor
        var bpid = ""
        if  let beatplanID = model.beatPlanID as? String{
            bpid = beatplanID
        }
        var bpn = ""
        if let beaplanName = model.beatPlanName as? String{
            bpn = beaplanName
        }
        self.lblCompanyName.text = String.init(format:"%@  %@",bpid,bpn)
        self.stkForOrder.isHidden = true
        self.btnCall.isHidden = true
        //if((!self.isexpand)&&(expaned == currentindexpath)){
        //        if(self.isexpand){
        //            self.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
        //self.lblIndicator.backgroundColor = UIColor.white
        //self.lblIndicator.textColor = UIColor.graphYellowColor
        //    self.vwTitleInfo.backgroundColor =  UIColor.graphYellowColor
        //        self.lblCompanyName.textColor = UIColor.white
        //        self.lblTime.textColor = UIColor.white
        //        self.vwContactInfo.isHidden = false
        //        self.vwLocationInfo.isHidden = false
        //        self.stackDetailInfo.isHidden = true
        //                }else{
        //                    self.lblIndicator.backgroundColor = UIColor.graphYellowColor
        //                    self.lblIndicator.textColor = UIColor.white
        //                    vwTitleInfo.backgroundColor = UIColor.white
        //                    self.lblCompanyName.textColor = UIColor.black
        //                    self.lblTime.textColor = UIColor.black
        //                    self.vwContactInfo.isHidden = true
        //                    self.vwLocationInfo.isHidden = true
        //                    self.stackDetailInfo.isHidden = true
        //                }
        self.lblContactPersonName.textAlignment = NSTextAlignment.left
        //        self.vwContactInfo.isHidden = true
        //        self.vwLocationInfo
        if(model.isActive == 1){
            self.lblContactPersonName.text = "Approved"
        }else if (model.isActive == 2){
            self.lblContactPersonName.text = "Pending Approval"
        }else{
            self.lblContactPersonName.text = "Visit Created"
        }
        self.btnLocation.isHidden = true
        //        self.vwLocationInfo.isHidden = false
        let attrs = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.Appthemebluecolor,
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        let buttonplandetailStr = NSMutableAttributedString(string:"View BeatPlan Detail", attributes:attrs)
        self.lblAddressVisit.attributedText = buttonplandetailStr
        
        //        self.lblAddressVisit.text = "Visit Created"
        //        lblAddressVisit.isHidden = false
        
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    func setColdCallData(model:SalesPlanModel, expaned:IndexPath ,currentindexpath:IndexPath)->(){
        self.lblCheckinTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblCheckinTitle.layoutIfNeeded()
        if(self.stkForOrder.isHidden){
            
            let widthconstranint = self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            NSLayoutConstraint.activate([widthconstranint])
            //widthForViewConstant.constant >= 100
        }else{
            //  self.lblCheckinTitle.widthAnchor.constraint(equalToConstant: 40)
            let widthconstranint = self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            NSLayoutConstraint.activate([widthconstranint])
            //widthForViewConstant.constant >= 40
        }
        self.stkForOrder.isHidden = true
        let date  =  Utils.getDateBigFormatToDefaultFormat(date: model.checkInTime ?? "2021/10/18 10:18:18", format: "yyyy/MM/dd")//Utils.getDatestringWithGMT(gmtDateString: lastvisitcheckin.checkInTime, format: "yyyy/mm/dd")
        
        if(date == SalesPlanHome.selectedDate){
            
            
            if(model.checkInTime?.count ?? 0 > 0){
                self.lblCheckinTitle.text = "Checkout"
                self.lblCheckin.isHidden = false
                var strcheckin = ""
                if let strn = Utils.getDateBigFormatToDefaultFormat(date: model.checkInTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                    strcheckin = strn
                }
                self.lblCheckin.text =  String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: strcheckin, format: "hh:mm a"))")
                
                // self.lblCheckin.text = model.checkInTime
            }else{
                self.lblCheckinTitle.text = "Checkin"
                self.btnCall.isHidden =  false
            }
        }else{
            self.lblCheckinTitle.text = "Checkin"
            self.btnCall.isHidden =  false
        }
        self.lblIndicator.text = "C"
        self.imgExpantion.image = UIImage.init(named: "icon_right_skyblue")
        self.lblIndicator.textColor = UIColor.brown //UIColor.UnPlannedVisitIndicationcolor
        self.vwIndication.backgroundColor = UIColor.brown
        
        self.lblCompanyName.text = model.checkInCustomerName
        var strnt = ""
        if let strn = Utils.getDateBigFormatToDefaultFormat(date: model.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            strnt = strn
        }
        
        self.lblTime.text = (model.nextActionTime?.count ?? 0 > 0) ? (Utils.getDateBigFormatToDefaultFormat(date: strnt, format: "hh:mm a")
                                                                      , format: "hh:mm a") as? String ?? " " : ""  //Utils.getDateBigFormatToDefaultFormat(date: strnt
        self.lblContactPersonName.attributedText = NSMutableAttributedString().stratributed(bold: "Remark: ", normal: model.modelDescription ?? "")
        
        self.lblAddressVisit.isHidden = true
        if let stacktitle =  self.stackTitleInfo{
            self.stackTitleInfo.isHidden = false
        }
        self.btnCall.isHidden = true
        
        
        
        self.btnLocation.isHidden = true
        
        
        
        
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    func setActivityPlanData(model:SalesPlanModel, expaned:IndexPath ,currentindexpath:IndexPath)->(){
        if(self.stkForOrder.isHidden){
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            //widthForViewConstant.constant >= 100
        }else{
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            //widthForViewConstant.constant >= 40
        }
        self.stkForOrder.isHidden = true
        let date  =  Utils.getDateBigFormatToDefaultFormat(date: model.checkInTime ?? "2021/10/18 10:18:18", format: "yyyy/MM/dd")//Utils.getDatestringWithGMT(gmtDateString: lastvisitcheckin.checkInTime, format: "yyyy/mm/dd")
        
        if(date == SalesPlanHome.selectedDate){
            if(model.checkInTime?.count ?? 0 > 0){
                self.lblCheckin.isHidden = false
                
                var strcheckin = ""
                if let strn = Utils.getDateBigFormatToDefaultFormat(date: model.checkInTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                    strcheckin = strn
                }
                self.lblCheckin.text =  String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: strcheckin, format: "hh:mm a"))")
                self.lblCheckinTitle.text = "Checkout"
                // self.lblCheckin.text = model.checkInTime
            }else{
                self.lblCheckinTitle.text =  "Checkin"
                self.btnCall.isHidden =  false
            }
        }else{
            self.lblCheckinTitle.text =  "Checkin"
            self.btnCall.isHidden =  false
        }
        self.lblIndicator.text = "A"
        self.lblReportTitle.text = "Report"
        self.imgExpantion.image = UIImage.init(named: "icon_right_violet")
        self.lblIndicator.textColor = UIColor.graphBlueColor
        self.vwIndication.backgroundColor = UIColor.graphBlueColor
        self.lblCompanyName.text = model.checkInCustomerName //visit.customerName
        /*
         
         if let strnextTime = activitymodel?.originalNextActionTime{
         let date = dateFormater.date(from: strnextTime)
         
         
         cell.lblCheckinTime.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: activitymodel?.nextActionTime ?? "67/68/678687", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/02/12 09:02:12", format: "dd-MM-yyyy, hh:mm a")
         //Utils.getDateinstrwithaspectedFormat(givendate:date ?? Date(), format: "dd-MM-yyyy ,  hh:mm a", defaultTimZone: false)
         
         
         
         }
         if let strn = Utils.getDateBigFormatToDefaultFormat(date: visit.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
         strnt = strn
         }
         
         self.lblTime.text = (visit.nextActionTime?.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a"): ""
         **/
        var strnt = ""
        if let strn = Utils.getDateBigFormatToDefaultFormat(date: model.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            strnt = strn
        }
        self.lblTime.text = (model.nextActionTime.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a"): ""//getDateBigFormatToDefaultFormat//(model.nextActionTime.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: model.nextActionTime ?? "67/68/678687", format: "hh:mm a") ?? "2020/02/12 09:02:12", format: "hh:mm a") : ""
        
        
        //(model.nextActionTime.count ?? 0 > 0) ? Utils.getDateBigFormatToDefaultFormat(date: strnt, format: "hh:mm a"): ""//getDateBigFormatToDefaultFormat
        // self.lblContactPersonName.text = visit.customerName
        if let contactno =  model.customerMobileNumber{
            self.lblContactPersonName.text = String.init(format:"\(contactno)")
            
        }else{
            self.lblContactPersonName.text = ""
        }
        self.lblContactPersonName.setMultilineLabel(lbl: self.lblContactPersonName)
        let strAddress = model.chekInAddress//""
        
        self.lblAddressVisit.text = strAddress
        self.lblAddressVisit.setMultilineLabel(lbl: self.lblAddressVisit)
        //self.stackTitleInfo.isHidden = false
        
        //   if((!self.isexpand) && (currentindexpath == expaned)){
        
        
        
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    func setLeadPlanData(model:SalesPlanModel, expaned:IndexPath ,currentindexpath:IndexPath)->(){
        if(model.isCheckedIn){
            self.vwBtnWhatsApp.isHidden = true
            self.vwBtnWhatsApp.isUserInteractionEnabled = false
            self.btnLocation.isUserInteractionEnabled = false
            self.lblCheckin.isHidden = false
        }else{
            self.vwBtnWhatsApp.isUserInteractionEnabled = true
            self.btnLocation.isUserInteractionEnabled = true
            self.lblCheckin.isHidden = true
        }
        if(self.stkForOrder.isHidden){
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            //widthForViewConstant.constant >= 100
        }else{
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            //widthForViewConstant.constant >= 40
        }
        
        let date  =  Utils.getDateBigFormatToDefaultFormat(date: model.checkInTime ?? "2021/10/18 10:18:18", format: "yyyy/MM/dd")//Utils.getDatestringWithGMT(gmtDateString: lastvisitcheckin.checkInTime, format: "yyyy/mm/dd")
        self.stkForOrder.isHidden = true
        if(date == SalesPlanHome.selectedDate){
            if(model.checkInTime?.count ?? 0 > 0){
                self.lblCheckin.isHidden = false
                self.btnCall.isHidden = true
                
                var strcheckin = ""
                if let strn = Utils.getDateBigFormatToDefaultFormat(date: model.checkInTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                    strcheckin = strn
                }
                self.lblCheckin.text = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: strcheckin, format: "hh:mm a"))")
                self.lblCheckinTitle.text = "Checkout"
                // self.lblCheckin.text = model.checkInTime
            }else{
                self.lblCheckinTitle.text =  "Checkin"
                self.lblCheckin.isHidden = true
                self.btnCall.isHidden =  false
            }
        }else{
            self.lblCheckinTitle.text =  "Checkin"
            self.lblCheckin.isHidden = true
            self.btnCall.isHidden =  false
        }
        self.lblIndicator.text = "L"
        self.imgExpantion.image = UIImage.init(named: "icon_right_violet")
        self.lblReportTitle.text = "Status"
        
        self.lblIndicator.textColor = UIColor.graphDarkVioletColor
        self.vwIndication.backgroundColor = UIColor.graphDarkVioletColor
        self.lblCompanyName.text = model.checkInCustomerName //visit.customerName
        /*
         if(visit.nextActionTime?.count ?? 0 > 0){
         var strnt = ""
         if let strn = Utils.getDateBigFormatToDefaultFormat(date: visit.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
         strnt = strn
         }
         self.lblNextActionDetail.text = String.init(format: "%@:%@", arguments: [NSLocalizedString("next_action", comment: ""),Utils.getDatestringWithGMT(gmtDateString: strnt, format: "dd-MM-yyyy , hh:mm a")])
         
         **/
        var strnt = ""
        if let strn = Utils.getDateBigFormatToDefaultFormat(date: model.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            strnt = strn
        }
        self.lblTime.text = (model.nextActionTime.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a"): ""
        //getDateBigFormatToDefaultFormat //getDatestringWithGMT
        if let contactno =  model.customerMobileNumber{
            self.lblContactPersonName.text = String.init(format:"\(contactno)")
        }
        else{
            
        }
        let strAddress = model.chekInAddress//""
        
        
        self.lblAddressVisit.text = strAddress
        
        self.lblAddressVisit.setMultilineLabel(lbl: self.lblAddressVisit)
        
        
        
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    
    func  setUnplanVisitSalesData(model:SalesPlanModel, expaned:IndexPath ,currentindexpath:IndexPath)->(){
        self.lblCheckinTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblCheckinTitle.layoutIfNeeded()
        if(self.stkForOrder.isHidden){
            
            let widthconstranint = self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            NSLayoutConstraint.activate([widthconstranint])
            //widthForViewConstant.constant >= 100
        }else{
            //  self.lblCheckinTitle.widthAnchor.constraint(equalToConstant: 40)
            let widthconstranint = self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            NSLayoutConstraint.activate([widthconstranint])
            //widthForViewConstant.constant >= 40
        }
        self.stkForOrder.isHidden = true
        let date  =  Utils.getDateBigFormatToDefaultFormat(date: model.checkInTime ?? "2021/10/18 10:18:18", format: "yyyy/MM/dd")//Utils.getDatestringWithGMT(gmtDateString: lastvisitcheckin.checkInTime, format: "yyyy/mm/dd")
        
        if(date == SalesPlanHome.selectedDate){
            if(model.checkInTime?.count ?? 0 > 0){
                self.lblCheckinTitle.text = "Checkout"
                //self.btnVisitDetail.setTitle("Checkout", for: .normal)
                self.lblCheckin.isHidden = false
                self.btnCall.isHidden = true
                var strcheckin = ""
                if let strn = Utils.getDateBigFormatToDefaultFormat(date: model.checkInTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                    strcheckin = strn
                }
                self.lblCheckin.text =  String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: strcheckin, format: "hh:mm a"))")
                
                
            }else{
                self.lblCheckinTitle.text =  "Checkin"
                //  self.btnVisitDetail.setTitle("Checkin", for: .normal)
                // self.lblCheckinTitle.isHidden = true
                self.btnCall.isHidden =  false
            }
        }else{
            self.lblCheckinTitle.text =  "Checkin"
            //  self.btnVisitDetail.setTitle("Checkin", for: .normal)
            // self.lblCheckinTitle.isHidden = true
            self.btnCall.isHidden =  false
        }
        self.lblIndicator.text = "C"
        self.lblReportTitle.text = "Report"
        self.imgExpantion.image = UIImage.init(named: "icon_right_violet")
        self.lblIndicator.textColor =  UIColor.UnPlannedVisitIndicationcolor
        self.vwIndication.backgroundColor = UIColor.UnPlannedVisitIndicationcolor
        self.lblCompanyName.text = model.checkInCustomerName //visit.customerName
        
        var strnt = ""
        if let strn = Utils.getDateBigFormatToDefaultFormat(date: model.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            strnt = strn
        }
        self.lblTime.text = (model.nextActionTime.count ?? 0 > 0) ? Utils.getDateBigFormatToDefaultFormat(date: strnt, format: "hh:mm a"): ""//getDateBigFormatToDefaultFormat //getDatestringWithGMT
        // self.lblContactPersonName.text = visit.customerName
        if let contactno =  model.customerMobileNumber{
            self.lblContactPersonName.text = String.init(format:"\(contactno)")
        }else{
            self.lblContactPersonName.text = ""
        }
        /*   if let  customer = CustomerDetails.getCustomerByID(cid: model.customerID ?? NSNumber.init(value:0)) as? CustomerDetails{
         self.lblContactPersonName.text = customer.mobileNo
         }else{
         self.lblContactPersonName.text = ""
         }*/
        
        /* if(visit.contactName?.count == 0 && Int(visit.contactID ?? 0) > 0){
         let contact =  Contact.getContactsUsingCustomerID(customerId: visit.contactID ?? 0).first
         // self.lblContactPersonName.text = String.init(format: "%@ %@", (contact?.firstName ?? "") ,(contact?.lastName ?? ""))
         self.lblContactPersonName.text  = contact?.mobile
         }else{
         //  self.lblContactPersonName.text = (visit.contactName?.count == 0) ? "No Contact" : visit.contactName
         self.lblContactPersonName.text  =  ""
         }*/
        var strAddress = model.chekInAddress//""
        
        
        self.lblAddressVisit.text = strAddress
        
        self.lblAddressVisit.setMultilineLabel(lbl: self.lblAddressVisit)
        // self.stackTitleInfo.isHidden = false
        
        
        
        
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    func setVisitData(visit:PlannVisit)->(){
        self.lblCheckinTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblCheckinTitle.layoutIfNeeded()
        if(self.stkForOrder.isHidden){
            let autoresizeoff: () = self.lblCheckinTitle.translatesAutoresizingMaskIntoConstraints = false
            let widthconstranint = self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            NSLayoutConstraint.activate([widthconstranint])
            //widthForViewConstant.constant >= 100
        }else{
            //  self.lblCheckinTitle.widthAnchor.constraint(equalToConstant: 40)
            let widthconstranint = self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            NSLayoutConstraint.activate([widthconstranint])
            //widthForViewConstant.constant >= 40
        }
        self.btnCall.isHidden =  false
        self.lblIndicator.text = "V"
        self.imgExpantion.image = UIImage.init(named: "icon_right_green")
        self.lblIndicator.textColor = UIColor.PlannedVisitIndicationcolor
        self.vwIndication.backgroundColor = UIColor.PlannedVisitIndicationcolor
        self.lblCompanyName.text =  visit.customerName
        /*(visit.nextActionTime?.count ?? 0 > 0) ?
         String.init(format: "%@:%@", arguments: [NSLocalizedString("next_action", comment: ""),Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: visit.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss"), format: "dd-MM-yyyy , hh:mm a")]) : ""*/
        var strnt = ""
        if let strn = Utils.getDateBigFormatToDefaultFormat(date: visit.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            strnt = strn
        }
        
        self.lblTime.text = (visit.nextActionTime?.count ?? 0 > 0) ? Utils.getDateBigFormatToDefaultFormat(date: strnt, format: "hh:mm a"): "" //getDateBigFormatToDefaultFormat //getDatestringWithGMT
        //  self.lblContactPersonName.text = visit.contactMobileNo
        
        //        if(visit.contactName?.count == 0 && visit.contactID  > 0){
        //        let contact =  Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value:visit.contactID) ).first
        //        self.lblContactPersonName.text = String.init(format: "%@ %@", (contact?.firstName ?? "") ,(contact?.lastName ?? ""))
        //            self.lblContactPersonName.text = contact?.mobile
        //        }else{
        //        self.lblContactPersonName.text = ""//(visit.contactName?.count == 0) ? "No Contact" : visit.contactName
        //        }
        if let  customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:visit.customerID ?? 0)) as? CustomerDetails{
            self.lblContactPersonName.text = customer.mobileNo
        }else{
            self.lblContactPersonName.text = ""
        }
        //        if let customer = CustomerDetails().
        //    self.lblContactPersonName.text = visit.MobileNo
        var strAddress = ""
        if(visit.addressMasterID > 0){
            if  let address = AddressList().getAddressStringByAddressId(aId:
                                                                            NSNumber.init(value:visit.addressMasterID)) as? String{
                strAddress = address
            }
        }
        
        self.lblAddressVisit.setMultilineLabel(lbl: self.lblAddressVisit)
        
        self.lblAddressVisit.text = strAddress
        self.stackTitleInfo.isHidden = false
        self.stkForOrder.isHidden = false
        if(self.isexpand){
            self.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
            self.lblIndicator.backgroundColor = UIColor.white
            self.lblIndicator.textColor = UIColor.PlannedVisitIndicationcolor
            vwTitleInfo.backgroundColor =  UIColor.PlannedVisitIndicationcolor
            self.lblCompanyName.textColor = UIColor.white
            self.lblTime.textColor = UIColor.white
            
            self.vwContactInfo.isHidden = false
            self.vwLocationInfo.isHidden = false
            self.stackDetailInfo.isHidden = false
            self.contentView.layoutIfNeeded()
        }else{
            vwTitleInfo.setShadow()
            self.lblIndicator.backgroundColor = UIColor.PlannedVisitIndicationcolor
            self.lblIndicator.textColor = UIColor.white
            vwTitleInfo.backgroundColor = UIColor.white
            self.lblCompanyName.textColor = UIColor.black
            self.lblTime.textColor = UIColor.black
            self.vwContactInfo.isHidden = true
            self.vwLocationInfo.isHidden = true
            self.stackDetailInfo.isHidden = true
        }
        
        
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
        
    }
    
    func setActivityVisitData(activityvisit:Activitymodel)->(){
        if(self.stkForOrder.isHidden){
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            //widthForViewConstant.constant >= 100
        }else{
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            //widthForViewConstant.constant >= 40
        }
        self.lblContactPersonName.setMultilineLabel(lbl: self.lblContactPersonName)
        self.btnCall.isHidden =  false
        self.lblIndicator.text = "A"
        self.imgExpantion.image = UIImage.init(named: "icon_right_violet")
        self.lblIndicator.textColor = UIColor.ActivityVisitIndicationcolor
        self.vwIndication.backgroundColor = UIColor.ActivityVisitIndicationcolor
        self.lblCompanyName.text =  activityvisit.activityTypeName
        print(activityvisit.activityTypeName)
        var strct = ""
        if let strc = Utils.getDateBigFormatToDefaultFormat(date:activityvisit.createdTime  ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            strct = strc
        }
        self.lblTime.text = (activityvisit.createdTime?.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strct, format: "hh:mm a") : ""
        
        self.lblContactPersonName.text = activityvisit.activitydescription
        var strAddress = ""
        // if(activityvisit.addressMasterID > 0){
        if let address = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:activityvisit.addressMasterID ?? 0)) as? String{
            strAddress = address
        }
        // }
        self.lblAddressVisit.text = strAddress
        self.stackTitleInfo.isHidden = false
        self.stkForOrder.isHidden = true
        if(self.isexpand){
            self.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
            self.lblIndicator.backgroundColor = UIColor.white
            self.lblIndicator.textColor = UIColor.ActivityVisitIndicationcolor
            vwTitleInfo.backgroundColor =  UIColor.ActivityVisitIndicationcolor
            self.lblCompanyName.textColor = UIColor.white
            self.lblTime.textColor = UIColor.white
            
            self.vwContactInfo.isHidden = false
            self.vwLocationInfo.isHidden = false
            self.stackDetailInfo.isHidden = false
            self.contentView.layoutIfNeeded()
        }else{
            vwTitleInfo.setShadow()
            self.lblIndicator.backgroundColor = UIColor.ActivityVisitIndicationcolor
            self.lblIndicator.textColor = UIColor.white
            vwTitleInfo.backgroundColor = UIColor.white
            self.lblCompanyName.textColor = UIColor.black
            self.lblTime.textColor = UIColor.black
            self.vwContactInfo.isHidden = true
            self.vwLocationInfo.isHidden = true
            self.stackDetailInfo.isHidden = true
        }
        
        
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    func setBeatplanVisitData(bvisit:BeatPlan)->(){
        if(self.stkForOrder.isHidden){
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            //widthForViewConstant.constant >= 100
        }else{
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            //widthForViewConstant.constant >= 40
        }
        self.btnCall.isHidden = false
        self.lblIndicator.text = "B"
        self.imgExpantion.image = UIImage.init(named: "icon_right_skyblue")
        self.lblIndicator.textColor = UIColor.BeatPlanVisitIndicationcolor
        self.vwIndication.backgroundColor = UIColor.BeatPlanVisitIndicationcolor
        self.lblCompanyName.text =  String.init(format:"%@   %@",bvisit.BeatPlanID,bvisit.BeatPlanName)
        //bvisit.customerName
        //        var strbpd = ""
        //        if let strbp = Utils.getDateBigFormatToDefaultFormat(date:bvisit.BeatPlanDate  ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
        //         strbpd = strbp
        //        }
        //
        //        var strbcnat = ""
        //         if let strn = Utils.getDateBigFormatToDefaultFormat(date: bvisit.NextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
        //            strbcnat = strn
        //         }
        
        self.lblTime.text = "10:00 AM"
        // self.lblTime.text = (bvisit.BeatPlanDate?.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strbpd, format: "dd-MM-yyyy") : ""
        
        self.stackTitleInfo.isHidden = false
        self.btnCall.isHidden = true
        if(self.isexpand){
            self.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
            self.lblIndicator.backgroundColor = UIColor.white
            self.lblIndicator.textColor = UIColor.BeatPlanVisitIndicationcolor
            vwTitleInfo.backgroundColor =  UIColor.BeatPlanVisitIndicationcolor
            self.lblCompanyName.textColor = UIColor.white
            self.lblTime.textColor = UIColor.white
            self.vwContactInfo.isHidden = false
            self.vwLocationInfo.isHidden = true
            self.stackDetailInfo.isHidden = true
        }else{
            vwTitleInfo.setShadow()
            
            self.lblIndicator.backgroundColor = UIColor.BeatPlanVisitIndicationcolor
            self.lblIndicator.textColor = UIColor.white
            vwTitleInfo.backgroundColor = UIColor.white
            self.lblCompanyName.textColor = UIColor.black
            self.lblTime.textColor = UIColor.black
            self.vwContactInfo.isHidden = true
            self.vwLocationInfo.isHidden = true
            self.stackDetailInfo.isHidden = true
        }
        if(bvisit.IsActive == 1){
            self.lblContactPersonName.text = "Approved"
        }else if (bvisit.IsActive == 2){
            self.lblContactPersonName.text = "Pending Approval"
        }else{
            self.lblContactPersonName.text = "Visit Created"
        }
        
        
        
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    func setUnplanVisitData(visit:UnplannedVisit)->(){
        if(self.stkForOrder.isHidden){
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            //widthForViewConstant.constant >= 100
        }else{
            self.lblCheckinTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            //widthForViewConstant.constant >= 40
        }
        self.btnCall.isHidden = false
        self.lblIndicator.text = "V"
        self.imgExpantion.image = UIImage.init(named: "icon_right_violet")
        self.lblIndicator.textColor = UIColor.UnPlannedVisitIndicationcolor
        self.vwIndication.backgroundColor = UIColor.UnPlannedVisitIndicationcolor
        self.lblCompanyName.text =  visit.customerName
        
        var strnt = ""
        if let strn = Utils.getDateBigFormatToDefaultFormat(date: visit.NextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            strnt = strn
        }
        self.lblTime.text = (visit.NextActionTime?.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a"): ""
        // self.lblContactPersonName.text = visit.customerName
        if(visit.contactName?.count == 0 && Int(visit.contactID ?? 0) > 0){
            let contact =  Contact.getContactsUsingCustomerID(customerId: visit.contactID ?? 0).first
            self.lblContactPersonName.text  = contact?.mobile
        }else{
            self.lblContactPersonName.text  =  ""
        }
        var strAddress = ""
        if(visit.addressMasterID?.intValue ?? 0 > 0){
            if let address =  AddressList().getAddressStringByAddressId(aId: visit.addressMasterID ?? 0) as? String{
                strAddress = address
            }else{
                strAddress = ""
            }
        }
        self.lblAddressVisit.text = strAddress
        let strAddress1 = String.init(format:" %@, %@, %@-%@, %@ %@", visit.tempCustomerObj?.AddressLine1 ?? "", visit.tempCustomerObj?.AddressLine2 ?? "", visit.tempCustomerObj?.City ?? "", visit.tempCustomerObj?.Pincode ?? "", visit.tempCustomerObj?.State ?? "", visit.tempCustomerObj?.Country ?? "")
        //   strAddress1 = String.init(format: "%@ , %@ , %@ - %lld , %@ %@", address.addressLine1 ?? "" , address.addressLine2  ?? "",address.city  ?? "",address.pincode  ?? "", address.state ?? "" , address.country  ?? "")
        
        
        
        self.lblAddressVisit.text = strAddress1
        self.lblAddressVisit.setMultilineLabel(lbl: self.lblAddressVisit)
        self.stackTitleInfo.isHidden = false
        self.stkForOrder.isHidden = true
        if(self.isexpand){
            self.imgExpantion.image = UIImage.init(named: "icon_down_arrow")
            self.lblIndicator.backgroundColor = UIColor.white
            self.lblIndicator.textColor = UIColor.UnPlannedVisitIndicationcolor
            vwTitleInfo.backgroundColor =  UIColor.UnPlannedVisitIndicationcolor
            self.lblCompanyName.textColor = UIColor.white
            self.lblTime.textColor = UIColor.white
            
            self.vwContactInfo.isHidden = false
            self.vwLocationInfo.isHidden = false
            self.stackDetailInfo.isHidden = false
        }else{
            vwTitleInfo.setShadow()
            self.lblIndicator.backgroundColor = UIColor.UnPlannedVisitIndicationcolor
            self.lblIndicator.textColor = UIColor.white
            vwTitleInfo.backgroundColor = UIColor.white
            self.lblCompanyName.textColor = UIColor.black
            self.lblTime.textColor = UIColor.black
            self.vwContactInfo.isHidden = true
            self.vwLocationInfo.isHidden = true
            self.stackDetailInfo.isHidden = true
        }
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK: IBAction
    
    
    @IBAction func btnEditCustomerClicked(_ sender: UIButton) {
        
        self.salesplandelegate?.iconEditCustomerClicked(cell: self)
    }
    
    @IBAction func btnWhatsAppClicked(_ sender: UIButton) {
        self.salesplandelegate?.iconWhatsAppClicked(cell: self)
    }
    @IBAction func btnCallIconChecked(_ sender: UIButton) {
        self.salesplandelegate?.iconCallClicked(cell: self)
    }
    
    
    @IBAction func btnLocationIconClicked(_ sender: UIButton) {
        self.salesplandelegate?.iconMapClicked(cell: self)
    }
    
    @IBAction func btnVisitDetailTapped(_ sender: UIButton) {
        self.salesplandelegate?.visitDetailTapped(cell: self)
    }
    
    @IBAction func btnVisitCheckinTapped(_ sender: UIButton) {
        self.salesplandelegate?.visitCheckinTapped(cell: self)
    }
    
    
    
    
    @IBAction func btnVisitReportTapped(_ sender: UIButton) {
        self.salesplandelegate?.visitReportTapped(cell: self)
    }
    
    @IBAction func btnOrderTapped(_ sender: UIButton) {
        self.salesplandelegate?.orderFromClickedTapped(cell: self)
    }
}
