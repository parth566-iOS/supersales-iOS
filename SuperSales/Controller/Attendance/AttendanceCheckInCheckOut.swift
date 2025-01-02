//
//  AttendanceCheckInCheckOut.swift
//  SuperSales
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
import AVFoundation
import FastEasyMapping


protocol AttendanceCheckInCheckOutDelegate {
    func fillDataAttendance()
    
}

class AttendanceCheckInCheckOut: BaseViewController {
    static var verifycheckinAdd:Bool!
    static var verifycheckoutAdd:Bool!
    var tempAddressText:String = ""
    typealias AttendanceCompletionBlock = () -> Void
    public static var selectedLocationType:String!
    public static var defaultsetting:DefaultSettingModel!
    var attendancecheckincheckoutdelegate:AttendanceCheckInCheckOutDelegate?
    static var isCheckInAtcheckincheckout:Bool = false
    static var isSelefieAvailbalecheckincheckout  = false
    static var selfieImagecheckincheckout:UIImage?
    static var mutaddressBoth:[AddressInfo] = [AddressInfo]()
    static var mutAddressOffice:[AddressInfo] = [AddressInfo]()
    static var mutAddressBranch:[AddressInfo] = [AddressInfo]()
    static var arrCustomerList:[CustomerDetails]! = [CustomerDetails]()
    static var arrVendorList:[Vendor]! = [Vendor]()
    var parentview: UIViewController!
    var param = Common.returndefaultparameter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //  self.setAddress()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Method
    
    func setAddress(){
        //set address
        AttendanceCheckInCheckOut.mutAddressOffice.removeAll()
        if (self.activeuser?.company?.addressList?.count ?? 0 > 0){
            AttendanceCheckInCheckOut.mutAddressOffice =  self.activeuser?.company?.addressList ?? [AddressInfo]()
        }
        
        if let branchaddress = self.activeuser?.branchAddress{
            AttendanceCheckInCheckOut.mutAddressBranch =  [branchaddress]
        }else{
            AttendanceCheckInCheckOut.mutAddressBranch = AttendanceCheckInCheckOut.mutAddressOffice
        }
        
        AttendanceCheckInCheckOut.mutaddressBoth = self.activeuser?.company?.addressList ?? [AddressInfo]()
        if let branchadd = self.activeuser?.branchAddress as? AddressInfo{
            AttendanceCheckInCheckOut.mutaddressBoth.append(branchadd)
        }
        
        let dicdefaultSetting = Utils.getDefaultDicValue(key: Constant.kUserDefault)
        if(dicdefaultSetting.keys.count > 0){
            let dsettingModel = DefaultSettingModel().getdefaultSettingModelWithDic(dict: dicdefaultSetting)
            AttendanceCheckInCheckOut.defaultsetting = dsettingModel
            
        }else{
            self.loadDefaultSetting(view: self,completion:{_ in
                
            })
        }
        AttendanceCheckInCheckOut.arrCustomerList = CustomerDetails.getAllCustomers()
        AttendanceCheckInCheckOut.arrVendorList = Vendor.getAll()
        let dsetting = AttendanceCheckInCheckOut.defaultsetting
        if let address = dsetting?.clientAddress
            as? AddressListModel{
            if let locationType = dsetting?.locationType as? NSNumber{
                print("Location type = \(locationType)")
                if(locationType ==  NSNumber.init(value: 1)){
                    
                    tempAddressText = "Office"
                    let setting = self.activesetting
                    if((setting.addressSettingsForAttendance == NSNumber.init(value:1)) || (setting.addressSettingsForAttendance == NSNumber.init(value:3)) || (self.activeuser?.branchAddress ==  nil)){
                        if(address != nil){
                            // let addModel =  AddressListModel().getaddressListModelWithDic(dict: address)
                            AttendanceViewController.selectedAddreeList =  address
                            
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
                            
                            
                            
                            
                        }else{
                            if(self.activeuser?.company?.addressList?.count ?? 0 > 0){
                                let add = self.activeuser?.company?.addressList?[0]
                                AttendanceViewController.selectedAddress = add
                                let floatlat = Float(AttendanceViewController.selectedAddress?.lat ?? "0.00000")
                                
                                let floatlong = Float(AttendanceViewController.selectedAddress?.lng ?? "0.0000")
                                
                                let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                                AttendanceViewController.selectedLocation = location
                                
                            }
                        }
                        
                    }
                    else{
                        let address = self.activeuser?.branchAddress
                        AttendanceViewController.selectedAddress =  address
                        let floatlat = Float(AttendanceViewController.selectedAddress?.lat ?? "0.00000")
                        
                        let floatlong = Float(AttendanceViewController.selectedAddress?.lng ?? "0.0000")
                        
                        let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                        AttendanceViewController.selectedLocation = location
                        
                    }
                    
                }else if(locationType ==  NSNumber.init(value: 2)){
                    if(!(Utils.isCustomerMapped(cid: dsetting?.clientvendorid ?? NSNumber.init(value:0)))){
                        tempAddressText = "Office"
                        
                        
                        let add = self.activeuser?.company?.addressList?[0] as? AddressInfo
                        AttendanceViewController.selectedAddress = add
                        let floatlat = Float(AttendanceViewController.selectedAddress?.lat ?? "0.00000")
                        
                        let floatlong = Float(AttendanceViewController.selectedAddress?.lng ?? "0.0000")
                        AttendanceViewController.selectedLocation = CLLocation.init( latitude:(CLLocationDegrees.init(floatlat ?? 0.00)), longitude: CLLocationDegrees.init(floatlong ?? 0.00))
                        
                        
                        return
                    }
                    tempAddressText = "Customer"
                    AttendanceViewController.selectedAddreeList = address
                    let latdouble = Float(address.lattitude ?? "0.0000")
                    let longdouble = Float(address.longitude ?? "0.0000")
                    
                    AttendanceViewController.selectedLocation = CLLocation.init( latitude:(CLLocationDegrees.init(latdouble ?? 0.00)), longitude: CLLocationDegrees.init(longdouble ?? 0.00))
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
                    
                    
                    //tfLocation.tag = self.
                    
                }else if(locationType ==  NSNumber.init(value: 3)){
                    if(AttendanceCheckInCheckOut.arrVendorList.count == 0){
                        let setting =      AttendanceCheckInCheckOut.defaultsetting
                        setting?.locationType = NSNumber.init(value:1)
                        //   Utils.setDefultvalue(key: Constant.kUserDefault, value: setting)
                        let setting1  =  Utils.getDefaultDicValue(key: Constant.kUserDefault)
                        
                        
                        
                        
                        tempAddressText = "Office"
                        
                        return
                    }
                    tempAddressText = "Vendor"
                    
                    AttendanceViewController.selectedAddreeList =  address
                    let latdouble = address.lattitude.toDouble() ?? 0.00
                    let longdouble = address.longitude.toDouble() ?? 0.00
                    AttendanceViewController.selectedLocation =  CLLocation.init(latitude: latdouble , longitude: longdouble)
                    
                    //   tf3.text = String.init(format:"\(AttendanceViewController.selectedAddreeList.addressLine1)")
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
                    
                    //                                let vendor = self.arrVendorList[tfAddress.tag]
                    //
                    //                                }
                    if (locationType == NSNumber.init(value:4)){
                        tempAddressText = "Travel Local"
                    }
                    
                    if (locationType == NSNumber.init(value:7)){
                        tempAddressText = "Travel Upcountry"
                    }
                    //                    let strarrLocation = self.arrType.map{
                    //                        $0.location
                    //                    }
                    //                    let arrKey = self.arrType.map{
                    //                        $0.key
                    //                    }
                    if (locationType == NSNumber.init(value:8)){
                        tempAddressText = "Home"
                        if let stradd = self.activeuser?.permanentAddress?.addressString() as? String{
                            
                        }
                        //        showTextFiled()
                        //                                    self.hideTextField()
                        //                              //  }
                    }
                    
                    //                    let arrLocation  = self.arrType.map { (location) in
                    //                        return location.location
                    //                    }
                    //                    if(!(arrLocation.contains(tfLocation.text))){
                    //                        if(arrLocation.count > 0){
                    //        if(arrKey.contains(NSNumber.init(value:1)) && self.activeuser?.isCheckInAllowedFromHome == false){
                    //            if((self.arrType.count > 1) && (arrKey.first == NSNumber.init(value:1))){
                    //
                    //                                    }else{
                    //
                    //
                    //
                    //                                    }
                }else{
                    
                    
                    
                    
                }
                
                if(tempAddressText == "office"){
                    //check setting
                    if(self.activesetting.addressSettingsForAttendance == 1){
                        AttendanceViewController.selectedAddress = self.activeuser?.company?.addressList?[0]
                        let latdouble = address.lattitude.toDouble() ?? 0.00
                        let longdouble = address.longitude.toDouble() ?? 0.00
                        AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                        
                    }else if(self.activesetting.addressSettingsForAttendance == 2){
                        //set branch address
                        if(self.activeuser?.branchAddress != nil){
                            AttendanceViewController.selectedAddress =  self.activeuser?.branchAddress
                            let latdouble = address.lattitude.toDouble() ?? 0.00
                            let longdouble = address.longitude.toDouble() ?? 0.00
                            AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                            if(AttendanceViewController.selectedAddress?.addressString().count ?? 0 > 0){
                                //  tfAddress.text = selectedAddress?.addressString()
                            }else{
                                // tfAddress.text = String.init(format:"\(selectedAddress?.addressLine1),\(selectedAddress?.addressLine2),\(selectedAddress?.city),\(selectedAddress?.state),\(selectedAddress?.country)")
                            }
                        }else{
                            AttendanceViewController.selectedAddress = self.activeuser?.company?.addressList?[0]
                            let latdouble = address.lattitude.toDouble() ?? 0.00
                            let longdouble = address.longitude.toDouble() ?? 0.00
                            AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                            //   tfAddress.text = selectedAddress?.addressString()
                        }
                    }else{
                        
                        let custAddress = AttendanceCheckInCheckOut.mutaddressBoth[0] as? AddressList ?? AddressList()
                        let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                        AttendanceViewController.selectedAddreeList = addModel
                        let latdouble = addModel.lattitude.toDouble() ?? 0.00
                        let longdouble = addModel.longitude.toDouble() ?? 0.00
                        AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                        
                        
                    }
                    
                }else if(tempAddressText == "customer"){
                    if(AttendanceCheckInCheckOut.arrCustomerList.count > 0 ){
                        let customer = AttendanceCheckInCheckOut.arrCustomerList[0]
                        let custAddress = customer.addressList[0] as? AddressList ?? AddressList()
                        let addModel = AddressListModel().getaddressListModelWithDic(dict: custAddress.toDictionary())
                        AttendanceViewController.selectedAddreeList = addModel
                        let latdouble = AttendanceViewController.selectedAddreeList.lattitude.toDouble() ?? 0.00
                        let longdouble = AttendanceViewController.selectedAddreeList.longitude.toDouble() ?? 0.00
                        AttendanceViewController.selectedLocation = CLLocation.init(latitude: latdouble, longitude: longdouble)
                        
                        //tf3.text = String.init(format:"\(AttendanceViewController.selectedAddreeList.addressLine1),\(selectedAddress?.addressLine2),\(selectedAddress?.city),\(selectedAddress?.state),\(selectedAddress?.country)")
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
                        
                    }
                    
                }else if(tempAddressText == "vendor"){
                    if(AttendanceCheckInCheckOut.arrVendorList.count > 0){
                        let vendor = AttendanceCheckInCheckOut.arrVendorList[0]
                        //  AttendanceViewController.selectedAddreeList = vendor.addressList[0] as! AddressList
                        
                        let floatlat = Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                        
                        let floatlong = Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                        
                        let location = CLLocation.init(latitude: CLLocationDegrees.init(floatlat ?? 0.0), longitude: CLLocationDegrees.init(floatlong ?? 0.0))
                        AttendanceViewController.selectedLocation = location
                        
                        // CLLocation.init(latitude: Double(selectedAddress?.lat ?? 0.00), longitude: Double(selectedAddress?.lng ?? 0.00))
                        
                        
                    }
                    
                    
                    
                }else if(tempAddressText == "home"){
                    
                    
                }
            }
        }
        else{
            AttendanceViewController.tfLocationTag = 0
            for loc in 0...AttendanceViewController.arrType.count - 1 {
                let temploc = AttendanceViewController.arrType[loc]
                if(tempAddressText == temploc.location){
                    AttendanceViewController.tfLocationTag = loc
                }
            }
            
        }
        
    }
    
    
    
    
    func isableToLogin(add:CLLocation)->Bool{
        if let  coord = Location.sharedInsatnce.currentLocation as? CLLocation{
            let location1 = CLLocation.init(latitude: coord.coordinate.latitude, longitude: coord.coordinate.longitude)
            
            let meter = location1.distance(from: add)
            
            if(meter <= self.activeuser?.company?.radiusSuperSales?.doubleValue ?? 0.00){
                
                return true
            }else{
                
                // Common.showalert(msg: "You are not at above location OR your location may be not updated. Please refresh location.", view: self)
                return false
            }
        }else{
            Common.showalert(msg: "We can not get your current location please check your gps", view: self)
            return false
        }
    }
    
    func verfyingAddress(tag:Int,tflocationText:String,viewController:UIViewController){//(status:Int,lat:NSNumber,long:NSNumber,isVisitPlanned:VisitType,objplannedVisit:PlannVisit,objunplannedVisit:UnplannedVisit,visitid:NSNumber,viewcontroller:UIViewController,addressID:NSNumber){
       // let currenlocation =  Location.sharedInsatnce.currentLocation
       
      
        if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
            //          CLLocationCoordinate2DIsValid(currentCoordinate)
            if(CLLocationCoordinate2DIsValid(currentCoordinate)){
                let currentlat =  currentCoordinate.latitude
                let currentlong = currentCoordinate.longitude
                if(!AttendanceCheckInCheckOut.verifycheckinAdd){
                    AttendanceCheckInCheckOut.verifycheckinAdd = true
                    self.checkinClicked(tag: tag, tflocationText: tflocationText, viewController: viewController)
                   
                 
                    //self.checkout(visitstatus: status, lat: NSNumber.init(value: currentlat), long: NSNumber.init(value: currentlong), isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, viewcontroller: viewcontroller, addressID: addressID)
                }else{
                    AttendanceCheckInCheckOut.verifycheckoutAdd = true
                    self.checkOutClicked(tag: tag, tflocationText: tflocationText, viewController: viewController)
             //   self.checkin(visitstatus: status, lat: NSNumber.init(value:currentlat), long: NSNumber.init(value:currentlong), isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
              //  self.checkin(visitstatus: status, lat: currentlat, long: currentlong, isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
               // self.checkin(visitstatus: status, lat: currentCoordinate.latitude, long: currentCoordinate.longitude, isVisitPlanned: VisitType.directvisitcheckin, objplannedVisit: objplannedVisit, objunplannedVisit: UnplannedVisit(), visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
            }
            }
        }else{
            Utils.toastmsg(message: "Please check your gps", view: viewController.view)
            }
    }
    func checkinClicked(tag:Int,tflocationText:String,viewController:UIViewController){
        SVProgressHUD.show()
        setAddress()
        parentview = viewController
        if(AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 8)){
            if((self.activeuser?.isCheckInAllowedFromHome ==  false)){
                
                viewController.view.makeToast("You are not authorized for Home location Check-In or Check-Out", duration: 2.0, position: CGPoint.init(x:180, y: self.view.frame.height - 100))
                Common.showalert(msg: "You are not authorized for Home location Check-In or Check-Out", view: viewController)
                return
            }
        }
        
        if(self.activesetting.allowSelfieInAttendance == 1){
           
            if((AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 4)) || (AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 7))){
                self.userCheckIn(status: true, viewController: viewController)
            }else{
                if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                    //diffrent method for different location
                    if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                        self.userCheckIn(status: true, viewController: viewController)
                    }else{
                        if(AttendanceCheckInCheckOut.verifycheckinAdd){
                          
                        
                            if let checkin = AttendanceCheckInCheckOut.verifycheckinAdd{
                                if(checkin){
                                    SVProgressHUD.dismiss()
                                    self.displayAlert(displayview: self.parentview ??  self)
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
                            
   
                                Utils.toastmsg(message: "Verifying Address", view: viewController.view)
                            
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    self.verfyingAddress(tag: tag, tflocationText: tflocationText, viewController: viewController)
  
                                }
                               
                            
                        }
                    }
                }
            }
            //    if(tflocationText.lowercased() == "office" || tflocationText.lowercased() == "vendor" || tflocationText.lowercased() == "customer"){
            //    if(tflocationText.lowercased() == "office"){
            //
            //    }
            //    }
        }else if(self.activesetting.allowSelfieInAttendance == 2){
          
            let noAction = UIAlertAction.init(title: "NO", style: UIAlertAction.Style.cancel) { (action) in
                SVProgressHUD.show()
                if((AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 4)) || (AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 7))){
                    
                    self.userCheckIn(status: true, viewController: viewController)
                    
                }else{
                    if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                        if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                            self.userCheckIn(status: true, viewController: viewController)
                        }else{
                           
                            
                            if let checkin = AttendanceCheckInCheckOut.verifycheckinAdd{
                                if(checkin){
                                    SVProgressHUD.dismiss()
                                    self.displayAlert(displayview: self.parent ??  self)
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
                      
                        if let checkin = AttendanceCheckInCheckOut.verifycheckinAdd{
                            if(checkin){
                                SVProgressHUD.dismiss()
                                self.displayAlert(displayview: self.parent ??  self)
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
                    
                }
            }
            let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
                AttendanceCheckInCheckOut.isCheckInAtcheckincheckout = true
//                SVProgressHUD.show()
                self.takeNewPhotoFromCamera()
            }
            SVProgressHUD.dismiss()
            Common.showalertWithAction(msg: "Do you want to take selfie?", arrAction: [yesAction,noAction], view: viewController)
        }else if(self.activesetting.allowSelfieInAttendance == 3){
            let yesAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.destructive) { (action) in
                
                self.takeNewPhotoFromCamera()
            }
            SVProgressHUD.dismiss()
            Common.showalertWithAction(msg: "Please take Selfie", arrAction: [yesAction], view: viewController)
        }
    }
    
    func checkOutClicked(tag:Int,tflocationText:String,viewController:UIViewController){
        SVProgressHUD.show()
        setAddress()
        parentview = viewController
        AttendanceCheckInCheckOut.verifycheckoutAdd = false
        if(AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 8)){
            if((self.activeuser?.isCheckInAllowedFromHome ==  false)){
                //            tfAddress.isHidden = true
                //            lbl2Title.isHidden = true
                viewController.view.makeToast("You are not authorized for Home location Check-In or Check-Out", duration: 2.0, position: CGPoint.init(x:180, y: self.view.frame.height - 100))
//                viewController.view.makeToast("You are not authorized for Home location Check-In or Check-Out")
                Common.showalert(msg: "You are not authorized for Home location Check-In or Check-Out", view: viewController)
                return
            }
        }
        
        if(self.activesetting.allowSelfieInAttendance == 1){
            if((AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 4)) || (AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 7))){
                self.userCheckIn(status:  false, viewController: viewController)
            }else{
                if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                    //diffrent method for different location
                    if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                        self.userCheckIn(status: false, viewController: viewController)
                    }else{
                       
                        if let checkout = AttendanceCheckInCheckOut.verifycheckoutAdd{
                            if(checkout){
                                SVProgressHUD.dismiss()
                                self.displayAlert(displayview: self.parent ??  self)
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
            }
            //    if(tflocationText.lowercased() == "office" || tflocationText.lowercased() == "vendor" || tflocationText.lowercased() == "customer"){
            //    if(tflocationText.lowercased() == "office"){
            //
            //    }
            //    }
        }else if(self.activesetting.allowSelfieInAttendance == 2){
            let noAction = UIAlertAction.init(title: "NO", style: UIAlertAction.Style.cancel) { (action) in
                if((AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 4)) || (AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 7))){
                    self.userCheckIn(status: false, viewController: viewController)
                    
                }else{
                    if let slocation = AttendanceViewController.selectedLocation as? CLLocation{
                        if(AttendanceCheckInCheckOut().isableToLogin(add: slocation)){
                            self.userCheckIn(status: false, viewController: viewController)
                        }else{
                           
                            if let checkout = AttendanceCheckInCheckOut.verifycheckoutAdd{
                                if(checkout){
                                    SVProgressHUD.dismiss()
                                    self.displayAlert(displayview: self.parent ??  self)
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
                       
                        if let checkout = AttendanceCheckInCheckOut.verifycheckoutAdd{
                            if(checkout){
                                SVProgressHUD.dismiss()
                                self.displayAlert(displayview: self.parent ??  self)
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
            }
            let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
                AttendanceCheckInCheckOut.isCheckInAtcheckincheckout = true
                
                self.takeNewPhotoFromCamera()
            }
            SVProgressHUD.dismiss()
            Common.showalertWithAction(msg: "Do you want to take selfie?", arrAction: [yesAction,noAction], view: viewController)
        }else if(self.activesetting.allowSelfieInAttendance == 3){
            let yesAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.destructive) { (action) in
                
                self.takeNewPhotoFromCamera()
            }
            SVProgressHUD.dismiss()
            Common.showalertWithAction(msg: "Please take Selfie", arrAction: [yesAction], view: viewController)
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
    
    
    
    
    func takeNewPhotoFromCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            if let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.camera) as? Bool {
                let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                switch authStatus {
                case .authorized:
                    
                    NotificationCenter.default.post(name: Notification.Name.init("cameraAction"), object: nil,userInfo: nil)
                //   showCameraPicker()
                // SalesPlanHome().salesdelegate?.showCameraPicker()
                case .denied:
                    
                    alertPromptToAllowCameraAccessViaSettings()
                case .notDetermined:
                    
                    AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                        if(granted){
                            NotificationCenter.default.post(name: Notification.Name.init("cameraAction"), object: nil,userInfo: nil)
                        }else{
                            DispatchQueue.main.async {
                                self.permissionPrimeCameraAccess()
                            }
                        }
                    }
                default:
                    DispatchQueue.main.async { [self] in
                        self.permissionPrimeCameraAccess()
                    }
                }
            } else {
                parentview.view.makeToast("Device has no camera", duration: 2.0, position: CGPoint.init(x: 50, y: parentview.view.frame.height - 80))
                parentview.view.makeToast("Device has no camera")
                //               let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
                //               let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                //                 //  Analytics.track(event: .permissionsPrimeCameraNoCamera)
                //               })
                //               alertController.addAction(defaultAction)
                //               present(alertController, animated: true, completion: nil)
            }
        }else{
            parentview.view.makeToast("Device has no camera", duration: 2.0, position: CGPoint.init(x: 160, y: parentview.view.frame.height - 80))
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
        parentview.present(alert, animated: true, completion: nil)
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
            self.parentview.present(alert, animated: true, completion: nil)
        }
    }
    
    //       func showCameraPicker() {
    //
    //           let picker = UIImagePickerController()
    //        picker.delegate = self //parentviewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    //            picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
    //            picker.allowsEditing = false
    //            picker.sourceType = UIImagePickerController.SourceType.camera
    // //       self.present(picker, animated: true, completion: nil)
    //        parentview.present(picker, animated: true) {
    //
    //        }
    //       //     present(picker, animated: true, completion: nil)
    //       }
    
    func isableToLoginForCustomer(add:CLLocation)->Bool{
        if let  coord = Location.sharedInsatnce.currentLocation as? CLLocationCoordinate2D{
            let location1 = CLLocation.init(latitude: coord.latitude, longitude: coord.longitude)
            print("distance = \(location1.distance(from: add)) , radius = \(self.activeuser?.company?.radiusSuperSales?.doubleValue)")
            let meter = location1.distance(from: add)
            if(meter <= self.activeuser?.company?.radiusSuperSales?.doubleValue ?? 0.00){
                return true
            }else{
               
                if let checkin = AttendanceCheckInCheckOut.verifycheckinAdd{
                    if(checkin){
                        SVProgressHUD.dismiss()
                        self.displayAlert(displayview: self.parent ??  self)
                    }else{
                        Utils.toastmsg(message: "Verifying Address", view: self.view)
                          //  Utils.addShadow(view: viewcontroller.view)
                            let secondsToDelay = 4.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                self.verfyingAddress(status: true)
                            }
                           
                        
                    }
                }
                if let checkout = AttendanceCheckInCheckOut.verifycheckoutAdd{
                    if(checkout){
                        SVProgressHUD.dismiss()
                        self.displayAlert(displayview: self.parent ??  self)
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
            return false
        }
    }
    
    func displayAlert(displayview:UIViewController){
        
        let mapAction =  UIAlertAction.init(title: "VIEW ON MAP", style:.cancel) { (action) in
            if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
                map.isFromDashboard = false
                map.isFromAttendance = true
                map.isFromColdCall = false
                map.isFromVisitLeadDetail = false
                map.lattitude = NSNumber.init(value:AttendanceViewController.selectedLocation?.coordinate.latitude ?? 0.0000)
                
                map.longitude = NSNumber.init(value:AttendanceViewController.selectedLocation?.coordinate.longitude ?? 0.0000)
                
                
                displayview.navigationController?.pushViewController(map, animated: true)
            }
        }
        let refreshLocation = UIAlertAction.init(title: "Refresh", style: UIAlertAction.Style.default) { (action) in
            displayview.view.makeToast("Refreshing Location", duration: 2.0, position: CGPoint.init(x: 160, y: displayview.view.frame.height - 80))
            // self.parentview.view.makeToast("Refreshing Location")
            Location.sharedInsatnce.startLocationManager()
        }
        let cancelAction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: nil)
        Common.showalertWithAction(msg: "You are not at above location OR your location may be not updated. Please refresh location.", arrAction: [mapAction,refreshLocation,cancelAction], view: displayview)
        
    }
    //MARK: - API Call
    func loadDefaultSetting(view:UIViewController,completion:@escaping (AttendanceCompletionBlock) -> Void){
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
                
                
                print("dic is of default setting =  \(dic)")
                //print("type of user Location \(type(of: dic("UserLocationType")))")
                Utils.setDefultvalue(key: Constant.kUserDefault, value: dic)
                let dicdefaultSetting = Utils.getDefaultDicValue(key: Constant.kUserDefault)
                if(dicdefaultSetting.keys.count > 0){
                    let dsettingModel = DefaultSettingModel().getdefaultSettingModelWithDic(dict: dicdefaultSetting)
                    AttendanceCheckInCheckOut.defaultsetting = dsettingModel
                    //view.fillData()
                    completion(){
                        print("etbtebtrbe")
                    }
                    self.attendancecheckincheckoutdelegate?.fillDataAttendance()
                }else{
                    //self.loadDefaultSetting()
                }
                
                /* DefaultSetting.mr_truncateAll()
                 MagicalRecord.save({ (localContext) in
                 print("count of default setting is = \(DefaultSetting.getAll().count)")
                 let arrvisit = FEMDeserializer.collection(fromRepresentation: [dic], mapping: DefaultSetting.defaultMapping(), context: localContext)
                 print("arr femmapping obj  = \(arrvisit)")
                 
                 //        let dicAtten  = FEMDeserializer.object(fromRepresentation: dic, mapping: DefaultSetting.defaultMapping(), context: localContext)
                 //        print(" dic femmapping obj = \(dicAtten)")
                 localContext.mr_saveToPersistentStoreAndWait()
                 print("first object = \(DefaultSetting.mr_findFirst())")
                 }, completion: { (contextdidsave, error) in
                 print("first object = \(DefaultSetting.mr_findFirst())")
                 print("status = \(contextdidsave) , error = \(error)")
                 print("DefaultSetting saved")
                 print("count of default setting is = \(DefaultSetting.getAll().count)")
                 if let lastvisit = DefaultSetting.mr_findAll()?.last as? DefaultSetting{
                 print(lastvisit.locationtype)
                 print(lastvisit.user_id)
                 print(lastvisit.user_location_type)
                 print(lastvisit.clientvendorid)
                 print(lastvisit.address_id)
                 print(lastvisit.clientaddress)
                 print(lastvisit.company_id)
                 print(lastvisit.modified_by)
                 }
                 })*/
                //    MagicalRecord.save { (localContext) in
                //        DefaultSetting.mr_truncateAll(in: localContext)
                //        print("count of default setting is = \(DefaultSetting.getAll().count)")
                //      // FEMDeserializer.object(fromRepresentation: dic, mapping: DefaultSetting.defaultMapping(), context: localContext)
                //        FEMDeserializer.collection(fromRepresentation: [dic], mapping: DefaultSetting.defaultMapping(), context: localContext)
                //    }, completion: { (contextdidsave, error) in
                //        print("count of default setting is = \(DefaultSetting.getAll().count)")
                //        print("first object = \(DefaultSetting.mr_findFirst()), user id = \(DefaultSetting.mr_findFirst()?.user_id)")
                //    })
                /*MagicalRecord.save({ (localContext) in
                 DefaultSetting.mr_truncateAll(in: localContext)
                 print("count of default setting is = \(DefaultSetting.getAll().count)")
                 // FEMDeserializer.object(fromRepresentation: dic, mapping: DefaultSetting.defaultMapping(), context: localContext)
                 let arr =  FEMDeserializer.collection(fromRepresentation: [dic], mapping: DefaultSetting.defaultMapping(), context: localContext)
                 print("arr is = \(arr)")
                 localContext.mr_saveToPersistentStore { (status, error) in
                 print("1 count of default setting is = \(DefaultSetting.getAll().count)")
                 print("first object = \(DefaultSetting.mr_findFirst()), user id = \(DefaultSetting.mr_findFirst()?.user_id)")
                 }
                 localContext.mr_saveToPersistentStore { (status, error) in
                 print("2 count of default setting is = \(DefaultSetting.getAll().count)")
                 print("first object = \(DefaultSetting.mr_findFirst()), user id = \(DefaultSetting.mr_findFirst()?.user_id)")
                 }
                 
                 //       print(setting)
                 //        print((setting as! DefaultSetting).user_id)
                 //   FEMDeserializer.collection(fromRepresentation: menus as? [[String:Any]] ?? [[String:Any]]() , mapping: CompanyMenus.defaultMapping() , context: localContext)
                 }, completion: { (contextdidsave, error) in
                 print("3 count of default setting is = \(DefaultSetting.getAll().count)")
                 print("first object = \(DefaultSetting.mr_findFirst()), user id = \(DefaultSetting.mr_findFirst()?.user_id),\(DefaultSetting.getAll().first?.locationtype)")
                 })
                 /*MagicalRecord.save({ (localcontext) in
                 DefaultSetting.mr_truncateAll(in: localcontext)
                 print("count of default setting is = \(DefaultSetting.getAll().count)")
                 let dic = FEMDeserializer.object(fromRepresentation: dic, mapping: DefaultSetting.defaultMapping(), context: localcontext)
                 print("setting dic = \(dic)")
                 //let arr = FEMDeserializer.collection(fromRepresentation: [dic], mapping: DefaultSetting.defaultMapping(), context: localcontext)
                 //    print("setting arr = \(arr)")
                 //////    print("count of default setting after mapping  \(DefaultSetting.getAll().count)")
                 //    localcontext.mr_save { (localcontext) in
                 //        print("saving")
                 //    } completion: { (status, error) in
                 //
                 //        print("first obj = \(DefaultSetting.getAll().first)")
                 //    print("get default setting \(DefaultSetting.getDefaultSetting()) , Location type using default = \(DefaultSetting.getDefaultSetting()?.location_type)  , get default setting \(DefaultSetting.getDefaultSetting())")
                 //    }
                 ////
                 localcontext.mr_saveToPersistentStore { (status, error) in
                 print("first obj = \(DefaultSetting.getAll().first)")
                 print("first object = \(DefaultSetting.mr_findFirst()), user location type = \(DefaultSetting.mr_findFirst()?.location_type)")
                 print("get default setting \(DefaultSetting.getDefaultSetting()) , Location type using default = \(DefaultSetting.getDefaultSetting()?.location_type)  , get default setting \(DefaultSetting.getDefaultSetting())")
                 }
                 localcontext.mr_saveToPersistentStoreAndWait()
                 //    print("get default setting \(DefaultSetting.getDefaultSetting()) , Location type using default = \(DefaultSetting.getDefaultSetting()?.location_type) , get default setting \(DefaultSetting.getDefaultSetting())")
                 localcontext.mr_saveToPersistentStore { (status, error) in
                 print("first object = \(DefaultSetting.mr_findFirst()), user location type = \(DefaultSetting.mr_findFirst()?.location_type)")
                 print("get default setting \(DefaultSetting.getDefaultSetting()) , Location type using default = \(DefaultSetting.getDefaultSetting()?.location_type) , get default setting \(DefaultSetting.getDefaultSetting())")
                 }
                 
                 
                 }
                 , completion: { (contextdidsave, error) in
                 if(error ==  nil){
                 print("count of default setting is = \(DefaultSetting.getAll().count)")
                 print("All setting \(DefaultSetting.getAll()), user location type = \(DefaultSetting.mr_findFirst()?.location_type)")
                 print("first object = \(DefaultSetting.mr_findFirst())")
                 print("first obj = \(DefaultSetting.getAll().first) location type = \(DefaultSetting.getAll().first?.location_type)")
                 print("get default setting \(DefaultSetting.getDefaultSetting()) , Location type using default = \(DefaultSetting.getDefaultSetting()?.location_type) , get default setting \(DefaultSetting.getDefaultSetting())")
                 
                 //if let defaultsetting = DefaultSetting.mr_findAll()?.first as? DefaultSetting{
                 //    print("address id = \(defaultsetting.address_id)")
                 //    //print(defaultsetting.userid)
                 //    print("Location  type in first object = \(defaultsetting.location_type)")
                 //    }
                 
                 }
                 else{
                 print(error?.localizedDescription)
                 }
                 
                 })*/
                 
                 /*MagicalRecord.save({ (localContext) in
                 DefaultSetting.mr_truncateAll(in: localContext)
                 //FEMDeserializer.collection(fromRepresentation: [dic], mapping: DefaultSetting.defaultMapping(), context: localContext)
                 let arr  = FEMDeserializer.collection(fromRepresentation: [dic], mapping: DefaultSetting.defaultMapping(), context: localContext)
                 //    FEMDeserializer.object(fromRepresentation: dic, mapping: AttendanceHistory.defaultMapping(), context: localContext)
                 print("arr is \(arr)")
                 print("count is \(DefaultSetting.getAll().count)")
                 //  print(DefaultSetting.getDefaultSetting())
                 //    localContext.mr_save { (localcontext) in
                 //        print("saving")
                 //    } completion: { (status, error) in
                 //        print(status)
                 //        print(error?.localizedDescription)
                 //        print("count is \(DefaultSetting.getAll().count)")
                 //        print(DefaultSetting.getDefaultSetting())
                 //        print("location type = \(DefaultSetting.getDefaultSetting()?.location_type)")
                 //    }
                 //    print("count is \(DefaultSetting.getAll().count)")
                 //    print(DefaultSetting.getDefaultSetting())
                 //    localContext.mr_saveToPersistentStoreAndWait()
                 //    localContext.mr_saveToPersistentStore { (status, error) in
                 //        print(status)
                 //        print(error?.localizedDescription)
                 //        print("count is \(DefaultSetting.getAll().count)")
                 //        print(DefaultSetting.getDefaultSetting())
                 //        print("user id is = \(DefaultSetting.getDefaultSetting()?.user_id)")
                 //        print("company_id is = \(DefaultSetting.getDefaultSetting()?.company_id)")
                 //        print("location_type is = \(DefaultSetting.getDefaultSetting()?.location_type)")
                 //        print("client address is = \(DefaultSetting.getDefaultSetting()?.clientaddress)")
                 //        print("user id in last obj = \(DefaultSetting.getAll().first?.user_id)")
                 //        print("company_id is = \(DefaultSetting.getAll().first?.company_id)")
                 //        print("location_type is = \(DefaultSetting.getAll().first?.location_type)")
                 //        print("client address is = \(DefaultSetting.getAll().first?.clientaddress)")
                 //    }
                 //    print("count is \(DefaultSetting.getAll().count)")
                 //    print(DefaultSetting.getDefaultSetting())
                 //    print(DefaultSetting.getDefaultSetting())
                 //    print("user id is = \(DefaultSetting.getDefaultSetting()?.user_id)")
                 //    print("company_id is = \(DefaultSetting.getDefaultSetting()?.company_id)")
                 //    print("location_type is = \(DefaultSetting.getDefaultSetting()?.location_type)")
                 //    print("client address is = \(DefaultSetting.getDefaultSetting()?.clientaddress)")
                 //    print("user id in last obj = \(DefaultSetting.getAll().first?.user_id)")
                 //    print("company_id is = \(DefaultSetting.getAll().first?.company_id)")
                 //    print("location_type is = \(DefaultSetting.getAll().first?.location_type)")
                 print("client address is = \(DefaultSetting.getAll().first?.clientaddress)")
                 /*  FEMDeserializer.object(fromRepresentation: dic, mapping: DefaultSetting.defaultMapping(), context: localContext)
                 
                 localContext.mr_save { (localContext) in
                 print("saving")
                 } completion: { (status, error) in
                 print("status of defaultsaving \(status)")
                 print("error of defaultsaving \(error)")
                 for user in DefaultSetting.getAll(){
                 print("Default companyid in setting \(user.company_id ?? 1) total settings \(DefaultSetting.getAll().count)")
                 
                 print(DefaultSetting.getDefaultSetting())
                 print("user id = \(DefaultSetting.getDefaultSetting()?.user_id)")
                 }
                 }
                 
                 }, completion: { (status, error) in
                 print("Default setting saved :)")
                 
                 for user in DefaultSetting.getAll(){
                 print("Default setting \(user.company_id ?? 1) total settings \(DefaultSetting.getAll().count)")
                 print(DefaultSetting.getDefaultSetting())
                 print("user id = \(DefaultSetting.getDefaultSetting()?.user_id)")
                 }*/
                 })*/
                 
                 /*   { (status, error) in
                 if(error == nil){
                 print(error?.localizedDescription)
                 
                 if let set = DefaultSetting.mr_findAll()?.first as? DefaultSetting{
                 print(set.clientaddress)
                 print(set.clientvendorid)
                 print(set.company_id)
                 }
                 
                 print("setting saved")
                 self.fillData()
                 
                 }*/
                 */
            }else if(error.code == 0){
                view.dismiss(animated: true, completion: nil)
                view.view.makeToast(message, duration: 2.0, position: CGPoint.init(x: 10, y: 80))
            }else{
                view.dismiss(animated: true, completion: nil)
                view.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
            }
        }
    }
    func userCheckIn(status:Bool,viewController:UIViewController){
        parentview = viewController
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
       
       let  arrCustomerList = CustomerDetails.getAllCustomers()
       let  arrVendorList =  Vendor.getAll()
        if let coord = Location.sharedInsatnce.getCurrentCoordinate(){
            if(CLLocationCoordinate2DIsValid(coord)){
//                if(coord.latitude > 0 && coord.longitude > 0){
                    
                    param["UserID"] = self.activeuser?.userID
                    param["CompanyID"] = self.activeuser?.company?.iD
                    param["Latitude"] = coord.latitude
                    param["Longitude"] = coord.longitude
//                }else{
//                    SVProgressHUD.dismiss()
//                    let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
//                    let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
//                        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
//                    }
//                    Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
//                }
                
                if(AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 1)){
                    param["ClientVendorID"] = NSNumber.init(value:0)
                    //var address = AddressInfo()
                    //if(self.activesetting.addressSettingsForAttendance == 1){
                    //    address = AttendanceCheckInCheckOut.mutAddressOffice[AttendanceViewController.tfAddressTag]
                    //}else if(self.activesetting.addressSettingsForAttendance == 2){
                    //    address = AttendanceCheckInCheckOut.mutAddressBranch[AttendanceViewController.tfAddressTag]
                    //}else {
                    //    address = AttendanceCheckInCheckOut.mutaddressBoth[AttendanceViewController.tfAddressTag]
                    //   }
                    let address1 = AttendanceCheckInCheckOut.defaultsetting?.clientAddress as? AddressListModel
                    param["AddressMasterID"] = address1?.addressId
                    param["Type"] = NSNumber.init(value:1)
                }else if(AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 2)){
                   // let cust = AttendanceViewController.arrOfSelectedMultipleCustomer[0] //AttendanceCheckInCheckOut.arrCustomerList[AttendanceViewController.tfLocationTag]
                   
                    let add = AttendanceViewController.selectedAddreeList//cust.addressList[AttendanceViewController.tfLocationTag > 0 ? AttendanceViewController.tfLocationTag :0] as? AddressList
                    param["ClientVendorID"] =  AttendanceCheckInCheckOut.defaultsetting.clientvendorid
                    param["AddressMasterID"] = add.addressId
                    param["Type"] = NSNumber.init(value:3)
                }else if(AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 3)){
//                    var cust = CustomerDetails()
//                    if let customer = CustomerDetails.getCustomerByID(cid: AttendanceCheckInCheckOut.defaultsetting.clientvendorid) as? CustomerDetails{
//                        cust = customer
//                    }else{
//                        cust =
//                    }
                    let vendorAdd = AttendanceViewController.selectedAddreeList
                    param["ClientVendorID"] = AttendanceCheckInCheckOut.defaultsetting.clientvendorid 
                    param["AddressMasterID"] = vendorAdd.addressId
                    param["Type"] = NSNumber.init(value:2)
                }else if(AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 4)){
                   
                    param["Type"] =  NSNumber.init(value:4)
                    param["AddressMasterID"] = NSNumber.init(value:0)
                    param["travelAddress"] = AttendanceViewController.tarvelAddress
                }else if(AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 7)){
                    param["Type"] = NSNumber.init(value:7)
                    param["AddressMasterID"] = NSNumber.init(value:0)
                    param["travelAddress"] = AttendanceViewController.tarvelAddress
                }else if(AttendanceCheckInCheckOut.defaultsetting.locationType == NSNumber.init(value: 8)){
                    param["Type"] = NSNumber.init(value:8)
                    param["AddressMasterID"] = self.activeuser?.permanentAddress?.address_id
                    
                }
                var strurl  = ""
                if(status == true){
                    strurl =  ConstantURL.kWSUrlCheckIn
                }else{
                    strurl = ConstantURL.kWSUrlCheckOut
                }
                var givenImg = UIImage()
                if  let img  =   AttendanceCheckInCheckOut.selfieImagecheckincheckout as? UIImage{
                    param["Is_File"] =  true
                    givenImg  = img
                }else{
                    param["Is_File"] =  false
                    
                }
                self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: strurl, img: givenImg, imgparamname: "File", param: param) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    AttendanceCheckInCheckOut.selfieImagecheckincheckout = nil//UIImage()
                   
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        SVProgressHUD.dismiss()
                        viewController.view.makeToast(message, duration: 2.0, position: CGPoint.init(x: 160, y: viewController.view.frame.height - 80))
                        
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
                            NotificationCenter.default.post(name: Notification.Name.init("updateplancheckinInfo"), object: nil,userInfo: nil)
                            SVProgressHUD.dismiss()
                        })
                        // func saveToDataBase(data:[TestData]){
                        //            for data1 in arrOfAttendance{
                        //
                        //                let request:NSFetchRequest<AttendanceHistory> = AttendanceHistory.fetchRequest()
                        //                do {
                        //                    let count = try managedObjectcontext.count(for: request)
                        //                    if count == 0 {
                        //                        // save data according to your requirement.
                        //                        print(data1)
                        //                    }else{
                        //
                        //                        //if anything you want to update then wright here
                        //                    }
                        //
                        //                }catch{
                        //                    let error  = error as NSError
                        //                    print("\(error)")
                        //                }
                        //            }
                        //     }
                        
                    } else if(error.code == 0){
                        SVProgressHUD.dismiss()
                        viewController.view.makeToast(message, duration: 2.0, position: CGPoint.init(x: 10, y: 80))
                    }else{
                        SVProgressHUD.dismiss()
                        if(message.lowercased() == "you are not at work location"){
                            Utils.toastmsg(message: message, view: self.view)
                           // viewController.view.makeToast(message, duration: 2.0, position: CGPoint.init(x: 10, y: 80))
                            self.displayAlert(displayview: self.parentview ?? self)
                        }else{
                        viewController.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription, duration: 2.0, position: CGPoint.init(x: 160, y: viewController.view.frame.height - 80))
                        }
                        //    self.parentview.view.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription)
                    }
                }
            }else{
                SVProgressHUD.dismiss()
                self.parentview.view.makeToast("Latitude or Longitude is zero, please try again", duration: 2.0, position: CGPoint.init(x: 160, y: self.parentview.view.frame.height - 80))
                //   self.parentview.view.makeToast("Latitude or Longitude is zero, please try again")
            }
            
        }else{
            SVProgressHUD.dismiss()
            let cancelaction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: nil)
            let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: UIAlertAction.Style.default) { (action) in
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
            }
            viewController.view.makeToast("Please enable Location Services in Settings", duration: 2.0, position: CGPoint.init(x: 160, y: self.parentview.view.frame.height - 80))
            Common.showalertWithAction(msg: "Please enable Location Services in Settings", arrAction: [cancelaction,settingAction], view: viewController)
        }
        
    }

    func verfyingAddress(status:Bool){//(status:Int,lat:NSNumber,long:NSNumber,isVisitPlanned:VisitType,objplannedVisit:PlannVisit,objunplannedVisit:UnplannedVisit,visitid:NSNumber,viewcontroller:UIViewController,addressID:NSNumber){
       // let currenlocation =  Location.sharedInsatnce.currentLocation
       
      
        if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
            //          CLLocationCoordinate2DIsValid(currentCoordinate)
            if(CLLocationCoordinate2DIsValid(currentCoordinate)){
                let currentlat =  currentCoordinate.latitude
                let currentlong = currentCoordinate.longitude
                if let attendancecheckin = AttendanceCheckInCheckOut.verifycheckinAdd{
                    if(!attendancecheckin){
                        AttendanceCheckInCheckOut.verifycheckinAdd = true
                      
                        self.userCheckIn(status: status, viewController: parentview)
                    }else{
                        if(status){
                            self.displayAlert(displayview: self)
                        }
                    }
                }
                if let attendancecheckout = AttendanceCheckInCheckOut.verifycheckoutAdd{
                    if(!attendancecheckout){
                        AttendanceCheckInCheckOut.verifycheckoutAdd = true
                        self.userCheckIn(status: status, viewController: parentview)
                    }else{
                        if(status == false){
                            self.displayAlert(displayview: self)
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
    
}

//extension AttendanceCheckInCheckOut :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//
//        picker.dismiss(animated: true
//            , completion:   nil)
//    }
//
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.show()
//        AttendanceCheckInCheckOut.isSelefieAvailbalecheckincheckout = true
//       if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//       {
//        AttendanceCheckInCheckOut.selfieImagecheckincheckout = chosenImage
//        if(AttendanceCheckInCheckOut.isCheckInAtcheckincheckout){
//            self.userCheckIn(status: true, viewController: parentview)
//        }else{
//            self.userCheckIn(status: false, viewController: parentview)
//        }
//
//        }
//
//
//        picker.dismiss(animated:true, completion: nil)
//
//    }
//}
