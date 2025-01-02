//
//  NotificationApproval.swift
//  SuperSales
//
//  Created by mac on 21/11/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class NotificationApproval: BaseViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tblnotificationApprovalList: UITableView!
    var statusId = 0
    var currentpageno = 1
    var arrOfNotifications:[Notificationmodel]! = [Notificationmodel]()
    var strRejectionMsg = ""
    var dictRejection:Notificationmodel!
    var expenseId = NSNumber.init(value: 0)
    var selectedCell:VisitApprovalCell!
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        DispatchQueue.main.async {
        super.viewDidLoad()
        self.setUI()
        }

        // Do any additional setup after loading the view.
    }
    

    //MARK: - method
    func setUI(){
        tblnotificationApprovalList.estimatedRowHeight = 300.0
        tblnotificationApprovalList.rowHeight = UITableView.automaticDimension
        tblnotificationApprovalList.tableFooterView = UIView()
        tblnotificationApprovalList.separatorColor = UIColor.clear
        //selected_date = [NSDate date];
        tblnotificationApprovalList.delegate = self
        tblnotificationApprovalList.dataSource = self
        self.tblnotificationApprovalList.addPullToRefresh { [self] in
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            self.callWebService()
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.callWebService()
    }
    @objc private func onTap(sender: UITapGestureRecognizer) {
        if let selectedrecord = sender.view?.tag as? Int{
        let selectedobj  = arrOfNotifications[selectedrecord]
        //expense list
        let selectedexpense = self.arrOfNotifications[selectedrecord]
        if  let  cell = tblnotificationApprovalList.cellForRow(at: IndexPath.init(row: selectedrecord, section: 0)) as? VisitApprovalCell{
            self.selectedCell  = cell
            if(selectedobj.status ==  1 && ((selectedobj.type == 61) || (selectedobj.type == 62) )){
            self.getExpenseDetail(transactionId: selectedobj.transactionID, action: "Redirection")
        }
        }
        }
    }
    func callWebService(){
        /*
         RestAPIManager.httpRequest("getLatestSalesOrdersOfCustomer", .get, parameters: param, isTeamWorkUrl: true, isFull: true) { [self] response, success, error in
             SVProgressHUD.dismiss()
             if let res = response as? [String: Any], let aDataInfo = res["data"] as? [[String: Any]]{
                 if(aDataInfo.count > 0){
         24,25,27,28,29,30,31,32,42,43,44,47,48,50,51,52,53,57,58,61,62,78,79,80,81,83,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,152
         **/
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        
        var param = Common.returndefaultparameter()
        param["LastSynchTime"] = ""
        param["PageSize"] = 20
        param["PageNumber"] = currentpageno
        param["Type"] = "24,25,27,28,29,30,31,32,42,43,44,47,48,50,51,52,53,57,58,61,62,78,79,80,81,83,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,152,180"
        RestAPIManager.httpRequest("getSuperSalesApprovalNotifications", .get, parameters: param, isTeamWorkUrl: false, isFull: true){ [self] response, success, error in
            SVProgressHUD.dismiss()
            self.tblnotificationApprovalList.pullToRefreshView.stopAnimating()
            if success {
                SVProgressHUD.dismiss()
             print("Approval list = \(response) ")
                if let res = response as? [String: Any], let aDataInfo = res["data"] as? [[String: Any]]{
                    
                    print("count of approval list = \(aDataInfo.count)")
               // let arrNotification:[[String:Any]] = arr as? [[String:Any]] ?? [[String:Any]]()
                if(self.currentpageno == 1){
                    self.arrOfNotifications = [Notificationmodel]()
                     self.arrOfNotifications.removeAll()
                    
                }
                    for dic in aDataInfo{
                        let notificationobj = Notificationmodel().initwithdic(dict:dic)
                        self.arrOfNotifications.append(notificationobj)
                    }
                }
                self.tblnotificationApprovalList.reloadData()
            }else if let result = response as? [String: Any]{
                SVProgressHUD.dismiss()
                if result["status"] as? String == "Error"{
                    Utils.toastmsg(message:result["message"] as? String ?? "",view: self.view)
                   
                }else if result["status"] as? String == "Invalid Token"{
                    Utils.toastmsg(message:(result["message"] as? String ?? ""),view: self.view)
//                    AppDelegate.shared.logout
                }else{
                    Utils.toastmsg(message:(error?.localizedDescription as? String ?? ""),view: self.view)
                }
            }else{
                SVProgressHUD.dismiss()
                Utils.toastmsg(message:(error?.localizedDescription as? String ?? ""),view: self.view)
            }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

    func showDialog(noti:Notificationmodel){
        var arrOfAction = [UIAlertAction]()
      //  arrOfAction.append(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))
        arrOfAction.append(UIAlertAction.init(title: "Approve", style: UIAlertAction.Style.default, handler: { (action) in
            self.showApprovalDialog(status: true, dic: noti)
        }))
        arrOfAction.append(UIAlertAction.init(title: "Reject", style: UIAlertAction.Style.default, handler: { (action) in
           // self.approveChangeMobile(status: true, dic: noti)
            self.strRejectionMsg = ""
            self.dictRejection = noti
            let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)

            //2. Add the text field. You can configure it however you need.
            
            alert.addTextField { (textField) in
                textField.placeholder = "Enter reason to reject"
            }

            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                print("Text field: \(textField?.text)")
                self.strRejectionMsg = textField?.text ?? ""
                self.showApprovalDialog(status: false, dic: noti)
            }))

            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            
        }))
        if(noti.type == 142){
//            arrOfAction.append(UIAlertAction.init(title: NSLocalizedString("VIEW ON MAP", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
//                if let mapobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
//                    mapobj.lattitude = noti.data.userLattitude
//                    mapobj.longitude = noti.data.userLongitude
//                    self.navigationController?.pushViewController(mapobj, animated: true)
//                }
//            }))
        }
        if(noti.type == 108 || noti.type == 109){
            arrOfAction.append(UIAlertAction.init(title: NSLocalizedString("VIEW", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
               //proposal or order
            }))
        }
        Common.showalertWithAction(msg: noti.message, arrAction: arrOfAction, view: self)
       // Common.showalert(title: "Approval", msg: noti.message, yesAction: UIAlertAction.init(), noAction: UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil), view: self)
    
    }
    func showDialogCommon(noti:Notificationmodel){
        var arrOfAction = [UIAlertAction]()
        arrOfAction.append(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))
        arrOfAction.append(UIAlertAction.init(title: "Approve", style: UIAlertAction.Style.default, handler: { (action) in
            self.approveChangeMobile(status1: true, dic: noti)
        }))
        arrOfAction.append(UIAlertAction.init(title: "Reject", style: UIAlertAction.Style.default, handler: { (action) in
            self.approveChangeMobile(status1: false, dic: noti)
        }))
        Common.showalertWithAction(msg: noti.message, arrAction: arrOfAction, view: self)
    }
    
    
    func approvalForResignation(dic:Notificationmodel,withapproval:Bool){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        
        var param = Common.returndefaultparameter()
        param["OwnerID"] = self.activeuser?.company?.ownerID
        param["TransactionID"] = dic.data.transactionID
        param["MemberID"] = dic.data.iD
        param["Accept"] = withapproval
        
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAcceptRejectResignation, method: Apicallmethod.post){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
//                let arrdic  = arr as? [String:Any] ?? [String:Any]()
//                let statusid = arrdic["StatusID"] as? Int ?? 0
                if(withapproval){
                
                    dic.status =   2
                }else{
                   
                    dic.status =  3
                }
             
                
                if let i = self.arrOfNotifications.firstIndex(of: dic) {
                    self.arrOfNotifications[i] = dic
                }
                self.tblnotificationApprovalList.reloadData()
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:(message),view: self.view)
                }
            }
            else{
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:(message),view: self.view)
                }
                Utils.toastmsg(message:(error.localizedDescription),view: self.view)
            }
        }
    }
    func approveChangeMobile(status1:Bool,dic:Notificationmodel){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        
        var param = Common.returndefaultparameter()
        param["MobileNo"] = dic.data.newmobileNo
        param["TransactionID"] = dic.data.transactionID
        param["MemberID"] = dic.data.iD
        param["Approved"] = status1
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveChangeMobile, method: Apicallmethod.post){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
//                let arrdic  = arr as? [String:Any] ?? [String:Any]()
//                let statusid = arrdic["StatusID"] as? Int ?? 0
                if(status1){
                    dic.data.statusID =  2
                    dic.status =   2
                }else{
                    dic.data.statusID =  3
                    dic.status =  3
                }
             
                
                if let i = self.arrOfNotifications.firstIndex(of: dic) {
                    self.arrOfNotifications[i] = dic
                }
                self.tblnotificationApprovalList.reloadData()
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:(message),view: self.view)
                }
            }
            else{
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:(message),view: self.view)
                }
                Utils.toastmsg(message:(error.localizedDescription),view: self.view)
            }
        }
    }
    
    
    func verifyAddressLatLong(dic:[String:Any]){
        var param1 = Common.returndefaultparameter()
        param1["Lattitude"] = dic["Lattitude"] as? Double ?? 0.0
        param1["Longitude"] = dic["Longitude"] as? Double ?? 0.0
        param1["CustomerID"] = dic["CustomerID"] as? Int64 ?? 0
        param1["AddressID"] = dic["AddressMasterID"] as? Int64 ?? 0
//        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
//            param1["CustomerID"] = planobj.customerID
//            param1["AddressID"] = planobj.addressMasterID
//        }else{
//            param1["CustomerID"] = unplanobj.tempCustomerID
//            param1["AddressID"] = unplanobj.addressMasterID
//        }
        self.apihelper.getdeletejoinvisit(param: param1, strurl: ConstantURL.kWSUrlVerifyAddressLatLong, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:(message),view: self.view)
                }
                Utils.verifyAddressDetail(custID: NSNumber.init(value: dic["CustomerID"] as? Int64 ?? 0), addID: NSNumber.init(value: dic["AddressMasterID"] as? Int64 ?? 0), lat: NSNumber.init(value: dic["Lattitude"] as? Double ?? 0.0), long: NSNumber.init(value: dic["Longitude"] as? Double ?? 0.0))
            }else{
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:(message),view: self.view)
                }
                Utils.toastmsg(message:(error.localizedDescription),view: self.view)
            }
        }
    }
    
    
    func changetheStatus(status:Bool,attendanceCheckinDetail:Notificationmodel){
       /* SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["TransactionID"] = attendanceCheckinDetail.transactionID
        param["AttendanceID"] = attendanceCheckinDetail.data.attendanceID
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetTravelCheckInCheckOutDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
           
            if(status.lowercased() == Constant.SucessResponseFromServer){
              
            }else{
                
            }
        }*/
//        if(self.attendanceCheckinDetail?.attendanceuser.entity_id == 0){
//            self.attendanceCheckinDetail?.attendanceuser.entity_id = Int(self.attendanceCheckinDetail?.attendanceuser.userId ?? 0 )
//        }
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["AttendanceID"] =  attendanceCheckinDetail.data.attendanceID//self.attendanceCheckinDetail?.entity_id
        param["UserID"] = self.activeuser?.userID
        param["ClientID"] = NSNumber.init(value: 0)
        param["TransactionID"] = attendanceCheckinDetail.transactionID
        param["CompanyID"] =  self.activeuser?.company?.iD
        param["MemberID"] = attendanceCheckinDetail.data.iD
        param["Approve"] = NSNumber.init(value:status)
        param["IsPermanentLocation"] = NSNumber.init(value:false)
        param["TokenID"] =  self.activeuser?.securityToken
        param["InTime"] = ""
        param["OutTime"] = ""
        print("parameter of approval request = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveAttendance, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
         
            if(status.lowercased() == Constant.SucessResponseFromServer){
                SVProgressHUD.dismiss()
                //NotificationCenter.default.post(name: Notification.Name("LoadUserAttendanceHistory"), object: nil)
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:(message),view: self.view)
                }
                if let i = self.arrOfNotifications.firstIndex(of: attendanceCheckinDetail) {
                    self.arrOfNotifications[i] = attendanceCheckinDetail
                    
                }
                self.callWebService()
              
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    self.navigationController?.popViewController(animated: true)
//                }
            }else if(error.code == 0){
                SVProgressHUD.dismiss()
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:(message),view: self.view)
                }
                
            }else{
                SVProgressHUD.dismiss()
                Utils.toastmsg(message:((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription),view: self.view)
            }
        }
    }
    func showApprovalDialog(status:Bool,dic:Notificationmodel){
        var approvaljson = [String:Any]()
        approvaljson["CompanyID"] = self.activeuser?.company?.iD
        approvaljson["CreatedBy"] = self.activeuser?.userID
        approvaljson["ApprovedBy"] = self.activeuser?.userID
        if(dic.type == 180){
            approvaljson["ApprovedTo"] = dic.data.memberID
        }else{
        approvaljson["ApprovedTo"] = dic.data.assignBy
        }
        if let transactionid = dic.transactionID{
            if(transactionid.count > 3){
                let str2 = transactionid.substring(from: 3)
                approvaljson["ID"] = str2
            }
        
       
        if(status){
            statusId = 2
        }else{
            statusId = 3
        }
        if(dic.type == 142){
            if(transactionid.contains("PCK")){
                approvaljson["ManualCheckInStatusID"] = statusId
            }else{
                approvaljson["ManualCheckOutStatusID"] = statusId
            }
        }else{
            approvaljson["StatusID"] = statusId
            
        }
            
            if(dic.type == 143){
                if(transactionid.contains("PLK")){
                    approvaljson["ManualCheckInStatusID"] = statusId
                }else{
                    approvaljson["ManualCheckOutStatusID"] = statusId
                }
            }else{
                approvaljson["StatusID"] = statusId
                
            }
            
            if(statusId == 3){
                approvaljson["RejectMessage"] = strRejectionMsg.escapeUnicodeString()
            }
            
            if(dic.type == 143 || dic.type == 128 || dic.type == 142 || dic.type == 126){
                if(statusId == 2){
                    approvaljson["CheckInCheckOutStatusID"] = NSNumber.init(value: 1)
                }else if(statusId == 3){
                    approvaljson["CheckInCheckOutStatusID"] = NSNumber.init(value: 0)
                }
            }else{
                if let seriesPrefix = dic.data.seriesPrefix as? String{
                    approvaljson["SeriesPrefix"] = dic.data.seriesPrefix
                }
                
                if let seriesPostfix = dic.data.seriesPostFix as? NSNumber{
                    if(seriesPostfix.intValue == 0){
                        
                    }else{
                        approvaljson["SeriesPostfix"] = seriesPostfix
                    }
                }
            }
            
            if(dic.type ==  180){
                approvaljson["MemberID"] = dic.data.memberID
                approvaljson["totalVisit"] = dic.data.totalVisit
                approvaljson["validVisit"] = dic.data.validVisit
                approvaljson["Presence"] = dic.data.presence
                approvaljson["Date"] = dic.data.date
                approvaljson["vID"] = dic.data.vID
                
            }
            var notijson = [String:Any]()
            notijson["NotificationsID"] = dic.iD
            notijson["Type"] = String.init(format: "\(dic.type ?? 0)")
            notijson["TransactionID"] = dic.data.transactionID
            
            var datajson = [String:Any]()
            datajson["Message"] = dic.message
            datajson["TransactionID"] = dic.data.transactionID
           
            datajson["CompanyID"] = String.init(format: "\(dic.data.companyID ?? 0)")
            datajson["StatusID"] = NSNumber.init(value: statusId)
            if(dic.type ==  180){
                datajson["AssignTo"] = String.init(format: "\(dic.data.memberID)")
                datajson["AssignBy"] = String.init(format: "\(self.activeuser?.userID ?? 0)")
                datajson["vID"] = dic.data.vID
                datajson["CompanyID"] = self.activeuser?.company?.iD
               
            }else{
                datajson["AssignBy"] = String.init(format: "\(dic.data.assignBy ?? 0)")
                datajson["AssignTo"] = String.init(format: "\(dic.data.assignTo ?? 0)")
            }
            var param = Common.returndefaultparameter()
            param["approveEventJson"] = Common.returnjsonstring(dic: approvaljson)
            param["approvenotificationJson"] = Common.returnjsonstring(dic: notijson)
            param["data"] = Common.returnjsonstring(dic: datajson)
            SVProgressHUD.show()
            print("url is = \(ConstantURL.kWSUrlGetApprove) param = \(param)")
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetApprove, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    if ( message.count > 0 ) {
                Utils.toastmsg(message:(message),view: self.view)
                }
                    print(responseType)
                    let arrdic  = arr as? [String:Any] ?? [String:Any]()
                    let statusid = arrdic["StatusID"] as? Int ?? 0
                    dic.data.statusID = statusid
                    dic.status =  statusid
                    print("count of total arr of notifications = \(self.arrOfNotifications.count) , \(statusid) , \(arrdic)")
                    if let i = self.arrOfNotifications.firstIndex(of: dic) {
                        self.arrOfNotifications[i] = dic
                    }
                    print("count of total arr of notifications = \(self.arrOfNotifications.count)")
                    self.tblnotificationApprovalList.reloadData()
                    if(dic.type == 126 || dic.type == 128 && arrdic.keys.count > 0 && self.statusId == 2 ){
                //verify address
                    }
                }else{
                    
                    if ( message.count > 0 ) {
                    Utils.toastmsg(message:(message),view: self.view)
                    }else if let ermsg = error.userInfo["localiseddescription"] as? String{
                        if(ermsg.count > 0){
                            Utils.toastmsg(message:(ermsg),view: self.view)
                        }
                    }
                }
            }
        }
    }
}
extension NotificationApproval:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count of notification approval = \(arrOfNotifications.count)")
        return arrOfNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:VisitApprovalCell = tableView.dequeueReusableCell(withIdentifier: Constant.ApprovalVisitListCell, for: indexPath) as? VisitApprovalCell
        {
        let notificationobj = arrOfNotifications[indexPath.row]
            cell.delegate = self
        cell.setData(notificationobj: notificationobj)
            if(notificationobj.type == 61){
                cell.stkBtn.isHidden = false
            }else{
                cell.stkBtn.isHidden = true
            }
            cell.stkAction.tag = indexPath.row
            let taprecogniser = UITapGestureRecognizer.init(target: self, action: #selector(onTap(sender:)))
            
            taprecogniser.numberOfTapsRequired = 1
            taprecogniser.numberOfTouchesRequired = 1
            taprecogniser.cancelsTouchesInView = false
//            taprecogniser.delegate = self
            cell.stkAction.isUserInteractionEnabled = true
            cell.stkAction.addGestureRecognizer(taprecogniser)
        return cell
        }else{
          return  UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationobj = arrOfNotifications[indexPath.row]
       
        if(notificationobj.type == 108){
            //proposal
        }else if(notificationobj.type == 180){
            // approve Deviation
            self.showDialog(noti: notificationobj)
//            let approveaction = UIAlertAction.init(title: "Approve", style: UIAlertAction.Style.default) { (action) in
//                self.view.makeToast("I have no api Detail")
//               // self.changetheStatus(status: true, attendanceCheckinDetail: notificationobj)
//            }
//            let rejectaction = UIAlertAction.init(title: "Reject", style: UIAlertAction.Style.default) { (action) in
//                self.view.makeToast("I have no api Detail")
//               // self.changetheStatus(status: false, attendanceCheckinDetail: notificationobj)
//            }
//            Common.showalert(title: "SuperSales", msg: notificationobj.message , yesAction: approveaction, noAction: rejectaction, view: self)
        }else if(notificationobj.type == 109){
            //sales order
            let str2 = notificationobj.transactionID.substring(from: 3)
            if let salesOrder = SOrder.getSOByID(vID: NSNumber(value: Int64(str2) ?? 0)){
                if let p = salesOrder.soProductList.firstObject as? SOrderProducts, p.gSTEnabled {
                    print("Sales Order Details")
                    if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                        vc.order = salesOrder
                        vc.strTransaction = notificationobj.transactionID;
                        self.navigationController!.pushViewController(vc, animated: true)
                    }
                }else{
                    self.view.window?.makeToast("you can't update previous sales order which has applied VAT/CST")
                }
            }else {
                let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "SOrderList") as! SOrderList
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if(notificationobj.type == 142 || notificationobj.type == 143 || notificationobj.type == 126 || notificationobj.type == 128 || notificationobj.type == 152){
            if(notificationobj.status == 1){
                self.showDialog(noti: notificationobj)
            }else{
                if(notificationobj.type == 142 || notificationobj.type == 126){
                    if let visit = PlannVisit.getVisit(visitID: notificationobj.data.checkInID){
                        if let addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddplanVisitView) as? AddPlanVisit{
                            addplanvisit.isEdit = true
                            addplanvisit.objVisit =  visit
                            self.navigationController?.pushViewController(addplanvisit, animated: true)
                        }
                            }
                }else if(notificationobj.type == 143 || notificationobj.type == 128){
                  
                    if let objLead = Lead.getLeadByID(Id: notificationobj.data.checkInID.intValue){
                        if let addLeadobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.AddLead) as? AddLead{
                            addLeadobj.editLeaddic =  objLead.toDictionary()
                            AddLead.isEditLead = true
                            self.navigationController?.pushViewController(addLeadobj, animated: true)
                        }
                    }
                }
            }
        }else if(notificationobj.type == 120){
            if(notificationobj.status == 1){
                self.showDialog(noti: notificationobj)
            }
        }else if(notificationobj.type == 61 || notificationobj.type == 62){
           
        }else if(notificationobj.type == 25){
            self.showDialogCommon(noti: notificationobj)
        }else if(notificationobj.type == 139 && notificationobj.status == 1){
            //manual approval
            
            let approveaction = UIAlertAction.init(title: "Approve", style: UIAlertAction.Style.default) { (action) in
                self.changetheStatus(status: true, attendanceCheckinDetail: notificationobj)
            }
            let rejectaction = UIAlertAction.init(title: "Reject", style: UIAlertAction.Style.default) { (action) in
                self.changetheStatus(status: false, attendanceCheckinDetail: notificationobj)
            }
            Common.showalert(title: "SuperSales", msg: "What do you want ?", yesAction: approveaction, noAction: rejectaction, view: self)
//            if let manualapprovalobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname:Constant.ManualCheckIn) as? ManualAttendanceController{
//                manualapprovalobj.approvalobj = notificationobj
//                self.navigationController?.pushViewController(manualapprovalobj, animated: true)
//            }
        }else if(notificationobj.type == 133 && notificationobj.status == 1){
            // leave approval
            
            self.getLeaveDetail(transactionId: notificationobj.transactionID, memeberID: notificationobj.data.iD)
            
        }else if(notificationobj.type == 28 && notificationobj.status == 1){
            // approval for registration
            
        }else if(notificationobj.type == 137 && notificationobj.status == 1){
            // Approval for attendance request at customer/vendor location
            let approveaction = UIAlertAction.init(title: "Approve", style: UIAlertAction.Style.default) { (action) in
                self.changetheStatus(status: true, attendanceCheckinDetail: notificationobj)
            }
            let rejectaction = UIAlertAction.init(title: "Reject", style: UIAlertAction.Style.default) { (action) in
                self.changetheStatus(status: false, attendanceCheckinDetail: notificationobj)
            }
            Common.showalert(title: "SuperSales", msg: "What do you want ?", yesAction: approveaction, noAction: rejectaction, view: self)
//            if let attendanceDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceDetail) as? AttendanceDetailViewController{
//             //   attendanceDetail.attendanceCheckinDetail = notificationobj
//                self.navigationController?.pushViewController(attendanceDetail, animated: true)
//            }
//
        }else if(notificationobj.type == 135 && notificationobj.status == 1){
            //Attendance Approval to Admin
            let approveaction = UIAlertAction.init(title: "Approve", style: UIAlertAction.Style.default) { (action) in
                self.changetheStatus(status: true, attendanceCheckinDetail: notificationobj)
            }
            let rejectaction = UIAlertAction.init(title: "Reject", style: UIAlertAction.Style.default) { (action) in
                self.changetheStatus(status: false, attendanceCheckinDetail: notificationobj)
            }
            Common.showalert(title: "SuperSales", msg: "What do you want ?", yesAction: approveaction, noAction: rejectaction, view: self)
//            if let objapproval = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance , classname: Constant.ApprovalPendingList) as? ApprovalwaitingList{
//                self.navigationController?.pushViewController(objapproval, animated: true)
//            }
        }else if(notificationobj.type == 42 && notificationobj.status == 1){
            //Update customer approval
        }
    }
    
}
extension NotificationApproval:VisitApprovalDelegate{
    
    func approveClicked(cell: VisitApprovalCell) {
        selectedCell = cell
        if let indexpath = tblnotificationApprovalList.indexPath(for: cell){
            let selectednotification = self.arrOfNotifications[indexpath.row]
            let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
                self.expenseId = selectednotification.iD
                if(self.expenseId.intValue == 0){
                    self.getExpenseDetail(transactionId: selectednotification.transactionID, action: "Approve")
                }else{
        //accept or reject
         //   let userexpense = self.editableExpense//self.arrExpense[indexpath.row]
            
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
    
            var param = Common.returndefaultparameter()
            param["TransactionID"] = selectednotification.transactionID
            param["isApproved"] = true
    
            param["ExpenseID"] = self.expenseId//userexpense?.expenseId
         
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveRejectExpense, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
  
                    if ( message.count > 0 ) {
                        Utils.toastmsg(message:message,view: self.view)
                     
                    }
                    self.navigationController?.popViewController(animated: true)
                }else if(error.code == 0){
                    self.dismiss(animated: true, completion: nil)
                             if ( message.count > 0 ) {
                                Utils.toastmsg(message:message,view: self.view)
                    }
                         }else{
                    self.dismiss(animated: true, completion: nil)
                            Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                         }
            }
                }
            }
            let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
            Common.showalert(title: "SuperSales", msg: "Are you sure you want to accept this expense request for requested amount?", yesAction: yesAction, noAction: noAction, view: self)
        }
        
    }
    
    func rejectClicked(cell: VisitApprovalCell) {
        selectedCell = cell
        if let indexpath = tblnotificationApprovalList.indexPath(for: cell){
            let selectednotification = self.arrOfNotifications[indexpath.row]
            let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
                self.expenseId = selectednotification.iD
                if(self.expenseId.intValue == 0){
                    self.getExpenseDetail(transactionId: selectednotification.transactionID, action: "Reject")
                }else{
        
           //     let userexpense = self.editableExpense//self.arrExpense[indexpath.row]
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
                var param = Common.returndefaultparameter()
            param["TransactionID"] = selectednotification.transactionID
                param["isApproved"] = false
            param["ExpenseID"] = self.expenseId//userexpense?.expenseId
                //param["ExpenseJSON"] =
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlApproveRejectExpense, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        
    //                    self.arrExpense.remove(at: indexpath.row)
    //                    userexpense.status = "Reject"
    //
    //                    self.loadData()
                        if ( message.count > 0 ) {
                            Utils.toastmsg(message:message,view: self.view)
                      
                    }
                        self.navigationController?.popViewController(animated: true)
                    }else if(error.code == 0){
                        self.dismiss(animated: true, completion: nil)
                                 if ( message.count > 0 ) {
                    
                                    Utils.toastmsg(message:message,view: self.view)
                    }
                             }else{
                        self.dismiss(animated: true, completion: nil)
                                Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view: self.view)
                               
                             }
                }
                }
            }
            let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
            Common.showalert(title: "Supersales", msg: "Are you sure want to reject this expense request?", yesAction: yesAction , noAction: noAction, view: self)
            
        }
        }
    
    func getLeaveDetail(transactionId:String,memeberID:NSNumber){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["TransactionID"] = transactionId
        param["MemberID"] =  memeberID
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetLeaveRequestDetails, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                var dicLeave = arr as? [String:Any] ?? [String:Any]()
                let entityid = dicLeave["entity_id"] as? NSNumber ?? NSNumber.init(value: 0)
        if let leavedetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLeave, classname: Constant.LeaveDetail) as? LeaveDetailController{
            if let obj = LeaveStatus.getLeaveStatusByID(statusid: entityid) as? LeaveStatus{
                leavedetail.leaveobj = obj
            }
            dicLeave["TransactionId"] = transactionId
            leavedetail.dicOfLeave = dicLeave
            leavedetail.fromNotification = true
            self.navigationController?.pushViewController(leavedetail, animated: true)
            
        }}else{
            if ( message.count > 0 ) {
                Utils.toastmsg(message:message,view:self.view)
               // self.view1.makeToast(message)
            }
                   else{
                 
              self.dismiss(animated: true, completion: nil)
                    Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String) ?? "" :error.localizedDescription,view:self.view)
                 //     self.view1.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                   }
        }
        }
    }
    func getExpenseDetail(transactionId:String,action:String){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["TransactionID"] = transactionId
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetExpenseForTransaction, method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
              
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let expensedic = arr as? [String:Any] ?? [String:Any]()
//                print(expensedic)
             //   let expense =  UserExpense(dictionary: expensedic as NSDictionary)
                let expense = UserExpense().initwithdic(dict: expensedic)
                if(action == "Redirection"){
                if let expensedetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.AddExpense) as? AddExpenseViewController{
                    expensedetail.fromNotification = true
                    expensedetail.iseditExpense = true
                    expensedetail.editableExpense = expense
                    self.navigationController?.pushViewController(expensedetail, animated: true)
                }
                }else if(action == "Approve"){
                    self.approveClicked(cell: self.selectedCell)
                }else{
                    self.rejectClicked(cell: self.selectedCell)
                }
            }else{
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view:self.view)
                   // self.view1.makeToast(message)
                }
                       else{
                     
                  self.dismiss(animated: true, completion: nil)
                        Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String) ?? "" :error.localizedDescription,view:self.view)
                     //     self.view1.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                       }
            }
           
        }
    }
    
}
