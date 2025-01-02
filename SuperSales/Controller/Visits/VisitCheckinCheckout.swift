//
//  VisitCheckinCheckout.swift
//  SuperSales
//
//  Created by Apple on 13/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation
import FastEasyMapping

class VisitCheckinCheckout: BaseViewController {
    var visitType = VisitType.coldcallvisit
    static var verifyAddress:Bool!
    static var verifyCheckoutAddress:Bool!
    var parentView:UIView!
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // window.rootViewController = UIViewController()
        // window.windowLevel = UIWindow.Level.alert
        // window.makeKeyAndVisible()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - API Calling
    func   checkin(visitstatus:Int,lat:NSNumber,long:NSNumber,isVisitPlanned:VisitType,objplannedVisit:PlannVisit,objunplannedVisit:UnplannedVisit,visitid:NSNumber,viewcontroller:UIViewController,addressID:NSNumber){
        if(Utils().FirstCheckInAttendance(view: viewcontroller) ==  true){
            if(activesetting.customTagging == NSNumber.init(value: 3)){
                
                if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
                    if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:objplannedVisit.customerID)))){
                        Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view:self.view)
                        return
                    }
                }
            }
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            visitType = isVisitPlanned
            DispatchQueue.main.async {
                self.parentView = viewcontroller.view
            }
            
            let currentLocation = Location.sharedInsatnce.currentLocation
            let chlo = CLLocation.init(latitude: (CLLocationDegrees.init(exactly: lat) ?? CLLocationDegrees.init(exactly: 0)) ?? 0, longitude:CLLocationDegrees.init(exactly: long) ?? 0 )
            //   Common.showalert(msg: "cl lat:: \(currentLocation?.coordinate.latitude), lng :: \(currentLocation?.coordinate.longitude) , ch l lat :: \(lat) , lng :: \(long)  meter  \(currentLocation?.distance(from: chlo))", view:  viewcontroller)
            
            self.apihelper.checkin(lat: lat, long: long, visitID: visitid , id: visitstatus) {
                (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                
                
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    //                 Utils.toastmsg(message: message, view: viewcontroller.view)
                    
                    let dicOfAttendance = arr as? [String:Any] ?? [String:Any]()
                    
                    if(dicOfAttendance["CheckInCheckOutStatusID"] as? Int ?? 100 == 0){
                        Utils.toastmsg(message: message, view: viewcontroller.view)
                        print(dicOfAttendance["CheckInCheckOutStatusID"] as? Int ?? 100)
                        if(self.activeuser?.role?.id?.intValue ?? 0 > 6 ){
                            SVProgressHUD.dismiss()
                            Utils.removeShadow(view: viewcontroller.view)
                            let noAction = UIAlertAction.init(title: NSLocalizedString("no", comment:""), style: .cancel, handler: { (action) in
                                SVProgressHUD.show()
                                
                                self.deleteCheckIn(id: dicOfAttendance["ID"] as? NSNumber ?? NSNumber.init(value: 0))
                            })
                            
                            let yesAction = UIAlertAction.init(title: NSLocalizedString("yes", comment:""), style: .destructive, handler: { (action) in
                                SVProgressHUD.show()
                                if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.planedvisitHistory || self.visitType == VisitType.directvisitcheckin){
                                    
                                    if let planvisit = PlannVisit.getVisit(visitID:dicOfAttendance["VisitID"] as? NSNumber ?? NSNumber.init(value: 0)){
                                        MagicalRecord.save({ (localcontext) in
                                            FEMDeserializer.collection(fromRepresentation: [dicOfAttendance], mapping: VisitCheckInOutList.defaultmapping(), context: localcontext)
                                            localcontext.mr_save({ (localcontext) in
                                                print("saving")
                                            })
                                            if(self.visitType != VisitType.directvisitcheckin){
                                                localcontext.mr_saveToPersistentStoreAndWait()
                                                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                                            }
                                        }, completion: { (status, error) in
                                            
                                            if  let visitcheckinoutlistobj = VisitCheckInOutList().getVisitcheckinoutFromID(visitID: NSNumber.init(value: objplannedVisit.iD)){
                                                print("counts of checkin before add check in visit \(objplannedVisit.checkInOutData.count) need to added checkin object = \(visitcheckinoutlistobj) , checkin time = \(visitcheckinoutlistobj.checkInTime) and dic = \(dicOfAttendance)")
                                                if(self.visitType != VisitType.directvisitcheckin){
                                                planvisit.insertObject(value:visitcheckinoutlistobj , at: 0)
                                                }

                                            }
                                            
                                          
                                            planvisit.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                                if(error == nil){
                                                    print("checkin data saved sucessfully")
                                                    let checkinInfo:[String:Any] = ["visitType":self.visitType,"visitId":visitid,"message":message]
                                                    print("check in data = \(planvisit.checkInOutData.count) 1")
                                                    NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: nil,userInfo: checkinInfo)
                                                    
                                                }else{
                                                    print(error?.localizedDescription ?? "")
                                                }
                                            })
                                            
                                            // objplannedVisit
                                        })
                                        // })
                                    }
                                    
                                }else{
                                    
                                    
                                    objunplannedVisit.checkInList?.insert(CheckInData().initwithdic(dict: dicOfAttendance), at: 0)
                                    let checkinInfo:[String:Any] = ["visitType":self.visitType,"visitId":visitid,"message":message]
                                    
                                    NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: checkinInfo)
                                }
                                
                                
                                
                                
                                self.visitCheckInApproval(id: NSNumber.init(value:dicOfAttendance["ID"] as? Int ?? 0), withVisitID: visitid, lat: lat, long: long)
                                
                            })
                            SVProgressHUD.dismiss()
                            Common.showalertWithAction(msg:NSLocalizedString("your_current_location_is_different_from_customer_location_do_you_want_to_sent_approval_for_check_in", comment: "") , arrAction:[yesAction,noAction], view: viewcontroller)
                            
                        }else{
                            let noAction = UIAlertAction.init(title: NSLocalizedString("no", comment:""), style: .cancel, handler: { (action) in
                                SVProgressHUD.show()
                                self.deleteCheckIn(id: dicOfAttendance["ID"] as? NSNumber ?? NSNumber.init(value: 0))
                            })
                            
                            let yesAction = UIAlertAction.init(title: NSLocalizedString("yes", comment:""), style: .destructive, handler: { (action) in
                                SVProgressHUD.show()
                                Utils.toastmsg(message: message, view: viewcontroller.view)
                                //     Utils.toastmsg(message: message, view: viewcontroller.view)
                                if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.planedvisitHistory || self.visitType == VisitType.directvisitcheckin){
                                    if  let planvisit = PlannVisit.getVisit(visitID:dicOfAttendance["VisitID"] as? NSNumber ?? NSNumber.init(value: 0)) as? PlannVisit{
                                        //  let visitstatuslist = planvisit.visitStatusList
                                        MagicalRecord.save({ (localcontext) in
                                            FEMDeserializer.collection(fromRepresentation: [dicOfAttendance], mapping: VisitCheckInOutList.defaultmapping(), context: localcontext)
                                            localcontext.mr_save({ (localcontext) in
                                                print("saving")
                                            })
                                            if(self.visitType != VisitType.directvisitcheckin){
                                                localcontext.mr_saveToPersistentStoreAndWait()
                                                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                                            }
                                        }, completion: { (status, error) in
                                            
                                            if  let visitcheckinoutlistobj = VisitCheckInOutList().getVisitcheckinoutFromID(visitID: NSNumber.init(value: objplannedVisit.iD)){
                                                print("counts of checkin before add check in visit \(objplannedVisit.checkInOutData.count) need to added checkin object = \(visitcheckinoutlistobj) , checkin time = \(visitcheckinoutlistobj.checkInTime) and dic = \(dicOfAttendance)")
                                                if(self.visitType != VisitType.directvisitcheckin){
                                                planvisit.insertObject(value:visitcheckinoutlistobj , at: 0)
                                                }
                                                //   planvisit.visitStatusList =  visitstatuslist
                                                //let checkinlist =   planvisit.checkInOutData as? NSMutableOrderedSet
                                                //checkinlist?.add(visitcheckinoutlistobj)
                                                //planvisit.checkInOutData =  checkinlist!
                                                //print(planvisit.checkInOutData.count)
                                                
                                            }
                                            
                                            planvisit.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                                if(error == nil){
                                                    print("checkin data saved sucessfully")
                                                    let checkinInfo:[String:Any] = ["visitType":self.visitType,"visitId":visitid,"message":message]
                                                    print("check in data = \(planvisit.checkInOutData.count) 2")
                                                    NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: nil,userInfo: checkinInfo)
                                                    if(self.visitType == VisitType.directvisitcheckin){
                                                        //                                                    do {
                                                        //                                                        sleep(10)
                                                        //                                                    }
                                                        if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                                            if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                                                                
                                                                self.navigationController?.popToViewController(controller,animated:true)
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                                    //
                                                                    SVProgressHUD.dismiss()
                                                                }
                                                            }
                                                        }else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                                            
                                                            if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                                                                self.navigationController?.popToViewController(controller,animated:true)
                                                                SVProgressHUD.dismiss()
                                                            }
                                                        }else{
                                                            
                                                            self.navigationController?.popViewController(animated:true)
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                                //
                                                                SVProgressHUD.dismiss()
                                                            }
                                                        }
                                                    }
                                                }else{
                                                    
                                                    print(error?.localizedDescription ?? "")
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                        //
                                                        SVProgressHUD.dismiss()
                                                    }
                                                }
                                            })
                                            // objplannedVisit
                                        })
                                        // })
                                    }
                                }else{
                                    SVProgressHUD.dismiss()
                                    objunplannedVisit.checkInList?.insert(CheckInData().initwithdic(dict: dicOfAttendance), at: 0)
                                    let checkinInfo:[String:Any] = ["visitType":self.visitType,"visitId":visitid,"message":message]
                                   
                                    NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: checkinInfo)
                                    
                                    
                                    //         }
                                    
                                }
                                //            if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.planedvisitHistory){
                                self.updateCheckIn(id: NSNumber.init(value:dicOfAttendance["ID"] as? Int ?? 0), checkinId: visitid, lat: lat, long: long,visitType: self.visitType,planobj: objplannedVisit,unplanobj: objunplannedVisit)
                                //            }else{
                                //                self.updateCheckIn(id: NSNumber.init(value:dicOfAttendance["ID"] as? Int ?? 0), checkinId: visitid, lat: lat, long: long,visitType: isVisitPlanned,planobj: objplannedVisit,unplanobj: objunplannedVisit)
                                //            }
                                
                            })
                            SVProgressHUD.dismiss()
                            Common.showalertWithAction(msg:NSLocalizedString("your_current_location_is_different_from_customer_location_do_you_want_to_update_customer_location_for_check_in", comment: "") , arrAction:[yesAction,noAction], view: viewcontroller)
                        }
                        
                    }
                    else{
                        Utils.toastmsg(message: message, view: viewcontroller.view)
                        if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.planedvisitHistory || self.visitType == VisitType.directvisitcheckin){
                            if  let planvisit = PlannVisit.getVisit(visitID:dicOfAttendance["VisitID"] as? NSNumber ?? NSNumber.init(value: 0)) as? PlannVisit{
                                MagicalRecord.save({ (localcontext) in
                                    FEMDeserializer.collection(fromRepresentation: [dicOfAttendance], mapping: VisitCheckInOutList.defaultmapping(), context: localcontext)
                                   
                                    localcontext.mr_save({ (localcontext) in
                                                                                 
                                                print("saving")
                                        })
                                    if(self.visitType != VisitType.directvisitcheckin){
                                        localcontext.mr_saveToPersistentStoreAndWait()
                                        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                                        localcontext.mr_save({ (localcontext) in
                                            print("saving checkin")

                                        })
                                        if(viewcontroller is VisitDetail){
                                        localcontext.mr_saveToPersistentStoreAndWait()
                                        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                                        }
                                    }
                                }, completion: { (status, error) in
                                    if  let visitcheckinoutlistobj = VisitCheckInOutList().getVisitcheckinoutFromID(visitID: NSNumber.init(value: objplannedVisit.iD)){
                                        print("counts of checkin before add check in visit \(objplannedVisit.checkInOutData.count) need to added checkin object = \(visitcheckinoutlistobj) , checkin time = \(visitcheckinoutlistobj.checkInTime) and dic = \(dicOfAttendance)")
                                        if(self.visitType != VisitType.directvisitcheckin && viewcontroller is VisitDetail){
                                        planvisit.insertObject(value:visitcheckinoutlistobj , at: 0)
                                        }

                                    }
                                    planvisit.managedObjectContext?.mr_save({ (localmanagecontext) in
                                        print("saving")
                                    }, completion: { (status, error) in
                                        if(error == nil){
                                            print("checkin data saved sucessfully")
                                            let checkinInfo:[String:Any] = ["visitType":self.visitType,"visitId":visitid,"message":message]
                                            print("check in data = \(planvisit.checkInOutData.count) 3")
                                            NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: nil)
                                            
                                            if(self.visitType == VisitType.directvisitcheckin){
                                                if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                                    if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                                                        
                                                        self.navigationController?.popToViewController(controller,animated:true)
                                                        
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                            //
                                                            SVProgressHUD.dismiss()
                                                        }
                                                        
                                                    }
                                                }else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                                    
                                                    if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                                                        self.navigationController?.popToViewController(controller,animated:true)
                                                        
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                            //
                                                            SVProgressHUD.dismiss()
                                                        }
                                                        
                                                    }
                                                }else{
                                                    self.navigationController?.popViewController(animated: true)
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                        //
                                                        SVProgressHUD.dismiss()
                                                    }
                                                    
                                                }
                                            }
                                        }else{
                                            SVProgressHUD.dismiss()
                                            Utils.toastmsg(message: error?.localizedDescription ?? "", view: viewcontroller.view)
                                            print(error?.localizedDescription ?? "")
                                        }
                                    })
                                    // objplannedVisit
                                })
                                // })
                            }
                        }
                        else{
                            //   Utils.toastmsg(message: message, view: viewcontroller.view)
                            objunplannedVisit.checkInList.insert(CheckInData().initwithdic(dict: dicOfAttendance), at: 0)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                Utils.toastmsg(message: message, view: viewcontroller.view)
                                SVProgressHUD.dismiss()
                                let checkinInfo:[String:Any] = ["visitType":self.visitType,"visitId":visitid,"message":message]
                               
                                NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: checkinInfo)
                            }
                            //self.updateDataForColdCall(objun:objunplannedVisit,obj:CheckInData().initwithdic(dict: dicOfAttendance),msg:message,viewController:viewcontroller) { (status) in
                            //
                            //     if(status == true){
                            //         Utils.toastmsg(message: message, view: viewcontroller.view)
                            //                    NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: nil)
                            //                }
                            //            }
                            
                            
                            //            if(self.visitType == VisitType.coldcallvisitwithdicheckin){
                            //                if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                            //                                                                                if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                            //                                                                                                                               self.navigationController?.popToViewController(controller,animated:true)
                            //                                                                                                                           }
                            //                                                                                                                       }else{
                            //                                                                                                               self.navigationController?.popViewController(animated:true)
                            //                                                                                                                       }
                            //            }
                            // self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                }else{
                    //  Utils.toastmsg(message: message, view: viewcontroller.view)
                    print(message)
                    
                    if((message == NSLocalizedString("you_are_not_at_work_location_please_refresh_location", comment: "") && (self.visitType ==  VisitType.planedvisit || self.visitType == VisitType.planedvisitHistory || self.visitType == VisitType.directvisitcheckin)) || (message == NSLocalizedString("you_are_not_at_work_location_please_do_manual_Check_IN", comment: "") && (self.visitType ==  VisitType.planedvisit || self.visitType == VisitType.planedvisitHistory || self.visitType == VisitType.directvisitcheckin)) || (message == "You are at different location") && (self.visitType ==  VisitType.planedvisit || self.visitType == VisitType.planedvisitHistory || self.visitType == VisitType.directvisitcheckin) ){
                        let viewOnMapAction = UIAlertAction.init(title: NSLocalizedString("VIEW_ON_MAP", comment: ""), style: .cancel, handler: { (action) in
                            if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
                                map.isFromDashboard = false
                                if(self.visitType == VisitType.directvisitcheckin){
                                    Common.skipVisitSelection = false
                                }
                                if(isVisitPlanned == VisitType.coldcallvisit){
                                    map.isFromColdCall = true
                                    map.isFromVisitLeadDetail = true
                                    map.unplanvisit = objunplannedVisit
                                    map.lattitude = NSNumber.init(value: Int(objunplannedVisit.tempCustomerObj?.Lattitude ?? "0") ?? 0)//NSNumber.init(coder:Int(objunplannedVisit?.tempCustomerObj.Lattitude ?? "0") ?? 0)
                                    map.longitude = NSNumber.init(value: Int(objunplannedVisit.tempCustomerObj?.Longitude ?? "0") ?? 0) //NSNumber.init(value:Int(objunplannedVisit?.tempCustomerObj.Longitude ?? "0") ?? 0)
                                }else if( isVisitPlanned == VisitType.directvisitcheckin){
                                    map.isFromColdCall = false
                                    map.isFromVisitLeadDetail = true
                                    map.planvisit = objplannedVisit
                                    if let address =  AddressList().getAddressByAddressId(aId: addressID){
                                        //
                                        let latdouble = Float(address.lattitude ?? "0.0000")//address.lattitude ?? 0.00 //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                                        
                                        let longdouble = Float(address.longitude ?? "0.0000")//address.longitude ?? 0.00  //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                                        //    let latdouble = Float(address.lattitude ?? "0.000" )
                                        //    let longdouble = Float(address.longitude ?? "0.000")
                                        print("address id = \(addressID) , lat = \(NSNumber.init(value:latdouble ?? 0.00)), long = \(NSNumber.init(value:longdouble ?? 0.00))")
                                        map.lattitude = NSNumber.init(value:latdouble ?? 0.00)
                                        map.longitude = NSNumber.init(value:longdouble ?? 0.00)
                                    }else
                                    
                                    if   let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:objplannedVisit.addressMasterID)){
                                        
                                        let latdouble = Float(address.lattitude ?? "0.0000")//address.lattitude ?? 0.00 //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                                        
                                        let longdouble = Float(address.longitude ?? "0.0000")//address.longitude ?? 0.00  //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                                        //    let latdouble = Float(address.lattitude ?? "0.000" )
                                        //    let longdouble = Float(address.longitude ?? "0.000")
                                        map.lattitude = NSNumber.init(value:latdouble ?? 0.00)
                                        map.longitude = NSNumber.init(value:longdouble ?? 0.00)
                                        print("address id with planvisit = \(objplannedVisit.addressMasterID) , lat = \(NSNumber.init(value:latdouble ?? 0.00)), long = \(NSNumber.init(value:longdouble ?? 0.00))")
                                    }else{
                                        map.lattitude = NSNumber.init(value:0)
                                        map.longitude = NSNumber.init(value:0)
                                    }
                                    
                                    
                                }
                                else if(isVisitPlanned == VisitType.planedvisit ){
                                    if((self.activesetting.customTagging == 3) && (isVisitPlanned == VisitType.planedvisit)){
                                        if(!Utils.isCustomerMapped(cid: NSNumber.init(value:objplannedVisit.customerID))){
                                            
                                            Utils.toastmsg(message: NSLocalizedString("customer_not_mapped_so_you_cant_view_location", comment: ""), view: self.parentView)
                                            return
                                        }
                                    }
                                    
                                    map.planvisit = objplannedVisit
                                    map.isFromColdCall = false
                                    map.isFromVisitLeadDetail = true
                                    if let address =  AddressList().getAddressByAddressId(aId: addressID){
                                        //
                                        let latdouble = Float(address.lattitude ?? "0.0000")//address.lattitude ?? 0.00 //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                                        
                                        let longdouble = Float(address.longitude ?? "0.0000")//address.longitude ?? 0.00  //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                                        //    let latdouble = Float(address.lattitude ?? "0.000" )
                                        //    let longdouble = Float(address.longitude ?? "0.000")
                                        map.lattitude = NSNumber.init(value:latdouble ?? 0.00)
                                        map.longitude = NSNumber.init(value:longdouble ?? 0.00)
                                    }else
                                    
                                    if   let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:objplannedVisit.addressMasterID)){
                                        
                                        let latdouble = Float(address.lattitude ?? "0.0000")//address.lattitude ?? 0.00 //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                                        
                                        let longdouble = Float(address.longitude ?? "0.0000")//address.longitude ?? 0.00  //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                                        //    let latdouble = Float(address.lattitude ?? "0.000" )
                                        //    let longdouble = Float(address.longitude ?? "0.000")
                                        map.lattitude = NSNumber.init(value:latdouble ?? 0.00)
                                        map.longitude = NSNumber.init(value:longdouble ?? 0.00)
                                        
                                    }else{
                                        map.lattitude = NSNumber.init(value:0)
                                        map.longitude = NSNumber.init(value:0)
                                    }
                                }
                                viewcontroller.navigationController?.pushViewController(map, animated: true)
                                SVProgressHUD.dismiss()
                            }
                        })
                        let manualAction = UIAlertAction.init(title: NSLocalizedString("MANUAL_CHECK_IN", comment: ""), style: .default, handler: { (action) in
                            SVProgressHUD.show()
                            self.manualCheckin(visitid: visitid , manuallat:lat, manuallong: long, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, viewcontroller: viewcontroller, visitType: isVisitPlanned)
                        })
                        let refreshAction = UIAlertAction.init(title: NSLocalizedString("Refresh", comment:""), style: .default, handler: { (action) in
                            
                            Utils.toastmsg(message: "Location Refreshing", view: self.parentView)
                            SVProgressHUD.dismiss()
                        })
                        let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment:""), style: .default, handler: nil)
                        if(isVisitPlanned == VisitType.directvisitcheckin ){
                            
                            if(VisitCheckinCheckout.verifyAddress == true){
                                Common.showalertWithAction(msg: message, arrAction: [viewOnMapAction,manualAction,cancelAction], view: viewcontroller)
                                SVProgressHUD.dismiss()
                            }else{
                                
                                Utils.toastmsg(message: "Verifying Address", view: viewcontroller.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    //                                Utils.removeShadow(view: viewcontroller.view)
                                    //                                SVProgressHUD.show()
                                    self.verfyingAddress(status: visitstatus, lat: lat, long: long, isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
                                }
                                
                            }
                        }else{
                            if(VisitCheckinCheckout.verifyAddress){
                                Common.showalertWithAction(msg: message, arrAction: [viewOnMapAction,manualAction,refreshAction,cancelAction], view: viewcontroller)
                                SVProgressHUD.dismiss()
                            }else{
                                //                            SVProgressHUD.dismiss()
                                Utils.toastmsg(message: "Verifying Address", view: viewcontroller.view)
                                //  Utils.addShadow(view: viewcontroller.view)
                                let secondsToDelay = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                    
                                    self.verfyingAddress(status: visitstatus, lat: lat, long: long, isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
                                }
                                
                            }
                        }
                        
                    }else{
                        self.navigationController?.popViewController(animated: true)
                        Utils.toastmsg(message: message, view: viewcontroller.view)
                        SVProgressHUD.dismiss()
                        
                        //
                    }
                }
            }
            
        }
    }
    
    func verfyingAddress(status:Int,lat:NSNumber,long:NSNumber,isVisitPlanned:VisitType,objplannedVisit:PlannVisit,objunplannedVisit:UnplannedVisit,visitid:NSNumber,viewcontroller:UIViewController,addressID:NSNumber){
        // let currenlocation =  Location.sharedInsatnce.currentLocation
        
        
        if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
            //          CLLocationCoordinate2DIsValid(currentCoordinate)
            if(CLLocationCoordinate2DIsValid(currentCoordinate)){
                let currentlat =  currentCoordinate.latitude
                let currentlong = currentCoordinate.longitude
                if var checkinverify = VisitCheckinCheckout.verifyAddress as? Bool{
                    if(!checkinverify){
                        VisitCheckinCheckout.verifyAddress = true
                        
                        
                        self.checkin(visitstatus: status, lat: NSNumber.init(value:currentlat), long: NSNumber.init(value:currentlong), isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
                        
                    }
                }
                if var checkoutverify = VisitCheckinCheckout.verifyCheckoutAddress as? Bool{
                    if(!checkoutverify){
                        VisitCheckinCheckout.verifyCheckoutAddress = true
                        self.checkout(visitstatus: status, lat: NSNumber.init(value: currentlat), long: NSNumber.init(value: currentlong), isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, viewcontroller: viewcontroller, addressID: addressID)
                        
                    }
                }
                
                //  self.checkin(visitstatus: status, lat: currentlat, long: currentlong, isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
                // self.checkin(visitstatus: status, lat: currentCoordinate.latitude, long: currentCoordinate.longitude, isVisitPlanned: VisitType.directvisitcheckin, objplannedVisit: objplannedVisit, objunplannedVisit: UnplannedVisit(), visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
            }else{
                SVProgressHUD.dismiss()
                Utils.toastmsg(message: "negative lattitude or longitude", view: viewcontroller.view)
            }
            //}
        }else{
            SVProgressHUD.dismiss()
            Utils.toastmsg(message: "Please check your gps", view: viewcontroller.view)
        }
    }
    
    func updateDataForColdCall(objun:UnplannedVisit,obj:CheckInData,msg:String,viewController:UIViewController,completionHandler: CompletionHandler) {
        Utils.toastmsg(message: msg, view: viewController.view)
        // download code.
        
        objun.checkInList.insert(obj, at: 0)
        // true if download succeed,false otherwise
        
        completionHandler(true)
    }
    func manualCheckin(visitid:NSNumber,manuallat:NSNumber,manuallong:NSNumber,objplannedVisit:PlannVisit,objunplannedVisit:UnplannedVisit,viewcontroller:UIViewController,visitType:VisitType){
        var param = Common.returndefaultparameter()
        
        let manualvisit = ["VisitID":visitid,"CreatedBy":activeuser?.userID,"CompanyID":activeuser?.company?.iD,"Lattitude":manuallat,"Longitude":manuallong,"CheckInCheckOutStatusID":NSNumber.init(value: 1),"StatusID":NSNumber.init(value: 2)]
        param["visitManualCheckInJson"] = Common.json(from: manualvisit)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlVisitManualCheckIn, method: Apicallmethod.post) {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            if(error.code == 0){
                Utils.toastmsg(message: message, view: viewcontroller.view)
                
                
                if(responseType == ResponseType.dic){
                    if let dicResponse:[String:Any] = arr as? [String:Any] {
                        print(dicResponse)
                        if(self.visitType == VisitType.coldcallvisit){
                            
                            let checkin = CheckInData().initwithdic(dict: dicResponse)
                            objunplannedVisit.checkInList.insert(checkin, at: 0)
                            let checkinInfo:[String:Any] = ["visitType":self.visitType,"visitId":visitid,"message":message]
                            NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: checkinInfo)
                            SVProgressHUD.dismiss()
                        }else{
                            
                            print(objplannedVisit.checkInOutData.count)
                            MagicalRecord.save({ (localcontext) in
                                FEMDeserializer.collection(fromRepresentation: [dicResponse], mapping: VisitCheckInOutList.defaultmapping(), context: localcontext)
                                
                                print("dic response of checkout api = \(dicResponse)")
                                localcontext.mr_saveToPersistentStore(completion: { (status, error) in
                                    print("saving")
                                })
                                
                            }, completion: { (status, error) in
                                print("compeletion = \(status)")
                                print(error?.localizedDescription ?? "")
                                
                                if let visitcheckinoutlistobj = VisitCheckInOutList().getVisitcheckinoutFromID(visitID:visitid){
                                    
                                    // print(visitcheckinoutlistobj.count)
                                    
                                    print("counts of checkin before add check in visit \(objplannedVisit.checkInOutData.count) need to added checkin object = \(visitcheckinoutlistobj) , checkin time = \(visitcheckinoutlistobj.checkInTime) and dic = \(dicResponse)")
                                    
                                    objplannedVisit.insertObject(value:visitcheckinoutlistobj , at: 0)
                                    print(VisitCheckInOutList().getAllForVisit(visitID:NSNumber.init(value:objplannedVisit.iD)))
                                    print(objplannedVisit.iD)
                                    print("counts of checkin after add check in visit \(objplannedVisit.checkInOutData.count)")
                                    
                                    
                                    objplannedVisit.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                        if(error == nil){
                                            print("checkin data saved sucessfully")
                                            print(objplannedVisit.checkInOutData.count)
                                            let checkinInfo:[String:Any] = ["visitType":visitType,"visitId":visitid,"message":message]
                                            print("check in data = \(objplannedVisit.checkInOutData.count) 4")
                                            NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: nil,userInfo: checkinInfo)
                                            
                                        }else{
                                            SVProgressHUD.dismiss()
                                            print(error?.localizedDescription ?? "")
                                            print(objplannedVisit.checkInOutData.count)
                                        }
                                        
                                    })
                                }else{
                                    SVProgressHUD.dismiss()
                                    // Utils.toastmsg(message: message, view: viewcontroller.view)
                                    //                let checkinInfo:[String:Any] = ["visitType":visitType,"visitId":visitid,"message":message]
                                    // NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: nil,userInfo: checkinInfo)
                                    /*if(self.visitType == VisitType.directvisitcheckin){
                                     if let  controllerIndex = viewcontroller.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection
                                     }){
                                     if let controller = viewcontroller.navigationController?.viewControllers[controllerIndex - 1]{
                                     viewcontroller.navigationController?.popToViewController(controller,animated:true)
                                     }
                                     }else{
                                     viewcontroller.navigationController?.popViewController(animated:true)
                                     }
                                     }*/
                                    print("not get checkin record")
                                }
                                
                            })
                            //                      NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: nil)
                            
                        }
                    }
                    
                }
            }else{
                SVProgressHUD.dismiss()
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String) as? String ?? "" :error.localizedDescription ?? "", view: self.parentView)
            }
        }
        
    }
    
    
    func visitCheckInApproval(id:NSNumber,withVisitID:NSNumber,lat:NSNumber,long:NSNumber){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        var obj = [String:Any]()
        obj["ID"] = id
        obj["VisitID"] = withVisitID
        obj["CreatedBy"] = self.activeuser?.userID
        obj["CompanyID"] = self.activeuser?.company?.iD
        obj["Lattitude"] = lat
        obj["Longitude"] = long
        param["visitCheckInSendApprovalJson"] = Common.json(from: obj)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlVisitCheckInSendApproval, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                Utils.toastmsg(message: message, view: self.parentView)
                self.navigationController?.popViewController(animated: true)
                
            }else if(error.code == 0){
                Utils.toastmsg(message: message, view: self.parentView)
                self.navigationController?.popViewController(animated: true)
                SVProgressHUD.dismiss()
            }else{
                
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String) as? String ?? "" :error.localizedDescription ?? "", view: self.parentView)
                SVProgressHUD.dismiss()
                
            }
        }
    }
    
    func updateCheckIn(id:NSNumber,checkinId:NSNumber,lat:NSNumber,long:NSNumber,visitType:VisitType,planobj:PlannVisit,unplanobj:UnplannedVisit){
        var param = Common.returndefaultparameter()
        var param1 = [String:Any]()
        param1["VisitID"] = id
        param1["ID"] = checkinId
        param1["CheckInCheckOutStatusID"] =  NSNumber.init(value:1)
        param1["StatusID"] = NSNumber.init(value:2)
        SVProgressHUD.show(withStatus: "Send Check-IN Update.....")
        param["updateCheckInJson"] = Common.json(from: param1)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlUpdateCheckIn, method: Apicallmethod.post){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                Utils.toastmsg(message: message, view: self.parentView)
                
                self.verifyAddress(lat: lat, long: long,visitType: visitType,planobj: planobj,unplanobj: unplanobj)
            }else if(error.code == 0){
                Utils.toastmsg(message: message, view: self.parentView)
                SVProgressHUD.dismiss()
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String) as? String ?? "" :error.localizedDescription ?? "", view: self.parentView)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func verifyAddress(lat:NSNumber,long:NSNumber,visitType:VisitType,planobj:PlannVisit,unplanobj:UnplannedVisit){
        var param1 = Common.returndefaultparameter()
        param1["Lattitude"] = lat
        param1["Longitude"] = long
        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
            param1["CustomerID"] = planobj.customerID
            param1["AddressID"] = planobj.addressMasterID
        }else{
            param1["CustomerID"] = unplanobj.tempCustomerID
            param1["AddressID"] = unplanobj.addressMasterID
        }
        self.apihelper.getdeletejoinvisit(param: param1, strurl: ConstantURL.kWSUrlVerifyAddressLatLong, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                Utils.toastmsg(message: message, view: self.parentView)
                //                SVProgressHUD.dismiss()
            }else{
                Utils.toastmsg(message: message, view: self.parentView)
                SVProgressHUD.dismiss()
            }
        }
        //
    }
    
    func deleteCheckIn(id:NSNumber)->(){
        let deletedic = ["ID":id]
        var param =  Common.returndefaultparameter()
        param["deleteCheckInJson"] = Common.json(from: deletedic)
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlDeleteCheckIn, method: Apicallmethod.get) {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responsType) in
            if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responsType)
                self.navigationController?.popViewController(animated: true)
                SVProgressHUD.dismiss()
                //let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "VisitCheckInOutList")
                //fetchrequest.predicate = NSPredicate.init(format: "iD == %@", )
                
            }else{
                self.navigationController?.popViewController(animated: true)
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String) as! String:error.localizedDescription ?? "" , view: self.parentView)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    
    func checkout(visitstatus:Int,lat:NSNumber,long:NSNumber,isVisitPlanned:VisitType,objplannedVisit:PlannVisit,objunplannedVisit:UnplannedVisit,viewcontroller:UIViewController,addressID:NSNumber){
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        visitType = isVisitPlanned
        parentView = view
        var visitid = NSNumber.init(value:0)
        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
            visitid = NSNumber.init(value:objplannedVisit.iD)
        }else{
            visitid = NSNumber.init(value:objunplannedVisit.localID ?? 0)
        }
        
        self.apihelper.checkout(visitType: isVisitPlanned, lat: lat, long: long, visitID: visitid , id: visitstatus) {
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() ==  Constant.SucessResponseFromServer){
                //   Utils.toastmsg(message: message, view: viewcontroller.view)
                if(error.code == 0){
                    if(responseType == ResponseType.dic){
                        let dicOfAttendance = arr as? [String:Any] ?? [String:Any]()
                        
                        if(isVisitPlanned == VisitType.planedvisit || isVisitPlanned == VisitType.directvisitcheckin){
                            
                            
                            MagicalRecord.save({ (localcontext) in
                                let arrOfCheckOut = FEMDeserializer.collection(fromRepresentation: [dicOfAttendance], mapping: VisitCheckInOutList.defaultmapping(), context: localcontext)
                                print("arr of checkout = \(arrOfCheckOut)")
                                print("dic response of checkout api = \(dicOfAttendance)")
                                
                                localcontext.mr_saveToPersistentStoreAndWait()
                                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                                
                                
                            }, completion: { (status, error) in
                                
                                if let visitcheckinoutlistobj = VisitCheckInOutList().getVisitcheckinoutFromID(visitID: NSNumber.init(value: objplannedVisit.iD)){
                                    
                                    if(objplannedVisit.checkInOutData.count > 0){
                                        objplannedVisit.removeObjectFromCheckInOutData(at: 0)
                                    }
                                    objplannedVisit.insertObject(value:visitcheckinoutlistobj , at: 0)
                                    objplannedVisit.managedObjectContext?.mr_saveToPersistentStoreAndWait()
                                    
                                    NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                                    
                                    
                                }else{
                                    SVProgressHUD.dismiss()
                                    print("not get checkout")
                                }
                                
                                objplannedVisit.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                    if(error == nil){
                                        print("check out  data saved sucessfully")
                                        let checkinInfo:[String:Any] = ["visitType":isVisitPlanned,"visitId":visitid,"message":message]
                                        
                                        NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: nil,userInfo: checkinInfo)
                                        SVProgressHUD.dismiss()
                                    }else{
                                        print(error?.localizedDescription ?? "")
                                    }
                                })
                                // objplannedVisit
                            })
                            if((dicOfAttendance["CloseVisitFlag"] as? Int ?? 10) == 0){
                                print("visit should be deleted")
                                //                                    let result = PlannVisit.getVisitByPredicate(predicate: NSPredicate.init(format: "iD == %d", argumentArray: [visitid ?? 0]))
                                //                                    let context = PlannVisit.getContext()
                                //                                    print("delelte visits %@",result)
                                //                                    if(result.count > 0 ){
                                //                                        for visit in result{
                                //                                            context.delete(visit)
                                //                                        }
                                //                                        context.mr_saveToPersistentStore { (status, error) in
                                //                                            if(error ==  nil){
                                //                                                print("context did saved \(status)")
                                //
                                //                                                self.navigationController?.popViewController(animated: true)
                                //                                            }else{
                                //                                                print("error is = \(error?.localizedDescription)")
                                //                                             //   Utils.toastmsg(message:error?.localizedDescription ?? "",view:self.view)
                                //
                                //                                            }
                                //                                        }
                                //                                    }
                                
                            }
                        }else{
                            let dicOfAttendance = arr as? [String:Any] ?? [String:Any]()
                            //   objunplannedVisit.checkInList.insert(CheckInData().initwithdic(dict: dicOfAttendance), at: 0)
                            objunplannedVisit.checkInList.remove(at: 0)
                            objunplannedVisit.checkInList.insert(CheckInData().initwithdic(dict: dicOfAttendance), at: 0)
                            
                            //  objunplannedVisit.checkInList.
                            
                            let checkinInfo:[String:Any] = ["visitType":self.visitType,"visitId":visitid,"message":message]
                            NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: checkinInfo)
                            SVProgressHUD.dismiss()
                            print("visit is unplanned")
                        }
                    }
                }else{
                    print(message)
                    if((message == NSLocalizedString("you_are_not_at_work_location_please_refresh_location", comment: "")) || (message == NSLocalizedString("you_are_not_at_work_location_please_do_manual_Check_IN", comment: ""))){
                        
                        let viewOnMapAction = UIAlertAction.init(title: NSLocalizedString("VIEW_ON_MAP", comment: ""), style: .cancel, handler: { (action) in
                            if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
                                map.isFromDashboard = false
                                if(self.visitType == VisitType.directvisitcheckin){
                                    Common.skipVisitSelection = false
                                }
                                if(isVisitPlanned == VisitType.coldcallvisit){
                                    map.unplanvisit = objunplannedVisit
                                    map.isFromColdCall = true
                                    map.isFromVisitLeadDetail = false
                                    map.lattitude = NSNumber.init(value: Int(objunplannedVisit.tempCustomerObj?.Lattitude ?? "0") ?? 0)//NSNumber.init(coder:Int(objunplannedVisit?.tempCustomerObj.Lattitude ?? "0") ?? 0)
                                    map.longitude = NSNumber.init(value: Int(objunplannedVisit.tempCustomerObj?.Longitude ?? "0") ?? 0) //NSNumber.init(value:Int(objunplannedVisit?.tempCustomerObj.Longitude ?? "0") ?? 0)
                                }else if(isVisitPlanned == VisitType.planedvisit ){
                                    map.isFromColdCall = false
                                    map.isFromVisitLeadDetail = false
                                    if    let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:objplannedVisit.addressMasterID)){
                                        let latdouble = Float(address.lattitude ?? "0.0000")//address.lattitude ?? 0.00 //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                                        
                                        let longdouble =  Float(address.longitude ?? "0.0000")//address.longitude ?? 0.00 //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                                        //            let latdouble = Float(address.lattitude ?? "0.0000")
                                        //            let longdouble = Float(address.longitude ?? "0.0000")
                                        map.lattitude = NSNumber.init(value:latdouble ?? 0.00)
                                        map.longitude = NSNumber.init(value:longdouble ?? 0.00)
                                        
                                    }else{
                                        map.isFromColdCall = false
                                        map.isFromVisitLeadDetail = false
                                        
                                        map.lattitude = NSNumber.init(value:0)
                                        map.longitude = NSNumber.init(value:0)
                                        
                                    }
                                }
                                viewcontroller.navigationController?.pushViewController(map, animated: true)
                            }
                        })
                        let manualAction = UIAlertAction.init(title: NSLocalizedString("MANUAL_CHECK_OUT", comment: ""), style: .default, handler: { (action) in
                            self.manualCheckout(visitType: isVisitPlanned, visitid: NSNumber.init(value:objplannedVisit.iD) , manuallat:lat, manuallong: long, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, viewcontroller: viewcontroller)
                        })
                        let refreshAction = UIAlertAction.init(title: NSLocalizedString("Refresh", comment:""), style: .default, handler: { (action) in
                            Utils.toastmsg(message: "Location Refreshing", view: viewcontroller.view)
                            
                        })
                        let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment:""), style: .default, handler: nil)
                        if(VisitCheckinCheckout.verifyCheckoutAddress == true){
                            SVProgressHUD.dismiss()
                            Common.showalertWithAction(msg: message, arrAction: [viewOnMapAction,manualAction,refreshAction,cancelAction], view: viewcontroller)
                        }  else{
                            
                            Utils.toastmsg(message: "Verifying Address", view: viewcontroller.view)
                            
                            let secondsToDelay = 4.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                
                                self.verfyingAddress(status: visitstatus, lat: lat, long: long, isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
                            }
                            
                        }
                        
                    }else{
                        SVProgressHUD.dismiss()
                        Utils.toastmsg(message: message, view: viewcontroller.view)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                // Utils.toastmsg(message: message, view: viewcontroller.view)
                print(message)
                if((message == NSLocalizedString("you_are_not_at_work_location_please_refresh_location", comment: "")) || (message == NSLocalizedString("you_are_not_at_work_location_please_do_manual_Check_IN", comment: ""))){
                    let viewOnMapAction = UIAlertAction.init(title: NSLocalizedString("VIEW_ON_MAP", comment: ""), style: .cancel, handler: { (action) in
                        if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
                            map.isFromDashboard = false
                            if(self.visitType == VisitType.directvisitcheckin){
                                Common.skipVisitSelection = false
                            }
                            if(isVisitPlanned == VisitType.coldcallvisit){
                                map.unplanvisit = objunplannedVisit
                                map.isFromColdCall = true
                                map.isFromVisitLeadDetail = false
                                map.lattitude = NSNumber.init(value: Int(objunplannedVisit.tempCustomerObj?.Lattitude ?? "0") ?? 0)//NSNumber.init(coder:Int(objunplannedVisit?.tempCustomerObj.Lattitude ?? "0") ?? 0)
                                map.longitude = NSNumber.init(value: Int(objunplannedVisit.tempCustomerObj?.Longitude ?? "0") ?? 0) //NSNumber.init(value:Int(objunplannedVisit?.tempCustomerObj.Longitude ?? "0") ?? 0)
                            }else if(isVisitPlanned == VisitType.planedvisit || isVisitPlanned == VisitType.directvisitcheckin){
                                map.planvisit = objplannedVisit
                                map.isFromColdCall = false
                                map.isFromVisitLeadDetail = false
                                if   let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:objplannedVisit.addressMasterID)){
                                    let latdouble = Float(address.lattitude ?? "0.0000")//address.lattitude ?? 0.00 Float(add?.lattitude ?? "0.0000") //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")
                                    
                                    let longdouble = Float(address.longitude ?? "0.0000") //Float(add?.longitude ?? "0.0000") //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
                                    //        let latdouble  = Float(address.lattitude ?? "0.0000")
                                    //       let longdouble = Float(address.longitude ?? "0.0000")
                                    
                                    
                                    map.lattitude = NSNumber.init(value:latdouble ?? 0.00)
                                    map.longitude = NSNumber.init(value:longdouble ?? 0.00)
                                }else{
                                    map.isFromColdCall = false
                                    map.isFromVisitLeadDetail = false
                                    map.lattitude = NSNumber.init(value:0)
                                    map.longitude = NSNumber.init(value:0)
                                }
                            }
                            viewcontroller.navigationController?.pushViewController(map, animated: true)
                        }
                    })
                    let manualAction = UIAlertAction.init(title: NSLocalizedString("MANUAL_CHECK_OUT", comment: ""), style: .default, handler: { (action) in
                        self.manualCheckout(visitType: isVisitPlanned, visitid: visitid , manuallat:lat, manuallong: long, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, viewcontroller: viewcontroller)
                    })
                    let refreshAction = UIAlertAction.init(title: NSLocalizedString("Refresh", comment:""), style: .default, handler: { (action) in
                        
                        Utils.toastmsg(message: "Location Refreshing", view: viewcontroller.view)
                    })
                    let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment:""), style: .default, handler: nil)
                    if(VisitCheckinCheckout.verifyCheckoutAddress == true)
                    {
                        SVProgressHUD.dismiss()
                        Common.showalertWithAction(msg: message, arrAction: [viewOnMapAction,manualAction,refreshAction,cancelAction], view: viewcontroller)
                    }
                    else{
                        //                            SVProgressHUD.dismiss()
                        Utils.toastmsg(message: "Verifying Address", view: viewcontroller.view)
                        //  Utils.addShadow(view: viewcontroller.view)
                        let secondsToDelay = 4.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                            //                                Utils.removeShadow(view: viewcontroller.view)
                            //                                SVProgressHUD.show()
                            self.verfyingAddress(status: visitstatus, lat: lat, long: long, isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
                        }
                        
                    }
                }else{
                    SVProgressHUD.dismiss()
                    Utils.toastmsg(message: message, view: viewcontroller.view)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        
    }
    func checkForVisit(visitType:VisitType,planvisit:PlannVisit,unplanvisit:UnplannedVisit,viewcontroller:UIViewController,completion:@escaping(_ territorystatus:Bool)->()){
        var display = 0
        let group = DispatchGroup()
        var status = true
        
        if(visitType == VisitType.planedvisit && (!(visitType == VisitType.planedvisitHistory))){
            group.enter()
            if(self.activesetting.customTagging == 3){
                if(!(Utils.isCustomerMapped(cid: NSNumber.init(value:planvisit.customerID ?? 0)))){
                    if(display == 0){
                        display += 1
                        Utils.toastmsg(message:NSLocalizedString("customer_is_not_mapped_so_you_cant_Check_IN", comment: ""),view: self.view)
                    }
                    group.leave()
                    status = false
                    
                }else{
                    group.leave()
                }
                
            }else{
                group.leave()
            }
        }// && (arrofmandatorystepID.contains(38) Grishma said to remove it
        if(self.activesetting.mandatoryPictureInVisit == 1 ){
            group.enter()
            if(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                if(unplanvisit.isPictureAvailable ==  1){
                    group.leave()
                }else{
                    if(display == 0){
                        display += 1
                        Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
                    }
                    group.leave()
                    status = false
                    
                }
            }else{
                if let planVisit = planvisit as? PlannVisit{
                  
                    self.isPictureavailable(activeplanVisit: planVisit, completion: { (picstatus) in
                        if(picstatus){
                            group.leave()
                            
                        }else{
                            if(display == 0){
                                display += 1
                               // Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
                            }
                            group.leave()
                            status = false
                        }
                    })
                    
                    
                }
                
                
            }
        }// && (arrofmandatorystepID.contains(35) Grishma said to remove it
//        if(self.activesetting.mandatoryVisitReport == 1 ){
//            group.enter()
//            if (visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
//                if (unplanvisit.visitStatusList.count == 0){
//                    if(display == 0){
//                        display += 1
//                        Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
//                    }
//                    group.leave()
//                    status = false
//                }else{
//                    group.leave()
//                }
//            }else{
//                if (planvisit.visitStatusList.count == 0){
//                    if(display == 0){
//                        display += 1
//                        Utils.toastmsg(message:NSLocalizedString("please_submit_visit_report_to_do_Check_Out", comment: ""),view: self.view)
//                    }
//                    group.leave()
//                    status = false
//                }
//            }
//        }
        
        if((self.activesetting.requireSOFromVisitBeforeCheckOut == 1) && (!(visitType ==  VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory)) ){
            group.enter()
            /*  if(self.activesetting.requireVisitCounterShare == NSNumber.init(value: 1)){
             if let countershare = planvisit.visitCounterShare {
             
             }else{
             if(display == 0){
             display += 1
             Utils.toastmsg(message:NSLocalizedString("please_add_counter_share_in_this_visit_for_check_Out", comment: ""),view: self.view)
             }
             
             status = false
             }
             }
             else if(self.activesetting.requireVisitCollection == NSNumber.init(value: 1)){
             group.enter()
             if let countershare = planvisit.visitCollection as? VisitCollection {
             
             }else{
             if(display == 0){
             display += 1
             Utils.toastmsg(message:NSLocalizedString("please_add_collection_in_this_visit_for_check_Out", comment: ""),view: self.view)
             }
             status = false
             }
             }else*/
            
            
            if let order = Utils.getorderByVisitId(visitID: NSNumber.init(value: planvisit.iD ?? 0)){
                group.leave()
            }else{
                if(display == 0){
                    display += 1
                    Utils.toastmsg(message:"Please add sales order",view: self.view)
                }
                group.leave()
                status = false
            }
        }
        
//        if(self.activesetting.requireVisitCounterShare == NSNumber.init(value: 1)){
//            group.enter()
//            if let countershare = planvisit.visitCounterShare {
//                group.leave()
//            }else{
//                if(display == 0){
//                    display += 1
//                    Utils.toastmsg(message:NSLocalizedString("please_add_counter_share_in_this_visit_for_check_Out", comment: ""),view: self.view)
//                }
//                group.leave()
//                status = false
//            }
//        }
        
        group.notify(queue: .main){
          
            completion(status)
        }
    }
    
    func isPictureavailable(activeplanVisit:PlannVisit,completion: @escaping (_ picstatus:Bool)->()){
        let group = DispatchGroup()
        var availabale = false
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["VisitID"] =  activeplanVisit.iD
        group.enter()
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetVisitUploadImages, method: Apicallmethod.get) {
            
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                
                if(responseType == ResponseType.arr || responseType == ResponseType.arrOfAny){
                    let arrofpicturedata = arr as? [[String:Any]] ?? [[String:Any]]()
                    
                    if(arrofpicturedata.count > 0){
                        availabale = true
                    }else{
                        Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
                        availabale = false
                    }
                    
                    group.leave()
                
                    
                }else if(error.code == 0){
                  
                    availabale =  false
                    
                    
                    group.leave()
                    
                }else{
                    
                    availabale =  false
                    
                    Utils.toastmsg(message:"Error while checking picture",view: self.view)
                    group.leave()
                    
                }
            }
            
            
        }
        // Notify Completion of tasks on main thread.
        group.notify(queue: .main) {
            if(availabale == false){
                completion(availabale)
            }else{
                completion(availabale)
            }
        }
        
    }
    
    func manualCheckout(visitType:VisitType,visitid:NSNumber,manuallat:NSNumber,manuallong:NSNumber,objplannedVisit:PlannVisit,objunplannedVisit:UnplannedVisit,viewcontroller:UIViewController){
        self.checkForVisit(visitType: visitType, planvisit: objplannedVisit, unplanvisit: objunplannedVisit, viewcontroller: viewcontroller) { (status) in
            if(status){
                
                SVProgressHUD.show()
                var param = Common.returndefaultparameter()
                let manualvisit = ["VisitID":visitid,"CreatedBy":self.activeuser?.userID,"CompanyID":self.activeuser?.company?.iD,"Lattitude":manuallat,"Longitude":manuallong,"CheckInCheckOutStatusID":NSNumber.init(value: 1),"StatusID":NSNumber.init(value: 2)]
                param["visitManualCheckOutJson"] = Common.json(from: manualvisit)
                self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlVisitManualCheckOut, method: Apicallmethod.post) {
                    (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        print(responseType)
                        Utils.toastmsg(message: message, view: self.parentView)
                        
                        let dicResponse:[String:Any] = arr as? [String:Any] ?? [String:Any]()
                        if(responseType == ResponseType.dic){
                            
                            
                            if(self.visitType == VisitType.coldcallvisit){
                                SVProgressHUD.dismiss()
                                let checkin = CheckInData().initwithdic(dict: dicResponse)
                                objunplannedVisit.checkInList.insert(checkin, at: 0)
                                
                                let checkinInfo:[String:Any] = ["visitType":self.visitType,"visitId":visitid,"message":message]
                                NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: checkinInfo)
                                
                            }else{
                                
                                Utils.toastmsg(message: message, view: viewcontroller.view)
                                
                                MagicalRecord.save({ (localcontext) in
                                    //   FEMDeserializer.object(fromRepresentation: dicResponse, mapping: VisitCheckInOutList.defaultmapping(), context: localcontext)
                                    let arrofcheckinout = FEMDeserializer.collection(fromRepresentation: [dicResponse], mapping: VisitCheckInOutList.defaultmapping(), context: localcontext)
                                    print("arr of checkout = \(arrofcheckinout)")
                                    print("dic response of checkout api = \(dicResponse)")
                                    localcontext.mr_saveToPersistentStore(completion: { (status, error) in
                                        print("saving status =\(status) and error \(error?.localizedDescription)")
                                    })
                                    
                                    
                                }, completion: { (status, error) in
                                    print("compeletion status = \(status)")
                                    print(error?.localizedDescription ?? "")
                                    
                                    if let visitcheckinoutlistobj = VisitCheckInOutList().getVisitcheckinoutFromID(visitID: NSNumber.init(value: objplannedVisit.iD)){
                                        
                                        
                                        ////objplannedVisit.insertObject(value:visitcheckinoutlistobj , at: 0)
                                        //        print(objplannedVisit.checkInOutData.firstObject)
                                        //        print(visitcheckinoutlistobj)
                                        //        objplannedVisit.replaceObjectFrom(value: visitcheckinoutlistobj, at: 0)
                                        
                                        if(objplannedVisit.checkInOutData.count > 0){
                                            objplannedVisit.removeObjectFromCheckInOutData(at: 0)
                                        }
                                        objplannedVisit.insertObject(value:visitcheckinoutlistobj , at: 0)
                                        //  print(objplannedVisit.checkInOutData.firstObject)
                                        //  print("counts of checkin after add check out visit \(objplannedVisit.checkInOutData.count)")
                                        //  print(visitcheckinoutlistobj.checkOutTime)
                                        let visitcheckout = objplannedVisit.checkInOutData.lastObject as? VisitCheckInOutList
                                        print(visitcheckout?.checkOutTime)
                                        
                                        objplannedVisit.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                            if(error == nil){
                                                print("checkout data saved sucessfully")
                                                print(objplannedVisit.checkInOutData.count)
                                                let checkinInfo:[String:Any] = ["visitType":self.visitType,"visitId":visitid,"message":message]
                                                
                                                NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: checkinInfo)
                                            }else{
                                                print(error?.localizedDescription ?? "")
                                                print(" with error \(objplannedVisit.checkInOutData.count)")
                                            }
                                        })
                                    }else{
                                        print("not get checkin record")
                                    }
                                    
                                })
                                //                      NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: nil)
                            }
                        }
                    }else if(error.code == 0){
                        Utils.toastmsg(message: message, view: self.parentView)
                    }else{
                        Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String) as? String ?? "" :error.localizedDescription ?? "", view: self.parentView)
                    }
                    
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
    
}
