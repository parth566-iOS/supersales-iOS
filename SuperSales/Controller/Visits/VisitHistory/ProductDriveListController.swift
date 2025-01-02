//
//  ProductDriveListController.swift
//  SuperSales
//
//  Created by Apple on 21/06/19.
//  Copyright © 2019 Big Bang Innovations. All rights reserved.
//

import UIKit

class ProductDriveListController: BaseViewController {

    @IBOutlet weak var tblProductDrive: UITableView!
    @objc open var ObjVisit:_PlannVisit!
    var productDrive:Array<Any>! = Array()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.showNavBar1()
      
        //self.title = "Product Drive";
        self.title = NSLocalizedString("Product_Drive", comment: "")
        tblProductDrive.delegate = self
        tblProductDrive.dataSource =  self
        tblProductDrive.tableFooterView = UIView(frame: CGRect.zero)
        tblProductDrive.separatorColor = .clear
        
        
        productDrive = Array<_Product>()
        
        tblProductDrive.addPullToRefresh {
            self.getProductDriveList()
        }
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
    //MARK: - API Call
    func getProductDriveList(){
        //http://supersales.co:8080/salesprodev/getProductsForDrive?CompanyID=107&UserID=293&CustomerID=1379
        
        let account = Utils.getActiveAccount()
        
        let param = NSMutableDictionary()
       
        var strUrl:String = String.init()
        strUrl.append(kBaseTeamworkURL)
        strUrl.append(KWSUrlGetProductDriveList)
        
        
        param.setObject(account?.user_id ?? 1, forKey: "UserID" as NSCopying)
        //param.setObject(account?.securityToken ?? 1, forKey: "TokenID" as NSCopying)
        param.setObject(account?.company_info.company_id ?? 1, forKey: "CompanyID" as NSCopying)
        // param.setObject(1, forKey: "CompanyID" as NSCopying)
        param.setObject(ObjVisit?.customerID ?? 1 , forKey: "CustomerID" as NSCopying)
        print(param)
        
        /*   callAPIget(methodName: "get" , url: kBaseTeamworkURL + KWSUrlAvailablePromotionList, parameter: param as! [String : Any],completionHandler: (status,result),{
         
         })*/
        
        callAPIget(methodName: "get", url:strUrl , parameter: param as! [String : Any]) { (status, result) in
            SVProgressHUD.dismiss()
            print(status)
            if(status.lowercased() == "success"){
                self.tblProductDrive.pullToRefreshView.stopAnimating()
                do{
                    //here dataResponse received from a network request
                    
                    print(result )
                    let resultModel = Result(result as! [String : Any])
                    var arrOfProduct:Array<Product> = Array()
                    print(resultModel)
                    if(resultModel.status.lowercased() == "success" ){
                        
                        if(resultModel.data.count == 0 &&  resultModel.dataString.count == 0){
                          //  self.view.makeToast(resultModel.message)
                           // self.dataInt  = dictionary["data"] as? Array<Int> ?? [Int]()
                            let Dic = result as! [String:Any]
                          
                            print(Dic)
                            arrOfProduct = Array()
                            for item in Dic["data"] as? [Any] ?? Array(){
                                
                                print(item)
                                let product = _Product.getProduct(item as? NSNumber)
                                arrOfProduct.append(product as! Product)
                         
                            }
                            
                            self.productDrive  = arrOfProduct as? Array<Any>
                        
                            print(self.productDrive)
                            if(arrOfProduct.count == 0){
                                 self.view.makeToast("Product Drive Not Available")
                            }
                          
                            self.tblProductDrive.reloadData()
                        }
                        else{
                          //  self.view.makeToast(resultModel.message)
                           // self.dataInt = [Int]()
                        }
                       //
                        

                       
                      
                            self.tblProductDrive.reloadData()
                      
                    }
                    else{
                        self.view.makeToast(resultModel.message)
                       // self.showAlert(withMessage: "SomeThing Went Wrong")
                        
                    }
                }
            }
                
            else{
                self.tblProductDrive.pullToRefreshView.stopAnimating()
              //  self.showAlert(withMessage: "SomeThing Went Wrong Please try again")
            }
        }
    }

}
extension ProductDriveListController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return self.productDrive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productcellswift", for: indexPath) as! ProductCellSwift
            //tableView.dequeueReusableCell(withIdentifier: "test") as UITableViewCell? ?? UITableViewCell()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
      
        let product = productDrive[indexPath.row] as! Product
        cell.lblProductName.textAlignment =  NSTextAlignment.left
        cell.lblProductName.text = product.productName
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   //     _ = productDrive[indexPath.row]
        SVProgressHUD.show()
        let productObj:UIStoryboard  =
            UIStoryboard.init(name: "Products", bundle: nil)
       
        let productDriveListObj:ProductDetails = productObj.instantiateViewController(withIdentifier: "productdetails") as! ProductDetails
        
        productDriveListObj.startFrom =  Int32(indexPath.row)
        productDriveListObj.fromProductDrive =  true
        productDriveListObj.arrOfProduct = self.productDrive  as! [Any]
   
        SVProgressHUD.dismiss()
        self.navigationController?.pushViewController(productDriveListObj, animated: true)
      
    }
    
}
