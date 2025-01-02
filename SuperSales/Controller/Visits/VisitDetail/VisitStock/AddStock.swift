//
//  AddStock.swift
//  SuperSales
//
//  Created by Apple on 24/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol  AddStockDelegate{
    func updateProductInfo(product:SelectedProduct,Record:Int)->()
}
class AddStock: BaseViewController {

    @IBOutlet weak var lblVisitNo: UILabel!
    var planvisit:PlannVisit!
    var unplanvisit:UnplannedVisit!
    var visitType:VisitType!
    var arrOfProduct:[SelectedProduct] = [SelectedProduct]()
 //   @IBOutlet weak var cnstProductListHt: NSLayoutConstraint!
    var tableViewHeight: CGFloat{
        tblProductList.layoutIfNeeded()
        return tblProductList.contentSize.height
    }
    
    @IBOutlet weak var tblProductList: UITableView!
    
    @IBOutlet weak var btnUpdateStock: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Method
    func setUI(){
        self.title = "Update Stock"
        btnUpdateStock.setbtnFor(title:NSLocalizedString("updatestock", comment: ""), type: Constant.kPositive)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        
if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory)
{
lblVisitNo.text = String.init(format: "Visit No: %ld", unplanvisit.localID ?? 0)
        }
else
{
lblVisitNo.text = String.init(format: "Visit No: %ld", planvisit.seriesPostfix)
}

tblProductList.estimatedRowHeight = 40
tblProductList.rowHeight = UITableView.automaticDimension
tblProductList.delegate = self
tblProductList.dataSource = self
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: IBAction
    
    @IBAction func addProduct(_ sender: UIButton) {
        if(self.activesetting.visitUpdateStockProductPermission == NSNumber.init(value: 2)){
            if let multipleproductselection = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MultipleProductSelection) as? MultipleProductSelection{
                Common.skipVisitSelection = false
                multipleproductselection.issalesorder = false
                multipleproductselection.multipleproductselectiondelegate = self
                if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.planedvisitHistory){
                    multipleproductselection.customerId = NSNumber.init(value: planvisit.customerID)
                }
                else{
                multipleproductselection.customerId = unplanvisit.customerID ?? NSNumber.init(value: 0)
                }
            self.navigationController?.pushViewController(multipleproductselection, animated: true)
            }
        }else{
        if let addproductobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.SingleProductSelection) as? Addproduct{
            addproductobj.isFromProductStock =  true
            addproductobj.isVisit = true
            addproductobj.isCut = true
            addproductobj.isFromSalesOrder =  false
            addproductobj.productselectiondelegate = self
            addproductobj.modalPresentationStyle = .overCurrentContext
            addproductobj.parentviewforpopup = self.view
            Utils.addShadow(view: self.view)
               self.present(addproductobj, animated: true, completion: nil)
                   }
        }
    
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        if(arrOfProduct.count > 0){
            
            let strcurrentdt = String.init(format: "%@ 00:00:00", Utils.getDateWithAppendingDay(day: 0, date: Date(), format: "yyyy/MM/dd", defaultTimeZone: true))
             var jsonpro = [[String:Any]]()
            for prod in arrOfProduct{
                var dic = [String:Any]()
                if(visitType == VisitType.coldcallvisit){
                    dic["VisitID"] =  unplanvisit.localID
                }else{
                    dic["VisitID"] = NSNumber.init(value:planvisit.iD)
                }
                dic["CreatedBy"] = self.activeuser?.userID
                dic["StockDate"] = strcurrentdt
                dic["ProductID"] = prod.productID
                dic["Quantity"] = prod.quantity
                jsonpro.append(dic)
            }
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            //updateVisitUpdateStockJson
            var param = Common.returndefaultparameter()
            param["updateVisitUpdateStockJson"] =  Common.json(from: jsonpro)
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlUpdateVisitStock, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                     if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                    self.planvisit?.isStockAvailable = 1
                    self.planvisit?.managedObjectContext?.mr_save({ (localcontext) in
                        print("saving")
                    }, completion: { (status, error) in
                        print(error?.localizedDescription ?? "no error")
                        print("saved , \(self.planvisit?.isPictureAvailable)")
                        
                    })
                    self.navigationController?.popViewController(animated: true)
                }else if(error.code == 0){
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                }else{
                   Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                }
            }
        }else{
            Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view: self.view)
        }
    }
    
}


extension AddStock:MultipleProductSelectionDelegate{
func addProductFromMultipleSelection(product: SelectedProduct) {
print("Selected Multiple products \(product)")
    for prod in arrOfProduct{
        if(prod.productID == product.productID){
Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view: self.view)
                return
            }
        }
    arrOfProduct.append(product)
    tblProductList.layoutIfNeeded()
    tblProductList.layoutSubviews()
    tblProductList.reloadData()
    DispatchQueue.main.async {
  

     self.tblProductList.layoutIfNeeded()
     self.tblProductList.reloadData()
         }
       
    }

}

extension AddStock:AddStockDelegate{
    func updateProductInfo(product:SelectedProduct,Record:Int)->(){
        arrOfProduct.remove(at: Record)
        arrOfProduct.insert(product, at: Record)
    }
}
extension AddStock:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return arrOfProduct.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProductCell{
            cell.addStockDelegate = self
           let product = arrOfProduct[indexPath.row]
           cell.stkBudget.isHidden = true
            cell.delegate = self
//           cell.lblProductName.text = product.productName
//           cell.tfQty.text = String.init(format:"%@",product.quantity ?? 0)
            cell.setProductInfo(pro: product, record: indexPath.row)
             cell.btnDelete.tag =  indexPath.row
           //           cell.btnDelete.addTarget(self, action:#selector(deleteProduct), for: .touchUpInside)
           return cell
           }else{
              return UITableViewCell()
           }
       }
           
       func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
        return UITableView.automaticDimension//40
       }
          
       func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
            return UITableView.automaticDimension
       }
   /* @objc func deleteProduct(sender:UIButton)->(){
        if let localpoint = tblProductList.convert(CGPoint.zero, to: sender) as? CGPoint{
            let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
            let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
    //            print(localpoint.tag) print(sender.tag)
                print(self.arrOfProduct.count)
              
                self.arrOfProduct.remove(at: self.tblProductList.indexPathForRow(at: localpoint)?.row ?? 0)
                self.tblProductList.beginUpdates()
                //self.tblProduct.deleteRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: true)
                self.tblProductList.deleteRows(at: [(self.tblProductList.indexPathForRow(at: localpoint) ?? IndexPath.init(row: 0, section: 0))], with: UITableView.RowAnimation.top)
                self.tblProductList.endUpdates()
                  
                
            }
            Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)

}
       
        tblProductList.beginUpdates()
        tblProductList.deleteRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
        tblProductList.endUpdates()
       
    }*/
}
extension AddStock : ProductCellDelegate{
    func deleteProduct(cell: ProductCell) {
        if let indexPath = tblProductList.indexPath(for: cell) as? IndexPath{
        let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
        let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in


            self.arrOfProduct.remove(at: indexPath.row)
           

            self.tblProductList.beginUpdates()
        
            self.tblProductList.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
            DispatchQueue.main.async {
                self.tblProductList.layoutIfNeeded()
                self.tblProductList.reloadData()
               // self..constant = self.tblProduct.contentSize.height
            }
            self.tblProductList.endUpdates()


        }
        Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
        }
    }
    
    func deletePro(index1: Int) {
       
        if let localpoint = tblProductList.convert(CGPoint.zero, to: self.tblProductList) as? CGPoint{
            if let   indexPath = self.tblProductList.indexPathForRow(at: localpoint) as? IndexPath{
            print("clicked pro no = \(indexPath.row) ,index is = \(index1)")
            }
        let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
        let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in

           
            self.arrOfProduct.remove(at: index1)
           

            self.tblProductList.beginUpdates()
          //
            self.tblProductList.deleteRows(at: [IndexPath.init(row: index1, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
           // self.tblProduct.deleteRows(at: [(self.tblProduct.indexPathForRow(at: localpoint) ?? IndexPath.init(row: 0, section: 0))], with: UITableView.RowAnimation.top)
            self.tblProductList.endUpdates()
              
            
        }
        Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item"
                                                          , comment: ""), arrAction: [yesAction,noAction], view: self)
        }
    }
}

extension AddStock:ProductSelectionDelegate{
   
         func addProduct1(product: SelectedProduct) {
        Utils.removeShadow(view: self.view)
            for prod in arrOfProduct{
        if(prod.productID == product.productID){
        Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: "") ,view: self.view)
                    return
                }
                
                if(prod.quantity?.count == 0){
                    Utils.toastmsg(message:String.init(format: "%@ %@", NSLocalizedString("please_add_product_quantity_greater_than_0_to", comment: "") ,prod.productName!) ,view: self.view)
                    return
                }
            }
            
      //      [self.view.window makeToast:FormatString(@"%@ %@",NSLocalizedString(@"please_add_product_quantity_greater_than_0_to", @""), dict[@"productName"])];
            arrOfProduct.append(product)
           DispatchQueue.main.async {
         // self.cnstProductListHt.constant = self.tableViewHeight

            self.tblProductList.layoutIfNeeded()
            self.tblProductList.reloadData()
                }
           // cnstProductListHt.constant = tableViewHeight
            tblProductList.layoutIfNeeded()
            tblProductList.reloadData()
           //
    }

}
