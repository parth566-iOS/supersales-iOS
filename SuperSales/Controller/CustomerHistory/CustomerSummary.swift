//
//  CustomerSummary.swift
//  SuperSales
//
//  Created by mac on 04/04/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit

class CustomerSummary: BaseViewController {

    @IBOutlet weak var lblCustomerDurationInfo: UILabel!
    
    @IBOutlet weak var tblCustomerHistorySummary: UITableView!
    
    static var arrCustomerHistorySummary:CustomerHistoryResult! = CustomerHistoryResult()
   // static var noOfRecord:Int = 0
    
    var startDate:String?
    var endDate:String?
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            super.viewDidLoad()
            self.setUI()
            // Do any additional setup after loading the view.
        }
      
    }
    
    
    //MARK: Method
    func setUI(){
        if(startDate?.count ?? 0 > 0 && endDate?.count ?? 0  > 0){
            lblCustomerDurationInfo.text = String.init(format:"\(startDate ?? "") to \(endDate ?? "")")
        }
        tblCustomerHistorySummary.reloadData()
        tblCustomerHistorySummary.delegate = self
        tblCustomerHistorySummary.dataSource = self
        tblCustomerHistorySummary.setCommonFeature()
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
extension CustomerSummary:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(startDate?.count ?? 0 > 0 && endDate?.count ?? 0  > 0){
//            self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//            let sdate = self.dateFormatter.date(from: startDate ?? "")
//            let edate = self.dateFormatter.date(from: endDate ?? "")
//            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            
           // lblCustomerDurationInfo.text = String.init(format:"Period: \(self.dateFormatter.string(from: sdate ??  Date())) to \(self.dateFormatter.string(from: edate ?? Date()))")
            lblCustomerDurationInfo.text = String.init(format:"Period: \(startDate) to \(endDate)")
        }
        if(CustomerSummary.arrCustomerHistorySummary.resultList.count + CustomerSummary.arrCustomerHistorySummary.topTenOrderDataByProduct.count + CustomerSummary.arrCustomerHistorySummary.topFiveOrderDataByCategoty.count > 0){
        return ((2 * CustomerSummary.arrCustomerHistorySummary.resultList.count) + CustomerSummary.arrCustomerHistorySummary.topFiveOrderDataByCategoty.count + CustomerSummary.arrCustomerHistorySummary.topTenOrderDataByProduct.count + 12)
        }else{
            return 12
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let custsummary = CustomerSummary.arrCustomerHistorySummary
        let noofresult = custsummary?.resultList.count ?? 0
        let nooforderbyCat = custsummary?.topFiveOrderDataByCategoty.count ?? 0
        let nooforderbyproduct = custsummary?.topTenOrderDataByProduct.count ?? 0
        if(indexPath.row == 0){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath)  as? ThreeLblHorizontalCell{
                cell.lbl1.text = ""
                cell.lbl2.text = "Visits"
                cell.lbl3.text = "Order"
                cell.lbl2.textColor = UIColor.blue
                cell.lbl3.textColor = UIColor.blue
                return cell

            }else{
                return UITableViewCell()
            }
        }else if(indexPath.row  < 3 + noofresult){
        if let cell = tableView.dequeueReusableCell(withIdentifier: "fivelblhorizontalcell", for: indexPath) as? FivelblHorizontalCell{
            cell.lbl1.font =  UIFont.systemFont(ofSize: 14)
            cell.lbl2.font =  UIFont.systemFont(ofSize: 14)
            cell.lbl3.font =  UIFont.systemFont(ofSize: 14)
            cell.lbl4.font =  UIFont.systemFont(ofSize: 14)
            cell.lbl5.font =  UIFont.systemFont(ofSize: 14)
           

            if(indexPath.row == 1){
                cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
            cell.lbl1.text = "Month"
            cell.lbl2.text = "Done"
            cell.lbl3.text = "Report"
            cell.lbl4.text = "Count"
            cell.lbl5.text = "Value"
            }
            else if(indexPath.row < 2 + noofresult ){
                if  let result = custsummary?.resultList[indexPath.row - 2]{
                    cell.lbl1.textColor = UIColor.blue
                    cell.lbl1.font = UIFont.boldSystemFont(ofSize: 15)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)
                    cell.lbl2.textColor = UIColor.black
                    cell.lbl3.textColor = UIColor.black
                    cell.lbl4.textColor = UIColor.black
                    cell.lbl5.textColor = UIColor.black
                    cell.lbl5.setMultilineLabel(lbl: cell.lbl5)
                    if((indexPath.row )%2 == 0){
                        cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                     
                    }else{
                       cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                        cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                       
                       
                    }
                cell.lbl1.text = String.init(format:"\(result.monthyear)")
                cell.lbl2.text = String.init(format:"\(result.monthDoneVisit)")
                cell.lbl3.text = String.init(format:"\(result.monthVisitReport)")
                cell.lbl4.text = String.init(format:"\(result.monthOrderCount)")
                cell.lbl5.text = String.init(format:"\(result.monthOrderValue)")
                }else{
                    print("out of bound , \(indexPath.row) , \(noofresult)")
                }
            }else if(indexPath.row  == 2 + noofresult ){
                cell.lbl1.text = "Total"
                cell.lbl1.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl2.textColor = UIColor.black
                cell.lbl3.textColor = UIColor.black
                cell.lbl4.textColor = UIColor.black
                cell.lbl5.textColor = UIColor.black
                cell.lbl5.setMultilineLabel(lbl: cell.lbl5)
                if(noofresult > 0){
                    if  let data = custsummary?.resultList[indexPath.row - 2 - noofresult + noofresult - 1]{
                    cell.lbl2.text = String.init(format:"\(data.monthTotalDoneVsit)")
                    cell.lbl3.text =  String.init(format:"\(data.monthTotalReportVsit)")
                    cell.lbl4.text =  String.init(format:"\(data.monthTotalCount)")
                    cell.lbl5.text =  String.init(format:"\(data.monthTotalValue)")
                    
                }
                }else{
                    cell.lbl2.text = String.init(format:"\(0)")
                    cell.lbl3.text =  String.init(format:"\(0)")
                    cell.lbl4.text =  String.init(format:"\(0)")
                    cell.lbl5.text =  String.init(format:"\(0)")
                }
            }
            
            return cell
        }else{
            return UITableViewCell()
        }
        }
        else if(indexPath.row  == 3 + noofresult ){
            return UITableViewCell()
        }else if(indexPath.row  == 4 + noofresult ){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath)  as? ThreeLblHorizontalCell{
                cell.lbl1.font =  UIFont.systemFont(ofSize: 16)
                cell.lbl2.font =  UIFont.systemFont(ofSize: 16)
                cell.lbl3.font =  UIFont.systemFont(ofSize: 16)
                cell.lbl1.text = "Top 5 Cat for total Period"
                cell.lbl2.text = ""
                cell.lbl3.text = "Last 30 Days"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.textColor = UIColor.blue
                cell.lbl3.textColor = UIColor.blue
                return cell
            }else{
                return UITableViewCell()
            }
        }
        else if(indexPath.row < 6 + noofresult + nooforderbyCat ){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "fivelblhorizontalcell", for: indexPath) as? FivelblHorizontalCell{
                cell.lbl1.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl2.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl3.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl4.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl5.font =  UIFont.systemFont(ofSize: 14)
                if(indexPath.row == 5 + noofresult){
                cell.lbl1.text = ""
                cell.lbl2.text = "Qty"
                cell.lbl3.text = "Value"
                cell.lbl4.text = "Qty"
                cell.lbl5.text = "Value"
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                }
                else if(indexPath.row < 6 + noofresult + nooforderbyCat){
                    if  let orderbycat = custsummary?.topFiveOrderDataByCategoty[indexPath.row - 6 - noofresult]{
                        cell.lbl1.setMultilineLabel(lbl: cell.lbl1)
                        cell.lbl1.textColor = UIColor.blue
                        cell.lbl1.font = UIFont.boldSystemFont(ofSize: 15)
                        cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)
                        cell.lbl2.textColor = UIColor.black
                        cell.lbl3.textColor = UIColor.black
                        cell.lbl4.textColor = UIColor.black
                        cell.lbl5.textColor = UIColor.black
                        cell.lbl5.setMultilineLabel(lbl: cell.lbl5)
                        cell.lbl3.setMultilineLabel(lbl: cell.lbl3)
                        if((indexPath.row )%2 == 0){
                            cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                             cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                             cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                             cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                         
                        }else{
                            cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                          
                           
                           
                        }
                        cell.lbl1.text =  orderbycat.subject
                    cell.lbl2.text = String.init(format:"\(orderbycat.totalPeriodQty)")
                    cell.lbl3.text = String.init(format:"\(orderbycat.totalPeriodValue)")
                    cell.lbl4.text = String.init(format:"\(orderbycat.lastThirthDayPeriodQty)")
                    cell.lbl5.text = String.init(format:"\(orderbycat.lastThirthDayPeriodValue)")
                    }
                }
                return cell
            }else{
                return UITableViewCell()
            }
        }
        else if(indexPath.row  == 6 + noofresult + nooforderbyCat ){
            return UITableViewCell()
        }
        else if(indexPath.row  == 7 + noofresult + nooforderbyCat){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath)  as? ThreeLblHorizontalCell{
                cell.lbl1.font =  UIFont.systemFont(ofSize: 16)
                cell.lbl2.font =  UIFont.systemFont(ofSize: 16)
                cell.lbl3.font =  UIFont.systemFont(ofSize: 16)
                cell.lbl1.text = "Top 10 Cat for total Period"
                cell.lbl2.text = ""
                cell.lbl3.text = "Last 30 Days"
                cell.lbl1.textColor = UIColor.blue
                cell.lbl2.textColor = UIColor.blue
                cell.lbl3.textColor = UIColor.blue
                return cell
            }else{
                return UITableViewCell()
            }
        }
        else if(indexPath.row < 9 + noofresult + nooforderbyCat + nooforderbyproduct ){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "fivelblhorizontalcell", for: indexPath) as? FivelblHorizontalCell{
                cell.lbl1.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl2.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl3.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl4.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl5.font =  UIFont.systemFont(ofSize: 14)
                if(indexPath.row == 8 + noofresult + nooforderbyCat){
                cell.lbl1.text = ""
                cell.lbl2.text = "Qty"
                cell.lbl3.text = "Value"
                cell.lbl4.text = "Qty"
                cell.lbl5.text = "Value"
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                }
                else if(indexPath.row < 9 + noofresult + nooforderbyCat + nooforderbyproduct){
                    if  let orderbycat = custsummary?.topTenOrderDataByProduct[indexPath.row - 9 - noofresult - nooforderbyCat]{
                        cell.lbl1.setMultilineLabel(lbl: cell.lbl1)
                        cell.lbl1.textColor = UIColor.blue
                        cell.lbl1.font = UIFont.boldSystemFont(ofSize: 15)
                        cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)
                        cell.lbl2.textColor = UIColor.black
                        cell.lbl3.textColor = UIColor.black
                        cell.lbl4.textColor = UIColor.black
                        cell.lbl5.textColor = UIColor.black
                        cell.lbl5.setMultilineLabel(lbl: cell.lbl5)
                        cell.lbl3.setMultilineLabel(lbl: cell.lbl3)
                        if((indexPath.row )%2 == 0){
                            cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                         
                        }else{
                           cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                           
                           
                        }
                        cell.lbl1.text =  orderbycat.subject
                    cell.lbl2.text = String.init(format:"\(orderbycat.totalPeriodQty)")
                    cell.lbl3.text = String.init(format:"\(orderbycat.totalPeriodValue)")
                    cell.lbl4.text = String.init(format:"\(orderbycat.lastThirthDayPeriodQty)")
                    cell.lbl5.text = String.init(format:"\(orderbycat.lastThirthDayPeriodValue)")
                    }
                }
                return cell
            }else{
                return UITableViewCell()
            }// < 8 + noofresult + nooforderbyCat + nooforderbyproduct
        }else if(indexPath.row == 9 + noofresult + nooforderbyCat + nooforderbyproduct ){
            return UITableViewCell()
        }
        else if(indexPath.row < 12 + noofresult + nooforderbyCat + nooforderbyproduct + noofresult ){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "fivelblhorizontalcell", for: indexPath) as? FivelblHorizontalCell{
                cell.lbl1.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl2.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl3.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl4.font =  UIFont.systemFont(ofSize: 14)
                cell.lbl5.font =  UIFont.systemFont(ofSize: 14)
                if(indexPath.row == 10 + noofresult + nooforderbyCat + nooforderbyproduct){
                cell.lbl1.text = "Leads Summary"
                cell.lbl2.text = "Gen"
                cell.lbl3.text = "Updtd"
                cell.lbl4.text = "Won"
                cell.lbl5.text = "Lost"
                    cell.lbl1.textColor = UIColor.blue
                    cell.lbl2.textColor = UIColor.blue
                    cell.lbl3.textColor = UIColor.blue
                    cell.lbl4.textColor = UIColor.blue
                    cell.lbl5.textColor = UIColor.blue
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                cell.lbl1.setMultilineLabel(lbl: cell.lbl1)
                }
                else if(indexPath.row < 11 + noofresult + nooforderbyCat + nooforderbyproduct + noofresult){
                    if  let leadData = custsummary?.resultList[indexPath.row - 11 - noofresult - nooforderbyCat - nooforderbyproduct]{
                        cell.lbl1.textColor = UIColor.blue
                        cell.lbl1.font = UIFont.boldSystemFont(ofSize: 15)
                        cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)
                        cell.lbl2.textColor = UIColor.black
                        cell.lbl3.textColor = UIColor.black
                        cell.lbl4.textColor = UIColor.black
                        cell.lbl5.textColor = UIColor.black
                        cell.lbl5.setMultilineLabel(lbl: cell.lbl5)
                        
                        if((indexPath.row )%2 == 0){
                            cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                         
                        }else{
                           cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                            cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                           
                           
                        }
                        cell.lbl1.text = leadData.monthyear
                    cell.lbl2.text = String.init(format:"\(leadData.montLeadGenerated)")
                    cell.lbl3.text = String.init(format:"\(leadData.monthLeadUpdated)")
                    cell.lbl4.text = String.init(format:"\(leadData.monthLeadWon)")
                    cell.lbl5.text = String.init(format:"\(leadData.monthLeadLost)")
                    }
                }
                else if(indexPath.row == 11 + noofresult + nooforderbyCat + nooforderbyproduct + noofresult){
                    cell.lbl1.text = "Total"
                    cell.lbl1.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl5.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)
                    cell.lbl2.textColor = UIColor.black
                    cell.lbl3.textColor = UIColor.black
                    cell.lbl4.textColor = UIColor.black
                    cell.lbl5.textColor = UIColor.black
                    cell.lbl5.setMultilineLabel(lbl: cell.lbl5)
                    if(noofresult > 0){
                        if  let leadData = custsummary?.resultList[indexPath.row - 11 - noofresult - nooforderbyCat - nooforderbyproduct - noofresult + noofresult - 1]{
                        cell.lbl2.text = String.init(format:"\(leadData.monthTotalLeadGenerated)")
                        cell.lbl3.text =  String.init(format:"\(leadData.monthTotalLeadUpdated)")
                        cell.lbl4.text =  String.init(format:"\(leadData.monthTotalLeadWon)")
                        cell.lbl5.text =  String.init(format:"\(leadData.monthTotalLeadLost)")
                        
                    }
                    }else{
                        cell.lbl2.text = String.init(format:"\(0)")
                        cell.lbl3.text =  String.init(format:"\(0)")
                        cell.lbl4.text =  String.init(format:"\(0)")
                        cell.lbl5.text =  String.init(format:"\(0)")
                    }
                }
                return cell
            }else{
                return UITableViewCell()
            }
        }
        else{
            return UITableViewCell()
        }
    
    }
}
