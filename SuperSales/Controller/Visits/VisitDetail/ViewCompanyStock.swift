//
//  ViewCompanyStock.swift
//  SuperSales
//
//  Created by Apple on 27/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewCompanyStock: BaseViewController {

    @IBOutlet weak var tblStock: UITableView!
    var filter = 0
    var filterdata = 0
    var arrCompanyStock:[CompanyStock]! = [CompanyStock]()
    var popup:CustomerSelection? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadCompanyStock()
    }
    // MARK: - Method
    func setUI(){
        self.title = NSLocalizedString("View Company Stock", comment:"")
        tblStock.tableFooterView = UIView()
        tblStock.separatorColor = UIColor.clear
        tblStock.delegate = self
        tblStock.dataSource = self
        
    }
    // MARK: - IBAction
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        let ftcellconfig = FTCellConfiguration.init()
                      ftcellconfig.textColor = UIColor.black
                      let ftconfig = FTConfiguration.shared
              
                      ftconfig.backgoundTintColor =  UIColor.white
              //NSLocalizedString(@"by_product_category", @""),NSLocalizedString(@"by_product_sub_category", @""),NSLocalizedString(@"by_product_sub_category", @"")
              FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("by_product_category", comment:""),NSLocalizedString("by_product_sub_category", comment:""),NSLocalizedString("all", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (i) in
                  print(i)
                switch i{
                case 0:
                    self.filter = 2
                    self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                    self.popup?.modalPresentationStyle = .overCurrentContext
                    self.popup?.strTitle = ""
                    self.popup?.nonmandatorydelegate = self
                    self.popup?.arrOfProductCategory = ProdCategory.getAll()
                    self.popup?.arrOfSelectedProductCategory = [ProdCategory]()
                    self.popup?.strLeftTitle = ""
                    self.popup?.strRightTitle = ""
                    self.popup?.selectionmode = SelectionMode.none
                    
                    self.popup?.isSearchBarRequire = true
                    self.popup?.isFromSalesOrder =  false
                    self.popup?.viewfor = ViewFor.productcategory
                    self.popup?.isFilterRequire = false
                    // popup?.showAnimate()
                    self.present(self.popup!, animated: false, completion: nil)
                    
            
                break
                    case 1:
                        self.filter = 3
                        self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                                      self.popup?.modalPresentationStyle = .overCurrentContext
                                      self.popup?.strTitle = ""
                                      self.popup?.nonmandatorydelegate = self
                                      self.popup?.arrOfProductSubCategory = ProductSubCat.getAll()
                                      self.popup?.arrOfSelectedSubProductCategory = [ProductSubCat]()
                                      self.popup?.strLeftTitle = ""
                                      self.popup?.strRightTitle = ""
                                      self.popup?.selectionmode = SelectionMode.none
                                      
                                      self.popup?.isSearchBarRequire = true
                                      self.popup?.isFromSalesOrder =  false
                                      self.popup?.viewfor = ViewFor.productsubcategory
                                      self.popup?.isFilterRequire = false
                                      // popup?.showAnimate()
                                      self.present(self.popup!, animated: false, completion: nil)
                        break
               
                case 2:
                    self.filter = 0
                    self.filterdata = 0
                    self.loadCompanyStock()
                    break
                    
                     default:
                    break
                    
                }
        })
                
    }
    
    // MARK: - APICall
    func loadCompanyStock(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["Filter"]  = filter
        param["FilterData"]  = filterdata
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlViewCompanyStock, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        self.arrCompanyStock.removeAll()
        SVProgressHUD.dismiss()
       
        if(status.lowercased() == Constant.SucessResponseFromServer){
             print(responseType)
            if(responseType ==  ResponseType.arr){
                           let arrOfCompanyStock = arr as? [[String:Any]] ?? [[String:Any]]()
                           if(arrOfCompanyStock.count > 0){
                               for companystock in  arrOfCompanyStock{
                                   let stock  = CompanyStock().initwithdic(dic: companystock)

                                   self.arrCompanyStock.append(stock)
                                   
                               }
                            self.tblStock.reloadData()
                           }else{
                            self.tblStock.reloadData()
                }
                 if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }
        }else if(error.code == 0){
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        }else{
        Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view: self.view)
        }
        }
             self.tblStock.reloadData()
       
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
extension ViewCompanyStock:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCompanyStock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ForuLabelVerticalCell, for: indexPath) as? FourLblVerticalCell{
           
            let stock = arrCompanyStock[indexPath.row]
            if let product =  Product.getProduct(productID: stock.productID!) as? Product{
                print(product.productSubCatId)
                if    let productsubcat = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value:product.productSubCatId)) as? ProductSubCat{
                let productCategory =
                 ProdCategory.getProductByCatID(catId: NSNumber.init(value:product.productCatId))
              
                    cell.lblCustomerName.text =  String.init(format: "%@ \n %@ \n %@",productCategory?.name ?? "",productsubcat.name ?? "",product.productName ?? "")
                }
//
            }else{
            cell.lblCustomerName.text = ""
            }
            
           
        
            cell.lblCustomerName.setMultilineLabel(lbl: cell.lblCustomerName)
            var onhandstock =  NSMutableAttributedString()
            onhandstock = onhandstock.stratributed(bold: "Onhand Stock : ", normal: String.init(format: "%@", stock.onHandStock ?? 0))
           
            var availablestock =  NSMutableAttributedString()
            availablestock = availablestock.stratributed(bold: "Available Stock : ", normal: String.init(format: "%@", stock.availableStock ?? 0))
             cell.lblCustomerContactNo.attributedText = availablestock
            cell.lblCustomerAddress.attributedText = onhandstock
            var shipperstock =  NSMutableAttributedString()
            shipperstock = shipperstock.stratributed(bold: "Shipper Stock : ", normal: String.init(format: "%@", stock.shipperStock ?? 0))
            cell.lblTime.attributedText = shipperstock
            
            return cell
        }else{
        return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension ViewCompanyStock:PopUpDelegateNonMandatory{



func completionProductCategory(arr: [ProdCategory]) {
    Utils.removeShadow(view: self.view)
    if(arr.count > 0){
        let selectedCategory = arr.first
        self.filterdata = Int(selectedCategory?.iD ?? 0)
        self.loadCompanyStock()
    }
}
    
    func completionProductSubCategory(arr: [ProductSubCat]) {
        Utils.removeShadow(view: self.view)
        if(arr.count > 0){
            let selectedCategory = arr.first
            self.filterdata = Int(selectedCategory?.iD ?? 0)
            self.loadCompanyStock()
        }
    }

}
