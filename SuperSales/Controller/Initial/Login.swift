//
//  Login.swift
//  SuperSales
//
//  Created by Apple on 19/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD



class Login: BaseViewController {
    
    
    
    var activeAccount:DataUser!
    var loader:SVProgressHUD!
    
    @IBOutlet weak var tfUserName: CustomeTextfield!
    
    @IBOutlet weak var tfPassword: CustomeTextfield!
    
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //    required init(){
    //        super.init(coder: )
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        activeAccount =   Utils().getActiveAccount()
        
        
        //set loader
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SVProgressHUD.dismiss()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tfPassword.isSecureTextEntry = true
        self.setUI()
        if let navigation = self.navigationController{
            navigation.isNavigationBarHidden = true
        }else{
            Login().logout()
        }
    }
    func setUI(){
        self.tfUserName.setleftImage(img: UIImage.init(named: "icon_user")!)
        self.tfPassword.setleftImage(img: UIImage.init(named: "icon_password")!)
        self.tfUserName.setBottomBorder(tf: self.tfUserName, color: UIColor.black)
        self.tfPassword.setBottomBorder(tf: self.tfPassword, color: UIColor.black)
        self.tfUserName.textCustompadding = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.tfPassword.textCustompadding = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.btnSubmit.setbtnFor(title: "Sign In", type: Constant.kPositive)
        self.btnSignUp.setbtnFor(title: "Sign Up", type: Constant.kNutral)
        
        
        let attributedPlaceholderU = NSAttributedString.init(string: "Mobile Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor().colorFromHexCode(rgbValue: 0x7FA5B3)])
        self.tfUserName.attributedPlaceholder =  attributedPlaceholderU
        let attributedPlaceholderPassword = NSAttributedString.init(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor().colorFromHexCode(rgbValue: 0x7FA5B3)])
        self.tfPassword.attributedPlaceholder =  attributedPlaceholderPassword
        
        let contactno = NSAttributedString.init(string: "Forgot Password?" ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.Appskybluecolor , NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue])
        
        self.btnForgotPassword.setAttributedTitle(contactno, for: UIControl.State.normal)
        
        
        //        let yourAttributes: [String: Any] = [
        //            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
        //            NSAttributedString.Key.foregroundColor: UIColor.white,
        //            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
        //        ] // .styleDouble.rawValue, .styleThick.rawValue, .styleNone.rawValue
        let attributedtitle = NSAttributedString.init(string: "Forgot Password", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                                              NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                                                              NSAttributedString.Key.underlineStyle: 1, NSAttributedString.Key.underlineColor: UIColor.lightGray])
        
        self.btnForgotPassword.setAttributedTitle(attributedtitle, for: .normal)
        
        
    }
    
    func setDashboard(){
        
        
        
        
    }
    func getShiftTiming(user:DataUser?) {
        
        var param = [String: Any]()
        param["TokenID"] = user?.securityToken
        param["UserID"] = user?.userID
        param["CompanyID"] = user?.company?.iD
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        RestAPIManager.httpRequest(ConstantURL.getUserTimingInfo, .get, parameters: param, isTeamWorkUrl: true, isFull: false,isMappFromModel: true) { [self] response, success, error in
            SVProgressHUD.dismiss()
            if let res = response as? ShiftTiming {
                let userdefault = UserDefaults.standard
                userdefault.setValue(res.shiftID, forKey: Constant.kUserShiftTiming)
                userdefault.synchronize()
                
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        //        let ftcellconfig = FTCellConfiguration.init()
        //        ftcellconfig.textColor = UIColor.black
        //        let ftconfig = FTConfiguration.shared
        //
        //        ftconfig.backgoundTintColor =  UIColor.white
        //
        //        FTPopOverMenu.showForSender(sender: sender, with: ["one","two","three"], menuImageArray: [] , cellConfigurationArray: [ftcellconfig,ftcellconfig,ftcellconfig], done: { (i) in
        //            print(i)
        //        }, cancel: {
        //             print("cancel tapped")
        //        })
        
        
        //Account().authincateUser()
        if(validate()){
            SVProgressHUD.show(withStatus: "log in")
            let appversionforstring = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            let versionBuildString = String.init(format: "%@", appversionforstring as? CVarArg ?? "34")
            
            let language = NSLocale.preferredLanguages.first
            var param:[String:Any] = ["MobileNo":tfUserName.text!,
                                      "Password":tfPassword.text!,
                                      "Application":ConstantURL.ApplicationTeamwork,
                                      "WebLogin":"F",
                                      "DeviceName":String.init(format: "%@+%@", UIDevice.current.name,UIDevice.current.systemVersion),
                                      "Language":
                                        language?.replacingOccurrences(of: "-", with: "_")
                                      as Any,
                                      "Version":versionBuildString,
                                      "DeviceID":"740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad",
                                      "GcmID":"740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad"]
            let appDel: AppDelegate = UIApplication.shared.delegate
            as? AppDelegate ?? AppDelegate()
            
            if(appDel.deviceTokeninApp?.count ?? 0 > 0){
                if let token = appDel.deviceTokeninApp{
                    param["DeviceID"] =  token as Any
                    param["GcmID"] = token as Any
                }
            }else{
                //
                param["DeviceID"] =  "740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad"
                param["GcmID"] =  "740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad"
            }
            //   print("parameter of log in  = \(param)")
            apicall(url: ConstantURL.kWSUrlLogin, param: param, method:Apicallmethod.post, completion:  {(totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                if(error.code == 0){
                    // print("response of  log in  = \(dic)")
                    self.tfUserName.resignFirstResponder()
                    self.tfPassword.resignFirstResponder()
                    SVProgressHUD.dismiss()
                    if let topController = UIApplication.shared.keyWindow?.rootViewController {
                        topController.view.makeToast(message)
                        
                        
                        // topController should now be your topmost view controller
                    }
                    // UIApplication.shared.windows.first?.inputViewController?.view.makeToast(message)
                    //   if ( message.count > 0 ) {
                    //                     Utils.toastmsg(message:message,view: self.view)
                    //                }
                    //
                    
                    
                    Utils.setDefultvalue(key: Constant.kIsSyncDone, value: false)
                    //        defaults_set_object(@"LastSynchTime",[Utils getDate:[NSDate date] andFormat:@"yyyy/MM/dd HH:mm:ss"]);
                    Utils.setDefultvalue(key: Constant.kSyncTime, value: Utils.getDateWithAppendingDay(day: 0, date: Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true))
                    
                    if ( message.count > 0 ) {
                        Utils.toastmsg(message:message,view: self.view)
                    }
                    let dicresponse = arr as? [String:Any] ?? [String:Any]()
                    let user = DataUser.init(dictionary: dicresponse)
                    DataUser.sharedInstance.activeUser = DataUser.init(dictionary: dicresponse)
                    
                    self.getShiftTiming(user: user)
                    let defaultuser = UserDefaults.standard
                    
                    defaultuser.setValue(arr, forKey: Constant.kCurrentUser)
                    defaultuser.synchronize()
                    
                    if(user.userID == 0){
                        
                    }else{
                        //  UserDefaults.standard.set(true, forKey: "LOGGED_IN")
                        let syncvc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: "syncvc")
                        Sync.isFromDashboard = false
                        if let navigation =  self.navigationController{
                            navigation.pushViewController(syncvc, animated: true)
                        }else{
                            AppDelegate.shared.rootViewController.switchToMainScreen()
//                            let new  = UINavigationController(rootViewController: self)
//                            new.pushViewController(syncvc, animated: true)
                        }
                        //   self.setDashboard()
                    }
                }else{
                    self.tfUserName.resignFirstResponder()
                    self.tfPassword.resignFirstResponder()
                    SVProgressHUD.dismiss()
                    //Common.showalert(msg: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription)
                    Utils.toastmsg(message:error.userInfo["localiseddescription"]  as? String ?? "",view:self.view)
                }
            })
            
            
        }
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: UIButton) {
        let resetpasswordvw = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.ResetPassword)
        self.navigationController?.pushViewController(resetpasswordvw, animated: true)
    }
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        
    }
    func validate()->Bool{
        if(tfUserName.text?.count == 0){
            Common.showalert(msg: "Please Enter User name",view:self)
            return false
        }else if(tfPassword.text?.count == 0){
            Common.showalert(msg: "Please Enter Password",view:self)
            return false
        }else{
            return true
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
    func logout(){
        
        
        //                   if let menuview  =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: "menuviewcontroller") as? MenuViewController{
        //                       print("sub views  = \(menuview.view.subviews)")
        if((UIApplication.shared.keyWindow?.subviews.contains(BaseViewController.menuview.view)) != nil){
            BaseViewController.menuview.view.removeFromSuperview()
            BaseViewController.menuview.removeFromParent()
        }else{
            print("not containing slider , \(UIApplication.shared.keyWindow?.topMostController())")
        }
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        //    menuview.sidemenudelegate? = self
        
        //   if let baseview = fromview as? BaseViewController{
        //            let baseviewcontrollerobj = BaseViewController()
        //        //if let menuview = baseview.menuview as? MenuViewController{
        //           if let menuview = baseviewcontrollerobj.menuview as? MenuViewController{
        //            if(baseviewcontrollerobj.children.contains(menuview)){
        //                    UIView.animate(withDuration: 0.3, animations:
        //                        { () -> Void in
        //                            baseviewcontrollerobj.menuview.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width/2.5,height: UIScreen.main.bounds.size.height)
        //                            baseviewcontrollerobj.view.layoutIfNeeded()
        //                           baseviewcontrollerobj.view.backgroundColor = UIColor.clear
        //                            BaseViewController.blurEffectView.removeFromSuperview();
        //                            BaseViewController.blurEffectView.removeFromSuperview()
        //                    },completion:
        //                        {   (finished) -> Void in
        //
        //                            baseviewcontrollerobj.menuview.view.removeFromSuperview() //@ need to check
        //                            baseviewcontrollerobj.menuview.removeFromParent()
        //
        //                    })
        //                }
        //            }
        //                else{
        //
        //                }
        
        
        let userdefault = UserDefaults.standard
        userdefault.setValue([:], forKey: Constant.kUserSetting)
        userdefault.setValue([:], forKey: Constant.kCurrentUser)
        userdefault.setValue([:], forKey: Constant.kUserShiftTiming)
        userdefault.synchronize()
        //Clearing static data
        // Location.currentLocationcoordinate = optional
        AddParticipant.arrOfParticipant = [participant]()
        Reports.selectedDate = ""
        AddEditSalesOrderVC.productDriveIDSInNumber = [NSNumber]()
        BaseViewController.staticlowerUser = [CompanyUsers]()
        // BaseViewController.staticlower
        ActivityList.arrActivity = [Activity]()
        // self.navigationController?.popToRootViewController(animated: true)
        // self.setScreen()
        MagicalRecord.save({ (localcontext) in
            AddressList.mr_truncateAll(in:localcontext)
            
            CompanyMenus.mr_truncateAll(in:localcontext)
            MenuTabs.mr_truncateAll(in: localcontext)
            CustomerSegment.mr_truncateAll(in: localcontext)
            POrder.mr_truncateAll(in: localcontext)
            SOrder.mr_truncateAll(in: localcontext)
            //      [_Company MR_truncateAllInContext:localContext];
            //      [_DefaultSetting MR_truncateAllInContext:localContext];
            Proposl.mr_truncateAll(in: localcontext)
            Vendor.mr_truncateAll(in: localcontext)
            Lead.mr_truncateAll(in: localcontext)
            Contact.mr_truncateAll(in: localcontext)
            ProductSubCat.mr_truncateAll(in: localcontext)
            CustomerDetails.mr_truncateAll(in: localcontext)
            PlannVisit.mr_truncateAll(in: localcontext)
            VisitOutcomes.mr_truncateAll(in: localcontext)
            LeadSource.mr_truncateAll(in: localcontext)
            Outcomes.mr_truncateAll(in: localcontext)
            CompanyUsers.mr_truncateAll(in: localcontext)
            AttendanceHistory.mr_truncateAll(in: localcontext)
            AttendanceUserHistory.mr_truncateAll(in: localcontext)
            Territory.mr_truncateAll(in: localcontext)
            
            
            
            
        }) { (status, error) in
            //      UserDefaults.standard.set(false, forKey: "LOGGED_IN")
            //            let loginViewController = LoginViewController()
            
            SVProgressHUD.dismiss()
            let userdefault = UserDefaults.standard
            userdefault.setValue(false, forKey:Constant.kIsSyncDone)
            userdefault.setValue([String:Any](),forKey: Constant.kUserDefault)
            userdefault.synchronize()
            AppDelegate.shared.rootViewController.switchToLogout()
            
            //             print("Logout Successfully")
            
            
        }
    }
    
}
