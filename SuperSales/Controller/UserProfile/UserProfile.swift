//
//  UserProfile.swift
//  SuperSales
//
//  Created by Apple on 26/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation



class UserProfile: BaseViewController {
    
    @IBOutlet weak var imgUserPic: UIImageView!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var btnYourManager: UIButton!
    
    @IBOutlet weak var tfFirstName: UITextField!
    
    @IBOutlet weak var tfLastName: UITextField!
    
    @IBOutlet weak var tfMobileNo: UITextField!
    
    @IBOutlet var tfEmail: UITextField!
    
    @IBOutlet var lblEmployeeCode: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    
    @IBOutlet weak var vwPerAddTitle: UIView!
    @IBOutlet weak var vwTempTitle: UIView!
    
    // permenent address
    @IBOutlet weak var tfAddressLine1: UITextField!
    
    @IBOutlet weak var tfAddressLine2: UITextField!
    
    // @IBOutlet weak var tfTown: UITextField!
    
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfPincode: UITextField!
    //tfCountry
    @IBOutlet weak var tfLattitude: UITextField!
    @IBOutlet weak var tfLongitude: UITextField!
    @IBOutlet weak var tfCountry: UITextField!
    
    
    // Temperory address
    @IBOutlet weak var tfTempAddressLine1: UITextField!
    
    @IBOutlet weak var tfTempAddressLine2: UITextField!
    
    @IBOutlet weak var tfTempCity: UITextField!
    
    
    @IBOutlet weak var tfTempState: UITextField!
    
    @IBOutlet weak var tfTempPincode: UITextField!
    
    @IBOutlet weak var tfTempCountry: UITextField!
    
    @IBOutlet weak var tfTempLattitude: UITextField!
    
    @IBOutlet weak var tfTempLongitude: UITextField!
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    var strLat:CLLocationDegrees!
    var strLong:CLLocationDegrees!
    var address:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        SVProgressHUD.dismiss()
    }
    
    
    // MARK: - Method
    func setUI(){
        self.title = "User Profile"
        //set text color
        tfFirstName.setCommonFeature()
        tfLastName.setCommonFeature()
        tfCity.setCommonFeature()
        tfEmail.setCommonFeature()
        tfMobileNo.setCommonFeature()
        tfState.setCommonFeature()
        tfAddressLine1.setCommonFeature()
        tfCountry.setCommonFeature()
        tfAddressLine2.setCommonFeature()
        tfLattitude.setCommonFeature()
        tfLongitude.setCommonFeature()
       
        tfTempPincode.setCommonFeature()
        tfTempCity.setCommonFeature()
        tfTempState.setCommonFeature()
       
        tfTempLattitude.setCommonFeature()
        tfTempLongitude.setCommonFeature()
        tfTempCountry.setCommonFeature()
        tfTempAddressLine1.setCommonFeature()
        tfTempAddressLine2.setCommonFeature()
        
        
        
        
            tfFirstName.textColor = BaseViewController.blackuniversalcolor
            tfLastName.textColor = BaseViewController.blackuniversalcolor
            tfCity.textColor = BaseViewController.blackuniversalcolor
            tfEmail.textColor = BaseViewController.blackuniversalcolor
            tfMobileNo.textColor = BaseViewController.blackuniversalcolor
            tfState.textColor = BaseViewController.blackuniversalcolor
            tfAddressLine1.textColor = BaseViewController.blackuniversalcolor
            tfCountry.textColor = BaseViewController.blackuniversalcolor
            tfAddressLine2.textColor = BaseViewController.blackuniversalcolor
            tfLattitude.textColor = BaseViewController.blackuniversalcolor
            tfLongitude.textColor = BaseViewController.blackuniversalcolor
           
            tfTempPincode.textColor = BaseViewController.blackuniversalcolor
            tfTempCity.textColor = BaseViewController.blackuniversalcolor
            tfTempState.textColor = BaseViewController.blackuniversalcolor
           
            tfTempLattitude.textColor = BaseViewController.blackuniversalcolor
            tfTempLongitude.textColor = BaseViewController.blackuniversalcolor
            tfTempCountry.textColor = BaseViewController.blackuniversalcolor
            tfTempAddressLine1.textColor = BaseViewController.blackuniversalcolor
            tfTempAddressLine2.textColor = BaseViewController.blackuniversalcolor
            
        lblEmployeeCode.textColor = BaseViewController.blackuniversalcolor
            
        
        SVProgressHUD.setDefaultMaskType(.black)
        
        self.vwTempTitle.backgroundColor = UIColor.Appskybluecolor
        self.vwPerAddTitle.backgroundColor = UIColor.Appskybluecolor
        
        //set borders
        self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        self.tfFirstName.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfLattitude.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfLastName.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfEmail.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfMobileNo.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfEmail.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfTempLongitude.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfAddressLine1.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfAddressLine2.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfCountry.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfCity.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfState.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfPincode.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfLongitude.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfTempCity.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfTempState.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfTempAddressLine1.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfTempAddressLine2.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfTempCountry.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfTempLattitude.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        self.tfTempPincode.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        
        imgUser.backgroundColor = UIColor.clear
        imgUser.layer.borderColor = UIColor.white.cgColor
        imgUser.layer.borderWidth = 2.0
        if(self.activeuser?.picture?.count ?? 0  > 0){
            imgUser.sd_setImage(with: URL.init(string: self.activeuser?.picture ?? ""), placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                print("image downloaded")
            }
        }else{
            
            self.imgUser.image = UIImage.init(named: "icon_placeholder_user")
        }
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        if(self.activeuser?.role?.id == NSNumber.init(value:5)){
            
            btnYourManager.isHidden = true
        }
        lblPosition.text =  self.activeuser?.role?.desc
        tfFirstName.text = self.activeuser?.firstName
        tfLastName.text = self.activeuser?.lastName
        tfMobileNo.text =  self.activeuser?.mobileNo1
        imgUser.layer.masksToBounds = true
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2.0
        tfEmail.text =  self.activeuser?.emailID
        lblEmployeeCode.text = String.init(format:"%@ %@","Employee Code:",self.activeuser?.employeeCode ?? "")
        
        /*
         tfAddressLine1.text = dic["address1"] as? String
         tfAddressLine2.text = dic["address2"] as? String
         tfCity.text = dic["city"] as? String
         tfState.text = dic["state"] as? String
         tfCountry.text = dic["country"] as? String
         tfPincode.text = dic["postalcode"] as? String
         tfLattitude.text = String(self.strLat)
         tfLongitude.text = String(self.strLong)
         **/
        
        if let permenentaddress = self.activeuser?.permanentAddress as? AddressInfo {
            tfAddressLine1.text = permenentaddress.addressLine1
            tfAddressLine2.text =  permenentaddress.addressLine2
            tfCity.text = permenentaddress.city
            tfState.text = permenentaddress.state
            tfCountry.text = permenentaddress.country
            tfPincode.text = permenentaddress.pincode
            tfLattitude.text = permenentaddress.lat//String(self.strLat)
            tfLongitude.text = permenentaddress.lng//String(self.strLong)
        }
        if let tempAddress = self.activeuser?.temporaryAddress as? TemporaryAddres{
            // tfTempAddressLine1.text = //tempAddress.addressID
            tfTempAddressLine1.text =  tempAddress.addressLine1
            tfTempAddressLine2.text =  tempAddress.addressLine2
            tfTempCity.text = tempAddress.city
            tfTempState.text = tempAddress.state
            tfTempCountry.text =  tempAddress.country
            tfTempPincode.text =  tempAddress.pincode
            tfTempLattitude.text =  tempAddress.lattitude
            tfTempLongitude.text =  tempAddress.longitude
            self.strLat = tempAddress.lattitude?.toDouble() as? CLLocationDegrees
            self.strLong =  tempAddress.longitude?.toDouble() as? CLLocationDegrees
        }
    }
    func fillupdatedatainUI(dic:[String:Any]){
        
        
        if(dic.keys.count > 0){
            self.strLat = dic["latitude"] as? CLLocationDegrees ?? 0.0000
            self.strLong = dic["longitude"] as? CLLocationDegrees ?? 0.0000
            
            
            //        custAddDic["Country"] = dic["country"]
            //        custAddDic["State"] = dic["state"]
            //        custAddDic["Type"] = NSNumber.init(value: 1)
            
            
            tfAddressLine1.text = dic["address1"] as? String
            tfAddressLine2.text = dic["address2"] as? String
            tfCity.text = dic["city"] as? String
            tfState.text = dic["state"] as? String
            tfCountry.text = dic["country"] as? String
            tfPincode.text = dic["postalcode"] as? String
            tfLattitude.text = String(self.strLat)
            tfLongitude.text = String(self.strLong)
            
        }
        
    }
    func checkTempAdd(){
        
        if(tfTempAddressLine1.text?.count ==  0 && tfTempAddressLine2.text?.count == 0 && tfTempCity.text?.count == 0 && tfTempState.text?.count == 0 && tfTempCountry.text?.count == 0){
            
            
        }else{
            
            if(tfTempAddressLine1.text?.count == 0){
                tfTempAddressLine1.becomeFirstResponder()
                Utils.toastmsg(message:"Enter addressline1",view: self.view)
                return
            }else if(tfTempAddressLine2.text?.count == 0){
                tfTempAddressLine2.becomeFirstResponder()
                Utils.toastmsg(message:"Enter addressline2",view: self.view)
                return
            }else if(tfTempCity.text?.count == 0){
                tfTempCity.becomeFirstResponder()
                Utils.toastmsg(message:"Enter City",view: self.view)
                return
            }else if(tfTempState.text?.count == 0){
                tfTempState.becomeFirstResponder()
                Utils.toastmsg(message:"Enter State",view: self.view)
                return
            }else if(tfTempCountry.text?.count == 0){
                tfTempCountry.becomeFirstResponder()
                Utils.toastmsg(message:"Enter Coutry",view: self.view)
                return
            }
            
        }
        
    }
    func fillupdatedatainTempUI(dic:[String:Any]){
        
        
        if(dic.keys.count > 0){
            self.strLat = dic["latitude"] as? CLLocationDegrees ?? 0.0000
            self.strLong = dic["longitude"] as? CLLocationDegrees ?? 0.0000
            
            
            //        custAddDic["Country"] = dic["country"]
            //        custAddDic["State"] = dic["state"]
            //        custAddDic["Type"] = NSNumber.init(value: 1)
            
            
            tfTempAddressLine1.text = dic["address1"] as? String
            tfTempAddressLine2.text = dic["address2"] as? String
            tfTempCity.text = dic["city"] as? String
            tfTempState.text = dic["state"] as? String
            tfTempCountry.text = dic["country"] as? String
            tfTempPincode.text = dic["postalcode"] as? String
            tfTempLattitude.text = String(self.strLat)  //as? String ?? "0.0000"
            tfTempLongitude.text =  String(self.strLong)   // as? String  ?? "0.0000"
            
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
    
    //MARK: - IBAction
    
    @IBAction func permenentAddMapClicked(_ sender: UIButton) {
        address = 0
        if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
            map.isFromDashboard = false
            Common.skipVisitSelection = false
            map.isFromColdCall = false
            map.isFromVisitLeadDetail = false
            if let currentlocation = Location.sharedInsatnce.getCurrentCoordinate(){
            
            map.lattitude = NSNumber.init(value:currentlocation.latitude ?? 0.0000)
            
            map.longitude = NSNumber.init(value:currentlocation.longitude ?? 0.0000)
            }//NSNumber.init(value:AttendanceViewController.selectedLocation?.coordinate.longitude ?? 0.00)
            map.delegate = self
            map.isFromCustomer = true
            self.navigationController?.pushViewController(map, animated: true)
        }
    }
    
    
    
    @IBAction func tempAddMapClicked(_ sender: UIButton) {
        address = 1
        
        if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
            map.isFromDashboard = false
            Common.skipVisitSelection = false
            map.isFromColdCall = false
            map.isFromVisitLeadDetail = false
            //           let currentlocation = Location.sharedInsatnce.getCurrentCoordinate()
            //
            //            map.lattitude = NSNumber.init(value:currentlocation.latitude ?? 0.0000)
            //
            //            map.longitude = NSNumber.init(value:currentlocation.longitude ?? 0.0000)  //NSNumber.init(value:AttendanceViewController.selectedLocation?.coordinate.longitude ?? 0.00)
            map.lattitude = NSNumber.init(value:self.strLat) as? NSNumber ?? NSNumber.init(value: 0)
            map.longitude = NSNumber.init(value:self.strLong) as? NSNumber ?? NSNumber.init(value: 0)
            map.delegate = self
            map.isFromCustomer = true
            self.navigationController?.pushViewController(map, animated: true)
        }
    }
    
    
    @IBAction func btnYourManagerClicked(_ sender: UIButton) {
        if let yourmanagersobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.YourManagers) as? YourManagers{
           
            self.navigationController?.pushViewController(yourmanagersobj, animated: true)
        }
    }
    @IBAction func btnChangePasswordClicked(_ sender: UIButton) {
        if let changepassword = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.ChangePassword) as? ChangePasswordView{
            changepassword.parentviewForpopup =  self.view
            Utils.addShadow(view: self.view)
            changepassword.modalPresentationStyle = .overCurrentContext
            changepassword.view.center = self.view.center
            self.present(changepassword, animated: true) {
                
            }
        }
    }
    
    @IBAction func btnChangeMobileClicked(_ sender: UIButton) {
        let changemobilevw = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.ChangeMobile)
        self.navigationController?.pushViewController(changemobilevw, animated: true)
        
    }
    @IBAction func btnLogoutClicked(_ sender: UIButton) {
      
        Common.showalert(title: "Supersales", msg: "Are you sure you want to Logout ?", yesAction: UIAlertAction.init(title: "YES", style: UIAlertAction.Style.destructive, handler: { (action) in
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            //
          
            let param = Common.returndefaultparameter()
            

            RestAPIManager.httpRequest(ConstantURL.kWSRESTUrlLogout, .post, parameters: param, isTeamWorkUrl: false) { (response, sucess, error) in
                SVProgressHUD.dismiss()
                var message = ""
                if let result = response as? [String: Any]{
                    message = result["message"] as? String ?? ""
                }
                if(sucess){
                if let result = response as? [String: Any]{
                if ( message.count > 0 ) {
                 Utils.toastmsg(message:message,view: self.view)
                }
                    Login().logout()
                }else{
                    Login().logout()
                    Utils.toastmsg(message:"Logout Success",view: self.view)
                }
                    
                }else{
                    SVProgressHUD.dismiss()
                        if (message.count > 0 ) {
                            if(message.localizedLowercase == "invalid token"){
                                Login().logout()
                            }
                     Utils.toastmsg(message:message,view: self.view)
              
                        }else if(error?.localizedDescription.count ?? 0 > 0){
                            if(error?.localizedDescription.localizedLowercase == "invalid token"){
                                Login().logout()
                            }
                            Utils.toastmsg(message:error?.localizedDescription ?? "" ,view: self.view)
                        }
                }
            }
        }),
        noAction: UIAlertAction.init(title: "NO", style: UIAlertAction.Style.default, handler: nil),
        view: self)
        
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if(tfMobileNo.text?.count ?? 0 > 0 && tfMobileNo.text?.count ?? 0 < 6){
            Utils.toastmsg(message:"invalid mobile number",view: self.view)
            tfMobileNo.becomeFirstResponder()
            return
        }else if(tfAddressLine1.text?.count == 0){
            Utils.toastmsg(message:"Enter Address Line 1",view: self.view)
            tfAddressLine1.becomeFirstResponder()
            return
        }else if(tfAddressLine2.text?.count == 0){
            Utils.toastmsg(message:"Enter Address Line 2",view: self.view)
            tfAddressLine2.becomeFirstResponder()
            return
        }else if(tfCity.text?.count == 0){
            Utils.toastmsg(message:"Enter City",view: self.view)
            tfCity.becomeFirstResponder()
            return
        }else if(tfState.text?.count == 0){
            Utils.toastmsg(message:"Enter State",view: self.view)
            tfState.becomeFirstResponder()
            return
        }else if(tfCountry.text?.count == 0){
            Utils.toastmsg(message:"Enter Country",view: self.view)
            tfCountry.becomeFirstResponder()
            return
        }else{
            self.checkTempAdd()
            SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            param["Email"] = self.tfEmail.text
            param["FirstName"] = self.tfFirstName.text?.escapeUnicodeString()
            param["LastName"] = self.tfLastName.text?.escapeUnicodeString()
            param["Mobile2"] = self.tfMobileNo.text?.escapeUnicodeString()
            let perAddDic = ["State":tfState.text,"Longitude":tfLongitude.text,"Pincode":tfPincode.text?.escapeUnicodeString(),"Country":tfCountry.text?.escapeUnicodeString(),"Lattitude":tfLattitude.text,"AddressLine1":tfAddressLine1.text?.escapeUnicodeString(),"AddressLine2":tfAddressLine2.text?.escapeUnicodeString(),"City":tfCity.text?.escapeUnicodeString()]
            param["PermAdd"] = Common.returnjsonstring(dic: perAddDic as [String : Any])
            param["EmployeeCode"] = self.activeuser?.employeeCode ?? "" //""//lblEmployeeCode.text
            if(tfTempAddressLine1.text?.count ?? 0 > 0){
                let pertempAddDic = ["State":tfTempState.text,"Longitude":tfTempLongitude.text,"Pincode":tfTempPincode.text?.escapeUnicodeString(),"Country":tfTempCountry.text?.escapeUnicodeString(),"Lattitude":tfTempLattitude.text,"AddressLine1":tfTempAddressLine1.text?.escapeUnicodeString(),"AddressLine2":tfTempAddressLine2.text?.escapeUnicodeString(),"City":tfTempCity.text?.escapeUnicodeString()]
                param["TempAdd"] = Common.returnjsonstring(dic: pertempAddDic as [String : Any])
            }
           print("parameter of user profile update =\(param)")
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlUpdateUser, method: Apicallmethod.post){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                   
                    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                
                    ApiHelper().getUser { _ in
                        print("get user information ")
                    }
                  /*  print("parameter of updateUserFromApp profile update =\(param)")
                    apicall(url: ConstantURL.kWSUpdateUserDetail , param: param, method: Apicallmethod.post) {
                        (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                        if(error.code == 0){
                            print(arr)
                            let dic = arr as? [String:Any] ?? [String:Any]()
                            let activieaccount = Utils().getActiveAccount()
                            let securityToken = activieaccount?.securityToken
                            //self.isSettingChanged = false
                            let user = DataUser.init(dictionary: dic)
                            user.securityToken = securityToken
                            Utils.setDefultvalue(key: Constant.kCurrentUser, value: user.toDictionary())
                            DataUser.sharedInstance.activeUser = DataUser.init(dictionary: dic)
                            
                            
                                                let defaultuser = UserDefaults.standard
                            
                                                defaultuser.setValue(dic, forKey: Constant.kCurrentUser)
                                                defaultuser.synchronize()
                                                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                            /*
                             
                             isSettingChanged = NO;
                             NSLog(@"response of user data = %@",request.responseData);
                             Account *account = [Utils getActiveAccount];
                             NSString *strSecuritiyToken = account.securityToken;
                             Account *accountFromNotification = [[Account alloc]initialiseData: request.responseData[@"data"][@"User"]];
                             accountFromNotification.securityToken =  strSecuritiyToken;
                           //  account.DicBranchAddress =request.responseData[@"data"][@"User"][@"branchAddress"];
                         
                             [AccountManager Instance].activeAccount = accountFromNotification;
                             NSLog(@"active account is %@",[[Utils getActiveAccount]DicBranchAddress]);
                             */
                            
                            
                        }else{
                           // completion((totalpages,pagesavailable,lastsynctime,[[:]],status,error.localizedRecoverySuggestion ?? "",error: error,ResponseType.none))
                        }*/
//                    let dicresp = arr as? [String:Any] ?? [String:Any]()
//                    let activieaccount = Utils().getActiveAccount()
//                    let securityToken = activieaccount?.securityToken
//                   // self.isSettingChanged = false
//                    let user = DataUser.init(dictionary: dicresp)
//             //       print("address = \(user.permanentAddress?.addressLine1)")
//                    user.securityToken = securityToken
//                    Utils.setDefultvalue(key: Constant.kCurrentUser, value: user.toDictionary())
//
//
//                    DataUser.sharedInstance.activeUser = DataUser.init(dictionary: dicresp)
//
//
//                    let defaultuser = UserDefaults.standard
//
//                    defaultuser.setValue(dicresp, forKey: Constant.kCurrentUser)
//                    defaultuser.synchronize()
                    
                    }
                else{
                    if(message.count > 0){
                        if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                    }else if let strerr = error.userInfo["localiseddescription"] as? String{
                        if(strerr.count > 0){
                            Utils.toastmsg(message:strerr,view: self.view)
                        }else{
                            Utils.toastmsg(message:error.localizedDescription,view: self.view)
                        }
                    }
                }
            }
        }
    }
    
}
extension UserProfile:GoogleMapDelegate{
    func updateAddress(dic: [String : Any]) {
        if(address == 0){
            self.fillupdatedatainUI(dic: dic)
        }else if(address == 1){
            self.fillupdatedatainTempUI(dic: dic)
        }
    }
    func updateAddress(dic:[String:Any],TempaddNo:NSNumber){
        
    }
}
