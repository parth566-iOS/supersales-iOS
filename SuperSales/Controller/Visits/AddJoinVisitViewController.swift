//
//  AddJoinVisit.swift
//  SuperSales
//
//  Created by Apple on 10/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import  CoreLocation
import SVProgressHUD
import FastEasyMapping

class AddJoinVisitViewController: BaseViewController {
    
    //swiftlint:disable line_length
    //swiftlint:disable type_body_length
    //swiftlint:disable file_length
    //swiftlint:disable function_body_length
    //swiftlint:disable force_cast
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnAddNewCustomer: UIButton!
    
    @IBOutlet weak var lblCustomerNameTitle: UILabel!
    
    @IBOutlet weak var stackCustomerSearch: UIStackView!
    
    @IBOutlet weak var tfCustomerName: UITextField!
    
    @IBOutlet weak var lblCustomerAddressTitle: UILabel!
    
    @IBOutlet weak var vwCustAddress: UIView!
    @IBOutlet weak var tvCustomerAddress: UITextView!
    
    @IBOutlet weak var btnCustomerNearMe: UIButton!
    
    @IBOutlet weak var lblDateTitle: UILabel!
    
    
    @IBOutlet weak var tfDate: UITextField!
    
    
    @IBOutlet weak var lblCheckInTitile: UILabel!
    
    
    @IBOutlet weak var tfCheckInTime: UITextField!
    
    @IBOutlet weak var lblCheckOutTitle: UILabel!
    
    @IBOutlet weak var tfCheckOutTime: UITextField!
    
    @IBOutlet weak var tfMeetingType: UITextField!
    
    
    @IBOutlet weak var tfMeetingLocation: UITextField!
    
    @IBOutlet weak var lblMeetingtimeTitle: UILabel!
    
    
    @IBOutlet weak var tfSelectionMeeting: UITextField!
    
    @IBOutlet weak var lblDurationTitle: UILabel!
    
    @IBOutlet weak var stackDurationTime: UIStackView!
    
    @IBOutlet weak var tfHours: UITextField!
    
    @IBOutlet weak var tfMinutes: UITextField!
    
    
    @IBOutlet weak var tfObjective: UITextField!
    
    
    @IBOutlet weak var tfOutcome: UITextField!
    
    
    @IBOutlet weak var btnAddContact: UIButton!
    
    @IBOutlet weak var tblAddContact: UITableView!
    @IBOutlet weak var btnAddUser: UIButton!
    
    @IBOutlet weak var tblUser: UITableView!
    
    @IBOutlet weak var cnstTblUserHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cnstTblContactHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchCustomer: UISearchBar!
    
    @IBOutlet weak var tfSearchCustomer: UITextField!
    
    
    var arrOfSelectedContact:[Contact] = [Contact]()
    var arrOfSelectedUser:[CompanyUsers] = [CompanyUsers]()
    
    var visitType:VisitType!
    var  strNextActionTime = ""
    var arrStrAddress = [String]()
    var popup:CustomerSelection? = nil
    var arrOfLowerLevelExecutive:[CompanyUsers]!
    var arrOfSelectedExecutive:[CompanyUsers]! = [CompanyUsers]()
    var selectedExecutive:CompanyUsers!
    var selectedExecutiveIndexes:[IndexPath]!
    var arrAllCustomer:[NSString] = [NSString]()
    var filteredCustomer:[NSString] = [NSString]()
    var arrOfCustomers = [CustomerDetails]()
    var arrOfSelectedCustomer = [CustomerDetails]()
    var arrOffilteredCustomer = [CustomerDetails]()
    var customerDropdown:DropDown! = DropDown()
    var addressDropdown:DropDown! = DropDown()
    var selectedCustomer:CustomerDetails?
    var arrOfTempAddress = [AddressList]()
    var arrNearCustomer:[CustomerDetails] = [CustomerDetails]()
    var addressMasterID:NSNumber = 0
    var originalAssignee = 0
    var executiveID:NSNumber = NSNumber.init(value: 0)
    var currenlocation:CLLocation!
    var currentlocationcoordinate:CLLocationCoordinate2D!
    let noOFCustomer = Utils.getDefaultIntValue(key: Constant.kNoOfCustomer)
    let noOfTotalCustomer = Utils.getDefaultIntValue(key:  Constant.kTotalCustomer)
    var arrOffilteredTempCustomer  = [TempcustomerDetails]()
    
    var selectedTempCustomer:TempcustomerDetails?
    var searchedtext = ""
    var checkindate:Date!
    var checkoutdate:Date!
    
    var datepicker:UIDatePicker!
    var noOfCustomer = 0
    
    @IBOutlet weak var cnstTvCustomerAddressHeight: NSLayoutConstraint!
    // MARK: - Implementation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name.init("updatecheckinInfo"), object: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updatecheckinInfo"), object: nil)
        
    }
    
    override func viewDidAppear(_ animate:Bool){
        super.viewDidAppear(true)
        Common.skipVisitSelection = true
    }
    
    // MARK: Method
    
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        //  self.navigationController?.popViewController(animated: true)
        print(notification.userInfo ?? "userinfo")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("message = \(notification.userInfo?["message"] ?? "gffgfgh")")
            if let strmsg = notification.userInfo?["message"] as? String{
                Utils.toastmsg(message:strmsg,view: self.view)
                if(self.navigationController?.viewControllers.count ?? 0 > 0){
                    
                    if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                        if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                            self.navigationController?.popToViewController(controller,animated:true)
                            SVProgressHUD.dismiss()
                        }
                    }else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                        if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                            self.navigationController?.popToViewController(controller,animated:true)
                            SVProgressHUD.dismiss()
                        }
                    }else{
                        self.navigationController?.popViewController(animated:true)
                        SVProgressHUD.dismiss()
                    }
                }
            }
            else{
                //  Utils.toastmsg(message:"manual checkin done sucessfully",view: self.view)
                if(self.navigationController?.viewControllers.count ?? 0 > 0){
                    
                    if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                        if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                            self.navigationController?.popToViewController(controller,animated:true)
                            SVProgressHUD.dismiss()
                        }
                    }else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                        if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                            self.navigationController?.popToViewController(controller,animated:true)
                            SVProgressHUD.dismiss()
                        }
                    }else{
                        self.navigationController?.popViewController(animated:true)
                        SVProgressHUD.dismiss()
                    }
                }
            }
            
        }
        
        
        /*serialque.async {
         DispatchQueue.main.async {
         if(self.navigationController?.viewControllers.count ?? 0 > 0){
         
         
         if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
         if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
         self.navigationController?.popToViewController(controller,animated:true)
         }
         }else{
         self.navigationController?.popViewController(animated:true)
         }
         }
         }
         }*/
    }
    func setUI(){
        
        
        CustomeTextfield.setBottomBorder(tf: tfSearchCustomer)
        self.salesPlandelegateObject = self
        selectedExecutive = CompanyUsers()
        
        
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        cnstTblUserHeight.constant = CGFloat(arrOfSelectedUser.count * 50)
        cnstTblContactHeight.constant = CGFloat(arrOfSelectedContact.count * 50)
        arrOfCustomers = CustomerDetails.getAllCustomers()
        arrAllCustomer = arrOfCustomers.map{ $0.name } as? [NSString] ?? [NSString]()
        if let  originalAssignee = activeuser?.userID
        {
            self.originalAssignee =  Int(originalAssignee)
        }
        datepicker = UIDatePicker()
        datepicker.setCommonFeature()
        datepicker.date = Date()
        
        tfDate.inputView  =  datepicker
        tfCheckInTime.inputView  = datepicker //checkindatepicker
        tfCheckOutTime.inputView = datepicker //checkoutdatepicker
        checkoutdate =   Utils.getNSDateWithAppendingDay(day: 0, date1: datepicker.date, format: "yyyy-MM-dd hh:mm a")
        checkindate =   Utils.getNSDateWithAppendingDay(day: 0, date1: datepicker.date, format: "yyyy-MM-dd hh:mm a")
        tfDate.setCommonFeature()
        tfHours.setCommonFeature()
        tfMinutes.setCommonFeature()
        tfOutcome.setCommonFeature()
        tfObjective.setCommonFeature()
        tfMeetingType.setCommonFeature()
        tfCustomerName.setCommonFeature()
        tfSearchCustomer.setCommonFeature()
        tfMeetingLocation.setCommonFeature()
        tfSearchCustomer.setCommonFeature()
        tfSelectionMeeting.setCommonFeature()
        tfCheckInTime.setCommonFeature()
        tfCheckOutTime.setCommonFeature()
        
        
        if(visitType == VisitType.manualvisit){
            
            self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
            self.title = "Add Manual Visit"
            
            
            
            lblCustomerNameTitle.text = "  Customer Details"
            lblCustomerAddressTitle.text = "  Customer Address"
            lblDateTitle.text = "  Date"
            lblCheckInTitile.text =  "  Check-In Time"
            lblCheckOutTitle.text = "  Check-Out Time"
            self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
            btnAddNewCustomer.isHidden = true
            stackCustomerSearch.isHidden = true
            btnCustomerNearMe.isHidden = true
            lblDateTitle.isHidden = false
            tfDate.isHidden = false
            lblCheckInTitile.isHidden = false
            tfCheckInTime.isHidden = false
            lblCheckOutTitle.isHidden = false
            tfCheckOutTime.isHidden = false
            tfMeetingType.isHidden = true
            tfMeetingLocation.isHidden = true
            lblMeetingtimeTitle.isHidden = true
            tfSelectionMeeting.isHidden = true
            lblDurationTitle.isHidden = true
            tfHours.isHidden = true
            tfMinutes.isHidden = true
            tfObjective.isHidden = true
            tfOutcome.isHidden = true
            btnAddUser.isHidden = true
            btnAddContact.isHidden = true
            tblUser.isHidden = true
            tblAddContact.isHidden = true
            
            //set delegate
            tfDate.delegate = self
            tfCheckOutTime.delegate = self
            tfCheckInTime.delegate = self
            tfCustomerName.delegate = self
            tvCustomerAddress.delegate = self
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            self.datepicker.maximumDate = Date()
            tfDate.text = self.dateFormatter.string(from: datepicker.date)
            self.dateFormatter.dateFormat = "hh:mm a"
            tfCheckInTime.text = self.dateFormatter.string(from: datepicker.date)
            tfCheckOutTime.text = self.dateFormatter.string(from: datepicker.date)
            self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            tfCustomerName.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
            tfDate.setrightImage(img: UIImage.init(named: "icon_calender")!)
            tfCheckInTime.setrightImage(img: UIImage.init(named: "icon_time")!)
            tfCheckOutTime.setrightImage(img: UIImage.init(named: "icon_time")!)
            
        }else if(visitType == VisitType.joinvisit)
        {
            if(BaseViewController.staticlowerUser.count == 0){
                self.fetchuser{
                    (arrOfuser,error) in
                    
                }
            }
            datepicker.minimumDate = Date()
            self.title = "Add Joint Visit"
            btnAddNewCustomer.isHidden = true
            
            self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
            lblCustomerNameTitle.text = "Sales Executive"
            tfCustomerName.placeholder = "Select Sales Executive"
            
            self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
            /* lblDateTitle.isHidden = false
             tfDate.isHidden = false
             btnCustomerNearMe.isHidden = true
             lblCheckInTitile.isHidden = false
             tfCheckInTime.isHidden = false
             tvCustomerAddress.isHidden = true
             lblCustomerAddressTitle.isHidden = true
             lblCheckOutTitle.isHidden = false
             tfCheckOutTime.isHidden = false
             tfMeetingType.isHidden = true
             tfMeetingLocation.isHidden = true
             lblMeetingtimeTitle.isHidden = true
             tfSelectionMeeting.isHidden = true
             lblDurationTitle.isHidden = true
             
             tfHours.isHidden = true
             tfMinutes.isHidden = true
             tfObjective.isHidden = true
             tfOutcome.isHidden = true
             btnAddUser.isHidden = true
             btnAddContact.isHidden = true
             tblUser.isHidden = true
             tblAddContact.isHidden = true*/
            
            btnAddNewCustomer.isHidden = true
            stackCustomerSearch.isHidden = true
            btnCustomerNearMe.isHidden = true
            lblDateTitle.isHidden = false
            tfDate.isHidden = false
            lblCheckInTitile.isHidden = false
            tfCheckInTime.isHidden = false
            lblCheckOutTitle.isHidden = false
            tfCheckOutTime.isHidden = false
            tfMeetingType.isHidden = true
            tfMeetingLocation.isHidden = true
            lblMeetingtimeTitle.isHidden = true
            tfSelectionMeeting.isHidden = true
            lblDurationTitle.isHidden = true
            tfHours.isHidden = true
            tfMinutes.isHidden = true
            tfObjective.isHidden = true
            tfOutcome.isHidden = true
            btnAddUser.isHidden = true
            btnAddContact.isHidden = true
            tblUser.isHidden = true
            tblAddContact.isHidden = true
            tvCustomerAddress.isHidden = true
            lblCustomerAddressTitle.isHidden = true
            vwCustAddress.isHidden = true
            tvCustomerAddress.backgroundColor = UIColor.blue
            
            tfSearchCustomer.backgroundColor = UIColor.green
            //set delegate
            
            tfCustomerName.delegate = self
            tfDate.delegate = self
            tfCheckInTime.delegate = self
            tfCheckOutTime.delegate = self
            lblCheckInTitile.text = "Start Time"
            lblCheckOutTitle.text = "End Time"
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            tfDate.text = self.dateFormatter.string(from: datepicker.date)
            self.dateFormatter.dateFormat = "hh:mm a"
            tfCheckInTime.text = self.dateFormatter.string(from: datepicker.date)
            tfCheckOutTime.text = self.dateFormatter.string(from: datepicker.date)
            if(BaseViewController.staticlowerUser.count == 0){
                self.fetchuser{
                    (arrOfuser,error) in
                    
                }
            }
            tfSearchCustomer.backgroundColor = UIColor.red
            tfCheckInTime.setrightImage(img: UIImage.init(named: "icon_time")!)
            tfCheckOutTime.setrightImage(img: UIImage.init(named: "icon_time")!)
            
            tfCustomerName.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
            tfDate.setrightImage(img: UIImage.init(named: "icon_calender")!)
            stackCustomerSearch.isHidden = true
            
            //            let predicate = NSPredicate.init(format: "role_id == 8", [])
            //            let sortDescriptor1 = NSSortDescriptor.init(key: "firstName", ascending: true)
            //            let sortDescriptor2 = NSSortDescriptor.init(key: "lastName", ascending: true)
            //    arrOfLowerLevelExecutive = [CompanyUsers]()
            
            
        }else if(visitType == VisitType.corporatevisit){
            
            self.title = "Add Joint Visit"
            btnAddNewCustomer.isHidden = true
            stackCustomerSearch.isHidden = true
            
            lblCustomerNameTitle.text = "Customer Detail"
            self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
            lblDateTitle.isHidden = true
            tfDate.isHidden = true
            btnCustomerNearMe.isHidden = true
            lblCheckInTitile.isHidden = true
            tfCheckInTime.isHidden = true
            tvCustomerAddress.isHidden = true
            lblCustomerAddressTitle.isHidden = true
            lblCheckOutTitle.isHidden = true
            tfCheckOutTime.isHidden = true
            tfMeetingType.isHidden = false
            tfMeetingLocation.isHidden = false
            lblMeetingtimeTitle.isHidden = false
            tfSelectionMeeting.isHidden = false
            lblDurationTitle.isHidden = false
            
            tfHours.isHidden = false
            tfMinutes.isHidden = false
            tfObjective.isHidden = false
            tfOutcome.isHidden = false
            btnAddUser.isHidden = false
            btnAddContact.isHidden = false
            tblUser.isHidden = false
            tblAddContact.isHidden = false
            
            //set delegate
            tfCustomerName.delegate = self
            tfMeetingLocation.delegate = self
            tfMeetingType.delegate = self
            tfSelectionMeeting.delegate = self
            tfHours.delegate = self
            tfMinutes.delegate = self
            tfObjective.delegate = self
            tfOutcome.delegate = self
            tblUser.delegate = self
            tblUser.dataSource = self
            tblAddContact.delegate = self
            tblAddContact.dataSource = self
            
        }else{
            self.lblCustomerNameTitle.backgroundColor = UIColor.clear
            self.lblCustomerAddressTitle.backgroundColor =  UIColor.clear
            self.title = NSLocalizedString("add_direct_visit_check_in", comment: "")
            if(activesetting.requireAddNewCustomerInVisitLeadOrder == NSNumber.init(value: 0)){
                btnAddNewCustomer.isHidden = true
            }else{
                btnAddNewCustomer.isHidden = false
            }
            Location.sharedInsatnce.startLocationManager()
            currentlocationcoordinate = Location.sharedInsatnce.getCurrentCoordinate()
            if let  currenlocation1 = Location.sharedInsatnce.getLocation(){
                currenlocation = currenlocation1
            }else{
                Utils.toastmsg(message:"can not get current location please check gps",view: self.view)
            }
            
            stackCustomerSearch.isHidden = false
            tfCustomerName.isHidden = true
            lblCustomerNameTitle.text = " Customer Name"
            //customer_near_me
            // btnCustomerNearMe.setTitle(NSLocalizedString("customer_near_me", comment: ""), for: .normal)
            let attrs = [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.Appskybluecolor,
                NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
            let buttonTitleStr = NSMutableAttributedString(string:NSLocalizedString("customer_near_me", comment: ""), attributes:attrs)
            btnCustomerNearMe.setAttributedTitle(buttonTitleStr, for: UIControl.State.normal)
            btnCustomerNearMe.isHidden = false
            lblDateTitle.isHidden = true
            tfDate.isHidden = true
            lblCheckInTitile.isHidden = true
            tfCheckInTime.isHidden = true
            lblCheckOutTitle.isHidden = true
            tfCheckOutTime.isHidden = true
            tfMeetingType.isHidden = true
            tfMeetingLocation.isHidden = true
            lblMeetingtimeTitle.isHidden = true
            tfSelectionMeeting.isHidden = true
            lblDurationTitle.isHidden = true
            tfHours.isHidden = true
            tfMinutes.isHidden = true
            tfObjective.isHidden = true
            tfOutcome.isHidden = true
            btnAddUser.isHidden = true
            btnAddContact.isHidden = true
            tblUser.isHidden = true
            tblAddContact.isHidden = true
            
            //set delegate
            searchCustomer.delegate = self
            tvCustomerAddress.delegate = self
            tfSearchCustomer.delegate = self
            self.btnSubmit.setbtnFor(title: NSLocalizedString("CHECK_IN", comment: ""), type: Constant.kPositive)
            
            
        }
        tvCustomerAddress.setFlexibleHeight()
        
        self.initDropDown()
    }
    
    
    func initDropDown(){
        customerDropdown.anchorView = tfSearchCustomer //searchCustomer
        customerDropdown.bottomOffset = CGPoint.init(x: 0, y: tfSearchCustomer.bounds.size.height+20)
        //   CGPointMake(0.0, self.btnAddress.bounds.size.height);
        customerDropdown.dataSource = filteredCustomer as [String]
        customerDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfSearchCustomer.text = item
            self.arrOfSelectedCustomer.removeAll()
            if(noOFCustomer > noOfTotalCustomer && arrOfCustomers.count > 0){
                self.selectedCustomer = self.arrOffilteredCustomer[index]
                if let selectedcustomer = self.selectedCustomer{
                    self.arrOfSelectedCustomer.append(selectedcustomer)
                    self.setAddress()
                }
            }else if(arrOffilteredTempCustomer.count > 0){
                self.selectedTempCustomer = self.arrOffilteredTempCustomer[index]
                self.setTempAddress()
                
            }else{
                self.selectedCustomer = self.arrOffilteredCustomer[index]
                if let selectedcustomer = self.selectedCustomer{
                    self.arrOfSelectedCustomer.append(selectedcustomer)
                    self.setAddress()
                }
            }
        }
        customerDropdown.reloadAllComponents()
        
        addressDropdown.anchorView = vwCustAddress //tvCustomerAddress
        addressDropdown.bottomOffset = CGPoint.init(x: 0, y: vwCustAddress.bounds.size.height+20)
        //   CGPointMake(0.0, self.btnAddress.bounds.size.height);
        
        addressDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tvCustomerAddress.text = item
            // let selectedaddress = arrOfTempAddress[item] as? AddressList
            addressMasterID = NSNumber.init(value: arrOfTempAddress[index].addressID)
            
        }
        addressDropdown.reloadAllComponents()
    }
    func setvalidationForjointVisit()->Bool{
        
        print("today date = \(Date()) , check in date = \(checkindate) , checkout date = \(checkoutdate)")
        if(tfCustomerName.text?.count ?? 0 == 0){
            Utils.toastmsg(message:NSLocalizedString("please_select_the_executive", comment:""),view: self.view)
            return false
        }else if(checkindate.compare(Date()) == .orderedAscending){
            Utils.toastmsg(message:NSLocalizedString("select_valid_visit_time", comment:""),view: self.view)
            return false
        }else if(checkoutdate.compare(Date()) == .orderedAscending){
            Utils.toastmsg(message:NSLocalizedString("select_valid_visit_time", comment:""),view: self.view)
            return false
        }
        else if(checkindate.compare(checkoutdate) == .orderedDescending){
            Utils.toastmsg(message:NSLocalizedString("make_sure_your_start_time_is_before_end_time", comment:""),view: self.view)
            return false
        }else{
            return true
        }
    }
    func setvalidationForcorporateVisit()->Bool{
        
        if(tfCustomerName.text?.count ?? 0 == 0){
            Utils.toastmsg(message:NSLocalizedString("please_select_customer", comment:""),view: self.view)
            return false
        }else if(tfMeetingType.text?.count == 0){
            Utils.toastmsg(message:NSLocalizedString("please_select_meeting_type", comment:""),view: self.view)
            return false
        }
        else if(tfMeetingLocation.text?.count == 0){
            Utils.toastmsg(message:NSLocalizedString("please_select_meeting_location", comment:""),view: self.view)
            return false
        }else if(tfMeetingLocation.text?.count == 0){
            Utils.toastmsg(message:NSLocalizedString("please_select_meeting_location", comment:""),view: self.view)
            return false
        }else if(tfObjective.text?.count == 0){
            Utils.toastmsg(message:NSLocalizedString("please_enter_objective", comment:""),view: self.view)
            return false
        }else if(tfOutcome.text?.count == 0){
            Utils.toastmsg(message:NSLocalizedString("please_enter_outcome", comment:""),view: self.view)
            return false
        }else if(arrOfSelectedUser.count == 0){
            Utils.toastmsg(message:NSLocalizedString("please_select_the_executive", comment:""),view: self.view)
            return false
        }else{
            return true
        }
    }
    
    func setValidationForManualCheckin()->Bool{
        
        
        let calendarComponents : Set<Calendar.Component> = [ .minute]
        if(tfCustomerName.text?.count ?? 0 == 0){
            //            let win:UIWindow = UIApplication.shared.delegate!.window!!
            //            win.currentViewController().view.makeToast(NSLocalizedString("please_select_customer", comment:""))
            
            //UIApplication.shared.windows.first?.makeToast(NSLocalizedString("please_select_customer", comment:""))
            Utils.toastmsg(message:NSLocalizedString("please_select_customer", comment:""),view: self.view)
            return false
        }else{
            
            if(checkindate.compare(Date()) == .orderedDescending){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_future_check_in_time", comment:""),view: self.view)
                return false
            }else if(checkoutdate.compare(Date()) == .orderedDescending){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_future_check_uut_time", comment:""),view: self.view)
                return false
            }else if(Calendar.current.dateComponents(calendarComponents, from: checkindate, to: checkoutdate).minute ?? 0 < 1){
                Utils.toastmsg(message:NSLocalizedString("make_sure_your_check_in_time_is_before_check_out_time", comment:""),view: self.view)
                return false
            }
            else if(checkindate.compare(checkoutdate) == .orderedSame){
                Utils.toastmsg(message:NSLocalizedString("make_sure_your_check_in_time_is_before_check_out_time", comment:""),view: self.view)
                return false
            }else{
                return true
            }
        }
    }
    func setValidationForDirectVisitCheckin()->Bool{
        
        //            if(tfSearchCustomer.text?.count == 0){
        //                Utils.toastmsg(message:NSLocalizedString("please_select_customer", comment:""))
        //                return false
        //            }else{
        if let selectedcustomer = self.selectedCustomer{
            if(activesetting.customTagging == NSNumber.init(value: 3)){
                if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:selectedcustomer.iD ?? 0)))){
               // if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:selectedcustomer.iD)))){
                    Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view: self.view)
                    return false
                }else{
                    if(tfSearchCustomer.text?.count == 0){
                        Utils.toastmsg(message:NSLocalizedString("please_select_customer", comment:""),view: self.view)
                        return false
                    }else{
                        return true
                    }
                }
            }
            else{
                return true
            }
            
            
            
            
            
        }else if let selectedcustomer =  self.selectedTempCustomer{
            if(activesetting.customTagging == NSNumber.init(value: 3)){
             
//                if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:selectedcustomer.iD ?? 0)))){
                if(!Utils.isTempCustomerMapped(cid: NSNumber.init(value:selectedcustomer.iD ?? 0))){
                    Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view: self.view)
                    return false
                }else{
                    if(tfSearchCustomer.text?.count == 0){
                        Utils.toastmsg(message:NSLocalizedString("please_select_customer", comment:""),view: self.view)
                        return false
                    }else{
                        return true
                    }
                }
            }
            else{
                return true
            }
            
            
        }else{
            Utils.toastmsg(message:NSLocalizedString("please_select_customer", comment:""),view: self.view)
            return false
        }
        
        
    }
    
    func setAddress(){
        arrOfTempAddress.removeAll()
        if let selectedcustomer = self.selectedCustomer{
            arrOfTempAddress = AddressList().getAllAddressUsingCustomerId(cID: NSNumber.init(value: selectedcustomer.iD))
            addressMasterID = NSNumber.init(value: arrOfTempAddress.first?.addressID ?? 0)
            arrStrAddress =  arrOfTempAddress.map{
                String.init(format: "%@ , %@ , %@ - %@ , %@ %@", $0.addressLine1 ?? "" , $0.addressLine2  ?? "",$0.city  ?? "",$0.pincode ?? ""  , $0.state ?? "" , $0.country  ?? "")
                
            }
            
            addressDropdown.dataSource = arrStrAddress
            tvCustomerAddress.text  = arrStrAddress.first
            tvCustomerAddress.setFlexibleHeight()
        }
        //        arrOfContact.removeAll()
        //        arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: selectedCustomer.iD))
        //        arrOfStrContactName =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
        //        tfContactPerson.text =  arrOfStrContactName.count == 0 ? "No Contacts Exists":"Select Contact"
        //        contactDropdown.dataSource = arrOfStrContactName
        //        contactDropdown.reloadAllComponents()
    }
    
    func setTempAddress(){
        arrOfTempAddress.removeAll()
        if let selectedcustomer = self.selectedTempCustomer{
            arrOfTempAddress = AddressList().getAllAddressUsingCustomerId(cID: NSNumber.init(value: selectedcustomer.iD))
            addressMasterID = NSNumber.init(value: arrOfTempAddress.first?.addressID ?? 0)
            arrStrAddress =  arrOfTempAddress.map{
                String.init(format: "%@ , %@ , %@ - %@ , %@ %@", $0.addressLine1 ?? "" , $0.addressLine2  ?? "",$0.city  ?? "",$0.pincode ?? ""  , $0.state ?? "" , $0.country  ?? "")
                
            }
            
            addressDropdown.dataSource = arrStrAddress
            tvCustomerAddress.text  = arrStrAddress.first
            tvCustomerAddress.setFlexibleHeight()
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        tfDate.text = self.dateFormatter.string(from: sender.date)
    }
    @objc func handleCheckinDatePicker(sender: UIDatePicker) {
        
        self.dateFormatter.dateFormat = "hh:mm a"
        tfCheckInTime.text = self.dateFormatter.string(from: sender.date)
        print(sender.date)
        
    }
    @objc func handleCheckoutDatePicker(sender: UIDatePicker) {
        
        self.dateFormatter.dateFormat = "hh:mm a"
        tfCheckOutTime.text = self.dateFormatter.string(from: sender.date)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK: API Call
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
    
    // MARK: IBAction
    
    @IBAction func btnSearchCustomerClicked(_ sender: UIButton){
        if(visitType == VisitType.manualvisit || visitType == VisitType.directvisitcheckin){
            if(arrOfCustomers.count > 0){
                if(CustomerDetails.getAllCustomers().count > 0 &&  noOfTotalCustomer < noOFCustomer){
                    popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                    popup?.modalPresentationStyle = .overCurrentContext
                    popup?.nonmandatorydelegate = self
                    popup?.strTitle = ""
                    popup?.isSearchBarRequire =  true
                    popup?.isFromSalesOrder =  false
                    popup?.viewfor = ViewFor.customer
                    popup?.arrOfList = arrOfCustomers
                    popup?.selectionmode = SelectionMode.none
                    popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
                    popup?.isFilterRequire = false
                    popup?.strLeftTitle = "REFRESH"
                    // popup?.showAnimate()
                    //self.popoverPresentationController =  popup
                    popup?.parentViewOfPopup = self.view
                    Utils.addShadow(view: self.view)
                    
                    self.present(popup!, animated: true, completion: nil)
                }
            }else{
                // Utils.toastmsg(message:"No Customer Please Create new",view: self.view)
            }
        }else{
            arrOfLowerLevelExecutive = BaseViewController.staticlowerUser
            
            if(arrOfSelectedExecutive.count == 0 && arrOfLowerLevelExecutive.count > 0){
                arrOfSelectedExecutive =       [(arrOfLowerLevelExecutive.first ?? CompanyUsers())]
            }
            popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            popup?.selectionmode =  SelectionMode.single
            popup?.modalPresentationStyle = .overCurrentContext
            popup?.nonmandatorydelegate = self
            popup?.strTitle = "Select User"
            popup?.strRightTitle = "CANCEL"
            popup?.strLeftTitle = "OK"
            popup?.arrOfExecutive = arrOfLowerLevelExecutive
            popup?.arrOfSelectedExecutive = arrOfSelectedExecutive//[CompanyUsers]()
            popup?.isFilterRequire = false
            popup?.isFromSalesOrder =  false
            popup?.viewfor = ViewFor.companyuser
            popup?.isSearchBarRequire = false
            // popup?.showAnimate()
            //   self.popoverPresentationController =  popup
            popup?.parentViewOfPopup = self.view
            Utils.addShadow(view: self.view)
            self.present(popup!, animated: true, completion: nil)
        }
    }
    @IBAction func btnSearchAddressClicked(_ sender: UIButton) {
        addressDropdown.show()
    }
    @IBAction func btnCustomerNearmeClicked(_ sender: UIButton) {
        arrNearCustomer.removeAll()
        if let currentlocation = currenlocation as? CLLocation{
            if (CLLocationCoordinate2DIsValid(currentlocationcoordinate)) {
                print("Visit Thread Do Check-IN ==> latitude: \(currentlocationcoordinate.latitude) and longitude \(currentlocationcoordinate.longitude)")
                if(arrOfCustomers.count > 0){
                    for cust in 0...arrOfCustomers.count-1{
                        let customer = arrOfCustomers[cust]
                        arrOfTempAddress = AddressList().getAllAddressUsingCustomerId(cID: NSNumber.init(value:  customer.iD))
                        if(arrOfTempAddress.count > 0){
                            for tempAdd in 0...arrOfTempAddress.count-1{
                                let address = arrOfTempAddress[tempAdd]
                                let lat = Double(address.lattitude ?? "0.00") ?? 0.00
                                let long = Double(address.longitude ?? "0.00") ?? 0.00
                                //                            let lat = address.lattitude ?? 0.00
                                //                            let long = address.longitude ?? 0.00
                                //                            let lat = 0.00
                                //                            let long = 0.00
                                if let currentlocation = currenlocation as? CLLocation{
                                    let meter = currenlocation.distance(from: CLLocation.init(latitude:lat , longitude: long))
                                      print("meter = \(meter), lattitude = \(lat) , longitude = \(long) lattitude current location = \(currenlocation.coordinate.latitude) , longitude = \(currenlocation.coordinate.longitude)")
                                    //may be radius will come
                                    if(meter < 501){
                                        arrNearCustomer.append(customer)
                                       
                                    }
                                }else{
                                    Utils.toastmsg(message:"can not find current location please check your GPS and permission",view: self.view)
                                }
                            }
                        }
                    }
                }
                if(arrNearCustomer.count > 0){
                    // &&  noOfTotalCustomer > noOFCustomer as in case total customer is 60 and limited customer is 5000 no customer nearby was displaying 
                    if(CustomerDetails.getAllCustomers().count > 0){
                        popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                        popup?.modalPresentationStyle = .overCurrentContext
                        popup?.nonmandatorydelegate = self
                        popup?.strTitle = ""
                        popup?.arrOfList = arrNearCustomer
                        popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
                        popup?.selectionmode = SelectionMode.none
                        popup?.isFromSalesOrder =  false
                        popup?.viewfor = ViewFor.customer
                        popup?.isFilterRequire = false
                        popup?.strLeftTitle = ""
                        popup?.isSearchBarRequire =  true
                        popup?.parentViewOfPopup = self.view
                        Utils.addShadow(view: self.view)
                        
                        self.present(popup!, animated: true, completion: nil)
                    }
                }
                else{
                    Utils.toastmsg(message:"No customer nearby",view: self.view)
                }
            }else{
                let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                    
                }
                Common.showalert(title: NSLocalizedString("location_services_disabled", comment:""), msg: NSLocalizedString("please_enable_location_services_in_settings", comment:""), yesAction: settingAction, noAction: cancelAction,view:self)
            }
        }else{
            Utils.toastmsg(message:"can not find current location please check your GPS and permission",view: self.view)
        }
    }
    
    @IBAction func btnAddNewCustomerClicked(_ sender: UIButton){
        if (self.activeuser?.roleId?.intValue ?? 0 > 6 && self.activesetting.customerApproval == 1) {
            Utils.toastmsg(message:"You are not permitted to add customer, Please contact Admin for permission", view: self.view)
        } else if (self.activeuser?.roleId?.intValue ?? 0 > 6 && self.activesetting.customerApproval == 2) {
            Utils.toastmsg(message:"It require approval to add customer, Please contact Admin for permission", view: self.view)
        } else {
            if  let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                SVProgressHUD.show()
                Common.skipVisitSelection = false
                addCustomer.isFromColdCallVisit = false
                AddCustomer.isFromInfluencer = 0
                addCustomer.isForAddAddress = false
                addCustomer.isEditCustomer = false
                addCustomer.isVendor = false
                addCustomer.saveCustDelegate = self
                
                self.navigationController?.pushViewController(addCustomer, animated: true)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        
        if(visitType == VisitType.manualvisit){
            //manual visit
            if(self.setValidationForManualCheckin() == true){
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
                var visitdict = [String:Any]()
                if let selectedcustomer = self.selectedCustomer{
                    visitdict = ["CompanyID":activeuser?.company?.iD ?? NSNumber.init(value: 0),"CustomerID":NSNumber.init(value: selectedcustomer.iD),"AddressMasterID": addressMasterID,"CreatedBy":activeuser?.userID ?? NSNumber.init(value: 0),
                                 /*[Utils getDate:checkInDt andFormat:@"yyyy/MM/dd HH:mm:ss"]
                                  */ "CheckInTime":Utils.getDateinstrwithaspectedFormat(givendate: checkindate, format: "yyyy/MM/dd HH:mm:ss",defaultTimZone:true),"CheckOutTime":Utils.getDateinstrwithaspectedFormat(givendate: checkoutdate, format: "yyyy/MM/dd HH:mm:ss",defaultTimZone:true)] as [String : Any]
                }else{
                    Utils.toastmsg(message:"Please select Customer",view: self.view)
                    return
                }
                var param = Common.returndefaultparameter()
                param["visitDate"] = String.init(format: "%@ 00:00:00", Utils.getDateWithAppendingDayLang(day: 0, date: checkindate, format: "yyyy/MM/dd"))
                param["addManualVisitJson"] = Common.json(from: visitdict)
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddManualVisit, method: Apicallmethod.post) {
                    (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                    if(error.code == 0){
                        print(responseType)
                        print(arr)
                        var dicVisit = arr as? [String:Any] ?? [String:Any]()
                        if ( message.count > 0 ) {
                            Utils.toastmsg(message:message,view: self.view)
                        }
                        let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: dicVisit["CustomerID"] as? Int ?? 0))
                        if(strCustomerName.count == 0){
                            dicVisit["CustomerName"] = "Customer Not Mapped"
                        }else{
                            dicVisit["CustomerName"] = strCustomerName
                        }
                        let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
                        if(reassignedId > 0){
                            
                            if   let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId)){
                                let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                                dicVisit["RessigneeName"] = reassignUserName
                            }else{
                                dicVisit["RessigneeName"] = ""
                            }
                        }else{
                            dicVisit["RessigneeName"] = ""
                        }
                        print(dicVisit)
                        MagicalRecord.save({ (localContext) in
                            FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
                            localContext.mr_save({ (localContext) in
                                print("saving")
                            }, completion: { (status, error) in
                                print("saved")
                            })
                            // FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping())
                            
                        }, completion: { (contextdidsave, error) in
                            print("visit saved")
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
                                }else{
                                    self.navigationController?.popViewController(animated:true)
                                }
                                
                            }
                            
                            
                        })
                    }else{
                        Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                    }
                }
            }
            
        }
        else if(visitType == VisitType.corporatevisit){
            if(self.setvalidationForcorporateVisit() == true){
                
            }
        }
        else if(visitType == VisitType.joinvisit){
            if(self.setvalidationForjointVisit() == true){
                SVProgressHUD.show(withStatus: "adding joint visit")
                //  [visitdict setObject:[Utils getDate:[[NSDate date] dateByAddingMinutes:5] andFormat:@"yyyy/MM/dd HH:mm:ss"] forKey:@"NextActionTime"];[Utils getDate:checkInDt andFormat:@"yyyy/MM/dd HH:mm:ss"] forKey:@"StartTime"]
                var param = Common.returndefaultparameter()
                let mettingdic = ["CompanyID":activeuser?.company?.iD ?? NSNumber.init(value: 0),"MemberID":selectedExecutive.entity_id,"UserID":activeuser?.userID ?? 0,"StartTime":Utils.getDate(date: checkindate as! NSDate, withFormat: "yyyy/MM/dd HH:mm:ss"),"EndTime":Utils.getDate(date: checkoutdate as! NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")] as [String : Any]
                param["addJointVisitJson"] = Common.json(from: mettingdic)
                print("parameter of add joint visit = \(param)")
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddJointVisit, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    
                    if(error.code == 0){
                        
                        print("response of add joint visit = \(param)")
                        if(responseType == ResponseType.arr){
                            let  arrJointVisit = arr as? [String:Any] ?? [String:Any]()
                            if(arrJointVisit.count > 0){
                                MagicalRecord.save({ (localcontext) in
                                    FEMDeserializer.collection(fromRepresentation: [arrJointVisit], mapping: PlannVisit.defaultmapping(), context: localcontext)
                                    localcontext.mr_save({ (localContext) in
                                        print("saving")
                                    }, completion: { (status, error) in
                                        if(error == nil){
                                            print("saved")
                                        }else{
                                            print(error?.localizedDescription ?? "")
                                        }
                                    })
                                }, completion: { (status, error) in
                                    if(error == nil){
                                        if ( message.count > 0 ) {
                                            Utils.toastmsg(message:message,view: self.view)
                                        }
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
                                    }
                                })
                            }else{
                                if ( message.count > 0 ) {
                                    
                                    Utils.toastmsg(message:message,view: self.view)
                                }
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
                                
                            }
                        }else{
                            if ( message.count > 0 ) {
                                
                                Utils.toastmsg(message:message,view: self.view)
                            }
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
                        if ( message.count > 0 ) {
                            Utils.toastmsg(message:message,view: self.view)
                        }
                    }
                }
            } //Joint visit
        }else if(visitType == VisitType.directvisitcheckin){
            // direct visit checkin
            if(self.setValidationForDirectVisitCheckin() == true){
                
                if(CLLocationCoordinate2DIsValid(currentlocationcoordinate) && currentlocationcoordinate.latitude != 0.0 && currentlocationcoordinate.longitude != 0.0 ) {
                    SVProgressHUD.setDefaultMaskType(.black)
                    SVProgressHUD.show()
                    var param = Common.returndefaultparameter()
                    var visitDict = [String:Any]()
                    if let selectedcustomer = self.selectedCustomer{
                        visitDict = ["VisitTypeID":NSNumber.init(value: 1),"CompanyID":activeuser?.company?.iD ?? NSNumber.init(value: 0),"CustomerID":NSNumber.init(value:selectedcustomer.iD),"NextActionID":NSNumber.init(value: 2),"OriginalNextActionID":NSNumber.init(value: 2),"AddressMasterID":addressMasterID,"CreatedBy":activeuser?.userID ?? NSNumber.init(value: 0),"SeriesPrefix":"","NextActionTime":Utils.getDate(date: Date().dateByAddingMinutes(min: 5) as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss"),/*Utils.getDateinstrwithaspectedFormat(givendate: Date().addingTimeInterval(5), format: "yyyy/MM/dd HH:mm:ss",defaultTimZone:false)*/"OriginalNextActionTime":Utils.getDate(date: Date().dateByAddingMinutes(min: 5) as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")/*Utils.getDateinstrwithaspectedFormat(givendate: Date().addingTimeInterval(5), format: "yyyy/MM/dd HH:mm:ss",defaultTimZone:false)*/] as [String : Any]
                    }else if let selectedcustomer = self.selectedTempCustomer {
                        visitDict = ["VisitTypeID":NSNumber.init(value: 1),"CompanyID":activeuser?.company?.iD ?? NSNumber.init(value: 0),"CustomerID":NSNumber.init(value:selectedcustomer.iD),"NextActionID":NSNumber.init(value: 2),"OriginalNextActionID":NSNumber.init(value: 2),"AddressMasterID":addressMasterID,"CreatedBy":activeuser?.userID ?? NSNumber.init(value: 0),"SeriesPrefix":"","NextActionTime":Utils.getDate(date: Date().dateByAddingMinutes(min: 5) as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss"),/*Utils.getDateinstrwithaspectedFormat(givendate: Date().addingTimeInterval(5), format: "yyyy/MM/dd HH:mm:ss",defaultTimZone:false)*/"OriginalNextActionTime":Utils.getDate(date: Date().dateByAddingMinutes(min: 5) as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")] as [String : Any]
                    }
                    else{
                        SVProgressHUD.dismiss()
                        Utils.toastmsg(message:"Please select Customer",view: self.view)
                        return
                    }
                    visitDict["OriginalAssignee"] = NSNumber.init(value: originalAssignee)
                    param["addUpdateVisitProductJson"] = Common.json(from: [[String:Any]]())
                    param["addUpdateVisitJson"] = Common.json(from: visitDict)
                    
                    self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddEditPlannedVisit, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                        
                        if(error.code == 0){
                            print(message)
                            if (message.count > 0 ) {
                                Utils.toastmsg(message:message,view: self.view)
                            }
                            print(responseType)
                            if(responseType ==  ResponseType.dic){
                                var newVisitID = NSNumber.init(value: 0)
                                var dicVisit = arr as? [String:Any] ?? [String:Any]()
                                
                                newVisitID =  NSNumber.init(value:dicVisit["ID"] as? Int ?? 0)
                                
                                let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: dicVisit["CustomerID"] as? Int ?? 0))
                                if(strCustomerName.count == 0){
                                    dicVisit["CustomerName"] = "Customer Not Mapped"
                                }else{
                                    dicVisit["CustomerName"] = strCustomerName
                                }
                                let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
                                if(reassignedId > 0){
                                    
                                    if      let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId )){
                                        let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                                        dicVisit["RessigneeName"] = reassignUserName
                                    }else{
                                        dicVisit["RessigneeName"] = ""
                                    }
                                }else{
                                    dicVisit["RessigneeName"] = ""
                                }
                                print(dicVisit)
                                MagicalRecord.save({ (localContext) in
                                    let arr = FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                        localContext.mr_save({ (localContext) in
                                            localContext.mr_saveToPersistentStoreAndWait()
                                            print("saving")
                                        }, completion: { (status, error) in
                                            print("saved")
                                            //                var visitid = NSNumber.init(value: 0)
                                            //                if let visit = PlannVisit.getAll().last{
                                            //        visitid = NSNumber.init(value:visit.iD)
                                            //    }
                                            if(arr.count > 0){
                                                
                                                if(error == nil){
                                                    DispatchQueue.main.async {
                                                        if let lastvisit = PlannVisit.getVisit(visitID: newVisitID){
                                                            print("visit id of direct checkin visit  = \(newVisitID)")
                                                            SVProgressHUD.dismiss()
                                                            if let lastplanvisit = lastvisit  as? PlannVisit{
                                                                VisitCheckinCheckout.verifyAddress = false
                                                                VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: self.currentlocationcoordinate.latitude) ,long:NSNumber.init(value:self.currentlocationcoordinate.longitude),isVisitPlanned:VisitType.directvisitcheckin, objplannedVisit:lastplanvisit , objunplannedVisit: UnplannedVisit(), visitid: newVisitID,viewcontroller:self,addressID:self.addressMasterID);
                                                            }
                                                        }else{
                                                            Utils.toastmsg(message: error?.localizedDescription ?? "", view: self.view)
                                                            //VisitCheckinCheckout().checkin(visitstatus:0,lat:NSNumber.init(value: self.currentlocationcoordinate.latitude) ,long:NSNumber.init(value:self.currentlocationcoordinate.longitude),isVisitPlanned:VisitType.directvisitcheckin, objplannedVisit: PlannVisit.getAll().last as? PlannVisit ?? PlannVisit() , objunplannedVisit: UnplannedVisit(), visitid: newVisitID,viewcontroller:self,addressID:self.addressMasterID);
                                                            
                                                        }
                                                    }
                                                }else{
                                                    Utils.toastmsg(message: error?.localizedDescription ?? "", view: self.view)
                                                }
                                            }
                                        })
                                        
                                        localContext.mr_saveToPersistentStoreAndWait()
                                        
                                    })
                                    // FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping())
                                    
                                }, completion: { (contextdidsave, error) in
                                    print("visit saved")
                                    
                                    
                                    print(error?.localizedDescription ?? "")
                                    
                                })
                                
                            }
                        }else{
                            
                            if ( message.count > 0 ) {
                                Utils.toastmsg(message:message,view: self.view)
                            }
                        }
                    }
                }else{
                    let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                    let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                        
                    }
                    Common.showalert(title: NSLocalizedString("location_services_disabled", comment:""), msg: NSLocalizedString("please_enable_location_services_in_settings", comment:""), yesAction: settingAction, noAction: cancelAction,view:self)
                }
            }
        }
    }
}
// MARK: UITextField
extension AddJoinVisitViewController:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfCustomerName){
            if(visitType == VisitType.joinvisit){
                
                
                
                
                
                arrOfLowerLevelExecutive = BaseViewController.staticlowerUser
                
                //                arrOfLowerLevelExecutive = BaseViewController.staticlowerUser.filter{
                //                    $0 !=  self.activeuser
                //                }
                arrOfLowerLevelExecutive = BaseViewController.staticlowerUser.filter({ (user) -> Bool in
                    
                    var activuserid = NSNumber.init(value:0)
                    if let activseuserID = self.activeuser?.userID{
                        activuserid =  activseuserID
                    }
                    
                    return user.entity_id != activuserid
                })
                
                
                if(arrOfSelectedExecutive.count == 0 ){
                    if(arrOfLowerLevelExecutive.count > 0){
                        arrOfSelectedExecutive =       [arrOfLowerLevelExecutive.first ?? CompanyUsers()]
                    }else{
                        arrOfSelectedExecutive = [CompanyUsers]()
                    }
                }
                
                popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                popup?.selectionmode =  SelectionMode.single
                popup?.modalPresentationStyle = .overCurrentContext
                popup?.nonmandatorydelegate = self
                popup?.strTitle = "Select User"
                popup?.strRightTitle = "Cancel"
                popup?.strLeftTitle = "Ok"
                popup?.arrOfExecutive = arrOfLowerLevelExecutive
                popup?.arrOfSelectedExecutive = arrOfSelectedExecutive//[CompanyUsers]()
                popup?.isFilterRequire = false
                popup?.isFromSalesOrder =  false
                popup?.viewfor = ViewFor.companyuser
                popup?.isSearchBarRequire = false
                popup?.parentViewOfPopup = self.view
                Utils.addShadow(view: self.view)
                self.present(popup!, animated: true, completion: nil)
                
            }else{
                popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                popup?.modalPresentationStyle = .overCurrentContext
                popup?.nonmandatorydelegate = self
                popup?.isSearchBarRequire = true
                popup?.viewfor = ViewFor.customer
                popup?.strTitle = ""
                popup?.isFromSalesOrder =  false
                popup?.arrOfList = arrOfCustomers
                popup?.arrOfSelectedSingleCustomer = [CustomerDetails]()
                popup?.selectionmode = SelectionMode.none
                // popup?.selectedIndexPaths = [IndexPath]()
                popup?.isFilterRequire = false
                popup?.strLeftTitle = "REFRESH"
                popup?.parentViewOfPopup = self.view
                Utils.addShadow(view: self.view)
                self.present(popup!, animated: true, completion: nil)
                
            }
            return false
        }
        else if(textField == tfMeetingType){
            if  let meetingTypeList = Common.returnclassviewcontroller(storybordname:Constant.StoryboardNamePopUp , classname: "productselection") as? ProductNameList
            {
                //            self.view.backgroundColor = UIColor.black
                //            self.view.alpha = 0.7
                meetingTypeList.modalPresentationStyle = .overCurrentContext
                meetingTypeList.delegate = self
                meetingTypeList.strTitle = "Metting Type"
                meetingTypeList.isDisplayName = true
                meetingTypeList.arrOfName = ["Negotiation","Demo","Courtesy Call","Collection","Dispute Resolution","Service Issues","Others"]
                meetingTypeList.isSearchRequire = false
                self.present(meetingTypeList, animated: true, completion: nil)
            }
            return false
        }
        else if(textField == tfDate){
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            datepicker.datePickerMode = .date
            if let strdate = tfDate.text as? String{
                if let strcheckintime = tfCheckInTime as? String{
                    if let strcheckouttime = tfCheckOutTime as? String{
                        let strcheckin = String.init(format: "\(strdate) \(strcheckintime)")
                        let strcheckout = String.init(format: "\(strdate) \(strcheckouttime)")
                        self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
                        checkindate = self.dateFormatter.date(from: strcheckin)
                        checkoutdate =  self.dateFormatter.date(from: strcheckout)
                        datepicker.date =  checkindate
                    }
                }
                
            }
            
            
            // datepicker.date = self.dateFormatter.date(from: tfDate.text!)!
            return true
        }else if(textField == tfCheckInTime){
            self.dateFormatter.dateFormat = "hh:mm a"
            datepicker.date = checkindate
            return true
        }else if(textField == tfCheckOutTime){
            
            self.dateFormatter.dateFormat = "hh:mm a"
            datepicker.date = checkoutdate
            //checkoutdatepicker.datePickerMode = .time
            //checkoutdatepicker.date = self.dateFormatter.date(from: tfCheckOutTime.text!)!
            return true
        }
        else{
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == tfDate){
            datepicker.tag = 0
            datepicker.datePickerMode = UIDatePicker.Mode.date
            // tfDate.text = self.dateFormatter.string(from: datepicker.date)
        }else if(textField == tfCheckInTime){
            datepicker.tag = 1
            datepicker.datePickerMode = UIDatePicker.Mode.time
            //datepicker.date = checkindate
            //                self.dateFormatter.dateFormat = "hh:mm a"
            //                tfCheckInTime.text = self.dateFormatter.string(from: datepicker.date)
        }else if(textField == tfCheckOutTime){
            datepicker.tag = 2
            datepicker.datePickerMode = UIDatePicker.Mode.time
            //   datepicker.date = checkoutdate
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var fullstring = ""
        if let tft = textField.text as? String{
            fullstring.append(tft)
        }
        fullstring.append(string)
        
        let trimmedstring = fullstring.trimmingCharacters(in: .whitespaces).lowercased()
        if(textField == tfSearchCustomer){
            //            filteredCustomer =
            //                arrAllCustomer.compactMap { (temp) -> CustomerDetails in
            //                    return temp
            //                    }.filter { (aUser) -> Bool in
            //
            //                        return aUser.name?.localizedCaseInsensitiveContains(searchText) == true || aUser.mobileNo?.localizedCaseInsensitiveContains(searchText) == true
            
            /*   filteredCustomer =
             arrAllCustomer.filter({(item: NSString) -> Bool in
             
             let stringMatch1 = item.contains(trimmedstring ?? "")
             
             return stringMatch1
             })
             
             arrOffilteredCustomer =
             arrOfCustomers.compactMap { (temp) -> CustomerDetails in
             return temp
             }.filter { (aUser) -> Bool in
             return aUser.name?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true || aUser.mobileNo?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true
             }
             
             
             customerDropdown.dataSource = arrOffilteredCustomer.map{
             $0.name
             } as [String]
             
             customerDropdown.reloadAllComponents()
             
             customerDropdown.show()*/
            
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfDate){
            
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            tfDate.text = self.dateFormatter.string(from: datepicker.date)
            if let strdate = tfDate.text as? String{
                if let strcheckintime = tfCheckInTime.text as? String{
                    
                    if let strcheckouttime = tfCheckOutTime.text as? String{
                        let strcheckin = String.init(format: "\(strdate) \(strcheckintime)")
                        let strcheckout = String.init(format: "\(strdate) \(strcheckouttime)")
                        self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
                        checkindate = self.dateFormatter.date(from: strcheckin)
                        checkoutdate =  self.dateFormatter.date(from: strcheckout)
                        
                        datepicker.date =  checkindate
                        print("str = \(strcheckin) , strcheckout = \(strcheckout) , date = \(checkindate) , \(checkoutdate) , \(datepicker.date)")
                    }
                }
            }
            
        }else if(textField == tfCheckInTime){
            self.dateFormatter.dateFormat = "hh:mm a"
            tfCheckInTime.text = self.dateFormatter.string(from: datepicker.date)
            if let strdate = tfDate.text as? String{
                if let strcheckintime = tfCheckInTime.text as? String{
                    
                    if let strcheckouttime = tfCheckOutTime.text as? String{
                        let strcheckin = String.init(format: "\(strdate) \(strcheckintime)")
                        let strcheckout = String.init(format: "\(strdate) \(strcheckouttime)")
                        self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
                        checkindate = self.dateFormatter.date(from: strcheckin)
                        checkoutdate =  self.dateFormatter.date(from: strcheckout)
                        datepicker.date =  checkindate
                    }
                }
            }
            //  self.dateFormatter.dateFormat = " "
            //   tfCheckInTime.text = Utils.getDateWithAppendingDay(day: 0, date: datepicker.date, format: "hh:mm a", defaultTimeZone: true)//Utils.getDateWithAppendingDayLang(day: 0, date: datepicker.date, format: "hh:mm a")
            
            
            
            /*  var strNextActionTime = ""
             if let strdate = tfDate.text{
             strNextActionTime.append(strdate)
             }
             if let strtime =  tfCheckInTime.text{
             strNextActionTime.append("  \(strtime)")
             }
             
             print(strNextActionTime)
             dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
             let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
             datePicker.date = dateNextActionTime ?? Date()*/
            /*  let strtime1 = Utils.getDateWithAppendingDayLang(day: 0, date: datepicker.date, format: "yyyy-MM-dd hh:mm a")
             let index = strtime1.index(strtime1.startIndex, offsetBy: 10)
             let time1 = strtime1[..<index]
             
             let strcheckintime1 = Utils.getDateWithAppendingDayLang(day: 0, date: checkindate, format: "yyyy-MM-dd hh:mm a")
             let sindex = strcheckintime1.index(strcheckintime1.startIndex, offsetBy: 10)
             let strchecktime1 = strcheckintime1[..<sindex]
             let strtime2 = Utils.getDateWithAppendingDayLang(day: 0, date: checkindate, format: "yyyy-MM-dd hh:mm a").replacingOccurrences(of:strchecktime1, with:time1)
             
             //let index2 = strtime2.index(strtime2.startIndex, offsetBy: 10)
             //let time2 = strtime2[..<index2]
             //self.dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
             //    let ftime2 = String.init(time2)
             self.dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
             checkindate = self.dateFormatter.date(from: strtime2)
             tfDate.text = Utils.getDate(date: checkindate as! NSDate, withFormat: "dd-MM-yyyy")//Utils.getDateWithAppendingDayLang(day: 0, date: datepicker.date, format: "dd-MM-yyyy")
             
             let strtemp1 = Utils.getDateWithAppendingDayLang(day: 0, date: checkindate, format: "yyyy-MM-dd hh:mm a")
             
             let index3 = strtemp1.index(strtime2.startIndex, offsetBy: 10)
             let temp1 = strtemp1[..<index3]
             
             let strcheckoutime1 = Utils.getDateWithAppendingDayLang(day: 0, date: checkoutdate, format: "yyyy-MM-dd hh:mm a")
             let scindex = strcheckoutime1.index(strcheckintime1.startIndex, offsetBy: 10)
             let strchoutime1 = strcheckoutime1[..<scindex]
             /** Utils.getDateWithAppendingDayLang(day: 0, date: checkindate, format: "yyyy-MM-dd hh:mm a").replacingOccurrences(of:strchecktime1, with:time1)*/
             let strtemp2 = Utils.getDateWithAppendingDayLang(day: 0, date: checkoutdate, format: "yyyy-MM-dd hh:mm a").replacingOccurrences(of:strchoutime1, with:temp1)
             self.dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
             
             checkoutdate =  self.dateFormatter.date(from: strtemp2)*/
            
        }else if(textField == tfCheckOutTime){
            self.dateFormatter.dateFormat = "hh:mm a"
            tfCheckOutTime.text = self.dateFormatter.string(from: datepicker.date)
            if let strdate = tfDate.text as? String{
                if let strcheckintime = tfCheckInTime.text as? String{
                    
                    if let strcheckouttime = tfCheckOutTime.text as? String{
                        let strcheckin = String.init(format: "\(strdate) \(strcheckintime)")
                        let strcheckout = String.init(format: "\(strdate) \(strcheckouttime)")
                        self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
                        checkindate = self.dateFormatter.date(from: strcheckin)
                        checkoutdate =  self.dateFormatter.date(from: strcheckout)
                        datepicker.date =  checkindate
                    }
                }
            }
            //dateFormatter.dateFormat = "hh:mm a"
            //  tfCheckOutTime.text =  Utils.getDateWithAppendingDay(day: 0, date: datepicker.date, format: "hh:mm a", defaultTimeZone: true)// Utils.getDateWithAppendingDayLang(day: 0, date: datepicker.date, format: "hh:mm a") //dateFormatter.string(from: checkoutdatepicker.date)
            
            /* let strtime1 = Utils.getDateWithAppendingDayLang(day: 0, date: datepicker.date, format: "yyyy-MM-dd hh:mm a")
             let index = strtime1.index(strtime1.startIndex, offsetBy: 10)
             let time1 = strtime1[..<index]
             
             let strcheckintime1 = Utils.getDateWithAppendingDayLang(day: 0, date: checkindate, format: "yyyy-MM-dd hh:mm a")
             let sindex = strcheckintime1.index(strcheckintime1.startIndex, offsetBy: 10)
             let strchecktime1 = strcheckintime1[..<sindex]
             let strtime2 = Utils.getDateWithAppendingDayLang(day: 0, date: checkindate, format: "yyyy-MM-dd hh:mm a").replacingOccurrences(of:strchecktime1, with:time1)
             
             //let index2 = strtime2.index(strtime2.startIndex, offsetBy: 10)
             //let time2 = strtime2[..<index2]
             //self.dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
             //    let ftime2 = String.init(time2)
             self.dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
             checkindate = self.dateFormatter.date(from: strtime2)
             tfDate.text = Utils.getDate(date: checkindate as! NSDate, withFormat: "dd-MM-yyyy")//Utils.getDateWithAppendingDayLang(day: 0, date: datepicker.date, format: "dd-MM-yyyy")
             
             let strtemp1 = Utils.getDateWithAppendingDayLang(day: 0, date: checkindate, format: "yyyy-MM-dd hh:mm a")
             
             let index3 = strtemp1.index(strtime2.startIndex, offsetBy: 10)
             let temp1 = strtemp1[..<index3]
             
             let strcheckoutime1 = Utils.getDateWithAppendingDayLang(day: 0, date: checkoutdate, format: "yyyy-MM-dd hh:mm a")
             let scindex = strcheckoutime1.index(strcheckintime1.startIndex, offsetBy: 10)
             let strchoutime1 = strcheckoutime1[..<scindex]
             /** Utils.getDateWithAppendingDayLang(day: 0, date: checkindate, format: "yyyy-MM-dd hh:mm a").replacingOccurrences(of:strchecktime1, with:time1)*/
             let strtemp2 = Utils.getDateWithAppendingDayLang(day: 0, date: checkoutdate, format: "yyyy-MM-dd hh:mm a").replacingOccurrences(of:strchoutime1, with:temp1)
             self.dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
             
             checkoutdate =  self.dateFormatter.date(from: strtemp2)*/
            
        }
    }
    
}
// MARK: UITextView
extension AddJoinVisitViewController:UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        addressDropdown.show()
        return false
    }
}
extension AddJoinVisitViewController:ProductSelectionPopUpDelegate{
    func completionData(arr: [Product]) {
        Utils.removeShadow(view: self.view)
        print(arr)
    }
    
    func completionNameData(arr: [String]) {
        Utils.removeShadow(view: self.view)
        //        self.view.backgroundColor = UIColor.clear
        //        self.view.alpha = 1.0
        print(arr)
    }
    
    
}
extension AddJoinVisitViewController:UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
        
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
                
                let stringMatch1 = item.contains(trimmedstring ?? "")
                
                return stringMatch1
            })
            
            arrOffilteredCustomer =
            arrOfCustomers.compactMap { (temp) -> CustomerDetails in
                return temp
            }.filter { (aUser) -> Bool in
                
                return aUser.name?.localizedCaseInsensitiveContains(trimmedstring ?? "" ) == true
            }
            
            
            customerDropdown.dataSource = filteredCustomer as [String]
            customerDropdown.reloadAllComponents()
            
            customerDropdown.show()
        }
        //self.tblCustomer.reloadData()
    }
}
extension AddJoinVisitViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblAddContact){
            return arrOfSelectedContact.count
        }else{
            return arrOfSelectedUser.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "namedisplaycell", for: indexPath) as? NameDisplay
        {
            cell.lblProductName.text = "TEST"
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
}
extension AddJoinVisitViewController:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    func menuitemTouched(item: UPStackMenuItem) {
        
    }
    
    
    
}

extension AddJoinVisitViewController:PopUpDelegateNonMandatory{
    func completionSelectedExecutive(arr: [CompanyUsers]) {
        Utils.removeShadow(view: self.view)
        if(arr.count > 0){
            
            selectedExecutive = arr[0]
            tfCustomerName.text = String.init(format: "%@ %@",  selectedExecutive.firstName , selectedExecutive.lastName)
        }
    }
    
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr.count)
        arrOfSelectedCustomer = arr
        //        if (popup?.isMultipleSelection) {
        //            customerName  = ""
        //            if(arr.count > 0){
        //                for i in 0...arr.count - 1 {
        //                    if(i == 0){
        //                        let customer = arr[i]
        //                        customerName.append(contentsOf:customer.name)
        //                    }else{
        //                        let customer = arr[i]
        //                        customerName.append(contentsOf: String.init(format: ",%@",customer.name))
        //                    }
        //                }
        //            }
        //            searchCustomer.text = customerName
        //        }else{
        
        selectedCustomer =  arr.first!
        if let selectedcustomer = selectedCustomer{
            searchCustomer.text = selectedcustomer.name
            tfCustomerName.text = selectedcustomer.name
            self.tfSearchCustomer.text = selectedcustomer.name
        }
        //  tfContactPerson.text = selectedCustomer.contactName
        
        
        self.setAddress()
        
    }
    
    
    //    func completionSelectedExecutive(arr: [CompanyUsers]) {
    //        if(arr.count > 0){
    //        selectedExecutive = arr[0]
    //        tfCustomerName.text = String.init(format: "%@ %@",  selectedExecutive.firstName , selectedExecutive.lastName)
    //        }
    //    }
    //
    //    func CompletionData(arr: [CustomerDetails]) {
    //        print(arr.count)
    //        arrOfSelectedCustomer = arr
    ////        if (popup?.isMultipleSelection) {
    ////            customerName  = ""
    ////            if(arr.count > 0){
    ////                for i in 0...arr.count - 1 {
    ////                    if(i == 0){
    ////                        let customer = arr[i]
    ////                        customerName.append(contentsOf:customer.name)
    ////                    }else{
    ////                        let customer = arr[i]
    ////                        customerName.append(contentsOf: String.init(format: ",%@",customer.name))
    ////                    }
    ////                }
    ////            }
    ////            searchCustomer.text = customerName
    ////        }else{
    //
    //            selectedCustomer =  arr.first!
    //            searchCustomer.text = selectedCustomer.name
    //        tfCustomerName.text = selectedCustomer.name
    //          //  tfContactPerson.text = selectedCustomer.contactName
    //
    //
    //            self.setAddress()
    //
    //        //}
    //    }
    //
    
}
extension AddJoinVisitViewController:AddCustomerDelegate{
    func saveCustomer(customerID: NSNumber, customerName: String, contactID: NSNumber) {
        if let addedcustomer = CustomerDetails.getCustomerByID(cid: customerID){
            arrOfCustomers =  CustomerDetails.getAllCustomers()
            
            arrAllCustomer = arrOfCustomers.map{ $0.name } as? [NSString] ?? [NSString]()
            selectedCustomer = addedcustomer
            tfCustomerName.text =  customerName
            searchCustomer.text =  customerName
            self.tfSearchCustomer.text = customerName
            if let selectedcustomer = self.selectedCustomer{
                self.arrOfSelectedCustomer.append(selectedcustomer)
                self.setAddress()
            }
        }
        
    }
    
    
}
