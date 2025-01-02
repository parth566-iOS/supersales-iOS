//
//  AddActivity.swift
//  SuperSales
//
//  Created by Apple on 27/07/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import DropDown
import CoreLocation
import LMGeocoder
import FastEasyMapping


class AddActivity: BaseViewController {

    @IBOutlet weak var tfActivityType: UITextField!
    
    @IBOutlet weak var tfCustomer: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfTime: UITextField!
    var isEdit:Bool! = false
    var isFirstTime =  false
    var strNextActionTime = ""
    var selectedActivityType:ActivityType!
    @IBOutlet weak var tvActivityDesc: UITextView!
    
    
    @IBOutlet weak var tfAddressLine1: UITextField!
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnMap: UIButton!
    
    
    @IBOutlet weak var tfAddressLine2: UITextField!
    
    @IBOutlet weak var tfTown: UITextField!
    
    
    @IBOutlet weak var tfPincode: UITextField!
    
    @IBOutlet weak var tfState: UITextField!
    
    
    @IBOutlet weak var stkCustomer: UIStackView!
    @IBOutlet weak var tfCountry: UITextField!
    
    var arrActivityType:[ActivityType] = [ActivityType]()
    var arrOfSelectedSingleCustomer = [CustomerDetails]()
    
    var activityTypeDropdown:DropDown! = DropDown()
    var arrAddress:[[String:Any]] = [[String:Any]]()
    var datepicker:UIDatePicker!
    var selectedCustomer:CustomerDetails!
    var arrOfCustomers = [CustomerDetails]()
    var arrOffilteredCustomer = [CustomerDetails]()
    var customerDropdown:DropDown! = DropDown()
    var popup:CustomerSelection? = nil
    var arrAllCustomer:[NSString] = [NSString]()
    var filteredCustomer:[NSString] = [NSString]()
    let settingactive = Utils().getActiveSetting()
    let noOFCustomer = Utils.getDefaultIntValue(key: Constant.kNoOfCustomer)
    let noOfTotalCustomer = Utils.getDefaultIntValue(key:  Constant.kTotalCustomer)
    var arrOffilteredTempCustomer  = [TempcustomerDetails]()
    var selectedTempCustomer:TempcustomerDetails?
    var searchedtext = ""
    
    var activitydate:Date!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
  
    
    //MARK: - Method
    func setUI(){
        self.tfPincode.keyboardType = .numberPad
        
        btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
    self.title = "Add Activity"
    self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
    self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
    self.tfActivityType.setrightImage(img: UIImage.init(named: "icon_down_arrow_gray")!)
        self.getActivityType()
        self.tvActivityDesc.delegate = self
        self.tfActivityType.delegate = self
        self.tfDate.delegate = self
        self.tfTime.delegate = self
        self.tfAddressLine1.delegate = self
        self.tfAddressLine2.delegate = self
        self.tfTown.delegate = self
        self.tfPincode.delegate = self
        self.tfState.delegate = self
        self.tfCountry.delegate = self
        self.tfCustomer.delegate = self
        
        
        self.tfActivityType.setCommonFeature()
        self.tfDate.setCommonFeature()
        self.tfTime.setCommonFeature()
        self.tfAddressLine1.setCommonFeature()
        self.tfAddressLine2.setCommonFeature()
        self.tfTown.setCommonFeature()
        self.tfPincode.setCommonFeature()
        self.tfState.setCommonFeature()
        self.tfCountry.setCommonFeature()
        self.tfCustomer.setCommonFeature()
        
        
        if(settingactive.customerRequiredInActivity == NSNumber.init(value: 1)){
            stkCustomer.isHidden = false
        }else{
            stkCustomer.isHidden = true
        }
        
        datepicker = UIDatePicker()
        datepicker.setCommonFeature()
        datepicker.date = Date()
        datepicker.minimumDate = Date().addingTimeInterval(180)//Date()
       
        tfTime.inputView =  datepicker
        tfDate.inputView = datepicker
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfDate.text = dateFormatter.string(from: datepicker.date)
        dateFormatter.dateFormat = "hh:mm a"
        tfTime.text = dateFormatter.string(from: datepicker.date)
        Location.sharedInsatnce.startLocationManager()
        Location.sharedInsatnce.locationUpdaterDelegate = self
                
        
        tfAddressLine1.addBorders(edges: .bottom, color: UIColor.lightGray, cornerradius: 0)
        tfAddressLine2.addBorders(edges: .bottom, color: UIColor.lightGray, cornerradius: 0)
        tfDate.addBorders(edges: .bottom, color: UIColor.lightGray, cornerradius: 0)
        tfTime.addBorders(edges: .bottom, color: UIColor.lightGray, cornerradius: 0)
        tfTown.addBorders(edges: .bottom, color: UIColor.lightGray, cornerradius: 0)
        tfPincode.addBorders(edges: .bottom, color: UIColor.lightGray, cornerradius: 0)
        tfState.addBorders(edges: .bottom, color: UIColor.lightGray, cornerradius: 0)
        tfCountry.addBorders(edges: .bottom, color: UIColor.lightGray, cornerradius: 0)
        arrOfCustomers = CustomerDetails.getAllCustomers()
      //self.tfDate.inputView =
    
        arrOfCustomers = CustomerDetails.getAllCustomers()
        arrAllCustomer = arrOfCustomers.map{ $0.name } as? [NSString] ?? [NSString]()
        
        customerDropdown.anchorView = stkCustomer
        customerDropdown.direction = .any
      
//        customerDropdown.anchorView = searchCustomer
        customerDropdown.bottomOffset = CGPoint.init(x: 0, y: stkCustomer.bounds.size.height+20)
       
       // customerDropdown.bottomOffset = CGPoint.init(x: 0, y: searchCustomer.bounds.size.height+20)
        //   CGPointMake(0.0, self.btnAddress.bounds.size.height);
        customerDropdown.dataSource = filteredCustomer as [String]
        customerDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            tfCustomer.text = item
        self.arrOfSelectedSingleCustomer.removeAll()
            if(noOFCustomer > noOfTotalCustomer && arrOfCustomers.count > 0){
        self.selectedCustomer = self.arrOffilteredCustomer[index]
            self.arrOfSelectedSingleCustomer.removeAll()
            if let selectedcustomer = self.selectedCustomer{
    self.arrOfSelectedSingleCustomer.append(selectedcustomer)
            }
            }else if(arrOffilteredTempCustomer.count > 0){
                self.selectedTempCustomer = self.arrOffilteredTempCustomer[index]
                    self.arrOfSelectedSingleCustomer.removeAll()
//                    if let selectedcustomer = self.selectedTempCustomer{
//            self.arrOfSelectedSingleCustomer.append(selectedcustomer)
//                    }
            }else{
                self.selectedCustomer = self.arrOffilteredCustomer[index]
                    self.arrOfSelectedSingleCustomer.removeAll()
                    if let selectedcustomer = self.selectedCustomer{
            self.arrOfSelectedSingleCustomer.append(selectedcustomer)
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
    //MARK: - Method
    func initdropdown(){
    //    activityTypeDropdown =
            activityTypeDropdown.dataSource = arrActivityType.map({
                ($0.activityType)
            })
        activityTypeDropdown.anchorView =  tfActivityType
        tfActivityType.text =  activityTypeDropdown.dataSource.first
        self.selectedActivityType = self.arrActivityType.first
        activityTypeDropdown.bottomOffset = CGPoint.init(x: 0.0, y: tfActivityType.bounds.size.height)
        activityTypeDropdown.selectionAction = {(index,item) in
            self.tfActivityType.text = item
            self.selectedActivityType = self.arrActivityType[index]
        }
    }
    
    
    func fillupdatedatainUI(dic:[String:Any]){
        tfAddressLine1.text = dic["address1"] as? String
        tfAddressLine2.text = dic["address2"] as? String
        tfTown.text = dic["city"] as? String
        tfState.text = dic["state"] as? String
        tfCountry.text = dic["country"] as? String
        tfPincode.text = dic["postalcode"] as? String
        
    }
    
    func updateDictionaryKey(add:[String:Any])->[String:Any]{
        /*
         -(NSMutableDictionary*)updateDictionaryKeys:(NSDictionary*)address {
             
         //    NSMutableDictionary *aMutDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:address[@"latitude"],@"Lattitude",address[@"longitude"],@"Longitude",@1,@"Type",@0,@"AddressID",address[@"country"],@"Country",address[@"address1"],@"AddressLine1",address[@"address2"],@"AddressLine2",address[@"city"],@"City",address[@"state"],                                            @"State",address[@"postalcode"],@"Pincode",nil];

           //  return aMutDict;
             NSMutableDictionary *aMutDict = [[NSMutableDictionary alloc]init];
             [aMutDict setValue:[address valueForKey:@"latitude"] forKey:@"Lattitude"];
             [aMutDict setValue:[address valueForKey:@"longitude"] forKey:@"Longitude"];
             [aMutDict setValue:@1 forKey:@"Type"];
             [aMutDict setValue:[address valueForKey:@"country"] forKey:@"Country"];
             [aMutDict setValue:[address valueForKey:@"address1"] forKey:@"AddressLine1"];
             [aMutDict setValue:[address valueForKey:@"address2"] forKey:@"AddressLine2"];
             [aMutDict setValue:[address valueForKey:@"city"] forKey:@"City"];
             [aMutDict setValue:[address valueForKey:@"state"] forKey:@"State"];
             [aMutDict setValue:[address valueForKey:@"postalcode"] forKey:@"Pincode"];
             
             
             
             return aMutDict;
         }
         **/
        var dicAddress = [String:Any]()
        dicAddress["Lattitude"] = add["latitude"]
        dicAddress["Longitude"] = add["longitude"]
        dicAddress["Type"] = NSNumber.init(value: 1)
        dicAddress["Country"] = add["country"]
        dicAddress["AddressLine1"] = add["address1"]
        dicAddress["AddressLine2"] = add["address2"]
        dicAddress["City"] = add["city"]
        dicAddress["State"] = add["state"]
        dicAddress["Pincode"] = add["postalcode"]
        return dicAddress
    }
    
    func checkValidation()->Bool{
        if(tfActivityType.text?.count == 0){
            Utils.toastmsg(message:"Please Select Activity Type",view: self.view)
        return false
        }else if(tvActivityDesc.text.count == 0){
            
            Utils.toastmsg(message:"Please enter description",view: self.view)
        return false
        }else if(tfAddressLine1.text?.count == 0){
            Utils.toastmsg(message:"Please enter address line 1",view: self.view)
        return false
        }else if(tfAddressLine2.text?.count == 0){
            Utils.toastmsg(message:"Please enter address line 2",view: self.view)
        return false
        }else if(tfTown.text?.count == 0){
            Utils.toastmsg(message:"Please enter city",view: self.view)
        return false
        }else if(tfPincode.text?.count == 0){
            Utils.toastmsg(message:"Please enter pincode",view: self.view)
        return false
        }else if(tfState.text?.count == 0){
            Utils.toastmsg(message:"Please enter state",view: self.view)
        return false
        }else if(tfCountry.text?.count == 0){
            Utils.toastmsg(message:"Please enter country",view: self.view)
        return false
        }else{
            return true
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func btnSearchCustomerClicked(_ sender: UIButton) {
        
        popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection
        popup?.strTitle = ""
        popup?.arrOfSelectedSingleCustomer = arrOfSelectedSingleCustomer
        popup?.modalPresentationStyle = .overCurrentContext
        popup?.nonmandatorydelegate = self
        popup?.arrOfList = arrOfCustomers
        popup?.selectionmode = SelectionMode.none
        popup?.isFilterRequire = false
        popup?.isFromSalesOrder =  false
        popup?.strLeftTitle = "REFRESH"
        popup?.isSearchBarRequire = true
        popup?.viewfor = ViewFor.customer
        popup?.parentViewOfPopup = self.view
      
        if( CustomerDetails.getAllCustomers().count > 0 &&  noOfTotalCustomer < noOFCustomer){
            Utils.addShadow(view: self.view)
            self.present(popup!, animated: true, completion:nil)
        }
    }
    @IBAction func btnMapClicked(_ sender: UIButton) {
        
        if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
            map.isFromDashboard = false
            Common.skipVisitSelection = false
            map.isFromColdCall = false
            map.isFromVisitLeadDetail = false
            if(arrAddress.count  ==  0){
                if let currentlocation = Location.sharedInsatnce.getCurrentCoordinate(){

            map.lattitude = NSNumber.init(value:currentlocation.latitude )

            map.longitude = NSNumber.init(value:currentlocation.longitude )
                }else{
                    map.lattitude = 0.0
                    map.longitude = 0.0
                }
            }else{
                let address = arrAddress[arrAddress.count - 1]
 //          let currentlocation = Location.sharedInsatnce.getCurrentCoordinate()
//            map.lattitude = NSNumber.init(value:currentlocation.latitude)
//            map.longitude =  NSNumber.init(value:currentlocation.longitude)
            
            
         /*   let nsnumberlat = NSNumber.init(value: address.lattitude as? Double ?? 0.0)
            let nsnumberlong = NSNumber.init(value: address.longitude as? Double ?? 0.0 )
            map.lattitude = nsnumberlat
            map.longitude = nsnumberlong*/
//            map.lattitude =  NSNumber.init(value:Double(([address.lattitude] as? NSString)?.doubleValue ?? 000000))
//            map.longitude = NSNumber.init(value:Double(([address.longitude] as? NSString)?.doubleValue ?? 000000))
            
//            let doublelat = (address["Lattitude"] as? String)?.toDouble()
//            let doublelng = (address["Longitude"] as? String)?.toDouble()
            map.lattitude = address["Lattitude"] as? NSNumber
            map.longitude = address["Longitude"] as? NSNumber
            
            }
            //NSNumber.init(value:AttendanceViewController.selectedLocation?.coordinate.longitude ?? 0.00)
            map.delegate = self
            map.isFromCustomer = false
            map.isFromAddActivity =  true
            self.navigationController?.pushViewController(map, animated: true)
        }
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        /*
         contactdict["AddressLine1"] = TfAddress1.text
         contactdict["AddressLine2"] = TfAddress2.text
         contactdict["City"] = TfTown.text
         contactdict["Country"] = TfCountry.text
         contactdict["State"] = TfState.text
         contactdict["Pincode"] = TfPincode.text
         contactdict["Lattitude"] =  lblLatitude.text
         //NSNumber.init(value: Double(lblLatitude.text) ?? 0.00)
         contactdict["Longitude"] =  lblLongitude.text
         
         */
        if(self.checkValidation()){
            var dicActivity = [String:Any]()
            dicActivity["CompanyID"] = self.activeuser?.company?.iD
            dicActivity["CreatedBy"] = self.activeuser?.userID
            dicActivity["NextActionTime"] = Utils.getDate(date: datepicker.date as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")//Utils.getDateinstrwithaspectedFormat(givendate: datepicker.date, format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: true)
            dicActivity["OriginalNextActionTime"] = Utils.getDate(date: datepicker.date as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")//Utils.getDateinstrwithaspectedFormat(givendate: datepicker.date, format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: true)
            dicActivity["Description"] = tvActivityDesc.text
            dicActivity["ActivityTypeID"] = selectedActivityType.activityTypeIndex
            if let selectedcustomer = selectedCustomer{
                dicActivity["customerID"] = selectedcustomer.iD
            }else if let tempcustomer =  selectedTempCustomer{
                dicActivity["customerID"] = tempcustomer.iD
            }else{
                dicActivity["customerID"] = 0
            }
            var param = Common.returndefaultparameter()
            param["addEditActivityjson"] = Common.returnjsonstring(dic: dicActivity)
            var address1 = [String:Any]()
            address1["AddressLine1"] = tfAddressLine1.text
            address1["AddressLine2"] = tfAddressLine2.text
            address1["City"] = tfTown.text
            address1["Country"] = tfCountry.text
            address1["State"] = tfState.text
            address1["Pincode"] = tfPincode.text
            address1["Lattitude"] = self.arrAddress.first?["latitude"]
            address1["Longitude"] = self.arrAddress.first?["longitude"]
            
            self.arrAddress.insert(address1, at: 0)
         //   self.arrAddress.append(self.updateDictionaryKey(add:address1))
            param["AddressDetailsjson"] = Common.returnjsonstring(dic: self.arrAddress.first ?? [:])
            
            print("parameter of add activity = \(param)")
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddEditActivity, method: Apicallmethod.post){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                 print("Response of add activity = \(arr)")
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                    var dicOfActivity = arr as? [String:Any] ?? [String:Any]()
                    print("dic of activity  = \(dicOfActivity)")
                    var address = dicOfActivity["AddressDetails"] as? [String:Any] ?? [String:Any]()
                    let addtype = address["Type"] as? NSNumber
                    address["Type"] = addtype?.stringValue
                    print("address  = \(address)")
                    dicOfActivity["AddressDetails"] = address
                    print(" result = \(addtype) and type of it is  = \(type(of: addtype)) , dic = \(dicOfActivity)")
                    MagicalRecord.save { (localcontext) in
                                               
        FEMDeserializer.object(fromRepresentation: dicOfActivity, mapping: Activity.defaultMapping(), context: localcontext)
                                         
} completion: { (status, error) in
        print("New Activity Saved. and total activity is  = \(Activity.getAll().count)")
    ActivityList().getActivityList(isOnActivityList:false)
                                            }
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                }
            }
        }
    }
    
    // MARK: - API Call
    func getActivityType(){
        var param = Common.returndefaultparameter()
        let dicForActivityType = ["CompanyID":self.activeuser?.company?.iD]
        
        param["getActivityTypejson"] = Common.returnjsonstring(dic: dicForActivityType)
        
        self.apihelper.getdeletejoinvisit(param: param , strurl: ConstantURL.kWSUrlGetActivityType , method: Apicallmethod.get){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
               print(responseType)
            print(arr)
                let arrOfActivityType  =  arr as? [[String:Any]] ?? [[String:Any]]()
                self.arrActivityType = [ActivityType]()
                for activitype in arrOfActivityType{
                    let dicactivitytype = activitype as! [String:Any]
                    var activitytype = ""
                    if let activityType = activitype["ActivityType"] as? String{
                        activitytype = activityType
                    }
                    //activityTypeIndex
                    var activityindex = NSNumber.init(value:0)
                    if let activityIndex = activitype["ActivityTypeIndex"] as? Int{
                        activityindex =  NSNumber.init(value: activityIndex)
                    }
                    var companyid = NSNumber.init(value:0)
                    if let companyId = activitype["CompanyID"] as? Int{
                        companyid =  NSNumber.init(value: companyId)
                    }
                    var createdby = NSNumber.init(value:0)
                    if let createdBy = activitype["CreatedBy"] as? Int{
                        createdby = NSNumber.init(value: createdBy)
                    }
                    var activityID = NSNumber.init(value:0)
                    if let activityid = activitype["ID"] as? Int{
                        activityID = NSNumber.init(value:activityid)
                    }
                var activitymodel = ActivityType(activityType: activitytype, activityTypeIndex: activityindex , companyId: companyid , createdBy: createdby, activityId: activityID)
                
                    
                    self.arrActivityType.append(activitymodel)
                    
                }
                if(self.arrActivityType.count > 0){
                    let arrActivityTypeName = self.arrActivityType.map{
                        return $0.activityType
                    }
                   // self.activityTypeDropdown.dataSource =  arrActivityTypeName
                    self.initdropdown()
                    
                }
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
    }
}
extension AddActivity:GoogleMapDelegate{
    func updateAddress(dic: [String : Any]) {
        arrAddress.removeAll()
        arrAddress.append(self.updateDictionaryKey(add:dic))
        self.fillupdatedatainUI(dic: dic)
    }
    func updateAddress(dic:[String:Any],TempaddNo:NSNumber){
        
    }
}
extension AddActivity:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField == tfActivityType){
            activityTypeDropdown.show()
            return false
        }else if(textField == tfDate){
            self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            datepicker.datePickerMode = .date
            print("str next action time = \(strNextActionTime)")
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datepicker.date = dateNextActionTime ?? Date()//self.dateFormatter.date(from: tfDate.text!)!
          //  activitydate = datepicker.date
            return true
        }
        else if(textField == tfTime){
            self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            datepicker.datePickerMode = .time
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datepicker.date = dateNextActionTime ?? Date() //self.dateFormatter.date(from: tfTime.text!)!
           // activitydate = datepicker.date
            return true
        }else{
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var fullstring = ""
        if let tft = textField.text as? String{
            fullstring.append(tft)
        }
        fullstring.append(string)
      
        let trimmedstring = fullstring.trimmingCharacters(in: .whitespaces).lowercased()
     
        print("count =  \(trimmedstring.count) nd string = \(trimmedstring)")
        if (textField == tfCustomer){
            
            arrOfCustomers = CustomerDetails.getAllCustomers()
            let arrOfTempCustomers = TempcustomerDetails.getAllCustomers()
            print("No of customer = \(noOFCustomer) && all cust count = \(arrOfCustomers.count)")
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
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfDate.text =  dateFormatter.string(from: datepicker.date)
            strNextActionTime = ""
            if let strdate = tfDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfTime.text{
                strNextActionTime.append("  \(strtime)")
            }
           
            print("next action time = \(strNextActionTime) end editing ")
        
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datepicker.date = dateNextActionTime ?? Date()
            activitydate = datepicker.date
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
           
            print("next action time = \(strNextActionTime) end editing ")
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datepicker.date = dateNextActionTime ?? Date()
            activitydate = datepicker.date
        }
    }
    
}
extension AddActivity:locationUpdater{
    func updatecurrentlocation(location: CLLocation,distance:CLLocationDistance){
        if(isEdit == true){
            
        }else{
            if(isFirstTime == false){
                isFirstTime = true
                
             /*   let lastlocation = location
                let coordinate = lastlocation.coordinate
                
                LMGeocoder.sharedInstance().cancelGeocode()
                LMGeocoder.sharedInstance().reverseGeocodeCoordinate(coordinate, service: LMGeocoderServiceApple, alternativeService: LMGeocoderServiceApple) { (results, error) in
                    if((results?.count ?? 0 > 0) && (error == nil) ){
                        let address =  results?.first
                        
                        if(address?.formattedAddress?.count ?? 0 > 0){
                            print(address)
                          
                            
                            var address1 = [String:Any]()
                            var stradd1 = ""
                            if let  strno = address?.streetNumber as? String{
                                stradd1.append(strno)
                            }
                            if let  subadm = address?.subAdministrativeArea as? String{
                                stradd1.append(subadm)
                            }
                            if let adm = address?.administrativeArea as? String{
                                stradd1.append(adm)
                            }
                            if let neighbour = address?.neighborhood as? String{
                                stradd1.append(neighbour)
                            }
                            //address1["AddressLine1"] = String.init(format: "%@  , %@", address?.streetNumber ,address?.route)
                            //String.init(format:"%@ , %@", address?.streetNumber as? CVarArg,address?.route as? CVarArg)
                            address1["address1"] =  stradd1
                            address1["address2"] = address?.subLocality
                            address1["state"] = address?.administrativeArea
                            address1["country"] = address?.country
                            address1["postalcode"] = address?.postalCode
                            address1["city"] = address?.locality
                            var strlatitude = ""
                            if let strlat = address?.coordinate.latitude as? Double{
                                strlatitude = String(strlat)
                            }
                            address1["latitude"] =  strlatitude
                            var strlongitude = ""
                            if let strlong =  address?.coordinate.longitude as? Double{
                                strlongitude = String(strlong)
                            }
                            address1["longitude"] = strlongitude
                            self.arrAddress.removeAll()
                            self.arrAddress.append(self.updateDictionaryKey(add:address1))
                            self.fillupdatedatainUI(dic: address1)
                        }
                        
                    }
                    else{*/
                        self.getAddressFromCurrentLocation { (address,error) in
                            if(error.code == 0 && address.keys.count > 0){
                                self.arrAddress.removeAll()
                                self.arrAddress.append(self.updateDictionaryKey(add:address))
                                self.fillupdatedatainUI(dic: address)
                            }else{
                                Common.showalert(msg: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view:self)
                            }
                        //}
                   // }
                }
            }else if(distance > 5){
              /*  let lastlocation = location
                let coordinate = lastlocation.coordinate
                
                LMGeocoder.sharedInstance().cancelGeocode()
                LMGeocoder.sharedInstance().reverseGeocodeCoordinate(coordinate, service: LMGeocoderServiceApple, alternativeService: LMGeocoderServiceApple) { (results, error) in
                    if((results?.count ?? 0 > 0) && (error == nil) ){
                        let address =  results?.first
                        
                        if(address?.formattedAddress?.count ?? 0 > 0){
                            print(address)
                            print("formated  address = \(address?.formattedAddress) ")
                            print("address lines = \(address?.lines) , neighbourhood = \(address?.neighborhood) , raw source = \(address?.rawSource)")
                            print("route = \(address?.route) , administritative area = \(address?.administrativeArea) , sub administrative area = \(address?.subAdministrativeArea) , sublocality = \(address?.subLocality) , locality = \(address?.locality) , street number = \(address?.streetNumber)")
                            
                            var address1 = [String:Any]()
                            var stradd1 = ""
                            if let  strno = address?.streetNumber as? String{
                                stradd1.append(strno)
                            }
                            if let  subadm = address?.subAdministrativeArea as? String{
                                stradd1.append(subadm)
                            }
                            if let adm = address?.administrativeArea as? String{
                                stradd1.append(adm)
                            }
                            if let neighbour = address?.neighborhood as? String{
                                stradd1.append(neighbour)
                            }
                            //address1["AddressLine1"] = String.init(format: "%@  , %@", address?.streetNumber ,address?.route)
                            //String.init(format:"%@ , %@", address?.streetNumber as? CVarArg,address?.route as? CVarArg)
                            address1["address1"] =  stradd1
                            address1["address2"] = address?.subLocality
                            address1["state"] = address?.locality
                            address1["country"] = address?.country
                            address1["postalcode"] = address?.postalCode
                            var strlatitude = ""
                            if let strlat = address?.coordinate.latitude as? Double{
                                strlatitude = String(strlat)
                            }
                            address1["latitude"] =  strlatitude
                            var strlongitude = ""
                            if let strlong =  address?.coordinate.longitude as? Double{
                                strlongitude = String(strlong)
                            }
                            address1["longitude"] = strlongitude
                            self.arrAddress.removeAll()
                            self.arrAddress.append(self.updateDictionaryKey(add:address1))
                            self.fillupdatedatainUI(dic: address1)
                        }
                        // self.lblAddress.text =  address?.formattedAddress
                    }
                    
                    else{*/
                        self.getAddressFromCurrentLocation { (address,error) in
                            if(error.code == 0 && address.keys.count > 0){
                                self.arrAddress.removeAll()
                                self.arrAddress.append(self.updateDictionaryKey(add:address))
                                self.fillupdatedatainUI(dic: address)
                            }else{
                                Common.showalert(msg: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view:self)
                            }
                        }
                        //            self.getAddressFromCurrentLocation(address,error){
                        //                if(error.code == 0 && address.allkey.count > 0){
                        //
                        //                }else{
                        //                    common.showalert(error.localizeddescription)
                        //                }
                        //            }
                        
                 //   }
                    
              //  }
            }
        }
    }
}
extension AddActivity:UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.setFlexibleHeight()
        return true
    }
    
}
extension AddActivity:PopUpDelegateNonMandatory{
    
    
    
    func completionData(arr: [CustomerDetails]) {
        Utils.removeShadow(view: self.view)
        print(arr.count)
     
            arrOfSelectedSingleCustomer = arr
        selectedCustomer = arr.first
           // lblCustomerName.text = selectedCustomer.name
            if let selectedcustomer = self.selectedCustomer{
                selectedCustomer =  selectedcustomer
            tfCustomer.text = selectedcustomer.name
               
            
            }
    }
            
    
    }
    
   
