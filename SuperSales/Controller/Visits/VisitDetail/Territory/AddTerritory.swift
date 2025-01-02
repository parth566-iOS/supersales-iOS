//
//  AddTerritory.swift
//  SuperSales
//
//  Created by Apple on 27/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol  AddTerritoryDelegate{
    func updateProductInfo(product:SelectedProduct,Record:Int)->()
}
class AddTerritory: BaseViewController {

    @IBOutlet weak var lblVisitNo: UILabel!
    @IBOutlet weak var tfStartDate: UITextField!
    var visitType:VisitType!
       var planVisit:PlannVisit?
       var unplanVisit:UnplannedVisit?
    
    @IBOutlet weak var btnProduct: UIButton!
    @IBOutlet weak var tfEndDate: UITextField!
     @IBOutlet weak var tblProductList: UITableView!
    
   @IBOutlet weak var cnstProductListHt: NSLayoutConstraint!
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    var startdatepicker:UIDatePicker!
    var enddatepicker:UIDatePicker!
    var startDate:Date!
    var endDate:Date!
    var tableViewHeight: CGFloat {
        tblProductList.layoutIfNeeded()
        return tblProductList.contentSize.height
    }
    var arrOfProduct:[SelectedProduct]! = [SelectedProduct]()
    var arrOfProductDic:[[String:Any]]! = [[String:Any]]()
    var isProduct:Bool!
    var isService:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        DispatchQueue.main.async {
//                //This code will run in the main thread:
//               // CGRect frame = self.tableView.frame
//            self.tblProductList.isScrollEnabled = false
//            var frame = self.tblProductList.frame
//                frame.size.height = self.tblProductList.contentSize.height
//                self.tblProductList.frame = frame
//           // self.cnstProductListHt.constant  = frame.size.height
//            print("Table height \( frame.size.height)")
//            self.tblProductList.reloadData()
//            }
//    }
    
    // MARK: - Method
    func setUI(){
        tfStartDate.setCommonFeature()
        tfEndDate.setCommonFeature()
        
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        
        self.btnSubmit.setbtnFor(title: NSLocalizedString("submit", comment: ""), type: Constant.kPositive)
        
        self.title =  "Add Tertiary"
       if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
        lblVisitNo.text = String.init(format: "Visit NO: %d", unplanVisit?.localID ?? 0)
        }else{
        lblVisitNo.text = String.init(format: "Visit NO: %ld", planVisit?.seriesPostfix ?? 0)
        }
        startDate = Date()
        endDate = Date()
        startdatepicker = UIDatePicker()
        enddatepicker = UIDatePicker()
        startdatepicker.setCommonFeature()
        enddatepicker.setCommonFeature()
        tfStartDate.inputView = startdatepicker
        tfEndDate.inputView = enddatepicker
        tfStartDate.delegate = self
        tfEndDate.delegate = self
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        tfStartDate.text = Utils.getDateWithAppendingDay(day: -1, date: startdatepicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)//self.dateFormatter.string(from: startDate)
        tfEndDate.text = Utils.getDateWithAppendingDay(day: 0, date: enddatepicker.date, format: "dd-MM-yyyy", defaultTimeZone: true)
        startDate = Utils.getNSDateWithAppendingDay(day: -1, date1: startdatepicker.date, format: "yyyy-MM-dd")
        endDate = Utils.getNSDateWithAppendingDay(day: 0, date1: enddatepicker.date, format: "yyyy-MM-dd")
        
       
        tblProductList.rowHeight = UITableView.automaticDimension
        tblProductList.estimatedRowHeight = 102
        tblProductList.delegate = self
        tblProductList.dataSource = self
        tblProductList.isScrollEnabled = false
       // cnstProductListHt.constant = tableViewHeight
        tblProductList.layoutIfNeeded()
    }
   
    
    func checkValidation()->Bool{
        if(arrOfProduct.count == 0){
Utils.toastmsg(message:NSLocalizedString("please_select_the_product", comment:""),view: self.view)
        return false
        }else{
            for prod in arrOfProduct{
                let dic = prod.toDictionary()
                arrOfProductDic.append(dic)
            }
        return true
        }
    }
    // MARK: -  IBAction
    
    @IBAction func selectStartDate(_ sender: UIButton) {
        tfStartDate.becomeFirstResponder()
//        self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:startdatepicker, textfield: nil)
//        startdatepicker?.minimumDate = Date()
        
    }
    
    @IBAction func selectEndDate(_ sender: UIButton) {
        tfEndDate.becomeFirstResponder()
//        self.openDatePicker(view: self.view, dateType: .date, tag: 0, datepicker:enddatepicker, textfield: nil)
//        enddatepicker?.minimumDate = Date()
    }
    
    @IBAction func addProduct(_ sender: UIButton) {
        if let addproductobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.SingleProductSelection) as? Addproduct{
            //addproductobj.customerId =  NSNumber.init(value:.customerID)
                   addproductobj.isFromProductStock =  false
                   addproductobj.isVisit = true
                   addproductobj.isCut = true
            addproductobj.isFromSalesOrder =  false
                   addproductobj.modalPresentationStyle = .overCurrentContext
                    addproductobj.productselectiondelegate = self
            addproductobj.parentviewforpopup = self.view
            Utils.addShadow(view: self.view)
                      self.present(addproductobj, animated: true, completion: nil)
                          }
    }
    
    @IBAction func save(_ sender: UIButton) {
        if(self.checkValidation()){
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            var param1 = ["CreatedBy":self.activeuser?.userID! ?? 0] as [String:Any]
            if(visitType == VisitType.coldcallvisit){
                param1["VisitID"] = unplanVisit?.localID
            }else{
                param1["VisitID"] = planVisit?.iD
            }
            param1["StartDate"] = String.init(format:"%@ 05:30:00", Utils.getDateWithAppendingDay(day: 0, date: startDate, format: "yyyy/MM/dd", defaultTimeZone: true))
            param1["EndDate"] = String.init(format:"%@ 11:59:00", Utils.getDateWithAppendingDay(day: 0, date: endDate, format: "yyyy/MM/dd", defaultTimeZone: true))
            param["updateVisitTertiaryJson"] = Common.json(from: param1)
            param["updateVisitTertiaryProductJson"] = Common.json(from: arrOfProductDic) //
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlUpdateVisitTertiary, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                    self.navigationController?.popViewController(animated: true)
                }else{
                    
                }
            }
        }
    }
    
   
    
    /*
     @IBAction func selectEndDate(_ sender: UIButton) {
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddTerritory:AddTerritoryDelegate{
    func updateProductInfo(product:SelectedProduct,Record:Int)->(){
        arrOfProduct.remove(at: Record)
        arrOfProduct.insert(product, at: Record)
    }
}
extension AddTerritory:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
           if(textField == tfStartDate){
               startdatepicker.date = startDate
               self.dateFormatter.dateFormat = "dd-MM-yyyy"
               startdatepicker.datePickerMode = .date
               startdatepicker.date = self.dateFormatter.date(from: tfStartDate.text!)!
               return true
           }else if(textField == tfEndDate){
               enddatepicker.date = endDate
               self.dateFormatter.dateFormat = "dd-MM-yyyy"
               enddatepicker.datePickerMode = .date
               enddatepicker.date = self.dateFormatter.date(from: tfEndDate.text!)!
              
                return true
           }else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         self.dateFormatter.dateFormat = "dd-MM-yyyy"
               if(textField == tfStartDate){
                tfStartDate.text = self.dateFormatter.string(from:  startdatepicker.date)
                //startdatepicker.date =  dateFormatter.date(from: tfStartDate.text ?? "") ?? Date()
                 startDate = startdatepicker.date
                   //datepicker.reloadInputViews()
               }else if(textField == tfEndDate){
                tfEndDate.text = self.dateFormatter.string(from:  enddatepicker.date)
//                enddatepicker.date = dateFormatter.date(from: tfEndDate.text ?? "") ?? Date()
                endDate =  enddatepicker.date
                  // datepicker.reloadInputViews()
               }
    }
}
extension AddTerritory:ProductSelectionDelegate{
     func addProduct1(product: SelectedProduct) {
        Utils.removeShadow(view: self.view)
        for prod in arrOfProduct{
            if(prod.productID == product.productID){
        Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view: self.view)
                return
            }
        }
        arrOfProduct.append(product)
        self.cnstProductListHt.constant = self.tblProductList.contentSize.height
               tblProductList.layoutIfNeeded()
               tblProductList.reloadData()
               print("Table height =  \(tableViewHeight)")
       DispatchQueue.main.async {
        //self.cnstProductListHt.constant = CGFloat(self.arrOfProduct.count) *  self.tblProductList.rowHeight //self.tableViewHeight
        self.cnstProductListHt.constant = self.tblProductList.contentSize.height
        print("Table height \(self.tableViewHeight)")
        self.tblProductList.layoutIfNeeded()
        self.tblProductList.reloadData()
            }
//
//        DispatchQueue.main.async {
//                //This code will run in the main thread:
//               // CGRect frame = self.tableView.frame
//            self.tblProductList.layoutIfNeeded()
//            self.tblProductList.reloadData()
//        //    self.tblProductList.isScrollEnabled = false
//            var frame = self.tblProductList.frame
//                frame.size.height = self.tblProductList.contentSize.height
//                self.tblProductList.frame = frame
//            self.cnstProductListHt.constant  = self.tblProductList.contentSize.height
//            //frame.size.height
//            print("Table height \( frame.size.height)")
//            self.tblProductList.reloadData()
//            }
       
    }
}
extension AddTerritory:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProductCell{
        let product = arrOfProduct[indexPath.row]
            cell.teridelegate = self
            cell.setProductInfo(pro: product, record: indexPath.row)
        cell.stkBudget.isHidden = true
            cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
            cell.btnDelete.tag =  indexPath.row
         //   cell.btnDelete.addTarget(self, action:#selector(deleteProduct), for: .touchUpInside)
        return cell
        }else{
           return UITableViewCell()
        }
    }
        
//    func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
//               return UITableView.automaticDimension
//    }
       
  /*  @objc func deleteProduct(sender:UIButton)->(){
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
//        arrOfProduct.remove(at: sender.tag)
//        tblProductList.beginUpdates()
//        tblProductList.deleteRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
//        tblProductList.endUpdates()
        if(arrOfProduct.count == 0){
            isProduct = false
            isService = false
        }
    }*/
}
extension AddTerritory : ProductCellDelegate{
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
        Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
        }
    }
}
