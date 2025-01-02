//
//  GoogleMap.swift
//  SuperSales
//
//  Created by Apple on 13/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD
import CoreLocation
protocol GoogleMapDelegate {
    func updateAddress(dic:[String:Any])
    func updateAddress(dic:[String:Any],TempaddNo:NSNumber)
}

class GoogleMap: BaseViewController {
    var tempAddNo:NSNumber?
    var delegate:GoogleMapDelegate?
    var firstLocationUpdate:Bool!
    var unplanvisit:UnplannedVisit?
    var planvisit:PlannVisit?
    var objLead:Lead?
    var isFromDashboard:Bool!
    var custname:String!
    var isupdateLocation:Bool?
    var isFromMovementTreport:Bool?
    var isFromAttendance:Bool?
    var isFromAddActivity:Bool?
    var isFromVisitLeadDetail:Bool?
    var isFromColdCall:Bool?
    var isFromDailyReport:Bool?
    var isFromSalesPlan:Bool?
    var isFromApprovalList:Bool?
    var isFromCustomer:Bool?
    var select_date:String!
    var aryDailyReportArray:[Any]!
    var lattitude:NSNumber!
    var longitude:NSNumber!
    var currentLocation:CLLocation!
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var btnUpdateAddress: UIButton!
    
    //For polyline
    
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    
    var selectedRoute: Dictionary<NSObject, AnyObject>!
    
    var overviewPolyline: Dictionary<NSObject, AnyObject>!
    
    var originCoordinate: CLLocationCoordinate2D!
    
    var destinationCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //  mapview.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let path = GMSMutablePath()
        if(isFromDailyReport == true){
            let bounds = GMSCoordinateBounds()
            let path = GMSMutablePath()
            var source = "" , destination = "", waypoints = ""
            if let mutarrfromreport = aryDailyReportArray{
                if(mutarrfromreport.count > 0){
                    for i in 0...aryDailyReportArray.count - 1 {
                        let dailyreport = aryDailyReportArray[i]
                        if(type(of: dailyreport) == PlannVisit.self){
                            let planvisit = dailyreport as? PlannVisit
                            
                            if let checkinlist = VisitCheckInOutList().getVisitCheckInOutUsingDate(visitby: NSNumber.init(value:planvisit?.iD ?? 0), cby: self.select_date.components(separatedBy: " ").first ?? "1"){
                                let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude ?? "0.00") ?? 0.00  , longitude: Double(checkinlist.longitude ?? "0.00") ?? 0.00))
                                print("Record no = \(i), lat = \(checkinlist.lattitude) , long = \(checkinlist.longitude) , cust name = \(checkinlist.customerID)")
                                bounds.contains(marker.position)
                                bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00, longitude: Double(checkinlist.longitude) ?? 0.00))
                                marker.title = planvisit?.customerName
                                marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a")))")
                                let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                mapview.camera = camera
                                marker.map = mapview
                                path.add(marker.position)
                                if(i == 0){
                                    
                                    source = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                }else if(i < aryDailyReportArray.count - 1){
                                    waypoints.append(String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00) \("|") "))
                                }else{
                                    destination = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                    
                                }
                                
                            }
                            
                        }else
                        if(type(of: dailyreport) == Activity.self){
                            if let activity = dailyreport as? Activity{
                                if let checkinlist = ActivityCheckinCheckout.getActivityCheckInOutUsingDate(activityID: NSNumber.init(value:activity.activityId), cby: self.select_date.components(separatedBy: " ").first ?? "1"){
                                    if(i == 0){
                                        source = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                    }else if(i < aryDailyReportArray.count - 1){
                                        waypoints.append(String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00) \("|") "))
                                    }else{
                                        destination = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                    }
                                }
                            }
                        }else if(type(of: dailyreport) ==  Lead.self){
                            if  let lead = dailyreport as? Lead{
                                if let checkinlist = lead.leadCheckInOutList.firstObject as? LeadCheckInOutList{
                                    var marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00  , longitude: Double(checkinlist.longitude) ?? 0.00))
                                    //bounds.insert(contentsOf: [marker.position], at: 0)
                                    //bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
                                    bounds.contains(marker.position)
                                    bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00, longitude: Double(checkinlist.longitude) ?? 0.00))
                                    
                                    marker.title = lead.customerName
                                    marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                    let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                    mapview.camera = camera
                                    marker.map = mapview
                                    path.add(marker.position)
                                    if(i == 0){
                                        source = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
                                    }else if(i < aryDailyReportArray.count - 1){
                                        waypoints.append(String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00) \("|") "))
                                    }else{
                                        destination = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
                                    }
                                }
                            }
                        }else
                        if(type(of: dailyreport) == UnplannedVisit.self){
                            let unplanvisit = dailyreport as? UnplannedVisit
                            
                            if let checkinlist = unplanvisit?.checkInList.first as? CheckInData{
                                var marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude ?? "0.00") ?? 0.00  , longitude: Double(checkinlist.longitude ?? "0.00") ?? 0.00))
                                //bounds.insert(contentsOf: [marker.position], at: 0)
                                //bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
                                bounds.contains(marker.position)
                                bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude ?? "0.00") ?? 0.00, longitude: Double(checkinlist.longitude ?? "0.00") ?? 0.00))
                                marker.title = unplanvisit?.tempCustomerObj?.CustomerName
                                marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                mapview.camera = camera
                                marker.map = mapview
                                path.add(marker.position)
                                if(i == 0){
                                    source = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                }else if(i < aryDailyReportArray.count - 1){
                                    waypoints.append(String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00) \("|") "))
                                }else{
                                    destination = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
                //            if(waypoints.count > 0){
                //                waypoints.substring(to: waypoints.count - 1)
                //            }
                // mapview.animate(to: GMSCameraUpdate.fit(bounds, withPadding: 12.0))
                if(waypoints.count > 0 && waypoints.contains("|")){
                    
                    if(waypoints != ""){
                        //  waypoints = waypoints.substring(to: (waypoints.count - 1))
                        waypoints =  waypoints.filter({ c in
                            c != "|"
                        })
                        waypoints =  ""
                    }
                }
            }
            mapview.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 12.0))
           /* if(((source != "") && (destination != ""))){
                let directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?"
                let directionsUrlString = String.init(format: "\(directionsAPI)&origin=\(source)&destination=\(destination)&waypoints\(waypoints)&sensor=false")
                if let directionsUrl = NSURL.init(string: directionsUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!) as? NSURL{
                    //  let fetchDirectionsTask = URLSession.shared.dataTask(with: directionsUrl) { (data, response, error) in
                    let task = URLSession.shared.dataTask(with: URLRequest.init(url: directionsUrl as URL), completionHandler: {(data, response, error) -> Void in
                        if let data = data {
                            do{
                                if  let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:Any] {
                                    var polyline = GMSPolyline()
                                    let routesArray = json["routes"] as? [[String:Any]]
                                    if(routesArray?.count ?? 0 > 0){
                                        let routedic  = routesArray?.first
                                        let routeOverviewPolyline = routedic? ["overview_polyline"] as? [String:Any]
                                        let points = routeOverviewPolyline?["points"] as? String
                                        print("points = \(points)")
                                        DispatchQueue.main.async{
                                            //   polyline = self.polylineWithEncodedString(encodedstring: points ?? "")
                                            if let pathpoints = points{
                                                let path = GMSPath.init(fromEncodedPath: pathpoints)
                                                polyline =  GMSPolyline(path: path)
                                                polyline.strokeWidth = 2.0
                                                polyline.map =  self.mapview
                                            }
                                        }
                                    }
                                }
                                
                            }catch{
                                
                            }
                        }
                    })
                    task.resume()
                }
            }*/
            
            
            
            
        }else if(isFromSalesPlan == true){
            
            
        }else if(isFromMovementTreport == true){
            
            
            
            
            let bounds = GMSCoordinateBounds()
           
            var source = "" , destination = "", waypoints = ""
            //            aryDailyReportArray
            //            var ready = convertedArray.sorted(by: { $0.compare($1) == .orderedDescending })
            
            
            //aryDailyReportArray.sorted { $0.checkinTime, $1.checkinTime in
            //                $0.checkinTime < $1.checkinTime
            //            }
            
            if let mutarrfromreport = aryDailyReportArray as? [Any]{
                if(mutarrfromreport.count > 0){
                    for i in 0...aryDailyReportArray.count - 1 {
                        let dailyreport = aryDailyReportArray[i]
                        
                        if(type(of: dailyreport) == PlannVisit.self){
                            let planvisit = dailyreport as? PlannVisit
                            
                            if let checkinlist = VisitCheckInOutList().getVisitCheckInOutUsingDate(visitby: NSNumber.init(value:planvisit?.iD ?? 0), cby: self.select_date.components(separatedBy: " ").first ?? "1") as? VisitCheckInOutList{
                                var marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude ?? "0.00") ?? 0.00  , longitude: Double(checkinlist.longitude ?? "0.00") ?? 0.00))
                                //bounds.insert(contentsOf: [marker.position], at: 0)
                                //bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
                                bounds.contains(marker.position)
                                bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00, longitude: Double(checkinlist.longitude) ?? 0.00))
                                marker.title = planvisit?.customerName
                                marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                mapview.camera = camera
                                marker.map = mapview
                                path.add(marker.position)
                                if(i == 0){
                                    source = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                }else if(i < aryDailyReportArray.count - 1){
                                    
                                    waypoints.append(String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00) \("|") "))
                                }else{
                                    destination = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                }
                            }
                        }else if(type(of: dailyreport) == Activity.self){
                            if let activity = dailyreport as? Activity{
                                if let checkinlist = activity.activityCheckInCheckOutList.first as? ActivityCheckInOutModel{
                                    var marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00  , longitude: Double(checkinlist.longitude) ?? 0.00))
                                    //bounds.insert(contentsOf: [marker.position], at: 0)
                                    //bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
                                    bounds.contains(marker.position)
                                    bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00, longitude: Double(checkinlist.longitude) ?? 0.00))
                                    marker.title = activity.activityTypeName
                                    marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                    let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                    mapview.camera = camera
                                    marker.map = mapview
                                    path.add(marker.position)
                                    //drawPolyline(
                                    //                                    if(i == 0){
                                    //                                        source = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
                                    //                                    }else if(i < aryDailyReportArray.count - 1){
                                    //                                        waypoints.append(String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00) \("|") "))
                                    //                                    }else{
                                    //                                        destination = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
                                    //                                    }
                                }
                            }
                        }else if(type(of: dailyreport) ==  Lead.self){
                            let lead = dailyreport as? Lead
                            if let checkinlist = lead?.leadCheckInOutList.firstObject as? LeadCheckInOutList{
                                var marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00  , longitude: Double(checkinlist.longitude) ?? 0.00))
                                //bounds.insert(contentsOf: [marker.position], at: 0)
                                //bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
                                bounds.contains(marker.position)
                                bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00, longitude: Double(checkinlist.longitude) ?? 0.00))
                                marker.title = lead?.customerName
                                marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                mapview.camera = camera
                                marker.map = mapview
                                path.add(marker.position)
                                if(i == 0){
                                    source = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
                                }else if(i < aryDailyReportArray.count - 1){
                                    waypoints.append(String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00) \("|") "))
                                }else{
                                    destination = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
                                }
                            }
                            
                        }
                        else if(type(of: dailyreport) == AttendanceHistory.self){
                            if  let attendanceobject = dailyreport as? AttendanceHistory {
                                
                                //  if let checkinlist = VisitCheckInOutList().getVisitCheckInOutUsingDate(visitby: NSNumber.init(value:planvisit?.iD ?? 0), cby: self.select_date.components(separatedBy: " ").first ?? "1") as? VisitCheckInOutList{
                                var marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(Int(attendanceobject.checkinLattitude) ?? 0) ?? 0.00  , longitude: Double(Int(attendanceobject.checkinLongitude) ?? 0) ?? 0.00))
                                let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                mapview.camera = camera
                                bounds.contains(marker.position)
                                bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: Double(attendanceobject.checkinLattitude) ?? 0.00, longitude: Double(attendanceobject.checkinLongitude) ?? 0.00))
                                if(attendanceobject.checkInAttendanceType > 0){
                                    
                                    if (attendanceobject.checkInAttendanceType == 1){
                                        marker.title  = "Office CheckIn"
                                    }
                                    else if (attendanceobject.checkInAttendanceType == 2){
                                        marker.title  = "Vendor CheckIn"
                                    }
                                    else if (attendanceobject.checkInAttendanceType == 3){
                                        marker.title  = "Customer CheckIn"
                                    }else if (attendanceobject.checkInAttendanceType == 4){
                                        marker.title  = "Travel Local CheckIn"
                                    }
                                    else if (attendanceobject.checkInAttendanceType == 7){
                                        marker.title  = "Travel Upcountry CheckIn"
                                    }
                                    else if (attendanceobject.checkInAttendanceType == 8){
                                        marker.title  = "Home CheckIn"
                                    }            else{
                                        marker.title  = "CheckIn"
                                    }
                                    let dateformateter = DateFormatter()
                                    dateformateter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                    marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: dateformateter.string(from: (attendanceobject.checkInTime ?? Date())), format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                    let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                    mapview.camera = camera
                                }else if(attendanceobject.checkOutAttendanceType > 0){
                                    if (attendanceobject.checkOutAttendanceType == 1){
                                        marker.title  = "Office CheckOut"
                                    }
                                    else if (attendanceobject.checkOutAttendanceType == 2){
                                        marker.title  = "Vendor CheckOut"
                                    }
                                    else if (attendanceobject.checkOutAttendanceType == 3){
                                        marker.title  = "Customer CheckOut"
                                    }else if (attendanceobject.checkOutAttendanceType == 4){
                                        marker.title  = "Travel Local CheckOut"
                                    }
                                    else if (attendanceobject.checkOutAttendanceType == 7){
                                        marker.title  = "Travel Upcountry CheckOut"
                                    }
                                    else if (attendanceobject.checkOutAttendanceType == 8){
                                        marker.title  = "Home CheckOut"
                                    }            else{
                                        marker.title  = "CheckOut"
                                    }
                                    let dateformateter = DateFormatter()
                                    dateformateter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                    let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                    mapview.camera = camera
                                    //   marker.snippet = String.init(format:"Out: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:dateformateter.string(from:  (attendanceobject.checkOutTime ?? Date()) as Date), format: "yyyy/MM/dd HH:mm:ss")) ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                }
                                // marker.title = planvisit?.customerName
                                
                                marker.map = mapview
                                path.add(marker.position)
                                if(i == 0){
                                    source = String.init(format:"\(Double(Int(attendanceobject.checkinLattitude) ?? 0) ?? 0.00 ) , \(Double(Int(attendanceobject.checkinLongitude) ?? 0) ?? 0.00)")
                                }else if(i < aryDailyReportArray.count - 1){
                                    waypoints.append(String.init(format:"\(Double(Int(attendanceobject.checkinLattitude) ?? 0) ?? 0.00 ) , \(Double(Int(attendanceobject.checkinLongitude) ?? 0) ?? 0.00) \("|") "))
                                }else{
                                    destination = String.init(format:"\(Double(Int(attendanceobject.checkinLattitude) ?? 0) ?? 0.00 ) , \(Double(Int(attendanceobject.checkinLongitude)  ?? 0) ?? 0.00)")
                                }
                                
                            }
                            
                        }
                        
                        else if(type(of: dailyreport) == UnplannedVisit.self){
                            if   let unplanvisit = dailyreport as? UnplannedVisit{
                                //   let predicate = NSPredicate.init(format: "visitID = \(unplanvisit?.localID) && checkInTime contains[\(self.select_date)]")
                                //                                let arrOfCheckIn = unplanvisit?.checkInList.allSatisfy({ (predicate) -> Bool in
                                //
                                //                                    return (predicate.visitID ==  unplanvisit?.localID && ((predicate.checkInTime?.contains(self.select_date)) != nil))
                                //                                })
                                let arrOfCheckIn = unplanvisit.checkInList.filter({ (predicate) -> Bool in
                                    if let checkintime = predicate.checkInTime as? String{
                                        return (predicate.visitID ==  unplanvisit.localID && (((checkintime.contains(self.select_date)))))
                                    }else{
                                        return false
                                    }
                                })
                                let arrOfColdCallCheckinVisit = arrOfCheckIn as? [CheckInData]
                                if let checkinlist = arrOfColdCallCheckinVisit?.first as? CheckInData{//VisitCheckInOutList().getVisitCheckInOutUsingDate(visitby: NSNumber.init(value:planvisit?.iD ?? 0), cby: self.select_date.components(separatedBy: " ").first ?? "1") as? VisitCheckInOutList{
                                    let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude ?? "0.00") ?? 0.00  , longitude: Double(checkinlist.longitude ?? "0.00") ?? 0.00))
                                    //bounds.insert(contentsOf: [marker.position], at: 0)
                                    //bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
                                    bounds.contains(marker.position)
                                    bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude ?? "0.00") ?? 0.00, longitude: Double(checkinlist.longitude ?? "0.00") ?? 0.00))
                                    marker.title = unplanvisit.tempCustomerObj?.CustomerName
                                    marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                    let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                    mapview.camera = camera
                                    marker.map = mapview
                                    path.add(marker.position)
                                    if(i == 0){
                                        source = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                    }else if(i < aryDailyReportArray.count - 1){
                                        waypoints.append(String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00) \("|") "))
                                    }else{
                                        destination = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                    }
                                }
                            }
                        }
                        else{
                            if let model = dailyreport as? Movementmodel{
                                
                                let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: CLLocationDegrees(model.checkInLatitude.doubleValue) , longitude: model.checkInLongitude.doubleValue))
                                //bounds.insert(contentsOf: [marker.position], at: 0)
                                //bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
                                let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                mapview.camera = camera
                                marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: model.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                bounds.contains(marker.position)
                                bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: CLLocationDegrees(model.checkInLatitude.doubleValue), longitude: model.checkInLongitude.doubleValue))
                                print("record no = \(i) ,  lat  = \(model.checkInLatitude) , long = \(model.checkInLongitude) , checkin time = \(model.checkInTime)")
                                if(i == 0){
                                    
                                    //                                    let floatlat = model.checkInLatitude.floatValue
                                    //                                    let floatlong = model.checkInLongitude.floatValue.round(6)
                                    //                                    source = String.init(format:"\(floatlat) , \(floatlong)")
                                    source = String.init(format:"%f , %f",model.checkInLatitude.floatValue  ?? 0.00  , model.checkInLongitude.floatValue  ?? 0.00)
                                }else if(i < aryDailyReportArray.count - 1){
                                   // if(waypoints.count < 13){
                                        waypoints.append(String.init(format:"\(model.checkInLatitude.stringValue) , \(model.checkInLongitude.stringValue),\("|")"))
                                  //  }
                                    
                                    
                                    //(!waypoints.contains(model.checkInLatitude.stringValue)) &&
                                    //   waypoints.append(String.init(format:"\(Double(Int(attendanceobject.checkinLattitude) ?? 0) ?? 0.00 ) , \(Double(Int(attendanceobject.checkinLongitude) ?? 0) ?? 0.00) \("|") "))
                                }else{
                                    destination = String.init(format:"\(model.checkInLatitude.stringValue) , \(model.checkInLongitude.stringValue)")
                                    //  destination = String.init(format:"\(Double(Int(attendanceobject.checkinLattitude) ?? 0) ?? 0.00 ) , \(Double(Int(attendanceobject.checkinLongitude)  ?? 0) ?? 0.00)")
                                }
                                
                                if(model.detailType == 1){
                                    if let attendanceobject = model as? Movementmodel{
                                        marker.title  = model.checkInCustomerName
                                        
                                        let dateformateter = DateFormatter()
                                        dateformateter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                        // marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: attendanceobject.checkInTime, format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a")))")
                                        let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                        mapview.camera = camera
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    marker.map = mapview
                                    path.add(marker.position)
                                    //  let attendanceobject = model as? AttendanceHistory
                                    //                                    if(attendanceobject.checkinLattitude ?? 0 > 0 || attendanceobject.checkInLongitude > 0) {
                                    //
                                    ////                                        if (attendanceobject?.checkInAttendanceType == 1){
                                    ////                                         marker.title  = "Office CheckIn"
                                    ////                                         }
                                    ////                                        else if (attendanceobject?.checkInAttendanceType == 2){
                                    ////                                            marker.title  = "Vendor CheckIn"
                                    ////                                         }
                                    ////                                        else if (attendanceobject?.checkInAttendanceType == 3){
                                    ////                                            marker.title  = "Customer CheckIn"
                                    ////                                        }else if (attendanceobject?.checkInAttendanceType == 4){
                                    ////                                            marker.title  = "Travel Local CheckIn"
                                    ////                                         }
                                    ////                                        else if (attendanceobject?.checkInAttendanceType == 7){
                                    ////                                            marker.title  = "Travel Upcountry CheckIn"
                                    ////                                         }
                                    ////                                        else if (attendanceobject?.checkInAttendanceType == 8){
                                    ////                                            marker.title  = "Home CheckIn"
                                    ////                                         }            else{
                                    ////                                            marker.title  = "CheckIn"
                                    ////                                         }
                                    //                                        let dateformateter = DateFormatter()
                                    //                                        dateformateter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                    //                                        marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: dateformateter.string(from: (attendanceobject.checkInTime ?? Date())), format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                    //                                    }else if(attendanceobject.checkOutLatitude > 0 || attendanceobject.checkOutLongitude > 0){
                                    //                                        if (attendanceobject.checkOutAttendanceType == 1){
                                    //                                        marker.title  = "Office CheckOut"
                                    //                                        }
                                    //                                        else if (attendanceobject.checkOutAttendanceType == 2){
                                    //                                           marker.title  = "Vendor CheckOut"
                                    //                                        }
                                    //                                        else if (attendanceobject.checkOutAttendanceType == 3){
                                    //                                           marker.title  = "Customer CheckOut"
                                    //                                        }else if (attendanceobject.checkOutAttendanceType == 4){
                                    //                                           marker.title  = "Travel Local CheckOut"
                                    //                                        }
                                    //                                        else if (attendanceobject.checkOutAttendanceType == 7){
                                    //                                           marker.title  = "Travel Upcountry CheckOut"
                                    //                                        }
                                    //                                        else if (attendanceobject.checkOutAttendanceType == 8){
                                    //                                           marker.title  = "Home CheckOut"
                                    //                                        }            else{
                                    //                                           marker.title  = "CheckOut"
                                    //                                        }
                                    let dateformateter = DateFormatter()
                                    dateformateter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                    //  marker.title = model.
                                    //attendance
                                    if   let  attendanceObj = dailyreport as? AttendanceHistory{
                                        
                                    }
                                    if  let attendanceobject = model as? AttendanceHistory {
                                        //  if let checkinlist = VisitCheckInOutList().getVisitCheckInOutUsingDate(visitby: NSNumber.init(value:planvisit?.iD ?? 0), cby: self.select_date.components(separatedBy: " ").first ?? "1") as? VisitCheckInOutList{
                                        
                                        if(attendanceobject.checkInAttendanceType > 0){
                                            
                                            if (attendanceobject.checkInAttendanceType == 1){
                                                marker.title  = "Office CheckIn"
                                            }
                                            else if (attendanceobject.checkInAttendanceType == 2){
                                                marker.title  = "Vendor CheckIn"
                                            }
                                            else if (attendanceobject.checkInAttendanceType == 3){
                                                marker.title  = "Customer CheckIn"
                                            }else if (attendanceobject.checkInAttendanceType == 4){
                                                marker.title  = "Travel Local CheckIn"
                                            }
                                            else if (attendanceobject.checkInAttendanceType == 7){
                                                marker.title  = "Travel Upcountry CheckIn"
                                            }
                                            else if (attendanceobject.checkInAttendanceType == 8){
                                                marker.title  = "Home CheckIn"
                                            }            else{
                                                marker.title  = "CheckIn"
                                            }
                                            let dateformateter = DateFormatter()
                                            dateformateter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                            marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: dateformateter.string(from: (attendanceobject.checkInTime ?? Date())), format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                            let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                            mapview.camera = camera
                                        }else if(attendanceobject.checkOutAttendanceType > 0){
                                            if (attendanceobject.checkOutAttendanceType == 1){
                                                marker.title  = "Office CheckOut"
                                            }
                                            else if (attendanceobject.checkOutAttendanceType == 2){
                                                marker.title  = "Vendor CheckOut"
                                            }
                                            else if (attendanceobject.checkOutAttendanceType == 3){
                                                marker.title  = "Customer CheckOut"
                                            }else if (attendanceobject.checkOutAttendanceType == 4){
                                                marker.title  = "Travel Local CheckOut"
                                            }
                                            else if (attendanceobject.checkOutAttendanceType == 7){
                                                marker.title  = "Travel Upcountry CheckOut"
                                            }
                                            else if (attendanceobject.checkOutAttendanceType == 8){
                                                marker.title  = "Home CheckOut"
                                            }            else{
                                                marker.title  = "CheckOut"
                                            }
                                            let dateformateter = DateFormatter()
                                            dateformateter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                            let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                            mapview.camera = camera
                                            //   marker.snippet = String.init(format:"Out: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date:dateformateter.string(from:  (attendanceobject.checkOutTime ?? Date()) as Date), format: "yyyy/MM/dd HH:mm:ss")) ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                        }
                                        // marker.title = planvisit?.customerName
                                        
                                        marker.map = mapview
                                        path.add(marker.position)
                                        print("record no = \(i) ,  lat  = \(attendanceobject.checkinLattitude) , long = \(attendanceobject.checkinLongitude)")
                                        if(i == 0){
                                            source = String.init(format:"\(Double(Int(attendanceobject.checkinLattitude) ?? 0) ?? 0.00 ) , \(Double(Int(attendanceobject.checkinLongitude) ?? 0) ?? 0.00)")
                                        }else if(i < aryDailyReportArray.count - 1){
                                            
                                            waypoints.append(String.init(format:"\(Double(Int(attendanceobject.checkinLattitude) ?? 0) ?? 0.00 ) , \(Double(Int(attendanceobject.checkinLongitude) ?? 0) ?? 0.00) \("|") "))
                                        }else{
                                            destination = String.init(format:"\(Double(Int(attendanceobject.checkinLattitude) ?? 0) ?? 0.00 ) , \(Double(Int(attendanceobject.checkinLongitude)  ?? 0) ?? 0.00)")
                                        }
                                    }
                                    
                                    
                                    marker.map = mapview
                                    path.add(marker.position)
                                    
                                }else if(model.detailType == 2){
                                    // "Visit"
                                    // let planvisit = model as? PlannVisit
                                    marker.title  = model.checkInCustomerName
                                    
                                    //                                    if let checkinlist = VisitCheckInOutList().getVisitCheckInOutUsingDate(visitby: NSNumber.init(value:planvisit?.iD ?? 0), cby: self.select_date.components(separatedBy: " ").first ?? "1") as? VisitCheckInOutList{
                                    //                                        var marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude ?? "0.00") ?? 0.00  , longitude: Double(checkinlist.longitude ?? "0.00") ?? 0.00))
                                    //                                        //bounds.insert(contentsOf: [marker.position], at: 0)
                                    //                                        //bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
                                    //                                        let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                    //                                        mapview.camera = camera
                                    //                                        bounds.contains(marker.position)
                                    //                                        bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00, longitude: Double(checkinlist.longitude) ?? 0.00))
                                    //                                        marker.title = planvisit?.customerName
                                    //                                        marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                    //                                        marker.map = mapview
                                    //                                        path.add(marker.position)
                                    //                                        if(i == 0){
                                    //                                            source = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                    //                                        }else if(i < aryDailyReportArray.count - 1){
                                    //                                            waypoints.append(String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00) \("|") "))
                                    //                                        }else{
                                    //                                            destination = String.init(format:"\(Double(checkinlist.lattitude ?? "0.00") ?? 0.00 ) , \(Double(checkinlist.longitude ?? "0.00") ?? 0.00)")
                                    //                                        }
                                    //                                    }
                                }else if(model.detailType == 3){
                                    //"Lead"
                                    marker.title  = model.checkInCustomerName
                                    //                                    if let checkinlist = lead?.leadCheckInOutList.firstObject as? LeadCheckInOutList{
                                    //                                        var marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00  , longitude: Double(checkinlist.longitude) ?? 0.00))
                                    //                                        //bounds.insert(contentsOf: [marker.position], at: 0)
                                    //                                        //bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
                                    //                                        let camera = GMSCameraPosition.init(latitude: marker.position.latitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: marker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                                    //                                        mapview.camera = camera
                                    //                                        bounds.contains(marker.position)
                                    //                                        bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00, longitude: Double(checkinlist.longitude) ?? 0.00))
                                    //                                        marker.title = lead?.customerName
                                    //                                        marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
                                    //                                        marker.map = mapview
                                    //                                        path.add(marker.position)
                                    //                                        if(i == 0){
                                    //                                            source = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
                                    //                                        }else if(i < aryDailyReportArray.count - 1){
                                    //                                            waypoints.append(String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00) \("|") "))
                                    //                                        }else{
                                    //                                            destination = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
                                    //                                        }
                                    //                                    }
                                    
                                }else if(model.detailType == 4){
                                    //"Activity"
                                    //                                    let activity = model as? Activity
                                    //                                    marker.title  = activity?.activityTypeName
                                    marker.title  = model.checkInCustomerName
                                }else if(model.detailType == 5){
                                    //"Unplanned Visit"
                                    //                                    let unplanvisit = model as? UnplannedVisit
                                    //                                    marker.title  = unplanvisit?.tempCustomerObj?.CustomerName  //activity?.activityTypeName
                                    marker.title  = model.checkInCustomerName
                                }
                                marker.map = mapview
                                path.add(marker.position)
                            }
                            
                        }
                        
                    }
                    
                    //            if(waypoints.count > 0){
                    //                waypoints.substring(to: waypoints.count - 1)
                    //            }
                    // mapview.animate(to: GMSCameraUpdate.fit(bounds, withPadding: 12.0))
                    
                    if(waypoints.count  > 0 && (waypoints.contains("|"))){
                        
                        if(waypoints != ""){
                            //  waypoints = waypoints.substring(to: (waypoints.count - 1))
                            waypoints =  waypoints.filter({ c in
                                c != "|"
                                
                            })
                            
                        }
                    }
                }
                mapview.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 12.0))
                /*if(((source != "") && (destination != ""))){
                    
                    print("source = \(source) , destination = \(destination) , waypoints = \(waypoints)")
                    let directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?"
                    let directionsUrlString = String.init(format: "\(directionsAPI)&origin=\(source)&destination=\(destination)&sensor=false&key=AIzaSyBruhtDdaFfPuEPOAJ_1-F1y7_I8lfJn_4")//&key=\(Constant.GOOGLE_MAPS_API_KEY)&waypoints=\(waypoints)
                    if let directionsUrl = NSURL.init(string: directionsUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!) as? NSURL{
                        //  let fetchDirectionsTask = URLSession.shared.dataTask(with: directionsUrl) { (data, response, error) in
                        let task = URLSession.shared.dataTask(with: URLRequest.init(url: directionsUrl as URL), completionHandler: {(data, response, error) -> Void in
                            print("data = \(data) , response = \(response) , error = \(error) , url  = \(directionsUrl)")
                            if let data = data {
                                do{
                                    if  let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:Any] {
                                        var polyline = GMSPolyline()
                                        print("json = \(json)")
                                        let routesArray = json["routes"] as? [[String:Any]]
                                        if(routesArray?.count ?? 0 > 0){
                                            
                                            
                                            let routedic  = routesArray?.first
                                            let routeOverviewPolyline = routedic? ["overview_polyline"] as? [String:Any]
                                            let points = routeOverviewPolyline?["points"] as? String
                                            print("points = \(points)")
                                            DispatchQueue.main.async{
                                                //   polyline = self.polylineWithEncodedString(encodedstring: points ?? "")
                                                if let pathpoints = points{
                                                    let path = GMSPath.init(fromEncodedPath: pathpoints)
                                                    polyline =  GMSPolyline(path: path)
                                                    polyline.strokeWidth = 2.0
                                                    polyline.map =  self.mapview
                                                }
                                            }
                                        }
                                    }
                                }catch{
                                    
                                }
                            }
                        })
                        task.resume()
                    }
                }*/
                
                
            }else{
                self.loadmap()
                //   let circle = GMSCircle.init(position: self., radius: self.activeuser?.company?.radius)
                // circle.stroke
            }
           
        }
        if(path.count() > 0){
            for i in 0...path.count() - 1{
                if(i == 0){
                    let origin = path.coordinate(at: 0)
                    let destination = path.coordinate(at: 1)
                    let strorigin = String.init(format: "\(origin.latitude),\(origin.longitude)")
                    let strdestination = String.init(format: "\(destination.latitude),\(destination.longitude)")
                    self.drawPolyline(source: strorigin, destination: strdestination)
                }else if(i == path.count() - 1){
                    let origin = path.coordinate(at: path.count() - 2)
                    let destination = path.coordinate(at: path.count() - 1)
                    let strorigin = String.init(format: "\(origin.latitude),\(origin.longitude)")
                    let strdestination = String.init(format: "\(destination.latitude),\(destination.longitude)")
                    self.drawPolyline(source: strorigin, destination: strdestination)
                }else if(i > 1 && i < path.count() - 2){
                    let origin = path.coordinate(at: i)
                    let destination = path.coordinate(at: i +  1)
                    let strorigin = String.init(format: "\(origin.latitude),\(origin.longitude)")
                    let strdestination = String.init(format: "\(destination.latitude),\(destination.longitude)")
                    self.drawPolyline(source: strorigin, destination: strdestination)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if((isFromAttendance == false) && (isFromDailyReport == false)){
            self.getAddressFromLocation(location: currentLocation)  {(address,error) in
                //      print(address)
                self.delegate?.updateAddress(dic: address)
            }
            
        }
        
        //   mapview.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        /*if(isFromDailyReport == true){
         let bounds = GMSCoordinateBounds()
         let path = GMSMutablePath()
         var source = "" , destination = "", waypoints = ""
         if let mutarrfromreport = aryDailyReportArray as? [Any]{
         if(mutarrfromreport.count > 0){
         for i in 0...aryDailyReportArray.count - 1 {
         let dailyreport = aryDailyReportArray[i]
         if(type(of: dailyreport) == PlannVisit.self){
         let planvisit = dailyreport as? PlannVisit
         if let checkinlist = VisitCheckInOutList().getVisitCheckInOutUsingDate(visitby: NSNumber.init(value:planvisit?.iD ?? 0), cby: self.select_date.components(separatedBy: " ").first ?? "1") as? VisitCheckInOutList{
         let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00   , longitude: Double(checkinlist.longitude) ?? 0.00 ))
         //bounds.insert(contentsOf: [marker.position], at: 0)
         //bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
         bounds.contains(marker.position)
         marker.title = planvisit?.customerName
         marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
         marker.map = mapview
         path.add(marker.position)
         if(i == 0){
         source = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
         }else if(i < aryDailyReportArray.count - 1){
         waypoints.append(String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00) \("|") "))
         }else{
         destination = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
         }
         }
         }else if(type(of: dailyreport) == Activity.self){
         
         }else{
         let unplanvisit = dailyreport as? UnplannedVisit
         if let checkinlist = VisitCheckInOutList().getVisitCheckInOutUsingDate(visitby: NSNumber.init(value:planvisit?.iD ?? 0), cby: self.select_date.components(separatedBy: " ").first ?? "1") as? VisitCheckInOutList{
         var marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(checkinlist.lattitude) ?? 0.00  , longitude: Double(checkinlist.longitude) ?? 0.00))
         // bounds.insert(contentsOf: [marker.position], at: 0)
         //  bounds.insert(GMSCoordinateBounds().includingCoordinate(marker.position), at: 0)
         bounds.includingCoordinate(marker.position)
         marker.title = planvisit?.customerName
         marker.snippet = String.init(format:"In: \(Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: checkinlist.checkInTime ?? "2020/10/10 10:10:10", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/10 10:10:10", format: "hh:mm a"))")
         marker.map = mapview
         path.add(marker.position)
         if(i == 0){
         source = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
         }else if(i < aryDailyReportArray.count - 1){
         waypoints.append(String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00) \("|") "))
         }else{
         destination = String.init(format:"\(Double(checkinlist.lattitude) ?? 0.00 ) , \(Double(checkinlist.longitude) ?? 0.00)")
         }
         }
         }
         }
         }
         }
         //            if(waypoints.count > 0){
         //                waypoints.substring(to: waypoints.count - 1)
         //            }
         // mapview.animate(to: GMSCameraUpdate.fit(bounds, withPadding: 12.0))
         mapview.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 12.0))
         
         
         }*/
    }
    
    //MARK: - Method
    func drawPolyline(source:String,destination:String){
        DispatchQueue.main.async {
            let directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?"
            let directionsUrlString = String.init(format: "\(directionsAPI)&origin=\(source)&destination=\(destination)&sensor=false&key=\(Constant.GOOGLE_MAPS_API_KEY)")//&key=\(Constant.GOOGLE_MAPS_API_KEY)
            if let directionsUrl = NSURL.init(string: directionsUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!) as? NSURL{
                //  let fetchDirectionsTask = URLSession.shared.dataTask(with: directionsUrl) { (data, response, error) in
                let task = URLSession.shared.dataTask(with: URLRequest.init(url: directionsUrl as URL), completionHandler: {
                    (data, response, error) -> Void in
                    print("data = \(data) , response = \(response) , error = \(error) , url  = \(directionsUrl)")
                    if let data = data {
                        do{
                            if  let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:Any] {
                                var polyline = GMSPolyline()
                                let routesArray = json["routes"] as? [[String:Any]]
                                if(routesArray?.count ?? 0 > 0){
                                    
                                    
                                    let routedic  = routesArray?.first
                                    let routeOverviewPolyline = routedic? ["overview_polyline"] as? [String:Any]
                                    let points = routeOverviewPolyline?["points"] as? String
                                    print("points = \(points)")
                                    DispatchQueue.main.async{
                                        //   polyline = self.polylineWithEncodedString(encodedstring: points ?? "")
                                        if let pathpoints = points{
                                            let path = GMSPath.init(fromEncodedPath: pathpoints)
                                            polyline =  GMSPolyline(path: path)
                                            polyline.strokeWidth = 2.0
                                            polyline.map =  self.mapview
                                        }
                                    }
                                }
                            }
                        }catch{
                            
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    func setUI(){
        print("lattitude = \(self.lattitude ?? NSNumber.init(value: 0)) on map")
        print("longitude = \(self.longitude ?? NSNumber.init(value: 0)) on map")
        btnUpdateAddress.setbtnFor(title: "Update Address", type: Constant.kPositive)
        self.btnUpdateAddress.isHidden = false
        self.salesPlandelegateObject = self
        self.title = NSLocalizedString("google_map", comment:"")
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        mapview.settings.compassButton = true
        mapview.settings.myLocationButton = true
        //        if(isFromCustomer ?? false){
        //
        //        }else{
        //        mapview.settings.myLocationButton = true
        //        }
        mapview.delegate = self
        //let coord =
        let dragablemarker = GMSMarker()
        dragablemarker.position = Location.sharedInsatnce.getCurrentCoordinate() ?? CLLocationCoordinate2D()
        if(isFromAddActivity == true || isFromCustomer == true){
            dragablemarker.position = CLLocationCoordinate2DMake(CLLocationDegrees.init(self.lattitude) as? CLLocationDegrees ?? CLLocationDegrees.init(00000), CLLocationDegrees.init(self.longitude) as? CLLocationDegrees ?? CLLocationDegrees.init(00000))
            btnUpdateAddress.isHidden = true
            dragablemarker.map =  self.mapview
        }
        if(isFromDashboard){
            var camera = GMSCameraPosition.init(latitude: self.lattitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: self.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
            
            dragablemarker.position = CLLocationCoordinate2DMake(CLLocationDegrees.init(self.lattitude) as? CLLocationDegrees ?? CLLocationDegrees.init(00000), CLLocationDegrees.init(self.longitude) as? CLLocationDegrees ?? CLLocationDegrees.init(00000))
            
            dragablemarker.title = custname
            btnUpdateAddress.isHidden = true
            dragablemarker.map =  self.mapview
            let currentlocationmarker = GMSMarker()
            currentlocationmarker.position = Location.sharedInsatnce.getCurrentCoordinate() ?? CLLocationCoordinate2D()
            currentlocationmarker.icon = UIImage.init(named:"icon_map_mark_blue.png")
            currentlocationmarker.title = "Your Position on map"
            currentlocationmarker.map =  self.mapview
            if(self.lattitude.intValue > 0 && self.longitude.intValue > 0){
                
            }else{
                camera = GMSCameraPosition.init(latitude:  currentlocationmarker.position.latitude, longitude: currentlocationmarker.position.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
            }
            if(currentlocationmarker.position.latitude > 0 && currentlocationmarker.position.longitude > 0 && self.lattitude.intValue > 0 && self.longitude.intValue > 0){
                let path = GMSMutablePath.init()// [GMSMutablePath path]
                path.add(currentlocationmarker.position)
                path.add(CLLocationCoordinate2D.init(latitude: self.lattitude as! CLLocationDegrees, longitude: self.longitude as! CLLocationDegrees))
                //            [path addCoordinate:CLLocationCoordinate2DMake(@(18.520).doubleValue,@(73.856).doubleValue)];
                //            [path addCoordinate:CLLocationCoordinate2DMake(@(16.7).doubleValue,@(73.8567).doubleValue)];
                
                //            GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
                //            rectangle.strokeWidth = 2.f;
                //            rectangle.map = _mapView;
                //            self.view=_mapView;
                /*let polyline = GMSPolyline.init(path: path)
                 polyline.strokeWidth = 2
                 polyline.map = self.mapview*/
                let   source = String.init(format:"\(Double(currentlocationmarker.position.latitude ?? 0.00) ?? 0.00 ) , \(Double(currentlocationmarker.position.longitude ?? 0.00) ?? 0.00)")
                let destination = String.init(format:"\(Double(self.lattitude ?? 0.00) ?? 0.00 ) , \(Double(self.longitude ?? 0.00) ?? 0.00)")
                let waypoints = ""
                
               /* if(((source != "") && (destination != ""))){
                    
                    print("source = \(source) , destination = \(destination) , waypoints = \(waypoints)")
                    let directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?"
                    let directionsUrlString = String.init(format: "\(directionsAPI)&origin=\(source)&destination=\(destination)&waypoints=\(waypoints)&sensor=false&key=\(Constant.GOOGLE_MAPS_API_KEY)")//&key=\(Constant.GOOGLE_MAPS_API_KEY)
                    if let directionsUrl = NSURL.init(string: directionsUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!) as? NSURL{
                        //  let fetchDirectionsTask = URLSession.shared.dataTask(with: directionsUrl) { (data, response, error) in
                        let task = URLSession.shared.dataTask(with: URLRequest.init(url: directionsUrl as URL), completionHandler: {
                            (data, response, error) -> Void in
                            print("data = \(data) , response = \(response) , error = \(error) , url  = \(directionsUrl)")
                            if let data = data {
                                do{
                                    if  let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:Any] {
                                        var polyline = GMSPolyline()
                                        let routesArray = json["routes"] as? [[String:Any]]
                                        if(routesArray?.count ?? 0 > 0){
                                            
                                            
                                            let routedic  = routesArray?.first
                                            let routeOverviewPolyline = routedic? ["overview_polyline"] as? [String:Any]
                                            let points = routeOverviewPolyline?["points"] as? String
                                            print("points = \(points)")
                                            DispatchQueue.main.async{
                                                //   polyline = self.polylineWithEncodedString(encodedstring: points ?? "")
                                                if let pathpoints = points{
                                                    let path = GMSPath.init(fromEncodedPath: pathpoints)
                                                    polyline =  GMSPolyline(path: path)
                                                    polyline.strokeWidth = 2.0
                                                    polyline.map =  self.mapview
                                                }
                                            }
                                        }
                                    }
                                }catch{
                                    
                                }
                            }
                        })
                        task.resume()
                    }
                }*/
               /* for i in 0...path.count() - 1{
                    if(i == 0){
                        let origin = path.coordinate(at: 0)
                        let destination = path.coordinate(at: 1)
                        let strorigin = String.init(format: "\(origin.latitude),\(origin.longitude)")
                        let strdestination = String.init(format: "\(destination.latitude),\(destination.longitude)")
                        self.drawPolyline(source: strorigin, destination: strdestination)
                    }else if(i == path.count() - 1){
                        let origin = path.coordinate(at: path.count() - 2)
                        let destination = path.coordinate(at: path.count() - 1)
                        let strorigin = String.init(format: "\(origin.latitude),\(origin.longitude)")
                        let strdestination = String.init(format: "\(destination.latitude),\(destination.longitude)")
                        self.drawPolyline(source: strorigin, destination: strdestination)
                    }else{
                        let origin = path.coordinate(at: i)
                        let destination = path.coordinate(at: i +  1)
                        let strorigin = String.init(format: "\(origin.latitude),\(origin.longitude)")
                        let strdestination = String.init(format: "\(destination.latitude),\(destination.longitude)")
                        self.drawPolyline(source: strorigin, destination: strdestination)
                    }
                }*/
            }
            
            mapview.camera = camera
        }else{
            dragablemarker.title = "Your Position on map"
        }
        dragablemarker.icon = UIImage.init(named:"icon_map_mark_red.png")//UIImage.init("icon_map_mark_blue.png")
        dragablemarker.isDraggable = true
        if( isFromDailyReport == true || isFromMovementTreport == true){
            btnUpdateAddress.isHidden = true
            dragablemarker.map = nil
        }else if(isFromVisitLeadDetail == true || isFromColdCall == true){
            dragablemarker.map = nil
        }else{
            dragablemarker.map =  self.mapview
        }
        
        
        if(isFromMovementTreport ==  true || isFromDailyReport == true || isFromSalesPlan == true || isFromApprovalList == true){
            
        }else{
            
            //  dispatch_queue_main_t.async(execute: dispatch_queue_main_t())
            if(isFromSalesPlan ==  true){
                
            } else if(isFromDailyReport == true){
                
            }else if(isFromVisitLeadDetail == true || isFromColdCall == true){
                let camera = GMSCameraPosition.init(latitude: self.lattitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: self.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                let dragablemarker = GMSMarker()
                dragablemarker.position = CLLocationCoordinate2D.init(latitude: self.lattitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: self.longitude as? CLLocationDegrees ?? CLLocationDegrees())
                dragablemarker.icon = UIImage.init(named:"icon_map_mark_red.png")
                dragablemarker.title = "Customer location"
                dragablemarker.map = self.mapview
                dragablemarker.isDraggable = false
                let dragablemarker1 = GMSMarker()
                let currentLocation = Location.sharedInsatnce.getCurrentCoordinate()
                dragablemarker1.position = currentLocation ?? CLLocationCoordinate2D()
                dragablemarker1.map = self.mapview
                dragablemarker1.isDraggable = false
                dragablemarker1.icon = UIImage.init(named:"icon_map_mark_blue.png")
                dragablemarker1.title = "Your position on map"
                let radius = self.activeuser?.company?.radius ?? 5
                let circle = GMSCircle.init(position: dragablemarker1.position, radius: CLLocationDistance(truncating: radius))//GMSCircle.init(position: camera.target, radius: self.activeuser?.company?.radius)
                //circle.fillColor = UIColor.blue.withAlphaComponent(0.5)
                circle.strokeColor = UIColor.blue.withAlphaComponent(0.8)
                circle.strokeWidth = 4
                circle.map = mapview
                mapview.camera = camera
                if(isFromColdCall == true){
                    btnUpdateAddress.isHidden = true
                    
                }
            }
            else{
                
                let camera = GMSCameraPosition.init(latitude: self.lattitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: self.longitude as? CLLocationDegrees ?? CLLocationDegrees(), zoom: 14)
                if(isFromAttendance == true){
                    let dragablemarker = GMSMarker()
                    dragablemarker.position = CLLocationCoordinate2D.init(latitude: self.lattitude as? CLLocationDegrees ?? CLLocationDegrees() , longitude: self.longitude as? CLLocationDegrees ?? CLLocationDegrees())
                    dragablemarker.icon = UIImage.init(named:"icon_map_mark_red.png")
                    dragablemarker.title = "CheckinPostion"
                    dragablemarker.map = self.mapview
                    btnUpdateAddress.isHidden = true
                    let radius = self.activeuser?.company?.radius ?? 5
                    let circle = GMSCircle.init(position: dragablemarker.position, radius: CLLocationDistance(truncating: radius))//GMSCircle.init(position: camera.target, radius: self.activeuser?.company?.radius)
                    //circle.fillColor = UIColor.blue.withAlphaComponent(0.5)
                    circle.strokeColor = UIColor.blue.withAlphaComponent(0.8)
                    circle.strokeWidth = 4
                    circle.map = mapview
                }
                if(!isFromDashboard){
                    mapview.camera = camera
                }
                print("lattitude = \(self.lattitude ?? NSNumber.init(value: 0)) on camera")
                print("longitude = \(self.longitude ?? NSNumber.init(value: 0)) on camera")
            }
            mapview.isMyLocationEnabled = true
            SVProgressHUD.showInfo(withStatus: NSLocalizedString("fetching_current_location", comment:""))
            
            
            
        }
    }
    
    
    
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(firstLocationUpdate == false){
            firstLocationUpdate = true
            // let location = change?["NSKeyValueChangeKey"] as? CLLocation
            self.loadmap()
            //let coord = Location.sharedInsatnce.getCurrentCoordinate()
            let dragablemarker = GMSMarker()
            if(isFromCustomer == false){
                dragablemarker.position = mapview.myLocation?.coordinate ?? CLLocationCoordinate2D()
            }
            dragablemarker.title = "Your Position on map"
            dragablemarker.icon = UIImage.init(named:"icon_map_mark_blue.png")//UIImage.init("icon_map_mark_blue.png")
            if(isFromAttendance == false){
                currentLocation =  CLLocation.init(latitude: dragablemarker.position.latitude, longitude: dragablemarker.position.longitude)
            }
            
            dragablemarker.map =  self.mapview
            
        }
    }
    func polylineWithEncodedString(encodedstring:String)-> GMSPolyline {
        let bytes  = encodedstring.utf8
        let length = encodedstring.lengthOfBytes(using: String.Encoding.utf8)
        let idx = 0
        var count = length/4
        let coords  = [CLLocationCoordinate2D]()
        // let coords = calloc(count, Size(CLLocationCoordinate2D.dynamic))
        var coorIdx = 0
        
        var lattitude = 0
        var longitude = 0
        while(idx < length ){
            var byte = 0
            var res = 0
            var shift = "0"
            do{
                //        byte = Int(bytes[id += 1] - 63)
                //                res|= (bytes & 0x1F) << shift
            }
            while (byte >= 0x20){
                
            }
            var deltLon = (((res & 1) != 0) ? ~(res >> 1) : (res >> 1))
            longitude += deltLon;
            //            var finalLat = lattitude * (1E-5);
            //            var finalLon = longitude * (1E-5);
            //                    var coord = CLLocationCoordinate2DMake(finalLat, finalLon)
            //                    coords[coorIdx += 1] =  coord
            
            if(coorIdx == count){
                let newcount = count + 10
                //                        coords = realloc(coords, newcount * sizeof(type(of: CLLocationCoordinate2D)))
                count = newcount
            }
        }
        var path = GMSMutablePath.init()
        var i = 0
        for i in 0...coords.count - 1 {
            path.add(coords[i])
        }
        let polyline  = GMSPolyline.init(path: path)
        //free(coords)
        return polyline
    }
    func loadmap(){
        let marker = GMSMarker.init()
        marker.position = CLLocationCoordinate2DMake(self.lattitude as? CLLocationDegrees ?? CLLocationDegrees(), self.longitude as? CLLocationDegrees ?? CLLocationDegrees())
        print(NSLocalizedString("customer_location", comment: ""))
        marker.title = NSLocalizedString("customer_location", comment:"")
        if(isFromAttendance == true){
            marker.title = "Checkin Location"
            let camera = GMSCameraPosition.camera(withLatitude: self.lattitude as! CLLocationDegrees,
                                                  longitude:self.longitude as! CLLocationDegrees, zoom: 6)
            let radius = self.activeuser?.company?.radius ?? 5
            let circle = GMSCircle.init(position: camera.target, radius: CLLocationDistance(truncating: radius))//GMSCircle.init(position: camera.target, radius: self.activeuser?.company?.radius)
            //circle.fillColor = UIColor.blue.withAlphaComponent(0.5)
            circle.strokeColor = UIColor.blue.withAlphaComponent(0.8)
            circle.strokeWidth = 4
            circle.map = mapview
            
            
        }else{
            
            marker.title  = "Your Position on map"
            marker.isDraggable = true
            
            
        }
        marker.map = mapview
        
        /*
         GMSMarker *draggableMarker = [[GMSMarker alloc] init];;
         draggableMarker.position = mapView_.myLocation.coordinate;
         draggableMarker.title = NSLocalizedString(@"your_position_on_map", @"");
         draggableMarker.icon = [UIImage imageNamed:@"map_mark_blue.png"];
         draggableMarker.map = mapView_;
         **/
        
    }
    @IBAction func btnupdateAddressClicked(_ sender: UIButton) {
        //  Common.showalert(msg: "Are you sure, you want to set your current location as Customer Location?", view: self)
        Common.showalert(title: "SuperSales", msg: "Are you sure, you want to set your current location as Customer Location?", yesAction: UIAlertAction.init(title: "YES", style: UIAlertAction.Style.default, handler: { (action) in
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            var address1 = [String:Any]()
            address1["LastModifiedBy"] = self.activeuser?.userID
            var addressOfDetail =
            AddressList()
            if((self.isFromVisitLeadDetail == true) && (self.isFromColdCall ==  false)){
                if let planVisit = self.planvisit as? PlannVisit{
                    if let addressOfDetail1 = AddressList().getAddressByAddressId(aId: NSNumber.init(value: planVisit.addressMasterID)){
                        
                        addressOfDetail = addressOfDetail1
                    }
                }
                if let objlead =  self.objLead as? Lead{
                    if let addressOfDetail1 =  AddressList().getAddressByAddressId(aId:NSNumber.init(value:objlead.addressMasterID)) {
                        
                        addressOfDetail = addressOfDetail1
                    }else{
                        print("did not get address")
                    }
                }
                
            }
            
            address1["Country"] = (addressOfDetail.country?.count ?? 0 > 0) ?addressOfDetail.country:self.unplanvisit?.tempCustomerObj?.Country
            address1["State"] = (addressOfDetail.state?.count ?? 0 > 0) ?addressOfDetail.state:self.unplanvisit?.tempCustomerObj?.State
            address1["City"] = (addressOfDetail.city?.count ?? 0 > 0) ?addressOfDetail.city:self.unplanvisit?.tempCustomerObj?.City
            address1["AddressLine1"] = (addressOfDetail.addressLine1?.count ?? 0 > 0) ?addressOfDetail.addressLine1:self.unplanvisit?.tempCustomerObj?.AddressLine1
            address1["AddressLine2"] = (addressOfDetail.addressLine2?.count ?? 0 > 0) ?addressOfDetail.addressLine2:self.unplanvisit?.tempCustomerObj?.AddressLine2
            address1["Pincode"] = (addressOfDetail.pincode.count ?? 0 > 0) ?addressOfDetail.pincode:self.unplanvisit?.tempCustomerObj?.Pincode
            address1["Lattitude"] = Location.sharedInsatnce.currentLocation.coordinate.latitude ?? self.lattitude
            address1["Longitude"] = Location.sharedInsatnce.currentLocation.coordinate.longitude ?? self.longitude
            
            if(self.isFromColdCall == true){
                param["CustomerID"] = self.unplanvisit?.customerID
                address1["AddressID"] = self.unplanvisit?.addressMasterID
                if let type  = self.unplanvisit?.tempCustomerObj?.TempCustomerType {
                    address1["Type"] = NSNumber.init(value:Int(type) ?? 0)
                }
            }else{
                address1["Type"] = addressOfDetail.type
                if let planv = self.planvisit as? PlannVisit{
                    param["CustomerID"] = planv.customerID
                    address1["AddressID"] = planv.addressMasterID
                }
                if let lead =  self.objLead as? Lead{
                    param["CustomerID"] = lead.customerID
                    address1["AddressID"] = lead.addressMasterID
                }
            }
            param["Address"] =  Common.returnjsonstring(dic: address1)
            
            self.apihelper.getdeletejoinvisit(param:param , strurl: ConstantURL.kWSUrlUpdateCustAddress, method: Apicallmethod.post)   { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    if ( message.count > 0 ) {
                        Utils.toastmsg(message:message,view: self.view)
                    }
                    self.navigationController?.popViewController(animated: true)
                }else if(error.code == 0){
                    if ( message.count > 0 ) {
                        Utils.toastmsg(message:message,view: self.view)
                    }
                }else{
                    Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                }
            }
        }), noAction: UIAlertAction.init(title: "NO", style: UIAlertAction.Style.default, handler: nil), view: self)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension GoogleMap:BaseViewControllerDelegate{
    func  backTapped(){
        // print(mapview.)
        // mapview.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
}
extension GoogleMap:GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        currentLocation =  CLLocation.init(latitude: marker.position.latitude, longitude: marker.position.longitude)
        print("current location lat = \(currentLocation.coordinate.latitude) , longtidue = \(currentLocation.coordinate.longitude)")
        if(isFromCustomer == true){
            let markercurrent = GMSMarker.init()
            // markercurrent.position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude )
            markercurrent.position = CLLocationCoordinate2DMake(CLLocationDegrees.init(self.lattitude) as? CLLocationDegrees ?? CLLocationDegrees.init(00000), CLLocationDegrees.init(self.longitude) as? CLLocationDegrees ?? CLLocationDegrees.init(00000))
            markercurrent.title = "your position on map"//NSLocalizedString("customer_location", comment:"")
            markercurrent.map = mapview
            
            
            
        }
        self.getAddressFromLocation(location: currentLocation)  {(address,error) in
            print("address = \(address)")
            
            if let tempadd = self.tempAddNo as? NSNumber{
                self.delegate?.updateAddress(dic: address, TempaddNo: tempadd)
            }else{
                self.delegate?.updateAddress(dic: address)
            }
        }
    }
}
