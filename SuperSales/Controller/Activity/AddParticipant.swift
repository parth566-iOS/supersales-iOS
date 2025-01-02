//
//  AddParticipant.swift
//  SuperSales
//
//  Created by mac on 07/06/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import DropDown
import FastEasyMapping

struct  participant {
    let name:String
    let cid:Int64?
    let contactno:String
}
extension participant:Equatable{
    static func == (lhs: participant, rhs: participant) -> Bool {
    return
        lhs.name == rhs.name &&
        lhs.cid == rhs.cid &&
        lhs.contactno == rhs.contactno
}
}
class AddParticipant: BaseViewController {

    @IBOutlet weak var btnNewCustomer: UIButton!
    @IBOutlet weak var btnExistingCustomer: UIButton!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnSearchCustomer: UIButton!
    
    @IBOutlet weak var tfCustomerName: UITextField!
    
    @IBOutlet weak var tfCustomerContact: UITextField!
    
    static var arrOfParticipant:[participant] = [participant]()
    var selectedcustomerId:NSNumber!
    var selectedActivityId:NSNumber!
    var customerselectionmode = CustomerSelectionMode.single
    var originalAssignee:NSNumber = 0
    var selectedTempCustomer:TempcustomerDetails?
    var selectedCustomer:CustomerDetails?
    var arrOfCustomers = [CustomerDetails]()
    var arrOfSelectedSingleCustomer  = [CustomerDetails]()
    var popup:CustomerSelection? = nil
    var selectedInteraction = InteractionType.metting
    let settingactive = Utils().getActiveSetting()
    let noOFCustomer = Utils.getDefaultIntValue(key: Constant.kNoOfCustomer)
    let noOfTotalCustomer = Utils.getDefaultIntValue(key:  Constant.kTotalCustomer)
    var arrOffilteredTempCustomer  = [TempcustomerDetails]()
    var searchedtext = ""
    var arrOfFilteredLowerLeverUser:[CompanyUsers] = [CompanyUsers]()
    var arrOffilteredCustomer = [CustomerDetails]()
    var filteredCustomer:[NSString] = [NSString]()
    var arrAllCustomer:[NSString] = [NSString]()
    var customerDropdown:DropDown! = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Method
    func setUI(){
        customerselectionmode = CustomerSelectionMode.multiple
        self.setViewAsperCustomerSelectionMode()
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        
        
        self.title = "Add Participant"
        
        //set delegate
        self.btnExistingCustomer.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.btnNewCustomer.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.tfCustomerName.delegate = self
        self.tfCustomerContact.delegate = self
        btnSubmit.setbtnFor(title: "Add Participant", type: Constant.kPositive)
//        tfCustomerName.setBottomBorder(tf: tfCustomerName, color: UIColor.black)
//        tfCustomerContact.setBottomBorder(tf: tfCustomerContact, color: UIColor.black)
        tfCustomerName.addBorders(edges: .bottom, color: .black, cornerradius: 1)
        tfCustomerContact.addBorders(edges: .bottom, color: .black, cornerradius: 1)
        arrOfCustomers = CustomerDetails.getAllCustomers()
        tfCustomerContact.isUserInteractionEnabled = false
        customerDropdown.anchorView = tfCustomerName
        //        customerDropdown.anchorView = searchCustomer
        customerDropdown.bottomOffset = CGPoint.init(x: 0, y: tfCustomerName.bounds.size.height+20)
        // customerDropdown.bottomOffset = CGPoint.init(x: 0, y: searchCustomer.bounds.size.height+20)
        //   CGPointMake(0.0, self.btnAddress.bounds.size.height);
        customerDropdown.dataSource = filteredCustomer as [String]
        customerDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            
            //      self.searchCustomer.text = item
            tfCustomerName.text = item
         
            self.arrOfSelectedSingleCustomer.removeAll()
            if(arrOffilteredCustomer.count > 0){
            self.selectedCustomer = self.arrOffilteredCustomer[index]
        
            
            self.arrOfSelectedSingleCustomer.removeAll()
            if let selectedcustomer = self.selectedCustomer{
                self.arrOfSelectedSingleCustomer.append(selectedcustomer)
               
            }
            }else if(arrOffilteredTempCustomer.count > 0){
//                self.selectedTempCustomer = self.arrOffilteredTempCustomer[index]
                if let tempcustomer = self.arrOffilteredTempCustomer[index] as? TempcustomerDetails{
                self.selectedTempCustomer = tempcustomer
                    self.arrOfSelectedSingleCustomer.removeAll()
//                    if let selectedcustomer = self.selectedTempCustomer{
//            self.arrOfSelectedSingleCustomer.append(selectedcustomer)
//                    }
                }
            }else{
                self.selectedCustomer = self.arrOffilteredCustomer[index]
                    self.arrOfSelectedSingleCustomer.removeAll()
                    if let selectedcustomer = self.selectedCustomer{
            self.arrOfSelectedSingleCustomer.append(selectedcustomer)
                    }
            }
           
        }
        customerDropdown.reloadAllComponents()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: IBAction
    
    @IBAction func btnExistingCustomerClicke(_ sender: UIButton) {
        customerselectionmode = CustomerSelectionMode.multiple
        self.setViewAsperCustomerSelectionMode()
    }
    
    
    @IBAction func btnNewCustomerClicked(_ sender: UIButton) {
        customerselectionmode = CustomerSelectionMode.single
        self.setViewAsperCustomerSelectionMode()
    }
    
    
    @IBAction func btnSearchCustomerclicked(_ sender: UIButton) {
        
        if( CustomerDetails.getAllCustomers().count > 0 &&  noOfTotalCustomer < noOFCustomer){
            
           
                
                
                if( noOfTotalCustomer < noOFCustomer){
                    SVProgressHUD.show()
                    //CustomerDetails.getAllCustomers()
                    popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                    popup?.strTitle = ""
                    popup?.arrOfSelectedSingleCustomer = arrOfSelectedSingleCustomer
                    popup?.modalPresentationStyle = .overCurrentContext
                    popup?.nonmandatorydelegate = self
                    popup?.isFromSalesOrder =  false
                    popup?.arrOfList = arrOfCustomers
                    popup?.selectionmode = SelectionMode.none
                    popup?.isFilterRequire = false
                    popup?.strLeftTitle = "REFRESH"
                    popup?.isSearchBarRequire = true
                    popup?.viewfor = ViewFor.customer
                    popup?.parentViewOfPopup = self.view
                    Utils.addShadow(view: self.view)
                    if( CustomerDetails.getAllCustomers().count > 0 &&  noOfTotalCustomer < noOFCustomer){
                        self.present(popup!, animated: true, completion:nil)
                    }
                    SVProgressHUD.dismiss()
                }else{
                    // SVProgressHUD.dismiss()
                    //   Utils.toastmsg(message:"No Customer Please Create new",view: self.view)
                }
            }
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if(customerselectionmode == CustomerSelectionMode.single){
            if(tfCustomerName.text?.count == 0){
                Utils.toastmsg(message: "Please select customer", view: self.view)
            }else{
                self.addparticipant()
            }
        }else if(customerselectionmode == CustomerSelectionMode.multiple){
            if(tfCustomerName.text?.count == 0){
                Utils.toastmsg(message: "Please add customer name", view: self.view)
            }else if(tfCustomerContact.text?.count == 0){
                Utils.toastmsg(message: "Please add customer contact", view: self.view)
            }else{
                self.addparticipant()
            }
        }
    }
    
    func addparticipant(){
//        var participant = [String:Any]()
//        participant["CreatedBy"] = self.activeuser?.userID
//        self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//        participant["CreatedTime"] = self.dateFormatter.string(from: Date())
//        participant["CustomerID"] =  selectedcustomerId
//        participant["CustomerMobile"] = tfCustomerContact.text
//        participant["CustomerName"] =  tfCustomerName.text
//        participant["UserID"] = self.activeuser?.userID
//        participant["ActivityID"] = selectedActivityId
   
        
//        let filteredArray = AddParticipant.arrOfParticipant.filter { foo in
//            if AddParticipant.arrOfParticipant.contains(participant) {
//                // We already had a `Foo` with this `bar` value: skip.
//                return false
//            } else {
//                // First `Foo` with this `bar` value: remember and include.
//                AddParticipant.arrOfParticipant.append(participant)
//                return true
//            }
//        }
       
       
        let custname = self.tfCustomerName.text ?? ""
        let custno = self.tfCustomerContact.text ?? ""
        var custid = Int64(0)
        if let selectedcustomer = self.selectedCustomer as? CustomerDetails{
            custid = self.selectedCustomer?.iD ?? Int64(0)
        }else{
            if(custid == 0){
                custid =  self.selectedTempCustomer?.iD ?? Int64(0)
                
            }
        }
        var actparticipant:participant?
        if(self.customerselectionmode == CustomerSelectionMode.single){
            actparticipant =  participant(name: custname, cid: custid , contactno: custno)
        }else{
            actparticipant =  participant(name: custname, cid: custid , contactno: custno)
        }
        if let activityparticipant = actparticipant as? participant{
            if AddParticipant.arrOfParticipant.contains(activityparticipant) {
               
            }else{
                AddParticipant.arrOfParticipant.append(activityparticipant)
            }
        }
        self.navigationController?.popViewController(animated: true)
      //  participant["CustomerID"] =
    }
    
    func setViewAsperCustomerSelectionMode(){
        if let   originalAssignee = activeuser?.userID{
            self.originalAssignee = originalAssignee
        }
       // lblCustomerName.setMultilineLabel(lbl: lblCustomerName)
        if(customerselectionmode == CustomerSelectionMode.single){
            //New customer
            btnNewCustomer.isSelected = true
            btnExistingCustomer.isSelected = false
            btnSearchCustomer.isHidden = true
            tfCustomerContact.keyboardType = .numberPad
            tfCustomerContact.isUserInteractionEnabled = true
            tfCustomerContact.text = ""
            tfCustomerName.text = ""
         /*   tfAssignTo.isUserInteractionEnabled = true
            lblCustomerDetail.text = "Customer Name"
            lblCustomerName.layoutIfNeeded()
            //          searchCustomer.layoutIfNeeded()
            tfSelectCustomer.layoutIfNeeded()
            btnSingle.isSelected = true
            btnMultiple.isSelected = false
            tfSelectCustomer.isHidden = false
            vwCustAddress.isHidden = false
            lblCustomerAddressTitle.isHidden = false
            tvCustomerAddress.isHidden = false
            
            lblCustomerName.isHidden =  true
            
            if(self.activesetting.requiProductInAddVisit == NSNumber.init(value: 1)){
                lblProductInterestedIn.isHidden = false
                vwAddProduct.isHidden = false
                tblProduct.isHidden = false
            }else{
                lblProductInterestedIn.isHidden = true
                vwAddProduct.isHidden = true
                tblProduct.isHidden = true
                
            }
            
            if(self.activesetting.RequiContactPersonInAddVisit == NSNumber.init(value: 1)){
                
                vwContact.isHidden = false
            }else{
                
                vwContact.isHidden = true
            }
            
            if(self.activesetting.requiInteractionTypeInAddVisit == NSNumber.init(value: 1)){
                vwInteraction.isHidden  = false
            }else{
                vwInteraction.isHidden  = true
            }
            
            
            
            
            if(self.activesetting.requireAddNewCustomerInVisitLeadOrder == NSNumber.init(value: 1)){
                btnAddCustomer.isHidden = false
            }else{
                btnAddCustomer.isHidden = true
            }
            
            
            
            
            
            
            //Set Data
            if(customerselectionmode == CustomerSelectionMode.single && self.arrOfSelectedSingleCustomer.count > 0){
                
                if(selectedCustomer?.name.count ?? 0 > 0){
                    if let selectedcustomer = self.selectedCustomer{
                        //           searchCustomer.text =   selectedcustomer.name ?? ""
                        tfSelectCustomer.text =   selectedcustomer.name ?? ""
                    }
                    
                }else{
                    //           searchCustomer.text =  ""
                    tfSelectCustomer.text =  ""
                    
                }
                
            }else{
                //     searchCustomer.text =  ""
                tfSelectCustomer.text =  ""
                
            }*/
        }else{
            btnNewCustomer.isSelected = false
            btnExistingCustomer.isSelected = true
            btnSearchCustomer.isHidden = false
            tfCustomerContact.isUserInteractionEnabled = false
            tfCustomerName.delegate = self
            /*  tfSelectCustomer.resignFirstResponder()
            tfAssignTo.isUserInteractionEnabled = false
            lblCustomerName.layoutIfNeeded()
            lblCustomerName.setMultilineLabel(lbl: lblCustomerName)
            tfSelectCustomer.layoutIfNeeded()
            lblCustomerName.isHidden =  false
            
            btnSingle.isSelected = false
            self.tblProduct.isHidden = true
            
            tfSelectCustomer.isHidden = true
            btnMultiple.isSelected = true
            
            lblCustomerAddressTitle.isHidden = true
            vwCustAddress.isHidden = true
            btnAddCustomer.isHidden = true
            
            lblProductInterestedIn.isHidden = true
            
            btndrtFromLead.isHidden = true
            
            tvCustomerAddress.isHidden = true
            vwAddProduct.isHidden = true
            vwContact.isHidden = true
            vwLeadSelection.isHidden = true
            
            
            
            if(self.activesetting.requiInteractionTypeInAddVisit == NSNumber.init(value: 1)){
                vwInteraction.isHidden  = false
            }else{
                vwInteraction.isHidden  = true
            }
            //Set Data
            lblCustomerName.text = "Select Customers"
            self.tblProductListHeight.constant = 0
            */
        }
        
    }
    
    
    func getTaagedCustomer(pageno:Int,trimmedstring:String){
        
        var param = Common.returndefaultparameter()
        param["Filter"] = trimmedstring
        param["PageNo"] = pageno
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
                        Utils().getTaagedCustomer(pageno: pageno + 1 ,trimmedstring: trimmedstring , savepermenent: false){
                            (arr,message) in 
                        }
                        
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
extension AddParticipant:PopUpDelegateNonMandatory{
    
   
    
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr.count)
        
        //        arrOfSelectedCustomer = arr
       
  
            arrOfSelectedSingleCustomer = arr
        selectedCustomer  =  arr.first as? CustomerDetails  ?? CustomerDetails()
          //  self.changeAssigneeAsperCustomerSelection()
            if let selectedcustomer = selectedCustomer as? CustomerDetails{
              
                tfCustomerName.text = selectedcustomer.name
                tfCustomerContact.text = selectedcustomer.mobileNo
            
          //  self.setAddress()
            if let customerfromDb =  CustomerDetails.getCustomerByID(cid: NSNumber.init(value: selectedcustomer.iD ?? 0) ?? NSNumber.init(value: 0)){
                
            }else{
//                Utils().getCustomerDetail(cid:NSNumber.init(value: selectedCustomer?.iD ?? 0)) {
//                    (status) in
//                }
            }
            }
       
    }
    
    
    
    
}
extension AddParticipant:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == tfCustomerName){
           
                return true
            
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
         
        arrOfFilteredLowerLeverUser = BaseViewController.staticlowerUser
        let trimmedstring = textField.text?.trimmingCharacters(in: .whitespaces).lowercased()
        print("count =  \(trimmedstring?.count) nd string = \(trimmedstring)")
        if (textField == tfCustomerName && customerselectionmode == CustomerSelectionMode.multiple){
            
            var fullstring = ""
            if let tft = textField.text as? String{
                fullstring.append(tft)
            }
            fullstring.append(string)
          
            let trimmedstring = fullstring.trimmingCharacters(in: .whitespaces).lowercased()
         
            print("count =  \(trimmedstring.count) nd string = \(trimmedstring)")
           
                
                arrOfCustomers = CustomerDetails.getAllCustomers()
                let arrOfTempCustomers = TempcustomerDetails.getAllCustomers()
                print("No of customer = \(noOFCustomer) && all cust count = \(arrOfCustomers.count)co")
                if(string.count == 0 && trimmedstring.count != 4 ){
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
            return true
        }else if(textField == tfCustomerContact){
            let maxLength = 16
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if(textField == tfCustomerName){
            return true
        }else{
            return true
        }
       
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
      
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
