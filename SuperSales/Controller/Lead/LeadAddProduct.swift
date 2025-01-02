//
//  LeadAddProduct.swift
//  SuperSales
//
//  Created by Apple on 20/07/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
protocol  LeadAddProductDelegate{
    func updateProductInfo(product:SelectedProduct,Record:Int)->()
}
class LeadAddProduct: BaseViewController {
    static var arrOfProduct:[SelectedProduct]! = [SelectedProduct]()
    static var arrOfProductDic:[[String:Any]] = [[String:Any]]()
    static var arrOfEditProduct:[SelectedProduct]! = [SelectedProduct]()
   
    @IBOutlet weak var tblProduct: UITableView!
     @IBOutlet weak var tblProductListHeight: NSLayoutConstraint!
    var tableViewHeight: CGFloat {
        tblProduct.layoutIfNeeded()
        return tblProduct.contentSize.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setUI()
        // Do any additional setup after loading the view.
    }
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setUI()
    }
    //MARK: - Method
    func setUI(){
        tblProduct.tableFooterView = UIView()
        tblProduct.separatorColor = UIColor.clear
        tblProduct.delegate = self
        tblProduct.dataSource = self
        tblProduct.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 200, right: 0)
        
        if(AddLead.isEditLead == true){
            LeadAddProduct.arrOfProduct = [SelectedProduct]()
            LeadAddProduct.arrOfProductDic = [[String:Any]]()
            if(LeadAddProduct.arrOfEditProduct.count == 0){
            for product in AddLead.objLead.productList{
        if let addedproduct = product as? ProductsList{
            
            
        var dic = [String:Any]()
        var subcatid = 0
        var budget = 0
    if  let subcat = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value:addedproduct.categoryID)){
        subcatid = Int(subcat.iD)
        }
            if let pbudget = addedproduct.budget{
                budget = Int(pbudget)
        }
            var strProductName = ""
            if let productname = addedproduct.productName as? String{
                if(productname.count > 0){
                let productName = productname
             strProductName.append(productName)
                }else{
                   
            if let subcatid = addedproduct.subcategoryID as? Int64 {
            if(subcatid > 0){
            let prosubcat = ProductSubCat.getSubCatName(subcatid: NSNumber.init(value:subcatid))
                        if(prosubcat.count > 0){
                            strProductName.append(("SubCat: \(prosubcat) \n"))
                        }
                        }
                     }else{
                if let catid = addedproduct.categoryID as? Int64 {
                            let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:catid))
                            if(procatname.count > 0){
                                strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                            }
                        }
                    }
                }
            }else{
             
                      if let catid = addedproduct.categoryID as? Int64 {
                            let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:addedproduct.categoryID))
                            if(procatname.count > 0){
                                strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                            }
                        }
                   
                }
//
            dic = ["productName":strProductName,"ProductID":addedproduct.productID,"CategoryID":addedproduct.categoryID,"SubCategoryID":subcatid,"Quantity":String.init(format:"\(addedproduct.quantity)") ,"Budget": String.init(format:"\(budget)")] as [String : Any]
let product = SelectedProduct().initwithdic(dict: dic)
LeadAddProduct.arrOfProduct.append(product)
LeadAddProduct.arrOfEditProduct.append(product)
                }
            }
            }else{
                for product in AddLead.objLead.productList{
            if let addedproduct = product as? ProductsList{
                
                
            var dic = [String:Any]()
            var subcatid = 0
            var budget = 0
        if  let subcat = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value:addedproduct.categoryID)){
            subcatid = Int(subcat.iD)
            }
                if let pbudget = addedproduct.budget{
                    budget = Int(pbudget)
            }
                var strProductName = ""
                if let productname = addedproduct.productName as? String{
                    if(productname.count > 0){
                    let productName = productname
                 strProductName.append(productName)
                    }else{
                       
                if let subcatid = addedproduct.subcategoryID as? Int64 {
                if(subcatid > 0){
                let prosubcat = ProductSubCat.getSubCatName(subcatid: NSNumber.init(value:subcatid))
                            if(prosubcat.count > 0){
                                strProductName.append(("SubCat: \(prosubcat) \n"))
                            }
                            }
                         }else{
                    if let catid = addedproduct.categoryID as? Int64 {
                                let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:catid))
                                if(procatname.count > 0){
                                    strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                                }
                            }
                        }
                    }
                }else{
                 
                          if let catid = addedproduct.categoryID as? Int64 {
                                let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:addedproduct.categoryID))
                                if(procatname.count > 0){
                                    strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                                }
                            }
                       
                    }
    //
                dic = ["productName":strProductName,"ProductID":addedproduct.productID,"CategoryID":addedproduct.categoryID,"SubCategoryID":subcatid,"Quantity":String.init(format:"\(addedproduct.quantity)") ,"Budget": String.init(format:"\(budget)")] as [String : Any]
    let product = SelectedProduct().initwithdic(dict: dic)
    LeadAddProduct.arrOfProduct.append(product)
   
                    }
                }
            }
for prod in LeadAddProduct.arrOfProduct{
                var dic = [String:Any]()
    if(self.activesetting.leadProductPermission == 2){
        dic["Budget"] = String.init(format:"%@",prod.price ?? 0)
    }else{
        dic["Budget"] = String.init(format:"%@",prod.budget ?? 0)
        }
              //dic["Budget"] = prod.budget
                dic["CategoryID"] = prod.productCatId
                dic["ProductID"] = prod.productID
                dic["Quantity"] = prod.quantity
                dic["SubCategoryID"] = prod.productSubCatId
                //print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
                LeadAddProduct.arrOfProductDic.append(dic)
                    }
           // print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
        }else{
//            LeadAddProduct.arrOfProduct = [SelectedProduct]()
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
    //MARK: - IBAction
    
    @IBAction func btnAddProductClicked(_ sender: UIButton) {
if(self.activesetting.leadProductPermission == 2){
            if let multipleproductselection = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MultipleProductSelection) as? MultipleProductSelection{
                let dicLead = AddLead.LeadDic["addleadjson"] as? [String:Any]
               if let cid = LeadCustomerDetail.selectedCustomer as? CustomerDetails{
                    multipleproductselection.customerId = NSNumber.init(value:LeadCustomerDetail.selectedCustomer.iD)
                    }
                multipleproductselection.isLead1 =  true
                multipleproductselection.issalesorder = false
                multipleproductselection.multipleproductselectiondelegate = self
      //          multipleproductselection.customerId =
self.navigationController?.pushViewController(multipleproductselection, animated: true)
                }
        }else{
if let addproductobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.SingleProductSelection) as? Addproduct{
    addproductobj.isFromProductStock = false
    addproductobj.isVisit = false
    addproductobj.isLead1 =  true
    if let selectedcustomer = LeadCustomerDetail.selectedCustomer as? CustomerDetails{
    addproductobj.customerId = LeadCustomerDetail.selectedCustomer.iD
    }
    addproductobj.isFromSalesOrder =  false
addproductobj.productselectionfrom = ProductSelectionFromView.lead
addproductobj.productselectiondelegate = self
addproductobj.modalPresentationStyle = .overCurrentContext
    addproductobj.parentviewforpopup = self.view
    Utils.addShadow(view: self.view)
    self.present(addproductobj, animated: true, completion: nil)
        }
    }
}
}
extension LeadAddProduct:ProductSelectionDelegate{
    func addProduct1(product: SelectedProduct) {
        
        Utils.removeShadow(view: self.view)
        for prod in LeadAddProduct.arrOfProduct{
            if(prod.productID == product.productID && self.activesetting.productMandatoryInLead == 1){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view: self.view)
                return
            }else if((self.activesetting.productMandatoryInLead == 0)&&(prod.productID == product.productID)&&(prod.productSubCatId == product.productSubCatId)&&(prod.productCatId == product.productCatId)){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view: self.view)
                return
            }
        }
        LeadAddProduct.arrOfProduct.append(product)
        LeadAddProduct.arrOfEditProduct.append(product)
        LeadAddProduct.arrOfProductDic = [[String:Any]]()
        for prod in LeadAddProduct.arrOfProduct{
            var dic = [String:Any]()
            if(self.activesetting.leadProductPermission == 2){
                dic["Budget"] = String.init(format:"%@",prod.price ?? 0)
            }else{
                dic["Budget"] = String.init(format:"%@",prod.budget ?? 0)
            }
            // dic["Budget"] = prod.budget
            dic["CategoryID"] = prod.productCatId
            dic["ProductID"] = prod.productID
            dic["Quantity"] = prod.quantity
            dic["SubCategoryID"] = prod.productSubCatId
            // print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
            LeadAddProduct.arrOfProductDic.append(dic)
            //   print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
        }
        tblProductListHeight.constant = tableViewHeight
        tblProduct.layoutIfNeeded()
        tblProduct.reloadData()
        tblProductListHeight.constant = tableViewHeight
        tblProduct.layoutIfNeeded()
        tblProduct.reloadData()
    }
    
    
}
extension LeadAddProduct:LeadAddProductDelegate{
    func updateProductInfo(product:SelectedProduct,Record:Int)->(){
        LeadAddProduct.arrOfProduct.remove(at: Record)
        LeadAddProduct.arrOfEditProduct.remove(at: Record)
        LeadAddProduct.arrOfProduct.insert(product, at: Record)
        LeadAddProduct.arrOfEditProduct.insert(product, at: Record)
        LeadAddProduct.arrOfProductDic = [[String:Any]]()
        for prod in LeadAddProduct.arrOfProduct{
                        var dic = [String:Any]()
            if(self.activesetting.leadProductPermission == 2){
                dic["Budget"] = String.init(format:"%@",prod.price ?? 0)
            }else{
                dic["Budget"] = String.init(format:"%@",prod.budget ?? 0)
                }
                      //dic["Budget"] = prod.budget
            dic["CategoryID"] = prod.productCatId
            dic["ProductID"] = prod.productID
            dic["Quantity"] = prod.quantity
            dic["SubCategoryID"] = prod.productSubCatId
         //   print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
        LeadAddProduct.arrOfProductDic.append(dic)
                            }
    }
}
extension LeadAddProduct:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return LeadAddProduct.arrOfProduct.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProductCell{
            cell.leadDelegate = self
            cell.selectionStyle = .none
            
        let product = LeadAddProduct.arrOfProduct[indexPath.row]
          
    cell.lblProductName.text = product.productName
          
    cell.tfQty.text = String.init(format:"%@",product.quantity ?? 0)
if(self.activesetting.leadProductPermission == 2){
    let strprice = String.init(format:"%@",product.price ?? 0)
    if let tfstrprice = strprice as? String{
        if(tfstrprice.count > 0){
            cell.tfBudget.text = String.init(format:"%@",product.price ?? 0)
        }else{
            cell.tfBudget.text = String.init(format:"%@",product.budget ?? 0)
        }
    }else{
        cell.tfBudget.text = String.init(format:"%@",product.budget ?? 0)
    }

}else{
cell.tfBudget.text = String.init(format:"%@",product.budget ?? 0)
    }
            cell.setProductInfo(pro: product, record: indexPath.row)

    cell.btnDelete.tag = indexPath.row
            cell.delegate = self
            //self.btnSearchCustomerClicked(_:)
         //   cell.btnDelete.addTarget(self, action: #selector(deleteProduct(_:)), for: UIControl.Event.touchUpInside)
            
            cell.deleteAction = { sender in
                self.deletePro(index1: indexPath.row)
            }
           return cell
           }else{
              return UITableViewCell()
           }
       }
  //  @objc func deleteProduct(sender:AnyObject)->(){
//        var touches = event.allTouches()!        \
//        let  touches = (event as AnyObject).allTouches  as? Set<UITouch>
//        if let touch = touches?.first as? UITouch{
//            var currentTouchPosition = touch.location(in: tblProduct)
//            if let  indexPath = tblProduct.indexPathForRow(at: currentTouchPosition ) as? IndexPath{//tblProduct.indexPathForRow(atPoint: currentTouchPosition)!
//            print("position:\(indexPath.row)")
//            }
//        }
    
           
       func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
       return 40
       }
          
       func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
    return tableView.contentSize.height
       }
          
}
extension LeadAddProduct : ProductCellDelegate{
    
    
    func deleteProduct(cell: ProductCell) {
        if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
        let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
        let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in

            print(LeadAddProduct.self.arrOfProduct.count)
            LeadAddProduct.arrOfProduct.remove(at: indexPath.row)
            LeadAddProduct.arrOfEditProduct.remove(at: indexPath.row)

            self.tblProduct.beginUpdates()
          //
            self.tblProduct.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
            self.tblProduct.reloadData()
           // self.tblProduct.deleteRows(at: [(self.tblProduct.indexPathForRow(at: localpoint) ?? IndexPath.init(row: 0, section: 0))], with: UITableView.RowAnimation.top)
            self.tblProduct.endUpdates()
        
            
        }
        Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
        }
    }
    
    func deletePro(index1: Int) {
       
        if let localpoint = tblProduct.convert(CGPoint.zero, to: self.tblProduct) as? CGPoint{
            if let   indexPath = self.tblProduct.indexPathForRow(at: localpoint) as? IndexPath{
            print("clicked pro no = \(indexPath.row) ,index is = \(index1)")
            }
        let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
        let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in

            print(LeadAddProduct.self.arrOfProduct.count)
            LeadAddProduct.arrOfProduct.remove(at: index1)
            LeadAddProduct.arrOfEditProduct.remove(at: index1)
//        LeadAddProduct.arrOfProduct.remove(at: self.tblProduct.indexPathForRow(at: localpoint)?.row ?? 0)
//            LeadAddProduct.arrOfEditProduct.remove(at: self.tblProduct.indexPathForRow(at: localpoint)?.row ?? 0)
            self.tblProduct.beginUpdates()
          //
            self.tblProduct.deleteRows(at: [IndexPath.init(row: index1, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
           // self.tblProduct.deleteRows(at: [(self.tblProduct.indexPathForRow(at: localpoint) ?? IndexPath.init(row: 0, section: 0))], with: UITableView.RowAnimation.top)
            self.tblProduct.reloadData()
            self.tblProduct.endUpdates()
              
            
        }
        Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
        }
    }
}
extension LeadAddProduct:MultipleProductSelectionDelegate{
    
    func addProductFromMultipleSelection(product: SelectedProduct) {

for prod in LeadAddProduct.arrOfProduct{
if(prod.productID == product.productID){
Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view: self.view)
return
                }
    
            }
LeadAddProduct.arrOfProduct.append(product)
        LeadAddProduct.arrOfEditProduct.append(product)
        
var dic = [String:Any]()
        if(self.activesetting.leadProductPermission == 2){
            dic["Budget"] = String.init(format:"%@",product.price ?? 0)
        }else{
            dic["Budget"] = String.init(format:"%@",product.budget ?? 0)
            }
//dic["Budget"] =  product.budget
dic["CategoryID"] = product.productCatId
dic["ProductID"] = product.productID
dic["Quantity"] = product.quantity
dic["SubCategoryID"] = product.productSubCatId
      //  print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
        LeadAddProduct.arrOfProductDic.append(dic)
                
        tblProductListHeight.constant = tableViewHeight
        tblProduct.layoutIfNeeded()
        tblProduct.reloadData()
        tblProductListHeight.constant = tableViewHeight
        tblProduct.layoutIfNeeded()
        tblProduct.reloadData()
        }

    }
