//
//  WorkLocationController.swift
//  SuperSales
//
//  Created by Apple on 25/05/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
import CoreLocation
import FastEasyMapping

class WorkLocationController: BaseViewController {

    let LocationTag = 1000
    let NameTag =  2000
    let AddressTag =  3000
    
    
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var tfLocation: UITextField!
    
    @IBOutlet var tfAddress: UITextField!
    @IBOutlet var tf3: UITextField!
    var dropdownLocation = DropDown()
    var dropdownAddress = DropDown()
    var arrType:[AttendanceLocation] = [AttendanceLocation]()
    var currentCompany:Company?
    var arrCustomerList:[CustomerDetails] = [CustomerDetails]()
    var arrVendorList:[Vendor] = [Vendor]()
    var mutaddressBoth:[AddressInfo] = [AddressInfo]()
    var mutAddressOffice:[AddressInfo] = [AddressInfo]()
    var mutAddressBranch:[AddressInfo] = [AddressInfo]()
    var dropdownCustomerVendor = DropDown()
    var selectedAddress:AddressInfo? = AddressInfo()
    var selectedAddreeList:AddressListModel = AddressListModel()
    var popup:CustomerSelection!
    var arrOfSelectedMultipleCustomer:[CustomerDetails] = [CustomerDetails]()
    var arrOfSelectedVendor:[Vendor] = [Vendor]()
    
    @IBOutlet var lblAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
  
    
    
    //MARK: - Method
    func setUI(){
        self.tfAddress.isUserInteractionEnabled = true
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        tfLocation.delegate = self
        tfAddress.delegate = self
        tf3.delegate = self
        lbl1.setMultilineLabel(lbl: lbl1)
        lbl2.setMultilineLabel(lbl: lbl2)
        lbl3.setMultilineLabel(lbl: lbl3)
        self.title = "Update Work Location"
        self.tfLocation.addBorders(edges: [.bottom], color: UIColor.black, cornerradius: 0)
        self.tfAddress.addBorders(edges: [.bottom], color: UIColor.black, cornerradius: 0)
         let arrCompany = Company.getAll()
        AttendanceViewController.arrType = [AttendanceLocation]()
              if(arrCompany.count > 0){
                  currentCompany =  arrCompany.first
              }
              if(currentCompany?.officeType?.intValue  == 1){
                  let dic = ["key":NSNumber.init(value:0),"Location":"Office"] as [String : Any] 
                  let atl = AttendanceLocation().initWithDic(dic: dic)
                  arrType.append(atl)
              }
              
              if(currentCompany?.homeType?.intValue  == 1){
                  let dic = ["key":NSNumber.init(value:1),"Location":"Home"] as [String : Any] 
                  let atl = AttendanceLocation().initWithDic(dic: dic)
                  arrType.append(atl)
              }
              
              if(currentCompany?.travelLocalType?.intValue  == 1){
                         let dic = ["key":NSNumber.init(value:2),"Location":"Travel Local"] as [String : Any] 
                         let atl = AttendanceLocation().initWithDic(dic: dic)
                                    arrType.append(atl)
                     }
        
        if(currentCompany?.travelUpCountryType?.intValue  == 1){
        let dic = ["key":NSNumber.init(value:3),"Location":"Travel Upcountry"] as [String : Any] 
        let atl = AttendanceLocation().initWithDic(dic: dic)
        arrType.append(atl)
        }
        
             if(currentCompany?.vendorType?.intValue  == 1){
                  let dic = ["key":NSNumber.init(value:4),"Location":"Vendor"] as [String : Any] 
                  let atl = AttendanceLocation().initWithDic(dic: dic)
                             arrType.append(atl)
              }
              
              if(currentCompany?.customerType?.intValue  == 1){
                        let dic = ["key":NSNumber.init(value:5),"Location":"Customer"] as [String : Any] 
                        let atl = AttendanceLocation().initWithDic(dic: dic)
                                   arrType.append(atl)
                    }
      
//        arrCustomerList = CustomerDetails.getAllCustomers()
//        arrVendorList =  [Vendor]()//Vendor.getAll()
        arrCustomerList = CustomerDetails.getAllCustomers()
        arrVendorList =  Vendor.getAll()
        self.hideTextField()
        
        mutAddressOffice = self.activeuser?.company?.addressList ?? [AddressInfo]()
        
        if(self.activeuser?.branchAddress ==  nil){
            
        }
        
          mutaddressBoth = self.activeuser?.company?.addressList ?? [AddressInfo]()
        
       
        let dicdefaultSetting = Utils.getDefaultDicValue(key: Constant.kUserDefault)
        if(dicdefaultSetting.keys.count > 0){
            let dsettingModel = DefaultSettingModel().getdefaultSettingModelWithDic(dict: dicdefaultSetting)
            AttendanceCheckInCheckOut.defaultsetting = dsettingModel
               self.fillData()
            }else{
              self.loadDefaultSetting()
               }
        
    }
    
    func loadDefaultSetting(){
        var param =  Common.returndefaultparameter()
        param["Type"] = "default"
        param["MemberID"] = self.activeuser?.userID
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetDefaultSetting, method: Apicallmethod.get){ (pagesavailable,lastsynctime,arr,status,message,error,responseType) in
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
                   }
    MagicalRecord.save({ (localcontext) in
    DefaultSetting.mr_truncateAll(in: localcontext)
        let arr =  FEMDeserializer.collection(fromRepresentation: [dic], mapping: DefaultSetting.defaultMapping(), context: localcontext)
                    
        }) { (status, error) in
                    if(error == nil){
                        print("setting saved")
                    }
                }
        }else if(error.code == 0){
              self.dismiss(animated: true, completion: nil)
                       self.view.makeToast(message)
        }else{
              self.dismiss(animated: true, completion: nil)
                      self.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                   }
        }
    }
    
    func fillData(){
    let dsetting = AttendanceCheckInCheckOut.defaultsetting
    if let address = dsetting?.clientAddress
            as? AddressListModel{
            if let locationType = dsetting?.locationType as? NSNumber{
                print("Location type = \(locationType)")
        if(locationType ==  NSNumber.init(value: 1)){
        tfLocation.text = "Office"
                
        let setting = self.activesetting
        if((setting.addressSettingsForAttendance == NSNumber.init(value:1)) || (setting.addressSettingsForAttendance == NSNumber.init(value:3)) || (self.activeuser?.branchAddress ==  nil)){
       if(address != nil){
    // let addModel =  AddressListModel().getaddressListModelWithDic(dict: address)
        selectedAddreeList =  address

        let floatlat = Float(selectedAddreeList.lattitude ?? "0.00000")
                                   
        let floatlong = Float(selectedAddreeList.longitude ?? "0.0000")
                                
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
        
    tfAddress.text = strAddress
       // tfAddress.text = String.init(format:"\(address.addressLine1 ?? "hjgvjhvjh") , \(address.addressLine2 ?? "fcgytvfgvju") , \(address.city) , \(address.state ?? "fhgvjgj"), \(address.country)",[])
                                    
        tfAddress.tag = self.getAddressIndex(addressId: Int(address.addressId ?? 0))
                                }else{
            if(self.activeuser?.company?.addressList?.count ?? 0 > 0){
            let add = self.activeuser?.company?.addressList?[0]
                selectedAddress = add
                let floatlat = Float(selectedAddress?.lat ?? "0.00000")
                
                let floatlong = Float(selectedAddress?.lng ?? "0.0000")
            
                let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
            AttendanceViewController.selectedLocation = location
            tfAddress.text = add?.addressString()
            tfAddress.tag = self.getAddressIndex(addressId: add?.address_id ?? 0)
                                    }
                                }
                                
                            }
            else{
            let address = self.activeuser?.branchAddress
            selectedAddress =  address
                let floatlat = Float(selectedAddress?.lat ?? "0.00000")
                   
                   let floatlong = Float(selectedAddress?.lng ?? "0.0000")
               
                   let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                AttendanceViewController.selectedLocation = location
            if(address?.addressString().count ?? 0 > 0){
            tfAddress.text = address?.addressString()
            }else{
            tfAddress.text =         String.init(format:"\(address?.addressLine1),\(address?.addressLine2),\(address?.city),\(address?.country)")
                                }
            }
            self.hideTextField()
                            
                        }else if(locationType ==  NSNumber.init(value: 2)){
            if(!(Utils.isCustomerMapped(cid: dsetting?.clientvendorid ?? NSNumber.init(value:0)))){
                                tfLocation.text = "Office"
                                
                                
        let add = self.activeuser?.company?.addressList?[0] as? AddressInfo
        selectedAddress = add
        //AttendanceViewController.selectedLocation = CLLocation.init(latitude: Double(add?.lat ?? 0.00), longitude: Double(add?.lng ?? 0.00))
                                
                                tfAddress.text = add?.addressString()
                                tfAddress.tag = self.getAddressIndex(addressId: add?.address_id ?? 0)
                                self.hideTextField()
                                return
                            }
                            tfLocation.text = "Customer"
                            
                            tfAddress.text = dsetting?.clientName
                            selectedAddreeList = address
                            let latdouble = Float(address.lattitude ?? "0.0000")
                            let longdouble = Float(address.longitude ?? "0.0000")
    //                        map.lattitude = NSNumber.init(value:latdouble ?? 0.00)
    //                        map.longitude = NSNumber.init(value:longdouble ?? 0.00)
    //    AttendanceViewController.selectedLocation =  CLLocation.init(latitude: latdouble, longitude: longdouble)
     var strAdd = ""
                            if let stradd1 = selectedAddreeList.addressLine1{
                                strAdd.append(stradd1)
                            }
                            if let stradd2 = selectedAddreeList.addressLine2{
                                strAdd.append(stradd2)
                            }
                            if let strAddCity = selectedAddreeList.city{
                                strAdd.append(strAddCity)
                            }
                            if let strAddState = selectedAddreeList.state{
                                strAdd.append(strAddState)
                            }
                            if let strAddCountry = selectedAddreeList.country{
                                strAdd.append(strAddCountry)
                            }
        tf3.text = strAdd  //String.init(format:"\(selectedAddreeList.addressLine1),\(selectedAddreeList.addressLine2),\(selectedAddreeList.city),\(selectedAddreeList.state),\(selectedAddreeList.country)")
            tfAddress.tag =  self.getCustomerIndex(customerId: dsetting?.clientvendorid?.intValue ?? 0)
            tf3.tag =  self.getAddressIndex(addressId: dsetting?.addressID?.intValue ?? 0)
                            showTextFiled()
                            
            //tfLocation.tag = self.
                            
                        }else if(locationType ==  NSNumber.init(value: 3)){
                            if(self.arrVendorList.count == 0){
                        //    dsetting?.setValue(NSNumber.init(value:1), forKey: "location_type")
                                let setting =      AttendanceCheckInCheckOut.defaultsetting
                                     setting?.locationType = NSNumber.init(value:1)
                                  //   Utils.setDefultvalue(key: Constant.kUserDefault, value: setting)
                                let setting1  =  Utils.getDefaultDicValue(key: Constant.kUserDefault)
                                self.fillData()
                                return
                            }
        tfLocation.text = "Vendor"
                           
        selectedAddreeList =  address
        let latdouble = address.lattitude as? Double ?? 0.00
        let longdouble = address.longitude as? Double ?? 0.00
                 //           AttendanceViewController.selectedLocation =  CLLocation.init(latitude: latdouble , longitude: longdouble)
            tfAddress.text = dsetting?.clientName
             //   tf3.text = String.init(format:"\(selectedAddreeList.addressLine1)")
                            var strAdd = ""
                        if let stradd1 = selectedAddreeList.addressLine1{
                                                       strAdd.append(stradd1)
                                                   }
                                                   if let stradd2 = selectedAddreeList.addressLine2{
                                                       strAdd.append(stradd2)
                                                   }
                                                   if let strAddCity = selectedAddreeList.city{
                                                       strAdd.append(strAddCity)
                                                   }
                                                   if let strAddState = selectedAddreeList.state{
                                                       strAdd.append(strAddState)
                                                   }
                                                   if let strAddCountry = selectedAddreeList.country{
                                                       strAdd.append(strAddCountry)
                                                   }
                               tf3.text = strAdd
            tfAddress.tag = self.getVendorIndex(vendorId: dsetting?.clientvendorid.intValue ?? 0)
                            let vendor = self.arrVendorList[tfAddress.tag]
                        tf3.tag = self.getAddressFromVendor(ven: vendor, addressId: dsetting?.addressID as! NSInteger)
                            showTextFiled()
                            }
        if (locationType == NSNumber.init(value:4)){
                            tfLocation.text = "Travel Local"
                            
                            
                                lbl2.isHidden = true
                                lbl3.isHidden = true
                                tf3.isHidden = true
                            tfAddress.isHidden = true
                            lblAddress.isHidden = false
                        }
                            
                if (locationType == NSNumber.init(value:7)){
                    tfLocation.text = "Travel Upcountry"
                    
                    
                    lbl2.isHidden = true
                    lbl3.isHidden = true
                    tf3.isHidden = true
                                                   tfAddress.isHidden = true
                                                   lblAddress.isHidden = false
                                               }
                let strarrLocation = self.arrType.map{
                    $0.location
                }
                let arrKey = self.arrType.map{
                    $0.key
                }
    if (locationType == NSNumber.init(value:8)){
        tfLocation.text = "Home"
        
        
//        lbl1.isHidden = false
//        tfLocation.isHidden = false
                lbl3.isHidden = true
                tf3.isHidden = true
      
        lblAddress.isHidden = false
        
//    if(self.activeuser?.isCheckInAllowedFromHome == false){
//
//
//
//                                }else{
                                    tfAddress.isHidden = false
                                   lblAddress.isHidden = false
                                    tfAddress.text = self.activeuser?.permanentAddress?.addressString()
        if let stradd = self.activeuser?.permanentAddress?.addressString() as? String{
        self.lblAddress.text = String.init(format:"Address: \n \(stradd)")
        }
//        showTextFiled()
//                                    self.hideTextField()
//                              //  }
                            }
               
                let arrLocation  = self.arrType.map { (location) in
                    return location.location
                }
                if(!(arrLocation.contains(tfLocation.text))){
                    if(arrLocation.count > 0){
    if(arrKey.contains(NSNumber.init(value:1)) && self.activeuser?.isCheckInAllowedFromHome == false){
        if((self.arrType.count > 1) && (arrKey.first == NSNumber.init(value:1))){
        tfLocation.text = strarrLocation.first as! String
                                    

                                    tfAddress.isHidden = false
                                    lblAddress.isHidden = false
                                }else{
                                    tfAddress.isHidden = true
                                    lblAddress.isHidden = true
//                                    if(arrKey.contains(NSNumber.init(value: 1))){
//                                        Common.showalert(msg: "You are not authorized for Home location Check-In or Check-Out", view: self)
//                                    }
        tfLocation.text = strarrLocation.first as! String

                                    
                                }
                            }else{
                                tfLocation.text = strarrLocation.first as! String
                                
                              
                                if((tfLocation.text?.lowercased() == "office")||(tfLocation.text?.lowercased() == "home")||(tfLocation.text?.lowercased() == "vendor")||(tfLocation.text?.lowercased() == "customer")){
                                    self.hideTextField()
                                }else{
          lbl2.isHidden = true
          lbl3.isHidden = true
            tfAddress.isHidden = true
          tf3.isHidden = true
            lblAddress.isHidden = false
                                }
                            }
                        tfLocation.tag = 0
                        if(tfLocation.text?.lowercased() == "office"){
                            //check setting
                            if(self.activesetting.addressSettingsForAttendance == 1){
                                selectedAddress = self.activeuser?.company?.addressList?[0]
                                let latdouble = address.lattitude as? Double ?? 0.00
                                let longdouble = address.longitude as? Double ?? 0.00
    AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                                tfAddress.text = selectedAddress?.addressString()
                            }else if(self.activesetting.addressSettingsForAttendance == 2){
                                //set branch address
                                if(self.activeuser?.branchAddress != nil){
                                    selectedAddress =  self.activeuser?.branchAddress
                                    let latdouble = address.lattitude as? Double ?? 0.00
                                    let longdouble = address.longitude as? Double ?? 0.00
    AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                                    if(selectedAddress?.addressString().count ?? 0 > 0){
                                        tfAddress.text = selectedAddress?.addressString()
                                    }else{
                                        tfAddress.text = String.init(format:"\(selectedAddress?.addressLine1),\(selectedAddress?.addressLine2),\(selectedAddress?.city),\(selectedAddress?.state),\(selectedAddress?.country)")
                                    }
                                }else{
                                    selectedAddress = self.activeuser?.company?.addressList?[0]
                                    let latdouble = address.lattitude as? Double ?? 0.00
                                    let longdouble = address.longitude as? Double ?? 0.00
        AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
        tfAddress.text = selectedAddress?.addressString()
                                }
                            }else{
                                
        let custAddress = mutaddressBoth[0] as? AddressList ?? AddressList()
        let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
        selectedAddreeList = addModel

       // AttendanceViewController.selectedLocation = CLLocation.init(latitude: selectedAddress?.lat, longitude: selectedAddress?.lng)
        //CLLocation.init(latitude: Double(selectedAddress?.lat ?? 0.00), longitude: Double(selectedAddress?.lng ?? 0.00))
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
        let custAddress = customer.addressList[0] as? AddressList ?? AddressList()
        let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
        selectedAddreeList = addModel
        let latdouble = selectedAddreeList.lattitude as? Double ?? 0.00
        let longdouble = selectedAddreeList.longitude as? Double ?? 0.00
        AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
        tfAddress.text = customer.name
        //tf3.text = String.init(format:"\(selectedAddreeList.addressLine1),\(selectedAddress?.addressLine2),\(selectedAddress?.city),\(selectedAddress?.state),\(selectedAddress?.country)")
            var strAdd = ""
        if let stradd1 = selectedAddreeList.addressLine1{
                                       strAdd.append(stradd1)
                                   }
                                   if let stradd2 = selectedAddreeList.addressLine2{
                                       strAdd.append(stradd2)
                                   }
                                   if let strAddCity = selectedAddreeList.city{
                                       strAdd.append(strAddCity)
                                   }
                                   if let strAddState = selectedAddreeList.state{
                                       strAdd.append(strAddState)
                                   }
                                   if let strAddCountry = selectedAddreeList.country{
                                       strAdd.append(strAddCountry)
                                   }
               tf3.text = strAdd
        tfAddress.tag = 0
                                tf3.tag = 0
            showTextFiled()
                            }
                            
    }else if(tfLocation.text?.lowercased() == "vendor"){
    if(self.arrVendorList.count > 0){
            let vendor = self.arrVendorList[0]
    //  selectedAddreeList = vendor.addressList[0] as! AddressList
        
        let floatlat = Float(selectedAddreeList.lattitude ?? "0.00000")
       
        let floatlong = Float(selectedAddreeList.longitude ?? "0.0000")

        let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
    AttendanceViewController.selectedLocation = location
        
        // CLLocation.init(latitude: Double(selectedAddress?.lat ?? 0.00), longitude: Double(selectedAddress?.lng ?? 0.00))
        tfLocation.text = vendor.name
        tfAddress.text = String.init(format:"\(selectedAddreeList.addressLine1),\(selectedAddreeList.addressLine2),\(selectedAddreeList.city),\(selectedAddreeList.state),\(selectedAddreeList.country)")
     tfAddress.tag = 0
  // tfLocation.tag = index
        showTextFiled()
                            }
                            
                        
                           
                        }else if(tfLocation.text?.lowercased() == "home"){
                            tfAddress.text = self.activeuser?.permanentAddress?.addressString()
                            self.hideTextField()
                            
                    }
                    }
            }
                else{
                            tfLocation.tag = 0
                            for loc in 0...arrType.count - 1 {
                                let temploc = arrType[loc]
                                if(tfLocation.text == temploc.location){
                                    tfLocation.tag = loc
                                }
                            }
                           
                    }
                self.initDropDown()
        }
        }
        self.initDropDown()
    }
    func hideTextField(){
        lbl2.text = NSLocalizedString("Address", comment: "")
        lbl3.isHidden = true
       
        tf3.isHidden = true
        tfAddress.isHidden = false
        lbl2.isHidden = false
        lblAddress.isHidden = false
    }
    
    func hideTextField1(){
        lbl2.text = NSLocalizedString("Address", comment: "")
        lbl3.isHidden = true
        tf3.isHidden = true
        tfAddress.isHidden = true
        lbl2.isHidden = true
        lblAddress.isHidden = true
    }
    
    func showTextFiled(){
        lbl2.text = "Customer/Vendor"
        lbl3.text = NSLocalizedString("Address", comment: "")
        lblAddress.isHidden = false
        tfAddress.isHidden = false
        tfLocation.isHidden = false
        lbl3.isHidden = false
        tf3.isHidden = false
        lbl2.isHidden = false 
        
    }
    
    func getAddressIndex(addressId:Int)->Int{
        var index = 0
        var int = 0
        if(self.activeuser?.company?.addressList?.count ?? 0 > 0){
        for add in self.activeuser?.company?.addressList ?? [AddressInfo](){
            print("add = \(add.address_id), address ID =  \(addressId)")
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
    func getAddressFromVendor(ven:Vendor,addressId:NSInteger)->NSInteger{
        var index = 0
             
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
  func initDropDown(){
    self.lblAddress.font = UIFont.boldSystemFont(ofSize: 16)
    self.lblAddress.setMultilineLabel(lbl: self.lblAddress)
    
            dropdownLocation.dataSource = self.arrType.map({
                ($0.location)
            })
    if (tfLocation.text?.lowercased() == "office" ){
        
    
    if(self.activesetting.addressSettingsForAttendance ==  1 ){
        self.dropdownAddress.dataSource = self.mutAddressOffice.map({
            ($0.addressString())
        })
    }else if(self.activesetting.addressSettingsForAttendance ==  2){
        self.dropdownAddress.dataSource = self.mutAddressBranch.map({
            ($0.addressString())
        })
    }else{
        self.dropdownAddress.dataSource = self.mutaddressBoth.map({
            ($0.addressString())
        })
        }
        let selectedTag = tfAddress.tag
        self.tfAddress.text = self.dropdownAddress.dataSource[selectedTag]

        self.lblAddress.text = String.init(format:"Address: \n \(self.dropdownAddress.dataSource[selectedTag])")
        self.hideTextField()
    }
    else if(tfLocation.text?.lowercased() == "customer"){
         
        
        if(self.arrCustomerList.count > 0){
              
            self.dropdownCustomerVendor.dataSource = [String]()
        if(self.arrCustomerList.first?.addressList.count ?? 0 > 0){
            if let arrCust = self.arrCustomerList.first?.addressList as? NSOrderedSet
            {
                arrCust.enumerateObjects { (elem, idx, stop) -> Void in
                    
                    print("\(idx): \(elem)")
                    let add =  elem as? AddressList
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
//            self.tf3.text =  self.dropdownCustomerVendor.dataSource.first
//         self.lblAddress.text = String.init(format:"Address: \n \(self.dropdownCustomerVendor.dataSource[0])")
//        self.tfAddress.text = self.arrCustomerList.first?.name
            self.showTextFiled()
            
        }else{
            self.showTextFiled()
self.view.makeToast("No customers available")
        }
        self.dropdownAddress.dataSource = self.arrCustomerList.map({
            return $0.name
        })
    }
    else if(tfLocation.text?.lowercased() == "vendor"){
         
        if(self.arrVendorList.count > 0){
            self.dropdownCustomerVendor.dataSource = [String]()
                        if(self.arrVendorList.first?.addressList.count ?? 0 > 0){
                            if let arrCust = self.arrVendorList.first?.addressList as? NSOrderedSet
                            {
                                arrCust.enumerateObjects { (elem, idx, stop) -> Void in
                                    
                                    print("\(idx): \(elem)")
                                    let add =  elem as? AddressList
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
//            self.tfAddress.text = self.arrVendorList.first?.name
//            self.tf3.text = self.dropdownCustomerVendor.dataSource.first
//              self.lblAddress.text = String.init(format:"Address: \n \(self.dropdownCustomerVendor.dataSource[0])")
          self.showTextFiled()
        }else{
            self.showTextFiled()
            self.view.makeToast("No vendors available")
        }
        self.dropdownAddress.dataSource = self.arrVendorList.map({
            return $0.name
        })
    }
    else if (tfLocation.text?.lowercased() == "home"){
         self.lblAddress.isHidden =  true
//                    if(self.activeuser?.isCheckInAllowedFromHome == true){
            
            self.tfAddress.isHidden = true
            self.lblAddress.isHidden = true
        if let address = self.activeuser?.permanentAddress as? AddressInfo{
            self.dropdownAddress.dataSource = [address.addressString()]
           
//                    }else{
//                        self.dropdownAddress.dataSource = [""]
//                        self.view.makeToast("You are not allowdwd checkin from Home")
//                        let okAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
//                        Common.showalertWithAction(msg: "You are not allowdwd checkin from Home", arrAction: [okAction], view: self)
//                    }
self.tfAddress.text = self.dropdownAddress.dataSource[0]
self.lblAddress.text = String.init(format:"Address: \n \(self.dropdownAddress.dataSource[0])")
         self.hideTextField()
        }else{
            let okAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
             Common.showalertWithAction(msg: "You are not allowdwd checkin from Home", arrAction: [okAction], view: self)
//           self.tfAddress.isHidden = false
//           self.lblAddress.isHidden = false
        }
    }else if((tfLocation.text?.lowercased() == "travel local") || (tfLocation.text?.lowercased() == "travel upcountry")){
         
        self.lblAddress.isHidden = true
        self.lbl2.isHidden = true
        self.lbl3.isHidden = true
        self.tfAddress.isHidden = true
        self.tf3.isHidden = true
        self.lblAddress.isHidden = true
       // if()
    }
            dropdownLocation.anchorView =  tfLocation
            dropdownLocation.bottomOffset = CGPoint.init(x: 0.0, y: tfLocation.bounds.size.height)
            dropdownLocation.selectionAction = {(index,item) in
               
                
                if (item.lowercased() == "office" ){
                     self.tfLocation.text = item
                    self.tfAddress.isUserInteractionEnabled =  true
                if(self.activesetting.addressSettingsForAttendance ==  1 ){
                    self.dropdownAddress.dataSource = self.mutAddressOffice.map({
                        ($0.addressString())
                    })
                }else if(self.activesetting.addressSettingsForAttendance ==  2){
                    self.dropdownAddress.dataSource = self.mutAddressBranch.map({
                        ($0.addressString())
                    })
                }else{
                    self.dropdownAddress.dataSource = self.mutaddressBoth.map({
                        ($0.addressString())
                    })
                    }
                    self.tfAddress.text = self.dropdownAddress.dataSource[0]
                    self.lblAddress.text = String.init(format:"Address: \n \(self.dropdownAddress.dataSource[0])")
                    self.hideTextField()
                }
                else if(item.lowercased() == "customer"){
                     self.tfLocation.text = item
                    self.tfAddress.isUserInteractionEnabled = false
                    if(self.arrCustomerList.count > 0){
                        
                  //      self.dropdownCustomerVendor.dataSource = [String]()
                    if(self.arrCustomerList.first?.addressList.count ?? 0 > 0){
                        if let arrCust = self.arrCustomerList.first?.addressList as? NSOrderedSet
                        {
                            arrCust.enumerateObjects { (elem, idx, stop) -> Void in
                                
                                print("\(idx): \(elem)")
                                let add =  elem as? AddressList
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
                     self.tf3.text =  self.dropdownCustomerVendor.dataSource.first
                     self.lblAddress.text = String.init(format:"Address: \n \(self.dropdownCustomerVendor.dataSource[0])")
                        print("first customer = \(self.arrCustomerList.first?.name)")
                    self.tfAddress.text = self.arrCustomerList.first?.name
                    self.showTextFiled()
                    self.tfAddress.isUserInteractionEnabled = false
                    }else{
                        self.showTextFiled()
            self.view.makeToast("No customers available")
                    }
                    self.dropdownAddress.dataSource = self.arrCustomerList.map({
                        return $0.name
                    })
                }
                else if(item.lowercased() == "vendor"){
                    self.tfAddress.isUserInteractionEnabled = false
                     self.tfLocation.text = item
                    self.showTextFiled()
                    if(self.arrVendorList.count > 0){
                        self.dropdownCustomerVendor.dataSource = [String]()
                                    if(self.arrVendorList.first?.addressList.count ?? 0 > 0){
                                        if let arrCust = self.arrVendorList.first?.addressList as? NSOrderedSet
                                        {
                                            arrCust.enumerateObjects { (elem, idx, stop) -> Void in
                                                
                                                print("\(idx): \(elem)")
                                                let add =  elem as? AddressList
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
                        self.tf3.text = self.dropdownCustomerVendor.dataSource.first
                          self.lblAddress.text = String.init(format:"Address: \n \(self.dropdownCustomerVendor.dataSource[0])")
                        self.tfAddress.isUserInteractionEnabled = false
                      
                    }else{
                       
                        self.view.makeToast("No vendors available")
                    }
                    self.dropdownAddress.dataSource = self.arrVendorList.map({
                        return $0.name
                    })
                }
                else if (item.lowercased() == "home"){
                    self.tfAddress.isUserInteractionEnabled = true
                     self.lblAddress.isHidden =  true
//                    if(self.activeuser?.isCheckInAllowedFromHome == true){
                         self.tfLocation.text = item
                        self.tfAddress.isHidden = true
                        self.lblAddress.isHidden = true
                    if let address = self.activeuser?.permanentAddress as? AddressInfo{
                        self.dropdownAddress.dataSource = [address.addressString()]
                       
//                    }else{
//                        self.dropdownAddress.dataSource = [""]
//                        self.view.makeToast("You are not allowdwd checkin from Home")
//                        let okAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
//                        Common.showalertWithAction(msg: "You are not allowdwd checkin from Home", arrAction: [okAction], view: self)
//                    }
            self.tfAddress.text = self.dropdownAddress.dataSource[0]
            self.lblAddress.text = String.init(format:"Address: \n \(self.dropdownAddress.dataSource[0])")
                     self.hideTextField()
                    }else{
                        let okAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                         Common.showalertWithAction(msg: "You are not allowdwd checkin from Home", arrAction: [okAction], view: self)
    //                    self.tfAddress.isHidden = false
    //                    self.lblAddress.isHidden = false
                    }
                }else if((item.lowercased() == "travel local") || (item.lowercased() == "travel upcountry")){
                    self.tfAddress.isUserInteractionEnabled = true
                     self.tfLocation.text = item
                    self.lblAddress.isHidden = true
                    self.lbl2.isHidden = true
                    self.lbl3.isHidden = true
                    self.tfAddress.isHidden = true
                    self.tf3.isHidden = true
                    self.lblAddress.isHidden = true
                   // if()
                }
            }
            dropdownAddress.anchorView =  tfAddress
            dropdownAddress.bottomOffset = CGPoint.init(x: 0.0, y: tfAddress.bounds.size.height)
             
             dropdownAddress.selectionAction = {(index,item) in
                self.tfAddress.tag = index
                self.tfAddress.text = item
                self.lblAddress.text = String.init(format:"Address: \n \(item)")
            }
            
    //        if(tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "custmor"){
                dropdownCustomerVendor.anchorView = tf3
                dropdownCustomerVendor.bottomOffset = CGPoint.init(x:0.0 , y:self.tf3.bounds.size.height)
                dropdownCustomerVendor.selectionAction = {
                    (index,item) in
                    self.tf3.text = item
                   // self.tfAddress.tag = index
                    self.lblAddress.text = String.init(format:"Address: \n \(item)")
                }
                
           // }
            }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnSaveClicked(_ sender: UIButton) {
        var msg = ""
        if(tfLocation.text?.count == 0){
            msg = "Please select location"
        }else if(tfAddress.text?.count == 0){
            if(tfLocation.text == "Office"){
                msg = "Please select address"
            }else if(tfLocation.text == "Customer"){
                 msg = "Please select customer"
            }else if(tfLocation.text == "Vendor"){
                 msg = "Please select vendor"
            }
        }
//        else if(tf3.text?.count == 0){
//            if(tfLocation.tag > 1){
//                msg = "Please select address"
//            }
//        }
//        if(tfLocation.text == "Home"){
//            if(msg.count ==  0 && self.activeuser?.isCheckInAllowedFromHome == false){
//                msg = "You are not authorized for Home location Check-In or Check-Out"
//            }
//        }
        if(msg.count > 0){
            self.view.makeToast(msg)
        }else{
            var param = Common.returndefaultparameter()
            if(tfLocation.text?.lowercased() == "office"){
                param["ClientVendorID"] = NSNumber.init(value: 0)
            
            var address:AddressInfo!
            if(self.activesetting.addressSettingsForAttendance == 1){
            address = mutAddressOffice[tfAddress.tag] //self.activeuser?.company?.addressList?[0]
//         tfAddress.text = address.addressString()
            }else if(self.activesetting.addressSettingsForAttendance == 2){
                address = mutAddressBranch[tfAddress.tag]
                }else{
                address = mutaddressBoth[tfAddress.tag]
//                    let address = self.activeuser?.company?.addressList?[0]
//                    tfAddress.text = address?.addressString()
                }
//            }else{
//                let address = mutaddressBoth[tfAddress.tag]
//            }
            param["AddressMasterID"] = address.address_id
            param["LocationType"] = "Office"
            }else if(tfLocation.text?.lowercased() == "home"){
                let address = self.activeuser?.permanentAddress
                param["ClientVendorID"] = NSNumber.init(value:0)
                param["AddressMasterID"] = address?.address_id
                param["LocationType"] = "Home"
            }else if(tfLocation.text?.lowercased() == "travel local"){
             
                param["ClientVendorID"] = NSNumber.init(value:0)
                param["AddressMasterID"] = NSNumber.init(value:0)
                param["LocationType"] = "Travel"
            }else if(tfLocation.text?.lowercased() == "travel upcountry"){
              
                param["ClientVendorID"] = NSNumber.init(value:0)
                param["AddressMasterID"] = NSNumber.init(value:0)
                param["LocationType"] = "Travel Upcountry"
            }else if(tfLocation.text?.lowercased() == "customer"){
                tfAddress.tag = 0 //as vendor/customer is disable
                let cust = arrCustomerList[tfAddress.tag]
               
                let address =  cust.addressList[tf3.tag] as? AddressList
                param["ClientVendorID"] = cust.iD
                param["AddressMasterID"] = address?.addressID
                param["LocationType"] = "Customer"
            }else if(tfLocation.text?.lowercased() == "vendor"){
                tfAddress.tag = 0 //as vendor/customer is disable
                let vendor = arrVendorList[tfAddress.tag]
                
                let address = vendor.addressList[tf3.tag] as? AddressList
                param["ClientVendorID"] = vendor.iD
                param["AddressMasterID"] =  address?.addressID
                param["LocationType"] = "Vendor"
            }
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlSetDefaultSetting, method: Apicallmethod.post) { (pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    self.view.makeToast(message)
                    let dic = arr as? [String:Any] ?? [String:Any]()
                    print("dic is of default setting =  \(dic)")
                    self.loadDefaultSetting()
                        //print("type of user Location \(type(of: dic("UserLocationType")))")
//                        Utils.setDefultvalue(key: Constant.kUserDefault, value: dic)
//                        let dicdefaultSetting = Utils.getDefaultDicValue(key: Constant.kUserDefault)
//                        if(dicdefaultSetting.keys.count > 0){
//                            let dsettingModel = DefaultSettingModel().getdefaultSettingModelWithDic(dict: dicdefaultSetting)
//                            AttendanceCheckInCheckOut.defaultsetting = dsettingModel
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateAsperDefaultData"), object: nil)
//                        }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateAsperDefaultData"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                } else if(error.code == 0){
                                 self.dismiss(animated: true, completion: nil)
                                          self.view.makeToast(message)
                                      }else{
                                 self.dismiss(animated: true, completion: nil)
                                         self.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                                      }
            }
        }
    }
}
extension WorkLocationController:UITextFieldDelegate{

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfLocation){
            print(dropdownLocation.dataSource)
            dropdownLocation.reloadAllComponents()
            dropdownLocation.show()
            return false
        }else if(textField == tfAddress){
            print(dropdownAddress.dataSource)
            if(tfLocation.text?.lowercased() == "office" || tfLocation.text?.lowercased() == "home" ){
            dropdownAddress.reloadAllComponents()
            dropdownAddress.show()
            }else if(tfLocation.text?.lowercased() == "customer"){
              popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                          popup.modalPresentationStyle = .overCurrentContext
                          popup.strTitle = ""
                          popup.nonmandatorydelegate = self
                          popup.arrOfList = arrCustomerList
                          popup.strLeftTitle = "OK"
                          popup.strRightTitle = "cancel"
                          popup.selectionmode = SelectionMode.none
                          popup.arrOfSelectedSingleCustomer = arrOfSelectedMultipleCustomer
                          popup.isSearchBarRequire = true
                          popup.viewfor = ViewFor.customer
                          popup.isFilterRequire = false
                          // popup.showAnimate()
                popup.parentViewOfPopup = self.view
                Utils.addShadow(view: self.view)
                          self.present(popup, animated: false, completion: nil)
            }else if(tfLocation.text?.lowercased() == "vendor"){
                popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
                                        popup.modalPresentationStyle = .overCurrentContext
                                        popup.strTitle = ""
                                        popup.nonmandatorydelegate = self
                                        popup.arrOfVendor = arrVendorList
                                        popup.strLeftTitle = "OK"
                                        popup.strRightTitle = "cancel"
                                        popup.selectionmode = SelectionMode.none
                                        popup.arrOfSelectedVendor = arrOfSelectedVendor
                                        popup.isSearchBarRequire = true
                                        popup.viewfor = ViewFor.vendor
                                        popup.isFilterRequire = false
                                        // popup.showAnimate()
                popup.parentViewOfPopup = self.view
                Utils.addShadow(view: self.view)
                                        self.present(popup, animated: false, completion: nil)
            }
            return false
        }else if(textField == tf3){
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
extension WorkLocationController:PopUpDelegateNonMandatory{
    
    
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print("Selected customers \(arr)")
        arrOfSelectedMultipleCustomer = arr
        tfAddress.text = arr.first?.name
        if(tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "customer"){
        tf3.inputView = dropdownCustomerVendor
        }
    dropdownCustomerVendor.dataSource = [String]()
    if(arr.first?.addressList.count ?? 0 > 0){
    if let arrCust = arr.first?.addressList as? NSOrderedSet
    {
        arrCust.enumerateObjects { (elem, idx, stop) -> Void in
            
            
            let add =  elem as? AddressList
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
  //      tfAddress.tag = 0
        tf3.tag = 0
        tf3.text = dropdownCustomerVendor.dataSource.first
        if let add = tf3.text{
        self.lblAddress.text = String.init(format:"Address: \n \(add)")
        }else{
            self.lblAddress.text = String.init(format:"Address:")
        }
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
        Utils.removeShadow(view: self.view)
        print("Selected Vendor \(arr)")
        arrOfSelectedVendor = arr
        tfAddress.text = arr.first?.name
         if(tfLocation.text?.lowercased() == "vendor" || tfLocation.text?.lowercased() == "customer"){
        tf3.inputView = dropdownCustomerVendor
        }
        dropdownCustomerVendor.dataSource = [String]()
               if(arr.first?.addressList.count ?? 0 > 0){
           if let arrCust = arr.first?.addressList as? NSOrderedSet
           {
               arrCust.enumerateObjects { (elem, idx, stop) -> Void in
                   
                   
                   let add =  elem as? AddressList
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
        tf3.textColor = UIColor.black
        tf3.text = dropdownCustomerVendor.dataSource.first
       // tfAddress.tag = 0
        tf3.tag = 0
        if let add = tf3.text{
        self.lblAddress.text = String.init(format:"Address: \n \(add)")
        }else{
            self.lblAddress.text = String.init(format:"Address:")
        }
    }
    
  
    
}

