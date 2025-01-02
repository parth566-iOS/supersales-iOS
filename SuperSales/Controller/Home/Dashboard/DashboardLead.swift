//
//  DashboardLead.swift
//  SuperSales
//
//  Created by Apple on 17/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import Charts
//import DGCharts


class DashboardLead: BaseViewController, ChartViewDelegate {

     @IBOutlet var tblSalesLead: UITableView!
    @IBOutlet var btnLevelBack: UIButton!
    
    @IBOutlet var vwGraphIndicator: UIView!
    @IBOutlet var lbl1Indicator: UILabel!
    
    @IBOutlet var lbl1Title: UILabel!
    
    @IBOutlet var lbl2Indicator: UILabel!
    
    @IBOutlet var lbl2Title: UILabel!
    
    @IBOutlet var lbl3Indicator: UILabel!
    @IBOutlet var lbl3Title: UILabel!
    
    @IBOutlet var stkGraph: UIStackView!
    
    var listLeadReport:[LeadDashboardReport]?
    var levelLeadReport:[LeadDashboardReport]?
    @IBOutlet var totalChart:HorizontalBarChartView!
    
    @IBOutlet var lblPlanned: UILabel!
    
    @IBOutlet var lblRupees: UILabel!
    
    @IBOutlet var lblOrders: UILabel!
    var createdBy:NSNumber?
    var arrLeads:[[String:Any]]?
//     var selectedDate:String!
//    var selectedUserID:NSNumber!
//    
    
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
            self.getLeadForDashoard()
             })
    }

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
        SVProgressHUD.show(withStatus: "Loading")
            NotificationCenter.default.addObserver(forName: Notification.Name("DashboardLeadUpdated"), object: nil, queue: OperationQueue.main) { (notify) in
                print(notify.object as?  Dictionary<String,Any>)
                self.getLeadForDashoard()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - Method
    func setUI(){
        tblSalesLead.tableFooterView?.isHidden = true
        self.getLeadForDashoard()
        self.setGraphData()
        SalesPlanHome().salesdelegate = self 
       self.showGraphIndicator(show: false)
        self.tblSalesLead.delegate = self
        self.tblSalesLead.dataSource = self
    }
    
    func setGraphData(){
        lbl1Indicator.backgroundColor = UIColor.systemBlue
                  lbl1Title.text = "Assigned"
                  lbl2Indicator.backgroundColor = UIColor.systemGreen
                  lbl2Title.text = "Added"
                   lbl3Indicator.backgroundColor = UIColor.systemOrange
                  lbl3Title.text = "Updated"
    }
    func showGraphIndicator(show:Bool){
      //  vwGraphIndicator.isHidden = show
      //  stkGraph.isHidden = show
          btnLevelBack.isHidden  = true
        lbl1Indicator.isHidden = show
        lbl1Title.isHidden = show
        lbl2Indicator.isHidden = show
        lbl2Title.isHidden = show
        lbl3Indicator.isHidden = show
        lbl3Title.isHidden = show
        
    }
    func itemclick(userid:NSNumber){
            createdBy = userid
            if(createdBy ==  self.activeuser?.userID ?? 0){
                btnLevelBack.isHidden = true
            }else{
                 btnLevelBack.isHidden = false
            }
            
     
                listLeadReport = [LeadDashboardReport]()
                if(arrLeads?.count ?? 0 > 0){
                    for lead in arrLeads ?? [[String:Any]](){
                        let objleadreport = LeadDashboardReport().initwithdict(dic: lead)
                        listLeadReport?.append(objleadreport)
                    }
                    levelLeadReport = [LeadDashboardReport]()
                    if(listLeadReport?.count ?? 0 > 0){
                        var blueLeadReportList:[LeadDashboardReport] = [LeadDashboardReport]()
                        var redLeadReportList:[LeadDashboardReport] = [LeadDashboardReport]()
                        var tempblueLeadReportList:[LeadDashboardReport]  =   [LeadDashboardReport]()
                        var tempredLeadReportList:[LeadDashboardReport]  = [LeadDashboardReport]()
                    for vlr in 0...(listLeadReport?.count ?? 0)-1{
                            if  let leaddashboard  = listLeadReport?[vlr] as? LeadDashboardReport{
                            if let createdbyid = createdBy as? NSNumber{
                             
                                if(createdbyid.intValue == leaddashboard.UserID){
                                   
                                    leaddashboard.ColorCode =  NSNumber.init(value: 1) as? NSInteger
                              levelLeadReport?.append(leaddashboard ?? LeadDashboardReport())
                                }else if(createdbyid.intValue == leaddashboard.managerID && leaddashboard.lowerHierarchyUsers?.count ?? 0 > 0){
                                    leaddashboard.ColorCode = NSNumber.init(value: 2) as? NSInteger
                                    print(leaddashboard.RoleID)
                            tempblueLeadReportList.append(leaddashboard)
                                }
                                else if(createdbyid.intValue == leaddashboard.managerID && leaddashboard.lowerHierarchyUsers?.count ?? 0 ==  0){
                                    leaddashboard.ColorCode = NSNumber.init(value: 3) as? NSInteger
                                    tempredLeadReportList.append(leaddashboard)
                                }
                            else if(createdbyid.intValue == leaddashboard.DottedManagerID && leaddashboard.lowerHierarchyUsers?.count ?? 0 > 0){
                                leaddashboard.ColorCode = NSNumber.init(value: 2) as? NSInteger
                               
                                tempblueLeadReportList.append(leaddashboard)
                          
                            }
                            else if(createdbyid.intValue  == leaddashboard.DottedManagerID   && leaddashboard.lowerHierarchyUsers?.count ?? 0 ==  0){
                                leaddashboard.ColorCode = NSNumber.init(value: 3) as? NSInteger
                                
                                tempredLeadReportList.append(leaddashboard)
                        
                            }
                            }
                            }
                        }
//                        if(CompanyUsers().getUser(userId: createdBy ?? 0)?.role_id == NSNumber.init(value: 5)){
//                            if(tempblueLeadReportList.count > 0){
//                                for tbvdr in  0...tempblueLeadReportList.count - 1{
//
//                                  if  let  visitreport = tempblueLeadReportList[tbvdr] as? LeadDashboardReport{
//                                        if(visitreport.RoleID == 6){
//
//
//                    if(listLeadReport?.count ?? 0 > 0){
//                        let listredreportcount = listLeadReport?.count ?? 0
//                        for lvdr in 0...(listredreportcount ?? 0) - 1{
//
//                            if(tempblueLeadReportList[tbvdr].UserID == listLeadReport?[lvdr].managerID){
//                                                    if(listLeadReport?[lvdr].lowerHierarchyUsers?.count == 0){
//                                                        listLeadReport?[lvdr].ColorCode = NSNumber.init(value: 3) as? NSInteger
//                                        tempredLeadReportList.append(listLeadReport?[lvdr] ?? LeadDashboardReport())
//                                                    }else if(listLeadReport?[lvdr].lowerHierarchyUsers?.count ?? 0 > 0){
//                                                        listLeadReport?[lvdr].ColorCode = NSNumber.init(value: 2) as? NSInteger
//                                                                                          tempblueLeadReportList.append(listLeadReport?[lvdr] ?? LeadDashboardReport())
//                                }
//                                                }
//
//                                            }
//                                                }
//
//                                    }
//                                    }
//                                }
//                            }
//                        }
                        
                        
                        if(tempblueLeadReportList.count > 0){
                            for tbrl in 0...tempblueLeadReportList.count-1{
                           
                                if(tempblueLeadReportList[tbrl].RoleID ?? 0 > 5){
                    blueLeadReportList.append(tempblueLeadReportList[tbrl])
                                }
                            }
                        }
                        
                        if(tempredLeadReportList.count > 0){
                            for trvdl in 0...tempredLeadReportList.count-1{
                                if(tempredLeadReportList[trvdl].RoleID ?? 0 > 5){
                    redLeadReportList.append(tempredLeadReportList[trvdl])
                                }
                            }
                        }
                        
                        if(blueLeadReportList.count > 0){
                        
                        for bvdrl in 0...blueLeadReportList.count-1{
                            let parts = blueLeadReportList[bvdrl].lowerHierarchyUsers?.components(separatedBy: ",")
    //                        var totalActualVisit = blueLeadReportList[bvdrl].ActualVisit
    //                        var totalPlannedVisit = blueLeadReportList[bvdrl].PlannedVisit
    //                        var totalMissedVisit = blueLeadReportList[bvdrl].MissedVisit
    //                        var totalUpdatedVisit = blueLeadReportList[bvdrl].UpdatedVisit
                            
                            var assignedLead = blueLeadReportList[bvdrl].AssignedLead
                            var generatedLead = blueLeadReportList[bvdrl].GeneratedLead
                            var updatedLead = blueLeadReportList[bvdrl].UpdatedLead
                            
                            if(parts?.count ?? 0 > 0){
                                for part in 0...(parts?.count ?? 0) - 1{
                                    if(listLeadReport?.count ?? 0 > 0){
                                        print(listLeadReport?.count)
                                        for lvdr in listLeadReport ?? [LeadDashboardReport](){
                                           
                                            if(parts?[part].count ?? 0 > 0){
                                                let userId = Int(parts?[part] ?? "0")
                                                if(userId == lvdr.UserID){
                        if var tAssignedLead = assignedLead as? NSInteger{
                                                                                            tAssignedLead += lvdr.AssignedLead ?? 0
                                                                                            assignedLead = tAssignedLead
                                                                                            }
                                                                                             if var tgeneratedLead  = generatedLead as? NSInteger{
                                                                                                tgeneratedLead += lvdr.GeneratedLead ?? 0
                                                                                                generatedLead = tgeneratedLead
                                                                                            }
                                                                                             if var tupdatedLead   = updatedLead as? NSInteger{
                                                                                                tupdatedLead += lvdr.UpdatedLead ?? 0
                                                                                                updatedLead = tupdatedLead
                                                                                            }

                                                                                            break
                                                }
                                            }

                                   }
                                    
                                    }
                                }
                            }
        blueLeadReportList[bvdrl].AssignedLead = assignedLead
        blueLeadReportList[bvdrl].GeneratedLead = generatedLead
        blueLeadReportList[bvdrl].UpdatedLead =  updatedLead

        
            levelLeadReport?.append(blueLeadReportList[bvdrl])
                        }
                        }
                        for rvdr in redLeadReportList{
                       
                            levelLeadReport?.append(rvdr)
                        }
                        
                        if(levelLeadReport?.count ?? 0 > 0){
    //                        var plan = 0
    //                        var act = 0
    //                        var miss = 0
                            var uptd = 0
                            var added = 0
                            var assigned = 0
                            
                            for lvdr in levelLeadReport ?? [LeadDashboardReport](){
    //                            plan += lvdr.PlannedVisit ?? 0
    //                            act += lvdr.ActualVisit ?? 0
    //                            miss += lvdr.MissedVisit ?? 0
                                uptd += lvdr.UpdatedLead ?? 0
                                added += lvdr.GeneratedLead ?? 0
                                assigned += lvdr.AssignedLead ?? 0
                            }
                           
                            lblPlanned.isHidden = true
                            lblRupees.isHidden = true
                            lblOrders.isHidden = true
                            
                            tblSalesLead.tableFooterView?.isHidden = false
                            if(uptd > 0 || added > 0 || assigned > 0){
                                totalChart.isHidden = false
                                self.setDataCount([assigned,added,uptd], range: 50, chart: totalChart)
                            }else{
                                totalChart.isHidden = true
                            }
                        }
                    }else{
                         tblSalesLead.tableFooterView?.isHidden = true
                    }
                 tblSalesLead.reloadData()
                
            }
          SVProgressHUD.dismiss()
}
    
    func setDataCount(_ count: [Int], range: UInt32,chart:HorizontalBarChartView) {
       
        let spaceForBar = 1.0
        
       
        let yVals = [BarChartDataEntry(x: 1.0 * spaceForBar  , y: Double(count[0]) , icon: nil),BarChartDataEntry(x: 2.0 * spaceForBar  , y: Double(count[1]) , icon: nil),BarChartDataEntry(x: 3.0 * spaceForBar  , y: Double(count[2]) , icon: nil)]
          //  [BarChartDataEntry(x: Double(count[0]), y: 1.0 * spaceForBar , icon: nil),BarChartDataEntry(x: Double(count[1]), y: Double(5.0 * spaceForBar), icon: nil),BarChartDataEntry(x: Double(count[2]), y: Double(7.0  * spaceForBar), icon: nil)]//[BarChartDataEntry(x: Double(1)*spaceForBar, y: Double(count))]
        let set1 = BarChartDataSet(entries: yVals, label: "")
        set1.colors = [UIColor.systemBlue,UIColor.systemGreen,UIColor.systemOrange]
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:15)!)
        data.setValueFont(.boldSystemFont(ofSize: 10))
        data.setValueTextColor(UIColor.white)
        
        chart.rightAxis.enabled = false//true
        chart.rightAxis.drawLabelsEnabled = false//true
        // For hide border values
        chart.leftAxis.enabled = false
        //chart.rightAxis.enabled = false
        chart.drawBordersEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
     //   chart.rightAxis.drawLabelsEnabled = false
        chart.drawGridBackgroundEnabled = false
        chart.drawValueAboveBarEnabled = false
        chart.delegate = self
        chart.xAxis.granularityEnabled = false
        chart.xAxis.enabled = true
        chart.xAxis.drawLabelsEnabled = true
        chart.legend.enabled = false
        chart.xAxis.granularity =  30.0
       // chart.xAxis.enabled = true
        // for set color
        
        
        // disable zoom
        chart.setScaleEnabled(false)
        chart.dragEnabled = false
        chart.doubleTapToZoomEnabled = false
        
        
        
        
      
        
       
       
       
       
        
       
        
        // disable zoom
        chart.setScaleEnabled(false)
        chart.dragEnabled = false
        chart.doubleTapToZoomEnabled = false
        
    
      //  data.barWidth = barWidth
       // chart.drawValueAboveBarEnabled = false
    //    chart.xAxis.labelPosition = .bottom
//        chart.drawGridBackgroundEnabled = false
//        chart.drawBordersEnabled = false
        
        chart.data = data
    }
    
    //MARK: - IBAction
    @IBAction func btnBackClicked(_ sender: UIButton) {
        
            let leadreport = levelLeadReport?.first
            createdBy = NSNumber.init(value:leadreport?.managerID ?? 0)
            if(CompanyUsers().getUser(userId: createdBy ?? 0)?.role_id == NSNumber.init(value:6)){
                self.itemclick(userid: self.activeuser?.userID ?? 0)
            }else{
                self.itemclick(userid: createdBy ?? 0)
            }
        
        
    }
    
    
    
    //MARK: - API Call
    func getLeadForDashoard(){
       SVProgressHUD.show(withStatus: "Loading")
              
        self.apihelper.getVisitDashboard(strurl: ConstantURL.kWSUrlGetLeadReportForDay, selecteduserID: SalesPlanHome.selectedUserID.stringValue, selectedDate: SalesPlanHome.selectedDate) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                  SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    print(responseType)
                       SVProgressHUD.dismiss()
                    if(responseType == ResponseType.arr){
                        self.arrLeads =  arr as? [[String:Any]] ?? [[String:Any]]()
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
}
extension DashboardLead:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return levelLeadReport?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dashboardleadcell = tableView.dequeueReusableCell(withIdentifier: "dashboardcell", for: indexPath) as? DashboardCell{
           
            if let leadreport =  levelLeadReport?[indexPath.row] as? LeadDashboardReport{
                dashboardleadcell.lbl1.text = leadreport.UserName
          //  dashboardvisitcell.detailTextLabel?.text = String.init(format:"%@",visitreport?.PlannedVisit ?? "0")
              dashboardleadcell.setDashboardLeadData(leadReport: leadreport, indexpath: indexPath)
            }
           
            
            
        return dashboardleadcell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let leadReport = levelLeadReport?[indexPath.row] as? LeadDashboardReport{
            if(leadReport.ColorCode == NSInteger.init(CGFloat(2))){
                self.itemclick(userid: NSNumber.init(value:leadReport.UserID ?? 0))
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
extension DashboardLead:SalesPlanHomedelegate{
    func dateselectionsalesplandone(date: Date) {
        print(date)
        self.getLeadForDashoard()
    }
//    func showCameraPicker(){
//        
//    }
    
}
