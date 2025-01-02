//
//  ProductDriveListController.swift
//  SuperSales
//
//  Created by Apple on 21/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit
import SVProgressHUD


class ProductDriveListController: BaseViewController {

    @IBOutlet weak var tblProductDrive: UITableView!
    @objc open var ObjVisit:PlannVisit!
    var productDrive:Array<Any>! = Array()
  
    override func viewDidLoad() {
        super.viewDidLoad()
     // self.showNavBar1()
      
        //self.title = "Product Drive";
        self.title = NSLocalizedString("Product_Drive", comment: "")
        tblProductDrive.delegate = self
        tblProductDrive.dataSource =  self
        tblProductDrive.tableFooterView = UIView(frame: CGRect.zero)
        tblProductDrive.separatorColor = .clear
        
        
        productDrive = Array<Product>()
        
//        tblProductDrive.addPullToRefresh {
//            self.getProductDriveList()
//        }
//        productDrive = Array()
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getProductDriveList()
    }
    
    
//    @objc func gotoHome()  {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - API Call
    func getProductDriveList(){
    
        SVProgressHUD.showInfo(withStatus: "Loading")
        var customerID = NSNumber.init(value: 0)
       
            customerID = NSNumber.init(value:ObjVisit.customerID)
            
        
        
        
            
        
self.apihelper.getPromotionList(strurl:ConstantURL.KWSUrlGetProductDriveList,customerId:customerID) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            self.productDrive.removeAll()
            if(error.code == 0){
               
                if(responseType == ResponseType.arrOfAny){
                     let arrOfPromotion = arr as? [Any] ?? [Any]()
                    self.productDrive.removeAll()
                    if(arrOfPromotion.count>0){
                        for int in arrOfPromotion {
                            print(int)
                            let productId = int as? NSNumber
                            let product = Product.getProduct(productID:productId!)
                            self.productDrive.append(product)
                        }
                    }
                    
                }else{
                       let dicOFProductDrive = arr as? [String:Any] ?? [String:Any]()
                    print(dicOFProductDrive)
                }
                if(self.productDrive.count == 0){
                    Utils.toastmsg(message:"No Products in ProductDrive",view: self.view)
                }
                    self.tblProductDrive.reloadData()
                
            }else{
//                AppDelegate.shared.alertWindow.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
 Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
    }

}
extension ProductDriveListController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return self.productDrive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "productcellswift", for: indexPath) as? ProductCellSwift
       {
            //tableView.dequeueReusableCell(withIdentifier: "test") as UITableViewCell? ?? UITableViewCell()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
      
        if  let product = productDrive[indexPath.row] as? Product{
        cell.lblProductName.textAlignment =  NSTextAlignment.left
        cell.lblProductName.text = product.productName
        }
        return cell
       }else{
        return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   //     _ = productDrive[indexPath.row]
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
       
       
       if  let productDriveListObj:ProductDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.ProductDetailView) as? ProductDetail
       {
        productDriveListObj.startFrom =  indexPath.row
        productDriveListObj.fromProductDrive =  true
        productDriveListObj.arrOfProduct = self.productDrive as? [Product]

        SVProgressHUD.dismiss()
        self.navigationController?.pushViewController(productDriveListObj, animated: true)
        }
      
    }
    
}
