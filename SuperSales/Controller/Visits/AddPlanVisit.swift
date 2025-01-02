//
//  AddPlanVisit.swift
//  SuperSales
//
//  Created by Apple on 25/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import Foundation
import SVProgressHUD
import FirebaseCrashlytics
import FastEasyMapping
import MagicalRecord


class AddPlanVisit: BaseViewController {
    // swiftlint:disable file_length
    // swiftlint:disable line_length
    // swiftlint:disable type_body_length
    
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var stackCustomerSelectionMode: UIStackView!
    
    @IBOutlet weak var stkAssignUser: UIStackView!
    
    @IBOutlet weak var stkCustomerDetail: UIStackView!
    @IBOutlet weak var searchHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var vwContactPerson: UIView!
    @IBOutlet weak var vwCustAddress: UIView!
    
    var arrAllCustomer:[NSString] = [NSString]()
    var filteredCustomer:[NSString] = [NSString]()
    var assignUserDropdown:DropDown! = DropDown()
    var customerDropdown:DropDown! = DropDown()
    var contactDropdown:DropDown! = DropDown()
    var addressDropdown:DropDown! = DropDown()
    var objVisit:PlannVisit?
    var isEdit:Bool = false
    var customerName  = ""
    var arrOfSelectedSingleCustomer = [CustomerDetails]()
    var arrOfSelectedMultipleCustomer = [CustomerDetails]()
    var selectedCustomer:CustomerDetails?
    var arrOffilteredCustomer = [CustomerDetails]()
    var arrOffilteredTempCustomer  = [TempcustomerDetails]()
    var selectedTempCustomer:TempcustomerDetails?
    var arrLowerLevelUser = [CompanyUsers]()
    var arrOfCustomers = [CustomerDetails]()
    var arrOfTempAddress = [AddressList]()
    var arrOfContact = [Contact]()
    var arrOfStrContactName = [String]()
    var arrOfLowerLevelUser:[CompanyUsers] = [CompanyUsers]()
    var arrOfFilteredLowerLeverUser:[CompanyUsers] = [CompanyUsers]()
    var arrOfLowerLevelUserName:[NSString] = [NSString]()
    var arrOfFilteredLowerLevelUserName:[NSString] = [NSString]()
    var arrStrAddress = [String]()
    var arrAddressID = [Int64]()
    // var arrOfProductEdit:[ProductsList]! = [ProductsList]()
    var arrOfProduct:[SelectedProduct]! = [SelectedProduct]()
    var arrOFselectedLead:[Lead]! = [Lead]()
    var strNextActionTime = ""
    
    var popup:CustomerSelection? = nil
    var searchedtext = ""
    
    var customerselectionmode = CustomerSelectionMode.single
    
    var selectedInteraction = InteractionType.metting
    let noOFCustomer = Utils.getDefaultIntValue(key: Constant.kNoOfCustomer)
    let noOfTotalCustomer = Utils.getDefaultIntValue(key:  Constant.kTotalCustomer)
   
    @IBOutlet weak var btndrtFromLead: UIButton!
    @IBOutlet weak var btnSearchAssignee: UIButton!
    
    @IBOutlet weak var lblCustomerAddressTitle: UILabel!
    
    @IBOutlet weak var lblContactpersonTitle: UILabel!
    
    @IBOutlet weak var lblCustomerDetail: UILabel!
    
    
    @IBOutlet weak var lblProductInterestedIn: UILabel!
    
    @IBOutlet weak var lblInteractionTypeTitle: UILabel!
    
    @IBOutlet weak var lblDescTitle: UILabel!
    @IBOutlet weak var tfSelectLead: CustomeTextfield!
    @IBOutlet weak var lblAssignToTitle: UILabel!
    
    @IBOutlet weak var btnMultiple: UIButton!
    @IBOutlet weak var btnSingle: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet weak var btnAddCustomer: UIButton!
    
    
    @IBOutlet weak var btnAddContact: UIButton!
    //constant heights
    
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var tfSelectCustomer: UITextField!
    
    // @IBOutlet weak var searchCustomer: UISearchBar!
    
    
    @IBOutlet weak var btnSearchCustomer: UIButton!
    
    //    @IBOutlet weak var searchCustomer: UISearchBar!
    @IBOutlet weak var tvCustomerAddress: UITextView!
    
    @IBOutlet weak var searchAssignUser: UISearchBar!
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var tfContactPerson: UITextField!
    
    
    @IBOutlet weak var vwAddProduct: UIView!
    @IBOutlet weak var btnAddProduct: UIButton!
    
    @IBOutlet weak var tblProduct: UITableView!
    
    //btn of interaction type
    
    
    @IBOutlet weak var btnInteractionMeeting: UIButton!
    
    @IBOutlet weak var btnInteractionCall: UIButton!
    
    
    @IBOutlet weak var btnInteractionMail: UIButton!
    
    
    @IBOutlet weak var btnInteractionMessage: UIButton!
    
    @IBOutlet weak var vwInteraction: UIView!
    
    @IBOutlet weak var tfDate: UITextField!
    
    @IBOutlet weak var tfTime: UITextField!
    
    @IBOutlet weak var tfAssignTo: UITextField!
    
    @IBOutlet weak var tblProductListHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwLeadSelection: UIView!
    
    
    @IBOutlet weak var vwInteractionType: UIView!
    
    @IBOutlet weak var vwContact: UIView!
    
    @IBOutlet weak var vwVisitDirectFromLead: UIView!
    var arrSelectedProduct:[SelectedProduct] = [SelectedProduct]()
    var arrSelectedProductDic:[[String:Any]] = [[String:Any]]()
    //    var alignment = Alignment.left
    var contactID:NSNumber = 0
    var addressMasterID:NSNumber = 0
    var nextActionID:NSNumber = 0
    var originalAssignee:NSNumber = 0
    var selectedcustomerIndexes:[IndexPath]?
    var datepicker:UIDatePicker!
    
    var tableViewHeight: CGFloat {
        tblProduct.layoutIfNeeded()
        return tblProduct.contentSize.height
    }
    
    var isProduct:Bool =  false
    var isService:Bool =  false
    
    
    var noOfCustomer = 0
    // MARK: - Implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.activesetting.requiDirectVisitFromLeadInAddVisit == NSNumber.init(value: 1)){
            vwVisitDirectFromLead.isHidden = false
            if(isEdit){
                btndrtFromLead.isUserInteractionEnabled =  false
            }
        }else{
            vwVisitDirectFromLead.isHidden = true
        }
        self.title = "Add Visit"
        // Do any additional setup after loading the view.
        //        Crashlytics.sharedInstance().crash()
        // fatalError("rfbejbh")
        self.setUI()
        
        if(BaseViewController.staticlowerUser?.count ?? 0 > 0){
            arrLowerLevelUser = BaseViewController.staticlowerUser!
        }
        //        NotificationCenter.default.addObserver(self,
        //                                               selector: #selector(AddPlanVisit.handleTextChange(_:)),
        //                                               name: NSNotification.Name.init("handleTextChange"), object: nil)
        
        //   view.addSubview(button)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(forName: Notification.Name("updateContactDetail"), object: nil, queue: OperationQueue.main) { (notify) in
            
            self.updateContactUI()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateContactDetail"), object: nil)
    }
    
    
    override func viewDidAppear(_ animate:Bool){
        super.viewDidAppear(true)
        Common.skipVisitSelection = true
        self.setUIAsperSetting()
    }
    
    // MARK: Method
    func setUIAsperSetting(){
        if(self.activesetting.requiInteractionTypeInAddVisit == NSNumber.init(value: 1)){
            vwInteractionType.isHidden = false
        }else{
            vwInteractionType.isHidden = true
        }
        if(self.activesetting.RequiContactPersonInAddVisit == NSNumber.init(value: 1)){
            vwContact.isHidden = false
        }else{
            vwContact.isHidden = true
        }
        
        if(self.activesetting.requiProductInAddVisit == NSNumber.init(value: 1)){
            lblProductInterestedIn.isHidden = false
            vwAddProduct.isHidden  =  false
            tblProduct.isHidden = false
        }else{
            lblProductInterestedIn.isHidden = true
            vwAddProduct.isHidden  =  true
            tblProduct.isHidden = true
        }
        if(btndrtFromLead.isSelected){
            vwLeadSelection.isHidden = false
        }else{
            vwLeadSelection.isHidden = true
        }
    }
    //    override func viewWillLayoutSubviews(){
    //        super.viewWillLayoutSubviews()
    //        if(customerselectionmode == CustomerSelectionMode.single){
    //            searchHeightConstant.isActive = true
    //            searchCustomer.layoutIfNeeded()
    //        }else{
    //            searchHeightConstant.isActive = false
    //            searchCustomer.layoutIfNeeded()
    //        }
    //    }
    
    
    func setUI(){
        
        self.btnSingle.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.btnMultiple.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        self.btnAddProduct.contentHorizontalAlignment = .left
        self.btnAddProduct.setrightImage()
        self.salesPlandelegateObject = self
        DispatchQueue.global(qos: .background).async {
            self.fetchuser{
                (arrOfuser,error) in
            }
        }
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        
        tfContactPerson.setImageRight(image: UIImage.init(named: "icon_search_black")!)
        
        
        //add gesture to customer name
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(lblcustomernameTapped))
        lblCustomerName.isUserInteractionEnabled = true
        lblCustomerName.addGestureRecognizer(gesture)
        
        //hide lead selection section
        // vwLeadSelection.isHidden = true
        // tfSelectCustomer.isHidden = true
        // tfAssignTo.isHidden = true
        //set corner radius
        
        lblContactpersonTitle.layer.masksToBounds = true
        lblCustomerDetail.layer.masksToBounds = true
        lblCustomerAddressTitle.layer.masksToBounds = true
        lblDescTitle.layer.masksToBounds = true
        lblAssignToTitle.layer.masksToBounds = true
        lblProductInterestedIn.layer.masksToBounds = true
        lblInteractionTypeTitle.layer.masksToBounds = true
        lblCustomerDetail.layer.cornerRadius = 5
        lblCustomerAddressTitle.layer.cornerRadius = 5
        lblContactpersonTitle.layer.cornerRadius = 5
        lblDescTitle.layer.cornerRadius = 5
        lblAssignToTitle.layer.cornerRadius = 5
        lblProductInterestedIn.layer.cornerRadius = 5
        lblInteractionTypeTitle.layer.cornerRadius = 5
        
        //set bottome border
        
        //    CustomeTextfield.setBottomBorder(tf: tfSelectCustomer)
        //    CustomeTextfield.setBottomBorder(tf: tfContactPerson)
        //    CustomeTextfield.setBottomBorder(tf:tfDate)
        //    CustomeTextfield.setBottomBorder(tf:tfTime)
        // CustomeTextfield.setBottomBorder(tf:tfAssignTo)
        
        
        datepicker = UIDatePicker()
        datepicker.setCommonFeature()
        datepicker.date = Date()
        datepicker.minimumDate = Date().addingTimeInterval(180)
        
        tfTime.inputView =  datepicker
        tfDate.inputView = datepicker
        tfDate.delegate = self
        tfTime.delegate = self
        tfContactPerson.delegate = self
        tvCustomerAddress.delegate = self
        tfSelectCustomer.delegate = self
        tfAssignTo.delegate = self
        
        //   searchCustomer.delegate = self
        searchAssignUser.delegate = self
        tfSelectLead.delegate = self
        
        
        tfDate.setCommonFeature()
        tfTime.setCommonFeature()
        tfContactPerson.setCommonFeature()
        
        tfSelectCustomer.setCommonFeature()
        tfAssignTo.setCommonFeature()
        
        tfSelectLead.setCommonFeature()
        
        searchAssignUser.isHidden = true
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfDate.text = dateFormatter.string(from: datepicker.date)
        dateFormatter.dateFormat = "hh:mm a"
        tfTime.text = dateFormatter.string(from: datepicker.date)
        
        // tblProductListHeight.constant =  CGFloat(arrSelectedProduct.count * 60)
        
        //set images
        tfSelectLead.setrightImage(img:  UIImage.init(named: "icon_down_arrow_gray") ?? UIImage.init())
        
        //hide cursor
        tfSelectLead.tintColor = UIColor.clear
        //    searchCustomer.backgroundColor = UIColor.white
        searchAssignUser.barTintColor = UIColor.white
        self.setViewAsperCustomerSelectionMode()
        arrOfCustomers = CustomerDetails.getAllCustomers()
        arrAllCustomer = arrOfCustomers.map{ $0.name } as? [NSString] ?? [NSString]()
        
        arrOfLowerLevelUser = BaseViewController.staticlowerUser ?? [CompanyUsers]()
        arrOfLowerLevelUserName = arrOfLowerLevelUser.map{
            String.init(format: "%@ %@", $0.firstName , $0.lastName)
        } as [NSString] as [NSString]
        self.initDropDown()
        
        
        selectedInteraction =  InteractionType.metting
        btnInteractionMeeting.isSelected = true
        tblProduct.delegate = self
        tblProduct.dataSource = self
        tblProduct.rowHeight = UITableView.automaticDimension
        tblProduct.estimatedRowHeight = 102//UITableView.automaticDimension
        
        if(isEdit == true){
            if let user = CompanyUsers().getUser(userId: (NSNumber.init(value:objVisit?.reAssigned ?? 0) ?? self.activeuser?.userID) ?? NSNumber.init(value:0)) as? CompanyUsers{
                searchAssignUser.text = String.init(format:"\(user.firstName) \(user.lastName)")
            }
            tvCustomerAddress.setFlexibleHeight()
            tvDescription.setFlexibleHeight()
            self.title = String.init(format:"%@ %lld",NSLocalizedString("visit_no", comment:""),(objVisit?.seriesPostfix ?? 0) )
            btnAddCustomer.isUserInteractionEnabled = false
            stackCustomerSelectionMode.isHidden = true
            arrOfSelectedSingleCustomer  = [CustomerDetails]()
            if let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value: objVisit?.customerID ?? 0)) as? CustomerDetails{
                selectedCustomer = customer
                self.changeAssigneeAsperCustomerSelection()
                arrOfSelectedSingleCustomer.append(customer)
            }
            //    searchCustomer.isUserInteractionEnabled = false
            tfSelectCustomer.isUserInteractionEnabled = false
            // btnSearchCustomer.isUserInteractionEnabled = false
            
            if(objVisit?.customerName?.count ?? 0 > 0){
                lblCustomerName.text = objVisit?.customerName
                tfSelectCustomer.text = objVisit?.customerName
                //    searchCustomer.text = objVisit?.customerName
                if let straddmasterid = objVisit?.addressMasterID as? Int64{
                    if  let selectedAddress = AddressList().getAddressStringByAddressId(aId: NSNumber.init(value:straddmasterid)){
                        tvCustomerAddress.text = selectedAddress
                        
                        tvCustomerAddress.setFlexibleHeight()
                    }else{
                        tvCustomerAddress.text = ""
                        tvCustomerAddress.setFlexibleHeight()
                    }
                }else{
                    tvCustomerAddress.text = ""
                    tvCustomerAddress.setFlexibleHeight()
                }
                tvCustomerAddress.setFlexibleHeight()
                contactID  = NSNumber.init(value:objVisit?.contactID ?? 0)
                arrOfTempAddress.removeAll()
                arrOfTempAddress = AddressList().getAllAddressUsingCustomerId(cID: NSNumber.init(value: objVisit?.customerID ?? 0))
                addressMasterID = NSNumber.init(value: arrOfTempAddress.first?.addressID ?? 0)
                arrStrAddress =  arrOfTempAddress.map{ String.init(format: "%@ , %@ , %@ - %@ , %@ %@", $0.addressLine1 ?? "" , $0.addressLine2  ?? "",$0.city  ?? "",$0.pincode ?? "0"  , $0.state ?? "" , $0.country  ?? "")}
                arrAddressID = arrOfTempAddress.map{
                    $0.addressID
                }
                addressDropdown.dataSource = arrStrAddress
                tvCustomerAddress.text  = arrStrAddress.first
                
                arrOfContact.removeAll()
                arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: objVisit?.customerID ?? 0))
                arrOfStrContactName =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
                tfContactPerson.text =  arrOfStrContactName.count == 0 ? "No Contacts Exists":"Select Contact"
                
                if  let contact  =  Contact.getContactFromID(contactID: NSNumber.init(value:objVisit?.contactID ?? 0)){
                    tfContactPerson.text = String.init(format: "%@ %@", contact.firstName , contact.lastName)
                }
                contactDropdown.dataSource = arrOfStrContactName
                contactDropdown.reloadAllComponents()
                nextActionID = NSNumber.init(value:objVisit?.nextActionID ?? 1)
                self.selectedInteractionType(tag: Int(objVisit?.nextActionID ?? 1))
                if let strdt = Utils.getDateBigFormatToDefaultFormat(date: objVisit?.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                    let date = Utils.getDateFromStringWithFormat(gmtDateString: strdt)
                    
                    tfDate.text = Utils.getDateWithAppendingDay(day: 0, date: date, format: "dd MMM,yyyy", defaultTimeZone: true)
                    tfTime.text = Utils.getDateWithAppendingDay(day: 0, date: date, format: "hh:mm a", defaultTimeZone: true)
                }else{
                    tfDate.text = ""
                    tfTime.text = ""
                }
                originalAssignee = NSNumber.init(value:objVisit?.originalAssignee ?? 0)
                if let assignuser =   CompanyUsers().getUser(userId: originalAssignee){
                    tfAssignTo.text = String.init(format: "%@ %@", assignuser.firstName,assignuser.lastName)
                }else{
                    tfAssignTo.text = " "
                    //    tfAssignTo.text = String.init(format: "\(self.activeuser?.firstName ?? " ") \(self.activeuser?.lastName ?? " ")")
                }
                tvDescription.text = objVisit?.conclusion
            }else{
                addressMasterID =  NSNumber.init(value: objVisit?.addressMasterID ?? 0)
                contactID = NSNumber.init(value: objVisit?.contactID ?? 0)
            }
            arrOfProduct = [SelectedProduct]()
            //Assign Product
            if(objVisit?.productList.count ?? 0 > 0){
                
                for product in objVisit!.productList{
                    if let prod = product as? ProductsList{
                        let productdic = prod.toDictionary()
                        
                        let product = SelectedProduct().initwithdic(dict: productdic)
                        print("dic is  = \(productdic) and quatntity = \(product.quantity) , budget = \(product.budget) ,  name is = \(product.productName)" )
                        arrOfProduct.append(product)
                        //                    if let tempproduct = ProductsList.getProduct(productID: NSNumber.init(value: prod.productId as? Int ?? 0)) as? ProductsList{
                        //                        let productsubcat = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value: tempproduct.productSubCatId))
                        //                      //  let prodic = ["productName":Product.getProductName(productID: NSNumber.init(value:prod.productId),"ProductID":NSNumber.init(value:prod.productId),"Quantity":prod] as? [String:Any]
                        //   }
                        
                        
                    }
                    
                }
                tblProduct.reloadData()
                self.tblProductListHeight.constant = self.tblProduct.contentSize.height
            }
        }else{
            tfAssignTo.text = String.init(format: "\(self.activeuser?.firstName ?? " ") \(self.activeuser?.lastName ?? " ")")
            self.originalAssignee = self.activeuser?.userID ?? NSNumber.init(value: 0)
            tfSelectCustomer.becomeFirstResponder()
        }
        tvCustomerAddress.setFlexibleHeight()
        if BaseViewController.staticlowerUser.count > 0 {
            self.stkAssignUser.alpha = 1
            self.lblDivider.alpha = 1
            self.lblAssignToTitle.alpha = 1
        }else {
            self.stkAssignUser.alpha = 0
            self.lblDivider.alpha = 0
            self.lblAssignToTitle.alpha = 0
        }
        tblProductListHeight.constant = tableViewHeight
        
    }
    
    func updateContactUI(){
        arrOfContact.removeAll()
        if(isEdit){
            arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: objVisit?.customerID ?? 0))
        }else{
            arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: selectedCustomer?.iD ?? 0))
        }
        arrOfStrContactName =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
        
        tfContactPerson.text =  arrOfStrContactName.count == 0 ? "No Contacts Exists":"Select Contact"
        
        if  let contact  =  Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value:selectedCustomer?.iD ?? 0)).first{
            
            var strContact =  ""
            if let firstname = contact.firstName as? String{
                strContact.append(firstname)
            }
            if let secondname = contact.lastName as? String{
                strContact.append(" \(secondname)")
            }
            if let contact = arrOfContact.first as? Contact{
                contactID = NSNumber.init(value:contact.iD)
            }
            tfContactPerson.text =  strContact
        }
        contactDropdown.dataSource = arrOfStrContactName
        contactDropdown.reloadAllComponents()
    }
    
    func initDropDown(){
        
        
        assignUserDropdown.anchorView = stkAssignUser //searchAssignUser
        assignUserDropdown.bottomOffset = CGPoint.init(x: 0, y: stkAssignUser.bounds.size.height+20)
        
        assignUserDropdown.dataSource = arrOfFilteredLowerLevelUserName as [String]
        assignUserDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfAssignTo.text = item
            let assignee =
                self.arrOfFilteredLowerLeverUser[index]
            self.originalAssignee = assignee.entity_id
        }
        assignUserDropdown.reloadAllComponents()
        customerDropdown.anchorView = stkCustomerDetail
        //        customerDropdown.anchorView = searchCustomer
        customerDropdown.bottomOffset = CGPoint.init(x: 0, y: stkCustomerDetail.bounds.size.height+20)
        // customerDropdown.bottomOffset = CGPoint.init(x: 0, y: searchCustomer.bounds.size.height+20)
        //   CGPointMake(0.0, self.btnAddress.bounds.size.height);
        customerDropdown.dataSource = filteredCustomer as [String]
        customerDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            
            //      self.searchCustomer.text = item
            tfSelectCustomer.text = item
            self.lblCustomerName.text = item
            self.arrOfSelectedSingleCustomer.removeAll()
            self.arrOfSelectedMultipleCustomer.removeAll()
            if(noOFCustomer > noOfTotalCustomer && arrOfCustomers.count > 0){
            
            self.selectedCustomer = self.arrOffilteredCustomer[index]
            self.changeAssigneeAsperCustomerSelection()
            
            self.arrOfSelectedSingleCustomer.removeAll()
            if let selectedcustomer = self.selectedCustomer{
                self.arrOfSelectedSingleCustomer.append(selectedcustomer)
                self.arrOfSelectedMultipleCustomer.append(selectedcustomer)
            }
            self.setAddress()
            }else if(self.arrOffilteredTempCustomer.count > 0){
                
                
                self.selectedTempCustomer = self.arrOffilteredTempCustomer[index]
                 
                self.changeAssigneeAsperTempCustomerSelection()
                
                self.arrOfSelectedSingleCustomer.removeAll()
//                if let selectedcustomer = self.selectedTempCustomer{
//                    self.arrOfSelectedSingleCustomer.append(selectedcustomer)
//                    self.arrOfSelectedMultipleCustomer.append(selectedcustomer)
//                }
                self.setTempAddress()
            }else{
                self.selectedCustomer = self.arrOffilteredCustomer[index]
                self.changeAssigneeAsperCustomerSelection()
                
                self.arrOfSelectedSingleCustomer.removeAll()
                if let selectedcustomer = self.selectedCustomer{
                    self.arrOfSelectedSingleCustomer.append(selectedcustomer)
                    self.arrOfSelectedMultipleCustomer.append(selectedcustomer)
                }
                self.setAddress()
            }
        }
        customerDropdown.reloadAllComponents()
        
        addressDropdown.anchorView = vwCustAddress //tvCustomerAddress
        addressDropdown.bottomOffset = CGPoint.init(x: 0, y: vwCustAddress.bounds.size.height+20)
        //   CGPointMake(0.0, self.btnAddress.bounds.size.height);
        
        addressDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tvCustomerAddress.text = item
            
            addressMasterID = NSNumber.init(value: arrAddressID[index])
            tvCustomerAddress.setFlexibleHeight()
        }
        
        addressDropdown.reloadAllComponents()
        
        contactDropdown.anchorView = tfContactPerson
        contactDropdown.bottomOffset = CGPoint.init(x: 0, y: tfContactPerson.bounds.size.height)
        contactDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfContactPerson.text = item
            self.contactID =  NSNumber.init(value: self.arrOfContact[index].iD)//NSNumber.init(value: index)
        }
        contactDropdown.reloadAllComponents()
        
    }
    
    func setViewAsperCustomerSelectionMode(){
        if let   originalAssignee = activeuser?.userID{
            self.originalAssignee = originalAssignee
        }
        lblCustomerName.setMultilineLabel(lbl: lblCustomerName)
        if(customerselectionmode == CustomerSelectionMode.single){
            if(self.activesetting.requiDirectVisitFromLeadInAddVisit == NSNumber.init(value: 1)){
                btndrtFromLead.isHidden = false
                vwVisitDirectFromLead.isHidden = false
            }
            tfAssignTo.isUserInteractionEnabled = true
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
                
            }
        }else{
            btndrtFromLead.isHidden = true
            vwVisitDirectFromLead.isHidden = true
            tfSelectCustomer.resignFirstResponder()
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
            
        }
        
    }
    
    // MARK: Method
    @objc func lblcustomernameTapped(){
        popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        popup?.modalPresentationStyle = .overCurrentContext
        popup?.strTitle = ""
        popup?.isSearchBarRequire = true
        popup?.isFromSalesOrder =  false
        popup?.viewfor = ViewFor.customer
        popup?.nonmandatorydelegate = self
        popup?.arrOfList = arrOfCustomers
        popup?.strLeftTitle = "OK"
        popup?.strRightTitle = "Cancel"
        popup?.selectionmode = SelectionMode.multiple
        popup?.arrOfSelectedMultipleCustomer = arrOfSelectedMultipleCustomer
        popup?.isFilterRequire = true
        // popup?.showAnimate()
        popup?.parentViewOfPopup = self.view
        Utils.addShadow(view: self.view)
        
        
        
        if(CustomerDetails.getAllCustomers().count > 0 &&  noOfTotalCustomer < noOFCustomer){
            self.present(popup!, animated: false, completion: nil)
        }
    }
    func isProductOrNot(product:Bool,service:Bool)->(){
        isProduct = product
        isService = service
    }
    
    func setAddress(){
        arrOfTempAddress.removeAll()
        if let selectedcustomer = self.selectedCustomer{
            
            arrOfTempAddress = AddressList().getAllAddressUsingCustomerId(cID: NSNumber.init(value: selectedcustomer.iD))
        }
        addressMasterID = NSNumber.init(value: arrOfTempAddress.first?.addressID ?? 0)
        arrStrAddress =  arrOfTempAddress.map{ String.init(format: "%@ , %@ , %@ - %@ , %@ %@", $0.addressLine1 ?? "" , $0.addressLine2  ?? "",$0.city  ?? "" ,$0.pincode ?? ""  , $0.state ?? "" , $0.country  ?? "")}
        arrAddressID = arrOfTempAddress.map{
            $0.addressID
        }
        addressDropdown.dataSource = arrStrAddress
        tvCustomerAddress.text  = arrStrAddress.first
        tvCustomerAddress.setFlexibleHeight()
        arrOfContact.removeAll()
        if let selectedcustomer = self.selectedCustomer{
            arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: selectedcustomer.iD))
        }
        arrOfStrContactName =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
        tfContactPerson.text =  arrOfStrContactName.count == 0 ? "No Contacts Exists":"Select Contact"
        contactDropdown.dataSource = arrOfStrContactName
        contactDropdown.reloadAllComponents()
    }
    
    
    
    func changeAssigneeAsperCustomerSelection(){
        var taggedToIDListOfUserID  = [Int]()
        if let selectedCustomer = selectedCustomer as? CustomerDetails{
            taggedToIDListOfUserID = selectedCustomer.taggedToIDList.map(
                {
                    //taggedUserID
                    ($0 as! TaggedToIDList).taggedUserID
                    
                })
        }
        for user in BaseViewController.staticlowerUser{
            if(user.entity_id == self.activeuser?.userID){
                arrOfLowerLevelUser.append(user)
            }else if(taggedToIDListOfUserID.contains(Int(user.entity_id)) && user.role_id != 9){
                arrOfLowerLevelUser.append(user)
            }
            
        }
    }
    
    //MARK: = For temp Customer (Customer which is not exist in database  and will added afer create a visit/lead for them)
    func setTempAddress(){
        arrOfTempAddress.removeAll()
        if let selectedcustomer = self.selectedTempCustomer{
            
            arrOfTempAddress = AddressList().getAllAddressUsingCustomerId(cID: NSNumber.init(value: selectedcustomer.iD))
        }
        addressMasterID = NSNumber.init(value: arrOfTempAddress.first?.addressID ?? 0)
        arrStrAddress =  arrOfTempAddress.map{ String.init(format: "%@ , %@ , %@ - %@ , %@ %@", $0.addressLine1 ?? "" , $0.addressLine2  ?? "",$0.city  ?? "" ,$0.pincode ?? ""  , $0.state ?? "" , $0.country  ?? "")}
        arrAddressID = arrOfTempAddress.map{
            $0.addressID
        }
        addressDropdown.dataSource = arrStrAddress
        tvCustomerAddress.text  = arrStrAddress.first
        tvCustomerAddress.setFlexibleHeight()
        arrOfContact.removeAll()
        if let selectedcustomer = self.selectedTempCustomer{
            arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: selectedcustomer.iD))
        }
        arrOfStrContactName =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
        tfContactPerson.text =  arrOfStrContactName.count == 0 ? "No Contacts Exists":"Select Contact"
        contactDropdown.dataSource = arrOfStrContactName
        contactDropdown.reloadAllComponents()
    }
    func changeAssigneeAsperTempCustomerSelection(){
        var taggedToIDListOfUserID  = [Int]()
        if let selectedCustomer = selectedCustomer as? TempcustomerDetails{
            taggedToIDListOfUserID = selectedCustomer.taggedToIDList.map(
                {
                    //taggedUserID
                    ($0 as! TaggedToIDList).taggedUserID
                    
                })
        }
        for user in BaseViewController.staticlowerUser{
            if(user.entity_id == self.activeuser?.userID){
                arrOfLowerLevelUser.append(user)
            }else if(taggedToIDListOfUserID.contains(Int(user.entity_id)) && user.role_id != 9){
                arrOfLowerLevelUser.append(user)
            }
            
        }
    }
    
   
    
    func selectedInteractionType(tag:Int){
        switch tag {
        case 1:
            
            // sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = true
            btnInteractionCall.isSelected = false
            btnInteractionMail.isSelected = false
            btnInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.metting
            break
            
        case 2:
            //  sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = false
            btnInteractionCall.isSelected = true
            btnInteractionMail.isSelected = false
            btnInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.call
            break
            
        case 3:
            //  sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = false
            btnInteractionCall.isSelected = false
            btnInteractionMail.isSelected = true
            btnInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.mail
            break
            
        case 4:
            // sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = false
            btnInteractionCall.isSelected = false
            btnInteractionMail.isSelected = false
            btnInteractionMessage.isSelected = true
            selectedInteraction = InteractionType.message
            break
            
        default:
            print("Its default case")
        }
    }
    // MARK: IBAction
    
    
    @IBAction func btnSearchAssignUserClicked(_ sender: UIButton) {
        
    }
    @IBAction func btnSearchAssigneeClicked(_ sender: Any) {
        tfAssignTo.becomeFirstResponder()
    }
    
    @IBAction func btnSearchCustomerClicked(_ sender: UIButton) {
        print(CustomerDetails.getAllCustomers().count)
        print(noOfCustomer)
        print(noOfTotalCustomer)
        if( CustomerDetails.getAllCustomers().count > 0 &&  noOfTotalCustomer < noOFCustomer){
            
            if(customerselectionmode == CustomerSelectionMode.single){
                
                
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
                    if(CustomerDetails.getAllCustomers().count > 0 &&  noOfTotalCustomer < noOFCustomer){
                        SVProgressHUD.dismiss()
                        self.present(popup!, animated: true, completion:nil)
                    }else{
                    SVProgressHUD.dismiss()
                    }
                }else{
                    // SVProgressHUD.dismiss()
                    //   Utils.toastmsg(message:"No Customer Please Create new",view: self.view)
                }
                
            }else{
                arrOfSelectedMultipleCustomer = [CustomerDetails]()
                popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                popup?.modalPresentationStyle = .overCurrentContext
                popup?.strTitle = ""
                popup?.isSearchBarRequire = true
                popup?.viewfor = ViewFor.customer
                popup?.nonmandatorydelegate = self
                popup?.isFromSalesOrder =  false
                popup?.arrOfList = arrOfCustomers
                popup?.strLeftTitle = "Okay"
                popup?.strRightTitle = "Cancel"
                popup?.selectionmode = SelectionMode.multiple
                popup?.arrOfSelectedMultipleCustomer = arrOfSelectedMultipleCustomer
                popup?.isFilterRequire = true
                // popup?.showAnimate()
                popup?.parentViewOfPopup = self.view
                Utils.addShadow(view: self.view)
                if( CustomerDetails.getAllCustomers().count > 0 &&  noOfTotalCustomer < noOFCustomer){
                    self.present(popup!, animated: false, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnSearchAddressClicked(_ sender: UIButton) {
        addressDropdown.show()
    }
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if(arrOfSelectedMultipleCustomer.count == 0 && tfSelectCustomer.text?.count == 0){
            Utils.toastmsg(message:NSLocalizedString("please_select_customer", comment: ""),view: self.view)
        }else{
            var maindict = Common.returndefaultparameter()
            
            if(customerselectionmode == CustomerSelectionMode.single){
                
                var visitDic =  ["CompanyID":activeuser?.company?.iD ?? NSNumber.init(value: 0),"CreatedBy":activeuser?.userID ?? NSNumber.init(value: 0),"ContactID":contactID,"VisitTypeID":NSNumber.init(value: 1),"SeriesPrefix":"","Conclusion":tvDescription.text,"AddressMasterID":addressMasterID,"NextActionID":nextActionID,"OriginalAssignee":originalAssignee,"NextActionTime":Utils.getDate(date: datepicker.date as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")] as [String : Any]//Utils.getDateinstrwithaspectedFormat(givendate: datepicker.date, format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: false)
                if(isEdit){
                    visitDic["ID"] = objVisit?.iD
                    visitDic["SeriesPostfix"] = objVisit?.seriesPostfix
                    visitDic["SeriesPrefix"] = objVisit?.seriesPrefix
                    visitDic["CustomerID"] = objVisit?.customerID
                }
                else{
                    if let selectedcustomer = self.selectedCustomer{
                        
                        visitDic["CustomerID"] = selectedcustomer.iD
                    }else if let tempcustomer = self.selectedTempCustomer{
                        visitDic["CustomerID"] = tempcustomer.iD
                    }
                }
                maindict["addUpdateVisitJson"] = Common.returnjsonstring(dic:visitDic )
                if(arrOfProduct.count > 0){
                    for pro in arrOfProduct{
                        var dic = [String:Any]()
                        dic["productName"] = pro.productName ?? ""
                        dic["ProductID"] = pro.productID ?? 0
                        if(pro.productCatId == 0){
                            dic["CategoryID"] = NSNumber.init(value:0)
                        }else{
                            dic["CategoryID"] = pro.productCatId
                            
                        }
                        if(pro.productSubCatId == 0){
                            dic["SubCategoryID"] = NSNumber.init(value:0)
                        }else{
                            dic["SubCategoryID"] = pro.productSubCatId
                            
                        }
                        if(pro.quantity?.count == 0){
                            dic["Quantity"] = "0"
                        }else{
                            dic["Quantity"] = pro.quantity
                            
                        }
                        if(pro.budget?.count == 0){
                            dic["Budget"] = "0"
                        }else{
                            dic["Budget"] = pro.budget
                            
                        }
                        
                        if(pro.salesDiscount?.count == 0){
                            dic["salesDiscount"] = "0"
                        }else{
                            dic["salesDiscount"] = pro.salesDiscount
                        }
                        if(pro.price?.count == 0){
                            dic["Price"] = "0"
                        }else{
                            dic["Price"] =  pro.price
                        }
                        if(pro.maxdiscount?.count == 0){
                            dic["Maxdiscount"] = "0"
                        }else{
                            dic["Maxdiscount"] = pro.maxdiscount
                        }
                        if(pro.leadId?.count == 0){
                            dic["LeadId"] = "0"
                        }else{
                            dic["LeadId"] = pro.leadId
                        }
                        if((self.activesetting.visitProductPermission == 2) && (((dic["Budget"] as? String)?.count == 0) ||
                                (dic["Budget"] as? String == "0"))){
                            dic["Budget"] = String.init(format:"%@",pro.price ?? 0)
                        }else{
                            dic["Budget"] = String.init(format:"%@",pro.budget ?? 0)
                        }
                        print("dic is  = \(dic)")
                        arrSelectedProductDic.append(dic)
                    }
                }
                
                if(arrSelectedProductDic.count > 0){
                    maindict["addUpdateVisitProductJson"] = Common.json(from: arrSelectedProductDic)
                    
                }else{
                    maindict["addUpdateVisitProductJson"] = "[\n\n]"
                }
            }
            else{
                var multipleCutomer = [[String:Any]]()
                if(arrOfSelectedMultipleCustomer.count > 0){
                    for cust in arrOfSelectedMultipleCustomer{
                        var dic:[String:Any] = [String:Any]()
                        dic["CustomerID"] =  cust.iD
                        dic["NextActionTime"] = Utils.getDate(date: datepicker.date as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")//Utils.getDateinstrwithaspectedFormat(givendate: datepicker.date, format: "yyyy/MM/dd HH:mm:ss",defaultTimZone:false)
                        multipleCutomer.append(dic)
                    }
                }
                var visitDic =  ["CompanyID":activeuser?.company?.iD ?? NSNumber.init(value: 0),"CustomerID":NSNumber.init(value: 0),"CreatedBy":activeuser?.userID ?? NSNumber.init(value: 0),"ContactID":contactID,"VisitTypeID":NSNumber.init(value: 1),"SeriesPrefix":"","Conclusion":tvDescription.text,"customerLocalID":NSNumber.init(value: 0),"LeadID":NSNumber.init(value: 0),"NextActionID":nextActionID,"OriginalNextActionID":nextActionID,"OriginalAssignee":originalAssignee,"NextActionTime":Utils.getDateinstrwithaspectedFormat(givendate: datepicker.date, format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: false)] as [String : Any]
                if(isEdit){
                    visitDic["ID"] = objVisit?.iD
                    visitDic["SeriesPostfix"] = objVisit?.seriesPostfix
                    visitDic["SeriesPrefix"] = objVisit?.seriesPrefix
                }
                maindict["addUpdateVisitProductJson"] = Common.json(from: arrSelectedProduct)
                maindict["addUpdateVisitJson"] = Common.json(from: visitDic)
                maindict["customerDetailsJson"] = Common.json(from: multipleCutomer)
            }
            let strurl  =  (customerselectionmode == CustomerSelectionMode.single) ?ConstantURL.kWSUrlAddEditPlannedVisit:ConstantURL.kWSUrlAddEditPlannedVisitForMultipleCustomer
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            print("parameter of Add plan visit = \(maindict)")
            self.apihelper.getdeletejoinvisit(param: maindict, strurl: strurl, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                
              
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    print(responseType)
                    if(responseType ==  ResponseType.dic){
                        var dicVisit = arr as? [String:Any] ?? [String:Any]()
                        if(self.customerselectionmode == CustomerSelectionMode.single){
                            if(CustomerDetails.getAllCustomers().count > 0 &&  self.noOfTotalCustomer < self.noOFCustomer){
                                SVProgressHUD.dismiss()
                                let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: dicVisit["CustomerID"] as? Int ?? 0))
                                if(strCustomerName.count == 0){
                                    dicVisit["CustomerName"] = "Customer Not Mapped"
                                }else{
                                    dicVisit["CustomerName"] = strCustomerName
                                }
                                let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
                                if(reassignedId > 0){
                                    
                                    if let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId)){
                                        let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                                        dicVisit["RessigneeName"] = reassignUserName
                                    }else{
                                        dicVisit["RessigneeName"] = ""
                                    }
                                }else{
                                    dicVisit["RessigneeName"] = ""
                                }
                                MagicalRecord.save({ (localContext) in
                                    let arrvisit = FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
                                    print(arrvisit)
                                    
                                }, completion: { (contextdidsave, error) in
                                    print("\(contextdidsave) , error = \(error)")
                                    print("visit saved")
                                    if(self.isEdit){
                                        NotificationCenter.default.post(name: Notification.Name("updateVisitData"), object: nil, userInfo: nil)
                                    }
                                    //    if let lastvisit = PlannVisit.mr_findAll()?.last as? PlannVisit{
                                    //                print(lastvisit.customerName)
                                    //            }
                                    print(error?.localizedDescription ?? "")
                                    print(self.navigationController?.viewControllers.count ?? 0)
                                    //     AppDelegate.shared.rootViewController.switchToMainScreen()
                                    
                                    if(self.navigationController?.viewControllers.count ?? 0 > 0){
                                        
                                        if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                            if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                                                self.navigationController?.popToViewController(controller,animated:true)
                                            }
                                        }else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                            if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                                                self.navigationController?.popToViewController(controller,animated:true)
                                            }
                                        }else{
                                            self.navigationController?.popViewController(animated:true)
                                        }
                                        
                                    }
                                    
                                    
                                })
                            }else{
                                let tempcustid = NSNumber.init(value:self.selectedTempCustomer?.iD ?? 0)
                                Utils().getCustomerDetail(cid: tempcustid) { (status) in
                                    SVProgressHUD.dismiss()
                                
                           
                                let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: dicVisit["CustomerID"] as? Int ?? 0))
                                if(strCustomerName.count == 0){
                                    dicVisit["CustomerName"] = "Customer Not Mapped"
                                }else{
                                    dicVisit["CustomerName"] = strCustomerName
                                }
                                let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
                                if(reassignedId > 0){
                                    
                                    if let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId)){
                                        let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                                        dicVisit["RessigneeName"] = reassignUserName
                                    }else{
                                        dicVisit["RessigneeName"] = ""
                                    }
                                }else{
                                    dicVisit["RessigneeName"] = ""
                                }
                                MagicalRecord.save({ (localContext) in
                                    let arrvisit = FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
                                    print(arrvisit)
                                    
                                }, completion: { (contextdidsave, error) in
                                    print("\(contextdidsave) , error = \(error)")
                                    print("visit saved")
                                    if(self.isEdit){
                                        NotificationCenter.default.post(name: Notification.Name("updateVisitData"), object: nil, userInfo: nil)
                                    }
                                    //    if let lastvisit = PlannVisit.mr_findAll()?.last as? PlannVisit{
                                    //                print(lastvisit.customerName)
                                    //            }
                                    print(error?.localizedDescription ?? "")
                                    print(self.navigationController?.viewControllers.count ?? 0)
                                    //     AppDelegate.shared.rootViewController.switchToMainScreen()
                                    
                                    if(self.navigationController?.viewControllers.count ?? 0 > 0){
                                        
                                        if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                            if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                                                self.navigationController?.popToViewController(controller,animated:true)
                                            }
                                        }else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                            if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                                                self.navigationController?.popToViewController(controller,animated:true)
                                            }
                                        }else{
                                            self.navigationController?.popViewController(animated:true)
                                        }
                                        
                                    }
                                    
                                    
                                })
                            }
                            }
                            
                        }else{
                            SVProgressHUD.dismiss()
                        }
                    }else{
                        SVProgressHUD.dismiss()
                        if(self.customerselectionmode == CustomerSelectionMode.multiple){
                            if(responseType == ResponseType.arr){
                                let arrVisitVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                                for dic in arrVisitVisit{
                                    var dicVisit = dic
                                    let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: dicVisit["CustomerID"] as? Int ?? 0))
                                    if(strCustomerName.count == 0){
                                        dicVisit["CustomerName"] = "Customer Not Mapped"
                                    }else{
                                        dicVisit["CustomerName"] = strCustomerName
                                    }
                                    let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
                                    if(reassignedId > 0){
                                        if    let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId )){
                                            let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                                            dicVisit["RessigneeName"] = reassignUserName
                                        }else{
                                            dicVisit["RessigneeName"] =  ""
                                        }
                                    }else{
                                        dicVisit["RessigneeName"] =  ""
                                    }
                                    MagicalRecord.save({ (localContext) in
                                        
                                        FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
                                        localContext.mr_save({ (localContext) in
                                            print("saving")
                                        }, completion: { (status, error) in
                                            print("saved")
                                        })
                                        
                                        localContext.mr_saveToPersistentStoreAndWait()
                                    }, completion: { (contextdidsave, error) in
                                        print("visit saved for multiple customer")
                                        print(error?.localizedDescription ?? "")
                                        if(self.navigationController?.viewControllers.count ?? 0 > 0){
                                            
                                            if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                                if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                                                    self.navigationController?.popToViewController(controller,animated:true)
                                                }
                                            }else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                                if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                                                    self.navigationController?.popToViewController(controller,animated:true)
                                                }
                                            }
                                            else{
                                                self.navigationController?.popViewController(animated:true)
                                            }
                                        }
                                    })
                                    
                                }
                            }
                        }
                    }
                    
                    
                }else{
                    SVProgressHUD.dismiss()
                    Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view: self.view)
                }
                if ( message.count > 0 ) {
                    SVProgressHUD.dismiss()
                    Utils.toastmsg(message:message,view: self.view)
                }
            }
        }
    }
    
    @IBAction func btnSingleClicked(_ sender: UIButton) {
        
        customerselectionmode = CustomerSelectionMode.single
        self.setViewAsperCustomerSelectionMode()
    }
    
    @IBAction func btnMultipleClicked(_ sender: UIButton) {
        if( CustomerDetails.getAllCustomers().count > 0 &&  noOfTotalCustomer < noOFCustomer){
            customerselectionmode = CustomerSelectionMode.multiple
            self.setViewAsperCustomerSelectionMode()
        }
    }
    
    
    @IBAction func btndrtLeadClicked(_ sender: UIButton) {
        btndrtFromLead.isSelected = !btndrtFromLead.isSelected
        if(btndrtFromLead.isSelected){
            vwLeadSelection.isHidden = false
        }else{
            vwLeadSelection.isHidden = true
        }
    }
    
    
    @IBAction func btnAddCustomerClicked(_ sender: UIButton) {
        
        SVProgressHUD.show()
        if (self.activeuser?.roleId?.intValue ?? 0 > 6 && self.activesetting.customerApproval == 1) {
            SVProgressHUD.dismiss()
            Utils.toastmsg(message:"You are not permitted to add customer, Please contact Admin for permission", view: self.view)
        } else if (self.activeuser?.roleId?.intValue ?? 0 > 6 && self.activesetting.customerApproval == 2) {
            SVProgressHUD.dismiss()
            Utils.toastmsg(message:"It require approval to add customer, Please contact Admin for permission", view: self.view)
        } else {
            if let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                
                Common.skipVisitSelection = false
                AddCustomer.isFromInfluencer = 0
                addCustomer.isForAddAddress = false
                addCustomer.isFromColdCallVisit = false
                addCustomer.isEditCustomer = false
                addCustomer.selectedCustomer = CustomerDetails()
                addCustomer.isVendor = false
                addCustomer.saveCustDelegate = self
                self.navigationController?.pushViewController(addCustomer, animated: true)
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.dismiss()
            }
        }
    }
    @IBAction func btnAddNewContactClicked(_ sender: UIButton) {
        if(arrOfSelectedSingleCustomer.count == 0){
            Utils.toastmsg(message:"Please select customer first",view: self.view)
        }else{
            if  let addContact = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddContactView) as? AddContact{
                
                addContact.isEditContact = false
                Common.skipVisitSelection = false
                addContact.selectedCust = arrOfSelectedSingleCustomer.first
                addContact.isVendor = false
                addContact.selectedContact = Contact()
                addContact.addcontactdel = self
                self.navigationController?.pushViewController(addContact, animated: true)
            }
        }
        
    }
    
    
    @IBAction func btnAddProductClicked(_ sender: UIButton) {
        if(activesetting.visitProductPermission == 2){
            // multiple product selection
            if let multipleproductselection = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MultipleProductSelection) as? MultipleProductSelection{
                Common.skipVisitSelection = false
                multipleproductselection.issalesorder = false
                multipleproductselection.multipleproductselectiondelegate = self
                if let selectedcustomer = self.selectedCustomer{
                    multipleproductselection.customerId =  NSNumber.init(value:selectedcustomer.iD as? Int64 ?? 0)  //NSNumber.init(value:dicLead?["CustomerID"] as? Int64)
                    
                }
                self.navigationController?.pushViewController(multipleproductselection, animated: true)
                
            }
            
        }else{
            if let addproductobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.SingleProductSelection) as? Addproduct{
                addproductobj.isFromProductStock = false
                addproductobj.isVisit = true
                addproductobj.isFromSalesOrder =  false
                addproductobj.productselectionfrom = ProductSelectionFromView.visit
                addproductobj.productselectiondelegate = self
                addproductobj.modalPresentationStyle = .overCurrentContext
                addproductobj.parentviewforpopup = self.view
                Utils.addShadow(view: self.view)
                self.present(addproductobj, animated: true, completion: nil)
            }
            // AddProductPopup().displayPopup(parentView: self.view)
        }
    }
    
    @IBAction func btnInteractionSelectionClicked(_ sender: UIButton) {
        print(sender.tag)
        nextActionID = NSNumber.init(value: sender.tag)
        self.selectedInteractionType(tag: sender.tag)
        
        
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

// MARK: UITextView
extension AddPlanVisit:UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        addressDropdown.show()
        return false
    }
}

// MARK: UITextfield
extension AddPlanVisit:UITextFieldDelegate{
    
    @objc func btnLeftTapped(){
        
        print("fsd sf fd")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == tfSelectCustomer){
            if(customerselectionmode == CustomerSelectionMode.single){
                return true
            }else{
                return false
            }
        }
        else if(textField == tfContactPerson){
            contactDropdown.show()
            return false
        }
        else if(textField == tfDate){
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            datepicker.datePickerMode = .date
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datepicker.date = dateNextActionTime ?? Date()
            print("\(strNextActionTime) , \(datepicker.date)")
            return true
        }
        else if(textField == tfTime){
            self.dateFormatter.dateFormat = "hh:mm a"
            datepicker.datePickerMode = .time
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datepicker.date = dateNextActionTime ?? Date()
            print("\(strNextActionTime) , \(datepicker.date)")
            return true
        }else if(textField == tfSelectLead){
            self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            self.popup?.modalPresentationStyle = .overCurrentContext
            self.popup?.strTitle = ""
            self.popup?.isFromSalesOrder =  false
            self.popup?.nonmandatorydelegate = self
            self.popup?.parentViewOfPopup = self.contentView
            self.popup?.arrOfLead = Lead.getAll()
            self.popup?.arrOfSelectedLead = arrOFselectedLead ?? [Lead]()
            self.popup?.strLeftTitle = ""
            self.popup?.strRightTitle = ""
            self.popup?.selectionmode = SelectionMode.none
            //popup?.selectedIndexPaths = selectedcustomerIndexes ?? [IndexPath]()
            self.popup?.isSearchBarRequire = true
            self.popup?.viewfor = ViewFor.lead
            
            self.popup?.isFilterRequire = false
            // popup?.showAnimate()
            //self.present(self.popup!, animated: false, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(self.popup!, animated: true, completion: {
                
            })
            return false
        }
        else{
            return true
        }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - textField: <#textField description#>
    ///   - range: <#range description#>
    ///   - string: <#string description#>
    /// - Returns: <#description#>
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        arrOfFilteredLowerLeverUser = BaseViewController.staticlowerUser
        
        var fullstring = ""
        if let tft = textField.text as? String{
            fullstring.append(tft)
        }
        fullstring.append(string)
      
        let trimmedstring = fullstring.trimmingCharacters(in: .whitespaces).lowercased()
     
        print("count =  \(trimmedstring.count) nd string = \(trimmedstring)")
        if (textField == tfSelectCustomer){
            
            arrOfCustomers = CustomerDetails.getAllCustomers()
            let arrOfTempCustomers = TempcustomerDetails.getAllCustomers()
            print("No of customer = \(noOfCustomer) && all cust count = \(arrOfCustomers.count)co")
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
                    SVProgressHUD.dismiss()
                    
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
        }else if(textField == tfAssignTo){
            //arrOfLowerLevelUser = [CompanyUsers]()
            
            if(BaseViewController.staticlowerUser.count == 0){
                if let active = CompanyUsers().getUser(userId: self.activeuser?.userID ?? 0) as? CompanyUsers{
                    BaseViewController.staticlowerUser.append(active)
                }
                
            }
            
            
            
            
            
            arrOfLowerLevelUserName =   arrOfLowerLevelUser.map{
                String.init(format: "%@ %@", $0.firstName , $0.lastName)
            } as [NSString]
            arrOfFilteredLowerLevelUserName =
                arrOfLowerLevelUserName.filter({(item: NSString) -> Bool in
                    let checkedstr = textField.text//?.trimmingCharacters(in: .whitespaces) ?? "@$W$")
                    let stringMatch1 = item.localizedCaseInsensitiveContains(checkedstr ?? "")
                    
                    return stringMatch1
                }
                )
            arrOfFilteredLowerLeverUser =  arrOfLowerLevelUser.filter({ (item:CompanyUsers) -> Bool in
                let checkedstr = (textField.text?.trimmingCharacters(in: .whitespaces) ?? "@$W$")
                let assigneeusername = String.init(format:"\(item.firstName) \(item.lastName)")
                print("assigne name = \(assigneeusername)")
                let stringMatch1 = assigneeusername.localizedCaseInsensitiveContains(checkedstr)
                
                return stringMatch1
            })
            
            //arrOfFilteredLowerLeverUser =
            //                arrOfLowerLevelUser.compactMap { (temp) -> CompanyUsers in
            //                    print(temp.firstName)
            //                    return temp
            //                    }.filter { (aUser) -> Bool in
            //                        print(aUser.firstName)
            //                        print(trimmedstring!)
            //                        return aUser.firstName.localizedCaseInsensitiveContains(trimmedstring!) == true
            //        //||(aUser.lastName?.localizedCaseInsensitiveContains(trimmedstring ?? "" ) == true)
            //            }
            // arrOfFilteredLowerLeverUser =
            
            assignUserDropdown.dataSource = arrOfFilteredLowerLevelUserName as [String]
            assignUserDropdown.reloadAllComponents()
            
            assignUserDropdown.show()
        }
        return true
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == tfSelectLead){
            
            
        }
        else
        if(textField == tfDate){
            datepicker.datePickerMode = UIDatePicker.Mode.date
        }else if(textField == tfTime){
            datepicker.datePickerMode = UIDatePicker.Mode.time
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfDate){
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfDate.text =  dateFormatter.string(from: datepicker.date)
            
            strNextActionTime = ""
            if let strdate = tfDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfTime.text{
                strNextActionTime.append("  \(strtime)")
            }
            
            
            
        }else{
            dateFormatter.dateFormat = "hh:mm a"
            tfTime.text =  dateFormatter.string(from: datepicker.date)
            strNextActionTime = ""
            if let strdate = tfDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfTime.text{
                strNextActionTime.append("  \(strtime)")
            }
            
            
        }
    }
}
extension AddPlanVisit:UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        /*   if(searchBar == searchCustomer){
         if(customerselectionmode == CustomerSelectionMode.single){
         return true
         }else{
         arrOfSelectedMultipleCustomer = [CustomerDetails]()//
         popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
         popup?.modalPresentationStyle = .overCurrentContext
         popup?.strTitle = ""
         popup?.nonmandatorydelegate = self
         popup?.arrOfList = arrOfCustomers
         popup?.strLeftTitle = "OK"
         popup?.strRightTitle = "Cancel"
         popup?.selectionmode = SelectionMode.multiple
         popup?.arrOfSelectedMultipleCustomer = arrOfSelectedMultipleCustomer
         popup?.isSearchBarRequire = true
         popup?.viewfor = ViewFor.customer
         popup?.isFilterRequire = true
         // popup?.showAnimate()
         //  popup?.parentViewOfPopup = self.view
         Utils.addShadow(view: self.view)
         self.present(popup!, animated: false, completion: nil)
         return false
         }
         }else{*/
        return true
        //  }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        /*  if(searchBar == searchCustomer){
         searchCustomer.endEditing(true)
         }else{*/
        searchAssignUser.endEditing(true)
        //  }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        /*    if(searchBar == searchCustomer){
         searchCustomer.endEditing(true)
         }else{*/
        searchAssignUser.endEditing(true)
        //  }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /*  if(searchBar == searchCustomer){
         searchCustomer.endEditing(true)
         }else{*/
        searchAssignUser.endEditing(true)
        //  }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrOfFilteredLowerLeverUser = BaseViewController.staticlowerUser
        let trimmedstring = searchBar.text?.trimmingCharacters(in: .whitespaces).lowercased()
        print(trimmedstring ?? "")
        
        /*   if(searchBar == searchCustomer){
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
         }else{*/
        
        arrOfLowerLevelUser = BaseViewController.staticlowerUser
        arrOfLowerLevelUserName =   arrOfLowerLevelUser.map{
            String.init(format: "%@ %@", $0.firstName , $0.lastName)
        } as [NSString] as [NSString]
        
        arrOfFilteredLowerLevelUserName =
            arrOfLowerLevelUserName.filter({(item: NSString) -> Bool in
                let checkedstr = (searchBar.text?.trimmingCharacters(in: .whitespaces) ?? "@$W$")
                let stringMatch1 = item.localizedCaseInsensitiveContains(checkedstr)
                
                print(searchBar.text?.trimmingCharacters(in: .whitespaces) ?? "rege")
                
                return stringMatch1
            })
        
        
        arrOfFilteredLowerLeverUser =  arrOfLowerLevelUser.filter({ (item:CompanyUsers) -> Bool in
            let checkedstr = (searchBar.text?.trimmingCharacters(in: .whitespaces) ?? "@$W$")
            let assigneeusername = String.init(format:"\(item.firstName) \(item.lastName)")
            print("assigne name = \(assigneeusername)")
            let stringMatch1 = assigneeusername.localizedCaseInsensitiveContains(checkedstr)
            
            return stringMatch1
        })
        arrOfFilteredLowerLeverUser =    arrOfLowerLevelUser.compactMap { (temp) -> CompanyUsers in
            return temp
        }.filter { (aUser) -> Bool in
            print(searchText)
            let assigneeusername = String.init(format:"\(aUser.firstName) \(aUser.lastName)")
            return assigneeusername.localizedCaseInsensitiveContains(searchText) == true || aUser.mobileNo1.localizedCaseInsensitiveContains(searchText) == true
        }
        print("arroffilter = \(arrOfFilteredLowerLeverUser.count) , total = \(arrOfLowerLevelUser.count)")
        print("count of name filter = \(arrOfFilteredLowerLevelUserName.count) , total = \(arrOfLowerLevelUser.count)")
      
        
        assignUserDropdown.dataSource = arrOfFilteredLowerLevelUserName as [String]
        assignUserDropdown.reloadAllComponents()
        
        assignUserDropdown.show()
      
    }
}

extension AddPlanVisit:BaseViewControllerDelegate{
    
    func editiconTapped() {
        
    }
    
 
    
    func datepickerSelectionDone() {
      
    }
    
    
}

extension AddPlanVisit:PopUpDelegateNonMandatory{
    
    func completionSelectedLead(arr: [Lead]) {
        arrOFselectedLead = arr
        if let selectedLead = arrOFselectedLead.first as? Lead{
            var strCustomerName = ""
            if let strCustname = selectedLead.customerName{
                strCustomerName = strCustname
            }
            tfSelectLead.text = String.init(format: "\(selectedLead.iD), \(strCustomerName)")
            
            tfSelectCustomer.text = selectedLead.customerName
            
            if let selectedtempCustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:selectedLead.customerID)){
                self.arrOfSelectedSingleCustomer = [selectedtempCustomer]
                arrOfCustomers = CustomerDetails.getAllCustomers()
                
                
                filteredCustomer = arrOfCustomers.map{
                    $0.name as? NSString ?? ""
                }
                
                customerDropdown.dataSource = filteredCustomer as [String]
                print("contact id is = \(contactID) in plan visit")
                self.contactID =  NSNumber.init(value:selectedLead.contactID)
                tfContactPerson.text = selectedtempCustomer.contactName
                selectedCustomer =  selectedtempCustomer
                self.changeAssigneeAsperCustomerSelection()
                self.setAddress()
                arrOfProduct = [SelectedProduct]()
                //Assign Product
                if(selectedLead.productList.count ?? 0 > 0){
                    
                    for product in selectedLead.productList{
                        if let prod = product as? ProductsList{
                            let productdic = prod.toDictionary()
                            
                            let product = SelectedProduct().initwithdic(dict: productdic)
                            print("dic is  = \(productdic) and quatntity = \(product.quantity) , budget = \(product.budget) ,  name is = \(product.productName)" )
                            arrOfProduct.append(product)
                            //                    if let tempproduct = ProductsList.getProduct(productID: NSNumber.init(value: prod.productId as? Int ?? 0)) as? ProductsList{
                            //                        let productsubcat = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value: tempproduct.productSubCatId))
                            //                      //  let prodic = ["productName":Product.getProductName(productID: NSNumber.init(value:prod.productId),"ProductID":NSNumber.init(value:prod.productId),"Quantity":prod] as? [String:Any]
                            //   }
                            
                            
                        }
                        
                    }
                    tblProduct.reloadData()
                    self.tblProductListHeight.constant = self.tblProduct.contentSize.height
                }
            }
        }
    }
    
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr.count)
        
        //        arrOfSelectedCustomer = arr
        if (popup?.selectionmode == SelectionMode.multiple) {
            arrOfSelectedMultipleCustomer = arr
            customerName  = ""
            if(arr.count > 0){
                for int in 0...arr.count - 1 {
                    if(int == 0){
                        let customer = arr[int]
                        customerName.append(contentsOf:customer.name)
                    }else{
                        let customer = arr[int]
                        customerName.append(contentsOf: String.init(format: ",%@",customer.name))
                    }
                }
            }
            lblCustomerName.setMultilineLabel(lbl: lblCustomerName)
            lblCustomerName.text = customerName
          
            lblCustomerName.setMultilineLabel(lbl: lblCustomerName)
            
        }else{
            arrOfSelectedSingleCustomer = arr
            selectedCustomer =  arr.first!
            self.changeAssigneeAsperCustomerSelection()
            if let selectedcustomer = self.selectedCustomer{
              
                tfSelectCustomer.text = selectedcustomer.name
                tfContactPerson.text = selectedcustomer.contactName
            }
            self.setAddress()
            if let customerfromDb =  CustomerDetails.getCustomerByID(cid: NSNumber.init(value: selectedCustomer?.iD ?? 0) ?? NSNumber.init(value: 0)){
                
            }else{
                Utils().getCustomerDetail(cid:NSNumber.init(value: selectedCustomer?.iD ?? 0)) {
                    (status) in
                }
            }
        }
       
    }
    
    
    
    
}

extension AddPlanVisit:ProductSelectionDelegate{
    func addProduct1(product: SelectedProduct) {
        Utils.removeShadow(view: self.view)
        for prod in arrOfProduct{
            if(prod.productID == product.productID){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view: self.view)
                return
            }
        }
        arrOfProduct.append(product)
        self.tblProductListHeight.constant = self.tblProduct.contentSize.height
        DispatchQueue.main.async {
            self.tblProduct.layoutIfNeeded()
            self.tblProduct.reloadData()
            self.tblProductListHeight.constant = self.tblProduct.contentSize.height
        }
        
        
        
        
        
        
        
    }
}
// MARK: UITABLE
extension AddPlanVisit:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return arrOfProduct.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProductCell{
            
            let product = arrOfProduct[indexPath.row]
            cell.setProductInfo(pro: product, record: indexPath.row)
            cell.lblProductName.text = product.productName
            cell.tfQty.text = String.init(format:"%@",product.quantity ?? 0)
            
            if(activesetting.visitProductPermission == 2){
                cell.tfBudget.text = String.init(format:"%@",product.price ?? 0)
                if(cell.tfBudget.text?.count == 0){
                    cell.tfBudget.text = String.init(format:"%@",product.budget ?? 0)
                }
            }else{
                cell.tfBudget.text = String.init(format:"%@",product.budget ?? 0)
            }
            print("budget is = \(cell.tfBudget.text) , name is = \(cell.lblProductName.text) , quantity is = \(cell.tfQty.text) ")
            cell.btnDelete.tag = indexPath.row
            //   cell.btnDelete.addTarget(self, action: #selector(deleteProduct), for: UIControl.Event.touchUpInside)
            cell.delegate = self
            //        cell.deleteAction = { sender in
            //            self.deletePro(index1: indexPath.row)
            //        }
            return cell
        }
        else{
            print("not get cell")
            return UITableViewCell()
        }
    }
    
    
    
    func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
        return 112//UITableView.automaticDimension
    }
    
    func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
        return UITableView.automaticDimension//tableView.contentSize.height
    }
    
    override func viewDidLayoutSubviews() {
        
        self.tblProductListHeight.constant = tblProduct.contentSize.height
    }
    
}

extension AddPlanVisit : ProductCellDelegate{
    func deleteProduct(cell: ProductCell) {
        if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
            let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
            let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
                
                
                self.arrOfProduct.remove(at: indexPath.row)
                
                
                self.tblProduct.beginUpdates()
                
                self.tblProduct.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
                DispatchQueue.main.async {
                    self.tblProduct.layoutIfNeeded()
                    self.tblProduct.reloadData()
                    self.tblProductListHeight.constant = self.tblProduct.contentSize.height
                }
                self.tblProduct.endUpdates()
                
                
            }
            Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
        }
    }
    
    
}

extension AddPlanVisit:MultipleProductSelectionDelegate{
    func addProductFromMultipleSelection(product: SelectedProduct) {
        print("Selected Multiple products \(product)")
        for prod in arrOfProduct{
            if(prod.productID == product.productID){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view: self.view)
                return
            }
        }
        arrOfProduct.append(product)
        tblProduct.layoutIfNeeded()
        tblProduct.layoutSubviews()
        tblProduct.reloadData()
        self.tblProductListHeight.constant = self.tblProduct.contentSize.height
        DispatchQueue.main.async {
            
            self.tblProduct.reloadData()
            self.tblProductListHeight.constant = self.tblProduct.contentSize.height
            self.tblProduct.layoutIfNeeded()
            
        }
        
    }
    
}

extension AddPlanVisit:AddContactDelegate{
    func saveContact(customerID: NSNumber, customerName: String, contactName: String, contactID: NSNumber) {
        tfContactPerson.text = contactName
        self.contactID =  contactID
        self.updateContactUI()
        //  self.setAddress()
    }
}

extension AddPlanVisit:AddCustomerDelegate{
    
    
    func saveCustomer(customerID: NSNumber, customerName: String, contactID: NSNumber) {
        
        // searchCustomer.text  =  customerName
        tfSelectCustomer.text = customerName
        if let selectedtempCustomer = CustomerDetails.getCustomerByID(cid: customerID) as? CustomerDetails {
            self.arrOfSelectedSingleCustomer = [selectedtempCustomer]
            arrOfCustomers = CustomerDetails.getAllCustomers()
            
            
            filteredCustomer = arrOfCustomers.map{
                $0.name as! NSString ?? ""
            }
            
            customerDropdown.dataSource = filteredCustomer as [String]
            print("contact id is = \(contactID) in plan visit")
            self.contactID =  contactID
            tfContactPerson.text = selectedtempCustomer.contactName
            selectedCustomer =  selectedtempCustomer
            self.changeAssigneeAsperCustomerSelection()
            self.setAddress()
        }
        
    }
    
    
}
