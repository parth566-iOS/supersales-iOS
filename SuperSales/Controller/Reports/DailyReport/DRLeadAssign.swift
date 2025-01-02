//
//  DRLeadAssign.swift
//  SuperSales
//
//  Created by Apple on 14/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class DRLeadAssign: BaseViewController {
    private let refreshControl = UIRefreshControl()
    
    public static var arrLeadAssign:[Lead]!
    @IBOutlet var tblLeadAssign: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
        if #available(iOS 10.0, *) {
            tblLeadAssign.refreshControl = refreshControl
        } else {
            tblLeadAssign.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
//         [_tblListing addPullToRefreshWithActionHandler:^{
//         jointVisitPageNo=1;
//         [self callWebservice];
//         }];
         
    }
    @objc private func refreshWeatherData(_ sender: Any) {
//        // Fetch Weather Data
        refreshControl.endRefreshing()
        NotificationCenter.default.post(name: NSNotification.Name("getDailyReports"), object: nil)
        tblLeadAssign.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(true)
        if(DRLeadAssign.arrLeadAssign.count > 0 &&  tblLeadAssign.visibleCells.count > 0){
        self.tblLeadAssign.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        tblLeadAssign.reloadData()
       }
    
    //MARK: -Method
    func setUI(){
            
    tblLeadAssign.delegate = self
    tblLeadAssign.dataSource = self
    tblLeadAssign.separatorColor = .clear
             
    tblLeadAssign.estimatedRowHeight = 90
             
    tblLeadAssign.rowHeight = UITableView.automaticDimension
    
    tblLeadAssign.reloadData()
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
extension DRLeadAssign:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return DRLeadAssign.arrLeadAssign.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.LeadReportCell, for: indexPath) as? LeadReportCell{
        let leadstatus = DRLeadAssign.arrLeadAssign[indexPath.row]
        cell.imgLeft.isHidden = true
        cell.setReportLeadAssign(leadstatus:leadstatus, assign: true)
        
           return cell
           }else{
               return UITableViewCell()
           }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leadstatus = DRLeadAssign.arrLeadAssign[indexPath.row]
        if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
            let dateFormatter = "yyyy/MM/dd"
            let reportDate = self.dateFormatter.date(from: Reports.selectedDate)
            if((reportDate?.isEndDateIsSmallerThanCurrent(checkendDate: Date())) != nil){
                leadDetail.isHistory = true
            }else{
                leadDetail.isHistory = false
            }
        
        leadDetail.redirectTo =  0
        leadDetail.lead =  leadstatus //arrOfLead[indexPath.row]
            print(leadDetail.lead.iD)
            //        visitDetail.planvisit = arrOfPlanVisit[indexPath.row]
        //        if(visitDetail.planvisit?.visitStatusID == 3){
        //            visitDetail.visitType = VisitType.manualvisit
        //        }else{
        //            visitDetail.visitType = VisitType.planedvisit
        //        }
        self.navigationController?.pushViewController(leadDetail, animated: true)
        }
    }
}
