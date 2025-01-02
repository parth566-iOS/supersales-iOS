//
//  LeadCustomerDetail.swift
//  SuperSales
//
//  Created by Apple on 08/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
import FastEasyMapping

class LeadCustomerDetail: BaseViewController {

     // @IBOutlet var tfCustomer: UITextField!
    //  @IBOutlet weak var searchCustomer:  UISearchBar!
      
    @IBOutlet weak var scrlLeadCustomer: UIScrollView!
    @IBOutlet weak var tfSearchBar: UITextField!
    
      @IBOutlet weak var btnSearchCustomer: UIButton!
      
    @IBOutlet weak var btnAddNewCustomer: UIButton!
    
    @IBOutlet weak var btnAddNewAddress: UIButton!
    @IBOutlet weak var btnAddNewContactAddress: UIButton!
    //    @IBOutlet weak var searchCustomer: UISearchBar!
      @IBOutlet weak var tvCustomerAddress: UITextView!
    
    @IBOutlet var tfContactPerson: UITextField!
    var popup:CustomerSelection? = nil
    var arrAllCustomer:[NSString] = [NSString]()
    var filteredCustomer:[NSString] = [NSString]()
    var arrOffilteredCustomer = [CustomerDetails]()
    public static var selectedCustomer:CustomerDetails!
    public static var selectedTempCustomer:TempcustomerDetails!
    var arrLowerLevelUser = [CompanyUsers]()
    var arrOfCustomers = [CustomerDetails]()
    var arrOfSelectedSingleCustomer = [CustomerDetails]()
    var customerDropdown:DropDown! = DropDown()
    var arrOfTempAddress = [AddressList]()
   
    
    var arrStrAddress = [String]()
    var arrOfContact = [Contact]()
    var arrOfStrContactName = [String]()
    public static var  addressMasterID:NSNumber = NSNumber.init(value:0)
    public static var contactID:NSNumber = NSNumber.init(value:0)
   
    var arrOfFilteredLowerLeverUser:[CompanyUsers] = [CompanyUsers]()
    
    var contactDropdown:DropDown! = DropDown()
    var addressDropdown:DropDown! = DropDown()
    var initalleaddic:[String:Any] = [String:Any]()
    var editLeadDic:[String:Any] = [String:Any]()
    var arrOffilteredTempCustomer  = [TempcustomerDetails]()
   
    var selectedTempCustomer:TempcustomerDetails?
    let noOFCustomer = Utils.getDefaultIntValue(key: Constant.kNoOfCustomer)
    let noOfTotalCustomer = Utils.getDefaultIntValue(key:  Constant.kTotalCustomer)
    var searchedtext = ""
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
       // self.view.backgroundColor = UIColor.blue
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(forName: Notification.Name("updateContactDetail"), object: nil, queue: OperationQueue.main) { (notify) in
                 
          self.updateContactUI()
       
              }
  }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setUI()
    }
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(true)
      NotificationCenter.default.removeObserver(self, name: Notification.Name("updateContactDetail"), object: nil)
  }
    //MARK: - Method
    func setUI(){
     
        if(self.activesetting.requireAddNewCustomerInVisitLeadOrder == 0) {
            btnAddNewCustomer.isHidden = true
        }else{
            btnAddNewCustomer.isHidden = false
        }
        tfSearchBar.setCommonFeature()
        tfContactPerson.setCommonFeature()
        
        tfContactPerson.setrightImage(img: UIImage.init(named: "icon_search_black")!)
        scrlLeadCustomer.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 300, right: 0)
        tfSearchBar.delegate = self
        tfContactPerson.delegate = self
        tvCustomerAddress.delegate = self
        arrOfCustomers = CustomerDetails.getAllCustomers()
        arrAllCustomer = arrOfCustomers.map{ $0.name } as? [NSString] ?? [NSString]()
        addressDropdown.anchorView =  tvCustomerAddress
        self.tfContactPerson.addBorders(edges: .bottom, color: UIColor.black, cornerradius: 0)
        addressDropdown.bottomOffset = CGPoint.init(x: 0.0, y: tvCustomerAddress.bounds.size.height)
        addressDropdown.selectionAction = {(index,item) in
                    self.tvCustomerAddress.text = item
            self.tvCustomerAddress.setFlexibleHeight()
                }
                contactDropdown.anchorView =  tfContactPerson
                
                contactDropdown.bottomOffset = CGPoint.init(x: 0.0, y: tfContactPerson.bounds.size.height)
                contactDropdown.selectionAction = {(index,item) in
let selectedcontact = self.arrOfContact[index] as Contact
                    LeadCustomerDetail.contactID = NSNumber.init(value:selectedcontact.iD)
                    
                    
                    
                    //seet border
   
if(AddLead.isEditLead == false){
let     arrLeadSource = LeadSource.getAll()
    if(arrLeadSource.count > 0){
    LeadSourceInfluencer.selectedsource = arrLeadSource[0]
    LeadSourceInfluencer.leadSourceIndex = LeadSourceInfluencer.selectedsource.leadSourceIndex
   
    }else{
        LeadSourceInfluencer.leadSourceIndex = NSNumber.init(value:1).int64Value
    }
        AddLead.LeadDic["addleadjson"] = self.initalleaddic
                    }else{
       
//        self.editLeadDic["ContactID"] = LeadCustomerDetail.contactID
//        AddLead.LeadDic["addleadjson"] = self.editLeadDic
                    }
        self.tfContactPerson.text = item
                }
        self.initalleaddic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
        self.editLeadDic = AddLead.LeadDic["addleadjson"] as! [String : Any]
         customerDropdown.anchorView =  tfSearchBar
                
     customerDropdown.bottomOffset = CGPoint.init(x: 0.0, y: tfSearchBar.bounds.size.height)
               
    customerDropdown.selectionAction = {(index,item) in
       
        self.changeAssigneeAsperCustomerSelection()
        self.tfSearchBar.text =  item
   // self.searchCustomer.text = item
        self.arrOfSelectedSingleCustomer = [CustomerDetails]()
        if(self.noOFCustomer > self.noOfTotalCustomer && self.arrOfCustomers.count > 0){
            self.arrOfSelectedSingleCustomer = [self.arrOfCustomers[index]]
        }else{
          //  self.arrOfSelectedSingleCustomer = arrOffilteredTempCustomer[index]
        }
      //  self.arrOfSelectedSingleCustomer = [LeadCustomerDetail.selectedCustomer]
       
   
        
        self.arrOfSelectedSingleCustomer.removeAll()
      
        if(self.noOFCustomer > self.noOfTotalCustomer && self.arrOfCustomers.count > 0){
            LeadCustomerDetail.selectedCustomer = self.arrOffilteredCustomer[index] as
                CustomerDetails
        self.changeAssigneeAsperCustomerSelection()
        
        self.arrOfSelectedSingleCustomer.removeAll()
            if let selectedcustomer = LeadCustomerDetail.selectedCustomer{
            self.arrOfSelectedSingleCustomer.append(selectedcustomer)
            
        }
        self.setAddress()
        }else if(self.arrOffilteredTempCustomer.count > 0){
            LeadCustomerDetail.selectedTempCustomer = self.arrOffilteredTempCustomer[index] as
                TempcustomerDetails
            
            self.changeAssigneeAsperTempCustomerSelection()
            
            self.arrOfSelectedSingleCustomer.removeAll()
//                if let selectedcustomer = self.selectedTempCustomer{
//                    self.arrOfSelectedSingleCustomer.append(selectedcustomer)
//                    self.arrOfSelectedMultipleCustomer.append(selectedcustomer)
//                }
            self.setTempAddress()
        }else{
            LeadCustomerDetail.selectedCustomer = self.arrOffilteredCustomer[index] as
                CustomerDetails
        self.changeAssigneeAsperCustomerSelection()
        
        self.arrOfSelectedSingleCustomer.removeAll()
            if let selectedcustomer = LeadCustomerDetail.selectedCustomer{
            self.arrOfSelectedSingleCustomer.append(selectedcustomer)
            
        }
        self.setAddress()
        }
        
    }
     if(AddLead.isEditLead ==  true){
        self.editLeadDic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
        self.editLeadDic["LeadSourceID"] = LeadSourceInfluencer.leadSourceIndex
        self.editLeadDic["OriginalAssignee"] = self.activeuser?.userID
            self.editLeadDic["CreatedBy"] = self.activeuser?.userID
             AddLead.LeadDic["addleadjson"] = self.editLeadDic
            if let cust = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:AddLead.objLead?.customerID ?? 0)) as? CustomerDetails{
                LeadCustomerDetail.selectedCustomer = cust
                self.changeAssigneeAsperCustomerSelection()
            }
        self.tfSearchBar.text = LeadCustomerDetail.selectedCustomer.name
//searchCustomer.text = selectedCustomer.name
self.setAddress()
if(AddLead.objLead.addressMasterID > 0){
    if  let address = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:AddLead.objLead?.addressMasterID ?? 0)) as? String
    {
        tvCustomerAddress.text =  address
        self.tvCustomerAddress.setFlexibleHeight()
        }
    }
        
        
}else{
            if let selectedcustomer = LeadCustomerDetail.selectedCustomer{
                self.tfSearchBar.text = LeadCustomerDetail.selectedCustomer.name
                self.setAddress()
            }
            if (LeadCustomerDetail.contactID.intValue > 0){
                if let selectedContact = Contact.getContactFromID(contactID: LeadCustomerDetail.contactID) as? Contact{
                    tfContactPerson.text = String.init(format:"\(selectedContact.firstName ?? "") \(selectedContact.lastName ?? "")")
                }
            }
//        self.initalleaddic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
//       
//            AddLead.LeadDic["addleadjson"] = self.initalleaddic
        }


       
        
    }
    
    func changeAssigneeAsperCustomerSelection(){
        var taggedToIDListOfUserID  = [Int]()
        AddLeadFourthStep.arrOfLowerLevelUser = [CompanyUsers]()
        if let selectedCustomer = LeadCustomerDetail.selectedCustomer as? CustomerDetails{
        taggedToIDListOfUserID = selectedCustomer.taggedToIDList.map(
            {
                //taggedUserID
                ($0 as! TaggedToIDList).taggedUserID
                
            })
        }
        for user in BaseViewController.staticlowerUser{
            if(user.entity_id == self.activeuser?.userID){
                AddLeadFourthStep.arrOfLowerLevelUser.append(user)
            }else if(taggedToIDListOfUserID.contains(Int(user.entity_id)) && user.role_id != 9){
                AddLeadFourthStep.arrOfLowerLevelUser.append(user)
            }
            
        }
    }
    
    
    //MARK: = For temp Customer (Customer which is not exist in database  and will added afer create a visit/lead for them)
    func setTempAddress(){
        arrOfTempAddress.removeAll()
        arrOfTempAddress = AddressList().getAllAddressUsingCustomerId(cID: NSNumber.init(value: LeadCustomerDetail.selectedTempCustomer.iD ))
        
    self.initalleaddic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
    self.editLeadDic = AddLead.LeadDic["addleadjson"] as! [String : Any]
     //   self.initalleaddic["AddressMasterID"] = LeadCustomerDetail.addressMasterID
    arrStrAddress =  arrOfTempAddress.map{ String.init(format: "%@ , %@ , %@ - %@, %@ %@", $0.addressLine1 ?? "" , $0.addressLine2  ?? "",$0.city  ?? "",$0.pincode ?? "" , $0.state ?? "" , $0.country  ?? "")}
  
    addressDropdown.dataSource = arrStrAddress
        
   
    tvCustomerAddress.setFlexibleHeight()
    arrOfContact.removeAll()
        arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: LeadCustomerDetail.selectedTempCustomer.iD))
    arrOfStrContactName =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
    
    contactDropdown.dataSource = arrOfStrContactName
    contactDropdown.reloadAllComponents()
    if(AddLead.isEditLead == false){
        LeadCustomerDetail.addressMasterID = NSNumber.init(value: arrOfTempAddress.first?.addressID ?? 0)
        tvCustomerAddress.text  = arrStrAddress.first
        tvCustomerAddress.setFlexibleHeight()
        tfContactPerson.text =  arrOfStrContactName.count == 0 ? "No Contacts Exists":"Select Contact"

      
    }else{
        LeadCustomerDetail.addressMasterID = NSNumber.init(value:AddLead.objLead.addressMasterID)
        if(arrOfStrContactName.count == 0){
         tfContactPerson.text = "No Contacts Exists"
        }else if(LeadCustomerDetail.contactID.intValue > 0){
            if let contact = Contact.getContactFromID(contactID:LeadCustomerDetail.contactID){
                
                tfContactPerson.text = String.init(format:"\(contact.firstName ?? "") \(contact.lastName ?? "")")
            }
        }else if(AddLead.objLead.contactID == 0 &&  arrOfStrContactName.count > 0){
          tfContactPerson.text = "Select Contact"
        }else{
            if let contact = Contact.getContactFromID(contactID: NSNumber.init(value:AddLead.objLead.contactID)){
                LeadCustomerDetail.contactID = NSNumber.init(value:AddLead.objLead.contactID)
                tfContactPerson.text = String.init(format:"\(contact.firstName ?? "") \(contact.lastName ?? "")")
            }else{
                LeadCustomerDetail.contactID = NSNumber.init(value:0)
              tfContactPerson.text = ""
            }
        }
        editLeadDic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
        editLeadDic["CustomerID"] = LeadCustomerDetail.selectedCustomer.iD
        editLeadDic["ContactID"] = LeadCustomerDetail.contactID
        editLeadDic["AddressMasterID"] = LeadCustomerDetail.addressMasterID
    AddLead.LeadDic["addleadjson"] = editLeadDic
        }
        
        
        
        
        
        
        
       
    }
    
    
    func changeAssigneeAsperTempCustomerSelection(){
        var taggedToIDListOfUserID  = [Int]()
        if let selectedCustomer = LeadCustomerDetail.selectedTempCustomer as? TempcustomerDetails{
            taggedToIDListOfUserID = selectedCustomer.taggedToIDList.map(
                {
                    //taggedUserID
                    ($0 as! TaggedToIDList).taggedUserID
                    
                })
        }
        for user in BaseViewController.staticlowerUser{
            if(user.entity_id == self.activeuser?.userID){
                AddLeadFourthStep.arrOfLowerLevelUser.append(user)
            }else if(taggedToIDListOfUserID.contains(Int(user.entity_id)) && user.role_id != 9){
                AddLeadFourthStep.arrOfLowerLevelUser.append(user)
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
    //MARK: - IBAction
    @IBAction func btnSearchCustomerClicked(_ sender: UIButton) {
         if(AddLead.isEditLead == false){
            if(arrOfCustomers.count > 0){
                popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                popup?.strTitle = ""
            popup?.arrOfSelectedSingleCustomer = arrOfSelectedSingleCustomer
                popup?.modalPresentationStyle = .overCurrentContext
                popup?.nonmandatorydelegate = self
                popup?.arrOfList = arrOfCustomers
                popup?.selectionmode = SelectionMode.none
                popup?.isFilterRequire = false
                popup?.strLeftTitle = "REFRESH"
                popup?.isSearchBarRequire = true
                popup?.isFromSalesOrder =  false
                popup?.viewfor = ViewFor.customer
              
                popup?.parentViewOfPopup = self.view
                Utils.addShadow(view: self.view)
                self.present(popup!, animated: true, completion: nil)
            }else{
             //   Utils.toastmsg(message:"No Customer Please Create new",view:self.view)
            }
        }
    }
    @IBAction func btnAddCustomerClicked(_ sender: UIButton) {
        
        if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
            Common.skipVisitSelection = false
            addCustomer.isFromColdCallVisit = false
            addCustomer.isEditCustomer = false
            AddCustomer.isFromInfluencer = 0
            addCustomer.isForAddAddress = false
            addCustomer.selectedCustomer = CustomerDetails()
            addCustomer.isVendor = false
            addCustomer.saveCustDelegate = self
        self.navigationController?.pushViewController(addCustomer, animated: true)
        }
    }
    @IBAction func btnAddCustomerAddressClicked(_ sender: UIButton) {
        if(arrOfSelectedSingleCustomer.count > 0){
          
        if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
            Common.skipVisitSelection = false
            addCustomer.isVendor = false
            AddCustomer.isFromInfluencer = 0
           
            addCustomer.isFromColdCallVisit = false
            addCustomer.isEditCustomer = true
            addCustomer.isForAddAddress = false
            addCustomer.selectedCustomer = LeadCustomerDetail.selectedCustomer
        self.navigationController?.pushViewController(addCustomer, animated: true)
        }
        }else{
            self.navigationController?.view.makeToast("Please select customer")
           // Utils.toastmsg(message:"Please select customer")
        }
    }
    
    @IBAction func btnAddNewContactClicked(_ sender: UIButton) {
      
            if  let addContact = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddContactView) as? AddContact{
                addContact.isEditContact = false
                Common.skipVisitSelection = false
                addContact.selectedCust =  LeadCustomerDetail.selectedCustomer
            
//                if  let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planVisit?.customerID ?? 0)){
//                addContact.selectedCust = customer
//                }
                addContact.isVendor = false
                addContact.selectedContact = Contact()
                addContact.addcontactdel = self
        self.navigationController?.pushViewController(addContact, animated: true)
            }
        
    }
    
    
    //MARK: - Method
    func setAddress(){
   
        arrOfTempAddress.removeAll()
        arrOfTempAddress = AddressList().getAllAddressUsingCustomerId(cID: NSNumber.init(value: LeadCustomerDetail.selectedCustomer.iD ))
        
    self.initalleaddic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
    self.editLeadDic = AddLead.LeadDic["addleadjson"] as! [String : Any]
     //   self.initalleaddic["AddressMasterID"] = LeadCustomerDetail.addressMasterID
    arrStrAddress =  arrOfTempAddress.map{ String.init(format: "%@ , %@ , %@ - %@, %@ %@", $0.addressLine1 ?? "" , $0.addressLine2  ?? "",$0.city  ?? "",$0.pincode ?? "" , $0.state ?? "" , $0.country  ?? "")}
  
    addressDropdown.dataSource = arrStrAddress
        
   
    tvCustomerAddress.setFlexibleHeight()
    arrOfContact.removeAll()
        arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: LeadCustomerDetail.selectedCustomer.iD))
    arrOfStrContactName =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
    
    contactDropdown.dataSource = arrOfStrContactName
    contactDropdown.reloadAllComponents()
    if(AddLead.isEditLead == false){
        LeadCustomerDetail.addressMasterID = NSNumber.init(value: arrOfTempAddress.first?.addressID ?? 0)
        tvCustomerAddress.text  = arrStrAddress.first
        tvCustomerAddress.setFlexibleHeight()
        tfContactPerson.text =  arrOfStrContactName.count == 0 ? "No Contacts Exists":"Select Contact"

      
    }else{
        LeadCustomerDetail.addressMasterID = NSNumber.init(value:AddLead.objLead.addressMasterID)
        if(arrOfStrContactName.count == 0){
         tfContactPerson.text = "No Contacts Exists"
        }else if(LeadCustomerDetail.contactID.intValue > 0){
            if let contact = Contact.getContactFromID(contactID:LeadCustomerDetail.contactID){
                
                tfContactPerson.text = String.init(format:"\(contact.firstName ?? "") \(contact.lastName ?? "")")
            }
        }else if(AddLead.objLead.contactID == 0 &&  arrOfStrContactName.count > 0){
          tfContactPerson.text = "Select Contact"
        }else{
            if let contact = Contact.getContactFromID(contactID: NSNumber.init(value:AddLead.objLead.contactID)){
                LeadCustomerDetail.contactID = NSNumber.init(value:AddLead.objLead.contactID)
                tfContactPerson.text = String.init(format:"\(contact.firstName ?? "") \(contact.lastName ?? "")")
            }else{
                LeadCustomerDetail.contactID = NSNumber.init(value:0)
              tfContactPerson.text = ""
            }
        }
        editLeadDic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
        editLeadDic["CustomerID"] = LeadCustomerDetail.selectedCustomer.iD
        editLeadDic["ContactID"] = LeadCustomerDetail.contactID
        editLeadDic["AddressMasterID"] = LeadCustomerDetail.addressMasterID
    AddLead.LeadDic["addleadjson"] = editLeadDic
        }
        }
    
    
    func updateContactUI(){
        
        if let selectedCustomer = LeadCustomerDetail.selectedCustomer as? CustomerDetails{
            arrOfContact.removeAll()
        arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: LeadCustomerDetail.selectedCustomer.iD ?? 0))
        arrOfStrContactName =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
        print(arrOfStrContactName.count)
        tfContactPerson.text =  arrOfStrContactName.count == 0 ? "No Contacts Exists":"Select Contact"
           
        if  let contact  =  Contact.getContactFromID(contactID: NSNumber.init(value:LeadCustomerDetail.selectedCustomer.iD ?? 0)){
            LeadCustomerDetail.contactID = NSNumber.init(value:contact.iD)
            tfContactPerson.text = String.init(format: "%@ %@", contact.firstName , contact.lastName)
        }else{
            if let contact = arrOfContact.first as? Contact{
                LeadCustomerDetail.contactID = NSNumber.init(value:contact.iD)
                tfContactPerson.text = String.init(format: "%@ %@", contact.firstName , contact.lastName)
            }
        }
        contactDropdown.dataSource = arrOfStrContactName
        contactDropdown.reloadAllComponents()
        }
    }
    func getTaagedCustomer(pageno:Int,trimmedstring:String){
        
        var param = Common.returndefaultparameter()
        param["Filter"] = trimmedstring
        param["PageNo"] = pageno
        print("parameter is = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetAllTaggedCustomer, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                let arrOfTaggedCustomer = arr as? [[String:Any]] ?? [[String:Any]]()
                
                
                print("array of customer = \(arrOfTaggedCustomer.count) for page no  = \(pageno) , \(pagesavailable),\(totalpages)")
                if(arrOfTaggedCustomer.count > 0){
                    
                    MagicalRecord.save({ (localcontext) in
                        if(pageno == 1){
                            CustomerDetails.mr_truncateAll(in: localcontext)
                        }
                        
                        
                        
                        FEMDeserializer.collection(fromRepresentation: arrOfTaggedCustomer, mapping: CustomerDetails.defaultmapping(), context: localcontext)
                        
                        
                        localcontext.mr_save({ (localcontext) in
                            //print("saving")
                        }, completion: { (status, error) in
                            //print("saved")
                        })
                        
                        
                        
                    }, completion: { (status, error) in
                        
                        if(error?.localizedDescription == ""){
                            print("tagged customer saved sucessfully total customer = \(CustomerDetails.getAllCustomers().count)")
                            let arrOfCustomers =  CustomerDetails.getAllCustomers()
                            self.filteredCustomer =  arrOfCustomers.filter({ (customer) -> Bool in
                                return (customer.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || customer.mobileNo.localizedStandardContains(trimmedstring ?? "") == true)
                            }).map{
                                $0.name as? NSString ?? ""
                            }
                            self.customerDropdown.dataSource = self.filteredCustomer as [String]
                            self.customerDropdown.reloadAllComponents()
                            
                            self.customerDropdown.show()
                        }else{
                            //print(error?.localizedDescription ?? "")
                        }
                        
                    })
                    
                    if(pageno < totalpages){
                        print("page is available for tagged customer api \(pagesavailable)")
                        self.getTaagedCustomer(pageno: pageno + 1 ,trimmedstring: trimmedstring)
                        
                    }else{
                        SVProgressHUD.dismiss()
                        self.arrOfCustomers = CustomerDetails.getAllCustomers()
                        
                        self.arrAllCustomer = self.arrOfCustomers.map{ $0.name } as? [NSString] ?? [NSString]()
                        
                        self.filteredCustomer =
                            self.arrAllCustomer.filter({(item: NSString) -> Bool in
                                return item.localizedCaseInsensitiveContains(trimmedstring ?? "") == true
                            })
                        
                        self.arrOffilteredCustomer =
                            self.arrOfCustomers.compactMap { (temp) -> CustomerDetails in
                                return temp
                            }.filter { (aUser) -> Bool in
                                return aUser.name?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true
                            }
                        
                        self.customerDropdown.dataSource = self.filteredCustomer as [String]
                        self.customerDropdown.reloadAllComponents()
                        self.customerDropdown.show()
                        
                    }
                }else{
                    SVProgressHUD.dismiss()
                    Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String
                                    ?? "" ?? message, view: self.view)
                }
            }else{
                SVProgressHUD.dismiss()
                Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String
                                ?? "" ?? message, view: self.view)
                
            }
        }
    }
}
/*
extension LeadCustomerDetail:UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if(searchBar == searchCustomer){
            if(AddLead.isEditLead == false){
            return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if(searchBar == searchCustomer){
        searchCustomer.endEditing(true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       if(searchBar == searchCustomer){
        searchCustomer.endEditing(true)
       }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      if(searchBar == searchCustomer){
        searchCustomer.endEditing(true)
      }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let trimmedstring = searchBar.text?.trimmingCharacters(in: .whitespaces).lowercased()
       
         if(searchBar == searchCustomer){
        filteredCustomer =
            arrAllCustomer.filter({(item: NSString) -> Bool in
              
                let stringMatch1 = item.localizedCaseInsensitiveContains(trimmedstring ?? "")

                return stringMatch1
            })
       
        arrOffilteredCustomer =
            arrOfCustomers.compactMap { (temp) -> CustomerDetails in
                return temp
                }.filter { (aUser) -> Bool in
                    
                    return aUser.name?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true
        }
            
        
        customerDropdown.dataSource = filteredCustomer as [String]
        customerDropdown.reloadAllComponents()
            
        customerDropdown.show()
         }
           // arrOfFilteredLowerLeverUser =
            
                   
        //self.tblCustomer.reloadData()
    }
    
}*/
extension LeadCustomerDetail:PopUpDelegateNonMandatory{
    
   
    
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr.count)
        arrOfSelectedSingleCustomer = arr
        LeadCustomerDetail.selectedCustomer =  arr.first!
        self.changeAssigneeAsperCustomerSelection()
      //  searchCustomer.text = selectedCustomer.name
        tfSearchBar.text = LeadCustomerDetail.selectedCustomer.name
    
            self.setAddress()
            
        
    }
    

    
}
extension LeadCustomerDetail:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfContactPerson){
            contactDropdown.show()
            return false
        }else{
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        arrOfFilteredLowerLeverUser = BaseViewController.staticlowerUser
        
        var fullstring = ""
        if let tft = textField.text as? String{
            fullstring.append(tft)
        }
        fullstring.append(string)
       // let trimmedstring = textField.text?.trimmingCharacters(in: .whitespaces).lowercased()
        let trimmedstring = fullstring.trimmingCharacters(in: .whitespaces).lowercased()
        if (textField == tfSearchBar){
            arrOfCustomers = CustomerDetails.getAllCustomers()
            let arrOfTempCustomers = TempcustomerDetails.getAllCustomers()
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
                    
                    self.customerDropdown.show()
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
                    Utils().getTaagedCustomer(pageno: 1, trimmedstring: trimmedstring ?? "", savepermenent: false){ (arr,message) in
                        SVProgressHUD.dismiss()
                       
                       // self.arrOfCustomers = CustomerDetails.getAllCustomers()
                        self.filteredCustomer =  arrOfTempCustomers.filter({ (customer) -> Bool in
                            return (customer.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || customer.mobileNo.localizedStandardContains(trimmedstring ?? "") == true)
                        }).map{
                            $0.name as? NSString ?? ""
                        }
                        self.arrOffilteredTempCustomer =
                                            arrOfTempCustomers.compactMap { (temp) -> TempcustomerDetails in
                                                return temp
                                            }.filter { (aUser) -> Bool in
                                                return (aUser.name.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || aUser.mobileNo.localizedCaseInsensitiveContains(trimmedstring ?? "") == true)
                                            }
                                        
                                        self.customerDropdown.dataSource = self.filteredCustomer as [String]
                        print("count of data source = \(self.filteredCustomer.count) temp customer arr = \(self.arrOffilteredTempCustomer.count)")
                                        self.customerDropdown.reloadAllComponents()
                                        
                                        self.customerDropdown.show()
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
            return true
        
        
     }
}
extension LeadCustomerDetail:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(textView == tvCustomerAddress){
            addressDropdown.show()
            return false
        }else{
            return true
        }
    }
}
extension LeadCustomerDetail:AddCustomerDelegate{
    func saveCustomer(customerID: NSNumber, customerName: String, contactID: NSNumber) {

        initalleaddic = AddLead.LeadDic["addleadjson"] as! [String:Any]
        initalleaddic["CustomerID"] = customerID // LeadCustomerDetail.selectedCustomer.iD
        if let newcustomer  =  CustomerDetails.getCustomerByID(cid: customerID) as? CustomerDetails{
            LeadCustomerDetail.selectedCustomer = newcustomer
            self.changeAssigneeAsperCustomerSelection()
        }
        AddLead.LeadDic["addleadjson"]  =  initalleaddic
        self.tfSearchBar.text = LeadCustomerDetail.selectedCustomer.name
        self.setAddress()
    }
    
    
}
extension LeadCustomerDetail:AddContactDelegate{
    func saveContact(customerID: NSNumber, customerName: String, contactName: String, contactID: NSNumber) {
        tfContactPerson.text = contactName
        LeadCustomerDetail.contactID =  contactID
      //  self.setAddress()
    }
}
