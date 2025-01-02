//
//  UpdateCustomerPotential.swift
//  SuperSales
//
//  Created by mac on 21/04/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class UpdateCustomerPotential: BaseViewController, PotentialProductDelegate {
    func addpotentialProduct(product: PotentialProduct) {
        Utils.removeShadow(view: self.view)
        let arrOFProductID = arrOfPotentialProduct.map {
            $0.ProductID

        }
        let arrOFSubCatID = arrOfPotentialProduct.map{
            $0.SubCategoryID

        }
        let arrOfCatID = arrOfPotentialProduct.map{
            $0.CategoryID
        }
        if(product.ProductID > 0 && arrOFProductID.contains(product.ProductID)){
            Utils.toastmsg(message: "You can't add same product", view: self.view)
        }else if(product.ProductID == 0 &&  product.SubCategoryID > 0 && arrOFSubCatID.contains(product.SubCategoryID)){
            Utils.toastmsg(message: "You can't add same product", view: self.view)
        }else if(product.ProductID == 0 &&  product.SubCategoryID == 0 && product.CategoryID > 0 && arrOfCatID.contains(product.CategoryID)){
            Utils.toastmsg(message: "You can't add same product", view: self.view)
        }else{
        arrOfPotentialProduct.insert(product, at: arrOfPotentialProduct.count)
        
        }
        tblPotentialProuctHeight.constant =  tableViewHeight
        
        tblProduct.reloadData()
        tblPotentialProuctHeight.constant =  tableViewHeight
    }
    
   
    

    
    //MARK: IBAction
    
    @IBOutlet weak var tfNoOfProject: UITextField!
    
    
    @IBOutlet weak var tfNoOfPremiumProject: UITextField!
    
    
    @IBOutlet weak var tfSizeOfTeam: UITextField!
    
    
    @IBOutlet weak var tfApproximateTurnOver: UITextField!
    
    
    @IBOutlet weak var tfApproximateSegmentTurnOver: UITextField!
    
    @IBOutlet weak var tblProduct: UITableView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    @IBOutlet weak var tblPotentialProuctHeight: NSLayoutConstraint!
    //MARK: Var
    var arrOfPotentialProduct:[PotentialProduct] = [PotentialProduct]()
    var noOfProduct = 0
    var customerpotential:CustomerPotential!
    var selectedCustomer : CustomerDetails!
    var tableViewHeight: CGFloat {
           tblProduct.layoutIfNeeded()
           return tblProduct.contentSize.height
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getPotentialDetail()
    }
    //MARK: - Method
    func setUI(){
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.title = selectedCustomer.name
        self.btnSubmit.setbtnFor(title: "Update", type: Constant.kPositive)
        self.tfSizeOfTeam.addBorders(edges: .bottom , color: UIColor.black, cornerradius: 0)
        self.tfNoOfProject.addBorders(edges: .bottom , color: UIColor.black, cornerradius: 0)
        self.tfNoOfPremiumProject.addBorders(edges: .bottom , color: UIColor.black, cornerradius: 0)
        self.tfApproximateTurnOver.addBorders(edges: .bottom , color: UIColor.black, cornerradius: 0)
        self.tfApproximateSegmentTurnOver.addBorders(edges: .bottom , color: UIColor.black, cornerradius: 0)
        self.tblProduct.setCommonFeature()
        self.tblProduct.estimatedRowHeight = 230
        self.tblProduct.rowHeight = UITableView.automaticDimension
        self.tfSizeOfTeam.delegate = self
        self.tfNoOfProject.delegate = self
        self.tfNoOfPremiumProject.delegate = self
        self.tfApproximateTurnOver.delegate = self
        self.tfApproximateSegmentTurnOver.delegate = self
        self.tblProduct.delegate = self
        self.tblProduct.dataSource = self
        tblPotentialProuctHeight.constant =  tableViewHeight
        self.tfSizeOfTeam.keyboardType = .numberPad
        self.tfNoOfProject.keyboardType = .numberPad
        self.tfApproximateTurnOver.keyboardType = .numberPad
        self.tfNoOfPremiumProject.keyboardType = .numberPad
        self.tfApproximateSegmentTurnOver.keyboardType = .numberPad
        self.tblProduct.isScrollEnabled = false
        
    }
    
    func setDataOfKYC(potential:CustomerPotential){
        self.tfSizeOfTeam.text = String.init(format:"\(potential.teamSize)")
        self.tfNoOfProject.text = String.init(format:"\(potential.totalSites)")
        self.tfApproximateTurnOver.text = String.init(format:"\(potential.totalTurnOver)")
        self.tfApproximateSegmentTurnOver.text = String.init(format:"\(potential.segmentTurnOver)")
        self.tfNoOfPremiumProject.text = String.init(format:"\(potential.totalHighPotentialSites)")
        self.arrOfPotentialProduct = [PotentialProduct]()
        let serialQueue = DispatchQueue(label: "serialQueueWork" )
        let semaphore = DispatchSemaphore(value: 1)
//        let task0 = DispatchWorkItem {
//            semaphore.wait()
//            print("0 started.")
//            if(potential.productId > 0  || potential.subcategoryId > 0 || potential.categoryId > 0){
//                var dic1 = [String:Any]()
//                dic1["productId"] = self.customerpotential.productId
//                dic1["subcategoryId"] = self.customerpotential.subcategoryId
//                dic1["categoryId"] = self.customerpotential.categoryId
//                dic1["pitched"] = self.customerpotential.pitched
//                dic1["interestLevel"] = self.customerpotential.interestLevel
//                self.arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic1 as NSDictionary), at: self.arrOfPotentialProduct.count)
//            }
//        }

                let task1 = DispatchWorkItem {
                    semaphore.wait()
                    print("1 started.")
                    if(potential.productId1 > 0  || potential.subcategoryId1 > 0 || potential.categoryId1 > 0){
                        var dic1 = [String:Any]()
                        dic1["productId"] = self.customerpotential.productId1
                        dic1["subcategoryId"] = self.customerpotential.subcategoryId1
                        dic1["categoryId"] = self.customerpotential.categoryId1
                        dic1["pitched"] = self.customerpotential.pitched1
                        dic1["interestLevel"] = self.customerpotential.interestLevel1
                        self.arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic1 as NSDictionary), at: self.arrOfPotentialProduct.count)
                    }
                }

                let task2 = DispatchWorkItem  {
                    semaphore.wait()
                    print("2 started.")
                    if(potential.productId2 > 0  || potential.subcategoryId2 > 0 || potential.categoryId2 > 0){
                        var dic2 = [String:Any]()
                        dic2["productId"] = self.customerpotential.productId2
                        dic2["subcategoryId"] = self.customerpotential.subcategoryId2
                        dic2["categoryId"] = self.customerpotential.categoryId2
                        dic2["pitched"] = self.customerpotential.pitched2
                        dic2["interestLevel"] = self.customerpotential.interestLevel2
                        self.arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic2 as NSDictionary), at: self.arrOfPotentialProduct.count)
                    }
                }
        let task3 = DispatchWorkItem {
            semaphore.wait()
            print("3 started.")
            if(potential.productId3 > 0  || potential.subcategoryId3 > 0 || potential.categoryId3 > 0){
                var dic3 = [String:Any]()
                dic3["productId"] = self.customerpotential.productId3
                dic3["subcategoryId"] = self.customerpotential.subcategoryId3
                dic3["categoryId"] = self.customerpotential.categoryId3
                dic3["pitched"] = self.customerpotential.pitched3
                dic3["interestLevel"] = self.customerpotential.interestLevel3
                self.arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic3 as NSDictionary), at: self.arrOfPotentialProduct.count)
            }
        }

        let task4 = DispatchWorkItem  {
            semaphore.wait()
            print("4 started.")
            if(potential.productId4 > 0  || potential.subcategoryId4 > 0 || potential.categoryId4 > 0){
                var dic4 = [String:Any]()
                dic4["productId"] = self.customerpotential.productId4
                dic4["subcategoryId"] = self.customerpotential.subcategoryId4
                dic4["categoryId"] = self.customerpotential.categoryId4
                dic4["pitched"] = self.customerpotential.pitched4
                dic4["interestLevel"] = self.customerpotential.interestLevel4
                self.arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic4 as NSDictionary), at: self.arrOfPotentialProduct.count)
            }
        }
        let task5 = DispatchWorkItem {
            semaphore.wait()
            print("5 started.")
            if(potential.productId5 > 0  || potential.subcategoryId5 > 0 || potential.categoryId5 > 0){
                var dic5 = [String:Any]()
                dic5["productId"] = self.customerpotential.productId5
                dic5["subcategoryId"] = self.customerpotential.subcategoryId5
                dic5["categoryId"] = self.customerpotential.categoryId5
                dic5["pitched"] = self.customerpotential.pitched5
                dic5["interestLevel"] = self.customerpotential.interestLevel5
                self.arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic5 as NSDictionary), at: self.arrOfPotentialProduct.count)
            }
        }

        let task6 = DispatchWorkItem  {
            semaphore.wait()
            print("6 started.")
            if(potential.productId6 > 0  || potential.subcategoryId6 > 0 || potential.categoryId6 > 0){
                var dic6 = [String:Any]()
                dic6["productId"] = self.customerpotential.productId6
                dic6["subcategoryId"] = self.customerpotential.subcategoryId6
                dic6["categoryId"] = self.customerpotential.categoryId6
                dic6["pitched"] = self.customerpotential.pitched6
                dic6["interestLevel"] = self.customerpotential.interestLevel6
                self.arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic6 as NSDictionary), at: self.arrOfPotentialProduct.count)
            }
        }
        let task7 = DispatchWorkItem  {
            semaphore.wait()
            print("7 started.")
            if(potential.productId7 > 0  || potential.subcategoryId7 > 0 || potential.categoryId7 > 0){
                var dic7 = [String:Any]()
                dic7["productId"] = self.customerpotential.productId7
                dic7["subcategoryId"] = self.customerpotential.subcategoryId7
                dic7["categoryId"] = self.customerpotential.categoryId7
                dic7["pitched"] = self.customerpotential.pitched7
                dic7["interestLevel"] = self.customerpotential.interestLevel7
                self.arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic7 as NSDictionary), at: self.arrOfPotentialProduct.count)
            }
        }
//        task0.notify(queue: DispatchQueue.main) {
//            print("0 is finished. \(self.arrOfPotentialProduct)")
//            semaphore.signal()
//        }
                task1.notify(queue: DispatchQueue.main) {
                    print("1 is finished. \(self.arrOfPotentialProduct)")
                    semaphore.signal()
                }

                task2.notify(queue: DispatchQueue.main) {
                    print("2 is finished  \(self.arrOfPotentialProduct)")
                    semaphore.signal()
                }
        task3.notify(queue: DispatchQueue.main) {
            print("3 is finished.  \(self.arrOfPotentialProduct)")
            semaphore.signal()
        }

        task4.notify(queue: DispatchQueue.main) {
            print("4 is finished  \(self.arrOfPotentialProduct)")
            semaphore.signal()
        }
        task5.notify(queue: DispatchQueue.main) {
            print("5 is finished.  \(self.arrOfPotentialProduct)")
            semaphore.signal()
        }
        task6.notify(queue: DispatchQueue.main) {
            print("6 is finished.  \(self.arrOfPotentialProduct)")
            semaphore.signal()
        }
        task7.notify(queue: DispatchQueue.main) {
            print("7 is finished.  \(self.arrOfPotentialProduct)")
            self.tblProduct.reloadData()
            self.tblPotentialProuctHeight.constant =   self.tableViewHeight
            semaphore.signal()
        }

        

        serialQueue.async(execute: task1 )
        serialQueue.async(execute: task2 )
        serialQueue.async(execute: task3 )
        serialQueue.async(execute: task4 )
        serialQueue.async(execute: task5 )
        serialQueue.async(execute: task6 )
        serialQueue.async(execute: task7 )
        
      
        
        
//        if(potential.productId3 > 0  || potential.subcategoryId3 > 0 || potential.categoryId3 > 0){
//            var dic1 = [String:Any]()
//            dic1["productId"] = customerpotential.productId3
//            dic1["subcategoryId"] = customerpotential.subcategoryId3
//            dic1["categoryId"] = customerpotential.categoryId3
//            dic1["pitched"] = customerpotential.pitched3
//            dic1["interestLevel"] = customerpotential.interestLevel3
//            arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic1 as NSDictionary), at: 2)
//        }
//        if(potential.productId4 > 0  || potential.subcategoryId4 > 0 || potential.categoryId4 > 0){
//            var dic1 = [String:Any]()
//            dic1["productId"] = customerpotential.productId4
//            dic1["subcategoryId"] = customerpotential.subcategoryId4
//            dic1["categoryId"] = customerpotential.categoryId4
//            dic1["pitched"] = customerpotential.pitched4
//            dic1["interestLevel"] = customerpotential.interestLevel4
//            arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic1 as NSDictionary), at: 3)
//        }
//        if(potential.productId5 > 0  || potential.subcategoryId5 > 0 || potential.categoryId5 > 0){
//            var dic1 = [String:Any]()
//            dic1["productId"] = customerpotential.productId5
//            dic1["subcategoryId"] = customerpotential.subcategoryId5
//            dic1["categoryId"] = customerpotential.categoryId5
//            dic1["pitched"] = customerpotential.pitched5
//            dic1["interestLevel"] = customerpotential.interestLevel5
//            arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic1 as NSDictionary), at: 4)
//        }
//        if(potential.productId6 > 0  || potential.subcategoryId6 > 0 || potential.categoryId6 > 0){
//            var dic1 = [String:Any]()
//            dic1["productId"] = customerpotential.productId6
//            dic1["subcategoryId"] = customerpotential.subcategoryId6
//            dic1["categoryId"] = customerpotential.categoryId6
//            dic1["pitched"] = customerpotential.pitched6
//            dic1["interestLevel"] = customerpotential.interestLevel6
//            arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic1 as NSDictionary), at: 5)
//        }
//        if(potential.productId7 > 0  || potential.subcategoryId7 > 0 || potential.categoryId7 > 0){
//            var dic1 = [String:Any]()
//            dic1["productId"] = customerpotential.productId7
//            dic1["subcategoryId"] = customerpotential.subcategoryId7
//            dic1["categoryId"] = customerpotential.categoryId7
//            dic1["pitched"] = customerpotential.pitched7
//            dic1["interestLevel"] = customerpotential.interestLevel7
//            arrOfPotentialProduct.insert(PotentialProduct.init(dictionary: dic1 as NSDictionary), at: 6)
//        }
      

        tblProduct.reloadData()
        tblProduct.estimatedRowHeight = 230 //UITableView.automaticDimension
        self.tblProduct.rowHeight = UITableView.automaticDimension
        tblPotentialProuctHeight.constant =  tableViewHeight
 
    }
    func checkvalidation()->Bool{
        if(tfNoOfProject.text?.toInt() ?? 0 < tfNoOfPremiumProject.text?.toInt() ?? 0){
            Utils.toastmsg(message: "Total project can not less than premimium project", view: self.view)
            return false
        }else{
            return true
        }
    }
    
    //MARK: IBAction
    
    @IBAction func btnAddProductClicked(_ sender: UIButton) {
        if(self.arrOfPotentialProduct.count == 7){
            Utils.toastmsg(message: "You can't add more than 7 product", view: self.view)
        }else{
        if let addproductobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.SingleProductSelection) as? Addproduct{
            addproductobj.isFromProductStock = false
            addproductobj.isVisit = true
            addproductobj.isFromSalesOrder =  false
            addproductobj.productselectionfrom = ProductSelectionFromView.potential
            addproductobj.potentialprodelegate = self
            addproductobj.modalPresentationStyle = .overCurrentContext
            addproductobj.parentviewforpopup = self.view
            Utils.addShadow(view: self.view)
            self.present(addproductobj, animated: true, completion: nil)
        }
        }
        
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if(checkvalidation()){
            if(arrOfPotentialProduct.count > 0){
            for i in 0...arrOfPotentialProduct.count - 1{
                if let poproduct = arrOfPotentialProduct[i] as? PotentialProduct{
                   if(i == 0){
                        customerpotential.productId1 = poproduct.ProductID
                        customerpotential.categoryId1 = poproduct.CategoryID
                        customerpotential.subcategoryId1 = poproduct.SubCategoryID
                        customerpotential.interestLevel1 =  poproduct.interestLevel
                        customerpotential.pitched1 = poproduct.pitched
                        customerpotential.product1Name = poproduct.productName
                    }else if(i == 1){
                        customerpotential.productId2 = poproduct.ProductID
                        customerpotential.categoryId2 = poproduct.CategoryID
                        customerpotential.subcategoryId2 = poproduct.SubCategoryID
                        customerpotential.interestLevel2 =  poproduct.interestLevel
                        customerpotential.pitched2 = poproduct.pitched
                        customerpotential.product2Name = poproduct.productName
                    }else if(i == 2){
                        customerpotential.productId3 = poproduct.ProductID
                        customerpotential.categoryId3 = poproduct.CategoryID
                        customerpotential.subcategoryId3 = poproduct.SubCategoryID
                        customerpotential.interestLevel3 =  poproduct.interestLevel
                        customerpotential.pitched3 = poproduct.pitched
                        customerpotential.product3Name = poproduct.productName
                    }else if(i == 3){
                        customerpotential.productId4 = poproduct.ProductID
                        customerpotential.categoryId4 = poproduct.CategoryID
                        customerpotential.subcategoryId4 = poproduct.SubCategoryID
                        customerpotential.interestLevel4 =  poproduct.interestLevel
                        customerpotential.pitched4 = poproduct.pitched
                        customerpotential.product4Name = poproduct.productName
                    }else if(i == 4){
                        customerpotential.productId5 = poproduct.ProductID
                        customerpotential.categoryId5 = poproduct.CategoryID
                        customerpotential.subcategoryId5 = poproduct.SubCategoryID
                        customerpotential.interestLevel5 =  poproduct.interestLevel
                        customerpotential.pitched5 = poproduct.pitched
                        customerpotential.product5Name = poproduct.productName
                    }else if(i == 5){
                        customerpotential.productId6 = poproduct.ProductID
                        customerpotential.categoryId6 = poproduct.CategoryID
                        customerpotential.subcategoryId6 = poproduct.SubCategoryID
                        customerpotential.interestLevel6 =  poproduct.interestLevel
                        customerpotential.pitched6 = poproduct.pitched
                        customerpotential.product6Name = poproduct.productName
                    }else if(i == 6){
                        customerpotential.productId7 = poproduct.ProductID
                        customerpotential.categoryId7 = poproduct.CategoryID
                        customerpotential.subcategoryId7 = poproduct.SubCategoryID
                        customerpotential.interestLevel7 =  poproduct.interestLevel
                        customerpotential.pitched7 = poproduct.pitched
                        customerpotential.product7Name = poproduct.productName
                    }
                    
                }
            }
            }
            self.addUpdatePotantial()
        }
    }
    //MARK: API Call
    func getPotentialDetail(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["CustomerID"] = selectedCustomer.iD
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetCustomerPotential, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                var dicCustomerPotential = arr as? [String:Any] ?? [String:Any]()
                dicCustomerPotential["CompanyID"] = self.activeuser?.company?.iD
                dicCustomerPotential["CustomerID"] = self.selectedCustomer.iD
                print("dic of customer potential = \(dicCustomerPotential)")
                self.customerpotential = CustomerPotential.init(dictionary: dicCustomerPotential as NSDictionary)
                self.setDataOfKYC(potential: self.customerpotential)
                print(dicCustomerPotential)
            }else{
                if(message.count > 0){
                Utils.toastmsg(message: message , view: self.view)
                }else{
                     Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String
                                ?? "", view: self.view)
                }
            }
        }
    }
    
    func addUpdatePotantial(){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        if var diccust = customerpotential.toDictionary() as? [String:Any]{
        diccust.removeValue(forKey: "productName")
        diccust.removeValue(forKey: "product2Name")
        diccust.removeValue(forKey: "product3Name")
        diccust.removeValue(forKey: "product4Name")
        diccust.removeValue(forKey: "product5Name")
        diccust.removeValue(forKey: "product6Name")
        diccust.removeValue(forKey: "product7Name")
        }
        param["addCustomerPotentialjson"] = Common.json(from: customerpotential.toDictionary())
        print("parameter of uodate customer potential = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddEditCustomerPotential, method: .post)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
          
            if(status.lowercased() == Constant.SucessResponseFromServer){
                SVProgressHUD.dismiss()
                Utils.toastmsg(message: message , view: self.view)
                self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.dismiss()
                if(message.count > 0){
                Utils.toastmsg(message: message , view: self.view)
                }else{
                     Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String
                                ?? "", view: self.view)
                }
            
            }
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
extension UpdateCustomerPotential:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == tfNoOfProject){
            let maxLength = 7
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if(textField == tfNoOfPremiumProject){
            let maxLength = 7
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfNoOfProject){
            customerpotential.totalSites = textField.text?.toInt() ?? 0
            
        }else if(textField ==  tfSizeOfTeam){
            customerpotential.teamSize = textField.text?.toInt() ?? 0
        }else if(textField == tfNoOfPremiumProject){
            customerpotential.totalHighPotentialSites = textField.text?.toInt() ?? 0
        }else if(textField == tfApproximateTurnOver){
            customerpotential.segmentTurnOver = textField.text?.toInt() ?? 0
        }else if(textField == tfApproximateSegmentTurnOver){
            customerpotential.totalTurnOver = textField.text?.toInt() ?? 0
        }
    }
}
extension UpdateCustomerPotential:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of product = \(arrOfPotentialProduct.count)")
        return arrOfPotentialProduct.count//noOfProduct
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "updatepotentialproductcell", for: indexPath) as? UpdatePotentialProductCell{
            cell.selectionStyle = .none
            cell.potproductDelegate = self
            cell.btnPitched.setImage(UIImage.init(named: "icon_switch_unselected"), for: UIControl.State.normal)
            cell.btnPitched.setImage(UIImage.init(named: "icon_switch_selected"), for: UIControl.State.highlighted)
            let selectedproduct =  arrOfPotentialProduct[indexPath.row]
            var strproductname = ""
            if(selectedproduct.ProductID > 0){
                strproductname = Product.getProductName(productID: NSNumber(value: selectedproduct.ProductID))
            }else if(selectedproduct.SubCategoryID > 0){
                strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: NSNumber(value: selectedproduct.SubCategoryID)))")
            }else if(selectedproduct.CategoryID > 0){
    strproductname =  String.init(format:"Cat:\(ProdCategory.getCategoryName(catId: NSNumber(value: selectedproduct.CategoryID)))")
            }
            cell.lblProductName.text = strproductname
            print("product pitched = \(selectedproduct.pitched) for \(indexPath.row),\(strproductname)" )
            if(selectedproduct.pitched ==  "Y"){
                cell.btnPitched.isSelected = true
            }else{
                cell.btnPitched.isSelected = false
            }
            if(selectedproduct.interestLevel == 1){
                self.configureButtonSelected(btn: cell.btnHot)
                self.configureButtonNormal(btn: cell.btnWarm)
                self.configureButtonNormal(btn: cell.btnCold)
            }else if(selectedproduct.interestLevel == 2){
                self.configureButtonSelected(btn: cell.btnWarm)
                self.configureButtonNormal(btn: cell.btnHot)
                self.configureButtonNormal(btn: cell.btnCold)
            }else if(selectedproduct.interestLevel == 3){
                self.configureButtonSelected(btn: cell.btnCold)
                self.configureButtonNormal(btn: cell.btnHot)
                self.configureButtonNormal(btn: cell.btnWarm)
            }else{
                self.configureButtonSelected(btn: cell.btnHot)
                self.configureButtonNormal(btn: cell.btnWarm)
                self.configureButtonNormal(btn: cell.btnCold)
            }
           /* if(indexPath.row == 0){
                var strproductname = ""
                if(customerpotential.productId1 > 0){
                    strproductname = Product.getProductName(productID: NSNumber(value: customerpotential.productId1))
                }else if(customerpotential.subcategoryId1 > 0){
                    strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: NSNumber(value: customerpotential.subcategoryId1)))")
                }else if(customerpotential.categoryId1 > 0){
                    strproductname =  String.init(format:"Cat: \(ProdCategory.getCategoryName(catId: NSNumber(value: customerpotential.categoryId1)))")
                }
                cell.lblProductName.text = strproductname
                if(customerpotential.pitched1 == "1"){
                    cell.btnPitched.isSelected = true
                }else{
                    cell.btnPitched.isSelected = false
                }
                if(customerpotential.interestLevel1 == 1){
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel1 == 2){
                    self.configureButtonSelected(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel1 == 3){
                    self.configureButtonSelected(btn: cell.btnCold)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                }else{
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }
            }else if(indexPath.row == 1){
                var strproductname = ""
                if(customerpotential.productId2 > 0){
                    strproductname = Product.getProductName(productID: NSNumber(value: customerpotential.productId2))
                }else if(customerpotential.subcategoryId2 > 0){
                    strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: NSNumber(value: customerpotential.subcategoryId2)))")
                }else if(customerpotential.categoryId2 > 0){
                    strproductname =  String.init(format:"Cat: \(ProdCategory.getCategoryName(catId: NSNumber(value: customerpotential.categoryId2)))")
                }
                cell.lblProductName.text = strproductname
                if(customerpotential.pitched2 == "1"){
                    cell.btnPitched.isSelected = true
                }else{
                    cell.btnPitched.isSelected = false
                }
                if(customerpotential.interestLevel2 == 1){
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel2 == 2){
                    self.configureButtonSelected(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel2 == 3){
                    self.configureButtonSelected(btn: cell.btnCold)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                }else{
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }
            }else if(indexPath.row == 2){
                var strproductname = ""
                if(customerpotential.productId3 > 0){
                    strproductname = Product.getProductName(productID: NSNumber(value: customerpotential.productId3))
                }else if(customerpotential.subcategoryId3 > 0){
                    strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: NSNumber(value: customerpotential.subcategoryId3)))")
                }else if(customerpotential.categoryId3 > 0){
                    strproductname =  String.init(format:"Cat: \(ProdCategory.getCategoryName(catId: NSNumber(value: customerpotential.categoryId3)))")
                }
                cell.lblProductName.text = strproductname
                if(customerpotential.pitched3 == "1"){
                    cell.btnPitched.isSelected = true
                }else{
                    cell.btnPitched.isSelected = false
                }
                if(customerpotential.interestLevel3 == 1){
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel3 == 2){
                    self.configureButtonSelected(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel3 == 3){
                    self.configureButtonSelected(btn: cell.btnCold)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                }else{
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }
            }
            else if(indexPath.row == 3){
                var strproductname = ""
                if(customerpotential.productId4 > 0){
                    strproductname = Product.getProductName(productID: NSNumber(value: customerpotential.productId4))
                }else if(customerpotential.subcategoryId4 > 0){
                    strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: NSNumber(value: customerpotential.subcategoryId4)))")
                }else if(customerpotential.categoryId4 > 0){
                    strproductname =  String.init(format:"Cat: \(ProdCategory.getCategoryName(catId: NSNumber(value: customerpotential.categoryId4)))")
                }
                cell.lblProductName.text = strproductname
                if(customerpotential.pitched4 == "1"){
                    cell.btnPitched.isSelected = true
                }else{
                    cell.btnPitched.isSelected = false
                }
                if(customerpotential.interestLevel4 == 1){
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel4 == 2){
                    self.configureButtonSelected(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel4 == 3){
                    self.configureButtonSelected(btn: cell.btnCold)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                }else{
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }
            }
            else if(indexPath.row == 4){
                var strproductname = ""
                if(customerpotential.productId5 > 0){
                    strproductname = Product.getProductName(productID: NSNumber(value: customerpotential.productId5))
                }else if(customerpotential.subcategoryId5 > 0){
                    strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: NSNumber(value: customerpotential.subcategoryId5)))")
                }else if(customerpotential.categoryId5 > 0){
                    strproductname =  String.init(format:"Cat: \(ProdCategory.getCategoryName(catId: NSNumber(value: customerpotential.categoryId5)))")
                }
                cell.lblProductName.text = strproductname
                if(customerpotential.pitched5 == "1"){
                    cell.btnPitched.isSelected = true
                }else{
                    cell.btnPitched.isSelected = false
                }
                if(customerpotential.interestLevel5 == 1){
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel5 == 2){
                    self.configureButtonSelected(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel5 == 3){
                    self.configureButtonSelected(btn: cell.btnCold)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                }else{
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }
            }else if(indexPath.row == 5){
                var strproductname = ""
                if(customerpotential.productId6 > 0){
                    strproductname = Product.getProductName(productID: NSNumber(value: customerpotential.productId6))
                }else if(customerpotential.subcategoryId6 > 0){
                    strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: NSNumber(value: customerpotential.subcategoryId6)))")
                }else if(customerpotential.categoryId6 > 0){
                    strproductname =  String.init(format:"Cat: \(ProdCategory.getCategoryName(catId: NSNumber(value: customerpotential.categoryId6)))")
                }
                cell.lblProductName.text = strproductname
                if(customerpotential.pitched6 == "1"){
                    cell.btnPitched.isSelected = true
                }else{
                    cell.btnPitched.isSelected = false
                }
                if(customerpotential.interestLevel6 == 1){
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel6 == 2){
                    self.configureButtonSelected(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel6 == 3){
                    self.configureButtonSelected(btn: cell.btnCold)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                }else{
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }
            }else if(indexPath.row == 6){
                var strproductname = ""
                if(customerpotential.productId7 > 0){
                    strproductname = Product.getProductName(productID: NSNumber(value: customerpotential.productId7))
                }else if(customerpotential.subcategoryId7 > 0){
                    strproductname =  String.init(format:"Sub Cat: \(ProductSubCat.getSubCatName(subcatid: NSNumber(value: customerpotential.subcategoryId7)))")
                }else if(customerpotential.categoryId7 > 0){
                    strproductname =  String.init(format:"Cat: \(ProdCategory.getCategoryName(catId: NSNumber(value: customerpotential.categoryId7)))")
                }
                cell.lblProductName.text = strproductname
                if(customerpotential.pitched7 == "1"){
                    cell.btnPitched.isSelected = true
                }else{
                    cell.btnPitched.isSelected = false
                }
                if(customerpotential.interestLevel7 == 1){
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel7 == 2){
                    self.configureButtonSelected(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnCold)
                }else if(customerpotential.interestLevel7 == 3){
                    self.configureButtonSelected(btn: cell.btnCold)
                    self.configureButtonNormal(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                }else{
                    self.configureButtonSelected(btn: cell.btnHot)
                    self.configureButtonNormal(btn: cell.btnWarm)
                    self.configureButtonNormal(btn: cell.btnCold)
                }
            }*/
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func configureButtonSelected(btn:UIButton)->(){
     
        btn.addBorders(edges: [.all], color: UIColor.clear, cornerradius: 0)
        //  btn.layer.borderColor = Common().UIColorFromRGB(rgbValue:0x114763).cgColor
        btn.layer.backgroundColor = UIColor.systemBlue.cgColor//UIColor.clear.cgColor
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }
    
    func configureButtonNormal(btn:UIButton)->(){
        btn.addBorders(edges: [.all], color: UIColor.black, cornerradius: 0)
        // self.addBorders(edges
        //   btn.layer.borderColor =  UIColor.systemBlue.cgColor//Common().UIColorFromRGB(rgbValue:0x114763).cgColor
        btn.backgroundColor = UIColor.clear
        btn.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
    }
    
}

extension UpdateCustomerPotential:UpdatePotentialProductDelegate{
    func prodeleteClicked(cell: UpdatePotentialProductCell) {
        if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
        let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
        let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in


            //self.arrOfProduct.remove(at: indexPath.row)
            self.arrOfPotentialProduct.remove(at: indexPath.row)

            self.tblProduct.beginUpdates()
        
            self.tblProduct.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
            DispatchQueue.main.async {
                self.tblProduct.layoutIfNeeded()
                self.tblProduct.reloadData()
                self.tblPotentialProuctHeight.constant = self.tableViewHeight
            }
            self.tblProduct.endUpdates()


        }
        Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
        }
    }
    
    func btnHotClicked(cell: UpdatePotentialProductCell) {
        self.configureButtonSelected(btn: cell.btnHot)
        self.configureButtonNormal(btn: cell.btnWarm)
        self.configureButtonNormal(btn: cell.btnCold)
        if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
        let selectedproduct = arrOfPotentialProduct[indexPath.row]
        
        selectedproduct.interestLevel =  1
       
        arrOfPotentialProduct.remove(at: indexPath.row)
        arrOfPotentialProduct.insert(selectedproduct, at: indexPath.row)
        }
    }
    
    func btnWarmClicked(cell: UpdatePotentialProductCell) {
        self.configureButtonSelected(btn: cell.btnWarm)
        self.configureButtonNormal(btn: cell.btnHot)
        self.configureButtonNormal(btn: cell.btnCold)
        if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
        let selectedproduct = arrOfPotentialProduct[indexPath.row]
        
        selectedproduct.interestLevel =  2
       
        arrOfPotentialProduct.remove(at: indexPath.row)
        arrOfPotentialProduct.insert(selectedproduct, at: indexPath.row)
        }
    }
    
    func btnColdClicked(cell: UpdatePotentialProductCell) {
        self.configureButtonSelected(btn: cell.btnCold)
        self.configureButtonNormal(btn: cell.btnHot)
        self.configureButtonNormal(btn: cell.btnWarm)
        if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
        let selectedproduct = arrOfPotentialProduct[indexPath.row]
        
        selectedproduct.interestLevel =  3
       
        arrOfPotentialProduct.remove(at: indexPath.row)
        arrOfPotentialProduct.insert(selectedproduct, at: indexPath.row)
        }
        
    }
    
    func btnPitchedClicked(cell: UpdatePotentialProductCell) {
        if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
            if(cell.btnPitched.isSelected){
                cell.btnPitched.isSelected = false
                
            }else{
                cell.btnPitched.isSelected = true
            }
            let selectedproduct = arrOfPotentialProduct[indexPath.row]
            if(cell.btnPitched.isSelected){
            selectedproduct.pitched = "Y"
            }else{
                selectedproduct.pitched = "N"
            }
            arrOfPotentialProduct.remove(at: indexPath.row)
            arrOfPotentialProduct.insert(selectedproduct, at: indexPath.row)
        }
    }
    
    
}
