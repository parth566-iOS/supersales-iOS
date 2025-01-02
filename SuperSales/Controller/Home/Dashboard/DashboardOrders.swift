//
//  DashboardOrders.swift
//  SuperSales
//
//  Created by Apple on 17/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD


class DashboardOrders: BaseViewController {

    @IBOutlet var tblSalesOrder: UITableView!
    @IBOutlet var btnLevelBack: UIButton!
    
    @IBOutlet var vwGraphIndicator: UIView!
    @IBOutlet var lbl1Indicator: UILabel!
    
    @IBOutlet var lbl1Title: UILabel!
    
    @IBOutlet var lbl2Indicator: UILabel!
    
    @IBOutlet var lbl2Title: UILabel!
    
    @IBOutlet var lbl3Indicator: UILabel!
    @IBOutlet var lbl3Title: UILabel!
    
    @IBOutlet var stkGraph: UIStackView!
   
    var listOrderReport:[OrderDashboardReport]?
     var levelOrderReport:[OrderDashboardReport]?
    
    @IBOutlet var lblPlanned: UILabel!
    
    @IBOutlet var lblRupees: UILabel!
    
    @IBOutlet var lblOrders: UILabel!
    var createdBy:NSNumber?
      var arrOrders:[[String:Any]]?
//    var selectedDate:String!
//       var selectedUserID:NSNumber!
    
    override func viewDidLoad() {
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        super.viewDidLoad()
            self.setUI()
        })
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
    
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
        super.viewDidAppear(true)
            SVProgressHUD.dismiss()
            self.getOrderForDashoard()
             })
    }

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
        SVProgressHUD.show(withStatus: "Loading")
        
                   NotificationCenter.default.addObserver(forName: Notification.Name("DashboardOrderUpdated"), object: nil, queue: OperationQueue.main) { (notify) in
                       print(notify.object as?  Dictionary<String,Any>)
                       self.getOrderForDashoard()
                             //  let dic = notify.object as! Dictionary<String,Any>
           //                  if let dic = notify.object as? Dictionary<String,Any> {
           //                      // action is not nil, is a String type, and is now stored in actionString
           //
           //                      self.getBeatPlanList(userID: Common.returndefaultnsnumber(dic: dic, keyvalue: "userId"), selectedMonth: Common.returndefaultstring(dic: dic,keyvalue: "selectedMonth"), selectedYear:Common.returndefaultstring(dic: dic, keyvalue: "selectedYear"))
           //                  } else {
           //                      // action was either nil, or not a String type
           //                  }
                   }
    }
    func showGraphIndicator(show:Bool){
        vwGraphIndicator.isHidden = false
        stkGraph.isHidden = false
        btnLevelBack.isHidden  = false
        lbl1Indicator.isHidden = true
        lbl1Title.isHidden = true
        lbl2Indicator.isHidden = true
        lbl2Title.isHidden = true
        lbl3Indicator.isHidden = true
        lbl3Title.isHidden = true
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - IBAction
    
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        
            let orderreport = levelOrderReport?.first
            createdBy = NSNumber.init(value:orderreport?.managerID ?? 0)
            if(CompanyUsers().getUser(userId: createdBy ?? 0)?.role_id == NSNumber.init(value:6)){
                self.itemclick(userid: self.activeuser?.userID ?? 0)
            }else{
                self.itemclick(userid: createdBy ?? 0)
            }
        
    }
    
    //MARK: - APICall
     func getOrderForDashoard(){
    SVProgressHUD.show(withStatus: "Loading")
        self.apihelper.getVisitDashboard(strurl: ConstantURL.kWSUrlGetOrderReportForDay, selecteduserID: SalesPlanHome.selectedUserID.stringValue, selectedDate: SalesPlanHome.selectedDate) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                            SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        print(responseType)
                       
                        if(responseType == ResponseType.arr){
                            self.arrOrders =  arr as? [[String:Any]] ?? [[String:Any]]()
                             self.itemclick(userid: self.activeuser?.userID ?? 0)
                            if(BaseViewController.staticlowerUser.count == 0){
                                DispatchQueue.global(qos: .background).async {
                                self.fetchuser{
                                    (arrOfuser,error) in
                                    
                                }
                                }
                            }
                        }
                    }else if(error.code == 0){
                     
                            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                        }else{
                      
                    Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)  //Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription
                        }
            }
        }

    //MARK: - Method
    func setUI(){
        tblSalesOrder.tableFooterView?.isHidden = true
        self.setGraphData()
        SalesPlanHome().salesdelegate = self 
        self.getOrderForDashoard()
        self.showGraphIndicator(show:true)
        self.tblSalesOrder.delegate = self
        self.tblSalesOrder.dataSource = self
    }
    
    func setGraphData(){
          btnLevelBack.isHidden = true
          vwGraphIndicator.isHidden = true
    }
    func itemclick(userid:NSNumber){
            createdBy = userid
            if(createdBy ==  self.activeuser?.userID ?? 0){
                 btnLevelBack.isHidden = true
            }else{
                 btnLevelBack.isHidden = false
            }
            
    
            listOrderReport = [OrderDashboardReport]()
            if(arrOrders?.count ?? 0 > 0){
                for order in arrOrders ?? [[String:Any]](){
                    let objorderreport = OrderDashboardReport().initwithdict(dic: order)
                    listOrderReport?.append(objorderreport)
                }
                levelOrderReport = [OrderDashboardReport]()
                if(listOrderReport?.count ?? 0 > 0){
                    var blueOrderReportList:[OrderDashboardReport] = [OrderDashboardReport]()
                    var redOrderReportList:[OrderDashboardReport] = [OrderDashboardReport]()
                    var tempblueOrderReportList:[OrderDashboardReport]  =   [OrderDashboardReport]()
                    var tempredOrderReportList:[OrderDashboardReport]  = [OrderDashboardReport]()
                    for vlr in 0...(listOrderReport?.count ?? 0)-1{
                        if  let orderdashboard  = listOrderReport?[vlr] as? OrderDashboardReport{
                        if let createdbyid = createdBy as? NSNumber{
                                         
                            if(createdbyid.intValue == orderdashboard.UserID){
                                               
                              orderdashboard.ColorCode =  NSNumber.init(value: 1) as? NSInteger
                              levelOrderReport?.append(orderdashboard ?? OrderDashboardReport())
                        }else if(createdbyid.intValue == orderdashboard.managerID && orderdashboard.lowerHierarchyUsers?.count ?? 0 > 0){
                orderdashboard.ColorCode = NSNumber.init(value: 2) as? NSInteger
                //tempblueLeadReportList.append(leaddashboard)
                tempblueOrderReportList.append(orderdashboard)
                }
                else if(createdbyid.intValue == orderdashboard.managerID && orderdashboard.lowerHierarchyUsers?.count ?? 0 ==  0){
                orderdashboard.ColorCode = NSNumber.init(value: 3) as? NSInteger
                //tempredLeadReportList.append(leaddashboard)
                tempredOrderReportList.append(orderdashboard)
                }else if(createdbyid.intValue == orderdashboard.DottedManagerID  && orderdashboard.lowerHierarchyUsers?.count ?? 0 > 0){
                    orderdashboard.ColorCode = NSNumber.init(value: 2) as? NSInteger
                   
                    tempblueOrderReportList.append(orderdashboard)
              
                }
                else if(createdbyid.intValue  == orderdashboard.DottedManagerID   && orderdashboard.lowerHierarchyUsers?.count ?? 0 ==  0){
                    orderdashboard.ColorCode = NSNumber.init(value: 3) as? NSInteger
                    
                    tempredOrderReportList.append(orderdashboard)
            
                }
            }
        }
    }
//    if(CompanyUsers().getUser(userId: createdBy ?? 0)?.role_id == NSNumber.init(value: 5)){
//    if(tempblueOrderReportList.count > 0){
//    for tbvdr in  0...tempblueOrderReportList.count - 1{
//        if  let  visitreport = tempblueOrderReportList[tbvdr] as? OrderDashboardReport{
//            if(visitreport.RoleID == 6){
//                            if(listOrderReport?.count ?? 0 > 0){
//                                        for lvdr in 0...(listOrderReport?.count ?? 0)-1{
//    //if(lvdr < tempblueOrderReportList.count ?? 0){
//                                        if(tempblueOrderReportList[tbvdr].UserID == listOrderReport?[lvdr].managerID){
//                                                if(listOrderReport?[lvdr].lowerHierarchyUsers?.count == 0){
//                                                                    listOrderReport?[lvdr].ColorCode = NSNumber.init(value: 3) as? NSInteger
//                                                    tempblueOrderReportList.append(listOrderReport?[lvdr] ?? OrderDashboardReport())
//                                                }else if(listOrderReport?[lvdr].lowerHierarchyUsers?.count ?? 0 > 0){
//                                                    listOrderReport?[lvdr].ColorCode = NSNumber.init(value: 2) as? NSInteger
//                                                        tempblueOrderReportList.append(listOrderReport?[lvdr] ?? OrderDashboardReport())
//                                            }
//                                                            }
//                                         //}
//                                                        }
//                                                            }
//                                                        
//                                                }
//                                                }
//                                            }
//                                        }
//                                    }
                                    
                                    
                                    if(tempblueOrderReportList.count > 0){
                                        for tbrl in 0...tempblueOrderReportList.count-1{
                                       
                                            if(tempblueOrderReportList[tbrl].RoleID ?? 0 > 5){
                                blueOrderReportList.append(tempblueOrderReportList[tbrl])
                                            }
                                        }
                                    }
                                    
                                    if(tempredOrderReportList.count > 0){
                                        for trvdl in 0...tempredOrderReportList.count-1{
                                            if(tempredOrderReportList[trvdl].RoleID ?? 0 > 5){
                                redOrderReportList.append(tempredOrderReportList[trvdl])
                                            }
                                        }
                                    }
                                    
                                    if(blueOrderReportList.count > 0){
                                    
                                    for bvdrl in 0...blueOrderReportList.count-1{
                                        let parts = blueOrderReportList[bvdrl].lowerHierarchyUsers?.components(separatedBy: ",")
                //                        var totalActualVisit = blueLeadReportList[bvdrl].ActualVisit
                //                        var totalPlannedVisit = blueLeadReportList[bvdrl].PlannedVisit
                //                        var totalMissedVisit = blueLeadReportList[bvdrl].MissedVisit
                //                        var totalUpdatedVisit = blueLeadReportList[bvdrl].UpdatedVisit
                                        
    //                                    var assignedLead = blueOrderReportList[bvdrl].AssignedLead
    //                                    var generatedLead = blueOrderReportList[bvdrl].GeneratedLead
    //                                    var updatedLead = blueOrderReportList[bvdrl].UpdatedLead
                                        var generateSO = blueOrderReportList[bvdrl].GeneratedSalesOrder
                                        var totalAmount = blueOrderReportList[bvdrl].TotalAmount
                                        
                                        
                                        if(parts?.count ?? 0 > 0){
                                            for part in 0...(parts?.count ?? 0) - 1{
                                                if(levelOrderReport?.count ?? 0 > 0){
                                                    print(levelOrderReport?.count)
                                                    for lvdr in levelOrderReport ?? [OrderDashboardReport](){
                                                        
            if(parts?[part].count ?? 0 > 0){
                                                            let userId = Int(parts?[part] ?? "0")
                                                            if(userId == lvdr.UserID){
                                    if var tgeneratedSO  = generateSO as? NSInteger{
                                                                                                        tgeneratedSO += lvdr.GeneratedSalesOrder ?? 0
                                                                                                        generateSO = tgeneratedSO
                                                                                                        }
                if var ototalAmount = totalAmount as? Double{
                                                                                                            ototalAmount += lvdr.TotalAmount ?? 0
                                                                                                            totalAmount = ototalAmount
                                                                                                        }
                                         

                                                                                                        break
                                                            }
                                                        }

                                               }
                                                
                                                }
                                            }
                                        }
                    blueOrderReportList[bvdrl].GeneratedSalesOrder = generateSO
                     blueOrderReportList[bvdrl].TotalAmount = totalAmount
              //blueOrderReportList[bvdrl].UpdatedLead =  updatedLead

                    print("count of order list \(levelOrderReport?.count) with blueorderlist count \(blueOrderReportList.count)")
                        levelOrderReport?.append(blueOrderReportList[bvdrl])
                                    }
                                    }
                                    for rvdr in redOrderReportList{
                                         print("count of order level report \(levelOrderReport?.count)")
                                        levelOrderReport?.append(rvdr)
                                    }
                                    
                                    if(levelOrderReport?.count ?? 0 > 0){
                                        var gntd = 0
                                        var amount = 0.0
                                        
                                        
                                        for lvdr in levelOrderReport ?? [OrderDashboardReport](){
                                            
                        gntd += lvdr.GeneratedSalesOrder ?? 0
                        amount += lvdr.TotalAmount ?? 0.00
                //                            plan += lvdr.PlannedVisit ?? 0
                //                            act += lvdr.ActualVisit ?? 0
                //                            miss += lvdr.MissedVisit ?? 0
                                        //    uptd += lvdr.UpdatedVisit ?? 0
                                        }
                lblRupees.isHidden = true
            lblPlanned.isHidden = false
           
            lblOrders.isHidden = false
                                        
             if let  amt = amount as? Double{
                          //  lblOrders.text  = String.init(format: "\(self.activeAccount?.company?.currCode ?? "$") \(amt)", [])
                lblPlanned.text = String.init(format:"\("₹") \(amt)",[])
              //  lblPlanned.text = String.init(format: "\("$") \(amt)", [])
                    }else{
                                             lblPlanned.text  = ""
                }
             //   lblPlanned.text = String.init(format:"\(self.activeAccount?.countryCode)\(amount)")
                                   lblOrders     .text = String.init(format:"\(gntd) orders ",[])
      
                                tblSalesOrder.tableFooterView?.isHidden = false
                                        
                                       
                                    }
                                }else{
                tblSalesOrder.tableFooterView?.isHidden = true
                                }
                             tblSalesOrder.reloadData()
                            
                        }
          SVProgressHUD.dismiss()
            }
        
        
}
extension DashboardOrders:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return levelOrderReport?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if let dashboardordercell = tableView.dequeueReusableCell(withIdentifier: "threelblhorizontal", for: indexPath) as? ThreeLblHorizontalCell{
                                           
                                            if let orderreport =  levelOrderReport?[indexPath.row] as? OrderDashboardReport{
                                                dashboardordercell.lbl1.text = orderreport.UserName
                                          //  dashboardvisitcell.detailTextLabel?.text = String.init(format:"%@",visitreport?.PlannedVisit ?? "0")
                                               dashboardordercell.setDashboardOrderData(orderReport: orderreport, indexpath: indexPath)
                                            }
                                          
                                            
                                            
                                        return dashboardordercell
                                        }else{
                                            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let orderReport = levelOrderReport?[indexPath.row] as? OrderDashboardReport{
                       if(orderReport.ColorCode == NSInteger.init(CGFloat(2))){
                           self.itemclick(userid: NSNumber.init(value:orderReport.UserID ?? 0))
                       }else{
                           if let reportview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ReportList) as? Reports{
                                 reportview.isHome = false
                            reportview.isFromValidAttendance = false
                       self.navigationController?.pushViewController(reportview, animated: true)
                           }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return  UITableView.automaticDimension
    }
          
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
              return 100
    }
    
}
extension DashboardOrders:SalesPlanHomedelegate{
    func dateselectionsalesplandone(date: Date) {
        print(date)
        self.getOrderForDashoard()
    }
//    func showCameraPicker(){
//        
//    }
    
}
