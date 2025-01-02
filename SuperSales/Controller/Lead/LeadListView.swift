//
//  LeadList.swift
//  SuperSales
//
//  Created by Apple on 27/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class LeadListView: BaseViewController {
    
    //swift:disable line_length
    
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var tblLeadList: UITableView!
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnSync: UIButton!
    
    @IBOutlet weak var btnHistory: UIButton!
    var isCreatedBy:Bool = false
    var arrOFLeadoutCome:[Outcomes] = []
    var arrOfSelectedLeadOutCome:[Outcomes] = []
    var arrOfLead:[Lead] = [Lead]()
    var filterType = 7
    var filterUser = 0
    var customerID = 0
    var productID = 0
    var productCategoryID = 0
    var segmentID = -1
    var classID = -1
    var sortType = ""
    var popup:CustomerSelection? = nil
    var customerSegmentIndex =  NSNumber.init(value:0)
    var customerClassIndex = NSNumber.init(value:0)
    //Bottom menu
    let baseviewcontrollerobj = BaseViewController()
    
    var sideMenus:[CompanyMenus]!
    var companyMenus:[CompanyMenus]!
    var temp:[UPStackMenuItem]!
    var arrOfBottomTabBar:[MenuTabs]!
    var arrTabbarItem:[UITabBarItem]!
    var arrOfCustomers:[CustomerDetails]!
    var arrOfProduct:[Product]! = [Product]()
    var arrProductCatrgory:[ProdCategory]!
    var arrOfExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrofSelectedClass:[String]! = [String]()
    
    var arrOfSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrOfSelectedSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrOfSelectedClass:[String]! = [String]()
    
    let refreshControl = UIRefreshControl.init()
    
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            super.viewDidLoad()
            SVProgressHUD.setDefaultMaskType(.black)
            self.setUI()
            // Do any additional setup after loading the view.
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        //        self.setrightbtn(btnType: BtnRight.none,navigationItem:self.tabBarController!.navigationItem)
        //           self.tabBarController?.navigationItem.title = "Lead"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.filterType = 7
        self.filterUser = 0
        self.customerID = 0
        self.productID = 0
        self.productCategoryID = 0
        self.segmentID = -1
        self.classID = -1
        if(arrOfLead.count > 0 && tblLeadList.visibleCells.count > 0){
            self.tblLeadList.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        
        self.getLeadList() {
            self.getTaggedUserList()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        //        if((BaseViewController.stackparentView?.subviews.contains(BaseViewController.blurEffectVisusalView)) != nil){
        //
        //            self.changeDemo(sender: baseviewcontrollerobj.btnPlus)
        //        }
    }
    
    // MARK: Method
    func setUI(){
        //        self.navigationController?.title = "Lead"
        //         self.tabBarController?.title  = "Lead"
        self.arrOFLeadoutCome = Outcomes.getAll()
        btnHistory.setAttributedTitle(NSAttributedString.init(string: "History", attributes: [NSAttributedString.Key.underlineStyle : 1 , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]), for: UIControl.State.normal)
        self.btnRefresh.setAttributedTitle(NSAttributedString.init(string: "Refresh", attributes: [NSAttributedString.Key.underlineStyle : 1 , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]), for: UIControl.State.normal)
        self.parentviewController = self
        self.salesPlandelegateObject = self
        baseviewcontrollerobj.salesPlandelegateObject = self
        tblLeadList.delegate = self
        tblLeadList.dataSource = self
        tblLeadList.tableFooterView = UIView()
        tblLeadList.separatorColor = UIColor.clear
        
        sideMenus = [CompanyMenus]()
        sideMenus = self.createUPStackMenuItems(isFromHome: true, view: self)
        companyMenus = [CompanyMenus]()
        temp = [UPStackMenuItem]()
        companyMenus = baseviewcontrollerobj.createUPStackMenuItems(isFromHome: true, view: self)
        for tempitem in companyMenus{
            print("\(tempitem.menuID) , \(tempitem.menuLocalText ?? "" )")
            if   let upstackmenu = UPStackMenuItem.init(image:  CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16)) as? UPStackMenuItem{
                
                temp.append(upstackmenu )
            }else{
                temp.append(UPStackMenuItem())
            }
        }
        arrTabbarItem = [UITabBarItem]()
        //     arrOfBottomTabBar = MenuTabs.getTabMenus(menu: [NSNumber.init(value: 0),NSNumber.init(value: 1),NSNumber.init(value: 2)], sort: true)
        arrOfBottomTabBar = MenuTabs.getTabMenus(menu:[0,1,2],sort:true)
        //  titlesOfButtons = arrOfBottomTabBar.map{ $0.menuLocalText }
        if(temp.count > 0){
            baseviewcontrollerobj.initbottomMenu(menus:temp , control: self)
        }
        arrOfCustomers =  CustomerDetails.getAllCustomers()
        arrOfProduct   =  Product.getAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            if(BaseViewController.staticlowerUser.count == 0){
                self.fetchuser{
                    (arrOfuser,error) in
                    
                }
            }
        })
        
        arrOfExecutive = BaseViewController.staticlowerUser
        arrProductCatrgory = ProdCategory.getAll()
        arrOfSegment = CustomerSegment.getAll()
        if #available(iOS 10.0, *) {
            tblLeadList.refreshControl = refreshControl
        } else {
            tblLeadList.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    @objc private func refreshWeatherData(_ sender: Any) {
        //        // Fetch Weather Data
        getLeadList()
    }
    func resetFilter(){
        self.arrOfLead.removeAll()
        self.filterType = 7
        self.filterUser = 0
        self.customerID = 0
        self.productID = 0
        self.productCategoryID = 0
        self.segmentID = -1
        self.classID = -1
        
        self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
    }
    
    func getLeadList(completion: (() -> Void)? = nil){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        arrOfLead.removeAll()
        
        if (filterUser == 0 && customerID == 0 && productID == 0 && productCategoryID == 0 && segmentID == -1 && classID == -1) {
            arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
            
            
        }else if(filterUser > 0){
            arrOfLead.append(contentsOf:Lead.getFilteredByAttributes(withAttributeName: "reAssigned", withAttributeValue: String(filterUser)))
        }else if (customerID > 0){
            arrOfLead.append(contentsOf:Lead.getFilteredByAttributes(withAttributeName: "customerID", withAttributeValue: String(customerID)))
            
        }else if(productID > 0){
            arrOfLead.append(contentsOf:Lead.getFilteredByAttributesComplex2(productIDs: [NSNumber.init(value:productID)]))
        }else if(productCategoryID > 0){
            arrOfLead.append(contentsOf: Lead.getFilteredByAttributesComplex2(productIDs: (Product.getProductIdFromCategoryID(catID: NSNumber(value:productCategoryID)).map {NSNumber(value: $0.productId)})))
        }
        else{
            //arrOfLead.append(contentsOf:Lead.get(predicate: NSPredicate.init(format: "customerID IN %@", argumentArray: [[CustomerDetails.getCustomersUsingPredicate(predicate:NSPredicate.init(format: "(customerClass = %d) AND type contains[cd] 'U' AND statusID != 3 AND isActive = 1", argumentArray: [classID]))]])))
        }
        self.refreshControl.endRefreshing()
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
            self.tblLeadList.reloadData()
        }
        completion?()
    }
    
   func refreshButtonClicked() {
       self.apihelper.getSyncedLead(compeletion:{ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
           in
           if(error.code == 0) {
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                   self.getLeadList()
//                   completion?()
               }
           }
       })
    }
    
    func getTaggedUserList() {
        self.apihelper.getTaggedCustomerList(pageno: 1 , pagesize: Constant.CustomerPageSize, completion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(error.code == 0){
            }
        })
    }
    
    // MARK: - IBAction
    
    
    @IBAction func btnHisotryClicked(_ sender: UIButton) {
        
        if let historyView = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadListHistoryView) as? LeadHistory{
            
            self.navigationController?.pushViewController(historyView, animated: true)
        }
    }
    
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        let ftcellconfig = FTCellConfiguration.init()
        ftcellconfig.textColor = UIColor.black
        let ftconfig = FTConfiguration.shared
        var strarrFilter = [String]()
        
        
        strarrFilter = [NSLocalizedString("All", comment:""),NSLocalizedString("Only Hot Leads", comment:""),NSLocalizedString("Only Hot + Warm Leads", comment:""),NSLocalizedString("by_user", comment:""),NSLocalizedString("By Product", comment:""),NSLocalizedString("By Customer", comment:""),NSLocalizedString("By Product Category", comment:""),NSLocalizedString("By Segment", comment:""),NSLocalizedString("By Class", comment:""),NSLocalizedString("By Created by", comment:""),NSLocalizedString("By Lead Outcome", comment:"")]
        
        if(self.activesetting.showLeadQualifiedInLead == true){
            if(self.activesetting.leadQualifiedTextInLead?.count ?? 0 > 0){
                strarrFilter.append(self.activesetting.leadQualifiedTextInLead ?? "")
            }else{
                strarrFilter.append("Lead Qualified/Prospect")
            }
        }
        
        if(self.activesetting.showTrialDoneInLead == true){
            if(self.activesetting.trialDoneTextInLead?.count ?? 0 > 0){
                strarrFilter.append(self.activesetting.trialDoneTextInLead ?? "")
            }else{
                strarrFilter.append("Demo/Trial Done")
            }
        }
        
        if(self.activesetting.showProposalSubInLead == true){
            if(self.activesetting.proposalSubTextInLead?.count ?? 0 > 0){
                if(self.activesetting.proposalSubTextInLead?.count ?? 0 > 0){
                    strarrFilter.append(self.activesetting.proposalSubTextInLead ?? "")
                }else{
                    strarrFilter.append("Proposal Given")
                }
            }
        }
        
        
        if(self.activesetting.showNegotiationInLead == 1){
            if(self.activesetting.negotiationTextInLead?.count ?? 0 > 0){
                strarrFilter.append(self.activesetting.negotiationTextInLead ?? "")
            }else{
                strarrFilter.append("Negotiation/Finalisation")
            }
        }
        
        ftconfig.backgoundTintColor =  UIColor.white
        FTPopOverMenu.showForSender(sender: sender, with: strarrFilter, popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (i) in
            print(i)
            switch i{
            case 0:
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                self.getLeadList()
                if(self.arrOfLead.count > 0  && self.tblLeadList.visibleCells.count > 0){
                    self.tblLeadList.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                }
                break
                
            case 1:
                self.arrOfLead.removeAll()
                self.filterType = 1
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                self.sortType = "leadTypeID"
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                let arronlyhotlead =  self.arrOfLead.filter{
                    $0.leadTypeID == 1
                }
                //    self.arrOfLead = arronlyhotlead
                self.arrOfLead =   arronlyhotlead.sorted { $0.leadTypeID < $1.leadTypeID }
                
                self.tblLeadList.reloadData()
                break
                
            case 2:
                //let
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                self.sortType = "leadTypeID"
                let arronlyhotlead =  self.arrOfLead.filter{
                    $0.leadTypeID == 1 || $0.leadTypeID == 2
                }
                //    self.arrOfLead = arronlyhotlead
                self.arrOfLead =   arronlyhotlead.sorted { $0.leadTypeID < $1.leadTypeID }
                self.tblLeadList.reloadData()
                break
                
            case 3:
                //by user
                self.isCreatedBy = false
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                if(self.arrOfSelectedExecutive.count == 0 && self.arrOfExecutive.count > 0){
                    self.arrOfSelectedExecutive.append(self.arrOfExecutive.first ?? CompanyUsers())
                    let selectedexecutive = self.arrOfSelectedExecutive.first
                    
                    self.filterUser = selectedexecutive?.entity_id as? Int ?? 0
                    
                }
                if let currentuserid = self.activeuser?.userID {
                    if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                        if(!(self.arrOfExecutive.contains(currentuser))){
                            
                            
                            self.arrOfExecutive.append(currentuser)
                            if(self.arrOfSelectedExecutive.count == 0){
                                self.arrOfSelectedExecutive = [currentuser]
                            }
                        }
                    }
                }
                //                self.arrOfExecutive = BaseViewController.staticlowerUser
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.parentViewOfPopup = self.view
                self.popup?.strTitle = "Select Sales Person"
                self.popup?.arrOfExecutive = self.arrOfExecutive
                self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [CompanyUsers]()
                self.popup?.nonmandatorydelegate = self
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
                
            case 4:
                //by product
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.parentViewOfPopup = self.view
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
                
            case 5:
                //by customer
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.parentViewOfPopup = self.view
                self.popup?.strTitle = ""
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfList = self.arrOfCustomers ?? [CustomerDetails]()
                self.popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
                self.popup?.strLeftTitle = "REFRESH"
                self.popup?.strRightTitle = ""
                self.popup?.selectionmode = SelectionMode.none
                //                popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = true
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.customer
                self.popup?.isFilterRequire = false
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                break
                
            case 6:
                
                //by product category
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.parentViewOfPopup = self.view
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
                
            case 7:
                //by  segment
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                if(self.arrOfSelectedSegment.count == 0 && self.arrOfSegment.count > 0){
                    self.arrOfSelectedSegment.append(self.arrOfSegment.first ?? CustomerSegment())
                    let selectedexecutive = self.arrOfSelectedSegment.first
                    
                    self.customerSegmentIndex = NSNumber.init(value:selectedexecutive?.iD ?? 0)
                    
                }
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.parentViewOfPopup = self.view
                self.popup?.strTitle = "Select Segment"
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfCustomerSegment = self.arrOfSegment ?? [CustomerSegment]()
                self.popup?.arrOfselectedCustomerSegment = self.arrOfSelectedSegment
                self.popup?.strLeftTitle = "OK"
                self.popup?.strRightTitle = "Cancel"
                self.popup?.selectionmode = SelectionMode.single
                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = false
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.customersegment
                self.popup?.isFilterRequire = false
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                
                break
                
            case 8:
                //class
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                if(self.arrofSelectedClass.count == 0 && Utils().getCustomerClassification().count > 0){
                    self.arrofSelectedClass.append(Utils().getCustomerClassification().first ?? "")
                    self.customerClassIndex = NSNumber.init(value:1)
                    
                    
                    
                }
                
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.parentViewOfPopup = self.view
                self.popup?.strTitle = "Select Class"
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfCustomerClass = Utils().getCustomerClassification()
                self.popup?.arrOfSelectedClass = self.arrofSelectedClass ?? [String]()
                self.popup?.strLeftTitle = "OK"
                self.popup?.strRightTitle = "Cancel"
                self.popup?.selectionmode = SelectionMode.single
                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                self.popup?.isSearchBarRequire = false
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.customerClass
                self.popup?.isFilterRequire = false
                // popup?.showAnimate()
                self.present(self.popup!, animated: false, completion: nil)
                break
            case 9:
                //by user
                self.isCreatedBy = true
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                if(self.arrOfSelectedExecutive.count == 0 && self.arrOfExecutive.count > 0){
                    self.arrOfSelectedExecutive.append(self.arrOfExecutive.first ?? CompanyUsers())
                    let selectedexecutive = self.arrOfSelectedExecutive.first
                    
                    self.filterUser = selectedexecutive?.entity_id as? Int ?? 0
                    
                }
                if let currentuserid = self.activeuser?.userID {
                    if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                        if(!(self.arrOfExecutive.contains(currentuser))){
                            
                            
                            self.arrOfExecutive.append(currentuser)
                            if(self.arrOfSelectedExecutive.count == 0){
                                self.arrOfSelectedExecutive = [currentuser]
                            }
                        }
                    }
                }
                self.fetchuser { users in
                    
                }
                self.arrOfExecutive = BaseViewController.staticlowerUser
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.parentViewOfPopup = self.view
                self.popup?.strTitle = "Select Sales Person"
                self.popup?.arrOfExecutive = self.arrOfExecutive
                self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [CompanyUsers]()
                self.popup?.nonmandatorydelegate = self
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
                
            case 10:
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.arrOfSelectedLeadOutCome = self.arrOfSelectedLeadOutCome
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = "Select Lead Outcome"
                self.popup?.parentViewOfPopup =  self.view
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfLeadOutCome = self.arrOFLeadoutCome
                self.popup?.strLeftTitle = "OK"
                self.popup?.strRightTitle = "Cancel"
                self.popup?.selectionmode = SelectionMode.single
                self.popup?.isSearchBarRequire = false
                self.popup?.isFromSalesOrder =  false
                self.popup?.viewfor = ViewFor.leadoutcome
                self.popup?.isFilterRequire = false
                self.present(self.popup!, animated: false, completion: nil)
                
                break
            case 11:
                // qualified
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                Common.showalert(title: "Select One", msg: "", yesAction: UIAlertAction.init(title: "Off", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isLeadQualified == 0
                    })
                    self.tblLeadList.reloadData()
                }), noAction: UIAlertAction.init(title: "On", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isLeadQualified == 1
                    })
                    self.tblLeadList.reloadData()
                }), view: self)
                break
                
                
                
            case 12:
                // demo/trial done
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                Common.showalert(title: "Select One", msg: "", yesAction: UIAlertAction.init(title: "Off", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isTrialDone == 0
                    })
                    self.tblLeadList.reloadData()
                }), noAction: UIAlertAction.init(title: "On", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isTrialDone == 1
                    })
                    self.tblLeadList.reloadData()
                }), view: self)
                break
                
                
            case 13:
                // Prposal given
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                Common.showalert(title: "Select One", msg: "", yesAction: UIAlertAction.init(title: "Off", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.proposalSubmitted == 0
                    })
                    self.tblLeadList.reloadData()
                }), noAction: UIAlertAction.init(title: "On", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.proposalSubmitted == 1
                    })
                    self.tblLeadList.reloadData()
                }), view: self)
                break
                
                
            case 14:
                // Negotiation done
                self.arrOfLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                Common.showalert(title: "Select One", msg: "", yesAction: UIAlertAction.init(title: "Off", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isNegotiationDone == 0
                    })
                    self.tblLeadList.reloadData()
                }), noAction: UIAlertAction.init(title: "On", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isNegotiationDone == 1
                    })
                    self.tblLeadList.reloadData()
                }), view: self)
                break
                
                
            default:
                print("default filter option clicked of lead screen")
            }
            
            
        },cancel: {
            print("cancel tapped")
        })
    }
    
    @IBAction func btnSyncClicked(_ sender: UIButton) {
        let ftcellconfig = FTCellConfiguration.init()
        ftcellconfig.textColor = UIColor.black
        let ftconfig = FTConfiguration.shared
        ftconfig.backgoundTintColor =  UIColor.white
        FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("Hot to Cold", comment:""),NSLocalizedString("Order Expected Date", comment:""),NSLocalizedString("Sort By ID", comment:""),NSLocalizedString("Sort By Customer", comment:""),NSLocalizedString("Sort By Next Action", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (i) in
            print(i)
            switch i{
            case 0:
                self.sortType = "leadTypeID"
                self.arrOfLead =   self.arrOfLead.sorted { $0.leadTypeID < $1.leadTypeID }
                self.tblLeadList.reloadData()
                break
                
            case 1:
                self.sortType = "orderExpectedDate"
                //                    self.arrOfLead = self.arrOfLead.sorted {
                //                        $0.seriesPostfix < $1.seriesPostfix
                //                    }
                self.tblLeadList.reloadData()
                break
                
            case 2:
                self.sortType = "iD"
                self.arrOfLead = self.arrOfLead.sorted {
                    $0.iD < $1.iD
                }
                self.tblLeadList.reloadData()
                break
                
            case 3:
                //     self.sortType = "customerName"
                //                       self.arrOfLead =   self.arrOfLead.sorted {
                //                            if let custname1 = $0.customerName as? String {
                //                                if let custname2 = $1.customerName as? String{
                //                            if(custname1.count > 0 && custname2.count > 0){
                //                            custname1.lowercased() < custname1.lowercased()
                //                            }else{
                //                                return false
                //                                    }
                //                            }
                //                            }else
                //                            {
                //                                return false
                //                            }
                //                     }
                self.arrOfLead =   self.arrOfLead.sorted { $0.customerName!.lowercased() < $1.customerName!.lowercased() }
                self.tblLeadList.reloadData()
                break
                
            case 4:
                self.sortType = "nextActionTime"
                //                                       self.arrOfLead = self.arrOfLead.sorted {
                //                                                               $0.iD < $1.iD
                //                                       }
                self.tblLeadList.reloadData()
                break
                
                // default:
            default:
                print("Default")
            }
            
            
            //switch i{
            //       case 0:
            //       //by customer
            //                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            //                self.popup?.modalPresentationStyle = .overCurrentContext
            //                self.popup?.strTitle = ""
            //                self.popup?.delegate = self
            //                self.popup?.arrOfList = self.arrOfCustomers ?? [CustomerDetails]()
            //                self.popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
            //                self.popup?.strLeftTitle = "OK"
            //                self.popup?.strRightTitle = "Cancel"
            //                self.popup?.selectionmode = SelectionMode.single
            //                //                popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            //                self.popup?.isSearchBarRequire = true
            //                self.popup?.viewfor = ViewFor.customer
            //                self.popup?.isFilterRequire = false
            //                // popup?.showAnimate()
            //                self.present(self.popup!, animated: false, completion: nil)
            //                break
            //
            //            case 1:
            //                //by product
            //                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            //                self.popup?.modalPresentationStyle = .overCurrentContext
            //                self.popup?.strTitle = ""
            //                self.popup?.delegate = self
            //                self.popup?.arrOfProduct = self.arrOfProduct
            //                self.popup?.strLeftTitle = ""
            //                self.popup?.strRightTitle = ""
            //                self.popup?.selectionmode = SelectionMode.none
            //                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            //                self.popup?.isSearchBarRequire = true
            //                self.popup?.viewfor = ViewFor.product
            //                self.popup?.isFilterRequire = false
            //                // popup?.showAnimate()
            //                self.present(self.popup!, animated: false, completion: nil)
            //                break
            //
            //            case 2:
            //                //by user
            //                self.arrOfExecutive = BaseViewController.staticlowerUser
            //                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            //                self.popup?.modalPresentationStyle = .overCurrentContext
            //                self.popup?.strTitle = "Select User"
            //                self.popup?.delegate = self
            //                self.popup?.arrOfExecutive = self.arrOfExecutive
            //                self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [CompanyUsers]()
            //                self.popup?.strLeftTitle = "OK"
            //                self.popup?.strRightTitle = "Cancel"
            //                self.popup?.selectionmode = SelectionMode.single
            //                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            //                self.popup?.isSearchBarRequire = false
            //                self.popup?.viewfor = ViewFor.companyuser
            //                self.popup?.isFilterRequire = false
            //                // popup?.showAnimate()
            //                self.present(self.popup!, animated: false, completion: nil)
            //                break
            //
            //            case 3:
            //                //by product category
            //
            //                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            //                self.popup?.modalPresentationStyle = .overCurrentContext
            //                self.popup?.strTitle = ""
            //                self.popup?.delegate = self
            //                self.popup?.arrOfProductCategory = self.arrProductCatrgory ?? [ProdCategory]()
            //                self.popup?.arrOfSelectedProductCategory = [ProdCategory]()
            //                self.popup?.strLeftTitle = ""
            //                self.popup?.strRightTitle = ""
            //                self.popup?.selectionmode = SelectionMode.none
            //                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            //                self.popup?.isSearchBarRequire = true
            //                self.popup?.viewfor = ViewFor.productcategory
            //                self.popup?.isFilterRequire = false
            //                // popup?.showAnimate()
            //                self.present(self.popup!, animated: false, completion: nil)
            //                break
            //
            //            case 4:
            //                //by  segment
            //                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            //                self.popup?.modalPresentationStyle = .overCurrentContext
            //                self.popup?.strTitle = "Select Segment"
            //                self.popup?.delegate = self
            //                self.popup?.arrOfCustomerSegment = self.arrOfSegment ?? [CustomerSegment]()
            //                self.popup?.arrOfselectedCustomerSegment = [CustomerSegment]()
            //                self.popup?.strLeftTitle = "OK"
            //                self.popup?.strRightTitle = "Cancel"
            //                self.popup?.selectionmode = SelectionMode.single
            //                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            //                self.popup?.isSearchBarRequire = false
            //                self.popup?.viewfor = ViewFor.customersegment
            //                self.popup?.isFilterRequire = false
            //                // popup?.showAnimate()
            //                self.present(self.popup!, animated: false, completion: nil)
            //
            //                break
            //
            //            case 5:
            //                //by  class
            //                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            //                self.popup?.modalPresentationStyle = .overCurrentContext
            //                self.popup?.strTitle = "Select Class"
            //                self.popup?.delegate = self
            //                self.popup?.arrOfCustomerClass = Utils.getCustomerClassification()
            //                self.popup?.arrOfSelectedClass = [String]()
            //                self.popup?.strLeftTitle = "OK"
            //                self.popup?.strRightTitle = "Cancel"
            //                self.popup?.selectionmode = SelectionMode.single
            //
            //                //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            //                self.popup?.isSearchBarRequire = false
            //                self.popup?.viewfor = ViewFor.customerClass
            //                self.popup?.isFilterRequire = false
            //                // popup?.showAnimate()
            //                self.present(self.popup!, animated: false, completion: nil)
            //
            //                break
            //
            //            case 6:
            //                //created by
            //                self.openDatePicker(view: self.view, dateType: .date, tag: 0)
            //                break
            //
            //            case 7:
            //                //All
            //                self.arrOfPlanVisit.removeAll()
            //                self.filterUser = 0
            //                self.customerID = 0
            //                self.productID = 0
            //                self.productCategoryID = 0
            //                self.segmentID = -1
            //                self.classID = -1
            //                self.getPlannedVisit()
            //                break
            //            default:
            //                print("nothing")
            //            }
            //        }, cancel: {
            //            print("cancel tapped")
            //        })
            //        //        let arrTitle = [NSLocalizedString("by_customer", comment: ""),NSLocalizedString("by_products", comment:""),NSLocalizedString("by_user",comment: ""),NSLocalizedString("by_product_category", comment:""),NSLocalizedString("by_segment", comment:""),NSLocalizedString("by_class", comment:""),NSLocalizedString("by_created_by", comment:""),NSLocalizedString("all", comment:"")]
            //        //
            //        //        FilterPopUp().showpopup(list: arrTitle, btn: sender, parentView: self.view)
            //
            //
        },cancel: {
            print("cancel tapped")
        })
    }
    
    
    @IBAction func btnRefreshTapped(_ sender: UIButton) {
        self.refreshButtonClicked()
    }
}
extension LeadListView:UITableViewDelegate,UITableViewDataSource{
    
    // MARK: UITableViewDelagate , UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrOfLead.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if let cell:LeadListCell = tableView.dequeueReusableCell(withIdentifier: Constant.LeadListCell, for: indexPath) as? LeadListCell{
            let leadobj = arrOfLead[indexPath.row]
            
            cell.setLeadData(lead: leadobj)
            cell.stackViewNextActionDetail.isHidden = true
            if BaseViewController.staticlowerUser.count > 0 {
                cell.lblCreatedBy.isHidden = false
                let userName = CompanyUsers().getUser(userId:leadobj.createdBy as NSNumber)
                cell.lblCreatedBy.text = "Created By: \(userName?.firstName ?? "")"
            }else {
                cell.lblCreatedBy.isHidden = true
            }
        
        return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objleadi =  arrOfLead[indexPath.row]
       
        if let selectedCustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objleadi.customerID)) as? CustomerDetails{
            Utils().getLeadDetail(leadid: NSNumber.init(value:objleadi.iD), completion: { (lead, msg) in
                if let objlead = lead as? Lead{
                    if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
                    leadDetail.isHistory = false
                    leadDetail.redirectTo =  0
//                        if let orderset =  objlead.productList.array.unique()  as? [Product] {
//                            objlead.productList = orderset
//                        }
                    leadDetail.lead =   objleadi
                    
                    print("Lead object = \(objleadi) ")
                        for status in objlead.leadStatusList{
                            if let statuslead =  status as? LeadStatusList{
                                print("status = \(statuslead.leadPreviousProductsList) ")
                            }
                           
                        }
                    
                  
                    self.navigationController?.pushViewController(leadDetail, animated: true)
                    }
                }else{
                    Utils.toastmsg(message: msg, view: self.view)
                }
            })
        }else{
            SVProgressHUD.show()
            Utils().getCustomerDetail(cid: NSNumber.init(value:objleadi.customerID)) { (status) in
               
                Utils().getLeadDetail(leadid: NSNumber.init(value:objleadi.iD), completion: { (lead, msg) in
                    SVProgressHUD.dismiss()
                    if let objlead = lead as? Lead{
                        if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
                        leadDetail.isHistory = false
                        leadDetail.redirectTo =  0
                        leadDetail.lead =   objlead
        //                print("Lead object = \(objlead) ")
                            for status in objlead.leadStatusList{
                                if let statuslead =  status as? LeadStatusList{
                                    print("status = \(statuslead.leadPreviousProductsList) ")
                                }
                               
                            }
                        
                            //        visitDetail.planvisit = arrOfPlanVisit[indexPath.row]
                        //        if(visitDetail.planvisit?.visitStatusID == 3){
                        //            visitDetail.visitType = VisitType.manualvisit
                        //        }else{
                        //            visitDetail.visitType = VisitType.planedvisit
                        //        }
                        self.navigationController?.pushViewController(leadDetail, animated: true)
                        }
                    }else{
                        Utils.toastmsg(message: msg, view: self.view)
                    }
                })
                  }
                }
            }
       
       
    
}
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension LeadListView:PopUpDelegateNonMandatory{
 
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedcustomer = arr.first
            customerID = Int(selectedcustomer?.iD ?? 0)
            self.getLeadList()
        }
    }
    
    func completionProductData(arr: [Product]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedproduct = arr.first
            productID = Int(selectedproduct?.productId ?? 0)
           self.getLeadList()
        }
    }
    
    func completionProductCategory(arr: [ProdCategory]) {
        Utils.removeShadow(view: self.view)
        if(arr.count > 0){
            let selectedCategory = arr.first
            productCategoryID = Int(selectedCategory?.iD ?? 0)
             self.getLeadList()
        }
    }
    
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            if self.isCreatedBy {
                self.arrOfSelectedExecutive = arr
                let selectedUser = self.arrOfSelectedExecutive.first
                self.arrOfLead = self.arrOfLead.filter({$0.createdBy == Int64(selectedUser?.entity_id ?? 0)})
                self.tblLeadList.reloadData()
            }else {
                self.arrOfSelectedExecutive = arr
                let selectedexecutive = arr.first
               
                filterUser = selectedexecutive?.entity_id as? Int ?? 0
                 self.getLeadList()
            }
            
        }
    }
    func completionSelectedClass(arr:[String],recordno:Int,strTitle:String){
   
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            self.arrOfSelectedClass =  arr
            customerClassIndex = NSNumber.init(value:recordno + 1)
            arrOfLead = arrOfLead.filter({ (objlead) -> Bool in
                if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objlead.customerID)) as? CustomerDetails{
                return customer.customerClass == self.customerClassIndex.int64Value
                }else{
                    return false
                }
            })
        }
        tblLeadList.reloadData()
       
    }
    
    
    func completionSelectedSegment(arr: [CustomerSegment]) {
        Utils.removeShadow(view: self.view)
        arrOfSelectedSegment =  arr
      //  self.tfCustomerSegment.text =  arr.first?.customerSegmentValue
        self.customerSegmentIndex =  NSNumber.init(value:arr.first?.iD ?? 0)
       
        
        arrOfLead = arrOfLead.filter({ (objlead) -> Bool in
        
            if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objlead.customerID)) as? CustomerDetails{
            return customer.segmentID == self.customerSegmentIndex.int64Value
            }else{
                return false
            }
        })
        tblLeadList.reloadData()
    }
    
    func completionSelectedLeadOutCome(arr: [Outcomes]) {
        
        Utils.removeShadow(view: self.view)
        if(arr.count > 0){
            arrOfSelectedLeadOutCome.removeAll()
            arrOfSelectedLeadOutCome = arr
            if  let outcome  =  self.arrOfSelectedLeadOutCome.first {
                var outcomeIDArray:[Int64] = []
                self.arrOfLead = self.arrOfLead.filter { objOfLead in
                    if let outcomeObj = objOfLead.leadStatusList.firstObject as? LeadStatusList {
                        let outcomeID = outcomeObj.outcomeID
                        if outcomeID == outcome.leadOutcomeIndexID {
                            outcomeIDArray.append(outcomeID)
                            return true
                        }
                    }
                    return false
                }
                DispatchQueue.main.async {
                    self.tblLeadList.reloadData()
                }
            }
        }
    }
}
extension LeadListView:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    
    @objc func menuitemTouched(item: UPStackMenuItem,companymenu:CompanyMenus) {
        
        print(companymenu)
        print(companymenu.menuID)
        print(companymenu)
        
           if(companymenu.menuID == 32){
               //add manualvisit
               if  let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
            Common.skipVisitSelection = false
               
               addjointvisit.visitType = VisitType.manualvisit
               
               self.navigationController!.pushViewController(addjointvisit, animated: true)
               }
               
               
           }else if(companymenu.menuID == 29){
               if let addunplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddUnplanVisitView) as? AddUnPlanVisit{
              
               self.navigationController!.pushViewController(addunplanvisit, animated: true)
               }
           }else if(companymenu.menuID == 31){
               //corporate meeting
           }else if(companymenu.menuID == 33){
               //beat plan
               let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView
               self.navigationController!.pushViewController(beatplancontainer!, animated: true)
           }else if(companymenu.menuID == 28){
               if let addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddplanVisitView) as? AddPlanVisit{
               //    self.dismiss(animated: false) {
               self.navigationController!.pushViewController(addplanvisit, animated: true)
               }
               //plan a visit
           }else if(companymenu.menuID == 26){
            //Add Activity
            if let addActivity = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.AddActivity) as? AddActivity{
                    
                    self.navigationController?.pushViewController(addActivity, animated: true)
            }
           }else if(companymenu.menuID == 504){
               //kpi data
           }else if(companymenu.menuID == 30){
               //Direct Visit Check-IN
               if let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
            Common.skipVisitSelection = false
               
               addjointvisit.visitType = VisitType.directvisitcheckin
              
               self.navigationController!.pushViewController(addjointvisit, animated: true)
               }
           }else if(companymenu.menuID == 23){
            if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                newlead.selectionFor = SelectionOf.visit
                
                self.navigationController!.pushViewController(newlead, animated: true)
            }
           }else if(companymenu.menuID == 24){
            if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                    newlead.selectionFor = SelectionOf.lead
               
                   self.navigationController!.pushViewController(newlead, animated: true)
           }
           }else if(companymenu.menuID == 0){
            if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
            as? Leadselection{
            addplanvisit.selectionFor = SelectionOf.visit
            self.navigationController!.pushViewController(addplanvisit, animated: true)
            }
           }else if(companymenu.menuID == 22){
            if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                self.navigationController?.pushViewController(attendance, animated: true)
            }
           }          // let selectedcompanyid = CompanyMenus.
           else if(companymenu.menuID == 18){
            if let objexcel = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ExcelReport) as? ExcelReport{
                self.navigationController?.pushViewController(objexcel, animated: true)
            }
           }
           else if(item.title.lowercased() == "visit"){
               
              if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
               as? Leadselection{
               addplanvisit.selectionFor = SelectionOf.visit
               self.navigationController!.pushViewController(addplanvisit, animated: true)
               }
         
           }else if(item.title.lowercased() == "new beat route"){
               
           }else if(item.title.lowercased() == "lead"){
               if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView) as? Leadselection{
               newlead.selectionFor = SelectionOf.lead
          
              self.navigationController!.pushViewController(newlead, animated: true)
               }
           }else if(item.title.lowercased() == "beat plan"){
               if let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView{
               self.navigationController!.pushViewController(beatplancontainer, animated: true)
               }
           }else if(companymenu.menuID == 25){
            print("Sales Order")
            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
    }
    
    func datepickerSelectionDone(){
//selectedDate = Utils.getStringFromDateInRequireFormat(format:"yyyy/MM/dd",date:datepicker.date)
//btnSelectedDate.setTitle(Utils.getStringFromDateInRequireFormat(format:"dd MMM yyyy",date:datepicker.date), for: .normal)
//self.getDailyReports()
//        if(screenselection == Dashboardscreen.salesplan){
//         self.getVisitFollowupList()
//        }else if(screenselection == Dashboardscreen.dashboardvisit){
//            self.getvisitForDashboard()
//        }else if(screenselection == Dashboardscreen.dashboardlead){
//            self.getLeadForDashoard()
//        }else if(screenselection == Dashboardscreen.dashboardorder){
//            self.getOrderForDashoard()
//        }
        
    }
    
     func cancelbtnTapped() {
//        datepicker.removeFromSuperview()
    }
    
}

