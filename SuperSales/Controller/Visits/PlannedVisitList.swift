//
//  PlannedVisitList.swift
//  SuperSales
//
//  Created by Apple on 17/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import  SVProgressHUD

class PlannedVisitList: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblPlanVisitList: UITableView!
   
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
     @IBOutlet weak var btnSync: UIButton!
    var arrOfCustomers:[CustomerDetails]!
    var arrOfProduct:[Product]!
    var arrProductCatrgory:[ProdCategory]!
    var arrOfExecutive:[CompanyUsers]!
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOfPlanVisit:[PlannVisit] = [PlannVisit]()
    var arrOfSegment:[CustomerSegment]!
    
    var filterUser = 0
    var customerID = 0
    var productID = 0
    var productCategoryID = 0
    var segmentID = -1
    var classID = -1
    let refreshControl = UIRefreshControl.init()
    var popup:CustomerSelection? = nil
    
    var filterDatepicker:UIDatePicker!
   
    var visitType:VisitType!
    var planvisit:PlannVisit!
    var unplanvisit:UnplannedVisit!
    
    var noOfCustomer = 0
    // MARK: - Implementation
    
    override func viewDidLoad() {
     
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                  super.viewDidLoad()
         
        //    Common.showalert(msg: "total push notification is \(AppDelegate.totalpushnotificationno)", view: self)
           self.btnSync.isHidden = false
           self.tblPlanVisitList.delegate = self
           self.tblPlanVisitList.dataSource = self
           self.tblPlanVisitList.separatorColor = .clear
           self.tblPlanVisitList.tableFooterView = UIView()
                                   
                                   if #available(iOS 10.0, *) {
                                      self.tblPlanVisitList.refreshControl = self.refreshControl
                                   } else {
                                      self.tblPlanVisitList.addSubview(self.refreshControl)
                                   }
                          self.refreshControl.addTarget(self, action: #selector(self.getPlannedVisit), for: .valueChanged)
        })
                            
        // Do any additional setup after loading the view.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getPlannedVisit()
        self.setData()
        if(arrOfPlanVisit.count > 0 && tblPlanVisitList.visibleCells.count > 0){
        self.tblPlanVisitList.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
      
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func getPlannedVisit(){
      
        arrOfPlanVisit.removeAll()
        if (filterUser == 0 && customerID == 0 && productID == 0 && productCategoryID == 0 && segmentID == -1 && classID == -1) {
          
            arrOfPlanVisit.append(contentsOf: (PlannVisit.getAllBy(atrname: "seriesPostfix",order: false)))

        }else if(filterUser > 0){
   
    arrOfPlanVisit.append(contentsOf:PlannVisit.getFilteredByAttributes(withAttributeName: "reAssigned", withAttributeValue: String(filterUser)))
            
        }else if (customerID > 0){
     
    arrOfPlanVisit.append(contentsOf:PlannVisit.getFilteredByAttributes(withAttributeName: "customerID", withAttributeValue: String(customerID)))

        }else if(productID > 0){
           
            arrOfPlanVisit.append(contentsOf:PlannVisit.getFilteredByAttributesComplex2(productIDs: [NSNumber.init(value:productID)]))
            print(arrOfPlanVisit.count)
          
        }else if(productCategoryID > 0){
            
            arrOfPlanVisit.append(contentsOf: PlannVisit.getFilteredByAttributesComplex2(productIDs: (Product.getProductIdFromCategoryID(catID: NSNumber(value:productCategoryID)).map {NSNumber(value: $0.productId)})))

        }
        else{
    
        arrOfPlanVisit.append(contentsOf:PlannVisit.getVisitByPredicate(predicate: NSPredicate.init(format: "customerID IN %@", argumentArray: [[CustomerDetails.getCustomersUsingPredicate(predicate:NSPredicate.init(format: "(customerClass = %d) AND type contains[cd] 'U' AND statusID != 3 AND isActive = 1", argumentArray: [classID]))]])))
            
        }
        arrOfPlanVisit = arrOfPlanVisit.filter{
            $0.createdBy == self.activeuser?.userID?.int64Value
        }
        if(self.activesetting.closeVisitUpon == 3){
        for planvisit in arrOfPlanVisit{
            let checkintime = Utils.getDateBigFormatToDefaultFormat(date: planvisit.createdTime ?? "" , format: "dd-MM-yyyy")
            let dateformatter = DateFormatter.init()
            dateformatter.dateFormat = "dd-MM-yyyy"
            let dateinstring = dateformatter.string(from: Date())
            
            let checkintimeDate = dateformatter.date(from: checkintime ?? dateinstring)
            if(Calendar.current.isDateInYesterday(checkintimeDate ?? Date())){
                arrOfPlanVisit = arrOfPlanVisit.filter{
                    let result = PlannVisit.getVisitByPredicate(predicate: NSPredicate.init(format: "iD == %d", argumentArray: [$0.iD ?? 0]))
                    let context = PlannVisit.getContext()
                    print("delelte visits %@",result)
                    if(result.count > 0 ){
                        for visit in result{
                            context.delete(visit)
                        }
                        context.mr_saveToPersistentStore { (status, error) in
                            if(error ==  nil){
                                print("context did saved \(status)")
                                Utils.toastmsg(message:"Visit closed successfully",view:self.view)
                                //   self.navigationController?.popViewController(animated: true)
                            }else{
                                Utils.toastmsg(message:error?.localizedDescription ?? "",view:self.view)
                                
                            }
                        }
                    }
                    
                    return $0 != planvisit
                }
            }
        }
        }
        refreshControl.endRefreshing()
        tblPlanVisitList.reloadData()
        
    }
    func setData(){
        
        DispatchQueue.main.async {
        
        self.filterDatepicker = UIDatePicker.init()
            self.filterDatepicker.setCommonFeature()
          
            self.filterDatepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200 , width: self.view.frame.size.width, height: 200))
            self.filterDatepicker.maximumDate = Date()
        }
        self.salesPlandelegateObject = self
       
        arrOfCustomers =  CustomerDetails.getAllCustomers()
        arrOfProduct   =  Product.getAll()
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
        self.fetchuser{
        (arrOfuser,error) in
        
    }
           })
        arrOfExecutive = BaseViewController.staticlowerUser
        arrProductCatrgory = ProdCategory.getAll()
        arrOfSegment = CustomerSegment.getAll()
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
    
    @IBAction func plusbtnClicked(_ sender: UIButton) {
        let addunplanvisitobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddplanVisitView)
        self.navigationController!.pushViewController(addunplanvisitobj, animated: true)
    }
    
    @IBAction func btnHisotryClicked(_ sender: UIButton) {
        if let historyView = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname:  "visithistorycontainer") as? VisitHistoryContainer{
        historyView.selectedIndex = UInt(0)
        self.navigationController?.pushViewController(historyView, animated: true)
        }
    }
  
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        
        
                let ftcellconfig = FTCellConfiguration.init()
                ftcellconfig.textColor = UIColor.black
                let ftconfig = FTConfiguration.shared
        
                ftconfig.backgoundTintColor =  UIColor.white
        
        FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("by_customer", comment:""),NSLocalizedString("by_products", comment:""),NSLocalizedString("by_user", comment:""),NSLocalizedString("by_product_category", comment:""),NSLocalizedString("by_segment", comment:""),NSLocalizedString("by_class", comment:""),NSLocalizedString("by_created_by", comment:""),NSLocalizedString("all", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (i) in
            print(i)
            switch i{
            case 0:
                //by customer
                self.arrOfPlanVisit.removeAll()
                self.arrOfPlanVisit =  PlannVisit.getAllBy(atrname: "seriesPostfix",order: false)
                Utils.addShadow(view: self.view)
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = ""
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfList = self.arrOfCustomers ?? [CustomerDetails]()
                self.popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
                self.popup?.strLeftTitle = "REFRESH"
                self.popup?.strRightTitle = ""
                self.popup?.selectionmode = SelectionMode.none
                self.popup?.parentViewOfPopup = self.view
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
                self.arrOfPlanVisit.removeAll()
                self.arrOfPlanVisit =  PlannVisit.getAllBy(atrname: "seriesPostfix",order: false)
                Utils.addShadow(view: self.view)
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = ""
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfProduct = self.arrOfProduct
                self.popup?.parentViewOfPopup = self.view
                self.popup?.strLeftTitle = ""
                self.popup?.strRightTitle = ""
                self.popup?.selectionmode = SelectionMode.none
                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = true
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.product
                self.popup?.isFilterRequire = false
                self.popup?.parentViewOfPopup = self.view
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                break
                
            case 2:
                //by user
                self.arrOfPlanVisit.removeAll()
                self.arrOfPlanVisit =  PlannVisit.getAllBy(atrname: "seriesPostfix",order: false)
                Utils.addShadow(view: self.view)
                self.arrOfExecutive = BaseViewController.staticlowerUser
                if let currentuserid = self.activeuser?.userID{
                    if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                        if(!(self.arrOfExecutive.contains(currentuser))){
                    

                            self.arrOfExecutive.append(currentuser)
                        }
                        if(self.arrOfSelectedExecutive.count == 0){
                        self.arrOfSelectedExecutive.append(currentuser)
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
                self.popup?.isFromSalesOrder =  false
                self.popup?.selectionmode = SelectionMode.single
                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = false
                self.popup?.viewfor = ViewFor.companyuser
                self.popup?.isFilterRequire = false
                self.popup?.parentViewOfPopup = self.view
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                break
                
            case 3:
                //by product category
                self.arrOfPlanVisit.removeAll()
                self.arrOfPlanVisit =  PlannVisit.getAllBy(atrname: "seriesPostfix",order: false)
                Utils.addShadow(view: self.view)
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
                self.popup?.parentViewOfPopup = self.view
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                break
                
            case 4:
                //by  segment
                self.arrOfPlanVisit.removeAll()
                self.arrOfPlanVisit =  PlannVisit.getAllBy(atrname: "seriesPostfix",order: false)
                Utils.addShadow(view: self.view)
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = "Select Segment"
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfCustomerSegment = self.arrOfSegment ?? [CustomerSegment]()
                self.popup?.arrOfselectedCustomerSegment = [CustomerSegment]()
                self.popup?.strLeftTitle = "OK"
                self.popup?.strRightTitle = "Cancel"
                self.popup?.selectionmode = SelectionMode.single
                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = false
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.customersegment
                self.popup?.isFilterRequire = false
                self.popup?.parentViewOfPopup = self.view
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                
                break
                
            case 5:
                //by  class
                self.arrOfPlanVisit.removeAll()
                self.arrOfPlanVisit =  PlannVisit.getAllBy(atrname: "seriesPostfix",order: false)
                Utils.addShadow(view: self.view)
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = "Select Class"
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfCustomerClass = Utils().getCustomerClassification()
                self.popup?.arrOfSelectedClass = [String]()
                self.popup?.strLeftTitle = "OK"
                self.popup?.strRightTitle = "Cancel"
                self.popup?.selectionmode = SelectionMode.single
              
                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = false
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.customerClass
                self.popup?.isFilterRequire = false
                self.popup?.parentViewOfPopup = self.view
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                
                break
                
            case 6:
                //created by
                self.arrOfPlanVisit.removeAll()
                self.arrOfPlanVisit =  PlannVisit.getAllBy(atrname: "seriesPostfix",order: false)
                self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:self.filterDatepicker, textfield: nil, withDateMonth: false)
                break
                
            case 7:
                //All
                self.arrOfPlanVisit.removeAll()
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                self.getPlannedVisit()
                break
            default:
                print("nothing")
            }
                }, cancel: {
                     print("cancel tapped")
                })
//        let arrTitle = [NSLocalizedString("by_customer", comment: ""),NSLocalizedString("by_products", comment:""),NSLocalizedString("by_user",comment: ""),NSLocalizedString("by_product_category", comment:""),NSLocalizedString("by_segment", comment:""),NSLocalizedString("by_class", comment:""),NSLocalizedString("by_created_by", comment:""),NSLocalizedString("all", comment:"")]
//
//        FilterPopUp().showpopup(list: arrTitle, btn: sender, parentView: self.view)
     
        
    }
    
    @IBAction func btnSyncClicked(_ sender: UIButton) {
        let ftcellconfig = FTCellConfiguration.init()
          ftcellconfig.textColor = UIColor.black
          let ftconfig = FTConfiguration.shared
          
          ftconfig.backgoundTintColor =  UIColor.white
        
          FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("by_customer", comment:""),NSLocalizedString("asc_visit_no", comment:""),NSLocalizedString("desc_visit_no", comment:""),NSLocalizedString("by_next_action_date", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (i) in
              print(i)
            switch i{
            case 0:
                self.arrOfPlanVisit =   self.arrOfPlanVisit.sorted { $0.customerName!.lowercased() < $1.customerName!.lowercased() }
                self.tblPlanVisitList.reloadData()
                break
                
            case 1:
                self.arrOfPlanVisit = self.arrOfPlanVisit.sorted {
                    $0.seriesPostfix < $1.seriesPostfix
                }
                self.tblPlanVisitList.reloadData()
            break
                
                case 2:
                    self.arrOfPlanVisit = self.arrOfPlanVisit.sorted {
                        $0.seriesPostfix > $1.seriesPostfix
                    }
                    self.tblPlanVisitList.reloadData()
                break
                
                    case 3:
                     //   var dateFormatter = DateFormatter()
                        self.dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss a"// yyyy-MM-dd"
                        
                        self.arrOfPlanVisit.sorted { (visit1, visit2) -> Bool in
                            visit1.nextActionTime?.compare(visit2.nextActionTime ?? "") == .orderedAscending
                        }
                      self.tblPlanVisitList.reloadData()
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
        print("count of planned visit list = \(arrOfPlanVisit.count)")
        return arrOfPlanVisit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell:VisitCell = tableView.dequeueReusableCell(withIdentifier: Constant.VisitListCell, for: indexPath) as? VisitCell{
        let visitobj = arrOfPlanVisit[indexPath.row]
            cell.setData(visit: visitobj,isPlan:true)
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
        let selectedvisit = arrOfPlanVisit[indexPath.row]
        if let selectedCustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:selectedvisit.customerID)) as? CustomerDetails{
            if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
            {
              visitDetail.redirectTo =  0
              visitDetail.planvisit =  selectedvisit
              print("id of visit = \(visitDetail.planvisit?.iD)")
                if let status =  visitDetail.planvisit?.visitStatusID {
              if(status == 3){
                  visitDetail.visitType = VisitType.manualvisit
              }else{
              visitDetail.visitType = VisitType.planedvisit
              }
              }else{
                  visitDetail.visitType = VisitType.planedvisit
              }
          self.navigationController?.pushViewController(visitDetail, animated: true)
              }
        }else{
            SVProgressHUD.show()
            Utils().getCustomerDetail(cid: NSNumber.init(value:selectedvisit.customerID)) { (status) in
                SVProgressHUD.dismiss()
                if   let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail
                {
                  visitDetail.redirectTo =  0
                  visitDetail.planvisit =  selectedvisit
                  print("id of visit = \(visitDetail.planvisit?.iD)")
                    if let status =  visitDetail.planvisit?.visitStatusID {
                  if(status == 3){
                      visitDetail.visitType = VisitType.manualvisit
                  }else{
                  visitDetail.visitType = VisitType.planedvisit
                  }
                  }else{
                      visitDetail.visitType = VisitType.planedvisit
                  }
              self.navigationController?.pushViewController(visitDetail, animated: true)
                  }
                }
            }
      
    }
}
extension PlannedVisitList:PopUpDelegateNonMandatory{
 
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedcustomer = arr.first
            filterUser = 0
            productID = 0
            productCategoryID = 0
            
            customerID = Int(selectedcustomer?.iD ?? 0)
            self.getPlannedVisit()
        }
    }
    
    func completionProductData(arr: [Product]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedproduct = arr.first
            productID = Int(selectedproduct?.productId ?? 0)
            customerID = 0
            filterUser = 0
            productCategoryID = 0
            self.getPlannedVisit()
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
             self.getPlannedVisit()
        }
    }
    
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            self.arrOfSelectedExecutive = arr
            let selectedexecutive = arr.first
           
            filterUser = selectedexecutive?.entity_id as? Int ?? 0
            customerID = 0
            productID = 0
            productCategoryID = 0
             self.getPlannedVisit()
        }
    }
    func completionSelectedSegment(arr: [CustomerSegment]) {
        Utils.removeShadow(view: self.view)
      //  arrOfSelectedSegment =  arr
      //  self.tfCustomerSegment.text =  arr.first?.customerSegmentValue
         let customerSegmentIndex =  NSNumber.init(value:arr.first?.iD ?? 0)
       
        
        arrOfPlanVisit = arrOfPlanVisit.filter({ (objlead) -> Bool in
        
            if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objlead.customerID)) as? CustomerDetails{
            return customer.segmentID == customerSegmentIndex.int64Value
            }else{
                return false
            }
        })
        tblPlanVisitList.reloadData()
    }
    
    func completionSelectedClass(arr: [String], recordno: Int, strTitle: String) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
//            self.arrOfSelectedClass =  arr
           let customerClassIndex = NSNumber.init(value:recordno + 1)
            arrOfPlanVisit = arrOfPlanVisit.filter({ (objlead) -> Bool in
                if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objlead.customerID)) as? CustomerDetails{
                return customer.customerClass == customerClassIndex.int64Value
                }else{
                    return false
                }
            })
        }
        tblPlanVisitList.reloadData()
    }
    
    
}

extension PlannedVisitList:BaseViewControllerDelegate{
    func datepickerSelectionDone(){
        var parameter = Common.returndefaultparameter()
        let calender = NSCalendar.current
        let startdt = calender.date(bySettingHour: 0, minute: 0, second: 1, of: filterDatepicker.date)
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let strdate = dateFormatter.string(from: startdt!)
        let enddt = calender.date(bySettingHour: 23, minute: 23, second: 59, of: filterDatepicker.date)
        let strenddate = dateFormatter.string(from: enddt!)
        let param = ["CreatedBy":self.activeuser?.userID ??  0 ,"CompanyID":self.activeuser?.company?.iD ?? 0,"FilterType":"0","SortType":"0","StartDate":strdate,"EndDate":strenddate] as [String : Any]
        parameter["getPlannedVisitsJson"] =  Common.returnjsonstring(dic: param)
        self.apihelper.getdeletejoinvisit(param: parameter, strurl: ConstantURL.kWSUrlGetMappedPlannedVisits, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                print(arr)
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
