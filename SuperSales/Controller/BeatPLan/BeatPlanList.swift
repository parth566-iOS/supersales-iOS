//
//  BeatPlanList.swift
//  SuperSales
//
//  Created by Apple on 02/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol beatPlanProtocol {
    func updataData(arrOfBeatPlan:Array<BeatPlanListModel>)->()
}

class BeatPlanList: BaseViewController {
 
    //var beatPlanData:[BeatPlanListModel]!
    var delegate:beatPlanProtocol?
    var beatPlanContainer:BeatPlanContainerView!
    var userIDForBeatPlantList:NSNumber!
    var inputFormatter:DateFormatter! = DateFormatter()
    static var globalLimitBeatArr: [BeatPlan]!
    var beatPlanData:[BeatPlan]?
    var strselectedyear:String!
    var strselectedMonth:String!
    var selectedUserID:NSNumber!
    var arrOfBeatPlan:[BeatPlan]! = [BeatPlan]()
    
    @IBOutlet weak var tblBeatplanList: UITableView!
    override func viewDidLoad() {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        super.viewDidLoad()
        self.setData()
        // Do any additional setup after loading the view.
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.userIDForBeatPlantList = self.activeuser?.userID
//        self.getBeatPlanList(userID: self.userIDForBeatPlantList , selectedMonth:self.strselectedMonth , selectedYear: self.strselectedyear, updateClendar: false )
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       // self.userIDForBeatPlantList = self.activeuser?.userID
        self.getBeatPlanList(userID: self.userIDForBeatPlantList , selectedMonth:self.strselectedMonth , selectedYear: self.strselectedyear, updateClendar: false )
    }

    // MARK: SetData
    func setData(){
        tblBeatplanList.reloadData()
        tblBeatplanList.delegate = self
        tblBeatplanList.dataSource = self
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        tblBeatplanList.tableFooterView = UIView()
        self.getBeatPlanList(userID: self.userIDForBeatPlantList , selectedMonth:self.strselectedMonth , selectedYear: self.strselectedyear, updateClendar: false )
        tblBeatplanList.separatorColor = UIColor.clear
        NotificationCenter.default.addObserver(forName: Notification.Name("updateBeatPlanCall"), object: nil, queue: OperationQueue.main) { (notify) in
            print(notify.object as?  Dictionary<String,Any>)
            //  let dic = notify.object as! Dictionary<String,Any>
            if let dic = notify.object as? Dictionary<String,Any> {
                // action is not nil, is a String type, and is now stored in actionString
               
            //    self.getBeatPlanList(userID: Common.returndefaultnsnumber(dic: dic, keyvalue: "userId"), selectedMonth: Common.returndefaultstring(dic: dic,keyvalue: "selectedMonth"), selectedYear:Common.returndefaultstring(dic: dic, keyvalue: "selectedYear"), updateClendar: true)
            } else {
                // action was either nil, or not a String type
            }
            
        }
    }
    // MARK: APICall
    func  getBeatPlanList(userID:NSNumber, selectedMonth:String,selectedYear:String,updateClendar:Bool){
        var beatplandetail = ["CompanyID":self.activeuser?.company?.iD]
        if(userID == 0){
            beatplandetail["AssigneeID"] =  self.activeuser?.userID
        }else{
            beatplandetail["AssigneeID"] =  userID
        }
        
        
        var param = [String:Any]() // Common.returndefaultparameter()
        param["Type"] = "1 , 2"//["1","2"]
//        param["TokenID"] = self.activeuser?.securityToken ?? "ds"
//        param["Application"] = ConstantURL.APPLICATIONSUPERSALESPRO
        self.userIDForBeatPlantList = userID
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        if(strselectedMonth.count == 0){
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            strselectedMonth = dateFormatter.string(from: now)
            
        }
        if(strselectedyear.count == 0){
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            strselectedyear = dateFormatter.string(from: now)
            // selectedMonth = nameOfMonth
        }
        param["TokenID"] = self.activeuser?.securityToken ?? "ds"
        param["Application"] = ConstantURL.APPLICATIONSUPERSALESPRO
        param["Month"] = selectedMonth
        param["Year"] =  selectedYear
        param["getAssigneeBeatPlanDetailsJson"] = Common.json(from: beatplandetail)
        print("Beatplan list param = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetAsignedBeatPlanList, method:Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
        SVProgressHUD.dismiss()
           
        if(status.lowercased() == Constant.SucessResponseFromServer){
            self.arrOfBeatPlan = [BeatPlan]()
        let arrOfBeatPlanFromAPI = arr as? [[String:Any]] ?? [[String:Any]]()
       
            for b in arrOfBeatPlanFromAPI{
                let bp = BeatPlan.init(b)
                self.arrOfBeatPlan.append(bp)
            }
        BeatPlanList.globalLimitBeatArr =  self.arrOfBeatPlan ?? [BeatPlan]()
            if(updateClendar){
                if  let beatPlanListObjcal = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanListCelander) as? BeatPlanListCalender{
                    beatPlanListObjcal.userIDForBeatPlantList = self.selectedUserID
                    beatPlanListObjcal.strselectedMonth = self.strselectedMonth
                    beatPlanListObjcal.strselectedyear = self.strselectedyear
                    BeatPlanListCalender.calendar.reloadData()
                   // BeatPlanListCalender.calendar.delegate?.calendar?(BeatPlanListCalender.calendar, willDisplay: FSCalendarCell(), for: Date(), at: FSCalendarMonthPositioncurrent)
                 //   beatPlanListObjcal.
                    //getBeatPlanList(userID:selectedUserID, selectedMonth: nameOfMonth, selectedYear: nameOfYear, updateClendar: false)
                }
            }
        self.tblBeatplanList.reloadData()
       if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        }else if(error.code == 0){
            self.tblBeatplanList.reloadData()
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
       self.tblBeatplanList.reloadData()
   Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
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
extension BeatPlanList:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arrOfBeatPlan.count)
        return arrOfBeatPlan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.BeatPlanListCell, for: indexPath) as? BeatPlanListCell{
        let beatplan = arrOfBeatPlan[indexPath.row]
        //cell.vwParent.addBorders(edges: [.left,.right,.top,.bottom], color: UIColor.gray, cornerradius: 5)
            cell.vwParent.backgroundColor = UIColor.init(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1.0)//UIColor.lightBackgroundColor
        cell.lblBeatID.text = beatplan.BeatPlanID
        cell.lblVisitStatus.text =  beatplan.BeatPlanName
        self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = self.dateFormatter.date(from: beatplan.BeatPlanDate)
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        cell.lblVisitDate.text = self.dateFormatter.string(from: date ?? Date())
        if(beatplan.StatusID == 1){
            cell.imgStatusIndicator.backgroundColor =  UIColor.gray
        }else if(beatplan.IsActive == 2){
            cell.imgStatusIndicator.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0xFFCE4B)//UIColor.yellow
        }else if(beatplan.IsActive == 1){
            cell.imgStatusIndicator.backgroundColor =  UIColor().colorFromHexCode(rgbValue: 0x25A614)//UIColor.green
        }
        return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
}
