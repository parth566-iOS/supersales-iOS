//
//  Common.swift
//  SuperSales
//
//  Created by Apple on 26/11/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import Alamofire
//import SVProgressHUD
typealias ImageDownloadCompeletionHandler = (UIImage)->()
class Common: UIViewController {
    
    static var skipVisitSelection =  false
    
    
    //#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    
    public  func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    //   var apimethodvar = Apicallmethod.get
    
    // var hud:SVProgressHUD = SVProgressHUD.init()
    class func nullToNil(value : Any?) -> Any? {
        if value is NSNull {
            if(type(of: value) == String.self){
                return ""
            }else if (type(of: value) ==  Int.self){
                return 0
            }else if(type(of: value) == [String:Any].self){
                return [[String:Any]]()
            }else{
                return [[[String:Any]]()]
            }
        } else {
            return value
        }
    }
    
    // MARK: - Useful Methods
    
    class func setTitleOfView(color:UIColor,viewController:UIViewController)->(){
        viewController.navigationController?.navigationBar.tintColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)    //UIColor.clear
        viewController.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255.0, green: 144/255.0, blue: 247/255.0, alpha: 1.0)
        viewController.navigationController?.navigationBar.titleTextAttributes =               [NSAttributedString.Key.foregroundColor : color]
    }
    
    class func showalert(msg:String,view:UIViewController)->(){
        let alert = UIAlertController.init(title: ConstantURL.Appname, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler:nil)
        alert.addAction(okAction)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.alert
        window.makeKeyAndVisible()
        if(self.SYSTEM_VERSION_GREATER_THAN(version:"12")){
            view.present(alert, animated: true, completion: nil)
            // let window = UIWindow.init()
            //    window.rootViewController = UIViewController()
            //            self.window.windowLevel = UIWindow.Level.alert + 1
            //            self.window.rootViewController?.present(alert, animated: true, completion: nil)
        }else{
            window.rootViewController?.present(alert, animated: false, completion: nil)
        }
        
    }
    class func showalert(title:String,msg:String,view:UIViewController)->(){
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler:nil)
        alert.addAction(okAction)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.alert
        window.makeKeyAndVisible()
        if(self.SYSTEM_VERSION_GREATER_THAN(version:"12")){
            view.present(alert, animated: true, completion: nil)
            // let window = UIWindow.init()
            //    window.rootViewController = UIViewController()
            //            self.window.windowLevel = UIWindow.Level.alert + 1
            //            self.window.rootViewController?.present(alert, animated: true, completion: nil)
        }else{
            window.rootViewController?.present(alert, animated: false, completion: nil)
        }
    }
    
    class func showalert(title:String,msg:String,yesAction:UIAlertAction,noAction:UIAlertAction,view:UIViewController)->(){
        
        
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.alert
        window.makeKeyAndVisible()
        if(self.SYSTEM_VERSION_GREATER_THAN(version:"12")){
            view.present(alert, animated: true, completion: nil)
            // let window = UIWindow.init()
            //    window.rootViewController = UIViewController()
            //            self.window.windowLevel = UIWindow.Level.alert + 1
            //            self.window.rootViewController?.present(alert, animated: true, completion: nil)
        }else{
            window.rootViewController?.present(alert, animated: false, completion: nil)
        }
    }
    class func showalertWithAction(msg:String,arrAction:[UIAlertAction],view:UIViewController)->(){
        let alert = UIAlertController.init(title: ConstantURL.Appname, message: msg, preferredStyle: .alert)
        for action in arrAction{
            alert.addAction(action)
        }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.alert
        window.makeKeyAndVisible()
        if(self.SYSTEM_VERSION_GREATER_THAN(version:"12")){
           // UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            view.present(alert, animated: true) {
                print("alret display ")
            }
          //  view.present(alert, animated: true, completion: nil)
            // let window = UIWindow.init()
            //    window.rootViewController = UIViewController()
            //            self.window.windowLevel = UIWindow.Level.alert + 1
            //            self.window.rootViewController?.present(alert, animated: true, completion: nil)
        }else{
            window.rootViewController?.present(alert, animated: false, completion: nil)
        }
    }
    
    
    
    // MARK: - Return Default Value
    class func returndefaultstring(dic:[String:Any],keyvalue:String)->String{
        let string = dic[keyvalue] as? String ?? ""
        
        return string
    }
    
    class func returndefaultfloat(dic:[String:Any],keyvalue:String)->Float{
        let floatvalue = dic[keyvalue] as? Float ?? 0.00
        return floatvalue
    }
    class func returndefaultInteger(dic:[String:Any],keyvalue:String)->Int{
        let int = dic[keyvalue] as? Int ?? 0
        return int
    }
    
    class func returndefaultNSInteger(dic:[String:Any],keyvalue:String)->NSInteger{
        let nsinteger = dic[keyvalue] as? NSInteger ?? 0
        return nsinteger
    }
    
    
    class func returndefaultdouble(dic:[String:Any],keyvalue:String)->Double{
        let double = dic[keyvalue] as? Double ?? Double.init(0.00)
        return double
    }
    
    class func returndefaultnsnumber(dic:[String:Any],keyvalue:String)->NSNumber{
        if(type(of: dic[keyvalue]) == String.self){
            if let myInteger = Int(dic[keyvalue] as? String ?? "") {
                let myNumber = NSNumber(value:myInteger)
                return myNumber
            }else{
                return  NSNumber.init(value: 0)
            }
        }else{
            let number = dic[keyvalue] as? NSNumber ?? NSNumber.init(value: 0)
            return number
        }
    }
    
    class func returndefaultbool(dic:[String:Any],keyvalue:String)->Bool{
        let bool = dic[keyvalue] as? Bool ?? false
        return bool
    }
    class func returndefaultdictionary(dic:[String:Any] , keyvalue:String)->[String:Any]{
        let dictionary = dic[keyvalue] as? [String:Any] ?? [String:Any]()
        return dictionary
    }
    
    class func returndefaultarray(dic:[String:Any] , keyvalue:String)->[Any]{
        let array = dic[keyvalue] as? [[String:Any]] ?? [[String:Any]]()
        return array
    }
    
    class func returndefaultNSNumberArray(dic:[String:Any] , keyvalue:String)->[NSNumber]{
        let array = dic[keyvalue] as? [NSNumber] ?? [NSNumber]()
        return array
    }
    
    class func returnclassviewcontroller(storybordname:String,classname:String)->UIViewController{
        let sb = UIStoryboard.init(name: storybordname, bundle: nil)
        var viewcontroller:UIViewController!
        viewcontroller = sb.instantiateViewController(withIdentifier: classname)
        return viewcontroller
        
    }
    
    class func returnRequest(url:String,method:Apicallmethod,param:[String:Any])->DataRequest{
        let url = URL.init(string: url)!

         
              var httpMethod:HTTPMethod!
              if(method == Apicallmethod.get){
                  httpMethod = HTTPMethod.get
              }else if(method == Apicallmethod.post){
                  httpMethod = HTTPMethod.post
              }

              let manager = Alamofire.SessionManager.default
              manager.session.configuration.timeoutIntervalForRequest = 120
              manager.session.configuration.timeoutIntervalForResource = 120
             
            let request = manager.request(url, method: httpMethod , parameters:param)
        return request 
    }
    
    class func returndefaultparameter()->[String:Any]{
        var parameter = [String:Any]()
        let activeUser = Utils().getActiveAccount()
        if(activeUser?.userID?.intValue ?? 0 > 0){
            
            
            parameter["CompanyID"] = activeUser?.company?.iD
            parameter["UserID"] = activeUser?.userID?.stringValue
            parameter["TokenID"] = activeUser?.securityToken ?? "ds"
            parameter["Application"] = ConstantURL.APPLICATIONSUPERSALESPRO
            // ["get_Settings":strjson as! String,"UserID":activeUser.userID?.stringValue as! String,"TokenID":activeUser.securityToken as! String ]
            //param = ["Application":Consatnt.APPLICATION_SUPERSALESPRO]
            
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIApplication.shared.keyWindow?.inputViewController?.view.makeToast("Invalid Token")
            Login().logout()
            }
        }
        return parameter
    }
    
    class func returnjsondata()->String{
        var strjson = String()
        
        let activeUser = Utils().getActiveAccount()
        if(activeUser?.userID?.intValue ?? 0 > 0){
            do{
                let jsondata = try JSONSerialization.data(withJSONObject: ["CreatedBy":activeUser?.userID?.stringValue,"CompanyID":activeUser?.company?.iD?.stringValue], options: [])
                strjson = String.init(data: jsondata, encoding: String.Encoding.utf8) ?? ""
            }catch{
                
            }
            
        }else{
            //  Login().logout()
        }
        return strjson
    }
    class func returnjsonstring(dic:[String:Any])->String
    {
        var strjson = String()
        
        let activeUser = Utils().getActiveAccount()
        if(activeUser?.userID?.intValue ?? 0 > 0){
            do{
                let jsondata = try JSONSerialization.data(withJSONObject: dic, options: [])
                strjson = String.init(data: jsondata, encoding: String.Encoding.utf8) ?? ""
            }catch{
                
            }
            
        }else{
            //            Login().logout()
        }
        return strjson
    }
    class func json(from object:Any) -> String {
        //        var str = ""
        //        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        //            return ""
        //        }
        //        str = String(data: data, encoding: String.Encoding.utf8) ?? ""
        //        print("json data = \(str)")
        //        return str
        var strjson = String()
        
        let activeUser = Utils().getActiveAccount()
        if(activeUser?.userID?.intValue ?? 0 > 0){
            do{
                let jsondata = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
                //try JSONSerialization.data(withJSONObject: object, options: [JSONSerialization.WritingOptions.prettyPrinted])
                strjson = String.init(data: jsondata, encoding: String.Encoding.utf8) ?? ""
                strjson = strjson.replacingOccurrences(of: "\\\\", with: "\\")
            }catch(let erroe){
                print(erroe.localizedDescription)
            }
            
        }else{
            //            Login().logout()
        }
        print(strjson)
        return strjson
    }
    
    
    class func returnnoerror()->NSError{
        let error:NSError = NSError.init(domain: "", code: 0, userInfo: [String:Any]())
        return error
    }
    
    class  func createImage(withImage image: UIImage, forSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return newImage;
        }
        return nil
    }
    
    
    
    class func getImageFromURL(strURL:String , comapletionHandler:@escaping ImageDownloadCompeletionHandler){
        
        let catPictureURL = URL(string: strURL)!
        let session = URLSession(configuration: .default)
        var outputImage = UIImage()
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                comapletionHandler(outputImage)
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                
                
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        print(image?.size ?? "N?1")
                        outputImage = image!
                        comapletionHandler(outputImage)
                        // Do something with your image.
                    } else {
                        //
                        comapletionHandler(outputImage)
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    comapletionHandler(outputImage)
                    //
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
        
        
    }
    class func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
}
struct ConstantURL {
    
    //    static let kBaseTeamworkURL = "http://supersales.co:8080/salesproprodtracking/"
    //    static let kBaseURL = "http://bigbangcommonservice.info:8080/commonServicesTestProduction/"
    
    public static let APPLICATIONSUPERSALESPRO = "SalesPro"
    //APPLICATION_TEAMWORK @"SalesPro"
    public static let ApplicationTeamwork = "SalesPro"
    public static let Appname = "SuperSales"
    public static let PendingLeave  = "Pending"
    public static let CancelledLeave  = "Cancelled"
    public static let WithdraenLeave  = "Withdrawn"
    public static let Approved  =  "Approved"
    
    
    //MARK: Notification
    /*
     #define BALANCE_UPDATE_NOTIFICATION @"UpdateUserBalance"
     #define LEAVE_UPDATE_NOTIFICATION @"LeaveUpdateNotification"
     #define HOLIDAYS_UPDATE_NOTIFICATION @"HolidayUpdateNotification"
     #define CHANGED_PROFILE_NOTIFICATION @"ProfileChanged"
     
     **/
    public static let UPDATE_DASHBOARD_SUMMARY = "UpdateDashboardSummary"
    public static let BALANCE_UPDATE_NOTIFICATION  =  "UpdateUserBalance"
    public static let LEAVE_UPDATE_NOTIFICATION  = "LeaveUpdateNotification"
    public static let HOLIDAYS_UPDATE_NOTIFICATION = "HolidayUpdateNotification"
    public static let CHANGED_PROFILE_NOTIFICATION  = "ProfileChanged"
    /*
     
     #define PENDING_LEAVE @"Pending"
     #define FONT_COLOR @"FONT_COLOR"
     #define CANCELLED_LEAVE @"Cancelled"
     #define WITHDRAWN_LEAVE @"Withdrawn"
     **/
    
    //Developer Mode
    
   //  static let kBaseURL ="http://bigbangcommonservice.info:8080/commonServices10/"
     
//    public static let kBaseURL = "http://bigbangcommonservice.info:8080/commonServicesDev/"
//        //"http://test.bigbangcommonservice.info:8080/commonServicesDev/" //"http://bigbangcommonservice.info:8080/commonServicesDev/"
//        //"http://test.bigbangcommonservice.info:8080/commonServicesDev/"//
//        public static let kBaseTeamworkURL = "http://bigbangcommonservice.info:8080/salesprodev/"  //"http://test.bigban gcommonservice.info:8080/salesprodev/" //common//"http://test.bigbangcommonservice.info:8080/salesprodev/"http://test.bigbangcommonservice.info:8080/salesproprodtracking/
//
//
    //APIs for Test environment-MasterSchema_Test2
//    public static let kBaseTeamworkURL @"http://supersales.co:8080/salesprotest/"
//    public static let kBaseURL @"http://bigbangcommonservice.info:8080/commonServices3/"
//
    // APIs for Test Production environment-MasterSchema_Test2
//    public static let kBaseTeamworkURL = "http://supersales.co:8443/salesproprodtracking/"
//    public static let kBaseURL = "http://bigbangcommonservice.info:8443/commonServicesTestProduction/"

    
//    public static let kBaseTeamworkURL = "https://supersales.co:8443/salesproprodtracking/"
//    public static let kBaseURL = "https://bigbangcommonservice.info:8443/commonServicesTestProduction/"
    
    
//Production Mode
    //"http://supersales.co:8080/salesproprod/"
    //http://bigbangcommonservice.info:8080/commonServices"
        public static let kBaseTeamworkURL = "https://supersales.co:8443/salesproprod/"
        public static let kBaseURL  = "https://bigbangcommonservice.info:8443/commonServices/"

    //MARK: Restapimanager
    //for login
    
    public static let kWSRESTUrlLogin = String.init(format: "%@","loginUser")
    public static let kWSRESTUrlLogout = String.init(format: "%@","logout")
    
    
    
    // MARK: Push notification
    
    //#define kWSUrlGetUser   kBaseURL@"getUser"
    public static let kWSRESTUrlGetUser = String.init(format: "%@","getUser")
    
    
    
  //  public static let kWSUpdateUserDetail = String.init(format: "%@%@",kBaseURL,"updateUserFromApp")
    
    // get Notification
   /* public static let  kWSUrlGetNotifications  = String.init(format: "%@%@",kBaseURL,"getNotifications")
    public static let  kWSUrlGetTravelCheckInCheckOutDetails  = String.init(format: "%@%@",kBaseTeamworkURL,"getTravelCheckInOutDetails")
    //  #define kWSUrlGetTravelCheckInCheckOutDetails           kBaseTeamworkURL@"getTravelCheckInOutDetails"
    // MARK: Setting
    
    //get setting
    public static let kWSUrlGetSetting = String.init(format: "%@%@",kBaseTeamworkURL,"getSettings")
    
  //  public static let kWSUrlGetMenuSetting = String.init(format: "%@%@",kBaseTeamworkURL,"getUserDisplayMenuAndTabSettings")
    
    
    
    
    //get company setting
    public static let kWSUrlGetCompanyMenuSetting = String.init(format:"%@%@",kBaseTeamworkURL,"getUserDisplayMenuAndTabSettings")
    
    public static let kWSUrlGetDefaultSetting = String.init(format:"%@%@",kBaseTeamworkURL,"getDefaultSettings")
    
    
    
    
    //fetch contacts
    public static let kWSUrlGetAllContact = String.init(format: "%@%@", kBaseURL,"getAllContact")
    
    //fetch vendors
    public static let kWSUrlGetAllVendor = String.init(format: "%@%@", kBaseURL,"getVendors")
    
    //fetch tagged customer
    public static let kWSUrlGetAllTaggedCustomer = String.init(format: "%@%@", kBaseURL,"getTaggedCustomersDetailsJson")
    
    // get setting
    public static let kWSUrlGetTypeAndSegmentSetting = String.init(format: "%@%@", kBaseURL,"getCustomerFormTypeAndSegmentSetting")
    //MARK: - Customer
    
    // #define kWSUrlTagCustomer
    
    public static let kWSUrlGetCustomerDetails = String.init(format: "%@%@", kBaseURL,"getCustomerVendorDetails")
    //kBaseURL@"tagCustomer"
    public static let kWSUrlTagCustomer  = String.init(format: "%@%@", kBaseURL,"tagCustomer")
    
    
    // export customer
    public static let kWSUrlExportCustomerVendor = String.init(format: "%@%@" , kBaseURL , "ExportCustVendorToClientServer")
    
    //get customer potenstial
    public static let kWSUrlGetCustomerPotential = String.init(format: "%@%@" , kBaseURL    ,"getCustomerPotential")
    
    public static let kWSUrlAddEditCustomerPotential =  String.init(format: "%@%@" , kBaseURL    ,"addCustomerPotential")

    
    public static let kWSUrlAddCustomerVendor  = String.init(format: "%@%@", kBaseURL,"addNewCustomerVendor")
    
    public static let kWSUrlUpdateCustomerVendor = String.init(format: "%@%@", kBaseURL,"updateCustomerVendor")
    //seacrh town
    // #define kWSUrlSearchTown                                kBaseURL@"searchTown"
    public static let kWSUrlSearchTown  = String.init(format: "%@%@", kBaseURL,"searchTown")
    
    //    #define kWSUrlAddCustomerVendor                         kBaseURL@"addNewCustomerVendor"
    
    //fetch product category
    public static let kWSUrlGetProductCategory = String.init(format: "%@%@", kBaseTeamworkURL,"getProductCategory")
    
    //fetch synced product
    public static let kWSUrlGetSyncProduct = String.init(format: "%@%@", kBaseTeamworkURL,"getMappedSyncProduct")
    
    //verify customer mobile no
    public static let kWSUrlVerifyCustomerMobileNo  = String.init(format: "%@%@", kBaseURL,"verifyCustomerMobileNo")
    //  #define kWSUrlVerifyCustomerMobileNo                    kBaseURL@"verifyCustomerMobileNo"
    
    //get customer's contact list
    // getContactWithFilter
    public static let kWSUrlContactDetailOfUser = String.init(format: "%@%@", kBaseURL,"getContactWithFilter")
    
    /*// Knowledge Center
     #define kWSUrlGetCategoryList                           kBaseURL@"getCategoryList"
     #define kWSUrlGetDocumentList                           kBaseURL@"getDocumentList"
     #define kWSUrlGetAllDocumentList                        kBaseURL@"getAllDocumentList"
     #define kWSUrlGetQuizResult                             kBaseURL@"getQuizResult"
     #define kWSUrlGetUserDocumentViewList                   kBaseURL@"getUserDocumentViewList"
     #define kWSUrlQuizStartStatus                           kBaseURL@"quizStartStatus"
     #define kWSUrlGetQuizQuestionList                       kBaseURL@"getQuizQuestionList"
     #define kWSUrlAddQuizAnswer                             kBaseURL@"addQuizAnswer"
     #define kWSUrlAddDocumentViewStatus                     kBaseURL@"addDocumentViewStatus"*/
    
    // MARK: Knowledge Center
    public static let kWSUrlGetCategoryList  =        String.init(format: "%@%@",kBaseURL,"getCategoryList")
    public static let kWSUrlGetDocumentList  =     String.init(format: "%@%@",kBaseURL,"getDocumentList")
    public static let kWSUrlGetAllDocumentList  =     String.init(format: "%@%@",kBaseURL,"getAllDocumentList")
    public static let kWSUrlGetQuizResult  =     String.init(format: "%@%@",kBaseURL,"getQuizResult")
    public static let kWSUrlGetUserDocumentViewList  =     String.init(format: "%@%@",kBaseURL,"getUserDocumentViewList")
    public static let kWSUrlQuizStartStatus  =     String.init(format: "%@%@",kBaseURL,"quizStartStatus")
    public static let kWSUrlGetQuizQuestionList  =     String.init(format: "%@%@",kBaseURL,"getQuizQuestionList")
    public static let kWSUrlAddQuizAnswer  =     String.init(format: "%@%@",kBaseURL,"addQuizAnswer")
    public static let kWSUrlAddDocumentViewStatus  =     String.init(format: "%@%@",kBaseURL,"addDocumentViewStatus")
    
    
    
    // MARK: Lead
    //fetch synced lead
    public static let kWSUrlGetSyncLeads  =                            String.init(format: "%@%@",kBaseTeamworkURL,"getSyncLeads")
    
    public static let kWSUrlGetLeadClose  =                            String.init(format: "%@%@",kBaseTeamworkURL,"getleadClose")
    
    //fetch Lead Outcome
    public static let kWSUrlGetLeadOutCome = String.init(format: "%@%@",kBaseTeamworkURL,"getleadOutcome")
    
    
    //fetch lead source
    public static let kWSUrlGetLeadSummary = String.init(format: "%@%@", kBaseTeamworkURL,"getLeadSummaryForUser")
    
    public static let kWSUrlGetLeadSource = String.init(format: "%@%@",kBaseTeamworkURL,"getleadSource")
    
    public static let kWSUrlGetLeadDetails = String.init(format: "%@%@",kBaseTeamworkURL,"getalead")
    
    public static let kWSUrlGetAddlead = String.init(format: "%@%@",kBaseTeamworkURL,"addlead")
    
    public static let kWSUrlUpdateLead = String.init(format: "%@%@",kBaseTeamworkURL,"updatelead")
    
    public static let kWSUrlAssignedlead = String.init(format: "%@%@",kBaseTeamworkURL,"assignedlead")
    
    public static let kWSUrlLeadCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"leadCheckIn")
    
    public static let kWSUrlLeadCheckOut = String.init(format: "%@%@",kBaseTeamworkURL,"leadCheckOut")
    
    public static let kWSUrlLeadManualCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"leadManualCheckIn")
    
    public static let kWSUrlLeadManualCheckOut = String.init(format: "%@%@",kBaseTeamworkURL,"leadManualCheckOut")
    
    public static let kWSUrlLeadCheckInSendApproval = String.init(format: "%@%@",kBaseTeamworkURL,"leadCheckInSendApproval")
    
    public static let kWSUrlLeadDeleteCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"deleteLeadCheckIn")
    
    public static let kWSUrlLeadUpdateCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"updateLeadCheckIn")
    
    // MARK: - Reports
    
    /*
     #define kWSURLGenerateExpenseReportForDates             kBaseURL@"generateExpenseReportForDates"
     #define kWSURLGenerateQuizReport                        kBaseURL@"generateQuizReport"
     #define kWSURLGenerateCustomerVendorReport              kBaseURL@"generateCustomerVendorDetailsReport"
     #define kWSURLGenerateFeedbackReport                    kBaseURL@"generateFeedbackReport"
     #define kWSURLGenerateExcelReport                       kBaseTeamworkURL@"generateExcelReport"
     **/
    
    public static let kWSURLGenerateExpenseReportForDates  = String.init(format:"%@%@",kBaseURL,"generateExpenseReportForDates")
    public static let kWSURLGenerateQuizReport  = String.init(format:"%@%@",kBaseURL,"generateQuizReport")
    public static let kWSURLGenerateCustomerVendorReport  = String.init(format:"%@%@",kBaseURL,"generateCustomerVendorDetailsReport")
    public static let kWSURLGenerateFeedbackReport   = String.init(format:"%@%@",kBaseURL,"generateFeedbackReport")
    public static let kWSURLGenerateExcelReport   = String.init(format:"%@%@",kBaseTeamworkURL,"generateExcelReport")
    
    // MARK: Attendance
    //
    public static let kWSUrlGetValidAtteApprove = String.init(format:"%@%@",kBaseTeamworkURL,"requestForValidAtteApprove")
    
    public static let kWSUrlGetValidAttendace = String.init(format:"%@%@",kBaseTeamworkURL,"getValidAttendanceForUser")
    
    public static let kWSUrlGetPendingAttendace = String.init(format:"%@%@",kBaseTeamworkURL,"getAllUsersPenddingAttendanceHistory")
    
    public static let kWSUrlGetAttendanceHistory = String.init(format: "%@%@",kBaseTeamworkURL,"getAttendanceHistory")
    
    public static let kWSUrlManualAttendance = String.init(format: "%@%@",kBaseTeamworkURL,"manualAttendance")
    
    public static let kWSUrlUpdateAttendance = String.init(format: "%@%@",kBaseTeamworkURL,"updateAttendance")
    
    public static let kWSUrlGetAllAttendanceHistory = String.init(format: "%@%@",kBaseTeamworkURL,"getAllUserAttendanceHistory")
    
    public static let kWSUrlApproveAttendance = String.init(format: "%@%@",kBaseTeamworkURL,"approveAttendance")
    
    public static let kWSUrlGetAttendanceUpdate = String.init(format: "%@%@",kBaseTeamworkURL,"getUpdateDetails")
    // MARK: - Expense
    public static let kWSUrlGetUserExpenses  = String.init(format: "%@%@",kBaseURL,"getUserExpenses")
    public static let kWSUrlGetMemberExpenses  = String.init(format: "%@%@",kBaseURL,"getMemberExpenses")
    public static let kWSUrlGetExpenseType  = String.init(format: "%@%@",kBaseURL,"getExpenseTypes")
    public static let kWSUrlAddExpense  = String.init(format: "%@%@",kBaseURL,"addExpense")
    public static let kWSUrlUpdateExpense   = String.init(format: "%@%@",kBaseURL,"updateExpense")
    public static let kWSUrlWithdrawExpense   = String.init(format: "%@%@",kBaseURL,"withdrawExpense")
    public static let kWSUrlApproveRejectExpense  = String.init(format: "%@%@",kBaseURL,"approveRejectExpense")
    public static let kWSUrlGetExpenseForTransaction  = String.init(format: "%@%@",kBaseURL,"getExpenseForTransaction")
    //Expense
    /*  #define kWSUrlGetUserExpenses                           kBaseURL@"getUserExpenses"
     #define kWSUrlGetMemberExpenses                         kBaseURL@"getMemberExpenses"
     #define kWSUrlGetExpenseType                            kBaseURL@"getExpenseType"
     #define kWSUrlAddExpense                                kBaseURL@"addExpense"
     #define kWSUrlUpdateExpense                             kBaseURL@"updateExpense"
     #define kWSUrlWithdrawExpense                           kBaseURL@"withdrawExpense"
     #define kWSUrlApproveRejectExpense                      kBaseURL@"approveRejectExpense"
     #define kWSUrlGetExpenseForTransaction                  kBaseURL@"getExpenseForTransaction"*/
    // MARK: Leave
    //https://supersales.bigbanginnovations.in/apilive/leave/get_copmany_active_leave
    public static let kWSUrlGetDynamicLeaveType =  String.init(format: "https://supersales.bigbanginnovations.in/apilive/leave/get_copmany_active_leave")//
    public static let kWSUrlGetLeaveRequestDetails = String.init(format: "%@%@",kBaseTeamworkURL,"leaveRequestDetails")
    
    public static let kWSUrlApplyLeave = String.init(format:"%@%@",kBaseTeamworkURL,"applyLeave")
    
    public static let kWSUrlApproveLeaves = String.init(format: "%@%@",kBaseTeamworkURL,"approveLeaves")
    
    public static let kWSUrlGetAllUserLeaves = String.init(format: "%@%@",kBaseTeamworkURL,"getAllUserLeaves")
    
    public static let kWSUrlGetLeaveBalance = String.init(format: "%@%@",kBaseTeamworkURL,"getLeaveBalance")
    
    public static let kWSUrlGetLeaveStatus = String.init(format: "%@%@",kBaseTeamworkURL,"getLeaveStatus")
    
    public static let kWSUrlWithDrawLeave = String.init(format: "%@%@",kBaseTeamworkURL,"withdrawLeaves")
    
    public static let kWSUrlCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"checkIn")
    
    public static let kWSUrlCheckOut = String.init(format: "%@%@",kBaseTeamworkURL,"checkOut")
    
    
    
    
    //  #define kWSUrlUpdateUserLeave                           kBaseTeamworkURL@"updateUserLeaves"
    // #define kWSUrlUpdateCompanyLeaves                       kBaseTeamworkURL@"updateCompanyLeaves"
    
    
    // MARK: visit url
    //add manual visit
    public static let kWSUrlAddManualVisit = String.init(format: "%@%@",kBaseTeamworkURL,"addManualVisit")
    
    //edit visit
    public static let kWSUrlAddEditPlannedVisit = String.init(format: "%@%@",kBaseTeamworkURL,"addEditVisit")
    
    //add joint visit
    public static let kWSUrlAddJointVisit = String.init(format: "%@%@",kBaseTeamworkURL,"addJointVisit")
    
    
    //fetch mapped plan visit
    public static let kWSUrlGetMappedPlannedVisits = String.init(format: "%@%@",kBaseTeamworkURL,"getMappedPlannedVisits")
    
    //fecth unplan visits with filter and sort type
    public static let kWSUrlGetUnPlannedVisits = String.init(format: "%@%@",kBaseTeamworkURL,"getUnPlannedVisits")
    
    //unplaned visit history
    public static let kWSUrlGetUnPlannedVisitsClose = String.init(format: "%@%@",kBaseTeamworkURL,"getUnPlannedVisitsClose")
    
    //planed visit history
    public static let kWSUrlGetPlannedVisitsClose = String.init(format: "%@%@",kBaseTeamworkURL,"getPlannedVisitsClose")
    
    public static let kWSUrlGetPlannedVisits  = String.init(format: "%@%@",kBaseTeamworkURL,"getPlannedVisits")
    
    //delete join visit
    public static let kWSUrlDeleteJointVisit = String.init(format: "%@%@",kBaseTeamworkURL,"deleteJointVisit")
    
    
    
    
    public static let  kWSUrlGetMissedNotificationData  = String.init(format: "%@%@",kBaseTeamworkURL,"getMissedNotificationDataPost")
    
    
    
    
    //fetch visit outcome
    public static let kWSUrlGetVisitOutcome = String.init(format: "%@%@",kBaseTeamworkURL,"getvisitOutcome")
    
    
    //fetch company user list
    public static let kWSUrlGetCompanyUsers = String.init(format: "%@%@",kBaseURL,"getCompanyUsersList")
    
    
    //fetch proposals
    public static let kWSURLGetSyncProposals = String.init(format: "%@%@",kBaseTeamworkURL,"getsyncproposals")
    
    // Orders
    //fetch sales order
    public static let kWSURLGetSyncSalesOrders = String.init(format: "%@%@",kBaseTeamworkURL,"getsyncsalesorders")
    
    
    //Purchase orders
    //fetch purchase orders
    public static let kWSURLGetSyncPurchaseOrder = String.init(format: "%@%@",kBaseTeamworkURL,"getSyncPurchaseOrder")
    
    
    //fetch customer segment
    public static let kWSUrlGetCustomerSegment = String.init(format: "%@%@",kBaseURL,"getCustomerSegment")
    
    // Attendance
    //fetch Attendance detail
    public static let kWSUrlGetAttendanceDetails = String.init(format: "%@%@",kBaseTeamworkURL,"getAttendanceDetails")
    
    
    //fetch CustomerVendorSetting
    public static let kWSUrlGetCustomerVendorSettings = String.init(format: "%@%@",kBaseURL,"getCustomerVendorSettings")
    
    //joint visit from manager
    public static let kWSUrlGetJointVisitsForManagerLogin = String.init(format: "%@%@",kBaseTeamworkURL,"getJointVisitsForManagerLogin")
    
    // Get Vat Code List
    
    public static let kWSUrlGetMetadataVATCodes = String.init(format: "%@%@",kBaseURL,"getMetadataVATCodes")
    
    //get step visit
    public static let kWSUrlGetStepVisitList = String.init(format: "%@%@",kBaseTeamworkURL,"getStepVisitList")
    
    //get AttendanceCompanyInfo
    public static let kWSURLGetCompanyInfo = String.init(format: "%@%@",kBaseTeamworkURL,"getAttendanceCompanyInfo")
    
    
    //get all teritory for user
    public static let kWSUrlGetTerritory = String.init(format: "%@%@",kBaseURL,"getAllLowerHierarchyTerritoryListOfUser")
    //getTerritoryList
    //getAllLowerHierarchyTerritoryListOfUser
    
    //get Joint Visit List
    public static let kWSUrlGetJointVisitList = String.init(format: "%@%@",kBaseTeamworkURL,"getJointVisitList")
    
    public static let kWSUrlVisitCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"visitCheckIn")
    
    public static let kWSUrlVisitCheckOut = String.init(format: "%@%@",kBaseTeamworkURL,"visitCheckOut")
    
    public static let kWSUrlVisitManualCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"visitManualCheckIn")
    
    public static let kWSUrlVisitManualCheckOut = String.init(format: "%@%@",kBaseTeamworkURL,"visitManualCheckOut")
    
    public static let kWSUrlGetVisitTertiary = String.init(format: "%@%@",kBaseTeamworkURL,"getVisitTertiary")
    
    public static let kWSUrlGetVisitStock = String.init(format: "%@%@",kBaseTeamworkURL,"getVisitStock")
    
    public static let kWSUrlUpdateVisitTertiary = String.init(format: "%@%@",kBaseTeamworkURL,"updateVisitTertiary")
    
    public static let kWSUrlUpdateVisitStock = String.init(format: "%@%@",kBaseTeamworkURL,"updateVisitStock")
    
    public static let kWSUrlUpdateCustAddress = String.init(format: "%@%@",kBaseURL,"updateCustAddress")
    
    
    public static let kWSUrlDeleteCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"deleteCheckIn")
    
    public static let kWSUrlUpdateCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"updateCheckIn")
    
    public static let kWSUrlVisitCheckInSendApproval = String.init(format: "%@%@",kBaseTeamworkURL,"visitCheckInSendApproval")
    
    public static let kWSUrlGetApprove = String.init(format: "%@%@",kBaseTeamworkURL,"approveEvent")
    
    public static let kWSUrlAddEditPlannedVisitForMultipleCustomer = String.init(format: "%@%@",kBaseTeamworkURL,"addMultipleVisitsForCustomerList")
    
    public static let kWSUrlUpdateVisitStatus = String.init(format: "%@%@",kBaseTeamworkURL,"updateVisitStatus")
    //updateVisitStatus
    public static let kWSUrlUploadVisitImage = String.init(format: "%@%@",kBaseTeamworkURL,"uploadVisitImage")
    
    public static let kWSUrlForOTPToCloseVisit  = String.init(format: "%@%@",kBaseTeamworkURL,"getVisitReportOtpByVisitAndUserID")
    
    public static let kWSUrlCloseVisit = String.init(format: "%@%@",kBaseTeamworkURL,"closeVisit")
    
    public static let kWSUrlAssignedVisit = String.init(format: "%@%@",kBaseTeamworkURL,"assignedVisit")
    
    //upload image in shelspace
    public static let kWSUrlUploadImage = String.init(format: "%@%@",kBaseTeamworkURL,"uploadImageViaIos")
    //
    public static let kWSUrlUploadImageEditCustomer = String.init(format: "%@%@",kBaseURL,"uploadLogo")
    //uploadImageViaIos
    //visit collection
    public static let  kWSUrlAddUpdateVisitCollection = String.init(format: "%@%@",kBaseTeamworkURL,"addUpdateVisitCollection")
    
    //view company stock
    public static let  kWSUrlViewCompanyStock = String.init(format: "%@%@",kBaseTeamworkURL,"viewCompanyStock")
    
    public static let  kWSUrlGetVisitUploadImages = String.init(format: "%@%@",kBaseTeamworkURL,"getVisitUploadImages")
    
    public static let  kWSUrlGetUserFeedback = String.init(format: "%@%@",kBaseURL,"getUserFeedback")
    
    public static let  kWSUrlGetQuestionList = String.init(format: "%@%@",kBaseURL,"getQuestionList")
    
    public static let  kWSUrlAddUpdateAnswer = String.init(format: "%@%@",kBaseURL,"addUpdateAnswer")
    
    //store check
    public static let  kWSUrlGetStoreCheckData = String.init(format: "%@%@",kBaseTeamworkURL,"getStoreCheckData")
    
    public static let  kWSUrlSaveBrandActivity = String.init(format: "%@%@",kBaseTeamworkURL,"saveBrandActivity")
    
    public static let  kWSUrlSaveAssignActivityCompetition = String.init(format: "%@%@",kBaseTeamworkURL,"saveAssignActivityCompetition")
    
    public static let  kWSUrlUpdateVisitCounterShare = String.init(format: "%@%@",kBaseTeamworkURL,"updateVisitCounterShare")
    public static let  kWSUrlAddVisitCounterShare = String.init(format: "%@%@",kBaseTeamworkURL,"addVisitCounterShare")
    
    public static let kwsurlgetCompetitionList = String.init(format:"%@%@",kBaseTeamworkURL,"getStoreCompetitionList")
    
    
    public static let  kWSUrlSetDefaultSetting = String.init(format:"%@%@",kBaseTeamworkURL,"setDefaultSettings")
    
    
    // #define kWSUrlGetUserFeedback                           kBaseURL@"getUserFeedback"
    //       #define kWSUrlGetQuestionList                           kBaseURL@"getQuestionList"
    //       #define kWSUrlAddUpdateAnswer                           kBaseURL@"addUpdateAnswer"
    //
    
    //     #define kWSUrlViewCompanyStock                          kBaseTeamworkURL@"viewCompanyStock"
    //MARAK: Beatplan
    
    //    #define kWSUrlGetUploadBeatPlanDetails                  kBaseTeamworkURL@"getUploadBeatPlanDetails"
    //    #define kWSUrlGetBeatPlanDetails                        kBaseTeamworkURL@"getAssignBeatPlanDetails"
    //    #define kWSUrlAssignedBeatPlan                          kBaseTeamworkURL@"assignBeatPlanRequest"
    //#define kWSUrlGetBeatPlanDetails kBaseTeamworkURL @"getBeatPlanDetails"assignBeatPlanRequest
    
    
    /*  #define kWSUrlAddManualVisit                            kBaseTeamworkURL@"addManualVisit"
     #define kWSUrlGetJointVisitList                         kBaseTeamworkURL@"getJointVisitList"
     #define kWSUrlDeleteJointVisit                          kBaseTeamworkURL@"deleteJointVisit"
     #define kWSUrlAddJointVisit                             kBaseTeamworkURL@"addJointVisit"*/
    
    
    //MARK: - Unplanvisit
    // for create customer to customer
    public static let kWSUrlAddTempCustomerProfile  = String.init(format: "%@%@",kBaseTeamworkURL,"addTempCustomerProfile")
    
    // for edit customer
    public static let kWSUrlUpdateTempCustomerProfile   = String.init(format: "%@%@",kBaseTeamworkURL,"kWSUrlUpdateTempCustomerProfile")
    
    // MARK: Activity
    // kWSUrlGetActivityType
    /*  #define kWSUrlGetActivityType                           kBaseTeamworkURL@"getActivityType"
     #define kWSUrlAddEditActivity                           kBaseTeamworkURL@"addEditActivity"
     #define kWSUrlGetPlannedActivity                        kBaseTeamworkURL@"getPlannedActivity"
     #define kWSUrlActivityCheckIn                           kBaseTeamworkURL@"activityCheckIn"
     #define kWSUrlActivityCheckOut                          kBaseTeamworkURL@"activityCheckOut"
     #define kWSUrlUpdateActivityStatus                      kBaseTeamworkURL@"updateActivityStatus"
     #define kWSUrlDeleteActivity                            kBaseTeamworkURL@"deleteActivity"
     #define kWSUrlGetActivityfollowups                      kBaseTeamworkURL@"getActivityfollowups"
     */
    public static let kWSUrlGetActivityType   = String.init(format: "%@%@",kBaseTeamworkURL,"getActivityType")
    
    public static let kWSUrlAddEditActivity   = String.init(format: "%@%@",kBaseTeamworkURL,"addEditActivity")
    
    public static let kWSUrlGetPlannedActivity    = String.init(format: "%@%@",kBaseTeamworkURL,"getPlannedActivity")
    
    public static let kWSUrlActivityCheckIn    = String.init(format: "%@%@",kBaseTeamworkURL,"activityCheckIn")
    
    public static let kWSUrlActivityCheckOut    = String.init(format: "%@%@",kBaseTeamworkURL,"activityCheckOut")
    
    public static let kWSUrlUpdateActivityStatus    = String.init(format: "%@%@",kBaseTeamworkURL,"updateActivityStatus")
    
    public static let kWSUrlDeleteActivity    = String.init(format: "%@%@",kBaseTeamworkURL,"deleteActivity")
    
    public static let kWSUrlGetActivityfollowups     = String.init(format: "%@%@",kBaseTeamworkURL,"getActivityfollowups")
    
    // MARK: SalesPlan
    // Sales Plan
    public static let kWSUrlGetLeadFollowUps = String.init(format: "%@%@",kBaseTeamworkURL,"getleadfollowups")
    
    //#define kWSUrlGetCollectionList                         kBaseTeamworkURL@"getcollectionlist"
    public static let kWSUrlGetCollectionList = String.init(format: "%@%@",kBaseTeamworkURL,"getvisitcollectionlist")
    // Getting Visit Collection
    
    public static let kWSUrlGetColdCallReminders = String.init(format: "%@%@",kBaseTeamworkURL,"getcoldcallreminders")
    
    public static let kWSUrlGetVisitFollowUps = String.init(format: "%@%@",kBaseTeamworkURL,"getVisitfollowups")
    
    public static let kWSUrlGetDailyPlan = String.init(format: "%@%@",kBaseTeamworkURL,"getDailySalesPlan")
    
    public static let kWSUrlGetBeatplanFollowupForSalesPlan = String.init(format: "%@%@",kBaseTeamworkURL,"getBeatPlanfollowups")
    
    public static let kWSUrlgetLowerHeirarchy = String.init(format: "%@%@",kBaseTeamworkURL,"getLowerHeirarchy")
    
    public static let kWSUrlApproveChangeMobile = String.init(format: "%@%@",kBaseURL,"approveChangeMobile")
    
    public static let kWSUrlResetPassword = String.init(format: "%@%@",kBaseURL,"resetPassword")
    
    //   #define kWSUrlGetManagerHierarchy                       kBaseURL@"getManagerHierarchy"
    public static let kWSUrlGetManagerHierarchy = String.init(format: "%@%@",kBaseURL,"getManagerHierarchy")
    
    public static let kWSUrlVerifyMobile = String.init(format: "%@%@",kBaseURL,"verifyChangeMobileNo")
    
    public static let kWSUrlCancelMobile = String.init(format: "%@%@",kBaseURL,"cancelChangeMobile")
    
    public static let kWSUrlResendOTP = String.init(format: "%@%@",kBaseURL,"generateOtp")
    

    
    public static let kWSChangeMobileNo = String.init(format: "%@%@",kBaseURL,"changeMobileNo")
    
    public static let kWSUrlAddContact = String.init(format: "%@%@",kBaseURL,"addContact")
    
    public static let kWSUrlEditContact = String.init(format: "%@%@",kBaseURL,"updateContact")
    
    public static let kWSUrlAcceptRejectResignation = String.init(format: "%@%@",kBaseURL,"acceptRejectResignation")
    
    public static let kWSUrlViewCustomerUpdates = String.init(format: "%@%@",kBaseURL,"viewCustomerUpdates")
    
    public static let kWSUrlAcceptUpdateCustomer = String.init(format: "%@%@",kBaseURL,"acceptUpdateCustomer")
    
    // MARK: Location
    public static let kWSUrlGetLocation = String.init(format: "%@%@",kBaseTeamworkURL,"getUserLocations")
    
    public static let kWSUrlUpdateCurrentUserLocation = String.init(format: "%@%@",kBaseTeamworkURL,"updateLocationOfUser")
    
    // MARK: User
    
    
    public static let  kWSUrlChangePassword  = String.init(format: "%@%@",kBaseURL,"changePassword")
    
    public static let kWSUrlUpdateUser = String.init(format: "%@%@",kBaseURL,"updateUserFromApp")//updateUser
    
    public static let kWSUrlUploadLogo = String.init(format: "%@%@",kBaseURL,"uploadLogo")
    
    
    public static let kWSUrlUploadAttachment = String.init(format: "%@%@",kBaseURL,"uploadAttachment")
    
    public static let kWSUrlGetCustomers = String.init(format: "%@%@",kBaseURL,"getCustomers")
    
    public static let kWSUrlGenerateCustomerOTP   = String.init(format: "%@%@",kBaseURL,"generateCustomerOTP")
    
    // MARK: Dashboard
    public static let kWSUrlGetVisitReportForDay = String.init(format: "%@%@",kBaseTeamworkURL,"getvisitreportforday")
    
    //  public static let kWSUrlGetActivityfollowups = String.init(format: "%@%@",kBaseTeamworkURL,"getActivityfollowups")
    
    
    
    public static let kWSUrlGetLeadReportForDay = String.init(format: "%@%@",kBaseTeamworkURL,"getleadreportforday")
    
    public static let kWSUrlGetOrderReportForDay = String.init(format: "%@%@",kBaseTeamworkURL,"getorderreportforday")
    
    public static let kWSUrlGetDailyReport = String.init(format: "%@%@",kBaseTeamworkURL,"getdailyreport")
    
    
    
    // MARK: Promotion
    
    public static let KWSUrlAvailablePromotionList = String.init(format: "%@%@",kBaseTeamworkURL,"getCustomerApplicablePromotionList")
    
    public static let KWSUrlAvailableEntitlementList = String.init(format: "%@%@",kBaseTeamworkURL,"getPendingEntitlementList")
    
    public static let kWSUrlGetJustificationList = String.init(format: "%@%@",kBaseTeamworkURL,"getCompanyJustificationList")
    
    public static let KWSUrlJointPromotion = String.init(format: "%@%@",kBaseTeamworkURL,"joinPromotion")
    
    public static let KWSUrlGetProductDriveList = String.init(format: "%@%@",kBaseTeamworkURL,"getProductsForDrive")
    
    public static let KWSUrlGetsuggestedQTyMultiple = String.init(format: "%@%@",kBaseTeamworkURL,"suggestOrderQtyMultiple")
    
    public static let kWSUrlGetShelfSpaceList1 = String.init(format: "%@%@",kBaseTeamworkURL,"getShelfSpaceList")
    
    public static let kWSUrlGetPositionList = String.init(format: "%@%@",kBaseTeamworkURL,"getPositionList")
    
    public static let kWSUrlAddShelfSpace = String.init(format: "%@%@",kBaseTeamworkURL,"addEditShelfSpace")
    
    public static let kWSUrlForEntitlementStatus = String.init(format: "%@%@",kBaseTeamworkURL,"changeEntitlementReceivedStatus")
    
    public static let kWSUrlForSendOTP = String.init(format: "%@%@",kBaseURL,"sendOTPToCustomer")
    
    public static let kWSUrlForVerifyOTP = String.init(format: "%@%@",kBaseURL,"verifyCustomerOTP")
    
    
    // MARK: - Beatplan
    
    
    //     public static let kWSUrlAssignedBeatPlan   = String.init(format: "%@%@",kBaseTeamworkURL,"assignBeatPlanRequest")
    
    public static let kWSUrlGetAsignedBeatPlanList   = String.init(format: "%@%@",kBaseTeamworkURL,"getAssigneeBeatPlanDetails")
    
    public static let kWSUrlGetUploadBeatPlanDetails = String.init(format: "%@%@",kBaseTeamworkURL,"getUploadBeatPlanDetails")
    
    //getAssigneeBeatPlanDetails   //getAssignBeatPlanDetails
    public static let kWSUrlDeleteBeatPlan = String.init(format: "%@%@",kBaseTeamworkURL,"deleteBeatPlanRequest")
    
    public static let kWSUrlEditBeatPlanList = String.init(format: "%@%@",kBaseTeamworkURL,"assignBeatPlanRequest")
    
    public static let kWSUrlForIndividiualBeatDetail = String.init(format: "%@%@",kBaseTeamworkURL,"getBeatPlanDetails")
    
    
    public static let kWSUrlVerifyAddressLatLong = String.init(format: "%@%@",kBaseURL,"verifyAddressLatLong")
    
    public static let kWSUrlGetMissedData = String.init(format: "%@%@",kBaseURL,"getMissedData")
    
    public static let kWSUrlGetSuperSalesNotifications = String.init(format: "%@%@",kBaseURL,"getSuperSalesNotifications")
    
    public static let kWSUrlGetSuperSalesApprovalNotifications = String.init(format: "%@%@",kBaseURL,"getSuperSalesApprovalNotifications")
    
    public static let kWSUrlGetCustomerHistoryReport = String.init(format: "%@%@",kBaseTeamworkURL,"getcustomerhistoryreport")
    
    
    */
    
    //MARK: APIManager
    //for login
    
    public static let kWSUrlLogin = String.init(format: "%@%@", kBaseURL,"loginUser")
    public static let kWSUrlLogout = String.init(format: "%@%@", kBaseURL,"logout")
    
    
    // MARK: Push notification
    
    //#define kWSUrlGetUser   kBaseURL@"getUser"
    public static let kWSUrlGetUser = String.init(format: "%@%@",kBaseURL,"getUser")
    
    
    
  //  public static let kWSUpdateUserDetail = String.init(format: "%@%@",kBaseURL,"updateUserFromApp")
    
    // get Notification
    public static let  kWSUrlGetNotifications  = String.init(format: "%@%@",kBaseURL,"getNotifications")
    public static let  kWSUrlGetTravelCheckInCheckOutDetails  = String.init(format: "%@%@",kBaseTeamworkURL,"getTravelCheckInOutDetails")
    //  #define kWSUrlGetTravelCheckInCheckOutDetails           kBaseTeamworkURL@"getTravelCheckInOutDetails"
    // MARK: Setting
    
    //get setting
    public static let kWSUrlGetSetting = String.init(format: "%@%@",kBaseTeamworkURL,"getSettings")
    
  //  public static let kWSUrlGetMenuSetting = String.init(format: "%@%@",kBaseTeamworkURL,"getUserDisplayMenuAndTabSettings")
    
    
    
    
    //get company setting
    public static let kWSUrlGetCompanyMenuSetting = String.init(format:"%@%@",kBaseTeamworkURL,"getUserDisplayMenuAndTabSettings")
    
    public static let kWSUrlGetDefaultSetting = String.init(format:"%@%@",kBaseTeamworkURL,"getDefaultSettings")
    
    
    
    
    //fetch contacts
    public static let kWSUrlGetAllContact = String.init(format: "%@%@", kBaseURL,"getAllContact")
    
    //fetch vendors
    public static let kWSUrlGetAllVendor = String.init(format: "%@%@", kBaseURL,"getVendors")
    
    //fetch tagged customer
    public static let kWSUrlGetAllTaggedCustomer = String.init(format: "%@%@", kBaseURL,"getTaggedCustomersDetailsJson")
    
    // get setting
    public static let kWSUrlGetTypeAndSegmentSetting = String.init(format: "%@%@", kBaseURL,"getCustomerFormTypeAndSegmentSetting")
    //MARK: - Customer
    
    // #define kWSUrlTagCustomer
    
    public static let kWSUrlGetCustomerDetails = String.init(format: "%@%@", kBaseURL,"getCustomerVendorDetails")
    //kBaseURL@"tagCustomer"
    public static let kWSUrlTagCustomer  = String.init(format: "%@%@", kBaseURL,"tagCustomer")
    
    
    // export customer
    public static let kWSUrlExportCustomerVendor = String.init(format: "%@%@" , kBaseURL , "ExportCustVendorToClientServer")
    
    //get customer potenstial
    public static let kWSUrlGetCustomerPotential = String.init(format: "%@%@" , kBaseURL    ,"getCustomerPotential")
    
    public static let kWSUrlAddEditCustomerPotential =  String.init(format: "%@%@" , kBaseURL    ,"addCustomerPotential")

    
    public static let kWSUrlAddCustomerVendor  = String.init(format: "%@%@", kBaseURL,"addNewCustomerVendor")
    
    public static let kWSUrlUpdateCustomerVendor = String.init(format: "%@%@", kBaseURL,"updateCustomerVendor")
    //seacrh town
    // #define kWSUrlSearchTown                                kBaseURL@"searchTown"
    public static let kWSUrlSearchTown  = String.init(format: "%@%@", kBaseURL,"searchTown")
    
    //    #define kWSUrlAddCustomerVendor                         kBaseURL@"addNewCustomerVendor"
    
    //fetch product category
    public static let kWSUrlGetProductCategory = String.init(format: "%@%@", kBaseTeamworkURL,"getProductCategory")
    
    //fetch synced product
    public static let kWSUrlGetSyncProduct = String.init(format: "%@%@", kBaseTeamworkURL,"getMappedSyncProduct")
    
    //verify customer mobile no
    public static let kWSUrlVerifyCustomerMobileNo  = String.init(format: "%@%@", kBaseURL,"verifyCustomerMobileNo")
    //  #define kWSUrlVerifyCustomerMobileNo                    kBaseURL@"verifyCustomerMobileNo"
    
    //get customer's contact list
    // getContactWithFilter
    public static let kWSUrlContactDetailOfUser = String.init(format: "%@%@", kBaseURL,"getContactWithFilter")
    
    /*// Knowledge Center
     #define kWSUrlGetCategoryList                           kBaseURL@"getCategoryList"
     #define kWSUrlGetDocumentList                           kBaseURL@"getDocumentList"
     #define kWSUrlGetAllDocumentList                        kBaseURL@"getAllDocumentList"
     #define kWSUrlGetQuizResult                             kBaseURL@"getQuizResult"
     #define kWSUrlGetUserDocumentViewList                   kBaseURL@"getUserDocumentViewList"
     #define kWSUrlQuizStartStatus                           kBaseURL@"quizStartStatus"
     #define kWSUrlGetQuizQuestionList                       kBaseURL@"getQuizQuestionList"
     #define kWSUrlAddQuizAnswer                             kBaseURL@"addQuizAnswer"
     #define kWSUrlAddDocumentViewStatus                     kBaseURL@"addDocumentViewStatus"*/
    
    // MARK: Knowledge Center
    public static let kWSUrlGetCategoryList  =        String.init(format: "%@%@",kBaseURL,"getCategoryList")
    public static let kWSUrlGetDocumentList  =     String.init(format: "%@%@",kBaseURL,"getDocumentList")
    public static let kWSUrlGetAllDocumentList  =     String.init(format: "%@%@",kBaseURL,"getAllDocumentList")
    public static let kWSUrlGetQuizResult  =     String.init(format: "%@%@",kBaseURL,"getQuizResult")
    public static let kWSUrlGetUserDocumentViewList  =     String.init(format: "%@%@",kBaseURL,"getUserDocumentViewList")
    public static let kWSUrlQuizStartStatus  =     String.init(format: "%@%@",kBaseURL,"quizStartStatus")
    public static let kWSUrlGetQuizQuestionList  =     String.init(format: "%@%@",kBaseURL,"getQuizQuestionList")
    public static let kWSUrlAddQuizAnswer  =     String.init(format: "%@%@",kBaseURL,"addQuizAnswer")
    public static let kWSUrlAddDocumentViewStatus  =     String.init(format: "%@%@",kBaseURL,"addDocumentViewStatus")
    
    
    
    // MARK: Lead
    //fetch synced lead
    public static let kWSUrlGetSyncLeads  =                            String.init(format: "%@%@",kBaseTeamworkURL,"getSyncLeads")
    
    public static let kWSUrlGetLeadClose  =                            String.init(format: "%@%@",kBaseTeamworkURL,"getleadClose")
    
    //fetch Lead Outcome
    public static let kWSUrlGetLeadOutCome = String.init(format: "%@%@",kBaseTeamworkURL,"getleadOutcome")
    
    
    //fetch lead source
    public static let kWSUrlGetLeadSummary = String.init(format: "%@%@", kBaseTeamworkURL,"getLeadSummaryForUser")
    
    public static let kWSUrlGetLeadSource = String.init(format: "%@%@",kBaseTeamworkURL,"getleadSource")
    
    public static let kWSUrlGetLeadDetails = String.init(format: "%@%@",kBaseTeamworkURL,"getalead")
    
    public static let kWSUrlGetAddlead = String.init(format: "%@%@",kBaseTeamworkURL,"addlead")
    
    public static let kWSUrlUpdateLead = String.init(format: "%@%@",kBaseTeamworkURL,"updatelead")
    
    public static let kWSUrlAssignedlead = String.init(format: "%@%@",kBaseTeamworkURL,"assignedlead")
    
    public static let kWSUrlLeadCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"leadCheckIn")
    
    public static let kWSUrlLeadCheckOut = String.init(format: "%@%@",kBaseTeamworkURL,"leadCheckOut")
    
    public static let kWSUrlLeadManualCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"leadManualCheckIn")
    
    public static let kWSUrlLeadManualCheckOut = String.init(format: "%@%@",kBaseTeamworkURL,"leadManualCheckOut")
    
    public static let kWSUrlLeadCheckInSendApproval = String.init(format: "%@%@",kBaseTeamworkURL,"leadCheckInSendApproval")
    
    public static let kWSUrlLeadDeleteCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"deleteLeadCheckIn")
    
    public static let kWSUrlLeadUpdateCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"updateLeadCheckIn")
    
    // MARK: - Reports
    
    /*
     #define kWSURLGenerateExpenseReportForDates             kBaseURL@"generateExpenseReportForDates"
     #define kWSURLGenerateQuizReport                        kBaseURL@"generateQuizReport"
     #define kWSURLGenerateCustomerVendorReport              kBaseURL@"generateCustomerVendorDetailsReport"
     #define kWSURLGenerateFeedbackReport                    kBaseURL@"generateFeedbackReport"
     #define kWSURLGenerateExcelReport                       kBaseTeamworkURL@"generateExcelReport"
     **/
    
    public static let kWSURLGenerateExpenseReportForDates  = String.init(format:"%@%@",kBaseURL,"generateExpenseReportForDates")
    public static let kWSURLGenerateQuizReport  = String.init(format:"%@%@",kBaseURL,"generateQuizReport")
    public static let kWSURLGenerateCustomerVendorReport  = String.init(format:"%@%@",kBaseURL,"generateCustomerVendorDetailsReport")
    public static let kWSURLGenerateFeedbackReport   = String.init(format:"%@%@",kBaseURL,"generateFeedbackReport")
    public static let kWSURLGenerateExcelReport   = String.init(format:"%@%@",kBaseTeamworkURL,"generateExcelReport")
    
    // MARK: Attendance
    //
    public static let kWSUrlGetValidAtteApprove = String.init(format:"%@%@",kBaseTeamworkURL,"requestForValidAtteApprove")
    
    public static let kWSUrlGetValidAttendace = String.init(format:"%@%@",kBaseTeamworkURL,"getValidAttendanceForUser")
    
    public static let kWSUrlGetPendingAttendace = String.init(format:"%@%@",kBaseTeamworkURL,"getAllUsersPenddingAttendanceHistory")
    
    public static let kWSUrlGetAttendanceHistory = String.init(format: "%@%@",kBaseTeamworkURL,"getAttendanceHistory")
    
    public static let kWSUrlManualAttendance = String.init(format: "%@%@",kBaseTeamworkURL,"manualAttendance")
    
    public static let kWSUrlUpdateAttendance = String.init(format: "%@%@",kBaseTeamworkURL,"updateAttendance")
    
    public static let kWSUrlGetAllAttendanceHistory = String.init(format: "%@%@",kBaseTeamworkURL,"getAllUserAttendanceHistory")
    
    public static let kWSUrlApproveAttendance = String.init(format: "%@%@",kBaseTeamworkURL,"approveAttendance")
    
    public static let kWSUrlGetAttendanceUpdate = String.init(format: "%@%@",kBaseTeamworkURL,"getUpdateDetails")
    // MARK: - Expense
    public static let kWSUrlGetUserExpenses  = String.init(format: "%@%@",kBaseURL,"getUserExpenses")
    public static let kWSUrlGetMemberExpenses  = String.init(format: "%@%@",kBaseURL,"getMemberExpenses")
    public static let kWSUrlGetExpenseType  = String.init(format: "%@%@",kBaseURL,"getExpenseTypes")
    public static let kWSUrlAddExpense  = String.init(format: "%@%@",kBaseURL,"addExpense")
    public static let kWSUrlUpdateExpense   = String.init(format: "%@%@",kBaseURL,"updateExpense")
    public static let kWSUrlWithdrawExpense   = String.init(format: "%@%@",kBaseURL,"withdrawExpense")
    public static let kWSUrlApproveRejectExpense  = String.init(format: "%@%@",kBaseURL,"approveRejectExpense")
    public static let kWSUrlGetExpenseForTransaction  = String.init(format: "%@%@",kBaseURL,"getExpenseForTransaction")
    //Expense
    /*  #define kWSUrlGetUserExpenses                           kBaseURL@"getUserExpenses"
     #define kWSUrlGetMemberExpenses                         kBaseURL@"getMemberExpenses"
     #define kWSUrlGetExpenseType                            kBaseURL@"getExpenseType"
     #define kWSUrlAddExpense                                kBaseURL@"addExpense"
     #define kWSUrlUpdateExpense                             kBaseURL@"updateExpense"
     #define kWSUrlWithdrawExpense                           kBaseURL@"withdrawExpense"
     #define kWSUrlApproveRejectExpense                      kBaseURL@"approveRejectExpense"
     #define kWSUrlGetExpenseForTransaction                  kBaseURL@"getExpenseForTransaction"*/
    // MARK: Leave
    //https://supersales.bigbanginnovations.in/apilive/leave/get_copmany_active_leave
    public static let kWSUrlGetDynamicLeaveType =  String.init(format: "https://supersales.bigbanginnovations.in/apilive/leave/get_copmany_active_leave")//
    public static let kWSUrlGetLeaveRequestDetails = String.init(format: "%@%@",kBaseTeamworkURL,"leaveRequestDetails")
    
    public static let kWSUrlApplyLeave = String.init(format:"%@%@",kBaseTeamworkURL,"applyLeave")
    
    public static let kWSUrlApproveLeaves = String.init(format: "%@%@",kBaseTeamworkURL,"approveLeaves")
    
    public static let kWSUrlGetAllUserLeaves = String.init(format: "%@%@",kBaseTeamworkURL,"getAllUserLeaves")
    
    public static let kWSUrlGetLeaveBalance = String.init(format: "%@%@",kBaseTeamworkURL,"getLeaveBalance")
    
    public static let kWSUrlGetLeaveStatus = String.init(format: "%@%@",kBaseTeamworkURL,"getLeaveStatus")
    
    public static let kWSUrlWithDrawLeave = String.init(format: "%@%@",kBaseTeamworkURL,"withdrawLeaves")
    
    public static let kWSUrlCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"checkIn")
    
    public static let kWSUrlCheckOut = String.init(format: "%@%@",kBaseTeamworkURL,"checkOut")
    
    
    
    
    //  #define kWSUrlUpdateUserLeave                           kBaseTeamworkURL@"updateUserLeaves"
    // #define kWSUrlUpdateCompanyLeaves                       kBaseTeamworkURL@"updateCompanyLeaves"
    
    
    // MARK: visit url
    //add manual visit
    public static let kWSUrlAddManualVisit = String.init(format: "%@%@",kBaseTeamworkURL,"addManualVisit")
    
    //edit visit
    public static let kWSUrlAddEditPlannedVisit = String.init(format: "%@%@",kBaseTeamworkURL,"addEditVisit")
    
    //add joint visit
    public static let kWSUrlAddJointVisit = String.init(format: "%@%@",kBaseTeamworkURL,"addJointVisit")
    
    
    //fetch mapped plan visit
    public static let kWSUrlGetMappedPlannedVisits = String.init(format: "%@%@",kBaseTeamworkURL,"getMappedPlannedVisits")
    
    //fecth unplan visits with filter and sort type
    public static let kWSUrlGetUnPlannedVisits = String.init(format: "%@%@",kBaseTeamworkURL,"getUnPlannedVisits")
    
    //unplaned visit history
    public static let kWSUrlGetUnPlannedVisitsClose = String.init(format: "%@%@",kBaseTeamworkURL,"getUnPlannedVisitsClose")
    
    //planed visit history
    public static let kWSUrlGetPlannedVisitsClose = String.init(format: "%@%@",kBaseTeamworkURL,"getPlannedVisitsClose")
    
    public static let kWSUrlGetPlannedVisits  = String.init(format: "%@%@",kBaseTeamworkURL,"getPlannedVisits")
    
    //delete join visit
    public static let kWSUrlDeleteJointVisit = String.init(format: "%@%@",kBaseTeamworkURL,"deleteJointVisit")
    
    
    
    
    public static let  kWSUrlGetMissedNotificationData  = String.init(format: "%@%@",kBaseTeamworkURL,"getMissedNotificationDataPost")
    
    
    
    
    //fetch visit outcome
    public static let kWSUrlGetVisitOutcome = String.init(format: "%@%@",kBaseTeamworkURL,"getvisitOutcome")
    
    
    //fetch company user list
    public static let kWSUrlGetCompanyUsers = String.init(format: "%@%@",kBaseURL,"getCompanyUsersList")
    
    
    //fetch proposals
    public static let kWSURLGetSyncProposals = String.init(format: "%@%@",kBaseTeamworkURL,"getsyncproposals")
    
    // Orders
    //fetch sales order
    public static let kWSURLGetSyncSalesOrders = String.init(format: "%@%@",kBaseTeamworkURL,"getsyncsalesorders")
    
    
    //Purchase orders
    //fetch purchase orders
    public static let kWSURLGetSyncPurchaseOrder = String.init(format: "%@%@",kBaseTeamworkURL,"getSyncPurchaseOrder")
    
    
    //fetch customer segment
    public static let kWSUrlGetCustomerSegment = String.init(format: "%@%@",kBaseURL,"getCustomerSegment")
    
    // Attendance
    //fetch Attendance detail
    public static let kWSUrlGetAttendanceDetails = String.init(format: "%@%@",kBaseTeamworkURL,"getAttendanceDetails")
    
    
    //fetch CustomerVendorSetting
    public static let kWSUrlGetCustomerVendorSettings = String.init(format: "%@%@",kBaseURL,"getCustomerVendorSettings")
    
    //joint visit from manager
    public static let kWSUrlGetJointVisitsForManagerLogin = String.init(format: "%@%@",kBaseTeamworkURL,"getJointVisitsForManagerLogin")
    
    // Get Vat Code List
    
    public static let kWSUrlGetMetadataVATCodes = String.init(format: "%@%@",kBaseURL,"getMetadataVATCodes")
    
    //get step visit
    public static let kWSUrlGetStepVisitList = String.init(format: "%@%@",kBaseTeamworkURL,"getStepVisitList")
    
    //get AttendanceCompanyInfo
    public static let kWSURLGetCompanyInfo = String.init(format: "%@%@",kBaseTeamworkURL,"getAttendanceCompanyInfo")
    
    
    //get all teritory for user
    public static let kWSUrlGetTerritory = String.init(format: "%@%@",kBaseURL,"getAllLowerHierarchyTerritoryListOfUser")
    //getTerritoryList
    //getAllLowerHierarchyTerritoryListOfUser
    
    //get Joint Visit List
    public static let kWSUrlGetJointVisitList = String.init(format: "%@%@",kBaseTeamworkURL,"getJointVisitList")
    
    public static let kWSUrlVisitCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"visitCheckIn")
    
    public static let kWSUrlVisitCheckOut = String.init(format: "%@%@",kBaseTeamworkURL,"visitCheckOut")
    
    public static let kWSUrlVisitManualCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"visitManualCheckIn")
    
    public static let kWSUrlVisitManualCheckOut = String.init(format: "%@%@",kBaseTeamworkURL,"visitManualCheckOut")
    
    public static let kWSUrlGetVisitTertiary = String.init(format: "%@%@",kBaseTeamworkURL,"getVisitTertiary")
    
    public static let kWSUrlGetVisitStock = String.init(format: "%@%@",kBaseTeamworkURL,"getVisitStock")
    
    public static let kWSUrlUpdateVisitTertiary = String.init(format: "%@%@",kBaseTeamworkURL,"updateVisitTertiary")
    
    public static let kWSUrlUpdateVisitStock = String.init(format: "%@%@",kBaseTeamworkURL,"updateVisitStock")
    
    public static let kWSUrlUpdateCustAddress = String.init(format: "%@%@",kBaseURL,"updateCustAddress")
    
    
    public static let kWSUrlDeleteCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"deleteCheckIn")
    
    public static let kWSUrlUpdateCheckIn = String.init(format: "%@%@",kBaseTeamworkURL,"updateCheckIn")
    
    public static let kWSUrlVisitCheckInSendApproval = String.init(format: "%@%@",kBaseTeamworkURL,"visitCheckInSendApproval")
    
    public static let kWSUrlGetApprove = String.init(format: "%@%@",kBaseTeamworkURL,"approveEvent")
    
    public static let kWSUrlAddEditPlannedVisitForMultipleCustomer = String.init(format: "%@%@",kBaseTeamworkURL,"addMultipleVisitsForCustomerList")
    
    public static let kWSUrlUpdateVisitStatus = String.init(format: "%@%@",kBaseTeamworkURL,"updateVisitStatus")
    //updateVisitStatus
    public static let kWSUrlUploadVisitImage = String.init(format: "%@%@",kBaseTeamworkURL,"uploadVisitImage")
    
    public static let kWSUrlForOTPToCloseVisit  = String.init(format: "%@%@",kBaseTeamworkURL,"getVisitReportOtpByVisitAndUserID")
    
    public static let kWSUrlCloseVisit = String.init(format: "%@%@",kBaseTeamworkURL,"closeVisit")
    
    public static let kWSUrlAssignedVisit = String.init(format: "%@%@",kBaseTeamworkURL,"assignedVisit")
    
    //upload image in shelspace
    public static let kWSUrlUploadImage = String.init(format: "%@%@",kBaseTeamworkURL,"uploadImageViaIos")
    //
    public static let kWSUrlUploadImageEditCustomer = String.init(format: "%@%@",kBaseURL,"uploadLogo")
    //uploadImageViaIos
    //visit collection
    public static let  kWSUrlAddUpdateVisitCollection = String.init(format: "%@%@",kBaseTeamworkURL,"addUpdateVisitCollection")   
    
    //view company stock
    public static let  kWSUrlViewCompanyStock = String.init(format: "%@%@",kBaseTeamworkURL,"viewCompanyStock")
    
    public static let  kWSUrlGetVisitUploadImages = String.init(format: "%@%@",kBaseTeamworkURL,"getVisitUploadImages")
    
    public static let  kWSUrlGetUserFeedback = String.init(format: "%@%@",kBaseURL,"getUserFeedback")
    
    public static let  kWSUrlGetQuestionList = String.init(format: "%@%@",kBaseURL,"getQuestionList")
    
    public static let  kWSUrlAddUpdateAnswer = String.init(format: "%@%@",kBaseURL,"addUpdateAnswer")
    
    //store check
    public static let  kWSUrlGetStoreCheckData = String.init(format: "%@%@",kBaseTeamworkURL,"getStoreCheckData")
    
    public static let  kWSUrlSaveBrandActivity = String.init(format: "%@%@",kBaseTeamworkURL,"saveBrandActivity")
    
    public static let  kWSUrlSaveAssignActivityCompetition = String.init(format: "%@%@",kBaseTeamworkURL,"saveAssignActivityCompetition")
    
    public static let  kWSUrlUpdateVisitCounterShare = String.init(format: "%@%@",kBaseTeamworkURL,"updateVisitCounterShare")
    public static let  kWSUrlAddVisitCounterShare = String.init(format: "%@%@",kBaseTeamworkURL,"addVisitCounterShare")
    
    public static let kwsurlgetCompetitionList = String.init(format:"%@%@",kBaseTeamworkURL,"getStoreCompetitionList")
    
    
    public static let  kWSUrlSetDefaultSetting = String.init(format:"%@%@",kBaseTeamworkURL,"setDefaultSettings")
    
    
    // #define kWSUrlGetUserFeedback                           kBaseURL@"getUserFeedback"
    //       #define kWSUrlGetQuestionList                           kBaseURL@"getQuestionList"
    //       #define kWSUrlAddUpdateAnswer                           kBaseURL@"addUpdateAnswer"
    //    
    
    //     #define kWSUrlViewCompanyStock                          kBaseTeamworkURL@"viewCompanyStock"
    //MARAK: Beatplan
    
    //    #define kWSUrlGetUploadBeatPlanDetails                  kBaseTeamworkURL@"getUploadBeatPlanDetails"
    //    #define kWSUrlGetBeatPlanDetails                        kBaseTeamworkURL@"getAssignBeatPlanDetails"
    //    #define kWSUrlAssignedBeatPlan                          kBaseTeamworkURL@"assignBeatPlanRequest"
    //#define kWSUrlGetBeatPlanDetails kBaseTeamworkURL @"getBeatPlanDetails"assignBeatPlanRequest
    
    
    /*  #define kWSUrlAddManualVisit                            kBaseTeamworkURL@"addManualVisit"
     #define kWSUrlGetJointVisitList                         kBaseTeamworkURL@"getJointVisitList"
     #define kWSUrlDeleteJointVisit                          kBaseTeamworkURL@"deleteJointVisit"
     #define kWSUrlAddJointVisit                             kBaseTeamworkURL@"addJointVisit"*/
    
    
    //MARK: - Unplanvisit
    // for create customer to customer
    public static let kWSUrlAddTempCustomerProfile  = String.init(format: "%@%@",kBaseTeamworkURL,"addTempCustomerProfile")
    
    // for edit customer
    public static let kWSUrlUpdateTempCustomerProfile   = String.init(format: "%@%@",kBaseTeamworkURL,"kWSUrlUpdateTempCustomerProfile")
    
    // MARK: Activity
    // kWSUrlGetActivityType
    /*  #define kWSUrlGetActivityType                           kBaseTeamworkURL@"getActivityType"
     #define kWSUrlAddEditActivity                           kBaseTeamworkURL@"addEditActivity"
     #define kWSUrlGetPlannedActivity                        kBaseTeamworkURL@"getPlannedActivity"
     #define kWSUrlActivityCheckIn                           kBaseTeamworkURL@"activityCheckIn"
     #define kWSUrlActivityCheckOut                          kBaseTeamworkURL@"activityCheckOut"
     #define kWSUrlUpdateActivityStatus                      kBaseTeamworkURL@"updateActivityStatus"
     #define kWSUrlDeleteActivity                            kBaseTeamworkURL@"deleteActivity"
     #define kWSUrlGetActivityfollowups                      kBaseTeamworkURL@"getActivityfollowups"
     */
    public static let kWSUrlGetActivityType   = String.init(format: "%@%@",kBaseTeamworkURL,"getActivityType")
    
    public static let kWSUrlAddEditActivity   = String.init(format: "%@%@",kBaseTeamworkURL,"addEditActivity")
    
    public static let kWSUrlGetPlannedActivity    = String.init(format: "%@%@",kBaseTeamworkURL,"getPlannedActivity")
    
    public static let kWSUrlActivityCheckIn    = String.init(format: "%@%@",kBaseTeamworkURL,"activityCheckIn")
    
    public static let kWSUrlActivityCheckOut    = String.init(format: "%@%@",kBaseTeamworkURL,"activityCheckOut")
    
    public static let kWSUrlUpdateActivityStatus    = String.init(format: "%@%@",kBaseTeamworkURL,"updateActivityStatus")
    
    public static let kWSUrlDeleteActivity    = String.init(format: "%@%@",kBaseTeamworkURL,"deleteActivity")
    
    public static let kWSUrlGetActivityfollowups     = String.init(format: "%@%@",kBaseTeamworkURL,"getActivityfollowups")
    
    // MARK: SalesPlan
    // Sales Plan
    public static let kWSUrlGetLeadFollowUps = String.init(format: "%@%@",kBaseTeamworkURL,"getleadfollowups")
    
    //#define kWSUrlGetCollectionList                         kBaseTeamworkURL@"getcollectionlist"
    public static let kWSUrlGetCollectionList = String.init(format: "%@%@",kBaseTeamworkURL,"getvisitcollectionlist")
    // Getting Visit Collection
    
    public static let kWSUrlGetColdCallReminders = String.init(format: "%@%@",kBaseTeamworkURL,"getcoldcallreminders")
    
    public static let kWSUrlGetVisitFollowUps = String.init(format: "%@%@",kBaseTeamworkURL,"getVisitfollowups")
    
    public static let kWSUrlGetDailyPlan = String.init(format: "%@%@",kBaseTeamworkURL,"getDailySalesPlan")
    
    public static let kWSUrlGetBeatplanFollowupForSalesPlan = String.init(format: "%@%@",kBaseTeamworkURL,"getBeatPlanfollowups")
    
    public static let kWSUrlgetLowerHeirarchy = String.init(format: "%@%@",kBaseTeamworkURL,"getLowerHeirarchy")
    
    public static let kWSUrlApproveChangeMobile = String.init(format: "%@%@",kBaseURL,"approveChangeMobile")
    
    public static let kWSUrlResetPassword = String.init(format: "%@%@",kBaseURL,"resetPassword")
    
    //   #define kWSUrlGetManagerHierarchy                       kBaseURL@"getManagerHierarchy"
    public static let kWSUrlGetManagerHierarchy = String.init(format: "%@%@",kBaseURL,"getManagerHierarchy")
    
    public static let kWSUrlVerifyMobile = String.init(format: "%@%@",kBaseURL,"verifyChangeMobileNo")
    
    public static let kWSUrlCancelMobile = String.init(format: "%@%@",kBaseURL,"cancelChangeMobile")
    
    public static let kWSUrlResendOTP = String.init(format: "%@%@",kBaseURL,"generateOtp")
    

    
    public static let kWSChangeMobileNo = String.init(format: "%@%@",kBaseURL,"changeMobileNo")
    
    public static let kWSUrlAddContact = String.init(format: "%@%@",kBaseURL,"addContact")
    
    public static let kWSUrlEditContact = String.init(format: "%@%@",kBaseURL,"updateContact")
    
    public static let kWSUrlAcceptRejectResignation = String.init(format: "%@%@",kBaseURL,"acceptRejectResignation")
    
    public static let kWSUrlViewCustomerUpdates = String.init(format: "%@%@",kBaseURL,"viewCustomerUpdates")
    
    public static let kWSUrlAcceptUpdateCustomer = String.init(format: "%@%@",kBaseURL,"acceptUpdateCustomer")
    
    // MARK: Location
    public static let kWSUrlGetLocation = String.init(format: "%@%@",kBaseTeamworkURL,"getUserLocations")
    
    public static let kWSUrlUpdateCurrentUserLocation = String.init(format: "%@%@",kBaseTeamworkURL,"updateLocationOfUser")
    
    // MARK: User
    
    
    public static let  kWSUrlChangePassword  = String.init(format: "%@%@",kBaseURL,"changePassword")
    
    public static let kWSUrlUpdateUser = String.init(format: "%@%@",kBaseURL,"updateUserFromApp")//updateUser
    
    public static let kWSUrlUploadLogo = String.init(format: "%@%@",kBaseURL,"uploadLogo")
    
    
    public static let kWSUrlUploadAttachment = String.init(format: "%@%@",kBaseURL,"uploadAttachment")
    
    public static let kWSUrlGetCustomers = String.init(format: "%@%@",kBaseURL,"getCustomers")
    
    public static let kWSUrlGenerateCustomerOTP   = String.init(format: "%@%@",kBaseURL,"generateCustomerOTP")
    
    // MARK: Dashboard
    public static let kWSUrlGetVisitReportForDay = String.init(format: "%@%@",kBaseTeamworkURL,"getvisitreportforday")
    
    //  public static let kWSUrlGetActivityfollowups = String.init(format: "%@%@",kBaseTeamworkURL,"getActivityfollowups")
    
    
    
    public static let kWSUrlGetLeadReportForDay = String.init(format: "%@%@",kBaseTeamworkURL,"getleadreportforday")
    
    public static let kWSUrlGetOrderReportForDay = String.init(format: "%@%@",kBaseTeamworkURL,"getorderreportforday")
    
    public static let kWSUrlGetDailyReport = String.init(format: "%@%@",kBaseTeamworkURL,"getdailyreport")
    
    
    
    // MARK: Promotion
    
    public static let KWSUrlAvailablePromotionList = String.init(format: "%@%@",kBaseTeamworkURL,"getCustomerApplicablePromotionList")
    
    public static let KWSUrlAvailableEntitlementList = String.init(format: "%@%@",kBaseTeamworkURL,"getPendingEntitlementList")
    
    public static let kWSUrlGetJustificationList = String.init(format: "%@%@",kBaseTeamworkURL,"getCompanyJustificationList")
    
    public static let KWSUrlJointPromotion = String.init(format: "%@%@",kBaseTeamworkURL,"joinPromotion")
    
    public static let KWSUrlGetProductDriveList = String.init(format: "%@%@",kBaseTeamworkURL,"getProductsForDrive")
    
    public static let KWSUrlGetsuggestedQTyMultiple = String.init(format: "%@%@",kBaseTeamworkURL,"suggestOrderQtyMultiple")
    
    public static let kWSUrlGetShelfSpaceList1 = String.init(format: "%@%@",kBaseTeamworkURL,"getShelfSpaceList")
    
    public static let kWSUrlGetPositionList = String.init(format: "%@%@",kBaseTeamworkURL,"getPositionList")
    
    public static let kWSUrlAddShelfSpace = String.init(format: "%@%@",kBaseTeamworkURL,"addEditShelfSpace")
    
    public static let kWSUrlForEntitlementStatus = String.init(format: "%@%@",kBaseTeamworkURL,"changeEntitlementReceivedStatus")
    
    public static let kWSUrlForSendOTP = String.init(format: "%@%@",kBaseURL,"sendOTPToCustomer")
    
    public static let kWSUrlForVerifyOTP = String.init(format: "%@%@",kBaseURL,"verifyCustomerOTP")
    
    
    // MARK: - Beatplan
    
    
    //     public static let kWSUrlAssignedBeatPlan   = String.init(format: "%@%@",kBaseTeamworkURL,"assignBeatPlanRequest")
    
    public static let kWSUrlGetAsignedBeatPlanList   = String.init(format: "%@%@",kBaseTeamworkURL,"getAssigneeBeatPlanDetails")
    
    public static let kWSUrlGetUploadBeatPlanDetails = String.init(format: "%@%@",kBaseTeamworkURL,"getUploadBeatPlanDetails")
    
    //getAssigneeBeatPlanDetails   //getAssignBeatPlanDetails
    public static let kWSUrlDeleteBeatPlan = String.init(format: "%@%@",kBaseTeamworkURL,"deleteBeatPlanRequest")
    
    public static let kWSUrlEditBeatPlanList = String.init(format: "%@%@",kBaseTeamworkURL,"assignBeatPlanRequest")
    
    public static let kWSUrlForIndividiualBeatDetail = String.init(format: "%@%@",kBaseTeamworkURL,"getBeatPlanDetails")
    
    
    public static let kWSUrlVerifyAddressLatLong = String.init(format: "%@%@",kBaseURL,"verifyAddressLatLong")
    
    public static let kWSUrlGetMissedData = String.init(format: "%@%@",kBaseURL,"getMissedData")
    
    public static let kWSUrlGetSuperSalesNotifications = String.init(format: "%@%@",kBaseURL,"getSuperSalesNotifications")
    
    public static let kWSUrlGetSuperSalesApprovalNotifications = String.init(format: "%@%@",kBaseURL,"getSuperSalesApprovalNotifications")
    
    public static let kWSUrlGetCustomerHistoryReport = String.init(format: "%@%@",kBaseTeamworkURL,"getcustomerhistoryreport")
    
    
    public static let commonview = UIApplication.shared.keyWindow?.rootViewController?.view
    
    static let addsalesorder                = "addsalesorder"
    static let delsalesorder                = "delsalesorder"
    static let generateSOPDF                = "generateSalesOrderPDF"
    static let suggestOrderQtyMultiple      = "suggestOrderQtyMultiple"
    static let getProductsForDrive          = "getProductsForDrive"
    static let viewCompanyStock             = "viewCompanyStock"
    static let getSalesOrderClose           = "getSalesOrderClose"
    static let closesalesorder              = "closesalesorder"
    static let getApplicablePromotionList   = "getApplicablePromotionList"
    
    static let approveRejectSalesOrder      = "approveRejectSalesOrder"
    static let approveRejectEditSalesOrder  = "approveRejectEditSalesOrder"
    static let assignedSalesOrder           = "assignsalesorder"
    static let updateVisitStock             = "updateVisitStock"
    
    //shelf space
    static let getVisitCustomForm           = "getVisitCustomForm"
    static let getUserTimingInfo           = "getUserTimingInfo"
    static let getCompanyLeaves = "getCompanyLeaves"
    static let getCompanyHolidays = "getCompanyHolidays"
    //  #define kWSUrlUplloadImageInSpace @"uploadImage"
    
    //   #define kWSUrlDeleteLogo                                kBaseURL@"deleteLogo"
    
    
    // #define kWSUrlDeletePicture                             kBaseURL@"deletePicture"
    //#define kWSUrlGetCompany                                kBaseURL@"getCompany"
    // #define kWSUrlGetRoleUser                               kBaseURL@"getRoleUser"
    //  #define kWSUrlUpdateUserRole                            kBaseURL@"updateUserRole"
    //   #define kWSUrlGetUser                                   kBaseURL@"getUser"
    //  #define kWSUrlResign                                    kBaseURL@"resign"
    //    #define kWSUrlResetPasswordForMember                    kBaseURL@"resetPasswordForMember"
    //   #define kWSUrlAddUser                                   kBaseURL@"addUser"
    
    //   #define kWSUrlEditContact                               kBaseURL@"updateContact"
    
    //  #define kWSUrlGetCheckInCheckOutDetails                 kBaseTeamworkURL@"getCheckInOutDetails"
    //   #define kWSUrlGetTravelCheckInCheckOutDetails           kBaseTeamworkURL@"getTravelCheckInOutDetails"
    
    
    
    //  #define kWSUrlCancelInvite                              kBaseURL@"cancelInvite"
    //  #define kWSUrlAddCompany                                kBaseURL@"addCompany"
    
    
    
    
    // #define kWSUrlGetCheckInCheckOutDetails                 kBaseTeamworkURL@"getCheckInOutDetails"
    
    
    
    
    
    
    
    
    //    #define kWSUrlCreateUser                                kBaseURL@"createUser"
    //
    //    #define kWSUrlGetRoleUser                               kBaseURL@"getRoleUser"
    
    
    //  #define kWSUrlGetUser                                   kBaseURL@"getUser"
    
    
    //Added By Vishal
    
    
    
    
    // DashBoard
    
    
    // Sales Plan
    
    //#define kWSUrlGetCollectionList                         kBaseTeamworkURL@"getcollectionlist"
    
    
    
    
    
    // Lead
    //  #define kWSUrlGetLeadsHistory                           kBaseTeamworkURL@"getleadshistory"
    //   #define kWSUrlGetLeads                                  kBaseTeamworkURL@"getleads"
    
    
    
    
    // Visit
    //  #define kWSUrlGetPlannedVisits                          kBaseTeamworkURL@"getPlannedVisits"
    
    
    
    
    
    
    
    
    
    
    
    //promotion
    
    
    
    //productDrive
    
    
    
    //Beat plan  getAssigneeBeatPlanDetails
    
    
    
    
    // Address
    
    
    
    
    //#define kWSUrlGetMissedNotificationData                 kBaseTeamworkURL@"getMissedNotificationData"
    
    
    
    /*   #define kWSUrlAddUpdateVisitCollection                  kBaseTeamworkURL@"addUpdateVisitCollection"
     #define kWSUrlAddVisitCounterShare                      kBaseTeamworkURL@"addVisitCounterShare"
     #define kWSUrlAddTempCustomerProfile                    kBaseTeamworkURL@"addTempCustomerProfile"
     #define kWSUrlUpdateTempCustomerProfile                 kBaseTeamworkURL@"updateTempCustomerProfile"
     #define kWSUrlUpdateVisitCounterShare                   kBaseTeamworkURL@"updateVisitCounterShare"
     #define kWSUrlGetCustomerCounterShareLastDetails       kBaseTeamworkURL@"getCustomerCounterShareLastDetails"
     
     #define kWSUrlGetJointVisitsForManagerLogin             kBaseTeamworkURL@"getJointVisitsForManagerLogin"
     #define kWSUrlUpdateVisitStatus                         kBaseTeamworkURL@"updateVisitStatus"
     #define kWSUrlGetVisitUploadImages                      kBaseTeamworkURL@"getVisitUploadImages"
     #define kWSUrlUploadVisitImage                          kBaseTeamworkURL@"uploadVisitImage"
     #define kWSUrlCloseVisit                                kBaseTeamworkURL@"closeVisit"
     #define kWSUrlAssignedVisit                             kBaseTeamworkURL@"assignedVisit"
     #define kWSUrlGetStepVisitList                          kBaseTeamworkURL@"getStepVisitList"
     
     
     // Settings
     
     
     
     // Fetch User List
     #define kWSUrlgetLowerHeirarchy                         kBaseTeamworkURL@"getLowerHeirarchy"
     
     // Fetch Customers
     #define kWSUrlGetTaggedCustomersDetails                 kBaseURL@"getTaggedCustomersDetails"
     
     // Fetch Contacts
     #define kWSUrlGetAllContact                             kBaseURL@"getAllContact"
     #define kWSUrlAddLoginDetails                           kBaseURL@"addLoginDetails"
     
     // Feedback
     #define kWSUrlGetUserFeedback                           kBaseURL@"getUserFeedback"
     #define kWSUrlGetQuestionList                           kBaseURL@"getQuestionList"
     #define kWSUrlAddUpdateAnswer                           kBaseURL@"addUpdateAnswer"
     
     // Proposals
     #define kWSURLGetSyncProposals                          kBaseTeamworkURL@"getsyncproposals"
     #define kWSURLDelProposal                               kBaseTeamworkURL@"delproposal"
     #define kWSURLAddProposal                               kBaseTeamworkURL@"addproposal"
     #define kWSUrlAssignedProposal                          kBaseTeamworkURL@"assignproposal"
     #define kWSUrlApproveRejectProposal                     kBaseTeamworkURL@"approveRejectProposal"
     #define kWSUrlGetProposals                     kBaseTeamworkURL@"getproposals"
     
     // Orders
     #define kWSURLGetSyncSalesOrders                        kBaseTeamworkURL@"getsyncsalesorders"
     #define kWSURLGetSalesOrderClose                        kBaseTeamworkURL@"getSalesOrderClose"
     #define kWSURLDelSalesOrder                             kBaseTeamworkURL@"delsalesorder"
     #define kWSURLAddSalesOrder                             kBaseTeamworkURL@"addsalesorder"
     #define kWSUrlAssignedSalesOrder                        kBaseTeamworkURL@"assignsalesorder"
     #define kWSUrlCloseSalesOrder                           kBaseTeamworkURL@"closesalesorder"
     #define kWSUrlApproveRejectSalesOrder                   kBaseTeamworkURL@"approveRejectSalesOrder"
     #define kWSUrlApproveRejectEditSalesOrder               kBaseTeamworkURL@"approveRejectEditSalesOrder"
     #define kWSUrlGenerateSalesOrderPDF                     kBaseTeamworkURL@"generateSalesOrderPDF"
     #define kWSUrlGetSalesOrders                            kBaseTeamworkURL@"getsalesorders"
     #define kWSUrlGetApplicablePromotionList                kBaseTeamworkURL@"getApplicablePromotionList"
     
     // Purchase Orders
     #define kWSURLGetPurchaseOrderClose                     kBaseTeamworkURL@"getPurchaseOrderClose"
     #define kWSURLGetSyncPurchaseOrder                      kBaseTeamworkURL@"getSyncPurchaseOrder"
     #define kWSURLDelPurchaseOrder                          kBaseTeamworkURL@"delPurchaseOrder"
     
     // Knowledge Center
     #define kWSUrlGetCategoryList                           kBaseURL@"getCategoryList"
     #define kWSUrlGetDocumentList                           kBaseURL@"getDocumentList"
     #define kWSUrlGetAllDocumentList                        kBaseURL@"getAllDocumentList"
     #define kWSUrlGetQuizResult                             kBaseURL@"getQuizResult"
     #define kWSUrlGetUserDocumentViewList                   kBaseURL@"getUserDocumentViewList"
     #define kWSUrlQuizStartStatus                           kBaseURL@"quizStartStatus"
     #define kWSUrlGetQuizQuestionList                       kBaseURL@"getQuizQuestionList"
     #define kWSUrlAddQuizAnswer                             kBaseURL@"addQuizAnswer"
     #define kWSUrlAddDocumentViewStatus                     kBaseURL@"addDocumentViewStatus"
     
     // Locate Customer
     #define kWSUrlGetAreaCustomers                          kBaseURL@"getAreaCustomers"
     #define kWSUrlGetCityCustomers                          kBaseURL@"getCityCustomers"
     #define kWSUrlGetCustomersNearMe                        kBaseURL@"getCustomersNearMe"
     #define kWSUrlUpdateCustomerAddress                     kBaseURL@"updateCustomerAddress"
     
     // Reports
     #define kWSURLGenerateExpenseReportForDates             kBaseURL@"generateExpenseReportForDates"
     #define kWSURLGenerateQuizReport                        kBaseURL@"generateQuizReport"
     #define kWSURLGenerateCustomerVendorReport              kBaseURL@"generateCustomerVendorDetailsReport"
     #define kWSURLGenerateFeedbackReport                    kBaseURL@"generateFeedbackReport"
     #define kWSURLGenerateExcelReport                       kBaseTeamworkURL@"generateExcelReport"
     
     // Attendance
     #define kWSUrlGetAttendanceDetails                      kBaseTeamworkURL@"getAttendanceDetails"
     
     
     
     // Activity
     #define kWSUrlGetActivityType                           kBaseTeamworkURL@"getActivityType"
     #define kWSUrlAddEditActivity                           kBaseTeamworkURL@"addEditActivity"
     #define kWSUrlGetPlannedActivity                        kBaseTeamworkURL@"getPlannedActivity"
     #define kWSUrlActivityCheckIn                           kBaseTeamworkURL@"activityCheckIn"
     #define kWSUrlActivityCheckOut                          kBaseTeamworkURL@"activityCheckOut"
     #define kWSUrlUpdateActivityStatus                      kBaseTeamworkURL@"updateActivityStatus"
     #define kWSUrlDeleteActivity                            kBaseTeamworkURL@"deleteActivity"
     #define kWSUrlGetActivityfollowups                      kBaseTeamworkURL@"getActivityfollowups"
     
     // Beat Plan
     #define kWSUrlGetUploadBeatPlanDetails                  kBaseTeamworkURL@"getUploadBeatPlanDetails"
     #define kWSUrlGetBeatPlanDetails                        kBaseTeamworkURL@"getAssignBeatPlanDetails"
     #define kWSUrlAssignedBeatPlan                          kBaseTeamworkURL@"assignBeatPlanRequest"
     //#define kWSUrlGetBeatPlanDetails kBaseTeamworkURL @"getBeatPlanDetails"assignBeatPlanRequest
     
     //Territory
     #define kWSUrlGetTerritory kBaseURL@"getAllLowerHierarchyTerritoryListOfUser"
     
     // Get Customer History
     #define kWSUrlGetCustomerHistoryReport                  kBaseTeamworkURL@"getcustomerhistoryreport"
     #define kWSUrlSearchTown                                kBaseURL@"searchTown"
     
     // Get All Menu List
     #define kWSUrlGetCompanyMenuSettings                    kBaseTeamworkURL@"getUserDisplayMenuAndTabSettings"
     
     // Get Vat Code List
     #define kWSUrlGetMetadataVATCodes                       kBaseURL@"getMetadataVATCodes"
     
     // GET KPI Data
     #define kWSUrlGetSplashScreenData                       kBaseTeamworkURL@"getSplashScreenData"
     #define kWSUrlViewCompanyStock                          kBaseTeamworkURL@"viewCompanyStock"
     
     // GET Store Check Data
     #define kWSUrlGetStoreCheckData                         kBaseTeamworkURL@"getStoreCheckData"
     
     #define kWSUrlSaveBrandActivity                         kBaseTeamworkURL@"saveBrandActivity"
     #define kWSUrlSaveAssignActivityCompetition             kBaseTeamworkURL@"saveAssignActivityCompetition"
     #define kWSUrlGetShelfSpaceList                         kBaseTeamworkURL@"getShelfSpaceList"
     #define kWSUrlUploadImage                               kBaseTeamworkURL@"uploadImage"
     
     #define kWSURLGetCompanyInfo                            kBaseTeamworkURL@"getAttendanceCompanyInfo"
     #define kWSUrlAddPicture                                kBaseURL@"addPicture"
     #define kWSUrlGetCustomers                              kBaseURL@"getCustomers"
     #define kWSUrlGetVendors                                kBaseURL@"getVendors"
     #define kWSUrlChangePassword                            kBaseURL@"changePassword"
     #define kWSUrlLogout                                    kBaseURL@"logout"
     #define kWSUrlUpdateCompany                             kBaseURL@"updateCompany"
     #define kWSUrlUpdateCompanyinfo                         kBaseTeamworkURL@"updateCompanyInfo"
     #define kWSUrlGetPrivileges                             kBaseTeamworkURL@"getPrivileges"
     #define kWSUrlGetCompanyUsers                           kBaseURL@"getCompanyUsersList"
     #define kWSUrlGetInvitedUsersList                       kBaseURL@"invitedMembers"
     #define kWSUrlGetManagerHierarchy                       kBaseURL@"getManagerHierarchy"
     #define kWSUrlAddCustomerVendor                         kBaseURL@"addNewCustomerVendor"
     #define kWSUrlVerifyCustomerMobileNo                    kBaseURL@"verifyCustomerMobileNo"
     #define kWSUrlGenerateCustomerOTP                       kBaseURL@"generateCustomerOTP"
     #define kWSUrlTagCustomer                               kBaseURL@"tagCustomer"
     
     #define kWSUrlUpdateCustomerVendor                      kBaseURL@"updateCustomerVendor"
     #define kWSUrlUpdateUserLocation                        kBaseTeamworkURL@"updateUserLocation"
     #define kWSUrlGetSalesCallType                          kBaseTeamworkURL@"getSalesCallType"
     
     #define kWSUrlGetLeadOutCome                            kBaseTeamworkURL@"getleadOutcome"
     #define kWSUrlGetVisitOutcome                           kBaseTeamworkURL@"getvisitOutcome"
     #define kWSUrlGetLeadSource                             kBaseTeamworkURL@"getleadSource"
     
     #define kWSUrlGetServiceComplaintType                   kBaseTeamworkURL@"getServiceComplaintType"
     #define kWSUrlGetServiceOutCome                         kBaseTeamworkURL@"getServiceOutcome"
     #define kWSUrlAddServiceOutCome                         kBaseTeamworkURL@"addServiceOutcome"
     #define kWSUrlAddServiceCallType                        kBaseTeamworkURL@"addServiceComplaintType"
     #define kWSUrlAddSalesCallType                          kBaseTeamworkURL@"addSalesCallType"
     /*  #define kWSUrlAddSalesOutCome                           kBaseTeamworkURL@"addSalesOutcomeType"
     #define kWSUrlAddRolePrivilege                          kBaseTeamworkURL@"addRolePrivilege"*/
     #define kWSUrlSetDefaultSetting                         kBaseTeamworkURL@"setDefaultSettings"
     #define kWSUrlAddUpdateCompanyPayRoll                   kBaseTeamworkURL@"addUpdateCompanyPayroll"
     #define kWSUrlGetCompanyPayRoll                         kBaseTeamworkURL@"getCompanyPayrolls"
     #define kWSUrlGetUserPayRollDetails                     kBaseTeamworkURL@"getUserPayrollDetails"
     #define kWSUrlAddUpdateUserPayroll                      kBaseTeamworkURL@"addUpdateUserPayroll"
     #define kWSUrlAddUpdateCompanyWorkingPolicy             kBaseTeamworkURL@"addUpdateCompanyWorkingPolicy"
     
     
     //   #define kWSUrlgetLowerHeirarchy                         kBaseTeamworkURL@"getLowerHeirarchy"
     */
}
//struct responseModel{
//    func `init`(){
//        
//    }
//}
//#define kWSUrlGetMappedPlannedVisits                    kBaseTeamworkURL@"getMappedPlannedVisits"


struct Constant {
    
    public static let SucessResponseFromServer = "success"
    public static let GOOGLE_MAPS_API_KEY = "AIzaSyBruhtDdaFfPuEPOAJ_1-F1y7_I8lfJn_4"//"AIzaSyBUTpurjAHhgKZIx23z4CKE_0ZolkbPUsw"// "AIzaSyAeLmS0YEqgGth7Ia7XMHjpZdAvIMfWZI4"//"AIzaSyBruhtDdaFfPuEPOAJ_1-F1y7_I8lfJn_4""AIzaSyBUTpurjAHhgKZIx23z4CKE_0ZolkbPUsw"//""
        
        
        
        
        //"AIzaSyDSwR1ffi2RrYgYI_Lkwl2BWB9E9Fy7DMA"
        //"AIzaSyBruhtDdaFfPuEPOAJ_1-F1y7_I8lfJn_4"
    
    
    
    
    
    //"AIzaSyAeLmS0YEqgGth7Ia7XMHjpZdAvIMfWZI4"//"AIzaSyBruhtDdaFfPuEPOAJ_1-F1y7_I8lfJn_4"//
   // let strkey = Utils.getDefaultStringValue(key: <#T##String#>)
    public static let GOOGLE_MAPS_PLACES_API = "AIzaSyDTgp0aSbBRBFrwe4IMTVSNqT18bTAINak"
//    "AIzaSyBUTpurjAHhgKZIx23z4CKE_0ZolkbPUsw"// "AIzaSyAeLmS0YEqgGth7Ia7XMHjpZdAvIMfWZI4"
    // //"AIzaSyBUTpurjAHhgKZIx23z4CKE_0ZolkbPUsw"//""AIzaSyBruhtDdaFfPuEPOAJ_1-F1y7_I8lfJn_4"
        
        
        //"AIzaSyDSwR1ffi2RrYgYI_Lkwl2BWB9E9Fy7DMA" //"AIzaSyBruhtDdaFfPuEPOAJ_1-F1y7_I8lfJn_4"
    
    
    
    
    //"AIzaSyAeLmS0YEqgGth7Ia7XMHjpZdAvIMfWZI4"//"AIzaSyBruhtDdaFfPuEPOAJ_1-F1y7_I8lfJn_4"//
    
    // public static let  IS_OS_8_OR_LATER = (Float(UIDevice.current.systemVersion) >= 8.0) //([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    
    // MARK: storyboard Constant
    public static let StoryboardNameMain =    "Main"
    public static let StoryboardNameVisit  =  "Visit"
    public static let StoryboardNameLead    = "Lead"
    public static let StoryboardNameActivity = "Activity"
    public static let StoryboardNameExpense = "Expense"
    public static let StoryboardNameLeave = "Leave"
    public static let StoryboardNameCustomer    = "Customer"
    public static let StoryboardProposal = "Proposal"
    public static let StoryboardNameOrder = "Order"
    public static let StoryboardNameSalesPaln = "SalesPlan"
    public static let StoryboardNamePopUp = "PopUp"
    public static let StoryboardNamePromotion = "Promotion"
    public static let StoryboardNameBeatPlan = "Beatplan"
    public static let StoryboardNameAttendance = "Attendance"
    public static let StoryboardNameCustomerHistory = "CustomerHistory"
    public static let StoryboardNameKnowledgeCenter = "KnowledgeCenter"
    public static let StoryboardNameReport = "Reports"
    public static let StroryBoardNameSplash = "Splash"
    
    //MARK: Splash
    public static let SplashScreen = "splashviewcontroller"
    
    
    //MARK: Notification
    public static let NotificationContainer = "notificationcontainer"
    public static let NotificationList = "notificationlist"
    public static let NotificationApproval = "notificationapproval"
    
   
    
    // MARK: View
    public static let LoginView = "login"
    public static let DashboardSalesLeadVisitView = "mainviewcontroller"
    public static let DashboardSalesPlan = "salesplanhome"
    // MARK: Dashboard
    public static let DashboardVisit = "dashboardvisit"
    public static let DashboardLead = "dashboardlead"
    public static let DashboardOrder = "dashboardorders"
    public static let PlanList = "salesplanlist"
    public static let DashboardSalesPlanView = "salesplan"
    public static let OrderList = "orders"
    public static let ReportList = "reports"
    public static let AddUnplanVisitView = "addunplanvisit"
    public static let AddplanVisitView = "addplanvisit"
    public static let AddjointVisitView = "addjointvisit"
    public static let VisitListView   = "visitcontainer"
    public static let VisitCustomerProfile = "visitcustomerprofile"
    public static let StoreCheckContainer = "storecheckcontainer"
    public static let StoreCheckBrand = "storecheckbrand"
    public static let StoreCheckCompetition = "storecheckcompetition"
    public static let VisitDetailContainerView   = "visitdetail"
    public static let ViewFeedbackView    = "viewfeedback"
    public static let SendFeedbackView    = "sendfeedback"
    public static let SingleProductSelection = "addproduct"
    public static let MultipleProductSelection = "multipleproductselection"
    public static let PromotionContainerView = "promotioncontainer"
    public static let PromotionListView = "promotionlist"
    public static let PromotionDetail = "promotiondetail"
    public static let VisitDetail = "visitsubdetail"
    public static let VisitReport = "visitreport"
    public static let MapView = "googlemap"
    public static let AddPicture = "addpicture"
    public static let ProductDriveView = "productdrivelistcontroller"
    public static let AddCustomerView = "addcustomer"
    public static let UpdateCustomerPotential = "updatecustomerpotential"
    public static let AddContactView = "addcontact"
    public static let LeadSelectionView = "leadselection"
    public static let VisitSelectionView = "visitselectionviewcontroller"
    // MARK: Expense
    public static let ExpenseContainer = "expensecontainer"
    public static let ExpenseList = "expenselistviewcontroller"
    public static let AddExpense = "addexpenseviewcontroller"
    
    
    // MARK: Leave
    public static let LeaveContainer = "leavecontainer"
    public static let LeaveList = "leavelistviewcontroller"
    public static let Leaves = "leavesviewcontroller"
    public static let LeaveBalanceUpdate = "leavebalanceupdatecontroller"
    public static let ApplyLeave = "applyleavecontroller"
    public static let LeaveDetail = "leavedetailcontroller"
    
    
    // MARK: Knowledge Center
    public static let KnowledgeCenter = "knowledgecenter"
    public static let QuizView = "quizview"
    public static let DownloadController = "downloadcontroller"
    public static let DocumentReport = "documentreport"
    
    
    // MARK: Reports
    public static let ReportSummary = "reportsummary"
    public static let DashboardReportMoment = "drmovement"
    public static let ExcelReport = "excelreport"
    
    public static let DashboardMissedVisit = "drmissedvisit"
    public static let DashboardMissedLead = "drmissedlead"
    public static let DashboardVisitUpdate = "drvisitupdate"
    public static let DashboardReportVisit = "drvisit"
    
    public static let DashboardLeadList = "drleadcreated"
    
    public static let DashboardVisitReportList = "drvisitreport"
    
    public static let DashboardLeadStatusList = "drleadstatus"
    
    public static let DashboardLeadAssign = "drleadassign"
    
    public static let DashboardColdCallList = "drcoldcall"
    
    public static let DashboardProposalList = "drproposal"
    
    public static let DashboardSalesOrderList = "drsalesorder"
    
    // MARK: Proposal
    public static let AddProposal = "addproposal"
    
    // MARK: popup
    public static let MiddlePopup = "productselection"
    public static let CustomPopupView = "custompopupselection"
    public static let FilterPopupView = "filter"
    public static let ChangeCustomerPopup = "changecustomerpopup"
    public static let BeatPlanConatinerview = "beatplancontainerview"
    public static let ProductDetailView =    "productdetailview"
    public static let AssignBeatPlanView =   "assignbeatplan"
    public static let BeatPlanListView =     "beatplanlist"
    public static let BeatPlanListCelander = "beatplanlistcalender"
    public static let BeatPlanDetailView =   "beatplandetail"
    public static let EditAssignBeatPlan =   "editassignbeatplan"
    public static let ShelfSpaceList =       "shelfspacecontroller"
    public static let VisitCollection =      "addvisitcollection"
    public static let VisitCountershare =    "addvisitcountershare"
    public static let VisitUpdateStock =     "updatestock"
    public static let VisitAddStock    =     "addstock"
    public static let ViewCompanyStock =   "viewcompanystock"
    public static let ViewTerritory =      "viewterritory"
    public static let AddTerritory =       "addterritory"
    public static let ViewFeedBack =       "viewfeedback"
    public static let AddFeedback =        "sendfeedback"
    public static let VisitCustomForm =    "VisitCustomForm"

    //MARK: - Activity Constants
    public static let AddActivity =         "addactivity"
    public static let ActivityDetail =      "activitydetail"
    public static let ActivitySubDetail =   "activitysubdetail"
    public static let ActivityReport =      "activityreport"
    public static let ActivityList =        "activitylist"
    public static let AddParticipant =      "addparticipant"
    public static let ViewActivityParticipant = "activityparticipatdisplay"
    //MARK: - Lead Constants
    public static let AddLead = "addlead"
    public static let LeadContainer = "leadcontainer"
    public static let LeadListView = "leadlistview"
    public static let AddLeadCustomerDetail = "leadcustomerdetail"
    public static let LeadSummary = "leadsummary"
    
    public static let AddLeadSoureInfluencer = "leadsourceinfluencer"
    public static let AddLeadProduct = "addleadproduct"
    public static let AddLeadFourthStep = "addleadfourthstep"
    
    public static let LeadListHistoryView = "leadhistoryview"
    public static let LeadDetail = "leaddetail"
    public static let LeadHistoryDetail = "leadhistorydetailviewcontroller"
    public static let LeadSubDetail = "leadsubdetail"
    public static let LeadPastInteraction = "pastinteraction"
    public static let LeadAddPictureStatus = "addpictureleadstatus"
    public static let LeadStatusUpdate = "updateleadstatus"
    public static let UserProfile = "userprofile"
    public static let ChangeMobile = "changemobile"
    public static let YourManagers = "yourmanagers"
    public static let ChangePassword = "changepassword"
    public static let VerifyMobile = "verifymobile"
    public static let ResetPassword = "resetpassword"
    
    // MARK: Customer
    
    public static let CustomerContainer = "customercontainer"
    public static let CustomerList = "customerlist"
    public static let ContactList = "contactlist"
    public static let VendorList = "vendorlist"
    
    // MARK: productselection
    public static let AttendanceContainer = "attendancecontainer"
    
    public static let Attendance = "attendanceviewcontroller"
    
    public static let WorkLocationController = "worklocationcontroller"
    
    
    public static let ValidAttendanceViewController =
    "validattendanceviewcontroller"
    
    public static let AttendanceHistory = "attendancehistoryviewcotnroller"
    
    public static let ApprovalPendingList = "approvalpendinglist"
    
    public static let AttendanceUserHistory = "attendanceuserhistorycontroller1"
    public static let AttendanceSelfHistory = "attendanceuserhistorycontroller"
    
    public static let AttendanceDetail = "attendancedetailviewcontroller"
    public static let AttendanceDetailUpdateRequest  = "attendancedetailupdaterequestview"
    public static let ManualCheckIn = "manualattendancecontroller"
    public static let UpdateAttendanceDetail = "updateattendancecontroller"
    
    public static let Customerhistorysummary = "customerhistorysummary"
    public static let Customerhistory = "customerhistorycontainer"
    public static let Customerhistoryvisit = "customerhistoryvisit"
    public static let Customerhistorysales = "customerhistorysales"
    public static let Customerhistorylead = "customerhistorylead"
    
    // MARK: userdefault key
    public static let kUserShiftTiming = "userShiftTiming"
    public static let kUserDefault = "userdefaultsetting"
    public static let kUserSetting = "usersetting"
    public static let kIsSyncDone = "isSyncDone"
    public static let kCurrentAppVersion = "currentVersion"
    public static let kCurrentUser = "currentuser"
    public static let kSyncTime = "LastSynchTime"
    public static let kNoOfCustomer = "NoOfCustomer"
    public static let kTotalCustomer = "TotalCustomerFromAPI"
    public static let kSettingTypeAndSegment = "SettingTypeAndSegment"
    public static let kNoOFCustomerLimit = 0
    
    // MARK: title for UI
    public static let kPositive = "positive"
    public static let kNegative = "negative"
    public static let kNutral = "nutral"
    //MARK: - notification identifier
    public static let kCurrentDateChange = "currentDateChanged"
    
    // MARK: cell
    public static let LeadListCell = "leadlistcell"
    public static let VisitListCell = "visitcell"
    public static let ActivityCell  = "activitycell"
    public static let ApprovalVisitListCell = "approvalcell"
    public static let JointVisitListCell = "jointvisitcell"
    public static let SalesPlanCell = "salesplancell"
    public static let VisitCollectionCell = "visitcollectioncell"
    
    public static let ReportMomentCell = "salesreportcell"
    
    
    public static let MissedVisitCell = "missedvisitcell"
    public static let LeadReportCell = "leadreportcell"
    public static let CheckinDetailCell = "checkindetailcell"
    public static let BeatplanAssignCell = "beatplanassigncell"
    public static let BeatPlanListCell = "beatplanlistcell"
    public static let ForuLabelVerticalCell = "fourlblvertical"
    public static let AttendaceCell = "attendancecell"
    
    
    //MARK: Leavecell
    public static let LeaveCell = "leavestatuscell"
    
    //MARK: DpcumentReportCell
    public static let DocumentReportCell = "documentreportcell"
    
    //kFontMedium @"Montserrat-Regular"
    public static let CustomerPageSize = NSNumber.init(value: 2500)
    public static let ProductCategoryPageSize = NSNumber.init(value: 1500)
    public static let ProductPageSize = NSNumber.init(value: 1500)
    public static let SOPageSize = NSNumber.init(value: 500)
    //#define SOPageSize              500
}
extension Common{
    
    public static let Encodingversion = 2
    
    
    public static let Screensize = UIScreen.main.bounds
    
    public static let kfontbold = "Montserrat-Bold"
    public static let kFontMedium = "Montserrat-Regular"
    public static let PROMOTION_TYPE_FLAT = "1"
    public static let  PROMOTION_TYPE_BONUS   = "2"
    public static let  LeaveType = ["Sick Leave","Casual Leave","Paid Leave","Optional Leave"]
}
