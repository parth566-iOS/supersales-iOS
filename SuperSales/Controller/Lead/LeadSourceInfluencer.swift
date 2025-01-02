//
//  LeadSource&Influencer.swift
//  SuperSales
//
//  Created by Apple on 08/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown

class LeadSourceInfluencer: BaseViewController {
    @IBOutlet var vwLeadSource: UIView!
    
    
    @IBOutlet weak var scrlSourceInfluencer: UIScrollView!
    @IBOutlet var vwSecondInfluencer: UIView!
    @IBOutlet var tfLeadSource: UITextField!
    var leadSourceID:NSNumber = 0
    var assignUserDropdown:DropDown! = DropDown()
    
    @IBOutlet var tfFirstInfluencerName: UITextField!

    @IBOutlet var tfSecondInfluencerName: UITextField!
    
    @IBOutlet var tvSecondFluencerAddress: UITextView!
  
    @IBOutlet var tvInfluencerAddress: UITextView!
    
  
    @IBOutlet weak var btnAddFirstInflencerAddress: ButtonWithImage!
    
    @IBOutlet weak var btnAddNewInfluencer: ButtonWithImage!
    
    @IBOutlet weak var btnAddSecondInfluencer: ButtonWithImage!
    
    @IBOutlet weak var btnSecondInfluencerAddress: ButtonWithImage!
    @IBOutlet var vwFirstInfluencer: UIView!
    
    public static var selectedsource:LeadSource!
    public static var leadSourceIndex = Int64(0)
    var leadsourceDropDown:DropDown! = DropDown()
    var arrLeadSource:[LeadSource]!
    var leadSourceIndex:NSNumber!
   
    var popup:CustomerSelection? = nil
    var arrOfCustomers = [CustomerDetails]()
    
    var arrOfSelectedSingleCustomer = [CustomerDetails]()
     var selectedCustomer = CustomerDetails()
    public static var selectedFirstInfluencer:CustomerDetails! // = CustomerDetails()
    public static var selectedSecondInfluencer:CustomerDetails! // = CustomerDetails()
    var fIaddressDropdown:DropDown! = DropDown()
    var sIaddressDropdown:DropDown! = DropDown()
    var arrOfTempAddress = [AddressList]()
    var arrOfSecondInfluAddress = [AddressList]()
    var addressMasterID:NSNumber = 0
    var arrStrAddress = [String]()
    var initalleaddic:[String:Any] = [String:Any]()
    var editLeaddic:[String:Any] = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
   
//    override func viewDidAppear(){
//        super.viewDidAppear(true)
//
//    }

    
    
    //MARK: - Method
    func setUI()->(){
        
        tfLeadSource.setCommonFeature()
        tfFirstInfluencerName.setCommonFeature()
        tfSecondInfluencerName.setCommonFeature()
        
     scrlSourceInfluencer.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 300, right: 0)
        arrLeadSource = LeadSource.getAll()
        arrOfCustomers = CustomerDetails.getAllInfluencers()
        leadsourceDropDown.anchorView =  tfLeadSource
        tfLeadSource.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray") ?? UIImage())
        tfFirstInfluencerName.setrightImage(img: UIImage.init(named: "icon_search_black")!)
       tfSecondInfluencerName.setrightImage(img: UIImage.init(named: "icon_search_black")!)
        leadsourceDropDown.dataSource = arrLeadSource.map(
           {(
            $0.leadSourceValue
            )})
        leadsourceDropDown.bottomOffset = CGPoint.init(x: 0.0, y: tfLeadSource.bounds.size.height)
        self.tfFirstInfluencerName.addBorders(edges: .bottom, color: UIColor.black, cornerradius: 0)
        self.tfSecondInfluencerName.addBorders(edges: .bottom, color: UIColor.black, cornerradius: 0)
        self.tfLeadSource.addBorders(edges: .bottom, color: UIColor.black, cornerradius: 0)
        tvInfluencerAddress.setFlexibleHeight()
        tvSecondFluencerAddress.setFlexibleHeight()
        if(AddLead.isEditLead == true){//addSecondInfluencerInLead == 1
            
         
            
            
            if(AddLead.objLead.influencerID > 0  && self.activesetting.addSecondInfluencerInLead == 1){
                btnAddNewInfluencer.isUserInteractionEnabled = false
                btnAddFirstInflencerAddress.isUserInteractionEnabled = false
                tfFirstInfluencerName.isUserInteractionEnabled = false
            }else{
                if(AddLead.objLead.secondInfluencerID > 0 && self.activesetting.influencerInLead  == 1){
                    vwSecondInfluencer.isHidden = false
                }else{
                    vwSecondInfluencer.isHidden = true
                }
                btnAddNewInfluencer.isUserInteractionEnabled = true
                btnAddFirstInflencerAddress.isUserInteractionEnabled = true
                tfFirstInfluencerName.isUserInteractionEnabled = true
            }
            
            if(AddLead.objLead.secondInfluencerID > 0 && self.activesetting.influencerInLead  == 1){
                vwSecondInfluencer.isHidden = false
                btnAddSecondInfluencer.isUserInteractionEnabled = false
                btnSecondInfluencerAddress.isUserInteractionEnabled = false
                tfSecondInfluencerName.isUserInteractionEnabled = false
            }else{
                vwSecondInfluencer.isHidden = true
                btnAddSecondInfluencer.isUserInteractionEnabled = true
                btnSecondInfluencerAddress.isUserInteractionEnabled = true
                tfSecondInfluencerName.isUserInteractionEnabled = true
            }
            
          
            
        if(AddLead.objLead.leadSourceID > 0){
            LeadSourceInfluencer.selectedsource = self.arrLeadSource.filter{
            $0.leadSourceIndex == AddLead.objLead.leadSourceID
         }.first
            
            tfLeadSource.text = LeadSourceInfluencer.selectedsource.leadSourceValue
        }
            
          
            if let firstInfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:AddLead.objLead?.influencerID ?? 0)){
                LeadSourceInfluencer.selectedFirstInfluencer = firstInfluencer
tfFirstInfluencerName.text = firstInfluencer.name
                self.setFirstInfluencerAddress()
            }
    if let secondInfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:AddLead.objLead?.secondInfluencerID ?? 0)){
        LeadSourceInfluencer.selectedSecondInfluencer =  secondInfluencer
    tfSecondInfluencerName.text = secondInfluencer.name
        self.setSecondInfluencerAddress()

    }
            
            
//            if(self.activesetting.addSecondInfluencerInLead == 1){
//                self.vwSecondInfluencer.isHidden = false
//
//            }else{
//                self.vwSecondInfluencer.isHidden = true
//            }
//
//            if(self.activesetting.influencerInLead == 1){
//                self.vwFirstInfluencer.isHidden = false
//
//            }else{
//                self.vwFirstInfluencer.isHidden = true
//            }
        }else{
            
               
            
            btnAddNewInfluencer.isUserInteractionEnabled = true
            btnAddSecondInfluencer.isUserInteractionEnabled = true
            btnAddFirstInflencerAddress.isUserInteractionEnabled = true
            btnSecondInfluencerAddress.isUserInteractionEnabled = true
            tfFirstInfluencerName.isUserInteractionEnabled = true
            tfSecondInfluencerName.isUserInteractionEnabled = true
            if let strsource = LeadSourceInfluencer.selectedsource as? LeadSource{
                tfLeadSource.text = LeadSourceInfluencer.selectedsource.leadSourceValue
            }else{
            
                LeadSourceInfluencer.selectedsource = arrLeadSource[0]
                LeadSourceInfluencer.leadSourceIndex = LeadSourceInfluencer.selectedsource.leadSourceIndex
                tfLeadSource.text = LeadSourceInfluencer.selectedsource.leadSourceValue
            }
            if let firstinfluencer = LeadSourceInfluencer.selectedFirstInfluencer as? CustomerDetails{
                if let firstInfluencer = firstinfluencer as? CustomerDetails{
                    LeadSourceInfluencer.selectedFirstInfluencer = firstInfluencer
                    tfFirstInfluencerName.text = firstInfluencer.name
                    self.setFirstInfluencerAddress()
//                    if let firstInfluenAddress = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:firstInfluencer.addressID)) as? String{
//                        tvInfluencerAddress.text = firstInfluenAddress
//                        tvInfluencerAddress.setFlexibleHeight()
//                        print(firstInfluenAddress)
//
//                    }
                }
            }
            
            if let secondinfluencer = LeadSourceInfluencer.selectedSecondInfluencer as? CustomerDetails{
        if let secondInfluencer = secondinfluencer as? CustomerDetails{
            LeadSourceInfluencer.selectedSecondInfluencer =  secondinfluencer
        tfSecondInfluencerName.text = secondinfluencer.name
            self.setSecondInfluencerAddress()
//            if let secondInfluenAddress = AddressList().getAddressStringByAddressId(aId:       NSNumber.init(value:secondinfluencer.addressID)) as? String{
//                tvSecondFluencerAddress.text = secondInfluenAddress
//                tvSecondFluencerAddress.setFlexibleHeight()
//                self.setSecondInfluencerAddress()
//              }
        }
            }
            
            if(self.activesetting.addSecondInfluencerInLead == 1){
                if(AddLead.isEditLead == true){
                if(AddLead.objLead.influencerID > 0){
                    self.vwSecondInfluencer.isHidden = false
                }
                }else{
                    self.vwSecondInfluencer.isHidden = true
                }
                
            }else{
                self.vwSecondInfluencer.isHidden = true
            }
           
            if(self.activesetting.influencerInLead == 1){
                self.vwFirstInfluencer.isHidden = false
                
            }else{
                self.vwFirstInfluencer.isHidden = true
            }
             
        }
        
leadsourceDropDown.selectionAction = {(index,item) in
     LeadSourceInfluencer.selectedsource = self.arrLeadSource[index]
    LeadSourceInfluencer.leadSourceIndex = LeadSourceInfluencer.selectedsource.leadSourceIndex
   
    if(AddLead.isEditLead == false){
       
    self.initalleaddic = AddLead.LeadDic["addleadjson"] as! [String:Any]
        self.initalleaddic["LeadSourceID"] = LeadSourceInfluencer.leadSourceIndex
    AddLead.LeadDic["addleadjson"] = self.initalleaddic
        
    //    if(self.activesetting)
    }else{
        self.editLeaddic = AddLead.LeadDic["addleadjson"] as! [String:Any]
        self.editLeaddic["LeadSourceID"] = LeadSourceInfluencer.leadSourceIndex
    AddLead.LeadDic["addleadjson"] = self.editLeaddic
    }
    
self.tfLeadSource.text = item
        }
        
        tfLeadSource.delegate = self
        tfFirstInfluencerName.delegate = self
        tvInfluencerAddress.delegate = self
        tfSecondInfluencerName.delegate = self
        tvSecondFluencerAddress.delegate = self
       
    }
    
    func setFirstInfluencerAddress(){
        arrOfTempAddress.removeAll()
        arrOfTempAddress = AddressList().getAllAddressUsingCustomerId(cID: NSNumber.init(value: LeadSourceInfluencer.selectedFirstInfluencer.iD))
        arrStrAddress = [String]()
        var selectedAddress = AddressList()
      
        if(arrOfTempAddress.count > 0){
            selectedAddress = arrOfTempAddress.first ?? AddressList()
            addressMasterID = NSNumber.init(value: arrOfTempAddress.first?.addressID ?? 0)
            arrStrAddress =  arrOfTempAddress.map{ String.init(format: "%@ , %@ , %@ - %@ , %@ %@", $0.addressLine1 ?? "" , $0.addressLine2  ?? "",$0.city  ?? "",$0.pincode ?? "" , $0.state ?? "" , $0.country  ?? "")}
   
           
            tvInfluencerAddress.text  = arrStrAddress.first
            
            tvInfluencerAddress.setFlexibleHeight()
        }
        tvInfluencerAddress.layoutIfNeeded()
         fIaddressDropdown.dataSource = arrStrAddress
        tvInfluencerAddress.setFlexibleHeight()
        fIaddressDropdown.anchorView = tvInfluencerAddress
    
    fIaddressDropdown.selectionAction = {(index,item) in
        selectedAddress = self.arrOfTempAddress[index]
        self.tvInfluencerAddress.text = item
        self.tvInfluencerAddress.setFlexibleHeight()
        }
        if(AddLead.isEditLead == false){
        initalleaddic = AddLead.LeadDic["addleadjson"] as! [String:Any]
        initalleaddic["InfluencerID"] = LeadSourceInfluencer.selectedFirstInfluencer.iD
        initalleaddic["InfluencerAddressMasterID"] = selectedAddress.addressID
           
           AddLead.LeadDic["addleadjson"] = initalleaddic
        }else{
            editLeaddic = AddLead.LeadDic["addleadjson"] as! [String:Any]
            editLeaddic["InfluencerID"] = LeadSourceInfluencer.selectedFirstInfluencer.iD
            editLeaddic["InfluencerAddressMasterID"] = selectedAddress.addressID
                   
        AddLead.LeadDic["addleadjson"] = editLeaddic
        }
        
        if(self.activesetting.addSecondInfluencerInLead == 1){
         
            self.vwSecondInfluencer.isHidden = false
            
        }else{
            self.vwSecondInfluencer.isHidden = true
        }
    }
    
    func setSecondInfluencerAddress(){
        arrOfSecondInfluAddress.removeAll()
        arrOfSecondInfluAddress = AddressList().getAllAddressUsingCustomerId(cID: NSNumber.init(value: LeadSourceInfluencer.selectedSecondInfluencer.iD ))
    addressMasterID = NSNumber.init(value: arrOfSecondInfluAddress.first?.addressID ?? 0)
    arrStrAddress =  arrOfSecondInfluAddress.map{ String.init(format: "%@ , %@ , %@ - %@ , %@ %@", $0.addressLine1 ?? "" , $0.addressLine2  ?? "",$0.city  ?? "",$0.pincode ?? "" , $0.state ?? "" , $0.country  ?? "")}
      
    sIaddressDropdown.dataSource = arrStrAddress
        var sIAddress = AddressList() //NSNumber.init(value: 0)
        sIaddressDropdown.anchorView = tvSecondFluencerAddress
sIaddressDropdown.selectionAction = {(index,item) in
sIAddress = self.arrOfSecondInfluAddress[index]
self.tvSecondFluencerAddress.text = item
    self.tvSecondFluencerAddress.setFlexibleHeight()
        }
        print(sIAddress)
        self.tvSecondFluencerAddress.layoutIfNeeded()
//        tvSecondFluencerAddress.text = "wvfrfw"
        tvSecondFluencerAddress.text  = arrStrAddress.first
tvSecondFluencerAddress.setFlexibleHeight()
        
        if(AddLead.isEditLead == false){
        initalleaddic = AddLead.LeadDic["addleadjson"] as! [String:Any]
            initalleaddic["secondInfluencerID"] = LeadSourceInfluencer.selectedSecondInfluencer.iD
    initalleaddic["secondInfluencerAddressMasterID"] = addressMasterID
           
           AddLead.LeadDic["addleadjson"] = initalleaddic
        }else{
    editLeaddic = AddLead.LeadDic["addleadjson"] as! [String:Any]
            editLeaddic["secondInfluencerID"] = LeadSourceInfluencer.selectedSecondInfluencer.iD
    editLeaddic["secondInfluencerAddressMasterID"] = addressMasterID
                   
        AddLead.LeadDic["addleadjson"] = editLeaddic
        }
    /*    if(AddLead.isEditLead == false){
              initalleaddic = AddLead.LeadDic["addleadjson"] as! [String:Any]
        initalleaddic["secondInfluencerID"] = selectedFirstInfluencer.iD
           
    initalleaddic["secondInfluencerAddressMasterID"] = self.addressMasterID
        AddLead.LeadDic["addleadjson"] = initalleaddic
        }else{
            editLeaddic = AddLead.LeadDic["addleadjson"] as! [String:Any]
                      editLeaddic["InfluencerID"] = selectedFirstInfluencer.iD
                   
    editLeaddic["InfluencerAddressMasterID"] = self.addressMasterID
        AddLead.LeadDic["addleadjson"] = editLeaddic
        }*/
    }
    //MARK: - IBAction


    @IBAction func btnAddInfluencerClicked(_ sender: UIButton) {
          if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
            Common.skipVisitSelection = false
            addCustomer.saveCustDelegate =  self
            addCustomer.isVendor = false
            addCustomer.isFromColdCallVisit = false
               addCustomer.isEditCustomer = false
            addCustomer.isForAddAddress = false
            AddCustomer.isFromInfluencer = 1
            self.navigationController?.pushViewController(addCustomer, animated: true)
               }
        /*
         if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
             Common.skipVisitSelection = false
             addCustomer.isFromColdCallVisit = false
             addCustomer.isEditCustomer = false
             addCustomer.selectedCustomer = CustomerDetails()
             addCustomer.isVendor = false
             addCustomer.saveCustDelegate = self
         self.navigationController?.pushViewController(addCustomer, animated: true)
         }
         
         **/
    }
    @IBAction func btnAddSecondInfluencerClicked(_ sender: UIButton) {
          if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
            Common.skipVisitSelection = false
            addCustomer.saveCustDelegate =  self
            addCustomer.isVendor = false
            addCustomer.isFromColdCallVisit = false
            addCustomer.isEditCustomer = false
            addCustomer.isForAddAddress = false
            AddCustomer.isFromInfluencer = 2
            self.navigationController?.pushViewController(addCustomer, animated: true)
               }
        /*
         if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
             Common.skipVisitSelection = false
             addCustomer.isFromColdCallVisit = false
             addCustomer.isEditCustomer = false
             addCustomer.selectedCustomer = CustomerDetails()
             addCustomer.isVendor = false
             addCustomer.saveCustDelegate = self
         self.navigationController?.pushViewController(addCustomer, animated: true)
         }
         
         **/
    }
    @IBAction func btnAddInflencerAddressClicked(_ sender: ButtonWithImage) {
        if let influencer  = LeadSourceInfluencer.selectedFirstInfluencer as? CustomerDetails{
        if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
            Common.skipVisitSelection = false
            AddCustomer.isFromInfluencer = 0
            addCustomer.isForAddAddress = false
            addCustomer.isVendor = false
            addCustomer.isFromColdCallVisit = false
            addCustomer.isEditCustomer = true
            addCustomer.selectedCustomer =  LeadSourceInfluencer.selectedFirstInfluencer
self.navigationController?.pushViewController(addCustomer, animated: true)
        }
        }else{
            Utils.toastmsg(message:"Please Select Influencer",view: self.view)
        }
    }
    
    
    @IBAction func btnAddSecondInfluencerAddressClicked(_ sender: ButtonWithImage) {
        if let influencer  = LeadSourceInfluencer.selectedSecondInfluencer as? CustomerDetails{
        if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
            Common.skipVisitSelection = false
            AddCustomer.isFromInfluencer = 0
            addCustomer.isForAddAddress = false
            addCustomer.isVendor = false
            addCustomer.isFromColdCallVisit = false
            addCustomer.isEditCustomer = true
            addCustomer.selectedCustomer =  LeadSourceInfluencer.selectedSecondInfluencer
self.navigationController?.pushViewController(addCustomer, animated: true)
        }
        }else{
            Utils.toastmsg(message:"Please Select Influencer",view: self.view)
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
extension LeadSourceInfluencer:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfLeadSource){
            leadsourceDropDown.show()
            return false
        }else if(textField == tfFirstInfluencerName){
   
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
                    popup?.viewfor = ViewFor.firstInfluencer
                
                          // popup?.showAnimate()
                          //   self.popoverPresentationController =  popup
                popup?.parentViewOfPopup = self.view
               
                Utils.addShadow(view: self.view)
                          self.present(popup!, animated: true, completion: nil)
            }else{
                Utils.toastmsg(message:"No influencer available",view: self.view)
            }
            
            return false
        }else if(textField == tfSecondInfluencerName){
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
                          popup?.viewfor = ViewFor.secondInfluencer
        print(popup?.viewfor)
        popup?.parentViewOfPopup = self.view
        Utils.addShadow(view: self.view)
                          self.present(popup!, animated: true, completion: nil)
            }else{
                Utils.toastmsg(message:"No influencer available",view: self.view)
            }
            return false
        }else{
            return false
        }
    }
   
}
extension LeadSourceInfluencer:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(textView == tvInfluencerAddress){
    fIaddressDropdown.show()
            return false
        }
        else if(textView == tvSecondFluencerAddress){
           sIaddressDropdown.show()
            return false
        }
        else{
        return true
        }
    }
}
extension LeadSourceInfluencer:PopUpDelegateNonMandatory{
    
   
    
    func completionfirstInfluencer(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
   
        print(arr.count)
        if(self.activesetting.addSecondInfluencerInLead == 1){
            self.vwSecondInfluencer.isHidden = false
            
        }else{
            self.vwSecondInfluencer.isHidden = true
        }
//        arrOfSelectedCustomer = arr
       
            arrOfSelectedSingleCustomer = arr
        LeadSourceInfluencer.selectedFirstInfluencer =  arr.first!
        tfFirstInfluencerName.text = LeadSourceInfluencer.selectedFirstInfluencer.name
    self.setFirstInfluencerAddress()
    }
      
        func completionsecondInfluencer(arr: [CustomerDetails]) {
            Utils.removeShadow(view: self.view)
       
            print(arr.count)
         
    //        arrOfSelectedCustomer = arr
           
    arrOfSelectedSingleCustomer = arr
            LeadSourceInfluencer.selectedSecondInfluencer =  arr.first!
           
            tfSecondInfluencerName.text = LeadSourceInfluencer.selectedSecondInfluencer.name
                
        self.setSecondInfluencerAddress()
                
            
        }

    
}
extension LeadSourceInfluencer:AddCustomerDelegate{
    func saveCustomer(customerID: NSNumber, customerName: String, contactID: NSNumber) {
        if let newcustomer  =  CustomerDetails.getCustomerByID(cid: customerID) as? CustomerDetails{
        if(AddCustomer.isFromInfluencer == 1){
                  
                        LeadSourceInfluencer.selectedFirstInfluencer =  newcustomer
                
          

        tfFirstInfluencerName.text = LeadSourceInfluencer.selectedFirstInfluencer.name
            
    self.setFirstInfluencerAddress()
        }else{
            LeadSourceInfluencer.selectedSecondInfluencer =  newcustomer
            tfSecondInfluencerName.text = LeadSourceInfluencer.selectedSecondInfluencer.name
        self.setSecondInfluencerAddress()
        }
        }
    }
    
    
}
//extension LeadSourceInfluencer:AddCustomerDelegate{
//    func saveCustomer(customerID: NSNumber, customerName: String) {
//
//        initalleaddic = AddLead.LeadDic["addleadjson"] as! [String:Any]
//        initalleaddic["CustomerID"] = customerID // LeadCustomerDetail.selectedCustomer.iD
//        if let newcustomer  =  CustomerDetails.getCustomerByID(cid: customerID) as? CustomerDetails{
//            LeadCustomerDetail.selectedCustomer = newcustomer
//        }
//        AddLead.LeadDic["addleadjson"]  =  initalleaddic
//        self.tfSearchBar.text = LeadCustomerDetail.selectedCustomer.name
//        self.setAddress()
//    }
//
//
//}
