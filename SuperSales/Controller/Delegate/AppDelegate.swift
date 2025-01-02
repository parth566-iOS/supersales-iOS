//
//  AppDelegate.swift
//  SuperSales
//
//  Created by Apple on 26/11/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import DropDown
import FirebaseCrashlytics
import FirebaseCore
import Firebase
import MagicalRecord


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
//    @available(iOS 13.0, *)
//    var osTheme: UIUserInterfaceStyle {
//        return UIScreen.main.traitCollection.userInterfaceStyle
//    }
    let activeAccount  = Utils().getActiveAccount()
    var deviceTokeninApp:String?
    var window: UIWindow?
    var navigationController:UINavigationController!
    var managedcontextobjectappdelegate:NSManagedObjectContext!
    static var totalpushnotificationno = 0
    //Location
    var locationTracker:LocationTracker!
    var locationUpdateTimer:Timer!
    let alertWindow: UIWindow = {
        let win = UIWindow(frame: UIScreen.main.bounds)
        win.windowLevel = UIWindow.Level.alert + 1
        return win
    }()
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let message = url.host?.removingPercentEncoding
        let alertController = UIAlertController(title: "Incoming Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(okAction)
        
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
        return true
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use the Firebase library to configure APIs.
       
        FirebaseApp.configure()
        //        Crashlytics.sharedInstance()
        Crashlytics.crashlytics()
        
        //for keyboard handling
        IQKeyboardManager.shared.enable = true
        
        
        
        //  Crashlytics.sharedInstance().delegate = self
        //Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        if let directoryLocation = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {             print("Documents Directory: \(directoryLocation)Application Support")         }
        if let options = launchOptions {
            // Do your checking on options here
            let locationBool =   options[UIApplication.LaunchOptionsKey.location] as? Bool ?? false
            if(locationBool == true){
                self.initLocationManager()
                locationTracker = LocationTracker.locationtracker
                locationTracker.startLocationTracking()
                UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                locationUpdateTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)//Timer.scheduledTimer(timeInterval: 30.0, target: self, selector:@selector(updateLocation), userInfo: nil, repeats: true)
                RunLoop.current.add(locationUpdateTimer, forMode: .common)
            }
        }else{
            let bgstatus = UIApplication.shared.backgroundRefreshStatus
            if(bgstatus == .denied){
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    if  let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                        Common.showalert(msg: "The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh",view:topController)
                    }else{
                        Common.showalert(msg: "The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh",view:topController)
                    }
                    
                    // topController should now be your topmost view controller
                }
                
                
            }else if(bgstatus == .restricted){
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                   if  let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                        
                        
                        Common.showalert(msg:"The functions of this app are limited because the Background App Refresh is disable.",view:topController)
                   }else{
                    Common.showalert(msg:"The functions of this app are limited because the Background App Refresh is disable.",view:topController)
                   }
                    
                    // topController should now be your topmost view controller
                }
                
            }
            else{
                locationTracker = LocationTracker.locationtracker
                locationTracker.startLocationTracking()
                locationUpdateTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
            }
        }
        
        
        
        //Setup MagicalRecord
        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "SuperSales")
        DropDown.startListeningToKeyboard()
        //setupCoreDataStackWithStoreNamed:@"SuperSales"];
        GMSPlacesClient.provideAPIKey(Constant.GOOGLE_MAPS_PLACES_API)
        GMSServices.provideAPIKey(Constant.GOOGLE_MAPS_API_KEY)
        //self.setScreen()
        
        // Override default font
        UIFont.overrideInitialize()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window!.rootViewController = RootViewController()
        window!.makeKeyAndVisible()
        self.registerNotficationForApplication(application: application)
        //    UIApplication.shared.keyWindow.overrideUserInterfaceStyle = preference == "dark" ? .dark : .light
        return  false
    }
    
    
    
    //        @objc  func splacshScreenDone(){
    ////            splashview.view.removeFromSuperview()
    ////            window!.rootViewController = RootViewController()
    ////            window!.makeKeyAndVisible()
    //
    //        }
    
    @objc  func updateLocation (){
        locationTracker.updateLocationToServer()
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions
        //(such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        //and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kCurrentDateChange), object: nil)
        self.perform(#selector(callWS), with: self, afterDelay: 0.4)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if(Utils.isAppUpdated() == true){
            if(activeAccount?.userID?.intValue ?? 0 > 0){
                self.initLocationManager()
            }else{
                // self.rootViewController.switchToLogout()
            }
        }else{
            //self.rootViewController.switchToLogout()
        }
        if #available(iOS 12.0, *) {
            switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                print("Theme of app is =  light or unspecified")
                
                break
                        // light mode detected
            case .dark:
                
                print("Theme of app is =  =dark ")
                Common.showalert(msg: "We are supporting only light mode", view: UIApplication.shared.keyWindow?.rootViewController ?? UIViewController())
                break
                        // dark mode detected
                }
           
        } else {
            // Fallback on earlier versions
        }
 //       @available(iOS 13.0, *)
//            if let iphonetheme = osTheme{
//                print("theme is = \(iphonetheme)")
//
//        } else {
//            // Fallback on earlier versions
//        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SuperSales")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        managedcontextobjectappdelegate = self.persistentContainer.viewContext
        return container
    }()
    
    // iOS 9 and below
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1])
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "SuperSales", withExtension: "momd")!
        print("url of database = \(modelURL)")
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application.
        //This implementation creates and returns a coordinator, having added the store for the application to it.
        //This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SuperSales.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        print("url of database = \(url)")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            print("url of database = \(url)")
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
        //This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedcontextobjectappdelegate = managedObjectContext
        return managedObjectContext
    }()
    
    //    static func getEntity<T: NSManagedObject>() -> T {
    //        if #available(iOS 10, *) {
    //            let obj = T(context: AppDelegate.context)
    //            return obj
    //        } else {
    //            guard let entityDescription = NSEntityDescription.entity(forEntityName: NSStringFromClass(T.self), in: AppDelegate.context) else {
    //                fatalError("Core Data entity name doesn't match.")
    //            }
    //            let obj = T(entity: entityDescription, insertInto: AppDelegate.context)
    //            return obj
    //        }
    //    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        
        if #available(iOS 10.0, *) {
            
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate.
                    //You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
            } else {
                // iOS 9.0 and below - however you were previously handling it
                if managedObjectContext.hasChanges {
                    do {
                        try managedObjectContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate.
                        //You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                        abort()
                    }
                }
                
            }
        }else{
            
        }
    }
    
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    }
    
    var rootViewController: RootViewController {
        return window!.rootViewController  as? RootViewController ?? RootViewController()
    }
    
    func initLocationManager(){
        // var error  =  Error
    }
    //MARK: - Method
    func checkStatusAndTypeFromNotification(userInfo:Any){
        //            if let topController = UIApplication.shared.keyWindow?.rootViewController {
        //            Common.showalert(msg: "get notfication",view:topController)
        //            }
        if let userinfodic = userInfo as? [String:Any]{
            if(userinfodic.count > 1){
                UIApplication.shared.applicationIconBadgeNumber = 0
                if let type = userinfodic["type"] as? Int{
                    if(type == 15 ){
                        Login().logout()
                    }else if(type  == 53 || type == 47){
                        self.perform(#selector(callgetUser), with: self, afterDelay: 0.6)
                    }else{
                        self.perform(#selector(callWS), with: self, afterDelay: 0.4)
                    }
                }
            }
        }
    }
    
    
    @objc func callWS(){
        ApiHelper().getMissedNotifications { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            print("get missed notification")
        }
    }
    @objc func callgetUser(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 100) {
            ApiHelper().getUser{ _ in
                        print("get user information")
                    }
        }
    }
    
    // MARK: - Push notification
    func registerNotficationForApplication(application:UIApplication)->()
    {
        //  if(application.responds(to: #selector(registerUserNotificationSettings))){
        
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        let usernotiType = (UIUserNotificationType.alert.rawValue | UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue)
        let setting = UIUserNotificationSettings.init(types: UIUserNotificationType(rawValue: usernotiType), categories: nil)
        application.registerUserNotificationSettings(setting)
        application.registerForRemoteNotifications()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        //  }
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("notification registered")
        //        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //        print(deviceTokenString)
    }
    
    private func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
           if  let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                
                Common.showalert(msg: error.localizedDescription,view:topController)
           }else{
            Common.showalert(msg: error.localizedDescription,view:topController)
           }
            
            // topController should now be your topmost view controller
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        deviceTokeninApp =  deviceTokenString
        print("device token = \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("get push notification")
        
        
    }
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("receive notification = \(userInfo)")
        //        if var topController = UIApplication.shared.keyWindow?.rootViewController {
        //       if  let presentedViewController = topController.presentedViewController {
        //                                  topController = presentedViewController
        //
        //        Common.showalert(msg: "receive push notification without completion handler",view:topController)
        //                              }
        //        }
        //        AppDelegate.totalpushnotificationno += 1
        //        if(application.applicationState == .background || application.applicationState == .inactive){
        //            self.checkStatusAndTypeFromNotification(userInfo:userInfo)
        //
        //        }
        //        if var topController = UIApplication.shared.keyWindow?.rootViewController {
        //             if  let presentedViewController = topController.presentedViewController {
        //                                        topController = presentedViewController
        //
        //              Common.showalert(msg: "receive push notification",view:topController)
        //                                    }
        //
        //                                    // topController should now be your topmost view controller
        //                                }
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("get notification")
        
        if(application.applicationState == .background || application.applicationState == .inactive){
            if let user = Utils().getActiveAccount(){
            self.checkStatusAndTypeFromNotification(userInfo:userInfo)
            }
            // completionHandler.(.UIBackgroundFetchResult)
        }else{
            // completionHandler.(.UIBackgroundFetchResult)
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print("Recived: \(userInfo)")
        if let user = Utils().getActiveAccount(){
        completionHandler(.newData)
            }
    }
}
extension AppDelegate:UNUserNotificationCenterDelegate{
    //    @available(iOS 10.0, *)
    //
    //    func userNotificationCenter(_ center: UNUserNotificationCenter,
    //                didReceive response: UNNotificationResponse,
    //                withCompletionHandler completionHandler:
    //                   @escaping () -> Void) {
    //       // Get the meeting ID from the original notification.
    //
    //       let userInfo = response.notification.request.content.userInfo
    //
    //      //  self.checkStatusAndTypeFromNotification(userInfo:userInfo)
    //
    //       // Always call the completion handler when done.
    //       completionHandler()
    //    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("push notfication detail = \(notification.request.content.userInfo)")
        if let user = Utils().getActiveAccount(){
        if let userinfodic = notification.request.content.userInfo as? [String:Any]{
            if(userinfodic.count > 1){
                UIApplication.shared.applicationIconBadgeNumber = 0
               
                if let type = userinfodic["type"] as? Int{
                    print("type is = \(type)")
                  //15, 48, 50, 51, 53, 78, 160, 146, 147, 144, 145, 148, 154, 155,
                    if(type == 6 || type == 126 || type == 53 || type == 107 || type == 48
                    || type == 15 || type == 50 || type == 51 || type == 78 || type == 160 || type == 146 || type == 144 || type == 145 || type == 148 || type == 154 || type == 155){
//                        Login().logout()
                        if let transactionid = userinfodic["transactionID"] as? String{
                            if(transactionid.contains("LUS")){
                                completionHandler(UNNotificationPresentationOptions.alert)
                            }
                        }else  if let data = userinfodic["data"] as? [String:Any] {
                            if(type == 126){
                                if let statusid = data["StatusID"] as? Int{
                                    if(statusid != 6){
                                        completionHandler(UNNotificationPresentationOptions.alert)
                                    }
                                }
                            }else if(type == 128){
                                if let statusid = data["StatusID"] as? Int{
                                    if(statusid != 6){
                                        
                                        completionHandler(UNNotificationPresentationOptions.alert)
                                    }
                                }
                            }else if(type == 142 || type == 143) {
                                if let statusid = data["ManualCheckInStatusID"] as? Int{
                                    if(statusid != 6){
                                        
                                        completionHandler(UNNotificationPresentationOptions.alert)
                                    }else if let statusid = data["ManualCheckOutStatusID"] as? Int{
                                        if(statusid != 6){
                                        completionHandler(UNNotificationPresentationOptions.alert)
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        completionHandler(UNNotificationPresentationOptions.alert)
                    }
                }
            }
        }
        self.checkStatusAndTypeFromNotification(userInfo:notification.request.content.userInfo)
        }
    }
}


//extension AppDelegate: CrashlyticsDelegate {
//
//    
//
//  func crashlyticsDidDetectReport(forLastExecution report: CLSReport, completionHandler: @escaping (Bool) -> Void) {
//    /* ... handle unsent reports */
//  }
//
////  func crashlyticsCanUseBackgroundSessions(_ crashlytics: Crashlytics) -> Bool {
////    return true
////  }
//    
//}
