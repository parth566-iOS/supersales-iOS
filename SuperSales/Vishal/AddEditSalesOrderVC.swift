//
//  AddEditSalesOrderVC.swift
//  SuperSales
//
//  Created by Apple on 03/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import ACFloatingTextfield_Swift
import UIFloatLabelTextView
import Alamofire
import SVProgressHUD
import FastEasyMapping


protocol AddEditSODelegate {
    func successfullySaveOrUpdateSO()
}

class AddEditSalesOrderVC: BaseViewController {
    //MARK: IBOutlets
    @IBOutlet weak var viewDirectSalesOrder: UIView!
    @IBOutlet weak var viewSelectCustomer: UIView!
    @IBOutlet weak var btnAddnewCustomer: UIButton!
    @IBOutlet weak var vwLeadProposalSel: UIView!
    @IBOutlet weak var btnAddProducts: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!

    @IBOutlet weak var txtCustomerSel: KTextField!
    @IBOutlet weak var txtPropLdSel: KTextField!
    @IBOutlet weak var txtWarranty: ACFloatingTextfield!
    @IBOutlet weak var txtDeliveryDays: ACFloatingTextfield!
    @IBOutlet weak var vwDelDaysWarrenty: UIView!
    @IBOutlet weak var txtDesc: ACFloatingTextfield!
    @IBOutlet weak var txtTNC: KTextView!

    @IBOutlet weak var txtDealerCode: ACFloatingTextfield!
    @IBOutlet weak var txtDealerCity: ACFloatingTextfield!

    // Order Fullfilled By
    @IBOutlet weak var lblFullfiledBy: UILabel!
    @IBOutlet weak var vwFullfiledBy: UIView!

    // Total Amt Fields & Contraints
    @IBOutlet weak var lblTtlProAmt: UILabel!
    @IBOutlet weak var lblTtlDisAmt: UILabel!
    @IBOutlet weak var lblTtlGrossAmt: UILabel!
    @IBOutlet weak var lblTtlPromotionAmt: UILabel!
    @IBOutlet weak var lblTtlTaxAmt: UILabel!
    @IBOutlet weak var lblTtlNetAmt: UILabel!
    
    @IBOutlet weak var vwTtlProAmt: UIView!
    @IBOutlet weak var vwTtlDisAmt: UIView!
    @IBOutlet weak var vwTtlGrossAmt: UIView!
    @IBOutlet weak var vwTtlPromotionAmt: UIView!
    @IBOutlet weak var vwTtlTaxAmt: UIView!
    @IBOutlet weak var vwTtlNetAmt: UIView!

    @IBOutlet weak var btnIsDirectProposal: UIButton!
    
    @IBOutlet var btnLeadProposal: [UIButton]!
    @IBOutlet weak var btnCompanyStock: UIButton!
    @IBOutlet weak var tableView: ContentSizedTableView!
    
    // Promotion
    @IBOutlet weak var vwPromotion: UIView!
    @IBOutlet weak var vwPromotion1: UIView!
    @IBOutlet weak var btnPromotion: UIButton!
    @IBOutlet weak var lblPromosionName: UILabel!
    
    // Setting for user
    let setting = Utils().getActiveSetting()
    let account = Utils().getActiveAccount()
    var customer: CustomerDetails? = nil
    var selectedPromotion: Promotion? = nil
    var promotionList = [Promotion]()
    var objVisit: PlannVisit? = nil // Sales Order from visit
    
    var lead: Lead? = nil //For lead proposal
    var proposal: Proposl? = nil //For lead proposal
    var order: SOrder? = nil
    
    var isProduct = false
    var isService = false
    var fulfilledByID: Int64 = 0
    var strTransaction: String?
    var assignTo: NSNumber? = 0
    var delegate: AddEditSODelegate?
    
    //product ID of product drive
    static var productDriveIDSInNumber:[NSNumber] = [NSNumber]()
    lazy var customerDropDown : DropDown = {
        let dropDown = DropDown()
        dropDown.direction = .bottom
        dropDown.bottomOffset = .init(x: 0, y: 38)
        return dropDown
    }()
    
    lazy var numberFormatter: NumberFormatter =  {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "en_US")
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    lazy var lstProposal : [Proposl] = {
        let lst = Proposl.getAll()
        var tempLst = [Proposl]()
        for prpsl in lst {
            let objCust = CustomerDetails.getCustomerByID(cid: NSNumber(value: prpsl.customerID))
            print(objCust)
            if (objCust?.statusID == 2 && objCust?.isActive == 1) {
                tempLst.append(prpsl)
            }
        }
        return tempLst
    }()

    lazy var lstLeads : [Lead] = {
        return Lead.getAllBy(withAttributeName: "seriesPostfix", withAsc: false)
    }()

    var popup:CustomerSelection? = nil

    lazy var arrOfCustomers:[CustomerDetails] = {
        return CustomerDetails.getAllCustomers()
    }()
    
    lazy var menus: [CompanyMenus] = {
        var menu = [NSNumber]()
        if (order?.statusID == 1 || order?.editStatusID == 1) {
        }else{
            menu.append(61)
            menu.append(62)
            menu.append(63)
        }
        menu.append(64)
        return CompanyMenus.getComapnyMenus(menu: menu, sort: true)
    }()

    var aryProductList = [SelectedProduct]() // to display products
    {
        didSet {
            vwTtlProAmt.isHidden = setting.requireDiscountAndTaxAmountInSO == 0 ? true : (aryProductList.count > 0 ? false : true)
            vwTtlDisAmt.isHidden = setting.requireDiscountAndTaxAmountInSO == 0 ? true : (aryProductList.count > 0 ? false : true)
            vwTtlGrossAmt.isHidden = setting.requireDiscountAndTaxAmountInSO == 0 ? true : (aryProductList.count > 0 ? false : true)
            vwTtlPromotionAmt.isHidden = setting.requirePromotionInSO == 0 ? true : (aryProductList.count > 0 ? false : true)
            vwTtlTaxAmt.isHidden = setting.requireDiscountAndTaxAmountInSO == 0 ? true : (aryProductList.count > 0 ? false : true)
            vwTtlNetAmt.isHidden = setting.requireDiscountAndTaxAmountInSO == 0 ? true :  false
            self.arrangeColor(views: [vwTtlProAmt,vwTtlDisAmt,vwTtlGrossAmt,vwTtlPromotionAmt,vwTtlTaxAmt,vwTtlNetAmt])
            tableView.reloadData()
        }
    }
    var productStockList = [[String: Any]]()
    var productDriveIDs = [Int64]()
    var aryStockProducts = [[String: Any]]()

    var ttlPro: Double = 0.0
    var ttlDis: Double = 0.0
    var ttlGross: Double = 0.0
    var ttlNet: Double = 0.0
    var ttlTax: Double = 0.0
    var ttlPromotion: Double = 0.0
    var flatPromotionPercentage: Float = 0.0
    var totalPromotionAmount: Double = 0.0
    var isPromotionApplied = false
    var isEdit = false

    //MARK: View Control Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setleftbtn(btnType: .back, navigationItem: self.navigationItem)
        self.title = "Add Sales Order"
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 600.0; // set to whatever your "average" cell height is

        if (setting.salesOrderFulfillmentFrom == 1) {
            vwFullfiledBy.isHidden = true
        }else{
            if (setting.salesOrderFulfillmentFrom == 2) {
                lblFullfiledBy.text = "Select Distributor";
            }else if (setting.salesOrderFulfillmentFrom == 3){
                lblFullfiledBy.text = "Select Retailer";
            }else if (setting.salesOrderFulfillmentFrom == 4){
                lblFullfiledBy.text = "Select Distributor OR Retailer";
            }
        }
        if order != nil {
            isEdit = true
            self.configureOrderInCaseEdit()
        }else {
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "icon_search_black"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(txtCustomerSel.frame.size.width - 25), y: CGFloat(0), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.btnSearchCustomerClicked(_:)), for: .touchUpInside)
            txtCustomerSel.rightView = button
            txtCustomerSel.rightViewMode = .always
            self.arrangeColor(views: [vwTtlProAmt,vwTtlDisAmt,vwTtlGrossAmt,vwTtlPromotionAmt,vwTtlTaxAmt,vwTtlNetAmt])
        }
        
        if let selectedLead = lead {
            viewDirectSalesOrder.isHidden = true
            viewSelectCustomer.isHidden = false
            vwLeadProposalSel.isHidden = false
            self.btnLeadProposalSel(btnLeadProposal[1])
            for x in btnLeadProposal {x.isUserInteractionEnabled = false}
            if let selectedCust = CustomerDetails.getCustomerByID(cid: NSNumber(value: selectedLead.customerID)) {
                customer = selectedCust
                self.txtCustomerSel.text = selectedCust.name
                if(AddEditSalesOrderVC.productDriveIDSInNumber.count == 0){
                    self.getProductDriveList()
                }
                self.txtCustomerSel.rightView = nil
                self.txtCustomerSel.isUserInteractionEnabled = false
                btnAddnewCustomer.isHidden = true
            }
            self.salesOrderFromLead(tempLead: selectedLead)
        }
        
        if let selectedVisit = objVisit {
//            viewDirectSalesOrder.isHidden = true
            viewSelectCustomer.isHidden = false
            vwLeadProposalSel.isHidden = true
            if let selectedCust = CustomerDetails.getCustomerByID(cid: NSNumber(value: selectedVisit.customerID)) {
                customer = selectedCust
                self.txtCustomerSel.text = selectedCust.name
                if(AddEditSalesOrderVC.productDriveIDSInNumber.count == 0){
                    self.getProductDriveList()
                }
                self.txtCustomerSel.rightView = nil
                self.txtCustomerSel.isUserInteractionEnabled = false
                btnAddnewCustomer.isHidden = true
            }
        }
        
        self.displayUIUsingSetting()
        
        // Do any additional setup after loading the view.
        
        //get product id
//        if(activesetting.showProductDrive ==  NSNumber.init(value: 1)){
//            if(AddEditSalesOrderVC.productDriveIDSInNumber.count == 0){
//            self.getProductDriveList()
//            }
//        }
    }
    
    func arrangeColor(views: [UIView]) {
        if order?.statusID == 7 {
            vwTtlProAmt.isHidden = true
            vwTtlDisAmt.isHidden = true
            vwTtlTaxAmt.isHidden = true
            vwTtlPromotionAmt.isHidden = true
            
            return
        }
        if setting.requireDiscountAndTaxAmountInSO == 1 {
            var colors = [#colorLiteral(red: 0.8823529412, green: 0.937254902, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0.937254902, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0.937254902, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0.937254902, blue: 0.9882352941, alpha: 1)]
            if aryProductList.count > 0 {
                colors.removeFirst()
            }
            var i = 0
            for x in views {
                if !x.isHidden {
                    x.backgroundColor = colors[i]
                    i += 1
                }
            }
        }
    }
    
    fileprivate func showNavBar1() {
        if (menus.count > 0) {
            let spacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacing.width = -15;
            
            let btnMenus = UIBarButtonItem.init(image: UIImage.init(named: "icon_menu_edit"), style: .plain, target: self, action: #selector(btnEditClicked(_:)))
            self.navigationItem.rightBarButtonItems = [spacing, btnMenus];
        }
    }
    
    @objc func btnEditClicked(_ sender: UIBarButtonItem) {
        popoverConfiguration.isTitleNeeded = false
        FTPopOverMenu.showForSender(sender: sender.plainView, with: menus.map {$0.menuLocalText}, popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration) { [self] (index) in
            let menuID = menus[index].menuID
            switch menuID{
            case 61:
                self.perform(#selector(getUsers), with:self, afterDelay:0.5)
                break
            case 63:
                self.closeSO()
                break
            case 64:
                if (setting.customTagging == 3){
                    if !(Utils.isCustomerMapped(cid: NSNumber(value: order?.customerID ?? 0))){
                        AppDelegate.shared.window?.makeToast("Customer is not mapped, so you can't view customer history")
                    }else{
                        if let customerhistory  = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistory) as? CustomerHistoryContainer{
                            customerhistory.isEdit = false
                            customerhistory.customerName = order?.customerName
                            customerhistory.customerID =  NSNumber(value:order?.customerID ?? 0)
                            self.navigationController?.pushViewController(customerhistory, animated: true)
                        }
                    }
                }else{
                    if let customerhistory  = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistory) as? CustomerHistoryContainer{
                        customerhistory.isEdit = false
                        customerhistory.customerName = order?.customerName
                        customerhistory.customerID =  NSNumber(value:order?.customerID ?? 0)
                        self.navigationController?.pushViewController(customerhistory, animated: true)
                    }                }
                break
            default:
                print("default case")
            }
        } cancel: {
            
        }
    }

    @objc fileprivate func getUsers() {
        self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        self.popup?.isFromSalesOrder =  false
        self.popup?.nonmandatorydelegate = self
        self.popup?.modalPresentationStyle = .overCurrentContext
        self.popup?.isFilterRequire = false
        self.popup?.strTitle = "Select User"
        self.popup?.selectionmode = .single
        self.popup?.strLeftTitle = "Ok"
        self.popup?.strRightTitle = "Cancel"
        self.popup?.viewfor = ViewFor.companyuser
        self.popup?.isSearchBarRequire = false
        popup?.parentViewOfPopup = self.view
        if(setting.customTagging == NSNumber(value: 3)){
            if (Utils.isCustomerMapped(cid: NSNumber(value: order?.customerID ?? 0))) {
                var arrOfLowerLevelUser = [CompanyUsers]()
                print(self.lowerUser ?? [CompanyUsers]())
                if(self.lowerUser.count == 0){
                    if let active = CompanyUsers().getUser(userId: self.activeuser?.userID ?? 0){
                        self.lowerUser.append(active)
                    }
                    
                }
                var taggedToIDListOfUserID  = [Int]()
                if let selectedCustomer = customer{
                    taggedToIDListOfUserID = selectedCustomer.taggedToIDList.map({
                        ($0 as! TaggedToIDList).taggedUserID
                    })
                }
                for user in self.lowerUser{
                    if(user.entity_id == self.activeuser?.userID){
                        arrOfLowerLevelUser.append(user)
                    }else if(taggedToIDListOfUserID.contains(user.entity_id.intValue) && user.role_id != 9){
                        arrOfLowerLevelUser.append(user)
                    }
                }
                for x in self.lowerUser {
                    if (x.entity_id == account?.userID) {
                        self.popup?.arrOfSelectedExecutive = [x]
                        break
                    }
                    if (x.entity_id == assignTo) {
                        self.popup?.arrOfSelectedExecutive = [x]
                        break
                    }
                }
                self.popup?.arrOfExecutive = arrOfLowerLevelUser
            }else{
                self.view.makeToast("Customer is not mapped, so you can't change assignee")
            }
        }else{
            let users = CompanyUsers.getFilteredUserUpper(roleId: 8)
            for x in users {
                if (x.entity_id == account?.userID) {
                    self.popup?.arrOfSelectedExecutive = [x]
                    break
                }
                if (x.entity_id == assignTo) {
                    self.popup?.arrOfSelectedExecutive = [x]
                    break
                }
            }
            self.popup?.arrOfExecutive = users
        }
        
        Utils.addShadow(view: self.view)
        self.present(self.popup!, animated: false, completion: nil)
    }
    
    fileprivate func closeSO() {
        if (order?.statusID == 1){
            self.view.makeToast("You can't close pending sales order")
            return;
        }
        let message = "Are you sure you want to close this Sales Order?"
        let alertController = UIAlertController(title: "Supersales", message: message, preferredStyle: .alert)
        let no_action = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yes_action = UIAlertAction(title: "Yes", style: .destructive) { [self] action in
            var jsonParameters = [String: Any]()
            jsonParameters["ID"] = order?.iD
            jsonParameters["CreatedBy"] = account?.userID
            jsonParameters["StatusID"] = 7
            jsonParameters["SeriesPrefix"] = order?.seriesPrefix
            jsonParameters["SeriesPostfix"] = order?.seriesPostfix
            jsonParameters["CompanyID"] = account?.company?.iD
                
            var maindict = [String: Any]()
            maindict["close_salesorder"] = jsonParameters.rs_jsonString(withPrettyPrint:true)
            maindict["UserID"] = account?.userID
            maindict["TokenID"] = account?.securityToken
            
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            RestAPIManager.httpRequest(ConstantURL.closesalesorder, .post, parameters: maindict, isTeamWorkUrl: true, isFull: true) { [self] response, sucess, error in
                SVProgressHUD.dismiss()
                if (sucess) {
                    let d = response as? [String: Any]
                    if d?["status"] as? String == "Success" {
                        if let o = order {
                            let context = SOrder.getContext()
                            context.delete(o)
                            context.mr_saveToPersistentStore { contextDidSave, error in
                                self.delegate?.successfullySaveOrUpdateSO()
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else if(d?["status"] as? String == "Invalid Token") {
                        self.view.makeToast(d?["message"] as? String ?? "")
                    }else{
                        self.view.makeToast(d?["message"] as? String ?? "")
                    }
                }else{
                    self.view.makeToast(error?.localizedDescription)
                }
            }

        }
        alertController.addAction(no_action)
        alertController.addAction(yes_action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configureOrderInCaseEdit() {
        customer = CustomerDetails.getCustomerByID(cid: NSNumber(value: order?.customerID ?? 0))
        assignTo = NSNumber(value: order?.assignedTo ?? 0)
        viewDirectSalesOrder.isHidden = true
        txtCustomerSel.isUserInteractionEnabled = false
        
        btnAddnewCustomer.isHidden = true
        
        if (order?.statusID == 7) {
            self.title = String(format: "SO No: %@%lld", order?.seriesPrefix ?? "", order?.seriesPostfix ?? 0);
            btnAddProducts.isHidden = true
            txtDesc.isUserInteractionEnabled = false
            txtDeliveryDays.isUserInteractionEnabled = false
            txtTNC.isUserInteractionEnabled = false
            vwPromotion.isUserInteractionEnabled = false
            vwPromotion1.isUserInteractionEnabled = false
        }else{
            self.title = NSLocalizedString("edit_sales_order", comment: "");
        }
        if (account?.roleId == 8 || order?.statusID == 7) {
        }else{
            self.showNavBar1()
        }
        
        if let full = CustomerDetails.getCustomerByID(cid: NSNumber(value: order?.fulfilledByID ?? 0)) {
            fulfilledByID = order?.fulfilledByID ?? 0
            lblFullfiledBy.text = full.name;
        }
        
        if (order?.leadID == 0 && order?.proposalID == 0) {
            if (Utils.isCustomerMapped(cid: NSNumber(value: order?.customerID ?? 0))) {
                txtCustomerSel.text = String(format: "%@",customer?.name ?? "")
            }else{
                txtCustomerSel.text = "Customer Not Mapped"
            }
        }else if (order?.leadID ?? 0 > 0) {
            if (Utils.isCustomerMapped(cid: NSNumber(value: order?.customerID ?? 0))) {
                txtCustomerSel.text = String(format: "Lead ID: %lld, %@", order?.leadSeriesPostfix ?? 0, customer?.name ?? "");
            }else{
                txtCustomerSel.text = String(format: "Lead ID: %lld, %@", order?.leadSeriesPostfix ?? 0, "Customer Not Mapped");
            }
        }else{
            if (Utils.isCustomerMapped(cid: NSNumber(value: order?.customerID ?? 0))) {                txtCustomerSel.text = String(format: "Proposal ID: %@%lld, %@",order?.proposalSeriesPrefix ?? 0, order?.proposalSeriesPostfix ?? 0, customer?.name ?? "");
            }else{
                txtCustomerSel.text = String(format: "Proposal ID: %@%lld, %@",order?.proposalSeriesPrefix ?? 0, order?.proposalSeriesPostfix ?? 0, "Customer Not Mapped")
            }
        }
        
        if let statusId = order?.statusID, let editStatusId = order?.editStatusID {
            if(statusId == 2 && editStatusId != 1){
                print("submit")
            }else if(statusId == 2 && editStatusId == 1 && (order?.assignedBy != account?.userID?.int64Value)){
                print("Edit accept")
                print("Edit reject")
                btnSubmit.isHidden = true
                btnAccept.isHidden = false
                btnReject.isHidden = false
                ///API NAme: approveRejectSalesOrder
            }else if(order?.assignedBy != account?.userID?.int64Value && statusId != 7){
                print("Add accept")
                print("Add reject")
                btnSubmit.isHidden = true
                btnAccept.isHidden = false
                btnReject.isHidden = false
                //API approveRejectEditSalesOrder
            }else{
                btnSubmit.isHidden = true
                btnAccept.isHidden = true
                btnReject.isHidden = true
                print("Hide all buttons")
            }
        }
        
        if (order?.promotionID ?? 0 > 0) {
            selectedPromotion = Promotion([:])
            selectedPromotion?.ID = Int(order?.promotionID ?? 0)
            selectedPromotion?.promotionType = order?.flatPromotionPercentage ?? 0.0 > 0 ? 1 : 2;
            selectedPromotion?.promotionTitle = order?.promotionName;
        }else {
            vwPromotion1.isHidden = true
        }
        var freeBonus = [FreeBonusProduct]()
        for d1 in order?.soProductList ?? []{
            let d = d1 as! SOrderProducts
            let p = Product.getProduct(productID: NSNumber(value: d.productID ))
            if (order?.promotionID ?? 0 > 0) {
                if (d.isPromotional > 0 && d.price == 0) {
                    let product = FreeBonusProduct([:])
                    product.productName = p?.productName ?? "";
                    product.freeProductQty = Int(d.quantity)
                    product.productID = Int(d.productID);
                    freeBonus.append(product)
                    continue;
                }
            }
            if (d.categoryType == 1){
                isProduct = true;
            }else{
                isService = true;
            }
                //Asian Paint
            if (account?.company?.iD == 1130) {
                if (d.productID == 21594) {
                        //Set Warranty ID to 7011111
                    txtWarranty.isEnabled = false;
                }
            }
            let sproduct = SelectedProduct()

            if (d.discountType>0) {
                sproduct.disType = Int8(d.discountType)
                if (d.discountB > 0 || d.discountA > 0) {
                    if(d.discountA>0){
                        sproduct.isAllow = true;
                        sproduct.isFirstStep = false;
                    }else{
                        sproduct.isAllow = true;
                        sproduct.isFirstStep = true;
                    }
                }else{
                    sproduct.isAllow = true;
                    sproduct.isFirstStep = true;
                }
            }else{
                sproduct.disType = 1;
            }

            if (d.customerClass>0) {
                sproduct.customerClass = Int(d.customerClass)
            }else{
                sproduct.customerClass = 1;
            }

            var taxTp = ""
            if (customer?.taxType == "VAT") {
                if (d.sGSTTax != 0) {
                    taxTp = "VAT";
                }else{
                    taxTp = "";
                }
            }else if(customer?.taxType == "CST"){
                if (d.iGSTTax != 0) {
                    taxTp = "CST";
                }else{
                    taxTp = "";
                }
            }else{
                taxTp = "";
            }

            if(d.vATPercentage > 0 || order?.totalTaxAmount == 0){
                sproduct.isVat = true;
            }else{
//                if (order?.totalGrossAmount == order?.finalSalesAmount) {
                    if (setting.vatGst==2) {
                        sproduct.isVat = true
                    }else{
                        sproduct.isVat = false;
                    }
//                }else{
//                    sproduct.isVat = false
//                }
            }
            sproduct.productName = p?.productName
            sproduct.productID = NSNumber(value: d.productID)
            sproduct.quantity = "\(d.quantity)"
            sproduct.price = "\(d.price)"
            sproduct.netAmt = d.productAmount
            sproduct.salesDiscount = "\(d.discount)"
            sproduct.maxdiscount = "\(d.maxdiscount)"
            sproduct.taxType = taxTp
            sproduct.SGSTTax = d.sGSTTax
            sproduct.CGSTTax = d.cGSTTax
            sproduct.IGSTTax = d.iGSTTax
            sproduct.disA = d.discountA
            sproduct.disB = d.discountB
            sproduct.disC = d.discountC
            sproduct.isInclusive = d.inclusiveExclusive
            sproduct.vATPercentage = d.vATPercentage
            sproduct.vATFrom = d.vATFrom
            sproduct.focQuantity = d.focQuantity
            sproduct.isFOC = d.focQuantity > 0 ? true : false
            sproduct.disInPerVal = 1
            aryProductList.append(sproduct)
        }
        if (freeBonus.count > 0) {
            selectedPromotion?.freeBonusProductList = freeBonus;
        }

        txtDealerCode.text = order?.dealerCode ?? "";
        txtWarranty.text = order?.warranty ?? ""
        txtDealerCity.text = order?.dealerCity ?? "";
        
        txtTNC.text = order?.tnc ?? ""
        
        txtDeliveryDays.text = order?.deliveryDays ?? 0 > 0 ? "\(order?.deliveryDays ?? 0)" : ""
        txtDesc.text = order?.desc ?? ""
        
        tableView.reloadData()

        if (setting.requirePromotionInSO == 1 && order?.isPromotionApplied == 1) {
            if (order?.isPromotionApplied == 1) {
                btnPromotion.isSelected = true;
                vwPromotion.isHidden = false;
                vwPromotion1.isHidden = false;
                lblPromosionName.text = String(format:"   %@ - promotion is applied", order?.promotionName ?? "");
                if (selectedPromotion?.promotionType == 1) {
                    print("Flat Promotion Applied");
                    totalPromotionAmount = order?.totalPromotionAmount ?? 0;
                }else{
                    print("Bonus Promotion Applied");
                    //Calculate VAT or GST
                    for c in selectedPromotion?.freeBonusProductList ?? [] {
                        let p = Product.getProduct(productID: NSNumber(value: c.productID))
                        if (p != nil) {
                            totalPromotionAmount += p?.price ?? 0;
                        }
                    }
                }
            }
            vwPromotion.isHidden = false
            vwPromotion1.isHidden = false
        }
        flatPromotionPercentage = order?.flatPromotionPercentage ?? 0.0;
        totalPromotionAmount = order?.totalPromotionAmount ?? 0;
        tableView.reloadData()
    }
    
    func displayUIUsingSetting() {

        txtTNC.text = "\(setting.salesOrderTerms ?? "")\n\(setting.salesOrderConditions ?? "")";

        if (setting.requireAddNewCustomerInVisitLeadOrder == 0) {
            btnAddnewCustomer.isHidden = true
        }

        if (setting.directSalesOrder == 0) {
            viewDirectSalesOrder.isHidden = true
        }

        if (setting.requireDeliveryDaysAndTnCInSO == 0) {
            txtDeliveryDays.isHidden = true
            txtTNC.isHidden = true
        }

        if (setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
            txtWarranty.keyboardType = UIKeyboardType.numberPad
        }

        if (setting.sORequireWarrantyAndDealerCode == 0) {
            vwDelDaysWarrenty.isHidden = true
        }

        if (setting.viewCompanyStock == 1) {
            btnCompanyStock.isHidden = false
            self.loadCompanyStock()
        }else{
            btnCompanyStock.isHidden = true
            if (setting.salesOrderProductPermission == 1) {
                if (setting.showProductDrive == 1) {
                    self.getProductDrive()
                }else{
                    if (setting.showSuggestOrderQty == 1) {
                        self.suggestOrderQtyMultiple()
                    }
                }
            }
        }
        if (setting.requirePromotionInSO == 1) {
            vwPromotion.isHidden = false
        }
    }
    
    func loadCompanyStock() {
        if Utils.isReachable() {
            var jsonParam = [String: Any]()
            jsonParam["Filter"] = 0
            jsonParam["FilterData"] = 0
            jsonParam["CompanyID"] = account?.company?.iD
            jsonParam["UserID"] = account?.userID
            jsonParam["TokenID"] = account?.securityToken
            jsonParam["Application"] = "SalesPro"
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            RestAPIManager.httpRequest(ConstantURL.viewCompanyStock, .get, parameters: jsonParam, isTeamWorkUrl: true) { (response, success, error) in
                SVProgressHUD.dismiss()
                if error != nil {
                    self.productStockList.removeAll()
                    guard let data = response as? [[String: Any]] else {
                        return
                    }

                    for d in data {
                        if let p = Product.getProduct(productID: d["ProductID"] as? NSNumber ?? 0) {
                            let dt = ["ProductID":p.productId,"Name":p.productName,"On": d["OnHandStock"],"Avl":d["AvailableStock"]]
                            self.productStockList.append(dt as [String : Any])
                        }
                    }
                    if (self.setting.salesOrderProductPermission == 1) {
                        if (self.setting.showProductDrive == 1) {
                            self.getProductDrive()
                        }else{
                            if (self.setting.showSuggestOrderQty == 1) {
                                SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
                                self.suggestOrderQtyMultiple()
                            }else{
                                SVProgressHUD.dismiss()
                            }
                        }
                    }else{
                        SVProgressHUD.dismiss()
                    }
                }else{
                    self.productStockList.removeAll()
                    if (self.setting.salesOrderProductPermission == 1) {
                        if (self.setting.showProductDrive == 1) {
                            self.getProductDrive()
                        }else{
                            if (self.setting.showSuggestOrderQty == 1) {
                                SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
                                self.suggestOrderQtyMultiple()
                            }else{
                                SVProgressHUD.dismiss()
                            }
                        }
                    }else{
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    func getProductDrive () {
        let customerId = customer?.iD
        if (customerId == 0) {
            SVProgressHUD.dismiss()
            return
        }
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = [String: Any]()
        param["UserID"] = account?.userID
        param["CompanyID"] = account?.company?.iD
        param["CustomerID"] = customerId
        RestAPIManager.httpRequest(ConstantURL.getProductsForDrive, .get, parameters: param, isTeamWorkUrl: true) { [self] (response, success, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                if let pIDs = response as? [Int64] {
                    self.productDriveIDs = pIDs
                }
                if setting.showSuggestOrderQty == 1 {
                    self.suggestOrderQtyMultiple()
                }
            }
        }
    }
    
    func suggestOrderQtyMultiple() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = [String: Any]()
        param["UserID"] = account?.userID
        param["CompanyID"] = account?.company?.iD
        let customerId  = customer?.iD;
        param["CustomerID"] = customerId
        param["TokenID"] = account?.securityToken
        param["ProductCatId"] = 0
        if (objVisit != nil) {
            param["VisitID"] = objVisit?.iD
        }else{
            param["VisitID"] = 0
        }
        param["ProductSubCatId"] = 0
        RestAPIManager.httpRequest(ConstantURL.suggestOrderQtyMultiple, .get, parameters: param, isTeamWorkUrl: true) { (response, sucess, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                if let result = response as? [[String: Any]] {
                    for d in result {
                        let pId = (d["ProductID"]) as? Int64
                        let p = Product.getProduct(productID: NSNumber(value:pId ?? 0))
                        for var stck in self.productStockList {
                            if (stck["ProductID"] as? Int64 == p?.productId) {
                                stck["SugQty"] = d["SuggestedOrderQty"]
                            }
                        }
                        let dt = ["ProductID": p?.productId ?? 0, "Name":p?.productName ?? "", "On": d["OnHandStock"] as Any, "Avl": d["AvailableStock"] as Any, "SugQty": d["SuggestedOrderQty"] as Any] as [String: Any]
                        self.productStockList.append(dt)
                    }
                }
            }else{
                
            }
        }
    }
    
    func cellObjectUserInteractionEnabled(isEnable: Bool, cell: OrderProductCell){
        cell.txtDiscountRupees.isUserInteractionEnabled = isEnable
        cell.txtDiscount.isUserInteractionEnabled = isEnable
//        cell.txtDisCVal.isUserInteractionEnabled = isEnable
//        cell.txtDisBVal.isUserInteractionEnabled = isEnable
//        cell.txtDisAVal.isUserInteractionEnabled = isEnable
        cell.txtPrice.isUserInteractionEnabled = isEnable
//        cell.txtDisC.isUserInteractionEnabled = isEnable
//        cell.txtDisB.isUserInteractionEnabled = isEnable
//        cell.txtDisA.isUserInteractionEnabled = isEnable
        cell.txtQty.isUserInteractionEnabled = isEnable
        cell.txtFOC.isUserInteractionEnabled = isEnable
        cell.btnDelete.isUserInteractionEnabled = isEnable
        cell.btnStep1.isUserInteractionEnabled = isEnable
        cell.btnStep2.isUserInteractionEnabled = isEnable
        cell.btnFOCSwitch.isUserInteractionEnabled = isEnable
        cell.btnAddiSwitch.isUserInteractionEnabled = isEnable
        cell.btnDelete.isUserInteractionEnabled = isEnable
    }
    //MARK: API Call
    func getProductDriveList(){
        
      //  SVProgressHUD.showInfo(withStatus: "Loading")
        var param  = Common.returndefaultparameter()
            param["CustomerID"] = NSNumber(value: customer?.iD ?? 0)
        
        ApiHelper().getPromotionList(strurl: ConstantURL.KWSUrlGetProductDriveList, customerId: NSNumber(value: customer?.iD ?? 0))  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print()
                AddEditSalesOrderVC.productDriveIDSInNumber = arr as! [NSNumber]
                AddEditSalesOrderVC.productDriveIDSInNumber.removeAll()
                if(error.code == 0){
        
                    if(responseType == ResponseType.arrOfAny || responseType == ResponseType.arr){
                        let arrOfPromotion = arr as? [NSNumber] ?? [NSNumber]()
                        AddEditSalesOrderVC.productDriveIDSInNumber = arrOfPromotion
                        SVProgressHUD.dismiss()
//                        if(self.activesetting.showSuggestOrderQty == (NSNumber.init(value: 1))){
//                            SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.show()
//                            self.suggestOrderQtyMultiple()
//                        }else{
//                            SVProgressHUD.dismiss()
//                        }
                    }
                }
            }
            else if(error.code == 0){
                self.view.makeToast(message)
            }else{
                self.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
            }
        }
    }
    
    //MARK: IBActions
    
    @IBAction func openCompanyStock(_ sender: Any) {
        if let viewcompanystock = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.ViewCompanyStock) as? ViewCompanyStock{
            self.navigationController?.pushViewController(viewcompanystock, animated: true)
        }
    }
    
    @IBAction func btnNewCustomer(_ sender: Any) {
        if (account?.roleId?.intValue ?? 0 > 6 && setting.customerApproval == 1) {
            self.view.makeToast("You are not permitted to add customer, Please contact Admin for permission")
        } else if (account?.roleId?.intValue ?? 0 > 6 && setting.customerApproval == 2) {
            self.view.makeToast("It require approval to add customer, Please contact Admin for permission")
        } else {
            if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                Common.skipVisitSelection = false
                AddCustomer.isFromInfluencer = 0
                addCustomer.isForAddAddress = false
                addCustomer.isFromColdCallVisit = false
                addCustomer.isEditCustomer = false
                addCustomer.selectedCustomer = CustomerDetails()
                addCustomer.isVendor = false
                addCustomer.saveCustDelegate = self
                self.navigationController?.pushViewController(addCustomer, animated: true)
            }
        }
    }
    
    @IBAction func btnSearchCustomerClicked(_ sender: Any) {
        if(arrOfCustomers.count > 0){
            popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            popup?.strTitle = ""
            popup?.arrOfSelectedSingleCustomer = arrOfCustomers
            popup?.modalPresentationStyle = .overCurrentContext
            popup?.nonmandatorydelegate = self
            popup?.arrOfList = arrOfCustomers
            popup?.selectionmode = SelectionMode.none
            popup?.isFromSalesOrder =  false
            popup?.isFilterRequire = false
            popup?.strLeftTitle = "REFRESH"
            popup?.isSearchBarRequire = true
            popup?.viewfor = ViewFor.customer
            popup?.parentViewOfPopup = self.view
            Utils.addShadow(view: self.view)
            self.present(popup!, animated: true, completion:nil)
        }else{
          //  self.view.makeToast("No Customer Please Create new")
        }
    }

    
    @IBAction func isDirectSalesOrder(_ sender: Any) {
        let button = sender as! UIButton
        button.isSelected = !button.isSelected
        viewSelectCustomer.isHidden = !button.isSelected
        vwLeadProposalSel.isHidden = button.isSelected
        self.btnLeadProposalSel(btnLeadProposal.first!)
    }
    
    @IBAction func btnLeadProposalSel(_ sender: Any) {
        for x in btnLeadProposal {
            x.isSelected = false
            x.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        (sender as! UIButton).isSelected = true
        (sender as! UIButton).backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        if btnLeadProposal.first == sender as? UIButton {
            txtPropLdSel.text = "Select Proposal"
        }else{
            txtPropLdSel.text = "Select Lead"
        }
        customer = nil
        aryProductList.removeAll()
    }
    
    @IBAction func btnAddProduct(_ sender: Any) {
        if(activesetting.salesOrderProductPermission == 2){
            // multiple product selection
            if let multipleproductselection = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MultipleProductSelection) as? MultipleProductSelection{
                Common.skipVisitSelection = false
                multipleproductselection.issalesorder = true
                multipleproductselection.multipleproductselectiondelegate = self
                multipleproductselection.isSalesOrderFromVisit = (objVisit != nil) ? true : false
                multipleproductselection.customerId = NSNumber(value: customer?.iD ?? 0)
                multipleproductselection.aryStockProducts = aryStockProducts
                multipleproductselection.stockReturn = {stocks in
                    self.aryStockProducts.append(contentsOf: stocks)
                }
                if let selectedcustomer = customer{
                    multipleproductselection.customerId =  NSNumber.init(value:selectedcustomer.iD)
                    multipleproductselection.multipleproductselectiondelegate = self
                    self.navigationController?.pushViewController(multipleproductselection, animated: true)
                }else{
                    self.view.makeToast("Please select customer first")
                }
            }
            
        }else{
            if let addproductobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.SingleProductSelection) as? Addproduct{
                addproductobj.customerId =   customer?.iD ?? 0
                addproductobj.isFromProductStock = false
                addproductobj.isVisit = false
                addproductobj.visitID = objVisit?.iD ?? 0
                addproductobj.customerId = customer?.iD ?? 0
                addproductobj.isCut = true
                addproductobj.isFromSalesOrder =  true
                addproductobj.productselectionfrom = ProductSelectionFromView.salesorder
                addproductobj.productselectiondelegate = self
                addproductobj.modalPresentationStyle = .overCurrentContext
                addproductobj.parentviewforpopup = self.view
                Utils.addShadow(view: self.view)
                self.present(addproductobj, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func save(_ sender: Any) {
        var message = ""
        if (btnIsDirectProposal.isSelected) {
            message = customer == nil ? "Please select customer" : aryProductList.count == 0 ? "Please add product" : ""
            if (message.count > 0) {
                self.view.window?.makeToast(message)
                return;
            }
            
            if setting.allowZeroPriceInSO == 0 {
                for d in aryProductList {
                    if d.price?.toDouble() == 0 {
                        self.view.window?.makeToast("Please add product price greater than 0 to \(d.productName ?? "")")
                        return
                    }
                }
            }
            
            if (txtWarranty.text?.count ?? 0 == 0 && setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
                self.view.window?.makeToast("Please add Warranty ID")
                return;
            }
            if (txtWarranty.text?.count ?? 0 < 7 && setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
                self.view.window?.makeToast("Enter 7 digit number for Warranty ID")
                return;
            }
            
            if (setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
                if !(txtWarranty.text?.hasPrefix("7") ?? false) {
                    self.view.window?.makeToast("Warranty ID should be starts with 7")
                    return;
                }
            }
            
            if !(Utils.isCustomerMapped(cid: NSNumber(value: customer?.iD ?? 0))) {
                self.view.window?.makeToast("Customer Not Mapped, So you can't Add Sales Order for this customer")
                return;
            }
            
            if (message.count == 0) {
                for d in aryProductList {
                    if d.quantity?.toInt() == 0 {
                        self.view.window?.makeToast("Enter product qty greater than zero")
                        return;
                    }else if (d.quantity?.toInt() ?? 0 > (setting.maxOrderQty?.intValue ?? 1)) {
                        self.view.window?.makeToast("Please select product quantity less than \(setting.maxOrderQty?.intValue ?? 0 + 1)")
                        return;
                    }
                }
            }
            
            if (message.count == 0) {
                    //Asian Paint
                if (account?.company?.iD ?? 1 == 1130) {
                    //Product ID - Low Cost Mixture
                    var checkWarantyValidation = false
                    for d in aryProductList {
                        if (d.productID == 21594) {
                            checkWarantyValidation = true
                        }
                    }
                    if (!checkWarantyValidation && txtWarranty.text == "7011111") {
                        message = "You can not add this Warranty ID for this product"
                    }
                }
            }
            
            if (message.count > 0) {
                self.view.window?.makeToast(message)
                return;
            }
        }else{
            if !(btnLeadProposal.first!.isSelected) {
                message = lead == nil ? "Please select lead" : aryProductList.count == 0 ? "Please add product" : ""

                if (message.count == 0) {
                    if setting.allowZeroPriceInSO == 0 {
                        for d in aryProductList {
                            if d.price?.toDouble() == 0 {
                                self.view.window?.makeToast("Please add product price greater than 0 to \(d.productName ?? "")")
                                return;
                            }
                        }
                    }
                    for d in aryProductList {
                        if (Int(d.quantity ?? "0") ?? 0 == 0) {
                            self.view.window?.makeToast("Enter product qty greater than zero")
                            return;
                        }else if (Int(d.quantity ?? "0")! > (setting.maxOrderQty?.intValue ?? 1)) {
                            self.view.window?.makeToast("Please select product quantity less than \(setting.maxOrderQty?.intValue ?? 0 + 1)")
                            return;
                        }
                    }
                    if (txtWarranty.text?.count ?? 0 == 0 && setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
                        self.view.window?.makeToast("Please add Warranty ID")
                        return;
                    }
                    if (txtWarranty.text?.count ?? 0 < 7 && setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
                        self.view.window?.makeToast("Enter 7 digit number for Warranty ID")
                        return;
                    }
                    
                    if (setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
                        if !(txtWarranty.text?.hasPrefix("7") ?? false) {
                            self.view.window?.makeToast("Warranty ID should be starts with 7")
                            return;
                        }
                    }
                }
                if (message.count == 0) {
                        //Asian Paint
                    if (account?.company?.iD ?? 1 == 1130) {
                        //Product ID - Low Cost Mixture
                        var checkWarantyValidation = false
                        for d in aryProductList {
                            if (d.productID == 21594) {
                                checkWarantyValidation = true
                            }
                        }
                        if (!checkWarantyValidation && txtWarranty.text == "7011111") {
                            message = "You can not add this Warranty ID for this product"
                        }
                    }
                }
                if (message.count > 0) {
                    self.view.window?.makeToast(message)
                    return;
                }
            }else{
                message = proposal == nil ? "Please select proposal" : aryProductList.count == 0 ? "Please add product" : ""
                if (message.count == 0) {
                    for d in aryProductList {
                        if (Int(d.quantity ?? "0") ?? 0 == 0) {
                            self.view.window?.makeToast("Enter product qty greater than zero")
                            return
//                            break;
                        }else if (Int(d.quantity ?? "0")! > (setting.maxOrderQty?.intValue ?? 1)) {
                            self.view.window?.makeToast("Please select product quantity less than \(setting.maxOrderQty?.intValue ?? 0 + 1)")
                            return
//                            break;
                        }
                    }
                }

                if (message.count > 0) {
                    self.view.window?.makeToast(message)
                    return;
                }

                if let objOutcome = Outcomes.isTrialSuccessful() {
                    if (setting.mandatoryTrialSuccessfulStatusForOrderInLead == 1) {
                        if let objTempLead = Lead.getLeadByID(Id: Int(lead?.iD ?? 0)), let leadOutcomes = objTempLead.leadStatusList.value(forKey: "outcomeID") as? [Int64] {
                            if !leadOutcomes.contains(objOutcome.leadOutcomeIndexID) {
                                self.view.window?.makeToast("Please update lead status to 'Trial Successful to place order.")
                                return
                            }
                        }
                    }
                }
                if (txtWarranty.text?.count ?? 0 == 0 && setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
                    self.view.window?.makeToast("Please add Warranty ID")
                    return;
                }
                if (txtWarranty.text?.count ?? 0 < 7 && setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
                    self.view.window?.makeToast("Enter 7 digit number for Warranty ID")
                    return;
                }
                
                if (setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
                    if !(txtWarranty.text?.hasPrefix("7") ?? false) {
                        self.view.window?.makeToast("Warranty ID should be starts with 7")
                        return;
                    }
                }
                if (message.count == 0) {
                        //Asian Paint
                    if (account?.company?.iD ?? 1 == 1130) {
                        //Product ID - Low Cost Mixture
                        var checkWarantyValidation = false
                        for d in aryProductList {
                            if (d.productID == 21594) {
                                checkWarantyValidation = true
                            }
                        }
                        if (!checkWarantyValidation && txtWarranty.text == "7011111") {
                            message = "You can not add this Warranty ID for this product"
                        }
                    }
                }
            }
        }
        if self.setting.askBeforeCloseLeadAfterSalesOrderCreate == 1 {
            let yesAction =  UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default) { (action) in
                self.apiCallSalesOrderCreated(message: message, isLeadCloseAfterConfirm: 1)
            }
            let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
                self.apiCallSalesOrderCreated(message: message, isLeadCloseAfterConfirm: 0)
            })
            Common.showalertWithAction(msg: "Do you want to close the lead with this order submission?", arrAction: [yesAction,noAction], view: self)
        }else {
            self.apiCallSalesOrderCreated(message: message, isLeadCloseAfterConfirm: 1)
        }
    }
    func apiCallSalesOrderCreated(message:String,isLeadCloseAfterConfirm:Int) {
        if (message.count > 0) {
            self.view.window?.makeToast(message)
            return;
        }else{
            var param = [String: Any]()
            param["isLeadCloseAfterConfirm"] = isLeadCloseAfterConfirm
            param["CreatedBy"] = account?.userID ?? 0
            if (btnIsDirectProposal.isSelected){
                param["CustomerID"] = customer?.iD ?? 0
                param["LeadID"] = lead?.iD ?? 0
            }else{
                param["CustomerID"] = customer?.iD ?? 0
                if (!viewSelectCustomer.isHidden){
                    param["ProposalID"] = proposal?.iD ?? 0
                }else {
                    param["LeadID"] = lead?.iD ?? 0
                }
            }
            param["AssignedTo"] = account?.userID
            param["StatusID"] = 1
            param["ApprovedBy"] = 1
            param["CompanyID"] = account?.company?.iD ?? 0
            param["GrossAmount"] = 0
            param["NetAmount"] = String(format:"%.2f", lblTtlNetAmt.text!.toDouble())
            param["finalSalesAmount"] = String(format:"%.2f", lblTtlNetAmt.text!.toDouble())
            param["Description"] = txtDesc.text?.escapeUnicodeString()
            param["TNC"] = txtTNC.text?.escapeUnicodeString()
            param["SeriesPrefix"] = setting.salesOrderFormat
            param["FulfilledByID"] = fulfilledByID
            
            if order != nil {
                param["ID"] = order?.iD
                param["SeriesPostfix"] = order?.seriesPostfix
            }
            
            if String.isNullOrEmpty(txtDeliveryDays.text) || txtDeliveryDays.text == "0" {
                param["DeliveryDays"] = 0
            }else{
                param["DeliveryDays"] = txtDeliveryDays.text
            }

            if (setting.sORequireWarrantyAndDealerCode == 1){
                param["Warranty"] = txtWarranty.text?.escapeUnicodeString()
                param["DealerCode"] = txtDealerCode.text?.escapeUnicodeString()
                param["DealerCity"] = txtDealerCity.text?.escapeUnicodeString()
            }else{
                param["Warranty"] = ""
                param["DealerCode"] = ""
                param["DealerCity"] = ""
            }
            
            var arr = [[String: Any]]()
            for d in aryProductList {
                var d1 = ["ProductID": d.productID ?? 0, "Quantity":d.quantity ?? "0", "Price":d.price ?? "0.0", "Discount":d.salesDiscount ?? "0.0", "ProductAmount": String(format: "%.2f", d.netAmt)] as [String : Any]
                if d.disType != 2 || d.disType == nil || d.customerClass == 4{
                    // Normal Discount
                    if d.isVat {
                        if let vt = MetadataVATCodes.getVatPerFromID(ID: NSNumber(value: d.vatID ?? 0)) {
                            d1["VATPercentage"] = vt.tAXPercentage
                            d1["InclusiveExclusive"] = vt.inclusiveExclusive
                            d1["VATFrom"] = d.vATFrom
                        }
                    }
                    d1["DiscountType"] = d.disType
                    if d.disType == 3 {
                        d1["Maxdiscount"] = String.isNullOrEmpty(d.maxdiscount) ? 0.0 : d.maxdiscount?.toDouble()
                    }else{
                        d1["Maxdiscount"] = 0.0
                    }
                    d1["CustomerClass"] = d.customerClass
                }else{
                    d1["Discount"] = 0
                    d1["DiscountType"] = d.disType
                    d1["CustomerClass"] = d.customerClass
                    if d.customerClass == 1 {// Customer Class A and if customer is not selected then value is calculated based on Customer Class A
                        d1["DiscountB"] = d.disB
                        d1["DiscountA"] = d.disA
                        d1["DiscountC"] = 0.0
                    }else if d.customerClass == 2 {// Customer Class B
                        d1["DiscountB"] = d.disB
                        d1["DiscountA"] = d.isAllow ? d.disA : 0.0
                    }else if d.customerClass == 3 {// Customer Class C
                        if d.isAllow {
                            if d.isFirstStep {
                                d1["DiscountB"] = d.disB
                                d1["DiscountA"] = 0.0
                                d1["DiscountC"] = 0.0
                            }else{
                                d1["DiscountB"] = d.disB
                                d1["DiscountA"] = d.disA
                            }
                        }else{
                            d1["DiscountC"] = d.disC
                        }
                    }else{ // Customer Class D
                        d1["DiscountB"] = 0.0
                        d1["DiscountA"] = 0.0
                        d1["DiscountC"] = 0.0
                    }
                    if d.isVat {
                        if let vt = MetadataVATCodes.getVatPerFromID(ID: NSNumber(value: d.vatID ?? 0)) {
                            d1["VATPercentage"] = vt.tAXPercentage
                            d1["InclusiveExclusive"] = vt.inclusiveExclusive
                            d1["VATFrom"] = d.vATFrom
                        }
                    }
                    d1["Maxdiscount"] = String.isNullOrEmpty(d.maxdiscount) ? 0.0 : d.maxdiscount?.toDouble()
                }
                // SO Promotion
                if let promotion = selectedPromotion {
                    if (promotion.promotionType == 1) {
                        for data in promotion.promotionProductList {
                            let p = Product.getProduct(productID: d.productID ?? 0)
                            if (data.byCategoryOrID == 1) {
                                //From Product ID
                                if (d.productID?.intValue == data.productID) {
                                    d1["IsPromotional"] = promotion.promotionType
                                }
                            } else if (data.byCategoryOrID == 2) {
                                //From category or Subcategory
                                if (data.productSubCategoryID == 0) {
                                    //From All Sub-Category for Selected Category
                                    if (Int(p?.productCatId ?? 0) == data.productCategoryID) {
                                        d1["IsPromotional"] = promotion.promotionType
                                    }
                                } else {
                                    //From selcted Subcategory for Selected Category
                                    if (Int(p?.productSubCatId ?? 0) == data.productSubCategoryID) {
                                        d1["IsPromotional"] = promotion.promotionType
                                    }
                                }
                            }
                        }
                    }
                }

                // Set FOC Quantity
                d1["FOCQuantity"] = d.focQuantity
                d1["CGSTTax"] = d.CGSTTax
                d1["CGSTSurcharges"] = 0
                d1["SGSTTax"] = d.SGSTTax
                d1["SGSTSurcharges"] = 0
                d1["IGSTTax"] = d.IGSTTax
                d1["IGSTSurcharges"] = 0
                arr.append(d1)
            }
            
            if let promotion = selectedPromotion {
                param["FlatPromotionPercentage"] = flatPromotionPercentage
                param["PromotionID"] = promotion.ID
                param["IsPromotionApplied"] = promotion.promotionType
                param["PromotionName"] = promotion.promotionTitle
                param["totalPromotionAmount"] = lblTtlPromotionAmt.text!.toDouble()
                for fp in promotion.freeBonusProductList {
                    var d1 = ["ProductID":fp.productID, "Quantity": fp.freeProductQty, "Price": 0.0, "Discount":0.0, "ProductAmount": 0.0] as [String : Any]
                    
                    // Set FOC Quantity
                    d1["IsPromotional"] = promotion.promotionType
                    d1["FOCQuantity"] = 0

                    d1["CGSTTax"] = 0
                    d1["CGSTSurcharges"] = 0
                    
                    d1["SGSTTax"] = 0
                    d1["SGSTSurcharges"] = 0

                    d1["IGSTTax"] = 0
                    d1["IGSTSurcharges"] = 0

                    arr.append(d1)
                }
            }
            
            var maindict = [String: Any]()
            maindict["addsalesorderjson"] = Common.json(from:param)//.rs_jsonString(withPrettyPrint: true)
            maindict["addsalesorderproductjson"] = Common.json(from:arr)//.rs_jsonString(withPrettyPrint: true)
            maindict["UserID"] = account?.userID
            maindict["TokenID"] = account?.securityToken

            print(maindict)
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            RestAPIManager.httpRequest(ConstantURL.addsalesorder, .post, parameters: maindict, isTeamWorkUrl: true) { (response, success, error) in
                SVProgressHUD.dismiss()
                if error != nil {
                    self.view.window?.makeToast(error?.localizedDescription)
                }else if var resOrder = (response as? [[String: Any]])?.first {
                    if (self.objVisit != nil){
                        resOrder["VisitID"] = self.objVisit?.iD ?? 0
                    }
                    resOrder["finalSalesAmount"] = self.lblTtlNetAmt.text!.toDouble()
                    resOrder["totalDiscount"] = self.ttlDis.roundToDecimal(2)
                    resOrder["totalGrossAmount"] = self.ttlGross.roundToDecimal(2)
                    resOrder["totalNetAmount"] = self.ttlPro.roundToDecimal(2)
                    resOrder["totalTaxAmount"] = self.lblTtlTaxAmt.text!.toDouble()
                    resOrder["totalPromotionAmount"] = self.lblTtlPromotionAmt.text!.toDouble()
                    MagicalRecord.save({ (localContext) in
                        let o = FEMDeserializer.collection(fromRepresentation: [resOrder], mapping: SOrder.defaultMapping(), context: localContext)
                        print(o)
                    }, completion: { [self] (contextdidsave, error) in
                        if ((self.objVisit != nil) && aryStockProducts.count > 0 && setting.stockUpdateInOrder == 1) {
                            var jsonPro = [[String: Any]]();
                            let strCurDate = String(format: "%@ 00:00:00", Utils.getDateWithAppendingDayLang(day: 0, date: Date(), format: "yyyy/MM/dd"))
                            for x in aryStockProducts{
                                var jsonParameters = [String: Any]();
                                jsonParameters["VisitID"] = objVisit?.iD
                                jsonParameters["CreatedBy"] = account?.userID
                                jsonParameters["StockDate"] = strCurDate
                                jsonParameters["ProductID"] = x["ProductID"]
                                jsonParameters["Quantity"] = x["Quantity"]
                                jsonPro.append(jsonParameters)
                            }
                            var maindict = [String: Any]()
                            maindict["updateVisitUpdateStockJson"] = jsonPro.rs_jsonString(withPrettyPrint:true)
                            maindict["UserID"] = account?.userID
                            maindict["CompanyID"] = account?.company?.iD
                            maindict["TokenID"] = account?.securityToken

                            SVProgressHUD.setDefaultMaskType(.black)
                            SVProgressHUD.show()
                            RestAPIManager.httpRequest(ConstantURL.updateVisitStock, .post, parameters: maindict, isTeamWorkUrl: true, isFull: true) { response, success, error in
                                if error == nil {
                                    guard let result = response as? [String: Any] else {
                                        return
                                    }
                                    if result["status"] as? String == "Success" {
                                        delegate?.successfullySaveOrUpdateSO()
                                        if let viewControllers = self.navigationController?.viewControllers {
                                            if viewControllers.contains(where: {
                                                return ($0 is LeadDetail || $0 is UpdateLeadStatus)
                                            }) {
                                                self.navigationController?.popToRootViewController(animated: true)
                                            }else{
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        }
                                    }else{
                                        self.view.makeToast(result["message"] as? String)
                                    }
                                }else{
                                    SVProgressHUD.dismiss()
                                    self.view.makeToast(error?.localizedDescription)
                                }
                            }
                        }else{
                            delegate?.successfullySaveOrUpdateSO()
                            if let viewControllers = self.navigationController?.viewControllers {
                                if viewControllers.contains(where: {
                                    return ($0 is LeadDetail || $0 is UpdateLeadStatus)
                                }) {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }else{
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    @objc private func calculateNetAmt(){
        ttlPro = 0.0
        ttlDis=0.0
        ttlGross=0.0
        ttlNet = 0.0
        ttlTax=0.0
//        ttlPromotion=0.0;
        for d in aryProductList {
            ttlPro += d.proAmt
            ttlDis += d.proDis
            ttlGross += d.proAftDisAmt
            ttlTax += d.proTax
            ttlNet += d.netAmt
        }
        if (aryProductList.count == 0 || setting.requireDiscountAndTaxAmountInSO != 1) {
            lblTtlProAmt.text = ""
            lblTtlDisAmt.text = ""
            lblTtlGrossAmt.text = ""
            lblTtlTaxAmt.text = ""
            lblTtlNetAmt.text = ""
            lblTtlPromotionAmt.text = "";
        }else{
            lblTtlProAmt.text   = numberFormatter.string(from: NSNumber(value:ttlPro)) //String(format: "%.2f", ttlPro);
            lblTtlDisAmt.text   = numberFormatter.string(from: NSNumber(value:ttlDis)) //String(format: "%.2f", ttlDis);
            lblTtlGrossAmt.text = numberFormatter.string(from: NSNumber(value:ttlGross)) //String(format: "%.2f", ttlGross);
            lblTtlTaxAmt.text   = numberFormatter.string(from: NSNumber(value:ttlTax)) //String(format: "%.2f", ttlTax);
            lblTtlNetAmt.text   = numberFormatter.string(from: NSNumber(value:ttlNet - ttlPromotion)) //String(format: "%.2f", ttlNet);
            if (selectedPromotion?.flatPromotionSlabDetails != nil && selectedPromotion?.flatPromotionSlabDetails.count ?? 0 > 0) {
            }else{
                if order != nil && selectedPromotion != nil {
                    lblTtlTaxAmt.text = numberFormatter.string(from: NSNumber(value: order?.totalTaxAmount ?? 0.0))
                    lblTtlNetAmt.text = numberFormatter.string(from: NSNumber(value: order?.finalSalesAmount ?? 0.0))
                    lblTtlPromotionAmt.text = numberFormatter.string(from: NSNumber(value: order?.totalPromotionAmount ?? 0.0))
                }
            }
            if (setting.requirePromotionInSO == 1 && selectedPromotion != nil) {
                //Process for apply promotion
                if isPromotionApplied {
                    return
                }
                if (selectedPromotion?.promotionType == 1) {
                    NSLog("Flat Promotion Applied");
                    if (selectedPromotion?.flatPromotionSlabDetails != nil && selectedPromotion?.flatPromotionSlabDetails.count ?? 0 > 0) {
                        flatPromotionPercentage = 0.0;
                        
                        //Find gross amount for Promotion products
                        var totalPromotionGrossAmount = 0.0;
                        
                        for temp in aryProductList {
                            for data in selectedPromotion?.promotionProductList ?? [] {
                                let p = Product.getProduct(productID: temp.productID ?? 0)
                                if (data.byCategoryOrID == 1) {
                                    //From Product ID
                                    if (temp.productID?.intValue ?? 0 == data.productID) {
                                        totalPromotionGrossAmount = totalPromotionGrossAmount + temp.proAftDisAmt
                                    }
                                } else if (data.byCategoryOrID == 2) {
                                    //From category or Subcategory
                                    if (data.productSubCategoryID == 0) {
                                        //From All Sub-Category for Selected Category
                                        if (p?.productCatId == Int64(data.productCategoryID)) {
                                            totalPromotionGrossAmount = totalPromotionGrossAmount + temp.proAftDisAmt
                                        }
                                    } else {
                                        //From selected Subcategory for Selected Category
                                        if (p?.productSubCatId == Int64(data.productSubCategoryID)) {
                                            totalPromotionGrossAmount = totalPromotionGrossAmount + temp.proAftDisAmt;
                                        }
                                    }
                                }
                            }
                        }
                        var lastSlabData = 0
                        var lastSlabPerc = 0
                        for slabData in selectedPromotion?.flatPromotionSlabDetails ?? [] {
                            lastSlabData = slabData.endSlabAmount;
                            lastSlabPerc = slabData.slabPercentage;
                            
                            if (Int(totalPromotionGrossAmount) >= slabData.startSlabAmount && Int(totalPromotionGrossAmount) <= slabData.endSlabAmount) {
                                flatPromotionPercentage = Float(slabData.slabPercentage)
                                break;
                            }
                        }
                        if(flatPromotionPercentage == 0.0){
                            if(totalPromotionGrossAmount > Double(lastSlabData)){
                                flatPromotionPercentage = Float(lastSlabPerc)
                            }
                        }
                        
                        if (flatPromotionPercentage > 0 && selectedPromotion?.promotionProductList != nil
                                && selectedPromotion?.promotionProductList.count ?? 0 > 0) {
                            self.applyFlatPromotionToIndividualProduct(percentage: Double(flatPromotionPercentage), withPromitionProduct: selectedPromotion?.promotionProductList)
                        }
                        
                    }else{
                        lblTtlTaxAmt.text = numberFormatter.string(from: NSNumber(value: order?.totalTaxAmount ?? 0.0))
                        lblTtlNetAmt.text = numberFormatter.string(from: NSNumber(value: order?.finalSalesAmount ?? 0.0))
                        lblTtlPromotionAmt.text = numberFormatter.string(from: NSNumber(value: order?.totalPromotionAmount ?? 0.0))
                    }
                    isPromotionApplied = true
                }else{
                    print("Bonus Promotion Applied")
                    //Calculate VAT or GST
                    var selectedFinalAmount = 0.0;
                    totalPromotionAmount = 0;
                    for c in selectedPromotion?.freeBonusProductList ?? []{
                        let p = Product.getProduct(productID: NSNumber(value:c.productID))
                        if (p != nil) {
                            totalPromotionAmount += ((p?.price ?? 0.0) * Double(c.freeProductQty));
                        }
                    }

                    selectedFinalAmount = lblTtlGrossAmt.text!.toDouble() + lblTtlTaxAmt.text!.toDouble()
                    lblTtlNetAmt.text = numberFormatter.string(from: NSNumber(value: selectedFinalAmount))
                    lblTtlPromotionAmt.text = numberFormatter.string(from: NSNumber(value: totalPromotionAmount))
                    if !isPromotionApplied {
                        isPromotionApplied = true
                        tableView.reloadData()
                        return
                    }
                }
            }else if(setting.requirePromotionInSO == 1){
                lblTtlPromotionAmt.text = "\(0.0)"
            }else{
                lblTtlPromotionAmt.text = "";
            }
        }
    }

    /**
     * @param percentage           --- flat promotion percentage
     * @param promotionProductList ---- promotion product list which are applicable for promotion
     * @return void
     * <p>
     * This method do flat promotion calculation
     * After discount value apply flat promotion using percentage to appliocable products only and
     * after promotion again do tax calculation
     */
    private func applyFlatPromotionToIndividualProduct(percentage: Double, withPromitionProduct promotionProductList:[PromotionProduct]?) {
        var selectedGrossAmount = 0.0;
        var selectedPromotionAmount = 0.0;
        var selectedPromotionAmountFinal = 0.0;
        var selectedFinalAmount = 0.0;
        var selectedFinalAmountTotal = 0.0;
        
        var ttlTax = 0.0;
        for temp in aryProductList {
            selectedPromotionAmount = 0.0
            var isDeduct = false
            for data in promotionProductList ?? [] {
                let p = Product.getProduct(productID: temp.productID ?? 0)
                if (data.byCategoryOrID == 1) {
                    //From Product ID
                    if (temp.productID?.intValue == data.productID) {
                        isDeduct = true;
                        selectedGrossAmount = temp.proAftDisAmt
                        selectedPromotionAmount = (selectedGrossAmount * percentage) / 100;
                        break;
                    }else{
                        if (temp.productID?.intValue != data.productID) {
                            selectedGrossAmount = temp.proAftDisAmt
                            isDeduct = false;
                        }
                    }
                } else if (data.byCategoryOrID == 2) {
                    //From category or Subcategory
                    if (data.productSubCategoryID == 0) {
                        //From All Sub-Category for Selected Category
                        if (p?.productCatId ?? 0 == data.productCategoryID) {
                            selectedGrossAmount = temp.proAftDisAmt
                            selectedPromotionAmount = (selectedGrossAmount * percentage) / 100;
                            isDeduct = true;
                            break;
                        }else{
                            selectedGrossAmount = temp.proAftDisAmt
                            isDeduct = false
                        }
                    } else {
                        //From selcted Subcategory for Selected Category
                        if (p?.productSubCatId == Int64(data.productSubCategoryID)) {
                            selectedGrossAmount = temp.proAftDisAmt
                            selectedPromotionAmount = (selectedGrossAmount * percentage) / 100;
                            isDeduct = true;
                            break;
                        }else{
                            selectedGrossAmount = temp.proAftDisAmt
                            isDeduct = false;
                        }
                    }
                }
            }
            
            //Calculate VAT or GST
            if (isDeduct) {
                selectedFinalAmount = selectedGrossAmount - selectedPromotionAmount;
            }else{
                selectedFinalAmount = selectedGrossAmount - 0;
            }
            if (setting.vatGst == 1) {
                //GST
                var SGST_IGST = 0
                if (temp.SGSTTax > 0.0) {
                    SGST_IGST = 1;
                } else if (temp.IGSTTax > 0.0) {
                    SGST_IGST = 2;
                } else {
                    SGST_IGST = 0;
                }
                
                var sgst = 0.0
                var cgst = 0.0
                var igst = 0.0
                if (SGST_IGST == 1) {
                    let sgstRate = temp.SGSTTax
                    let cgstRate = temp.CGSTTax
                    
                    sgst = (selectedFinalAmount * sgstRate) / 100.0
                    cgst = (selectedFinalAmount * cgstRate) / 100.0
                    
                } else if (SGST_IGST == 2) {
                    let igstRate = temp.IGSTTax
                    
                    igst = (selectedFinalAmount * igstRate) / 100.0
                }
                
                let a = sgst + cgst + igst;
                selectedFinalAmount = selectedFinalAmount + a;
                selectedFinalAmountTotal += selectedFinalAmount;
                ttlTax += a;
                temp.proTax = (sgst + cgst + igst)
                lblTtlTaxAmt.text = numberFormatter.string(from: NSNumber(value:ttlTax))
//                String(format: "%.2f", ttlTax);
            } else {
                //VAT
                var vatCode = 0.0
                var vatAmt = 0.0;
                var isInclusive = ""
                if temp.isVat {
                    if (temp.isInclusive != nil) {
                        vatCode = Double(temp.vATPercentage)
                    }else{
                        let vt = MetadataVATCodes.getVatPerFromID(ID: NSNumber(value: temp.vatID ?? 0))
                        if (vt?.inclusiveExclusive == "Inclusive") {
                            isInclusive = "Inclusive"
                        }else{
                            isInclusive = "Exclusive"
                        }
                        vatCode = Double(vt?.tAXPercentage ?? 0.0)
                    }
                }else{
                    vatCode = 0.0;
                }
                
                if (isInclusive == "Exclusive") {
                    vatAmt = (selectedFinalAmount * vatCode) / 100;
                    selectedFinalAmount = selectedFinalAmount + vatAmt;
                    selectedFinalAmountTotal += selectedFinalAmount;
//                    temp.proTax = vatAmt
                } else if (isInclusive == "Inclusive") {
                    let c = (selectedFinalAmount * 100.0) / (100.0 + vatCode);
                    vatAmt = selectedFinalAmount - c;
                    selectedFinalAmountTotal += selectedFinalAmount;
//                    temp.proTax = vatAmt
                }else{
                    vatAmt = (selectedFinalAmount * vatCode) / 100;
                    selectedFinalAmount = selectedFinalAmount + vatAmt;
                    selectedFinalAmountTotal += selectedFinalAmount;
                }
                ttlTax += vatAmt;
                
            }
            selectedPromotionAmountFinal += selectedPromotionAmount
        }
        ttlPromotion = selectedPromotionAmountFinal
        lblTtlTaxAmt.text = numberFormatter.string(from: NSNumber(value:ttlTax))//String(format: "%.2f", ttlTax);
        lblTtlNetAmt.text = numberFormatter.string(from: NSNumber(value:selectedFinalAmountTotal))
        lblTtlPromotionAmt.text = numberFormatter.string(from: NSNumber(value:selectedPromotionAmountFinal))
    }
    
    @IBAction func deleteSO(index: Int) {
        let alertController = UIAlertController(title: "Supersales", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: .default) { [self] action in
            if (btnIsDirectProposal.isSelected) {
                //Asian Paint
                if (account?.company?.iD == 1130) {
                    if (aryProductList[index].productID == 21594) {
                        //Set Warranty ID to 7011111
                        txtWarranty.text = ""
                        txtWarranty.isEnabled = true;
                    }
                }
                aryProductList.remove(at: index)
                if (aryProductList.count == 0) {
                    isProduct = false
                    isService = false
                }
            }
            tableView.reloadData()
            self.perform(#selector(calculateNetAmt), with: self, afterDelay: 0.2)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func isViewPromotion(_ sender: Any) {
        let btnSwitch = sender as! UIButton
        btnSwitch.isSelected = !btnSwitch.isSelected;
        if (btnSwitch.isSelected) {
            vwPromotion1.isHidden = false;
        }else{
            for cell in tableView.visibleCells {
                self.cellObjectUserInteractionEnabled(isEnable: true, cell: cell as! OrderProductCell)
            }
            ttlPromotion = 0.0
            vwPromotion1.isHidden = true;
            selectedPromotion=nil;
            lblPromosionName.text = ""
            isPromotionApplied = false
            tableView.reloadData()
        }
    }


    @IBAction func viewPromotionList(_ sender: Any) {
        if (customer == nil) {
            self.view.makeToast("Please select customer")
            return
        }
        
        if aryProductList.count == 0 {
            self.view.makeToast("Please select products")
            return
        }
        
        var arr = [[String: Any]]()
        for d in aryProductList {
            let d1 = ["ProductID": d.productID ?? 0, "Quantity": d.quantity?.toInt() ?? 0, "Price":d.price!.toDouble()] as [String : Any]
            arr.append(d1)
        }
        var dict = [String: Any]()
        dict["CompanyID"] = account?.company?.iD
        dict["UserID"] = account?.userID
        dict["TokenID"] = account?.securityToken
        dict["RequestProductList"] = arr.rs_jsonString(withPrettyPrint:true)
        dict["CustomerID"] = customer?.iD
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        RestAPIManager.httpRequest(ConstantURL.getApplicablePromotionList, .get, parameters: dict, isTeamWorkUrl: true, isFull: true) { [self] response, sucess, error in
            SVProgressHUD.dismiss()
            if sucess {
                promotionList.removeAll()
                guard let result = response as? [String: Any] else {
                    return
                }
                if let promotions = result["data"] as? [[String: Any]], promotions.count > 0 {
                    for dictPromotion in promotions {
                        let obj = Promotion(dictPromotion)
                        self.promotionList.append(obj)
                    }
                    if let controller = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "SOPromotionList") as? SOPromotionList{
                        controller.nvc = self.navigationController
                        controller.delegate = self;
                        controller.promotionList = self.promotionList;
                        self.addChild(controller)
                        controller.view.frame = AppDelegate.shared.alertWindow.frame
                        self.view.addSubview(controller.view)
                        controller.didMove(toParent:self)
                    }
                }else {
                    self.view.makeToast("There is no promotion found")
                }
            }else{
                self.view.makeToast(error?.localizedDescription)
            }
        }
    }

    @IBAction func selectFulfilledBy(_ sender: Any) {
        if (order?.statusID == 7) {
            return
        }
        var aryFilfilment = [CustomerDetails]()
        if (setting.salesOrderFulfillmentFrom==2) {
            aryFilfilment = CustomerDetails.getAllDistributors()
        }else if (setting.salesOrderFulfillmentFrom==3){
            aryFilfilment = CustomerDetails.getAllRetails()
        }else if (setting.salesOrderFulfillmentFrom==4){
            aryFilfilment = CustomerDetails.getAllRetailsAndDistributors()
        }
        
        customerDropDown.dataSource = aryFilfilment.map {$0.name ?? ""}
        customerDropDown.anchorView = vwFullfiledBy
        customerDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblFullfiledBy.text = item
            fulfilledByID = aryFilfilment[index].iD
        }
        customerDropDown.show()
    }
    
    @IBAction func approve(_ sender: Any) {
        let button = sender as! UIButton
        if (order?.editStatusID != 1) {
            if (button == btnAccept) {
                var dictSO = [String: Any]()
                dictSO["ID"] = order?.iD
                dictSO["CreatedBy"] = account?.userID
                dictSO["CompanyID"] = account?.company?.iD
                dictSO["StatusID"] = 2
                dictSO["ApprovedBy"] = account?.userID
                dictSO["ApprovedTo"] = order?.assignedBy
                dictSO["SeriesPrefix"] = order?.seriesPrefix
                dictSO["SeriesPostfix"] = order?.seriesPostfix
                self.addSOApproval(dict: dictSO)
            }else{
                let alert = UIAlertController(title: "Enter Rejection Message", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
                alert.view.autoresizesSubviews = true

                let textView = UITextView(frame: .zero)
                textView.translatesAutoresizingMaskIntoConstraints = false
                textView.font = UIFont.myMediumSystemFont(ofSize: 14)
                textView.tag = 25
                textView.delegate = self
                textView.keyboardType = .default
                textView.returnKeyType = .done

                let leadConstraint = NSLayoutConstraint(item: alert.view!, attribute: .leading, relatedBy: .equal, toItem: textView, attribute: .leading, multiplier: 1.0, constant: -8.0)
                
                let trailConstraint = NSLayoutConstraint(item: alert.view!, attribute: .trailing, relatedBy: .equal, toItem: textView, attribute: .trailing, multiplier: 1.0, constant: 8.0)

                let topConstraint = NSLayoutConstraint(item: alert.view!, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .top, multiplier: 1.0, constant: -46.0)

                let bottomConstraint = NSLayoutConstraint(item: alert.view!, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1.0, constant: 46.0)

                alert.view.addSubview(textView)
                NSLayoutConstraint.activate([leadConstraint, trailConstraint, topConstraint, bottomConstraint])

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] action in
                    var dictSO = [String: Any]()
                    dictSO["ID"] = order?.iD
                    dictSO["CreatedBy"] = account?.userID
                    dictSO["CompanyID"] = account?.company?.iD
                    dictSO["StatusID"] = 3
                    dictSO["ApprovedBy"] = account?.userID
                    dictSO["ApprovedTo"] = order?.assignedBy
                    dictSO["SeriesPrefix"] = order?.seriesPrefix
                    dictSO["SeriesPostfix"] = order?.seriesPostfix
                    dictSO["RejectMessage"] = textView.text.escapeUnicodeString()
                    self.addSOApproval(dict: dictSO)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else {
            if (button == btnAccept) {
                var dictSO = [String: Any]()
                dictSO["ID"] = order?.iD
                dictSO["CreatedBy"] = account?.userID
                dictSO["CompanyID"] = account?.company?.iD
                dictSO["StatusID"] = 2
                dictSO["EditStatusID"] = 2
                dictSO["ApprovedBy"] = account?.userID
                dictSO["ApprovedTo"] = order?.assignedBy
                dictSO["SeriesPrefix"] = order?.seriesPrefix
                dictSO["SeriesPostfix"] = order?.seriesPostfix
                if strTransaction != nil {
                    dictSO["salesordetTransactionID"] = strTransaction ?? ""
                }
                self.editApproval(dict: dictSO)
            }else{
                let alert = UIAlertController(title: "Enter Rejection Message", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
                alert.view.autoresizesSubviews = true

                let textView = UITextView(frame: .zero)
                textView.translatesAutoresizingMaskIntoConstraints = false
                textView.font = UIFont.myMediumSystemFont(ofSize: 14)
                textView.tag = 25
                textView.delegate = self
                textView.keyboardType = .default
                textView.returnKeyType = .done

                let leadConstraint = NSLayoutConstraint(item: alert.view!, attribute: .leading, relatedBy: .equal, toItem: textView, attribute: .leading, multiplier: 1.0, constant: -8.0)
                
                let trailConstraint = NSLayoutConstraint(item: alert.view!, attribute: .trailing, relatedBy: .equal, toItem: textView, attribute: .trailing, multiplier: 1.0, constant: 8.0)

                let topConstraint = NSLayoutConstraint(item: alert.view!, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .top, multiplier: 1.0, constant: -46.0)

                let bottomConstraint = NSLayoutConstraint(item: alert.view!, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1.0, constant: 46.0)

                alert.view.addSubview(textView)
                NSLayoutConstraint.activate([leadConstraint, trailConstraint, topConstraint, bottomConstraint])

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] action in
                    var dictSO = [String: Any]()
                    dictSO["ID"] = order?.iD
                    dictSO["CreatedBy"] = account?.userID
                    dictSO["CompanyID"] = account?.company?.iD
                    dictSO["StatusID"] = 3
                    dictSO["EditStatusID"] = 3
                    dictSO["ApprovedBy"] = account?.userID
                    dictSO["ApprovedTo"] = order?.assignedBy
                    dictSO["SeriesPrefix"] = order?.seriesPrefix
                    dictSO["SeriesPostfix"] = order?.seriesPostfix
                    dictSO["RejectMessage"] = textView.text.escapeUnicodeString()
                    if strTransaction != nil {
                        dictSO["salesordetTransactionID"] = strTransaction ?? ""
                    }
                    self.editApproval(dict: dictSO)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    fileprivate func addSOApproval(dict: [String: Any]) {
        var maindict = [String: Any]();
        maindict["approveRejectSalesOrderJson"] = dict.rs_jsonString(withPrettyPrint:true)
        maindict["UserID"] = account?.userID
        maindict["TokenID"] = account?.securityToken

        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        RestAPIManager.httpRequest(ConstantURL.approveRejectSalesOrder, .post, parameters: maindict, isTeamWorkUrl: true, isFull: true) { response, success, error in
            SVProgressHUD.dismiss()
            if error == nil {
                guard let result = response as? [String: Any]?, let status = result?["status"] as? String else {
                    return
                }
                if (status == "Success") {
                    self.view.window?.makeToast(result?["message"] as? String ?? "")
                    self.delegate?.successfullySaveOrUpdateSO()
                    self.navigationController?.popViewController(animated: true)
                }else if (status == "Error"){
                    self.view.window?.makeToast(result?["message"] as? String ?? "")
                }else if (status == "Invalid Token"){
                    self.view.window?.makeToast(result?["message"] as? String ?? "")
//                    [[AppDelegate appDelegate] logout];
                }
            }else {
                self.view.window?.makeToast(error?.localizedDescription)
            }
        }
    }
    
    fileprivate func editApproval(dict: [String: Any]) {
        var maindict = [String: Any]();
        maindict["approveRejectEditSalesOrderJson"] = dict.rs_jsonString(withPrettyPrint:true)
        maindict["UserID"] = account?.userID
        maindict["TokenID"] = account?.securityToken

        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        RestAPIManager.httpRequest(ConstantURL.approveRejectEditSalesOrder, .post, parameters: maindict, isTeamWorkUrl: true, isFull: true) { response, success, error in
            SVProgressHUD.dismiss()
            if error == nil {
                if let result = response as? [String: Any], let status = result["status"] as? String {
                    if (status == "Success") {
                        self.view.window?.makeToast(result["message"] as? String ?? "")
                        self.delegate?.successfullySaveOrUpdateSO()
                        self.navigationController?.popViewController(animated: true)
                    }else if (status == "Error"){
                        self.view.window?.makeToast(result["message"] as? String ?? "")
                    }else if (status == "Invalid Token"){
                        self.view.window?.makeToast(result["message"] as? String ?? "")
                        //                    [[AppDelegate appDelegate] logout];
                    }
                }
            }else {
                self.view.window?.makeToast(error?.localizedDescription)
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
    func salesOrderFromLead(tempLead: Lead) {
        self.txtPropLdSel.text = "ID:\(tempLead.seriesPrefix ?? "")\(tempLead.seriesPostfix) \(tempLead.customerName ?? "")"
        isProduct = false
        isService = false
        for pl in tempLead.productList{
            if let d = pl as? ProductsList, d.productID > 0 {
                let p = Product.getProduct(productID: NSNumber(value: d.productID ))
                if (d.categoryType == 1){
                    isProduct = true;
                }else{
                    isService = true;
                }
                var taxTp = "";
                if (customer?.taxType == "VAT") {
                    if (setting.manageSGST==1) {
                        taxTp = "VAT";
                    }else{
                        taxTp = "";
                    }
                }else if(customer?.taxType == "CST"){
                    if (setting.manageIGST==1) {
                        taxTp = "CST";
                    }else{
                        taxTp = "";
                    }
                }else{
                    taxTp = "";
                }
                let psc = ProdCategory.getProductByCatID(catId: NSNumber(value: p?.productSubCatId ?? 0))
                var vatID = 0;
                var VATFrom = "";
                //Asian Paint
                if (account?.company?.iD == 1130) {
                    //Product ID - Low Cost Mixture
                    if (d.productID == 21594) {
                        //Set Warranty ID to 7011111
                        txtWarranty.text = "7011111";
                        txtWarranty.isEnabled = false;
                    }
                }
                let product = SelectedProduct()
                if (psc != nil) {
                    if taxTp == "VAT" {
                        if setting.manageCGST == 1 {
                            product.CGSTTax = psc?.cGSTTax ?? 0
                        }else{
                            product.CGSTTax = 0.0
                        }
                        
                        if setting.manageSGST == 1 {
                            product.SGSTTax = psc?.sGSTTax ?? 0
                        }else{
                            product.SGSTTax = 0.0
                        }

                        if setting.manageIGST == 1 {
                            product.IGSTTax = psc?.iGSTTax ?? 0
                        }else{
                            product.IGSTTax = 0.0
                        }
                    }
                    if setting.vatCodeFrom == 1{
                        if psc?.vATCode != nil {
                            vatID = Int(psc?.vATCode ?? 0)
                        }else{
                            if (customer?.vATCode ?? 0) >= 0 {
                                vatID = Int(customer?.vATCode ?? 0)
                            }else {
                                vatID = 0
                            }
                        }
                    }
                    VATFrom = setting.vatCodeFrom == 1 ? "P" : "C"
                    product.productName = p?.productName
                    product.productID = NSNumber(value: d.productID)
                    product.quantity = "\(d.quantity)"
                    product.price = "\(p?.price ?? 0)"
                    product.salesDiscount = "\(p?.salesDiscount ?? 0.0)"
                    product.taxType = taxTp
                    product.disType = setting.discountType?.int8Value ?? 0
                    product.disInPerVal = 1
                    product.vatID = Int16(psc?.vAT ?? 0)
                }else{
                    let psc1 = ProductSubCat.getSubCatProduct(subcatid: NSNumber(value: p?.productSubCatId ?? 0))
                    if (psc1 != nil) {
                        if taxTp == "VAT" {
                            product.taxType = "VAT"
                            if setting.manageCGST == 1 {
                                product.CGSTTax = psc1?.cGSTTax ?? 0
                            }else{
                                product.CGSTTax = 0.0
                            }
                            
                            if setting.manageSGST == 1 {
                                product.SGSTTax = psc1?.sGSTTax ?? 0
                            }else{
                                product.SGSTTax = 0.0
                            }

                            if setting.manageIGST == 1 {
                                product.IGSTTax = psc1?.iGSTTax ?? 0
                            }else{
                                product.IGSTTax = 0.0
                            }
                        }else if taxTp == "CST"{
                            product.taxType = "CST"
                        }else{
                            product.taxType = ""
                        }
                        if setting.vatCodeFrom == 1{
                            if psc1?.vATCode != nil {
                                vatID = Int(psc1?.vATCode ?? 0)
                            }else{
                                if (customer?.vATCode ?? 0) >= 0 {
                                    vatID = Int(customer?.vATCode ?? 0)
                                }else {
                                    vatID = 0
                                }
                            }
                        }
                        VATFrom = setting.vatCodeFrom == 1 ? "P" : "C"
                        product.productName = p?.productName
                        product.productID = NSNumber(value: d.productID)
                        product.quantity = "\(d.quantity)"
                        product.price = "\(p?.price ?? 0)"
                        product.salesDiscount = "\(p?.salesDiscount ?? 0.0)"
                        product.disType = setting.discountType?.int8Value ?? 0
                        product.disInPerVal = 1
                        product.vatID = Int16(psc1?.vAT ?? 0)
                    }
                }
                product.customerClass = Int(customer?.customerClass ?? 0)
                product.disA = p?.discountA ?? 0.0
                product.disB = p?.discountB ?? 0.0
                product.disC = p?.discountC ?? 0.0
                product.isAllow = false
                product.isFirstStep = false
                product.isVat = (setting.vatGst==2 ? true : false)
                product.vatID = Int16(vatID)
                product.vATFrom = VATFrom
                product.maxdiscount = "\(p?.maxdiscount ?? 0.0)"
                aryProductList.append(product)
            }
        }
        if setting.productMandatoryInLead == 0 && aryProductList.count == 0 {
            self.view.window?.makeToast("select product")
            return
        }
    }
}

extension AddEditSalesOrderVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if txtCustomerSel == textField{
            let lstCustomers = CustomerDetails.getAllCustomerBySearch(searchString: updatedText)
            customerDropDown.dataSource = lstCustomers?.map {$0.name ?? ""} ?? []
            customerDropDown.anchorView = txtCustomerSel
            customerDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.txtCustomerSel.text = item
                
                if let selectedcustomer = lstCustomers?[index]{
                    customer = selectedcustomer
                    if(AddEditSalesOrderVC.productDriveIDSInNumber.count == 0){
                        self.getProductDriveList()
                    }
                    print(selectedcustomer)
                    aryProductList.removeAll()
                    self.tableView.reloadData()
                }
            }
            customer = nil
            customerDropDown.show()
        }else if (textField == txtWarranty && setting.sORequireWarrantyAndDealerCode == 1 && setting.enableWarrantyIDValidation == 1) {
            if (updatedText.count <= 7) {
                return true
            }else{
                return false
            }
        }else if (textField == txtDeliveryDays) {
            if (updatedText.count <= 3) {
                return true
            }else{
                return false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPropLdSel{
            textField.resignFirstResponder()
            if !(btnLeadProposal.first!.isSelected) {
                customerDropDown.dataSource = lstLeads.map {"ID:\($0.seriesPrefix ?? "")\($0.seriesPostfix) \($0.customerName ?? "")"}
                customerDropDown.anchorView = txtPropLdSel
                customerDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    let tempLead = lstLeads[index]
                    lead = tempLead
                    self.txtPropLdSel.text = item
                    customer = CustomerDetails.getCustomerByID(cid: NSNumber(value: tempLead.customerID))
                    self.salesOrderFromLead(tempLead: tempLead)
                }
            }else{
                customerDropDown.dataSource = lstProposal.map {"ID:\($0.seriesPrefix)\($0.seriesPostfix) \($0.customerName)"}
                customerDropDown.anchorView = txtPropLdSel
                customerDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    let tempProposal = lstProposal[index]
                    proposal = tempProposal
                    self.txtPropLdSel.text = item
                    customer = CustomerDetails.getCustomerByID(cid: NSNumber(value: tempProposal.customerID))
                    isProduct = false
                    isService = false
                    for pl in tempProposal.productList{
                        if let d = pl as? ProposlProduct {
                            let p = Product.getProduct(productID: NSNumber(value: d.productID ))
                            if (d.categoryType == 1){
                                isProduct = true;
                            }else{
                                isService = true;
                            }
                            var taxTp = "";
                            if (customer?.taxType == "VAT") {
                                if (setting.manageSGST==1) {
                                    taxTp = "VAT";
                                }else{
                                    taxTp = "";
                                }
                            }else if(customer?.taxType == "CST"){
                                if (setting.manageIGST==1) {
                                    taxTp = "CST";
                                }else{
                                    taxTp = "";
                                }
                            }else{
                                taxTp = "";
                            }
                            let psc = ProdCategory.getProductByCatID(catId: NSNumber(value: p?.productSubCatId ?? 0))
                            var vatID = 0;
                            var VATFrom = "";
                            //Asian Paint
                            if (account?.company?.iD == 1130) {
                                //Product ID - Low Cost Mixture
                                if (d.productID == 21594) {
                                    //Set Warranty ID to 7011111
                                    txtWarranty.text = "7011111";
                                    txtWarranty.isEnabled = false;
                                }
                            }
                            let product = SelectedProduct()
                            if (psc != nil) {
                                if taxTp == "VAT" {
                                    if setting.manageCGST == 1 {
                                        product.CGSTTax = psc?.cGSTTax ?? 0
                                    }else{
                                        product.CGSTTax = 0.0
                                    }
                                    
                                    if setting.manageSGST == 1 {
                                        product.SGSTTax = psc?.sGSTTax ?? 0
                                    }else{
                                        product.SGSTTax = 0.0
                                    }

                                    if setting.manageIGST == 1 {
                                        product.IGSTTax = psc?.iGSTTax ?? 0
                                    }else{
                                        product.IGSTTax = 0.0
                                    }
                                }
                                if setting.vatCodeFrom == 1{
                                    if psc?.vATCode != nil {
                                        vatID = Int(psc?.vATCode ?? 0)
                                    }else{
                                        if (customer?.vATCode ?? 0) >= 0 {
                                            vatID = Int(customer?.vATCode ?? 0)
                                        }else {
                                            vatID = 0
                                        }
                                    }
                                }
                                VATFrom = setting.vatCodeFrom == 1 ? "P" : "C"
                                product.productName = p?.productName
                                product.productID = NSNumber(value: d.productID)
                                product.quantity = "\(d.quantity)"
                                product.price = "\(p?.price ?? 0)"
                                product.salesDiscount = "\(p?.salesDiscount ?? 0.0)"
                                product.taxType = taxTp
                                product.disType = setting.discountType?.int8Value ?? 0
                                product.disInPerVal = 1
                                product.vatID = Int16(psc?.vAT ?? 0)
                            }else{
                                let psc1 = ProductSubCat.getSubCatProduct(subcatid: NSNumber(value: p?.productSubCatId ?? 0))
                                if (psc1 != nil) {
                                    if taxTp == "VAT" {
                                        product.taxType = "VAT"
                                        if setting.manageCGST == 1 {
                                            product.CGSTTax = psc1?.cGSTTax ?? 0
                                        }else{
                                            product.CGSTTax = 0.0
                                        }
                                        
                                        if setting.manageSGST == 1 {
                                            product.SGSTTax = psc1?.sGSTTax ?? 0
                                        }else{
                                            product.SGSTTax = 0.0
                                        }

                                        if setting.manageIGST == 1 {
                                            product.IGSTTax = psc1?.iGSTTax ?? 0
                                        }else{
                                            product.IGSTTax = 0.0
                                        }
                                    }else if taxTp == "CST"{
                                        product.taxType = "CST"
                                    }else{
                                        product.taxType = ""
                                    }
                                    if setting.vatCodeFrom == 1{
                                        if psc1?.vATCode != nil {
                                            vatID = Int(psc1?.vATCode ?? 0)
                                        }else{
                                            if (customer?.vATCode ?? 0) >= 0 {
                                                vatID = Int(customer?.vATCode ?? 0)
                                            }else {
                                                vatID = 0
                                            }
                                        }
                                    }
                                    VATFrom = setting.vatCodeFrom == 1 ? "P" : "C"
                                    product.productName = p?.productName
                                    product.productID = NSNumber(value: d.productID)
                                    product.quantity = "\(d.quantity)"
                                    product.price = "\(p?.price ?? 0)"
                                    product.salesDiscount = "\(p?.salesDiscount ?? 0.0)"
                                    product.disType = setting.discountType?.int8Value ?? 0
                                    product.disInPerVal = 1
                                    product.vatID = Int16(psc1?.vAT ?? 0)
                                }
                            }
                            product.customerClass = Int(customer?.customerClass ?? 0)
                            product.disA = p?.discountA ?? 0.0
                            product.disB = p?.discountB ?? 0.0
                            product.disC = p?.discountC ?? 0.0
                            product.isAllow = false
                            product.isFirstStep = false
                            product.isVat = (setting.vatGst==2 ? true : false)
                            product.vatID = Int16(vatID)
                            product.vATFrom = VATFrom
                            product.maxdiscount = "\(p?.maxdiscount ?? 0.0)"
                            aryProductList.append(product)
                        }
                    }
                }
            }
            customerDropDown.show()
        }
    }
}

extension AddEditSalesOrderVC: MultipleProductSelectionDelegate {
    func addProductFromMultipleSelection(product: SelectedProduct) {
        self.addProduct1(product: product)
    }
    
}

extension AddEditSalesOrderVC: ProductSelectionDelegate {
    func addProduct1(product: SelectedProduct) {
        Utils.removeShadow(view: self.view)
        
        for p in aryProductList {
            if (p.productID == product.productID) {
                self.view?.makeToast("You can't add one product multiple time.")
                return;
            }
        }
            //Asian Paint
        if (account?.company?.iD == 1130) {
                //Product ID - Low Cost Mixture
            if product.productID == 21594 {
                    //Set Warranty ID to 7011111
                txtWarranty.text = "7011111";
                txtWarranty.isEnabled = false;
            }
        }

        let p = Product.getProduct(productID: product.productID!)
        let psc = ProdCategory.getProductByCatID(catId: NSNumber(value: p?.productSubCatId ?? 0))

        if (customer?.taxType == "VAT") {
            if (setting.manageSGST==1) {
                product.taxType = "VAT"
            }
        }else if(customer?.taxType == "CST"){
            if (setting.manageIGST==1) {
                product.taxType = "CST"
            }
        }
        if (psc != nil) {
            product.vatID = setting.vatCodeFrom == 1 ? psc?.vATCode : customer?.vATCode
            product.SGSTTax = setting.manageSGST == 1 ? Double(psc?.sGSTTax ?? 0) : 0.0
            product.CGSTTax = setting.manageCGST == 1 ? Double(psc?.cGSTTax ?? 0) : 0.0
            product.IGSTTax = setting.manageIGST == 1 ? Double(psc?.iGSTTax ?? 0) : 0.0
        }else{
            let psc1 = ProductSubCat.getSubCatProduct(subcatid: NSNumber(value: p?.productSubCatId ?? 0))
            product.vatID = setting.vatCodeFrom == 1 ? psc1?.vATCode : customer?.vATCode
            product.SGSTTax = setting.manageSGST == 1 ? Double(psc1?.sGSTTax ?? 0) : 0.0
            product.CGSTTax = setting.manageCGST == 1 ? Double(psc1?.cGSTTax ?? 0) : 0.0
            product.IGSTTax = setting.manageIGST == 1 ? Double(psc1?.iGSTTax ?? 0) : 0.0
        }
        product.vATFrom = setting.vatCodeFrom == 1 ? "P" : "C"
        product.disType = setting.discountType?.int8Value ?? 1
        product.disInPerVal = 1
        product.customerClass = Int(customer?.customerClass ?? 1)
        product.disA = p?.discountA ?? 0.0
        product.disB = p?.discountB ?? 0.0
        product.disC = p?.discountC ?? 0.0
        product.maxdiscount = "\(p?.maxdiscount ?? 0.0)"
        product.salesDiscount = "\(p?.salesDiscount ?? 0.0)"
        product.price = "\(p?.price ?? 0.0)"
        product.isAllow = false
        product.isFirstStep = false
        product.isVat = setting.vatGst == 2 ? true : false

        aryProductList.append(product)
        self.tableView.reloadData()
    }
    
}

extension AddEditSalesOrderVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryProductList.count + (selectedPromotion?.freeBonusProductList.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrderProductCell
        if indexPath.row >= aryProductList.count {
            if let soProduct = selectedPromotion?.freeBonusProductList[indexPath.row - aryProductList.count] {
                cell.cellBonusPromotionConfigure(dict: soProduct)
                // False
                cell.tempView.isHidden = true
                for x in cell.stackView.arrangedSubviews {
                    x.isHidden = true
                }
                cell.lblProductNm.isHidden = true
                cell.btnDelete.isHidden = true
                cell.btnCollapse.isHidden = true
                cell.contentView.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.6392156863, blue: 0.2039215686, alpha: 1)
                cell.contentView.cornerRadius = 6.0
                cell.cnstBtnAmtTop.constant = -24
                cell.cnstBtnAmtHeight.constant = 0
            }
            return cell
        }
        cell.cnstBtnAmtTop.constant = 16
        cell.cnstBtnAmtHeight.constant = 34
        cell.btnCollapse.isHidden = false
        cell.contentView.backgroundColor = .clear
        cell.configuareUI(s: setting)
        cell.selectionStyle = .none
        cell.deleteAction = { sender in
            self.deleteSO(index: indexPath.row)
        }
        if (setting.priceEditable == 1) {
            cell.txtPrice.isUserInteractionEnabled = true;
        }
        let soProducts = aryProductList[indexPath.row]
        if (selectedPromotion != nil) {
            self.cellObjectUserInteractionEnabled(isEnable: false, cell: cell)
        }else{
            self.cellObjectUserInteractionEnabled(isEnable: true, cell: cell)
        }
        if !soProducts.isExpand {
            // False
            cell.tempView.isHidden = true
            for x in cell.stackView.arrangedSubviews {
                x.isHidden = true
            }
            cell.lblProductNm.isHidden = true
            cell.btnDelete.isHidden = true
        }else{
            // True
            cell.tempView.isHidden = false
            for x in cell.stackView.arrangedSubviews {
                x.isHidden = false
            }
            cell.lblProductNm.isHidden = false
            cell.btnDelete.isHidden = false
            cell.lblProductNmTemp.text = ""
            cell.layoutIfNeeded()
        }
        cell.blockCollapse = { sender in
            soProducts.isExpand = !soProducts.isExpand
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        cell.blockValueChanged = { (i, value) in
            if i == 1 {
                soProducts.price = value
            }else if i == 2 {
                soProducts.quantity = value
            }else if i == 3 {
                soProducts.salesDiscount = value
            }else if i == 4 {
                soProducts.salesDiscount = value
            }
        }
        
        cell.cellConfiguare(dict: soProducts) { (cell, forceReload) in
            print("Block call")
            let price = Double(soProducts.price ?? "") ?? 0.0
            let qty = Int(soProducts.quantity ?? "") ?? 0
            let discount = Double(soProducts.salesDiscount ?? "") ?? 0.0
            cell.lblProAmt.text = String(format: "%.2f", (price * Double(qty)))
            cell.lblProDis.text = String(format: "%.2f", ((price * Double(qty) * discount) / 100))
            
            let proAmt = Double(cell.lblProAmt.text ?? "") ?? 0.0
            let proDis = Double(cell.lblProDis.text ?? "") ?? 0.0
            cell.lblAmtAfterDiscount.text = String(format:"%.2f", (proAmt - proDis))
            
            soProducts.price = "\(price)"
            soProducts.quantity = "\(qty)"
//            soProducts.salesDiscount = "\(discount)"
            soProducts.focQuantity = Int64(cell.txtFOC.text ?? "") ?? 0
            
            cell.lblNetAmt.text = String(format: "%.2f", (cell.lblAmtAfterDiscount.text!.toDouble() + cell.lblSGSTAmt.text!.toDouble() + cell.lblCGSTAmt.text!.toDouble()))
            
            if (cell.btnDisCat.first!.isSelected) {
                soProducts.disInPerVal = 1
            }else{
                soProducts.disInPerVal = 2
            }
            if (cell.btnAddiSwitch.isSelected){
                soProducts.isAllow = true
            }else {
                soProducts.isAllow = false
                soProducts.isFirstStep = false
            }
            if (cell.btnStep1.isSelected) {
                soProducts.isFirstStep = true
            }else{
                soProducts.isFirstStep = false
            }
            if (cell.btnFOCSwitch.isSelected) {
                soProducts.isFOC = true
            }else{
                soProducts.isFOC = false
                soProducts.focQuantity = 0
            }
            if forceReload {
                tableView.reloadData()
            }else{
                cell.cellConfiguare1(dict: soProducts)
                self.calculateNetAmt()
            }
        }
        if !soProducts.isExpand {
            cell.cellSmallConfigure(s: setting, dict: soProducts)
            cell.layoutIfNeeded()
        }
        cell.btnDelete.isHidden = order?.statusID == 7 ? true : false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == tableView.indexPathsForVisibleRows?.last?.row ?? 0) {
            //end of loading
            //for example [activityIndicator stopAnimating];
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // your function here
                self.calculateNetAmt()
            }
        }
    }
}

extension AddEditSalesOrderVC: AddCustomerDelegate {
    func saveCustomer(customerID: NSNumber, customerName: String, contactID: NSNumber) {
        txtCustomerSel.text  =  customerName
        
        if let selectedtempCustomer = CustomerDetails.getCustomerByID(cid: customerID) {
            customer = selectedtempCustomer
            aryProductList.removeAll()
            self.tableView.reloadData()
        }
    }
    
}

extension AddEditSalesOrderVC: PopUpDelegateNonMandatory {
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        
        if let selectedcustomer = arr.first {
            customer = selectedcustomer
            txtCustomerSel.text = selectedcustomer.name
            if(AddEditSalesOrderVC.productDriveIDSInNumber.count == 0){
                self.getProductDriveList()
            }
            if (self.setting.showProductDrive == 1) {
                self.getProductDrive()
            }
            aryProductList.removeAll()
            self.tableView.reloadData()
        }
    }

    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        if let u = arr.first {
            let text = String(format: "%@ %@", u.firstName, u.lastName)
            if (assignTo == u.entity_id) {
                self.view.window?.makeToast("This sales order is already assigned to \(text)")
            } else {
                var jsonParameters = [String: Any]()
                jsonParameters["ID"] = order?.iD
                jsonParameters["CreatedBy"] = account?.userID
                jsonParameters["CompanyID"] = account?.company?.iD
                jsonParameters["AssignedTo"] = u.entity_id
                jsonParameters["SeriesPrefix"] = order?.seriesPrefix
                jsonParameters["SeriesPostfix"] = order?.seriesPostfix
                var maindict = [String: Any]()
                maindict["inputjson"] = jsonParameters.rs_jsonString(withPrettyPrint: true)
                maindict["UserID"] = account?.userID
                maindict["TokenID"] = account?.securityToken

                SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
                RestAPIManager.httpRequest(ConstantURL.assignedSalesOrder, .post, parameters: maindict, isTeamWorkUrl: true, isFull: true) { [self] response, success, error in
                    SVProgressHUD.dismiss()
                    guard let result = response as? [String: Any]?, let status = result?["status"] as? String else {
                        return
                    }
                    if error == nil {
                        if (status == "Success") {
                            assignTo = u.entity_id
                            self.view.window?.makeToast(result?["message"] as? String ?? "")
                            order?.assignedTo = assignTo?.int64Value ?? 0
                            order?.managedObjectContext?.mr_saveToPersistentStore(completion: { contextDidSave, error in
                                self.navigationController?.popViewController(animated: true)
                            })
                        }else if (status == "Error"){
                            self.view.window?.makeToast(result?["message"] as? String ?? "")
                        }else if (status == "Invalid Token"){
                            self.view.window?.makeToast(result?["message"] as? String ?? "")
        //                    [[AppDelegate appDelegate] logout];
                        }
                    }else {
                        self.view.window?.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
    }

}

extension AddEditSalesOrderVC: SOPromotionListDelegate {
    func returnPromotionIndex(promotionRow: NSInteger) {
        selectedPromotion = promotionList[promotionRow];
        lblPromosionName.text = String(format: "   %@ - promotion is applied", selectedPromotion?.promotionTitle ?? "");
        isPromotionApplied = false
        self.calculateNetAmt()
        for cell in tableView.visibleCells {
            self.cellObjectUserInteractionEnabled(isEnable: false, cell: cell as! OrderProductCell)
        }
    }
    
}

extension AddEditSalesOrderVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n" && textView.tag==25){
            textView.resignFirstResponder()
            return false
        }else if (textView.text.count + (text.count - range.length) <= 100 || textView.tag==25){
            return true
        }
        return false
    }
    
}

extension Array where Element: Hashable {
    func intersection(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.intersection(otherSet))
    }
}
