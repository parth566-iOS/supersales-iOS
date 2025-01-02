//
//  VisitCell.swift
//  SuperSales
//
//  Created by Apple on 18/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit


class VisitCell: UITableViewCell {
// swiftlint:disable line_length
    
    @IBOutlet weak var stackViewAssignDetail: UIStackView!
    
    @IBOutlet weak var stkParent: UIStackView!
    // @IBOutlet weak var : UIStackView!
    @IBOutlet weak var stackViewNextActionDetail: UIStackView!
    @IBOutlet weak var vwCustomer: UIView!
    
    @IBOutlet weak var vwCheckinDetail: UIView!
    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var lblCustomerName: UILabel!
    
   
    @IBOutlet weak var imgInteractionType: UIImageView!
    
    @IBOutlet weak var lblAssigneeName: UILabel!
    
    @IBOutlet weak var lblCheckinDetail: UILabel!
    
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblNextActionDetail: UILabel!
    @IBOutlet weak var lblVisitDate: UILabel!
    
    @IBOutlet weak var lblVisitSeries: UILabel?
    @IBOutlet weak var lblNextActionDt: UILabel!
    
    @IBOutlet weak var lblNextActionTm: UILabel!
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.lblCustomerName.textColor = .white
        vwParent.layer.borderColor = UIColor().colorFromHexCode(rgbValue: (0xEEEEEE)).cgColor
        vwParent.setShadow()
        //UIColor.gray.cgColor
//        vwParent.layer.cornerRadius =  10
        
        vwParent.layer.borderWidth = 1
        
        
       
        
        vwCustomer.backgroundColor = UIColor.Appskybluecolor
        // Initialization code
    }
    override func prepareForReuse() {
        
        super.prepareForReuse()
       // self.lblNextActionTm.text = ""
//        self.lblNextActionDt.text = ""
//        self.lblVisitSeries?.text = ""
//        self.lblVisitDate.text = ""
//        self.lblCreatedBy.text = ""
//        self.lblCheckinDetail.text = ""
//        self.lblNextActionDetail.text = ""
//        self.lblAssigneeName.text = ""
//        self.lblCustomerName.text = ""
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(visit:PlannVisit,isPlan:Bool){
        
        self.lblCustomerName.text = visit.customerName
        let img = Utils.getImageFrom(interactionId: Int(visit.nextActionID))
        self.imgInteractionType.image = img
        var assigneeName = NSAttributedString.init(string:"",attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor])
        if(visit.reAssigned > 0){
            if(!isPlan){
            if let assignee = CompanyUsers().getUser(userId: NSNumber.init(value:visit.reAssigned)){
                assigneeName =    NSAttributedString.init(string: assignee.firstName ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor])
            }else{
                assigneeName =    NSAttributedString.init(string: visit.ressigneeName ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor])
            }
            }else{
            assigneeName =    NSAttributedString.init(string: visit.ressigneeName ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor])
            }
        }
      
        //String(format:("#(%d)",visit.seriesPostfix))
        let visitNo = NSAttributedString.init(string:String.init(format: " (# %d)", arguments: [visit.seriesPostfix]),  attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
       // self.lblVisitNo.attributedText = visitNo
        let strassigneename = NSMutableAttributedString.init(attributedString: assigneeName)
        strassigneename.append(visitNo)
        self.lblAssigneeName.attributedText = strassigneename
        self.lblAssigneeName.lineBreakMode = .byTruncatingTail
    
        self.lblVisitSeries?.attributedText = visitNo
        self.lblVisitDate.textColor = UIColor.Appthemebluecolor
        //(visit.createdTime?.count ?? 0 > 0) ?: ""
        var strct = ""
        if let strc = Utils.getDateBigFormatToDefaultFormat(date:visit.createdTime  ?? "", format: "yyyy/MM/dd HH:mm:ss"){
            strct = strc
        }
self.lblVisitDate.text = (visit.createdTime?.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strct, format: "d MMM") : ""
        var strcheckinout:String = ""
        if(visit.checkInOutData.count == 0){
            self.lblCheckinDetail.text = NSLocalizedString("not_checked_IN_yet", comment: "text for no checkin checkout detail")
            
        }else {
            if let visitcheckinoutobj:VisitCheckInOutList = visit.checkInOutData.firstObject as? VisitCheckInOutList{
            if(!(visitcheckinoutobj.checkInTime != nil) && !(visitcheckinoutobj.checkOutTime != nil)){
                self.lblCheckinDetail.text = NSLocalizedString("not_checked_IN_yet", comment: "text for no checkin checkout detail")
            }else{
                
                var color:UIColor
                if(visitcheckinoutobj.statusID == 3){
                    color = Common().UIColorFromRGB(rgbValue: 0xE04445)
                }else{
                    color = Common().UIColorFromRGB(rgbValue: 0x797979)
                }
                self.lblCheckinDetail.textColor = color
                if(visitcheckinoutobj.checkInTime != nil){
    var strco = ""
              
    if let strc = Utils.getDateBigFormatToDefaultFormat(date: visitcheckinoutobj.checkInTime, format: "yyyy/MM/dd HH:mm:ss"){
      strco =  strc
        }
    var strchint = ""
    if let strch = Utils.getDateBigFormatToDefaultFormat(date: strco, format: "yyyy/MM/dd HH:mm:ss"){
                strchint = strch

                    }
/*
                     [Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:acheckInList.checkInTime andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"d MMM hh:mm a"]]
                     **/
//                    if let strch = Utils.getDatestringWithGMT(gmtDateString:  Utils.getDateBigFormatToDefaultFormat(date: visitcheckinoutobj.checkInTime, format: "yyyy/MM/dd HH:mm:ss"), format: "d MMM hh:mm a"){
//                        strchint = strch
//                    }
strcheckinout =  String.init(format: "%@:%@", arguments:[NSLocalizedString("in", comment: ""),Utils.getDatestringWithGMT(gmtDateString: strchint, format: "d MMM hh:mm a")])
                    
               
                }
if(visitcheckinoutobj.checkOutTime != nil){
                    //[Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:acheckInList.checkInTime andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"d MMM hh:mm a"]]
    var strcht = ""
    if let strch = Utils.getDateBigFormatToDefaultFormat(date: visitcheckinoutobj.checkOutTime, format: "yyyy/MM/dd HH:mm:ss") as? String{
        strcht = strch
    }
    strcheckinout.append(String.init(format: "  %@:%@", arguments:[NSLocalizedString("out", comment: ""),Utils.getDatestringWithGMT(gmtDateString: strcht, format: "d MMM hh:mm a")]))
                }else{
                    strcheckinout.append(String.init(format:"%@:--",arguments:[NSLocalizedString("out", comment: "")]))
                }
                
                self.lblCheckinDetail.text = strcheckinout
               
            }
            }
           
            
        }
        
//        let range1 = strcheckinout.range(of: NSLocalizedString("in", comment: ""))
//         let range2 = strcheckinout.range(of: NSLocalizedString("out", comment: ""))
//         let range3 = strcheckinout.range(of: "--:--")
//        var attributedText = NSMutableAttributedString.init(string: strcheckinout)
        
  //  attributedText.setAttributes(<#T##attrs: [NSAttributedString.Key : Any]?##[NSAttributedString.Key : Any]?#>, range: <#T##NSRange#>)
        //setAttributes([NSAttributedString.Key.font:lblCustomerName.font,NSAttributedString.Key.foregroundColor:lblCustomerName.textColor], range: range1)
        
                //strcheckinout.range(of: T##StringProtocol)
        if(visit.nextActionTime?.count ?? 0 > 0){
            var strnt = ""
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: visit.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
               strnt = strn
            }
           self.lblNextActionDetail.text = String.init(format: "%@:%@", arguments: [NSLocalizedString("next_action", comment: ""),Utils.getDatestringWithGMT(gmtDateString: strnt, format: "dd-MM-yyyy , hh:mm a")])
        }else{
            self.lblNextActionDetail.text = ""
        }
      /*  self.lblNextActionDetail.text = (visit.nextActionTime?.count ?? 0 > 0) ?
            String.init(format: "%@:%@", arguments: [NSLocalizedString("next_action", comment: ""),Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: visit.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss"), format: "dd-MM-yyyy , hh:mm a")]) : ""*/
        let date:Date = (visit.nextActionTime?.count ?? 0 > 0) ? Utils.getDateFromStringWithFormat(gmtDateString: visit.nextActionTime ?? "") : Date()
        
        //getDateFromStringWithFormat(gmtDateString: visit.nextActionTime)
        if(Utils.getNSDateWithAppendingDay(day: 0, date1: Date(), format: "yyyy/MM/dd HH:mm:ss").compare(date) == .orderedAscending){
            self.lblNextActionDetail.textColor = Common().UIColorFromRGB(rgbValue: 0x999999)
        }else{
             self.lblNextActionDetail.textColor = Common().UIColorFromRGB(rgbValue: 0xE04445)
        }
        if(visit.visitStatusID == 3){
           
            self.vwParent.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xFFCE4B)
        }else{
            if(visit.nextActionID == 6){
                  self.vwParent.backgroundColor =  UIColor.init(red: 86/255.0, green: 119/255.0, blue: 252/255.0, alpha: 0.5)
                //UIColor.init(displayP3Red: 86/255.0, green: 119/255.0, blue: 252/255.0, alpha: 0.5)
            }else{
                  self.vwParent.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
            }
        }
    }
    
    func setUnplanVisitData(dict:UnplannedVisit){
        self.lblCustomerName.text = dict.tempCustomerObj?.CustomerName ?? ""
        let img = Utils.getImageFrom(interactionId:dict.nextActionID?.intValue ?? 0)
        self.imgInteractionType.image = img
        
        let visitNoTitle = NSAttributedString.init(string: "Visit No. ::", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
        //String(format:("#(%d)",visit.seriesPostfix))
        let visitNo = NSAttributedString.init(string:String.init(format: " %d", arguments: [dict.seriesPostfix?.intValue ?? ""]),  attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)])
        let strvisitno = NSMutableAttributedString.init(attributedString: visitNoTitle)
        strvisitno.append(visitNo)
        self.lblCheckinDetail.attributedText = strvisitno
        
        let assigneeNameTitle = NSAttributedString.init(string: "Assigned To ::", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
        //String(format:("#(%d)",visit.seriesPostfix))
        let assigneeName = NSAttributedString.init(string:String.init(format: " %@", arguments: [dict.reassigneeName ?? ""]),  attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)])
        let strassigneename = NSMutableAttributedString.init(attributedString: assigneeNameTitle)
        strassigneename.append(assigneeName)
        self.lblCreatedBy.attributedText = strassigneename
        
        let createdbyNameTitle = NSAttributedString.init(string: "Created By :: ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
       
        let createdby = NSAttributedString.init(string:dict.createdByName ?? "",  attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)])
        let strcreatedbyName = NSMutableAttributedString.init(attributedString: createdbyNameTitle)
        strcreatedbyName.append(createdby)
        self.lblNextActionDetail.attributedText = strcreatedbyName
        
        self.lblNextActionDt.textColor = UIColor.Appthemebluecolor
        var strct = ""
        if let strc = Utils.getDateBigFormatToDefaultFormat(date: dict.createdTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
         strct = strc
        }
        self.lblNextActionDt.text = Utils.getDatestringWithGMT(gmtDateString:strct , format: "d MMM")
        //bold Font
        self.lblNextActionDt.font =  UIFont.boldSystemFont(ofSize: 16)
        self.lblNextActionTm.font =  UIFont.boldSystemFont(ofSize: 16)
        
        self.lblNextActionTm.textColor = UIColor.Appthemebluecolor
        var strnt = ""
        if let strn = Utils.getDateBigFormatToDefaultFormat(date: dict.NextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            strnt = strn
        }
        self.lblNextActionTm.text = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "dd-MM-yyyy , hh:mm a")
    }
    
}
class JointVisitCell : UITableViewCell{
    
    @IBOutlet weak var vwparent: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblExecutiveName: UILabel!
    @IBOutlet weak var lblVisitDate: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwparent.layer.borderColor = UIColor.gray.cgColor
        self.selectionStyle = .none
        //vwParent.layer.cornerRadius =  10
        vwparent.layer.borderWidth = 2
    }
    
    func setData(visit:JointVisit){
        
        lblExecutiveName.text = visit.MemberName
        let startTimeTitle = NSAttributedString.init(string: "Start Time :: ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])//,NSAttributedString.Key.foregroundColor : UIColor.black.cgColor
        
        /*
         NSString *strTm=FormatString(@"Start Time: %@", [Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:obj.StartTime andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"hh:mm a"]);
         NSRange range1 = [strTm rangeOfString:@"Start Time:"];
         NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:strTm];
         [attributedText setAttributes:@{NSFontAttributeName:self.lblUserNm.font,NSForegroundColorAttributeName:self.lblUserNm.textColor}
                                 range:range1];
         self.lblStartTm.attributedText = attributedText;
         var strnt = ""
         if let strn = Utils.getDateBigFormatToDefaultFormat(date: visit.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            strnt = strn
         }
        self.lblNextActionDetail.text = String.init(format: "%@:%@", arguments: [NSLocalizedString("next_action", comment: ""),Utils.getDatestringWithGMT(gmtDateString: strnt, format: "dd-MM-yyyy , hh:mm a")])
         
         **/
        
        var strvi = ""
        if let strv = Utils.getDateBigFormatToDefaultFormat(date: visit.StartTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
            strvi = strv
        }
        let createdby = NSMutableAttributedString.init(string:Utils.getDatestringWithGMT(gmtDateString: strvi, format: " hh:mm a") ,  attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor])
        
        //
        let strcreatedbyName = NSMutableAttributedString.init(attributedString: startTimeTitle)
        strcreatedbyName.append(createdby)
        self.lblStartTime.attributedText = strcreatedbyName
        
        let endTimeTitle = NSAttributedString.init(string: "End Time :: ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])//,NSAttributedString.Key.foregroundColor : UIColor.black.cgColor
        var stret = ""
        if let stre = Utils.getDateBigFormatToDefaultFormat(date: visit.EndTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
           stret = stre
        }
       let endtime = NSAttributedString.init(string:Utils.getDatestringWithGMT(gmtDateString: stret, format: " hh:mm a") ,  attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 17),NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor])
        let strendTime = NSMutableAttributedString.init(attributedString: endTimeTitle)
        strendTime.append(endtime)
        self.lblEndTime.attributedText = strendTime
        var stredt = ""
        if let stre = Utils.getDateBigFormatToDefaultFormat(date: visit.EndTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
           stredt = stre
        }
        let createdDate = NSAttributedString.init(string:Utils.getDatestringWithGMT(gmtDateString: stredt, format: "d MMM"),attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])//
      
        self.lblVisitDate.textColor = UIColor.blue
        self.lblVisitDate.attributedText =  createdDate
       // print("statrt time from back end = \(visit.StartTime) and displaying = \(strcreatedbyName) ,  end time from back end = \(visit.EndTime) and displaying  = \(strendTime)")
//        self.lblVisitDate.text = "vfdvdfvfdvdfvfdvdfvfdvdf"//createdDate
        
    }
   
}
protocol VisitApprovalDelegate {
    func approveClicked(cell:VisitApprovalCell)
    func rejectClicked(cell:VisitApprovalCell)
}
class VisitApprovalCell:UITableViewCell{
    
    var delegate:VisitApprovalDelegate?
    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblNotificationDetail: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var stkAction: UIStackView!
    @IBOutlet weak var stkBtn: UIStackView!
    
    @IBOutlet weak var btnApprove: UIButton!
    
    
    @IBOutlet weak var btnReject: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    self.selectionStyle = UITableViewCell.SelectionStyle.none
    vwParent.layer.borderColor = UIColor.gray.cgColor
            vwParent.layer.cornerRadius =  5
 //lblNotificationDetail.setMultilineLabel(lbl:self.lblNotificationDetail)
    vwParent.layer.borderWidth = 2
    }
    
    
    @IBAction func btnApproveClicked(_ sender: UIButton) {
        self.delegate?.approveClicked(cell: self)
    }
    
    
    
    @IBAction func btnRejectCliecked(_ sender: UIButton) {
        self.delegate?.rejectClicked(cell: self)
    }
    
    func setData(notificationobj:Notificationmodel){
        //Notificationmodel
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.lblTitle.font = UIFont.boldSystemFont(ofSize: 19)
         self.lblDate.font = UIFont.systemFont(ofSize: 15)
         self.lblNotificationDetail.font = UIFont.systemFont(ofSize: 15)
        if(notificationobj.type == 126){
            self.lblTitle.text = "Visit Check-IN"
        }else if(notificationobj.type == 142){
             self.lblTitle.text = "Manual Visit Check-IN/OUT"
        }else if (notificationobj.type == 24 || notificationobj.type == 25) {
            self.lblTitle.text  = "Change Mobile No"
        }else if (notificationobj.type == 27) {
           self.lblTitle.text  = "Invitation Approval"
        }else if (notificationobj.type == 28 || notificationobj.type == 29) {
           self.lblTitle.text  = "Resignation"
        }else if (notificationobj.type == 30) {
           self.lblTitle.text  = "Invitation"
        }else if (notificationobj.type == 31) {
           self.lblTitle.text  = "Remove User"
        }else if (notificationobj.type == 32) {
           self.lblTitle.text  = "Company Deleted"
        }else if (notificationobj.type == 42) {
           self.lblTitle.text  = "Update Customer-Vendor Approval"
        }else if (notificationobj.type == 43 || notificationobj.type == 48) {
           self.lblTitle.text  = "Customer-Vendor"
        }else if (notificationobj.type == 44) {
           self.lblTitle.text  = "Update User Role"
        }else if (notificationobj.type == 47) {
           self.lblTitle.text  = "Company Profile Updated"
        }else if (notificationobj.type == 50) {
           self.lblTitle.text  = "Contact"
        }else if (notificationobj.type == 51) {
           self.lblTitle.text  = "Delete Contact"
        }else if (notificationobj.type == 53) {
           self.lblTitle.text  = "Update Member Role Alert"
        }else if (notificationobj.type == 56) {
           self.lblTitle.text  = "New Reporting Member"
        }else if (notificationobj.type == 57) {
           self.lblTitle.text  = "Change Registered Device Request"
        }else if (notificationobj.type == 58) {
           self.lblTitle.text  = "Change Registered Device"
        }else if (notificationobj.type == 61) {
        var username = ""
            if let fname = notificationobj.data.firstName{
                username.append(fname)
            }
            if let lname =  notificationobj.data.lastName{
                if(username.count > 0){
                    username.append(" ")
                }
                username.append(lname)
            }
            self.lblTitle.text = String.init(format:(" \(username)"))
        }else if (notificationobj.type == 62) {
            var username = ""
                if let fname = notificationobj.data.firstName{
                    username.append(fname)
                }
                if let lname =  notificationobj.data.lastName{
                    if(username.count > 0){
                        username.append(" ")
                    }
                    username.append(lname)
                }
            self.lblTitle.text = String.init(format:(" \(username)"))
        }else if (notificationobj.type == 68) {
           self.lblTitle.text  = "Document Assigned"
        }else if (notificationobj.type == 69) {
           self.lblTitle.text  = "Document Removed"
        }else if (notificationobj.type == 78) {
           self.lblTitle.text  = "Customer/Vendor Settings"
        }else if (notificationobj.type == 79) {
           self.lblTitle.text  = "Add Customer Approval"
        }else if (notificationobj.type == 80) {
           self.lblTitle.text  = "Add Customer"
        }else if (notificationobj.type == 83) {
           self.lblTitle.text  = "Customer Segment"
        }else if (notificationobj.type == 101) {
           self.lblTitle.text  = "Product Category"
        }else if (notificationobj.type == 102) {
           self.lblTitle.text  = "Product Sub-Category"
        }else if (notificationobj.type == 103) {
           self.lblTitle.text  = "Product"
        }else if (notificationobj.type == 104) {
           self.lblTitle.text  = "Purchase Product"
        }else if (notificationobj.type == 105) {
           self.lblTitle.text  = "BOM"
        }else if (notificationobj.type == 106) {
           self.lblTitle.text  = "Cold Calling"
        }else if (notificationobj.type == 107) {
           self.lblTitle.text  = "Lead"
        }else if (notificationobj.type == 108) {
           self.lblTitle.text  = "Proposal"
        }else if (notificationobj.type == 109) {
           self.lblTitle.text  = "Sales Order"
        }else if (notificationobj.type == 110) {
           self.lblTitle.text  = "Purchase Order";
        }else if (notificationobj.type == 111) {
           self.lblTitle.text  = "Invoice"
        }else if (notificationobj.type == 112) {
           self.lblTitle.text  = "Key Customer"
        }else if (notificationobj.type == 113) {
           self.lblTitle.text  = "Sales Target"
        }else if (notificationobj.type == 114) {
            if (notificationobj.transactionID.contains("SCF")) {
               self.lblTitle.text  = "Configuration Setting"
            }else if (notificationobj.transactionID.contains("SAS")){
               self.lblTitle.text  = "Area Setup Setting"
            }
        }else if (notificationobj.type == 115) {
           self.lblTitle.text  = "Permission Setting"
        }else if (notificationobj.type == 116) {
           self.lblTitle.text  = "Taxation Setting"
        }else if (notificationobj.type == 117) {
           self.lblTitle.text  = "Template Setting"
        }else if (notificationobj.type == 118) {
           self.lblTitle.text  = "General Note"
        }else if (notificationobj.type == 119) {
           self.lblTitle.text  = "Meeting"
        }else if (notificationobj.type == 120) {
           self.lblTitle.text  = "Sales Order Cancellation"
        }else if (notificationobj.type == 121) {
           self.lblTitle.text  = "Purchase Order Cancellation"
        }else if (notificationobj.type == 122) {
           self.lblTitle.text  = "Purchase Order Closed"
        }else if (notificationobj.type == 123) {
           self.lblTitle.text  = "Sales Order Closed"
        }else if (notificationobj.type == 127) {
            if (notificationobj.transactionID.contains("ILS") || notificationobj.transactionID.contains("ULS") || notificationobj.transactionID.contains("DLS")) {
               self.lblTitle.text  = "Lead Source"
            }else if (notificationobj.transactionID.contains("ILO") || notificationobj.transactionID.contains("ULO") || notificationobj.transactionID.contains("DLO")){
               self.lblTitle.text  = "Lead Outcome"
            }else if (notificationobj.transactionID.contains("IVO") || notificationobj.transactionID.contains("UVO") || notificationobj.transactionID.contains("DVO")){
               self.lblTitle.text  = "Visit Outcome"
            }else if(notificationobj.transactionID.contains("IAT") || notificationobj.transactionID.contains("UAT") || notificationobj.transactionID.contains("DAT")){
                self.lblTitle.text  = "Activity Type"
            }else{
                print(notificationobj.transactionID)
            }
        }else if (notificationobj.type == 124) {
           self.lblTitle.text  = "Visit"
        }else if (notificationobj.type == 125) {
           self.lblTitle.text  = "Visit Closed"
        }else if (notificationobj.type == 126) {
           self.lblTitle.text  = "Visit Check-IN"
        }else if (notificationobj.type == 128) {
           self.lblTitle.text  = "Lead Check-IN"
        }else if (notificationobj.type == 129) {
           self.lblTitle.text  = "Users not checked in visit today"
        }else if (notificationobj.type == 130) {
           self.lblTitle.text  = "Daily Sales Plan"
        }else if (notificationobj.type == 131) {
           self.lblTitle.text  = "Company Settings"
        }else if (notificationobj.type == 132) {
           self.lblTitle.text  = "Visit Closed";
        }else if (notificationobj.type == 133) {
           self.lblTitle.text  = "Apply leave"
        }else if (notificationobj.type == 134) {
           self.lblTitle.text  = "Withdraw leave"
        }else if (notificationobj.type == 135) {
           self.lblTitle.text  = "Update attendance request"
        }else if (notificationobj.type == 136) {
           self.lblTitle.text  = "Attendance approve reject"
        }else if (notificationobj.type == 137) {
           self.lblTitle.text  = "Attendance request"
        }else if (notificationobj.type == 138) {
           self.lblTitle.text  = "Leave approve reject"
        }else if (notificationobj.type == 139) {
           self.lblTitle.text  = "Manual attendance request"
        }else if (notificationobj.type == 142) {
           self.lblTitle.text  = "Manual Visit Check-IN/OUT"
        }else if (notificationobj.type == 143) {
           self.lblTitle.text  = "Manual Lead Check-IN/OUT"
        }else if (notificationobj.type == 153) {
           self.lblTitle.text  = "Manual Visit"
        }else{
           self.lblTitle.text  = "Notification"
        }
        
        self.lblNotificationDetail.text = notificationobj.message
        self.lblDate.textAlignment = .right
        self.lblDate.text = Utils.getDatestringWithGMT(gmtDateString: notificationobj.lastModified, format: "dd-MM-yyyy hh:mm a")
        if(notificationobj.status == 1){
            self.vwParent.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xF3F3F3)
            self.lblTitle.textColor =  Common().UIColorFromRGB(rgbValue:0x4D4D4D)
            self.lblNotificationDetail.textColor =  Common().UIColorFromRGB(rgbValue:0x4D4D4D)
           self.lblDate.textColor =  Common().UIColorFromRGB(rgbValue:0x747474)
        }
        else if(notificationobj.status == 2){
            self.vwParent.backgroundColor = Common().UIColorFromRGB(rgbValue: 0x307191)
            self.lblTitle.textColor =  .white
            self.lblNotificationDetail.textColor =  .white
            self.lblDate.textColor =  Common().UIColorFromRGB(rgbValue:0xf5f5f5)
        }else if(notificationobj.status == 3){
            self.vwParent.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xDC4B3A)
            self.lblTitle.textColor =  .white
            self.lblNotificationDetail.textColor =  .white
            self.lblDate.textColor =  Common().UIColorFromRGB(rgbValue:0xf5f5f5)
        }
        else if(notificationobj.status == 4){
            self.vwParent.backgroundColor = Common().UIColorFromRGB(rgbValue: 0x999999)
            self.lblTitle.textColor =  .white
            self.lblNotificationDetail.textColor =  .white
            self.lblDate.textColor =  Common().UIColorFromRGB(rgbValue:0xf5f5f5)
        }else{
            self.vwParent.backgroundColor = UIColor.lightBackgroundColor// Common().UIColorFromRGB(rgbValue: 0xFFCE4B)
            self.lblTitle.textColor =  Common().UIColorFromRGB(rgbValue:0x4D4D4D)
            self.lblNotificationDetail.textColor =  Common().UIColorFromRGB(rgbValue:0x4D4D4D)
            self.lblDate.textColor =  Common().UIColorFromRGB(rgbValue:0x747474)
        }
        /*
         UIView *view = (UIView *) [[cell.contentView subviews] objectAtIndex:0];
         if (dict.status == 1){
             [view setBackgroundColor:UIColorFromRGB(0xF3F3F3)];
             [lblNotfTitle setTextColor:UIColorFromRGB(0x4D4D4D)];
             [lblNotfDesc setTextColor:UIColorFromRGB(0x4D4D4D)];
             [lblNotfDate setTextColor:UIColorFromRGB(0x747474)];
         }else if (dict.status == 2){
             [view setBackgroundColor:UIColorFromRGB(0x307191)];
             [lblNotfTitle setTextColor:whiteColor];
             [lblNotfDesc setTextColor:whiteColor];
             [lblNotfDate setTextColor:UIColorFromRGB(0xf5f5f5)];
         }else if (dict.status == 3){
             [view setBackgroundColor:UIColorFromRGB(0xDC4B3A)];
             [lblNotfTitle setTextColor:whiteColor];
             [lblNotfDesc setTextColor:whiteColor];
             [lblNotfDate setTextColor:UIColorFromRGB(0xf5f5f5)];
         }else if (dict.status == 4){
             [view setBackgroundColor:UIColorFromRGB(0x999999)];
             [lblNotfTitle setTextColor:whiteColor];
             [lblNotfDesc setTextColor:whiteColor];
             [lblNotfDate setTextColor:UIColorFromRGB(0xf5f5f5)];
         }else {
             [view setBackgroundColor:UIColorFromRGB(0xFFCE4B)];
             [lblNotfTitle setTextColor:UIColorFromRGB(0x4D4D4D)];
             [lblNotfDesc setTextColor:UIColorFromRGB(0x4D4D4D)];
             [lblNotfDate setTextColor:UIColorFromRGB(0x747474)];
         }
         
         **/
    }
    
//    func setMissedData(mvisit:){
//        
//    }
    
    
}

