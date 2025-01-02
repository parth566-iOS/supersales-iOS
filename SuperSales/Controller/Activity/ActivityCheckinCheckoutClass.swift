//
//  ActivityCheckinCheckout.swift
//  SuperSales
//
//  Created by Apple on 12/05/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import FastEasyMapping

class ActivityCheckinCheckoutClass: BaseViewController {
   // let activeuser = Utils().getActiveAccount()
    var parentView:UIView!
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - API Calling
    //activity checkin
    func activityCheckin(lat:NSNumber,long:NSNumber,viewcontroller:UIViewController,activityID:NSNumber){
        //kWSUrlVisitCheckInLattitude
        if(Utils().CheckInPossible(view: viewcontroller)){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
       
    DispatchQueue.main.async {
        self.parentView = viewcontroller.view
    }
        var param = Common.returndefaultparameter()
        var dicActivity = [String:Any]()
        dicActivity["CompanyID"] = self.activeuser?.company?.iD
        dicActivity["CreatedBy"] = self.activeuser?.userID
        dicActivity["ActivityID"] = activityID
        dicActivity["Lattitude"] = lat
        dicActivity["Longitude"] = long
        param["activityCheckInJson"] = Common.returnjsonstring(dic: dicActivity)
        apicall(url: ConstantURL.kWSUrlActivityCheckIn, param: param, method: Apicallmethod.post) {  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(error.code == 0){
                Utils.toastmsg(message: message, view: self.parentView)
           
                if(responseType == ResponseType.dic){
                    let dicOfAttendance = arr as? [String:Any] ?? [String:Any]()

                   
                    if let activity = Activity().getActivityFromId(userID: activityID){
                        
                        
                            
                            
                         
                        
                    MagicalRecord.save({ (localcontext) in
                        let mapping = Activity.defaultMapping()
                        let store = FEMManagedObjectStore.init(context: Activity.getContext())
                        store.saveContextOnCommit = false
                        let adeserialiser = FEMDeserializer.init(store: store)
//                        let arrstatusupdatedlead = dicResult["NewSalesOrder"] as? [[String:Any]] ?? [[String:Any]]()
//
                        let arr = adeserialiser.collection(fromRepresentation: [dicOfAttendance], mapping: ActivityCheckinCheckout.defaultMapping()) as? [ActivityCheckinCheckout]
                        //adeserialiser.collection(fromRepresentation: [dicOfAttendance], mapping: ActivityCheckinCheckout.defaultMapping(), context: localcontext)
                        
                        
                                              localcontext.mr_save({ (localcontext) in
                                              print("saving")
                                                  })

                        let context = Activity.getContext()
                        context.mr_saveToPersistentStore { (status, error) in
                            if(error ==  nil){

                            }
                        }
//                      //  let  arr = FEMDeserializer.collection(fromRepresentation: [dicResponse], mapping: Activity.defaultMapping(), context: localcontext)
//                    //  print(arr)

                        
                }, completion: { (status, error) in
               
                    if  let activitycheckincheckout = ActivityCheckinCheckout().getActivitycheckinoutFromID(visitID: activityID){
                
                    let mutableCheckinList = activity.activityCheckInCheckOutList as! NSMutableOrderedSet
                
                    print("activity chekin list = \(activity.activityCheckInCheckOutList) before add checkin")
                    mutableCheckinList.insert(activitycheckincheckout, at: 0)
                        print("activity chekin list = \(activity.activityCheckInCheckOutList) after add checkin")
                        activity.activityCheckInCheckOutList =  mutableCheckinList
                        activity.activityCheckInCheckOutList = NSOrderedSet(array: ActivityCheckinCheckout.getListOfCheckinOutList(leadID: NSNumber.init(value:activity.activityId)))
                    
                        activity.managedObjectContext?.mr_saveToPersistentStore(completion: {_,_ in
                            let checkinInfo:[String:Any] = ["activityId":activityID]
                            NotificationCenter.default.post(name: Notification.Name.init("updateActivityCheckinInfo"), object: nil,userInfo: checkinInfo)
                        })
           //         print("activity chekin list = \(activity.activityCheckInCheckOutList) after add checkin")
                    
//                        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
//                        activity.managedObjectContext?.mr_saveToPersistentStoreAndWait()
//                        activity.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
//                            print("error in persistenet saving = \(error)")
//                            let checkinInfo:[String:Any] = ["activityId":activityID]
//                            NotificationCenter.default.post(name: Notification.Name.init("updateActivityCheckinInfo"), object: nil,userInfo: checkinInfo)
//                        })
//                        activity.managedObjectContext?.mr_save({ (context) in
//                            print("saving")
//                            context.mr_saveToPersistentStore { (status, error) in
//                                print("before saving = \(activity.activityCheckInCheckOutList.count)")
//                            }
//                            context.mr_saveToPersistentStoreAndWait()
//                        }, completion: { (status, error) in
//                            if(error == nil){
//                                if let activity = Activity().getActivityFromId(userID: activityID) as? Activity{
//                                    print("after saving = \(activity.activityCheckInCheckOutList.count)")
//                                }
//                                print("Its saved")
//
//                            }
//                        })
                    }
              /*      if  let activitycheckincheckout = ActivityCheckinCheckout().getActivitycheckinoutFromID(visitID: activityID){
                 //   print("counts of checkin before add check in activity \(activity.activityCheckInCheckOutList.count) object  =  \(activitycheckincheckout) checkin time = \(activitycheckincheckout.checkInTime) and dic = \(dicOfAttendance) type of obj  = \(type(of: activitycheckincheckout))")
                    let mutableCheckinList = activity.activityCheckInCheckOutList as! NSMutableOrderedSet
                
                    print("activity chekin list = \(activity.activityCheckInCheckOutList) before add checkin")
                    mutableCheckinList.insert(activitycheckincheckout, at: 0)
                    print("activity chekin list = \(activity.activityCheckInCheckOutList) after add checkin")
                    
                        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                        activity.managedObjectContext?.mr_saveToPersistentStoreAndWait()
                    activity.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                        let checkinInfo:[String:Any] = ["activityId":activityID]
                        print("checkin data saved sucessfully , count \(activity.activityCheckInCheckOutList.count) for activity  \(activity), activity id = \(activityID) before post notification")
                        NotificationCenter.default.post(name: Notification.Name.init("updateActivityCheckinInfo"), object: nil,userInfo: checkinInfo)
                        print("checkin data saved sucessfully , count \(activity.activityCheckInCheckOutList.count) for activity  \(activity), activity id = \(activityID) after post notification")
                        if let activity = Activity().getActivityFromId(userID: activityID) as? Activity{
                            print(activity.activityCheckInCheckOutList.count)
                        }
                    })
                  
                }
             /*   if let activity = Activity().getActivityFromId(userID: activityID) as? Activity{
                   
                activity.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                       
           //  activity.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                if(error == nil){
                  
                    activity.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                     //   print("checkin data saved sucessfully , count \(activity.activityCheckInCheckOutList.count) for activity  \(Activity().getActivityFromId(userID: NSNumber.init(value:activity.activityId)))")
                        let checkinInfo:[String:Any] = ["activityId":activityID]
//                        print("checkin data saved sucessfully , count \(activity.activityCheckInCheckOutList.count) for activity  \(activity), activity id = \(activityID) before post notification")
                        NotificationCenter.default.post(name: Notification.Name.init("updateActivityCheckinInfo"), object: nil,userInfo: checkinInfo)
                        print("checkin data saved sucessfully , count \(activity.activityCheckInCheckOutList.count) for activity  \(activity), activity id = \(activityID) after post notification")
                    })*/
              
                   
                }else{
                    print(error?.localizedDescription ?? "")
                    }
            })
                
                    }*/
                  
                                                    })
                    }else{
                        print("Not get Activity")
                    }
              
                }else{
                    let arrOfAttendance = arr as? [[String:Any]] ?? [[String:Any]]()
                    print("arr = \(arrOfAttendance)")
                    let checkinInfo:[String:Any] = [String:Any]()
                    NotificationCenter.default.post(name: Notification.Name.init("updateActivityCheckinInfo"), object: nil,userInfo: checkinInfo)
               
                }
            }else{
             
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.parentView)
            }
    }
        }
    }
    
    
    
    //activity checkout
    func activityCheckout(lat:NSNumber,long:NSNumber,viewcontroller:UIViewController,activityID:NSNumber){
        //kWSUrlVisitCheckInLattitude
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
       
    DispatchQueue.main.async {
        self.parentView = viewcontroller.view
    }
        
        var param = Common.returndefaultparameter()
        var dicActivity = [String:Any]()
        dicActivity["CompanyID"] = self.activeuser?.company?.iD
        dicActivity["CreatedBy"] = self.activeuser?.userID
        dicActivity["ActivityID"] = activityID
        dicActivity["Lattitude"] = lat
        dicActivity["Longitude"] = long
        param["activityCheckOutjson"] = Common.returnjsonstring(dic: dicActivity)
        apicall(url: ConstantURL.kWSUrlActivityCheckOut, param: param, method: Apicallmethod.post) {  (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(error.code == 0){
            
                Utils.toastmsg(message: message, view: self.parentView)
                if(responseType == ResponseType.dic){
                    let dicOfAttendance = arr as? [String:Any] ?? [String:Any]()
                   
                    let checkinInfo:[String:Any] = ["activityId":activityID]
                   
                    if let activity = Activity().getActivityFromId(userID: activityID){
                        let mutableCheckinList = activity.activityCheckInCheckOutList as! NSMutableOrderedSet
                        if(activity.activityCheckInCheckOutList.count > 0){
                        mutableCheckinList.removeObject(at: 0)
                        }
                    MagicalRecord.save({ (localcontext) in
                        if let objWithCheckout =   FEMDeserializer.collection(fromRepresentation: [dicOfAttendance], mapping: ActivityCheckinCheckout.defaultMapping(), context: localcontext) as? [ActivityCheckinCheckout]{
                     print("\(objWithCheckout) ,  dic is = \(dicOfAttendance)")
                   //     activity.insertCheckInOutData(value: objWithCheckout , atIndexes: 0)
                        }
                        localcontext.mr_saveToPersistentStore(completion: { (status, error) in
                            print("saving status = \(status) and error \(error?.localizedDescription)")
                        })
                       
                
                }, completion: { (status, error) in
               print("compeletion status =    \(status) , error = \(error)")
                if  let visitcheckinoutlistobj = ActivityCheckinCheckout().getActivitycheckinoutFromID(visitID: activityID){
                    if(activity.activityCheckInCheckOutList.count ?? 0 > 0){
                        print("Check out time = \(visitcheckinoutlistobj.checkOutTime)")
                  
                         
                                        //    mutableCheckinList.add(visitcheckinoutlistobj)
                        

                    }
                    print(activity.activityCheckInCheckOutList)
 //                   activity.insertObject(value: visitcheckinoutlistobj, at: 0)
                //    print("activity chekin list = \(activity.activityCheckInCheckOutList) before add checkout")
                   mutableCheckinList.insert(visitcheckinoutlistobj, at: 0)
                 //   print("activity chekin list = \(activity.activityCheckInCheckOutList) before add checkout")
//                   activity.insertObject(value: visitcheckinoutlistobj, at: 0)
//                    print(activity.activityCheckInCheckOutList)
//                    print("counts of checkin after add check in activity \(activity.activityCheckInCheckOutList.count) , count of checkin list = \(ActivityCheckinCheckout.getAllForActivity(visitID: activityID))")
            

                }

                activity.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                if(error == nil){
                print("checkout data saved sucessfully")
                let checkinInfo:[String:Any] = ["activityId":activityID]
                    print("latest checkin object = \(ActivityCheckinCheckout().getActivitycheckinoutFromID(visitID: activityID)) , checkin time = \((ActivityCheckinCheckout().getActivitycheckinoutFromID(visitID: activityID))?.checkInTime) , checkout = \((ActivityCheckinCheckout().getActivitycheckinoutFromID(visitID: activityID))?.checkOutTime)")
                NotificationCenter.default.post(name: Notification.Name.init("updateActivityCheckinInfo"), object: nil,userInfo: checkinInfo)
                  
                }else{
                    print(error?.localizedDescription ?? "")
                    }
            })
                                                        // objplannedVisit
                                                    })
                    }
                 //   compeletion((totalpages,pagesavailable,lastsynctime,dicOfAttendance,status,message: message,error:Common.returnnoerror(),responseType: responseType))
                }else{
                    let arrOfAttendance = arr as? [[String:Any]] ?? [[String:Any]]()
                    print("arr = \(arrOfAttendance)")
                    let checkinInfo:[String:Any] = [String:Any]()
                    NotificationCenter.default.post(name: Notification.Name.init("updateActivityCheckinInfo"), object: nil,userInfo: checkinInfo)
                    //    compeletion((totalpages,pagesavailable,lastsynctime,arrOfAttendance,status,message: message,error:Common.returnnoerror(),responseType:responseType))
                }
            }else{
                //Utils.toastmsg(message:"Sync Compeleted", duration: 2.0, position: CGPoint.init(x: 150, y: self.view.frame.height - 80))
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.parentView)
             //   self.parentView.makeToast((error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String):error.localizedDescription, duration: 2.0, position: CGPoint.init(x: 180, y: self.view.frame.height - 100))
             //   compeletion((totalpages,pagesavailable,lastsynctime,[[String:Any]](),status,error.localizedRecoverySuggestion ?? message,error: error,ResponseType.none))
            }
    }
    }
//    func   checkin(status:Int,lat:NSNumber,long:NSNumber,activity:Activity,activityid:NSNumber,viewcontroller:UIViewController){
//            SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.show()
//           
//        DispatchQueue.main.async {
//            self.parentView = viewcontroller.view
//        }
//            
//
//    self.apihelper.checkin(lat: lat, long: long, visitID: visitid , id: status) {
//    (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
//                   
//            SVProgressHUD.dismiss()
//    if(status.lowercased() == Constant.SucessResponseFromServer){
//        viewcontroller.view.makeToast(message)
//    let dicOfAttendance = arr as? [String:Any] ?? [String:Any]()
//     
//    }
//    else{
//        viewcontroller.view.makeToast(message)
//   
//      
//    
//           
//        }
//
//                  
//                }
//                
//
//        }
//        
}
