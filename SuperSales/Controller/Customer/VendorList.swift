//
//  VendorList.swift
//  SuperSales
//
//  Created by Apple on 24/09/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import CoreMedia
import SVProgressHUD

class VendorList: BaseViewController {
    @IBOutlet var tblVendor: UITableView!
    
    @IBOutlet var tfVendor: UITextField!
    var arrVendor:[Vendor]! = [Vendor]()
    override func viewDidLoad() {
        DispatchQueue.main.async {
        super.viewDidLoad()
            self.setUI()
        }

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
        super.viewDidAppear(true)
        self.getVendorData()
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

    // MARK: - Method
    func getVendorData(){
        tfVendor.setCommonFeature()
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        arrVendor = [Vendor]()
        arrVendor =  Vendor.getAll()
        print("arr of vendor count = \(arrVendor.count)")
        tblVendor.reloadData()
        SVProgressHUD.dismiss()
        self.tblVendor.pullToRefreshView.stopAnimating()
    }
    func setUI(){
        tfVendor.delegate = self
        tblVendor.separatorColor = UIColor.clear
        tblVendor.tableFooterView = UIView()
        tblVendor.delegate = self
        tblVendor.dataSource =  self
        self.tblVendor.addPullToRefresh { [self] in
            self.getVendorData()
            
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
extension VendorList:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count of vendor = \(arrVendor.count)")
        return arrVendor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "customervendorcell", for: indexPath) as? CustomerVendorCell{
           if let customer = arrVendor[indexPath.row] as? Vendor{
           cell.lblName.text = customer.name
               cell.lblCustName.text = customer.mobileNo
               cell.vwEmail.isHidden = true
               cell.vwContactNo.isHidden =  true
           }
           return cell
       }else{
           return UITableViewCell()
       }
    }
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let addcustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
        if let customer = arrVendor[indexPath.row] as?  Vendor{
            addcustomer.selectedVendor = customer
            addcustomer.isVendor = true
//            if let custOfcontact = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:contact.customerID)) as? CustomerDetails{
//                addcontact.selectedCust = custOfcontact
//            }
        }
            addcustomer.isFromContactList = true
            addcustomer.isForAddAddress =  false
            addcustomer.isFromColdCallVisit = false
            addcustomer.isEditCustomer = true
            self.navigationController?.pushViewController(addcustomer, animated: true)
        }
    }
    
}
extension VendorList:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
           // arrOfFilteredLowerLeverUser = BaseViewController.staticlowerUser
            let trimmedstring = textField.text?.trimmingCharacters(in: .whitespaces).lowercased()
            print(trimmedstring ?? "")
        if (textField == tfVendor){
            arrVendor = Vendor.getAll()
           // arrCustomer = arrCustomer.map{ $0.name } as? [NSString] ?? [NSString]()
//            arrCustomer =
//            arrCustomer.filter({(item: NSString) -> Bool in
//
//                    let stringMatch1 = item.localizedCaseInsensitiveContains(trimmedstring ?? "")
//
//                    return stringMatch1
//                })
           
            arrVendor =
            arrVendor.compactMap { (temp) -> Vendor in
                    return temp
                    }.filter { (aUser) -> Bool in
                        
                        return ((aUser.name?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true) || (aUser.mobileNo.contains(trimmedstring ?? "") == true))
            }
                
            tblVendor.reloadData()
//            customerDropdown.dataSource = filteredCustomer as [String]
//            customerDropdown.reloadAllComponents()
//
//            customerDropdown.show()
          
        }
        return true
}
}
