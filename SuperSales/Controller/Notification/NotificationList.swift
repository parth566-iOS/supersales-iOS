//
//  NotificationList.swift
//  SuperSales
//
//  Created by mac on 21/11/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class NotificationList: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tblNotificationList: UITableView!
    
    var arrOfNotifications:[Notificationmodel]! = [Notificationmodel]()
    var currentpageno = 1
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
        super.viewDidLoad()
        self.setUI()
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.callWebService()
    }

    //MARK: - method
    func setUI(){
        
        tblNotificationList.estimatedRowHeight = 300.0
        tblNotificationList.rowHeight = UITableView.automaticDimension
        tblNotificationList.tableFooterView = UIView()
        tblNotificationList.separatorColor = UIColor.clear
        //selected_date = [NSDate date];
        tblNotificationList.delegate = self
        tblNotificationList.dataSource = self
       
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
        
        // remove proposal notificatin =  108
      
        param["Type"] = "19,24,25,27,28,29,30,31,32,42,43,44,47,50,51,52,86,56,57,58,61,62,68,69,78,79,80,83,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,131,132,133,134,135,136,137,138,139,142,143,144,145,146,147,151,152,153,81,82,75,154,155,163,164,167,168,165,166,169,170,171,172,173,174,180,150"
        RestAPIManager.httpRequest("getSuperSalesNotifications", .get, parameters: param, isTeamWorkUrl: false, isFull: true){ [self] response, success, error in
            
            if success {
                SVProgressHUD.dismiss()
             print(response)
                if let res = response as? [String: Any], let aDataInfo = res["data"] as? [[String: Any]]{
               // let arrNotification:[[String:Any]] = arr as? [[String:Any]] ?? [[String:Any]]()
                if(self.currentpageno == 1){
                    self.arrOfNotifications = [Notificationmodel]()
                     self.arrOfNotifications.removeAll()
                    
                }
                    for dic in aDataInfo{
                        print("dic of notification = \(dic)")
                        let notificationobj = Notificationmodel().initwithdic(dict:dic)
                        if((notificationobj.transactionID.contains("ACK") && notificationobj.status == 6 && notificationobj.type == 126) || (notificationobj.transactionID.contains("ALK") && notificationobj.status == 6 && notificationobj.type == 128)) {
                            print("have to hide this notification")
                        }else{
                        self.arrOfNotifications.append(notificationobj)
                        }
                    }
                }
                self.tblNotificationList.reloadData()
            }else if let result = response as? [String: Any]{
                SVProgressHUD.dismiss()
                if result["status"] as? String == "Error"{
                    Utils.toastmsg(message:result["message"] as? String ?? "",view:self.view)
              
                }else if result["status"] as? String == "Invalid Token"{
                    
                    Utils.toastmsg(message:result["message"] as? String ?? "",view:self.view)
            
//                    AppDelegate.shared.logout
                }else{
                    Utils.toastmsg(message:error?.localizedDescription as? String ?? "",view:self.view)
                  
                }
            }else{
                SVProgressHUD.dismiss()
                Utils.toastmsg(message:error?.localizedDescription as? String ?? "",view:self.view)
               
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
}
extension NotificationList:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count of notification list = \(arrOfNotifications.count)")
        return arrOfNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:VisitApprovalCell = tableView.dequeueReusableCell(withIdentifier: Constant.ApprovalVisitListCell, for: indexPath) as? VisitApprovalCell
        {
        let notificationobj = arrOfNotifications[indexPath.row]
      //  cell.stkBtn.isHidden = true
        cell.setData(notificationobj: notificationobj)
//            if(notificationobj.status == 61){
//                cell.stkBtn.isHidden = false
//            }else{
                cell.stkBtn.isHidden = true
          //  }
        return cell
        }else{
          return  UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationobj = arrOfNotifications[indexPath.row]
        if(notificationobj.type == 108){
            //proposal
        }else if(notificationobj.type == 109){
            //sales order
            if (notificationobj.status != 1){
                let str2 = notificationobj.transactionID.substring(from: 3)
                if let salesOrder = SOrder.getSOByID(vID: NSNumber(value: Int64(str2) ?? 0)){
                    if let p = salesOrder.soProductList.firstObject as? SOrderProducts, p.gSTEnabled {
                        print("Sales Order Details")
                        if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                            vc.order = salesOrder
                            self.navigationController!.pushViewController(vc, animated: true)
                        }
                    }else{
                        
                        self.view.window?.makeToast("you can't update previous sales order which has applied VAT/CST")
                    }
                }else {
                    let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "SOrderList") as! SOrderList
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else if(notificationobj.type == 142 || notificationobj.type == 143 || notificationobj.type == 126 || notificationobj.type == 128){
            if(notificationobj.status != 1){
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
                            AddLead.objLead = objLead
                            addLeadobj.editLeaddic =  objLead.toDictionary()
                            AddLead.isEditLead = true
                            self.navigationController?.pushViewController(addLeadobj, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    
}
