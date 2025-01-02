//
//  UnplannedVisitList.swift
//  SuperSales
//
//  Created by Apple on 17/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class UnplannedVisitList: BaseViewController ,UITableViewDataSource,UITableViewDelegate {
    // swiftlint:disable line_length
    var sortBy = 0
    var filterType = 0
  //  var filterUser = 0
    var customerID = 0
    var userID = 0
    var productID = 0
    var productCategoryID = 0
    var startDate = ""
    var endDate = ""
    
   
    
    
    @IBOutlet weak var tblUnplanvisitList: UITableView!
    
    @IBOutlet weak var btnSync: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    var popup:CustomerSelection? = nil
    var arrOfExecutive:[CompanyUsers]!
    var arrOfselectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOfProduct:[Product]!
    var arrProductCatrgory:[ProdCategory]!
    var arrUnPlannedList:[UnplannedVisit]!
    var filterDatepicker:UIDatePicker!
    
    override func viewDidLoad() {
        
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        super.viewDidLoad()
        
        self.apihelper.pageCurrent = 1
            self.btnSync.isHidden = false
           
    
            self.tblUnplanvisitList.delegate = self
            self.tblUnplanvisitList.dataSource = self
            self.tblUnplanvisitList.separatorColor = .clear
            self.tblUnplanvisitList.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    
    self.setData()
            
   
        })
         self.arrUnPlannedList = [UnplannedVisit]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         self.getUnplannedVisitList()
        if(arrUnPlannedList.count > 0 && self.tblUnplanvisitList.visibleCells.count > 0){
        self.tblUnplanvisitList.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    func setData(){
        filterDatepicker = UIDatePicker.init()
        filterDatepicker.setCommonFeature()
          
        filterDatepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        filterDatepicker.maximumDate = Date()
        
         self.salesPlandelegateObject = self
        if let userID = self.activeuser?.userID {
            self.userID = Int(userID)
        }
       
      //  arrOfCustomers =  CustomerDetails.getAllCustomers()
        arrOfProduct   =  Product.getAll()
  //      DispatchQueue.global(qos: .background).async {
        self.fetchuser{
        (arrOfuser,error) in
        }
   // }
        arrOfExecutive = self.lowerExecutiveUser
        arrProductCatrgory = ProdCategory.getAll()
        
      //  arrOfSegment = CustomerSegment.getAll()
        
    }
    func getUnplannedVisitList(){
        //getUnplannedVisitList
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.apihelper.getVisitForListingWithFilter(visitType: "unplanned", filteruser: String(userID), filterProduct: String(productID), filteredCustomerId: String(customerID), filterCatagroyID: String(productCategoryID), filterType: String(filterType), sortType: String(sortBy), statrtTime: startDate, endTime: endDate) {
            (totalpages,pagesavailable,lastsynctime,result,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(error.code == 0){
                
                self.arrUnPlannedList.removeAll()
                
                self.arrUnPlannedList = result as? [UnplannedVisit]
                self.tblUnplanvisitList.reloadData()
            }else{
                print(error.localizedDescription)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - IBAction
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        
        let ftcellconfig = FTCellConfiguration.init()
        ftcellconfig.textColor = UIColor.black
        let ftconfig = FTConfiguration.shared
        
        ftconfig.backgoundTintColor =  UIColor.white
        
        FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("by_products", comment:""),NSLocalizedString("by_user", comment:""),NSLocalizedString("by_product_category", comment:""),NSLocalizedString("by_created_by", comment:""),NSLocalizedString("all", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (int) in
            print(int)
            self.arrUnPlannedList.removeAll()
            switch int{
            case 0:
                //by product
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = ""
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfProduct = self.arrOfProduct
                self.popup?.arrOfSelectedProduct = [Product]()
                self.popup?.strLeftTitle = ""
                self.popup?.strRightTitle = ""
                self.popup?.selectionmode = SelectionMode.none
                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = true
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.product
                self.popup?.isFilterRequire = false
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                break
                
            case 1:
                //by user
                self.arrOfExecutive = BaseViewController.staticlowerUser
               
                if let currentuserid = self.activeuser?.userID{
                    if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                        if(!(self.arrOfExecutive.contains(currentuser))){
                    

                            self.arrOfExecutive.append(currentuser)
                        }
                        if(self.arrOfselectedExecutive.count == 0){
                        self.arrOfselectedExecutive.append(currentuser)
                        }
                    }
                    
                }
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = "Select User"
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfExecutive = self.arrOfExecutive
                self.popup?.arrOfSelectedExecutive = self.arrOfselectedExecutive ?? [CompanyUsers]()
                self.popup?.strLeftTitle = "OK"
                self.popup?.strRightTitle = "Cancel"
                self.popup?.selectionmode = SelectionMode.single
                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = false
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.companyuser
                self.popup?.isFilterRequire = false
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                break
                
            case 2:
                //by product category
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = ""
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfProductCategory = self.arrProductCatrgory ?? [ProdCategory]()
                self.popup?.arrOfSelectedProductCategory = [ProdCategory]()
                self.popup?.strLeftTitle = ""
                self.popup?.strRightTitle = ""
                self.popup?.selectionmode = SelectionMode.none
                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = true
                self.popup?.viewfor = ViewFor.productcategory
                self.popup?.isFilterRequire = false
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)

                break
                
            case 3:
                //by created by
                
                self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker: self.filterDatepicker, textfield: nil, withDateMonth: false)
                break
                
                
            case 4:
                //by  all
                self.sortBy = 0
                self.filterType = 5
               // self.filterUser = 0
                 self.customerID = 0
                self.userID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.startDate = ""
                self.endDate = ""
                 self.getUnplannedVisitList()
                break
            default:
                print("nothing")
            }
        }, cancel: {
            print("cancel tapped")
        })
        
    }
    
    @IBAction func btnSyncClicked(_ sender: UIButton) {
        let ftcellconfig = FTCellConfiguration.init()
                ftcellconfig.textColor = UIColor.black
                let ftconfig = FTConfiguration.shared
        
                ftconfig.backgoundTintColor =  UIColor.white
        //[FTPopOverMenu showForSender:sender withMenuArray:@[NSLocalizedString(@"by_customer", @""),NSLocalizedString(@"asc_visit_no", @""),NSLocalizedString(@"desc_visit_no", @""),NSLocalizedString(@"by_next_action_date", @"")]
        FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("asc_visit_no", comment:""),NSLocalizedString("desc_visit_no", comment:""),NSLocalizedString("by_next_action_date", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (i) in
            print(i)
            switch i{
            
                
            case 0:
                self.arrUnPlannedList = self.arrUnPlannedList.sorted {
                    $0.seriesPostfix?.intValue ?? 0 < $1.seriesPostfix?.intValue ?? 0
                }
                self.tblUnplanvisitList.reloadData()
            break
                
                case 1:
                    self.arrUnPlannedList = self.arrUnPlannedList.sorted {
                        $0.seriesPostfix?.intValue ?? 0 > $1.seriesPostfix?.intValue ?? 0
                    }
                    self.tblUnplanvisitList.reloadData()
                break
                
                    case 2:
                     //   var dateFormatter = DateFormatter()
//                        self.dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"// yyyy-MM-dd"
//                        
//                        self.arrUnPlannedList =  self.arrUnPlannedList.sorted(by: {
//                            print($0.NextActionTime ?? "")
//                            print(self.dateFormatter.date(from:$0.NextActionTime!))
//                            return self.dateFormatter.date(from:$0.NextActionTime!)!.compare(self.dateFormatter.date(from:$1.NextActionTime!)!) == .orderedDescending })
                      self.tblUnplanvisitList.reloadData()
                    break
            default:
                print("default case")
            }
        }, cancel: {
             print("cancel tapped")
        })
    }
    // MARK: - UITableviewdeleagate , UITableviewdatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return arrUnPlannedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:VisitCell = tableView.dequeueReusableCell(withIdentifier: Constant.VisitListCell, for: indexPath) as? VisitCell{
        let visitobj = arrUnPlannedList[indexPath.row]
         cell.stackViewAssignDetail.isHidden = true
       cell.setUnplanVisitData(dict:visitobj)
       
     
        return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if  let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
      {
         visitDetail.visitType = VisitType.coldcallvisit
        visitDetail.redirectTo =  0
        visitDetail.unplanvisit = arrUnPlannedList[indexPath.row]; self.navigationController?.pushViewController(visitDetail, animated: true)
        }
    }
    //MARK - IBAction
    
    @IBAction func plusbtnClicked(_ sender: UIButton) {
        let addunplanvisitobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddUnplanVisitView)
        self.navigationController!.pushViewController(addunplanvisitobj, animated: true)
    }
    
    @IBAction func btnHistoryClicked(_ sender: UIButton) {
        if let historyView = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname:  "visithistorycontainer") as? VisitHistoryContainer
       {
        historyView.selectedIndex = UInt(1)
        self.navigationController?.pushViewController(historyView, animated: true)
        }
    }
    
}
extension UnplannedVisitList:PopUpDelegateNonMandatory{
    
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedcustomer = arr.first
            customerID = Int(selectedcustomer?.iD ?? 0)
            productID = 0
            productCategoryID = 0
            userID = 0
            filterType = 1
           self.getUnplannedVisitList()
        }
    }
    
   
    
    func completionProductData(arr: [Product]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedproduct = arr.first
            productID = Int(selectedproduct?.productId ?? 0)
            customerID = 0
            productCategoryID = 0
            userID = 0
            filterType = 2
            self.getUnplannedVisitList()
        }
    }
    
    func completionProductCategory(arr: [ProdCategory]) {
        Utils.removeShadow(view: self.view)
        if(arr.count > 0){
            let selectedCategory = arr.first
            productCategoryID = Int(selectedCategory?.iD ?? 0)
            customerID = 0
            productID = 0
            userID = 0
            filterType = 3
            self.getUnplannedVisitList()
        }
    }
    
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedexecutive = arr.first
            self.arrOfselectedExecutive = arr
            userID = selectedexecutive?.entity_id.intValue ?? self.activeuser?.userID as? Int ?? 0
            customerID = 0
            productID = 0
            productCategoryID = 0
            filterType = 1
             self.getUnplannedVisitList()
        }
    }
    
    
}
extension UnplannedVisitList:BaseViewControllerDelegate{
    func datepickerSelectionDone(){
        
        let calender = NSCalendar.current
        let startdt = calender.date(bySettingHour: 0, minute: 0, second: 1, of: self.filterDatepicker.date)
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        startDate = dateFormatter.string(from: startdt!)
        let enddt = calender.date(bySettingHour: 23, minute: 23, second: 59, of: self.filterDatepicker.date)
        endDate = dateFormatter.string(from: enddt!)
        filterType = 0
        self.getUnplannedVisitList()
}
    func cancelbtnTapped() {
          self.filterDatepicker.removeFromSuperview()
       }
}
