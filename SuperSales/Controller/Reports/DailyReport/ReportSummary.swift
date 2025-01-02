//
//  ReportSummary.swift
//  SuperSales
//
//  Created by mac on 04/03/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit

class ReportSummary: BaseViewController {

    @IBOutlet weak var tblReportSummary: UITableView!
    var haveToDisplayAttendance = false
    var numberOfTitle = 0
    static var objReportSummary:ReportSummaryModel!
    var refreshControl = UIRefreshControl.init()
    var totalUniqueRetailer :Int = 0
    var totalValue :Int = 0
    var totalQuantity :Int = 0
    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            super.viewDidLoad()
            self.setUI()
            self.refreshControl.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
            if #available(iOS 10.0, *) {
                self.tblReportSummary.refreshControl = self.refreshControl
            } else {
                // Fallback on earlier versions
                self.tblReportSummary.addSubview(self.refreshControl)
            }
            self.tblReportSummary?.reloadData()
        })
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self,selector: #selector(updateSummaryData),
                                               name:Notification.Name(ConstantURL.UPDATE_DASHBOARD_SUMMARY),
                                               object: nil)//
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantURL.UPDATE_DASHBOARD_SUMMARY), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      
        
      
        tblReportSummary.reloadData()
    }
    
    
    //MARK: - Method
    @objc func updateSummaryData(){
        self.tblReportSummary?.reloadData()
    }
    func setUI(){
        tblReportSummary.setCommonFeature()
        tblReportSummary.delegate = self
        tblReportSummary.dataSource = self
        tblReportSummary.reloadData()
        if(self.activeuser?.role?.id == NSNumber.init(value: 5) || self.activeuser?.role?.id == NSNumber.init(value: 6)){
            haveToDisplayAttendance = false
        }else{
            haveToDisplayAttendance = true
        }
       
       
    }
    
    @objc func loadData(){
        NotificationCenter.default.post(name: NSNotification.Name("getDailyReports"), object: nil)
        tblReportSummary?.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    
    func fillData(summaryData:[[String:Any]]){
       // tblReportSummary.reloadData()
//        for leadsummary in summaryData{
//
//        }
        if(summaryData.count > 0){
            ReportSummary.objReportSummary = ReportSummaryModel.init(dictionary: summaryData.first! as NSDictionary)
            totalValue = 0
            totalQuantity = 0
            totalUniqueRetailer = 0
            for category in ReportSummary.objReportSummary.mtdOrderCategory{
                totalValue += category.orderTotal
                totalQuantity += category.orderCount
                totalUniqueRetailer += category.uniqueRetailer
            }
            print("Total  = \(totalValue) , \(totalQuantity) , \(totalUniqueRetailer)")
            tblReportSummary?.reloadData()
        }else{
            totalValue = 0
            totalQuantity = 0
            totalUniqueRetailer = 0
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
extension ReportSummary:UITableViewDelegate,UITableViewDataSource{

 

    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let obj = ReportSummary.objReportSummary{
    if(haveToDisplayAttendance){
        return 31 + ReportSummary.objReportSummary.mtdOrderCategory.count//31 + ReportSummary.objReportSummary.mtdOrderCategory.count
    }else{
        return 23 + ReportSummary.objReportSummary.mtdOrderCategory.count //24 + ReportSummary.objReportSummary.mtdOrderCategory.count
    }
    }else{
        return 0 
    }
   // return 2//totalnumberofRecord + leadsummary.byLeadProductCategoryList.count  + leadsummary.byLeadStatusList.count + leadsummary.byLeadSourceList.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if(haveToDisplayAttendance){
    if(indexPath.row == 0){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
       // cell.textLabel?.layoutMargins =  CGRect.init(x: 5, y: 0, width: cell.frame.size.width - 10, height: 40)
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 19)
        cell.textLabel?.text = "Attendance"
       // cell.textLabel?.drawText(in: CGRect.init(x: 0, y: 0, width: cell.frame.size.width, height: 40))
        cell.textLabel?.drawText(in: CGRect.init(x: -10, y: 0, width: cell.frame.size.width + 20 , height: 30))
        numberOfTitle += 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.contentView.frame = CGRect.init(x: 15, y: 0, width: cell.frame.size.width - 30, height: 40)
        cell.contentView.backgroundColor = UIColor.Appthemecolor
        return cell
    }else if(indexPath.row < 7){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
            cell.selectionStyle = .none
            switch indexPath.row {
            case 1:
              //  cell.contentView.backgroundColor =   UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl1.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                //if(indexPath.section == 0){
                    cell.lbl2.font = UIFont.boldSystemFont(ofSize: 14)
                    cell.lbl3.font = UIFont.boldSystemFont(ofSize: 14)
                //}
                cell.lbl1.text = " "
                cell.lbl2.text = "In"
                cell.lbl3.text = "Out"
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                
                break
                
            case 2:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.textAlignment = .left
                cell.lbl1.text = "Today"
                cell.lbl1.textColor = UIColor.blue
               // if(ReportSummary.objReportSummary.attendanc0xFAFAFA
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl3.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                if(ReportSummary.objReportSummary.attendanceTodayIn?.count ?? 0 > 0){
                    cell.lbl2.text = Utils.getDatestringWithGMT(gmtDateString:ReportSummary.objReportSummary.attendanceTodayIn ?? "", format: "hh:mm a")
                }else{
                    cell.lbl2.text = "----"
                }
                if(ReportSummary.objReportSummary.attendanceTodayOut?.count ?? 0 > 0){
                    cell.lbl3.text = Utils.getDatestringWithGMT(gmtDateString:ReportSummary.objReportSummary.attendanceTodayOut ?? "", format: "hh:mm a")
                }else{
                    cell.lbl3.text = "----"
                }
               
                break
            case 3:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.textAlignment = .left
                cell.lbl1.text = "Y'day"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl3.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                if(ReportSummary.objReportSummary.attendanceYesterdayIn?.count ?? 0 > 0){
                    cell.lbl2.text = Utils.getDatestringWithGMT(gmtDateString:ReportSummary.objReportSummary.attendanceYesterdayIn ?? "", format: "hh:mm a")
                }else{
                    cell.lbl2.text = "----"
                }
                if(ReportSummary.objReportSummary.attendanceYesterdayOut?.count ?? 0 > 0){
                    cell.lbl3.text = Utils.getDatestringWithGMT(gmtDateString: ReportSummary.objReportSummary.attendanceYesterdayOut ?? "", format: "hh:mm a")//ReportSummary.objReportSummary.attendanceYesterdayOut
                }else{
                    cell.lbl3.text = "----"
                }
               
                break
                
                
            case 4:
                cell.lbl1.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl1.text = " "
                cell.lbl2.text = "Days Present"
                cell.lbl3.text = "Hours Worked"
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                break
                
            case 5:
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl3.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl1.textAlignment = .left
                cell.lbl1.text = "MTD"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text =  String.init(format:"\(ReportSummary.objReportSummary.attendanceMTDDaysPresent)")
                if let strlastworked = ReportSummary.objReportSummary.attendanceMTDHourWorked as? String{
                    cell.lbl3.text = String.init(format:"\(strlastworked)")
                }else{
                    cell.lbl3.text = ""
                }
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                break
                
            case 6:
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl3.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl1.textAlignment = .left
                cell.lbl1.text = "Last Month"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.attendanceLastMonthDaysPresent)")
                if let strlastworked = ReportSummary.objReportSummary.attendanceLastMonthHourWorked as? String{
                    cell.lbl3.text = String.init(format:"\(strlastworked)")
                }else{
                    cell.lbl3.text = ""
                }
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                break
                
            default:
                print("\("default case") ,\(indexPath.row)")
            }
           
            
         
            return cell
        }else{
            return UITableViewCell()
        }
    }else if(indexPath.row == 7){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 19)
        cell.textLabel?.text = "Visits"
       
        numberOfTitle += 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.Appthemecolor
        return cell
    }else if(indexPath.row < 10){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
            cell.selectionStyle = .none
            if(indexPath.row == 8){
                cell.lbl1.text = "Today's Beat"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl3.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl2.text = ReportSummary.objReportSummary.visitTodayBeat
                cell.lbl3.isHidden = true
            }
            if(indexPath.row == 9){
                cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl1.text = "Yesterday's Beat"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl3.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl2.text = ReportSummary.objReportSummary.visitYesterdayBeat
                cell.lbl3.isHidden = true
            }
            return cell
        }else{
        return UITableViewCell()
    }
    }else if(indexPath.row < 16){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "fivelblhorizontalcell", for: indexPath) as? FivelblHorizontalCell{
            cell.selectionStyle = .none
            if((indexPath.row )%2 == 0){
              // cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
            }else{
              // cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
               
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
            }
            switch indexPath.row {
            
            case 10:
                cell.lbl1.font = UIFont.systemFont(ofSize: 14)
                cell.lbl2.font = UIFont.systemFont(ofSize: 14)
                cell.lbl3.font = UIFont.systemFont(ofSize: 14)
                cell.lbl4.font = UIFont.systemFont(ofSize: 14)
                cell.lbl5.font = UIFont.systemFont(ofSize: 14)
                cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl1.text = ""
                cell.lbl2.text = "Done"
                cell.lbl3.text = "Missed"
                cell.lbl4.text = "Updated"
                cell.lbl5.text = "Productive"
                cell.lbl4.setMultilineLabel(lbl: cell.lbl4)
                cell.lbl5.setMultilineLabel(lbl: cell.lbl5)
//                cell.lbl1.adjustsFontSizeToFitWidth = true
//                cell.lbl2.adjustsFontSizeToFitWidth = true
//                cell.lbl3.adjustsFontSizeToFitWidth = true
//                cell.lbl4.adjustsFontSizeToFitWidth = true
//                cell.lbl5.adjustsFontSizeToFitWidth = true
                
                
                break
            case 11:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Today"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.VisitTodayDone)")
                cell.lbl3.text =  String.init(format:"\(ReportSummary.objReportSummary.VisitTodayMissed)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.VisitTodayUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.VisitTodayProductive)")
                break
                
            case 12:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Y'day"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.VisitYesterdayDone)")
                cell.lbl3.text =  String.init(format:"\(ReportSummary.objReportSummary.VisitYesterdayMissed)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.VisitYesterdayUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.VisitYesterdayProductive)")
                break
                
            case 13:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "MTD"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDDone)")
                cell.lbl3.text =  String.init(format:"\(ReportSummary.objReportSummary.VisitMTDMissed)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDProductive)")
                break
                
            case 14:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "MTD Unique"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDUniqueDone)")
                cell.lbl3.text =  String.init(format:"\(ReportSummary.objReportSummary.VisitMTDUniqueMissed)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDUniqueUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDUniqueProductive)")
                break
                
            case 15:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Last Month"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.VisitLastMonthDone)")
                cell.lbl3.text =  String.init(format:"\(ReportSummary.objReportSummary.VisitLastMonthMissed)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.VisitLastMonthUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.VisitLastMonthProductive)")
                break
            default:
                print("\("default case") ,\(indexPath.row)")
            }
            
            return cell
        }else{
        return UITableViewCell()
    }
    }else if(indexPath.row == 16){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 19)
       
            cell.textLabel?.text = "Orders"
        
        numberOfTitle += 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.Appthemecolor
        return cell
    } else if(indexPath.row < 22){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "fourlblhorizontalcell", for: indexPath) as? FourlblHorizontalCell{
        cell.selectionStyle = .none
            if((indexPath.row )%2 == 0){
              // cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
              
            }else{
              // cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
               
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
              
            }
            switch indexPath.row {
            case 17:
                cell.lbl1.text = ""
                cell.lbl2.text = "Count"
                cell.lbl3.text = "Value"
                cell.lbl4.text = "Unique Retailers"
                cell.lbl1.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl2.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.setMultilineLabel(lbl: cell.lbl4)
                cell.lbl1.backgroundColor = UIColor.white
              
                
                
                break
                
            case 18:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Today"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.OrderTodayCount)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.OrderTodayValue)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.OrderTodayUniqueRetailer)")
                break
                
            case 19:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Y'day"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.OrderYesterdayCount)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.OrderYesterdayValue)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.OrderYesterdayUniqueRetailer)")
                break
                
            case 20:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "MTD"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.OrderMTDCount)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.OrderMTDValue)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.OrderMTDUniqueRetailer)")
                break
                
                
            case 21:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.setMultilineLabel(lbl: cell.lbl1)
                cell.lbl1.text = "Last Month"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.OrderLastMonthCount)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.OrderLastMonthValue)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.OrderLastMonthUniqueRetailer)")
                cell.lbl4.setMultilineLabel(lbl: cell.lbl4)
                break
            default:
                print("\("default case") ,\(indexPath.row)")
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }else if(indexPath.row == 22){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 19)
       
        cell.textLabel?.text = "MTD Order Category Breakup"
        
        numberOfTitle += 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.Appthemecolor
        return cell
    }else if(indexPath.row  == 23){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "fourlblhorizontalcell", for: indexPath) as? FourlblHorizontalCell{
        cell.selectionStyle = .none
            if((indexPath.row )%2 == 0){
              // cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
             
            }else{
              // cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
               
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
               
            }
        switch indexPath.row {
                    case 23:
                        cell.lbl1.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                        cell.lbl1.text = ""
                        cell.lbl2.text = "Unique Retailers"
                        cell.lbl3.text = "Value"
                        cell.lbl4.text = "Total Qty"
                        cell.lbl2.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl4.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl2.setMultilineLabel(lbl: cell.lbl2)
                        break
        default:
            print("\("default case") ,\(indexPath.row)")
        }
            return cell
        }else{
            return UITableViewCell()
        }
    }
       else if(indexPath.row < (25 + ReportSummary.objReportSummary.mtdOrderCategory.count)){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "fourlblhorizontalcell", for: indexPath) as? FourlblHorizontalCell{
        cell.selectionStyle = .none

            if(indexPath.row > 23 && indexPath.row < 24 + ReportSummary.objReportSummary.mtdOrderCategory.count){
                let selectedordercat = ReportSummary.objReportSummary.mtdOrderCategory[indexPath.row - 24]
                cell.lbl1.text = selectedordercat.CategoryName
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl2.text =  String.init(format:"\(selectedordercat.uniqueRetailer)")
                cell.lbl3.text =  String.init(format:"\(selectedordercat.orderTotal)")
                cell.lbl4.text =  String.init(format:"\(selectedordercat.orderCount)")
            }else{
                cell.lbl1.text = "Total"
                print("Total in table \(totalUniqueRetailer)")
                totalValue = 0
                totalQuantity = 0
                totalUniqueRetailer = 0
                for category in ReportSummary.objReportSummary.mtdOrderCategory{
                    totalValue += category.orderTotal
                    totalQuantity += category.orderCount
                    totalUniqueRetailer += category.uniqueRetailer
                }
                cell.lbl2.text =  String.init(format:"\(totalUniqueRetailer)")
                cell.lbl3.text = String.init(format:"\(totalValue)")
                cell.lbl4.text =  String.init(format:"\(totalQuantity)")
                
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }else if(indexPath.row == 25 + ReportSummary.objReportSummary.mtdOrderCategory.count){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
       
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 19)
        cell.textLabel?.text = "Leads"
        
        numberOfTitle += 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.Appthemecolor
        return cell
    }else if(indexPath.row < 31 + ReportSummary.objReportSummary.mtdOrderCategory.count){
       
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "sixlblhorizontalcell", for: indexPath) as? SixlblHorizontalCell{
        cell.selectionStyle = .none
            if((indexPath.row - 26 - ReportSummary.objReportSummary.mtdOrderCategory.count)%2 == 0){
              // cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
            }else{
              // cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
               
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
            }
            switch indexPath.row - 26 - ReportSummary.objReportSummary.mtdOrderCategory.count {
            case 0:
                cell.lbl1.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl1.text = ""
                cell.lbl2.text = "Generated"
                cell.lbl3.text = "Assigned"
                cell.lbl4.text = "Updated"
                cell.lbl5.text = "Won"
                cell.lbl6.text = "Lost"
                cell.lbl2.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl6.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                
                cell.lbl2.setMultilineLabel(lbl: cell.lbl2)
                cell.lbl3.setMultilineLabel(lbl: cell.lbl3)
                cell.lbl4.setMultilineLabel(lbl: cell.lbl4)
                break
                
            case 1:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Today"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.LeadTodayGenerated)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.LeadTodayAssigned)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.LeadTodayUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.LeadTodayWon)")
                cell.lbl6.text = String.init(format:"\(ReportSummary.objReportSummary.LeadTodayLost)")
                break
                
            case 2:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Y'day"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.LeadYesterdayGenerated)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.LeadYesterdayAssigned)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.LeadYesterdayUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.LeadYesterdayWon)")
                cell.lbl6.text = String.init(format:"\(ReportSummary.objReportSummary.LeadYesterdayLost)")
                break
                
            case 3:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "MTD"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.LeadMTDGenerated)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.LeadMTDAssigned)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.LeadMTDUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.LeadMTDWon)")
                cell.lbl6.text = String.init(format:"\(ReportSummary.objReportSummary.LeadMTDLost)")
                break
                
                
            case 4:
                cell.lbl1.setMultilineLabel(lbl: cell.lbl1)
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Last Month"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.LeadLastMonthGenerated)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.LeadLastMonthAssigned)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.LeadLastMonthUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.LeadLastMonthWon)")
                cell.lbl6.text = String.init(format:"\(ReportSummary.objReportSummary.LeadLastMonthLost)")
                cell.lbl4.setMultilineLabel(lbl: cell.lbl4)
                break
           
            default:
                print("\("default case") ,\(indexPath.row) after lead , \(indexPath.row - 24 - ReportSummary.objReportSummary.mtdOrderCategory.count)")
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }else{
        print(indexPath.row)
        return UITableViewCell()
    }
    
}else{
    if(indexPath.row == 0){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
       
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 19)
            cell.textLabel?.text = "Visits"
        
        numberOfTitle += 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.Appthemecolor
        return cell
    }else if(indexPath.row < 3){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
            cell.selectionStyle = .none
            if(indexPath.row == 1){
                cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl1.text = "Today's Beat"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = ReportSummary.objReportSummary.visitTodayBeat
                cell.lbl3.isHidden =  true
            }
            if(indexPath.row == 2){
                cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl1.text = "Yesterday's Beat"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = ReportSummary.objReportSummary.visitYesterdayBeat
                cell.lbl3.isHidden =  true
            }
            return cell
        }else{
        return UITableViewCell()
    }
    }else if(indexPath.row < 9){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "fivelblhorizontalcell", for: indexPath) as? FivelblHorizontalCell{
            cell.selectionStyle = .none
            if(indexPath.row == 3){
                cell.lbl1.text = ""
                cell.lbl2.text = "Done"
                cell.lbl3.text = "Missed"
                cell.lbl4.text = "Updated"
                cell.lbl5.text = "Productive"
                cell.lbl4.setMultilineLabel(lbl: cell.lbl4)
                cell.lbl5.setMultilineLabel(lbl: cell.lbl5)
                cell.lbl1.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
            }
            switch indexPath.row {
            case 4:
                cell.lbl1.backgroundColor =  UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Today"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.VisitTodayDone)")
                cell.lbl3.text =  String.init(format:"\(ReportSummary.objReportSummary.VisitTodayMissed)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.VisitTodayUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.VisitTodayProductive)")
                break
                
            case 5:
                cell.lbl1.backgroundColor =  UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Y'day"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.VisitYesterdayDone)")
                cell.lbl3.text =  String.init(format:"\(ReportSummary.objReportSummary.VisitYesterdayMissed)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.VisitYesterdayUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.VisitYesterdayProductive)")
                break
                
            case 6:
                cell.lbl1.backgroundColor =  UIColor.AppthemeAqvacolor
                cell.lbl1.text = "MTD"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDDone)")
                cell.lbl3.text =  String.init(format:"\(ReportSummary.objReportSummary.VisitMTDMissed)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDProductive)")
                break
                
            case 7:
                cell.lbl1.backgroundColor =  UIColor.AppthemeAqvacolor
                cell.lbl1.text = "MTD Unique"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDUniqueDone)")
                cell.lbl3.text =  String.init(format:"\(ReportSummary.objReportSummary.VisitMTDUniqueMissed)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDUniqueUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.VisitMTDUniqueProductive)")
                break
                
            case 8:
                cell.lbl1.backgroundColor =  UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Last Month"
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.VisitLastMonthDone)")
                cell.lbl3.text =  String.init(format:"\(ReportSummary.objReportSummary.VisitLastMonthMissed)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.VisitLastMonthUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.VisitLastMonthProductive)")
                break
            default:
                print("\("default case") ,\(indexPath.row)")
            }
            
            return cell
        }else{
        return UITableViewCell()
        }
    }else if(indexPath.row == 9){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
       
       
            cell.textLabel?.text = "Orders"
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 19)
        numberOfTitle += 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.Appthemecolor
        return cell
    }else if(indexPath.row < 15){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "fourlblhorizontalcell", for: indexPath) as? FourlblHorizontalCell{
        cell.selectionStyle = .none
            switch indexPath.row {
            case 10:
                cell.lbl1.text = ""
                cell.lbl2.text = "Count"
                cell.lbl3.text = "Value"
                cell.lbl4.text = "Unique Retailers"
                cell.lbl4.setMultilineLabel(lbl: cell.lbl4)
                cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                
                
                break
                
            case 11:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Today"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.OrderTodayCount)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.OrderTodayValue)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.OrderTodayUniqueRetailer)")
                break
                
            case 12:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Y'day"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.OrderYesterdayCount)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.OrderYesterdayValue)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.OrderYesterdayUniqueRetailer)")
                break
                
            case 13:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "MTD"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.OrderMTDCount)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.OrderMTDValue)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.OrderMTDUniqueRetailer)")
                break
                
                
            case 14:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.setMultilineLabel(lbl: cell.lbl1)
                cell.lbl1.text = "Last Month"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.OrderLastMonthCount)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.OrderLastMonthValue)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.OrderLastMonthUniqueRetailer)")
                cell.lbl4.setMultilineLabel(lbl: cell.lbl4)
                break
            default:
                print("\("default case") ,\(indexPath.row)")
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }else if(indexPath.row == 15){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 19)
       
        cell.textLabel?.text = "MTD Order Category Breakup"
        
        numberOfTitle += 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.Appthemecolor
        return cell
    }else if(indexPath.row  == 16){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "fourlblhorizontalcell", for: indexPath) as? FourlblHorizontalCell{
        cell.selectionStyle = .none
        switch indexPath.row {
                    case 16:
                        cell.lbl1.text = ""
                        cell.lbl2.text = "Unique Retailers"
                        cell.lbl3.text = "Value"
                        cell.lbl4.text = "Total Qty"
                        cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                        cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl2.setMultilineLabel(lbl: cell.lbl2)
                        break
        default:
            print("\("default case") ,\(indexPath.row)")
        }
            return cell
        }else{
            return UITableViewCell()
        }
    }
       else if(indexPath.row < (17 + ReportSummary.objReportSummary.mtdOrderCategory.count)){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "fourlblhorizontalcell", for: indexPath) as? FourlblHorizontalCell{
        cell.selectionStyle = .none

            if(indexPath.row > 16 && indexPath.row < 16 + ReportSummary.objReportSummary.mtdOrderCategory.count){
                let selectedordercat = ReportSummary.objReportSummary.mtdOrderCategory[indexPath.row - 17]
                cell.lbl1.text = selectedordercat.CategoryName
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl2.text =  String.init(format:"\(selectedordercat.uniqueRetailer)")
                cell.lbl3.text =  String.init(format:"\(selectedordercat.orderTotal)")
                cell.lbl4.text =  String.init(format:"\(selectedordercat.orderCount)")
            }else{
                cell.lbl1.text = "Total"
                print("Total in table \(totalUniqueRetailer)")
                totalValue = 0
                totalQuantity = 0
                totalUniqueRetailer = 0
                for category in ReportSummary.objReportSummary.mtdOrderCategory{
                    totalValue += category.orderTotal
                    totalQuantity += category.orderCount
                    totalUniqueRetailer += category.uniqueRetailer
                }
                cell.lbl2.text =  String.init(format:"\(totalUniqueRetailer)")
                cell.lbl3.text = String.init(format:"\(totalValue)")
                cell.lbl4.text =  String.init(format:"\(totalQuantity)")
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }else if(indexPath.row == 17 + ReportSummary.objReportSummary.mtdOrderCategory.count){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 19)
       
        cell.textLabel?.text = "Leads"
        
        numberOfTitle += 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.Appthemecolor
        return cell
    }else if(indexPath.row < 23 + ReportSummary.objReportSummary.mtdOrderCategory.count){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "sixlblhorizontalcell", for: indexPath) as? SixlblHorizontalCell{
        cell.selectionStyle = .none
            switch indexPath.row - 18 - ReportSummary.objReportSummary.mtdOrderCategory.count {
            case 0:
                cell.lbl1.text = ""
                cell.lbl2.text = "Generated"
                cell.lbl3.text = "Assigned"
                cell.lbl4.text = "Updated"
                cell.lbl5.text = "Won"
                cell.lbl6.text = "Lost"
                cell.lbl1.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl6.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                
                cell.lbl2.setMultilineLabel(lbl: cell.lbl2)
                cell.lbl3.setMultilineLabel(lbl: cell.lbl3)
                cell.lbl4.setMultilineLabel(lbl: cell.lbl4)
                break
                
            case 1:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Today"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.LeadTodayGenerated)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.LeadTodayAssigned)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.LeadTodayUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.LeadTodayWon)")
                cell.lbl6.text = String.init(format:"\(ReportSummary.objReportSummary.LeadTodayLost)")
                break
                
            case 2:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Y'day"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.LeadYesterdayGenerated)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.LeadYesterdayAssigned)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.LeadYesterdayUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.LeadYesterdayWon)")
                cell.lbl6.text = String.init(format:"\(ReportSummary.objReportSummary.LeadYesterdayLost)")
                break
                
            case 3:
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "MTD"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.LeadMTDGenerated)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.LeadMTDAssigned)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.LeadMTDUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.LeadMTDWon)")
                cell.lbl6.text = String.init(format:"\(ReportSummary.objReportSummary.LeadMTDLost)")
                break
                
                
            case 4:
                cell.lbl1.setMultilineLabel(lbl: cell.lbl1)
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.text = "Last Month"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.text = String.init(format:"\(ReportSummary.objReportSummary.LeadLastMonthGenerated)")
                cell.lbl3.text = String.init(format:"\(ReportSummary.objReportSummary.LeadLastMonthAssigned)")
                cell.lbl4.text = String.init(format:"\(ReportSummary.objReportSummary.LeadLastMonthUpdated)")
                cell.lbl5.text = String.init(format:"\(ReportSummary.objReportSummary.LeadLastMonthWon)")
                cell.lbl6.text = String.init(format:"\(ReportSummary.objReportSummary.LeadLastMonthLost)")
                cell.lbl4.setMultilineLabel(lbl: cell.lbl4)
                break
           
            default:
                print("\("default case") ,\(indexPath.row) after lead , \(indexPath.row - 24 - ReportSummary.objReportSummary.mtdOrderCategory.count)")
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }else{
        return UITableViewCell()
    }
    }
    /*else if(indexPath.row < 8 + numberOfTitle){
       if  let cell =  tableView.dequeueReusableCell(withIdentifier: "fourlblhorizontalcell", for: indexPath) as? FourlblHorizontalCell{
        cell.selectionStyle = .none
        switch indexPath.row {
        case 1:
            cell.lbl1.text = "Leads"
            cell.lbl2.text = "MTD"
            cell.lbl3.text = "Last Month"
            cell.lbl4.text = "YTD"
            
            break
        
        case 2:
            cell.lbl1.text = "Generated"
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDGenerated)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthGenerated)")
            cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDGenerated)")
            break
            
        case 3:
            cell.lbl1.text = "Assigned"
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDAssigned)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthAssigned)")
            cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDAssigned)")
            break
            
        case 4:
            cell.lbl1.text = "Status Uptd"
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDUpdated)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthUpdated)")
            cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDUpdated)")
            break
            
        case 5:
            cell.lbl1.text = "Won"
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDWon)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthWon)")
            cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDWon)")
            break
            
        case 6:
            cell.lbl1.text = "Lost"
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDLost)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthLost)")
            cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDLost)")
            break
            
        case 7:
            cell.lbl1.text = "Postponed"
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDPostponed)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthPostponed)")
            cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDPostponed)")
            break
            
        case 8:
            cell.lbl1.text = "Cancelled"
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDCancelled)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthCancelled)")
            cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDCancelled)")
            break
            
        default:
            print("default vghvjv j")
        }
        return cell
       }
       else{
       return UITableViewCell()
       }
    }else if(indexPath.row == 9){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        cell.textLabel?.text = "Active Lead Status"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.backgroundColor = UIColor.white
        return cell
       } else if(indexPath.row < 16){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
            
            cell.selectionStyle = .none
            switch indexPath.row {
            case 9:
               
                cell.lbl1.text = "Order Expected"
                cell.lbl2.text = "Count"
                cell.lbl3.text = "Amount"
                break
                
            case 10:
                cell.lbl1.font = UIFont.boldSystemFont(ofSize: 17)
                cell.lbl2.font = UIFont.boldSystemFont(ofSize: 17)
                cell.lbl3.font = UIFont.boldSystemFont(ofSize: 17)
                cell.lbl1.text = "Total"
                cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedTotalCount)")
                cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedTotalAmount)")
                break
                
                
            case 11:
            
                cell.lbl1.text = "< Previous Month"
                cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedLtPreviousMonthCount)")
                cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedLtPreviousMonthAmount)")
                break
                
                
            case 12:
            
                cell.lbl1.text = "Previous Month"
                cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedPreviousMonthCount)")
                cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedPreviousMonthAmount)")
                break
                
                
            case 13:
            
                cell.lbl1.text = "This Month"
                cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedThisMonthCount)")
                cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedThisMonthAmount)")
                break
                
                
            case 14:
            
                cell.lbl1.text = "Next Month"
                cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedNextMonthCount)")
                cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedNextMonthAmount)")
                break
                
            case 15:
            
                cell.lbl1.text = "> Next Month"
                cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedGtNextMonthCount)")
                cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedGtNextMonthAmount)")
                break
                
            default:
                print("default row")
            }
        return cell
        }
        else{
            return UITableViewCell()
        }
       }else if(indexPath.row == 16){
            let cell = UITableViewCell.init()
            cell.selectionStyle = .none
            cell.textLabel?.text = "Chances to Win"
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            cell.backgroundColor = UIColor.white
            return cell
           } else if(indexPath.row < 22){
            if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
                
                cell.selectionStyle = .none
                switch indexPath.row {
                case 17:
                
                    cell.lbl1.text = "<= 20%"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan20Count)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan20Amount)")
                    break
                    
                case 18:
                
                    cell.lbl1.text = "21 - 40%"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan21To40Count)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan21To40Amount)")
                    break
                    
                    
                case 19:
                
                    cell.lbl1.text = "41 - 60%"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan41To60Count)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan41To60Amount)")
                    break
                    
                    
                case 20:
                
                    cell.lbl1.text = "61 - 80%"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan61To80Count)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan61To80Amount)")
                    break
                    
                    
                case 21:
                
                    cell.lbl1.text = "81 - 100%"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan81To100Count)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan81To100Amount)")
                    break
                    
                    
                
                default:
                    print("default row")
                }
            return cell
            }else{
            return UITableViewCell()
            }
       }else if(indexPath.row == 22){
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        cell.textLabel?.text = "Satus"
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.backgroundColor = UIColor.white
        return cell
       } else if(indexPath.row < (23 + leadsummary.byLeadStatusList.count)){
        if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
            
            cell.selectionStyle = .none
            let selectedleadbystatus =  leadsummary.byLeadStatusList[indexPath.row - 23]
            
                cell.lbl1.text = selectedleadbystatus.StatusType
                cell.lbl2.text = String.init(format:"\(selectedleadbystatus.Count)")
                cell.lbl3.text = String.init(format:"\(selectedleadbystatus.Amount)")
                
        return cell
        }else{
        return UITableViewCell()
        }
   }else if(indexPath.row == 23 + leadsummary.byLeadStatusList.count){
    let cell = UITableViewCell.init()
    cell.selectionStyle = .none
    cell.textLabel?.text = "Active Leads by Product Category"
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.textColor = .black
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    cell.backgroundColor = UIColor.white
    return cell
   }else if(indexPath.row < (24 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count)){
    if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
        
        cell.selectionStyle = .none
        let selectedleadbyproductcategory =  leadsummary.byLeadProductCategoryList[indexPath.row - 24 - leadsummary.byLeadStatusList.count]
       
        
            cell.lbl1.text = selectedleadbyproductcategory.ProductCategory
            cell.lbl2.text = String.init(format:"\(selectedleadbyproductcategory.Count)")
            cell.lbl3.text = String.init(format:"\(selectedleadbyproductcategory.Amount)")
            
    return cell
    }else{
    return UITableViewCell()
    }
   }else if(indexPath.row == 24 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count){
    let cell = UITableViewCell.init()
    cell.selectionStyle = .none
    cell.textLabel?.text = "Active Leads by Stage"
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.textColor = .black
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    cell.backgroundColor = UIColor.white
    return cell
   }else if(indexPath.row < (25 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count + 6)){
    if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
        
        cell.selectionStyle = .none
        switch (indexPath.row - 25 - leadsummary.byLeadStatusList.count - leadsummary.byLeadProductCategoryList.count) {
        case 0:
            cell.lbl1.text = "None"
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStageNoneTotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStageNoneTotalAmount)")
        break
            
        case 1:
            cell.lbl1.text = leadsummary.LeadStageQualifiedDisplayText
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStageQualifiedTotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStageQualifiedTotalAmount)")
        break
            
        case 2:
            cell.lbl1.text = leadsummary.LeadStageTrialDisplayText
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStageTrialTotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStageTrialTotalAmount)")
        break
            
        case 3:
            cell.lbl1.text = leadsummary.LeadStageNegotiationDisplayText
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStageNegotiationTotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStageNegotiationTotalAmount)")
            break
            
        case 4:
            cell.lbl1.text = leadsummary.LeadStage5DisplayText
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStage5TotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStage5TotalAmount)")
            break
            
        case 5:
            cell.lbl1.text = leadsummary.LeadStage6DisplayText
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStage6TotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStage6TotalAmount)")
            break
            
        default:
            print("default = \(indexPath.row) , \(indexPath.row - 22 - leadsummary.byLeadStatusList.count - leadsummary.byLeadProductCategoryList.count)")
        }
       
        
            
            
    return cell
    }else{
    return UITableViewCell()
    }
   }else if(indexPath.row == 25 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count + 6)  {
    let cell = UITableViewCell.init()
    cell.selectionStyle = .none
    cell.textLabel?.text = "Active Leads by Source"
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.textColor = .black
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    cell.backgroundColor = UIColor.white
    return cell
   }else if(indexPath.row < (26 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count + 6 + leadsummary.byLeadSourceList.count)){
    
    if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
        
        cell.selectionStyle = .none
        let selectedleadsource = leadsummary.byLeadSourceList[indexPath.row - 26 - leadsummary.byLeadStatusList.count - leadsummary.byLeadProductCategoryList.count - 6]
        cell.lbl1.text = selectedleadsource.Source
        cell.lbl2.text = String.init(format:"\(selectedleadsource.Count)")
        cell.lbl3.text = String.init(format:"\(selectedleadsource.Amount)")
       /* switch (indexPath.row - 22 - leadsummary.byLeadStatusList.count - leadsummary.byLeadProductCategoryList.count - leadsummary.byLeadSourceList.count) {
        case 0:
            cell.lbl1.text = "None"
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStageNoneTotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStageNoneTotalAmount)")
        break
            
        case 1:
            cell.lbl1.text = leadsummary.LeadStageQualifiedDisplayText
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStageQualifiedTotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStageQualifiedTotalAmount)")
        break
            
        case 2:
            cell.lbl1.text = leadsummary.LeadStageTrialDisplayText
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStageTrialTotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStageTrialTotalAmount)")
        break
            
        case 3:
            cell.lbl1.text = leadsummary.LeadStageNegotiationDisplayText
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStageNegotiationTotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStageNegotiationTotalAmount)")
            break
            
        case 4:
            cell.lbl1.text = leadsummary.LeadStage5DisplayText
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStage5TotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStage5TotalAmount)")
            break
            
        case 5:
            cell.lbl1.text = leadsummary.LeadStage6DisplayText
            cell.lbl2.text = String.init(format:"\(leadsummary.LeadStage6TotalCount)")
            cell.lbl3.text = String.init(format:"\(leadsummary.LeadStage6TotalAmount)")
            break
            
        default:
            print("default = \(indexPath.row) , \(indexPath.row - 22 - leadsummary.byLeadStatusList.count - leadsummary.byLeadProductCategoryList.count)")
        }*/
       
        
            
            
    return cell
    }else{
    return UITableViewCell()
    }
   }else{
    return UITableViewCell()
    }*/
}
    
}
