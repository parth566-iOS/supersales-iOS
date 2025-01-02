//
//  CustomerSelection.swift
//  SuperSales
//
//  Created by Apple on 30/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol PopUpDelegateMandatory {
    // func btnClicked(btn:UIButton)
    
    func completionSelectedBeatPlan(arr:[BeatPlan])
    func completionSelectedDocument(arr:[Document])
    
}
@objc protocol PopUpDelegateNonMandatory {
    
    @objc optional func completionSelectedExecutive(arr:[CompanyUsers])
    @objc optional func completionSelectedVendor(arr:[Vendor])
    @objc optional func completionData(arr:[CustomerDetails])
    @objc optional func completionfirstInfluencer(arr:[CustomerDetails])
    @objc optional func completionsecondInfluencer(arr:[CustomerDetails])
    @objc optional func completionProductData(arr:[Product])
    @objc optional func completionSelectedTerritory(arr:[[String:Any]])
    @objc optional func completionProductCategory(arr:[ProdCategory])
    @objc optional func completionProductSubCategory(arr:[ProductSubCat])
    @objc optional func completionSelectedVisitOutCome(arr:[VisitOutcomes])
    @objc optional func completionSelectedLeadOutCome(arr:[Outcomes])
    @objc optional func completionSelectedSegment(arr:[CustomerSegment])
    @objc optional func completionSelectedClass(arr:[String],recordno:Int,strTitle:String)
    @objc optional func completionSelectedVisitStep(arr:[StepVisitList])
    @objc optional func completionSelectedLead(arr:[Lead])
    
    // func completionSelectedDocument(arr:[Document])
}
//
class CustomerSelection: UIViewController , UIGestureRecognizerDelegate  {
    
    
    var cell:CustomerSelectionCell! = CustomerSelectionCell()
    var tap: UITapGestureRecognizer!
    @IBOutlet weak var stackBottomButton: UIStackView!
    var activeuser = Utils().getActiveAccount()
    @IBOutlet weak var stkCustomerSelection: UIStackView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackSearch: UIStackView!
    
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblCustomerSelection: UITableView!
    var arrOfterritory:[[String:Any]]!
    var searchActive : Bool = false
    var parentViewOfPopup:UIView!
    var isFilterActive: Bool = false
    var isViewRequireInMiddle:Bool!
    var mandatorydelegate:PopUpDelegateMandatory?
    var nonmandatorydelegate:PopUpDelegateNonMandatory?
    var isFilterRequire:Bool! = false
    var isSearchBarRequire:Bool! = false
    var selectionmode:SelectionMode!
    var isContactNameRequire:Bool! = true
    
    // var arrLeadCheckInOption:[String]!
    var arrOfBeatPlan:[BeatPlan]!
    var isSugggestedQty = false
    var productDriveIDs = [NSNumber]()
    var isProductView = false
    var isProductViewWithMultiLine = false
    
    lazy var arrOfSelectedBeatPlan:[BeatPlan] = {
        return [BeatPlan]()
    }()
    
    var arrOffilteredBeatPlan:[BeatPlan] = [BeatPlan]()
    
    var arrOfSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrayFullList = [CustomerDetails]()
    var arrOfList = [CustomerDetails]()
    var filteredCustomer:[CustomerDetails] = [CustomerDetails]()
    var arrOfSelectedSingleCustomer:[CustomerDetails]!  = [CustomerDetails]()
    var arrOfSelectedMultipleCustomer:[CustomerDetails]!  = [CustomerDetails]()
    
    var arrOfExecutive:[CompanyUsers]!  = [CompanyUsers]()
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOffilteredExecutive:[CompanyUsers]! = [CompanyUsers]()
    
    var arrOfCustomerClass:[String]! = [String]()
    var arrOfSelectedClass:[String]! = [String]()
    var arrOffilteredCustomerClass:[String]! = [String]()
    
    var arrOfTerritory:[[String:Any]]! = [[String:Any]]()
    var arrOfSelectedTerritory:[[String:Any]]! = [[String:Any]]()
    
    var arrOfVendor:[Vendor]! = [Vendor]()
    var arrOfSelectedVendor:[Vendor]! = [Vendor]()
    var arrOfFilteredVendor:[Vendor]! = [Vendor]()
    
    
    var arrOfLead:[Lead]! = [Lead]()
    var arrOfSelectedLead:[Lead]! = [Lead]()
    var arrOfFilteredLead:[Lead]! = [Lead]()
    
    
    var arrOfCustomerSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrOfselectedCustomerSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrOffilteredCustomerSegment:[CustomerSegment]! = [CustomerSegment]()
    
    var arrOfProductCategory:[ProdCategory]! = [ProdCategory]()
    var arrOfSelectedProductCategory:[ProdCategory]! = [ProdCategory]()
    var arrOfFilteredCategory:[ProdCategory]! = [ProdCategory]()
    
    var arrOfProductSubCategory:[ProductSubCat]! = [ProductSubCat]()
    var arrOfSelectedSubProductCategory:[ProductSubCat]! = [ProductSubCat]()
    var arrOfFilteredProductSubCategory:[ProductSubCat]! = [ProductSubCat]()
    
    var arrOfDocument:[Document]! = [Document]()
    var arrOfSelectedDocument:[Document]! = [Document]()
    
    var arrOfProduct:[Product]! = [Product]()
    var arrOfSelectedProduct = [Product]()
    var arrOfFilteredProduct:[Product]! = [Product]()
    var productStockArray = [[String: Any]]()
    var arrOfLeadOutCome:[Outcomes]! = [Outcomes]()
    var arrOfSelectedLeadOutCome:[Outcomes]! = [Outcomes]()
    var arrOffilteredLeadOutcome:[Outcomes]! = [Outcomes]()
    
    var arrOfVisitOutCome:[VisitOutcomes]! = [VisitOutcomes]()
    var arrOfSelectedVisitOutcome:[VisitOutcomes]! = [VisitOutcomes]()
    var arrOffilteredVisitOutcome:[VisitOutcomes]! = [VisitOutcomes]()
    
    
    var arrOfVisitStep:[StepVisitList]! = [StepVisitList]()
    var arrOfMandatoryStep:[StepVisitList]! = [StepVisitList]()
    var arrOfSelectedVisitStep = [StepVisitList]()
    var arrOfDisableVisitStep = [StepVisitList]()
    
    var strTitle:String! = ""
    var strLeftTitle:String = ""
    var strRightTitle:String = ""
    
    @IBOutlet weak var lblMandatory: UILabel!
    @IBOutlet weak var btnMandatorySwitch: UIButton!
    
    var viewfor:ViewFor!
    
    @IBOutlet var searchBar: UISearchBar!
    
    // @IBOutlet var btnFilter: UIButton!
    @IBOutlet var btnClose: UIButton!
    // @IBOutlet var tblCustomer: UITableView!
    
    @IBOutlet var btnLeft: UIButton!
    
    @IBOutlet var btnRight: UIButton!
    
    var selectedRecordNo = 0
    var tag:Int! = 0
    var isFromSalesOrder:Bool! = false
    var customerID:NSNumber!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLeft.backgroundColor = UIColor.Appthemegreencolor
        btnRight.backgroundColor = UIColor.red
        //  arrOfCustomerSegment = CustomerSegment.getAll()
        self.arrOfList.sort { (cust1, cust2) -> Bool in
            cust1.name < cust2.name
        }
        
        self.arrayFullList = self.arrOfList
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        searchBar.delegate = self
        
        tblCustomerSelection.delegate = self
        tblCustomerSelection.dataSource = self
        tblCustomerSelection.tableFooterView = UIView()
        tblCustomerSelection.separatorInset = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        
        if(viewfor == ViewFor.visitoutcome || viewfor == ViewFor.visitStep || viewfor == ViewFor.leadoutcome || viewfor == ViewFor.document){
            tblCustomerSelection.separatorColor = UIColor.clear
        }else{
            tblCustomerSelection.separatorColor = UIColor.gray
        }
        if(!isFilterRequire){
            btnClose.setImage(UIImage.init(named: "icon_close"), for: .normal)
        }else{
            btnClose.setImage(UIImage.init(named: "icon_filter"), for: .normal)
        }
        
        if(isSearchBarRequire == false){
            vwTop.isHidden = true
        }else{
            vwTop.isHidden = false
        }
        
        if(strTitle.count > 0){
            lblTitle.isHidden = false
            lblTitle.text = strTitle
            lblTitle.textColor = UIColor.black
            lblTitle.font = UIFont.boldSystemFont(ofSize: 18)
        }else{
            lblTitle.isHidden = true
        }
        
        if(strLeftTitle.count == 0){
            btnLeft.isHidden = true
        }else{
            btnLeft.isHidden = false
            btnLeft.setbtnFor(title: strLeftTitle, type: Constant.kPositive)
            // btnLeft.setTitle(strLeftTitle, for: .normal)
        }
        if(strRightTitle.count == 0){
            btnRight.isHidden = true
        }else{
            //  btnRight.setTitle(strRightTitle, for: .normal)
            btnRight.setbtnFor(title: strRightTitle, type: Constant.kNegative)
        }
        if(viewfor == ViewFor.visitStep){
            lblMandatory.isHidden = false
        }else{
            lblMandatory.isHidden = true
        }
        //set alphabatically
        //        let soarrOfList = arrOfList.sorted(by: { (item1, item2) -> Bool in
        //            return item1.name.compare(item2.name) == ComparisonResult.orderedAscending
        //        })
        //            //arrOfList.sorted(by: { $0.name < $1.name })
        // arrOfList = arrOfList.sorted(by: { $0.name > $1.name })
        let soarrOfList = arrOfList.sorted { (cust1, cust2) -> Bool in
            cust1.name < cust2.name
        }
        //            arrOfList.sort { (cu1, cu2) -> Bool in
        //            return cu1.name.localizedCaseInsensitiveContains(cu2.name) == NSComparisonResult.OrderedAscending
        //        }
        arrOfList = soarrOfList
        searchBar.setBottomBorder(color: UIColor.white)
        vwTop.backgroundColor = UIColor.init(red: 0/255.0, green: 144/255.0, blue: 247/255.0, alpha: 1.0)
        self.view.setShadow()
        
        //tblCustomerSelection.layoutIfNeeded()
        tblCustomerSelection.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let activeSetting = Utils().getActiveSetting()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.view.window?.isUserInteractionEnabled = true
        self.view.window?.addGestureRecognizer(tap)
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self.stkCustomerSelection)
        
        if self.stkCustomerSelection.point(inside: location, with: nil) {
            return false
        }
        else {
            if let topviewcontroller = UIApplication.shared.keyWindow?.rootViewController as? UIViewController{
                Utils.removeShadow(view: topviewcontroller.view)
            }
            return true
        }
    }
    
    @objc private func onTap(sender: UITapGestureRecognizer) {
        self.view.window?.removeGestureRecognizer(sender)
        if let topviewcontroller = UIApplication.shared.keyWindow?.rootViewController as? UIViewController{
            Utils.removeShadow(view: topviewcontroller.view)
        }
        Utils.removeShadow(view:  self.view)
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - IBAction
    
    @IBAction func btnOfCustomerSelectionPopUpClicked(_ sender: UIButton) {
        
        if(sender == btnClose){
            if(self.isFilterRequire){
                //filter action
                
                let ftconfig = FTConfiguration.shared
                ftconfig.textColor = UIColor.black
                ftconfig.backgoundTintColor =  UIColor.white
                FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("all", comment:""),NSLocalizedString("by_city", comment:""),NSLocalizedString("by_pincode", comment:""),NSLocalizedString("by_segment", comment:""),NSLocalizedString("by_class", comment:""),NSLocalizedString("by_terriotry", comment:""),NSLocalizedString("by_beatroute", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: ftconfig, done: { (i) in
                    
                    //       FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("all", comment:""),NSLocalizedString("by_city", comment:""),NSLocalizedString("by_pincode", comment:""),NSLocalizedString("by_segment", comment:""),NSLocalizedString("by_class", comment:""),NSLocalizedString("by_terriotry", comment:""),NSLocalizedString("by_beatroute", comment:"")], menuImageArray: [] , config: ftconfig , done:{ (i) in
                    
                    //                FTPopOverMenu.showForSender(sender: sender, with:  [NSLocalizedString("all", comment:""),NSLocalizedString("by_city", comment:""),NSLocalizedString("by_pincode", comment:""),NSLocalizedString("by_segment", comment:""),NSLocalizedString("by_class", comment:""),NSLocalizedString("by_terriotry", comment:""),NSLocalizedString("by_beatroute", comment:"")], menuImageArray: [] , cellConfigurationArray: [ftcellconfig,ftcellconfig,ftcellconfig,ftcellconfig,ftcellconfig,ftcellconfig,ftcellconfig], done: { (i) in
                    //                    print(i)
                    switch i{
                    case 0:
                        //All
                        self.searchBar.text = ""
                        self.searchActive = false
                        self.isFilterActive = false
                        self.arrOfList = self.arrayFullList
                        
                        self.tblCustomerSelection.reloadData()
                        break
                        
                    case 1:
                        //by City
                        let alert = UIAlertController.init(title: "City", message: "", preferredStyle: .alert)
                        let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
                        let okAction = UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { [self] (action) in
                            let tfcity = alert.textFields![0]
                            
                            if(tfcity.text?.count == 0){
                                self.isFilterActive = false
                                Utils.toastmsg(message:"Please enter City Name",view:self.view)
                                //                            if let view = ConstantURL.commonview as? UIView{
                                //                            ConstantURL.commonview?.makeToast("Please enter City Name")
                                //                            }else{
                                //                                self.view1.makeToast("Please enter City Name")
                                //                            }
                            }else{
                                self.isFilterActive = true
                                let predicate = NSPredicate.init(format: "city CONTAINS[cd] %@",tfcity.text!)
                                let addressList = AddressList().getAddressUsingPredicate(predicate: predicate)
                                self.arrOfList = CustomerDetails.getCustomersUsingPredicate(predicate: NSPredicate.init(format: "SUBQUERY(addressList,$m,ANY $m IN %@).@count > 0",addressList as! CVarArg))
                                
                                self.tblCustomerSelection.reloadData()
                                //                            CustomerDetails.getCustomersUsingPredicate(predicate: <#T##NSPredicate#>)
                            }
                            //                        if(alert.inputView){
                            //
                            //                        }
                        })
                        alert.addTextField(configurationHandler: { (tfcity) in
                            tfcity.setCommonFeature()
                            tfcity.placeholder = "Enter City"
                        })
                        alert.addAction(cancelAction)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        break
                        
                    case 2:
                        //by pincode
                        let alert = UIAlertController.init(title: "Enter pincode", message: "", preferredStyle: .alert)
                        let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
                        let okAction = UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { (action) in
                            let tfcity = alert.textFields![0]
                            if(tfcity.text?.count == 0){
                                tfcity.placeholder = "Enter pincode"
                                
                                Utils.toastmsg(message:"Please enter Pincode",view:self.view)
                            }else{
                                self.isFilterActive = true
                                let predicate = NSPredicate.init(format: "pincode = %d",Int(tfcity.text ?? "0")!)
                                let addressList = AddressList().getAddressUsingPredicate(predicate: predicate)
                                
                                
                                self.arrOfList = CustomerDetails.getCustomersUsingPredicate(predicate: NSPredicate.init(format: "SUBQUERY(addressList,$m,ANY $m IN %@).@count > 0",addressList as! CVarArg))
                                
                                self.tblCustomerSelection.reloadData()
                            }
                            //                        if(alert.inputView){
                            //
                            //                        }
                        })
                        alert.addTextField(configurationHandler: { (tfcity) in
                            tfcity.placeholder = "Enter pincode"
                            tfcity.keyboardType  = UIKeyboardType.numberPad
                        })
                        alert.addAction(cancelAction)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                        break
                        
                        
                    case 3:
                        //by  segment
                        //  self.arrOfSegment = CustomerSegment.getAll()
                        if let segmentpopup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.MiddlePopup) as? ProductNameList{
                            if( self.arrOfselectedCustomerSegment.count == 0 && self.arrOfCustomerSegment.count > 0){
                                self.arrOfselectedCustomerSegment.removeAll()
                                self.arrOfselectedCustomerSegment.append(self.arrOfCustomerSegment.first ?? self.arrOfCustomerSegment[0])
                                
                            }
                            segmentpopup.modalPresentationStyle = .overCurrentContext
                            segmentpopup.arrOfCustomerSegment = self.arrOfSegment ?? [CustomerSegment]()
                            segmentpopup.arrOfselectedCustomerSegment = self.arrOfselectedCustomerSegment ?? [CustomerSegment]()
                            segmentpopup.strTitle = "Select Segment"
                            segmentpopup.strLeftTitle = "OK"
                            segmentpopup.strRightTitle = "Cancel"
                            segmentpopup.selectionmode = SelectionMode.single
                            segmentpopup.delegate = self
                            segmentpopup.isSearchRequire = false
                            segmentpopup.viewfor = ViewFor.customersegment
                            segmentpopup.isFilterRequire = false
                            segmentpopup.parentViewForPopup = self.view
                            Utils.addShadowOnSahdow(view: self.view)
                            self.present(segmentpopup, animated: true, completion: nil)
                        }
                        /* self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                         self.modalPresentationStyle = .overCurrentContext
                         self.strTitle = ""
                         self.delegate = self
                         self.arrOfCustomerSegment = self.arrOfSegment ?? [CustomerSegment]()
                         self.strLeftTitle = "OK"
                         self.strRightTitle = "Cancel"
                         self.selectionmode = SelectionMode.none
                         //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                         self.isSearchBarRequire = false
                         self.viewfor = ViewFor.customersegment
                         self.isFilterRequire = false
                         // popup?.showAnimate()
                         self.present(self, animated: false, completion: nil)
                         */
                        break
                        
                    case 4:
                        //by  class
                        if  let classpopup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.MiddlePopup) as? ProductNameList{
                            if( self.arrOfSelectedClass.count == 0 && Utils().getCustomerClassification().count > 0){
                                self.arrOfSelectedClass = [Utils().getCustomerClassification()[0]]
                            }
                            classpopup.modalPresentationStyle = .overCurrentContext
                            classpopup.strTitle = "Select Class"
                            //  classpopup.delegate = self
                            classpopup.arrOfCustomerClass = self.arrOfCustomerClass ?? Utils().getCustomerClassification()
                            classpopup.arrOfSelectedClass = self.arrOfSelectedClass ?? [String]()
                            classpopup.strLeftTitle = "OK"
                            classpopup.strRightTitle = "Cancel"
                            classpopup.selectionmode = SelectionMode.single
                            classpopup.delegate = self
                            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                            classpopup.isSearchRequire = false
                            classpopup.viewfor = ViewFor.customerClass
                            classpopup.isFilterRequire = false
                            // popup?.showAnimate()
                            /*
                             segmentpopup.parentViewForPopup = self.view
                             Utils.addShadowOnSahdow(view: self.view)
                             **/
                            classpopup.parentViewForPopup = self.view
                            Utils.addShadowOnSahdow(view: self.view)
                            self.present(classpopup, animated: false, completion: nil)
                        }
                        
                        break
                        
                    case 5:
                        //by  Territory
                        self.arrOfterritory = [["territoryName":"All","territoryId":0,"territoryCode":""]]
                        //["territoryName":"All"]
                        for t in Territory.getAll(){
                            self.arrOfterritory.append(t.toDictionary() as? [String:Any] ?? [String:Any]())
                        }
                        if    let classpopup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.MiddlePopup) as? ProductNameList{
                            if( self.arrOfSelectedTerritory.count == 0 && self.arrOfterritory.count > 0){
                                self.arrOfSelectedTerritory = [self.arrOfterritory[0]]
                            }
                            classpopup.modalPresentationStyle = .overCurrentContext
                            classpopup.delegate = self
                            
                            
                            classpopup.strLeftTitle = "Ok"
                            classpopup.strRightTitle = "Cancel"
                            classpopup.selectionmode = SelectionMode.single
                            classpopup.strTitle = "Select Customer Territory"
                            classpopup.arrOfTerritory = self.arrOfterritory
                            classpopup.arrOfSelectedTerritory = self.arrOfSelectedTerritory ?? [[String:Any]]()
                            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                            classpopup.isSearchRequire = false
                            classpopup.viewfor = ViewFor.territory
                            classpopup.isFilterRequire = false
                            classpopup.parentViewForPopup = self.view
                            Utils.addShadowOnSahdow(view: self.view)
                            // popup?.showAnimate()
                            self.present(classpopup, animated: false, completion: nil)
                        }
                        break
                        
                    case 6:
                        //by  beat route
                        self.isFilterActive = true
                        self.loadBeatID()
                        break
                        
                    case 7:
                        //All
                        break
                        
                    default:
                        
                        break
                        
                    }
                }, cancel: {
                    
                })
                
                
            }else{
                if let popperentview = self.parentViewOfPopup as? UIView {
                    Utils.removeShadow(view: popperentview)
                    
                }
                self.dismiss(animated:true, completion: {
                    Utils.removeShadow(view: self.view)
                })
                
                
                //                if let popview =  self.parentViewOfPopup
                // self.nonmandatorydelegate?.completionProductData?(arr: [])
                self.dismiss(animated: true, completion: nil)
            }
        }else if(sender == btnLeft){
            if(sender.currentTitle?.lowercased()  == "okay" || sender.currentTitle?.lowercased() == "ok"){
                if let popperentview = self.parentViewOfPopup as? UIView {
                    Utils.removeShadow(view: popperentview)
                    
                }
                
                self.dismiss(animated: true) {
                    if(self.viewfor == ViewFor.customer){
                        self.nonmandatorydelegate?.completionData!(arr: self.arrOfSelectedMultipleCustomer!)
                    }else if(self.viewfor == ViewFor.document){
                        if let popperentview = self.parentViewOfPopup as? UIView {
                            Utils.removeShadow(view: popperentview)
                        }
                        self.mandatorydelegate?.completionSelectedDocument(arr: self.arrOfSelectedDocument)
                        self.dismiss(animated: true) {
                            self.mandatorydelegate?.completionSelectedDocument(arr: self.arrOfSelectedDocument)
                            
                        }
                    }else  if(self.viewfor == ViewFor.firstInfluencer){
                        self.nonmandatorydelegate?.completionfirstInfluencer!(arr: self.arrOfSelectedSingleCustomer!)
                        
                    }else  if(self.viewfor == ViewFor.secondInfluencer){
                        self.nonmandatorydelegate?.completionsecondInfluencer?(arr: self.arrOfSelectedSingleCustomer!)
                    } else if(self.viewfor == ViewFor.companyuser || self.viewfor ==  ViewFor.viewForTageCustomer){
                        self.nonmandatorydelegate?.completionSelectedExecutive!(arr: self.arrOfSelectedExecutive!)
                    }else if(self.viewfor == ViewFor.leadoutcome){
                        self.nonmandatorydelegate?.completionSelectedLeadOutCome!(arr: self.arrOfSelectedLeadOutCome)
                    }else if(self.viewfor == ViewFor.visitoutcome){
                        self.nonmandatorydelegate?.completionSelectedVisitOutCome!(arr: self.arrOfSelectedVisitOutcome)
                    }else if(self.viewfor == ViewFor.visitStep){
                        self.nonmandatorydelegate?.completionSelectedVisitStep?(arr: self.arrOfSelectedVisitStep)
                    }
                    else if(self.viewfor == ViewFor.productcategory){
                        self.nonmandatorydelegate?.completionProductCategory!(arr: self.arrOfSelectedProductCategory)
                    }else if(self.viewfor == ViewFor.product){
                        self.nonmandatorydelegate?.completionProductData!(arr: self.arrOfSelectedProduct)
                    }else if(self.viewfor == ViewFor.customerClass){
                        self.nonmandatorydelegate?.completionSelectedClass?(arr: self.arrOfSelectedClass, recordno: self.selectedRecordNo, strTitle: self.strTitle)
                    }else if(self.viewfor == ViewFor.customersegment){
                        self.nonmandatorydelegate?.completionSelectedSegment?(arr: self.arrOfselectedCustomerSegment)
                    }
                }
            }else if(sender.currentTitle == "REFRESH"){
                //refresh the customers
                let topRow = IndexPath(row: 0,
                                       section: 0)
                if(tblCustomerSelection.visibleCells.count > 0){
                    // 2
                    self.tblCustomerSelection.scrollToRow(at: topRow,
                                                          at: .top,
                                                          animated: true)
                }
                // tblCustomerSelection.re
            }else if(sender.currentTitle == "CANCEL"){
                if let popperentview = self.parentViewOfPopup as? UIView {
                    Utils.removeShadow(view: popperentview)
                }
                
                self.dismiss(animated: true, completion: {
                    Utils.removeShadow(view: self.parentViewOfPopup)
                })
            }
        }else if(sender == btnRight){
            if let popperentview = self.parentViewOfPopup as? UIView {
                Utils.removeShadow(view: popperentview)
            }
            self.nonmandatorydelegate?.completionProductData?(arr: [])
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: APICall
    
    func loadBeatID(){
        let beatplandic = ["CompanyID":Utils().getActiveAccount()?.company?.iD,"UserID":Utils().getActiveAccount()?.userID]
        var param = Common.returndefaultparameter()
        param["getUploadBeatPlanDetailsJson"] = Common.json(from: beatplandic)
        ApiHelper().getdeletejoinvisit(param:param , strurl: ConstantURL.kWSUrlGetUploadBeatPlanDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                if(responseType == ResponseType.arr){
                    // self.arrOfTableBeatPlan = [BeatPlanAssign]()
                    var   arrofbeat = arr as? [Any] ?? [Any]()
                    self.arrOfBeatPlan = [BeatPlan]()
                    
                    var dic = [String:Any]()
                    dic["ID"] = NSNumber.init(value: 0)
                    dic["BeatPlanID"] = NSNumber.init(value: 0)
                    dic["BeatPlanName"] = "All"
                    arrofbeat.insert(dic, at: 0)
                    for beat in arrofbeat{
                        let dicBeat = beat as? [String : Any] ?? [String:Any]()
                        
                        let instancebeatplan = BeatPlan.init(dicBeat)
                        
                        self.arrOfBeatPlan.append(instancebeatplan)
                    }
                    if(self.arrOfSelectedBeatPlan.count == 0 && self.arrOfBeatPlan.count > 0){
                        self.arrOfSelectedBeatPlan = [self.arrOfBeatPlan[0]]
                    }
                    //by  segment
                    if let segmentpopup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.MiddlePopup) as? ProductNameList{
                        
                        segmentpopup.modalPresentationStyle = .overCurrentContext
                        // segmentpopup.arrOfCustomerSegment = self.arrOfSegment ?? [CustomerSegment]()
                        segmentpopup.arrOfBeatPlan = self.arrOfBeatPlan ?? [BeatPlan]()
                        segmentpopup.arrOfSelectedBeatPlan = self.arrOfSelectedBeatPlan ?? [BeatPlan]()
                        segmentpopup.strTitle = "Select Beat Plan"
                        segmentpopup.strLeftTitle = "OK"
                        segmentpopup.strRightTitle = "Cancel"
                        segmentpopup.selectionmode = SelectionMode.single
                        segmentpopup.delegate = self
                        segmentpopup.mandatorydelegate = self
                        segmentpopup.isSearchRequire = false
                        segmentpopup.viewfor = ViewFor.beatplan
                        segmentpopup.isFilterRequire = false
                        self.present(segmentpopup, animated: true, completion: nil)
                    }
                    /* if(self.arrOfBeatPlan.count > 0){
                     
                     self.dateFormatter.dateFormat = "dd-MM-yyyy"
                     let sd = self.dateFormatter.date(from: self.tfStartDate.text ?? "")
                     let ld = self.dateFormatter.date(from: self.tfEndDate.text ?? "")
                     let strstartdate = self.dateFormatter.string(from: sd ?? Date())
                     let strenddate = self.dateFormatter.string(from: ld ?? Date())
                     let startDate = self.dateFormatter.date(from: strstartdate)
                     let endDate = self.dateFormatter.date(from: strenddate)
                     let calender = Calendar.init(identifier: Calendar.Identifier.gregorian)
                     var dic = [String:Any]()
                     let daycomponents = calender.dateComponents([.day], from: startDate ?? Date(), to: endDate ?? Date())
                     //                        if((self.beatForSelectedBeatPlan.count > 0) && (self.isBeatsFiltered == true)){
                     //                            dic["selectedBeatPlan"] = self.beatForSelectedBeatPlan.first
                     //                        }else if((self.isBeatsFiltered == false) &&  (self.arrOfBeatPlan.count > 0 )){
                     //                            dic["selectedBeatPlan"] = self.arrOfBeatPlan.first
                     //                        }else{
                     
                     var dicForSelectedBeatPlan = [String:Any]()
                     dicForSelectedBeatPlan["BeatPlanName"] = "Select Beat ID"
                     dicForSelectedBeatPlan["BeatPlanID"] =  NSNumber.init(value:0)
                     dicForSelectedBeatPlan["selectedBeatPlan"] = dicForSelectedBeatPlan
                     dicForSelectedBeatPlan["CompanyID"] = self.activeuser?.company?.iD
                     dicForSelectedBeatPlan["AssigneeID"] = self.selectedUser.entity_id
                     dicForSelectedBeatPlan["ID"] = 0
                     dic["selectedBeatPlan"] =  BeatPlan.init(dicForSelectedBeatPlan)
                     //  }
                     //  if(self.activesetting.territoryMandatoryInBeatPlan ==  true  && self.arrTerriotaryFromAPI.count > 0){
                     if(self.arrTerriotaryFromAPI.count > 0){
                     dic["selectedTerritory"] =  self.arrTerriotaryFromAPI.first
                     }
                     dic["CreatedBy"] = self.activeuser?.userID
                     dic["AssigneeID"] = self.selectedUserID
                     dic["CompanyID"] = self.activeuser?.company?.iD
                     dic["isSelected"] =  false
                     //                        daycomponents
                     if(daycomponents.day ?? 0 > 0){
                     for day in 0...daycomponents.day! - 1{
                     var newcomponents = DateComponents()
                     newcomponents.day = day
                     let date = calender.date(byAdding: newcomponents, to: startDate!)
                     dic["BeatPlanDate"] =  self.dateFormatter.string(from: date!)
                     var beatplanassignobj =  BeatPlanAssign.init(dic)
                     self.dateFormatter.dateFormat = String.init(format:"yyyy'\'/MM'\'/dd' hh:mm:ss")
                     beatplanassignobj.BeatPlanDate =  self.dateFormatter.string(from: date!)
                     if(self.arrTerriotaryFromAPI.count > 0){
                     dic["selectedTerritory"] = self.arrTerriotaryFromAPI.first
                     }
                     self.arrOfTableBeatPlan.append(beatplanassignobj)
                     
                     //let obj =
                     }
                     
                     
                     }
                     self.dateFormatter.dateFormat = "dd-MM-yyyy"
                     let lld = self.dateFormatter.date(from: self.tfEndDate.text ?? "")
                     //"yyyy\/MM\/dd hh:mm:ss"
                     self.dateFormatter.dateFormat = String.init(format:"yyyy'\'/MM'\'/dd' hh:mm:ss")
                     dic["BeatPlanDate"] = self.dateFormatter.string(from:lld ?? Date())
                     let obj = BeatPlanAssign.init(dic)
                     //                        if(self.arrTerriotaryFromAPI.count > 0){
                     //                            dic["selectedTerritory"] = self.arrTerriotaryFromAPI.first
                     //                        }
                     self.arrOfTableBeatPlan.append(obj)
                     
                     
                     if(self.arrOfBeatPlan.count > 0 ){
                     
                     // self.heightTblBeatPlan.constant = self.tableViewHeight
                     
                     
                     }else{
                     self.view1.makeToast("You have not BeatIds")
                     }
                     //  print(self.heightTblBeatPlan.constant)
                     //                        self.isBeatsFiltered  = false
                     //
                     //                        self.beatIDPicker.dataSource = self.arrOfBeatPlan.map{
                     //                            String.init(format:"%@ | %@", $0.BeatPlanID , $0.BeatPlanName)
                     //                        }
                     //                        if(self.beatIDPicker.dataSource.count > 0){
                     //                            self.selectedBeatID =  self.arrOfBeatPlan.first?.ID ?? 0
                     //                        }else{
                     //                            self.selectedBeatID = 0
                     //                        }
                     //                        self.tblBeatPlan.reloadData()
                     }else{
                     self.view1.makeToast("You have not BeatIds")
                     // self.tblBeatPlan.reloadData()
                     }*/
                }
                
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view:self.view)
                    //   self.view1.makeToast(message)
                }
                
                //(message.count == 0 ? : self.view1.makeToast(message) )
                
            }else{
                Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view:self.view)
                // self.view1.makeToast(error.userInfo["localiseddescription"]  as? String ?? "")
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
    //    func showAnimate()
    //    {
    //        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    //        self.view.alpha = 0.0
    //        UIView.animate(withDuration: 0.25, animations: {
    //            self.view.alpha = 1.0
    //            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    //        })
    //    }
    //
    //    func removeAnimate()
    //    {
    //        UIView.animate(withDuration: 0.25, animations: {
    //            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    //            self.view.alpha = 0.0
    //        }, completion: {(finished : Bool) in
    //            if(finished)
    //            {
    //                self.willMove(toParent: nil)
    //                self.view.removeFromSuperview()
    //                self.removeFromParent()
    //            }
    //        })
    //    }
    
}

extension CustomerSelection : UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if(searchBar.text?.count ?? 0 > 0){
            searchActive = true;
        }else{
            searchActive = false;
        }
        self.searchBar.endEditing(true)
        self.tblCustomerSelection.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
        self.tblCustomerSelection.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text?.count ?? 0 > 0){
            searchActive = true;
        }else{
            searchActive = false;
        }
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count > 0){
            searchActive = true
            if(viewfor == ViewFor.customer || viewfor == ViewFor.firstInfluencer || viewfor == ViewFor.secondInfluencer){
                filteredCustomer =
                arrOfList.compactMap { (temp) -> CustomerDetails in
                    return temp
                }.filter { (aUser) -> Bool in
                    
                    return aUser.name?.localizedCaseInsensitiveContains(searchText) == true || aUser.mobileNo?.localizedCaseInsensitiveContains(searchText) == true
                }
                
                
                self.tblCustomerSelection.reloadData()
            }else if(viewfor == ViewFor.beatplan){
                arrOffilteredBeatPlan =
                self.arrOfBeatPlan.compactMap { (temp) -> BeatPlan in
                    return temp
                }.filter { (aUser) -> Bool in
                    return aUser.BeatPlanName?.localizedCaseInsensitiveContains(searchText) == true || aUser.BeatPlanID?.localizedCaseInsensitiveContains(searchText) == true
                    
                }
                
                
                self.tblCustomerSelection.reloadData()
            }else if(viewfor == ViewFor.product){
                arrOfFilteredProduct = arrOfProduct.compactMap { (temp) -> Product in
                    return temp
                }.filter { (aUser) -> Bool in
                    return aUser.productName?.localizedCaseInsensitiveContains(searchText) == true
                }
                
                self.tblCustomerSelection.reloadData()
            }
            else if(viewfor == ViewFor.productcategory){
                arrOfFilteredCategory = arrOfProductCategory.compactMap { (temp) -> ProdCategory in
                    return temp
                }.filter { (aUser) -> Bool in
                    
                    return aUser.name?.localizedCaseInsensitiveContains(searchText) == true
                }
                
                self.tblCustomerSelection.reloadData()
            }else if(viewfor == ViewFor.vendor){
                arrOfFilteredVendor = arrOfVendor.compactMap{ (temp) -> Vendor in
                    return temp
                }.filter { (aUser) -> Bool in
                    
                    
                    return aUser.name?.localizedCaseInsensitiveContains(searchText) == true
                }
                
                self.tblCustomerSelection.reloadData()
            }else if(viewfor == ViewFor.productsubcategory){
                arrOfFilteredProductSubCategory = arrOfProductSubCategory.compactMap { (temp) -> ProductSubCat in
                    return temp
                }.filter { (aUser) -> Bool in
                    
                    
                    return aUser.name?.localizedCaseInsensitiveContains(searchText) == true
                }
                
                self.tblCustomerSelection.reloadData()
            }else if(viewfor == ViewFor.customerClass){
                arrOffilteredCustomerClass = arrOfCustomerClass.filter({ (customerclass) -> Bool in
                    return customerclass.contains(searchText)
                })
                searchActive = true
                
                self.tblCustomerSelection.reloadData()
            }
        }else if(viewfor == ViewFor.lead){
            arrOfFilteredLead = arrOfLead.filter({ (lead) -> Bool in
                return (lead.customerName?.contains(searchText) ?? false)
            })
            searchActive = true
            
            self.tblCustomerSelection.reloadData()
        }else{
            searchActive = false
            tblCustomerSelection.reloadData()
        }
    }
}
extension CustomerSelection: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(viewfor == ViewFor.companyuser || viewfor ==  ViewFor.viewForTageCustomer ){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOffilteredExecutive.count
            }else{
                return arrOfExecutive?.count ?? 0
            }
        }else if(viewfor == ViewFor.lead || viewfor == ViewFor.lead){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOfFilteredLead.count
            }else{
                return arrOfLead.count
            }
        }else if(viewfor == ViewFor.product){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOfFilteredProduct.count
            }else{
                return arrOfProduct.count
            }
        }else if(viewfor == ViewFor.leadoutcome){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOffilteredLeadOutcome.count
            }else{
                return arrOfLeadOutCome.count
            }
        }else if(viewfor == ViewFor.visitoutcome){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOffilteredVisitOutcome.count
            }else{
                return arrOfVisitOutCome.count
            }
        }
        else if(viewfor == ViewFor.productcategory){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOfFilteredCategory.count
            }else{
                return arrOfProductCategory.count
            }
        }else if(viewfor == ViewFor.productsubcategory){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOfFilteredProductSubCategory.count
            }else{
                return arrOfProductSubCategory.count
            }
        }else if(viewfor == ViewFor.customersegment){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOffilteredCustomerSegment.count
            }else{
                return arrOfCustomerSegment.count
            }
        }else if(viewfor == ViewFor.customerClass){
            self.tblCustomerSelection.separatorColor = UIColor.clear
            if(isSearchBarRequire == true && searchActive == true){
                return arrOffilteredCustomerClass.count
            }else{
                return arrOfCustomerClass.count
            }
        }else if(viewfor == ViewFor.territory){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOfSelectedTerritory.count
            }else{
                return arrOfTerritory.count
            }
            
        }else if(viewfor == ViewFor.beatplan){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOffilteredBeatPlan.count
            }else{
                return arrOfBeatPlan.count
            }
        }else if(viewfor == ViewFor.vendor){
            if(isSearchBarRequire == true && searchActive == true){
                return arrOfSelectedVendor.count
            }else{
                return arrOfVendor.count
            }
        }
        else if(viewfor == ViewFor.visitStep){
            return arrOfVisitStep.count
        }else if(viewfor == ViewFor.document){
            return arrOfDocument.count
        }else{
            if(isSearchBarRequire == true && searchActive == true){
                return filteredCustomer.count
            } else {
                return arrOfList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "customerselectioncell", for: indexPath) as? CustomerSelectionCell
        cell.btnCustomerSelection.tag = indexPath.row
        if(viewfor == ViewFor.visitStep){
            cell.btnMandatorySwitch.isHidden = false
            cell.btnMandatorySwitch.isUserInteractionEnabled = false
        }else{
            cell.btnMandatorySwitch.isHidden = true
            cell.btnMandatorySwitch.isUserInteractionEnabled = false
        }
        if(selectionmode == SelectionMode.none){
            cell.vwMultipleSelection.isHidden = true
        }
        
        cell.btnCustomerSelection.tag = indexPath.row
        cell.btnCustomerSelection.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        
        if(viewfor == ViewFor.companyuser || viewfor ==  ViewFor.viewForTageCustomer ){
            
            var companyuser = CompanyUsers()
            if(isSearchBarRequire == true && searchActive == true){
                companyuser = arrOfSelectedExecutive[indexPath.row]
            }else{
                companyuser =  (arrOfExecutive?[indexPath.row])!
            }
            cell.lblCustomerName.text = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
            cell.vwContactNo.isHidden = true
            
            if (selectionmode == SelectionMode.single){
                if(arrOfSelectedExecutive?.contains(companyuser) ?? false ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                }
            }else if(selectionmode == SelectionMode.multiple){
                if(arrOfSelectedExecutive?.contains(companyuser) ?? false ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                    if(viewfor == ViewFor.viewForTageCustomer){
                        cell.btnCustomerSelection.isUserInteractionEnabled = false
                    }
                }else{
                    cell.btnCustomerSelection.isUserInteractionEnabled = true
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
                }
            }
            
            
            cell.contentView.layoutIfNeeded()
            return cell
            
            
        }
        else if(viewfor == ViewFor.lead){
            var selectedLead = Lead()
            if(isSearchBarRequire ==  true && searchActive == true){
                selectedLead =  arrOfFilteredLead[indexPath.row]
            }else{
                selectedLead = arrOfLead[indexPath.row]
            }
            cell.lblCustomerName.text = selectedLead.customerName
            cell.lblContactNo.text = String.init(format: "ID: \(selectedLead.iD)")
            cell.vwContactNo.isHidden = false
            cell.contentView.layoutIfNeeded()
            return cell
        }
        else if(viewfor == ViewFor.territory){
            
            var customerTerritory = [String:Any]()
            if(isSearchBarRequire == true && searchActive == true){
                customerTerritory = arrOfSelectedTerritory[indexPath.row]
            }else{
                customerTerritory =  (arrOfTerritory?[indexPath.row])!
            }
            if(indexPath.row == 0){
                cell.lblCustomerName.text =  customerTerritory["territoryName"] as! String
            }else{
                cell.lblCustomerName.text = String.init(format: "%@ | %@", customerTerritory["territoryName"] as! CVarArg,customerTerritory["territoryCode"] as! CVarArg)
            }
            cell.vwContactNo.isHidden = true
            
            if (selectionmode == SelectionMode.single){
                //if(arrOfTerritory?.contains(where: customerTerritory) ?? false ==  true){
                //                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                //                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                //                }else{
                //                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                //                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                //}
            }else if(selectionmode == SelectionMode.multiple){
                //if(arrOfSelectedTerritory?.contains(where: customerTerritory) ?? false ==  true){
                //                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                //                                       cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                //                    }else{
                //                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                //                        cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
                //}
            }
            
            
            cell.contentView.layoutIfNeeded()
            return cell
        }
        
        else if(viewfor == ViewFor.leadoutcome){
            var leadoutcome = Outcomes()
            if(isSearchBarRequire == true && searchActive == true){
                leadoutcome = arrOfSelectedLeadOutCome[indexPath.row]
            }else{
                leadoutcome =  arrOfLeadOutCome[indexPath.row]
            }
            
            cell.lblCustomerName.text = leadoutcome.leadOutcomeValue
            cell.lblCustomerName.setMultilineLabel(lbl: cell.lblCustomerName)
            cell.vwContactNo.isHidden = true
            if (selectionmode == SelectionMode.single){
                if(arrOfSelectedLeadOutCome?.contains(leadoutcome) ?? false ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                }
            }else if(selectionmode == SelectionMode.multiple){
                if(arrOfSelectedLeadOutCome?.contains(leadoutcome) ?? false ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
                }
            }
            cell.contentView.layoutIfNeeded()
            
//            if(arrOfSelectedLeadOutCome?.contains(leadoutcome) ?? false ==  true){
//                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
//                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
//            }else{
//                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
//                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
//            }
            
            return cell
        }else if(viewfor == ViewFor.visitoutcome){
            var visitoutcome = VisitOutcomes()
            
            if(isSearchBarRequire == true && searchActive == true){
                visitoutcome = arrOfSelectedVisitOutcome[indexPath.row]
            }else{
                visitoutcome =  arrOfVisitOutCome[indexPath.row]
            }
            
            cell.lblCustomerName.text = visitoutcome.visitOutcomeValue
            cell.lblCustomerName.setMultilineLabel(lbl: cell.lblCustomerName)
            cell.vwContactNo.isHidden = true
            if (selectionmode == SelectionMode.single){
                if(arrOfSelectedVisitOutcome?.contains(visitoutcome) ?? false ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                }
            }else if(selectionmode == SelectionMode.multiple){
                if(arrOfSelectedVisitOutcome?.contains(visitoutcome) ?? false ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
                }
            }
            cell.contentView.layoutIfNeeded()
            return cell
        }else if(viewfor == ViewFor.product){
            var product = Product()
            if(isSearchBarRequire == true && searchActive == true){
                product = arrOfFilteredProduct[indexPath.row]
            }else{
                product = arrOfProduct[indexPath.row]
            }
            if isProductView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductMultiLineCell", for: indexPath) as? ProductMultiLineCell
                cell?.lblProductNm.text = product.productName
                
                let filteredContacts = productStockArray.filter { object in
                    guard let title = object["Name"] as? String else {return false}
                    return title.contains(product.productName ?? "")
                }
                if let d = filteredContacts.first {
                    if isProductViewWithMultiLine {
                        cell?.lblOnHand.text = String(format: "OnHand\n\n%ld", d["On"] as? Int64 ?? 0)
                        cell?.lblAvl.text = String(format: "Avail\n\n%ld", d["Avl"] as? Int64 ?? 0)
                        cell?.lblSuggestedQty.text = String(format: "Suggest\n\n%ld", d["SugQty"] as? Int64 ?? 0)
                        cell?.lblSuggestedQty.isHidden = false
                    } else {
                        cell?.lblAvl.text = String(format: "Avail\n\n%ld", d["Avl"] as? Int64 ?? 0)
                        cell?.lblOnHand.text = String(format: "OnHand\n\n%ld", d["On"] as? Int64 ?? 0)
                        cell?.lblSuggestedQty.isHidden = true
                    }
                }else{
                    if isProductViewWithMultiLine {
                        cell?.lblOnHand.text = String(format: "Suggest: 0")
                        cell?.lblAvl.text = String(format: "Avail: 0")
                        cell?.lblSuggestedQty.text = String(format: "OnHand: 0")
                        cell?.lblSuggestedQty.isHidden = false
                    } else {
                        cell?.lblAvl.text = String(format: "OnHand: 0")
                        cell?.lblOnHand.text = String(format: "Avail: 0")
                        cell?.lblSuggestedQty.isHidden = true
                    }
                }
                
                if(self.productDriveIDs.contains(NSNumber(value:product.productId ))){
                    cell?.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xE2EDF1)
                }else{
                    cell?.backgroundColor = UIColor.white
                }
                return cell!
            }
            
            if(self.productDriveIDs.contains(NSNumber(value:product.productId ))){
                cell.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xE2EDF1)
            }else{
                cell.vwBackground.backgroundColor = UIColor.white
            }
            cell.lblCustomerName.text = product.productName
            cell.vwContactNo.isHidden = true
            if (selectionmode == SelectionMode.single){
                if(arrOfSelectedProduct.contains(product) ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                }
            }else if(selectionmode == SelectionMode.multiple){
                if(arrOfSelectedProduct.contains(product) ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
                }
            }
            
            cell.contentView.layoutIfNeeded()
            return cell
        }else if(viewfor == ViewFor.productsubcategory){
            var productsubcatergory = ProductSubCat()
            if(isSearchBarRequire == true && searchActive == true){
                productsubcatergory = arrOfFilteredProductSubCategory[indexPath.row]
            }else{
                productsubcatergory = arrOfProductSubCategory[indexPath.row]
            }
            
            cell.vwContactNo.isHidden = false
            let category = ProdCategory.getProductByCatID(catId: NSNumber.init(value:productsubcatergory.superCatID))
            cell.lblContactNo.textColor = UIColor.Appskybluecolor
            cell.lblContactNo.text = category?.name ?? ""//productsubcatergory.
            cell.lblCustomerName.text = productsubcatergory.name
            cell.contentView.layoutIfNeeded()
            return cell
        }
        else if(viewfor == ViewFor.productcategory){
            var productcatrgory = ProdCategory()
            if(isSearchBarRequire == true && searchActive == true){
                productcatrgory = arrOfFilteredCategory[indexPath.row]
            }else{
                productcatrgory = arrOfProductCategory[indexPath.row]
            }
            
            
            cell.vwContactNo.isHidden = true
            cell.lblCustomerName.text = productcatrgory.name
            cell.contentView.layoutIfNeeded()
            return cell
        }else if(viewfor == ViewFor.vendor){
            var vendor = Vendor()
            if(isSearchBarRequire == true && searchActive == true){
                vendor = arrOfFilteredVendor[indexPath.row]
            }else{
                vendor = arrOfVendor[indexPath.row]
            }
            cell.lblCustomerName.text = vendor.name
            cell.lblContactNo.text = vendor.mobileNo
            
            return cell
        }
        else if(viewfor == ViewFor.customersegment){
            var selectedsegment = CustomerSegment()
            if(isSearchBarRequire == true && searchActive == true){
                selectedsegment = arrOfselectedCustomerSegment[indexPath.row]
            }else{
                selectedsegment = arrOfCustomerSegment[indexPath.row]
            }
            if (selectionmode == SelectionMode.single){
                if(arrOfselectedCustomerSegment.contains(selectedsegment) ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                }
            }else if(selectionmode == SelectionMode.multiple){
                if(arrOfselectedCustomerSegment.contains(selectedsegment) ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
                }
            }
            
            cell.vwContactNo.isHidden = true
            cell.lblCustomerName.text = selectedsegment.customerSegmentValue
            cell.contentView.layoutIfNeeded()
            return cell
        }else if(viewfor == ViewFor.customerClass){
            var selectedclass = String()
            if(isSearchBarRequire == true && searchActive == true){
                selectedclass = arrOffilteredCustomerClass[indexPath.row]
            }else{
                selectedclass = arrOfCustomerClass[indexPath.row]
            }
            
            if (selectionmode == SelectionMode.single){
                if(arrOfSelectedClass.contains(selectedclass) ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                }
            }else if(selectionmode == SelectionMode.multiple){
                if(arrOfSelectedClass.contains(selectedclass) ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
                }
            }
            cell.vwContactNo.isHidden = true
            cell.lblCustomerName.text = selectedclass
            cell.contentView.layoutIfNeeded()
            return cell
        }else if(viewfor == ViewFor.beatplan){
            var selectedBeatPlan:BeatPlan!
            if(isSearchBarRequire == true && searchActive == true){
                selectedBeatPlan = arrOffilteredBeatPlan[indexPath.row]
            }else{
                selectedBeatPlan = arrOfBeatPlan[indexPath.row]
            }
            cell.vwContactNo.isHidden = true
            cell.lblCustomerName.text = String.init(format:"%@ | %@",selectedBeatPlan.BeatPlanID,selectedBeatPlan.BeatPlanName)
            cell.contentView.layoutIfNeeded()
            return cell
        }else if(viewfor == ViewFor.visitStep){
            let selectedstep = arrOfVisitStep[indexPath.row]
            cell.vwContactNo.isHidden = true
            cell.lblCustomerName.text = selectedstep.menuLocalText
            //            if(selectedstep.mandatoryOrOptional == true){
            //                cell.btnMandatorySwitch.isSelected = true
            //            }else{
            //                cell.btnMandatorySwitch.isSelected = false
            //            }
            if(self.arrOfMandatoryStep.contains(selectedstep)){
                cell.btnMandatorySwitch.isSelected = true
            }else{
                cell.btnMandatorySwitch.isSelected = false
            }
            if(arrOfSelectedVisitStep.contains(selectedstep) ==  true){
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                
            }else{
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
            }
            return cell
        }else if(viewfor == ViewFor.document){
            let selectedDocument =  arrOfDocument[indexPath.row]
            cell.lblCustomerName.text = selectedDocument.title
            cell.lblContactNo.isHidden = true
            var contain = false
            cell.btnCustomerSelection.tag = indexPath.row
            for doc in arrOfSelectedDocument{
                if(doc.documentID == selectedDocument.documentID){
                    contain = true
                }
            }
            if(contain ==  true){
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                
            }else{
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
            }
            
            return cell
        }else{
            
            var customer = CustomerDetails()
            if(searchActive) {
                customer =  filteredCustomer[indexPath.row]
            } else {
                customer =  arrOfList[indexPath.row]
            }
            
            
            
            
            cell.lblCustomerName.text = customer.name
            cell.lblContactNo.text = customer.mobileNo
            if (selectionmode == SelectionMode.single){
                if(arrOfSelectedSingleCustomer!.contains(customer) ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .selected)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_radio_unselected"), for: .normal)
                }
            }else if(selectionmode == SelectionMode.multiple){
                if(arrOfSelectedMultipleCustomer!.contains(customer) ==  true){
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_selected"), for: .selected)
                }else{
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .normal)
                    cell.btnCustomerSelection.setImage(UIImage.init(named: "icon_checkbox_unselected"), for: .selected)
                }
            }
            //        if(selectionmode == SelectionMode.none){
            //                cell.vwMultipleSelection.isHidden = true
            //            }else if (selectionmode == SelectionMode.single){
            //                cell.btnCustomerSelection.tag = indexPath.row
            //            cell.btnCustomerSelection.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
            //
            //            }else {
            //                cell.btnCustomerSelection.tag = indexPath.row
            //                cell.btnCustomerSelection.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
            //            }
            cell.contentView.layoutIfNeeded()
            cell.contentView.layoutSubviews()
            return cell
        }
    }
    @objc func btnClicked(sender:UIButton){
        
        if(viewfor == ViewFor.visitStep){
            let step = arrOfVisitStep[sender.tag]
            if(arrOfDisableVisitStep.contains(step)){
                return
            }else{
                sender.isSelected = !sender.isSelected
            }
        }else{
            sender.isSelected = !sender.isSelected
        }
        
        // selectedIndexPath = IndexPath.init(item: sender.tag, section: 0)
        
        
        if(viewfor == ViewFor.customer || viewfor == ViewFor.firstInfluencer || viewfor == ViewFor.secondInfluencer){
            if(searchActive) {
                if(arrOfSelectedMultipleCustomer!.contains(filteredCustomer[sender.tag])){
                    arrOfSelectedMultipleCustomer = arrOfSelectedMultipleCustomer!.filter{
                        $0 != filteredCustomer[sender.tag]
                    }
                    
                }else{
                    if(arrOfSelectedMultipleCustomer.count < 20){
                        arrOfSelectedMultipleCustomer.append(filteredCustomer[sender.tag])
                    }else{
                        Utils.toastmsg(message:"You can not add more than 20 customers",view:self.view)
                        //  self.view1.makeToast("You can not add more than 20 customers")
                    }
                }
            }else{
                if(selectionmode == SelectionMode.multiple){
                    if(arrOfSelectedMultipleCustomer!.contains(arrOfList[sender.tag])){
                        arrOfSelectedMultipleCustomer = arrOfSelectedMultipleCustomer!.filter{
                            $0 != arrOfList[sender.tag]
                        }
                    }else {
                        if(arrOfSelectedMultipleCustomer.count < 20){
                            arrOfSelectedMultipleCustomer.append(arrOfList[sender.tag])
                        }else {
                            Utils.toastmsg(message:"You can not add more than 20 customers",view:self.view)
                        }
                    }
                }else{
                    if(arrOfSelectedSingleCustomer!.contains(arrOfList[sender.tag])){
                        arrOfSelectedSingleCustomer = arrOfSelectedSingleCustomer!.filter{
                            $0 != arrOfList[sender.tag]
                        }
                    }
                }
            }
        }else if(viewfor == ViewFor.leadoutcome){
            if(searchActive) {
                if(arrOfSelectedLeadOutCome.contains(arrOffilteredLeadOutcome[sender.tag])){
                    arrOfSelectedLeadOutCome = arrOfSelectedLeadOutCome.filter{
                        $0 != arrOffilteredLeadOutcome[sender.tag]
                    }
                    
                }else{
                    if(arrOfSelectedLeadOutCome.count < 5){
                        arrOfSelectedLeadOutCome.append(arrOffilteredLeadOutcome![sender.tag])
                    }else{
                        Utils.toastmsg(message:"You can not add more than 5 Outcome",view:self.view)
                        // self.view1.makeToast("You can not add more than 5 Outcome")
                    }
                }
            }else {
                if(selectionmode ==  SelectionMode.single) {
                    arrOfSelectedLeadOutCome?.removeAll()
                    arrOfSelectedLeadOutCome?.append(arrOfLeadOutCome![sender.tag])
                }else if(selectionmode == SelectionMode.multiple){
//                    if(arrOfSelectedExecutive.contains(arrOfExecutive[sender.tag])){
//                        arrOfSelectedExecutive = arrOfSelectedExecutive.filter{
//                            $0 != arrOfExecutive[sender.tag]
//                        }
//                    }else{
//                        arrOfSelectedExecutive.append(arrOfExecutive[sender.tag])
//                    }
                    if(arrOfSelectedLeadOutCome.contains(arrOfSelectedLeadOutCome[sender.tag])){
                        arrOfSelectedLeadOutCome = arrOfSelectedLeadOutCome.filter{
                            $0 != arrOfLeadOutCome[sender.tag]
                        }
                        
                    }else{
                        if(arrOfSelectedLeadOutCome.count < 5){
                            arrOfSelectedLeadOutCome.append(arrOfLeadOutCome![sender.tag])
                        }else{
                            Utils.toastmsg(message:"You can not add more than 5 Outcome",view:self.view)
                            //  self.view1.makeToast("You can not add more than 5 Outcome")
                        }
                    }
                }
            }
        }else if(viewfor == ViewFor.visitoutcome){
            if(searchActive) {
                if(arrOfSelectedVisitOutcome.contains(arrOffilteredVisitOutcome[sender.tag])){
                    arrOfSelectedVisitOutcome = arrOfSelectedVisitOutcome.filter{
                        $0 != arrOffilteredVisitOutcome[sender.tag]
                    }
                    
                }else{
                    if(arrOfSelectedVisitOutcome.count < 5){
                        arrOfSelectedVisitOutcome.append(arrOffilteredVisitOutcome![sender.tag])
                    }else{
                        Utils.toastmsg(message:"You can not add more than 5 Outcome",view:self.view)
                        //  self.view1.makeToast("You can not add more than 5 Outcome")
                    }
                }
            }else{
                if(arrOfSelectedVisitOutcome.contains(arrOfVisitOutCome[sender.tag])){
                    arrOfSelectedVisitOutcome = arrOfSelectedVisitOutcome.filter{
                        $0 != arrOfVisitOutCome[sender.tag]
                    }
                    
                }else{
                    if(arrOfSelectedVisitOutcome.count < 5){
                        arrOfSelectedVisitOutcome.append(arrOfVisitOutCome![sender.tag])
                    }else{
                        Utils.toastmsg(message:"You can not add more than 5 Outcome",view:self.view)
                        //    self.view1.makeToast("You can not add more than 5 Outcome")
                    }
                }
            }
        }else if(viewfor == ViewFor.companyuser || viewfor ==  ViewFor.viewForTageCustomer ){
            if(selectionmode ==  SelectionMode.single){
                arrOfSelectedExecutive?.removeAll()
                arrOfSelectedExecutive?.append(arrOfExecutive![sender.tag])
            }else if(selectionmode == SelectionMode.multiple){
                if(arrOfSelectedExecutive.contains(arrOfExecutive[sender.tag])){
                    arrOfSelectedExecutive = arrOfSelectedExecutive.filter{
                        $0 != arrOfExecutive[sender.tag]
                    }
                }else{
                    arrOfSelectedExecutive.append(arrOfExecutive[sender.tag])
                }
            }
        }else if(viewfor == ViewFor.visitStep){
            if(arrOfSelectedVisitStep.contains(arrOfVisitStep[sender.tag])){
                arrOfSelectedVisitStep = arrOfSelectedVisitStep.filter{
                    $0 != arrOfVisitStep[sender.tag]
                }
            }else{
                arrOfSelectedVisitStep.append(arrOfVisitStep[sender.tag])
            }
        }else if(viewfor == ViewFor.productcategory){
            arrOfSelectedProductCategory.removeAll()
            arrOfSelectedProductCategory.append(arrOfProductCategory[sender.tag])
        }else if(viewfor == ViewFor.customersegment){
            arrOfselectedCustomerSegment.removeAll()
            arrOfselectedCustomerSegment.append(arrOfCustomerSegment[sender.tag])
        }else if(viewfor == ViewFor.customerClass){
            arrOfSelectedClass.removeAll()
            if(searchActive == true && isSearchBarRequire == true){
                arrOfSelectedClass.append(arrOffilteredCustomerClass[sender.tag])
            }else{
                arrOfSelectedClass.append(arrOfCustomerClass[sender.tag])
            }
        }
        
        tblCustomerSelection.reloadData()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cell = tblCustomerSelection.cellForRow(at: indexPath) as? CustomerSelectionCell
        
        
        //      selectedIndexPath = indexPath
        if cell == nil {
            arrOfSelectedProduct.removeAll()
            if(isSearchBarRequire == true && searchActive == true){
                arrOfSelectedProduct.append(arrOfFilteredProduct[indexPath.row])
            }else{
                arrOfSelectedProduct.append(arrOfProduct[indexPath.row])
            }
            self.dismiss(animated: true) {
                self.nonmandatorydelegate?.completionProductData!(arr: self.arrOfSelectedProduct )
            }
            return
        }
        cell.btnCustomerSelection.isSelected = !cell.btnCustomerSelection.isSelected
        if(viewfor == ViewFor.customer || viewfor == ViewFor.firstInfluencer || viewfor == ViewFor.secondInfluencer){
            if(selectionmode == SelectionMode.multiple){
                if(searchActive){
                    if(arrOfSelectedMultipleCustomer.contains(filteredCustomer[indexPath.row])){
                        arrOfSelectedMultipleCustomer = arrOfSelectedMultipleCustomer.filter{
                            $0 != filteredCustomer[indexPath.row]
                        }
                        
                    }else{
                        tblCustomerSelection.reloadData()
                        
                        if(arrOfSelectedMultipleCustomer.count < 20){
                            arrOfSelectedMultipleCustomer.append(filteredCustomer[indexPath.row])
                        }else{
                            Utils.toastmsg(message:"You can not add more than 20 customers",view:self.view)
                            // self.view1.makeToast("You can not add more than 20 customers")
                        }
                    }
                }else{
                    if(arrOfSelectedMultipleCustomer.contains(arrOfList[indexPath.row])){
                        arrOfSelectedMultipleCustomer = arrOfSelectedMultipleCustomer.filter{
                            $0 != arrOfList[indexPath.row]
                        }
                        
                    }else{
                        tblCustomerSelection.reloadData()
                        
                        if(arrOfSelectedMultipleCustomer.count < 20){
                            arrOfSelectedMultipleCustomer.append(arrOfList[indexPath.row])
                        }else{
                            Utils.toastmsg(message:"You can not add more than 20 customers",view:self.view)
                            //  self.view1.makeToast("You can not add more than 20 customers")
                        }
                    }
                }
            }else
            {
                arrOfSelectedSingleCustomer.removeAll()
                if(searchActive){
                    arrOfSelectedSingleCustomer.append(filteredCustomer[indexPath.row])
                }else{
                    arrOfSelectedSingleCustomer.append(arrOfList[indexPath.row])
                }
                self.dismiss(animated: true) {
                    if(self.viewfor == ViewFor.customer){
                        self.nonmandatorydelegate?.completionData!(arr: self.arrOfSelectedSingleCustomer)
                    }else if(self.viewfor == ViewFor.firstInfluencer){
                        self.nonmandatorydelegate?.completionfirstInfluencer?(arr: self.arrOfSelectedSingleCustomer)
                    }else{
                        self.nonmandatorydelegate?.completionsecondInfluencer?(arr: self.arrOfSelectedSingleCustomer)
                    }
                }
            }
        }else if(viewfor == ViewFor.lead){
            arrOfSelectedLead.removeAll()
            if(searchActive == true && isSearchBarRequire == true){
                arrOfSelectedLead.append(arrOfFilteredLead[indexPath.row])
            }else{
                arrOfSelectedLead.append(arrOfLead[indexPath.row])
            }
            
            self.dismiss(animated: true) {
                self.nonmandatorydelegate?.completionSelectedLead?(arr: self.arrOfSelectedLead)
            }
        }
        else if(viewfor == ViewFor.territory){
            arrOfSelectedTerritory.removeAll()
            //            if(isSearchBarRequire == true && searchActive == true){
            //                arrOfSelectedTerritory.append(arrOfFilteredProduct[indexPath.row])
            //            }else{
            arrOfSelectedTerritory.append(arrOfTerritory[indexPath.row])
            self.nonmandatorydelegate?.completionSelectedTerritory?(arr: arrOfSelectedTerritory)
            // }
            self.dismiss(animated: true) {
                //  self.nonmandatorydelegate?.completionSelectedTerritory?(arr: self.arrOfSelectedTerritory)
            }
            
        }else if(viewfor == ViewFor.product){
            if(selectionmode == SelectionMode.multiple){
                
            }else{
                arrOfSelectedProduct.removeAll()
                if(isSearchBarRequire == true && searchActive == true){
                    arrOfSelectedProduct.append(arrOfFilteredProduct[indexPath.row])
                }else{
                    arrOfSelectedProduct.append(arrOfProduct[indexPath.row])
                }
                self.dismiss(animated: true) {
                    self.nonmandatorydelegate?.completionProductData!(arr: self.arrOfSelectedProduct )
                }
            }
            
        }else if(viewfor == ViewFor.leadoutcome){
            if(selectionmode == SelectionMode.multiple){
                if(arrOfSelectedLeadOutCome.contains(arrOfLeadOutCome[indexPath.row])){
                    arrOfSelectedLeadOutCome = arrOfSelectedLeadOutCome.filter{
                        $0 != arrOfLeadOutCome[indexPath.row]
                    }
                }else{
                    
                    if(arrOfSelectedLeadOutCome.count < 5){
                        arrOfSelectedLeadOutCome.append(arrOfLeadOutCome![indexPath.row])
                    }else{
                        Utils.toastmsg(message:"You can not add more than 5 Outcome",view:self.view)
                        // self.view1.makeToast("You can not add more than 5 Outcome")
                    }
                }
            }else{
                arrOfSelectedLeadOutCome.removeAll()
                arrOfSelectedLeadOutCome.append(arrOfLeadOutCome[indexPath.row])
                self.dismiss(animated: true) {
                    self.nonmandatorydelegate?.completionSelectedLeadOutCome!(arr: self.arrOfSelectedLeadOutCome)
                }
                
            }
        }else if(viewfor == ViewFor.companyuser || viewfor ==  ViewFor.viewForTageCustomer ){
            if(selectionmode ==  SelectionMode.single || selectionmode ==  SelectionMode.none ){
                
                arrOfSelectedExecutive?.removeAll()
                
                arrOfSelectedExecutive?.append((arrOfExecutive?[indexPath.row])!)
            }else{
                
            }
        }
        /*else if(viewfor == ViewFor.leadoutcome){
            if(arrOfSelectedLeadOutCome.contains(arrOfLeadOutCome[indexPath.row])){
                arrOfSelectedLeadOutCome = arrOfSelectedLeadOutCome.filter{
                    $0 != arrOfLeadOutCome[indexPath.row]
                }
                
                
            }else{
                
                if(arrOfSelectedLeadOutCome.count < 5){
                    arrOfSelectedLeadOutCome.append(arrOfLeadOutCome![indexPath.row])
                }else{
                    Utils.toastmsg(message:"You can not add more than 5 Outcome",view:self.view)
                    // self.view1.makeToast("You can not add more than 5 Outcome")
                }
            }
        }*/
        else if(viewfor == ViewFor.visitoutcome){
            if(selectionmode == SelectionMode.multiple){
                if(arrOfSelectedVisitOutcome.contains(arrOfVisitOutCome[indexPath.row])){
                    arrOfSelectedVisitOutcome = arrOfSelectedVisitOutcome.filter{
                        $0 != arrOfVisitOutCome[indexPath.row]
                    }
                    
                    
                }else{
                    
                    if(arrOfSelectedVisitOutcome.count < 5){
                        arrOfSelectedVisitOutcome.append(arrOfVisitOutCome![indexPath.row])
                    }else{
                        Utils.toastmsg(message:"You can not add more than 5 Outcome",view:self.view)
                        // self.view1.makeToast("You can not add more than 5 Outcome")
                    }
                }
            }else{
                
            }
        }else if(viewfor == ViewFor.vendor){
            
            if(selectionmode ==  SelectionMode.single || selectionmode ==  SelectionMode.none ){
                
                arrOfSelectedVendor?.removeAll()
                
                arrOfSelectedVendor?.append((arrOfVendor?[indexPath.row])!)
                self.dismiss(animated: true) {
                    if let popperentview = self.parentViewOfPopup as? UIView {
                        Utils.removeShadow(view: popperentview)
                    }
                    
                    self.nonmandatorydelegate?.completionSelectedVendor?(arr: self.arrOfSelectedVendor)
                    //                self.dismiss(animated: true) {
                    
                }
                //   }
            }else{
                
            }
        }else if(viewfor == ViewFor.document){
            if(selectionmode == SelectionMode.multiple){
                
                let selectedDocument =  arrOfDocument[indexPath.row]
                cell.lblCustomerName.text = selectedDocument.title
                cell.lblContactNo.isHidden = true
                var contain = false
                for doc in arrOfSelectedDocument{
                    if(doc.documentID == selectedDocument.documentID){
                        contain = true
                    }
                }
                if(contain){
                    arrOfSelectedDocument = arrOfSelectedDocument.filter{
                        $0.documentID != selectedDocument.documentID
                    }
                }else{
                    arrOfSelectedDocument.append(selectedDocument)
                }
                
                
                
            }else{
                
                
            }
            
        }
        
        else if(viewfor == ViewFor.productcategory){
            if(selectionmode == SelectionMode.multiple){
                
            }else{
                arrOfSelectedProductCategory.removeAll()
                arrOfSelectedProductCategory.append(arrOfProductCategory[indexPath.row])
                self.dismiss(animated: true) {
                    self.nonmandatorydelegate?.completionProductCategory!(arr: self.arrOfSelectedProductCategory)
                }
            }
        }
        else if(viewfor == ViewFor.productsubcategory){
            if(selectionmode == SelectionMode.multiple){
                
            }else{
                arrOfSelectedSubProductCategory.removeAll()
                arrOfSelectedSubProductCategory.append(arrOfProductSubCategory[indexPath.row])
                self.dismiss(animated: true) {
                    self.nonmandatorydelegate?.completionProductSubCategory!(arr: self.arrOfSelectedSubProductCategory)
                }
            }
        }else if(viewfor == ViewFor.customersegment){
            if(selectionmode == SelectionMode.multiple){
                
            }else{
                arrOfselectedCustomerSegment.removeAll()
                arrOfselectedCustomerSegment.append(arrOfCustomerSegment[indexPath.row])
                if(selectionmode == SelectionMode.none){
                    self.dismiss(animated: true) {
                        self.nonmandatorydelegate?.completionSelectedSegment?(arr: self.arrOfselectedCustomerSegment)
                    }
                }else if(selectionmode == SelectionMode.single){
                    self.nonmandatorydelegate?.completionSelectedSegment?(arr: self.arrOfselectedCustomerSegment)
                    if(self.strLeftTitle.count == 0 && self.strRightTitle.count == 0){
                        self.dismiss(animated: true) {
                            self.nonmandatorydelegate?.completionSelectedSegment?(arr: self.arrOfselectedCustomerSegment)
                        }
                    }
                }
            }
        }else if(viewfor == ViewFor.customerClass){
            if(selectionmode == SelectionMode.multiple){
                
            }else{
                arrOfSelectedClass.removeAll()
                if(searchActive == true && isSearchBarRequire == true){
                    arrOfSelectedClass.append(arrOffilteredCustomerClass[indexPath.row])
                }else{
                    arrOfSelectedClass.append(arrOfCustomerClass[indexPath.row])
                }
                selectedRecordNo = indexPath.row
                if(selectionmode == SelectionMode.none){
                    self.nonmandatorydelegate?.completionSelectedClass?(arr: self.arrOfSelectedClass, recordno: self.selectedRecordNo, strTitle: self.strTitle)
                    self.dismiss(animated: true) {
                        
                        self.nonmandatorydelegate?.completionSelectedClass?(arr: self.arrOfSelectedClass, recordno: self.selectedRecordNo, strTitle: self.strTitle)
                    }
                }else if(selectionmode == SelectionMode.single){
                    self.nonmandatorydelegate?.completionSelectedClass?(arr: self.arrOfSelectedClass, recordno: self.selectedRecordNo, strTitle: self.strTitle)
                    self.dismiss(animated: true) {
                        
                        self.nonmandatorydelegate?.completionSelectedClass?(arr: self.arrOfSelectedClass, recordno: self.selectedRecordNo, strTitle: self.strTitle)
                    }
                }
            }
        }else if(viewfor == ViewFor.productcategory){
            if(selectionmode == SelectionMode.multiple){
                
            }else{
                arrOfSelectedProductCategory.removeAll()
                arrOfSelectedProductCategory.append(arrOfProductCategory[indexPath.row])
            }
        }else if(viewfor == ViewFor.customerClass){
            if(selectionmode == SelectionMode.multiple){
                
            }else{
                arrOfSelectedClass.removeAll()
                if(searchActive == true && isSearchBarRequire == true){
                    arrOfSelectedClass.append(arrOffilteredCustomerClass[indexPath.row])
                }else{
                    arrOfSelectedClass.append(arrOfCustomerClass[indexPath.row])
                }
            }
        }else if(viewfor == ViewFor.beatplan){
            arrOfSelectedBeatPlan.removeAll()
            arrOfSelectedBeatPlan.append(arrOfBeatPlan[indexPath.row])
            self.mandatorydelegate?.completionSelectedBeatPlan(arr: self.arrOfSelectedBeatPlan)
            self.dismiss(animated: true) {
                self.mandatorydelegate?.completionSelectedBeatPlan(arr: self.arrOfSelectedBeatPlan)
            }
        }
        
        tblCustomerSelection.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
extension CustomerSelection:ProductSelectionPopUpDelegate{
    func completionSelectedClass(arr: [String],recordNo:Int)  {
        if let popperentview = self.parentViewOfPopup as? UIView {
            Utils.removeShadow(view: popperentview)
        }
        self.isFilterActive = true
        arrOfSelectedClass = arr
        let predicate = NSPredicate.init(format: "customerClass = %d ",recordNo + 1 as! CVarArg)
        
        
        self.arrOfList = CustomerDetails.getCustomersUsingPredicate(predicate: predicate)
        
        //        self.arrOfList = self.arrayFullList.filter({ (cust) -> Bool in
        //            cust.customerClass ==
        //        })
        
        self.tblCustomerSelection.reloadData()
        
    }
    func completionSelectedSegment(arr: [CustomerSegment]) {
        ///segmentID = '%d'
        if let popperentview = self.parentViewOfPopup as? UIView {
            Utils.removeShadow(view: popperentview)
        }
        arrOfselectedCustomerSegment =  arr
        self.isFilterActive = true
        if let customersegment  = arr.first{
            let predicate = NSPredicate.init(format: "segmentID =  '%d'",customersegment.iD)
            //        //NSPredicate.init(format: "segmentID = '%d'",customersegment.iD as! CVarArg)
            //       // let addressList = AddressList().getAddressUsingPredicate(predicate: predicate)
            //            print(predicate)
            
            self.arrOfList = CustomerDetails.getCustomersUsingPredicate(predicate: predicate)
            
            //            for cust in  arrOfList{
            //                if(cust.iD == customersegment.iD){
            //
            //                }
            //            }
            self.arrOfList = self.arrayFullList.filter({ (cust) -> Bool in
                cust.segmentID == customersegment.iD
            })
            
            
        }
        self.tblCustomerSelection.reloadData()
    }
    
    func completionSelectedTerritory(arr: [[String:Any]]) {
        if let popperentview = self.parentViewOfPopup as? UIView {
            Utils.removeShadow(view: popperentview)
        }
        let selectedterritory = arr.first
        arrOfSelectedTerritory = arr
        if let tname = selectedterritory?["territoryName"] as? String{
            if(tname == "All"){
                isFilterActive = false
                self.arrOfList = self.arrayFullList
                
                self.tblCustomerSelection.reloadData()
            }else{
                let predicate = NSPredicate.init(format: "territoryID = '%d'",arr.first?["ID"] as! CVarArg)
                //
                self.arrOfList = CustomerDetails.getCustomersUsingPredicate(predicate: predicate)
                let territoryId = arr.first?["territoryId"]
                
                self.tblCustomerSelection.reloadData()
            }
        }
    }
    
}
extension CustomerSelection:ProductSelectionPopUpMandatoryDelegate{
    func completionSelectedBeatPlan(arr: [BeatPlan],recordnoForBeatplan:Int) {
        
        if let popperentview = self.parentViewOfPopup as? UIView {
            Utils.removeShadow(view: popperentview)
        }
        arrOfSelectedBeatPlan  = arr
        let selectedBeatPlan = arrOfSelectedBeatPlan.first as? BeatPlan
        let beatplanId = selectedBeatPlan?.BeatPlanID//selectedBeatPlan["BeatPlanID"] as? NSNumber
        var param = Common.returndefaultparameter()
        var bpdDic = [String:Any]()
        bpdDic["CompanyID"] = self.activeuser?.company?.iD
        if(recordnoForBeatplan == 0){
            bpdDic["BeatPlanID"] = NSNumber.init(value: 0)
            bpdDic["UserID"] = self.activeuser?.userID
            param["allBeatPlan"] = NSNumber.init(value: 1)
            param["UserID"] = self.activeuser?.userID
        }else{
            // let intbeatplanId = Int(selectedBeatPlan["BeatPlanID"]) as? Int ?? 0
            bpdDic["BeatPlanID"] = beatplanId
            bpdDic["UserID"] = self.activeuser?.userID
        }
        param["getBeatPlanDetailsJson"] = Common.returnjsonstring(dic: bpdDic)
        // let beatplandic = ["CompanyID":self.activeuser?.company?.iD,"UserID":self.activeuser?.userID]
        
        //   param["getBeatPlanDetailsJson"] = Common.json(from: beatplandic)
        ApiHelper().getdeletejoinvisit(param:param , strurl: ConstantURL.kWSUrlForIndividiualBeatDetail, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                if(responseType == ResponseType.arr){
                    //self.arrOfTableBeatPlan = [BeatPlanAssign]()
                    let  arrofbeat = arr as? [[String:Any]] ?? [[String:Any]]()
                    self.arrOfBeatPlan = [BeatPlan]()
                    let arrOfCustomer  = arrofbeat.compactMap {
                        $0["customer"]
                    }//["customer"] as? [[String:Any]] ?? [[String:Any]]()
                    self.arrOfList = [CustomerDetails]()
                    for dic in arrOfCustomer{
                        let custdic = dic as? [String:Any]
                        let custid = custdic?["ID"] as? Int ?? 0
                        if let cust = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: custid)) as? CustomerDetails{
                            self.arrOfList.append(cust)
                            
                        }
                    }
                    self.isFilterActive = true
                    self.tblCustomerSelection.reloadData()
                }
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view:self.view)
                    // self.view1.makeToast(message)
                }
            }else{
                Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view:self.view)
                //  self.view1.makeToast(error.userInfo["localiseddescription"]  as? String ?? "")
            }
        }
    }
}

