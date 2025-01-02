//
//  DRLeadCreated.swift
//  SuperSales
//
//  Created by Apple on 14/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class DRLeadCreated: BaseViewController {
    
    private let refreshControl = UIRefreshControl()
    @IBOutlet var tblLeadList: UITableView!
    public static var aNewLeads:[Lead]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
        if #available(iOS 10.0, *) {
            tblLeadList.refreshControl = refreshControl
        } else {
            tblLeadList.addSubview(refreshControl)
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
        tblLeadList.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      //  SVProgressHUD.show()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(DRLeadCreated.aNewLeads.count > 0 &&  tblLeadList.visibleCells.count > 0){
        self.tblLeadList.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
         tblLeadList.reloadData()
        
    }
    //MARK: - Method
       func setUI(){
               
       tblLeadList.delegate = self
       tblLeadList.dataSource = self
       tblLeadList.separatorColor = .clear
                
       tblLeadList.estimatedRowHeight = 90
                
       tblLeadList.rowHeight = UITableView.automaticDimension
       
       tblLeadList.reloadData()
            }

}
extension DRLeadCreated:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return DRLeadCreated.aNewLeads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.LeadReportCell, for: indexPath) as? LeadReportCell{
        let leadstatus = DRLeadCreated.aNewLeads[indexPath.row]
       cell.setReportLeadCreated(obj:leadstatus)
        
           return cell
           }else{
               return UITableViewCell()
           }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    }
    
}
