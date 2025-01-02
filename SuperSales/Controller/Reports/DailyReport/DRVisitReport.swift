//
//  DRVisitReport.swift
//  SuperSales
//
//  Created by Apple on 16/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class DRVisitReport: BaseViewController {

    @IBOutlet var tblVisitReport: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //tblMissedVisit.reloadData()
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//     tblProposal.reloadData()
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - IBAction
    
    @IBAction func mapClicked(_ sender: UIButton){
        
    }
}
/*extension DRVisitReport:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return self.arrLeadAssign.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.MissedVisitCell, for: indexPath) as? VisitCell{
        let visit = arrLeadAssign[indexPath.row]
      /*  if(type(of: visit) == PlannVisit.self){
        let planvisit = visit as? PlannVisit
           // let customerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: (planvisit?.customerID as? Int ?? 0)))
            cell.lblCreatedBy.isHidden = true
            cell.lblVisitDate.isHidden = true
            cell.stackViewNextActionDetail.isHidden = true

//            cell.lblNextActionDt.isHidden = true
//            cell.lblNextActionTm.isHidden = true
            cell.lblAssigneeName.isHidden = true
            if(planvisit?.customerName?.count ?? 0 > 0){
                cell.lblCustomerName.text = planvisit?.customerName
            }else{
cell.lblCustomerName.text = "Customer Not Mapped"
            }
cell.lblCustomerName.textColor = UIColor.black
    if let visitno = planvisit?.seriesPostfix as? Int64{       cell.lblCustomerName.text?.append("(#\(visitno))")
            }
            cell.imgInteractionType.image = UIImage.init(named: "icon_planvisit_interaction_metting")
            cell.vwCustomer.backgroundColor = UIColor.clear

            cell.lblCheckinDetail.text = "Not Checked-IN Yet"
self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
let dtnextAction = self.dateFormatter.date(from: planvisit?.nextActionTime ?? "3/02/2020 4:05 am")
self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            var titleNextAction = NSMutableAttributedString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray]) //NSMutableString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
            titleNextAction.append(NSAttributedString.init(string: self.dateFormatter.string(from: dtnextAction ?? Date()), attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
cell.lblNextActionDetail.attributedText  = titleNextAction
        }else{
            let coldcallvisit = aVisits[indexPath.row] as? UnplannedVisit
            cell.lblCustomerName.text = coldcallvisit?.tempCustomerObj?.CustomerName
          if  let visitno = coldcallvisit?.seriesPostfix as? NSNumber{
            cell.lblCustomerName.text?.append("(\(visitno))")
            
            }
    
            cell.lblNextActionDetail.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: coldcallvisit?.NextActionTime ?? "2010/09/12 04:12:34" , format: "yyyy/MM/dd HH:mm:ss"), format: "dd-MM-yyyy, hh:mm a")
            
        
        }*/
        return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
}
*/
