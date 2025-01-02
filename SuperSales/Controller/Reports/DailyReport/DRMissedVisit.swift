//
//  DRMissedVisit.swift
//  SuperSales
//
//  Created by Apple on 14/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class DRMissedVisit: BaseViewController {
    private let refreshControl = UIRefreshControl()
    @IBOutlet var tblMissedVisit: UITableView!
    public static var arrMissedVisits:[Any]! = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      //  Reports().delegateReport?.setData()
       // SVProgressHUD.show()
        tblMissedVisit.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(DRMissedVisit.arrMissedVisits.count > 0 &&  tblMissedVisit.visibleCells.count > 0){
        self.tblMissedVisit.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
      
         tblMissedVisit.reloadData()
       // SVProgressHUD.dismiss()
    }
    
    //MARK: - Method
    func setUI(){
        tblMissedVisit.delegate = self
        tblMissedVisit.dataSource = self
        tblMissedVisit.separatorColor = .clear
        
        tblMissedVisit.estimatedRowHeight = 90
        
        tblMissedVisit.rowHeight = UITableView.automaticDimension
       
        //For Pull to refresh
        if #available(iOS 10.0, *) {
            tblMissedVisit.refreshControl = refreshControl
        } else {
            tblMissedVisit.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
//        
//         [_tblListing addPullToRefreshWithActionHandler:^{
//         jointVisitPageNo=1;
//         [self callWebservice];
//         }];
         
    }
    @objc private func refreshWeatherData(_ sender: Any) {
//        // Fetch Weather Data
        refreshControl.endRefreshing()
        NotificationCenter.default.post(name: NSNotification.Name("getDailyReports"), object: nil)
       
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
extension DRMissedVisit:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("Missed visit Count = \(DRMissedVisit.arrMissedVisits.count)")
        return DRMissedVisit.arrMissedVisits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.MissedVisitCell, for: indexPath) as? VisitCell{
        cell.lblCreatedBy.isHidden = true
        cell.lblVisitDate.isHidden = true
           cell.stackViewNextActionDetail.isHidden = true
           cell.lblAssigneeName.isHidden = true
        cell.lblCustomerName.textColor = UIColor.darkGray
        cell.lblCustomerName.font = UIFont.boldSystemFont(ofSize: 15)
        let visit = DRMissedVisit.arrMissedVisits[indexPath.row]
        if(type(of: visit) == PlannVisit.self){
        let planvisit = visit as? PlannVisit
         
            if(planvisit?.customerName?.count ?? 0 > 0){
                cell.lblCustomerName.text = planvisit?.customerName
            }else{
cell.lblCustomerName.text = "Customer Not Mapped"
            }
cell.lblCustomerName.textColor = UIColor.black
            if let visitno = planvisit?.seriesPostfix{
        cell.lblCustomerName.text?.append("(#\(visitno))")
            }
            cell.stkParent.layoutIfNeeded()
            cell.stkParent.backgroundColor   =  UIColor().colorFromHexCode(rgbValue: 0xE7E7EC)
            cell.vwCustomer.backgroundColor = UIColor.clear

            cell.lblCheckinDetail.textColor = UIColor.Appthemebluecolor//UIColor().colorFromHexCode(rgbValue: (0x2541C9))//UIColor.blue
            cell.lblCheckinDetail.font = UIFont.boldSystemFont(ofSize: 14)
            cell.lblCheckinDetail.text = "      Not Checked-IN Yet:"
let titleNextAction = NSMutableAttributedString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
        
        titleNextAction.append(NSAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: planvisit?.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") ?? "2010/12/10 10:10:10", format: "dd-MM-yyyy , hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            cell.imgInteractionType.backgroundColor  = UIColor.lightGray
            cell.imgInteractionType.image = Utils.getImageFrom(interactionId: Int(planvisit?.nextActionID as? Int64 ?? 0))
            cell.lblNextActionDetail.attributedText  = titleNextAction
           
        }else{
            
            let coldcallvisit = DRMissedVisit.arrMissedVisits[indexPath.row] as? UnplannedVisit
            cell.lblCustomerName.textColor = UIColor.black
            cell.lblCustomerName.text = coldcallvisit?.tempCustomerObj?.CustomerName
            if  let visitno = coldcallvisit?.seriesPostfix{
                cell.lblCustomerName.text?.append("(\(visitno))")
            }
 
            cell.imgInteractionType.image = Utils.getImageFrom(interactionId: coldcallvisit?.nextActionID as? Int ?? 0)
     var strnt = ""
    if let strn = Utils.getDateBigFormatToDefaultFormat(date: coldcallvisit?.NextActionTime ?? "2010/09/12 04:12:34" , format: "yyyy/MM/dd HH:mm:ss") as? String{
        strnt = strn
            }
   cell.lblNextActionDetail.text =  Utils.getDatestringWithGMT(gmtDateString: strnt, format: "dd-MM-yyyy, hh:mm a")
            
    cell.vwCustomer.backgroundColor = UIColor.clear
            cell.lblCheckinDetail.textColor = UIColor.Appthemebluecolor
    cell.lblCheckinDetail.font = UIFont.boldSystemFont(ofSize: 16)
cell.lblCheckinDetail.text = "         Not Checked-IN Yet:"

let titleNextAction = NSMutableAttributedString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
    var strndt = ""
    if let strn = Utils.getDateBigFormatToDefaultFormat(date: coldcallvisit?.NextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
      strndt = strn
            }
titleNextAction.append(NSAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString: strndt, format: "dd-MM-yyyy , hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
cell.lblNextActionDetail.attributedText  = titleNextAction
        
        }
        return cell
        }else{
            return UITableViewCell()
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let visit = DRMissedVisit.arrMissedVisits[indexPath.row]
        if(type(of: visit) == PlannVisit.self){
            let planvisit = visit as? PlannVisit
            if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
         
                if(planvisit?.visitStatusID == 2){
                    visitDetail.visitType = VisitType.planedvisitHistory
                }else{
             visitDetail.visitType = VisitType.planedvisit
                }
            visitDetail.redirectTo =  0
            visitDetail.planvisit = planvisit
            self.navigationController?.pushViewController(visitDetail, animated: true)
            }
        }else if(type(of: visit) ==  UnplannedVisit.self){
            let unplanvisit = visit as? UnplannedVisit
            if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
         
             visitDetail.visitType = VisitType.coldcallvisit
            visitDetail.redirectTo =  0
            visitDetail.unplanvisit = unplanvisit
            self.navigationController?.pushViewController(visitDetail, animated: true)
            }
        }else{
            
        }
    }
    
}
extension DRMissedVisit:ReportsDelegate
{
    func setData() {
        self.tblMissedVisit.reloadData()
    }
}
