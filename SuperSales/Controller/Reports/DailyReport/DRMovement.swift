//
//  DRMovement.swift
//  SuperSales
//
//  Created by Apple on 11/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import FastEasyMapping
import MagicalRecord
import SVProgressHUD


class DRMovement: BaseViewController {
    private let refreshControl = UIRefreshControl()
    var totalkm =  0.0
    var totalminuts = 0
    var selectedroleid:NSNumber!
    @IBOutlet var tblMoment: UITableView!
    
    static  var arrMoment:[Any] = [Any]()
    static var attendanceList:[[String:Any]] = [[String:Any]]()
    static var arrActualMoment:[Any] = [Any]()
    @IBOutlet var vwMap: UIView!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblTotalMinute: UILabel!
    
    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            
            super.viewDidLoad()
            self.setUI()
            if #available(iOS 10.0, *) {
                self.tblMoment.refreshControl = self.refreshControl
            } else {
                self.tblMoment.addSubview(self.refreshControl)
            }
            // Configure Refresh Control
            self.refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        })
        
        
        
        //         [_tblListing addPullToRefreshWithActionHandler:^{
        //         jointVisitPageNo=1;
        //         [self callWebservice];
        //         }];
        
    }
    @objc private func refreshWeatherData(_ sender: Any) {
        //        // Fetch Weather Data
        
        refreshControl.endRefreshing()
        NotificationCenter.default.post(name: NSNotification.Name("getDailyReports"), object: nil)
        tblMoment.reloadData()
        if(DRMovement.arrMoment.count > 0){
            lblDistance.isHidden = false
            lblTotalMinute.isHidden = false
        }else{
            lblDistance.isHidden = true
            lblTotalMinute.isHidden = true
        }
        lblDistance.text = String.init(format:"Total: %.2f  KM",totalkm)
        lblTotalMinute.text =  String.init(format:"\(totalminuts) min")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if(selectedroleid == 9){
            vwMap.isHidden = true
        }else{
            vwMap.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SVProgressHUD.show()
        DispatchQueue.main.async(execute: {
            NotificationCenter.default.post(name: NSNotification.Name("getDailyReports"), object: nil)
            self.tblMoment.reloadData()
            SVProgressHUD.dismiss()
        })
       
        if((DRMovement.arrMoment.count > 0 || DRMovement.arrActualMoment.count > 0) &&  tblMoment.visibleCells.count > 0 ){
            self.tblMoment.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            self.tblMoment.reloadData()
        }
    }
    //MARK: - Method
    
    func setUI(){
        
        
        tblMoment?.estimatedRowHeight = 120
        tblMoment?.rowHeight = UITableView.automaticDimension
        tblMoment.separatorColor = UIColor.clear
        tblMoment.tableFooterView = UIView()
    }
    
    func fillData(visits:[[String:Any]],attendance:[[String:Any]],leads:[[String:Any]],moments:[[String:Any]]){
        
        DRMovement.arrMoment = [Any]()
        DRMovement.arrActualMoment = [Any]()
        totalkm = 0.0
        if(moments.count > 0){
            totalkm = 0.0
            totalminuts = 0
            
            var attendanceCheckoutObj:Movementmodel?
            
            for mom in moments {
                var dicmoment = mom
                let detailType = mom["detailType"] as? NSNumber  ?? NSNumber.init(value:0)
                print("dic = \(dicmoment) , \(detailType)")
                if(detailType == 1){
                    if let lastcheckoutkm = mom["LastCheckOutKM"] as? NSNumber{
                        totalkm += lastcheckoutkm.doubleValue
                    }
                }
                if(detailType.intValue > 1){
                    if(detailType == 2){
                        //visit
                        if let visit = PlannVisit.getVisit(visitID: NSNumber.init(value:mom["modulePrimaryID"] as? Int ?? 0 )) as? PlannVisit{
                            
                            if let address = AddressList().getAddressByAddressId(aId: NSNumber.init(value:visit.addressMasterID)){
                                if(address.lattitude.toDouble() > 0 && address.longitude.toDouble() > 0){
                                    dicmoment["checkInLatitude"] = NSNumber.init(value:address.lattitude.toDouble())
                                    dicmoment["checkInLongitude"] = NSNumber.init(value:address.longitude.toDouble())
                                }
                                // model.checkInLatitude = NSNumber.init(value:address.lattitude.toDouble())
                                //  model.checkOutLongitude =  NSNumber.init(value:address.longitude.toDouble())
                            }
                        }
                    }else if(detailType == 3){
                        //lead
                        if let lead = Lead.getLeadByID(Id: mom["modulePrimaryID"] as? Int  ?? 0) as? Lead{
                            if let address = AddressList().getAddressByAddressId(aId: NSNumber.init(value:lead.addressMasterID)){
                                if(address.lattitude.toDouble() > 0 && address.longitude.toDouble() > 0){
                                    dicmoment["checkInLatitude"] = NSNumber.init(value:address.lattitude.toDouble())
                                    dicmoment["checkInLongitude"] = NSNumber.init(value:address.longitude.toDouble())
                                }
                            }
                        }
                    }else if(detailType == 5){
                        ///  if let unplanvisit =
                        
                        let coldcalldic =  self.apihelper.getColdCallDetailWithId(coldcallId: NSNumber.init(value:mom["modulePrimaryID"] as? Int  ?? 0))
                        if(coldcalldic.keys.count > 0)
                        {
                            let unplanvisit = UnplannedVisit().initwithdic(dict: coldcalldic)
                            let checkinlist  = unplanvisit.checkInList
                            if(checkinlist?.count ?? 0 > 0){
                                if let checkindata = checkinlist?.first{
                                    dicmoment["checkInLatitude"] = NSNumber.init(value:checkindata.lattitude?.toDouble() ?? 0.0000)
                                    dicmoment["checkInLongitude"] = NSNumber.init(value:checkindata.longitude?.toDouble() ?? 0.0000)
                                }
                            }
                        }
                        ///
                    }
                    
                    let model = Movementmodel().initWithdict(dic:dicmoment)
                    //                print("dic is \(mom) , check in time = \(model.checkInTime) , \(model.checkInLatitude) , \(model.checkInCustomerName) , lat = \(model.checkInLatitude) , long = \(model.checkOutLongitude)")
                    
                    if let km = mom["KM"] as? NSNumber{
                        totalkm += km.doubleValue
                        
                    }
                    
                    lblDistance?.text = String.init(format:"%.2f  kms",totalkm)
                    DRMovement.arrMoment.append(model)
                    print("count of moment = \(DRMovement.arrMoment.count)")
                    
                }else{
                    let model = Movementmodel().initWithdict(dic:dicmoment)
                    if((detailType.intValue == 1) && (model.checkOutTime.count > 0)){
                        
                        attendanceCheckoutObj = model
                    }
                    if(detailType.intValue == 1 && (model.checkInTime.count > 0) ){
                        DRMovement.arrMoment.insert(model, at: 0)
                    }
                }
                print("cout of arrmomment = \(DRMovement.arrMoment.count) ,  moments count = \(moments.count) \(mom)")
                
                
                
            }
            if let atchoutobj =  attendanceCheckoutObj as? Movementmodel{
                DRMovement.arrMoment.insert(atchoutobj, at: DRMovement.arrMoment.count)
            }
            
        }else{
            
            if(visits.count > 0){
                for visit in 0...visits.count-1{
                    let cvisit = visits[visit]
                    if   let vtype = cvisit["TextType"] as? String{
                        if(vtype == "Lead"){
                            
                            let mapping = Lead.defaultmapping()
                            let store = FEMManagedObjectStore.init(context: Lead.getContext())
                            store.saveContextOnCommit = false
                            let ldeserialiser = FEMDeserializer.init(store: store)
                            if   let arrLead = ldeserialiser.collection(fromRepresentation: [cvisit], mapping: mapping).first as? Lead{
                                DRMovement.arrMoment.append(arrLead)
                            }
                            
                        }
                        if  let visitTypeID = cvisit["VisitTypeID"] as? Int {
                            if(visitTypeID == 1){
                                let mapping = PlannVisit.defaultmapping()
                                let store = FEMManagedObjectStore.init(context: PlannVisit.getContext())
                                store.saveContextOnCommit = false
                                let deserialiser = FEMDeserializer.init(store: store)
                                let objvisit = deserialiser.object(fromRepresentation: cvisit, mapping: mapping)
                                DRMovement.arrMoment.append(objvisit)
                            }else{
                                let coldcall = UnplannedVisit().initwithdic(dict: cvisit)
                                DRMovement.arrMoment.append(coldcall)
                            }
                        }
                    }
                }
            }
            if(attendance.count > 0){
                var arrOfAttendance = attendance as? [[String:Any]] ?? [[String:Any]]()
                print(attendance.count)
                for i in 0...attendance.count-1{
                    if var firstattendance = attendance[i] as? [String:Any]{
                        
                        
                        //                        let doublelatitude = firstattendance["checkinLattitude"] as? Double
                        //                        firstattendance["checkinLattitude"] = doublelatitude
                        //                    arrOfAttendance.remove(at: i)
                        //                    arrOfAttendance.insert(firstattendance, at: i)
                        let checkintime = firstattendance["checkInTime"] as? String
                        let updatedtime = firstattendance["updatedTimeIn"] as? String
                        
                        if(checkintime?.count ?? 0 > 0 || updatedtime?.count ?? 0 > 0){
                            
                            let mapping = AttendanceHistory.defaultMapping()
                            let store = FEMManagedObjectStore.init(context: AttendanceHistory.getContext())
                            store.saveContextOnCommit = false
                            let deserialiser = FEMDeserializer.init(store: store)
                            if   let attendanceobj1 = deserialiser.collection(fromRepresentation: arrOfAttendance, mapping: mapping).first as? AttendanceHistory{
                                
                                
                                print("long = \(attendanceobj1.checkinLongitude),lat = \(attendanceobj1.checkinLattitude) , ")
                                DRMovement.arrMoment.insert(attendanceobj1, at: 0)
                                // arrMoment.append(attendanceobj1)
                            }
                            
                            
                            var dicAttendance = [String:Any]()
                            if(checkintime?.count ?? 0 > 0){
                                if let strcheckintime = checkintime{
                                    dicAttendance["CheckInTime"] = strcheckintime
                                }
                                dicAttendance["Minute"] = "N/A"
                                DRMovement.attendanceList.append(dicAttendance)
                            }else{
                                if let strcheckintime = updatedtime{
                                    dicAttendance["CheckInTime"] = strcheckintime
                                }
                                dicAttendance["Minute"] = "N/A"
                                DRMovement.attendanceList.append(dicAttendance)
                            }
                        }
                        let checkouttime = firstattendance["checkOutTime"] as? String
                        let updatedtimeout = firstattendance["updatedTimeOut"] as? String
                        if(checkouttime?.count ?? 0 > 0 || updatedtimeout?.count ?? 0 > 0){
                            
                            let mapping = AttendanceHistory.defaultMapping()
                            let store = FEMManagedObjectStore.init(context: AttendanceHistory.getContext())
                            store.saveContextOnCommit = false
                            let deserialiser = FEMDeserializer.init(store: store)
                            if   let attendanceobj1 = deserialiser.collection(fromRepresentation: arrOfAttendance, mapping: mapping).first as? AttendanceHistory{
                                print("lat = \(attendanceobj1.checkinLattitude)")
                                print("long = \(attendanceobj1.checkinLongitude)")
                                DRMovement.arrMoment.insert(attendanceobj1, at: DRMovement.arrMoment.count )
                                //arrMoment.append(attendanceobj1)
                            }
                            
                            
                            var dicAttendance = [String:Any]()
                            if(checkouttime?.count ?? 0 > 0){
                                if let strcheckintime = checkintime{
                                    dicAttendance["CheckOutTime"] = strcheckintime
                                }
                                dicAttendance["Minute"] = "N/A"
                                DRMovement.attendanceList.append(dicAttendance)
                            }else{
                                if let strcheckintime = updatedtime{
                                    dicAttendance["CheckOutTime"] = strcheckintime
                                }
                                dicAttendance["Minute"] = "N/A"
                                DRMovement.attendanceList.append(dicAttendance)
                            }
                            
                            
                            
                        }
                    }
                }
            }
            var lastCheckInData  = [String:Any]()
            if(attendance.count > 0){
                
                
            }
        }
        
        
        print(DRMovement.arrMoment.count)
        var tempstrchintime = ""
        var  tempstrchouttime = ""
        
        totalminuts = 0
        if(DRMovement.arrMoment.count > 0){
            for model in DRMovement.arrMoment{
                print("type of model = \(type(of: model))")
                if(type(of: model) == PlannVisit.self){
                    if let planvisit = model as? PlannVisit{
                        if let strcheckInTime =  planvisit.checkInTime{
                            if let strcheckOutTime = planvisit.checkOutTime{
                                if(strcheckInTime.count > 0){
                                    var strch = ""
                                    if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit.checkInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                        strch = strcht
                                        tempstrchintime =    Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                    }else{
                                        tempstrchintime =    ""
                                    }
                                    
                                    
                                    
                                }else{
                                    tempstrchintime =    ""
                                    
                                }
                                if(strcheckOutTime.count > 0){
                                    var strch = ""
                                    if let strchot = Utils.getDateBigFormatToDefaultFormat(date: planvisit.checkOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                        strch = strchot
                                        tempstrchouttime =    Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                    }else{
                                        tempstrchouttime =  ""
                                    }
                                    
                                    
                                    
                                    
                                }else{
                                    tempstrchouttime =  ""
                                }
                                if((tempstrchintime.count > 0  &&  (tempstrchintime != "--:--")) && (tempstrchouttime.count > 0 && (tempstrchouttime != "--:--"))){
                                    let minutes = Utils.differenceOfMinutes(previTime: tempstrchintime , nextTime: tempstrchouttime)
                                    if(minutes > 0){
                                        totalminuts += minutes
                                    }
                                    //     print("total minutes = \(totalminuts) , \(minutes)")
                                }
                            }
                            
                        }
                    }
                }else if(type(of: model) == UnplannedVisit.self){
                    let unplanvisit = model as? UnplannedVisit
                    if let strcheckInTime =  unplanvisit?.checkinTime{
                        if let strcheckOutTime = unplanvisit?.checkoutTime{
                            if(strcheckInTime.count > 0){
                                var strch = ""
                                if let strcht = Utils.getDateBigFormatToDefaultFormat(date: unplanvisit?.checkinTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                    strch = strcht
                                    tempstrchintime =    Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                }else{
                                    tempstrchintime =   ""
                                }
                                
                                
                                
                            }else{
                                tempstrchintime =   ""
                            }
                            if(strcheckOutTime.count > 0){
                                var strch = ""
                                if let strchot = Utils.getDateBigFormatToDefaultFormat(date: unplanvisit?.checkoutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                    strch = strchot
                                    tempstrchouttime =    Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                }else{
                                    tempstrchouttime =  ""
                                }
                                
                                
                                
                            }else{
                                tempstrchouttime =  ""
                            }
                            if((tempstrchintime.count > 0  &&  (tempstrchintime != "--:--")) && (tempstrchouttime.count > 0 && (tempstrchouttime != "--:--"))){
                                let minutes = Utils.differenceOfMinutes(previTime: tempstrchintime , nextTime: tempstrchouttime)
                                if(minutes > 0){
                                    totalminuts += minutes
                                }
                                //     print("total minutes = \(totalminuts) , \(minutes)")
                            }
                        }
                        
                    }
                }else if(type(of: model) == Lead.self){
                    if let objlead = model as? Lead{
                        
                        if let checkinobj = objlead.leadCheckInOutList[0] as? LeadCheckInOutList{
                            
                            if let strcheckInTime =  checkinobj.checkInTime as? String{
                                if let strcheckOutTime = checkinobj.checkOutTime as? String{
                                    
                                    if(strcheckInTime.count > 0){
                                        var strch = ""
                                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                            strch = strcht
                                            tempstrchintime = Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                        }
                                        
                                        
                                    }
                                    
                                    else{
                                        
                                        tempstrchintime = ""
                                    }
                                    if(strcheckOutTime.count > 0 ){
                                        var strch = ""
                                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                            strch = strcht
                                            tempstrchouttime = Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                        }
                                        
                                        
                                        
                                        
                                    }else{
                                        tempstrchouttime = ""
                                    }
                                    if((tempstrchintime.count > 0  &&  (tempstrchintime != "--:--")) && (tempstrchouttime.count > 0 && (tempstrchouttime != "--:--"))){
                                        let minutes = Utils.differenceOfMinutes(previTime: tempstrchintime , nextTime: tempstrchouttime)
                                        if(minutes > 0){
                                            totalminuts += minutes
                                        }
                                        //        print("total minutes = \(totalminuts) , \(minutes)")
                                    }
                                }
                                
                                
                                
                                
                                //                        if let strcheckInTime =  objLead.checkInTime{
                                //                            if let strcheckOutTime = objLead.checkOutTime{
                                //                            if(strcheckInTime.count > 0){
                                //                                var strch = ""
                                //                                if let strcht = Utils.getDateBigFormatToDefaultFormat(date: objLead.checkInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                //                                strch = strcht
                                //                                    tempstrchintime =    Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                //                                }else{
                                //                                    tempstrchintime =    ""
                                //                                }
                                //
                                //
                                //
                                //                            }else{
                                //                                tempstrchintime =    ""
                                //
                                //                            }
                                //                            if(strcheckOutTime.count > 0){
                                //                                var strch = ""
                                //                                if let strchot = Utils.getDateBigFormatToDefaultFormat(date: objLead.checkOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                //                                strch = strchot
                                //                                    tempstrchouttime =    Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                //                                }else{
                                //                                    tempstrchouttime =  ""
                                //                                }
                                //
                                //
                                //
                                //
                                //                            }else{
                                //                                tempstrchouttime =  ""
                                //                            }
                                //                            if((tempstrchintime.count > 0  &&  (tempstrchintime != "--:--")) && (tempstrchouttime.count > 0 && (tempstrchouttime != "--:--"))){
                                //                                let minutes = Utils.differenceOfMinutes(previTime: tempstrchintime , nextTime: tempstrchouttime)
                                //                                totalminuts += minutes
                                //                                print("total minutes = \(totalminuts) , \(minutes)")
                                //                            }
                                //                        }
                                //
                                //                    }
                            }
                        }
                    }}else{
                        if let movmodel = model as? Movementmodel{
                            print("type of model = \(movmodel.detailType.intValue)")
                            if(movmodel.detailType.intValue == 2){
                                //visit  PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                                
                                if let strcheckInTime =  movmodel.checkInTime
                                {
                                    if let strcheckOutTime = movmodel.checkOutTime{
                                        if(strcheckInTime.count > 0){
                                            var strch = ""
                                            if let strcht = Utils.getDateBigFormatToDefaultFormat(date: movmodel.checkInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                                strch = strcht
                                                tempstrchintime =    Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                            }else{
                                                tempstrchintime =  ""
                                            }
                                            
                                            
                                            
                                        }else{
                                            tempstrchintime =  ""
                                        }
                                        if(strcheckOutTime.count > 0){
                                            var strch = ""
                                            if let strchot = Utils.getDateBigFormatToDefaultFormat(date: movmodel.checkOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                                strch = strchot
                                                tempstrchouttime =    Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                            }else{
                                                tempstrchouttime = ""
                                            }
                                            
                                            
                                            
                                            
                                        }else{
                                            tempstrchouttime = ""
                                        }
                                        if((tempstrchintime.count > 0  &&  (tempstrchintime != "--:--")) && (tempstrchouttime.count > 0 && (tempstrchouttime != "--:--"))){
                                            let minutes = Utils.differenceOfMinutes(previTime: tempstrchintime , nextTime: tempstrchouttime)
                                            //            print("total minutes = \(totalminuts) , \(minutes) ,\(tempstrchintime),\(tempstrchouttime) before == 5")
                                            if(minutes > 0){
                                                totalminuts += minutes
                                            }
                                        }
                                    }
                                }
                                //  }
                            }else if(movmodel.detailType.intValue == 5){
                                //                        if let unplanvisit = PlannVisit.getVisit(visitID: movmodel.modulePrimaryID ?? NSNumber.init(value: 0)) as? PlannVisit{
                                if let strcheckInTime =  movmodel.checkInTime{
                                    if let strcheckOutTime = movmodel.checkOutTime{
                                        if(strcheckInTime.count > 0){
                                            var strch = ""
                                            if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                                strch = strcht
                                                tempstrchintime =    Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                                
                                            }else{
                                                tempstrchintime =  ""
                                                
                                            }
                                            
                                            
                                        }
                                        if(strcheckOutTime.count > 0){
                                            var strch = ""
                                            if let strchot = Utils.getDateBigFormatToDefaultFormat(date: strcheckOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                                strch = strchot
                                                tempstrchouttime =    Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                            }else{
                                                tempstrchouttime = ""
                                            }
                                            
                                            
                                            
                                            
                                        }
                                        //                                    if((tempstrchintime.count > 0  &&  (tempstrchintime != "--:--")) && (tempstrchouttime.count > 0 && (tempstrchouttime != "--:--"))){
                                        //                                        let minutes = Utils.differenceOfMinutes(previTime: tempstrchintime , nextTime: tempstrchouttime)
                                        //                                        print("total minutes = \(totalminuts) , \(minutes) ,\(tempstrchintime),\(tempstrchouttime) in last")
                                        //                                        totalminuts += minutes
                                        //                                      
                                        //                                    }
                                        // }
                                    }
                                }
                            }
                        }
                    }
            }
            
            tblMoment?.reloadData()
            
            
            
        }
    }
    
    
    
    func getplanvisitDetial(visitId:NSNumber,ForAction:String) {
        /*
         
         NSMutableDictionary *jsonParameter = [NSMutableDictionary new];
         [jsonParameter setObject:@(account.company_info.company_id) forKey:@"CompanyID"];
         [jsonParameter setObject:@(obj.user_id) forKey:@"CreatedBy"];
         [jsonParameter setObject:@(objPlan.iD) forKey:@"ID"];
         
         NSMutableDictionary *maindict = [NSMutableDictionary new];
         [maindict setObject:[jsonParameter rs_jsonStringWithPrettyPrint:YES] forKey:@"getPlannedVisitsJson"];
         [maindict setObject:account.securityToken forKey:@"TokenID"];
         [maindict setObject:@(account.user_id) forKey:@"UserID"];
         [maindict setObject:@(account.company_info.company_id) forKey:@"CompanyID"];
         [maindict setObject:APPLICATION_TEAMWORK forKey:@"Application"];
         **/
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        var json = ["CompanyID":self.activeuser?.company?.iD,"ID":visitId,"CreatedBy":self.activeuser?.userID]
        param["getPlannedVisitsJson"] =  Common.json(from: json)
        var planvisit:PlannVisit?
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetPlannedVisits, method: Apicallmethod.get){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() ==  Constant.SucessResponseFromServer){
                SVProgressHUD.dismiss()
                let  arrVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                print("Dictionary of visit = \(arrVisit)")
                var mutarr = [[String:Any]]()
                for visit in arrVisit{
                    let customerID = NSNumber.init(value: visit["CustomerID"] as? Int ?? 0)
                    var dic = [String:Any]()
                    dic = visit
                    if let strcustname = CustomerDetails.getCustomerNameByID(cid: customerID) as? String{
                        dic["CustomerName"] = strcustname
                    }else{
                        dic["CustomerName"] = "Customer Not Mapped"
                    }
                    let companyuerID = NSNumber.init(value: visit["ReAssigned"] as? Int ?? 0)
                    var strreassigned = ""
                    if let companyuser = CompanyUsers().getUser(userId: companyuerID){
                        strreassigned = String.init(format: "\(companyuser.firstName) \(companyuser.lastName)")
                    }
                    dic["RessigneeName"] =  strreassigned
                    mutarr.append(dic)
                }
                MagicalRecord.save({ (localContext) in
                    let arrvisit = FEMDeserializer.collection(fromRepresentation: mutarr, mapping: PlannVisit.defaultmapping(), context: localContext)
                    print("arr of visit is = \(arrvisit)")
                    
                }, completion: { (contextdidsave, error) in
                    if let planvisit = PlannVisit.getVisit(visitID: visitId) as? PlannVisit{
                        if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                            print("count of check in at redirection time = \(planvisit.checkInOutData.count)")
                            visitDetail.visitType = VisitType.planedvisit
                            visitDetail.redirectTo =  0
                            visitDetail.planvisit = planvisit
                            self.navigationController?.pushViewController(visitDetail, animated: true)
                        }
                    }
                })
            }else{
                SVProgressHUD.dismiss()
            }
        }
    }
    
    
    
    
    func getunplannedVisitDetail(coldcallId:NSNumber){
        var param = Common.returndefaultparameter()
        var param1 = [String:Any]()
        param1["ID"] = coldcallId//visitID
        param1["CreatedBy"] = self.activeuser?.userID//createdBy
        param1["CompanyID"] = self.activeuser?.company?.iD
        param["getUnPlannedVisitsJson"] = Common.returnjsonstring(dic: param1)
        
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetUnPlannedVisits, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                let  arrVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                print("Dictionary of visit = \(arrVisit)")
                var dicVisit = arrVisit.first as? [String:Any] ?? [String:Any]()
                //                    let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: dicVisit["CustomerID"] as? Int ?? 0))
                //                    if(strCustomerName.count == 0){
                //                    dicVisit["CustomerName"] = "Customer Not Mapped"
                //                    }else{
                //                    dicVisit["CustomerName"] = strCustomerName
                //                    }
                //                    let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
                //                    if(reassignedId > 0){
                //
                //                        if let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId)){
                //                    let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                //                            dicVisit["RessigneeName"] = reassignUserName
                //                                                }else{
                //                                dicVisit["RessigneeName"] = ""
                //                                                }
                //                                            }else{
                //                                    dicVisit["RessigneeName"] = ""
                //                                            }
                //                    MagicalRecord.save({ (localContext) in
                //                    let arrvisit = FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
                //                        print(arrvisit)
                //
                //                    }, completion: { (contextdidsave, error) in
                //                        print("\(contextdidsave) , error = \(error)")
                //                        print("visit saved")
                //                        if let planvisit1  = PlannVisit.getVisit(visitID: visitID) as? PlannVisit{
                if(dicVisit.keys.count > 0){
                    let objcoldcall = UnplannedVisit().initwithdic(dict: dicVisit)
                    if let visitdetailobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                        visitdetailobj.redirectTo = 0
                        visitdetailobj.visitType = VisitType.coldcallvisit
                        visitdetailobj.unplanvisit = objcoldcall
                        self.navigationController?.pushViewController(visitdetailobj, animated: true)
                        //                            }else{
                        //                                print("not get visit ")
                    }
                }
            }
        }
    }
    
    func getleadDetail(leadId:NSNumber){
        var jsonlead = [String:Any]()
        jsonlead["ID"] = leadId
        jsonlead["CompanyID"] = self.activeuser?.company?.iD
        jsonlead["CreatedBy"] = self.activeuser?.userID
        var param = Common.returndefaultparameter()
        param["getleadjson"] = Common.returnjsonstring(dic: jsonlead)
        
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetLeadDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
                let arrLead = arr as? [String:Any] ?? [String:Any]()
                MagicalRecord.save({ (localContext) in
                    let arrlead = FEMDeserializer.collection(fromRepresentation: [arrLead], mapping: Lead.defaultmapping(), context: localContext)
                    print(arrlead)
                    
                }, completion: { (contextdidsave, error) in
                    
                    if let objLead  = Lead.getLeadByID(Id: leadId.intValue) as? Lead{
                        //   planvisit = planvisit1
                        
                        if   let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail
                        {
                            leadDetail.redirectTo = 0
                            leadDetail.lead = objLead
                            //arrOfPlanVisit[indexPath.row]
                            
                            
                            //                                if let status =  visitDetail.planvisit?.visitStatusID {
                            //                                    if(status == 3){
                            //                                        visitDetail.visitType = VisitType.manualvisit
                            //                                    }else{
                            //                                        visitDetail.visitType = VisitType.planedvisit
                            //                                    }
                            //
                            //                                }else{
                            //                                    visitDetail.visitType = VisitType.planedvisit
                            //                                }
                            self.navigationController?.pushViewController(leadDetail, animated: true)
                            
                            
                        }
                    }
                })
            }else {
                Utils.toastmsg(message:error.localizedDescription ,view: self.view)
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func mapClicked(_ sender: UIButton){
        //isFromDailyReport = true
        if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
            map.isFromDashboard = false
            map.isFromMovementTreport = true
            map.select_date =  Reports.selectedDate
            map.aryDailyReportArray = DRMovement.arrMoment
            self.navigationController?.pushViewController(map, animated: true)
        }
    }
    
    
    
}

extension DRMovement:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(DRMovement.arrMoment.count > 0 || DRMovement.arrActualMoment.count > 0){
            lblDistance.isHidden = false
            lblTotalMinute.isHidden = false
        }else{
            lblDistance.isHidden = true
            lblTotalMinute.isHidden = true
        }
        lblDistance.text = String.init(format:"Total: %.3f  KM",totalkm)
        lblTotalMinute.text =  String.init(format:"\(totalminuts) min")
        if(DRMovement.arrActualMoment.count > 0){
            return DRMovement.arrActualMoment.count
        }else{
            print(DRMovement.arrMoment.count)
            
            return DRMovement.arrMoment.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.ReportMomentCell, for: indexPath) as? SalesReportCell{
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if(DRMovement.arrActualMoment.count > 0){
                cell.vwTitle.backgroundColor = UIColor.PlannedVisitIndicationcolor
                cell.lblTitleType.text = "salesreport cell"
            }else{
                cell.lblTitleType.font = UIFont.boldSystemFont(ofSize: 15)
                cell.lblSubTitle.font = UIFont.boldSystemFont(ofSize: 15)
                cell.lblSubTitle.textColor = UIColor.darkGray
                
                let visit = DRMovement.arrMoment[indexPath.row]
                
                cell.vwTitle.backgroundColor = UIColor.PlannedVisitIndicationcolor
                
                //cell.vwSpeedDistance.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEBF5FF)
                
                if(type(of: visit) ==  Movementmodel.self){
                    if let model = visit as? Movementmodel{
                        cell.lblSubTitle.text = model.checkInCustomerName
                        cell.vwConclusion.isHidden = true
                        cell.lblInValue.font = UIFont.systemFont(ofSize: 15)
                        cell.lblOutValue.font = UIFont.systemFont(ofSize: 15)
                        if(model.kms.doubleValue > 0){
                            cell.lblDisValue.attributedText = NSMutableAttributedString.init(string: String.init(format:"%.3f  KM", model.kms.doubleValue), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                            
                        }else{
                            cell.lblDisValue.text = String.init(format:"0.0 KM")
                            cell.lblSpeedValue.text  = String.init(format:"0 KM/hr")
                        }
                        
                        
                        
                        if let strcheckInTime =  model.checkInTime{
                            if let strcheckOutTime = model.checkOutTime{
                                if(strcheckInTime.count > 0){
                                    var strch = ""
                                    if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                        strch = strcht
                                    }
                                    let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    //                attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                                    // cell.lblAssigneeName.attributedText  = attrbutedString
                                    cell.lblInValue.attributedText = attrbutedString//Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                                }else{
                                    let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblInValue.attributedText = attrbutedString 
                                    cell.lblMinute.isHidden = true
                                }
                                if(strcheckOutTime.count > 0 ){
                                    var strch = ""
                                    if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                        strch = strcht
                                    }
                                    
                                    let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    //                attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                                    // cell.lblAssigneeName.attributedText  = attrbutedString
                                    cell.lblOutValue.attributedText = attrbutedString
                                    
                                    if((cell.lblInValue.text?.count ?? 0 > 0  &&  (cell.lblInValue.text != "--:--")) && (cell.lblOutValue.text?.count ?? 0 > 0 && (cell.lblOutValue.text != "--:--")) && (cell.lblInValue.isHidden == false && cell.lblOutValue.isHidden ==  false)){
                                        let minutes = Utils.differenceOfMinutes(previTime: cell.lblInValue.text ?? "0:0", nextTime: cell.lblOutValue.text ?? "0:0")
                                        cell.lblMinute.isHidden = false
                                        cell.lblMinute.text = String.init(format:"\(minutes) min")
                                        if(model.kms.doubleValue > 0  && minutes
                                            > 0){
                                            cell.lblSpeedValue.text = String.init(format:"%0.2f KM/h",model.kms.doubleValue/Double(minutes))
                                        }else{
                                            cell.lblSpeedValue.text = String.init(format:"0 KM/h")
                                        }
                                        
                                    }else{
                                        cell.lblMinute.isHidden = true
                                    }
                                }else{
                                    let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblOutValue.attributedText = attrbutedString
                                    cell.lblMinute.isHidden = true
                                }
                                
                            }else{
                                
                                if(strcheckInTime.count > 0){
                                    var strch = ""
                                    if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                        strch = strcht
                                    }
                                    let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblInValue.attributedText = attrbutedString
                                }else{
                                    let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblInValue.attributedText = attrbutedString
                                }
                                let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                cell.lblOutValue.attributedText = attrbutedString
                                
                            }
                        }
                        if(model.detailType == 1){
                            cell.lblMinute.isHidden = true
                            cell.vwSpeedDistance.isHidden = true
                            if(indexPath.row == 0){
                                cell.lblTitleType.text = "Attendance Check-IN"
                                cell.lblSubTitle.text = "Office CheckIn"
                                cell.lblInTitle.isHidden = false
                                cell.lblInValue.isHidden = false
                                cell.lblOutTilte.isHidden = true
                                cell.lblOutValue.isHidden = true
                            }else{
                                cell.lblTitleType.text = "Attendance Check-Out"
                                cell.lblSubTitle.text = "Office CheckOut"
                                cell.lblInTitle.isHidden = true
                                cell.lblInValue.isHidden = true
                                cell.lblOutTilte.isHidden =  false
                                cell.lblOutValue.isHidden = false
                            }
                            if   let  attendanceObj = DRMovement.arrMoment[indexPath.row] as? AttendanceHistory{
                                cell.lblTitleType.text = "Attendance Check-IN"
                                
                                
                            }
                        }else if(model.detailType == 2){
                            cell.vwSpeedDistance.isHidden = false
                            cell.lblInTitle.isHidden = false
                            cell.lblInValue.isHidden = false
                            cell.lblOutTilte.isHidden =  false
                            cell.lblOutValue.isHidden = false
                            cell.lblTitleType.text = "Visit"
                            if let idofmodule = model.moduleID as? NSNumber{
                                cell.lblSubTitle.text?.append("(# \(idofmodule))")
                            }//String.in ?? <#default value#>it(format:"\(model?.checkInCustomerName)  (\(model?.modulePrimaryID))")
                        }else if(model.detailType == 3){
                            cell.vwSpeedDistance.isHidden = false
                            cell.lblInTitle.isHidden = false
                            cell.lblInValue.isHidden = false
                            cell.lblOutTilte.isHidden =  false
                            cell.lblOutValue.isHidden = false
                            cell.lblTitleType.text = "Lead"
                            if let idofmodule = model.modulePrimaryID as? NSNumber{
                                cell.lblSubTitle.text?.append("(# \(idofmodule))")
                            }
                        }else if(model.detailType == 4){
                            cell.vwSpeedDistance.isHidden = false
                            cell.lblInTitle.isHidden = false
                            cell.lblInValue.isHidden = false
                            cell.lblOutTilte.isHidden =  false
                            cell.lblOutValue.isHidden = false
                            cell.lblTitleType.text = "Activity"
                            if  let activity = visit as? Activitymodel{
                                
                                if let strcheckInTime =  activity.checkInTime{
                                    if let strcheckOutTime = activity.checkOutTime{
                                        if(strcheckInTime.count > 0){
                                            var strch = ""
                                            if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                                strch = strcht
                                            }
                                            let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                            cell.lblInValue.attributedText = attrbutedString
                                        }else{
                                            let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                            cell.lblInValue.attributedText = attrbutedString
                                        }
                                        if(strcheckOutTime.count > 0 ){
                                            var strch = ""
                                            if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                                strch = strcht
                                            }
                                            let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                            cell.lblOutValue.attributedText = attrbutedString
                                            if((cell.lblInValue.text?.count ?? 0 > 0  &&  (cell.lblInValue.text != "--:--")) && (cell.lblOutValue.text?.count ?? 0 > 0 && (cell.lblOutValue.text != "--:--")) && (cell.lblInValue.isHidden == false && cell.lblOutValue.isHidden ==  false)){
                                                cell.lblMinute.isHidden = false
                                                let minutes = Utils.differenceOfMinutes(previTime: cell.lblInValue.text ?? "0:0", nextTime: cell.lblOutValue.text ?? "0:0")
                                                
                                                cell.lblMinute.text = String.init(format:"\(minutes) min")
                                                if(model.kms.doubleValue > 0  && minutes
                                                    > 0){
                                                    cell.lblSpeedValue.text = String.init(format:"%0.2f KM/h",model.kms.doubleValue/Double(minutes))
                                                }else{
                                                    cell.lblSpeedValue.text = String.init(format:"0 KM/h")
                                                }
                                            }else{
                                                cell.lblMinute.isHidden = true
                                            }
                                        }else{
                                            let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                            cell.lblOutValue.attributedText = attrbutedString
                                            cell.lblMinute.isHidden = true
                                        }
                                        
                                    }else{
                                        
                                        if(strcheckInTime.count > 0){
                                            var strch = ""
                                            if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                                strch = strcht
                                            }
                                            let attrbutedString = NSMutableAttributedString.init(string:  Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                            cell.lblInValue.attributedText = attrbutedString
                                            
                                        }else{
                                            let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                            cell.lblInValue.attributedText = attrbutedString
                                        }
                                        
                                        let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblOutValue.attributedText = attrbutedString
                                        
                                    }
                                }
                            }
                        }else if(model.detailType == 5){
                            cell.vwSpeedDistance.isHidden = false
                            cell.lblTitleType.text = "Unplanned Visit"
                            cell.lblInTitle.isHidden = false
                            cell.lblInValue.isHidden = false
                            cell.lblOutTilte.isHidden =  false
                            cell.lblOutValue.isHidden = false
                            if let idofmodule = model.moduleID as? NSNumber{
                                cell.lblSubTitle.text?.append("(# \(idofmodule))")
                            }
                            
                            /*
                             if(model.kms.doubleValue > 0  && minutes
                             > 0){
                             cell.lblSpeedValue.text = String.init(format:"%0.2f KM/h",model.kms.doubleValue/Double(minutes))
                             }else{
                             cell.lblSpeedValue.text = String.init(format:"0 KM/h")
                             }
                             **/
                            
                            if let km = model.kms as? NSNumber{
                                
                                if(model.kms.doubleValue > 0){
                                    cell.lblDisValue.attributedText = NSMutableAttributedString.init(string: String.init(format:"%.3f  KM", model.kms.doubleValue), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                                    let minutes = Utils.differenceOfMinutes(previTime: cell.lblInValue.text ?? "0:0", nextTime: cell.lblOutValue.text ?? "0:0")
                                    if(model.kms.doubleValue > 0  && minutes
                                        > 0){
                                        cell.lblSpeedValue.text = String.init(format:"%0.2f KM/h",model.kms.doubleValue/Double(minutes))
                                    }else{
                                        cell.lblSpeedValue.text = String.init(format:"0 KM/h")
                                    }
                                    
                                }else{
                                    cell.lblDisValue.text = String.init(format:"0.0 KM")
                                    cell.lblSpeedValue.text  = String.init(format:"0 KM/hr")
                                }
                                
                            }
                            
                            if let strcheckInTime =  model.checkInTime{
                                if let strcheckOutTime = model.checkOutTime{
                                    if(strcheckInTime.count > 0){
                                        var strch = ""
                                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                            strch = strcht
                                        }
                                        let attrbutedString = NSMutableAttributedString.init(string:  Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblInValue.attributedText = attrbutedString
                                        
                                    }else{
                                        let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblInValue.attributedText = attrbutedString
                                    }
                                    if(strcheckOutTime.count > 0 ){
                                        var strch = ""
                                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                            strch = strcht
                                        }
                                        let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblOutValue.attributedText = attrbutedString
                                        if((cell.lblInValue.text?.count ?? 0 > 0  &&  (cell.lblInValue.text != "--:--")) && (cell.lblOutValue.text?.count ?? 0 > 0 && (cell.lblOutValue.text != "--:--")) && (cell.lblInValue.isHidden == false && cell.lblOutValue.isHidden ==  false)){
                                            let minutes = Utils.differenceOfMinutes(previTime: cell.lblInValue.text ?? "0:0", nextTime: cell.lblOutValue.text ?? "0:0")
                                            cell.lblMinute.isHidden = false
                                            cell.lblMinute.text = String.init(format:"\(minutes) min")
                                            if(model.kms.doubleValue > 0  && minutes
                                                > 0){
                                                cell.lblSpeedValue.text = String.init(format:"%0.2f KM/h",model.kms.doubleValue/Double(minutes))
                                            }else{
                                                cell.lblSpeedValue.text = String.init(format:"0 KM/h")
                                            }
                                            
                                        }else{
                                            cell.lblMinute.isHidden = true
                                        }
                                        
                                    }else{
                                        cell.lblMinute.isHidden = true
                                        let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblOutValue.attributedText = attrbutedString
                                        
                                    }
                                    
                                }else{
                                    
                                    if(strcheckInTime.count > 0){
                                        var strch = ""
                                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                            strch = strcht
                                        }
                                        let attrbutedString = NSMutableAttributedString.init(string:  Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblInValue.attributedText = attrbutedString
                                        
                                    }else{
                                        let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblInValue.attributedText = attrbutedString
                                        
                                    }
                                    let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblOutValue.attributedText = attrbutedString
                                    
                                    
                                }
                            }
                            
                            if(model.prodescription.count ?? 0 > 0){
                                if let conclusion = model.prodescription{
                                    cell.lblConclusion.text = String.init(format:"Conclusion: \(conclusion)")
                                }
                            }else{
                                cell.vwConclusion.isHidden = true
                            }
                            cell.vwConclusion.isHidden = true
                        }
                        
                    }
                    
                }
                else if(type(of: visit) == PlannVisit.self){
                    cell.lblMinute.isHidden = false
                    let planvisit = visit as? PlannVisit
                    //    cell.lblDisValue.text = String.init(format:"\(planvisit.K)")
                    //    cell.lblSpeedValue.text = String.init(format:)
                    cell.lblInTitle.isHidden = false
                    cell.lblInValue.isHidden = false
                    cell.lblOutTilte.isHidden =  false
                    cell.lblOutValue.isHidden = false
                    if(planvisit?.isManual == 1){
                        cell.lblTitleType.text = "Manual Visit"
                    }else{
                        cell.lblTitleType.text = "Visit"
                    }
                    
                    var strCustomerName = NSMutableAttributedString()
                    
                    if(planvisit?.customerName?.count ?? 0 > 0){
                        strCustomerName = NSMutableAttributedString.init(string: planvisit?.customerName ?? "", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                    }else{
                        strCustomerName =  NSMutableAttributedString.init(string:"Customer Not Mapped", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                    }
                    
                    if let visitno = planvisit?.seriesPostfix{
                        strCustomerName.append(NSMutableAttributedString.init(string:" (#\(visitno))", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
                    }
                    cell.lblSubTitle.attributedText = strCustomerName
                    if let checkinobj = planvisit?.checkInOutData[0] as? VisitCheckInOutList{
                        
                        if let strcheckInTime =  checkinobj.checkInTime{
                            if let strcheckOutTime = checkinobj.checkOutTime{
                                
                                
                                
                                if(strcheckInTime.count > 0){
                                    var strch = ""
                                    if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.checkInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                        strch = strcht
                                    }
                                    let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblInValue.attributedText = attrbutedString
                                    
                                }else{
                                    let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblInValue.attributedText = attrbutedString
                                    
                                }
                                if(strcheckOutTime.count > 0 ){
                                    var strch = ""
                                    if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.checkOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                        strch = strcht
                                    }
                                    let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblOutValue.attributedText = attrbutedString
                                    
                                    cell.lblMinute.isHidden = false
                                    if((cell.lblInValue.text?.count ?? 0 > 0  &&  (cell.lblInValue.text != "--:--")) && (cell.lblOutValue.text?.count ?? 0 > 0 && (cell.lblOutValue.text != "--:--")) && (cell.lblInValue.isHidden == false && cell.lblOutValue.isHidden ==  false)){
                                        let minutes = Utils.differenceOfMinutes(previTime: cell.lblInValue.text ?? "0:0", nextTime: cell.lblOutValue.text ?? "0:0")
                                        cell.lblMinute.isHidden = false
                                        cell.lblMinute.text = String.init(format:"\(minutes) min")
                                        //    cell.lblSpeedValue.text = String.init(format:"%0.2f K/h",model.kms.doubleValue/Double(minutes))
                                    }else{
                                        cell.lblMinute.isHidden = true
                                    }
                                    
                                }else{
                                    let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblOutValue.attributedText = attrbutedString
                                    
                                    cell.lblMinute.isHidden = true
                                }
                                
                            }else{
                                
                                if(strcheckInTime.count > 0){
                                    var strch = ""
                                    if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.checkInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                        strch = strcht
                                    }
                                    let attrbutedString = NSMutableAttributedString.init(string:  Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblInValue.attributedText = attrbutedString
                                    
                                }else{
                                    let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblInValue.attributedText = attrbutedString
                                    
                                }
                                let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                cell.lblOutValue.attributedText = attrbutedString
                                
                                
                            }
                        }
                    }
                    // cell.imgInteractionType.image = UIImage.init(named: "icon_planvisit_interaction_metting")
                    //cell.vwCustomer.backgroundColor = UIColor.clear
                    
                    //cell.lblCheckinDetail.text = "Not Checked-IN Yet"
                    self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                    let dtnextAction = self.dateFormatter.date(from: planvisit?.nextActionTime ?? "3/02/2020 4:05 am")
                    self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
                    let titleNextAction = NSMutableAttributedString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray]) //NSMutableString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
                    titleNextAction.append(NSAttributedString.init(string: self.dateFormatter.string(from: dtnextAction ?? Date()), attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
                    //cell.lblNextActionDetail.attributedText  = titleNextAction
                    
                    if(planvisit?.conclusion?.count ?? 0 > 0){
                        if let conclusion = planvisit?.conclusion{
                            cell.lblConclusion.text = String.init(format:"Conclusion: \(conclusion)")
                        }
                    }else{
                        cell.vwConclusion.isHidden = true
                    }
                    cell.vwConclusion.isHidden = true
                    cell.vwSpeedDistance.isHidden = false
                    if let checkindata = planvisit?.checkInOutData.firstObject as? VisitCheckInOutList {
                        cell.lblDisValue.text = String.init(format:"%0.2f KM",checkindata.kM)
                        if(checkindata.kM > 0 && checkindata.checkInTime.count > 0 && checkindata.checkOutTime.count > 0 && checkindata.approvedBy > 0){
                            let minutes = Utils.differenceOfMinutes(previTime: checkindata.checkInTime , nextTime: checkindata.checkOutTime)
                            cell.lblSpeedValue.text = String.init(format:"%0.2f KM/h",(checkindata.kM)/(Double(minutes/60)))
                        }else{
                            cell.lblSpeedValue.text = String.init(format:"%0.2f KM/h",0)
                        }
                    }
                    
                    //            if(model.kms.doubleValue > 0  && minutes
                    //                > 0){
                    //            cell.lblSpeedValue.text = String.init(format:"%0.2f KM/h",model.kms.doubleValue/Double(minutes))
                    //            }else{
                    //                cell.lblSpeedValue.text = String.init(format:"0 KM/h")
                    //            }
                    
                    
                }else if(type(of: visit) == Lead.self){
                    cell.lblTitleType.text = "Lead"
                    cell.lblInTitle.isHidden = false
                    cell.lblInValue.isHidden = false
                    cell.lblOutTilte.isHidden =  false
                    cell.lblOutValue.isHidden = false
                    cell.vwConclusion.isHidden = true
                    if let objlead = visit as? Lead{
                        
                        cell.lblSubTitle.text = objlead.customerName
                        if let idofmodule = objlead.seriesPostfix as? NSNumber{
                            cell.lblSubTitle.text?.append("(# \(idofmodule))")
                        }
                        if let checkinobj = objlead.leadCheckInOutList[0] as? LeadCheckInOutList{
                            
                            if let strcheckInTime =  checkinobj.checkInTime as? String{
                                if let strcheckOutTime = checkinobj.checkOutTime as? String{
                                    
                                    if(strcheckInTime.count > 0){
                                        var strch = ""
                                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                            strch = strcht
                                        }
                                        let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblInValue.attributedText = attrbutedString
                                        
                                    }
                                    else{
                                        let attrbutedString = NSMutableAttributedString.init(string: "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblInValue.attributedText = attrbutedString
                                        
                                    }
                                    if(strcheckOutTime.count > 0 ){
                                        var strch = ""
                                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: strcheckOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                            strch = strcht
                                        }
                                        
                                        let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblOutValue.attributedText = attrbutedString
                                        
                                        if((cell.lblInValue.text?.count ?? 0 > 0  &&  (cell.lblInValue.text != "--:--")) && (cell.lblOutValue.text?.count ?? 0 > 0 && (cell.lblOutValue.text != "--:--")) && (cell.lblInValue.isHidden == false && cell.lblOutValue.isHidden ==  false)){
                                            let minutes = Utils.differenceOfMinutes(previTime: cell.lblInValue.text ?? "0:0", nextTime: cell.lblOutValue.text ?? "0:0")
                                            cell.lblMinute.isHidden = false
                                            cell.lblMinute.text = String.init(format:"\(minutes) min")
                                            // cell.lblSpeedValue.text = String.init(format:"%0.2f K/h",model.kms.doubleValue/Double(minutes))
                                        }else{
                                            cell.lblMinute.isHidden = true
                                        }
                                    }else{
                                        let attrbutedString = NSMutableAttributedString.init(string:  "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                        cell.lblOutValue.attributedText = attrbutedString
                                        
                                        cell.lblMinute.isHidden = true
                                    }
                                }
                                
                            }
                        }
                        if let checkindata = objlead.leadCheckInOutList.firstObject as? LeadCheckInOutList {
                            cell.lblDisValue.text = String.init(format:"%0.2f KM",checkindata.kM)
                            if(checkindata.kM > 0 && checkindata.checkInTime.count > 0 && checkindata.checkOutTime.count > 0 && checkindata.approvedBy > 0){
                                let minutes = Utils.differenceOfMinutes(previTime: checkindata.checkInTime , nextTime: checkindata.checkOutTime)
                                cell.lblSpeedValue.text = String.init(format:"%0.2f KM/h",(checkindata.kM)/(Double(minutes/60)))
                            }else{
                                cell.lblSpeedValue.text = String.init(format:"%0.2f KM/h",0)
                            }
                        }
                        
                    }
                    
                    
                }
                else if(type(of: visit) == AttendanceHistory.self){
                    cell.vwSpeedDistance.isHidden = true
                    cell.lblMinute.text = ""
                    if(indexPath.row == 0){
                        cell.lblTitleType.text = "Attendance Check - In"
                    }else{
                        cell.lblTitleType.text = "Attendance Check - Out"
                    }
                    
                    if   let  attendanceObj = DRMovement.arrMoment[indexPath.row] as? AttendanceHistory{
                        if(indexPath.row == 0){
                            if (attendanceObj.checkInAttendanceType == 1){
                                cell.lblSubTitle.text = "Office CheckIn"
                            }
                            else if (attendanceObj.checkInAttendanceType == 2){
                                cell.lblSubTitle.text = "Vendor CheckIn"
                            }
                            else if (attendanceObj.checkInAttendanceType == 3){
                                cell.lblSubTitle.text = "Customer CheckIn"
                            }else if (attendanceObj.checkInAttendanceType == 4){
                                cell.lblSubTitle.text = "Travel Local CheckIn"
                            }
                            else if (attendanceObj.checkInAttendanceType == 7){
                                cell.lblSubTitle.text = "Travel Upcountry CheckIn"
                            }
                            else if (attendanceObj.checkInAttendanceType == 8){
                                cell.lblSubTitle.text = "Home CheckIn"
                            }            else{
                                cell.lblSubTitle.text = "CheckIn"
                            }
                        }else{
                            if (attendanceObj.checkOutAttendanceType == 1){
                                cell.lblSubTitle.text = "Office CheckOut"
                            }
                            else if (attendanceObj.checkOutAttendanceType == 2){
                                cell.lblSubTitle.text = "Vendor CheckOut"
                            }
                            else if (attendanceObj.checkOutAttendanceType == 3){
                                cell.lblSubTitle.text = "Customer CheckOut"
                            }else if (attendanceObj.checkOutAttendanceType == 4){
                                cell.lblSubTitle.text = "Travel Local CheckOut"
                            }
                            else if (attendanceObj.checkOutAttendanceType == 7){
                                cell.lblSubTitle.text = "Travel Upcountry CheckOut"
                            }
                            else if (attendanceObj.checkOutAttendanceType == 8){
                                cell.lblSubTitle.text = "Home CheckOut"
                            }
                            
                            else{
                                cell.lblSubTitle.text = "CheckOut"
                            }
                        }
                        cell.vwConclusion.isHidden = true
                        
                        if(indexPath.row == 0){
                            if(attendanceObj.checkInAttendanceType > 0 ){
                                if(attendanceObj.checkInApproved){
                                    cell.lblInValue.textColor = UIColor.black
                                }else{
                                    cell.lblInValue.textColor = UIColor.systemBlue
                                }
                                if let strcheckintime  = attendanceObj.checkInTime as? NSDate{
                                    let attrbutedString = NSMutableAttributedString.init(string:   Utils.getDateWithAppendingDay(day: 0, date: strcheckintime as Date, format: "hh:mm a", defaultTimeZone: true), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblInValue.attributedText = attrbutedString
                                    
                                    cell.lblOutTilte.isHidden = true
                                    cell.lblOutValue.isHidden = true
                                    cell.lblInTitle.isHidden = false
                                    cell.lblInValue.isHidden = false
                                }
                                if let strupdatetime  = attendanceObj.updatedTimeIn as? NSDate{
                                    let attrbutedString = NSMutableAttributedString.init(string:   Utils.getDateWithAppendingDay(day: 0, date: strupdatetime as Date, format: "hh:mm a", defaultTimeZone: true), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblInValue.attributedText = attrbutedString
                                    
                                    cell.lblOutTilte.isHidden = true
                                    cell.lblOutValue.isHidden = true
                                    cell.lblInTitle.isHidden = false
                                    cell.lblInValue.isHidden = false
                                }
                                
                            }
                        }else{
                            if(attendanceObj.checkOutAttendanceType > 0 ){
                                if(attendanceObj.checkOutApproved){
                                    cell.lblOutValue.textColor = UIColor.black
                                }else{
                                    cell.lblOutValue.textColor = UIColor.systemBlue
                                }
                                if let strcheckouttime  = attendanceObj.checkOutTime as? NSDate{
                                    
                                    let attrbutedString = NSMutableAttributedString.init(string: Utils.getDateWithAppendingDay(day: 0, date: strcheckouttime as Date, format: "hh:mm a", defaultTimeZone: true), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblOutValue.attributedText = attrbutedString
                                    
                                    /*  if((cell.lblInValue.text?.count ?? 0 > 0  &&  (cell.lblInValue.text != "--:--")) && (cell.lblOutValue.text?.count ?? 0 > 0 && (cell.lblOutValue.text != "--:--")) && (cell.lblInValue.isHidden == false && cell.lblOutValue.isHidden ==  false)){
                                     //                        let minutes = Utils.differenceOfMinutes(previTime: cell.lblInValue.text ?? "0:0", nextTime: cell.lblOutValue.text ?? "0:0")
                                     //                            cell.lblMinute.isHidden = false
                                     //                        cell.lblMinute.text = String.init(format:"\(minutes) min")
                                     //                            print("min is  = \(cell.lblMinute.text)")
                                     // cell.lblSpeedValue.text = String.init(format:"%0.2f K/h",model.kms.doubleValue/Double(minutes))
                                     }else{
                                     //     cell.lblMinute.isHidden = true
                                     }*/
                                    // cell.lblMinute.isHidden = true
                                    cell.lblInTitle.isHidden = true
                                    cell.lblInValue.isHidden = true
                                    cell.lblOutTilte.isHidden = false
                                    cell.lblOutValue.isHidden = false
                                }
                                if let strupdatecheckouttime  = attendanceObj.updatedTimeOut as? NSDate{
                                    
                                    let attrbutedString = NSMutableAttributedString.init(string: Utils.getDateWithAppendingDay(day: 0, date: strupdatecheckouttime as Date, format: "hh:mm a", defaultTimeZone: true), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                    cell.lblOutValue.attributedText = attrbutedString
                                    
                                    if((cell.lblInValue.text?.count ?? 0 > 0  &&  (cell.lblInValue.text != "--:--")) && (cell.lblOutValue.text?.count ?? 0 > 0 && (cell.lblOutValue.text != "--:--")) && (cell.lblInValue.isHidden == false && cell.lblOutValue.isHidden ==  false)){
                                        //                        let minutes = Utils.differenceOfMinutes(previTime: cell.lblInValue.text ?? "0:0", nextTime: cell.lblOutValue.text ?? "0:0")
                                        //                            cell.lblMinute.isHidden = false
                                        //                        cell.lblMinute.text = String.init(format:"\(minutes) min")
                                        //                    cell.lblSpeedValue.text = String.init(format:"0 KM/h")
                                        // cell.lblSpeedValue.text = String.init(format:"%0.2f K/h",model.kms.doubleValue/Double(minutes))
                                    }else{
                                        //      cell.lblMinute.isHidden = true
                                    }
                                    cell.lblInTitle.isHidden = true
                                    cell.lblInValue.isHidden = true
                                    cell.lblOutTilte.isHidden = false
                                    cell.lblOutValue.isHidden = false
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                    cell.lblSubTitle.setMultilineLabel(lbl:cell.lblSubTitle)
                }
                else{
                    cell.vwSpeedDistance.isHidden = false
                    cell.lblTitleType.text = "Visit"
                    let planvisit = visit as? UnplannedVisit
                    var strCustomerName = NSMutableAttributedString()
                    
                    if(planvisit?.tempCustomerObj?.CustomerName?.count ?? 0 > 0){
                        strCustomerName = NSMutableAttributedString.init(string: planvisit?.tempCustomerObj?.CustomerName ?? "", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                    }else{
                        strCustomerName =  NSMutableAttributedString.init(string:"Customer Not Mapped", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                    }
                    
                    if let visitno = planvisit?.seriesPostfix{
                        strCustomerName.append(NSMutableAttributedString.init(string:" (#\(visitno))" , attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
                    }
                    cell.lblSubTitle.attributedText = strCustomerName
                    
                    if let strcheckInTime =  planvisit?.checkinTime{
                        if let strcheckOutTime = planvisit?.checkoutTime{
                            
                            if(strcheckInTime.count > 0){
                                var strch = ""
                                if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.checkinTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                    strch = strcht
                                }
                                let attrbutedString = NSMutableAttributedString.init(string:  Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                cell.lblInValue.attributedText = attrbutedString
                                
                            }else{
                                let attrbutedString = NSMutableAttributedString.init(string:  "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                cell.lblInValue.attributedText = attrbutedString
                                
                                cell.lblMinute.isHidden = true
                            }
                            if(strcheckOutTime.count > 0 ){
                                var strch = ""
                                if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.checkoutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                    strch = strcht
                                }
                                
                                let attrbutedString = NSMutableAttributedString.init(string:  Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                cell.lblOutValue.attributedText = attrbutedString
                                
                                cell.lblOutTilte.isHidden = false
                                cell.lblOutValue.isHidden = false
                                
                                if((cell.lblInValue.text?.count ?? 0 > 0  &&  (cell.lblInValue.text != "--:--")) && (cell.lblOutValue.text?.count ?? 0 > 0 && (cell.lblOutValue.text != "--:--")) && (cell.lblInValue.isHidden == false && cell.lblOutValue.isHidden ==  false)){
                                    let minutes = Utils.differenceOfMinutes(previTime: cell.lblInValue.text ?? "0:0", nextTime: cell.lblOutValue.text ?? "0:0")
                                    cell.lblMinute.isHidden = false
                                    cell.lblMinute.text = String.init(format:"\(minutes) min")
                                    cell.lblSpeedValue.text = String.init(format:"0.00 Km")
                                    //  cell.lblSpeedValue.text = String.init(format:"%0.2f K/h",model.kms.doubleValue/Double(minutes))
                                }else{
                                    cell.lblSpeedValue.isHidden = true
                                    cell.lblMinute.isHidden = true
                                }
                            }else{
                                let attrbutedString = NSMutableAttributedString.init(string:  "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                cell.lblOutValue.attributedText = attrbutedString
                                
                                cell.lblMinute.isHidden = true
                            }
                            
                        }else{
                            cell.lblMinute.isHidden = true
                            if(strcheckInTime.count > 0){
                                var strch = ""
                                if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.checkinTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                    strch = strcht
                                }
                                let attrbutedString = NSMutableAttributedString.init(string:  Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                cell.lblInValue.attributedText = attrbutedString
                                
                            }else{
                                let attrbutedString = NSMutableAttributedString.init(string:  "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                                cell.lblInValue.attributedText = attrbutedString
                                
                            }
                            let attrbutedString = NSMutableAttributedString.init(string:  "--:--", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                            cell.lblOutValue.attributedText = attrbutedString
                            
                            
                            
                        }
                    }
                    // cell.imgInteractionType.image = UIImage.init(named: "icon_planvisit_interaction_metting")
                    //cell.vwCustomer.backgroundColor = UIColor.clear
                    
                    //cell.lblCheckinDetail.text = "Not Checked-IN Yet"
                    self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                    let dtnextAction = self.dateFormatter.date(from: planvisit?.NextActionTime ?? "3/02/2020 4:05 am")
                    self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
                    let titleNextAction = NSMutableAttributedString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray]) //NSMutableString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
                    titleNextAction.append(NSAttributedString.init(string: self.dateFormatter.string(from: dtnextAction ?? Date()), attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
                    //cell.lblNextActionDetail.attributedText  = titleNextAction
                    
                    if(planvisit?.conclusion?.count ?? 0 > 0){
                        if let conclusion = planvisit?.conclusion{
                            cell.lblConclusion.text = String.init(format:"Conclusion: \(conclusion)")
                        }
                    }else{
                        cell.vwConclusion.isHidden = true
                    }
                    cell.vwConclusion.isHidden = true
                }
                
            }
            if(cell.lblSpeedValue.text?.count == 0 && cell.lblSpeedValue.isHidden == false){
                cell.lblSpeedValue.text = "N/A"
            }
            if(cell.lblDisValue.text?.count == 0 && cell.lblDisValue.isHidden ==  false){
                cell.lblDisValue.text = "0.00 KM"
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let visit = DRMovement.arrMoment[indexPath.row]
        
        if(type(of: visit) == PlannVisit.self){
            let planvisit =  visit as? PlannVisit
            //            if let objVisit = PlannVisit.getVisit(visitID: NSNumber.init(value:planvisit?.iD ?? 0)) as? PlannVisit{
            //                if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
            //                    print("count of check in at redirection time = \(planvisit?.checkInOutData.count)")
            //                 visitDetail.visitType = VisitType.planedvisit
            //                visitDetail.redirectTo =  0
            //                visitDetail.planvisit = objVisit
            //                self.navigationController?.pushViewController(visitDetail, animated: true)
            //                }
            //            }else{
            self.getplanvisitDetial(visitId: NSNumber.init(value:planvisit?.iD ?? 0) , ForAction: "srgsr")
            //   }
            //            let planvisit = visit as? PlannVisit
            //            if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
            //                if(planvisit?.visitStatusID == 2){
            //                    visitDetail.visitType = VisitType.planedvisitHistory
            //                }else{
            //             visitDetail.visitType = VisitType.planedvisit
            //                }
            //            visitDetail.redirectTo =  0
            //
            //            visitDetail.planvisit = planvisit
            //            self.navigationController?.pushViewController(visitDetail, animated: true)
            //            }
        }else if(type(of: visit) ==  UnplannedVisit.self){
            
            let unplanvisit = visit as? UnplannedVisit
            self.getunplannedVisitDetail(coldcallId: NSNumber.init(value:unplanvisit?.localID ?? 0) ?? NSNumber.init(value:0))
            //            if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
            //
            //             visitDetail.visitType = VisitType.coldcallvisit
            //            visitDetail.redirectTo =  0
            //            visitDetail.unplanvisit = unplanvisit
            //            self.navigationController?.pushViewController(visitDetail, animated: true)
            //            }
        }else if(type(of: visit) == AttendanceHistory.self){
            //attendance
            let attendanceshistory = visit as? AttendanceHistory
            if(indexPath.row == 0){
                Common.showalert(title: "CheckIn Address", msg: attendanceshistory?.checkInAddress ?? "", view: self)
            }else{
                Common.showalert(title: "CheckOut Address", msg: attendanceshistory?.checkOutAddress ?? "", view: self)
            }
        }else if(type(of: visit) ==  Lead.self){
            let lead = visit as? Lead
            self.getleadDetail(leadId: NSNumber.init(value:lead?.iD ?? 0))
            //  let leadstatus = aLeadStatusListing[indexPath.row]
            //            if  let lead = visit as? Lead{
            //            if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
            //                leadDetail.isHistory = false
            //                leadDetail.redirectTo =  0
            //                leadDetail.lead = lead
            //
            //            self.navigationController?.pushViewController(leadDetail, animated: true)
            //            }
            //            }
        }else if(type(of: visit) == Movementmodel.self){
            let model = visit as? Movementmodel
            if(model?.detailType == 1){
                // attendance
                if(indexPath.row == 0){
                    Common.showalert(title: "CheckIn Address", msg: model?.chekInAddress ?? "", view: self)
                }else{
                    Common.showalert(title: "CheckOut Address", msg: model?.checkOutAddress ?? "", view: self)
                }
            }else if(model?.detailType == 2){
                //visit  PlannVisit.getVisit(visitID: model.modulePrimaryID) as? PlannVisit{
                //                if let planvisit = PlannVisit.getVisit(visitID: model?.modulePrimaryID ?? NSNumber.init(value: 0)) as? PlannVisit{
                //                if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                //
                //                 visitDetail.visitType = VisitType.planedvisit
                //                visitDetail.redirectTo =  0
                //                visitDetail.planvisit = planvisit
                //                self.navigationController?.pushViewController(visitDetail, animated: true)
                //                }
                //                }else{
                self.getplanvisitDetial(visitId: model?.modulePrimaryID ?? 0, ForAction: "srgsr")
                //  }
            }else if(model?.detailType == 3){
                //Lead
                
                self.getleadDetail(leadId: NSNumber.init(value:model?.modulePrimaryID.intValue ?? 0))
                //                if let objLead = Lead.getLeadByID(Id: model?.modulePrimaryID.intValue ?? 0){
                //                    if let leadDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadDetail) as? LeadDetail{
                //
                //                    leadDetail.isHistory = false
                //                    leadDetail.redirectTo =  0
                //                    leadDetail.lead =  objLead
                //                    self.navigationController?.pushViewController(leadDetail, animated: true)
                //                    }
                //                }
            }else if(model?.detailType == 4){
                //Activity
            }else{
                //unplanned visit
                self.getunplannedVisitDetail(coldcallId: model?.modulePrimaryID ?? NSNumber.init(value:0))
            }
            
        }
    }
}

