//
//  MultipleProductSelection.swift
//  SuperSales
//
//  Created by Apple on 03/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD

protocol MultipleProductSelectionDelegate{
    
    func addProductFromMultipleSelection(product: SelectedProduct)
}

class MultipleProductSelection: BaseViewController {
    var stockReturn:(([[String: Any]]) -> Void)?
    var multipleproductselectiondelegate:MultipleProductSelectionDelegate?
    var chooseProductCategory:DropDown = DropDown()
    var chooseProductSubCategory:DropDown = DropDown()
    var chooseProduct:DropDown = DropDown()
    
    var arrProductCatrgory:[ProdCategory]!
    var arrProductSubCategory:[ProductSubCat]!
    var arrProduct:[[String:Any]]! = [[String:Any]]()
    var arrTempProduct = [Product]()
    var tempProducts:[[String:Any]]! = [[String:Any]]()
    var tempSO = [[String: Any]]() // declaring array for update stock
    var aryStockProducts:[[String: Any]]?
    var customerId:NSNumber = 0
    @IBOutlet weak var tblProduct: UITableView!
    
    @IBOutlet weak var vwSearch: UIView!
    
    
    @IBOutlet weak var btnProductCategory: UIButton!
    
    @IBOutlet weak var lblProductCategory: UILabel!
    @IBOutlet weak var btnProductSubCategory: UIButton!
    
    @IBOutlet weak var lblProductSubCategory: UILabel!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var btnAddMore: UIButton!
    var selectedLevel:Int = 0
    var productCatID = 0
    var productID = 0
    var productsubcatID = 0
    var visitID = 0
    var productDriveIDs:[NSNumber] = [NSNumber]()
    var issalesorder:Bool!
    var isLead1:Bool!
    let account = Utils().getActiveAccount()
    var suggestedQty = [[String: Any]]()
    var isSalesOrderFromVisit = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUI()
        
        tempSO.append(contentsOf: aryStockProducts ?? [])
    }
    
    //    -(void)setTopSearchNar:(BOOL)isSet {
    //    CGRect frame = _tblProduct.frame;
    //    frame.size.height = isSet ? 132 : 88;
    //    _tblProduct.tableHeaderView.frame = frame;
    //    vwSearch.hidden = isSet ? NO : YES;
    //    }
    
    func setUI(){
        txtSearch.setCommonFeature()
        self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        self.btnAddMore.setbtnFor(title: "Add More", type: Constant.kNutral)
        tblProduct.delegate = self
        tblProduct.dataSource = self
        tblProduct.tableFooterView = UIView()
        tblProduct.setCommonFeature()
        tblProduct.estimatedRowHeight = UITableView.automaticDimension
        tblProduct.rowHeight = UITableView.automaticDimension
        self.title = NSLocalizedString("products", tableName: "", comment: "")
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        self.setTopSearchBar(available:false)
        txtSearch.placeholder = "Search"
        txtSearch.delegate = self
        if(self.activesetting.showProductDrive ==  NSNumber.init(value: 1)){
            self.getProductDriveList()
        }else{
            if (self.activesetting.showSuggestOrderQty == 1) {
                SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
                self.suggestOrderQtyMultiple()
            }
        }
        self.initDropDown()
        vwSearch.backgroundColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
    }
    
    func suggestOrderQtyMultiple() {
        if(Int(truncating: customerId) > 0){
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
                        self.suggestedQty = result
                    }
                }
            }
        }else{
            SVProgressHUD.dismiss()
        }
    }

    
    func initDropDown(){
        
        self.lblProductCategory.text = NSLocalizedString("select_category",  comment: "")
        self.lblProductSubCategory.text = NSLocalizedString("select_sub_category",comment:"")
        chooseProductCategory.anchorView = btnProductCategory
        //        chooseProductCategory.cornerRadius = 5
        chooseProductCategory.bottomOffset = CGPoint.init(x: 0, y: 0)
        chooseProductCategory.selectionAction =
            {
                [unowned self] (index: Int, item: String) in
                self.lblProductCategory.text = item
                let productCat = self.arrProductCatrgory[index]
                self.productCatID = Int(productCat.iD)
                self.productID = 0
                self.selectedLevel = 1
                if(self.productCatID > 0){
                    self.arrProductSubCategory = ProductSubCat.getSubProductFromCategoryID(categoryID:NSNumber.init(value: productCat.iD))
                    if(self.arrProductSubCategory.count > 0){
                        let productsubcat = self.arrProductSubCategory.first
                        if(productsubcat?.iD ?? 0 > 0){
                            self.setTopSearchBar(available:false)
                            let allproductsubcat = ProductSubCat.mr_createEntity() ?? ProductSubCat()
                            allproductsubcat.name = "All"
                            allproductsubcat.iD = 0
                            self.arrProductSubCategory.insert(allproductsubcat, at: 0)
                        }else{
                            self.setTopSearchBar(available:true)
                        }
                    }else{
                        let allproductsubcat = ProductSubCat.mr_createEntity() ?? ProductSubCat()
                        allproductsubcat.name = "All"
                        allproductsubcat.iD = 0
                        self.arrProductSubCategory.insert(allproductsubcat, at: 0)
                    }
                }else{
                    self.arrProductSubCategory = [ProductSubCat]()
                    let allproductsubcat = ProductSubCat.mr_createEntity() ?? ProductSubCat()
                    allproductsubcat.name = "All"
                    allproductsubcat.iD = 0
                    self.arrProductSubCategory.insert(allproductsubcat, at: 0)
                    self.setTopSearchBar(available:true)
                }
                self.arrProduct = [[String:Any]]()
                if(self.productCatID == 0){
                    self.setTopSearchBar(available:true)
                    self.lblProductSubCategory.text = "All"
                    let aryTempProduct = Product.getAll()
                    self.productID = 0
                    self.arrProduct = [[String:Any]]()
                    for p in aryTempProduct{
                        var price = 00.00
                        var salesdiscount = 00.00
                        var order = 0
                        var stock = 0
                        var sgtQty = 0
                        if(self.tempProducts.count > 0){
                            for temp in self.tempProducts{
                                let productId = temp["ProductID"] as? Int64
                                if(productId == p.productId){
                                    price = temp["Price"] as? Double ?? 0.00
                                    salesdiscount = temp["salesDiscount"] as? Double ?? 0.00
                                    order = temp["Quantity"] as? Int ?? 0
                                }
                            }
                        }
                        
                        for d in suggestedQty {
                            if (d["ProductID"] as? NSNumber)?.int64Value == p.productId {
                                if issalesorder && isSalesOrderFromVisit && self.activesetting.stockUpdateInOrder == 1 {
                                    sgtQty = (d["SuggestedOrderQty"] as? NSNumber)?.intValue ?? 0
                                } else {
                                    if issalesorder && !isSalesOrderFromVisit{
                                        order = (d["SuggestedOrderQty"] as? NSNumber)?.intValue ?? 0
                                    }
                                }
                            }
                        }
                        
                        for d in tempSO {
                            if (d["ProductID"] as? NSNumber)?.int64Value == p.productId {
                                price = (d["Price"] as? NSNumber)?.doubleValue ?? 0
                                salesdiscount = (d["salesDiscount"] as? NSNumber)?.doubleValue ?? 0
                                stock = (d["Quantity"] as? NSNumber)?.intValue ?? 0
                                order = (d["Quantity1"] as? NSNumber)?.intValue ?? 0
                            }
                        }
                        
                        let dic = ["productName":p.productName ?? "","CategoryID":NSNumber.init(value:p.productCatId),"SubCategoryID":NSNumber.init(value:p.productSubCatId),"ProductID":NSNumber.init(value:p.productId),"Quantity":NSNumber.init(value:0),"Price":NSNumber.init(value:p.price),"salesDiscount":NSNumber.init(value:p.salesDiscount),"MaxDiscount":NSNumber.init(value:p.maxdiscount),"Stock":NSNumber.init(value:stock),"Order":NSNumber.init(value:order),"SuggestedQty":NSNumber.init(value:sgtQty)] as [String : Any]
                        self.arrProduct.append(dic)
                    }
                    
                }else{
                    self.setTopSearchBar(available:false)
                    self.lblProductSubCategory.text = "Select Sub-Category"
                    /*      "All"
                     
                     self.arrTempProduct = Product.getProductUsingPredicate(predicate: NSPredicate.init(format: "productCatId = %d AND isActive = 1", argumentArray: [self.productCatID]))
                     if(self.arrTempProduct.count > 0){
                     for product in self.arrTempProduct{
                     var price = 0.0
                     var sdisc = 0.0
                     var order = 0
                     var stock = 0
                     var sgqty = 0
                     for tempp in self.tempProducts{
                     print(tempp["ProductID"] ?? "")
                     let productId = tempp["ProductID"] as? Int64
                     if(productId == product.productId){
                     price = tempp["Price"] as? Double ?? 0.0//[d[@"Price"] doubleValue];
                     sdisc = tempp["salesDiscount"] as? Double ?? 0.0//[d[@"salesDiscount"] floatValue];
                     order = tempp["Quantity"] as? Int ?? 0//[d[@"Quantity"] longLongValue];
                     }
                     }
                     let dic = ["productName":product.productName,"CategoryID":NSNumber.init(value:product.productCatId),"SubCategoryID":NSNumber.init(value:product.productSubCatId),"ProductID":NSNumber.init(value:product.productId),"Quantity":NSNumber.init(value:0),"Price":NSNumber.init(value:product.price),"salesDiscount":NSNumber.init(value:product.salesDiscount),"MaxDiscount":NSNumber.init(value:product.maxdiscount),"Stock":NSNumber.init(value:stock),"Order":NSNumber.init(value:order),"SuggestedQty":NSNumber.init(value:sgqty)] as [String : Any]
                     self.arrProduct.append(dic)
                     }
                     }*/
                }
                self.chooseProductSubCategory.dataSource = self.arrProductSubCategory.map{
                    $0.name
                }
                
              
                self.tblProduct.reloadData()
            }
        chooseProductSubCategory.anchorView = btnProductSubCategory
        chooseProductSubCategory.bottomOffset =  CGPoint.init(x: 0, y: btnProductSubCategory.bounds.size.height)
        chooseProductSubCategory.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedLevel = 2
            self.lblProductSubCategory.text = item
            let productsubcat =  self.arrProductSubCategory[index]
            if(self.arrProductSubCategory.count > 0){
                self.productsubcatID = Int(productsubcat.iD)
            }else{
                self.productCatID = 0
            }
            
            if(self.productCatID > 0  && self.productsubcatID > 0){
                self.arrTempProduct = Product.getProductUsingPredicate(predicate: NSPredicate.init(format: "productCatId = %d AND productSubCatId = %d AND isActive = 1", argumentArray: [self.productCatID,self.productsubcatID]))
            }else if(self.productCatID > 0){
                self.arrTempProduct  = Product.getProductUsingPredicate(predicate: NSPredicate.init(format: "productCatId = %d AND isActive = 1", argumentArray: [self.productCatID]))
                //[_Product getProductUsingPredicate:[NSPredicate predicateWithFormat:FormatString(@"productCatId = %d AND isActive = 1", productCatId)]];
            }else if(self.productsubcatID > 0){
                self.arrTempProduct  = Product.getProductUsingPredicate(predicate: NSPredicate.init(format: "productSubCatId = %d AND isActive = 1", argumentArray: [self.productsubcatID]))
                //  aryTempProduct = [_Product getProductUsingPredicate:[NSPredicate predicateWithFormat:FormatString(@"productSubCatId = %d AND isActive = 1",productSubCatId)]];
            }else{
                self.arrTempProduct = Product.getAll()
            }
            self.productID = 0
            self.arrProduct.removeAll()
            if(self.arrTempProduct.count > 0){
                for product in self.arrTempProduct{
                    var price = 0.0
                    var sdisc = 0.0
                    var order = 0
                    var stock = 0
                    var sgqty = 0
                    for tempp in self.tempProducts{
                        print(tempp["ProductID"] ?? "")
                        let productId = tempp["ProductID"] as? Int64
                        if(productId == product.productId){
                            price = tempp["Price"] as? Double ?? 0.0//[d[@"Price"] doubleValue];
                            sdisc = tempp["salesDiscount"] as? Double ?? 0.0//[d[@"salesDiscount"] floatValue];
                            order = tempp["Quantity"] as? Int ?? 0//[d[@"Quantity"] longLongValue];
                        }
                    }
                    for d in suggestedQty {
                        if (d["ProductID"] as? NSNumber)?.int64Value == product.productId {
                            if issalesorder && isSalesOrderFromVisit && self.activesetting.stockUpdateInOrder == 1 {
                                sgqty = (d["SuggestedOrderQty"] as? NSNumber)?.intValue ?? 0
                            } else {
                                if issalesorder && !isSalesOrderFromVisit{
                                    order = (d["SuggestedOrderQty"] as? NSNumber)?.intValue ?? 0
                                }
                            }
                        }
                    }
                    for d in tempSO {
                        if (d["ProductID"] as? NSNumber)?.int64Value == product.productId {
                            price = (d["Price"] as? NSNumber)?.doubleValue ?? 0
                            sdisc = (d["salesDiscount"] as? NSNumber)?.doubleValue ?? 0
                            stock = (d["Quantity"] as? NSNumber)?.intValue ?? 0
                        }
                    }
                    let dic = ["productName":product.productName ?? "","CategoryID":NSNumber.init(value:product.productCatId),"SubCategoryID":NSNumber.init(value:product.productSubCatId),"ProductID":NSNumber.init(value:product.productId),"Quantity":NSNumber.init(value:0),"Price":NSNumber.init(value:product.price),"salesDiscount":NSNumber.init(value:product.salesDiscount),"MaxDiscount":NSNumber.init(value:product.maxdiscount),"Stock":NSNumber.init(value:stock),"Order":NSNumber.init(value:order),"SuggestedQty":NSNumber.init(value:sgqty)] as [String : Any]
                    self.arrProduct.append(dic)
                }
            }
            if(self.arrProduct.count == 0){
                //lblProductCategory
            }
            
            self.tblProduct.reloadData()
        }
        
    }
    
    
    func setTopSearchBar(available:Bool){
        vwSearch.isHidden = available ? false:true
    }
    
    
    // MARK: APICall
    func getProductDriveList(){
        
        SVProgressHUD.showInfo(withStatus: "Loading")
        var param  = Common.returndefaultparameter()
        param["CustomerID"] = customerId
        
        self.apihelper.getPromotionList(strurl: ConstantURL.KWSUrlGetProductDriveList, customerId: customerId )  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
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
        //    self.apihelper.getPromotionList(strurl:ConstantURL.KWSUrlGetProductDriveList,customerId:customerID) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        //                SVProgressHUD.dismiss()
        //
        //                if(error.code == 0){
        //                      if(setting.ShowSuggestOrderQty){
        //        self.suggestOrderQtyMultiple()
        //    }else{
        //        SVProgressHUD.dismiss()
        //    }
        //                    if(responseType == ResponseType.arrOfAny){
        //                         let arrOfPromotion = arr as? [Any] ?? [Any]()
        //
        //                        if(arrOfPromotion.count>0){
        //                            for int in arrOfPromotion {
        //                                print(int)
        ////           let productId = int as? NSNumber
        ////           let product = Product.getProduct(productID:productId!)
        //
        //                            }
        //                        }
        //
        //                    }else{
        //                let dicOFProductDrive = arr as? [String:Any] ?? [String:Any]()
        //                print(dicOFProductDrive)
        //                    }
        //
        //
        //                }else{
        //    //                AppDelegate.shared.alertWindow.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
        //     Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
        //                }
        //            }
    }
    
    // MARK: - Method
    func productReadyForAdd(){
        var isAdded = false
        for pro in arrProduct{
            isAdded = false
            
            if(tempProducts.count > 0){
                for tempp in 0...tempProducts.count - 1{
                    var tempproduct = tempProducts[tempp]
                    let productId = tempproduct["ProductID"] as? Int64
                    //  tempproduct["Budget"] = "0"
                    let productID =  pro["ProductID"] as? Int64
                    if(productID == productId){
                        if let order = pro["Order"] as? Int{
                            if(order == 0){
                                print("removing product = \(pro["productName"])")
                               // tempProducts.remove(at: tempp)
                            }else{
                                if let price = pro["Price"] as? Int{
                                    tempproduct["Price"] = price
                                    tempproduct["Budget"] = price
                                }else{
                                    tempproduct["Price"] = 0
                                    tempproduct["Budget"] = 0
                                }
                                tempproduct["salesDiscount"] =  pro["salesDiscount"]
                                if let strorder = pro["Quantity"] as? Int{     tempproduct["Order"] = String.init(format:"\(strorder)")
                                }else{
                                    tempproduct["Order"] = ""
                                }
                            }
                            isAdded = true
                            break
                        }
                    }
                }
            }
            var strQuantity = "0"
            var iorder = 0
            if let order = pro["Order"] as? Int{
                iorder = order
                if(order > 0){
                    strQuantity = String.init(format:"\(order)")
                }
            }
            var strBudget = "0"
            if let budget = pro["Price"]  as? Int{
                
                if(budget > 0){
                    strBudget = String.init(format:"\(budget)")
                }
            }
            if(isAdded ==  false){
                
                if(iorder > 0){
                    
                    tempProducts.append(["productName":pro["productName"] ?? "product name","CategoryID":pro["CategoryID"] ?? 0,"SubCategoryID":pro["SubCategoryID"] ?? 0,"ProductID":pro["ProductID"] ?? 0 ,"Quantity": strQuantity ,"Budget":"0",
                                         "Price":strBudget ,"salesDiscount":pro["salesDiscount"] ?? 0,"Maxdiscount":pro["Maxdiscount"] ?? 0])
                }
                
            }
            
            //Vishal
          //  print(pro["productName"])
            tempSO.removeAll { dict in
                dict["Stock"] as? Int == 0
            }
            isAdded = false;
            tempSO.removeAll { added in
                return (pro["ProductID"] as? Int == added["ProductID"] as? Int)
            }
//            for var added in tempSO {
//                if (pro["ProductID"] as? Int == added["ProductID"] as? Int) {
//                    added["Price"] = pro["Price"] as? Double
//                    added["salesDiscount"] = pro["salesDiscount"] as? Float
//                    added["Quantity"] = pro["Stock"] as? Int
//                    added["Quantity1"] = pro["Order"] as? Int
//                    added.updateValue(0, forKey: "Quantity")
//                    added.updateValue(0, forKey: "Quantity1")
//                    isAdded = true;
//                    break;
//                }
//            }
            if (!isAdded) {
                if (pro["Stock"] as? Int ?? 0 > 0) || (pro["Order"] as? Int ?? 0 > 0) {
                    tempSO.append(["productName":pro["productName"] ?? "","CategoryID":pro["CategoryID"] ?? 0,"SubCategoryID":pro["SubCategoryID"] ?? 0,"ProductID":pro["ProductID"] ?? 0,"Quantity":pro["Stock"] ?? 0,"Quantity1":pro["Order"] ?? 0,"Price":pro["Price"] ?? 0,"salesDiscount":pro["salesDiscount"] ?? 0.0,"Maxdiscount":pro["Maxdiscount"] ?? 0.0])
                }
            }
        }
    }
    
    func updateSearchArray(searchtext:String){
        
      //  arrProduct = [[String:Any]]()
        var arrOfMoreQuantity = [[String:Any]]()
        lblProductCategory.text = "All"
        let predicate = NSPredicate.init(format:String.init(format: "productName contains[c] '%@'", searchtext))
        var arrTempProduct = [Product]()
        if(searchtext.count > 0){
            arrTempProduct = Product.getProductUsingPredicate(predicate: predicate)
        }else{
          
            arrTempProduct =  Product.getAll()
            for pro in arrProduct{
                if(pro["Order"]  as? Int ?? 0 > 0){
                    arrOfMoreQuantity.append(pro)
                }
            }
//            for pro in arrTempProduct{
//                let p = arrTempProduct[pro]
//                for prosearched in arrProduct{
//                    let sp =  arrProduct[prosearched]
//                    if(p.toDictionary() == sp){
//                        arrTempProduct.remove(at: pro)
//                        arrTempProduct.insert(<#T##newElement: Product##Product#>, at: <#T##Int#>)
//                    }
//                }
//            }
        }
        self.productID = 0
        self.arrProduct = [[String:Any]]()
        for p in arrTempProduct{
            var price = 00.00
            var salesdiscount = 00.00
            var order = 0
            var stock = 0
            var sgtQty = 0
            
            if(self.tempProducts.count > 0){
                for temp in self.tempProducts{
                    let productId = temp["ProductID"] as? Int64
                    if(productId == p.productId){
                        price = temp["Price"] as? Double ?? 0.00
                        salesdiscount = temp["salesDiscount"] as? Double ?? 0.00
                        order = temp["Quantity"] as? Int ?? 0
                    }
                }
                
                for temp in suggestedQty {
                    let productId = temp["ProductID"] as? Int64
                    if(productId == p.productId){
                        if (issalesorder && isSalesOrderFromVisit && self.activesetting.stockUpdateInOrder == 1) {
                            sgtQty = temp["SuggestedOrderQty"] as? Int ?? 0
                        }else{
                            order = temp["SuggestedOrderQty"] as? Int ?? 0
                        }
                    }
                }

                for temp in tempSO {
                    let productId = temp["ProductID"] as? Int64
                    if(productId == p.productId){
                        price = Double(temp["Price"] as? Int ?? 0)
                        salesdiscount = Double(temp["salesDiscount"] as? Float ?? 0)
                        stock = temp["Quantity"] as? Int ?? 0
                    }
                }
                 
               
            }

            for pro in arrOfMoreQuantity{
                if(pro["ProductID"] as? Int64 == p.productId){
                    order = pro["Order"] as? Int ?? 0
                      print("value of order updated \(order)")
                }
            }
            
            let dic = ["productName":p.productName ?? "","CategoryID":NSNumber.init(value:p.productCatId),"SubCategoryID":NSNumber.init(value:p.productSubCatId),"ProductID":NSNumber.init(value:p.productId),"Quantity":NSNumber.init(value:0),"Price":NSNumber.init(value:p.price),"salesDiscount":NSNumber.init(value:p.salesDiscount),"MaxDiscount":NSNumber.init(value:p.maxdiscount),"Stock":NSNumber.init(value:stock),"Order":NSNumber.init(value:order),"SuggestedQty":NSNumber.init(value:sgtQty)] as [String : Any]
            
            
            self.arrProduct.append(dic)
        }
        tblProduct.reloadData()
        // let arrTempProduct =
    }
    
    // MARK: - Search Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // let searchStr =
        //textField.text?.replaceSubrange(range, with: string)
        //        textField.text?.replacingCharacters(in: range, with: string) ?? "") as NSString
        let nsstring = textField.text! as NSString
        let newString: NSString =
            (nsstring.replacingCharacters(in: range, with: string) ) as NSString
        updateSearchArray(searchtext: newString as String)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtSearch.text = ""
        updateSearchArray(searchtext: txtSearch.text ?? "")
        //        arrProduct = [[String:Any]]()
        self.tblProduct.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
    
}

extension MultipleProductSelection :UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if(arrProduct.count > 0){
            return 1
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(issalesorder && isSalesOrderFromVisit && self.activesetting.stockUpdateInOrder == 1){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StockOrderCell {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                let product = arrProduct[indexPath.row]
               
                cell.dictData = product
                cell.lblProductNm.textAlignment =  NSTextAlignment.left
                cell.lblProductNm.text = product["productName"] as? String
                if(productDriveIDs.contains(NSNumber.init(value:product["ProductID"] as? Int ?? 0))){
                    cell.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xE2EDF1)
                }else{
                    cell.backgroundColor = UIColor.white
                }
                cell.btnProductName.tag = indexPath.row
                cell.btnProductName.addTarget(self, action: #selector(gotProductDetails), for: UIControl.Event.touchUpInside)
                
                cell.btnOrderValue.setTitle(String.init(format:"%d",product["Order"] as? Int ?? 0), for: .normal)
                cell.btnStockValue.setTitle(String(format:"%d", product["Stock"] as? Int ?? 0), for: .normal)
                cell.lblSuggestedQty.text = String(format:"%d", product["SuggestedQty"] as? Int ?? 0)
                cell.lblProductPrice.text = String(format:"%d", product["Price"] as? Int ?? 0)
                cell.lblSuggestedQty.isHidden = false
                cell.btnPlusOrder.tag = indexPath.row
                cell.btnMinusOrder.tag = indexPath.row
                
                cell.btnPlusOrder.addTarget(self, action: #selector(plusOrderClicked), for: UIControl.Event.touchUpInside)
                cell.btnMinusOrder.addTarget(self, action: #selector(minusOrderClicked), for: UIControl.Event.touchUpInside)
                cell.completionBlock = { (cell, value) in
                    self.updateStockValues(cell: cell, value: value)
                  
                  
                }
                cell.lblProductNm.setMultilineLabel(lbl: cell.lblProductNm)
                cell.contentView.layoutSubviews()
                cell.contentView.layoutIfNeeded()
//                cell.setNeedsUpdateConstraints()
//                cell.updateConstraintsIfNeeded()
                return cell
            }
            else{
                return UITableViewCell()
            }
        }else/* if(issalesorder == false)*/{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as? StockOrderCell {
                print(" \(issalesorder) , \(isSalesOrderFromVisit) , \(self.activesetting.stockUpdateInOrder)")
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                let product = arrProduct[indexPath.row]
                cell.lblProductNm.textAlignment =  NSTextAlignment.left
                cell.lblProductNm.text = product["productName"] as? String
                print("product name = \(cell.lblProductNm.text)")
                
                //"jrt7k87tqr3ty5uio8i7y45 t3qr thg rthtr herttrhe herthr htrhththtrh rtyhythrthhyhrt htythtry htrhy yhy yhhty hyhy rhyrjy juyujj urjlyrjlyljyljtljyjyjty httehrlhnrtlhtelnthrnklehklrthtre lhlhrtel" //
                if(productDriveIDs.contains(NSNumber.init(value:product["ProductID"] as? Int ?? 0))){
                    cell.backgroundColor = Common().UIColorFromRGB(rgbValue: 0xE2EDF1)
                }else{
                    cell.backgroundColor = UIColor.white
                }
                cell.btnProductName.tag = indexPath.row
                cell.btnProductName.addTarget(self, action: #selector(gotProductDetails), for: UIControl.Event.touchUpInside)
             //   cell.lblSuggestedQty.isHidden = true
               
                cell.btnOrderValue.setTitle(String.init(format:"%d",product["Order"] as? Int ?? 0), for:.normal)
                cell.btnOrderValue.setTitle(String.init(format:"%d",product["Order"] as? Int ?? 0), for: .normal)
             //   print("\(product["productName"]) , \(product["Order"])  , \(cell.btnOrderValue.currentTitle)")
                cell.btnPlusOrder.tag = indexPath.row
                cell.btnMinusOrder.tag = indexPath.row
                
                cell.btnPlusOrder.addTarget(self, action: #selector(plusOrderClicked), for: UIControl.Event.touchUpInside)
                cell.btnMinusOrder.addTarget(self, action: #selector(minusOrderClicked), for: UIControl.Event.touchUpInside)
                
                //            cell.btnStockValue.setTitle(String.init(format:"%ld",NSNumber.init(value:product["Stock"] as? Double ?? 00.00)), for: .normal)
                //
                //            cell.lblSuggestedQty.text = String.init(format:"%@",product["SuggestedQty"] as? NSInteger ?? 0)
               cell.lblProductNm.setMultilineLabel(lbl: cell.lblProductNm)
                
                cell.contentView.layoutSubviews()
                cell.contentView.layoutIfNeeded()
//                cell.setNeedsUpdateConstraints()
//                cell.updateConstraintsIfNeeded()
                return cell
            }
            else{
                return UITableViewCell()
            }
        }/*else{
            return UITableViewCell()
        }*/
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (issalesorder && isSalesOrderFromVisit && self.activesetting.stockUpdateInOrder == 1){
            return 140.0;
        }else{
            return 48
        }
    }
    
    func updateStockValues(cell: StockOrderCell, value: Int) {
        let indexpath = IndexPath(row: cell.btnPlusOrder.tag , section: 0)
        var product = arrProduct[indexpath.row]
        if value == 1{
            var currentquantityproduct = product["Stock"] as? Int ?? 0
            currentquantityproduct -= 1
            guard var currentquantity = Int(cell.btnStockValue.currentTitle ?? "0"), currentquantityproduct > -1
            else {
                return
            }
            currentquantity -= 1
            product["Stock"] = currentquantityproduct
            cell.btnStockValue.setTitle(String.init(format:"%d",currentquantity), for: .normal)
        }else{
            var currentquantityproduct = product["Stock"] as? Int ?? 0
            currentquantityproduct += 1
            guard var currentquantity = Int(cell.btnStockValue.currentTitle ?? "0"), currentquantityproduct > -1
            else {
                return
            }
            currentquantity += 1
            product["Stock"] = currentquantityproduct
            cell.btnStockValue.setTitle(String.init(format:"%d",currentquantity), for: .normal)
        }
        arrProduct.remove(at: cell.btnPlusOrder.tag)
        arrProduct.insert(product, at: cell.btnPlusOrder.tag)
    }
    
    @objc func plusOrderClicked(sender:UIButton)->(){
        let indexpath = IndexPath.init(row: sender.tag , section: 0)
        let cell = tblProduct.cellForRow(at: indexpath) as? StockOrderCell
        var product = arrProduct[indexpath.row]
        var currentquantityproduct = product["Order"] as? Int ?? 0
        currentquantityproduct += 1
        guard var currentquantity = Int(cell?.btnOrderValue.currentTitle ?? "0")
        else {
            return
        }
        currentquantity += 1
        print(currentquantityproduct)
        product["Order"] = currentquantityproduct
        arrProduct.remove(at: sender.tag)
        arrProduct.insert(product, at: sender.tag)
        cell?.btnOrderValue.setTitle(String.init(format:"%d",currentquantity), for: .normal)
        
    }
    
    @objc func minusOrderClicked(sender:UIButton)->(){
        let indexpath = IndexPath.init(row: sender.tag , section: 0)
        let cell = tblProduct.cellForRow(at: indexpath) as? StockOrderCell
        var product = arrProduct[indexpath.row]
        var currentquantityproduct = product["Order"] as? Int ?? 0
        if(currentquantityproduct > 0){
            currentquantityproduct -= 1
        }
        guard var currentquantity = Int(cell?.btnOrderValue.currentTitle ?? "0")
        else {
            return
        }
        if(currentquantity > 0){
            currentquantity -= 1
        }
        print(currentquantityproduct)
        product["Order"] = currentquantityproduct
        arrProduct.remove(at: sender.tag)
        if(currentquantity > 0){
            arrProduct.insert(product, at: sender.tag)
        }
        
        cell?.btnOrderValue.setTitle(String.init(format:"%d",currentquantity), for: .normal)
        
    }
    //        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //       //     _ = productDrive[indexPath.row]
    //            SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.show()
    //
    //
    //           if  let productDriveListObj:ProductDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.ProductDetailView) as? ProductDetail
    //           {
    //            productDriveListObj.startFrom =  indexPath.row
    //            productDriveListObj.fromProductDrive =  false
    //           // productDriveListObj.arrOfProduct = self.arrProduct
    //
    //            SVProgressHUD.dismiss()
    //            self.navigationController?.pushViewController(productDriveListObj, animated: true)
    //            }
    //
    //        }
    
    // MARK: Action
    @objc func gotProductDetails(sender:UIButton){
        sender.isSelected != sender.isSelected
        let dict  =  arrProduct[sender.tag]
        let objproduct = Product.getProduct(productID: NSNumber.init(value:dict["ProductID"] as? Int ?? 0))
        if let productdetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.ProductDetailView) as? ProductDetail{
            productdetail.product = objproduct
            productdetail.fromProductDrive =  false
            // productdetail.objProduct = [String:Any]
            self.navigationController?.pushViewController(productdetail, animated: true)
        }
    }
    @IBAction func close(_ sender: UIButton) {
        txtSearch.text = ""
        updateSearchArray(searchtext: txtSearch.text ?? "")
        //        arrProduct = [[String:Any]]()
        self.tblProduct.reloadData()
    }
    
    @IBAction func addMoreProducts(_ sender: UIButton){
        self.productReadyForAdd()
        arrProduct.removeAll()
        self.initDropDown()
        tblProduct.reloadData()
        txtSearch.text = ""
    }
    
    @IBAction func selectProductCategory(_ sender: UIButton) {
        arrProductCatrgory = [ProdCategory]()
        arrProductCatrgory.append(contentsOf: ProdCategory.getAll())
        let pro:ProdCategory = ProdCategory.mr_createEntity() ?? ProdCategory()
        pro.name = "All"
        pro.iD = 0
        arrProductCatrgory.insert(pro, at: 0)
        
        chooseProductCategory.dataSource = arrProductCatrgory.map {
            $0.name
            
        }
        //ProdCategory.getAll()
        chooseProductCategory.show()
        
        
    }
    
    @IBAction func selectProductSubCategory(_ sender: UIButton) {
        chooseProductSubCategory.show()
    }
    @IBAction func productSubmit(_ sender: UIButton) {
        self.productReadyForAdd()
        var arrOfProduct = [SelectedProduct]()
        
        for dic in tempProducts{
            let sproduct = SelectedProduct().initwithdic(dict: dic)
            if let a = tempSO.filter({ dict in
                return (dic["ProductID"] as? Int == dict["ProductID"] as? Int)
            }).first {
                sproduct.quantity = "\(a["Quantity1"] as? Int ?? 0)"
            }
            self.multipleproductselectiondelegate?.addProductFromMultipleSelection(product: sproduct)
            arrOfProduct.append(sproduct)
        }
        
        self.stockReturn?(tempSO)

        self.navigationController?.popViewController(animated: true)
        
        //self.multipleproductselectiondelegate?.addProductFromMultipleSelection(arr: arrOfProduct)
        
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
extension MultipleProductSelection:UITextFieldDelegate{
    
}
//extension MultipleProductSelection:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrProduct.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       if  let cell:StockOrderCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? StockOrderCell
//       {
//        return cell
//       }else{
//        return UITableViewCell()
//        }
//    }
//
//
//}
