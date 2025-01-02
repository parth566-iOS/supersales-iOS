//
//  DRLeadStatus.swift
//  SuperSales
//
//  Created by Apple on 16/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class DRLeadStatus: BaseViewController {
    private let refreshControl = UIRefreshControl()
    @IBOutlet var tblLeadStatus: UITableView!
    
    public static var aLeadStatusListing:[Lead]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
        if #available(iOS 10.0, *) {
            tblLeadStatus.refreshControl = refreshControl
        } else {
            tblLeadStatus.addSubview(refreshControl)
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
        tblLeadStatus.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(DRLeadStatus.aLeadStatusListing.count > 0 &&  tblLeadStatus.visibleCells.count > 0){
        self.tblLeadStatus.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        tblLeadStatus.reloadData()
    }
    
    //MARK: - Method
    func setUI(){
            
    tblLeadStatus.delegate = self
    tblLeadStatus.dataSource = self
    tblLeadStatus.separatorColor = .clear
             
    tblLeadStatus.estimatedRowHeight = 90
             
    tblLeadStatus.rowHeight = UITableView.automaticDimension
    
    tblLeadStatus.reloadData()
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
extension DRLeadStatus:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DRLeadStatus.aLeadStatusListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.LeadReportCell, for: indexPath) as? LeadReportCell{
        if  let leadstatus = DRLeadStatus.aLeadStatusListing[indexPath.row] as? Lead{
        cell.lblLeadTitle.text = leadstatus.customerName

        cell.lblLeadTitle.text?.append(String.init(format:"(#\(leadstatus.seriesPostfix))"))
        if(leadstatus.contactID > 0){
           let strContact = NSMutableAttributedString.init(string: "Contact:", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
            if let contact = Contact.getContactFromID(contactID: NSNumber.init(value:leadstatus.contactID)) as? Contact{
                strContact.append(NSAttributedString.init(string: String.init(format:"\(contact.firstName ?? "") \(contact.lastName ?? "")"), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
                cell.lblContact.attributedText = strContact
            }else{
                let strContact = NSMutableAttributedString.init(string: "Contact:", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
                strContact.append(NSAttributedString.init(string: NSLocalizedString("no_contact", comment: ""), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
                cell.lblContact.attributedText = strContact
            }
        }else{
            let strContact = NSMutableAttributedString.init(string: "Contact:", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
            strContact.append(NSAttributedString.init(string: NSLocalizedString("no_contact", comment: ""), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            cell.lblContact.attributedText = strContact
        }
        //    if(indexPath.row < leadstatus.leadStatusList.count){
            if let objLeadStatus =  leadstatus.leadStatusList[0] as? LeadStatusList{
        cell.setReportLeadStatus(obj:objLeadStatus, assign: false)
//                return cell
            }else{
              //  return UITableViewCell()
            }
//            }else{
//
//            }
            return cell
       
        }else{
            return UITableViewCell()
        }
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leadstatus = DRLeadStatus.aLeadStatusListing[indexPath.row]
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
