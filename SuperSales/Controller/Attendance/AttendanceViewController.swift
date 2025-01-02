//
//  AttendanceViewController.swift
//  SuperSales
//
//  Created by Apple on 15/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation
import LMGeocoder
import AVFoundation
import SVProgressHUD
import FastEasyMapping


class AttendanceViewController: BaseViewController {
    var strarrLocation = [String]()
    static var verifycheckinAdd:Bool!
    static var verifycheckoutAdd:Bool!
    let LocationTag = 1000
    let NameTag =  2000
    let AddressTag =  3000
    var selectedAddressID = NSNumber.init(value: 0)
    @IBOutlet var lbl2Title: UILabel!
    @IBOutlet var lbl1Title: UILabel!
    @IBOutlet var btnManualRequest: UIButton!
    @IBOutlet var btnHistory: UIButton!
    @IBOutlet var btnUpdateWorkLocation: UIButton!
    @IBOutlet var tfLocation: UITextField!
    
    
    @IBOutlet weak var btnValidAttendance: UIButton!
    
    
    static var tarvelAddress = ""
    var popup:CustomerSelection? = nil
    @IBOutlet var stkUpdateWorkLocation: UIStackView!
    
    //@IBOutlet var tvAddress: UITextView!
    
    @IBOutlet var tfAddress: UITextField!
    
    @IBOutlet var lbl3Title: UILabel!
    // @IBOutlet var tv3Value: UITextView!
    
    //  @IBOutlet weak var lblAvailability: UILabel!
    @IBOutlet var tf3Value: UITextField!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var btnCheckIn: UIButton!
    @IBOutlet var btnCheckOut: UIButton!
    var currentcoordination:CLLocationCoordinate2D?
    var locationManager:CLLocationManager = CLLocationManager()
    public static var selectedLocation:CLLocation? = CLLocation()
    public static var tfLocationTag:Int = 0
    public static var tfAddressTag:Int = 0
    //    public static var selectedAddressModel:AddressListModel!
    public static var selectedAddress:AddressInfo? = AddressInfo()
    public static var selectedAddreeList:AddressListModel = AddressListModel()
    var pickerView:UIPickerView = UIPickerView()
    public static var arrType:[AttendanceLocation] = [AttendanceLocation]()
    var currentCompany:Company!
    var arrCustomerList:[CustomerDetails] = [CustomerDetails]()
    var arrVendorList:[Vendor] = [Vendor]()
    var mutaddressBoth:[AddressInfo] = [AddressInfo]()
    var mutAddressOffice:[AddressInfo] = [AddressInfo]()
    var mutAddressBranch:[AddressInfo] = [AddressInfo]()
    var selectedArrOfAddress:[AddressInfo] = [AddressInfo]()
    var dropdownLocation = DropDown()
    var dropdownAddress = DropDown()
    var dropdownCustomerVendor = DropDown()
    var isCheckIn:Bool = false
    var isSelefieAvailbale  = false
    
    public static var arrOfSelectedMultipleCustomer:[CustomerDetails] = [CustomerDetails]()
    public static var arrOfSelectedVendor:[Vendor] = [Vendor]()
    var selfieImage:UIImage?
    var strCurrentAddress:String! = " "
    var btnCheckinClicked = true
    //MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(forName: Notification.Name("UpdateAsperDefaultData"), object: nil, queue: OperationQueue.main) { (notify) in
            
            self.updateAsPerDefaultData()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UpdateAsperDefaultData"), object: nil)
    }
    
    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            super.viewDidLoad()
            self.setUI()
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(self.activesetting.requiredValidAttendance == NSNumber.init(value: 1)){
            btnValidAttendance.isHidden = false
        }else{
            btnValidAttendance.isHidden = true
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
    //MARK: - API Call
    func loadDefaultSetting(){
        var param =  Common.returndefaultparameter()
        param["Type"] = "default"
        param["MemberID"] = self.activeuser?.userID
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetDefaultSetting, method: Apicallmethod.get){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
                let dic = arr as? [String:Any] ?? [String:Any]()
                Utils.setDefultvalue(key: Constant.kUserDefault, value: dic)
                let dicdefaultSetting = Utils.getDefaultDicValue(key: Constant.kUserDefault)
                if(dicdefaultSetting.keys.count > 0){
                    let dsettingModel = DefaultSettingModel().getdefaultSettingModelWithDic(dict: dicdefaultSetting)
                    AttendanceCheckInCheckOut.defaultsetting = dsettingModel
                    self.fillData()
                    
                }else{
                    //self.loadDefaultSetting()
                    self.fillData()
                }
                /*MagicalRecord.save({ (localcontext) in
                 DefaultSetting.mr_truncateAll(in: localcontext)
                 let arr =  FEMDeserializer.collection(fromRepresentation: [dic], mapping: DefaultSetting.defaultMapping(), context: localcontext)
                 
                 }) { (status, error) in
                 if(error == nil){
                 print("setting saved")
                 }
                 }*/
            }else if(error.code == 0){
                self.dismiss(animated: true, completion: nil)
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                }
            }else{
                self.dismiss(animated: true, completion: nil)
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
    }
    //MARK: - Method
    
    func setUI(){
        
        
        tfLocation.setCommonFeature()
        tfAddress.setCommonFeature()
        tf3Value.setCommonFeature()
        
        
        lblAddress.setMultilineLabel(lbl: lblAddress)
        lbl3Title.isHidden = true
        tf3Value.isHidden = true
        
        currentcoordination = Location.sharedInsatnce.getCurrentCoordinate()
        
        tfLocation.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tfAddress.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        tf3Value.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        
        
        
        
        let arrCompany = Company.getAll()
        AttendanceViewController.arrType = [AttendanceLocation]()
        if(arrCompany.count > 0){
            if let  currentCompany1 = Company.getCompanyByID(companyID: self.activeuser?.companyID ?? 0){
                currentCompany = currentCompany1
            }
            //arrCompany.first
            
            if(currentCompany?.officeType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:0),"Location":"Office"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
            
            if(currentCompany?.homeType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:1),"Location":"Home"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
            
            if(currentCompany?.travelLocalType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:2),"Location":"Travel Local"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
            
            if(currentCompany?.travelUpCountryType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:3),"Location":"Travel Upcountry"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
            
            if(currentCompany?.vendorType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:4),"Location":"Vendor"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
            
            if(currentCompany?.customerType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:5),"Location":"Customer"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
        }
        arrCustomerList = CustomerDetails.getAllCustomers()
        arrVendorList = Vendor.getAll()
        self.checkInButtonGreen()
        // self.updateDate()
        LMGeocoder.sharedInstance().googleAPIKey =  Constant.GOOGLE_MAPS_PLACES_API
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.distanceFilter = 100
        
        //if(self.locationManager.responds(to: #selector(requestWhenInUseAuthorization))){
        self.locationManager.requestWhenInUseAuthorization()
        //}
        self.locationManager.startUpdatingLocation()
        
        if(self.activesetting.addressSettingsForAttendance == 1){
            btnUpdateWorkLocation.isHidden = false
            stkUpdateWorkLocation.isHidden = false
            
        }else {
            //if(self.activesetting.addressSettingsForAttendance? == 2
            btnUpdateWorkLocation.isHidden = true
            stkUpdateWorkLocation.isHidden = true
        }
        
        //set address
        mutAddressOffice.removeAll()
        if (self.activeuser?.company?.addressList?.count ?? 0 > 0){
            mutAddressOffice =  self.activeuser?.company?.addressList ?? [AddressInfo]()
        }
        
        if let branchaddress = self.activeuser?.branchAddress as? AddressInfo{
            mutAddressBranch =  [branchaddress]
        }else{
            mutAddressBranch = mutAddressOffice
        }
        
        mutaddressBoth = self.activeuser?.company?.addressList ?? [AddressInfo]()
        if let branchadd = self.activeuser?.branchAddress as? AddressInfo{
            mutaddressBoth.append(branchadd)
        }
        
        
        
        if(self.activeuser?.role?.id == 7){
            if(self.activesetting.managerApplyManualAttendance == 1){
                btnManualRequest.isHidden = false
            }else{
                btnManualRequest.isHidden = true
            }
        }else if(self.activeuser?.role?.id == 8){
            if(self.activesetting.salesExecutiveApplyManualAttendance == 1){
                btnManualRequest.isHidden = false
            }else{
                btnManualRequest.isHidden = true
            }
        }else if(self.activeuser?.role?.id == 9){
            if(self.activesetting.salesRepresantativeApplyManualAttendance == 1){
                btnManualRequest.isHidden = false
            }else{
                btnManualRequest.isHidden = true
            }
        }
        
        tfLocation.delegate = self
        tfAddress.delegate = self
        tf3Value.delegate = self
        
        let dicdefaultSetting = Utils.getDefaultDicValue(key: Constant.kUserDefault)
        if(dicdefaultSetting.keys.count > 0){
            let dsettingModel = DefaultSettingModel().getdefaultSettingModelWithDic(dict: dicdefaultSetting)
            AttendanceCheckInCheckOut.defaultsetting = dsettingModel
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.fillData()
            // })
        }else{
            self.loadDefaultSetting()
        }
        
    }
    
    func updateAsPerDefaultData(){
        
        let dicdefaultSetting = Utils.getDefaultDicValue(key: Constant.kUserDefault)
        if(dicdefaultSetting.keys.count > 0){
            let dsettingModel = DefaultSettingModel().getdefaultSettingModelWithDic(dict: dicdefaultSetting)
            AttendanceCheckInCheckOut.defaultsetting = dsettingModel
            print("type of location = \(AttendanceViewController.arrType)")
            self.fillData()
            
        }else{
            //self.loadDefaultSetting()
        }
    }
    
    func updateAddresslabel(){
        self.lblAddress.isHidden  = false
        if let slocation = AttendanceViewController.selectedLocation{
            if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                self.lblAddress.text  = "You are ready to check-in or check-out"
                
            }else{
                self.lblAddress.text  = "You are not at above location OR your location may be not updated. Please refresh location."
            }
        }else{
            self.lblAddress.text  = ""
        }
    }
    
    func fillData(){
        
        let arrCompany = Company.getAll()
        AttendanceViewController.arrType = [AttendanceLocation]()
        if(arrCompany.count > 0){
            currentCompany =  arrCompany.first
            
            if(currentCompany?.officeType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:0),"Location":"Office"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
            
            if(currentCompany?.homeType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:1),"Location":"Home"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
            
            if(currentCompany?.travelLocalType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:2),"Location":"Travel Local"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
            
            if(currentCompany?.travelUpCountryType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:3),"Location":"Travel Upcountry"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
            
            if(currentCompany?.vendorType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:4),"Location":"Vendor"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
            
            if(currentCompany?.customerType?.intValue  == 1){
                let dic = ["key":NSNumber.init(value:5),"Location":"Customer"] as [String : Any]
                let atl = AttendanceLocation().initWithDic(dic: dic)
                AttendanceViewController.arrType.append(atl)
            }
        }
        strarrLocation = AttendanceViewController.arrType.map{
            $0.location
        }
        
        let arrKey = AttendanceViewController.arrType.map{
            $0.key
        }
        let dsetting = AttendanceCheckInCheckOut.defaultsetting
        
        if let address = dsetting?.clientAddress as? AddressListModel{
            
            if let locationType = dsetting?.locationType as? NSNumber{
                self.setAddressAsPerLocationSelection(locationID: locationType.intValue)
                if(locationType ==  NSNumber.init(value: 1)){
                    tfLocation.text = "Office"
                    
                    
                    
                    
                }else if(locationType ==  NSNumber.init(value: 2)){
                    if(!(Utils.isCustomerMapped(cid: dsetting?.clientvendorid ?? NSNumber.init(value:0)))){
                        tfLocation.text = "Office"
                        
                        
                        return
                    }
                    tfLocation.text = "Customer"
                    
                    tfAddress.text = dsetting?.clientName
                    if let customer = CustomerDetails.getCustomerByID(cid: dsetting?.clientvendorid ?? NSNumber.init(value: 0)) as? CustomerDetails{
                        let arrOfCust = [customer] as? [CustomerDetails] ?? [CustomerDetails]()
                        AttendanceViewController.arrOfSelectedMultipleCustomer = arrOfCust
                    }else{
                        let arrOfCust = [arrCustomerList.first] as? [CustomerDetails] ?? [CustomerDetails]()
                        AttendanceViewController.arrOfSelectedMultipleCustomer = arrOfCust
                    }
                    
                    //  tfLocation.tag = self.
                    
                }else if(locationType ==  NSNumber.init(value: 3)){
                    if(self.arrVendorList.count == 0){
                        
                        let setting =      AttendanceCheckInCheckOut.defaultsetting
                        setting?.locationType = NSNumber.init(value:1)
                        
                        
                        var setting1  =  Utils.getDefaultDicValue(key: Constant.kUserDefault)
                        
                        
                        tfLocation.text = "Office"
                        self.fillData()
                        return
                    }
                    tfLocation.text = "Vendor"
                    if let vendorid = dsetting?.clientvendorid{
                        let vendor = Vendor().getVendorById(aId: vendorid)
                        let arrOfVendor = [vendor] as? [Vendor] ?? [Vendor]()
                        AttendanceViewController.arrOfSelectedVendor =  arrOfVendor
                    }else{
                        let arrOfVendor = [arrVendorList.first] as? [Vendor] ?? [Vendor]()
                        AttendanceViewController.arrOfSelectedVendor = arrOfVendor
                    }
                    
                    AttendanceViewController.selectedAddreeList =  address
                    
                    let floatlat = Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                    
                    let floatlong = Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                    
                    let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                    AttendanceViewController.selectedLocation = location
                    tfAddress.text = dsetting?.clientName
                    // tf3Value.text = String.init(format:"\(AttendanceViewController.selectedAddreeList.addressLine1)")
                    var strAdd = ""
                    if let stradd1 = AttendanceViewController.selectedAddreeList.addressLine1{
                        strAdd.append(stradd1)
                    }
                    if let stradd2 = AttendanceViewController.selectedAddreeList.addressLine2{
                        strAdd.append(stradd2)
                    }
                    if let strAddCity = AttendanceViewController.selectedAddreeList.city{
                        strAdd.append(strAddCity)
                    }
                    if let strAddState = AttendanceViewController.selectedAddreeList.state{
                        strAdd.append(strAddState)
                    }
                    if let strAddCountry = AttendanceViewController.selectedAddreeList.country{
                        strAdd.append(strAddCountry)
                    }
                    tf3Value.text = strAdd
                    tfAddress.tag = self.getVendorIndex(vendorId: dsetting?.clientvendorid.intValue ?? 0)
                    AttendanceViewController.tfAddressTag = tfAddress.tag
                    let vendor = self.arrVendorList[tfAddress.tag]
                    tf3Value.tag = self.getAddressFromVendor(ven: vendor, addressId: dsetting?.addressID as! NSInteger)
                    self.showTextField()
                }
                if (locationType == NSNumber.init(value:4)){
                    tfLocation.text = "Travel Local"
                    
                    
                    lbl2Title.isHidden = true
                    lbl3Title.isHidden = true
                    tf3Value.isHidden = true
                    tfAddress.isHidden = true
                    
                }
                
                if (locationType == NSNumber.init(value:7)){
                    tfLocation.text = "Travel Upcountry"
                    
                    
                    lbl2Title.isHidden = true
                    lbl3Title.isHidden = true
                    tf3Value.isHidden = true
                    tfAddress.isHidden = true
                    
                }
                
                if (locationType == NSNumber.init(value:8)){
                    tfLocation.text = "Home"
                    
                    
                    lbl2Title.isHidden = true
                    lbl3Title.isHidden = true
                    tf3Value.isHidden = true
                    tfAddress.isHidden = true
                    
                    
                    if(self.activeuser?.isCheckInAllowedFromHome == false){
                        tfAddress.isHidden = true
                        
                        
                        if(strarrLocation.contains("Home")){
                            Common.showalert(msg: "You are not authorized for Home location Check-In or Check-Out", view: self)
                        }
                        
                        print("types of location  in fill data = \(AttendanceViewController.arrType)")
                        if(strarrLocation.count > 0){
                            if(self.strarrLocation.contains("Office")){
                                self.tfLocation.text = "Office"
                                //                            if(self.activesetting.addressSettingsForAttendance ==  1 ){
                                //                                    self.dropdownAddress.dataSource = self.mutAddressOffice.map({
                                //                                                   ($0.addressString())
                                //                                               })
                                //                                self.selectedArrOfAddress = self.mutAddressOffice
                                //                                                print(self.mutAddressOffice.first?.lat)
                                //                                           }else if(self.activesetting.addressSettingsForAttendance ==  2){
                                //                                               self.dropdownAddress.dataSource = self.mutAddressBranch.map({
                                //                                                   ($0.addressString())
                                //                                               })
                                //                                            self.selectedArrOfAddress = self.mutAddressBranch
                                //                                            print(self.mutAddressBranch.first?.lat)
                                //                                           }else{
                                //                                               self.dropdownAddress.dataSource = self.mutaddressBoth.map({
                                //                                                   ($0.addressString())
                                //                                               })
                                //                                            self.selectedArrOfAddress = self.mutaddressBoth
                                //                                            print(self.mutaddressBoth.first?.lat)
                                //                                               }
                            }else if(self.strarrLocation[0] == "Home" && self.strarrLocation.count > 1){
                                self.tfLocation.text = self.strarrLocation[1]
                                
                            }else{
                                self.tfLocation.text = self.strarrLocation[0]
                            }
                            self.updateDataAsperLocation(location: self.tfLocation.text ?? "")
                        }
                        
                    }else{
                        tfAddress.isHidden = false
                        
                        tfAddress.text = self.activeuser?.permanentAddress?.addressString()
                        selectedAddressID = NSNumber.init(value:self.activeuser?.permanentAddress?.address_id ?? 0)
                        AttendanceViewController.selectedAddreeList =  AddressListModel().getaddressListModelWithDic(dict: self.activeuser?.permanentAddress?.toDictionary() ?? [String:Any]())//self.activeuser?.permanentAddress
                        
                        let floatlat = Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                        
                        let floatlong = Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                        
                        let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                        AttendanceViewController.selectedLocation = location
                        self.hideTextField()
                    }
                }
                
                let arrLocation  = AttendanceViewController.arrType.map { (location) in
                    return location.location
                }
                if(!(arrLocation.contains(tfLocation.text))){
                    if(arrLocation.count > 0){
                        if((arrKey.contains(NSNumber.init(value:1))) && (self.activeuser?.isCheckInAllowedFromHome == false)){
                            if(arrKey.contains(NSNumber.init(value: 1))){
                                Common.showalert(msg: "You are not authorized for Home location Check-In or Check-Out", view: self)
                            }
                            if((AttendanceViewController.arrType.count > 1) && (arrKey.first == NSNumber.init(value:1))){
                                
                                
                                tfLocation.text = strarrLocation.first as! String
                                
                                
                                
                                
                                
                            }else if(AttendanceViewController.arrType.count > 1){
                                
                                tfAddress.isHidden = true
                                
                                
                                tfLocation.text = strarrLocation.first as! String
                                let firstkey = AttendanceViewController.arrType.first?.key ?? 1
                                
                                
                            }
                        }else{
                            tfLocation.text = strarrLocation.first as! String
                            
                            
                            if((tfLocation.text?.lowercased() == "office")||(tfLocation.text?.lowercased() == "home")||(tfLocation.text?.lowercased() == "vendor")||(tfLocation.text?.lowercased() == "customer")){
                                self.hideTextField()
                            }else{
                                lbl2Title.isHidden = true
                                lbl3Title.isHidden = true
                                tfAddress.isHidden = true
                                tf3Value.isHidden = true
                                
                            }
                        }
                        AttendanceViewController.tfLocationTag = 0
                        tfLocation.tag = 0
                        
                        
                        if(tfLocation.text?.lowercased() == "office"){
                            //check setting
                            if(self.activesetting.addressSettingsForAttendance == 1){
                                AttendanceViewController.selectedAddress = self.activeuser?.company?.addressList?[0]
                                if  let custAddress = self.activeuser?.company?.addressList?[0] as? AddressList{
                                    let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                                    AttendanceViewController.selectedAddreeList = addModel
                                }
                                let latdouble = address.lattitude as? Double ?? 0.00
                                let longdouble = address.longitude as? Double ?? 0.00
                                AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                                tfAddress.text = AttendanceViewController.selectedAddress?.addressString()
                                selectedAddressID = NSNumber.init(value:AttendanceViewController.selectedAddress?.address_id ?? 0)
                            }else if(self.activesetting.addressSettingsForAttendance == 2){
                                //set branch address
                                if(self.activeuser?.branchAddress != nil){
                                    AttendanceViewController.selectedAddress =  self.activeuser?.branchAddress
                                    if  let custAddress = self.activeuser?.branchAddress as? AddressList{
                                        let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                                        AttendanceViewController.selectedAddreeList = addModel
                                    }
                                    let latdouble = address.lattitude as? Double ?? 0.00
                                    let longdouble = address.longitude as? Double ?? 0.00
                                    AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                                    if(AttendanceViewController.selectedAddress?.addressString().count ?? 0 > 0){
                                        tfAddress.text = AttendanceViewController.selectedAddress?.addressString()
                                        selectedAddressID = NSNumber.init(value:AttendanceViewController.selectedAddress?.address_id ?? 0)
                                    }else{
                                        tfAddress.text = String.init(format:"\(AttendanceViewController.selectedAddress?.addressLine1),\(AttendanceViewController.selectedAddress?.addressLine2),\(AttendanceViewController.selectedAddress?.city),\(AttendanceViewController.selectedAddress?.state),\(AttendanceViewController.selectedAddress?.country)")
                                        selectedAddressID = NSNumber.init(value:AttendanceViewController.selectedAddress?.address_id ?? 0)
                                    }
                                }else{
                                    
                                    AttendanceViewController.selectedAddress = self.activeuser?.company?.addressList?[0]
                                    if  let custAddress = self.activeuser?.company?.addressList?[0] as? AddressList{
                                        let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                                        AttendanceViewController.selectedAddreeList = addModel
                                    }
                                    if  let custAddress = self.activeuser?.company?.addressList?[0] as? AddressList{
                                        let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                                        AttendanceViewController.selectedAddreeList = addModel
                                        let latdouble = address.lattitude as? Double ?? 0.00
                                        let longdouble = address.longitude as? Double ?? 0.00
                                        AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                                    }
                                    tfAddress.text = AttendanceViewController.selectedAddress?.addressString()
                                    selectedAddressID = NSNumber.init(value:AttendanceViewController.selectedAddress?.address_id ?? 0)
                                    
                                }
                            }else{
                                
                                let custAddress = mutaddressBoth[0] as? AddressList ?? AddressList()
                                let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                                AttendanceViewController.selectedAddreeList = addModel
                                
                                AttendanceViewController.selectedLocation = CLLocation.init(latitude: CLLocationDegrees.init(custAddress.lattitude.toDouble() ?? 000000), longitude: CLLocationDegrees.init(custAddress.longitude.toDouble() ?? 0000000))
                                //CLLocation.init(latitude:custAddress.lattitude , longitude:custAddress.longitude)
                                //CLLocation.init(latitude: CLLocationDegrees.init(custAddress.lattitude.toDouble() ?? 000000), longitude: CLLocationDegrees.init(custAddress.longitude?.toDouble() ?? 0000000))
                                
                                if(AttendanceViewController.selectedAddress?.addressString().count ?? 0 > 0){
                                    tfAddress.text = AttendanceViewController.selectedAddress?.addressString()
                                    selectedAddressID = NSNumber.init(value:AttendanceViewController.selectedAddress?.address_id ?? 0)
                                }else{
                                    tfAddress.text = String.init(format:"\(AttendanceViewController.selectedAddress?.addressLine1),\(AttendanceViewController.selectedAddress?.addressLine2),\(AttendanceViewController.selectedAddress?.city),\(AttendanceViewController.selectedAddress?.state),\(AttendanceViewController.selectedAddress?.country)")
                                    selectedAddressID = NSNumber.init(value:AttendanceViewController.selectedAddress?.address_id ?? 0)
                                }
                            }
                            self.hideTextField()
                        }else if(tfLocation.text?.lowercased() == "customer"){
                            if(self.arrCustomerList.count > 0 ){
                                let customer = self.arrCustomerList[0]
                                let custAddress = customer.addressList[0] as? AddressList ?? AddressList()
                                let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                                AttendanceViewController.selectedAddreeList = addModel
                                let latdouble = AttendanceViewController.selectedAddreeList.lattitude as? Double ?? 0.00
                                let longdouble = AttendanceViewController.selectedAddreeList.longitude as? Double ?? 0.00
                                AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                                tfAddress.text = customer.name
                                //    tf3Value.text = String.init(format:"\(AttendanceViewController.selectedAddreeList.addressLine1),\(AttendanceViewController.selectedAddreeList.addressLine2),\(AttendanceViewController.selectedAddreeList.city),\(AttendanceViewController.selectedAddreeList.state),\(AttendanceViewController.selectedAddreeList.country)")
                                var strAdd = ""
                                if let stradd1 = AttendanceViewController.selectedAddreeList.addressLine1{
                                    strAdd.append(stradd1)
                                }
                                if let stradd2 = AttendanceViewController.selectedAddreeList.addressLine2{
                                    strAdd.append(stradd2)
                                }
                                if let strAddCity = AttendanceViewController.selectedAddreeList.city{
                                    strAdd.append(strAddCity)
                                }
                                if let strAddState = AttendanceViewController.selectedAddreeList.state{
                                    strAdd.append(strAddState)
                                }
                                if let strAddCountry = AttendanceViewController.selectedAddreeList.country{
                                    strAdd.append(strAddCountry)
                                }
                                tf3Value.text = strAdd
                                // tfAddress.tag =
                                tf3Value.tag = 0
                                self.showTextField()
                            }
                            
                        }else if(tfLocation.text?.lowercased() == "vendor"){
                            if(self.arrVendorList.count > 0){
                                let vendor = self.arrVendorList[0]
                                //  selectedAddreeList = vendor.addressList[0] as! AddressList
                                
                                let floatlat = Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                                
                                let floatlong = Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                                
                                let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                                AttendanceViewController.selectedLocation = location
                                
                                // CLLocation.init(latitude: Double(selectedAddress?.lat ?? 0.00), longitude: Double(selectedAddress?.lng ?? 0.00))
                                tfLocation.text = vendor.name
                                tfAddress.text = String.init(format:"\(AttendanceViewController.selectedAddreeList.addressLine1),\(AttendanceViewController.selectedAddreeList.addressLine2),\(AttendanceViewController.selectedAddreeList.city),\(AttendanceViewController.selectedAddreeList.state),\(AttendanceViewController.selectedAddreeList.country)")
                                
                                selectedAddressID = AttendanceViewController.selectedAddreeList.addressId
                                tfAddress.tag = 0
                                AttendanceViewController.tfAddressTag = 0
                                //  tfLocation.tag = index
                                self.showTextField()
                            }
                            
                            
                            
                        }else if(tfLocation.text?.lowercased() == "home"){
                            tfAddress.text = self.activeuser?.permanentAddress?.addressString()
                            selectedAddressID = NSNumber.init(value:self.activeuser?.permanentAddress?.address_id ?? 0)
                            self.hideTextField()
                            
                        }
                    }
                }
                else{
                    AttendanceViewController.tfLocationTag = 0
                    tfLocation.tag = 0
                    for loc in 0...AttendanceViewController.arrType.count - 1 {
                        let temploc = AttendanceViewController.arrType[loc]
                        if(tfLocation.text == temploc.location){
                            AttendanceViewController.tfLocationTag = loc
                            tfLocation.tag = loc
                        }
                    }
                    
                }
            }
        }
        self.initDropDown()
        if((tfLocation.text?.lowercased() == "travel local")||(tfLocation.text?.lowercased() == "travel upcountry")){
            print("current Address = \(self.strCurrentAddress)")
            self.lblAddress.text = self.strCurrentAddress
            AttendanceViewController.tarvelAddress = self.strCurrentAddress
        }else{
            self.setVisibility()
        }
    }
    /*  if let dsetting = DefaultSetting.getDefaultSetting() as? DefaultSetting{
     if let address = dsetting.clientaddress  as? AddressList{
     if(dsetting.location_type ==  NSNumber.init(value: 1)){
     tfLocation.text = "Office"
     
     let setting = self.activesetting
     if((setting.addressSettingsForAttendance == NSNumber.init(value:1)) || (setting.addressSettingsForAttendance == NSNumber.init(value:3)) || (self.activeuser?.branchAddress ==  nil)){
     if(address != nil){
     
     selectedAddreeList =  address
     AttendanceViewController.selectedLocation = CLLocation.init(latitude: address.lattitude, longitude: address.longitude)
     
     tfAddress.text = String.init(format:"\(address.addressLine1) , \(address.addressLine2) , \(address.city) , \(address.state), \(address.country)",[])
     
     tfAddress.tag = self.getAddressIndex(addressId: Int(address.addressID ?? 0))
     }else{
     if(self.activeuser?.company?.addressList?.count ?? 0 > 0){
     let add = self.activeuser?.company?.addressList?[0]
     selectedAddress = add
     AttendanceViewController.selectedLocation =  CLLocation.init(latitude: Double(add?.lat ?? 0.00), longitude: Double(add?.lng ?? 0.00))
     tfAddress.text = add?.addressString()
     tfAddress.tag = self.getAddressIndex(addressId: add?.address_id ?? 0)
     }
     }
     
     }
     else{
     let address = self.activeuser?.branchAddress
     selectedAddress =  address
     AttendanceViewController.selectedLocation = CLLocation.init(latitude: Double(address?.lat ?? 0.00), longitude: Double(address?.lng ?? 0.00))
     if(address?.addressString().count ?? 0 > 0){
     tfAddress.text = address?.addressString()
     }else{
     tfAddress.text =         String.init(format:"\(address?.addressLine1),\(address?.addressLine2),\(address?.city),\(address?.country)")
     }
     }
     self.hideTextField()
     
     }else if(dsetting.location_type ==  NSNumber.init(value: 2)){
     if(!(Utils.isCustomerMapped(cid: dsetting.clientvendorid))){
     tfLocation.text = "Office"
     
     
     let add = self.activeuser?.company?.addressList?[0]
     selectedAddress = add
     AttendanceViewController.selectedLocation = CLLocation.init(latitude: Double(add?.lat ?? 0.00), longitude: Double(add?.lng ?? 0.00))
     
     tfAddress.text = add?.addressString()
     tfAddress.tag = self.getAddressIndex(addressId: add?.address_id ?? 0)
     self.hideTextField()
     return
     }
     tfLocation.text = "Customer"
     
     tfAddress.text = dsetting.client_name
     selectedAddreeList = address
     AttendanceViewController.selectedLocation =  CLLocation.init(latitude: address.lattitude, longitude: address.longitude)
     tf3Value.text = String.init(format:"\(address.addressLine1),\(address.addressLine2),\(address.city),\(address.state),\(address.country)")
     tfAddress.tag =  self.getCustomerIndex(customerId: dsetting.clientvendorid.intValue)
     tf3Value.tag =  self.getAddressIndex(addressId: dsetting.address_id.intValue)
     self.showTextField()
     
     //  tfLocation.tag = self.
     
     }else if(dsetting.location_type ==  NSNumber.init(value: 3)){
     if(self.arrVendorList.count == 0){
     dsetting.setValue(NSNumber.init(value:1), forKey: "location_type")
     self.fillData()
     return
     }
     tfLocation.text = "Vendor"
     
     selectedAddreeList =  address
     AttendanceViewController.selectedLocation =  CLLocation.init(latitude: address.lattitude, longitude: address.longitude)
     tfAddress.text = dsetting.client_name
     tf3Value.text = String.init(format:"\(address.addressLine1)")
     tfAddress.tag = self.getVendorIndex(vendorId: dsetting.clientvendorid.intValue)
     let vendor = self.arrVendorList[tfAddress.tag]
     tf3Value.tag = self.getAddressFromVendor(ven: vendor, addressId: dsetting.address_id as! NSInteger)
     self.showTextField()
     }
     if (dsetting.location_type == NSNumber.init(value:4)){
     tfLocation.text = "Travel Local"
     
     
     lbl2Title.isHidden = true
     lbl3Title.isHidden = true
     tf3Value.isHidden = true
     tfAddress.isHidden = true
     lblAddress.isHidden = false
     }
     
     if (dsetting.location_type == NSNumber.init(value:7)){
     tfLocation.text = "Travel Upcountry"
     
     
     lbl2Title.isHidden = true
     lbl3Title.isHidden = true
     tf3Value.isHidden = true
     tfAddress.isHidden = true
     lblAddress.isHidden = false
     }
     let strarrLocation = self.arrType.map{
     $0.location
     }
     let arrKey = self.arrType.map{
     $0.key
     }
     if (dsetting.location_type == NSNumber.init(value:8)){
     tfLocation.text = "Home"
     
     
     lbl2Title.isHidden = true
     lbl3Title.isHidden = true
     tf3Value.isHidden = true
     tfAddress.isHidden = true
     lblAddress.isHidden = false
     
     if(self.activeuser?.isCheckInAllowedFromHome == false){
     tfAddress.isHidden = true
     lblAddress.isHidden = true
     
     if(strarrLocation.contains("Home")){
     Common.showalert(msg: "You are not authorized for Home location Check-In or Check-Out", view: self)
     }
     }else{
     tfAddress.isHidden = false
     lblAddress.isHidden = false
     tfAddress.text = self.activeuser?.permanentAddress?.addressString()
     self.hideTextField()
     }
     }
     if(arrKey.contains(NSNumber.init(value:1)) && self.activeuser?.isCheckInAllowedFromHome == false){
     if((self.arrType.count > 1) && arrKey.first == NSNumber.init(value:1)){
     tfLocation.text = strarrLocation.first as! String
     
     
     tfAddress.isHidden = false
     lblAddress.isHidden = false
     }else{
     tfAddress.isHidden = true
     lblAddress.isHidden = true
     if(arrKey.contains(NSNumber.init(value: 1))){
     Common.showalert(msg: "You are not authorized for Home location Check-In or Check-Out", view: self)
     }
     tfLocation.text = strarrLocation.first as! String
     
     
     }
     }else{
     tfLocation.text = strarrLocation.first as! String
     
     
     if((tfLocation.text?.lowercased() == "office")||(tfLocation.text?.lowercased() == "home")||(tfLocation.text?.lowercased() == "vendor")||(tfLocation.text?.lowercased() == "customer")){
     self.hideTextField()
     }else{
     lbl2Title.isHidden = true
     lbl3Title.isHidden = true
     tfAddress.isHidden = true
     tf3Value.isHidden = true
     lblAddress.isHidden = false
     }
     }
     tfLocation.tag = 0
     for loc in 0...arrType.count - 1 {
     let temploc = arrType[loc]
     if(tfLocation.text == temploc.location){
     tfLocation.tag = loc
     }
     }
     if(tfLocation.text?.lowercased() == "office"){
     if(self.activesetting.addressSettingsForAttendance == 1){
     selectedAddress = self.activeuser?.company?.addressList?[0]
     AttendanceViewController.selectedLocation = CLLocation.init(latitude: address.lattitude, longitude: address.longitude)
     tfAddress.text = selectedAddress?.addressString()
     }else if(self.activesetting.addressSettingsForAttendance == 2){
     if(self.activeuser?.branchAddress != nil){
     selectedAddress =  self.activeuser?.branchAddress
     AttendanceViewController.selectedLocation = CLLocation.init(latitude: address.lattitude, longitude: address.longitude)
     if(selectedAddress?.addressString().count ?? 0 > 0){
     tfAddress.text = selectedAddress?.addressString()
     }else{
     tfAddress.text = String.init(format:"\(selectedAddress?.addressLine1),\(selectedAddress?.addressLine2),\(selectedAddress?.city),\(selectedAddress?.state),\(selectedAddress?.country)")
     }
     }else{
     selectedAddress = self.activeuser?.company?.addressList?[0]
     AttendanceViewController.selectedLocation = CLLocation.init(latitude: address.lattitude, longitude: address.longitude)
     tfAddress.text = selectedAddress?.addressString()
     }
     }else{
     selectedAddreeList = mutaddressBoth[0] as? AddressList ?? AddressList()
     AttendanceViewController.selectedLocation = CLLocation.init(latitude: Double(selectedAddress?.lat ?? 0.00), longitude: Double(selectedAddress?.lng ?? 0.00))
     if(selectedAddress?.addressString().count ?? 0 > 0){
     tfAddress.text = selectedAddress?.addressString()
     }else{
     tfAddress.text = String.init(format:"\(selectedAddress?.addressLine1),\(selectedAddress?.addressLine2),\(selectedAddress?.city),\(selectedAddress?.state),\(selectedAddress?.country)")
     }
     }
     self.hideTextField()
     }else if(tfLocation.text?.lowercased() == "customer"){
     if(self.arrCustomerList.count > 0 ){
     let customer = self.arrCustomerList[0]
     selectedAddreeList = customer.addressList[0] as? AddressList ?? AddressList()
     AttendanceViewController.selectedLocation = CLLocation.init(latitude: selectedAddreeList.lattitude, longitude: selectedAddreeList.longitude)
     tfAddress.text = customer.name
     tf3Value.text = String.init(format:"\(selectedAddreeList.addressLine1),\(selectedAddress?.addressLine2),\(selectedAddress?.city),\(selectedAddress?.state),\(selectedAddress?.country)")
     //   tfAddress.tag =
     tf3Value.tag = 0
     self.showTextField()
     }
     
     }else if(tfLocation.text?.lowercased() == "vendor"){
     if(self.arrVendorList.count > 0){
     let vendor = self.arrVendorList[0]
     selectedAddreeList = vendor.addressList[0] as! AddressList
     AttendanceViewController.selectedLocation = CLLocation.init(latitude: Double(selectedAddress?.lat ?? 0.00), longitude: Double(selectedAddress?.lng ?? 0.00))
     tfLocation.text = vendor.name
     tfAddress.text = String.init(format:"\(selectedAddreeList.addressLine1),\(selectedAddreeList.addressLine2),\(selectedAddreeList.city),\(selectedAddreeList.state),\(selectedAddreeList.country)")
     tfAddress.tag = 0
     //  tfLocation.tag = index
     self.showTextField()
     }
     
     
     
     }else if(tfLocation.text?.lowercased() == "home"){
     tfAddress.text = self.activeuser?.permanentAddress?.addressString()
     self.hideTextField()
     
     }
     }
     }*/
    
    
    func getAddressFromCustomer(cust:CustomerDetails,addressId:NSInteger)->Int{
        var index = 0
        
        if(cust.addressList.count > 0){
            for add in 0...cust.addressList.count - 1{
                let address = cust.addressList[add] as? AddressInfo
                if(address?.address_id == addressId){
                    index = add
                    break
                }
            }
        }
        return index
    }
    
    func getAddressFromVendor(ven:Vendor,addressId:NSInteger)->NSInteger{
        var index = 0
        var int = 0
        if(ven.addressList.count > 0){
            for add in 0...ven.addressList.count - 1{
                let address = ven.addressList[add] as? AddressInfo
                if(address?.address_id == addressId){
                    index = add
                    break
                }
            }
        }
        return index
    }
    
    
    func getAddressIndex(addressId:Int)->Int{
        var index = 0
        var int = 0
        if(self.activeuser?.company?.addressList?.count ?? 0 > 0){
            for add in self.activeuser?.company?.addressList ?? [AddressInfo](){
                if(add.address_id  == addressId){
                    index = int
                    break
                }
                int += 1
            }
            
        }
        return index
    }
    
    func getCustomerIndex(customerId:Int)->Int{
        var index = 0
        var int = 0
        for cust in self.arrCustomerList{
            if(cust.iD == customerId){
                index = int
                break
            }
            int += 1
        }
        return index
    }
    
    func getVendorIndex(vendorId:Int)->Int{
        var index = 0
        var int = 0
        for vend in self.arrVendorList{
            if(vend.iD == vendorId){
                index = int
                break
            }
            int += 1
        }
        return index
    }
    
    
    func takeNewPhotoFromCamera(){
        if let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.camera) as? Bool {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .authorized:
                
                showCameraPicker()
                
            case .denied:
                alertPromptToAllowCameraAccessViaSettings()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                    if(granted){
                        self.showCameraPicker()
                    }else{
                        self.permissionPrimeCameraAccess()
                    }
                }
            default:
                permissionPrimeCameraAccess()
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                //  Analytics.track(event: .permissionsPrimeCameraNoCamera)
            })
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func alertPromptToAllowCameraAccessViaSettings() {
        let alert = UIAlertController(title: "SuperSales Would Like To Access the Camera", message: "Please grant permission to use the Camera so that you can  customer benefit.", preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { alert in
            // Analytics.track(event: .permissionsPrimeCameraOpenSettings)
            if let appSettingsURL = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(appSettingsURL as URL)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    
    func permissionPrimeCameraAccess() {
        DispatchQueue.main.async {
            let alert = UIAlertController( title: "SuperSales Would Like To Access the Camera", message: "SuperSales would like to access your Camera so that you can customer benefit.", preferredStyle: .alert )
            let allowAction = UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
                // Analytics.track(event: .permissionsPrimeCameraAccepted)
                if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self] granted in
                        DispatchQueue.main.async {
                            // self?.cameraSelected() // try again
                        }
                    })
                }
            })
            alert.addAction(allowAction)
            let declineAction = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in
                //  Analytics.track(event: .permissionsPrimeCameraCancelled)
            }
            alert.addAction(declineAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func showCameraPicker() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerController.SourceType.camera
                self.present(picker, animated: true, completion: nil)
            }
        }else{
            Utils.toastmsg(message:"Camera is not present",view:self.view)
        }
    }
    
    func initDropDown(){
        if(tfLocation.text?.lowercased() == "office"){
            if(self.activesetting.addressSettingsForAttendance ==  1 ){
                self.dropdownAddress.dataSource = self.mutAddressOffice.map({
                    ($0.addressString())
                })
                selectedArrOfAddress = self.mutAddressOffice
                //                let floatlat = Float(self.mutAddressOffice.first?.lat ?? "0.00000")
                //
                //                let floatlong = Float(self.mutAddressOffice.first?.lng ?? "0.0000")
                //
                //                let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                //                AttendanceViewController.selectedLocation = location
            }else if(self.activesetting.addressSettingsForAttendance ==  2){
                self.dropdownAddress.dataSource = self.mutAddressBranch.map({
                    ($0.addressString())
                })
                selectedArrOfAddress = self.mutAddressBranch
                let floatlat = Float( self.mutAddressBranch.first?.lat ?? "0.00000")
                let floatlong = Float( self.mutAddressBranch.first?.lng ?? "0.0000")
                
                let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                //   AttendanceViewController.selectedLocation = location
            }else{
                self.dropdownAddress.dataSource = self.mutaddressBoth.map({
                    ($0.addressString())
                })
                selectedArrOfAddress = self.mutaddressBoth
                let floatlat = Float(self.mutaddressBoth.first?.lat ?? "0.00000")
                
                let floatlong = Float(self.mutaddressBoth.first?.lng ?? "0.0000")
                
                let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                //  AttendanceViewController.selectedLocation = location
                
            }
            if(self.dropdownAddress.dataSource.count > 0){
                let selectedTag = tfAddress.tag
                self.tfAddress.text = self.dropdownAddress.dataSource[selectedTag]
                
                
                AttendanceViewController.tarvelAddress = self.dropdownAddress.dataSource[selectedTag]
            }
        }else if(tfLocation.text?.lowercased() == "home"){
            if(self.activeuser?.isCheckInAllowedFromHome == true){
                
                
                
                
                if let address = self.activeuser?.permanentAddress as? AddressInfo{
                    self.dropdownAddress.dataSource = [address.addressString()]
                    self.selectedArrOfAddress = [address]
                    //    AttendanceViewController.selectedLocation = CLLocation.init(latitude: Double(address.lat ?? "0.00") ?? 0.00 , longitude: Double(address.lng ?? "0.00") ?? 0.00)
                }else{
                    self.dropdownAddress.dataSource = [""]
                    self.selectedArrOfAddress = [AddressInfo]()
                    Utils.toastmsg(message:"You are not allowded checkin from Home",view:self.view)
                    let okAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                    Common.showalertWithAction(msg: "You are not allowded checkin from Home", arrAction: [okAction], view: self)
                }
                self.tfAddress.text = self.dropdownAddress.dataSource[0]
                
                self.hideTextField()
            }}else if(tfLocation.text?.lowercased() == "travel local"){
                
            }
        dropdownLocation.dataSource = AttendanceViewController.arrType.map({
            ($0.location)
        })
        dropdownLocation.anchorView =  tfLocation
        dropdownLocation.bottomOffset = CGPoint.init(x: 0.0, y: tfLocation.bounds.size.height)
        dropdownLocation.selectionAction = {
            (index,item) in
            
            
            self.tfLocation.text = item
            if(self.activeuser?.isCheckInAllowedFromHome == false && self.tfLocation.text == "Home"){
                self.tfAddress.isHidden = true
                
                
                if(self.strarrLocation.contains("Home")){
                    Common.showalert(msg: "You are not authorized for Home location Check-In or Check-Out", view: self)
                }
                
                print("types of location  in fill data = \(AttendanceViewController.arrType)")
                if(self.strarrLocation.count > 0){
                    if(self.strarrLocation.contains("Office")){
                        self.tfLocation.text = "Office"
                        //                            if(self.activesetting.addressSettingsForAttendance ==  1 ){
                        //                                    self.dropdownAddress.dataSource = self.mutAddressOffice.map({
                        //                                                   ($0.addressString())
                        //                                               })
                        //                                self.selectedArrOfAddress = self.mutAddressOffice
                        //                                                print(self.mutAddressOffice.first?.lat)
                        //                                           }else if(self.activesetting.addressSettingsForAttendance ==  2){
                        //                                               self.dropdownAddress.dataSource = self.mutAddressBranch.map({
                        //                                                   ($0.addressString())
                        //                                               })
                        //                                            self.selectedArrOfAddress = self.mutAddressBranch
                        //                                            print(self.mutAddressBranch.first?.lat)
                        //                                           }else{
                        //                                               self.dropdownAddress.dataSource = self.mutaddressBoth.map({
                        //                                                   ($0.addressString())
                        //                                               })
                        //                                            self.selectedArrOfAddress = self.mutaddressBoth
                        //                                            print(self.mutaddressBoth.first?.lat)
                        //                                               }
                    }else if(self.strarrLocation[0] == "Home" && self.strarrLocation.count > 1){
                        self.tfLocation.text = self.strarrLocation[1]
                        
                    }else{
                        self.tfLocation.text = self.strarrLocation[0]
                    }
                    self.updateDataAsperLocation(location: self.tfLocation.text ?? "")
                }
            }
            self.updateDataAsperLocation(location: item)
            
            
        }
        dropdownAddress.anchorView =  tfAddress
        dropdownAddress.bottomOffset = CGPoint.init(x: 0.0, y: tfAddress.bounds.size.height)
        
        dropdownAddress.selectionAction = {(index,item) in
            // AttendanceViewController.selectedAddreeList =  selectedArrOfAddress[index]
            let address = self.selectedArrOfAddress[index]
            let floatlat = Float(address.lat ?? "0")
            let floatlong = Float(address.lng ?? "0")
            
            self.selectedAddressID =  NSNumber.init(value:address.address_id ?? 0)
            
            
            let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
            AttendanceViewController.selectedLocation = location
            
            
            
            self.tfAddress.text = item
            
            self.updateAddresslabel()
            
        }
        
        //        if(tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "custmor"){
        dropdownCustomerVendor.anchorView = tf3Value
        dropdownCustomerVendor.bottomOffset = CGPoint.init(x:0.0 , y:self.tf3Value.bounds.size.height)
        dropdownCustomerVendor.selectionAction = {
            (index,item) in
            self.tf3Value.text = item
            
        }
        
        // }
    }
    
    
    
    
    func isableToLoginForCustomer(add:CLLocation)->Bool{
        if let  coord = Location.sharedInsatnce.currentLocation as? CLLocation{
            let location1 = CLLocation.init(latitude: coord.coordinate.latitude, longitude: coord.coordinate.longitude)
            print("distance = \(location1.distance(from: add)) , radius = \(self.activeuser?.company?.radiusSuperSales?.doubleValue)")
            let meter = location1.distance(from: add)
            if(meter <= self.activeuser?.company?.radiusSuperSales?.doubleValue ?? 0.00){
                return true
            }else{
                if let attendancecheckin = AttendanceViewController.verifycheckinAdd{
                    if(attendancecheckin){
                        SVProgressHUD.dismiss()
                        self.displayAlert()
                    }else{
                        Utils.toastmsg(message: "Verifying Address", view: self.view)
                        //  Utils.addShadow(view: viewcontroller.view)
                        let secondsToDelay = 4.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                            self.verfyingAddress(status: true)
                        }
                        
                    }
                }
                
                if let attendancecheckout = AttendanceViewController.verifycheckoutAdd{
                    if(attendancecheckout){
                        SVProgressHUD.dismiss()
                        self.displayAlert()
                    }else{
                        Utils.toastmsg(message: "Verifying Address", view: self.view)
                        //  Utils.addShadow(view: viewcontroller.view)
                        let secondsToDelay = 4.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                            self.verfyingAddress(status: false)
                        }
                        
                    }
                }
                
                
                return false
            }
        }else{
            return true
        }
    }
    
    func displayAlert(){
        let mapAction =  UIAlertAction.init(title: "VIEW ON MAP", style:.cancel) { (action) in
            if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
                map.isFromDashboard = false
                map.isFromAttendance = true
                map.isFromColdCall = false
                map.isFromVisitLeadDetail = false
                map.lattitude = NSNumber.init(value:AttendanceViewController.selectedLocation?.coordinate.latitude ?? 0.0000)
                
                map.longitude = NSNumber.init(value:AttendanceViewController.selectedLocation?.coordinate.longitude ?? 0.0000)  //NSNumber.init(value:AttendanceViewController.selectedLocation?.coordinate.longitude ?? 0.00)
                self.navigationController?.pushViewController(map, animated: true)
            }
        }
        let refreshLocation = UIAlertAction.init(title: "Refresh", style: UIAlertAction.Style.default) { (action) in
            Utils.toastmsg(message:"Refreshing Location",view:self.view)
            Location.sharedInsatnce.startLocationManager()
        }
        let cancelAction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: nil)
        Common.showalertWithAction(msg: "You are not at above location OR your location may be not updated. Please refresh location.", arrAction: [mapAction,refreshLocation,cancelAction], view: self)
        
    }
    
    @objc func checkInButtonGreen(){
        print("total record of attendance in green method  = \(AttendanceHistory.getAll().count)")
        //        print("last object = \(AttendanceHistory.getAll().last)")
        if let ate = AttendanceHistory.getLatestAttendanceForDate(date: Date() ,userID:self.activeuser?.userID ?? 0){
            
            print("checkin type = \(ate.checkInAttendanceType) ,  checkout type = \(ate.checkOutAttendanceType)")
            if((ate.checkInAttendanceType > 0) && (ate.checkOutAttendanceType == 0)){
                
                
                
                btnCheckIn.setTitle("Checked-In" , for:.normal)
                btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x25A614)
            }else{
                btnCheckIn.setTitle("Check-In" , for:.normal)
                btnCheckIn.backgroundColor = Common().UIColorFromRGB(rgbValue:0x2196F3)
            }
        }else{
            print("not get record ")
        }
    }
    
    func hideTextField()->(){
        lbl2Title.text = NSLocalizedString("Address", comment: "")
        lbl2Title.isHidden = false
        tfAddress.isHidden = false
        lbl3Title.isHidden = true
        tf3Value.isHidden = true
        lblAddress.isHidden = false
        
        if(self.activeuser?.isCheckInAllowedFromHome == false && tfLocation.text?.lowercased() == "home"){
            lbl2Title.isHidden = true
            tfAddress.isHidden = true
        }else{
            lbl2Title.isHidden = false
            tfAddress.isHidden = false
        }
        
    }
    
    
    func showTextField()->(){
        lbl2Title.text = "Customer/Vendor"
        lbl3Title.text = NSLocalizedString("Address", comment: "")
        lbl2Title.isHidden = false
        
        tfAddress.isHidden = false
        lbl3Title.isHidden = false
        tf3Value.isHidden = false
        
        
    }
    func setAddressAsPerLocationSelection(locationID:Int){
        let dsetting = AttendanceCheckInCheckOut.defaultsetting
        
        if let address = dsetting?.clientAddress as? AddressListModel{
            if(locationID == 1){
                //Office
                let setting = self.activesetting
                if((setting.addressSettingsForAttendance == NSNumber.init(value:1)) || (setting.addressSettingsForAttendance == NSNumber.init(value:3)) || (self.activeuser?.branchAddress ==  nil)){
                    
                    if(address != nil){
                        //                                let addModel =  AddressListModel().getaddressListModelWithDic(dict: address)
                        AttendanceViewController.selectedAddreeList =  address
                        selectedAddressID = address.addressId
                        let floatlat = Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                        
                        let floatlong = Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                        
                        let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                        AttendanceViewController.selectedLocation = location
                        var strAddress = ""
                        if let stradd1 = address.addressLine1 {
                            strAddress.append(stradd1)
                        }
                        if let stradd2 = address.addressLine2 {
                            strAddress.append(",\(stradd2)")
                        }
                        if let straddCity = address.city {
                            strAddress.append(",\(straddCity)")
                        }
                        if let straddState = address.state {
                            strAddress.append(",\(straddState)")
                        }
                        if let straddCountry = address.country {
                            strAddress.append(",\(straddCountry)")
                        }
                        
                        tfAddress.text = strAddress//String.init(format:"\(address.addressLine1) , \(address.addressLine2) , \(address.city) , \(address.state), \(address.country)",[])
                        self.updateAddresslabel()
                        tfAddress.tag = self.getAddressIndex(addressId: Int(address.addressId ?? 0))
                        AttendanceViewController.tfAddressTag = tfAddress.tag
                        
                    }else{
                        if(self.activeuser?.company?.addressList?.count ?? 0 > 0){
                            let add = self.activeuser?.company?.addressList?[0]
                            AttendanceViewController.selectedAddress = add
                            if  let custAddress = self.activeuser?.company?.addressList?[0] as? AddressList{
                                let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                                AttendanceViewController.selectedAddreeList = addModel
                            }
                            let floatlat = Float(AttendanceViewController.selectedAddress?.lat ?? "0.00000")
                            
                            let floatlong = Float(AttendanceViewController.selectedAddress?.lng ?? "0.0000")
                            
                            let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                            AttendanceViewController.selectedLocation = location
                            tfAddress.text = add?.addressString()
                            selectedAddressID = NSNumber.init(value:AttendanceViewController.selectedAddress?.address_id ?? 0)
                            tfAddress.tag = self.getAddressIndex(addressId: add?.address_id ?? 0)
                            AttendanceViewController.tfAddressTag = tfAddress.tag
                        }
                    }
                    
                }
                else{
                    let address = self.activeuser?.branchAddress
                    AttendanceViewController.selectedAddress =  address
                    
                    if  let custAddress = self.activeuser?.branchAddress as? AddressList{
                        let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                        AttendanceViewController.selectedAddreeList = addModel
                    }
                    let floatlat = Float(AttendanceViewController.selectedAddress?.lat ?? "0.00000")
                    
                    let floatlong = Float(AttendanceViewController.selectedAddress?.lng ?? "0.0000")
                    
                    let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                    AttendanceViewController.selectedLocation = location
                    if(address?.addressString().count ?? 0 > 0){
                        tfAddress.text = address?.addressString()
                        selectedAddressID = NSNumber.init(value:address?.address_id ?? 0)
                    }else{
                        tfAddress.text =         String.init(format:"\(address?.addressLine1),\(address?.addressLine2),\(address?.city),\(address?.country)")
                        selectedAddressID = NSNumber.init(value:address?.address_id ?? 0)
                    }
                    
                }
            }else if(locationID == 2){
                //
                if(!(Utils.isCustomerMapped(cid: dsetting?.clientvendorid ?? NSNumber.init(value:0)))){
                    let add = self.activeuser?.company?.addressList?[0] as? AddressInfo
                    AttendanceViewController.selectedAddress = add
                    if  let custAddress = self.activeuser?.company?.addressList?[0] as? AddressInfo{
                        let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                        AttendanceViewController.selectedAddreeList = addModel
                    }
                    let floatlat = Float(AttendanceViewController.selectedAddress?.lat ?? "0.00000")
                    
                    let floatlong = Float(AttendanceViewController.selectedAddress?.lng ?? "0.0000")
                    
                    let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                    AttendanceViewController.selectedLocation = location
                    //AttendanceViewController.selectedLocation = CLLocation.init(latitude: Double(add?.lat ?? 0.00), longitude: Double(add?.lng ?? 0.00))
                    
                    tfAddress.text = add?.addressString()
                    selectedAddressID = NSNumber.init(value:add?.address_id ?? 0)
                    tfAddress.tag = self.getAddressIndex(addressId: add?.address_id ?? 0)
                    AttendanceViewController.tfAddressTag = tfAddress.tag
                    self.hideTextField()
                    return
                }
                else{
                    AttendanceViewController.selectedAddreeList = address
                    //                        let latdouble = Float(address.lattitude ?? "0.0000")
                    //                        let longdouble = Float(address.longitude ?? "0.0000")
                    let floatlat = Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                    
                    let floatlong = Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                    
                    let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                    AttendanceViewController.selectedLocation = location
                    
                    var strAdd = ""
                    if let stradd1 = AttendanceViewController.selectedAddreeList.addressLine1{
                        strAdd.append(stradd1)
                    }
                    if let stradd2 = AttendanceViewController.selectedAddreeList.addressLine2{
                        strAdd.append(stradd2)
                    }
                    if let strAddCity = AttendanceViewController.selectedAddreeList.city{
                        strAdd.append(strAddCity)
                    }
                    if let strAddState = AttendanceViewController.selectedAddreeList.state{
                        strAdd.append(strAddState)
                    }
                    if let strAddCountry = AttendanceViewController.selectedAddreeList.country{
                        strAdd.append(strAddCountry)
                    }
                    tf3Value.text = strAdd
                    tfAddress.tag =  self.getCustomerIndex(customerId: dsetting?.clientvendorid?.intValue ?? 0)
                    AttendanceViewController.tfAddressTag = tfAddress.tag
                    tf3Value.tag =  self.getAddressIndex(addressId: dsetting?.addressID?.intValue ?? 0)
                    self.showTextField()
                }
            }else if(locationID == 3){
                //vendor
                
                if(self.arrVendorList.count > 0){
                    AttendanceViewController.selectedAddreeList =  address
                    
                    let floatlat = Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                    
                    let floatlong = Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                    
                    let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                    AttendanceViewController.selectedLocation = location
                    tfAddress.text = dsetting?.clientName
                    // tf3Value.text = String.init(format:"\(AttendanceViewController.selectedAddreeList.addressLine1)")
                    var strAdd = ""
                    if let stradd1 = AttendanceViewController.selectedAddreeList.addressLine1{
                        strAdd.append(stradd1)
                    }
                    if let stradd2 = AttendanceViewController.selectedAddreeList.addressLine2{
                        strAdd.append(stradd2)
                    }
                    if let strAddCity = AttendanceViewController.selectedAddreeList.city{
                        strAdd.append(strAddCity)
                    }
                    if let strAddState = AttendanceViewController.selectedAddreeList.state{
                        strAdd.append(strAddState)
                    }
                    if let strAddCountry = AttendanceViewController.selectedAddreeList.country{
                        strAdd.append(strAddCountry)
                    }
                    tf3Value.text = strAdd
                    tfAddress.tag = self.getVendorIndex(vendorId: dsetting?.clientvendorid.intValue ?? 0)
                    AttendanceViewController.tfAddressTag = tfAddress.tag
                    let vendor = self.arrVendorList[tfAddress.tag]
                    tf3Value.tag = self.getAddressFromVendor(ven: vendor, addressId: dsetting?.addressID as! NSInteger)
                    self.showTextField()
                }
            }else {
                self.lblAddress.text = self.strCurrentAddress
                AttendanceViewController.tarvelAddress = self.strCurrentAddress
            }
        }
    }
    
    
    func updateDataAsperLocation(location:String){
        print(location)
        if (location == "Office"){
            
            
            if(self.activesetting.addressSettingsForAttendance ==  1 ){
                self.dropdownAddress.dataSource = self.mutAddressOffice.map({
                    ($0.addressString())
                })
                self.selectedArrOfAddress = self.mutAddressOffice
                let floatlat = Float(self.mutAddressOffice.first?.lat ?? "0.00000")
                
                let floatlong = Float(self.mutAddressOffice.first?.lng ?? "0.0000")
                
                let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                let address =
                AddressListModel().getaddressListModelWithDic(dict: self.mutAddressOffice.first?.toDictionary() ?? [String:Any]())
                AttendanceViewController.selectedAddreeList = address
                AttendanceViewController.selectedLocation = location
            }else if(self.activesetting.addressSettingsForAttendance ==  2){
                self.dropdownAddress.dataSource = self.mutAddressBranch.map({
                    ($0.addressString())
                })
                self.selectedArrOfAddress = self.mutAddressBranch
                let floatlat = Float( self.mutAddressBranch.first?.lat ?? "0.00000")
                
                let floatlong = Float( self.mutAddressBranch.first?.lng ?? "0.0000")
                
                let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                let address =
                AddressListModel().getaddressListModelWithDic(dict: self.mutAddressBranch.first?.toDictionary() ?? [String:Any]())
                AttendanceViewController.selectedAddreeList = address
                AttendanceViewController.selectedLocation = location
            }else{
                self.dropdownAddress.dataSource = self.mutaddressBoth.map({
                    ($0.addressString())
                })
                self.selectedArrOfAddress = self.mutaddressBoth
                let floatlat = Float(self.mutaddressBoth.first?.lat ?? "0.00000")
                
                let floatlong = Float(self.mutaddressBoth.first?.lng ?? "0.0000")
                
                let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                let address =
                AddressListModel().getaddressListModelWithDic(dict: self.mutaddressBoth.first?.toDictionary() ?? [String:Any]())
                AttendanceViewController.selectedAddreeList = address
                AttendanceViewController.selectedLocation = location
                
            }
            self.tfAddress.text = self.dropdownAddress.dataSource[0]
            self.selectedAddressID = NSNumber.init(value:self.selectedArrOfAddress[0].address_id ?? 0)
            self.hideTextField()
            self.updateAddresslabel()
        }else if(location == "Customer"){
            
            
            if(self.arrCustomerList.count > 0){
                AttendanceViewController.arrOfSelectedMultipleCustomer = [self.arrCustomerList[0]]
                self.dropdownCustomerVendor.dataSource = [String]()
                if(self.arrCustomerList.first?.addressList.count ?? 0 > 0){
                    if let arrCust = self.arrCustomerList.first?.addressList as? NSOrderedSet
                    {
                        arrCust.enumerateObjects { (elem, idx, stop) -> Void in
                            
                            print("\(idx): \(elem)")
                            let add =  elem as? AddressList
                            let address =  AddressListModel().getaddressListModelWithDic(dict: add?.toDictionary() ?? [String:Any]())
                            AttendanceViewController.selectedAddreeList =  address
                            //   AttendanceViewController.selectedLocation = CLLocation.init(latitude: Double(address.lattitude) ?? 0.00, longitude: Double(address.longitude) ?? 0.00)
                            var strad = ""
                            if let ad1 = add?.addressLine1 as? String {
                                strad.append("\(ad1),")
                            }
                            if let ad2 =  add?.addressLine2 as? String {
                                strad.append("\(ad2),")
                            }
                            if let city =  add?.city as? String {
                                strad.append("\(city),")
                            }
                            if let country =  add?.country as? String {
                                strad.append(country)
                            }
                            self.dropdownCustomerVendor.dataSource.append(strad)
                        }
                        
                    }
                }
                self.tf3Value.text =  self.dropdownCustomerVendor.dataSource.first
                let arrOfSelectedCustomer  = [self.arrCustomerList.first] as? [CustomerDetails] ?? [CustomerDetails]()
                AttendanceViewController.arrOfSelectedMultipleCustomer = arrOfSelectedCustomer
                self.tfAddress.text = self.arrCustomerList.first?.name
                
                self.showTextField()
                
            }else{
                self.hideTextField()
                Utils.toastmsg(message:"No customers available",view:self.view)
            }
            self.dropdownAddress.dataSource = self.arrCustomerList.map({
                return $0.name
            })
        }else if(location == "Vendor"){
            
            
            if(self.arrVendorList.count > 0){
                if let fvendor = self.arrVendorList.first{
                    AttendanceViewController.arrOfSelectedVendor = [fvendor]
                }
                self.dropdownCustomerVendor.dataSource = [String]()
                if(self.arrVendorList.first?.addressList.count ?? 0 > 0){
                    if let arrCust = self.arrVendorList.first?.addressList as? NSOrderedSet
                    {
                        arrCust.enumerateObjects { (elem, idx, stop) -> Void in
                            
                            print("\(idx): \(elem)")
                            let add =  elem as? AddressList
                            
                            let address =  AddressListModel().getaddressListModelWithDic(dict: add?.toDictionary() ?? [String:Any]())
                            AttendanceViewController.selectedAddreeList =  address
                            //    AttendanceViewController.selectedLocation = CLLocation.init(latitude: Double(address.lattitude) ?? 0.00 , longitude: Double(address.longitude) ?? 0.00)
                            var strad = ""
                            if let ad1 = add?.addressLine1 as? String {
                                strad.append("\(ad1),")
                            }
                            if let ad2 =  add?.addressLine2 as? String {
                                strad.append("\(ad2),")
                            }
                            if let city =  add?.city as? String {
                                strad.append("\(city),")
                            }
                            if let country =  add?.country as? String {
                                strad.append(country)
                            }
                            self.dropdownCustomerVendor.dataSource.append(strad)
                        }
                        
                    }
                }
                
                self.tfAddress.text = self.arrVendorList.first?.name
                self.tf3Value.text = self.dropdownCustomerVendor.dataSource.first
                let  arrOFSelectedVendor = [self.arrVendorList.first] as? [Vendor] ?? [Vendor]()
                AttendanceViewController.arrOfSelectedVendor = arrOFSelectedVendor
                self.showTextField()
            }else{
                self.hideTextField()
                Utils.toastmsg(message:"No vendors available",view:self.view)
            }
            self.dropdownAddress.dataSource = self.arrVendorList.map({
                return $0.name
            })
        }else if (location == "Home"){
            
            if(self.activeuser?.isCheckInAllowedFromHome == true){
                
                
                self.tfAddress.isHidden = true
                
                if let address = self.activeuser?.permanentAddress as? AddressInfo{
                    let floatlat = address.lat?.floatValue ?? 0.00
                    let floatlng = address.lng?.floatValue ?? 0.00
                    
                    AttendanceViewController.selectedLocation = CLLocation.init(latitude: CLLocationDegrees.init(floatlat), longitude: CLLocationDegrees.init(floatlng))
                    self.dropdownAddress.dataSource = [address.addressString()]
                    self.selectedArrOfAddress = [address]
                    //    AttendanceViewController.selectedLocation = CLLocation.init(latitude: Double(address.lat ?? "0.00") ?? 0.00 , longitude: Double(address.lng ?? "0.00") ?? 0.00)
                }else{
                    self.dropdownAddress.dataSource = [""]
                    self.selectedArrOfAddress = [AddressInfo]()
                    Utils.toastmsg(message:"No home address found",view:self.view)
                    let okAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                    Common.showalertWithAction(msg: "No home address found", arrAction: [okAction], view: self)
                }
                self.tfAddress.text = self.dropdownAddress.dataSource[0]
                
                self.hideTextField()
            }else{
                let okAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                Common.showalertWithAction(msg: "You are not allowded checkin from Home", arrAction: [okAction], view: self)
                
                
                if(self.strarrLocation.contains("Office")){
                    self.tfLocation.text = "Office"
                    if(self.activesetting.addressSettingsForAttendance ==  1 ){
                        self.dropdownAddress.dataSource = self.mutAddressOffice.map({
                            ($0.addressString())
                        })
                        self.selectedArrOfAddress = self.mutAddressOffice
                        print(self.mutAddressOffice.first?.lat)
                    }else if(self.activesetting.addressSettingsForAttendance ==  2){
                        self.dropdownAddress.dataSource = self.mutAddressBranch.map({
                            ($0.addressString())
                        })
                        self.selectedArrOfAddress = self.mutAddressBranch
                        print(self.mutAddressBranch.first?.lat)
                    }else{
                        self.dropdownAddress.dataSource = self.mutaddressBoth.map({
                            ($0.addressString())
                        })
                        self.selectedArrOfAddress = self.mutaddressBoth
                        print(self.mutaddressBoth.first?.lat)
                    }
                }else if(self.strarrLocation[0] == "Home" && self.strarrLocation.count > 1){
                    self.tfLocation.text = self.strarrLocation[1]
                }else{
                    self.tfLocation.text = self.strarrLocation[0]
                }
                self.updateDataAsperLocation(location: self.tfLocation.text ?? "")
                
                if(self.dropdownAddress.dataSource.count > 0){
                    self.tfAddress.text = self.dropdownAddress.dataSource[0]
                }
                self.hideTextField()
            }
        }else if((location == "Travel Local") || (location == "Travel Upcountry")){
            
            
            self.lbl2Title.isHidden = true
            self.lbl3Title.isHidden = true
            self.tfAddress.isHidden = true
            self.tf3Value.isHidden = true
            
            // if()
        }
        if((location == "Travel Local")||(location == "Travel Upcountry")){
            print(self.strCurrentAddress)
            
            self.lblAddress.text = self.strCurrentAddress
            AttendanceViewController.tarvelAddress = self.strCurrentAddress
            
        }else{
            self.updateAddresslabel()
            self.setVisibility()
            if(tfLocation.text?.lowercased() == "travel local" || tfLocation.text?.lowercased() == "travel upcountry"){
                self.lblAddress.text = self.strCurrentAddress
                self.tfAddress.isHidden = true
                self.lbl2Title.isHidden = true
            }else{
                self.tfAddress.isHidden = false
                self.lbl2Title.isHidden = false
            }
        }
        
        
    }
    func setVisibility()->(){
        
        let text = tfLocation.text
        if(text?.lowercased() == "office"){
            self.hideTextField()
            
            if let location =   AttendanceViewController.selectedLocation as? CLLocation{
                let checkavilability = AttendanceCheckInCheckOut().isableToLogin(add: location)
                if(checkavilability){
                    
                    self.lblAddress.text = "You are ready to check-in or check-out"
                }else{
                    self.lblAddress.text = "You are not at above location OR Your location may be not updated. Please refresh location."
                }
            }
        }else if(text?.lowercased() == "home"){
            /*
             
             if let location =   AttendanceViewController.selectedLocation as? CLLocation{
             let checkavilability = AttendanceCheckInCheckOut().isableToLogin(add: location)
             if(checkavilability){
             **/
            if let location =   AttendanceViewController.selectedLocation as? CLLocation{
                let checkavilability = AttendanceCheckInCheckOut().isableToLogin(add: location)
                if(checkavilability){
                    
                    self.lblAddress.text = "You are ready to check-in or check-out"
                }else{
                    self.lblAddress.text = "You are not at above location OR Your location may be not updated. Please refresh location."
                }
            }
            
        }else if(text?.lowercased() == "travel local"){
            
        }else if(text?.lowercased() == "travel upcountry"){
            
        }else {
            /*
             
             if let location =   AttendanceViewController.selectedLocation as? CLLocation{
             let checkavilability = AttendanceCheckInCheckOut().isableToLogin(add: location)
             if(checkavilability){
             **/
            if let location =   AttendanceViewController.selectedLocation as? CLLocation{
                let checkavilability = AttendanceCheckInCheckOut().isableToLogin(add: location)
                if(checkavilability){
                    
                    self.lblAddress.text = "You are ready to check-in or check-out"
                }else{
                    self.lblAddress.text = "You are not at above location OR Your location may be not updated. Please refresh location."
                }
            }
        }
    }
    
    
    func verfyingAddress(status:Bool){//(status:Int,lat:NSNumber,long:NSNumber,isVisitPlanned:VisitType,objplannedVisit:PlannVisit,objunplannedVisit:UnplannedVisit,visitid:NSNumber,viewcontroller:UIViewController,addressID:NSNumber){
        // let currenlocation =  Location.sharedInsatnce.currentLocation
        
        
        if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
            //          CLLocationCoordinate2DIsValid(currentCoordinate)
            if(CLLocationCoordinate2DIsValid(currentCoordinate)){
                let currentlat =  currentCoordinate.latitude
                let currentlong = currentCoordinate.longitude
                if let attendancecheckin = AttendanceViewController.verifycheckinAdd{
                    if(!attendancecheckin){
                        AttendanceViewController.verifycheckinAdd = true
                        
                        self.userCheckIn(statusOFCheckin: status)
                    }
                    else{
                        if(status){
                            self.displayAlert()
                        }
                    }
                }
                if let attendancecheckout = AttendanceViewController.verifycheckoutAdd{
                    if(!attendancecheckout){
                        AttendanceViewController.verifycheckoutAdd = true
                        self.userCheckIn(statusOFCheckin: status)
                    }else{
                        if(status == false){
                            self.displayAlert()
                        }
                    }
                }
                
                
                //   self.checkOutClicked(tag: tag, tflocationText: tflocationText, viewController: viewController)
                //   self.checkin(visitstatus: status, lat: NSNumber.init(value:currentlat), long: NSNumber.init(value:currentlong), isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
                //  self.checkin(visitstatus: status, lat: currentlat, long: currentlong, isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
                // self.checkin(visitstatus: status, lat: currentCoordinate.latitude, long: currentCoordinate.longitude, isVisitPlanned: VisitType.directvisitcheckin, objplannedVisit: objplannedVisit, objunplannedVisit: UnplannedVisit(), visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
            }
        }else{
            Utils.toastmsg(message: "Please check your gps", view: self.view)
        }
    }
    //MARK: - API Call
    
    func userCheckIn(statusOFCheckin:Bool){
        var msg = ""
        if(tfLocation.text?.count  == 0){
            msg = "Please select location"
        }else if(tfAddress.text?.count == 0){
            if(tfLocation.text?.lowercased() == "office"){
                msg = "Please select address"
            }else  if(tfLocation.text?.lowercased() == "customer"){
                msg = "Please select customer"
            }else if (tfLocation.text?.lowercased() == "vendor"){
                msg = "Please select vendor"
            }
        }
        
        if(tfLocation.text?.lowercased() == "home"){
            if((msg.count == 0) && (self.activeuser?.isCheckInAllowedFromHome == false)){
                lbl2Title.isHidden = true
                tfAddress.isHidden = true
                msg = "You are not authorized for Home location Check-In or Check-Out"
            }
        }
        if(msg.count > 0){
            Common.showalert(msg: msg , view: self)
        }else{
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            param["UserID"] = self.activeuser?.userID
            param["CompanyID"] = self.activeuser?.company?.iD
            if let coord = Location.sharedInsatnce.getCurrentCoordinate(){
                if(CLLocationCoordinate2DIsValid(coord)){
                    if(coord.latitude > 0 && coord.longitude > 0){
                        
                        param["Latitude"] = coord.latitude
                        param["Longitude"] = coord.longitude
                    }else{
                        SVProgressHUD.dismiss()
                        let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                        let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                            UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                        }
                        Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
                    }
                    if(tfLocation.text?.lowercased() == "office"){
                        param["ClientVendorID"] = NSNumber.init(value:0)
                        var address = AddressInfo()
                        //if(self.activesetting.addressSettingsForAttendance == 1){
                        //address = mutAddressOffice[tfAddress.tag]
                        //}else if(self.activesetting.addressSettingsForAttendance == 2){
                        //    address = mutAddressBranch[tfAddress.tag]
                        //}else {
                        //    address = mutaddressBoth[tfAddress.tag]
                        //   }
                        
                        param["AddressMasterID"] = selectedAddressID//address.address_id
                        param["Type"] = NSNumber.init(value:1)
                    }else if(tfLocation.text?.lowercased() == "customer"){
                        let cust = AttendanceViewController.arrOfSelectedMultipleCustomer[0]//self.arrCustomerList[tfLocation.tag]
                        let add = AttendanceViewController.selectedAddreeList//cust.addressList[tfLocation.tag > 0 ? tfLocation.tag:0] as? AddressList
                        param["ClientVendorID"] =  NSNumber.init(value:cust.iD)
                        param["AddressMasterID"] = add.addressId
                        param["Type"] = NSNumber.init(value:2) //3
                    }else if(tfLocation.text?.lowercased() == "vendor"){
                        let vendor = AttendanceViewController.arrOfSelectedVendor[0]//arrVendorList[tfLocation.tag]
                        let vendorAdd = AttendanceViewController.selectedAddreeList//vendor.addressList[tfLocation.tag] as? AddressList
                        param["ClientVendorID"] = vendor.iD
                        param["AddressMasterID"] = vendorAdd.addressId
                        param["Type"] = NSNumber.init(value:3) // 2
                    }else if(tfLocation.text?.lowercased() == "travel local"){
                        param["Type"] =  NSNumber.init(value:4)
                        param["AddressMasterID"] = NSNumber.init(value:0)
                        param["travelAddress"] = AttendanceViewController.tarvelAddress
                    }else if(tfLocation.text?.lowercased() == "travel upcountry"){
                        param["Type"] = NSNumber.init(value:7)
                        param["AddressMasterID"] = NSNumber.init(value:0)
                        param["travelAddress"] = AttendanceViewController.tarvelAddress
                    }else if(tfLocation.text?.lowercased() == "home"){
                        param["Type"] = NSNumber.init(value:8)
                        param["AddressMasterID"] = self.activeuser?.permanentAddress?.address_id
                    }
                    var strurl  = ""
                    if(statusOFCheckin == true){
                        strurl =  ConstantURL.kWSUrlCheckIn
                    }else{
                        strurl = ConstantURL.kWSUrlCheckOut
                    }
                    var givenImg = UIImage()
                    if  let img  =  selfieImage{
                        param["Is_File"] =  true
                        givenImg  = img
                    }else{
                        param["Is_File"] =  false
                        
                    }
                    print("parameter of check in  = \(param) , url is = \(strurl)")
                    self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: strurl, img: givenImg, imgparamname: "File", param: param) { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                        
                        self.selfieImage = nil
                        if(status.lowercased() == Constant.SucessResponseFromServer){
                            SVProgressHUD.dismiss()
                            if (message.count > 0) {
                                if(message.lowercased() == "you are not at work location"){
                                    self.displayAlert()
                                }
                                Utils.toastmsg(message:message,view: self.view)
                            }
                            print(responseType)
                            let responseDic = arr as? [String:Any] ??   [String:Any]()
                            
                            print("response of checkin = \(responseDic)")
                            
                            //[responseDic]
                            print("total record of attendance = \(AttendanceHistory.getAll().count)")
                            
                            MagicalRecord.save({ (localContext) in
                                AttendanceHistory.mr_truncateAll(in: localContext)
                                let dicOfCheckOut = FEMDeserializer.object(fromRepresentation: responseDic ?? [String:Any](), mapping: AttendanceHistory.defaultMapping(), context: localContext)
                            },
                                               completion: { (status, error) in
                                print("Attendance Detail  Saved")
                                self.checkInButtonGreen()
                            })
                            
                        }
                        else if(error.code == 0){
                            SVProgressHUD.dismiss()
                            self.dismiss(animated: true, completion: nil)
                            if ( message.count > 0 ) {
                                if(message.lowercased() == "you are not at work location"){
                                    self.displayAlert()
                                    //        if((AttendanceViewController.verifycheckinAdd) && (statusOFCheckin)){
                                    //            self.displayAlert()
                                    //        }
                                    //        if((AttendanceViewController.verifycheckoutAdd) && (!(statusOFCheckin))){
                                    //            self.displayAlert()
                                    //        }
                                    //        if((AttendanceViewController.verifycheckinAdd == true && status == true) || (AttendanceViewController.verifycheckoutAdd == true && status == false)){
                                    //        self.displayAlert()
                                    //    }
                                    Utils.toastmsg(message:message,view: self.view)
                                }
                            }
                        }
                        else{
                            SVProgressHUD.dismiss()
                            self.dismiss(animated: true, completion: nil)
                            var msg = ""
                            if let strmsg = error.userInfo["localiseddescription"] as? String {
                                if(strmsg.count == 0){
                                    msg = error.localizedDescription
                                    
                                }else{
                                    msg = strmsg
                                }
                            }
                            Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                            if(msg.lowercased() == "you are not at work location"){
                                self.displayAlert()
                                //        if((AttendanceViewController.verifycheckinAdd) && (statusOFCheckin)){
                                //            self.displayAlert()
                                //        }
                                //        if((AttendanceViewController.verifycheckoutAdd) && (!(statusOFCheckin))){
                                //            self.displayAlert()
                                //        }
                                //    } && ((AttendanceViewController.verifycheckinAdd == true && status == true) || (AttendanceViewController.verifycheckoutAdd == true && status == false))){
                                //        if (self is AttendanceViewController){
                                //        self.displayAlert()
                                //        }
                            }
                        }
                    }
                    
                    
                }else{
                    Utils.toastmsg(message:"Latitude or Longitude is zero, please try again",view:self.view)
                }
            }else{
                let cancelaction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: nil)
                let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: UIAlertAction.Style.default) { (action) in
                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                }
                Common.showalertWithAction(msg: "Please enable Location Services in Settings", arrAction: [cancelaction,settingAction], view: self)
            }
        }
    }
    
    
    //MARK: - Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.count > 0){
            let lastlocation = locations.last
            if let coordinate = lastlocation?.coordinate{
                
                LMGeocoder.sharedInstance().cancelGeocode()
                LMGeocoder.sharedInstance().reverseGeocodeCoordinate(coordinate, service: LMGeocoderServiceGoogle, alternativeService: LMGeocoderServiceApple) { (results, error) in
                    if((results?.count ?? 0 > 0) && (error == nil) ){
                        let address =  results?.first
                        
                        if(address?.formattedAddress?.count ?? 0 > 0){
                            if let addressline = address?.formattedAddress{
                                // print(addressline)
                                self.strCurrentAddress = addressline
                                if((self.tfLocation.text?.lowercased() == "travel local")||(self.tfLocation.text?.lowercased() == "travel upcountry")){
                                    self.lblAddress.text =  addressline
                                    AttendanceViewController.tarvelAddress = addressline
                                }else{
                                    var addressline = ""
                                    
                                    if let ad = address?.streetNumber{
                                        
                                        addressline.append(ad)
                                    }
                                    // neighborhood
                                    if let adneighbourhood = address?.neighborhood{
                                        if(addressline.count > 0){
                                            addressline.append(" , ")
                                        }
                                        addressline.append(adneighbourhood)
                                    }
                                    if let ad1 = address?.subLocality{
                                        if(addressline.count > 0){
                                            addressline.append(" , ")
                                        }
                                        addressline.append(ad1)
                                    }
                                    if let ad2 = address?.locality{
                                        if(addressline.count > 0){
                                            addressline.append(" , ")
                                        }
                                        addressline.append(ad2)
                                    }
                                    if let adcountry = address?.country{
                                        if(addressline.count > 0){
                                            addressline.append(" , ")
                                        }
                                        addressline.append(adcountry)
                                    }
                                    AttendanceViewController.tarvelAddress = addressline
                                    // self.strCurrentAddress =  "not get address"
                                }
                                
                            }
                            else
                            {
                                self.strCurrentAddress = "not get current address"
                                self.lblAddress.text =  "current Location address"
                            }
                            AttendanceViewController.tarvelAddress = self.strCurrentAddress
                        }
                    }else{
                        self.lblAddress.text = "-"
                        if let lastLocation = locations.last as? CLLocation{
                            self.getAddressFromLocation (location:lastLocation) {
                                (address,error)
                                in
                                var strAddress =  ""
                                if let strad1 = address["address1"] as? String{
                                    if(strad1.count > 0){
                                        strAddress.append(String.init(format:"\(strad1),"))
                                    }
                                }
                                if let strad2 = address["address2"] as? String{
                                    if(strad2.count > 0){
                                        strAddress.append(String.init(format:"\(strad2),"))
                                    }
                                }
                                
                                if let strcity = address["city"] as? String{
                                    if(strcity.count > 0){
                                        strAddress.append(String.init(format:"\(strcity),"))
                                    }
                                }
                                
                                
                                if let strstate = address["state"] as? String{
                                    if(strstate.count > 0){
                                        strAddress.append(String.init(format:"\(strstate),"))
                                    }
                                }
                                
                                if let strcountry = address["country"] as? String{
                                    if(strcountry.count > 0){
                                        strAddress.append(String.init(format:"\(strcountry),"))
                                    }
                                }
                                
                                if let strpincode = address["pincode"] as? String{
                                    if(strpincode.count > 0){
                                        strAddress.append(String.init(format:"\(strpincode),"))
                                    }
                                }
                                self.strCurrentAddress = strAddress
                                if(strAddress.count > 0 && ((self.tfLocation.text?.lowercased() == "travel local")||(self.tfLocation.text?.lowercased() == "travel upcountry "))){
                                    self.lblAddress.text = strAddress
                                    AttendanceViewController.tarvelAddress = strAddress
                                    
                                }else{
                                    self.strCurrentAddress = "not get in update current address"
                                    self.lblAddress.text =  "current address"
                                }
                                AttendanceViewController.tarvelAddress =  self.strCurrentAddress
                            }
                            
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func btnCheckInClicked(_ sender: UIButton) {
        btnCheckinClicked = true
        if(tfLocation.tag == 1){
            if((self.activeuser?.isCheckInAllowedFromHome ==  false)&&(tfLocation.text?.lowercased() == "home")){
                tfAddress.isHidden = true
                lbl2Title.isHidden = true
                Common.showalert(msg: "You are not authorized for Home location Check-In or Check-Out", view: self)
                return
            }
        }
        if(self.activesetting.allowSelfieInAttendance == 1){
            if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "customer" || tfLocation.text?.lowercased() == "home"){
                if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "home" ){
                    if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                        AttendanceViewController.verifycheckinAdd = false
                        SVProgressHUD.show()
                        if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                            
                            
                            self.userCheckIn(statusOFCheckin: true)
                        }else{
                            
                            if(AttendanceViewController.verifycheckinAdd){
                                SVProgressHUD.dismiss()
                                self.displayAlert()
                            }else{
                                
                                Utils.toastmsg(message: "Verifying Address", view: self.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    self.verfyingAddress(status: true)
                                }
                                
                                
                            }
                            
                        }
                    }else{
                        if(AttendanceViewController.verifycheckinAdd){
                            self.displayAlert()
                        }else{
                            
                            Utils.toastmsg(message: "Verifying Address", view: self.view)
                            //  Utils.addShadow(view: viewcontroller.view)
                            let secondsToDelay = 4.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                self.verfyingAddress(status: true)
                            }
                            
                            
                        }
                        
                    }
                }else{
                    AttendanceViewController.verifycheckinAdd = false
                    if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                        SVProgressHUD.show()
                        if(self.isableToLoginForCustomer(add: slocation)){
                            
                            self.userCheckIn(statusOFCheckin: true)
                        }else{
                            
                            //        if(AttendanceViewController.verifycheckinAdd){
                            //            SVProgressHUD.dismiss()
                            //        self.displayAlert()
                            //    }else{
                            //
                            //        Utils.toastmsg(message: "Verifying Address", view: self.view)
                            //          //  Utils.addShadow(view: viewcontroller.view)
                            //            let secondsToDelay = 4.0
                            //            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                            //                self.verfyingAddress(status: true)
                            //            }
                            //
                            //
                            //    }
                            
                        }
                    }else{
                        
                        if(AttendanceViewController.verifycheckinAdd){
                            self.displayAlert()
                        }else{
                            
                            Utils.toastmsg(message: "Verifying Address", view: self.view)
                            //  Utils.addShadow(view: viewcontroller.view)
                            let secondsToDelay = 4.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                self.verfyingAddress(status: true)
                            }
                            
                            
                        }
                        
                    }
                }
            }else{
                AttendanceViewController.verifycheckinAdd = false
                self.userCheckIn(statusOFCheckin: true)
            }
        }else if(self.activesetting.allowSelfieInAttendance == 2){
            let noAction = UIAlertAction.init(title: "NO", style: UIAlertAction.Style.cancel) { (action) in
                if(self.tfLocation.text?.lowercased() == "office" || self.tfLocation.text?.lowercased() == "vendor" || self.tfLocation.text?.lowercased() == "customer" || self.tfLocation.text?.lowercased() == "home" ){
                    if(self.tfLocation.text?.lowercased() == "office" || self.tfLocation.text?.lowercased() == "home"){
                        if let slocation = AttendanceViewController.selectedLocation{
                            AttendanceViewController.verifycheckinAdd = false
                            SVProgressHUD.show()
                            if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                                
                                self.userCheckIn(statusOFCheckin: true)
                            }else{
                                
                                if(AttendanceViewController.verifycheckinAdd){
                                    SVProgressHUD.dismiss()
                                    self.displayAlert()
                                }else{
                                    
                                    Utils.toastmsg(message: "Verifying Address", view: self.view)
                                    //  Utils.addShadow(view: viewcontroller.view)
                                    let secondsToDelay = 4.0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                        self.verfyingAddress(status: true)
                                    }
                                    
                                    
                                }
                                
                            }
                        }else{
                            
                            if(AttendanceViewController.verifycheckinAdd){
                                self.displayAlert()
                            }else{
                                
                                Utils.toastmsg(message: "Verifying Address", view: self.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    self.verfyingAddress(status: true)
                                }
                                
                                
                            }
                            
                        }
                    }else{
                        if let slocation = AttendanceViewController.selectedLocation{
                            SVProgressHUD.show()
                            AttendanceViewController.verifycheckinAdd = false
                            if(self.isableToLoginForCustomer(add: slocation)){
                                
                                self.userCheckIn(statusOFCheckin: true)
                            }else{
                                
                                if(AttendanceViewController.verifycheckinAdd){
                                    SVProgressHUD.dismiss()
                                    self.displayAlert()
                                }else{
                                    
                                    Utils.toastmsg(message: "Verifying Address", view: self.view)
                                    //  Utils.addShadow(view: viewcontroller.view)
                                    let secondsToDelay = 4.0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                        self.verfyingAddress(status: true)
                                    }
                                    
                                    
                                }
                                
                            }
                        }else{
                            
                            if(AttendanceViewController.verifycheckinAdd){
                                self.displayAlert()
                            }else{
                                
                                Utils.toastmsg(message: "Verifying Address", view: self.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    self.verfyingAddress(status: true)
                                }
                                
                                
                            }
                            
                        }
                    }
                }else{
                    AttendanceViewController.verifycheckinAdd = false
                    self.userCheckIn(statusOFCheckin: true)
                }
            }
            let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
                self.isCheckIn = true
                self.takeNewPhotoFromCamera()
            }
            Common.showalertWithAction(msg: "Do you want to take selfie?", arrAction: [yesAction,noAction], view: self)
        }else if(self.activesetting.allowSelfieInAttendance == 3){
            let yesAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.destructive) { (action) in
                
                self.takeNewPhotoFromCamera()
            }
            Common.showalertWithAction(msg: "Please take Selfie", arrAction: [yesAction], view: self)
        }
        
    }
    
    
    @IBAction func btnCheckOutClicked(_ sender: UIButton) {
        btnCheckinClicked = false
        if(tfLocation.tag == 1){
            if((self.activeuser?.isCheckInAllowedFromHome ==  false)&&(tfLocation.text?.lowercased() == "home")){
                tfAddress.isHidden = true
                lbl2Title.isHidden = true
                Common.showalert(msg: "You are not authorized for Home location Check-In or Check-Out", view: self)
                return
            }
        }
        SVProgressHUD.show()
        if(self.activesetting.allowSelfieInAttendance == 1){
            if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "customer" || tfLocation.text?.lowercased() == "home"){
                if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "home"){
                    
                    if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                        
                        AttendanceViewController.verifycheckoutAdd = false
                        
                        if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                            self.userCheckIn(statusOFCheckin: false)
                        }else{
                            if(AttendanceViewController.verifycheckoutAdd){
                                SVProgressHUD.dismiss()
                                self.displayAlert()
                            }else{
                                
                                Utils.toastmsg(message: "Verifying Address", view: self.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    self.verfyingAddress(status: false)
                                }
                                
                                
                            }
                        }
                    }else{
                        
                        if(AttendanceViewController.verifycheckinAdd){
                            self.displayAlert()
                        }else{
                            
                            Utils.toastmsg(message: "Verifying Address", view: self.view)
                            //  Utils.addShadow(view: viewcontroller.view)
                            let secondsToDelay = 4.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                self.verfyingAddress(status: true)
                            }
                            
                            
                        }
                        
                    }
                }else{
                    if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                        SVProgressHUD.show()
                        AttendanceViewController.verifycheckoutAdd = false
                        if(self.isableToLoginForCustomer(add: slocation)){
                            self.userCheckIn(statusOFCheckin: false)
                        }else{
                            if(AttendanceViewController.verifycheckoutAdd){
                                SVProgressHUD.dismiss()
                                self.displayAlert()
                            }else{
                                
                                Utils.toastmsg(message: "Verifying Address", view: self.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    self.verfyingAddress(status: false)
                                }
                                
                                
                            }
                        }
                    }else{
                        
                        //        if(AttendanceViewController.verifycheckoutAdd){
                        //        self.displayAlert()
                        //    }else{
                        //
                        //        Utils.toastmsg(message: "Verifying Address", view: self.view)
                        //          //  Utils.addShadow(view: viewcontroller.view)
                        //            let secondsToDelay = 4.0
                        //            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                        //                self.verfyingAddress(status: false)
                        //            }
                        //
                        //
                        //    }
                        
                    }
                }
            }else{
                AttendanceViewController.verifycheckoutAdd = false
                self.userCheckIn(statusOFCheckin: false)
            }
        }else if(self.activesetting.allowSelfieInAttendance == 2){
            let noAction = UIAlertAction.init(title: "NO", style: UIAlertAction.Style.cancel) { (action) in
                if(self.tfLocation.text?.lowercased() == "office" || self.tfLocation.text?.lowercased() == "vendor" || self.tfLocation.text?.lowercased() == "customer" || self.tfLocation.text?.lowercased() == "home" ){
                    if(self.tfLocation.text?.lowercased() == "office" || self.tfLocation.text?.lowercased() == "home"){
                        
                        if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                            AttendanceViewController.verifycheckoutAdd = false
                            SVProgressHUD.show()
                            if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                                self.userCheckIn(statusOFCheckin: false)
                            }else{
                                
                                if(AttendanceViewController.verifycheckoutAdd){
                                    SVProgressHUD.dismiss()
                                    self.displayAlert()
                                }else{
                                    
                                    Utils.toastmsg(message: "Verifying Address", view: self.view)
                                    //  Utils.addShadow(view: viewcontroller.view)
                                    let secondsToDelay = 4.0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                        self.verfyingAddress(status: false)
                                    }
                                    
                                    
                                }
                                
                            }
                        }else{
                            if(AttendanceViewController.verifycheckinAdd){
                                
                                self.displayAlert()
                            }else{
                                
                                Utils.toastmsg(message: "Verifying Address", view: self.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    self.verfyingAddress(status: true)
                                }
                                
                                
                            }
                            
                        }
                    }else{
                        if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                            AttendanceViewController.verifycheckoutAdd = false
                            if(self.isableToLoginForCustomer(add: slocation)){
                                SVProgressHUD.show()
                                
                                self.userCheckIn(statusOFCheckin: false)
                            }else{
                                
                                if(AttendanceViewController.verifycheckoutAdd){
                                    SVProgressHUD.dismiss()
                                    self.displayAlert()
                                }else{
                                    
                                    Utils.toastmsg(message: "Verifying Address", view: self.view)
                                    //  Utils.addShadow(view: viewcontroller.view)
                                    let secondsToDelay = 4.0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                        self.verfyingAddress(status: false)
                                    }
                                    
                                    
                                }
                                
                            }
                        }else{
                            
                            if(AttendanceViewController.verifycheckoutAdd){
                                self.displayAlert()
                            }else{
                                
                                Utils.toastmsg(message: "Verifying Address", view: self.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    self.verfyingAddress(status: false)
                                }
                                
                                
                            }
                            
                        }
                    }
                }else{
                    AttendanceViewController.verifycheckoutAdd = false
                    self.userCheckIn(statusOFCheckin: false)
                }
            }
            let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
                
                self.takeNewPhotoFromCamera()
            }
            Common.showalertWithAction(msg: "Do you want to take selfie?", arrAction: [yesAction,noAction], view: self)
        }else if(self.activesetting.allowSelfieInAttendance == 3){
            let yesAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.destructive) { (action) in
                self.isCheckIn = true
                self.takeNewPhotoFromCamera()
            }
            Common.showalertWithAction(msg: "Please take Selfie", arrAction: [yesAction], view: self)
        }
        
    }
    
    
    
    @IBAction func btnManualRequestClicked(_ sender: UIButton) {
        if let  manualvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.ManualCheckIn) as? ManualAttendanceController{
            // self.popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
            manualvisit.parentviewForpopup =  self.view
            Utils.addShadow(view: self.view)
            manualvisit.modalPresentationStyle = .overCurrentContext
            self.present(manualvisit, animated: true, completion: nil) //self.navigationController?.pushViewController(manualvisit, animated: true)
        }
        
    }
    
    @IBAction func btnHIstoryClicked(_ sender: UIButton) {
        
        if let  userhistory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceSelfHistory) as? AttendanceUserHistoryController{
            userhistory.memberId = self.activeuser?.userID
            
            self.navigationController?.pushViewController(userhistory, animated: true)
        }
    }
    
    @IBAction func btnUpdateWorkLocationClicked(_ sender: UIButton) {
        if let updateworklocation = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.WorkLocationController) as? WorkLocationController{
            self.navigationController?.pushViewController(updateworklocation, animated: true)
        }
        
    }
    
    @IBAction func btnValidAttendanceClicke(_ sender: UIButton) {
        if let updateworklocation = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.ValidAttendanceViewController) as? ValidAttendanceViewController{
            self.navigationController?.pushViewController(updateworklocation, animated: true)
        }
    }
    
    
}

//extension AttendanceViewController:UIPickerViewDelegate,UIPickerViewDataSource{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//     return  1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if(pickerView.tag == LocationTag){
//            return arrType.count
//        }else if(pickerView.tag == NameTag){
//            if(tfLocation.text?.lowercased() == "office"){
//                if(self.activesetting.addressSettingsForAttendance.intValue == 1 ){
//                      return 0
//                }else if(self.activesetting.addressSettingsForAttendance.intValue == 2){
//                    return 0
//                }else{
//                    return 0
//                }
//            }
//           // if(self.activesetting.)
//        else if (tfLocation.text?.lowercased() == "home"){
//            return 1;
//        }else if (tfLocation.text?.lowercased() == "customer"){
//              return 0
//           // return self.arrCustomerList.count;
//        }else if (tfLocation.text?.lowercased() == "vendor"){
//              return 0
//            //return self.arrVendorList.count;
//        }else{
//            return 0
//        }
//        }else if (pickerView.tag == AddressTag){
//            if(tfLocation.text?.lowercased() == "customer"){
//                 return 0
//            }else if(tfLocation.text?.lowercased() == "vendor"){
//                 return 0
//            }else{
//                return 0
//            }
//        }else{
//            return 0
//        }
//    }
//
//
//}
extension AttendanceViewController:CLLocationManagerDelegate{
    
}
extension AttendanceViewController:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfLocation){
            print(dropdownLocation.dataSource)
            dropdownLocation.reloadAllComponents()
            dropdownLocation.show()
            return false
        }else if(textField == tfAddress){
            
            if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "home" ){
                dropdownAddress.reloadAllComponents()
                dropdownAddress.show()
            }else if(tfLocation.text?.lowercased() == "customer"){
                popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                popup?.isFromSalesOrder =  false
                popup?.modalPresentationStyle = .overCurrentContext
                popup?.strTitle = ""
                popup?.nonmandatorydelegate = self
                popup?.arrOfList = arrCustomerList
                popup?.strLeftTitle = ""
                popup?.strRightTitle = ""
                popup?.selectionmode = SelectionMode.none
                popup?.arrOfSelectedSingleCustomer = AttendanceViewController.arrOfSelectedMultipleCustomer
                popup?.isSearchBarRequire = true
                popup?.viewfor = ViewFor.customer
                popup?.isFilterRequire = false
                // popup?.showAnimate()
                popup?.parentViewOfPopup = self.view
                
                Utils.addShadow(view: self.view)
                
                self.present(popup!, animated: false, completion: nil)
                
                return false
            }else if(tfLocation.text?.lowercased() == "vendor"){
                
                
                
                
                
                
                
                popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView)  as? CustomerSelection
                popup?.isFromSalesOrder =  false
                popup?.modalPresentationStyle = .overCurrentContext
                popup?.strTitle = ""
                popup?.nonmandatorydelegate = self
                popup?.arrOfVendor = arrVendorList
                popup?.strLeftTitle = ""
                popup?.strRightTitle = ""
                popup?.selectionmode = SelectionMode.none
                popup?.arrOfSelectedVendor = AttendanceViewController.arrOfSelectedVendor
                popup?.isSearchBarRequire = true
                popup?.viewfor = ViewFor.vendor
                popup?.isFilterRequire = false
                popup?.parentViewOfPopup = self.view
                if let shadowview = Utils.shadowView{
                    if(self.view.subviews.contains(shadowview)){
                        
                    }else{
                        Utils.addShadow(view: self.view)
                    }
                }else{
                    Utils.addShadow(view: self.view)
                }
                self.present(self.popup!, animated: false, completion: nil)
                
                
            }
            return false
        }else if(textField == tf3Value){
            print(dropdownCustomerVendor.dataSource)
            if(tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "customer"){
                dropdownCustomerVendor.reloadAllComponents()
                dropdownCustomerVendor.show()
            }
            return false
        }
        return true
    }
}

extension AttendanceViewController :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true
                       , completion:   nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //  SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        isSelefieAvailbale = true
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            selfieImage = chosenImage
            SVProgressHUD.dismiss()
            //        if let ate = AttendanceHistory.getLatestAttendanceForDate(date: Date() ,userID:self.activeuser?.userID ?? 0){
            //
            //            print("checkin type = \(ate.checkInAttendanceType) ,  checkout type = \(ate.checkOutAttendanceType)")
            //            if((ate.checkInAttendanceType > 0) && (ate.checkOutAttendanceType == 0)){
            //                if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "customer" || tfLocation.text?.lowercased() == "home"){
            //                if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "home"){
            //                    if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
            //                        if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
            //
            //                   AttendanceViewController.verifycheckoutAdd = false
            //    self.userCheckIn(status: false)
            //                        }else{
            //
            //                            self.displayAlert()
            //                        }
            //                }else{
            //                        self.displayAlert()
            //                     }
            //            }else{
            //                if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
            //                if(self.isableToLoginForCustomer(add: slocation)){
            //                   AttendanceViewController.verifycheckoutAdd = false
            //    self.userCheckIn(status: false)
            //                }else{
            //                    self.displayAlert()
            //                     }
            //                    }else{
            //                                         self.displayAlert()
            //                                    }
            //                                }
            //                            }else{
            //                               AttendanceViewController.verifycheckoutAdd = false
            //   self.userCheckIn(status: false)
            //                            }
            //
            //
            //
            //        }else{
            //            if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "customer" || tfLocation.text?.lowercased() == "home"){
            //            if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "home"){
            //                if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
            //                    if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
            //                        if(btnCheckinClicked){
            //                           AttendanceViewController.verifycheckinAdd = false
            //    self.userCheckIn(status: true)
            //                        }else{
            //               AttendanceViewController.verifycheckoutAdd = false
            //    self.userCheckIn(status: false)
            //                        }
            //                    }else{
            //                        self.displayAlert()
            //                    }
            //            }else{
            //                    self.displayAlert()
            //                 }
            //                }else{
            //            if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
            //            if(self.isableToLoginForCustomer(add: slocation)){
            //                if(btnCheckinClicked){
            //                   AttendanceViewController.verifycheckinAdd = false
            //   self.userCheckIn(status: true)
            //                }else{
            //       AttendanceViewController.verifycheckoutAdd = false
            //    self.userCheckIn(status: false)
            //                }
            //            }else{
            //                self.displayAlert()
            //                 }
            //                }else{
            //                                     self.displayAlert()
            //                                }
            //                            }
            //                        }else{
            //                            if(btnCheckinClicked){
            //                               AttendanceViewController.verifycheckinAdd = false
            //    self.userCheckIn(status: true)
            //                            }else{
            //                   AttendanceViewController.verifycheckoutAdd = false
            //    self.userCheckIn(status: false)
            //                            }
            //                        }
            //        }
            //
            //        }else{
            if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "customer" || tfLocation.text?.lowercased() == "home"){
                
                if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "home"){
                    if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                        if(btnCheckinClicked){
                            AttendanceViewController.verifycheckinAdd = false
                            
                        }else{
                            AttendanceViewController.verifycheckoutAdd = false
                        }
                        SVProgressHUD.show()
                        if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                            if(btnCheckinClicked){
                                AttendanceViewController.verifycheckinAdd = false
                                self.userCheckIn(statusOFCheckin: true)
                            }else{
                                AttendanceViewController.verifycheckoutAdd = false
                                self.userCheckIn(statusOFCheckin: false)
                            }
                        }else{
                            if(btnCheckIn.currentTitle?.lowercased() == "check-in"){
                                if let verifyAdd = AttendanceCheckInCheckOut.verifycheckinAdd{
                                    print(verifyAdd)
                                }else{
                                    AttendanceCheckInCheckOut.verifycheckinAdd = false
                                }
                                if(AttendanceCheckInCheckOut.verifycheckinAdd){
                                    AttendanceCheckInCheckOut().displayAlert(displayview:self)
                                }else{
                                    
                                    AttendanceViewController.verifycheckinAdd = false
                                    AttendanceCheckInCheckOut().userCheckIn(status: true, viewController: self)
                                }
                            }else{
                                if let verifyAdd = AttendanceCheckInCheckOut.verifycheckoutAdd{
                                    print(verifyAdd)
                                }else{
                                    AttendanceCheckInCheckOut.verifycheckoutAdd = false
                                }
                                if( AttendanceCheckInCheckOut.verifycheckoutAdd){
                                    AttendanceCheckInCheckOut().displayAlert(displayview:self)
                                }else{
                                    AttendanceViewController.verifycheckoutAdd = false
                                    AttendanceCheckInCheckOut().userCheckIn(status: false, viewController: self)
                                }
                            }
                        }
                    }else{
                        if(AttendanceViewController.verifycheckinAdd){
                            SVProgressHUD.show()
                            self.displayAlert()
                        }else{
                            
                            Utils.toastmsg(message: "Verifying Address", view: self.view)
                            //  Utils.addShadow(view: viewcontroller.view)
                            let secondsToDelay = 4.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                self.verfyingAddress(status: false)
                            }
                            
                            
                        }
                    }
                }else{
                    if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                        SVProgressHUD.show()
                        if(btnCheckinClicked){
                            AttendanceViewController.verifycheckinAdd = false
                            
                        }else{
                            AttendanceViewController.verifycheckoutAdd = false
                        }
                        if(self.isableToLoginForCustomer(add: slocation)){
                            
                            if(btnCheckinClicked){
                                AttendanceViewController.verifycheckinAdd = false
                                self.userCheckIn(statusOFCheckin: true)
                            }else{
                                AttendanceViewController.verifycheckoutAdd = false
                                self.userCheckIn(statusOFCheckin: false)
                            }
                        }else{
                            if(btnCheckinClicked){
                                if(AttendanceViewController.verifycheckoutAdd){
                                    SVProgressHUD.dismiss()
                                    self.displayAlert()
                                }else{
                                    
                                    Utils.toastmsg(message: "Verifying Address", view: self.view)
                                    //  Utils.addShadow(view: viewcontroller.view)
                                    let secondsToDelay = 4.0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                        
                                        self.verfyingAddress(status: false)
                                    }
                                    
                                    
                                }
                            }
                            else{
                                if(AttendanceViewController.verifycheckoutAdd){
                                    SVProgressHUD.dismiss()
                                    self.displayAlert()
                                }else{
                                    
                                    Utils.toastmsg(message: "Verifying Address", view: self.view)
                                    //  Utils.addShadow(view: viewcontroller.view)
                                    let secondsToDelay = 4.0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                        
                                        self.verfyingAddress(status: false)
                                    }
                                    
                                    
                                }
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                    }else{
                        if(btnCheckinClicked){
                            if(AttendanceViewController.verifycheckinAdd){
                                self.displayAlert()
                            }else{
                                
                                Utils.toastmsg(message: "Verifying Address", view: self.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    
                                    self.verfyingAddress(status: true)
                                }
                                
                                
                            }
                        }
                        else{
                            if(AttendanceViewController.verifycheckoutAdd){
                                self.displayAlert()
                            }else{
                                
                                Utils.toastmsg(message: "Verifying Address", view: self.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    
                                    self.verfyingAddress(status: false)
                                }
                                
                                
                            }
                        }
                    }
                }
                
            }else{
                if(btnCheckinClicked){
                    AttendanceViewController.verifycheckinAdd = false
                    
                }else{
                    AttendanceViewController.verifycheckoutAdd = false
                }
                if(btnCheckinClicked){
                    AttendanceViewController.verifycheckinAdd = false
                    self.userCheckIn(statusOFCheckin: true)
                }else{
                    AttendanceViewController.verifycheckoutAdd = false
                    self.userCheckIn(statusOFCheckin: false)
                }
            }
        }
        
        // }
        dismiss(animated:true, completion: nil)
        
    }
}

extension AttendanceViewController:PopUpDelegateNonMandatory{
    
    func completionData(arr: [CustomerDetails]) {
        self.dismiss(animated: true, completion: nil)
        Utils.removeShadow(view: self.view)
        print("Selected customers \(arr)")
        AttendanceViewController.arrOfSelectedMultipleCustomer = arr
        tfAddress.text = arr.first?.name
        if(tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "customer"){
            tf3Value.inputView = dropdownCustomerVendor
        }
        dropdownCustomerVendor.dataSource = [String]()
        if(arr.first?.addressList.count ?? 0 > 0){
            if let arrCust = arr.first?.addressList as? NSOrderedSet
            {
                
                arrCust.enumerateObjects { (elem, idx, stop) -> Void in
                    let add =  elem as? AddressList
                    let address =  AddressListModel().getaddressListModelWithDic(dict: add?.toDictionary() ?? [String:Any]())
                    AttendanceViewController.selectedAddreeList =  address
                    
                    
                    let floatlat = Float(add?.lattitude ?? "0.0000") //add?.lattitude ?? 0.00////Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                    
                    let floatlong = Float(add?.longitude ?? "0.0000") //add?.longitude ?? 0.00 // //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                    
                    let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                    AttendanceViewController.selectedLocation = location
                    print("selected location \(location)")
                    self.updateAddresslabel()
                    var strad = ""
                    if let ad1 = add?.addressLine1 {
                        strad.append("\(ad1),")
                    }
                    if let ad2 =  add?.addressLine2 as? String {
                        strad.append("\(ad2),")
                    }
                    if let city =  add?.city as? String {
                        strad.append("\(city),")
                    }
                    if let country =  add?.country as? String {
                        strad.append(country)
                    }
                    dropdownCustomerVendor.dataSource.append(strad)
                }
                tf3Value.text = dropdownCustomerVendor.dataSource.first
                /* dropdownCustomerVendor.dataSource = arrCust.map{
                 var strad = ""
                 if let ad1 = $0.addressLine1 as? String {
                 strad.append("\(ad1),")
                 }
                 if let ad2 =  $0.addressLine2 as? String {
                 strad.append("\(ad2),")
                 }
                 if let city =  $0.city as? String {
                 strad.append("\(city),")
                 }
                 if let country =  $0.country as? String {
                 strad.append(country)
                 }
                 //        let str = String.init(format:"\(self.addressLine1) , \(self.addressLine2),\(self.city),\(self.country)")
                 
                 return strad
                 }*/
            }
        }
    }
    func completionSelectedVendor(arr: [Vendor]) {
        self.dismiss(animated: true, completion: nil)
        Utils.removeShadow(view: self.view)
        print("Selected Vendor \(arr)")
        AttendanceViewController.arrOfSelectedVendor = arr
        tfAddress.text = arr.first?.name
        if(tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "customer"){
            tf3Value.inputView = dropdownCustomerVendor
        }
        dropdownCustomerVendor.dataSource = [String]()
        if(arr.first?.addressList.count ?? 0 > 0){
            if let arrCust = arr.first?.addressList as? NSOrderedSet
            {
                arrCust.enumerateObjects { (elem, idx, stop) -> Void in
                    
                    
                    let add =  elem as? AddressList
                    let address =  AddressListModel().getaddressListModelWithDic(dict: add?.toDictionary() ?? [String:Any]())
                    AttendanceViewController.selectedAddreeList =  address
                    let floatlat = Float(add?.lattitude ?? "0.0000")//add?.lattitude ?? 0.00//Float(add?.lattitude ?? "0.0000") //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                    
                    let floatlong = Float(add?.longitude ?? "0.0000")
                    //add?.longitude ?? 0.00 // //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                    //                let floatlat = Float(add?.lattitude ?? "0.0000") //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                    //
                    //                let floatlong = Float(add?.longitude ?? "0.0000") //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                    
                    let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                    print("Checkin location  = \(location)")
                    AttendanceViewController.selectedLocation = location
                    self.updateAddresslabel()
                    var strad = ""
                    if let ad1 = add?.addressLine1 as? String {
                        strad.append("\(ad1),")
                    }
                    if let ad2 =  add?.addressLine2 as? String {
                        strad.append("\(ad2),")
                    }
                    if let city =  add?.city as? String {
                        strad.append("\(city),")
                    }
                    if let country =  add?.country as? String {
                        strad.append(country)
                    }
                    dropdownCustomerVendor.dataSource.append(strad)
                }
            }
        }
        tf3Value.textColor = UIColor.black
        
        tf3Value.text = dropdownCustomerVendor.dataSource.first
        
    }
    
    
    
}

