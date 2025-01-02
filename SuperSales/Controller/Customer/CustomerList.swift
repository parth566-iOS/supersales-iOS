//
//  CustomerList.swift
//  SuperSales
//
//  Created by Apple on 23/09/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import DropDown

class CustomerList: BaseViewController {

    
    @IBOutlet var tfCustomer: UITextField!
    
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var tblCustomer: UITableView!
    
    @IBOutlet weak var btnCustomerHistory: UIButton!
    var arrCustomer:[CustomerDetails]!
    var arrAllCustomer:[NSString] = [NSString]()
    var filteredCustomer:[NSString] = [NSString]()
    var arrOfCustomers = [CustomerDetails]()
    var customerDropdown:DropDown! = DropDown()
    var arrOfUserExceptExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var arrOfSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrOfCustomerSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrOfselectedCustomerSegment:[CustomerSegment]! = [CustomerSegment]()
    var arrOffilteredCustomerSegment:[CustomerSegment]! = [CustomerSegment]()
    var popup:CustomerSelection? = nil
    let noOFCustomer = Utils.getDefaultIntValue(key: Constant.kNoOfCustomer)
    let noOfTotalCustomer = Utils.getDefaultIntValue(key:  Constant.kTotalCustomer)
    var arrOffilteredCustomer = [CustomerDetails]()
    var searchedtext = ""
    var arrOffilteredTempCustomer  = [TempcustomerDetails]()
    var arrOfTempCustomers = [TempcustomerDetails]()
    var selectedTempCustomer:TempcustomerDetails?
  
    
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
            self.tfCustomer.text = ""
        self.getCustomerData()
        }
    }
    // MARK: - IBAction
    
    @IBAction func btnRefreshClicked(_ sender: UIButton) {
        tfCustomer.text = ""
        self.getCustomerData()
    }
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        let ftcellconfig = FTCellConfiguration.init()
        ftcellconfig.textColor = UIColor.black
        let ftconfig = FTConfiguration.shared

        ftconfig.backgoundTintColor =  UIColor.white
        popoverConfiguration.alternateCellColor = false
//FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("by_customer", comment:""),NSLocalizedString("by_products", comment:""),NSLocalizedString("by_user", comment:""),NSLocalizedString("by_product_category", comment:""),NSLocalizedString("by_segment", comment:""),NSLocalizedString("by_class", comment:""),NSLocalizedString("by_created_by", comment:""),NSLocalizedString("all", comment:"")], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration ,
        FTPopOverMenu.showForSender(sender: sender, with: [NSLocalizedString("all", comment:""),NSLocalizedString("by_segment", comment:""),"By Sales Person"], menuImageArray: [], popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration) { (i) in
            print(i)
            switch i{
            case 0:
                //All
                self.getCustomerData()
                break
            case 1:
                //By Segment
                self.arrOfSegment = CustomerSegment.getAll()
                if let segmentpopup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.MiddlePopup) as? ProductNameList{
                    if( self.arrOfselectedCustomerSegment.count == 0 && self.arrOfCustomerSegment.count > 0){
                        self.arrOfselectedCustomerSegment.removeAll()
                        self.arrOfselectedCustomerSegment.append(self.arrOfCustomerSegment.first ?? self.arrOfCustomerSegment[0])
                    
                    }
                segmentpopup.modalPresentationStyle = .overCurrentContext
                segmentpopup.arrOfCustomerSegment = self.arrOfSegment ?? [CustomerSegment]()
                segmentpopup.arrOfselectedCustomerSegment = self.arrOfselectedCustomerSegment ?? [CustomerSegment]()
                segmentpopup.strTitle = "Select Segment"
                segmentpopup.strLeftTitle = "OK"
                segmentpopup.strRightTitle = "Cancel"
                segmentpopup.selectionmode = SelectionMode.single
                segmentpopup.delegate = self
                segmentpopup.isSearchRequire = false
                segmentpopup.viewfor = ViewFor.customersegment
                segmentpopup.isFilterRequire = false
                segmentpopup.parentViewForPopup = self.view
                Utils.addShadowOnSahdow(view: self.view)
                self.present(segmentpopup, animated: true, completion: nil)
                }
                break
            case 2:
                //By Sales person
                if(self.arrOfUserExceptExecutive.count == 0){
                    Utils.toastmsg(message:"No Executive reporting to you",view: self.view)
                }else{
                    let sortedUserarr = self.arrOfUserExceptExecutive.sorted { (user1, user2) -> Bool in
                        user1.firstName < user2.firstName
                    }
                    self.arrOfUserExceptExecutive = sortedUserarr
                    self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                    self.popup?.modalPresentationStyle = .overCurrentContext
                    self.popup?.strTitle = "Select Sales Person"
                    self.popup?.nonmandatorydelegate = self
                    self.popup?.arrOfExecutive = self.arrOfUserExceptExecutive
                    self.popup?.arrOfSelectedExecutive = self.arrOfSelectedExecutive ?? [self.arrOfUserExceptExecutive[0]]
                    self.popup?.strLeftTitle = "OK"
                    self.popup?.strRightTitle = "Cancel"
                    self.popup?.selectionmode = SelectionMode.single
                    //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
                    self.popup?.isSearchBarRequire = false
                    self.popup?.isFromSalesOrder =  false
                    self.popup?.viewfor = ViewFor.companyuser
                    self.popup?.isFilterRequire = false
                    // popup?.showAnimate()
                    self.popup?.parentViewOfPopup = self.view
                    Utils.addShadow(view: self.view)
                    self.present(self.popup!, animated: false, completion: nil)
                }
                break
                
            default:
                print("default filter option clicked of lead screen")
            }
        } cancel: {
            print("Cancel")
        }

    }
    @IBAction func btnViewHistoryClicked(_ sender: UIButton) {
        if let customerhistory  = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistory) as? CustomerHistoryContainer{
            customerhistory.isEdit = true
//            customerhistory.customerName = lblCustomerName.text
//            customerhistory.customerID =  NSNumber.init(value:planVisit!.customerID)
        self.navigationController?.pushViewController(customerhistory, animated: true)
            
        }
        
    }
    
    @IBAction func btnLocateCustomerClicked(_ sender: UIButton) {
        
    }
    
    // MARK: - Method
    func getCustomerData(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        arrCustomer = [CustomerDetails]()
        arrCustomer =  CustomerDetails.getAllCustomers()
        tblCustomer.reloadData()
        tblCustomer.setContentOffset(CGPoint.zero, animated:true)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10, execute: {
       
        SVProgressHUD.dismiss()
        self.tblCustomer.pullToRefreshView.stopAnimating()
            
        })
    }
    func setUI(){
        tfCustomer.setCommonFeature()
        tblCustomer.separatorColor = UIColor.clear
        tblCustomer.tableFooterView = UIView()
        tblCustomer.delegate = self
        tblCustomer.dataSource =  self
        tfCustomer.delegate = self
        self.tblCustomer.addPullToRefresh { [self] in
            tfCustomer.text = ""
            self.getCustomerData()
            
        }
      //  DispatchQueue.global(qos: .background).async {
        if(BaseViewController.staticlowerUser.count == 0){
        self.fetchuser{
            (arrOfuser,error) in
            self.arrOfUserExceptExecutive = [CompanyUsers]()
//                arrOfUserExceptExecutive = BaseViewController.staticlowerUser.filter{
//                    $0.role_id.intValue <=  8
//                }
            self.arrOfUserExceptExecutive = BaseViewController.staticlowerUser
        if let currentuserid = self.activeuser?.userID{
            if let currentuser = CompanyUsers().getUser(userId: currentuserid) {
                if(!(self.arrOfUserExceptExecutive.contains(currentuser))){
            

                self.arrOfUserExceptExecutive.append(currentuser)
                }
                if(self.arrOfSelectedExecutive.count == 0){
                    self.arrOfSelectedExecutive = [currentuser]
                }
            }
        }
            self.arrOfUserExceptExecutive = self.arrOfUserExceptExecutive.filter({ (user) -> Bool in
                user.role_id != 9
            })
            
            let attributedcustomerHistory = NSAttributedString.init(string: "View Customer History", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)])
            self.btnCustomerHistory.setAttributedTitle(attributedcustomerHistory, for: .normal)
            
            let attributedrefresh = NSAttributedString.init(string: "Refresh", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)])
            
            self.btnRefresh.setAttributedTitle(attributedrefresh, for: .normal)
            
            
            
            
            
    }
        }
            customerDropdown.anchorView = tfCustomer
            //        customerDropdown.anchorView = searchCustomer
            customerDropdown.bottomOffset = CGPoint.init(x: 0, y: tfCustomer.bounds.size.height+20)
            // customerDropdown.bottomOffset = CGPoint.init(x: 0, y: searchCustomer.bounds.size.height+20)
            //   CGPointMake(0.0, self.btnAddress.bounds.size.height);
            customerDropdown.dataSource = filteredCustomer as [String]
            customerDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                if(noOFCustomer > noOfTotalCustomer && arrOfCustomers.count > 0){
                if let addcustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                if let customer = arrOffilteredCustomer[index] as?  CustomerDetails{
                    addcustomer.selectedCustomer = customer
                    addcustomer.isFromContactList =  true
                    
        //            if let custOfcontact = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:contact.customerID)) as? CustomerDetails{
        //                addcontact.selectedCust = custOfcontact
        //            }
                }
                    addcustomer.isVendor = false
                    addcustomer.isForAddAddress =  false
                    addcustomer.isFromColdCallVisit = false
                    addcustomer.isEditCustomer = true
                    self.navigationController?.pushViewController(addcustomer, animated: true)
                }
                }
                else if(arrOffilteredCustomer.count > 0){
                    self.selectedTempCustomer =  arrOffilteredTempCustomer[index]
                    let tempcustid = NSNumber.init(value:self.selectedTempCustomer?.iD ?? 0)
                    SVProgressHUD.show()
                Utils().getCustomerDetail(cid: tempcustid) { (status) in
                    if let addcustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                        if let secustomer = CustomerDetails.getCustomerByID(cid: tempcustid) as? CustomerDetails{
                        addcustomer.selectedCustomer = secustomer
                        addcustomer.isFromContactList =  true

                        }
                        addcustomer.isVendor = false
                        addcustomer.isForAddAddress =  false
                        addcustomer.isFromColdCallVisit = false
                        addcustomer.isEditCustomer = true
                        self.navigationController?.pushViewController(addcustomer, animated: true)
                    }
                }
                }else if(arrCustomer.count > 0){
                    if let addcustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                    if let customer = arrCustomer[index] as?  CustomerDetails{
                        addcustomer.selectedCustomer = customer
                        addcustomer.isFromContactList =  true
                        
            //            if let custOfcontact = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:contact.customerID)) as? CustomerDetails{
            //                addcontact.selectedCust = custOfcontact
            //            }
                    }
                        addcustomer.isVendor = false
                        addcustomer.isForAddAddress =  false
                        addcustomer.isFromColdCallVisit = false
                        addcustomer.isEditCustomer = true
                        self.navigationController?.pushViewController(addcustomer, animated: true)
                    }
                }else if(arrOfCustomers.count > 0){
                    if let addcustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                    if let customer = arrOfCustomers[index] as?  CustomerDetails{
                        addcustomer.selectedCustomer = customer
                        addcustomer.isFromContactList =  true
                        
            //            if let custOfcontact = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:contact.customerID)) as? CustomerDetails{
            //                addcontact.selectedCust = custOfcontact
            //            }
                    }
                        addcustomer.isVendor = false
                        addcustomer.isForAddAddress =  false
                        addcustomer.isFromColdCallVisit = false
                        addcustomer.isEditCustomer = true
                        self.navigationController?.pushViewController(addcustomer, animated: true)
                    }
                }else if(arrOfTempCustomers.count > 0){
                    self.selectedTempCustomer =  arrOfTempCustomers[index]
                    let tempcustid = NSNumber.init(value:self.selectedTempCustomer?.iD ?? 0)
                    SVProgressHUD.show()
                Utils().getCustomerDetail(cid: tempcustid) { (status) in
                    if let addcustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                        if let secustomer = CustomerDetails.getCustomerByID(cid: tempcustid) as? CustomerDetails{
                        addcustomer.selectedCustomer = secustomer
                        addcustomer.isFromContactList =  true

                        }
                        addcustomer.isVendor = false
                        addcustomer.isForAddAddress =  false
                        addcustomer.isFromColdCallVisit = false
                        addcustomer.isEditCustomer = true
                        self.navigationController?.pushViewController(addcustomer, animated: true)
                    }
                }
                }
            }
            
        }
      //  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
extension CustomerList:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count of customer = \(arrCustomer.count)")
       return arrCustomer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "customervendorcell", for: indexPath) as? CustomerVendorCell{
           if let customer = arrCustomer[indexPath.row] as? CustomerDetails{
       
           cell.lblName.text = customer.name
               cell.lblCustName.text = customer.mobileNo
            cell.lblEmail.text = customer.emailID
            if let custemailid = customer.emailID as? String{
            if(customer.emailID.count > 0){
                cell.vwEmail.isHidden = false
            }else{
               cell.vwEmail.isHidden = true
            }
            }else{
                cell.vwEmail.isHidden = true
            }
               cell.vwContactNo.isHidden =  true
           }
           return cell
       }else{
           return UITableViewCell()
       }
    }
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(noOFCustomer > noOfTotalCustomer && arrOfCustomers.count > 0){
            if let addcustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
            if let customer = arrCustomer[indexPath.row] as?  CustomerDetails{
                addcustomer.selectedCustomer = customer
                addcustomer.isFromContactList =  true
   
            }
                addcustomer.isVendor = false
                addcustomer.isForAddAddress =  false
                addcustomer.isFromColdCallVisit = false
                addcustomer.isEditCustomer = true
                self.navigationController?.pushViewController(addcustomer, animated: true)
            }
        }else{
            if (arrOfCustomers.count > 0){
                if let addcustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                if let customer = arrCustomer[indexPath.row] as?  CustomerDetails{
                    addcustomer.selectedCustomer = customer
                    addcustomer.isFromContactList =  true
       
                }
                    addcustomer.isVendor = false
                    addcustomer.isForAddAddress =  false
                    addcustomer.isFromColdCallVisit = false
                    addcustomer.isEditCustomer = true
                    self.navigationController?.pushViewController(addcustomer, animated: true)
                }
            }else{
                if (arrCustomer.count > 0){
                    if let addcustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                    if let customer = arrCustomer[indexPath.row] as?  CustomerDetails{
                        addcustomer.selectedCustomer = customer
                        addcustomer.isFromContactList =  true
           
                    }
                        addcustomer.isVendor = false
                        addcustomer.isForAddAddress =  false
                        addcustomer.isFromColdCallVisit = false
                        addcustomer.isEditCustomer = true
                        self.navigationController?.pushViewController(addcustomer, animated: true)
                    }
                }else{
            self.selectedTempCustomer =  arrOffilteredTempCustomer[indexPath.row]
            let tempcustid = NSNumber.init(value:self.selectedTempCustomer?.iD ?? 0)
        Utils().getCustomerDetail(cid: tempcustid) { (status) in
            if let addcustomer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                if let secustomer = self.arrCustomer[indexPath.row] as?  CustomerDetails{
                addcustomer.selectedCustomer = secustomer
                addcustomer.isFromContactList =  true

                }
                addcustomer.isVendor = false
                addcustomer.isForAddAddress =  false
                addcustomer.isFromColdCallVisit = false
                addcustomer.isEditCustomer = true
                self.navigationController?.pushViewController(addcustomer, animated: true)
            }
        }
        }
        }
        }
    }
    
}
    extension CustomerList:PopUpDelegateNonMandatory{
        
        func completionSelectedExecutive(arr: [CompanyUsers]) {
            Utils.removeShadow(view: self.view)
            arrOfSelectedExecutive =  arr
let             selectedUser = arrOfSelectedExecutive.first

            self.arrCustomer = CustomerDetails.getAllCustomers().filter{
                $0.createdBy == selectedUser?.entity_id.int64Value
            }
            print("arr of customer count = \(self.arrCustomer.count) after filter by sales person = \(selectedUser?.firstName)")
            self.tblCustomer.reloadData()
        }
        
       
    }
extension CustomerList:ProductSelectionPopUpDelegate{
    func completionSelectedSegment(arr: [CustomerSegment]) {
        ///segmentID = '%d'
        Utils.removeShadow(view: self.view)
        arrOfselectedCustomerSegment =  arr
//            self.isFilterActive = true
        if let customersegment  = arr.first{
        let predicate = NSPredicate.init(format: "segmentID =  '%d'",customersegment.iD)
//        //NSPredicate.init(format: "segmentID = '%d'",customersegment.iD as! CVarArg)
//       // let addressList = AddressList().getAddressUsingPredicate(predicate: predicate)
//            print(predicate)
            
       self.arrCustomer = CustomerDetails.getCustomersUsingPredicate(predicate: predicate)
          
//            for cust in  arrOfList{
//                if(cust.iD == customersegment.iD){
//
//                }
//            }
            self.arrCustomer = self.arrCustomer.filter({ (cust) -> Bool in
                cust.segmentID == customersegment.iD
            })
            
       
        }
        self.tblCustomer.reloadData()
    }
    
    
}
extension CustomerList:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
           // arrOfFilteredLowerLeverUser = BaseViewController.staticlowerUser
          
          
        var fullstring = ""
        if let tft = textField.text as? String{
            fullstring.append(tft)
        }
        fullstring.append(string)
       // let trimmedstring = textField.text?.trimmingCharacters(in: .whitespaces).lowercased()
        let trimmedstring = fullstring.trimmingCharacters(in: .whitespaces).lowercased()
     
        print("count =  \(trimmedstring.count) nd string = \(trimmedstring)")
        if (textField == tfCustomer){
          
           
            arrOfCustomers = CustomerDetails.getAllCustomers()
            arrOfTempCustomers = TempcustomerDetails.getAllCustomers()
            print("No of customer = \(noOFCustomer) && all cust count = \(arrOfCustomers.count)")
            if(string.count == 0 && trimmedstring.count != 4){
                customerDropdown.hide()
                if(noOFCustomer > noOfTotalCustomer && arrOfCustomers.count > 0){
                filteredCustomer =  arrOfCustomers.filter({ (customer) -> Bool in
                    return (customer.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || customer.mobileNo.localizedCaseInsensitiveContains(trimmedstring ?? "") == true)
                }).map{
                    $0.name as? NSString ?? ""
                }
                arrOffilteredCustomer =
                    arrOfCustomers.compactMap { (temp) -> CustomerDetails in
                        return temp
                    }.filter { (aUser) -> Bool in
                        return (aUser.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || aUser.mobileNo.localizedCaseInsensitiveContains(trimmedstring ?? "") == true)
                    }
                
                customerDropdown.dataSource = filteredCustomer as [String]
                customerDropdown.reloadAllComponents()
                print("count of data source = \(filteredCustomer.count)")
                customerDropdown.show()
                }else{
                    self.filteredCustomer =  arrOfTempCustomers.filter({ (customer) -> Bool in
                        return (customer.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || customer.mobileNo.localizedStandardContains(trimmedstring ?? "") == true)
                    }).map{
                        $0.name as? NSString ?? ""
                    }
    arrOffilteredTempCustomer =
                        arrOfTempCustomers.compactMap { (temp) -> TempcustomerDetails in
                            return temp
                        }.filter { (aUser) -> Bool in
                            return (aUser.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || aUser.mobileNo.localizedCaseInsensitiveContains(trimmedstring ?? "") == true)
                        }
                    
                    self.customerDropdown.dataSource = self.filteredCustomer as [String]
                    print("count of data source = \(self.filteredCustomer.count) temp customer arr = \(arrOffilteredTempCustomer.count)")
                   self.customerDropdown.reloadAllComponents()
                    
                    customerDropdown.show()
                }
            }else{
                customerDropdown.hide()
            if(noOFCustomer > noOfTotalCustomer && arrOfCustomers.count > 0){
                arrAllCustomer = arrOfCustomers.map{ $0.name } as? [NSString] ?? [NSString]()
                
                //            filteredCustomer =
                //                arrAllCustomer.filter({(item: NSString) -> Bool in
                //                    return (item.localizedCaseInsensitiveContains(trimmedstring ?? "") == true )
                //                })
                
                filteredCustomer =  arrOfCustomers.filter({ (customer) -> Bool in
                    return (customer.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || customer.mobileNo.localizedCaseInsensitiveContains(trimmedstring ?? "") == true)
                }).map{
                    $0.name as? NSString ?? ""
                }
                arrOffilteredCustomer =
                    arrOfCustomers.compactMap { (temp) -> CustomerDetails in
                        return temp
                    }.filter { (aUser) -> Bool in
                        return (aUser.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || aUser.mobileNo.localizedCaseInsensitiveContains(trimmedstring ?? "") == true)
                    }
                
                customerDropdown.dataSource = filteredCustomer as [String]
                customerDropdown.reloadAllComponents()
                
                customerDropdown.show()
            }else{
               
                if((textField.text?.count == 4 && string.count == 0) || (trimmedstring.count == 3 && string.count > 0)){
                    SVProgressHUD.show()
                    searchedtext = trimmedstring
                    Utils().getTaagedCustomer(pageno: 1, trimmedstring: trimmedstring ?? "", savepermenent: false){ [self] (arr,message) in
                        SVProgressHUD.dismiss()
                       
                       // self.arrOfCustomers = CustomerDetails.getAllCustomers()
                        self.filteredCustomer =  self.arrOfTempCustomers.filter({ (customer) -> Bool in
                            return (customer.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || customer.mobileNo.localizedStandardContains(trimmedstring ?? "") == true)
                        }).map{
                            $0.name as? NSString ?? ""
                        }
                        self.arrOffilteredTempCustomer =
                            self.arrOfTempCustomers.compactMap { (temp) -> TempcustomerDetails in
                                                return temp
                                            }.filter { (aUser) -> Bool in
                                                return (aUser.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || aUser.mobileNo.localizedCaseInsensitiveContains(trimmedstring ?? "") == true)
                                            }
                                        
                                        self.customerDropdown.dataSource = self.filteredCustomer as [String]
                        print("count of data source = \(self.filteredCustomer.count) temp customer arr = \(self.arrOffilteredTempCustomer.count)")
                      customerDropdown.reloadAllComponents()
                        customerDropdown.anchorView = tfCustomer
                        customerDropdown.show()
                    }
                    
                }else{
                    filteredCustomer =  arrOfCustomers.filter({ (customer) -> Bool in
                        return (customer.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || customer.mobileNo.localizedCaseInsensitiveContains(trimmedstring ?? "") == true)
                    }).map{
                        $0.name as? NSString ?? ""
                    }
                    arrOffilteredCustomer =
                        arrOfCustomers.compactMap { (temp) -> CustomerDetails in
                            return temp
                        }.filter { (aUser) -> Bool in
                            return (aUser.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || aUser.mobileNo.localizedCaseInsensitiveContains(trimmedstring ?? "") == true)
                        }
                    
                    customerDropdown.dataSource = filteredCustomer as [String]
                    customerDropdown.reloadAllComponents()
                    print("count of data source = \(filteredCustomer.count)")
                    DispatchQueue.main.async {
                        self.customerDropdown.show()
                    }
                    
            
                    print("dropdowndisplay")
                }
            }
            }
                }
            tblCustomer.reloadData()
//            customerDropdown.dataSource = filteredCustomer as [String]
//            customerDropdown.reloadAllComponents()
//
//            customerDropdown.show()
        return true
        }
       
}

