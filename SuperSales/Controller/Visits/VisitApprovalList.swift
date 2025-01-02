//
//  VisitApprovalList.swift
//  SuperSales
//
//  Created by Apple on 17/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class VisitApprovalList: BaseViewController,UITableViewDataSource,UITableViewDelegate {

     @IBOutlet weak var tblVisitApproval: UITableView!
    
     var arrOfNotification:[Notificationmodel] = [Notificationmodel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tblVisitApproval.delegate = self
        tblVisitApproval.dataSource = self
        tblVisitApproval.separatorColor = .clear
        tblVisitApproval.tableFooterView = UIView()
        // Do any additional setup after loading the view.
         self.getApprovalVisitList()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.salesPlandelegateObject = self
        if(arrOfNotification.count > 0 && self.tblVisitApproval.visibleCells.count > 0){
        self.tblVisitApproval.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    func getApprovalVisitList(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()//126,142,143,108,109,110,111,151
    self.apihelper.getNotificationsList(type: "126,142") { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(error.code == 0){
                let arrNotification:[[String:Any]] = arr as? [[String:Any]] ?? [[String:Any]]()
                if(self.apihelper.pageCurrent == 1){
                    self.arrOfNotification = [Notificationmodel]()
                     self.arrOfNotification.removeAll()
                    
                }
                    for dic in arrNotification{
                        let notificationobj = Notificationmodel().initwithdic(dict:dic)
                        self.arrOfNotification.append(notificationobj)
                    }
                
                self.tblVisitApproval.reloadData()
            }else{
                Common.showalert(msg: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view:self)
            }
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

    //MARK - UITableviewdeleagate , UITableviewdatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return arrOfNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:VisitApprovalCell = tableView.dequeueReusableCell(withIdentifier: Constant.ApprovalVisitListCell, for: indexPath) as? VisitApprovalCell
        {
        let notificationobj = arrOfNotification[indexPath.row]
    
        cell.setData(notificationobj: notificationobj)
         //   cell.stkBtn.isHidden = true
        return cell
        }else{
          return  UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let visit = arrOfNotification[indexPath.row]
        print("Lattitude =  \(visit.userLattitude)")
        print("Longitude =  \(visit.userLongitude)")
        if(visit.status == 1){
            let approveAction = UIAlertAction.init(title: "Approve", style: UIAlertAction.Style.default) { (action) in
                var param = Common.returndefaultparameter()
        var approveEventJsonDic = [String:Any]()
        approveEventJsonDic["ID"] = visit.iD
        approveEventJsonDic["CompanyID"] = visit.companyID
       approveEventJsonDic["ApprovedTo"] =          visit.userID
       approveEventJsonDic["ApprovedBy"] = self.activeuser?.userID
        //approveEventJsonDic["CreatedBy"] = visit.
        var notijson = [String:Any]()
        notijson["NotificationsID"] = visit.iD
        notijson["Type"] = visit.type
        notijson["TransactionID"] = visit.transactionID
        var datajson = [String:Any]()
        datajson["Message"] = visit.message
        datajson["TransactionID"] = visit.transactionID
        datajson["AssignBy"] = visit.userID
        datajson["AssignTo"] = visit.lastModified
        datajson["CompanyID"] = visit.companyID
        datajson["StatusID"] = visit.status
                   
                    
        param["approveEventJson"] = approveEventJsonDic
        param["approvenotificationJson"] = notijson
        param["data"] = datajson
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetApprove, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
           print(responseType)
           print(status)
           print(arr)
                }
            }
            let rejectAction = UIAlertAction.init(title: "Reject", style: UIAlertAction.Style.destructive) { (reaction) in
    
    let rejectalert =  UIAlertController.init(title: "Reject Message", message: "", preferredStyle: UIAlertController.Style.alert)
    rejectalert.addTextField { (tf) in
        tf.placeholder = "Comments For Rejection"
    }
                
    let okAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default) { (okaction) in
         print("ok action for reject visit approval")
        var strRejectReason = ""
if((rejectalert.textFields!.first?.text?.isEmpty)!){
    strRejectReason = rejectalert.textFields!.first?.text ?? ""
        }
        
        }
    let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.destructive) { (cancelaction) in
                    
                }
    rejectalert.addAction(cancelAction)
    rejectalert.addAction(okAction)
self.present(rejectalert, animated: true) {
                    
                }
            }
            
            let viewOnMap = UIAlertAction.init(title: "View On Map", style: UIAlertAction.Style.default) { (vmoAction) in
                print("Click on view map")
                if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
                   /* var lattitude = NSNumber.init(value: 0)
                    if let myInteger = Int(visit.userLattitude ?? "0") {
                       lattitude = NSNumber(value:myInteger)
                    }
                    var longitude = NSNumber.init(value: 0)
                    if let myIntegerLongitude = Int(visit.userLongitude ?? "0") {
                       longitude = NSNumber(value:myIntegerLongitude)
                    }
                    
                    map.lattitude = lattitude
                    map.longitude = longitude*/
                    map.isFromDashboard = false
                    map.isFromColdCall = false
                    map.isFromVisitLeadDetail = false
                    print(visit.userLongitude)
                    print(visit.userLongitude)
                    map.lattitude = visit.userLattitude
                    map.longitude = visit.userLongitude
                    map.isFromApprovalList = true
                    print(visit.userLongitude) //NSNumber.init(value:AttendanceViewController.selectedLocation?.coordinate.longitude ?? 0.00)
self.navigationController?.pushViewController(map, animated: true)
                }
            }
            if(visit.type == 142 || visit.type == 143){
               Common.showalertWithAction(msg: visit.message, arrAction: [viewOnMap,approveAction,rejectAction], view: self)
            }else{
            Common.showalertWithAction(msg: visit.message, arrAction: [approveAction,rejectAction], view: self)
            }
        }
    }
}
extension VisitApprovalList:BaseViewControllerDelegate{
    
}
