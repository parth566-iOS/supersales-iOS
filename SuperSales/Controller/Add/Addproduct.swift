//
//  Addproduct.swift
//  SuperSales
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import BarcodeScanner
import SVProgressHUD

protocol  ProductSelectionDelegate {
    func addProduct1(product:SelectedProduct)
     
}
protocol PotentialProductDelegate {
    func addpotentialProduct(product:PotentialProduct)
}
class Addproduct: BaseViewController {
 
    var parentviewforpopup:UIView!
    var productselectiondelegate:ProductSelectionDelegate?
    var potentialprodelegate:PotentialProductDelegate?
    var productselectionfrom:ProductSelectionFromView!
    @IBOutlet weak var btnBarcode: UIButton!
    var selectedProduct:Product!
    var isVisit:Bool!
    var isLead:Bool!
    var isLead1:Bool!
    var isCut:Bool!
    var leadId:NSNumber!  = NSNumber.init(value: 0)
    var isProductOrNot:Bool!
    var withServiceFl:Bool!
    var isProduct:Bool!
    var isService:Bool!
    var isProductView:Bool? = false
    var arrProductCatrgory:[ProdCategory]!
    var arrProductSubCategory:[ProductSubCat]!
    var arrProduct:[Product]!
    var selectedProductCatId:NSNumber! = NSNumber.init(value: 0)
    var selectedProductSubCatId:NSNumber! = NSNumber.init(value: 0)
    var selectedProductId:NSNumber! = NSNumber.init(value: 0)
    var price:NSNumber!
    var maxdiscount:NSNumber!
    var isFromProductStock:Bool?
    var isFromSalesOrder:Bool!
    
    @IBOutlet weak var lblProductQuantity: UILabel!
    @IBOutlet var lblProductDiscount: UILabel!
    @IBOutlet var tfProductDiscount: UITextField!
    
    //    var selectedCatId:Int!
    //    var selectedSubCatId:Int!
    //    var selectedProductId:Int!
    @IBOutlet weak var tfProductSubCategory: UITextField!
    
    @IBOutlet weak var tfProduct: UITextField!
    
    @IBOutlet weak var tfProductQuantity: UITextField!
    
    @IBOutlet weak var tfProductBudget: UITextField!
    @IBOutlet weak var tfProductCategory: UITextField!
    
    @IBOutlet weak var btnAddProduct: UIButton!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var lblProductBudget: UILabel!
    
    @IBOutlet weak var vwProductpitched: UIView!
    
    @IBOutlet weak var vwInterestLevel: UIView!
    
    
    @IBOutlet weak var btnPitched: UIButton!
    
    @IBOutlet weak var btnWarm: UIButton!
    @IBOutlet weak var btnHot: UIButton!
    
    @IBOutlet weak var btnCold: UIButton!
    var selectedLevel:Int?
    var chooseProductCategory:DropDown! = DropDown.init()
    var chooseProductSubCategory:DropDown! = DropDown.init()
    var chooseProduct:DropDown! = DropDown.init()
    var selectedProductIndexes:[IndexPath]!
    var barcode = ""
    var barcode1 = ""
    var productCount:Int!
    var customerId:Int64 = 0
    var visitID:Int64 = 0

    var productDriveIDs = [NSNumber]()
    var productStockList = [[String: Any]]()
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    func validation()->Bool{
        if(tfProductCategory.text?.count == 0){
            Utils.toastmsg(message:"Please Select Product Category",view:self.view)
            return false
        }else if(tfProductSubCategory.text?.count == 0){
            Utils.toastmsg(message:"Please Select Product Sub Category",view:self.view)
            return false
        }else{
            return true
        }
        
    }
    func setUI(){
        self.view.setShadow()
        self.btnAddProduct.setbtnFor(title: "Add", type: Constant.kPositive)
        self.btnAddProduct.layer.cornerRadius = 5
        self.tfProductCategory.delegate = self
        self.tfProductSubCategory.delegate = self
        self.tfProduct.delegate = self
        self.tfProductQuantity.delegate = self
        self.tfProductBudget.delegate = self
        
        self.tfProductCategory.setCommonFeature()
        self.tfProductSubCategory.setCommonFeature()
        self.tfProduct.setCommonFeature()
        self.tfProductQuantity.setCommonFeature()
        self.tfProductBudget.setCommonFeature()
        self.tfProductDiscount.setCommonFeature()
        
        
        self.tfProductQuantity.keyboardType = .numberPad
        self.tfProductBudget.keyboardType = .numberPad
        self.lblProductDiscount.isHidden = true
        self.tfProductDiscount.isHidden = true
        //Set Borders
        CustomeTextfield.setBottomBorder(tf: self.tfProductCategory)
        CustomeTextfield.setBottomBorder(tf: self.tfProductSubCategory)
        CustomeTextfield.setBottomBorder(tf: self.tfProduct)
        CustomeTextfield.setBottomBorder(tf: self.tfProductQuantity)
        CustomeTextfield.setBottomBorder(tf: self.tfProductBudget)
        
        // set right image
        self.tfProductCategory.setrightImage(img: UIImage.init(named: "icon_search_black")!)
        self.tfProductSubCategory.setrightImage(img: UIImage.init(named: "icon_search_black")!)
        
        
        self.lblProductDiscount.isHidden = true
        
        tfProductDiscount.isHidden = true
        arrProductCatrgory =  ProdCategory.getAll()
        arrProductSubCategory = [ProductSubCat]()
        arrProduct = Product.getAll()
        if(isFromProductStock == true){
            //            tfProductBudget.isHidden = true
            //            lblProductBudget.isHidden = true
            btnBarcode.isHidden  = false
        }else{
            //            tfProductBudget.isHidden = false
            //            lblProductBudget.isHidden = false
            btnBarcode.isHidden = true
        }
        if(isCut == true){
            tfProductBudget.isHidden = true
            lblProductBudget.isHidden = true
            if(tfProductQuantity.text?.count == 0){
                
            }
        }
        self.initDropDown()

        if(self.activesetting.showProductDrive ==  NSNumber.init(value: 1)){
            self.getProductDriveList()
        }else{
            if (self.activesetting.showSuggestOrderQty == 1) {
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
                self.suggestOrderQtyMultiple()
            }
        }
        if(productselectionfrom == ProductSelectionFromView.potential){
            vwProductpitched.isHidden = false
            vwInterestLevel.isHidden = false
            
            tfProductQuantity.isHidden = true
            lblProductQuantity.isHidden = true
            lblProductBudget.isHidden = true
            tfProductBudget.isHidden = true
            lblProductDiscount.isHidden = true
            tfProductDiscount.isHidden = true
            self.configureButtonSelected(btn: btnHot)
            self.configureButtonNormal(btn: btnWarm)
            self.configureButtonNormal(btn: btnCold)
            
            btnHot.isSelected = true
            
        }else{
            vwProductpitched.isHidden = true
            vwInterestLevel.isHidden = true
        }
        btnPitched.setImage(UIImage.init(named: "icon_switch_unselected"), for: UIControl.State.normal)
       btnPitched.setImage(UIImage.init(named: "icon_switch_selected"), for: UIControl.State.highlighted)
    }
    
    func suggestOrderQtyMultiple() {
        if customerId > 0{
            let account = Utils().getActiveAccount()
            var param = [String: Any]()
            param["UserID"] = account?.userID
            param["CompanyID"] = account?.company?.iD
            param["CustomerID"] = customerId
            param["TokenID"] = account?.securityToken
            param["ProductCatId"] = 0
            param["VisitID"] = visitID
            
            param["ProductSubCatId"] = 0
            RestAPIManager.httpRequest(ConstantURL.suggestOrderQtyMultiple, .get, parameters: param, isTeamWorkUrl: true) { (response, sucess, error) in
                SVProgressHUD.dismiss()
                if error == nil {
                    if let result = response as? [[String: Any]] {
                        for d in result {
                            let p = Product.getProduct(productID: NSNumber(value:d["ProductID"] as? Int64 ?? 0))
                            for var stck in self.productStockList {
                                if (stck["ProductID"] as? Int64) == p?.productId {
                                    stck["SugQty"] = d["SuggestedOrderQty"] as? Int64 ?? 0
                                }
                            }
                            let dt = ["ProductID":p?.productId ?? 0, "Name":p?.productName ?? "", "On": d["OnHandStock"] as? Int64 ?? 0, "Avl": d["AvailableStock"] as? Int64 ?? 0, "SugQty": d["SuggestedOrderQty"] as? Int64 ?? 0] as [String : Any];
                            self.productStockList.append(dt)
                        }
                    }
                }
            }
        }else{
            SVProgressHUD.dismiss()
        }
    }
    
    
    func configureButtonSelected(btn:UIButton)->(){
        btn.isSelected =  true
        btn.addBorders(edges: [.all], color: UIColor.clear, cornerradius: 0)
        //  btn.layer.borderColor = Common().UIColorFromRGB(rgbValue:0x114763).cgColor
        btn.layer.backgroundColor = UIColor.systemBlue.cgColor//UIColor.clear.cgColor
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }
    
    func configureButtonNormal(btn:UIButton)->(){
        btn.isSelected = false
        btn.addBorders(edges: [.all], color: UIColor.black, cornerradius: 0)
        // self.addBorders(edges
        //   btn.layer.borderColor =  UIColor.systemBlue.cgColor//Common().UIColorFromRGB(rgbValue:0x114763).cgColor
        btn.backgroundColor = UIColor.clear
        btn.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
    }
    
    // MARK: APICall
    func getProductDriveList(){
        if(customerId > 0){
        SVProgressHUD.showInfo(withStatus: "Loading")
        var param  = Common.returndefaultparameter()
        param["CustomerID"] = customerId
        
        self.apihelper.getPromotionList(strurl: ConstantURL.KWSUrlGetProductDriveList, customerId: NSNumber(value: customerId))  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print()
                self.productDriveIDs = arr as! [NSNumber]
                self.productDriveIDs.removeAll()
                if(error.code == 0){
                    if(responseType == ResponseType.arrOfAny || responseType == ResponseType.arr){
                        let arrOfPromotion = arr as? [NSNumber] ?? [NSNumber]()
                        self.productDriveIDs = arrOfPromotion
                        if(self.activesetting.showSuggestOrderQty == (NSNumber.init(value: 1))){
                            SVProgressHUD.setDefaultMaskType(.black)
                            SVProgressHUD.show()
                            self.suggestOrderQtyMultiple()
                        }else{
                            SVProgressHUD.dismiss()
                        }
                    }
                }
            }
            else if(error.code == 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        }
    }
    
    func initDropDown(){
        chooseProductCategory.anchorView = self.tfProductCategory
        chooseProductCategory.bottomOffset = CGPoint.init(x: 0.0, y: tfProductCategory.bounds.size.height)
        
        chooseProductCategory.selectionAction = {(index,item) in
            self.selectedLevel = 2
            self.tfProductCategory.text = item
            
            let selectedcat = self.arrProductCatrgory[index]
            self.selectedProductCatId = NSNumber.init(value:selectedcat.iD)
            
            self.arrProductSubCategory = ProductSubCat.getSubProductFromCategoryID(categoryID: self.selectedProductCatId)
            self.arrProduct =  Product.getProductIdFromCategoryID(catID: self.selectedProductCatId)
            self.selectedProductCatId = NSNumber.init(value:self.arrProductCatrgory[index].iD)
            self.chooseProductSubCategory.dataSource = self.arrProductSubCategory.map{
                $0.name
            }
            print(self.chooseProductSubCategory.dataSource)
            // set first sub cat and product as selected
            
            if((self.arrProductSubCategory.count > 0) && (self.activesetting.productMandatoryInLead == NSNumber.init(value: 1))){
                let selectedProductSubcat = self.arrProductSubCategory[0]
                self.selectedProductSubCatId = NSNumber.init(value:selectedProductSubcat.iD)
                self.tfProductSubCategory.text = ""//selectedProductSubcat.name
                
                
            }else{
                self.selectedProductSubCatId = NSNumber.init(value:0)
                self.tfProductSubCategory.text = ""
                self.tfProduct.text = ""
            }
            let predicate = NSPredicate.init(format: "productCatId = %d AND productSubCatId = %d AND isActive = 1", argumentArray: [self.selectedProductCatId,self.selectedProductSubCatId])
            
            self.chooseProduct.anchorView = self.tfProduct
            self.chooseProduct.bottomOffset = CGPoint.init(x: 0.0, y: self.tfProduct.bounds.size.height)
            
            
            self.arrProduct =  Product.getProductUsingPredicate(predicate: predicate)
            self.chooseProduct.dataSource = self.arrProduct.map{
                ($0.productName ?? "")
                
            }
            if(self.arrProduct.count > 0 && self.activesetting.productMandatoryInLead == NSNumber.init(value: 1)){
                
                let selectedproduct =  self.arrProduct[0]
                self.selectedProductId  = NSNumber.init(value:selectedproduct.productId)
                self.tfProduct.text =  ""//selectedproduct.productName
            }else{
                self.selectedProductId  = NSNumber.init(value:0)
                self.tfProduct.text = ""
            }
            self.tfProductQuantity.text = ""
        }
        
        chooseProductSubCategory.anchorView = self.tfProductSubCategory
        chooseProductSubCategory.bottomOffset = CGPoint.init(x: 0.0, y: tfProductSubCategory.bounds.size.height)
        chooseProductSubCategory.selectionAction = {
            (index,item) in
            self.selectedLevel = 2
            self.tfProductSubCategory.text =  item
            let selectedproductSubCat =  self.arrProductSubCategory[index]
            self.selectedProductSubCatId = NSNumber.init(value:selectedproductSubCat.iD)
            
            let predicate = NSPredicate.init(format: "productCatId = %d AND productSubCatId = %d AND isActive = 1", argumentArray: [self.selectedProductCatId,self.selectedProductSubCatId])
            
            self.arrProduct =  Product.getProductUsingPredicate(predicate: predicate)
            self.chooseProduct.dataSource = self.arrProduct.map{
                ($0.productName ?? "")
            }
            
            if(self.arrProduct.count > 0 && self.activesetting.productMandatoryInLead == NSNumber.init(value: 1)){
                let selectedproduct =  self.arrProduct[0]
                self.selectedProductId  = NSNumber.init(value:selectedproduct.productId)
                self.tfProduct.text =  ""//selectedproduct.productName
            }else{
                self.selectedProductId  = NSNumber.init(value:0)
                self.tfProduct.text = ""
                
                print(self.chooseProduct.dataSource)
            }
            
            
            self.chooseProduct.anchorView = self.tfProduct
            self.chooseProduct.bottomOffset = CGPoint.init(x: 0.0, y: self.tfProduct.bounds.size.height)
            self.chooseProduct.dataSource = self.arrProduct.map{
                ($0.productName ?? "")
            }
            self.chooseProduct.selectionAction = {(index,item) in
                self.selectedProductId  = NSNumber.init(value:self.arrProduct[index].productId)
                self.selectedProduct = self.arrProduct[index]
                self.selectedLevel = 3
                self.tfProduct.text =  item
                self.tfProductQuantity.text = ""
            }
            self.tfProductQuantity.text = ""
        }
        
    }
    // MARK: - IBAction
    
    @IBAction func btnSearchProductClicked(_ sender: UIButton) {
        arrProduct = Product.getAll()

        var a1 = arrProduct.filter { p in
            return !productDriveIDs.contains(NSNumber(value: p.productId))
        }
        let a2 = arrProduct.filter { p in
            return productDriveIDs.contains(NSNumber(value: p.productId))
        }

        let rows = a2.map(\.productName)
        for t in a2 {
            a1.insert(t, at: 0)
        }

        arrProduct.removeAll()
        arrProduct = a1
        
        if let productnameList = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        {
            productnameList.selectionmode = SelectionMode.none
            //    productnameList.selectedIndexPaths = selectedProductIndexes ?? [IndexPath]()
            if(isFromSalesOrder){
                productnameList.customerID = NSNumber.init(value:customerId)
            }
            productnameList.isFromSalesOrder = isFromSalesOrder
            productnameList.strTitle = ""
            productnameList.strLeftTitle = ""
            productnameList.strRightTitle = ""
            productnameList.modalPresentationStyle = .overCurrentContext
            productnameList.nonmandatorydelegate = self
            productnameList.isFilterRequire = false
            productnameList.arrOfProduct =  arrProduct
            productnameList.productDriveIDs = productDriveIDs
            productnameList.isSugggestedQty = self.activesetting.showSuggestOrderQty == 1 ? true : false
            if (activesetting.viewCompanyStock == 1) {
                if (activesetting.showSuggestOrderQty == 1 && isFromSalesOrder) {
                    productnameList.isProductView = activesetting.showSuggestOrderQty == 1 ? true : false
                    productnameList.isProductViewWithMultiLine = activesetting.showSuggestOrderQty == 1 ? true : false
                }else{
                    productnameList.isProductView = false
                    productnameList.isProductViewWithMultiLine = false
                }
                productnameList.productStockArray = self.productStockList;
            }
            productnameList.isSearchBarRequire = true
            productnameList.viewfor = ViewFor.product
            productnameList.parentViewOfPopup = self.view
            Utils.addShadowOnSahdow(view: self.view)
            self.present(productnameList , animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnBarcodeClicked(_ sender: UIButton) {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self

        present(viewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnPitchedClicked(_ sender: UIButton) {
        let isSelected = !sender.isSelected
        sender.isSelected = isSelected
//        cell.btnSwitch.setImage(UIImage.init(named: "icon_switch_unselected"), for: UIControl.State.normal)
//        cell.btnSwitch.setImage(UIImage.init(named: "icon_switch_selected"), for: UIControl.State.selected)
        print("btn pitched is selected ? = \(sender.isSelected)" )
        if(sender.isSelected){
            btnPitched.isSelected = true
            sender.setImage(UIImage.init(named: "icon_switch_selected"), for: UIControl.State.selected)
        }else{
            btnPitched.isSelected = false
            sender.setImage(UIImage.init(named: "icon_switch_unselected"), for: UIControl.State.normal)
        }
    }
    
    
    @IBAction func btnHotClicked(_ sender: UIButton) {
        
        self.configureButtonSelected(btn: btnHot)
        self.configureButtonNormal(btn: btnWarm)
        self.configureButtonNormal(btn: btnCold)
        
//        if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
//        let selectedproduct = arrOfPotentialProduct[indexPath.row]
//
//        selectedproduct.interestLevel =  1
//
//        arrOfPotentialProduct.remove(at: indexPath.row)
//        arrOfPotentialProduct.insert(selectedproduct, at: indexPath.row)
//        }
    }
    
    
    @IBAction func btnWarmClicked(_ sender: UIButton) {
        self.configureButtonSelected(btn: btnWarm)
        self.configureButtonNormal(btn: btnHot)
        self.configureButtonNormal(btn: btnCold)
        
//        if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
//        let selectedproduct = arrOfPotentialProduct[indexPath.row]
//
//        selectedproduct.interestLevel =  1
//
//        arrOfPotentialProduct.remove(at: indexPath.row)
//        arrOfPotentialProduct.insert(selectedproduct, at: indexPath.row)
//        }
    }
    
    @IBAction func btnColdClicked(_ sender: UIButton) {
        self.configureButtonSelected(btn: btnCold)
        self.configureButtonNormal(btn: btnHot)
        self.configureButtonNormal(btn: btnWarm)
        
    }
    @IBAction func btnOfAddProductClicked(_ sender: UIButton) {
        if(sender == btnClose){
            Utils.removeShadow(view: parentviewforpopup)
            self.dismiss(animated: true, completion: nil)
        }else{
            // if(self.validation()){
            var str = String()
            if(productselectionfrom == ProductSelectionFromView.lead ||  productselectionfrom == ProductSelectionFromView.leadupdatestatus){
                if(self.activesetting.productMandatoryInLead == 1){
                    if(selectedProductCatId == 0){
                        str = "Please Select Product Category"
                    }else if(selectedProductSubCatId == 0){
                        str = "Please Select Product  SubCategory"
                    }else if(selectedProductId == 0 ){
                        str = "Please Select Product"
                    }else if(isCut == true && tfProductQuantity.text == ""){
                        str = "Please enter product quantity"
                    }
                }else{
                    if(selectedProductCatId == 0){
                        str = "Please select product Category"
                    }else if(isCut == true && tfProductQuantity.text == ""){
                        str = "Please enter product quantity"
                    }else{
                        str = ""
                    }
                }
            }else if(productselectionfrom  == ProductSelectionFromView.potential){
                if(selectedProductCatId == 0){
                    str = "Please Select Product Category"
                }else{
                    str = ""
                }
            }else{
                if(selectedProductCatId == 0){
                    str = "Please Select Product Category"
                }else if(selectedProductSubCatId == 0){
                    str = "Please Select Product  SubCategory"
                }else if(selectedProductId == 0 ){
                    str = "Please Select Product"
                }else{
                    if(isCut == true){
                        tfProductBudget.isHidden = true
                        lblProductBudget.isHidden = true
                        if(tfProductQuantity.text?.count == 0){
                            str = "Please enter product quantity"
                        }
                    }
                }
            }
            if(str.count == 0){
                if(productselectionfrom  == ProductSelectionFromView.visit){
                    if(tfProductBudget.text?.count == 0 ){
                        tfProductBudget.text = "0"
                    }
                    if(tfProductQuantity.text?.count == 0){
                        tfProductQuantity.text = "0"
                    }
                }else if(productselectionfrom  == ProductSelectionFromView.lead){
                    if(tfProductQuantity.text?.count == 0){
                        Utils.toastmsg(message:"Please enter product quantity",view:self.view)
                        return
                    }
                    if(tfProductBudget.text?.count == 0){
                        tfProductBudget.text = "0"
                    }
                }
            }else{
                Utils.toastmsg(message:str,view:self.view)
                return
            }
            if(str.count == 0){
                var flag = false
                if(ProductSubCat.getSubCatProduct(subcatid: selectedProductSubCatId)?.categoryType == 1){
                    flag = true
                }else{
                    flag = false
                }
                if(isProduct == isService){
                    if(ProductSubCat.getSubCatProduct(subcatid: selectedProductSubCatId)?.categoryType == 1){
                        isProductOrNot = true
                        withServiceFl = false
                    }else{
                        isProductOrNot = false
                        withServiceFl = true
                    }
                }else{
                    if(isProduct == true && flag == false){
                        Utils.toastmsg(message:"Please select either products or services",view:self.view)
                        return
                    }else if(flag == true){
                        Utils.toastmsg(message:"Please select either products or services",view:self.view)
                        return
                    }
                    
                }
             /*   self.dismiss(animated: true) {
                    if(self.productselectionfrom == ProductSelectionFromView.salesorder){
                        let dic = ["productName":self.tfProduct.text ?? "","ProductID":self.selectedProductId,"CategoryID":self.selectedProductCatId,"SubCategoryID":self.selectedProductSubCatId,"Quantity":self.tfProductQuantity.text! ,"Price": self.tfProductBudget.text!,"salesDiscount": self.tfProductDiscount.text ?? "0.0", "Maxdiscount" : self.maxdiscount] as [String : Any]
                        let product = SelectedProduct().initwithdic(dict: dic)
                        self.productselectiondelegate?.addProduct1(product: product)
                    }else if(self.productselectionfrom == ProductSelectionFromView.proposal){
                        
                    }else if(self.productselectionfrom == ProductSelectionFromView.lead || self.productselectionfrom == ProductSelectionFromView.leadupdatestatus){
                        //if(self.activesetting.productMandatoryInLead == 1){
                        var dic = [String:Any]()
                        dic = ["productName":self.tfProduct.text ?? "","ProductID":self.selectedProductId,"CategoryID":self.selectedProductCatId,"SubCategoryID":self.selectedProductSubCatId,"Quantity":self.tfProductQuantity.text! ,"Budget": self.tfProductBudget.text!] as [String : Any]
                        let product = SelectedProduct().initwithdic(dict: dic)
                        self.productselectiondelegate?.addProduct1(product: product)
                        // }
                    }else {
                        var dic = [String:Any]()
                        if(self.isFromProductStock == true){
                            dic = ["productName":self.tfProduct.text ?? "","ProductID":self.selectedProductId,"Quantity":self.tfProductQuantity.text! ,"Budget": "0" ,"LeadID":self.leadId] as [String : Any]
                            let product = SelectedProduct().initwithdic(dict: dic)
                            self.productselectiondelegate?.addProduct1(product: product)
                        }else{
                            //
                            dic = ["productName":self.tfProduct.text ?? "","ProductID":self.selectedProductId,"Quantity":self.tfProductQuantity.text! ,"Budget": self.tfProductBudget.text! ,"LeadID":self.leadId] as [String : Any]
                            let product = SelectedProduct().initwithdic(dict: dic)
                            self.productselectiondelegate?.addProduct1(product: product)
                        }
                        
                    }*/

                    self.dismiss(animated: true) {
                        if(self.productselectionfrom == ProductSelectionFromView.salesorder){

                        }
if(self.productselectionfrom == ProductSelectionFromView.proposal){

}else if(self.productselectionfrom == ProductSelectionFromView.lead || self.productselectionfrom == ProductSelectionFromView.leadupdatestatus ){
//if(self.activesetting.productMandatoryInLead == 1){
    var dic = [String:Any]()
    var strproductname = ""
    if(self.selectedProductId.intValue > 0){
        strproductname = Product.getProductName(productID: self.selectedProductId)
    }else if(self.selectedProductSubCatId.intValue > 0){
        strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: self.selectedProductSubCatId))")
    }else if(self.selectedProductCatId.intValue > 0){
        strproductname =  String.init(format:"Cat: \(ProdCategory.getCategoryName(catId: self.selectedProductCatId))")
    }
    dic = ["productName":strproductname ,"ProductID":self.selectedProductId ?? "","CategoryID":self.selectedProductCatId ?? "","SubCategoryID":self.selectedProductSubCatId ?? "" ,"Quantity":self.tfProductQuantity.text ?? "0" ,"Budget": self.tfProductBudget.text!] as [String : Any]
   let product = SelectedProduct().initwithdic(dict: dic)
   
   self.productselectiondelegate?.addProduct1(product: product)
   // }
}else if(self.productselectionfrom == ProductSelectionFromView.potential){
    var dic = [String:Any]()
    var strproductname = ""
    if(self.selectedProductId.intValue > 0){
        strproductname = Product.getProductName(productID: self.selectedProductId)
    }else if(self.selectedProductSubCatId.intValue > 0){
        strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: self.selectedProductSubCatId))")
    }else if(self.selectedProductCatId.intValue > 0){
        strproductname =  String.init(format:"Cat: \(ProdCategory.getCategoryName(catId: self.selectedProductCatId))")
    }
    dic = ["productName":strproductname ,"ProductID":self.selectedProductId ?? "","CategoryID":self.selectedProductCatId ?? "","SubCategoryID":self.selectedProductSubCatId ?? "" ,"Quantity":self.tfProductQuantity.text ?? "0" ,"Budget": self.tfProductBudget.text!] as [String : Any]
    if(self.btnPitched.isSelected){
        dic["pitched"] = "Y"
    }else{
        dic["pitched"] = "N"
    }
    if(self.btnHot.isSelected){
        dic["interestLevel"] =  1
    }else if(self.btnWarm.isSelected){
        dic["interestLevel"] = 2
    }else{
        dic["interestLevel"] = 3
    }
    let product = PotentialProduct.init(dictionary: dic as NSDictionary)
    self.potentialprodelegate?.addpotentialProduct(product: product)
}else {
    var dic = [String:Any]()
    if(self.isFromProductStock == true){
        var strproductname = ""
        if(self.selectedProductId.intValue > 0){
            strproductname = Product.getProductName(productID: self.selectedProductId)
        }else if(self.selectedProductSubCatId.intValue > 0){
            strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: self.selectedProductSubCatId))")
        }else if(self.selectedProductCatId.intValue > 0){
            strproductname =  String.init(format:"Cat: \(ProdCategory.getCategoryName(catId: self.selectedProductCatId))")
        }
dic = ["productName":strproductname ,"ProductID":self.selectedProductId,"Quantity":self.tfProductQuantity.text! ,"Budget": "0" ,"LeadID":self.leadId] as [String : Any]
        let product = SelectedProduct().initwithdic(dict: dic)
        self.productselectiondelegate?.addProduct1(product: product)
    }else{
                                //
    dic = ["productName":self.tfProduct.text ?? "","ProductID":self.selectedProductId,"Quantity":self.tfProductQuantity.text! ,"Budget": self.tfProductBudget.text! ,"LeadID":self.leadId] as [String : Any]
        let product = SelectedProduct().initwithdic(dict: dic)
        self.productselectiondelegate?.addProduct1(product: product)
                            }

                        }

//
//}else{
//Utils.toastmsg(message:str)
//=======
//>>>>>>> a1bf0987a158f2ce519848e3f967f44a3043230d
                }
                
            }else{
                Utils.toastmsg(message:str,view:self.view)
            }
            //  self.dismiss(animated: true, completion: nil)
            //  SelectedProduct =
            //}
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
    

}

extension Addproduct:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(textField)
        if(textField == tfProductCategory){
            chooseProductCategory.dataSource = arrProductCatrgory.map{
                $0.name
            }
            chooseProductCategory.reloadAllComponents()
            chooseProductCategory.show()
            return false
        }else if(textField == tfProductSubCategory){
            chooseProductSubCategory.dataSource = arrProductSubCategory.map{
                $0.name
            }
            chooseProductSubCategory.reloadAllComponents()
            chooseProductSubCategory.show()
            return false
        }else if(textField == tfProduct){
            if(self.selectedProductSubCatId.intValue > 0){
                chooseProduct.reloadAllComponents()
                chooseProduct.show()
            }else{
//                self.arrProduct = Product.getAll()
//            
//
//                chooseProduct.dataSource =  arrProduct.map{
//                    ($0.productName ?? "")
//                }
//                self.initDropDown()
//                chooseProduct.reloadAllComponents()
//                chooseProduct.show()
            }
            return false
        }else{
        return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.tfProductQuantity {
            let budget = (Double(self.tfProductQuantity.text ?? "0.0") ?? 0.0) * self.selectedProduct.price
            self.tfProductBudget.text = budget.description
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == tfProductQuantity){
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if(textField == tfProductBudget){
            let maxLength = 7
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
    
}
extension Addproduct:PopUpDelegateNonMandatory{
    
    
    
    func completionProductData(arr: [Product]) {
        Utils.removeShadow(view: self.view)
        print(arr)
        if let prdt = arr.first {
            selectedProduct = prdt
            tfProduct.text = selectedProduct?.productName
            self.selectedProductId =  NSNumber.init(value:selectedProduct.productId)
            self.selectedProductCatId =  NSNumber.init(value:selectedProduct.productCatId)
            self.selectedProductSubCatId =  NSNumber.init(value:selectedProduct.productSubCatId)
            if   let selectedCategory = ProdCategory.getProductByCatID(catId: self.selectedProductCatId){
                tfProductCategory.text = selectedCategory.name
            }
            if  let selecteSubCategory = ProductSubCat.getSubCatProduct(subcatid: self.selectedProductSubCatId){
                tfProductSubCategory.text = selecteSubCategory.name
            }
            let predicate = NSPredicate.init(format: "productCatId = %d AND productSubCatId = %d AND isActive = 1", argumentArray: [self.selectedProductCatId,self.selectedProductSubCatId])
            
            self.arrProduct =  Product.getProductUsingPredicate(predicate: predicate)
            if(arrProduct.count > 0){
                self.chooseProduct.dataSource = arrProduct.map{
                    ($0.productName ?? "")
                }
            }else{
                self.chooseProduct.dataSource  = [""]
            }
            
            if (activesetting.showSuggestOrderQty == 1 && isFromSalesOrder) {
                if let sugProd = productStockList.filter({($0["ProductID"] as? Int64 ?? 0) == selectedProduct.productId}).first {
                    tfProductQuantity.text = "\(sugProd["SugQty"] as? Int64 ?? 0)"
                }
            }
            
            self.arrProductSubCategory =  ProductSubCat.getSubProductFromCategoryID(categoryID: NSNumber.init(value:selectedProduct.productCatId))
            self.chooseProductSubCategory.dataSource = self.arrProductSubCategory.map{
                $0.name
            }
        }
//        else{
//            self.chooseProduct.dataSource  = [String]()
//        }
        
        
    }

    
    
    
}
extension Addproduct:BarcodeScannerCodeDelegate{
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("product Captured")
        print(code)
        print(barcode)
        if(code != barcode){
            barcode = code
            if(barcode == barcode1){
                productCount += 1
            }else{
                barcode1 = barcode
                productCount = 1
            }
            
            controller.dismiss(animated: true, completion: nil)
            Utils.toastmsg(message:String.init(format:"Scanned Code :: %@",barcode),view:self.view)
            
            
            if let product =  Product.getProductFromBarcode(barcode: barcode){
                self.selectedProduct = product
                //let product = Product.getProductFromBarcode(barcode: barcode)
                tfProductQuantity.text = String.init(format:"%d",productCount)
                tfProduct.text = product.productName
                selectedProductCatId = NSNumber.init(value:product.productCatId)
                selectedProductSubCatId = NSNumber.init(value:product.productSubCatId)
                selectedProductId = NSNumber.init(value:product.productId)
                price = NSNumber.init(value:product.price)
                maxdiscount = NSNumber.init(value:product.maxdiscount)
                if let subcat = ProductSubCat.getSubCatName(subcatid: selectedProductSubCatId) as? String{
                    tfProductSubCategory.text = subcat
                }else{
                    tfProductSubCategory.text = ""
                }
                if let catname = ProdCategory.getCategoryName(catId: selectedProductCatId) as? String{
                    tfProductCategory.text = catname//product.productName
                    
                }else{
                    tfProductCategory.text = ""
                }
                arrProduct = Product.getProductUsingPredicate(predicate: NSPredicate.init(format: "productCatId = %d AND productSubCatId = %d AND isActive = 1", argumentArray: [selectedProductCatId,selectedProductSubCatId]))
                if(arrProduct.count > 0){
                    self.chooseProduct.dataSource = arrProduct.map{
                        ($0.productName ?? "")
                    }
                }
                
            }
            else{
                Utils.toastmsg(message:"NO Product Found",view:self.view)
                selectedProductCatId = NSNumber.init(value:0)
                selectedProductSubCatId = NSNumber.init(value:0)
                selectedProductId =  NSNumber.init(value:0)
                tfProduct.text = "Product"
                tfProductSubCategory.text = "Product Subcategory"
                tfProductCategory.text = "Product Category"
                tfProductQuantity.text = ""
                
            }
        }else{
            print(barcode)
            print(barcode1)
            print(code)
        }
        controller.reset()
    }
    
    
}
extension Addproduct:BarcodeScannerErrorDelegate{
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print("get error")
        controller.dismiss(animated: true, completion: nil)
        Utils.toastmsg(message:error.localizedDescription,view:self.view)
        
    }
    
    
}
extension Addproduct:BarcodeScannerDismissalDelegate{
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        print("view is dismissed")
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
