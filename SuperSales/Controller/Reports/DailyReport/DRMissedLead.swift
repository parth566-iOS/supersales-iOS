//
//  DRMissedLead.swift
//  SuperSales
//
//  Created by APPLE on 31/12/24.
//  Copyright © 2024 Bigbang. All rights reserved.
//

import UIKit

class DRMissedLead: BaseViewController {
    
    @IBOutlet weak var tblMissedLead: UITableView!
    
    private let refreshControl = UIRefreshControl()
    public static var aNewLeads:[Lead]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        if #available(iOS 10.0, *) {
            self.tblMissedLead.refreshControl = refreshControl
        } else {
            self.tblMissedLead.addSubview(refreshControl)
        }
        // Configure Refresh Control
        self.refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
//        // Fetch Weather Data
        self.refreshControl.endRefreshing()
        NotificationCenter.default.post(name: NSNotification.Name("getDailyReports"), object: nil)
        self.tblMissedLead.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      //  SVProgressHUD.show()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(DRMissedLead.aNewLeads.count > 0 &&  self.tblMissedLead.visibleCells.count > 0) {
            self.tblMissedLead.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        self.tblMissedLead.reloadData()
        
    }
    
    
    //MARK: - Method
    func setUI(){
        
        
        self.tblMissedLead.separatorColor = .clear
        
        self.tblMissedLead.estimatedRowHeight = 90
        
        self.tblMissedLead.rowHeight = UITableView.automaticDimension
        
        self.tblMissedLead.reloadData()
    }
    
}
extension DRMissedLead:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return DRMissedLead.aNewLeads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.LeadReportCell, for: indexPath) as? LeadReportCell{
            let leadstatus = DRMissedLead.aNewLeads[indexPath.row]
            cell.setReportLeadCreated(obj:leadstatus)
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leadstatus = DRLeadCreated.aNewLeads[indexPath.row]
        if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
          
        leadDetail.isHistory = false
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
    }*/
    
}
