//
//  LeadSummary.swift
//  SuperSales
//
//  Created by mac on 04/03/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class LeadSummary: BaseViewController {

    @IBOutlet weak var btnSelecteSalesPerson: UIButton!
    @IBOutlet weak var btnTeam: UIButton!
    
    @IBOutlet weak var btnSelf: UIButton!
    @IBOutlet weak var vwSalesPerson: UIView!
    @IBOutlet weak var btnGetReport: UIButton!
    
    @IBOutlet weak var tblLeadSummary: UITableView!
    @IBOutlet weak var vwUserSelection: UIView!
    @IBOutlet weak var stkSalesPerson: UIStackView!
    
    @IBOutlet weak var lblSelectedSalesPerson: UILabel!
    
   // @IBOutlet weak var tblSummaryHeight: NSLayoutConstraint!
    var arrOfLowerUser:[CompanyUsers] = [CompanyUsers]()
    var arrOfSelectedLowerUser:[CompanyUsers] = [CompanyUsers]()
    var selectedUserID = NSNumber.init(value: 0)
    var arrOfSection = [String]()
    var leadsummary:LeadSummaryModel = LeadSummaryModel()
    var popup:CustomerSelection?
   static var totalnumberofRecord = 0
    var numberOfTitle = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        if(self.arrOfLowerUser.count == 0){
            vwUserSelection.isHidden = true
            self.getLeadSummary()
           
        }else{
          
            vwUserSelection.isHidden = false
        }
        tblLeadSummary.reloadData()
    }
    
    //MARK: - Method
    func setUI(){
      //  SVProgressHUD.show()
        self.btnSelf.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.btnTeam.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.btnGetReport.setbtnFor(title: "Get Report", type: Constant.kPositive)
        let attrs = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.blue,
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        let buttonTitleStr = NSMutableAttributedString(string:"Select Sales Person", attributes:attrs)
        btnSelecteSalesPerson.setAttributedTitle(buttonTitleStr, for: UIControl.State.normal)
        if(BaseViewController.staticlowerUser.count == 0){
        self.fetchuser{
            (arrOfuser,error) in
            self.arrOfLowerUser = [CompanyUsers]()
//                arrOfUserExceptExecutive = BaseViewController.staticlowerUser.filter{
//                    $0.role_id.intValue <=  8
//                }
            
            
            
            self.arrOfLowerUser = BaseViewController.staticlowerUser
        }
        }else{
            self.arrOfLowerUser = BaseViewController.staticlowerUser
        }
       
//        tblLeadSummary.isHidden = true
//        tblLeadSummary.isUserInteractionEnabled = false
        if(self.arrOfLowerUser.count == 0){
            vwUserSelection.isHidden = true
            self.getLeadSummary()
           
        }else{
          
            vwUserSelection.isHidden = false
        }
        let selfuser = self.arrOfLowerUser.filter{
            $0.entity_id == self.activeuser?.userID
        }
        self.arrOfSelectedLowerUser = [CompanyUsers]()
        self.arrOfSelectedLowerUser.append(contentsOf: selfuser)
        tblLeadSummary.estimatedRowHeight = 50
        tblLeadSummary.rowHeight = UITableView.automaticDimension
        tblLeadSummary.setCommonFeature()
        tblLeadSummary.delegate = self
        tblLeadSummary.dataSource = self
        btnSelf.isSelected = true
        vwSalesPerson.isHidden = true
        selectedUserID =  self.activeuser?.userID ?? NSNumber.init(value: 0)
       // self.getLeadSummary()
        LeadSummary.totalnumberofRecord = 0
        tblLeadSummary.reloadData()
    }
    
    func getLeadSummary(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        if(btnTeam.isSelected){
        param["TeamOrSelf"] = "Team"
    }
        else{
            param["TeamOrSelf"] = "Self"
        }
        param["lowerUserID"] =  selectedUserID
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetLeadSummary, method: Apicallmethod.get)
        {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        
      
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let dicsummary =  arr as? [String:Any] ?? [String:Any]()
                
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view:self.view)
                   // self.view1.makeToast(message)
                }
                self.leadsummary = LeadSummaryModel.init(dictionary: dicsummary as NSDictionary)
                
                self.arrOfSection = ["Lead Summary Report","Active Lead Status","Chance to Win","Active Leads by Stage","Status","Active Leads by Product Category","Active Leads by Source"]
                
                LeadSummary.totalnumberofRecord = 28 + self.leadsummary.byLeadStatusList.count + self.leadsummary.byLeadProductCategoryList.count  + self.leadsummary.byLeadSourceList.count + self.arrOfSection.count
//                if(self.leadsummary.byLeadStatusList.count > 0){
//                    self.totalnumberofRecord += 1
//                    self.arrOfSection.append("Status")
//                }
//
//                if(self.leadsummary.byLeadProductCategoryList.count > 0){
//                    self.totalnumberofRecord += 1
//                    self.arrOfSection.append("Active Leads by Product Category")
//                }
//
//                if(self.leadsummary.byLeadSourceList.count > 0){
//                    self.totalnumberofRecord += 1
//                    self.arrOfSection.append("Active Leads by Source")
//                }
//                if(self.leadsummary.byLeadProductCategoryList.count > 0){
//                    self.totalnumberofRecord += 1
//                    self.arrOfSection.append("Active Leads by Product Category")
//
//                }
                self.tblLeadSummary.reloadData()
                self.tblLeadSummary.isHidden = false
                self.tblLeadSummary.isUserInteractionEnabled = true
                if(26 + self.leadsummary.byLeadStatusList.count + self.leadsummary.byLeadProductCategoryList.count  + self.leadsummary.byLeadSourceList.count + self.arrOfSection.count > 0){
                  //  self.tblLeadSummary.
                    self.tblLeadSummary.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                }
             //   self.tblSummaryHeight.constant = self.tblLeadSummary.contentSize.height
                SVProgressHUD.dismiss()
            }else{
                if(error.code == 0){
                    SVProgressHUD.dismiss()
                    Utils.toastmsg(message: message, view: self.view)
               
            
                       }else{
                        SVProgressHUD.dismiss()
                  self.dismiss(animated: true, completion: nil)
                        Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String) ?? "" :error.localizedDescription,view:self.view)
                     //     self.view1.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                       }
                }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func btnSelfClicked(_ sender: UIButton) {
        btnSelf.isSelected = true
        btnTeam.isSelected = false
        vwSalesPerson.isHidden = true
        selectedUserID = self.activeuser?.userID ?? NSNumber.init(value: 0)
        
    }
    
    @IBAction func btnTeamClicked(_ sender: UIButton) {
        btnSelf.isSelected = false
        btnTeam.isSelected = true
        vwSalesPerson.isHidden = false
        self.arrOfSelectedLowerUser =  self.arrOfSelectedLowerUser ?? [self.arrOfLowerUser[0]]
        if let selectedUser = arrOfSelectedLowerUser.first as? CompanyUsers{
            selectedUserID =  selectedUser.entity_id
        }
        
    }
    @IBAction func btnSelectSalesPersonClicked(_ sender: UIButton) {
//        self.arrOfUserExceptExecutive = sortedUserarr
        self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        self.popup?.modalPresentationStyle = .overCurrentContext
        self.popup?.isFromSalesOrder =  false
        self.popup?.strTitle = "Select Sales Person"
        self.popup?.nonmandatorydelegate = self
        self.popup?.arrOfExecutive = self.arrOfLowerUser
        self.popup?.arrOfSelectedExecutive = self.arrOfSelectedLowerUser ?? [self.arrOfLowerUser[0]]
        self.popup?.strLeftTitle = "OK"
        self.popup?.strRightTitle = "Cancel"
        self.popup?.selectionmode = SelectionMode.single
        //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
        self.popup?.isSearchBarRequire = false
        self.popup?.viewfor = ViewFor.companyuser
        self.popup?.isFilterRequire = false
        // popup?.showAnimate()
      
        self.popup?.parentViewOfPopup = self.view
        Utils.addShadow(view: self.view)
        self.present(self.popup!, animated: false, completion: nil)
        
    }
    
     @IBAction func btnGetReportClicked(_ sender: UIButton) {
        self.getLeadSummary()
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
extension LeadSummary:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(in numberOfSectionsInTableView:Int)->Int{
        return 0 //arrOfSection.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return 26 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count + 6 + leadsummary.byLeadSourceList.count
        return LeadSummary.totalnumberofRecord
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0){
            let cell = UITableViewCell.init()
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 19) //UIFont.boldSystemFont(ofSize: 19)
            cell.textLabel?.text = "Lead Summary Report"
            
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .white
            cell.backgroundColor = UIColor.Appthemecolor
            return cell
        }else if(indexPath.row < 11 ){
            if  let cell =  tableView.dequeueReusableCell(withIdentifier: "fourlblhorizontalcell", for: indexPath) as? FourlblHorizontalCell{
                cell.selectionStyle = .none
                switch indexPath.row {
                case 1:
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor.lightGray
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor.lightGray
                    cell.lbl1.font = UIFont.myBoldSystemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.myBoldSystemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.myBoldSystemFont(ofSize: 17)
                    cell.lbl4.font = UIFont.myBoldSystemFont(ofSize: 17)
                    cell.lbl1.text = "Leads"
                    cell.lbl2.text = "MTD"
                    cell.lbl3.text = "Last Month"
                    cell.lbl3.setMultilineLabel(lbl: cell.lbl3)
                    cell.lbl4.text = "YTD"
                    
                    break
                    
                case 2:
                    cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                    
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.text = "Generated"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDGenerated)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthGenerated)")
                    cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDGenerated)")
                    break
                    
                case 3:
                    cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.text = "Assigned"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDAssigned)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthAssigned)")
                    cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDAssigned)")
                    break
                    
                case 4:
                    cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.text = "Status Uptd"
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDUpdated)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthUpdated)")
                    cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDUpdated)")
                    break
                    
                case 5:
                    cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                    cell.lbl1.text = "Won Count"
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDWon)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthWon)")
                    cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDWon)")
                    break
                    
                case 6:
                    cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                    cell.lbl1.text = "Won Value"
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDWonValue)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthWonValue)")
                    cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDWonValue)")
                    break
                    
                case 7:
                    cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                    cell.lbl1.text = "Lost Count"
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDLost)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthLost)")
                    cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDLost)")
                    break
                    
                case 8:
                    cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                    cell.lbl1.text = "Lost Value"
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDLostValue)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthLostValue)")
                    cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDLostValue)")
                    break
                    
                case 9:
                    cell.lbl1.text = "Postponed"
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDPostponed)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthPostponed)")
                    cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDPostponed)")
                    break
                    
                case 10:
                    cell.lbl1.text = "Cancelled"
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadMTDCancelled)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadLastMonthCancelled)")
                    cell.lbl4.text = String.init(format:"\(leadsummary.LeadYTDCancelled)")
                    break
                    
                default:
                    print("default")
                }
                return cell
            }
            else{
                return UITableViewCell()
            }
        }else if(indexPath.row == 11){
            let cell = UITableViewCell.init()
            cell.selectionStyle = .none
            cell.textLabel?.text = "Active Leads Status"
            cell.textLabel?.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            //cell.backgroundColor = UIColor.white
            return cell
        } else if(indexPath.row < 17){
            if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
                
                cell.selectionStyle = .none
                switch indexPath.row {
                case 12:
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor.lightGray
                    //   cell.lbl4.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xDDDDDD)//UIColor.lightGray
                    cell.lbl1.font = UIFont.myBoldSystemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.myBoldSystemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.myBoldSystemFont(ofSize: 17)
                    
                    
                    
                    cell.lbl1.text = "Order Expected"
                    cell.lbl2.text = "Count"
                    cell.lbl3.text = "Amount"
                    break
                    
                case 13:
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    
                    cell.lbl1.font = UIFont.boldSystemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.boldSystemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.boldSystemFont(ofSize: 17)
                    cell.lbl1.text = "Total"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedTotalCount)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedTotalAmount)")
                    break
                    
                    
                case 14:
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    
                    cell.lbl1.text = "< Previous Month"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedLtPreviousMonthCount)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedLtPreviousMonthAmount)")
                    break
                    
                    
                case 15:
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    
                    cell.lbl1.text = "Previous Month"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedPreviousMonthCount)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedPreviousMonthAmount)")
                    break
                    
                    
                case 16:
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    
                    cell.lbl1.text = "This Month"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedThisMonthCount)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedThisMonthAmount)")
                    break
                    
                    
                case 17:
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl1.text = "Next Month"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadOrderExpectedNextMonthCount)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadOrderExpectedNextMonthAmount)")
                    break
                    
                case 18:
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
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
        }else if(indexPath.row == 19){
            let cell = UITableViewCell.init()
            cell.selectionStyle = .none
            cell.textLabel?.text = "Chances to Win"
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            cell.backgroundColor = UIColor.white
            return cell
        } else if(indexPath.row < 25){
            if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
                
                cell.selectionStyle = .none
                switch indexPath.row {
                case 20:
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl1.text = "<= 20%"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan20Count)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan20Amount)")
                    break
                    
                case 21:
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    
                    cell.lbl1.text = "21 - 40%"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan21To40Count)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan21To40Amount)")
                    break
                    
                    
                case 22:
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl1.text = "41 - 60%"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan41To60Count)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan41To60Amount)")
                    break
                    
                    
                case 23:
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    
                    cell.lbl1.text = "61 - 80%"
                    cell.lbl2.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan61To80Count)")
                    cell.lbl3.text = String.init(format:"\(leadsummary.LeadChanceToWinLessThan61To80Amount)")
                    break
                    
                    
                case 24:
                    cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
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
        }else if(indexPath.row == 25){
            let cell = UITableViewCell.init()
            cell.selectionStyle = .none
            cell.textLabel?.text = "Status"
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            cell.backgroundColor = UIColor.white
            return cell
        } else if(indexPath.row < (26 + leadsummary.byLeadStatusList.count)){
            if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
                
                cell.selectionStyle = .none
                let selectedleadbystatus =  leadsummary.byLeadStatusList[indexPath.row - 26]
                cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                if((indexPath.row - 26)%2 == 0){
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                }else{
                    
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                }
                cell.lbl1.text = selectedleadbystatus.StatusType
                cell.lbl2.text = String.init(format:"\(selectedleadbystatus.Count)")
                cell.lbl3.text = String.init(format:"\(selectedleadbystatus.Amount)")
                
                return cell
            }else{
                return UITableViewCell()
            }
        }else if(indexPath.row == 26 + leadsummary.byLeadStatusList.count){
            let cell = UITableViewCell.init()
            cell.selectionStyle = .none
            cell.textLabel?.text = "Active Leads by Product Category"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            cell.backgroundColor = UIColor.white
            return cell
        }else if(indexPath.row < (27 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count)){
            if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
                
                cell.selectionStyle = .none
                let selectedleadbyproductcategory =  leadsummary.byLeadProductCategoryList[indexPath.row - 27 - leadsummary.byLeadStatusList.count]
                
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                if((indexPath.row - 27 - leadsummary.byLeadStatusList.count)%2 == 0){
                    //            cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                }else{
                    //            cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                }
                
                cell.lbl1.text = selectedleadbyproductcategory.ProductCategory
                cell.lbl2.text = String.init(format:"\(selectedleadbyproductcategory.Count)")
                cell.lbl3.text = String.init(format:"\(selectedleadbyproductcategory.Amount)")
                
                return cell
            }else{
                return UITableViewCell()
            }
        }else if(indexPath.row == 27 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count){
            
            let cell = UITableViewCell.init()
            cell.selectionStyle = .none
            cell.textLabel?.text = "Active Leads by Stage"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            cell.backgroundColor = UIColor.white
            return cell
        }else if(indexPath.row < (28 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count + 6)){
            
            if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                cell.selectionStyle = .none
                cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                if((indexPath.row - 28 - leadsummary.byLeadStatusList.count - leadsummary.byLeadProductCategoryList.count)%2 == 0){
                    
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                }else{
                    cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                }
                switch (indexPath.row - 28 - leadsummary.byLeadStatusList.count - leadsummary.byLeadProductCategoryList.count) {
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
                    print("default = \(indexPath.row) , \(indexPath.row - 28 - leadsummary.byLeadStatusList.count - leadsummary.byLeadProductCategoryList.count)")
                }
                return cell
            }else{
                return UITableViewCell()
            }
        }else if(indexPath.row == 28 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count + 6)  {
            let cell = UITableViewCell.init()
            cell.selectionStyle = .none
            cell.textLabel?.text = "Active Leads by Source"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            cell.backgroundColor = UIColor.white
            return cell
        }else if(indexPath.row < (29 + leadsummary.byLeadStatusList.count + leadsummary.byLeadProductCategoryList.count + 6 + leadsummary.byLeadSourceList.count)){
            
            if  let cell =  tableView.dequeueReusableCell(withIdentifier: "threelblhorizontalcell", for: indexPath) as? ThreeLblHorizontalCell{
                cell.lbl1.font = UIFont.systemFont(ofSize: 17)
                cell.lbl2.font = UIFont.systemFont(ofSize: 17)
                cell.lbl3.font = UIFont.systemFont(ofSize: 17)
                cell.lbl1.backgroundColor = UIColor.AppthemeAqvacolor
                if((indexPath.row - 29 - leadsummary.byLeadStatusList.count - leadsummary.byLeadProductCategoryList.count - 6)%2 == 0){
                    // cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                }else{
                    // cell.lbl1.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEDEDED)//UIColor.lightGray
                    
                    cell.lbl2.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                    cell.lbl3.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xFAFAFA)//UIColor.lightGray
                }
                cell.selectionStyle = .none
                let selectedleadsource = leadsummary.byLeadSourceList[indexPath.row - 29 - leadsummary.byLeadStatusList.count - leadsummary.byLeadProductCategoryList.count - 6]
                cell.lbl1.text = selectedleadsource.Source
                cell.lbl2.text = String.init(format:"\(selectedleadsource.Count)")
                cell.lbl3.text = String.init(format:"\(selectedleadsource.Amount)")
                
                
                return cell
            }else{
                return UITableViewCell()
            }
        }else{
            return UITableViewCell()
        }
    }
    
}
extension LeadSummary:PopUpDelegateNonMandatory{
    
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        arrOfSelectedLowerUser =  arr
        if let selectedUser = arrOfSelectedLowerUser.first as? CompanyUsers{
        lblSelectedSalesPerson.text = String.init(format: "%@ %@", selectedUser.firstName,selectedUser.lastName)
            selectedUserID = selectedUser.entity_id
        }
        
    }
}
