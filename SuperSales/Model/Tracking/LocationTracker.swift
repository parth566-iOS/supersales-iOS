//
//  LocationTracker.swift
//  SuperSales
//
//  Created by Apple on 07/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTracker: NSObject {
    let locationmanager = CLLocationManager.init()
    
 public static let locationtracker = LocationTracker()
   
    func initLocationTracker(){
        
        locationmanager.distanceFilter = kCLDistanceFilterNone
        locationmanager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationmanager.pausesLocationUpdatesAutomatically = false
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name:UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func applicationEnterBackground(){
        locationmanager.delegate = self
//        if((Common.SYSTEM_VERSION_GREATER_THAN(version:"8.0")) == true){
//            locationmanager.requestAlwaysAuthorization()
//        }
        locationmanager.startUpdatingLocation()
    locationmanager.startMonitoringSignificantLocationChanges()
        locationmanager.pausesLocationUpdatesAutomatically = false
    }
    func startLocationTracking(){
        DispatchQueue.global().async {
            if(CLLocationManager.locationServicesEnabled() == true){
                let authorizationStatus = CLLocationManager.authorizationStatus()
                if((authorizationStatus == CLAuthorizationStatus.denied)||(authorizationStatus == CLAuthorizationStatus.restricted)){
                    print("authorizationStatus failed")
                }else{
                    print("authorizationStatus authorized")
                    self.locationmanager.delegate = self
                    if((Common.SYSTEM_VERSION_GREATER_THAN(version:"8.0")) == true){
                        self.locationmanager.requestAlwaysAuthorization()
                    }
                    self.locationmanager.startUpdatingLocation()
                    self.locationmanager.startMonitoringSignificantLocationChanges()
                    self.locationmanager.pausesLocationUpdatesAutomatically = false
                }
            }else{
                if var topController = UIApplication.shared.windows.first?.rootViewController {
                    if  let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                        Common.showalert(title:"Location Services Disabled" ,msg:"You currently have all location services for this device disabled",view:topController)
                        
                        //     Common.showalert(msg: error?.localizedDescription ?? "",view:topController)
                    }else{
                        Common.showalert(title:"Location Services Disabled" ,msg:"You currently have all location services for this device disabled",view:topController)
                    }
                    
                    // topController should now be your topmost view controller
                }
                //            Common.showalert(title:"Location Services Disabled" ,msg:"You currently have all location services for this device disabled",view:self)
                
            }
        }
        
    }
    func stopLocationTracking(){
       // if(LocationShareModel)
    }
    func updateLocationToServer(){
        
    }
}
extension LocationTracker:CLLocationManagerDelegate{
    
}
