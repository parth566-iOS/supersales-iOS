//
//  HisotryPlannedVisitList.swift
//  SuperSales
//
//  Created by Apple on 27/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import  SVProgressHUD

class HistoryPlannedVisitList: BaseViewController,UITableViewDataSource,UITableViewDelegate {
   // var customerclass = 0
    var sortBy = 0
    var filterType = 0
    var filterUser = 0
    var customerID = 0
    var productID = 0
    var segmentID = 0
    var productCategoryID = 0
    let startDate = ""
    let endDate = ""
   
    let refreshControl = UIRefreshControl.init()
    
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBOutlet weak var btnSync: UIButton!
    @IBOutlet weak var tblPlanvisitHistoryList: UITableView!
    
    var popup:CustomerSelection? = nil
    var arrOfPlanVisitHistory:[PlannVisit] = [PlannVisit]()
    var arrOfCustomers:[CustomerDetails]!
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOfProduct:[Product]!
    var arrProductCatrgory:[ProdCategory]!
    var arrOfExecutive:[CompanyUsers]!
    var arrOfPlanVisit:[PlannVisit] = [PlannVisit]()
    var arrOfSegment:[CustomerSegment]!
     var filterDatepicker:UIDatePicker!
    
    var noOfCustomer = 0
    // MARK: - Implementation
    
    override func viewDidLoad() {
     
       
          DispatchQueue.main.async {
        super.viewDidLoad()
          
            self.btnSync.isHidden = false
            self.tblPlanvisitHistoryList.delegate = self
            self.tblPlanvisitHistoryList.dataSource = self
            self.tblPlanvisitHistoryList.separatorColor = .clear
            self.tblPlanvisitHistoryList.tableFooterView = UIView()
        if #available(iOS 10.0, *) {
            self.tblPlanvisitHistoryList.refreshControl = self.refreshControl
        } else {
            self.tblPlanvisitHistoryList.addSubview(self.refreshControl)
        }
            self.refreshControl.addTarget(self, action: #selector(self.getPlannedVisitHistory), for: .valueChanged)
       
        // Do any additional setup after loading the view.
        self.setData()
        self.getPlannedVisitHistory()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    if(arrOfPlanVisitHistory.count > 0 && tblPlanvisitHistoryList.visibleCells.count > 0){
    self.tblPlanvisitHistoryList.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
    }
    }
    func setData(){
        filterDatepicker = UIDatePicker.init()
        filterDatepicker.setCommonFeature()
          
        filterDatepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        filterDatepicker.maximumDate = Date()
        self.salesPlandelegateObject = self
        arrOfCustomers =  CustomerDetails.getAllCustomers()
        arrOfProduct   =  Product.getAll()
    //    DispatchQueue.global(qos: .background).async {
        self.fetchuser{
            (arrOfuser,error) in
            
        }
     //   }
        arrOfExecutive = self.lowerExecutiveUser
        arrProductCatrgory = ProdCategory.getAll()
        arrOfSegment = CustomerSegment.getAll()
    }
    @objc func getPlannedVisitHistory(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.apihelper.getVisitForListingWithFilter(visitType: "closeplanned", filteruser: String(filterUser) , filterProduct: String(productID), filteredCustomerId: String(customerID), filterCatagroyID: String(productCategoryID), filterType: String(filterType), sortType:  String(sortBy), statrtTime: startDate, endTime: endDate) { (totalpages,pagesavailable,lastsynctime,result,status,message,error,responseType) in
           
            self.refreshControl.endRefreshing()
            if(error.code == 0){
                print(result)
                self.arrOfPlanVisitHistory.removeAll()
                
                self.arrOfPlanVisitHistory = result as? [PlannVisit] ?? [PlannVisit]()
                self.tblPlanvisitHistoryList.reloadData()
                 SVProgressHUD.dismiss()
            }else{
                 SVProgressHUD.dismiss()
                print(error.localizedDescription)
            }
        }
    }
    //MARK: API Call
//    func getTaagedCustomer(pageno:Int,trimmedstring:String){
//      
//        var param = Common.returndefaultparameter()
//        param["Filter"] = trimmedstring
//        param["PageNo"] = pageno
//        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetAllTaggedCustomer, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
//           
//            if(status.lowercased() == Constant.SucessResponseFromServer){
//                
//                let arrOfTaggedCustomer = arr as? [[String:Any]] ?? [[String:Any]]()
//                
//                
//                print("array of customer = \(arrOfTaggedCustomer.count) for page no  = \(pageno) , \(pagesavailable),\(totalpages)")
//            if(arrOfTaggedCustomer.count > 0){
//            MagicalRecord.save({ (localcontext) in
//                if(pageno == 1){
//            CustomerDetails.mr_truncateAll(in: localcontext)
//                }
//    
//                
//            
//            FEMDeserializer.collection(fromRepresentation: arrOfTaggedCustomer, mapping: CustomerDetails.defaultmapping(), context: localcontext)
//              
//                
//                           localcontext.mr_save({ (localcontext) in
//                               //print("saving")
//                           }, completion: { (status, error) in
//                               //print("saved")
//                           })
//                            
//                                
//
//                       }, completion: { (status, error) in
//                          
//                        if(error?.localizedDescription == ""){
//                            print("tagged customer saved sucessfully total customer = \(CustomerDetails.getAllCustomers().count)")
//                            
//                        }else{
//                            //print(error?.localizedDescription ?? "")
//                        }
//
//                        })
//           
//                if(pageno < totalpages){
//                    print("page is available for tagged customer api \(pagesavailable)")
//                    self.getTaagedCustomer(pageno: pageno + 1 ,trimmedstring: trimmedstring)
//                    
//                }else{
//                    SVProgressHUD.dismiss()
//                    self.arrOfCustomers = CustomerDetails.getAllCustomers()
//                   
//                        self.arrAllCustomer = self.arrOfCustomers.map{ $0.name } as? [NSString] ?? [NSString]()
//                    
//                        self.filteredCustomer =
//                            self.arrAllCustomer.filter({(item: NSString) -> Bool in
//                            return item.localizedCaseInsensitiveContains(trimmedstring ?? "") == true
//                        })
//                   
//                        self.arrOffilteredCustomer =
//                            self.arrOfCustomers.compactMap { (temp) -> CustomerDetails in
//                            return temp
//                            }.filter { (aUser) -> Bool in
//                                return aUser.name?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true
//                    }
//                        
//                        self.customerDropdown.dataSource = self.filteredCustomer as [String]
//                        self.customerDropdown.reloadAllComponents()
//                        self.customerDropdown.show()
//                
//        }
//            }else{
//                SVProgressHUD.dismiss()
//                 Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String ?? "" ?? message, view: self.view)
//            }
//            }else{
//                SVProgressHUD.dismiss()
//                 Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String ?? "" ?? message, view: self.view)
//                
//            }
//    }
//    }
    
    // MARK: - IBAction
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        
        let ftcellconfig = FTCellConfiguration.init()
        ftcellconfig.textColor = UIColor.black
        let ftconfig = FTConfiguration.shared
        
        ftconfig.backgoundTintColor =  UIColor.white
        
        FTPopOverMenu.showForSender(sender: sender, with:  [NSLocalizedString("by_customer", comment:""),NSLocalizedString("by_products", comment:""),NSLocalizedString("by_user", comment:""),NSLocalizedString("by_product_category", comment:""),NSLocalizedString("by_created_by", comment:""),NSLocalizedString("all", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (i) in
            print(i)
            self.arrOfPlanVisitHistory.removeAll()
            switch i{
            case 0:
                //by customer
                
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = ""
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfList = self.arrOfCustomers ?? [CustomerDetails]()
                self.popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
                self.popup?.strLeftTitle = "OK"
                self.popup?.strRightTitle = "Cancel"
                self.popup?.selectionmode = SelectionMode.single
                //                popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = true
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.customer
                self.popup?.isFilterRequire = false
                // popup?.showAnimate()
                if(self.noOfCustomer < CustomerDetails.getAllCustomers().count){
                self.present(self.popup!, animated: false, completion: nil)
                }
                break
                
            case 1:
                //by product
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = ""
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfProduct = self.arrOfProduct
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
                
            case 2:
                //by user
                self.arrOfExecutive = BaseViewController.staticlowerUser
                if let currentuserid = self.activeuser?.userID{
                    if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                        if(!(self.arrOfExecutive.contains(currentuser))){
                    

                            self.arrOfExecutive.append(currentuser)
                        }
                        if(self.arrOfSelectedExecutive.count == 0){
                            self.arrOfSelectedExecutive = [currentuser]
                        }
                    }
                }
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = "Select User"
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfExecutive = self.arrOfExecutive
                self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [CompanyUsers]()
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
                
            case 3:
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
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.productcategory
                self.popup?.isFilterRequire = false
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                break
                
           
                
           
                
            case 4:
                //created by
                self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:  self.filterDatepicker, textfield: nil, withDateMonth: false)
                break
                
            case 5:
                //All
                self.arrOfPlanVisit.removeAll()
                self.filterType = 5
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
               
                self.getPlannedVisitHistory()
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
                  FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("by_customer", comment:""),NSLocalizedString("asc_visit_no", comment:""),NSLocalizedString("desc_visit_no", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (i) in
                      print(i)
                    switch i{
                    case 0:
                        self.arrOfPlanVisitHistory =   self.arrOfPlanVisitHistory.sorted { $0.customerName!.lowercased() < $1.customerName!.lowercased() }
                        self.tblPlanvisitHistoryList.reloadData()
                        break
                        
                    case 1:
                        self.arrOfPlanVisitHistory = self.arrOfPlanVisitHistory.sorted {
                            $0.seriesPostfix < $1.seriesPostfix
                        }
                        self.tblPlanvisitHistoryList.reloadData()
                    break
                        
                        case 2:
                            self.arrOfPlanVisitHistory = self.arrOfPlanVisitHistory.sorted {
                                $0.seriesPostfix > $1.seriesPostfix
                            }
                            self.tblPlanvisitHistoryList.reloadData()
                        break
                        
                       
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
        print("count of planned visit history = \(arrOfPlanVisitHistory.count)")
        return arrOfPlanVisitHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:VisitCell = tableView.dequeueReusableCell(withIdentifier: Constant.VisitListCell, for: indexPath) as? VisitCell{
        let visitobj = arrOfPlanVisitHistory[indexPath.row]
            cell.setData(visit: visitobj,isPlan:false)
        cell.lblCheckinDetail.isHidden = true
        cell.stackViewNextActionDetail.isHidden = true
        cell.lblCreatedBy.isHidden = true
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
        if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
        {
        visitDetail.visitType = VisitType.planedvisitHistory
       
        visitDetail.redirectTo =  0
        visitDetail.planvisit = arrOfPlanVisitHistory[indexPath.row]; self.navigationController?.pushViewController(visitDetail, animated: true)
        }
    }
}
extension HistoryPlannedVisitList:PopUpDelegateNonMandatory{
    
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedcustomer = arr.first
            customerID = Int(selectedcustomer?.iD ?? 0)
            productID = 0
            productCategoryID = 0
            filterUser = 0
            filterType = 1
            self.getPlannedVisitHistory()
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
            filterUser = 0
            filterType = 2
            self.getPlannedVisitHistory()
        }
    }
    
    func completionProductCategory(arr: [ProdCategory]) {
        Utils.removeShadow(view: self.view)
        if(arr.count > 0){
            let selectedCategory = arr.first
            productCategoryID = Int(selectedCategory?.iD ?? 0)
            customerID = 0
            productID = 0
            filterUser = 0
            filterType = 3
            self.getPlannedVisitHistory()
        }
    }
    
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedexecutive = arr.first
           self.arrOfSelectedExecutive = arr
            filterUser = selectedexecutive?.entity_id.intValue ?? (self.activeuser?.userID?.intValue)!
            customerID = 0
            productID = 0
            productCategoryID = 0
            filterType = 1
            self.getPlannedVisitHistory()
        }
    }
    
    
}

extension HistoryPlannedVisitList:BaseViewControllerDelegate{
    func datepickerSelectionDone(){
        var parameter = Common.returndefaultparameter()
        filterType = 0
        let calender = NSCalendar.current
        let startdt = calender.date(bySettingHour: 0, minute: 0, second: 1, of: self.filterDatepicker.date)
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let strdate = dateFormatter.string(from: startdt!)
        let enddt = calender.date(bySettingHour: 23, minute: 23, second: 59, of: self.filterDatepicker.date)
        let strenddate = dateFormatter.string(from: enddt!)
        let param = ["CreatedBy":self.activeuser?.userID ?? NSNumber.init(value: 0) ,"CompanyID":self.activeuser?.company?.iD ?? 0,"FilterType":"0","SortType":"0","StartDate":strdate,"EndDate":strenddate] as [String : Any]
        parameter["getPlannedVisitsJson"] =  Common.returnjsonstring(dic: param)
        self.apihelper.getdeletejoinvisit(param: parameter, strurl: ConstantURL.kWSUrlGetMappedPlannedVisits, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                print(arr)
           
                if(error.code == 0){
                 
                    self.arrOfPlanVisitHistory.removeAll()
                    
                    self.arrOfPlanVisitHistory = arr as? [PlannVisit] ?? [PlannVisit]()
                    self.tblPlanvisitHistoryList.reloadData()
                     SVProgressHUD.dismiss()
                }else{
                     SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
            }else{
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }
        }
        
    }
    func cancelbtnTapped() {
       self.filterDatepicker.removeFromSuperview()
    }
}
