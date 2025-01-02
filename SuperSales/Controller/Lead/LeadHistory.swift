//
//  LeadHistory.swift
//  SuperSales
//
//  Created by Apple on 05/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import FastEasyMapping

class LeadHistory: BaseViewController {
    
    @IBOutlet weak var tblLeadHistoryList: UITableView!
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnSync: UIButton!
    var arrOfLead:[Lead] = [Lead]()
    var arrOfDisplayLead:[Lead] = [Lead]()
    var arrLeadResult:[LeadListResult] = [LeadListResult]()
    var customerSegmentIndex =  NSNumber.init(value:0)
    var customerClassIndex = NSNumber.init(value:0)
    var filterType = 0
    var filterUser = 0
    var customerID = 0
    var productID = 0
    var productCategoryID = 0
    var segmentID = -1
    var classID = -1
    var sortType = "0"
    var popup:CustomerSelection? = nil
    var arrOfCustomers:[CustomerDetails]!
    var arrOfProduct:[Product]! = [Product]()
    var arrProductCatrgory:[ProdCategory]!
    var arrOfExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    
    var arrOfSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrOfSelectedSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrOfSelectedClass:[String]! = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
          self.setrightbtn(btnType: BtnRight.none,navigationItem: self.navigationItem)
       
        
      }
    
    override func viewDidAppear(_ animated:Bool)
    {
        if(arrOfDisplayLead.count > 0 && tblLeadHistoryList.visibleCells.count > 0){
        self.tblLeadHistoryList.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    // MARK: Method
    func setUI(){
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.title = "LEAD HISTORY"
        tblLeadHistoryList.delegate = self
        tblLeadHistoryList.dataSource = self
        tblLeadHistoryList.tableFooterView = UIView()
        tblLeadHistoryList.separatorColor = UIColor.clear
        self.getLeadList()
        arrOfCustomers = CustomerDetails.getAllCustomers()
        
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
    
    func getLeadList(){
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.arrLeadResult.removeAll()
        var param = [String:Any]()
        param["CreatedBy"] = self.activeuser?.userID
        param["CompanyID"] = self.activeuser?.company?.iD
        param["FilterUser"] = filterUser
        param["FilterProduct"] = productID
        param["CustomerID"] = customerID
        param["FilterCategoryID"] = productCategoryID
        param["SortType"] = sortType
        param["FilterType"] = filterType
        var param1 = Common.returndefaultparameter()
        param1["getleadsclosejson"] = Common.returnjsonstring(dic: param)
        print("parameter of lead close = \(param1)")
        ApiHelper().getdeletejoinvisit(param: param1, strurl: ConstantURL.kWSUrlGetLeadClose, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
                let leadHistory = arr as? [[String:Any]] ?? [[String:Any]]()
              
                for dic in leadHistory{
                    let leadresult = LeadListResult().initWithdic(dict: dic)
                    self.arrLeadResult.append(leadresult)
                   
                    
                }
                
                if(self.arrLeadResult.count > 0){
                    let mapping = Lead.defaultmapping()
                    let store = FEMManagedObjectStore.init(context: NSManagedObjectContext.mr_default())
                    store.saveContextOnCommit = false
                    let deserializer = FEMDeserializer.init(store: store)
                    let objects = deserializer.collection(fromRepresentation: leadHistory, mapping: mapping)
                    self.arrOfLead = objects as! [Lead]
                    self.arrOfDisplayLead = objects as! [Lead]
                   
                }
                self.tblLeadHistoryList.reloadData()
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else if(error.code == 0){
                self.tblLeadHistoryList.reloadData()
                self.dismiss(animated: true, completion: nil)
                
            }else{
                self.tblLeadHistoryList.reloadData()
                self.dismiss(animated: true, completion: nil)
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
            
        }
        
       
        //}
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        let ftcellconfig = FTCellConfiguration.init()
        ftcellconfig.textColor = UIColor.black
        let ftconfig = FTConfiguration.shared
        var strarrFilter = [String]()
        
        
        strarrFilter = [NSLocalizedString("Only Hot Leads", comment:""),NSLocalizedString("Only Hot + Warm Leads", comment:""),NSLocalizedString("By Sales Person", comment:""),NSLocalizedString("By Product", comment:""),NSLocalizedString("By Customer", comment:""),NSLocalizedString("By Product Category", comment:""),NSLocalizedString("By Product Sub Category", comment:""), NSLocalizedString("All", comment:"")]
        
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
            self.sortType  = "0"
            switch i{
            
            case 0:
                
                
                
                
                
                self.filterType = 1
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
              //  self.sortType = 1 //"leadTypeID"
                let arronlyhotlead =  self.arrOfLead.filter{
                    $0.leadTypeID == 1
                }
                //    self.arrOfLead = arronlyhotlead
                self.arrOfDisplayLead =   arronlyhotlead.sorted { $0.leadTypeID < $1.leadTypeID }
                
                self.tblLeadHistoryList.reloadData()
                break
                
            case 1:
                //let
              //  self.sortType = 2 //"leadTypeID"
                self.filterType  = 2
              //  self.arrOfLead =
                let arronlyhotlead =  self.arrOfLead.filter{
                    $0.leadTypeID == 1 || $0.leadTypeID == 2
                }
                //    self.arrOfLead = arronlyhotlead
                self.arrOfDisplayLead =   arronlyhotlead.sorted { $0.leadTypeID < $1.leadTypeID }
                self.tblLeadHistoryList.reloadData()
                break
                
            case 2:
                //by Sales person
                self.arrOfExecutive = BaseViewController.staticlowerUser
                if let currentuserid = self.activeuser?.userID{
                    if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                        if(!(self.arrOfExecutive.contains(currentuser))){
                    

                            self.arrOfExecutive.append(currentuser)
                            if(self.arrOfSelectedExecutive.count == 0){
                                self.arrOfSelectedExecutive = [currentuser]
                            }
                        }
                    }
                }
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = "Select Sales Person"
                self.popup?.parentViewOfPopup = self.view
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
                //by product
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.parentViewOfPopup = self.view
                self.popup?.strTitle = ""
                self.popup?.parentViewOfPopup = self.view
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
                
            case 4:
                //by customer
                self.filterType =  5
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = ""
                self.popup?.nonmandatorydelegate = self
                self.popup?.arrOfList = self.arrOfCustomers ?? [CustomerDetails]()
                self.popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
                self.popup?.strLeftTitle = "REFRESH"
                self.popup?.parentViewOfPopup = self.view
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
                
            case 5:
                
                //by product category
                
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = ""
                self.popup?.parentViewOfPopup = self.view
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
            case 6:
                
                //by product sub category
                
                self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                self.popup?.modalPresentationStyle = .overCurrentContext
                self.popup?.strTitle = ""
                self.popup?.parentViewOfPopup = self.view
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
                //All
                self.arrOfLead.removeAll()
                self.arrOfDisplayLead.removeAll()
                self.filterType = 0
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
                self.getLeadList()
                if(self.arrOfDisplayLead.count > 0 && self.tblLeadHistoryList.visibleCells.count > 0){
                self.tblLeadHistoryList.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                }
                break
                
//            case 8:
//                self.arrOfLead.removeAll()
//                self.filterType = 7
//                self.filterUser = 0
//                self.customerID = 0
//                self.productID = 0
//                self.productCategoryID = 0
//                self.segmentID = -1
//                self.classID = -1
//                self.getLeadList()
//
//                break
                
                
            case 8:
                // qualified
                self.arrOfLead.removeAll()
                self.arrOfDisplayLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
              
                self.arrOfDisplayLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                Common.showalert(title: "Select One", msg: "", yesAction: UIAlertAction.init(title: "Off", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfDisplayLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isLeadQualified == 0
                    })
                    self.tblLeadHistoryList.reloadData()
                }), noAction: UIAlertAction.init(title: "On", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfDisplayLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isLeadQualified == 1
                    })
                    self.tblLeadHistoryList.reloadData()
                }), view: self)
                break
                
                
                
            case 9:
                // demo/trial done
                self.arrOfLead.removeAll()
                self.arrOfDisplayLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
              
                self.arrOfDisplayLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                Common.showalert(title: "Select One", msg: "", yesAction: UIAlertAction.init(title: "Off", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isTrialDone == 0
                    })
                    self.tblLeadHistoryList.reloadData()
                }), noAction: UIAlertAction.init(title: "On", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfDisplayLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isTrialDone == 1
                    })
                    self.tblLeadHistoryList.reloadData()
                }), view: self)
                break
                
                
            case 10:
                // Prposal given
                self.arrOfLead.removeAll()
                self.arrOfDisplayLead.removeAll()
                self.filterType = 7
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.segmentID = -1
                self.classID = -1
              
                self.arrOfLead.append(contentsOf: (Lead.getAllBy(atrname: "seriesPostfix",order: false)))
                Common.showalert(title: "Select One", msg: "", yesAction: UIAlertAction.init(title: "Off", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfDisplayLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.proposalSubmitted == 0
                    })
                    self.tblLeadHistoryList.reloadData()
                }), noAction: UIAlertAction.init(title: "On", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfDisplayLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.proposalSubmitted == 1
                    })
                    self.tblLeadHistoryList.reloadData()
                }), view: self)
                break
                
                
            case 11:
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
                    self.arrOfDisplayLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isNegotiationDone == 0
                    })
                    self.tblLeadHistoryList.reloadData()
                }), noAction: UIAlertAction.init(title: "On", style: UIAlertAction.Style.default, handler: { (action) in
                    self.arrOfDisplayLead = self.arrOfLead.filter({ (obj) -> Bool in
                        obj.isNegotiationDone == 1
                    })
                    self.tblLeadHistoryList.reloadData()
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
        FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("Hot to Cold", comment:""), NSLocalizedString("Sort By ID", comment:""),NSLocalizedString("Sort By Customer", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (i) in
            print(i)
            switch i{
            case 0:
            //    self.sortType = 0//"leadTypeID"
                self.arrOfDisplayLead =   self.arrOfLead.sorted { $0.leadTypeID < $1.leadTypeID }
                self.tblLeadHistoryList.reloadData()
                break
                
                
                
            case 1:
                self.sortType = "iD"
                self.arrOfDisplayLead = self.arrOfLead.sorted {
                    $0.iD < $1.iD
                }
                self.tblLeadHistoryList.reloadData()
                break
                
            case 2:
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
                self.arrOfDisplayLead =   self.arrOfLead.sorted { $0.customerName!.lowercased() < $1.customerName!.lowercased() }
                self.tblLeadHistoryList.reloadData()
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
    
    
    
    //MARK: - UITableViewDelagate , UITableViewDataSource
}

extension LeadHistory:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfDisplayLead.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LeadListCell = tableView.dequeueReusableCell(withIdentifier: Constant.LeadListCell, for: indexPath) as! LeadListCell
        let leadobj = arrOfDisplayLead[indexPath.row]
        cell.setLeadData(lead: leadobj)
        cell.vwParent.addBorders(edges: [.bottom,.right], color: UIColor.lightGray, cornerradius: 10)
        cell.vwParent.backgroundColor = UIColor.clear
        cell.stackViewNextActionDetail.isHidden = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadHistoryDetail) as? LeadHistoryDetailViewController{
            
            //        leadDetail.isHistory = false
            //        leadDetail.redirectTo =  0
            leadDetail.leadhistory = arrOfDisplayLead[indexPath.row]
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
extension LeadHistory:PopUpDelegateNonMandatory{
    
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
            self.arrOfSelectedExecutive = arr
            let selectedexecutive = arr.first
           
            filterUser = selectedexecutive?.entity_id as? Int ?? 0
             self.getLeadList()
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
        tblLeadHistoryList.reloadData()
       
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
        tblLeadHistoryList.reloadData()
    }
    
}
