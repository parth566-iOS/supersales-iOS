//
//  ActivityList.swift
//  SuperSales
//
//  Created by Apple on 26/04/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import SVPullToRefresh
import FastEasyMapping

class ActivityList: BaseViewController {
    let baseviewcontrollerobj = BaseViewController()
    
    @IBOutlet weak var tblActivity: UITableView!
    static var activityPageNo = 1
    static var pagesAvailable = 0
    static var activityPagesize = NSNumber.init(value:20)
  //  var arrActivity:[Activitymodel]! = [Activitymodel]()
    var arrOfActivity =  [[String:Any]]()
    var mutArrOfActivity = [[String:Any]]()
    static var arrActivity:[Activity]! = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tblActivity.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(tblActivity.visibleCells.count > 0 &&  tblActivity.visibleCells.count > 0){
            
        self.tblActivity.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        self.getActivityList(isOnActivityList: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Method
    func setUI(){
        baseviewcontrollerobj.setparentview(control: self)
        tblActivity.delegate = self
        tblActivity.dataSource = self
        
        tblActivity.tableFooterView = UIView()
        tblActivity.separatorColor = UIColor.clear
        
        self.title =  "Activity"
        //NSLocalizedString("visit", comment: "Title of Visit List")
        baseviewcontrollerobj.setleftbtn(btnType: BtnLeft.menu, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        
        tblActivity.addInfiniteScrolling{
            self.insertRowAtBottom()
        }
        
        
        tblActivity.addPullToRefresh {
            self.getActivityList(isOnActivityList: true)
        }
        /*
         
         [tblView addInfiniteScrollingWithActionHandler:^{
             [weakSelf insertRowAtBottom];
         }];
         **/
    
       
        
    }
    
   
    /*
     [jsonParameter setObject:@(account.company_info.company_id) forKey:@"CompanyID"];
     [jsonParameter setObject:@(account.user_id) forKey:@"CreatedBy"];

     NSMutableDictionary *maindict = [NSMutableDictionary new];
     [maindict setObject:[jsonParameter rs_jsonStringWithPrettyPrint:YES] forKey:@"getPlannedActivityjson"];
     [maindict setObject:@(activityPageNo) forKey:@"PageNo"];
     [maindict setObject:@(activityPageSize) forKey:@"PageSize"];
     [maindict setObject:account.securityToken forKey:@"TokenID"];
     [maindict setObject:@(account.user_id) forKey:@"UserID"];
     [maindict setObject:@(account.company_info.company_id) forKey:@"CompanyID"];
     [maindict setObject:APPLICATION_TEAMWORK forKey:@"Application"];
     
     **/
    
    func getActivityList(isOnActivityList:Bool){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        var dicActivity = [String:Any]()
        dicActivity["CompanyID"] = self.activeuser?.company?.iD
        dicActivity["CreatedBy"] = self.activeuser?.userID
        param["getPlannedActivityjson"] = Common.returnjsonstring(dic: dicActivity)
        param["PageNo"] = ActivityList.activityPageNo
        param["PageSize"] = ActivityList.activityPagesize
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetPlannedActivity, method: Apicallmethod.get)
        { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                        if(isOnActivityList){
                        self.tblActivity.infiniteScrollingView.stopAnimating()
                        }
                        let arrOfActivity = arr as? [[String:Any]] ?? [[String:Any]]()
                        var mutArrOfActivity = [[String:Any]]()
                      
                        for activity in arrOfActivity{
                            print("dic of Activity  = \(activity)")
                            
                            if let dicOfAddress = activity["AddressDetails"] as? [String:Any]{
                                var mutdicadd = dicOfAddress
                                mutdicadd["AddressID"] = 0
                                let addtype = mutdicadd["Type"] as? NSNumber
                                mutdicadd["Type"] = addtype?.stringValue
                                var editedAct = activity
                                editedAct["AddressDetails"] = mutdicadd
                                mutArrOfActivity.append(editedAct)
                            }
                            
                           
                        }
                        if(pagesavailable == ActivityList.activityPageNo){
                           
                            for activity in arrOfActivity{
                                let dicactivity =  activity as? [String:Any] ?? [String:Any]()
                                let actfromResp = activity
                                print(actfromResp)
                        

                                if let act = Activity().getActivityFromId(userID: NSNumber.init(value: actfromResp["ID"] as? Double ?? 0000)) as? Activity{
                                    if(ActivityList.arrActivity.contains(act)){
                                        if let indexofexistingact = ActivityList.arrActivity.firstIndex(of: act){
                                            ActivityList.arrActivity.remove(at: indexofexistingact)
                                            ActivityList.arrActivity.insert(act, at: indexofexistingact)
                                        }
                                    }else{
                                    ActivityList.arrActivity.append(act)
                                    }
                                    
                                }else{
                                    print("not get activity \(actfromResp["ID"]) and double value \(actfromResp["ID"] as? Double ?? 0000) ")
                                }
                            }
                            if(isOnActivityList){
                            self.tblActivity.showsInfiniteScrolling = false
                            self.tblActivity.pullToRefreshView.stopAnimating()
                            }
                        }else{
                            for activity in arrOfActivity{
                                let actfromResp = activity
                                if let act = Activity().getActivityFromId(userID: NSNumber.init(value: actfromResp["ID"] as? Double ?? 0000)) as? Activity{
                                   // ActivityList.arrActivity.append(act)

                                    if(ActivityList.arrActivity.contains(act)){
                                        if let indexofexistingact = ActivityList.arrActivity.firstIndex(of: act){
                                            ActivityList.arrActivity.remove(at: indexofexistingact)
                                            ActivityList.arrActivity.insert(act, at: indexofexistingact)
                                        }
                                    }else{
                                    ActivityList.arrActivity.append(act)
                                    }                                }
                            }
                            if(isOnActivityList){
                            self.tblActivity.showsInfiniteScrolling = true
                            self.tblActivity.infiniteScrollingView.stopAnimating()
                            }
                        }
                        ActivityList.arrActivity =  unique(source: ActivityList.arrActivity)
                      
//                        for activity in arrOfActivity{
//                            let activitymodel = Activitymodel().initwithdic(dict: activity)
//
//                            if let dicOfAddress = activity["AddressDetails"] as? [String:Any]{
//                                var mutdicadd = dicOfAddress
//                                mutdicadd["AddressID"] = 0
//                                var editedAct = activity
//                                editedAct["AddressDetails"] = mutdicadd
//                                mutArrOfActivity.append(editedAct)
//                            }
//
//                            self.arrActivity.append(activitymodel)
//                        }
                   
                        if(isOnActivityList){
                        self.tblActivity.reloadData()
                        }
                    }else{
                        Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                         }
                        }
        
    }
    
    
    func deleteActivityAndRefresh(){
        ActivityList.activityPageNo=1
        self.getActivityList(isOnActivityList: true)
    }
    
    
    func insertRowAtBottom(){
        ActivityList.activityPageNo += 1
        self.getActivityList(isOnActivityList: true)
    }
    
    // MARK: - IBAction
    @IBAction func btnAddActivityClicked(_ sender: UIButton) {
        //Add Activity
        if let addActivity = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.AddActivity) as? AddActivity{
                
                self.navigationController?.pushViewController(addActivity, animated: true)
        }
    }
    
    
}
extension ActivityList:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ActivityList.arrActivity.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell:VisitCell = tableView.dequeueReusableCell(withIdentifier: Constant.ActivityCell, for: indexPath) as? VisitCell{
//        let visitobj = arrOfPlanVisit[indexPath.row]
//        cell.setData(visit: visitobj)
            let activitymodel = ActivityList.arrActivity[indexPath.row]
            print("activity  == \(activitymodel) , checkinoutlist  count = \(activitymodel.activityCheckInCheckOutList.count)")
        cell.stackViewNextActionDetail.isHidden = true
        cell.lblCreatedBy.isHidden = true
        cell.lblVisitSeries?.isHidden = true
            cell.lblAssigneeName.font = UIFont.systemFont(ofSize: 16)
            cell.lblVisitDate.font = UIFont.systemFont(ofSize: 17)
           // cell.lblAssigneeName.text = String.init(format:"Time: \(activitymodel.createdTime)")
           // cell.lblVisitDate.text = activitymodel.nextActionTime
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date = dateformatter.date(from: activitymodel.createdTime ?? "2020/10/31 10:10:11")
            let nadate = dateformatter.date(from: activitymodel.nextActionTime ?? "2020/10/31 10:10:11")//nextActionTime
            dateformatter.dateFormat = "dd MMM"
//            cell.lblVisitDate.text = dateformatter.string(from: date ?? Date())
//            dateformatter.dateFormat = "hh:mm a"
                /*
             [Utils getDatestringWithGMT:[Utils getDateBigFormatToDefaultFormat:objActivity.NextActionTime andFormat:@"yyyy/MM/dd HH:mm:ss"] andFormat:@"d MMM"]
             **/
            cell.lblVisitDate.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: activitymodel.nextActionTime ?? "2020/10/31 10:10:11", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/31 10:10:11", format: "d MMM")//dateformatter.string(from: nadate ?? Date())
            var strnt = ""
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: activitymodel.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                strnt = strn
             }
          //  cell.lblVisitDate.text = (activitymodel.nextActionTime.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a"): ""
            cell.lblCustomerName.text = activitymodel.activityTypeName
            let attributedStr = NSMutableAttributedString.init(string: "Time:", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
            if let nat = activitymodel.nextActionTime as? String{
            attributedStr.append(NSAttributedString.init(string: (activitymodel.nextActionTime.count ?? 0 > 0) ? Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: activitymodel.nextActionTime ?? "2020/10/31 10:10:11", format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/31 10:10:11", format: "hh:mm a"): "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]))
            }
            cell.lblAssigneeName.attributedText = attributedStr
         //   cell.lblAssigneeName.text = String.init(format:"Time: \(dateformatter.string(from: nadate ?? Date()))")
        
            cell.lblCheckinDetail.isHidden = false
                let attributedStr1 = NSMutableAttributedString.init(string: "Customer: ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
                attributedStr1.append(NSAttributedString.init(string: activitymodel.customerName ?? ""))
                cell.lblCheckinDetail.attributedText = attributedStr1
           
            cell.lblCreatedBy.isHidden = false
            cell.lblCreatedBy.text = activitymodel.activitydescription
            cell.lblCreatedBy.setMultilineLabel(lbl: cell.lblCreatedBy)
           
            cell.lblNextActionDetail.font = UIFont.boldSystemFont(ofSize: 16)
         
            print("activity = \(activitymodel) checkin out list count = \(activitymodel.activityCheckInCheckOutList.count)")
            if(activitymodel.activityCheckInCheckOutList.count ?? 0 > 0){
                if let checkinmodel = activitymodel.activityCheckInCheckOutList.firstObject as? ActivityCheckinCheckout{
                    var strcheckin = ""
                if let strCheckin = checkinmodel.checkInTime as? String{
                    strcheckin.append("In: ")
                        
  // strcheckin.append(\(Utils.getD))
 // let strcheckindate =
//Utils.getDatestringWithGMT(gmtDateString: strcheckin, format: "hh:mm a")
                    strcheckin.append(Utils.getDatestringWithGMT(gmtDateString: strCheckin, format: "dd MMM hh:mm a"))
 //  strcheckin.append(String.init(format: "\(Utils.getDateWithAppendingDay(day: 0, date: strCheckin as? Date ?? Date(), format: "dd-MMM hh:mm a"))"))
            cell.lblNextActionDetail.text = strcheckin
// strcheckin.append(String.init(format:"In : \(Utils.getDateWithAppendingDay(day: 0, date: strCheckin as Date, format: "hh:mm a")"))
                    }else{
                        
                    }
                    
                    if let strCheckout = checkinmodel.checkOutTime as? String{
                        if(strCheckout.count > 0){
                        strcheckin.append(" Out: ")
                        
                       // strcheckin.append(\(Utils.getD))
//                        let strcheckindate =
                        //Utils.getDatestringWithGMT(gmtDateString: strcheckin, format: "hh:mm a")
                            strcheckin.append(Utils.getDatestringWithGMT(gmtDateString: strCheckout, format: "dd MMM hh:mm a"))
                      //  strcheckin.append(String.init(format: "\(Utils.getDateWithAppendingDay(day: 0, date: strCheckin as? Date ?? Date(), format: "dd-MMM hh:mm a"))"))
                        cell.lblNextActionDetail.text = strcheckin
                        }else{
                            strcheckin.append(" Out: ")
                            strcheckin.append("--:--")
                            cell.lblNextActionDetail.text = strcheckin
                        }
                    
               // strcheckin.append(String.init(format:"In : \(Utils.getDateWithAppendingDay(day: 0, date: strCheckin as Date, format: "hh:mm a")"))
                    }else{
                        
                    }
                }
            }else{
                cell.lblNextActionDetail.text = "Not Checked in yet"
            }
       //     cell.lblNextActionDetail.text =
        return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let activitydetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityDetail) as? ActivityDetail{//arrActivity[indexPath.row]
            if let activitymodel = ActivityList.arrActivity[indexPath.row] as? Activitymodel{
                if let activityfromdatabase = Activity().getActivityFromId(userID: NSNumber.init(value: activitymodel.ID ?? 0)) {
            activitydetail.activitymodelInDetail = activityfromdatabase
                }
            }
            activitydetail.activitymodelInDetail =  ActivityList.arrActivity[indexPath.row]
            self.navigationController?.pushViewController(activitydetail, animated: true)
        }
        
    }
    func unique<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
