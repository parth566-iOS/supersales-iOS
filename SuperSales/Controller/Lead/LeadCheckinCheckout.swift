//
//  LeadCheckinCheckout.swift
//  SuperSales
//
//  Created by Apple on 07/07/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation
import FastEasyMapping

class LeadCheckinCheckout: BaseViewController{
    //var leadType = VisitType.coldcallvisit
    var activeUser:DataUser?
    static var verifyAddress:Bool!
    static var verifyLeadCheckoutAddress:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
 activeUser =  Utils().getActiveAccount()
        // Do any additional setup after loading the view.
    }

    
    //MARK: - API Calling
    func   checkinLead(leadstatus:Int,lat:NSNumber,long:NSNumber,objlead:Lead,cust:String,viewcontroller:UIViewController){
    if(Utils().CheckInPossible(view: viewcontroller)){
    
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    //var leaid = NSNumber.init(value:objlead.iD)
        var param = Common.returndefaultparameter()
        var leadobj = [String:Any]()
        leadobj["LeadID"] = NSNumber.init(value:objlead.iD)
       
        
        leadobj["CreatedBy"] = self.activeuser?.userID
        leadobj["CompanyID"] = self.activeuser?.company?.iD
        
        leadobj["CheckInCheckOutStatusID"] = NSNumber.init(value:0)
        
        leadobj["Lattitude"] = lat
        leadobj["Longitude"] = long
        leadobj["StatusID"] = NSNumber.init(value:1)
        leadobj["CheckInFrom"] = cust
        param["leadCheckInJson"] = Common.returnjsonstring(dic: leadobj)
        print("parameter of lead check in \(param)")
        SVProgressHUD.show(withStatus: "Check - In")
self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlLeadCheckIn, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
       
if(status.lowercased() == Constant.SucessResponseFromServer){
            print(responseType)
            print(arr)
            print(message)
           
        if(status.lowercased() ==  Constant.SucessResponseFromServer){
            
            if(message.count > 0){
                SVProgressHUD.dismiss()
                Utils.toastmsg(message: message,view:viewcontroller.view)
            }
    if(error.code == 0){
if(responseType == ResponseType.dic){
    let dicOfAttendance = arr as? [String:Any] ?? [String:Any]()
                        print(dicOfAttendance)
if(dicOfAttendance["CheckInCheckOutStatusID"] as? Int ?? 100 == 0){
    var checkincheckoutID = NSNumber.init(value: 0)
    if let checkincheckoutId = dicOfAttendance["ID"] as? String{
        checkincheckoutID = NSNumber.init(value: Int(checkincheckoutId) ?? 0)
    }
if(self.activeuser?.role?.id?.intValue ?? 0 > 6){
let noAction = UIAlertAction.init(title: NSLocalizedString("no", comment:""), style: .cancel, handler: { (action) in
   
   
    self.deleteCheckin(checkinId: checkincheckoutID, viewcontroller: viewcontroller)
                                                    })
                            let yesAction = UIAlertAction.init(title: NSLocalizedString("yes", comment:""), style: .destructive, handler: { (action) in
//                                if ( message.count > 0 ) {
//                     Utils.toastmsg(message:message,view: self.view)
//                }
                               
                                MagicalRecord.save { (localcontext) in
                                    FEMDeserializer.collection(fromRepresentation: [dicOfAttendance], mapping: LeadCheckInOutList.defaultmapping(), context: localcontext)
                                } completion: { (status, error) in
                                    if let leadcheckincheckoutobj = LeadCheckInOutList().getLeadCheckinoutFromId(leadId: NSNumber.init(value: objlead.iD)){
                                        let arrOfcheckinList =  objlead.leadCheckInOutList as! NSMutableOrderedSet
                                        print("count of Lead Checkin = \(arrOfcheckinList.count) before addition")
                                        arrOfcheckinList.insert(leadcheckincheckoutobj, at: 0)
                                        objlead.insertObject(value: leadcheckincheckoutobj, at: 0)
                                        print("count of Lead Checkin = \(arrOfcheckinList.count) after addition")
                                        objlead.leadCheckInOutList = arrOfcheckinList
                                        objlead.leadCheckInOutList = NSOrderedSet(array: LeadCheckInOutList.getListOfCheckinOutList(leadID: NSNumber.init(value:objlead.iD ?? 0)))
                                        print("count of Lead Checkin = \(objlead.leadCheckInOutList.count) ")
                                        //objlead.insertObject(value: leadcheckincheckoutobj, at: 0)
                                        objlead.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                            //update on screen
                                            //update info
                                            print("count of Lead Checkin = \(objlead.leadCheckInOutList.count) ")
                                            let checkinInfo = [String:Any]()
                                            NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
                                        })
                                    }
                                }
                                
                                self.leadcheckinapproval(statusID: checkincheckoutID, objleadId:  NSNumber.init(value:objlead.iD), lat: lat, long: long, viewcontroller: viewcontroller)

                                
                                   })
                            
Common.showalertWithAction(msg:NSLocalizedString("your_current_location_is_different_from_customer_location_do_you_want_to_sent_approval_for_check_in", comment: "") , arrAction:[yesAction,noAction], view: viewcontroller)
                                                    
}else{
    let noAction = UIAlertAction.init(title: NSLocalizedString("no", comment:""), style: .cancel, handler: { (action) in
       
       
        self.deleteCheckin(checkinId: checkincheckoutID, viewcontroller: viewcontroller)
                                                        })
                                let yesAction = UIAlertAction.init(title: NSLocalizedString("yes", comment:""), style: .destructive, handler: { (action) in
        if (message.count > 0) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                                    MagicalRecord.save { (localcontext) in
                                        FEMDeserializer.collection(fromRepresentation: [dicOfAttendance], mapping: LeadCheckInOutList.defaultmapping(), context: localcontext)
                                    } completion: { (status, error) in
                                        if let leadcheckincheckoutobj = LeadCheckInOutList().getLeadCheckinoutFromId(leadId: NSNumber.init(value: objlead.iD)){
                                            let arrOfcheckinList =  objlead.leadCheckInOutList as! NSMutableOrderedSet
                                            arrOfcheckinList.insert(leadcheckincheckoutobj, at: 0)
                                            print("count of Lead Checkin = \(arrOfcheckinList.count) after addition")
                                        objlead.leadCheckInOutList = arrOfcheckinList
                                        objlead.insertObject(value: leadcheckincheckoutobj, at: 0)
                                            objlead.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                                //update on screen
                                                //update info
                                                print("count of Lead Checkin = \(objlead.leadCheckInOutList.count)")
                                                let checkinInfo = [String:Any]()
                                                NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
                                                
                                                /*
                                                 if let visitcheckinoutlistobj = VisitCheckInOutList().getVisitcheckinoutFromID(visitID:visitid){
                                              
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
                                          NotificationCenter.default.post(name: Notification.Name.init("updatecheckinInfo"), object: nil,userInfo: checkinInfo)
                                                 
                                                 **/
                                            })
                                        }
                                    }
                                    
                                    self.updateleadcheckin(statusID: checkincheckoutID, objlead:objlead, lat: lat, long: long, viewcontroller: viewcontroller)

                                    
                                       })
                                
    Common.showalertWithAction(msg:NSLocalizedString("your_current_location_is_different_from_customer_location_do_you_want_to_sent_approval_for_check_in", comment: "") , arrAction:[yesAction,noAction], view: viewcontroller)
}
                        }else{
                            MagicalRecord.save { (localcontext) in
                                let arrOfcheckinList =  objlead.leadCheckInOutList as! NSMutableOrderedSet
                                print("count of Lead Checkin = \(arrOfcheckinList.count)  without completion before saving , \(dicOfAttendance) ")
                                FEMDeserializer.collection(fromRepresentation: [dicOfAttendance], mapping: LeadCheckInOutList.defaultmapping(), context: localcontext)
                                print("count of Lead Checkin = \(arrOfcheckinList.count)  without completion after saving ")
                            } completion: { (status, error) in
                                if let leadcheckincheckoutobj = LeadCheckInOutList().getLeadCheckinoutFromId(leadId: NSNumber.init(value: objlead.iD)){
                                    let arrOfcheckinList =  objlead.leadCheckInOutList as! NSMutableOrderedSet
                                    print("count of Lead Checkin = \(arrOfcheckinList.count) before addition added object  = \(leadcheckincheckoutobj)")
                                    arrOfcheckinList.insert(leadcheckincheckoutobj, at: 0)
                                    objlead.insertObject(value: leadcheckincheckoutobj, at: 0)
                                    print("count of Lead Checkin = \(arrOfcheckinList.count) after addition")
                                    objlead.leadCheckInOutList = arrOfcheckinList
                                    objlead.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                        //update on screen
                                        //update info
                                        let checkinInfo = [String:Any]()
                                        print("count of Lead Checkin = \(objlead.leadCheckInOutList.count)")
                                        NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
                                    })
                                }
                            }
        
                    }
                }else{
                                            let arrOfCheckIn = arr as? [[String:Any]] ?? [[String:Any]]()
                                            print(arrOfCheckIn)
                                        }
                                    }else{
                                        if(error.userInfo.description.localizedLowercase.count > 0){
                                            Utils.toastmsg(message: error.userInfo.description.localizedLowercase, view: viewcontroller.view)

                                        }
                                    }
}else{

            
    if((message == NSLocalizedString("you_are_not_at_work_location_please_refresh_location", comment: "")) || (message == NSLocalizedString("you_are_not_at_work_location_please_do_manual_Check_IN", comment: ""))){
    let viewOnMapAction = UIAlertAction.init(title: NSLocalizedString("VIEW_ON_MAP", comment: ""), style: .cancel, handler: { (action) in
        if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
            map.isFromDashboard = false
            map.isFromColdCall = false
            map.isFromVisitLeadDetail = true
            map.objLead = objlead
            if(self.activesetting.customTagging == 3){
                if(!Utils.isCustomerMapped(cid: NSNumber.init(value:objlead.customerID))){
                    Utils.toastmsg(message:"Customer Not Mapped, So you can't get Location",view: self.view)
                    return
                }
            }
            if   let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:objlead.addressMasterID)){
                let latdouble = Float(address.lattitude ?? "0.0000") //address.lattitude ?? 0.00// //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")

                let longdouble = Float(address.longitude ?? "0.0000") //address.longitude ?? 0.00 // //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
//                let latdouble = Float(address.lattitude ?? "0.000" )
//                let longdouble = Float(address.longitude ?? "0.000")
                map.lattitude = NSNumber.init(value:latdouble ?? 0.00)
                map.longitude = NSNumber.init(value:longdouble ?? 0.00)
            }else{
                map.lattitude = NSNumber.init(value:0)
                map.longitude = NSNumber.init(value:0)
                                            }
          viewcontroller.navigationController?.pushViewController(map, animated: true)
                                            }
                                        })
                            let manualAction = UIAlertAction.init(title: NSLocalizedString("MANUAL_CHECK_IN", comment: ""), style: .default, handler: { (action) in

self.manualCheckin(leadid: NSNumber.init(value:objlead.iD), manuallat: lat, manuallong: long, cust: cust, objmanuallead: objlead, viewcontroller: viewcontroller)
                                        })
                                        let refreshAction = UIAlertAction.init(title: NSLocalizedString("Refresh", comment:""), style: .default, handler: { (action) in
    Utils.toastmsg(message: "Location Refreshing" , view:viewcontroller.view)
                                        })
                                        let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment:""), style: .default, handler: nil)
Common.showalertWithAction(msg: message, arrAction: [viewOnMapAction,manualAction,refreshAction,cancelAction], view: viewcontroller)
                                        
                                    }else{
                                        if(message.count > 0){
            Utils.toastmsg(message: message,view:viewcontroller.view)
                                        }
                                    self.navigationController?.popViewController(animated: true)
                                    }
                                }

}else{
   // Utils.toastmsg(message: message,view:viewcontroller.view)
//print(message)
    var strmsg = ""
    if let errmsg = error.userInfo["localiseddescription"] as? String{
        if(errmsg.count > 0){
            print(errmsg)
            strmsg = errmsg
   // Utils.toastmsg(message: errmsg , view:viewcontroller.view)
        }else{
            strmsg = errmsg
print(error.localizedDescription)

  //  Utils.toastmsg(message: error.localizedDescription , view:viewcontroller.view)
        }
    }
//print()    Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
if((strmsg == NSLocalizedString("you_are_not_at_work_location_please_refresh_location", comment: "")) || (strmsg == NSLocalizedString("you_are_not_at_work_location_please_do_manual_Check_IN", comment: ""))){
        let viewOnMapAction = UIAlertAction.init(title: NSLocalizedString("VIEW_ON_MAP", comment: ""), style: .cancel, handler: { (action) in
    if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
        map.isFromDashboard = false
        map.isFromColdCall = false
        map.isFromVisitLeadDetail = true
        map.objLead = objlead
        if   let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:objlead.addressMasterID)){
            let latdouble = Float(address.lattitude ?? "0.0000")//address.lattitude ?? 0.00// //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")

            let longdouble = Float(address.longitude ?? "0.0000")//address.longitude ?? 0.00 //Float(add?.longitude ?? "0.0000") //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
//            let latdouble = Float(address.lattitude ?? "0.000" )
//            let longdouble = Float(address.longitude ?? "0.000")
            map.lattitude = NSNumber.init(value:latdouble ?? 0.00)
            map.longitude = NSNumber.init(value:longdouble ?? 0.00)
        }else{
            map.lattitude = NSNumber.init(value:0)
            map.longitude = NSNumber.init(value:0)
                                        }
    /*if(isVisitPlanned ==               VisitType.coldcallvisit){
                                                    map.lattitude = NSNumber.init(value: Int(objunplannedVisit.tempCustomerObj?.Lattitude ?? "0") ?? 0)//NSNumber.init(coder:Int(objunplannedVisit?.tempCustomerObj.Lattitude ?? "0") ?? 0)
                                                    map.longitude = NSNumber.init(value: Int(objunplannedVisit.tempCustomerObj?.Longitude ?? "0") ?? 0) //NSNumber.init(value:Int(objunplannedVisit?.tempCustomerObj.Longitude ?? "0") ?? 0)
                                                }else if(isVisitPlanned == VisitType.planedvisit){
                                                    if   let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:objplannedVisit.addressMasterID)){
                                                    map.lattitude = NSNumber.init(value:address.lattitude)
                                                    map.longitude = NSNumber.init(value:address.longitude)
                                                    }else{
                                                         map.lattitude = NSNumber.init(value:0)
                                                        map.longitude = NSNumber.init(value:0)
                                                    }
                }
                   */ viewcontroller.navigationController?.pushViewController(map, animated: true)
                                                }
                                            })
let manualAction = UIAlertAction.init(title: NSLocalizedString("MANUAL_CHECK_IN", comment: ""), style: .default, handler: { (action) in

    self.manualCheckin(leadid: NSNumber.init(value:objlead.iD), manuallat: lat, manuallong: long, cust: cust, objmanuallead: objlead, viewcontroller: viewcontroller)
                                            })
let refreshAction = UIAlertAction.init(title: NSLocalizedString("Refresh", comment:""), style: .default, handler: { (action) in
    Utils.toastmsg(message: "Location Refreshing" , view:viewcontroller.view)
})
let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment:""), style: .default, handler: nil)
    if(LeadCheckinCheckout.verifyAddress){
        SVProgressHUD.dismiss()
Common.showalertWithAction(msg: message, arrAction: [viewOnMapAction,manualAction,refreshAction,cancelAction], view: viewcontroller)
    }  else{
        //                            SVProgressHUD.dismiss()
                                    Utils.toastmsg(message: "Verifying Address", view: viewcontroller.view)
                                  //  Utils.addShadow(view: viewcontroller.view)
                                    let secondsToDelay = 4.0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                        self.verfyingAddress(status: leadstatus, lat: lat, long: long, objLead: objlead, viewcontroller: viewcontroller, custName: cust)
                                   //     self.verfyingAddress(status: visitstatus, lat: lat, long: long, isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
                                    }
                                   
                                }
                                        }else{
                                            SVProgressHUD.dismiss()
    Utils.toastmsg(message: message,view:viewcontroller.view)
                                        self.navigationController?.popViewController(animated: true)
                                        }
            }
        }
    }
    }
    


    func   checkoutLead(leadstatus:Int,lat:NSNumber,long:NSNumber,objlead:Lead,cust:String,viewcontroller:UIViewController){
   
    var param = Common.returndefaultparameter()
    var leadobj = [String:Any]()
    leadobj["LeadID"] = NSNumber.init(value:objlead.iD)
    leadobj["CheckInFrom"] = cust
    leadobj["CheckInCheckOutStatusID"] = NSNumber.init(value:0)
    leadobj["CompanyID"] = activeuser?.company?.iD
    leadobj["CreatedBy"] = activeuser?.userID
    leadobj["Lattitude"] = lat
    leadobj["Longitude"] = long
    leadobj["StatusID"] = NSNumber.init(value:1)
           
    param["leadCheckOutJson"] = Common.returnjsonstring(dic: leadobj)
    print("parameter of lead check out \(param)")
    SVProgressHUD.show(withStatus: "Check - Out")
    self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlLeadCheckOut, method: Apicallmethod.post){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
      
if(status.lowercased() == Constant.SucessResponseFromServer){
  

    if(message.count > 0){
       Utils.toastmsg(message: message,view:viewcontroller.view)
    }
    SVProgressHUD.dismiss()
    let dicres = arr as? [String:Any] ?? [String:Any]()
    print("response of checkout lead = \(arr) , dic = \(dicres)")
MagicalRecord.save({ (localContext) in
    let arrOfCheckOut = FEMDeserializer.collection(fromRepresentation: [dicres], mapping: LeadCheckInOutList.defaultmapping(), context: localContext)
//         print("arr of checkout = \(arrOfCheckOut)")
//         print("dic response of checkout api = \(dicres)")
    localContext.mr_saveToPersistentStore(completion: { (status, error) in
                 print("saving")
        let checkinInfo = [String:Any]()
        print("count of Lead Checkin = \(objlead.leadCheckInOutList.count)")
        NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
             })
 //   localContext.mr_save(options: <#T##MRSaveOptions#>, completion: <#T##MRSaveCompletionHandler?##MRSaveCompletionHandler?##(Bool, Error?) -> Void#>)
    
}) { (status, error) in
  
    
    if let leadcheckincheckoutobj = LeadCheckInOutList().getLeadCheckinoutFromId(leadId: NSNumber.init(value: objlead.iD)){
        let arrOfcheckinList =  objlead.leadCheckInOutList as! NSMutableOrderedSet
        print("checkin obj = before add or remove = \(leadcheckincheckoutobj) count = \(objlead.leadCheckInOutList.count)")
        if(arrOfcheckinList.count > 0){
        arrOfcheckinList.removeObject(at: 0)
            arrOfcheckinList.insert(leadcheckincheckoutobj, at: 0)
        }
        
        
    objlead.insertObject(value: leadcheckincheckoutobj, at: 0)
        print("count of Lead Checkin = \(arrOfcheckinList.count) after addition")
        objlead.leadCheckInOutList = arrOfcheckinList
//        print("checkin obj  = \(leadcheckincheckoutobj) list of checkin for lead = \(arrOfcheckinList) count is = \(objlead.leadCheckInOutList.count)")
//        bjlead.insertObject(value: leadcheckincheckoutobj, at: 0)
        objlead.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
            //update on screen
            //update info
            let checkinInfo = [String:Any]()
            print("count of Lead Checkin = \(objlead.leadCheckInOutList.count)")
            NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
        })
    }

    if(error == nil){
        print("Lead Check Out saved")
    }
                    }
                }
    else {
//    Utils.toastmsg(message: message,view:viewcontroller.view)
//print(message)
var strmsg = ""
if let errmsg = error.userInfo["localiseddescription"] as? String{
    if(errmsg.count > 0){
    print(errmsg)
    strmsg = errmsg
   // Utils.toastmsg(message: errmsg , view:viewcontroller.view)
        
}else{
strmsg = errmsg
print(error.localizedDescription)
    if(error.localizedDescription.count > 0){
   // Utils.toastmsg(message: error.localizedDescription , view:viewcontroller.view)
    }
                }
            }
if((strmsg == NSLocalizedString("you_are_not_at_work_location_please_refresh_location", comment: "")) || (strmsg == NSLocalizedString("you_are_not_at_work_location_please_do_manual_Check_IN", comment: ""))){
                let viewOnMapAction = UIAlertAction.init(title: NSLocalizedString("VIEW_ON_MAP", comment: ""), style: .cancel, handler: { (action) in
            if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
                map.isFromDashboard = false
                map.isFromColdCall = false
                map.isFromVisitLeadDetail = true
                map.objLead = objlead
                if   let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:objlead.addressMasterID)){
                    let latdouble = Float(address.lattitude ?? "0.0000")//address.lattitude ?? 0.00//Float(add?.lattitude ?? "0.0000") //Float(AttendanceViewController.selectedAddreeList.lattitude ?? "0.00000")

                    let longdouble = Float(address.longitude ?? "0.0000")//address.longitude ?? 0.00 //Float(add?.longitude ?? "0.0000") //Float(AttendanceViewController.selectedAddreeList.longitude ?? "0.0000")
//                    let latdouble = Float(address.lattitude ?? "0.000" )
//                    let longdouble = Float(address.longitude ?? "0.000")
                    map.lattitude = NSNumber.init(value:latdouble ?? 0.00)
                    map.longitude = NSNumber.init(value:longdouble ?? 0.00)
                }else{
                    map.lattitude = NSNumber.init(value:0)
                    map.longitude = NSNumber.init(value:0)
                                                }
            /*if(isVisitPlanned ==               VisitType.coldcallvisit){
                                                            map.lattitude = NSNumber.init(value: Int(objunplannedVisit.tempCustomerObj?.Lattitude ?? "0") ?? 0)//NSNumber.init(coder:Int(objunplannedVisit?.tempCustomerObj.Lattitude ?? "0") ?? 0)
                                                            map.longitude = NSNumber.init(value: Int(objunplannedVisit.tempCustomerObj?.Longitude ?? "0") ?? 0) //NSNumber.init(value:Int(objunplannedVisit?.tempCustomerObj.Longitude ?? "0") ?? 0)
                                                        }else if(isVisitPlanned == VisitType.planedvisit){
                                                            if   let address = AddressList().getAddressByAddressId(aId:NSNumber.init(value:objplannedVisit.addressMasterID)){
                                                            map.lattitude = NSNumber.init(value:address.lattitude)
                                                            map.longitude = NSNumber.init(value:address.longitude)
                                                            }else{
                                                                 map.lattitude = NSNumber.init(value:0)
                                                                map.longitude = NSNumber.init(value:0)
                                                            }
                        }
                           */
                viewcontroller.navigationController?.pushViewController(map, animated: true)
                                                        }
                                                    })
        let manualAction = UIAlertAction.init(title: NSLocalizedString("MANUAL_CHECK_OUT", comment: ""), style: .default, handler: { (action) in
            self.manualCheckout(leadid: NSNumber.init(value:objlead.iD), manuallat: lat, manuallong: long, cust: cust, objmanuallead: objlead, viewcontroller: viewcontroller)
          //  self.manualCheckin(leadid: NSNumber.init(value:objlead.iD), manuallat: lat, manuallong: long, cust: cust, objmanuallead: objlead, viewcontroller: viewcontroller)
                                                    })
                                                    let refreshAction = UIAlertAction.init(title: NSLocalizedString("Refresh", comment:""), style: .default, handler: { (action) in
            Utils.toastmsg(message: "Location Refreshing" , view:viewcontroller.view)
                                                    })
                                                    let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment:""), style: .default, handler: nil)
    if(LeadCheckinCheckout.verifyLeadCheckoutAddress){
        SVProgressHUD.dismiss()
        Common.showalertWithAction(msg: message, arrAction: [viewOnMapAction,manualAction,refreshAction,cancelAction], view: viewcontroller)
    }  else{
        //                            SVProgressHUD.dismiss()
                                    Utils.toastmsg(message: "Verifying Address", view: viewcontroller.view)
                                  //  Utils.addShadow(view: viewcontroller.view)
                                    let secondsToDelay = 4.0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                        self.verfyingAddress(status: leadstatus, lat: lat, long: long, objLead: objlead, viewcontroller: viewcontroller, custName: cust)
                                   //     self.verfyingAddress(status: visitstatus, lat: lat, long: long, isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
                                    }
                                   
                                }
                                                }else{
            print("message is \(message)")
    if(strmsg.count > 0){
        Utils.toastmsg(message: strmsg,view:viewcontroller.view)
    }
                                                    SVProgressHUD.dismiss()
self.navigationController?.popViewController(animated: true)
                
                                                }
                    }
                }
    }
        
    
    func leadcheckinapproval(statusID:NSNumber,objleadId:NSNumber,lat:NSNumber,long:NSNumber,viewcontroller:UIViewController){
        var param = Common.returndefaultparameter()
        var leadobj = [String:Any]()
        leadobj["LeadID"] = objleadId
        leadobj["ID"] = statusID
        leadobj["CreatedBy"] = self.activeuser?.userID
        leadobj["CompanyID"] = self.activeuser?.company?.iD
        leadobj["Lattitude"] = lat
        leadobj["Longitude"] = long
       
        param["leadCheckInSendApprovalJson"] = Common.returnjsonstring(dic: leadobj)
        print("parameter of lead check in approval = \(param)")
        SVProgressHUD.show(withStatus: "Send Check-IN Approval.....")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlLeadManualCheckIn, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
        if(status.lowercased() == Constant.SucessResponseFromServer){
               
                    print(arr)
                    print(message)
                    SVProgressHUD.dismiss()
        if(status.lowercased() ==  Constant.SucessResponseFromServer){
            Utils.toastmsg(message: message,view:viewcontroller.view)
//            let dicres = arr as? [String:Any] ?? [String:Any]()
//        MagicalRecord.save({ (localContext) in
//        //FEMDeserializer.collection(fromRepresentation: [dicres], mapping: LeadCheckInOutList.defaultmapping())
//            FEMDeserializer.object(fromRepresentation: dicres, mapping: LeadCheckInOutList.defaultmapping(), context: localContext)
//             localContext.mr_save({ (localContext) in
//                print("saving")
//            }, completion: { (status, error) in
//            print("saved")
//                print(error)
//                if let leadcheckinout = LeadCheckInOutList().getLeadCheckinoutFromId(leadId:NSNumber.init(value:objmanuallead.iD)) as? LeadCheckInOutList{
//        objmanuallead.insertObject(value: leadcheckinout, at: 0)
//
//        objmanuallead.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
//        print(error?.localizedDescription)
//            //update info
//            let checkinInfo = [String:Any]()
//            NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
//                    })
//
//                }
//
//         })
//        }) { (status, error) in
//            if(error == nil){
//                print("Lead Check in saved")
//            }else{
//                print(error?.localizedDescription)
//            }
//                            }
                        }
                        }else{
                print(message)
                Utils.toastmsg(message: message,view:viewcontroller.view)
                    }
            }
    }
    
    func updateleadcheckin(statusID:NSNumber,objlead:Lead,lat:NSNumber,long:NSNumber,viewcontroller:UIViewController){
        var param = Common.returndefaultparameter()
        
        var leadobj = [String:Any]()
        leadobj["LeadID"] = NSNumber.init(value:objlead.iD)
        
        leadobj["ID"] = statusID
        leadobj["CheckInCheckOutStatusID"] = NSNumber.init(value:1)
        leadobj["Lattitude"] = lat
        leadobj["Longitude"] = long
        leadobj["StatusID"] = NSNumber.init(value:2)

     
        param["updateLeadCheckInJson"] = Common.returnjsonstring(dic: leadobj)
        print("parameter of lead manual check in \(param)")
        SVProgressHUD.show(withStatus: "Send Check-IN Update.....")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlLeadUpdateCheckIn, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
        if(status.lowercased() == Constant.SucessResponseFromServer){
               
                    SVProgressHUD.dismiss()

            Utils.toastmsg(message: message,view:viewcontroller.view)
            let dicres = arr as? [String:Any] ?? [String:Any]()
            let intleadid = dicres["ID"] as? Int
            let leadid = NSNumber.init(value: intleadid ?? 0)
        /*MagicalRecord.save({ (localContext) in
        //FEMDeserializer.collection(fromRepresentation: [dicres], mapping: LeadCheckInOutList.defaultmapping())
            FEMDeserializer.object(fromRepresentation: dicres, mapping: LeadCheckInOutList.defaultmapping(), context: localContext)
             localContext.mr_save({ (localContext) in
                print("saving")
            }, completion: { (status, error) in
            print("saved")
                print(error)
                if let leadcheckinout = LeadCheckInOutList().getLeadCheckinoutFromId(leadId:leadid) as? LeadCheckInOutList{
        //objmanuallead.insertObject(value: leadcheckinout, at: 0)
                    let arrOfcheckinList =  objmanuallead.leadCheckInOutList as! NSMutableOrderedSet
                    arrOfcheckinList.insert(leadcheckinout, at: 0)
        objmanuallead.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
        print(error?.localizedDescription)
            //update info
            let checkinInfo = [String:Any]()
            NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
                    })

                }else{
                    print("not get checkin object")
                }
                
         })
        }) { (status, error) in
            if(error == nil){
                print("Lead Check in saved")
            }else{
                print(error?.localizedDescription)
            }
                            }*/
            
            MagicalRecord.save { (localcontext) in
                FEMDeserializer.collection(fromRepresentation: [dicres], mapping: LeadCheckInOutList.defaultmapping(), context: localcontext)
            } completion: { (status, error) in
                if let leadcheckincheckoutobj = LeadCheckInOutList().getLeadCheckinoutFromId(leadId: NSNumber.init(value: objlead.iD)){
                    let arrOfcheckinList =  objlead.leadCheckInOutList as! NSMutableOrderedSet
                    arrOfcheckinList.insert(leadcheckincheckoutobj, at: 0)
                    objlead.insertObject(value: leadcheckincheckoutobj, at: 0)
                    objlead.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                        //update on screen
                        //update info
                        let checkinInfo = [String:Any]()
                        NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
                    })
                }
            }
            
                        
                        }else{
                print(message)
                            
                            var strmsg = ""
                            if(message.count > 0){
                                strmsg =  message
            
                            }else
                            if let errmsg = error.userInfo["localiseddescription"] as? String{
                                if(errmsg.count > 0){
                                    print(errmsg)
                                    strmsg = errmsg
                        
                                }else{
                                    strmsg = errmsg
                        print(error.localizedDescription)
                                }
                        Utils.toastmsg(message: strmsg,view:viewcontroller.view)
                    }
            }
            }
    }
    
    func deleteCheckin(checkinId:NSNumber,viewcontroller:UIViewController)->(){
        var param = Common.returndefaultparameter()
        var leadobj = [String:Any]()
        
        leadobj["ID"] = checkinId
       
       
        param["deleteLeadCheckInJson"] = Common.returnjsonstring(dic: leadobj)
        print("parameter of lead check in delete = \(param)")
        SVProgressHUD.show(withStatus: "Send Check-IN Approval.....")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlLeadDeleteCheckIn, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
        if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
                    print(arr)
                    print(message)
                    SVProgressHUD.dismiss()
        if(status.lowercased() ==  Constant.SucessResponseFromServer){
            Utils.toastmsg(message: message,view:viewcontroller.view)
//            let dicres = arr as? [String:Any] ?? [String:Any]()
//        MagicalRecord.save({ (localContext) in
//        //FEMDeserializer.collection(fromRepresentation: [dicres], mapping: LeadCheckInOutList.defaultmapping())
//            FEMDeserializer.object(fromRepresentation: dicres, mapping: LeadCheckInOutList.defaultmapping(), context: localContext)
//             localContext.mr_save({ (localContext) in
//                print("saving")
//            }, completion: { (status, error) in
//            print("saved")
//                print(error)
//                if let leadcheckinout = LeadCheckInOutList().getLeadCheckinoutFromId(leadId:NSNumber.init(value:objmanuallead.iD)) as? LeadCheckInOutList{
//        objmanuallead.insertObject(value: leadcheckinout, at: 0)
//
//        objmanuallead.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
//        print(error?.localizedDescription)
//            //update info
//            let checkinInfo = [String:Any]()
//            NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
//                    })
//
//                }
//
//         })
//        }) { (status, error) in
//            if(error == nil){
//                print("Lead Check in saved")
//            }else{
//                print(error?.localizedDescription)
//            }
//                            }
                        }
                        }else{
                print(message)
                Utils.toastmsg(message: message,view:viewcontroller.view)
                    }
            }
    }
    
    func verfyingAddress(status:Int,lat:NSNumber,long:NSNumber,objLead:Lead,viewcontroller:UIViewController,custName:String){
    //(status:Int,lat:NSNumber,long:NSNumber,isVisitPlanned:VisitType,objplannedVisit:PlannVisit,objunplannedVisit:UnplannedVisit,visitid:NSNumber,viewcontroller:UIViewController,addressID:NSNumber){
       // let currenlocation =  Location.sharedInsatnce.currentLocation
       
      
        if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
            //          CLLocationCoordinate2DIsValid(currentCoordinate)
            if(CLLocationCoordinate2DIsValid(currentCoordinate)){
                
                let currentlat =  currentCoordinate.latitude
                let currentlong = currentCoordinate.longitude
                if let leadcheckout = LeadCheckinCheckout.verifyLeadCheckoutAddress as? Bool{
                if(!leadcheckout){
                    LeadCheckinCheckout.verifyLeadCheckoutAddress = true
                
                                LeadCheckinCheckout().checkoutLead(leadstatus: status, lat: NSNumber.init(value: currentlat), long: NSNumber.init(value:currentlong), objlead: objLead, cust: custName, viewcontroller: viewcontroller)
                   
                }
                }
                if let leadcheckin = LeadCheckinCheckout.verifyAddress as? Bool{
                if(!leadcheckin){
                    LeadCheckinCheckout.verifyAddress = true
                
                    LeadCheckinCheckout().checkinLead(leadstatus: status, lat: NSNumber.init(value: currentlat), long: NSNumber.init(value:currentlong), objlead: objLead, cust: custName, viewcontroller: viewcontroller)
                   
                }
                }
//                else{
//                    LeadCheckinCheckout.verifyLeadCheckoutAddress = true
//                    self.checkoutLead(leadstatus: status, lat: NSNumber.init(value: currentlat), long: NSNumber.init(value:currentlong), objlead: objLead, cust: custName, viewcontroller: viewcontroller)
//               // self.checkin(visitstatus: status, lat: NSNumber.init(value:currentlat), long: NSNumber.init(value:currentlong), isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
//              //  self.checkin(visitstatus: status, lat: currentlat, long: currentlong, isVisitPlanned: isVisitPlanned, objplannedVisit: objplannedVisit, objunplannedVisit: objunplannedVisit, visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
//               // self.checkin(visitstatus: status, lat: currentCoordinate.latitude, long: currentCoordinate.longitude, isVisitPlanned: VisitType.directvisitcheckin, objplannedVisit: objplannedVisit, objunplannedVisit: UnplannedVisit(), visitid: visitid, viewcontroller: viewcontroller, addressID: addressID)
//            }
            }
        }else{
            Utils.toastmsg(message: "Please check your gps", view: viewcontroller.view)
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


    func manualCheckin(leadid:NSNumber,manuallat:NSNumber,manuallong:NSNumber,cust:String,objmanuallead:Lead,viewcontroller:UIViewController){
var param = Common.returndefaultparameter()
var leadobj = [String:Any]()
leadobj["LeadID"] = NSNumber.init(value:objmanuallead.iD)
    
leadobj["CreatedBy"] = self.activeuser?.userID
leadobj["CompanyID"] = self.activeuser?.company?.iD
leadobj["CheckInCheckOutStatusID"] = NSNumber.init(value:1)
leadobj["Lattitude"] = manuallat
leadobj["Longitude"] = manuallong
leadobj["StatusID"] = NSNumber.init(value:2)

leadobj["CheckInFrom"] = cust
param["leadManualCheckInJson"] = Common.returnjsonstring(dic: leadobj)
print("parameter of lead manual check in \(param)")
SVProgressHUD.show(withStatus: "Manual Check - In")
self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlLeadManualCheckIn, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
SVProgressHUD.dismiss()
if(status.lowercased() == Constant.SucessResponseFromServer){
       
            SVProgressHUD.dismiss()

    Utils.toastmsg(message: message,view:viewcontroller.view)
    let dicres = arr as? [String:Any] ?? [String:Any]()
   
 
    
    MagicalRecord.save { (localcontext) in
        print("dic = \(dicres)")
       let arrofcheckin =  FEMDeserializer.collection(fromRepresentation: [dicres], mapping: LeadCheckInOutList.defaultmapping(), context: localcontext)
        print("chckin obj = \(arrofcheckin)")
    } completion: { (status, error) in
        if let leadcheckincheckoutobj = LeadCheckInOutList().getLeadCheckinoutFromId(leadId: NSNumber.init(value: objmanuallead.iD)){
            let arrOfcheckinList =  objmanuallead.leadCheckInOutList as! NSMutableOrderedSet
            arrOfcheckinList.insert(leadcheckincheckoutobj, at: 0)
            print("checkin obj  = \(leadcheckincheckoutobj) list of checkin for lead = \(arrOfcheckinList)")
            objmanuallead.insertObject(value: leadcheckincheckoutobj, at: 0)
            objmanuallead.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                //update on screen
                //update info
                let checkinInfo = [String:Any]()
                NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
            })
        }
    }
    
                
                }else{
        print(message)
                    
                    var strmsg = ""
                    if(message.count > 0){
                        strmsg =  message
    
                    }else
                    if let errmsg = error.userInfo["localiseddescription"] as? String{
                        if(errmsg.count > 0){
                            print(errmsg)
                            strmsg = errmsg
                
                        }else{
                            strmsg = errmsg
                print(error.localizedDescription)
                        }
                Utils.toastmsg(message: strmsg,view:viewcontroller.view)
            }
    }
    }
    
    }

        func manualCheckout(leadid:NSNumber,manuallat:NSNumber,manuallong:NSNumber,cust:String,objmanuallead:Lead,viewcontroller:UIViewController){
    var param = Common.returndefaultparameter()
    var leadobj = [String:Any]()
    leadobj["LeadID"] = NSNumber.init(value:objmanuallead.iD)
    leadobj["CreatedBy"] = self.activeuser?.userID
    leadobj["CompanyID"] = self.activeuser?.company?.iD
    leadobj["CheckInCheckOutStatusID"] = NSNumber.init(value:1)
    leadobj["Lattitude"] = manuallat
    leadobj["Longitude"] = manuallong
    leadobj["StatusID"] = NSNumber.init(value:2)
          
    leadobj["CheckInFrom"] = cust
    param["leadManualCheckOutJson"] = Common.returnjsonstring(dic: leadobj)
    print("parameter of lead manual check out \(param)")
    SVProgressHUD.show(withStatus: "Manual Check - Out")
    self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlLeadManualCheckOut, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                if(status.lowercased() == Constant.SucessResponseFromServer){
                print(responseType)
                print(arr)
                print(message)
                SVProgressHUD.dismiss()
    if(status.lowercased() == Constant.SucessResponseFromServer){
    Utils.toastmsg(message: message,view:viewcontroller.view)
        let dicres = arr as? [String:Any] ?? [String:Any]()
    MagicalRecord.save({ (localContext) in
    
     let arrofcheckout = FEMDeserializer.collection(fromRepresentation: [dicres], mapping: LeadCheckInOutList.defaultmapping(), context: localContext)
//      print("checkout obj = \(arrofcheckout)")
        print("dic = \(dicres)")
        
    }) { (status, error) in
       
        
        if let leadcheckincheckoutobj = LeadCheckInOutList().getLeadCheckinoutFromId(leadId: NSNumber.init(value: objmanuallead.iD)){
            let arrOfcheckinList =  objmanuallead.leadCheckInOutList as! NSMutableOrderedSet
            arrOfcheckinList.insert(leadcheckincheckoutobj, at: 0)
            print("checkin obj  = \(leadcheckincheckoutobj) list of checkin for lead = \(arrOfcheckinList)")
            objmanuallead.insertObject(value: leadcheckincheckoutobj, at: 0)
            objmanuallead.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                //update on screen
                //update info
                let checkinInfo = [String:Any]()
                NotificationCenter.default.post(name: Notification.Name.init("updateLeadcheckinInfo"), object: nil,userInfo: checkinInfo)
            })
        }
    
        if(error == nil){
            print("Lead Check Out saved")
        }
                        }
                    }
                    }else{
                        print(message)
                                    
                                    var strmsg = ""
                                    if(message.count > 0){
                                        strmsg =  message
                    
                                    }else
                                    if let errmsg = error.userInfo["localiseddescription"] as? String{
                                        if(errmsg.count > 0){
                                            print(errmsg)
                                            strmsg = errmsg
                                
                                        }else{
                                            strmsg = errmsg
                                print(error.localizedDescription)
                                        }
                                Utils.toastmsg(message: strmsg,view:viewcontroller.view)
                            }
                    }
        }
        }
}
