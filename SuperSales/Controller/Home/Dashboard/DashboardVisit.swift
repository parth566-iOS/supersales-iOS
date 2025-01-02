//
//  DashboardVisit.swift
//  SuperSales
//
//  Created by Apple on 17/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import Charts
//import DGCharts

class DashboardVisit: BaseViewController, ChartViewDelegate {

   
    @IBOutlet var tblSalesVisit: UITableView!
    
    //graph
    
    @IBOutlet var btnLevelBack: UIButton!
    
    @IBOutlet var vwGraphIndicator: UIView!
    @IBOutlet var lbl1Indicator: UILabel!
    
    @IBOutlet var lbl1Title: UILabel!
    
    @IBOutlet var lbl2Indicator: UILabel!
    
    @IBOutlet var lbl2Title: UILabel!
    
    @IBOutlet var lbl3Indicator: UILabel!
    @IBOutlet var lbl3Title: UILabel!
    
    @IBOutlet var stkGraph: UIStackView!
    
    @IBOutlet weak var totalVisitChart: HorizontalBarChartView!
    //    var selectedDate:String!
//    var selectedUserID:NSNumber!
     var arrVisits:[[String:Any]]?
    
    var createdBy:NSNumber?
       var listReport:[VisitDashboardReport]?
        var levelReport:[VisitDashboardReport]?
     
       
       @IBOutlet var lblPlanned: UILabel!
       
       @IBOutlet var lblRupees: UILabel!
       
       @IBOutlet var lblOrders: UILabel!
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
            self.getvisitForDashboard()
             })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SVProgressHUD.show(withStatus: "Loading")
        NotificationCenter.default.addObserver(forName: Notification.Name("DashboardUpdated"), object: nil, queue: OperationQueue.main) { (notify) in
            print(notify.object as?  Dictionary<String,Any>)
            self.getvisitForDashboard()
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
    func setgraphdata(){
           btnLevelBack.isHidden = true
           
               lbl1Indicator.backgroundColor = UIColor.systemGreen
               lbl1Title.text = "Done"
               lbl2Indicator.backgroundColor = UIColor.systemYellow
                          lbl2Title.text = "Missed"
                 lbl3Indicator.backgroundColor = UIColor.systemRed
                          lbl3Title.text = "Updated"
          
       }
    
    
    
    func setUI(){
    
         tblSalesVisit.tableFooterView?.isHidden = true
        self.salesPlandelegateObject = self
         if let salephome = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardSalesPlan) as? SalesPlanHome{
        salephome.salesdelegate = self
        }
        SalesPlanHome().salesdelegate = self 
        self.setgraphdata()
           self.getvisitForDashboard()
        self.showGraphIndicator(show: false)
        self.tblSalesVisit.delegate = self
        self.tblSalesVisit.dataSource = self
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
    
    func setDataCount(_ count: [Int], range: UInt32,chart:HorizontalBarChartView) {
       
        let spaceForBar = 1.0
        
      let  yVals = [BarChartDataEntry.init(x:  1 * spaceForBar, yValues: [Double(count[0]),Double(count[1]),Double(count[2])])]
      //  let yVals = [BarChartDataEntry(x: 1.0 * spaceForBar  , y: Double(count[0])  , icon: nil),BarChartDataEntry(x: 1.0 * spaceForBar  , y: Double(count[1]), icon: nil),BarChartDataEntry(x: 1.0 * spaceForBar , y:  Double(count[2]), icon: nil)]
          //  [BarChartDataEntry(x: Double(count[0]), y: 1.0 * spaceForBar , icon: nil),BarChartDataEntry(x: Double(count[1]), y: Double(5.0 * spaceForBar), icon: nil),BarChartDataEntry(x: Double(count[2]), y: Double(7.0  * spaceForBar), icon: nil)]//[BarChartDataEntry(x: Double(1)*spaceForBar, y: Double(count))]
        let set1 = BarChartDataSet(entries: yVals, label: "")
        set1.colors = [UIColor.systemGreen,UIColor.systemYellow,UIColor.systemRed]
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:15)!)
        data.setValueFont(.boldSystemFont(ofSize: 10))
        data.setValueTextColor(UIColor.white)
        
        
        // For hide border values
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.drawBordersEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
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
    
      //  data.barWidth = barWidth
       // chart.drawValueAboveBarEnabled = false
    //    chart.xAxis.labelPosition = .bottom
//        chart.drawGridBackgroundEnabled = false
//        chart.drawBordersEnabled = false
        
        chart.data = data
    }
    
    func itemclick(userid:NSNumber){
            createdBy = userid
            if(createdBy ==  self.activeuser?.userID ?? 0){
                btnLevelBack.isHidden = true
            }else{
                 btnLevelBack.isHidden = false
            }
            
   
            listReport = [VisitDashboardReport]()
            if(arrVisits?.count ?? 0 > 0){
                
                
                for visit in arrVisits ?? [[String:Any]](){
                    let objreport = VisitDashboardReport().initwithdict(dic: visit)
               
                    listReport?.append(objreport)
                }
                levelReport = [VisitDashboardReport]()
                if(listReport?.count ?? 0 > 0){
                 
                    var blueReportList:[VisitDashboardReport] = [VisitDashboardReport]()
                    var redReportList:[VisitDashboardReport] = [VisitDashboardReport]()
                    var tempblueReportList:[VisitDashboardReport]  =   [VisitDashboardReport]()
                    var tempredReportList:[VisitDashboardReport]  = [VisitDashboardReport]()
    //                for vdr1 in listReport ?? [VisitDashboardReport](){
    //                    print(vdr1.UserID)
    //                    print(vdr1.managerID)
    //                    print(createdBy)
    //                }
                for vdr in 0...(listReport?.count ?? 0)-1{
                        if  let visitdashboard  = listReport?[vdr] as? VisitDashboardReport{
    //                print("Created by \(createdBy) and userid of visit is \(visitdashboard.UserID) and manager id \(visitdashboard.managerID) and loweuser \(visitdashboard.lowerHierarchyUsers)")
    //                    print("Type of = \(type(of: createdBy)), and type of manager id = \((type(of:visitdashboard.managerID)))")
                            let numberUserID = visitdashboard.UserID! as NSNumber
                            let numberManagerID =  visitdashboard.managerID! as NSNumber
                        let numberDottedManagerID = visitdashboard.DottedManagerID! as NSNumber
                            print("lower hierarchy count = \(visitdashboard.lowerHierarchyUsers?.count) , name = \(visitdashboard.UserName) and numberUSerID = \(numberUserID) and created by = \(createdBy) , dotted namanger id = \(numberDottedManagerID) || manager id = \(numberManagerID)")
                        if let createdbyid = createdBy {
                            
                            if(createdbyid == numberUserID){
                              
                                visitdashboard.ColorCode =  NSNumber.init(value: 1) as? NSInteger
                       
                                levelReport?.append(visitdashboard)
                            }else if(createdbyid == numberManagerID && visitdashboard.lowerHierarchyUsers?.count ?? 0 > 0){
                                visitdashboard.ColorCode = NSNumber.init(value: 2) as? NSInteger
                               
                                tempblueReportList.append(visitdashboard)
                          
                            }
                            else if(createdbyid  == numberManagerID  && visitdashboard.lowerHierarchyUsers?.count ?? 0 ==  0){
                                visitdashboard.ColorCode = NSNumber.init(value: 3) as? NSInteger
                                
                                tempredReportList.append(visitdashboard)
                        
                            }else if(createdbyid == numberDottedManagerID && visitdashboard.lowerHierarchyUsers?.count ?? 0 > 0){
                                visitdashboard.ColorCode = NSNumber.init(value: 2) as? NSInteger
                               
                                tempblueReportList.append(visitdashboard)
                          
                            }
                            else if(createdbyid  == numberDottedManagerID  && visitdashboard.lowerHierarchyUsers?.count ?? 0 ==  0){
                                visitdashboard.ColorCode = NSNumber.init(value: 3) as? NSInteger
                                
                                tempredReportList.append(visitdashboard)
                        
                            }
                        }
                            
                        }
                    }
                
//                    if(CompanyUsers().getUser(userId: createdBy ?? 0)?.role_id == NSNumber.init(value: 5)){
//
//                             if(tempblueReportList.count ?? 0 > 0){
//                                 for tbvdr in  0...tempblueReportList.count - 1{
//
//                          if  let  visitreport = tempblueReportList[tbvdr] as? VisitDashboardReport{
//                        if(visitreport.RoleID == 6){
//
//                       if(listReport?.count ?? 0 > 0){
//                    for lvdr in 0...(listReport?.count ?? 0)-1{
//
//                    if(tempblueReportList[tbvdr].UserID == listReport?[lvdr].managerID){
//                        if(listReport?[lvdr].lowerHierarchyUsers?.count == 0){
//
//                        listReport?[lvdr].ColorCode = NSNumber.init(value: 3) as? NSInteger
//                        tempredReportList.append(listReport?[lvdr] ?? VisitDashboardReport())
//
//                        }else if (listReport?[lvdr].lowerHierarchyUsers?.count ?? 0 > 0){
//                            listReport?[lvdr].ColorCode = NSNumber.init(value: 2) as? NSInteger
//                            tempblueReportList.append(listReport?[lvdr] ?? VisitDashboardReport())
//
//                         }
//                        }else if(tempblueReportList[tbvdr].UserID == listReport?[lvdr].DottedManagerID){
//                            if(listReport?[lvdr].lowerHierarchyUsers?.count == 0){
//                                listReport?[lvdr].ColorCode = NSNumber.init(value: 3) as? NSInteger
//                                tempredReportList.append(listReport?[lvdr] ?? VisitDashboardReport())
//                            }else if (listReport?[lvdr].lowerHierarchyUsers?.count ?? 0 > 0){
//                                listReport?[lvdr].ColorCode = NSNumber.init(value: 2) as? NSInteger
//                                tempblueReportList.append(listReport?[lvdr] ?? VisitDashboardReport())
//
//                             }
//                        }
//                    }
//                                        }
//                                            }
//
//                                    }
//                                }
//                        }
//                    }
                    if(tempblueReportList.count > 0){
                        for tbrl in 0...tempblueReportList.count-1{
                         
                            if(tempblueReportList[tbrl].RoleID ?? 0 > 5){ //replace 6  with 5 as per
                blueReportList.append(tempblueReportList[tbrl])
                            }
                        }
                    }
                    
                    if(tempredReportList.count > 0){
                        for trvdl in 0...tempredReportList.count-1{
                            if(tempredReportList[trvdl].RoleID ?? 0 > 5){ //replace 6  with 5 as per
                                redReportList.append(tempredReportList[trvdl])
                            }
                        }
                    }
                               
                    if(blueReportList.count > 0){
                    
                    for bvdrl in 0...blueReportList.count-1{
                        let parts = blueReportList[bvdrl].lowerHierarchyUsers?.components(separatedBy: ",")
                        var totalActualVisit = blueReportList[bvdrl].ActualVisit
                        var totalPlannedVisit = blueReportList[bvdrl].PlannedVisit
                        var totalMissedVisit = blueReportList[bvdrl].MissedVisit
                        var totalUpdatedVisit = blueReportList[bvdrl].UpdatedVisit
                        
                if(parts?.count ?? 0 > 0){
                for part in 0...(parts?.count ?? 0) - 1{
                if(listReport?.count ?? 0 > 0){
                                    
                for lvdr in listReport ?? [VisitDashboardReport](){
                                     
                if(parts?[part].count ?? 0 > 0){
                                let userId = Int(parts?[part] ?? "0")
                                if(userId == lvdr.UserID){
                                if var tActualVisit = totalActualVisit as? NSInteger{
                                tActualVisit += lvdr.ActualVisit ?? 0
                                totalActualVisit = tActualVisit
                                }
                                
                                if var tPlannedVisit  = totalPlannedVisit as? NSInteger{
                                tPlannedVisit += lvdr.PlannedVisit ?? 0
                                totalPlannedVisit = tPlannedVisit
                                }
                                                
                                if var tMissedVisit   = totalMissedVisit as? NSInteger{
                                tMissedVisit += lvdr.MissedVisit ?? 0
                                totalMissedVisit = tMissedVisit
                                                                                        }
                                if var tUpdatedVisit  = totalUpdatedVisit  as? NSInteger{
                                tUpdatedVisit += lvdr.UpdatedVisit ?? 0
                                totalUpdatedVisit = tUpdatedVisit
                                            }
                                            break
                                            }
                                        }

                               }
                                
                                }
                            }
                        }
                        blueReportList[bvdrl].ActualVisit = totalActualVisit
                        blueReportList[bvdrl].PlannedVisit = totalPlannedVisit
                        blueReportList[bvdrl].MissedVisit =  totalMissedVisit
                        blueReportList[bvdrl].UpdatedVisit = totalUpdatedVisit
                       
                      levelReport?.append(blueReportList[bvdrl])
                    }
                    }
                    for rvdr in redReportList{
                     
                        levelReport?.append(rvdr)
                    }
                    
                    if(levelReport?.count ?? 0 > 0){
                        var plan = 0
                        var act = 0
                        var miss = 0
                        var uptd = 0
                        
                        for lvdr in levelReport ?? [VisitDashboardReport](){
                            plan += lvdr.PlannedVisit ?? 0
                            act += lvdr.ActualVisit ?? 0
                            miss += lvdr.MissedVisit ?? 0
                            uptd += lvdr.UpdatedVisit ?? 0
                        }
                        lblPlanned.text = String.init(format: "\(plan) planned", [])
                        lblPlanned.isHidden = false
                        lblRupees.isHidden = true
                        lblOrders.isHidden = true
                        tblSalesVisit.tableFooterView?.isHidden = false
                        if(miss > 0 || act > 0 || uptd > 0 ){
                            totalVisitChart.isHidden = false
                            self.setDataCount([act,miss,uptd], range: 50, chart: totalVisitChart)
                        }else{
                            totalVisitChart.isHidden = true
                        }
                       
                    }
                }else{
                     tblSalesVisit.tableFooterView?.isHidden = true
                }
              //  print("item of count = \(levelReport)")
                 tblSalesVisit.reloadData()
            }
          SVProgressHUD.dismiss()
            
        }
    
    //MARK: - IBAction
    @IBAction func btnBackClicked(_ sender: UIButton) {
       
        let report = levelReport?.first
            createdBy = NSNumber.init(value:report?.managerID ?? 0)
        if(CompanyUsers().getUser(userId: createdBy ?? 0)?.role_id == NSNumber.init(value:6)){
            self.itemclick(userid: self.activeuser?.userID ?? 0)
        }else{
            self.itemclick(userid: createdBy ?? 0)
        }
        
    }
    
        
    
    //MARK: - API Call
    func getvisitForDashboard(){
       SVProgressHUD.show(withStatus: "Loading")
    print("api for update called ")
        self.apihelper.getVisitDashboard(strurl: ConstantURL.kWSUrlGetVisitReportForDay, selecteduserID: SalesPlanHome.selectedUserID.stringValue, selectedDate: SalesPlanHome.selectedDate) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    print(responseType)
                      SVProgressHUD.dismiss()
                    if(responseType == ResponseType.arr){
                        self.arrVisits =  arr as? [[String:Any]] ?? [[String:Any]]()
                       
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
extension DashboardVisit:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return levelReport?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let dashboardvisitcell = tableView.dequeueReusableCell(withIdentifier: "dashboardcell", for: indexPath) as? DashboardCell{
                   
                    if let visitreport =  levelReport?[indexPath.row] as? VisitDashboardReport{
                        dashboardvisitcell.lbl1.text = visitreport.UserName
                  //  dashboardvisitcell.detailTextLabel?.text = String.init(format:"%@",visitreport?.PlannedVisit ?? "0")
                        print("\(visitreport.ActualVisit) , \(visitreport.PlannedVisit) ,\(visitreport.MissedVisit) , \(indexPath.row)")
                dashboardvisitcell.setDashboardVisitData(report: visitreport, indexpath: indexPath)
                    }
                   
                    
                    
                return dashboardvisitcell
                }else{
                    return UITableViewCell()
                }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
                    if let report = levelReport?[indexPath.row] as? VisitDashboardReport{
                        if(report.ColorCode == NSInteger.init(CGFloat(2))){
                            self.itemclick(userid: NSNumber.init(value:report.UserID ?? 0))
                        }else{
                            if let reportview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ReportList) as? Reports{
                                reportview.selectedUserID =  NSNumber.init(value:report.UserID ?? 0)
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
extension DashboardVisit:BaseViewControllerDelegate{
    
}
extension DashboardVisit:SalesPlanHomedelegate{
    func dateselectionsalesplandone(date: Date) {
        print(date)
        self.getvisitForDashboard()
    }
//    func showCameraPicker(){
//        
//    }
    
}
