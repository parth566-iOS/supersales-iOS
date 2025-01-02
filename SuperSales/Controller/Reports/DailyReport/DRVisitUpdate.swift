//
//  DRVisitUpdate.swift
//  SuperSales
//
//  Created by Apple on 14/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit

class DRVisitUpdate: BaseViewController {
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet var tblVisitUpdate: UITableView!
    
   public static var aVisitupdate:[Any]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
        if #available(iOS 10.0, *) {
            tblVisitUpdate.refreshControl = refreshControl
        } else {
            tblVisitUpdate.addSubview(refreshControl)
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
        tblVisitUpdate.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
          
        tblVisitUpdate.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(DRVisitUpdate.aVisitupdate.count > 0 &&  tblVisitUpdate.visibleCells.count > 0){
        self.tblVisitUpdate.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    
        tblVisitUpdate.reloadData()
    }
    
    //MARK: - Method
    func setUI(){
        tblVisitUpdate.delegate = self
        tblVisitUpdate.dataSource = self
        tblVisitUpdate.separatorColor = .clear
        
        tblVisitUpdate.estimatedRowHeight = 90
        
        tblVisitUpdate.rowHeight = UITableView.automaticDimension
        
        tblVisitUpdate.reloadData()
        
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
extension DRVisitUpdate:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("vist update data = \(DRVisitUpdate.aVisitupdate.count)")
        return DRVisitUpdate.aVisitupdate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.LeadReportCell, for: indexPath) as? LeadReportCell{
            let visit = DRVisitUpdate.aVisitupdate[indexPath.row]
            //cell.vwParent.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xE7E7EC)
            if(type(of: visit) == PlannVisit.self){
                let planvisit = visit as? PlannVisit
                // let customerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: (planvisit?.customerID as? Int ?? 0)))
                var  strcustomername  = String.init(format:"\(planvisit?.customerName ?? "")")
                let  stroutcome = NSMutableAttributedString.init(string: "Outcome: ", attributes: [NSAttributedString.Key .font :UIFont.myBoldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.black])
                strcustomername.append(String.init(format:"(# \(planvisit?.seriesPostfix ?? 0))"))
                cell.lblLeadTitle.text = strcustomername
                cell.imgLeft.image = Utils.getImageFrom(interactionId: Int(planvisit?.nextActionID as? Int64 ?? 0))
                cell.imgRight.isHidden = true
                let  strContact = NSMutableAttributedString.init(string: "Contact:", attributes: [NSAttributedString.Key .font :UIFont.boldSystemFont(ofSize: 16)])
                if(planvisit?.contactID ?? 0 > 0){
                    if  let  planvisitcontact = Contact.getContactFromID(contactID: NSNumber.init(value:planvisit?.contactID ?? 0)) as? Contact{
                        // lblContactName.text = String.init(format:"%@ %@", planvisitcontact.firstName,planvisitcontact.lastName)
                        strContact.append(NSAttributedString.init(string: String.init(format:"%@ %@", planvisitcontact.firstName,planvisitcontact.lastName) ?? "No Contact", attributes: [:]))
                    }
                }else{
                    strContact.append(NSAttributedString.init(string:  "No Contact", attributes: [:]))
                }
                if let vstatusList = planvisit?.visitStatusList as? NSOrderedSet{
                    if let firstvisitStatus = vstatusList.firstObject as? VisitStatus{
                        cell.lblReason.text = VisitOutcomes.getOutcomeFromOutcomeID(leadSourceID: NSNumber.init(value:firstvisitStatus.visitOutcomeID ?? 0))
                        //strContact.append(NSAttributedString.init(string: firstvisitStatus.CreatedByName ?? "", attributes: [:]))
                        
                        stroutcome.append(NSAttributedString.init(string: VisitOutcomes.getOutcomeFromOutcomeID(leadSourceID: NSNumber.init(value:firstvisitStatus.visitOutcomeID ?? 0)), attributes: [:]))
                    }
                }
                
                
                let  strAction  = NSMutableAttributedString.init(string: "Next Action: ", attributes: [NSAttributedString.Key .font :UIFont.boldSystemFont(ofSize: 16)])
                strAction.append(NSAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString: planvisit?.nextActionTime ?? "23-02-2019 02:34 am", format: "dd-MM-yyyy hh:mm a"), attributes: [:]))
                
                cell.imgNextAction.isHidden = true
                cell.lblNextAction.attributedText = stroutcome//strAction
                cell.lblContact.attributedText = strContact
                let  strDescription  = NSMutableAttributedString.init(string: "Description: ", attributes: [NSAttributedString.Key .font :UIFont.boldSystemFont(ofSize: 16)])
               
                if let strdescription = planvisit?.conclusion as? String{
                    if(strdescription.count > 0){
                    strDescription.append(NSAttributedString.init(string:  strdescription  ?? "conclusion" , attributes: [:]))
                cell.lblReason.attributedText = strDescription
                    cell.vwReason.isHidden = false
                    }else{
                        cell.vwReason.isHidden = true
                    }
                }else{
                    cell.vwReason.isHidden = true
                }
                //cell.lblReason.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEBF5FF) //UIColor().colorFromHexCode(rgbValue: 0x332196F3)//
                // cell.vwNextAction.isHidden  = true
                
                var strProductName = NSMutableAttributedString()
                var strProductQuantity = NSMutableAttributedString()
                var strProductBudget = NSMutableAttributedString()
                //product information
                if(planvisit?.productList.count ?? 0 > 0){
                    cell.vwProduct.isHidden = false
                    let countofproduct = planvisit?.productList.count ?? 0
                    for p in 0...countofproduct{
                        if(p == 0){
                            strProductQuantity = NSMutableAttributedString.init(string: "  Qty \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appthemebluecolor,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])
                          strProductName = NSMutableAttributedString.init(string: "  Product \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appthemebluecolor,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])
                            strProductBudget = NSMutableAttributedString.init(string: "  Budget \n \n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appthemebluecolor,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])

                        }else{
                            if let product = planvisit?.productList[p-1] as? ProductsList{
                                //if let product = p  as? ProductsList {
                                if let productname = product.productName{
                                    let productName = NSAttributedString.init(string:String.init(format:"\(productname) \n"), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                                    strProductName.append(productName)
                                }
                                print(product.quantity)
                                  //  strProductDetail.append(productName)
                                if let prodQuantity = product.quantity as? Int64 {
                                    let quantivalue = NSAttributedString.init(string: String.init(format:"%d \n",prodQuantity) , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                                    cell.lbl2ProductQuantity.attributedText = quantivalue
                                    strProductQuantity.append(quantivalue)
                                }

                                if let probudget = product.budget as? NSDecimalNumber{
                                    let budgetvalue = NSAttributedString.init(string: String.init(format:"%.1f \n",probudget.floatValue) , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)])
                                    //strProductDetail.append(budgetvalue)
                                    cell.lbl3ProductBudget.attributedText = budgetvalue
                                    strProductBudget.append(budgetvalue)
                               }
                            }else{
                                print("product not get")
                            }
                            cell.lbl1ProductName.setMultilineLabel(lbl: cell.lbl1ProductName)
                            cell.lbl2ProductQuantity.setMultilineLabel(lbl: cell.lbl2ProductQuantity)
                            cell.lbl3ProductBudget.setMultilineLabel(lbl: cell.lbl3ProductBudget)
//
                       }
                       
                   
                        
                    }
                    
                 
                    cell.lbl1ProductName.attributedText = strProductName
                    cell.lbl2ProductQuantity.attributedText = strProductQuantity
                    cell.lbl3ProductBudget.attributedText = strProductBudget
                    cell.lbl1ProductName.setMultilineLabel(lbl: cell.lbl1ProductName)
                    cell.lbl2ProductQuantity.setMultilineLabel(lbl: cell.lbl2ProductQuantity)
                    cell.lbl3ProductBudget.setMultilineLabel(lbl: cell.lbl3ProductBudget)
                    cell.vwProduct.isHidden = false
                }else{
                    cell.vwProduct.isHidden = true
                }
                cell.contentView.layoutIfNeeded()
            }
            else{
                let coldcallvisit = visit as? UnplannedVisit
                var  strcustomername  = String.init(format:"\(coldcallvisit?.tempCustomerObj?.CustomerName ?? "")")
                strcustomername.append(String.init(format:"(# \(coldcallvisit?.seriesPostfix ?? 0))"))
                cell.lblLeadTitle.text = strcustomername
                cell.imgLeft.image = Utils.getImageFrom(interactionId: coldcallvisit?.originalNextActionID as? Int ?? 0)
                cell.imgRight.isHidden = true
                let  stroutcome = NSMutableAttributedString.init(string: "Outcome: ", attributes: [NSAttributedString.Key .font :UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
                let  strContact = NSMutableAttributedString.init(string: "Contact: ", attributes: [NSAttributedString.Key .font :UIFont.boldSystemFont(ofSize: 16)])
                let  strAction  = NSMutableAttributedString.init(string: "Next Action: ", attributes: [NSAttributedString.Key .font :UIFont.boldSystemFont(ofSize: 16)])
                strAction.append(NSAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString: coldcallvisit?.NextActionTime ?? "23-02-2019 02:34 am", format: "dd-MM-yyyy hh:mm a"), attributes: [:]))
                if let vstatus = coldcallvisit?.visitStatusList.first{
                    stroutcome.append(NSAttributedString.init(string: VisitOutcomes.getOutcomeFromOutcomeID(leadSourceID: NSNumber.init(value:vstatus.visitOutcomeID ?? 0)), attributes: [:]))
                    strContact.append(NSAttributedString.init(string: vstatus.CreatedByName ?? "", attributes: [:]))
                }
                cell.lblReason.attributedText = stroutcome
                cell.lblNextAction.attributedText = strAction
                cell.lblContact.attributedText = strContact
            }
          
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let visit = DRVisitUpdate.aVisitupdate[indexPath.row]
        if(type(of: visit) == PlannVisit.self){
            let planvisit = visit as? PlannVisit
            if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                
                visitDetail.visitType = VisitType.planedvisit
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
