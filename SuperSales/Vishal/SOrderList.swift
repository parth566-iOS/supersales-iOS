//
//  SOrderList.swift
//  SuperSales
//
//  Created by Apple on 27/06/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import Foundation
import SVProgressHUD

class SOrderList: BaseViewController {
    @IBOutlet weak var btnPurchaseOrder: UIButton!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var lstSOrder = [SOrder]()

    // Setting for user
    let setting = Utils().getActiveSetting()
    let account = Utils().getActiveAccount()
    
    fileprivate lazy private(set) var filterMenu: [FTPopOverMenuModel] = {
        var menus = [FTPopOverMenuModel]()
        for x in [NSLocalizedString("by_customer", comment:""),NSLocalizedString("by_products", comment:""),"By Sales Person",NSLocalizedString("by_product_category", comment:""),NSLocalizedString("by_created_by", comment:""),NSLocalizedString("all", comment:""),"By Pending Despatch"] {
            let menu = FTPopOverMenuModel(title: x, image: nil, selected: false)
            menus.append(menu)
        }
        return menus
    }()

    fileprivate lazy private(set) var sortMenu: [FTPopOverMenuModel] = {
        var menus = [FTPopOverMenuModel]()
        for x in ["By Customer","ASC Sales Order No","DESC Sales Order No","By Order Created"] {
            let menu = FTPopOverMenuModel(title: x, image: nil, selected: false)
            menus.append(menu)
        }
        return menus
    }()
    
    lazy var createdDateFormatter:DateFormatter = {
        let df = DateFormatter()
        df.timeZone = TimeZone.init(secondsFromGMT:0)
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return df
    }()
    
    var popup:CustomerSelection? = nil

    lazy var arrOfCustomers:[CustomerDetails] = {
        return CustomerDetails.getAllCustomers()
    }()
    lazy var arrOfProduct:[Product] = {
        return Product.getAll()
    }()
    lazy var arrProductCatrgory:[ProdCategory] = {
        return ProdCategory.getAll()
    }()
    lazy var arrOfExecutive:[CompanyUsers] = {
        return [CompanyUsers]()
    }()
    lazy var arrOfSelectedExecutive:[CompanyUsers] = {
        return [CompanyUsers]()
    }()
    lazy var arrOfSegment:[CustomerSegment] = {
        return CustomerSegment.getAll()
    }()
    
    var filterUser = 0
    var customerID = 0
    var productID = 0
    var productCategoryID = 0
    var sortType:String? = nil
    var sd: Date?
    var ed: Date?
    lazy var filterDatepicker:UIDatePicker = {
        let dp = UIDatePicker(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200 , width: self.view.frame.size.width, height: 200))
        dp.setCommonFeature()
        dp.maximumDate = Date()
        return dp
    }()
    
    override func viewDidLoad() {
        self.tblView.rowHeight = UITableView.automaticDimension;
        self.tblView.estimatedRowHeight = 100.0; // set to whatever your "average" cell height is
        if (Int(truncating: account?.role?.id ?? 0) > 7) {
            btnPurchaseOrder.isHidden = true
            lblTemp.isHidden = true
        }
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            // Do any additional setup after loading the view.
            super.viewDidLoad()
            
            self.salesPlandelegateObject = self

            self.tblView.addPullToRefresh { [self] in
                sd = nil
                ed = nil
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.getSalesOrderFromDB()
            }
            self.tblView.isHidden = true
            self.getSalesOrderFromDB()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.tblView.isHidden = false
                self.getSalesOrderFromDB()
            })
        })
        // Do any additional setup after loading the view.
    }
    
    /**
     This method fetches list Sales order from corr data DB
     */
    fileprivate func getSalesOrderFromDB() {
        self.lstSOrder.removeAll()
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        if (filterUser == 0 && customerID == 0 && productID == 0 && productCategoryID == 0 && sd == nil) {
            lstSOrder.append(contentsOf: SOrder.getAll())
        }else if (filterUser > 0){
            lstSOrder.append(contentsOf: SOrder.getFilteredByAttribute(strAttributeName: "createdBy", withSortAttribute: sortType, withValue: [filterUser], withSortType: true))
        }else if (customerID > 0){
            lstSOrder.append(contentsOf: SOrder.getFilteredByAttribute(strAttributeName: "customerID", withSortAttribute: sortType, withValue: [customerID], withSortType: true))
        }else if (productID > 0){
            lstSOrder.append(contentsOf: SOrder.getFilteredByAttributesComplex2(productIDs: [NSNumber(value: productID)]))
        }else if (productCategoryID > 0){
            lstSOrder.append(contentsOf: SOrder.getFilteredByAttributesComplex2(productIDs: (Product.getProductIdFromCategoryID(catID: NSNumber(value:productCategoryID)).map {NSNumber(value: $0.productId)})))
        }else if(sd != nil) {
            lstSOrder.append(contentsOf: SOrder.getAll().filter({ (order) in
                let createdDate = Utils.getDateFromStringWithFormat(gmtDateString: order.createdTime)
                return Utils.date(date: createdDate, beginDate: self.sd!, endDate: self.ed!)
            }))
        }
        SVProgressHUD.dismiss()
        self.tblView.pullToRefreshView.stopAnimating()
        tblView.reloadData()
    }
        
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        self.filterUser = 0
        self.customerID = 0
        self.productID = 0
        self.productCategoryID = 0
        sd = nil
        ed = nil
        FTPopOverMenu.showForSender(sender: sender, with: filterMenu, popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration) { (index) in
            switch index{
            case 0:
                //by customer
                self.openFilterPopup(title: "" ,viewFor:ViewFor.customer,leftTitle: "REFRESH", isSearchBarRequire: true)
                self.popup?.arrOfList = self.arrOfCustomers
                self.popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
                Utils.addShadow(view: self.view)
                self.present(self.popup!, animated: false, completion: nil)
                break
                
            case 1:
                //by product
                self.openFilterPopup(title: "" ,viewFor:ViewFor.product, isSearchBarRequire: true)
                self.popup?.arrOfProduct = self.arrOfProduct
                Utils.addShadow(view: self.view)
                self.present(self.popup!, animated: false, completion: nil)
                break
                
            case 2:
                //by user
                
                self.openFilterPopup(title: "Select User", viewFor:ViewFor.companyuser, leftTitle: "Ok", rightTitle: "Cancel",selectionMode: .single)

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
//                self.arrOfExecutive = self.lowerUser
                self.popup?.arrOfExecutive = self.arrOfExecutive
                self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive
                Utils.addShadow(view: self.view)
                self.present(self.popup!, animated: false, completion: nil)
                break
                
            case 3:
                //by product category
                self.openFilterPopup(title: "", viewFor:ViewFor.productcategory, isSearchBarRequire: true)
                self.popup?.arrOfProductCategory = self.arrProductCatrgory
                self.popup?.arrOfSelectedProductCategory = [ProdCategory]()
                self.popup?.viewfor = ViewFor.productcategory
                Utils.addShadow(view: self.view)
                self.present(self.popup!, animated: false, completion: nil)

                break
            case 4:
                //created by
                self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:self.filterDatepicker, textfield: nil, withDateMonth: false)
                break
                
            case 5:
                //All
                self.lstSOrder.removeAll()
                self.filterUser = 0
                self.customerID = 0
                self.productID = 0
                self.productCategoryID = 0
                self.getSalesOrderFromDB()
                return
            case 6:
                //By Despatch
                return
            default:
                print("nothing")
            }
//            Utils.addShadow(view: self.view)
//            self.present(self.popup!, animated: false, completion: nil)
        } cancel: {
            Utils.removeShadow(view: self.view)
        }

    }
    
    func openFilterPopup(title: String? = "", viewFor: ViewFor, leftTitle: String? = "", rightTitle: String? = "", selectionMode: SelectionMode? = SelectionMode.none, isSearchBarRequire: Bool = false) {
        self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        self.popup?.isFromSalesOrder =  false
        self.popup?.nonmandatorydelegate = self
        self.popup?.modalPresentationStyle = .overCurrentContext
        self.popup?.isFilterRequire = false
        self.popup?.strTitle = title
        self.popup?.selectionmode = selectionMode
        self.popup?.strLeftTitle = leftTitle ?? ""
        self.popup?.strRightTitle = rightTitle ?? ""
        self.popup?.viewfor = viewFor
        self.popup?.isSearchBarRequire = isSearchBarRequire
    }
    
    @IBAction func btnSortClicked(_ sender: UIButton) {
        FTPopOverMenu.showForSender(sender: sender, with: sortMenu, popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration) { (index) in
            switch index{
            case 0:
                self.sortType = "customerName"
                self.lstSOrder = self.lstSOrder.sorted { $0.customerName.lowercased() < $1.customerName.lowercased() }
                break
            case 1:
                self.sortType = "seriesPostfix"
                self.lstSOrder = self.lstSOrder.sorted {
                    $0.seriesPostfix < $1.seriesPostfix
                }
                break
            case 2:
                self.sortType = "seriesPostfix"
                self.lstSOrder = self.lstSOrder.sorted {
                    $0.seriesPostfix > $1.seriesPostfix
                }
                break
            case 3:
                self.sortType = "createdTime"
                self.lstSOrder.sort(by: { (s1, s2) -> Bool in
                    let date1 = self.createdDateFormatter.date(from: s1.createdTime)
                    let date2 = self.createdDateFormatter.date(from: s2.createdTime)
                    return date1!.compare(date2!) == .orderedDescending
                })
                break
            default:
                print("default case")
            }
            self.tblView.reloadData()
        } cancel: {
            
        }
    }
    
    // Validate PDF using NSData
    func isValidePDF(pdfData: Data) -> Bool {
        var isPDF = false
        if (pdfData.count >= 1024 ) {
            let startMetaCount = 4, endMetaCount = 5;
                // check pdf data is the NSData with embedded %PDF & %%EOF
            let startPDFData = Data(bytes: UnsafeRawPointer("%PDF"), count: startMetaCount)
            let endPDFData = Data(bytes: UnsafeRawPointer("%%EOF"), count: endMetaCount)
            // startPDFData, endPDFData data are the NSData with embedded in pdfData
            let startRange = pdfData.range(of: startPDFData, options: [], in: Range(NSRange(location: 0, length: 1024)))
            let endRange = pdfData.range(of: endPDFData, options: [], in: Range(NSRange(location: 0, length: pdfData.count)))

            if startRange != nil && startRange?.count == startMetaCount && endRange != nil && endRange?.count == endMetaCount {
                // This assumes the checkstartPDFData doesn't have a specific range in file pdf data
                isPDF = true
            } else {
                isPDF = false
            }
        }
        return isPDF;
    }

        // Download PDF file in asynchronous way and validate pdf file formate.
    func downloadPDFfile(fileName:String, withFileURL url1: String) {
        DispatchQueue.main.async {
            let request = URLRequest(url: URL(string: url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!)
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                SVProgressHUD.dismiss()
                guard let unwrappedData = data else { return }
                //if self.isValidePDF(pdfData: unwrappedData) {
                    DispatchQueue.main.async(execute: {
                        let url = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
                        // write data
                        do {
                            try unwrappedData.write(to: url)
                            let activityItems = [url]
                            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                            activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                                //Delete file
                                do {
                                    try FileManager.default.removeItem(at: url)
                                } catch {
                                    print("json error: \(error)")
                                }
                            }
                            self.present(activityVC, animated: true)
                        }catch {
                            print("json error: \(error)")
                        }
                    })
                //}
            }).resume()
        }
    }
}

extension SOrderList: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstSOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrderCell
        let dict = lstSOrder[indexPath.row]
        cell.configureCell(order: dict, s: setting)
        cell.selectionStyle = .none
        cell.btnDelete.isHidden = account?.roleId == 8 ? true : false;
        cell.delegate = self
        if(dict.statusID==1) {
            cell.vwColor.backgroundColor = UIColor.graphYellowColor;
        } else if(dict.statusID==0) {
            cell.vwColor.backgroundColor = UIColor.graphYellowColor;
        }else if(dict.statusID==2 && dict.editStatusID == 1) {
            cell.vwColor.backgroundColor = UIColor.graphYellowColor
        } else if(dict.statusID==3) {
            cell.vwColor.backgroundColor = UIColor.graphRedColor;
        } else if(dict.statusID==7) {
            cell.vwColor.backgroundColor = UIColor.Appskybluecolor
        }else if(dict.statusID==2) {
            cell.vwColor.backgroundColor = UIColor.Appskybluecolor;
        }
        
        if dict.productDispatchedStatusID == 1 {
            cell.isDespatched = true
            let mySelectedAttributedTitle = NSAttributedString(string: "Despatched",
                                                               attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.06031910787, green: 0.6, blue: 0.3607843137, alpha: 1) , NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.btnDispatch.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
        }else{
            let mySelectedAttributedTitle = NSAttributedString(string: "Despatch Order Item",
                                                               attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.btnDispatch.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
            cell.isDespatched = false
        }
                
        cell.focProducts.removeAll()
        cell.products = nil
        cell.products = dict.soProductList
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objSalesOrder = lstSOrder[indexPath.row]
        if let p = objSalesOrder.soProductList.firstObject as? SOrderProducts, p.gSTEnabled {
            print("Sales Order Details")
            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                vc.delegate = self
                vc.order = objSalesOrder
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }else{
            self.view.window?.makeToast("you can't update previous sales order which has applied VAT/CST")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension SOrderList: OrderCellDelegate {
    func deleteSO(cell: OrderCell) {
        let indexPath = tblView.indexPath(for: cell)
        let objSalesOrder = lstSOrder[indexPath?.row ?? 0]
        if (objSalesOrder.statusID == 1){
            self.view.window?.makeToast("You can't delete pending sales order")
            return;
        }
        let alertController = UIAlertController(title: "SuperSales", message: "Are you sure you want to delete this sales order?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: .default) { (action) in
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            let dict = ["ID": objSalesOrder.iD, "CreatedBy": self.account?.userID ?? 0,"CompanyID": self.account?.company?.iD ?? 0, "SeriesPrefix": objSalesOrder.seriesPrefix,"SeriesPostfix": objSalesOrder.seriesPostfix] as [String : Any]
            let maindict = ["delsalesorderjson": dict.rs_jsonString(withPrettyPrint: true) ?? "","UserID": self.account?.userID ?? 0,"TokenID": self.account?.securityToken ?? ""] as [String : Any]
            RestAPIManager.httpRequest(ConstantURL.delsalesorder, .get, parameters: maindict, isTeamWorkUrl: true,isFull: true) { [self] (response, success, error) in
                SVProgressHUD.dismiss()
                if success {
                    if let res = response as? [String: Any], let st = res["data"] as? Int,st == 1 {
                        self.lstSOrder.remove(at: indexPath?.row ?? 0)
                        let predicate  = NSPredicate(format: "iD == %d", objSalesOrder.iD)
                        SOrder.mr_deleteAll(matching: predicate)
                        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                        tblView.reloadData()
                    }else if let res = response as? [String: Any]{
                        self.view.window?.makeToast(res["message"] as? String)
                    }
                }else{
                    self.view.window?.makeToast(error?.localizedDescription)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
    
    func shareSO(cell: OrderCell) {
        let indexPath = tblView.indexPath(for: cell)
        let objSalesOrder = lstSOrder[indexPath?.row ?? 0]

        let dict = ["ID": objSalesOrder.iD,"CompanyID": self.account?.company?.iD ?? 0] as [String : Any]
        let maindict = ["Application":"SalesPro", "generateSalesOrderPDFJson": dict.rs_jsonString(withPrettyPrint: true) ?? "","UserID": self.account?.userID ?? 0,"TokenID": self.account?.securityToken ?? "","CompanyID": self.account?.company?.iD ?? 0] as [String : Any]
        SVProgressHUD.show(withStatus: "Generating sales order file....")
        RestAPIManager.httpRequest(ConstantURL.generateSOPDF, .post, parameters: maindict, isTeamWorkUrl: true) { (response, success, error) in
            if let result = response as? [String: Any], let pdfUrl = result["PDFPath"] as? String {
                self.downloadPDFfile(fileName: String(format: "%@%ld.pdf", objSalesOrder.seriesPrefix,objSalesOrder.seriesPostfix), withFileURL: pdfUrl)
            }else if let result = response as? [String: Any]{
                SVProgressHUD.dismiss()
                if result["status"] as? String == "Error"{
                    self.view.makeToast(result["message"] as? String)
                }else if result["status"] as? String == "Invalid Token"{
                    self.view.makeToast(result["message"] as? String)
//                    AppDelegate.shared.logout
                }else{
                    self.view.makeToast(error?.localizedDescription)
                }
            }else{
                SVProgressHUD.dismiss()
                self.view.makeToast(error?.localizedDescription)
            }
        }

    }
    
    func dispatchSO(cell: OrderCell) {
        
    }
    
}

extension SOrderList: PopUpDelegateNonMandatory{
    
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedcustomer = arr.first
            customerID = Int(selectedcustomer?.iD ?? 0)
            getSalesOrderFromDB()
        }
    }
    
    func completionProductData(arr: [Product]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            let selectedproduct = arr.first
            productID = Int(selectedproduct?.productId ?? 0)
            getSalesOrderFromDB()
        }
    }
    
    func completionProductCategory(arr: [ProdCategory]) {
        Utils.removeShadow(view: self.view)
        if(arr.count > 0){
            let selectedCategory = arr.first
            productCategoryID = Int(selectedCategory?.iD ?? 0)
            getSalesOrderFromDB()
        }
    }
    
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if(arr.count > 0){
            self.arrOfSelectedExecutive = arr
            let selectedexecutive = arr.first
            
            filterUser = selectedexecutive?.entity_id as? Int ?? 0
            getSalesOrderFromDB()
        }
    }
}

extension SOrderList: AddEditSODelegate {
    func successfullySaveOrUpdateSO() {
        self.getSalesOrderFromDB()
    }
    
}

extension SOrderList:BaseViewControllerDelegate{
    func datepickerSelectionDone(){
        let calender = NSCalendar.current
        let startdt = calender.date(bySettingHour: 0, minute: 0, second: 1, of: filterDatepicker.date)
        sd = startdt
        ed = calender.date(bySettingHour: 23, minute: 23, second: 59, of: filterDatepicker.date)
        self.getSalesOrderFromDB()
    }
    
    func cancelbtnTapped() {
        self.filterDatepicker.removeFromSuperview()
    }
}
