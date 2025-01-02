 //
//  DRColdCall.swift
//  SuperSales
//
//  Created by Apple on 14/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class DRColdCall: BaseViewController {
    private let refreshControl = UIRefreshControl()
    public static var aColdCallListing:[UnplannedVisit]!//[[String:Any]]!
     @IBOutlet var tblColdCallList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
        if #available(iOS 10.0, *) {
            tblColdCallList.refreshControl = refreshControl
        } else {
            tblColdCallList.addSubview(refreshControl)
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
        tblColdCallList.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(DRColdCall.aColdCallListing.count > 0 &&  tblColdCallList.visibleCells.count > 0 ){
        self.tblColdCallList.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
         tblColdCallList.reloadData()
    }
    
    //MARK: -Method
    func setUI(){
        tblColdCallList.delegate = self
        tblColdCallList.dataSource = self
        tblColdCallList.separatorColor = .clear
        
        tblColdCallList.estimatedRowHeight = 90
        
        tblColdCallList.rowHeight = UITableView.automaticDimension
        tblColdCallList.reloadData()
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
 extension DRColdCall:UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        print(DRColdCall.aColdCallListing.count)
        return DRColdCall.aColdCallListing.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.LeadReportCell, for: indexPath) as? LeadReportCell{
        
            let coldcall = DRColdCall.aColdCallListing[indexPath.row]
            let strcoldcallno = NSMutableAttributedString.init(string: "Cold Call No: ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
            strcoldcallno.append(NSAttributedString.init(string: String.init(format:"\(coldcall.seriesPostfix ?? 344)"), attributes: [:]))
            
cell.lblLeadTitle.attributedText = strcoldcallno
let strcustomername = NSMutableAttributedString.init(string: "Customer: ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
strcustomername.append(NSAttributedString.init(string: String.init(format:"\(coldcall.customerName ?? "vds")"), attributes: [:]))
cell.lblContact.attributedText = strcustomername
     //       cell.lblContact.backgroundColor = UIColor().colorFromHexCode(rgbValue:0xEBF5FF)
            cell.vwProduct.backgroundColor = UIColor.clear
            cell.vwProduct.isHidden = true
            let strProductCategory = NSMutableAttributedString.init(string: "Product Category:   ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
strProductCategory.append(NSAttributedString.init(string: String.init(format:"\(coldcall.productCategoryName ?? "vds")"), attributes: [:]))
            let strProductRemarks = NSMutableAttributedString.init(string: "Remarks:  ", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
            strProductRemarks.append(NSAttributedString.init(string: String.init(format:"\(coldcall.conclusion ?? "vds")"), attributes: [:]))
    
            cell.lblNextAction.attributedText = strProductRemarks
            cell.lblReason.isHidden = false
            cell.lblReason.attributedText = strProductCategory
            cell.lblReason.backgroundColor  = UIColor.clear
            let imgNextActionID = Utils.getImageFrom(interactionId: Int(coldcall.nextActionID ?? 0))
            cell.imgLeft.image  =   imgNextActionID
            //cell.lblNextAction.isHidden = true
            //if(coldcall.)
            
         return cell
         }else{
             return UITableViewCell()
         }
     }
     
     
 }
// extension DRColdCall:UITableViewDelegate,UITableViewDataSource{
//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         
//
//         return self.aColdCallListing.count
//     }
//     
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.MissedVisitCell, for: indexPath) as? VisitCell{
//         let visit = aColdCallListing[indexPath.row]
//       /*  if(type(of: visit) == PlannVisit.self){
//         let planvisit = visit as? PlannVisit
//            // let customerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: (planvisit?.customerID as? Int ?? 0)))
//             cell.lblCreatedBy.isHidden = true
//             cell.lblVisitDate.isHidden = true
//             cell.stackViewNextActionDetail.isHidden = true
//
// //            cell.lblNextActionDt.isHidden = true
// //            cell.lblNextActionTm.isHidden = true
//             cell.lblAssigneeName.isHidden = true
//             if(planvisit?.customerName?.count ?? 0 > 0){
//                 cell.lblCustomerName.text = planvisit?.customerName
//             }else{
// cell.lblCustomerName.text = "Customer Not Mapped"
//             }
// cell.lblCustomerName.textColor = UIColor.black
//     if let visitno = planvisit?.seriesPostfix as? Int64{       cell.lblCustomerName.text?.append("(#\(visitno))")
//             }
//             cell.imgInteractionType.image = UIImage.init(named: "icon_planvisit_interaction_metting")
//             cell.vwCustomer.backgroundColor = UIColor.clear
//
//             cell.lblCheckinDetail.text = "Not Checked-IN Yet"
// self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
// let dtnextAction = self.dateFormatter.date(from: planvisit?.nextActionTime ?? "3/02/2020 4:05 am")
// self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
//             var titleNextAction = NSMutableAttributedString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray]) //NSMutableString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
//             titleNextAction.append(NSAttributedString.init(string: self.dateFormatter.string(from: dtnextAction ?? Date()), attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
// cell.lblNextActionDetail.attributedText  = titleNextAction
//         }else{
//             let coldcallvisit = aVisits[indexPath.row] as? UnplannedVisit
//             cell.lblCustomerName.text = coldcallvisit?.tempCustomerObj?.CustomerName
//           if  let visitno = coldcallvisit?.seriesPostfix as? NSNumber{
//             cell.lblCustomerName.text?.append("(\(visitno))")
//             
//             }
//     
//             cell.lblNextActionDetail.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: coldcallvisit?.NextActionTime ?? "2010/09/12 04:12:34" , format: "yyyy/MM/dd HH:mm:ss"), format: "dd-MM-yyyy, hh:mm a")
//             
//         
//         }*/
//         return cell
//         }else{
//             return UITableViewCell()
//         }
//     }
//     
//     
// }
