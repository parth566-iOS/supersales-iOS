//
//  CustomerHistoryVisit.swift
//  SuperSales
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

class CustomerHistoryVisit: BaseViewController {
    
    var customerId:NSNumber!
    @IBOutlet var tblView: UITableView!
    var dicData:[String:Any]?
    static var arrVisits:[[String:Any]]! = [[String:Any]]()
    var arrVisitStatusList:[[String:Any]]! = [[String:Any]]()
    var arrVisitCheckinCheckoutList:[[String:Any]]! = [[String:Any]]()
    
    override func viewDidLoad() {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        super.viewDidLoad()
            self.setUI()
//       if let popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.ChangeCustomerPopup) as? CustomerPopup{
//                         popup?.modalPresentationStyle = .overCurrentContext
//        popup?.customerId = self.customerId
//        popup?.delegate = self
//                         self.present(popup!, animated: true, completion: nil)
//               }
       })
       
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tblView.reloadData()
    }
    
    // MARK: -  Method
    func setUI(){
     
        tblView.delegate =  self
        tblView.dataSource =  self
        tblView.reloadData()
        
    }
    
//    func customerHistoryWithResponse(name:String,dictdata:[String:Any]){
//        self.title = name
//        Utils.toastmsg(message:dictdata["message"] as? String)
//        dicData = dicData?["data"] as? [String : Any] ?? [String:Any]()
//        
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CustomerHistoryVisit:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        print(CustomerHistoryVisit.arrVisits?.count ?? 0)
        return CustomerHistoryVisit.arrVisits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let visit =  CustomerHistoryVisit.arrVisits?[section]
        arrVisitStatusList = visit?["VisitStatusList"] as? [[String:Any]] ?? [[String:Any]]()
        arrVisitCheckinCheckoutList = visit?["VisitCheckInCheckOutList"] as? [[String:Any]] ?? [[String:Any]]()
        let totalvisithistory = arrVisitStatusList.count + arrVisitCheckinCheckoutList.count
       
        return totalvisithistory
      //  return arrVisits!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let visit =  CustomerHistoryVisit.arrVisits?[indexPath.section]
        let arrVisitStatusList1 = visit?["VisitStatusList"] as? [[String:Any]] ?? [[String:Any]]()
        let arrVisitCheckinOut1 = visit?["VisitCheckInCheckOutList"] as? [[String:Any]] ?? [[String:Any]]()
        if(indexPath.row < arrVisitStatusList1.count){
           
            let status =  arrVisitStatusList1[indexPath.row] as? [String:Any]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomerVisitHistoryCell
            cell.selectionStyle = .none
            cell.lblCreatedName.text = status?["CreatedByName"] as? String ?? ""
            cell.lblShortDate.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:status?["CreatedTime"] as? String ?? "" , format: "yyyy/MM/dd HH:mm:ss") ?? "2021/12/10 10:10:10", format: "d-MM-yyyy")//status?["CreatedTime"] as? String ?? ""
            let strattrioutcome = NSMutableAttributedString.init(string: "Outcome:", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)])
            strattrioutcome.append(NSAttributedString.init(string: VisitOutcomes.getOutcomeFromOutcomeID(leadSourceID: NSNumber.init(value:status?["VisitOutcomeID"] as? Int ?? 0 )), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            cell.lblOutcome.attributedText = strattrioutcome
            cell.lblConclusion.text = status?["Conclusion"] as? String ?? ""
            return cell
           
        }else{
            let checkincheckoutobj =  arrVisitCheckinOut1[indexPath.row - arrVisitStatusList1.count] as? [String:Any]

            let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! CustomerHistoryVisitCheckInOutCell
            cell1.selectionStyle = .none
            cell1.lblCheckInOutByNm.text = checkincheckoutobj?["CreatedByName"] as? String ?? ""
            let strcreateddate = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:checkincheckoutobj?["CreatedTime"] as? String ?? "" , format: "yyyy/MM/dd HH:mm:ss") ?? "2021/12/10 10:10:10", format: "d-MM-yyyy")
            cell1.lblCheckInOutDate.text = strcreateddate
            let strattriin = NSMutableAttributedString.init(string: "In:", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)])
            if let strcheckin = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:checkincheckoutobj?["CheckInTime"] as? String ?? "" , format: "yyyy/MM/dd HH:mm:ss") ?? "2021/12/10 10:10:10", format: "hh:mm a") as? String{
                strattriin.append(NSAttributedString.init(string: strcheckin))
            }
           // cell1.lblCheckInOutDate.attributedText = strattriin
            let strattriout = NSMutableAttributedString.init(string: "    Out:", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)])
           
            if let strcheckout = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:checkincheckoutobj?["CheckOutTime"] as? String ?? "" , format: "yyyy/MM/dd HH:mm:ss") ?? "2021/12/10 10:10:10", format: "hh:mm a") as? String{
                strattriout.append(NSAttributedString.init(string: strcheckout))
            }
            strattriin.append(strattriout)
            cell1.lblCheckInOutTime.attributedText = strattriin
            return cell1
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        let visit =  CustomerHistoryVisit.arrVisits?[indexPath.section]
        let arrVisitStatusList1 = visit?["VisitStatusList"] as? [[String:Any]] ?? [[String:Any]]()
        let arrVisitCheckinCheckout1 = visit?["VisitCheckInCheckOutList"] as? [[String:Any]] ?? [[String:Any]]()
        var visitID = NSNumber.init(value: 0)
        var createdBy = NSNumber.init(value: 0)
        var typeid = NSNumber.init(value: 0)
        typeid = NSNumber.init(value:visit?["VisitTypeID"] as? Int ?? 0)
        createdBy = NSNumber.init(value:visit?["CreatedBy"] as? Int ?? 0)
        visitID = NSNumber.init(value:visit?["ID"] as? Int ?? 0)
        if(indexPath.row < arrVisitStatusList1.count){
            let objvisit = arrVisitStatusList1[indexPath.row]
            visitID = NSNumber.init(value:objvisit["VisitID"] as? Int ?? 0)
            createdBy = NSNumber.init(value:objvisit["CreatedBy"] as? Int ?? 0)
          
        }else{
            let objvisit =  arrVisitCheckinCheckout1[indexPath.row - arrVisitStatusList1.count]
        ////arrVisitStatusList1[indexPath.row]
           
                  
                 
        }
        if(typeid == 1){
            //plan visit
            if let planvisit = PlannVisit.getVisit(visitID: visitID) as? PlannVisit{
                if let visitdetailobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                    visitdetailobj.redirectTo = 0
                    visitdetailobj.visitType = VisitType.planedvisitHistory
                    visitdetailobj.planvisit = planvisit
                    self.navigationController?.pushViewController(visitdetailobj, animated: true)
                }
            }else{
                var param = Common.returndefaultparameter()
                var param1 = [String:Any]()
                param1["ID"] = visitID
                param1["CreatedBy"] = createdBy
                param1["CompanyID"] = self.activeuser?.company?.iD
                param["getPlannedVisitsJson"] = Common.returnjsonstring(dic: param1)

                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetPlannedVisits, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                  //  SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        let  arrVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                        print("Dictionary of visit = \(arrVisit)")
                        var dicVisit = arrVisit.first as? [String:Any] ?? [String:Any]()
                        let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: dicVisit["CustomerID"] as? Int ?? 0))
                        if(strCustomerName.count == 0){
                        dicVisit["CustomerName"] = "Customer Not Mapped"
                        }else{
                        dicVisit["CustomerName"] = strCustomerName
                        }
                        let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
                        if(reassignedId > 0){
                                                    
                            if let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId)){
                        let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                                dicVisit["RessigneeName"] = reassignUserName
                                                    }else{
                                    dicVisit["RessigneeName"] = ""
                                                    }
                                                }else{
                                        dicVisit["RessigneeName"] = ""
                                                }
                        MagicalRecord.save({ (localContext) in
                        let arrvisit = FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
                            print(arrvisit)

                        }, completion: { (contextdidsave, error) in
                            print("\(contextdidsave) , error = \(error)")
                            print("visit saved")
                            if let planvisit1  = PlannVisit.getVisit(visitID: visitID) as? PlannVisit{
                                if let visitdetailobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                                    visitdetailobj.redirectTo = 0
                                    visitdetailobj.visitType = VisitType.planedvisitHistory
                                    visitdetailobj.planvisit = planvisit1
                                    self.navigationController?.pushViewController(visitdetailobj, animated: true)
                                }else{
                                    Utils.toastmsg(message:"Visit is not synced",view:self.view)
                                    print("not get visit ")
                                }
                            }
   
                        })
                    }
                    else{
                        
                    }
                }
                
            }
            
        }else{
            //unplan visit
            var param = Common.returndefaultparameter()
            var param1 = [String:Any]()
            param1["ID"] = visitID
            param1["CreatedBy"] = createdBy
            param1["CompanyID"] = self.activeuser?.company?.iD
            param["getUnPlannedVisitsJson"] = Common.returnjsonstring(dic: param1)

            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetUnPlannedVisits, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
              //  SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    let  arrVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                    print("Dictionary of visit = \(arrVisit)")
                    var dicVisit = arrVisit.first as? [String:Any] ?? [String:Any]()
//                    let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: dicVisit["CustomerID"] as? Int ?? 0))
//                    if(strCustomerName.count == 0){
//                    dicVisit["CustomerName"] = "Customer Not Mapped"
//                    }else{
//                    dicVisit["CustomerName"] = strCustomerName
//                    }
//                    let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
//                    if(reassignedId > 0){
//
//                        if let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId)){
//                    let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
//                            dicVisit["RessigneeName"] = reassignUserName
//                                                }else{
//                                dicVisit["RessigneeName"] = ""
//                                                }
//                                            }else{
//                                    dicVisit["RessigneeName"] = ""
//                                            }
//                    MagicalRecord.save({ (localContext) in
//                    let arrvisit = FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
//                        print(arrvisit)
//
//                    }, completion: { (contextdidsave, error) in
//                        print("\(contextdidsave) , error = \(error)")
//                        print("visit saved")
//                        if let planvisit1  = PlannVisit.getVisit(visitID: visitID) as? PlannVisit{
                    if(dicVisit.keys.count > 0){
                    let objcoldcall = UnplannedVisit().initwithdic(dict: dicVisit)
                            if let visitdetailobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                                visitdetailobj.redirectTo = 0
                                visitdetailobj.visitType = VisitType.coldcallvisitHistory
                                visitdetailobj.unplanvisit = objcoldcall
                                self.navigationController?.pushViewController(visitdetailobj, animated: true)
//                            }else{
//                                print("not get visit ")
                            }
                        }
                }else{
                    Utils.toastmsg(message:"Visit is not synced",view:self.view)
                }
            }
                   // })
        }
//        }else{
//            let objvisit =  arrVisitCheckinCheckout1[indexPath.row - arrVisitStatusList1.count]
////arrVisitStatusList1[indexPath.row]
//            visitID = NSNumber.init(value:objvisit["ID"] as? Int ?? 0)
//            createdBy = NSNumber.init(value:objvisit["CreatedBy"] as? Int ?? 0)
//            typeid = NSNumber.init(value:objvisit["VisitTypeID"] as? Int ?? 0)
//        }
    }
    
}
