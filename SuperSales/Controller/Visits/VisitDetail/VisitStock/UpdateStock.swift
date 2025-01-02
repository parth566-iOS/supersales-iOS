//
//  UpdateStock.swift
//  SuperSales
//
//  Created by Apple on 24/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class UpdateStock: BaseViewController {
    
    @IBOutlet var btnAddStock: UIButton!
    @IBOutlet weak var tblStock: UITableView!
    var planvisit:PlannVisit!
    var unplanvisit:UnplannedVisit!
    var visitType:VisitType!
    var arrStock:[VisitStock] = [VisitStock]()
    var   AlertForGetOTP : UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getStock()
    }
   
    // MARK: - Method
    
    func setUI(){
        tblStock.separatorColor = UIColor.clear
        tblStock.tableFooterView = UIView()
        tblStock.delegate = self
        tblStock.dataSource = self
        if(visitType == VisitType.planedvisitHistory || visitType == VisitType.coldcallvisitHistory){
            btnAddStock.isHidden = true
        }else{
            
            var strnt = ""
            if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.originalNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
               strnt = strn
            }
            }else{
                if let strn = Utils.getDateBigFormatToDefaultFormat(date: unplanvisit?.originalNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                   strnt = strn
                }
            }
            self.dateFormatter.dateFormat =  "yyyy/MM/dd HH:mm:ss"
            let date = self.dateFormatter.date(from: strnt) ?? Date()
            let strnextactionDate =  self.dateFormatter.string(from: date)
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            let planDate = self.dateFormatter.date(from: strnextactionDate)
          //  plandate < createddate
            if(self.activesetting.allowEditVisitDataForPreviousDate == NSNumber.init(value: 0)){

                if(date.isEndDateIsSmallerThanCurrent(checkendDate: Date())){
                btnAddStock.isHidden = true
                    }
                }
            else{
                self.btnAddStock.isHidden = false
            }
        
        
    }
    }
    func updateProduct(product:VisitStock,qty:String,productName:String){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var para = Common.returndefaultparameter()
        var getvisitjson = [String:Any]()
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                          getvisitjson["VisitID"] = unplanvisit.localID
        }else{
                          getvisitjson["VisitID"] = planvisit.iD
        }
        getvisitjson["Quantity"] = qty
        getvisitjson["ProductID"] = product.productID
        getvisitjson["StockDate"] = product.stockDate
        getvisitjson["CreatedBy"] = product.createdBy
        getvisitjson["ID"] =  product.iD
        para["updateVisitUpdateStockJson"] = Common.json(from: [getvisitjson])
               self.apihelper.getdeletejoinvisit(param: para, strurl: ConstantURL.kWSUrlUpdateVisitStock, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                   SVProgressHUD.dismiss()
                   self.tblStock.reloadData()
                   if(status.lowercased() == Constant.SucessResponseFromServer){
                       print(responseType)
                  
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                    self.getStock()
                   }else if(error.code == 0){
                       if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                   }else{
                   Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view: self.view)
                   }
               }
    }
    func deleteProduct(product:VisitStock){
        var para = Common.returndefaultparameter()
               
               var getvisitjson = [String:Any]()
               if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                   getvisitjson["VisitID"] = unplanvisit.localID
               }else{
                   getvisitjson["VisitID"] = planvisit.iD
               }
        getvisitjson["ID"] =  product.iD
        para["deleteStockJson"] = Common.json(from: [getvisitjson])
        self.apihelper.getdeletejoinvisit(param: para, strurl: ConstantURL.kWSUrlUpdateVisitStock, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            self.tblStock.reloadData()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                 print(responseType)
                 self.navigationController?.popViewController(animated: true)
                 if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
            Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view: self.view)
            }
        }
    }
    // MARK: - APICall
    func getStock(){
        var para = Common.returndefaultparameter()
        
        var getvisitjson = [String:Any]()
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            getvisitjson["VisitID"] = unplanvisit.localID
        }else{
            getvisitjson["VisitID"] = planvisit.iD
        }
        para["getVisitStockJson"] =  Common.json(from: getvisitjson)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.apihelper.getdeletejoinvisit(param: para, strurl: ConstantURL.kWSUrlGetVisitStock, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            self.arrStock.removeAll()
            self.tblStock.reloadData()
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(arr)
                
                if(responseType == ResponseType.arr){
                    let arrOfStock = arr as? [[String:Any]] ?? [[String:Any]]()
                    if(arrOfStock.count > 0){
                        self.planvisit?.isStockAvailable = 1
                        self.planvisit?.managedObjectContext?.mr_save({ (localcontext) in
                            print("saving")
                        }, completion: { (status, error) in
                            print(error?.localizedDescription ?? "no error")
                            print("saved , \(self.planvisit?.isPictureAvailable)")
                            
                        })
                        for arr in arrOfStock{
                            let stock = VisitStock().initwithdic(dict: arr)
                            self.arrStock.append(stock)
                        }
                        self.tblStock.reloadData()
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
    }
    // MARK: - IBAction
    
    @IBAction func addStock(_ sender: UIButton) {
        if  let   addStock =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitAddStock) as? AddStock {
            addStock.visitType = self.visitType
            addStock.planvisit = self.planvisit
            addStock.unplanvisit = self.unplanvisit
            self.navigationController?.pushViewController(addStock, animated: true)
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
extension UpdateStock:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrStock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "stockcell", for: indexPath) as? StockCell{
            let stock = arrStock[indexPath.row]
            self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let dt = self.dateFormatter.date(from: stock.stockDate ?? "2020/03/12 11:12:00") ?? Date()
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            let strstockdate = self.dateFormatter.string(from: dt)
            
            cell.lblDate.text = strstockdate
            cell.lblProductName.text = stock.productName
            let strquantity = NSMutableAttributedString().stratributed(bold: "Quantity:", normal:String.init(format:"%@",stock.quantity!))
            cell.lblProductQuantity.attributedText = strquantity
            let strupdatedby = NSMutableAttributedString().stratributed(bold: "Updated By:", normal:String.init(format:"%@",stock.createdByName!))
            cell.lblUpdatedBy.attributedText = strupdatedby
            cell.btnEdit.tag = indexPath.row
//            cell.delegate = self
            cell.btnDelete.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(editiconTapped), for: UIControl.Event.touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(deleteiconTapped), for: UIControl.Event.touchUpInside)
           
        return cell
            
        }else{
            return UITableViewCell()
        }
    }
    @objc func editiconTapped(sender:UIButton){
        let stock = arrStock[sender.tag]
        AlertForGetOTP = UIAlertController.init(title:stock.productName , message: "" , preferredStyle: UIAlertController.Style.alert)
                       //  let text = UITextField.init()
                       // text.placeholder = "AddOTP"
                       
                       AlertForGetOTP.addTextField { (textField : UITextField!) -> Void in
                        textField.setCommonFeature()
                        
                           textField.placeholder = "Quantity"
                        textField.keyboardType = .numberPad
                        textField.text = String.init(format:"%@",stock.quantity!)
                        textField.delegate = self
                       }
                       
                       let cancelAction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: { (action) in
                           self.navigationController?.popViewController(animated: true)
                       })
                       
                       let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                        if((self.AlertForGetOTP.textFields!.first?.text?.isEmpty)!){
                              Utils.toastmsg(message:"Enter Quantity",view: self.view)
                               //self.showAleert(withMessage: "Please Enter OTP")
                        }else if(Int(self.AlertForGetOTP.textFields!.first!.text as? Int ?? 0) > 0){
                            Utils.toastmsg(message:"Please enter quantity",view: self.view)
                           }
                           else{
                           
                             //  self.callAPIForVerifyOTP(OTP: (AlertForGetOTP.textFields!.first?.text)!)
                            self.updateProduct(product: stock, qty: self.AlertForGetOTP.textFields!.first?.text ?? "0", productName: stock.productName!)
                           }
                       })
                       AlertForGetOTP.addAction(okAction)
                       AlertForGetOTP.addAction(cancelAction)
                       
                       
            self.present(AlertForGetOTP, animated: true, completion: nil)
    
    }
    @objc func deleteiconTapped(sender:UIButton){
      //  let stock = self.arrStock[sender.tag]
         if let localpoint = tblStock.convert(CGPoint.zero, to: sender) as? CGPoint{
      //  self.arrStock.remove(at: self.tblStock.indexPathForRow(at: localpoint)?.row ?? 0)
        
            let stock = self.arrStock[self.tblStock.indexPathForRow(at: localpoint)?.row ?? 0]
        let AlertForGetOTP = UIAlertController.init(title:"SuperSales" , message: "Are you sure you want to delete this product from stock?" , preferredStyle: UIAlertController.Style.alert)
                             //  let text = UITextField.init()
                             // text.placeholder = "AddOTP"
                             
                            
                             
                             let cancelAction = UIAlertAction.init(title: "YES", style: UIAlertAction.Style.destructive, handler: { (action) in
                                //self.deleteProduct(product:VisitStock)
                                self.deleteProduct(product: stock)
                                
                             })
                             
                             let okAction = UIAlertAction.init(title: "NO", style: UIAlertAction.Style.default, handler: nil)
                             AlertForGetOTP.addAction(okAction)
                             AlertForGetOTP.addAction(cancelAction)
                             
                             
                  self.present(AlertForGetOTP, animated: true, completion: nil)
          
//        let yesAction = UIAlertAction.init(title: "YES", style: .destructive) { (action) in
//            
//        }
//        let noAction = UIAlertAction.init(title: "NO", style: .default, handler: nil)
//        Common.showalertWithAction(msg: "Are you sure you want to delete stock?", arrAction: [yesAction,noAction])
        }
    }
}
extension UpdateStock:UITextFieldDelegate{
     //self.AlertForGetOTP.textFields!.first
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if(textField == self.AlertForGetOTP.textFields!.first){
           let maxLength = 5
           let currentString: NSString = textField.text! as NSString
           let newString: NSString =
               currentString.replacingCharacters(in: range, with: string) as NSString
           return newString.length <= maxLength
           }else{
               return true
           }
       }
}
