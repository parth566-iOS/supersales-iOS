//
//  Location.swift
//  SuperSales
//
//  Created by Apple on 06/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CoreLocation
protocol locationUpdater {
    func updatecurrentlocation(location:CLLocation,distance:CLLocationDistance)->()
}
class Location: NSObject {
    var dist:CLLocationDistance! = 0
    var reverseGeocoder:CLGeocoder?
    var location:CLLocation?
    var locationManager:CLLocationManager!
    static var currentLocationcoordinate:CLLocationCoordinate2D?
    static var currentAddress:String!
    var strcurrentLocation:String?
    var currentLocation:CLLocation!
    public static let sharedInsatnce = Location()
    var locationUpdaterDelegate:locationUpdater?
    
    func startLocationManager(){
        locationManager = CLLocationManager.init()
        locationManager?.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        if(locationManager.responds(to: Selector(locationManager.))){
//            locationManager.requestAlwaysAuthorization()
//        }
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopLocationManager(){
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
//        [locationManager stopUpdatingLocation];
//        [locationManager stopMonitoringSignificantLocationChanges];
    }
    
    func getCurrentCoordinate()->CLLocationCoordinate2D?{
        if let currentcoordinate = Location.currentLocationcoordinate{
        return Location.currentLocationcoordinate
        }else{
            return nil
        }
    }
    func getLocation()->CLLocation?{
        if let currentLocation = currentLocation as? CLLocation{
        return currentLocation
        }else{
            return nil
        }
    }
    func updateLocationInMainThread(currentlocation:CLLocation,distance:CLLocationDistance)->(){
        if((self.locationUpdaterDelegate) != nil){
            self.locationUpdaterDelegate?.updatecurrentlocation(location:currentlocation,distance:dist)
        }
    }
    
}
extension Location:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     //   let LLocation = locations.last
        currentLocation = locations.last
       
        Location.currentLocationcoordinate = locations.last?.coordinate
        if(locations.count > 2){
            Location.currentLocationcoordinate = locations.last?.coordinate
            
            
        if let location = locations.last as? CLLocation as? CLLocation{
         if let  lastlocation = locations[locations.count - 1] as? CLLocation{
            dist = lastlocation.distance(from: location)
        }
            }
        self.updateLocationInMainThread(currentlocation: location!, distance: dist)
        }else{
            if let LLocation  = locations.last as? CLLocation as? CLLocation{
            self.updateLocationInMainThread(currentlocation: LLocation, distance: dist)
            }
        }
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        <#code#>
//    }

}
