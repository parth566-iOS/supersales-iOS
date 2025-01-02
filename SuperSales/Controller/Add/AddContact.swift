//
//  AddContact.swift
//  SuperSales
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import DropDown
import FastEasyMapping

protocol AddContactDelegate {
    func saveContact(customerID:NSNumber,customerName:String,contactName:String,contactID:NSNumber)
}

class AddContact: BaseViewController {
    //MARK: - variable
    var saveContDelegate:AddContactDelegate?
    var isEditContact:Bool!
    var isVendor:Bool!
    var conimg:UIImage = UIImage()
    var selectedContact:Contact!
    var addcontactdel:AddContactDelegate?
    var dropDownContLevel:DropDown!
    var popup:CustomerSelection? = nil
    var arrOfSelectedSingleCustomer = [CustomerDetails]()
    var arrOfCustomers = [CustomerDetails]()
    
    //MARK: - IBOutlet
    @IBOutlet weak var tfCutomerName: CustomeTextfield!
    
    @IBOutlet weak var tfContactName: CustomeTextfield!
    
    
    @IBOutlet weak var tfContactLastName: CustomeTextfield!
    
    @IBOutlet weak var tfContactMobieNo: CustomeTextfield!
    
    @IBOutlet weak var tfContactEmailid: CustomeTextfield!
    
    @IBOutlet weak var tfContactKeyRole: CustomeTextfield!
   
    @IBOutlet weak var tfContactDesignation: CustomeTextfield!
    
    @IBOutlet weak var tfContactFavourable: CustomeTextfield!
    
    
    @IBOutlet weak var tvContactDesc: UITextView!
    
    
    @IBOutlet weak var tvDescHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnAddCustomer: ButtonWithImage!
    
    @IBOutlet weak var lblContactFavourable: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    //MARK: - Variable
    var selectedCust:CustomerDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
   
    //MARK: - Method
    func checkValidation()-> Bool{
        
        if(tfContactName.text?.count == 0){
            tfContactName.becomeFirstResponder()
            Utils.toastmsg(message:"Please enter Contact Name",view: self.view)
            return false
        }else if(tfContactMobieNo.text?.count == 0){
            tfContactMobieNo.becomeFirstResponder()
            Utils.toastmsg(message:"Please enter Contact Number",view: self.view)
            return false
        }else if(tfContactMobieNo.text?.count ?? 0 < 6){
            tfContactMobieNo.becomeFirstResponder()
            Utils.toastmsg(message:"Please enter valid mobile no",view: self.view)
            return false
        }else if(tfContactMobieNo.text?.count ?? 0 > 0 && (tfContactName.text?.count ?? 0 == 0)){
            tfContactName.becomeFirstResponder()
            Utils.toastmsg(message:"Enter Contact Name",view: self.view)
            return false
        }
        else if(tfContactName.text?.count ?? 0 > 0 && (tfContactMobieNo.text?.count ?? 0 == 0)){
            tfContactMobieNo.becomeFirstResponder()
            Utils.toastmsg(message:"Enter Contact Number",view: self.view)
            return false
        }else if let selectedcustomer = selectedCust as? CustomerDetails{
            return true
          
        }else {
            tfCutomerName.becomeFirstResponder()
            Utils.toastmsg(message:"Please Select Customer",view: self.view)
            return false
        }
    }
    
    func setUI(){
        self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        self.btnAddCustomer.backgroundColor = UIColor.Appskybluecolor
        self.lblContactFavourable.backgroundColor = UIColor.Appskybluecolor
        
        
        
        self.tfCutomerName.textCustompadding = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        self.tfContactDesignation.textCustompadding = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.tfContactKeyRole.textCustompadding = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.tfContactFavourable.textCustompadding = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        
        
        self.tfContactName.setAttributedPlaceHolder(color: UIColor.systemGray, text: "First Name")
        self.tfContactLastName.setAttributedPlaceHolder(color: UIColor.systemGray, text: "Last Name")
        self.tfContactMobieNo.setAttributedPlaceHolder(color: UIColor.systemGray, text: "Contact Number")
        self.tfContactEmailid.setAttributedPlaceHolder(color: UIColor.systemGray, text: "Email-id")
        self.tfContactDesignation.setAttributedPlaceHolder(color: UIColor.systemGray, text: "Designation")
        self.tfContactKeyRole.setAttributedPlaceHolder(color: UIColor.systemGray, text: "Key Role")
        
        
        
        arrOfCustomers = CustomerDetails.getAllCustomers()
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        
        tfContactMobieNo.keyboardType = UIKeyboardType.numberPad
        tfCutomerName.delegate = self
        tfContactEmailid.delegate = self
        tfContactDesignation.delegate = self
        tfContactKeyRole.delegate = self
        tfContactMobieNo.delegate = self
        tfContactKeyRole.delegate = self
        tfContactName.delegate = self
        tfContactFavourable.delegate = self
        tfContactLastName.delegate = self
        tvContactDesc.setFlexibleHeight()
        
        
       // CustomeTextfield.setBottomBorder(tf: tfCutomerName)
       
        tfContactFavourable.setrightImage(img: (UIImage.init(named: "icon_down_arrow_gray") ?? UIImage.init()))
     
        tfCutomerName.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray") ?? UIImage.init())
     
        tfContactName.setleftImage(img: UIImage.init(named: "icon_user_blue") ?? UIImage.init())
        tfContactMobieNo.setleftImage(img: UIImage.init(named: "icon_addContact_blue") ?? UIImage.init())
        tfContactEmailid.setleftImage(img: UIImage.init(named: "icon_mail_blue") ?? UIImage.init())
       
        self.tfContactEmailid.addBorders(edges: [.bottom], color: UIColor.gray, cornerradius: 0)
        self.tfContactDesignation.addBorders(edges: [.bottom], color: UIColor.gray, cornerradius: 0)
        self.tfContactKeyRole.addBorders(edges: [.bottom], color: UIColor.gray, cornerradius: 0)
        self.tfContactName.addBorders(edges: [.bottom], color: UIColor.gray, cornerradius: 0)
        self.tfContactMobieNo.addBorders(edges: [.bottom], color: UIColor.gray, cornerradius: 0)
        self.tfContactLastName.addBorders(edges: [.bottom], color: UIColor.gray, cornerradius: 0)
       
    //    CustomeTextfield.setBottomBorder(tf: tfContactEmailid)
        CustomeTextfield.setBottomBorder(tf: tfContactDesignation)
        CustomeTextfield.setBottomBorder(tf: tfContactKeyRole)
        CustomeTextfield.setBottomBorder(tf: tfContactName)
        CustomeTextfield.setBottomBorder(tf: tfContactMobieNo)
        CustomeTextfield.setBottomBorder(tf: tfContactLastName)
        //tvContactDesc.setBottomBorder(tv: tvContactDesc)
       
        
        tfContactFavourable.inputView =  dropDownContLevel
        
        dropDownContLevel =  DropDown.init()
        dropDownContLevel.anchorView =  tfContactFavourable
        dropDownContLevel.dataSource =  Utils.getAllCustomerOrientation()
        dropDownContLevel.selectionAction =  {(index,item) in
            
        self.tfContactFavourable.text = item
           
        }
        if(self.isEditContact){
            self.title = "Edit Contact"
            if let selectedcustomer = selectedCust as? CustomerDetails{
            tfCutomerName.text = selectedcustomer.name
            tfCutomerName.isUserInteractionEnabled = false
            }else{
                tfCutomerName.text = "Select Customer"
                tfCutomerName.isUserInteractionEnabled = true
            }
            tfContactEmailid.text = selectedContact.emailID
            tfContactName.text = selectedContact.firstName
            tfContactLastName.text = selectedContact.lastName
            
            tfContactFavourable.text = dropDownContLevel.dataSource[Int(selectedContact.favourableID)]
            tfContactDesignation.text = selectedContact.designation
            tfContactMobieNo.text = selectedContact.mobile
            tfContactKeyRole.text = selectedContact.keyRole
            tvContactDesc.text = selectedContact.desc
            
        }else{
            self.title = "Add Contact"
            self.tfContactFavourable.text = self.dropDownContLevel.dataSource.first
        }
        if let selectedcustomer = selectedCust as? CustomerDetails{
        tfCutomerName.text = selectedcustomer.name
        tfCutomerName.isUserInteractionEnabled = false
        }else{
            tfCutomerName.text = "Select Customer"
            tfCutomerName.isUserInteractionEnabled = true
        }
        //         self.setrightbtn(btnType: BtnRight.detail, navigationItem: self.navigationItem)
    }
    
    //MARK: - IBAction
    
    @IBAction func btnAddCustomerClicked(_ sender: UIButton) {
        if  let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
            addCustomer.isVendor = false
            AddCustomer.isFromInfluencer = 0
            addCustomer.isForAddAddress = false
            addCustomer.isFromColdCallVisit = false
            addCustomer.isEditCustomer = false
            addCustomer.saveCustDelegate = self
        self.navigationController?.pushViewController(addCustomer, animated: true)
        }
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if(self.checkValidation()){
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            var strurl = ""
            var param = Common.returndefaultparameter()
            var contactDic = [String:Any]()
            if(self.isEditContact){
                strurl = ConstantURL.kWSUrlEditContact
                contactDic["ID"] = selectedContact.iD
            }else{
                strurl = ConstantURL.kWSUrlAddContact
            }
          
            contactDic["FirstName"] =  tfContactName.text
            contactDic["LastName"] =  tfContactLastName.text
            contactDic["Description"] = tvContactDesc.text
            contactDic["Designation"] =  tfContactDesignation.text
            contactDic["CompanyID"] = self.activeuser?.company?.iD
            contactDic["EmailID"] = tfContactEmailid.text
            contactDic["FavourableID"] = NSNumber.init(value: 0)
            contactDic["KeyRole"] = tfContactKeyRole.text
            
            contactDic["Mobile"] = tfContactMobieNo.text
            if(isVendor){
                contactDic["CustomerID"] = NSNumber.init(value: 0)
            }else{
                contactDic["CustomerID"] = self.selectedCust?.iD
            }
            contactDic["CreatedBy"] = self.activeuser?.userID
            param["ContactDetails"] = Common.json(from: contactDic)
            self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: strurl, img: conimg, imgparamname: "File", param: param) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    var dicResponse =  arr as? [String:Any]
                    if(self.isVendor){
                        dicResponse?["CustomerVendor.Type"] = "V"
                    }else{
                        dicResponse?["CustomerVendor.Type"] = "U"
                    }
                  
                    let contactID = dicResponse?["ID"] as? Int
                    let nsnumContactID = NSNumber.init(value: contactID ?? 0)
                    MagicalRecord.save { (localcontext) in
                       // FEMDeserializer.collection(fromRepresentation: [dicResponse], mapping: Contact.defaultMapping())
                        
                      
                        FEMDeserializer.object(fromRepresentation: dicResponse ?? [String:Any](), mapping: Contact.defaultMapping(), context: localcontext)
                        localcontext.mr_save { (localcontext) in
                            print("saving")
                        } completion: { (status, error) in
                                print("saved")
                            print(error?.localizedDescription ?? "no error")
                            if let lastContact =  Contact.mr_findAll()?.last as? Contact{
                              
                                self.saveContDelegate?.saveContact(customerID: nsnumContactID, customerName: self.tfCutomerName.text  ?? "", contactName: String.init(format: "\(lastContact.firstName) \(lastContact.lastName)"), contactID: NSNumber.init(value:lastContact.iD))
                            }
          
                        }
//                        localcontext.mr_saveToPersistentStore { (status, error
//                        ) in
//                            print(error?.localizedDescription)
//                            print("after saving persistant")
//                            if let lastContact =  Contact.mr_findAll()?.last as? Contact{
//                                print(lastContact.firstName)
//                                print(lastContact.lastName)
//                                print(lastContact.iD)
//                            }
//                        }

                    } completion: { (status , error) in
                        
                        print(error ?? "no error")
                      
                        if let lastContact =  Contact.mr_findAll()?.last as? Contact{
                            
                            print(lastContact.iD)
                        }
                        let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
                            self.addcontactdel?.saveContact(customerID: NSNumber.init(value: self.selectedCust?.iD ?? 0), customerName: self.selectedCust?.name ?? "", contactName: String.init(format: "%@ %@", self.tfContactName.text!,self.tfContactLastName.text!), contactID: nsnumContactID)
                        
                            self.navigationController?.popViewController(animated: true)
                          
                        }
//                        let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
//                            self.addcontactdel?.saveContact(customerID: NSNumber.init(value: selectedCust.iD), customerName: selectedCust.name, contactName: String.init(format: "%@ %@", dicResponse?["FirstName"] as! CVarArg,dicResponse["LastName"])  , contactID: NSNumber.init(value: dicResponse["ID"]))
//                        }
                        Common.showalertWithAction(msg: message, arrAction: [okAction], view: self)
                    }

                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
//                    self.navigationController?.popViewController(animated: true)
                   
                }else{
                    Utils.toastmsg(message:message.debugDescription,view: self.view)
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
extension AddContact:UITextFieldDelegate{
   // let padding = UIEdgeInsets(top: 0, left:  10 , bottom: 0, right: 5)
    
//    func leftViewRect(forbounds bounds:CGRect)->CGRect{
//           var ract = self.leftViewRect(forbounds: bounds)//self.leftViewRect(leftViewRect(forbounds: bounds))
//           let padding:CGFloat = 5
//           ract.origin.x += padding
//           return ract
//        }
//           
//        func textRect(forBounds bounds: CGRect) -> CGRect {
//               var ract = self.textRect(forBounds: bounds)
//               let padding:CGFloat = 5
////            if self.leftView != nil{
////                   ract.origin.x += padding
////               }else{
////                   ract.origin.x = padding
////               }
////
////               ract.size.width   -=  2 * padding
////            if self.rightView != nil{
////                   ract.size.width -= 5
////               }
//            if let leftview
//               return ract
//                     }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField == tfContactFavourable){
            dropDownContLevel.show()
            return false
        }else if(textField == tfCutomerName){
           // if let selectedcustomer = selectedCust as? CustomerDetails{
                popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                popup?.strTitle = ""
                popup?.isFromSalesOrder =  false
                popup?.arrOfSelectedSingleCustomer = arrOfSelectedSingleCustomer
                popup?.modalPresentationStyle = .overCurrentContext
                popup?.nonmandatorydelegate = self
                popup?.arrOfList = arrOfCustomers
                popup?.selectionmode = SelectionMode.none
                popup?.isFilterRequire = false
                popup?.strLeftTitle = "REFRESH"
                popup?.isSearchBarRequire = true
                popup?.viewfor = ViewFor.customer
                popup?.parentViewOfPopup = self.view
                Utils.addShadow(view: self.view)
            self.present(popup!, animated: true, completion: nil)
          //  }
           return false
        }else{
        return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if(textField == tfContactMobieNo){
        let maxLength = 15
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }else{
            return true
        }
    }
    
}
extension AddContact:PopUpDelegateNonMandatory{
    
   
    
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr.count)
     
//        arrOfSelectedCustomer = arr
        if (popup?.selectionmode == SelectionMode.multiple) {
           
            
        }else{
            arrOfSelectedSingleCustomer = arr
            selectedCust =  arr.first!
        
            if let selectedcustomer = selectedCust {
                tfCutomerName.text = selectedcustomer.name

            }
           
            
        }
    }
    
   
   
    
}
extension AddContact:AddCustomerDelegate{
    func saveCustomer(customerID: NSNumber, customerName: String, contactID: NSNumber) {
        if let selectedCustomer = CustomerDetails.getCustomerByID(cid: customerID){
        self.selectedCust = selectedCustomer
        }
    }
    
    
}
