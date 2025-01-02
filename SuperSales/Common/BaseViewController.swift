//
//  BaseViewController.swift
//  SuperSales
//
//  Created by Apple on 23/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import GooglePlaces
import CoreData
import MonthYearPicker
import FastEasyMapping
//import PaddingLabel


@objc protocol BaseViewControllerDelegate
{
    @objc optional func backTapped()
    @objc optional func mapTapped()
    @objc optional func editiconTapped(sender:UIBarButtonItem)
    @objc optional func menuitemTouched(item:UPStackMenuItem,companymenu:CompanyMenus)
    @objc optional func datepickerSelectionDone()
    @objc optional func cancelbtnTapped()
    @objc optional func cameraTapped()
    @objc optional func reloadTapped()
    @objc optional func syncTapped()
    @objc optional func notificationTapped()
}

protocol SideMenuDelegate
{
    func sideMenuItemSelectedAtIndex(_ index : Int32)
    
}

class BaseViewController: UIViewController , SideMenuDelegate{
    public static var blackuniversalcolor = UIColor()
   
    public typealias ResponseUserBlock = (arruser:[CompanyUsers],error:NSError)
    public typealias AddressCompeletionBlock = (address: [String:Any],error:NSError)
    public typealias AddressFromGoogleAPIKey = (String)
    var  btnMenuEditBar = UIBarButtonItem()
//  public static let sharedInsatnce = Location()
    public static var staticlowerUser:[CompanyUsers]! = [CompanyUsers]()
    var lowerUser:[CompanyUsers]! = [CompanyUsers]()
    var lowerExecutiveUser:[CompanyUsers]!  = [CompanyUsers]()
    var containSlider = false
    static var blurEffectView:UIView!
    static var menuview : MenuViewController!
    let activesetting = Utils().getActiveSetting()
    let activeuser = Utils().getActiveAccount()
    var btnback:UIBarButtonItem? //back button
    var btnHome:UIBarButtonItem? //Home button
    var istabBarpresent:Bool!
    var stack:UPStackMenu!
    var stackparentView:UIView?
    public var btnPlus:UIButton!
    var contentView:UIView!
    var blurEffectVisusalView:UIVisualEffectView!
    var items:[UPStackMenuItem]?
    var parentviewController:UIViewController?
    var salesPlandelegateObject:BaseViewControllerDelegate?
    var parentdatepicker:UIDatePicker!
    var parentMonthYeardatepicker:MonthYearPickerView!
    var toolBar:UIToolbar!
    var userLatestActivity = UserLatestActivityForVisit.none
    var dateFormatter:DateFormatter = DateFormatter.init()
    let apihelper =  ApiHelper()
    var cmenus:[CompanyMenus]!
    
    lazy private(set) var popoverConfiguration: FTConfiguration = {
        let config = FTConfiguration()
        config.selectedTextColor = UIColor.white
        config.textColor = .black
        config.backgoundTintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        config.isTitleNeeded = true
        config.selectedCellBackgroundColor = UIColor.white
        config.alternateCellColor = true
        config.menuSeparatorInset = .zero
        config.menuWidth = 200
        config.borderWidth = 4.0
        config.borderColor = .white
        return config
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0 , *) {
            BaseViewController.blackuniversalcolor = UIColor(named:"universal_black") ?? UIColor.black
        }else{
            BaseViewController.blackuniversalcolor = UIColor.black
        }
        parentdatepicker = UIDatePicker()
        parentdatepicker.setCommonFeature()
        toolBar = UIToolbar()
        contentView = UIView()
        btnPlus = UIButton()
        stackparentView   = UIView()
        stack =  UPStackMenu()
        //UIColor.init(red: 0/255.0, green: 144/255.0, blue: 247/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255.0, green: 144/255.0, blue: 247/255.0, alpha: 1.0)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            appearance.backgroundColor = UIColor.init(red: 0/255.0, green: 144/255.0, blue: 247/255.0, alpha: 1.0)
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        }
        self.navigationController?.navigationBar.titleTextAttributes =               [NSAttributedString.Key.foregroundColor : UIColor.white]
        // Do any additional setup after loading the view.
        
        //right slider
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        
        BaseViewController.blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        BaseViewController.blurEffectView.frame = self.view.bounds
        BaseViewController.blurEffectView.backgroundColor = .white
        
        BaseViewController.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //datepicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: view.frame.size.width, height: 200))
        
        BaseViewController.menuview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: "menuviewcontroller") as? MenuViewController
        
        BaseViewController.menuview.sidemenudelegate? = self
    }
    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidAppear(true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //if(((parentviewController?.view.subviews.contains(stack))) != nil){
//        if((self.stackparentView?.subviews.contains(self.blurEffectVisusalView)) != nil){
//            print("btn should collapse")
//            self.changeDemo(sender: self.btnPlus)
//        }

        if let stview = stackparentView as? UIView{
            if(self.view.subviews.contains(stview)){
                stview.removeFromSuperview()
            }
        }
      
    }
    
    // MARK: Some useful method  //@escaping AddressCompeletionBlock
    func hideBtnPlus(){
        if(parentviewController?.view.subviews.contains(btnPlus) ?? false)
        {
            btnPlus.removeFromSuperview()
        }else{
            
        }
    }
    
    
    
    func getAddressFromCurrentLocation(completion:@escaping(AddressCompeletionBlock)->Void){
        let placefield = GMSPlacesClient.shared()
      
        let fields: GMSPlaceField = [.name, .placeID, .coordinate, .all,.formattedAddress]

//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.all.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue))
        placefield.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields:fields) { (likelihoods, error) in
            if(error != nil){
                if let topController = UIApplication.shared.keyWindow?.rootViewController {

                        
                        
                        Common.showalert(msg: error?.localizedDescription ?? "",view:topController)
              
                }
                
                return
            }else{
                if(likelihoods?.count ?? 0 > 0){
                    let place = likelihoods?.first?.place
                    placefield.lookUpPlaceID(place!.placeID!, callback: { (p, error) in
                        if(error == nil){
                            completion((self.getAddressOfUser(pl: p!),Common.returnnoerror()))
                        }else{
                            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                               if  let presentedViewController = topController.presentedViewController {
                                    topController = presentedViewController
                                    
                                    
                                    Common.showalert(msg: error?.localizedDescription ?? "",view:topController)
                               }else{
                                Common.showalert(msg: error?.localizedDescription ?? "",view:topController)
                               }
                                
                                // topController should now be your topmost view controller
                            }
                            // Common.showalert(msg: error?.localizedDescription ?? "")
                        }
                    })
                }
            }
        }
    }
    
    
    func getAddressOfUser(pl:GMSPlace)->[String:Any]{
        
        var address = ["address1":pl.name ?? ""] as [String:Any]
        let addresscomponent = pl.addressComponents
        var straddress1 = ""
        if(addresscomponent?.count  == 0){
            if((pl.formattedAddress?.count == 0) || (pl.formattedAddress == "(null)")){
                let coordinate = pl.coordinate
                if(CLLocationCoordinate2DIsValid(coordinate)){
                    let location = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    let geo = CLGeocoder.init()
                    geo.reverseGeocodeLocation(location) { (placemarks, error) in
                        if(placemarks?.count ?? 0 > 0 && placemarks?.first != nil){
                            let placemark = placemarks!.first
                            straddress1.append(placemark!.thoroughfare ?? "")
                            straddress1.append(placemark?.subThoroughfare ?? "")
                            address["address2"] =  straddress1
                            address["city"] = placemark!.locality
                            address["state"] = placemark?.administrativeArea
                            address["country"] =  placemark?.country
                            if(placemark?.postalCode != nil){
                                address["postalcode"] = placemark?.postalCode
                            }else{
                                address["postalcode"] = "0"
                            }
                            let formatedaddress =      placemark?.addressDictionary?["FormattedAddressLines"]
                            address["FormattedAddressLines"] = formatedaddress as? String ?? ""
                            
                            
                            
                        }else{
                            Utils.toastmsg(message:"Not getting proper address!",view: self.view)
                        }
                    }
                    
                    
                }else{
                    Utils.toastmsg(message:"Not getting proper address!",view: self.view)
                }
                address["latitude"] =  pl.coordinate.latitude
                address["longitude"] = pl.coordinate.longitude
                address["address2"] = straddress1
                return address
            }else{
                let arrOfAddress = pl.formattedAddress?.components(separatedBy: ",")
                if(arrOfAddress?.count ?? 0 > 0){
                    straddress1.append(arrOfAddress?.first ?? "")
                }
                address["latitude"] = NSNumber.init(value: pl.coordinate.latitude)
                address["longitude"] = NSNumber.init(value: pl.coordinate.longitude)
                address["address2"] = straddress1
                return address
            }
        }
        else{
            for addcomponent in addresscomponent!{
                if(addcomponent.type == "route"){
                    straddress1.append(addcomponent.name)
                    straddress1.append(", ")
                }
                if(addcomponent.type == "neighborhood"){
                    straddress1.append(addcomponent.name)
                    straddress1.append(", ")
                }
                if(addcomponent.type == "sublocality_level_1"){
                    straddress1.append(addcomponent.name)
                    straddress1.append(", ")
                }else if(addcomponent.type == "locality"){
                    address["city"] = addcomponent.name
                }else if(addcomponent.type == "administrative_area_level_1"){
                    address["state"] = addcomponent.name
                }else if(addcomponent.type == "country"){
                    address["country"] = addcomponent.name
                }else if(addcomponent.type == "postal_code"){
                    address["postalcode"] = addcomponent.name
                }else if(addcomponent.type == ""){
                    
                }
                
            }
            address["latitude"] = NSNumber.init(value: pl.coordinate.latitude)
            address["longitude"] = NSNumber.init(value: pl.coordinate.longitude)
            address["address2"] = straddress1
            return address
        }
    }
    func openOnlyMonthDatePicker(view:UIView,dateType:UIDatePicker.Mode,tag:Int,datepicker:MonthYearPickerView,textfield:UITextField?,withDateMonth:Bool){
        if(withDateMonth){
            Utils.addShadow(view: self.view)
            
            parentMonthYeardatepicker = datepicker
            print(parentMonthYeardatepicker.frame)
            
            // parentdatepicker.datePickerMode = dateType
            //    parentMonthYeardatepicker.setCommonFeature() //.lightBackgroundColor
            //            if #available(iOS 13.4, *) {
            //            self.preferredDatePickerStyle = .wheels
            //            }
            parentMonthYeardatepicker.backgroundColor = UIColor.white
            parentMonthYeardatepicker.tag = tag
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor.black
            toolBar.sizeToFit()
            parentMonthYeardatepicker.sizeToFit()
            
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(mySelect))
            
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelTapped))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            var yorigin =  parentMonthYeardatepicker.frame.origin.y
            //self.view.frame.size.height -
            yorigin = yorigin - 40
            print("yorigin = \(yorigin)")
            parentMonthYeardatepicker.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
            toolBar.frame = CGRect.init(x: 0, y: yorigin, width: self.view.frame.size.width, height: 40)
            toolBar.frame = CGRect.init(x: 0, y: datepicker.frame.origin.y - 40, width: self.view.frame.size.width, height: 40)
            // }
            if(textfield != nil){
                //(0, 0, [UIScreen mainScreen].bounds.size.width, 40)
                toolBar.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40)
                textfield?.inputAccessoryView =  toolBar
            }else{
                if(!(view.subviews.contains(parentMonthYeardatepicker.self))){
                    view.addSubview(parentMonthYeardatepicker)
                    view.addSubview(toolBar)
                }
                
            }
        }
        
    }
    func openDatePicker(view:UIView,dateType:UIDatePicker.Mode,tag:Int,datepicker:UIDatePicker,textfield:UITextField?,withDateMonth:Bool){
        if(withDateMonth){
            /*   if let shadow = Utils.shadowView as? UIView{
             if(self.view.subviews.contains(shadow)){
             Utils.addShadowOnSahdow(view: self.view)
             }else{
             Utils.addShadow(view: self.view)
             }
             }else{*/
            Utils.addShadowOnSahdow(view: self.view)
            //  Utils.addShadow(view: self.view)
            //  }
            parentdatepicker = datepicker
            print(parentdatepicker.frame)
            
            parentdatepicker.datePickerMode = dateType
            parentdatepicker.setCommonFeature() //.lightBackgroundColor
            parentdatepicker.tag = tag
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor.black
            toolBar.sizeToFit()
            datepicker.sizeToFit()
            parentdatepicker.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(mySelect))
            
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelTapped))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            var yorigin =  parentdatepicker.frame.origin.y
            //self.view.frame.size.height -
            yorigin = yorigin - 40
            
            datepicker.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
            toolBar.frame = CGRect.init(x: 0, y: yorigin, width: self.view.frame.size.width, height: 40)
            // }
            if(textfield != nil){
                //(0, 0, [UIScreen mainScreen].bounds.size.width, 40)
                toolBar.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40)
                textfield?.inputAccessoryView =  toolBar
            }else{
                if(!(view.subviews.contains(datepicker.self))){
                    view.addSubview(datepicker)
                    view.addSubview(toolBar)
                }
                
            }
            
        }else{
            if let shadow = Utils.shadowView as? UIView{
                if(self.view.subviews.contains(shadow)){
                    Utils.addShadowOnSahdow(view: self.view)
                }else{
                    Utils.addShadow(view: self.view)
                }
            }else{
                Utils.addShadow(view: self.view)
            }
            
            parentdatepicker = datepicker
            print(parentdatepicker.frame)
            
            parentdatepicker.datePickerMode = dateType
            parentdatepicker.setCommonFeature() //.lightBackgroundColor
            parentdatepicker.tag = tag
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor.black
            toolBar.sizeToFit()
            datepicker.sizeToFit()
            parentdatepicker.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(mySelect))
            
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelTapped))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            var yorigin =  parentdatepicker.frame.origin.y
            //self.view.frame.size.height -
            yorigin = yorigin - 40
            
            datepicker.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
            toolBar.frame = CGRect.init(x: 0, y: yorigin, width: self.view.frame.size.width, height: 40)
            toolBar.frame = CGRect.init(x: 0, y: datepicker.frame.origin.y - 40, width: self.view.frame.size.width, height: 40)
            // }
            if(textfield != nil){
                //(0, 0, [UIScreen mainScreen].bounds.size.width, 40)
                toolBar.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40)
                textfield?.inputAccessoryView =  toolBar
            }else{
                if(!(view.subviews.contains(datepicker.self))){
                    view.addSubview(datepicker)
                    view.addSubview(toolBar)
                }
                
            }
        }
        
    }
    
    @objc func mySelect(){
        Utils.removeShadow(view: UIView())
        salesPlandelegateObject?.datepickerSelectionDone!()
        for v in view.subviews{
            if(type(of: v) == UIDatePicker.self){
                v.removeFromSuperview()
            }
            //            else if(type(of: v) == MonthYearPicker.self){
            //                v.removeFromSuperview()
            //
            //            }
        }
        //datepicker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    @objc func cancelTapped(){
        Utils.removeShadow(view: UIView())
        salesPlandelegateObject?.cancelbtnTapped!()
        //   datepicker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    
    
    func getLatestCheckinDetail()->String{
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        print(Date().shortDate)
        let attendanceForToday = AttendanceHistory.getLatestAttendanceForDate(date: dateFormatter.date(from: Date().shortDate)! , userID: activeuser?.userID ?? 0)
        
        //        for atte in attendanceForToday{
        //            dateFormatter.dateFormat = "yyyy/MM/dd"
        //
        //        }
        
        //        Account *currentAccount = ACTIVE_ACCOUNT;
        //        NSDateFormatter *formater = [[NSDateFormatter alloc]init];
        //        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];       // Sun Aug  4 16:34:00 2019
        //        [formater setDateFormat:@"dd-MM-yyyy"];
        //        if(currentAccount.role_id > 6){
        //            NSMutableArray *mutArrOfAttendanceForToday =   [_AttendanceHistory getAll] ;
        //
        //            NSLog(@"attendance history data = %@",mutArrOfAttendanceForToday);
        return ""
    }
    
    // MARK: - Top View Set
    
    func setleftbtn(btnType:BtnLeft,navigationItem:UINavigationItem){
        if(btnType == BtnLeft.menu){
            
            btnback = UIBarButtonItem.init(image: UIImage.init(named: "icon_menu"), style: .plain, target: self, action:  #selector(self.btnMenuTapped(_:)))
            navigationItem.leftBarButtonItem = btnback
        }else{
            btnback = UIBarButtonItem.init(image: UIImage.init(named: "icon_arrow_back"), style: .plain, target: self, action: #selector(btnBackTapped))
            navigationItem.leftBarButtonItem = btnback
        }
    }
    
    func setrightbtn(btnType:BtnRight,navigationItem:UINavigationItem){
        
        btnMenuEditBar = UIBarButtonItem.init(image: UIImage.init(named: "icon_menu_edit"), style: .done , target: self, action:#selector(btnEditTapped))
        //btnMenuEditBar.imageInsets = UIEdgeInsets.init(top: 0, left: -15, bottom: 0, right: 0)
        let syncBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        syncBtn.setImage(UIImage.init(named: "icon_sync"), for: UIControl.State.normal)
        syncBtn.addTarget(self, action:#selector(btnSyncTapped), for: UIControl.Event.touchUpInside)
        syncBtn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
      
//        let btnSyncBar = UIBarButtonItem(customView: syncBtn)
//        btnHome = UIBarButtonItem.init(image: UIImage.init(named: "icon_home_white"), style: .plain, target: self, action: #selector(btnHomeTapped))
//        btnHome?.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        let reloadBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        reloadBtn.setImage(UIImage.init(named: "icon_reload"), for: UIControl.State.normal)
        reloadBtn.addTarget(self, action:#selector(btnReloadTapped), for: UIControl.Event.touchUpInside)
        reloadBtn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let btnReloadBar = UIBarButtonItem(customView: reloadBtn)
        
        
        let notificationBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notificationBtn.setImage(UIImage.init(named: "icon_notification"), for: UIControl.State.normal)
        notificationBtn.addTarget(self, action:#selector(btnNotificationTapped), for: UIControl.Event.touchUpInside)
        notificationBtn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let btnNotificationBar = UIBarButtonItem(customView: notificationBtn)
        
        
//        let editBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
//        editBtn.setImage(UIImage.init(named: "icon_edit"), for: UIControl.State.normal)
//        editBtn.addTarget(self, action:#selector(btnEditTapped), for: UIControl.Event.touchUpInside)
//        editBtn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
//        let btnEditBar = UIBarButtonItem(customView: editBtn)
////        let btnEditBar:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_edit"), style: .done , target: self, action:#selector(btnEditTapped))
//        
//        
//        let mapBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
//        mapBtn.setImage(UIImage.init(named: "icon_map"), for: UIControl.State.normal)
//        mapBtn.addTarget(self, action:#selector(btnMapTapped), for: UIControl.Event.touchUpInside)
//        mapBtn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
//        let btnMapBar = UIBarButtonItem(customView: mapBtn)
      //  let btnMapBar:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_map"), style: .done , target: self, action:#selector(btnMapTapped))

        let btnHome = UIBarButtonItem.init(image: UIImage.init(named: "icon_home_white"), style: .plain, target: self, action: #selector(btnHomeTapped))
        btnHome.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        if(btnType == BtnRight.home){
            
            // navigationItem.rightBarButtonItem = [UIBarButtonItem]()
            navigationItem.rightBarButtonItems = [UIBarButtonItem]()
            navigationItem.rightBarButtonItem = btnHome
        }else if(btnType == BtnRight.others){
            
            
          
            
//            let btnReloadBar:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_reload"), style: .done , target: self, action:#selector(btnReloadTapped))
//            btnReloadBar.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -40)
//            let btnNotificationBar:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_notification"), style: .done , target: self, action:#selector(btnNotificationTapped))
//            btnNotificationBar.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -10)
           
            
//            let btnSyncBar:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_sync"), style: .done , target: self, action:#selector(btnSyncTapped))
//            btnSyncBar.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -10)
            
           
            navigationItem.rightBarButtonItems = [btnNotificationBar,btnReloadBar] //[btnReloadBar,btnNotificationBar,btnSyncBar]
        }else if(btnType == BtnRight.othershome){
//            let btnReloadBar:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_reload"), style: .done , target: self, action:#selector(btnReloadTapped))
//            btnReloadBar.imageInsets = UIEdgeInsets.init(top: 0, left: -15, bottom: 0, right: 0)
  
            navigationItem.rightBarButtonItems = [btnHome,btnNotificationBar,btnReloadBar] //[btnReloadBar,btnNotificationBar,btnSyncBar,btnHome]
        }else if(btnType == BtnRight.editMap){
            let btnEditBar:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_edit"), style: .done , target: self, action:#selector(btnEditTapped))
            let btnMapBar:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_map"), style: .done , target: self, action:#selector(btnMapTapped))
            navigationItem.rightBarButtonItems = [btnMapBar,btnEditBar]
        }else if(btnType == BtnRight.camera){
            let btnCamera:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_camera"), style: .done , target: self, action:#selector(btnCameraTapped))
            navigationItem.rightBarButtonItem = btnCamera
        }else if(btnType == BtnRight.homeedit){
         
            
            navigationItem.rightBarButtonItems = [btnMenuEditBar,btnHome] as? [UIBarButtonItem]
        }else if(btnType == BtnRight.edit){
            
            navigationItem.rightBarButtonItems = [btnMenuEditBar]
        }else if(btnType == BtnRight.none) {
            navigationItem.rightBarButtonItems = [UIBarButtonItem]()
        }
    }
    
    @objc func btnCameraTapped(){
        salesPlandelegateObject?.cameraTapped!()
        
        
    }
    @objc func btnEditTapped(sender:UIButton){
        salesPlandelegateObject?.editiconTapped!(sender:  btnMenuEditBar)
    }
    
    @objc func btnMapTapped(){
        salesPlandelegateObject?.mapTapped!()
    }
    
    @objc func btnBackTapped(){
        
        salesPlandelegateObject?.backTapped?()
        if(self.navigationController?.viewControllers.count ?? 0 > 0){
            if(Common.skipVisitSelection == true){
                if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is AddLead }){
                    
                    AddLead().initialiseLeadData()
                }
                if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                    //  AddLead().initialiseLeadData()
                    if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                        self.navigationController?.popToViewController(controller,animated:true)
                    }
                }
                else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                    if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                        self.navigationController?.popToViewController(controller,animated:true)
                    }
                }else{
                    self.navigationController?.popViewController(animated:true)
                }
            }else{
                self.navigationController?.popViewController(animated:true)
            }
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func btnHomeTapped(){
        AppDelegate.shared.rootViewController.switchToMainScreen()
        // self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func btnReloadTapped(){
        //        self.navigationController?.popToRootViewController(animated: true)
        //        Login().logout()
        print("reload tapped")
        //salesPlandelegateObject?.datepickerSelectionDone!()
        salesPlandelegateObject?.reloadTapped!()
    }
    @objc func btnNotificationTapped(){
     
//            if let notificationcontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.NotificationContainer) as? NotificationContainer {
//                self.navigationController?.pushViewController(notificationcontainer, animated: true)
//            }
        salesPlandelegateObject?.notificationTapped!()
        print("notification tapped")
    }
    @objc func btnSyncTapped(){
        print("sync tapped")
        
        salesPlandelegateObject?.syncTapped!()
    }
    //    //set left item
    //    class func setletnavigationItem(item:UIBarButtonItem){
    //        navi
    //    }
    
    //Plus Menu 
    func initbottomMenu(menus:[UPStackMenuItem],control:UIViewController){
        print("class  = \(control)")
        //        if((!control.isKind(of: VisitContainer.self) || (!control.isKind(of: PlannedVisitList.self) || (!control.isKind(of: UnplannedVisitList.self) )))){
        parentviewController = control
        items = menus
        if(control is LeadListView){
            //stack.frame = CGRect.init(x:parentviewController!.view.frame.size.width - 75,y:parentviewController!.view.frame.size.height - 90,width: 80,height: 80)
            btnPlus = UIButton.init(frame: CGRect.init(x:self.view.frame.size.width - 75,y:self.view.frame.size.height - 248,width: 80,height: 80))
        }else{
        btnPlus = UIButton.init(frame: CGRect.init(x:self.view.frame.size.width - 75,y:self.view.frame.size.height - 190,width: 80,height: 80))
        }
        stackparentView?.frame =  btnPlus.frame
        control.view.addSubview(stackparentView ?? UIView())
        btnPlus.layer.cornerRadius = 30.0
        btnPlus.setImage(UIImage.init(named: "icon_plus"), for: .normal)
        btnPlus.addTarget(self, action: #selector(changeDemo), for: .touchUpInside)
        
        control.view.addSubview(btnPlus)
        //  }
    }
    
    func setparentview(control:UIViewController){
        parentviewController = control
        BaseViewController.menuview =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: "menuviewcontroller") as? MenuViewController
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        
        blurEffectVisusalView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectVisusalView.frame = self.view.bounds
        blurEffectVisusalView.backgroundColor = .white
        blurEffectVisusalView.alpha = 0.3
        //    MainViewController.tabBarOfApp.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0x010000)
    blurEffectVisusalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // menuview.sidemenudelegate? = self
    }
    
    func sideMenuItemSelectedAtIndex(_ index: Int32)
    {
        let topViewController : UIViewController = self.navigationController!.topViewController! 
        print("Base View Controller is : \(topViewController) \n")
        
        
    }
    
    
    func fetchuser(completion:@escaping(ResponseUserBlock)->Void){
    
        if(BaseViewController.staticlowerUser.count == 0){
            print("\(BaseViewController.staticlowerUser) in base view controller")
            self.apihelper.getLowerHierarchyUser { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(error.code == 0)   {
                    let arrOfUser = arr as? [[String:Any]] ?? [[String:Any]]()
                    var arrId:[NSNumber] = [self.activeuser?.userID ?? NSNumber.init(value:0)]
                    if(arrOfUser.count > 0){
                        
                        for item in arrOfUser{
                            arrId.append(NSNumber.init(value: (item["id"] as? Int ?? 0)))
                        }
                        //    print(arrOfUser["id"])
                        BaseViewController.staticlowerUser = [CompanyUsers]()
                        
                        self.lowerExecutiveUser = [CompanyUsers]()
                        for user in BaseViewController.staticlowerUser{
                            print("role id = \(user.role_id.intValue) at edited method")
                        }
                        BaseViewController.staticlowerUser = BaseViewController.staticlowerUser.filter{
                            $0.role_id.intValue <=  8
                        }
                        //  self.lowerExecutiveUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrexecutiveId)
                        BaseViewController.staticlowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                        self.lowerUser = [CompanyUsers]()
                        self.lowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                    }
                }else {
                    print("error is  = \(error.localizedDescription)")
                }
                /*if(error.code == 0){
                    let arrOfUser = arr as? [[String:Any]] ?? [[String:Any]]()
                    var arrId:[NSNumber] = [self.activeuser?.userID ?? NSNumber.init(value:0)]
                    if(arrOfUser.count > 0){
                        
                        for item in arrOfUser{
                            arrId.append(NSNumber.init(value: (item["id"] as? Int ?? 0)))
                        }
                        //    print(arrOfUser["id"])
                        BaseViewController.staticlowerUser = [CompanyUsers]()
                        
                        self.lowerExecutiveUser = [CompanyUsers]()
                        for user in BaseViewController.staticlowerUser{
                            print("role id = \(user.role_id.intValue) at base view")
                        }
                      
                        //  self.lowerExecutiveUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrexecutiveId)
                        BaseViewController.staticlowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                        BaseViewController.staticlowerUser = BaseViewController.staticlowerUser.filter{
                          
                            $0.role_id.intValue <=  8
                        }
                        self.lowerUser = [CompanyUsers]()
                        self.lowerUser = CompanyUsers().getFilteredUserByIDs(arrOfId: arrId)
                        //        self.lowerExecutiveUser =  BaseViewController.staticlowerUser.filter({ (value:CompanyUsers) -> Bool in
                        //                            return value.role_id == NSNumber.init(value: 8)
                        //                        })
                        
                        
                        //                        let allUserCount = BaseViewController.staticlowerUser.count-1
                        //                        for i in 0...allUserCount {
                        //
                        //                            if(i < BaseViewController.staticlowerUser.count){
                        //                                let user = BaseViewController.staticlowerUser[i]
                        //                            if(BaseViewController.staticlowerUser.contains(user)){
                        //                                BaseViewController.staticlowerUser.remove(at: i)
                        //                            }
                        //                            }
                        //                        }
                        completion((BaseViewController.staticlowerUser,error))
                    }else{
                        completion(([CompanyUsers](),error))
                        //                       Utils.toastmsg(message:message,view: self.view)
                    }
                }else{
                    print("error is  = \(error.localizedDescription)")
                }*/
            }
        }else{
            SVProgressHUD.dismiss()
            completion((BaseViewController.staticlowerUser,Common.returnnoerror()))
        }
        //            return self.arrLowerLevelUser
    }
    
    @objc func btnMenuTapped(_ sender : UIBarButtonItem)  {
        
        if let viewControllers = parentviewController!.navigationController?.viewControllers {
            for view in viewControllers {
                if view.isKind(of: MenuViewController.self) {
                    
                    //Your Process
                    containSlider = true
                }
                else{
                    print(type(of: view))
                }
            }
        }else{
            
        }
        if(!parentviewController!.view.subviews.contains(BaseViewController.menuview.view)){
            
            parentviewController!.view.addSubview(BaseViewController.blurEffectView)
            UIView.animate(withDuration: 0.3, animations:
                            { () -> Void in
                                print(self.view.subviews.count)
                                BaseViewController.menuview.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
                                BaseViewController.menuview.view.layoutIfNeeded()
                                BaseViewController.menuview.view.backgroundColor = UIColor.clear
                            },completion:
                                {   (finished) -> Void in
                                    
                                   // self.parentviewController?.view.addSubview(BaseViewController.menuview.view)
                                    self.parentviewController?.navigationController?.view.backgroundColor = .black
                                    
                                    self.parentviewController?.navigationController?.view.alpha = 0.4;   UIApplication.shared.keyWindow?.addSubview(BaseViewController.menuview.view)
                                    
                                    self.parentviewController?.addChild(BaseViewController.menuview)
                                    BaseViewController.menuview.view.layoutIfNeeded()
                                    
                                })
            
        }else{
            print(self.view.subviews)
            BaseViewController.menuview.view.removeFromSuperview()
            BaseViewController.menuview.removeFromParent()
            
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
    //    @objc func changeDemo(_ sender: UIButton) {
    
    @objc func changeDemo(sender: UIButton) {
      
        
        if(!parentviewController!.view.subviews.contains(stack)){
            
            
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
            blurEffectVisusalView  = UIVisualEffectView(effect: blurEffect)
            blurEffectVisusalView .frame = self.view.bounds
            blurEffectVisusalView .backgroundColor = .white
            blurEffectVisusalView .alpha  = 0.7
            blurEffectVisusalView .autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            
            //  let blureparentview = UIView.init(frame: UIScreen.main.bounds)
            stack  = UPStackMenu.init(contentView: sender)
            //UIButton.init(frame: CGRect.init(x:self.view.frame.size.width - 90,y:self.view.frame.size.height - 190,width: 80,height: 80))
            if(parentviewController is LeadListView){
                stack.frame = CGRect.init(x:parentviewController!.view.frame.size.width - 75,y:parentviewController!.view.frame.size.height - 90,width: 80,height: 80)
            }else{
            stack.frame = CGRect.init(x:parentviewController!.view.frame.size.width - 75,y:parentviewController!.view.frame.size.height - 190,width: 80,height: 80)
            }
            
            
            //
            stack.delegate =  self
            stack.addItems(items)
            stack.stackPosition = UPStackMenuStackPosition_up
            if(items?.count == 0){
                stack.isHidden = true
            }
           stack.openAnimationDuration = 0.2
            stack.closeAnimationDuration = 0.2
            for item in items ?? [UPStackMenuItem]() {
                item.labelPosition = UPStackMenuItemLabelPosition_left
                if((self.navigationController?.presentedViewController?.isKind(of: CustomerContainer.self)) != nil){
                item.backgroundColor = UIColor.lightGray
                }else{
                item.backgroundColor = UIColor.clear
                }
                //UIColor.init(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)//UIColor.lightGray//UIColor.init(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0) //UIColor().colorFromHexCode("0xEEEEEE")
                
                item.setTitleColor(.black)
            }
            
            self.setStackIconClosed(closed: true)
            
            parentviewController!.view.addSubview(stack)
        }else{
            stackparentView?.frame = btnPlus.frame
            stack.removeFromSuperview()
        }
        
    }
    
    
    func setStackIconClosed(closed:Bool){
        
        
        
        let img = btnPlus.imageView
        
        let angle = closed ? 0:(.pi * 0.25)
        UIView.animate(withDuration: 0.1) {
            // img!.layer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(angle)))
            self.btnPlus.layer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(angle)))
        }
        
    }
    
    func createUPStackMenuItems(isFromHome:Bool,view:UIViewController)->[CompanyMenus]{
        var items = [NSNumber]()//NSNumber.init(value: 31),
        if(isFromHome && activesetting.visitMenuOnHomeScreen == NSNumber.init(value: 1)){
            if(activeuser?.role?.id != 9){
                items =  [NSNumber.init(value: 28)
                          ,NSNumber.init(value: 29),
                          NSNumber.init(value: 30),
                          
                          NSNumber.init(value: 32),
                          NSNumber.init(value: 33),
                          NSNumber.init(value: 34),
                          NSNumber.init(value: 504)]
                
            }else{
                items = [NSNumber.init(value: 22),NSNumber.init(value: 24)]
            }
        }else{
            if(activeuser?.role?.id == NSNumber.init(value: 9)){
                items = [NSNumber.init(value: 22),NSNumber.init(value: 24)]
            }else{
                items = [NSNumber.init(value: 22),NSNumber.init(value: 23),NSNumber.init(value: 24),NSNumber.init(value: 25),NSNumber.init(value: 26),NSNumber.init(value: 504),NSNumber.init(value: 27)]
            }
        }
        if(!isFromHome && items.contains(NSNumber.init(value: 504))){
            items.remove(at: items.firstIndex(of:NSNumber.init(value: 504)) ?? 0)
        }
        if(activesetting.disableVisitFromPlusMenu == NSNumber.init(value: 1) && items.contains(NSNumber.init(value: 23))){
            items.remove(at: items.firstIndex(of:NSNumber.init(value: 23)) ?? 0)
        }
        if(activesetting.disableOrderFromPlusMenu == NSNumber.init(value: 1) && items.contains(NSNumber.init(value: 25))){
            items.remove(at: items.firstIndex(of:NSNumber.init(value: 25)) ?? 0)
        }
        if((activeuser?.role?.id != NSNumber.init(value: 7)) && items.contains(NSNumber.init(value: 34))){
            items.remove(at: items.firstIndex(of:NSNumber.init(value: 34)) ?? 0)
        }
        //remove attendance
        if(type(of: view) ==  SalesPlanHome.self){
            if(SalesPlanHome.screenselection == Dashboardscreen.dashboardvisit || SalesPlanHome.screenselection == Dashboardscreen.dashboardlead ||  SalesPlanHome.screenselection == Dashboardscreen.dashboardorder || SalesPlanHome.screenselection == Dashboardscreen.salesplan){
                if(isFromHome){
            items = items.filter{
                $0 != 22
            }
                }
        }
        }
        cmenus = CompanyMenus.getComapnyMenus(menu: items, sort: false)
        
        
        return cmenus
    }
    
    
    /*
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func getAddressFromLocation(location:CLLocation , completionblock:@escaping(AddressCompeletionBlock)->Void){
        var dic = [String:Any]()
        var strAddress = ""
        let ceo = CLGeocoder.init()
        ceo.reverseGeocodeLocation(location) { (placemarks , error) in
            if(placemarks?.count ?? 0 > 0 && placemarks?.first != nil){
                let placemark = placemarks?.first
                // strAddress.append(placemark?.name ?? "")
                
                
                strAddress.append(placemark?.thoroughfare ?? "")
                
                strAddress.append(placemark?.subThoroughfare ?? "")
                
                strAddress.append(placemark?.subLocality ?? "")
                dic["address2"] = strAddress
                dic["city"] = placemark?.locality?.count ?? 0 > 0 ? placemark?.locality:""
                dic["state"] = placemark?.administrativeArea
                dic["country"] =  placemark?.country
                dic["postalcode"] =  placemark?.postalCode?.count ?? 0 > 0 ? placemark?.postalCode : "0"
                
                dic["address1"] = placemark?.name
                dic["latitude"] = NSNumber.init(value:location.coordinate.latitude)
                dic["longitude"] = NSNumber.init(value:location.coordinate.longitude)
                completionblock((dic,NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : ""])))
            }else{
                print(error?.localizedDescription)
                
                completionblock((dic,error as! NSError))
            }
        }
        
    }
    
    func getAddressFromLatLong(lattitude:CLLocationDegrees ,longitude:CLLocationDegrees, completionblock:@escaping(AddressFromGoogleAPIKey)->Void){
        
        var strAddress = ""
        var urlString = String.init(format:"https://maps.googleapis.com/maps/api/geocode/json?latlng=")

        urlString.append(String.init(format:"\(lattitude),\(longitude)&sensor=true&key=\(Constant.GOOGLE_MAPS_PLACES_API)") )
        
      
        
        do {
            let  urlnsstring = try NSString.init(contentsOf: URL.init(string: urlString)!, encoding: String.Encoding.ascii.rawValue)
            if  let data = Data.init(base64Encoded: urlnsstring as String){//Data.init(base64Encoded: urlnsstring) ?? ""
            let arrResult = try JSONSerialization.jsonObject(with: data  , options: []) as? [[String:Any]]
            
            print(arrResult)
            }
//            if  let data = Data.init(base64Encoded: urlnsstring) as? Data{//Data.init(base64Encoded: urlnsstring) ?? ""
//            let arrResult = try JSONSerialization.jsonObject(with: data  , options: []) as? [[String:Any]]
//            
//            print(arrResult)
//            }
//        if let arrResultAdd = arrResult["results"] {
//            if(arrResultAdd.count > 0){
//                let firstadd  = arrResultAdd[0]
//                strAddress = firstadd["formatted_address"] as? String ?? ""
//            }
//        }
        } catch {
    print(error)
}
        //String.init(format:"https://maps.googleapis.com/maps/api/geocode/json?latlng=",\(lattitude.float)","\(longitude.float)"&sensor=true&key=AIzaSyAeLmS0YEqgGth7Ia7XMHjpZdAvIMfWZI4")
        //        let  locationstring = NSString.stringWithContents(of: URL.init(string:urlString)).encode(to: .ascii)
        //        //urlString.stringWithContents(of: URL.init(string: urlString as String).asc)//urlString.stringWithContents(of: URL.init(string: urlString),NSASCIIStringEncoding)
        //        let jsonobj = JSONSerialization.data(withJSONObject:locationstring , options: <#T##JSONSerialization.WritingOptions#>)//JSONSerialization.data(withJSONObject: locationString.dataUsingEncoding(.utf8, allowLossyConversion: false), options: .fragmentsAllowed)
        //        let locationnsstring:NSString = NSString.init(contentsOf: URL.init, encoding: <#T##UInt#>)
        //        //NSString.stringWithContents(of: URL.init(String:urlString)).encode(to: Encoder.ascii)
        //        let jsonobj = JSONSerialization.data(withJSONObject: locationnsstring.data(using: .utf8), options:0)
        //        let arrResult = jsonobj["results"] as? [[String:Any]]
        //        if(arrResult.count > 0){
        //           strAddress =  arrResult[0]["formatted_address"]
        //        }
        //        completionblock(strAddress)
        
        completionblock(strAddress)
        
        //        var dic = [String:Any]()
        //        var strAddress = ""
        //        let ceo = CLGeocoder.init()
        //        ceo.reverseGeocodeLocation(location) { (placemarks , error) in
        //            if(placemarks?.count ?? 0 > 0 && placemarks?.first != nil){
        //                let placemark = placemarks?.first
        //               // strAddress.append(placemark?.name ?? "")
        //
        //
        //strAddress.append(placemark?.thoroughfare ?? "")
        //
        //strAddress.append(placemark?.subThoroughfare ?? "")
        //
        //strAddress.append(placemark?.subLocality ?? "")
        //dic["address2"] = strAddress
        //dic["city"] = placemark?.locality?.count ?? 0 > 0 ? placemark?.locality:""
        //dic["state"] = placemark?.administrativeArea
        //dic["country"] =  placemark?.country
        //dic["postalcode"] =  placemark?.postalCode?.count ?? 0 > 0 ? placemark?.postalCode : "0"
        //
        //    dic["address1"] = placemark?.name
        //    dic["latitude"] = NSNumber.init(value:location.coordinate.latitude)
        //    dic["longitude"] = NSNumber.init(value:location.coordinate.longitude)
        //                completionblock((dic,NSError()))
        //            }else{
        //                print(error?.localizedDescription)
        //
        //                completionblock((dic,error as! NSError))
        //            }
    }
    
    func openURLInBrowser(urlString:String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Cannot open URL")
            }
        } else {
            print("Invalid URL")
        }
    }
}
//extension BaseViewController:SalesPlanDelegate{
//    func menuitemTouched(item: UPStackMenuItem) {
//         print("method is in baseview controller")
//    }
//
////    func itemTouched(item: UPStackMenuItem) {
////        print("method is in baseview controller")
////      //  self.salesPlandelegateObject?.itemTouched(item: )
////    }
//
//
//}
extension BaseViewController:UPStackMenuDelegate{
    
    func stackMenuWillOpen(_ menu: UPStackMenu!) {
     
        if(btnPlus.subviews.count == 0){
            return
            
        }
        else{
            let window = UIWindow(frame: UIScreen.main.bounds)
            stackparentView?.frame = window.rootViewController?.view.frame ?? parentviewController!.view.frame
            blurEffectVisusalView .frame = stack.superview?.frame ?? CGRect.zero
           
            stackparentView?.addSubview(blurEffectVisusalView)
        }
        self.setStackIconClosed(closed: false)
        
    }
    
    func stackMenuWillClose(_ menu: UPStackMenu!) {
    
        if(btnPlus.subviews.count == 0){
            return
        }
        else{
            stackparentView?.frame = btnPlus.frame
            blurEffectVisusalView .frame = btnPlus.frame
        
           
            blurEffectVisusalView.removeFromSuperview()
        }
        self.setStackIconClosed(closed: true)
        
    }
    //- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index {
    //[stack closeStack];
    func stackMenu(_ menu: UPStackMenu!, didTouch item: UPStackMenuItem!, at index: UInt) {
        print(index)
        
        let selectedInt = Int(index)
        print(selectedInt)
        
        let selectedItem = cmenus![selectedInt]
        stack.closeStack()
        self.salesPlandelegateObject?.menuitemTouched!(item: item,companymenu:selectedItem)
        
        //       print(companymenu)
        //                  print(companymenu.menuID)
        //                  print(companymenu)
        //
        //                     if(selectedItem.menuID == 32){
        //                         //add manualvisit
        //                         if  let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
         //   Common.skipVisitSelection = false
        //
        //                         addjointvisit.visitType = VisitType.manualvisit
        //
        //                         self.navigationController!.pushViewController(addjointvisit, animated: true)
        //                         }
        //
        //
        //                     }else if(selectedItem.menuID == 29){
        //                         if let addunplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddUnplanVisitView) as? AddUnPlanVisit{
        //
        //                         self.navigationController!.pushViewController(addunplanvisit, animated: true)
        //                         }
        //                     }else if(selectedItem.menuID == 31){
        //                         //corporate meeting
        //                     }else if(selectedItem.menuID == 33){
        //                         //beat plan
        //                         let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView
        //                         self.navigationController!.pushViewController(beatplancontainer!, animated: true)
        //                     }else if(selectedItem.menuID == 28){
        //                         if let addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddplanVisitView) as? AddPlanVisit{
        //                         //    self.dismiss(animated: false) {
        //                         self.navigationController!.pushViewController(addplanvisit, animated: true)
        //                         }
        //                         //plan a visit
        //                     }else if(selectedItem.menuID == 504){
        //                         //kpi data
        //                     }else if(selectedItem.menuID == 30){
        //                         //Direct Visit Check-IN
        //                         if let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
        //    Common.skipVisitSelection = false
        //
        //                         addjointvisit.visitType = VisitType.directvisitcheckin
        //
        //                         self.navigationController!.pushViewController(addjointvisit, animated: true)
        //                         }
        //                     }else if(selectedItem.menuID == 23){
        //                         if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
        //                         as? Leadselection{
        //                         addplanvisit.selectionFor = SelectionOf.visit
        //                         self.navigationController!.pushViewController(addplanvisit, animated: true)
        //                         }
        //                     }else if(selectedItem.menuID == 24){
        //                      if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView) as? Leadselection{
        //                              newlead.selectionFor = SelectionOf.lead
        //
        //                             self.navigationController!.pushViewController(newlead, animated: true)
        //                     }
        //                     }
        //                    // let selectedcompanyid = CompanyMenus.
        //                     else if(item.title.lowercased() == "visit"){
        //
        //                        if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
        //                         as? Leadselection{
        //                         addplanvisit.selectionFor = SelectionOf.visit
        //                         self.navigationController!.pushViewController(addplanvisit, animated: true)
        //                         }
        //
        //                     }else if(item.title.lowercased() == "new beat route"){
        //
        //                     }else if(item.title.lowercased() == "lead"){
        //                         if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView) as? Leadselection{
        //                         newlead.selectionFor = SelectionOf.lead
        //
        //                        self.navigationController!.pushViewController(newlead, animated: true)
        //                         }
        //                     }else if(item.title.lowercased() == "new order"){
        //
        //                     }else if(item.title.lowercased() == "new cold call"){
        //                         if let addcoldvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit , classname: Constant.AddUnplanVisitView) as? AddUnPlanVisit{
        //                         self.navigationController!.pushViewController(addcoldvisit, animated: true)
        //                         }
        //
        //                     }else if(item.title.lowercased() == "beat plan"){
        //                         if let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView{
        //                         self.navigationController!.pushViewController(beatplancontainer, animated: true)
        //                         }
        //                     }
    }
}
extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}
extension Formatter {
    static let date = DateFormatter()
}
extension Date {
    
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                              in timeZone : TimeZone = .current,
                              locale   : Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    
    var localizedDescription: String {
        return localizedDescription()
    }
    
    var fullDate: String   {return localizedDescription(dateStyle: .full,   timeStyle: .none) }
    var longDate: String   {return localizedDescription(dateStyle: .long,   timeStyle: .none) }
    var mediumDate: String {return localizedDescription(dateStyle: .medium, timeStyle: .none) }
    var shortDate: String  {return localizedDescription(dateStyle: .short,  timeStyle: .none) }
    
    var fullTime: String   {return localizedDescription(dateStyle: .none,   timeStyle: .full) }
    var longTime: String   {return localizedDescription(dateStyle: .none,   timeStyle: .long) }
    var mediumTime: String {return localizedDescription(dateStyle: .none,   timeStyle: .medium) }
    var shortTime: String  {return localizedDescription(dateStyle: .none,   timeStyle: .short) }
    
    var fullDateTime: String   {return localizedDescription(dateStyle: .full,   timeStyle: .full) }
    var longDateTime: String   {return localizedDescription(dateStyle: .long,   timeStyle: .long) }
    var mediumDateTime: String { return localizedDescription(dateStyle: .medium, timeStyle: .medium) }
    var shortDateTime: String  {return  localizedDescription(dateStyle: .short,  timeStyle: .short) }
}

extension Date{
    func getDateFromJSONString(str:String)->Date{
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone.init(abbreviation: "UTC")! as TimeZone
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter.date(from: str)
        formatter.dateFormat = "dd-MM-yyyy"
        let strDate = formatter.string(from: date!)
        let requireformatDate = formatter.date(from: strDate) ?? Date()
        
        return requireformatDate
    }
}
