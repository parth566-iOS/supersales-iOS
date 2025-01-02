//
//  CustomerHistoryLead.swift
//  SuperSales
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping

class CustomerHistoryLead: BaseViewController {

    @IBOutlet weak var tblLead: UITableView!
    static var arrLeads:[[String:Any]]! = [[String:Any]]()
    var arrLeadStatusList:[[String:Any]]! = [[String:Any]]()
    var arrLeadCheckinCheckoutList:[[String:Any]]! = [[String:Any]]()
    
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
        tblLead.reloadData()
    }
    
    // MARK: -  Method
    func setUI(){
     
        tblLead.delegate =  self
        tblLead.dataSource =  self
        tblLead.reloadData()
        
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
extension CustomerHistoryLead:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        print(CustomerHistoryLead.arrLeads?.count ?? 0)
        return CustomerHistoryLead.arrLeads?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let lead =  CustomerHistoryLead.arrLeads?[section]
        arrLeadStatusList = lead?["LeadStatusList"] as? [[String:Any]] ?? [[String:Any]]()
        arrLeadCheckinCheckoutList = lead?["LeadCheckInOutList"] as? [[String:Any]] ?? [[String:Any]]()
        print(arrLeadStatusList.count  + arrLeadCheckinCheckoutList.count  + 1)
        return arrLeadStatusList.count  + arrLeadCheckinCheckoutList.count  + 1
      //  return arrVisits!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let visit =  CustomerHistoryLead.arrLeads?[indexPath.section]
        let arrLeadStatusList1 = visit?["LeadStatusList"] as? [[String:Any]] ?? [[String:Any]]()
        let arrLeadCheckinOut1 = visit?["LeadCheckInOutList"] as? [[String:Any]] ?? [[String:Any]]()
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! CustomerHistoryLeadCell
            cell.selectionStyle = .none
            cell.lblShortDate.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:visit?["CreatedTime"] as? String ?? "" , format: "yyyy/MM/dd HH:mm:ss") ?? "2021/12/10 10:10:10", format: "d MMM")
            let strattrioutcome = NSMutableAttributedString.init(string: "Created By:", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)])
            strattrioutcome.append(NSAttributedString.init(string: visit?["CreatedByName"] as? String ?? "" , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            cell.lblCreatedBy.attributedText = strattrioutcome
            
            let strattrleadid = NSMutableAttributedString.init(string: "ID:", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)])
            strattrleadid.append(NSAttributedString.init(string: String.init("\(visit?["SeriesPostfix"] as? Int ?? 0) ") , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            cell.lblLeadID.attributedText = strattrleadid
            let strattriproduct = NSMutableAttributedString.init(string: "Products:\n", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)])
            let arrProduct = visit?["ProductsList"] as? [[String:Any]] ?? [[String:Any]]()
            for product in arrProduct{
                strattriproduct.append(NSAttributedString.init(string: product["ProductName"] as? String ?? "", attributes: nil))
                strattriproduct.append(NSAttributedString.init(string: ", Quantity: " , attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)]))
                var strQty  = 0
                
                
                if let qty = product["Quantity"] as? Int{
                    strQty =  qty
                }
                strattriproduct.append(NSAttributedString.init(string: String.init(format:"%d",strQty), attributes: [:]))
              
                strattriproduct.append(NSAttributedString.init(string: ", Budget: " , attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)]))
                var strBudget = 0
               
                if let budget = product["Budget"] as? Int{
                    strBudget = budget
                }
                strattriproduct.append(NSAttributedString.init(string: String.init(format:"%d",strBudget), attributes: [:]))
                //\(product[""]
            }
            cell.lblProduct.attributedText = strattriproduct
            cell.vwBackgroundBg.backgroundColor = UIColor.white
//let count =
//            strattrioutcome.append(NSAttributedString.init(string: visit?["CreatedByName"] as? String ?? "" , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
//            cell.lblCreatedBy.attributedText = strattrioutcome
            return cell
        }else
        if(indexPath.row <  1 + arrLeadStatusList1.count){
           
            let status =  arrLeadStatusList1[indexPath.row - 1] as? [String:Any]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomerHistoryLeadUpdateStatusCell
            cell.selectionStyle = .none
            cell.lblCreatedName.text = status?["CreatedByName"] as? String ?? ""
            cell.lblShortDate.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:status?["CreatedTime"] as? String ?? "" , format: "yyyy/MM/dd HH:mm:ss") ?? "2021/12/10 10:10:10", format: "d-MM-yyyy")//status?["CreatedTime"] as? String ?? ""
            let strattrioutcome = NSMutableAttributedString.init(string: "Outcome:", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)])
            strattrioutcome.append(NSAttributedString.init(string:  status?["OutcomeValue"] as? String ??  "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            cell.lblOutcome.attributedText = strattrioutcome
            cell.lblConclusion.text = status?["Remarks"] as? String ?? ""
            
            cell.vwBackgroundBg.backgroundColor = UIColor.lightBackgroundColor
            
            return cell
           
        }else{
            let checkincheckoutobj =  arrLeadCheckinOut1[indexPath.row - arrLeadStatusList1.count - 1] as? [String:Any]

            let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! CustomerHistoryLeadCheckInOutCell
            cell1.selectionStyle = .none
            if let createdby = CompanyUsers().getUser(userId: NSNumber.init(value: checkincheckoutobj?["CreatedBy"] as? Int ?? 0)){
            cell1.lblCheckInOutByNm.text = String.init(format: "\(createdby.firstName) \(createdby.lastName)")
            }else{
                cell1.lblCheckInOutByNm.text = ""
            }
            let strcreateddate = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:checkincheckoutobj?["CreatedTime"] as? String ?? "" , format: "yyyy/MM/dd HH:mm:ss") ?? "2021/12/10 10:10:10", format: "d-MM-yyyy")
            cell1.lblCheckInOutDate.text = strcreateddate
            let strattriin = NSMutableAttributedString.init(string: "In:", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)])
            if let strcheckin = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:checkincheckoutobj?["CheckInTime"] as? String ?? "" , format: "yyyy/MM/dd HH:mm:ss") ?? "2021/12/10 10:10:10", format: "d-MM-yyyy") as? String{
                strattriin.append(NSAttributedString.init(string: strcheckin))
            }
            //cell1.lblCheckInOutDate.attributedText = strattriin
            let strattriout = NSMutableAttributedString.init(string: "  Out:", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14)])
            if let strcheckout = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:checkincheckoutobj?["CheckOutTime"] as? String ?? "" , format: "yyyy/MM/dd HH:mm:ss") ?? "2021/12/10 10:10:10", format: "hh:mm a") as? String{
                strattriout.append(NSAttributedString.init(string: strcheckout))
            }
            strattriin.append(strattriout)
            cell1.lblCheckInOutTime.attributedText = strattriin
            cell1.vwCheckInOutBg.backgroundColor = UIColor.lightGray
            return cell1
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arrvi = CustomerHistoryLead.arrLeads[indexPath.section]
        
        let visit =  CustomerHistoryLead.arrLeads?[indexPath.section]
        let arrLeadStatusList1 = visit?["LeadStatusList"] as? [[String:Any]] ?? [[String:Any]]()
        let arrLeadCheckinCheckout1 = visit?["LeadCheckInOutList"] as? [[String:Any]] ?? [[String:Any]]()
        
        var leadID = NSNumber.init(value: 0)
        var createdBy = NSNumber.init(value: 0)
        if(indexPath.row == 0){
            leadID = NSNumber.init(value:arrvi["ID"] as? Int ?? 0)
            createdBy = NSNumber.init(value:arrvi["CreatedBy"] as? Int ?? 0)
        }else
        if(indexPath.row < 1 + arrLeadStatusList1.count){
            let objlead = arrLeadStatusList1[indexPath.row - 1]
            leadID = NSNumber.init(value:objlead["LeadID"] as? Int ?? 0)
            createdBy = NSNumber.init(value:objlead["CreatedBy"] as? Int ?? 0)
        }else{
            let objLead  = arrLeadCheckinCheckout1[indexPath.row - arrLeadStatusList1.count - 1]
            leadID = NSNumber.init(value:objLead["LeadID"] as? Int ?? 0)
            createdBy = NSNumber.init(value:objLead["CreatedBy"] as? Int ?? 0)
        }
      
            //plan visit
        if let objLead = Lead.getLeadByID(Id: leadID.intValue){
        //PlannVisit.getVisit(visitID: visitID) as? PlannVisit{
                if let visitdetailobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
                    visitdetailobj.redirectTo = 0
                    visitdetailobj.lead = objLead
                    self.navigationController?.pushViewController(visitdetailobj, animated: true)
                }
            }else{
                var param = Common.returndefaultparameter()
                var param1 = [String:Any]()
                param1["ID"] = leadID
                param1["CreatedBy"] = createdBy
                param1["CompanyID"] = self.activeuser?.company?.iD
                param["getleadjson"] = Common.returnjsonstring(dic: param1)

                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetLeadDetails, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                  //  SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        let  arrVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                        print("Dictionary of lead = \(arrVisit)")
                        var dicVisit = arrVisit.first as? [String:Any] ?? [String:Any]()
//                        let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: dicVisit["CustomerID"] as? Int ?? 0))
//                        if(strCustomerName.count == 0){
//                        dicVisit["CustomerName"] = "Customer Not Mapped"
//                        }else{
//                        dicVisit["CustomerName"] = strCustomerName
//                        }
//                        let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
//                        if(reassignedId > 0){
//
//                            if let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId)){
//                        let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
//                                dicVisit["RessigneeName"] = reassignUserName
//                                                    }else{
//                                    dicVisit["RessigneeName"] = ""
//                                                    }
//                                                }else{
//                                        dicVisit["RessigneeName"] = ""
//                                                }
                        if(dicVisit.keys.count > 0){
                        MagicalRecord.save({ (localContext) in
                        let arrvisit = FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: Lead.defaultmapping(), context: localContext)
                            print(arrvisit)

                        }, completion: { (contextdidsave, error) in
                            print("\(contextdidsave) , error = \(error)")
                            print("visit saved")
                            if let objLead = Lead.getLeadByID(Id: leadID.intValue){
                                if let visitdetailobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
                                    visitdetailobj.redirectTo = 0
                                   
                                    visitdetailobj.lead = objLead
                                    self.navigationController?.pushViewController(visitdetailobj, animated: true)
                                }
                                }else{
                                    print("not get lead ")
                                }
                            })
                        }else{
                            Utils.toastmsg(message:"Lead is not synced",view: self.view)
                        }
                    
                    }
                    else{
                        
                    }
                }
                
            }
            
        /*}else{
            //unplan visit
//            if let planvisit = PlannVisit.getVisit(visitID: visitID) as? PlannVisit{
//                if let visitdetailobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
//                    visitdetailobj.redirectTo = 0
//                    visitdetailobj.visitType = VisitType.planedvisitHistory
//                    visitdetailobj.planvisit = planvisit
//                    self.navigationController?.pushViewController(visitdetailobj, animated: true)
//                }
//            }else{
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
                                    print("not get visit ")
                                }
                            }
   
                        })
                    }
                    else{
                        
                    }
                }
                
            }
        //}*/
        }
    
}

