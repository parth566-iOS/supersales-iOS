//
//  ActivityDetail.swift
//  SuperSales
//
//  Created by Apple on 26/07/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit
import SVProgressHUD
import CoreLocation

class ActivityDetail: BaseViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var vwCheckInDetail: UIView!
    @IBOutlet weak var lblCheckInDetail: UILabel!
    
    @IBOutlet weak var  btnCheckIn: UIButton!
    var itemsvisitDetail:Array<String>!
    
    var carbonswipenavigationobj:CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    @IBOutlet weak var targetview: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var btnRefresh: UIButton!
    var activitymodelInDetail:Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name("updateActivityCheckinInfo"), object: nil, queue: OperationQueue.main) { (notify) in
            
            self.setActivityCheckininfo()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateActivityCheckinInfo"), object: nil)
    }
    
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(true)
    //        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("updateActivityCheckinInfo"), object: nil)
    //    }
    
    //MARK: - Method
    
    
    func setUI(){
        btnCheckIn.backgroundColor = UIColor.Appskybluecolor
        self.title = "Activity"
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        if(activitymodelInDetail?.activityCheckInCheckOutList.count == 0){
            self.setrightbtn(btnType: BtnRight.homeedit, navigationItem: self.navigationItem)
        }else{
            self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        }
        if(activitymodelInDetail?.statusDescription.count ?? 0 > 0){
            itemsvisitDetail = ["Details"]
        }else{
            itemsvisitDetail = ["Details","Report"]
        }
        self.salesPlandelegateObject = self
        if let activityModel = activitymodelInDetail{
            let (message,lastcheckinStatus) =  Utils.latestCheckinForActivity(activity: activityModel)
            if(lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
                btnCheckIn.setTitle(NSLocalizedString("CHECK_OUT", comment:""), for: .normal)
                btnRefresh.setImage(UIImage.init(named: "icon_exit"), for: .normal)
            }else if(lastcheckinStatus == UserLatestActivityForVisit.none){
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""), for: .normal)
                btnRefresh.setImage(UIImage.init(named:"icon_error"), for:.normal)
            }else{
                btnRefresh.setImage(UIImage.init(named: "icon_error"), for: .normal)
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""), for: .normal)
                
            }
            
            lblCheckInDetail.text = message
        }
        
        carbonswipenavigationobj = CarbonTabSwipeNavigation.init(items: itemsvisitDetail, toolBar: toolbar, delegate: self)
        carbonswipenavigationobj.insert(intoRootViewController: self, andTargetView: targetview)
        self.setActivityDetailStyle()
        self.setActivityCheckininfo()
    }
    
    func setActivityCheckininfo(){
        lblCheckInDetail.font = UIFont.systemFont(ofSize: 15)
        lblCheckInDetail.setMultilineLabel(lbl: lblCheckInDetail)
        if(activitymodelInDetail?.activityCheckInCheckOutList.count == 0){
            self.setrightbtn(btnType: BtnRight.homeedit, navigationItem: self.navigationItem)
        }else{
            self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        }
        if let activityModel = activitymodelInDetail as? Activity{
            let (message,lastcheckinStatus) =  Utils.latestCheckinForActivity(activity: activityModel)
            if(lastcheckinStatus == UserLatestActivityForVisit.checkedIn){
                btnCheckIn.setTitle(NSLocalizedString("CHECK_OUT", comment:""), for: .normal)
                btnRefresh.setImage(UIImage.init(named: "icon_exit"), for: .normal)
            }else if(lastcheckinStatus == UserLatestActivityForVisit.none){
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""), for: .normal)
                btnRefresh.setImage(UIImage.init(named:"icon_error"), for:.normal)
            }else{
                btnRefresh.setImage(UIImage.init(named: "icon_error"), for: .normal)
                btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment:""), for: .normal)
                //  btnCheckIn.setImage(UIImage.init(named:"icon_error"), for:.normal)
            }
            print(message)
            lblCheckInDetail.setMultilineLabel(lbl: lblCheckInDetail)
            lblCheckInDetail.text = message
        }
        lblCheckInDetail.setMultilineLabel(lbl: lblCheckInDetail)
    }
    
    
    
    func setActivityDetailStyle(){
        carbonswipenavigationobj.setTabExtraWidth(0)
        //        self.attendanceToolbar.tintColor =  UIColor.Appskybluecolor
        //        self.attendanceToolbar.barTintColor = UIColor.Appthemecolor
        
        
        //float width = screenSize.size.width/(items.count>3?3:items.count);
        let width = (Common.Screensize.size.width)/CGFloat(itemsvisitDetail.count > 3 ? 3:itemsvisitDetail.count)
        
        for i in 0...itemsvisitDetail.count - 1{
            carbonswipenavigationobj.carbonSegmentedControl?.setWidth(width, forSegmentAt: i)
        }
        
        
        carbonswipenavigationobj.setNormalColor(.black , font: UIFont.systemFont(ofSize: 15));
        
        carbonswipenavigationobj.setSelectedColor(UIColor().colorFromHexCode(rgbValue: 0x2196F3) , font: UIFont.boldSystemFont(ofSize: 15))
        carbonswipenavigationobj.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    // MARK: -IBAction
    
    
    @IBAction func btnCheckInClicked(_ sender: UIButton) {
        if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
            //          CLLocationCoordinate2DIsValid(currentCoordinate)
            if(CLLocationCoordinate2DIsValid(currentCoordinate)){
                if let aid = activitymodelInDetail?.activityId {
                    
                    //            ActivityCheckinCheckoutClass().activityCheckin(lat: currentCoordinate.latitude, long: currentCoordinate.longitude, activityID:aid){
                    if( sender.currentTitle == NSLocalizedString("CHECK_IN", comment: "")){
                        if(Utils().FirstCheckInAttendance(view: self) ==  true){
                        ActivityCheckinCheckoutClass().activityCheckin(lat: NSNumber.init(value: currentCoordinate.latitude), long: NSNumber.init(value: currentCoordinate.longitude), viewcontroller: self, activityID: NSNumber.init(value:aid))
                        }
                    }else{
                        ActivityCheckinCheckoutClass().activityCheckout(lat: NSNumber.init(value:currentCoordinate.latitude), long: NSNumber.init(value: currentCoordinate.longitude), viewcontroller: self, activityID: NSNumber.init(value: aid))
                    }
                }
                
                /*    ActivityCheckinCheckoutClass().activityCheckin(lat: currentCoordinate.latitude, long: currentCoordinate.longitude, activityID: activitymodelInDetail?.activityId){
                 //                (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                 if(status.lowercased() == Constant.SucessResponseFromServer){
                 
                 }else{
                 
                 }
                 } */
                
                //            self.apihelper.activityCheckin(lat: currentCoordinate.latitude, long: currentCoordinate.longitude, activityID: activitymodel?.ID){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                //                
                //            }
                //            self.apihelper.activityCheckin(lat: currentCoordinate.latitude, long: currentCoordinate.longitude, activityID: activitymodel?.ID)
                //            self.apihelper.activityCheckin(lat: currentCoordinate.latitude, long: currentCoordinate.longitude, activityID: activitymodel?.ID)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                //                SVProgressHUD.dismiss()
                //                if(status.lowercased() == Constant.SucessResponseFromServer){
                //
                //                }else{
                //
                //                }
                //            }
            }else{
                Utils.toastmsg(message:"Please do relogin",view: self.view)
            }
        }else
        {
            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
            let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
            }
            Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
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
extension ActivityDetail:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        //    selectedindex = Int(index)
        if(index == 0){
            if let activitydetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivitySubDetail) as? ActivitySubDetail{
                activitydetail.activitymodel = activitymodelInDetail
                
                return activitydetail
            }else{
                return UIViewController()
            }
        }else{
            if let activityStatus = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityReport) as? ActivityReport{
                activityStatus.activitymodel = activitymodelInDetail
                if let activityID = activitymodelInDetail?.activityId as? Int64
                {
                    activityStatus.activityId = NSNumber.init(value: activityID)
                }
                return activityStatus
            }else{
                return UIViewController()
            }
        }
    }
}
extension ActivityDetail:BaseViewControllerDelegate{
    func editiconTapped(sender:UIBarButtonItem) {
        let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
            self.deleteActivity()
        }
        Common.showalert(title: "Delete Activity", msg: "Are you sure you want to delete Actvity", yesAction: yesAction, noAction: noAction, view: self)
        
    }
    
    func deleteActivity(){
        /*
         [jsonParameters setObject:@(account.company_info.company_id) forKey:@"CompanyID"];
         [jsonParameters setObject:@(_activity.ID) forKey:@"ID"];
         
         NSMutableDictionary *maindict = [NSMutableDictionary new];
         [maindict setObject:[jsonParameters rs_jsonStringWithPrettyPrint:YES] forKey:@"deleteActivityjson"];
         [maindict setObject:@(account.user_id) forKey:@"UserID"];
         [maindict setObject:account.securityToken forKey:@"TokenID"];
         [maindict setObject:@(account.company_info.company_id) forKey:@"CompanyID"];
         [SVProgressHUD showWithStatus:@"Deleting Activity..."];
         
         **/
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        var deletestrActivity = [String:Any]()
        deletestrActivity["CompanyID"] = self.activeuser?.company?.iD
        deletestrActivity["ID"] = activitymodelInDetail?.activityId
        param["deleteActivityjson"] = Common.json(from: deletestrActivity)
        param["CompanyID"] = self.activeuser?.company?.iD
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlDeleteActivity, method: Apicallmethod.post){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                MagicalRecord.save { (localcontext) in
                    if let activityId = self.activitymodelInDetail?.activityId{
                        //  Activity.deleteActivity(activityID: NSNumber.init(value:activityId))
                        //     let context:NSManagedObjectContext = AppDelegate.managedObjectContext
                        
                        if let activity = Activity().getActivityFromId(userID: NSNumber.init(value:activityId)){
                            let Predicate = NSPredicate.init(format: "activityId = %d ", activityId)
                            Activity.mr_deleteAll(matching: Predicate, in: localcontext)
                            //   localcontext.delete(activity)
                            // NSManagedObjectContext.mr_default().delete(activity)
                            
                            // localcontext.delete(activity)
                        }
                    }
                    
                    
                    
                } completion: { (status, error) in
                    if(error == nil){
                        print("deleted")
                        //                        if let activityId = self.activitymodelInDetail?.activityId{
                        //                            if let recentactivity = Activity().getActivityFromId(userID: NSNumber.init(value:activityId)){
                        //                                print("status isactive of activity = \(recentactivity.isActive)")
                        //                            }
                        //                        }
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }else{
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
        }
        
    }
    
}

