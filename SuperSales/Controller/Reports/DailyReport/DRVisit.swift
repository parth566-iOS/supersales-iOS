//
//  DRVisit.swift
//  SuperSales
//
//  Created by Apple on 14/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import FastEasyMapping


class DRVisit: BaseViewController {
    private let refreshControl = UIRefreshControl()
    @IBOutlet var tblVisitReport: UITableView!
    var selectedroleid:NSNumber!
    public static var aVisits:[Any]!
    public static var atempData:[Any]!
    
    @IBOutlet var vwMap: UIView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
        if #available(iOS 10.0, *) {
            tblVisitReport.refreshControl = refreshControl
        } else {
            tblVisitReport.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
//         [_tblListing addPullToRefreshWithActionHandler:^{
//         jointVisitPageNo=1;
//         [self callWebservice];
//         }];
         
    }
    @objc private func refreshWeatherData(_ sender: Any) {
//        // Fetch Weather Data
        refreshControl.endRefreshing()
        NotificationCenter.default.post(name: NSNotification.Name("getDailyReports"), object: nil)
        tblVisitReport.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(DRVisit.aVisits.count > 0 &&  tblVisitReport.visibleCells.count > 0){
        self.tblVisitReport.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
         tblVisitReport.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(selectedroleid)
        tblVisitReport.reloadData()
       

        if(selectedroleid == 9){
            vwMap.isHidden = true
        }else{
            vwMap.isHidden = false
        }
        vwMap.isHidden = true
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - Method
    func setUI(){
            
    tblVisitReport.delegate = self
    tblVisitReport.dataSource = self
    tblVisitReport.separatorColor = .clear
             
    tblVisitReport.estimatedRowHeight = 90
             
    tblVisitReport.rowHeight = UITableView.automaticDimension
    
    tblVisitReport.reloadData()
         }
    
    //MARK: - API Call
    func getActivityDetail(activityId:NSNumber){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        var dicActivity = [String:Any]()
        dicActivity["CompanyID"] = self.activeuser?.company?.iD
        dicActivity["CreatedBy"] = self.activeuser?.userID
        dicActivity["ID"] = activityId
        param["getPlannedActivityjson"] = Common.returnjsonstring(dic: dicActivity)
//        param["PageNo"] = ActivityList.activityPageNo
//        param["PageSize"] = ActivityList.activityPagesize
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetPlannedActivity, method: Apicallmethod.get)
        { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                    SVProgressHUD.dismiss()
                    if(status.lowercased() == Constant.SucessResponseFromServer){
                       
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
                        MagicalRecord.save { (localcontext) in
                            Activity.mr_truncateAll(in: localcontext)
                           let act =  FEMDeserializer.collection(fromRepresentation:  mutArrOfActivity, mapping: Activity.defaultMapping(), context: localcontext)
                            //print("activity = \(act) ")
                           
                            
                            
                            for activity in Activity.getAll(){
                                if  let visitcheckinoutlistobj = ActivityCheckinCheckout().getActivitycheckinoutFromID(visitID: NSNumber.init(value:activity.activityId)) as? ActivityCheckinCheckout{
                                    //print("counts of checkin before add check in activity \(activity.activityCheckInCheckOutList.count) object  =  \(visitcheckinoutlistobj) checkin time = \(visitcheckinoutlistobj.checkInTime)")
    //                                let mutableCheckinList = activity.activityCheckInCheckOutList as! NSMutableOrderedSet
    //                                activity.activityCheckInCheckOutList = mutableCheckinList
                                }

                             activity.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                if(error == nil){
                                    //print("checkin data saved sucessfully , count \(activity.activityCheckInCheckOutList.count) for activity of  customer   =  \(activity.activityId)")
                               
                               
                            
                                   
                                }else{
                                    //print(error?.localizedDescription ?? "")
                                    }
                            })
                        }
                            localcontext.mr_saveToPersistentStoreAndWait()
                        } completion: { (status, error) in
                            //print("New Activity Saved. and total activity is \(Activity.getAll().count)")
                            for activity in Activity.getAll(){
                                if  let visitcheckinoutlistobj = ActivityCheckinCheckout().getActivitycheckinoutFromID(visitID: NSNumber.init(value:activity.activityId)) as? ActivityCheckinCheckout{
                                    //print("counts of checkin before add check in activity \(activity.activityCheckInCheckOutList.count) object  =  \(visitcheckinoutlistobj) checkin time = \(visitcheckinoutlistobj.checkInTime)")
                                    let mutableCheckinList = activity.activityCheckInCheckOutList as! NSMutableOrderedSet
                                    activity.activityCheckInCheckOutList = mutableCheckinList
                                }

                             activity.managedObjectContext?.mr_saveToPersistentStore(completion: { (status, error) in
                                if(error == nil){
                                    //print("checkin data saved sucessfully , count \(activity.activityCheckInCheckOutList.count) for activity  \(activity.customerName)")
                                }else{
                                    //print(error?.localizedDescription ?? "")
                                    }
                            })
                        }
                       
                        }
                        if let activityfromdatabase = Activity().getActivityFromId(userID: activityId){
                        if let activitydetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityDetail) as? ActivityDetail{//arrActivity[indexPath.row]
                      
                    activitydetail.activitymodelInDetail = activityfromdatabase
                        
                    
                    //activitydetail.activitymodelInDetail =  activity//arrActivity[indexPath.row]
                    self.navigationController?.pushViewController(activitydetail, animated: true)
                        }
                        }
                    }else{
                        Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
                         }
        }
        
    }
    //MARK: - IBAction
    
    @IBAction func mapClicked(_ sender: UIButton){
        //isFromDailyReport = true
        if let map = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MapView) as? GoogleMap{
            map.isFromDashboard = false
            map.isFromDailyReport = true
            map.select_date =  Reports.selectedDate
            map.aryDailyReportArray = DRVisit.aVisits
            self.navigationController?.pushViewController(map, animated: true)
        }
    }

}
extension DRVisit:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(DRVisit.aVisits.count)
        return DRVisit.aVisits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let  cell = tableView.dequeueReusableCell(withIdentifier: Constant.MissedVisitCell, for: indexPath) as? VisitCell{
        cell.stkParent.backgroundColor   =  UIColor().colorFromHexCode(rgbValue: 0xE7E7EC)
        cell.stackViewNextActionDetail.isHidden = true
        cell.lblCreatedBy.isHidden = true
        cell.lblNextActionDetail.isHidden = true
        let visit = DRVisit.aVisits[indexPath.row]
        if(type(of: visit) == PlannVisit.self){
        let planvisit = visit as? PlannVisit
            cell.vwCustomer.backgroundColor =  UIColor.clear
            cell.lblCustomerName.textColor = UIColor.darkGray
            cell.lblCustomerName.font = UIFont.myMediumSystemFont(ofSize: 15)
            if(planvisit?.customerName?.count ?? 0 > 0){
                cell.lblCustomerName.text = planvisit?.customerName
            }else{
cell.lblCustomerName.text = "Customer Not Mapped"
            }

    if let visitno = planvisit?.seriesPostfix as? Int64{
        cell.lblCustomerName.text?.append(" (#\(visitno))")
        
            }
   
self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
let dtnextAction = self.dateFormatter.date(from: planvisit?.nextActionTime ?? "3/02/2020 4:05 am")
self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let titleNextAction = NSMutableAttributedString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.darkGray,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)]) //NSMutableString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
            titleNextAction.append(NSAttributedString.init(string: self.dateFormatter.string(from: dtnextAction ?? Date()), attributes: [NSAttributedString.Key.foregroundColor:UIColor.darkGray]))
cell.lblCheckinDetail.attributedText  = titleNextAction
            cell.imgInteractionType.isHidden = false
            let img = Utils.getNextActionImage(interactionId: Int(planvisit?.nextActionID ?? 1))
            cell.imgInteractionType.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEBF5FF)
            cell.imgInteractionType.image = img
        
            cell.lblAssigneeName.font = UIFont.systemFont(ofSize: 15)
            cell.lblVisitDate.font  = UIFont.systemFont(ofSize: 15)
            if let strcheckInTime =  planvisit?.checkInTime{
                if let strcheckOutTime = planvisit?.checkOutTime{

            if(strcheckInTime.count > 0){
                var strch = ""
                if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.checkInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                    strch.append(strcht)
                }
             
                let strchtime = Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                attrbutedString.append(NSAttributedString.init(string:strchtime, attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                
                /*
                 if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.checkInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                 strch = strcht
                 }
                 let attrbutedString = NSMutableAttributedString.init(string: Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a"), attributes: [NSAttributedString.Key.foregroundColor     : UIColor.blue])
                 cell.lblInValue.attributedText = attrbutedString
                 **/
                  cell.lblAssigneeName.attributedText =  attrbutedString
            }else{
                let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                cell.lblAssigneeName.attributedText  = attrbutedString
            }
            if(strcheckOutTime.count > 0 ){
                var strch = ""
                if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.checkOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                    strch.append(strcht)
                    cell.lblVisitDate.text = String.init(format:"Out: \(strch)")
                    
                }
                let strchtime = Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                let attrbutedString = NSMutableAttributedString.init(string: "Out: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                attrbutedString.append(NSAttributedString.init(string:strchtime, attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                cell.lblVisitDate.attributedText  = attrbutedString
            }else{
                let attrbutedString = NSMutableAttributedString.init(string: "Out: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                 cell.lblVisitDate.attributedText  = attrbutedString
            }
                
                }else{
                 //   cell.vwSpeedDistance.isHidden = true
                    
                    if(strcheckInTime.count > 0){
                        var strch = ""
                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: planvisit?.checkInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                            strch.append(strcht)
                        }
                      let strchtime = Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                       // cell.lblAssigneeName.text = String.init(format:"In: \(strchtime)")
                        let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                        attrbutedString.append(NSAttributedString.init(string:strchtime, attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                        cell.lblAssigneeName.attributedText  = attrbutedString
                    }else{
                        let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                        attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                        cell.lblAssigneeName.attributedText  = attrbutedString
                       // cell.lblAssigneeName.text = "In: --:--"
                    }
                    let attrbutedString = NSMutableAttributedString.init(string: "Out: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                    attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                     cell.lblVisitDate.attributedText  = attrbutedString
                        // cell.lblVisitDate.text = "Out: --:--"
                    
                }
            }else{
                let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                cell.lblAssigneeName.attributedText  = attrbutedString
               // cell.lblAssigneeName.text = "In: --:--"
              //  cell.lblVisitDate.text = "Out: --:--"
                let attrbutedString1 = NSMutableAttributedString.init(string: "Out: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                attrbutedString1.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                 cell.lblVisitDate.attributedText  = attrbutedString1
            }
        }else if(type(of: visit) == Activitymodel.self){
            cell.imgInteractionType.isHidden = true
            cell.lblCustomerName.textColor = UIColor.darkGray
            if let activity = DRVisit.aVisits[indexPath.row] as?
                Activitymodel{
          
            //UIColor().colorFromHexCode(rgbValue: 0xE7E7EC)
          
            
        
            if let activitytype = activity.activityTypeName{
                cell.lblCustomerName.text = String.init(format:"\(activitytype) \("(Activity)")")
            }
            if let customerid =  activity.customerID{
                if(customerid.intValue > 0){
                let customerdetail = CustomerDetails.getCustomerByID(cid: customerid)
            cell.stackViewNextActionDetail.isHidden = false
                    cell.lblNextActionTm.isHidden = true
                    let stratrcustname  = NSMutableAttributedString.init(string: "Customer:", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 15)])
                    stratrcustname.append(NSAttributedString.init(string: customerdetail?.name ?? "name", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))
                cell.lblNextActionDt.attributedText = stratrcustname
                    cell.stkParent.backgroundColor   =  UIColor.clear
        cell.stackViewNextActionDetail.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xE7E7EC)
    cell.vwCheckinDetail.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xE7E7EC)
                }else{
                    cell.stkParent.backgroundColor   = UIColor().colorFromHexCode(rgbValue: 0xE7E7EC)
                    cell.stackViewNextActionDetail.isHidden = true
                }
                }
            else{
                cell.stkParent.backgroundColor   = UIColor().colorFromHexCode(rgbValue: 0xE7E7EC)
                cell.stackViewNextActionDetail.isHidden = true
            }
            cell.vwCustomer.backgroundColor =  Utils.hexStringToUIColor(hex:"#A9BBFD")//UIColor(red:86.0/255.0, green:119.0/255.0, blue:252.0/255.0, alpha:1.0)
           
            self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let dtnextAction = self.dateFormatter.date(from: activity.nextActionTime ?? "3/02/2020 4:05 am")
            self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let titleNextAction = NSMutableAttributedString.init(string: "Date & Time:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.darkGray,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)]) //NSMutableString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
            titleNextAction.append(NSAttributedString.init(string: self.dateFormatter.string(from: dtnextAction ?? Date()), attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
            cell.lblCheckinDetail.attributedText  = titleNextAction

            cell.lblAssigneeName.font = UIFont.systemFont(ofSize: 15)
            cell.lblVisitDate.font  = UIFont.systemFont(ofSize: 15)
            if let strcheckInTime =  activity.checkInTime{
                if let strcheckOutTime = activity.checkOutTime{

            if(strcheckInTime.count > 0){
          var strch = ""
                if let strcht = Utils.getDateBigFormatToDefaultFormat(date: activity.checkInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                    strch.append(strcht)
                }
            
                let strchtime = Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                  cell.lblAssigneeName.text = String.init(format:"In: \(strchtime)")
            }else{
                let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                cell.lblAssigneeName.attributedText  = attrbutedString
               // cell.lblAssigneeName.text = "In: --:--"
            }
            if(strcheckOutTime.count > 0 ){
                var strch = ""
                if let strcht = Utils.getDateBigFormatToDefaultFormat(date: activity.checkOutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                    strch.append(strcht)
                    cell.lblVisitDate.text = String.init(format:"Out: \(strch)")
                }
                let strchtime =  Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                cell.lblVisitDate.text = String.init(format:"Out: \(strchtime)")
            }else{
                let attrbutedString1 = NSMutableAttributedString.init(string: "Out: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                attrbutedString1.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                 cell.lblVisitDate.attributedText  = attrbutedString1
                // cell.lblVisitDate.text =  "Out: --:--"
            }
                
                }else{
                 //   cell.vwSpeedDistance.isHidden = true
                    if(strcheckInTime.count > 0){
                  var strch = ""
                        if let strcht = Utils.getDateBigFormatToDefaultFormat(date: activity.checkInTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                            strch.append(strcht)
                        }
                   
                        let strchtime = Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                          cell.lblAssigneeName.text = String.init(format:"In: \(strchtime)")
                    }else{
                        let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                        attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                        cell.lblAssigneeName.attributedText  = attrbutedString
                       // cell.lblAssigneeName.text = "In: --:--"
                    }
                    let attrbutedString1 = NSMutableAttributedString.init(string: "Out: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                    attrbutedString1.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                     cell.lblVisitDate.attributedText  = attrbutedString1
                      //   cell.lblVisitDate.text = "Out: --:--"
                    
                }
            }else{
                let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                cell.lblAssigneeName.attributedText  = attrbutedString
               // cell.lblAssigneeName.text = "In: --:--"
              //  cell.lblVisitDate.text = "Out: --:--"
                let attrbutedString1 = NSMutableAttributedString.init(string: "Out: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                attrbutedString1.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                 cell.lblVisitDate.attributedText  = attrbutedString1
            }
            
        }else{
            let coldcallvisit = DRVisit.aVisits[indexPath.row] as? UnplannedVisit
            cell.lblCheckinDetail.text = coldcallvisit?.tempCustomerObj?.CustomerName
          if  let visitno = coldcallvisit?.seriesPostfix as? NSNumber{
            cell.lblCheckinDetail.text?.append("(\(visitno))")
            
            }
    var strnt = ""
if let strn = Utils.getDateBigFormatToDefaultFormat(date: coldcallvisit?.NextActionTime ?? "2010/09/12 04:12:34" , format: "yyyy/MM/dd HH:mm:ss") as? String{
            strnt = strn
            }
cell.lblCheckinDetail.text = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "dd-MM-yyyy, hh:mm a")
            
        
        }
            
       
        }else{
            let unplanvisit = visit as? UnplannedVisit
                cell.vwCustomer.backgroundColor =  UIColor.clear
       
                if(unplanvisit?.customerName?.count ?? 0 > 0){
                    cell.lblCustomerName.text = unplanvisit?.customerName
                }else if(unplanvisit?.tempCustomerObj?.CustomerName?.count ?? 0 > 0){
                    cell.lblCustomerName.text = unplanvisit?.tempCustomerObj?.CustomerName
                }else{
    cell.lblCustomerName.text = "Customer Not Mapped"
                }
    cell.lblCustomerName.textColor = UIColor.black
            if let visitno = unplanvisit?.localID as? Int{
            cell.lblCustomerName.text?.append(" (#\(visitno))")
            
                }
       
    self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    let dtnextAction = self.dateFormatter.date(from: unplanvisit?.NextActionTime ?? "3/02/2020 4:05 am")
    self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let titleNextAction = NSMutableAttributedString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)]) //NSMutableString.init(string: "Next Action:", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
                titleNextAction.append(NSAttributedString.init(string: self.dateFormatter.string(from: dtnextAction ?? Date()), attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
    cell.lblCheckinDetail.attributedText  = titleNextAction
                cell.imgInteractionType.isHidden = false
                let img = Utils.getNextActionImage(interactionId: Int(unplanvisit?.nextActionID ?? 1))
                cell.imgInteractionType.backgroundColor = UIColor().colorFromHexCode(rgbValue: 0xEBF5FF)
                cell.imgInteractionType.image = img
            
                cell.lblAssigneeName.font = UIFont.systemFont(ofSize: 15)
                cell.lblVisitDate.font  = UIFont.systemFont(ofSize: 15)
                if let strcheckInTime =  unplanvisit?.checkinTime{
                    if let strcheckOutTime = unplanvisit?.checkoutTime{

                if(strcheckInTime.count > 0){
              var strch = ""
                    if let strcht = Utils.getDateBigFormatToDefaultFormat(date: unplanvisit?.checkinTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                        strch.append(strcht)
                    }
                 
                    let strchtime = Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                    
                      cell.lblAssigneeName.text = String.init(format:"In: \(strchtime)")
                }else{
                    let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                    attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                    cell.lblAssigneeName.attributedText  = attrbutedString
                   // cell.lblAssigneeName.text = "In: --:--"
                }
                if(strcheckOutTime.count > 0 ){
                    var strch = ""
                    if let strcht = Utils.getDateBigFormatToDefaultFormat(date: unplanvisit?.checkoutTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                        strch.append(strcht)
                        cell.lblVisitDate.text = String.init(format:"Out: \(strch)")
                        
                    }
                    cell.lblVisitDate.text = Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                }else{
                    let attrbutedString1 = NSMutableAttributedString.init(string: "Out: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                    attrbutedString1.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                     cell.lblVisitDate.attributedText  = attrbutedString1
                   //  cell.lblVisitDate.text = "Out: --:--"
                }
                    
                    }else{
                     //   cell.vwSpeedDistance.isHidden = true
                        
                        if(strcheckInTime.count > 0){
                            var strch = ""
                            if let strcht = Utils.getDateBigFormatToDefaultFormat(date: unplanvisit?.checkinTime ?? "2020/04/23 02:12:23", format: "yyyy/MM/dd HH:mm:ss"){
                                strch.append(strcht)
                            }
                          let strchtime = Utils.getDatestringWithGMT(gmtDateString:  strch, format: "hh:mm a")
                            cell.lblAssigneeName.text = String.init(format:"In: \(strchtime)")
                            
                        }else{
                            let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                            attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                            cell.lblAssigneeName.attributedText  = attrbutedString
                            //cell.lblAssigneeName.text = "In: --:--"
                        }
                        let attrbutedString1 = NSMutableAttributedString.init(string: "Out: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                        attrbutedString1.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                         cell.lblVisitDate.attributedText  = attrbutedString1
                        //     cell.lblVisitDate.text = "Out: --:--"
                        
                    }
                }else{
                    let attrbutedString = NSMutableAttributedString.init(string: "In: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                    attrbutedString.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                    cell.lblAssigneeName.attributedText  = attrbutedString
                   // cell.lblAssigneeName.text = "In: --:--"
                   // cell.lblVisitDate.text = "Out: --:--"
                    let attrbutedString1 = NSMutableAttributedString.init(string: "Out: ", attributes: [NSAttributedString.Key.foregroundColor     : UIColor.gray])
                    attrbutedString1.append(NSAttributedString.init(string:"--:--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]))
                     cell.lblVisitDate.attributedText  = attrbutedString1
                }
        }
        return cell
       }else{
            return UITableViewCell()
        }
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let visit = DRVisit.aVisits[indexPath.row]
        if(type(of: visit) == PlannVisit.self){
            let planvisit = visit as? PlannVisit
            if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
         
             visitDetail.visitType = VisitType.planedvisit
            visitDetail.redirectTo =  0
            visitDetail.planvisit = planvisit
            self.navigationController?.pushViewController(visitDetail, animated: true)
            }
        }else if(type(of: visit) ==  UnplannedVisit.self){
            let unplanvisit = visit as? UnplannedVisit
            if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
         
             visitDetail.visitType = VisitType.coldcallvisit
            visitDetail.redirectTo =  0
            visitDetail.unplanvisit = unplanvisit
            self.navigationController?.pushViewController(visitDetail, animated: true)
            }
        }else if(type(of: visit) == Activitymodel.self){
            if let activity = DRVisit.aVisits[indexPath.row] as?
                Activitymodel{
                if let activitydetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityDetail) as? ActivityDetail{//arrActivity[indexPath.row]
                  
                        if let activityfromdatabase = Activity().getActivityFromId(userID: NSNumber.init(value: activity.ID ?? 0)) {
                    activitydetail.activitymodelInDetail = activityfromdatabase
                    self.navigationController?.pushViewController(activitydetail, animated: true)
                        }else{
                            self.getActivityDetail(activityId:NSNumber.init(value: activity.ID ?? 0))
                        }
                    
                    //activitydetail.activitymodelInDetail =  activity//arrActivity[indexPath.row]
                   
                }
            }
        }else{
            
        }
    }
}
