//
//  LeaveDetailController.swift
//  SuperSales
//
//  Created by Apple on 20/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage


class LeaveDetailController: BaseViewController {
  
    @IBOutlet weak var lblCertiName: UILabel!
    @IBOutlet weak var stackMedicalCerti: UIStackView!
    @IBOutlet weak var viewCenterConstraint: NSLayoutConstraint!
    var dicOfLeave:[String:Any]!
    var leaveobj:LeaveStatus?
    var fromNotification:Bool!
    var arrdate:[Date]!
    var arrOfselectedDate:[Date]! = [Date]()
    var arrstrdate:[String]! = [String]()
    @IBOutlet weak var cnstimgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblHighLighter: UILabel!
    @IBOutlet weak var lblLeaveHFType: UILabel!
    @IBOutlet weak var cnstTblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblDateValue: UITableView!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLeaveType: UILabel!
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblDateValue: UILabel!
    @IBOutlet weak var btnReject: UIButton!
    
    
    @IBOutlet weak var tvReason: KTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
       
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Method
    func setUI(){
        self.btnApprove.setTitle("Accept", for: UIControl.State.normal)
        tvReason.setFlexibleHeight()
        self.btnReject.setTitle("Reject", for: UIControl.State.normal)
        self.btnReject.backgroundColor = UIColor.red
        if(fromNotification){
            lblLeaveHFType.isHidden = false
            lblHighLighter.isHidden = false
            
            lblLeaveHFType.text = String.init(format:"\(self.dicOfLeave["LeaveDay"] as? String ?? "") day")
            viewCenterConstraint.isActive = false
            self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
            self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
            self.title = "Leave Details"
            self.btnClose.isHidden = true
            self.cnstimgHeight.constant = 0
            
            self.view.backgroundColor =  UIColor.white
            self.view.isOpaque = true
            let dicuser = dicOfLeave["User"] as? [String:Any] ?? [String:Any]()
            var companyuser = CompanyUsers()
            if let user =   CompanyUsers().getUser(userId: NSNumber.init(value:dicuser["id"] as? Int ?? 0)){
                companyuser = user
                
                var username = ""
                if let fname = companyuser.firstName  as? String{
                    username.append(fname)
                }
                if let lname = companyuser.lastName as? String{
                    if(username.count > 0){
                        username.append(" ")
                    }
                    username.append(lname)
                }
                
                lblUserName.text = username
            }
            //            imgUser.image = UIImage.init(named: "icon_user_blue")
            //            imgUser.makeImgRound()
            //            if let url = companyuser.picture as? String{
            //            imgUser.sd_setImage(with:  URL.init(string: (url.replacingOccurrences(of: " ", with: "%20").trimString) as? String ?? "")  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
            //
            //                if(err == nil){
            //                    self.imgUser.image = img
            ////                    self.statusImage1 = img ?? UIImage()
            ////                    self.statusImg1 = IDMPhoto.init(url: urlofimage)
            ////                    let imggesture = UITapGestureRecognizer.init(target: self, action: #selector(self.img1Tapped))
            ////                    self.statusimg1.isUserInteractionEnabled = true
            ////                    self.statusimg1.addGestureRecognizer(imggesture)
            //                }else{
            //                    self.imgUser.image = nil
            //                    self.imgUser.image = UIImage.init(named: "icon_user_blue")
            //                }
            //            }
            //            }
            lblLeaveType.text = dicOfLeave["Type"] as? String ?? ""
            self.dateFormatter.dateFormat = "dd MMM, yyyy"
            arrdate = dicOfLeave["Dates"] as? [Date] ?? [Date]()
            if(arrdate.count == 0){
                arrstrdate = dicOfLeave["Dates"] as? [String] ?? [String]()
                if(arrstrdate.count > 0){
                    
                    for strdate in arrstrdate
                    {
                        self.dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
                        let date = self.dateFormatter.date(from: strdate) ?? Date()
                        arrdate.append(date)
                    }
                }
            }
            if(arrdate.count > 0 && arrdate.count == 1){
                let leaveday = dicOfLeave["LeaveDay"] as? String ?? String()
                if let firstdate = arrdate.first as? Date/* ?? Date()*/{
                    self.dateFormatter.dateFormat = "yyyy/MM/dd"
                    lblDateValue.text = String.init(format: "\(self.dateFormatter.string(from: firstdate))")
                }
                tblDateValue.isHidden = true
                lblDateValue.isHidden = false
            }else if(arrdate.count > 1){
                tblDateValue.isHidden = false
                lblDateValue.isHidden = true
                //                DispatchQueue.main.async {
                //                    self.tblDateValue.reloadData()
                //                    self.cnstTblHeight.constant = self.tblDateValue.contentSize.height
                //                }
            }else{
                tblDateValue.isHidden = true
                lblDateValue.isHidden = true
            }
            //  lblDateValue.text = String.init(format: "\(self.dateFormatter.string(from: leaveobj.date)) (\(leaveobj.leaveDay ?? "") day )")
            tvReason.text = dicOfLeave["Reason"] as? String ?? ""
            tblDateValue.delegate = self
            tblDateValue.dataSource = self
            tblDateValue.reloadData()
            tblDateValue.setCommonFeature()
            tblDateValue.isScrollEnabled = false
            tblDateValue.separatorColor = UIColor.lightGray
            cnstTblHeight.constant = tblDateValue.contentSize.height
            
        }else{
            lblLeaveHFType.isHidden = true
            lblHighLighter.isHidden = false
            tblDateValue.isHidden = true
            lblDateValue.isHidden = false
            self.cnstimgHeight.constant = 100
            viewCenterConstraint.isActive = true
            self.view.backgroundColor =  UIColor.clear
            self.view.isOpaque = false
            
            if let leaveobj =  leaveobj as? LeaveStatus{
                var username = ""
                if let fname = leaveobj.leavestatususer.firstName{
                    username.append(fname)
                }
                if let lname = leaveobj.leavestatususer.lastName{
                    if(username.count > 0){
                        username.append(" ")
                    }
                    username.append(lname)
                }
                if leaveobj.medicalCerti != nil || leaveobj.medicalCerti != "" {
                    self.stackMedicalCerti.isHidden = false
                    let attributes: [NSAttributedString.Key: Any] = [
                           .font: UIFont.boldSystemFont(ofSize: 16), // Bold font
                           .underlineStyle: NSUnderlineStyle.single.rawValue // Underline style
                       ]
                    let attributedString = NSAttributedString(string: leaveobj.medicalCerti ?? "", attributes: attributes)

                    self.lblCertiName.attributedText = attributedString
                }else{
                    self.stackMedicalCerti.isHidden = false
                }
                lblUserName.text = username
                lblLeaveType.text = leaveobj.status
                self.dateFormatter.dateFormat = "dd MMM, yyyy"
                lblDateValue.text = String.init(format: "\(self.dateFormatter.string(from: leaveobj.date)) (\(leaveobj.leaveDay ?? "") day )")
                tvReason.text = leaveobj.reason
                tvReason.isUserInteractionEnabled = false
                
                if(self.activeuser?.role?.id == 5 || self.activeuser?.role?.id == 6 || (self.activeuser?.role?.id == 7 || self.activeuser?.role?.id == 8 ) && (self.activeuser?.userID != NSNumber.init(value:leaveobj.leavestatususer.entity_id))){
                    if(leaveobj.status == ConstantURL.PendingLeave){
                        if(self.activeuser?.roleId == 7){
                            if(self.activesetting.managerApproveLeave == 1){
                                self.btnApprove.isHidden = false
                                self.btnReject.isHidden = false
                            }else{
                                self.btnApprove.isHidden = true
                                self.btnReject.isHidden = true
                            }
                        }
                        if(self.activeuser?.roleId == 8){
                            if(self.activesetting.salesExecutiveApproveLeave == 1){
                                self.btnApprove.isHidden = false
                                self.btnReject.isHidden = false
                            }else{
                                self.btnApprove.isHidden = true
                                self.btnReject.isHidden = true
                            }
                        }
                    }else{
                        self.btnApprove.isHidden = true
                        self.btnReject.isHidden = true
                    }
                    self.btnApprove.setTitle("Approve", for: UIControl.State.normal)
                }else{
                    self.btnApprove.setTitle("Withdraw", for: UIControl.State.normal)
                    self.btnReject.isHidden = true
                    
                }
                if(leaveobj.status == ConstantURL.Approved || leaveobj.status == ConstantURL.WithdraenLeave || leaveobj.status == ConstantURL.CancelledLeave){
                    btnReject.isHidden = true
                    if(leaveobj.status == ConstantURL.Approved  && self.activeuser?.userID?.int32Value == leaveobj.leavestatususer.entity_id){
                        self.btnApprove.setTitle("Withdraw", for: UIControl.State.normal)
                        btnApprove.isHidden = false
                    }else{
                        btnApprove.isHidden = true
                    }
                }
                
                if(self.activeuser?.roleId?.intValue ?? 0 > 6){
                    if((self.activeuser?.roleId == 7 && (self.activeuser?.userID?.int32Value != leaveobj.leavestatususer.entity_id)) || (self.activeuser?.roleId == 8 && (self.activeuser?.userID?.int32Value != leaveobj.leavestatususer.entity_id))){
                        
                    }else{
                        if(leaveobj.status == ConstantURL.Approved){
                            btnReject.isHidden = false
                        }else if(leaveobj.status == ConstantURL.CancelledLeave || leaveobj.status == ConstantURL.WithdraenLeave){
                            btnReject.isHidden = true
                            btnApprove.isHidden = true
                        }
                    }
                }
                imgUser.image = UIImage.init(named: "icon_user_blue")
                imgUser.makeImgRound()
                imgUser.sd_setImage(with:  URL.init(string: (leaveobj.leavestatususer.picture?.replacingOccurrences(of: " ", with: "%20").trimString) as? String ?? "")  , placeholderImage: UIImage.init(named: "icon_placeholder"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                    
                    if(err == nil){
                        self.imgUser.image = img
                        //                    self.statusImage1 = img ?? UIImage()
                        //                    self.statusImg1 = IDMPhoto.init(url: urlofimage)
                        //                    let imggesture = UITapGestureRecognizer.init(target: self, action: #selector(self.img1Tapped))
                        //                    self.statusimg1.isUserInteractionEnabled = true
                        //                    self.statusimg1.addGestureRecognizer(imggesture)
                    }else{
                        self.imgUser.image = nil
                        self.imgUser.image = UIImage.init(named: "icon_user_blue")
                    }
                }
            }
            //self.dateFormatter.string(from: )
        }
    }
    
    
    @objc func btnClicked(sender:UIButton){
        print(sender.isSelected)
        let selectedDate = arrdate[sender.tag]
        if(arrOfselectedDate.contains(selectedDate)){
            arrOfselectedDate =    arrOfselectedDate.filter{
                $0 != selectedDate
            }
        }else{
            arrOfselectedDate.append(selectedDate)
        }
        print("\(sender.isSelected), for record = \(sender.tag) , \(arrOfselectedDate)")
//        let selectedDate = arrdate[sender.tag]
//        if(sender.isSelected){
//
//
//        }else{
//            if(arrOfselectedDate.contains(selectedDate)){
//                arrOfselectedDate =     arrOfselectedDate.filter{
//                    $0 != selectedDate
//                }
//            }
//        }
        tblDateValue.reloadData()
    }
    //MARK: - API Call
    
    func approveleave(obj:LeaveStatus?,status:Bool){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        if(fromNotification){
            if let dicOfUser = self.dicOfLeave["User"] as? [String:Any]{
                param["MemberID"] = dicOfUser["id"] as? Int
                param["Approve"] = NSNumber.init(value: status)
                let arrOFLeave = self.dicOfLeave["Dates"] as? [String]
                //   let leavedate = Utils.getDateUTCWithAppendingDay(day: 0, date: arrOFLeave?.first ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: false)
                let leavedate = Utils.getDateBigFormatToDefaultFormat(date: arrOFLeave?.first ?? "", format:  "yyyy/MM/dd HH:mm:ss")
                if(arrstrdate.count > 1){
                    var arrstrDate = [String]()
                    for date in arrOfselectedDate{
                        let leavedate = Utils.getDate(date: ( date as NSDate ?? Date() as NSDate), withFormat: "yyyy/MM/dd HH:mm:ss")
                        //Utils.getDateBigFormatToDefaultFormat(date: date ?? "", format: "yyyy/MM/dd HH:mm:ss")
                        arrstrDate.append(leavedate)
                    }
                    param["LeaveDates"] =  Common.json(from:arrstrDate ?? [String]())
                }else{
                    let arrOfDate = [leavedate]
                    param["LeaveDates"] =  Common.json(from: arrOfDate)
                }
                param["TransactionID"] = self.dicOfLeave["TransactionId"] as? String
            }
        }else{
            param["MemberID"] = obj?.leavestatususer.entity_id
            param["Approve"] = NSNumber.init(value: status)
            let leavedate = Utils.getDateUTCWithAppendingDay(day: 0, date: obj?.date ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)
            let arrOfDate = [leavedate]
            param["LeaveDates"] =  Common.json(from: arrOfDate)
            param["TransactionID"] = obj?.transactionID
        }
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveLeaves, method: Apicallmethod.post){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                self.btnReject.isHidden = true
                self.btnApprove.isHidden = true
                NotificationCenter.default.post(name: NSNotification.Name(ConstantURL.BALANCE_UPDATE_NOTIFICATION), object: nil, userInfo: nil)
                let okaction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
                    if(self.fromNotification){
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.dismiss(animated: true, completion: nil)
                        Utils.removeShadow(view: self.view)
                    }
                }
                Common.showalertWithAction(msg: message, arrAction: [okaction], view: self)
                //  self.loadData()
            }else{
                Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view:self.view)
            }
        }
    }
    
    
    //MARK: - IBAction
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            Utils.removeShadow(view: self.view)
        })
    }
    
    
    
    @IBAction func btnApproveClicked(_ sender: UIButton) {
      //  if let leaveobj =  leaveobj as? LeaveStatus{
        if(self.activeuser?.role?.id == 5 || self.activeuser?.role?.id == 6 || (self.activeuser?.role?.id == 7 || self.activeuser?.role?.id == 8 ) && (self.activeuser?.userID != NSNumber.init(value:leaveobj?.leavestatususer.entity_id ?? 0))){
            let yesAction =  UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
                self.approveleave(obj: self.leaveobj, status: true)
            }
            let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
            Common.showalertWithAction(msg: "Are you sure you want to Approve this leave?", arrAction: [yesAction,noAction], view: self)
            }else{
                let yesAction =  UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
                    SVProgressHUD.show()
                    var param = Common.returndefaultparameter()
                    param["Status"] = self.leaveobj?.status
                    let leavedate = Utils.getDateUTCWithAppendingDay(day: 0, date: self.leaveobj?.date ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)
                    if(self.arrstrdate.count > 0){
                        param["LeaveDates"] =  Common.json(from:self.arrOfselectedDate ?? [Date]())
                    }else{
                    let arrOfDate = [leavedate]
                    
                    param["LeaveDates"] =  Common.json(from: arrOfDate)
                    }
                    self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlWithDrawLeave, method: Apicallmethod.post){
                    (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
               
                    SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                     
                        self.btnReject.isHidden = true
                        self.btnApprove.isHidden = true
                        NotificationCenter.default.post(name: NSNotification.Name(ConstantURL.BALANCE_UPDATE_NOTIFICATION), object: nil, userInfo: nil)
                        let okaction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
                            self.dismiss(animated: true, completion: nil)
                        }
                        Common.showalertWithAction(msg: message, arrAction: [okaction], view: self)
                      //  self.loadData()
                    }else{
                        Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view:self.view)
                    }
                }
                }
                let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
                Common.showalertWithAction(msg: "Are you sure you want to withdraw this leave?", arrAction: [yesAction,noAction], view: self)
               
            }
        //}
    }
    
    
    @IBAction func btnRejectClicked(_ sender: UIButton) {
       // if let leaveobj =  leaveobj as? LeaveStatus{
            let yesAction =  UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
                self.approveleave(obj: self.leaveobj, status: false)
            }
            let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
            Common.showalertWithAction(msg: "Are you sure you want to Reject this leave?", arrAction: [yesAction,noAction], view: self)
       
       // }
    }
    
    @IBAction func btnViewCertiTapped(_ sender: UIButton) {
        self.openURLInBrowser(urlString: self.leaveobj?.medicalCerti ?? "")
    }
    

}
extension LeaveDetailController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrdate.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customerselectioncell", for: indexPath) as? CustomerSelectionCell{
            let selectedDate =  arrdate[indexPath.row]
            cell.selectionStyle = .none
            cell.btnMandatorySwitch.isHidden = true
            cell.btnCustomerSelection.isHidden = false
            cell.lblContactNo.isHidden = true
            self.dateFormatter.dateFormat = "dd MMM, yyyyy"
            cell.lblCustomerName.text = self.dateFormatter.string(from: selectedDate)
            if(arrOfselectedDate?.contains(selectedDate) ?? false ==  true){
                
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                }
            cell.btnCustomerSelection.tag = indexPath.row
            cell.btnCustomerSelection.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
            return cell
        }else{
        return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDate = arrdate[indexPath.row]
        if(arrOfselectedDate.contains(selectedDate)){
            arrOfselectedDate =    arrOfselectedDate.filter{
                $0 != selectedDate
            }
        }else{
            arrOfselectedDate.append(selectedDate)
        }
       

        tblDateValue.reloadData()
    }
    
    func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
            return 40
        }
    
        func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
}
