//
//  JointVisitList.swift
//  SuperSales
//
//  Created by Apple on 17/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class JointVisitList: BaseViewController,UITableViewDelegate,UITableViewDataSource{

    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var tblJointVisitList: UITableView!
     var arrOfPlanVisit:[PlannVisit]!
    var currentPageForJointVisit:Int!
     var arrOfJointVisit:[JointVisit] = [JointVisit]()
    var lastItemReached:Bool!
    
    override func viewDidLoad() {
        currentPageForJointVisit = 1
        super.viewDidLoad()
        lastItemReached = false
        arrOfPlanVisit = [PlannVisit]()
        tblJointVisitList.delegate = self
        tblJointVisitList.dataSource = self
        tblJointVisitList.separatorColor = .clear
        tblJointVisitList.tableFooterView = UIView()
        
        //infinite scrolling
//        if #available(iOS 10.0, *) {
//            tblJointVisitList.refreshControl = refreshControl
//        } else {
//            tblJointVisitList.addSubview(refreshControl)
//        }
//        // Configure Refresh Control
//        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
//        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
//        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Other Joint visits ...", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
        // Do any additional setup after loading the view.
    
        self.getJointVisitList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.salesPlandelegateObject = self
        if(arrOfJointVisit.count > 0 && self.tblJointVisitList.visibleCells.count > 0){
        self.tblJointVisitList.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    // MARK: - Method
    @objc private func refreshWeatherData(_ sender: Any) {
//        // Fetch Weather Data
//        getJointVisitList()
    }
    // MARK: - API Call
    func getJointVisitList(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.apihelper.getJointVisitList(currentPage: currentPageForJointVisit) { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(error.code == 0){
                self.refreshControl.endRefreshing()
                self.currentPageForJointVisit = self.currentPageForJointVisit + 1
                 if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                print(responseType)
                let arrJointVisit:[[String:Any]] = arr as? [[String:Any]] ?? [[String:Any]]()
                if(arrJointVisit.count == 0){
                    self.lastItemReached = true
                }else{
                    self.lastItemReached = false
                }
                if(self.currentPageForJointVisit == 1){
                    self.arrOfJointVisit = [JointVisit]()
                    self.arrOfJointVisit.removeAll()
                }
                print( "Before append \(self.arrOfJointVisit.count) and count of jointvisit list = \(arrJointVisit.count)")
                for dic in arrJointVisit{
                    do {
                        let jointvisit = try JSONDecoder().decode(JointVisit.self, from: JSONSerialization.data(withJSONObject:dic)) 
                       
                        self.arrOfJointVisit.append(jointvisit)
                    } catch {
                        // print error here.
                        print("get some error")
                    }
                }
                print( "after append \(self.arrOfJointVisit.count)")
                self.tblJointVisitList.reloadData()
            }else{
                self.refreshControl.endRefreshing()
                Common.showalert(msg: (error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?((error.userInfo["localiseddescription"] as? String)!):error.localizedDescription,view:self)
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
    //MARK - UITableviewdeleagate , UITableviewdatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfJointVisit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if    let cell:JointVisitCell = tableView.dequeueReusableCell(withIdentifier: Constant.JointVisitListCell, for: indexPath) as? JointVisitCell{
        let visitobj = arrOfJointVisit[indexPath.row]
       cell.setData(visit: visitobj)
        cell.btnDelete.tag = indexPath.row
       
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteTapped), for: .touchUpInside)
//        cell.stackViewNextActionDetail.isHidden = true
//        cell.lblCreatedBy.isHidden = true
            print(indexPath.row)
            print(arrOfJointVisit.count - 1)
            if((indexPath.row == arrOfJointVisit.count - 1 ) && (lastItemReached == false) ){
                self.getJointVisitList()
            }
        return cell
        }else{
            return UITableViewCell()
        }
    }
    @objc func btnDeleteTapped(sender:UIButton){
       
        let yesAction = UIAlertAction.init(title: "YES", style: .destructive) { (action) in
            SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
            let jointvisitobj = self.arrOfJointVisit[sender.tag]
            var param = Common.returndefaultparameter()
            var param1 = [String:Any]()
            param1["ID"] = jointvisitobj.ID
            param1["CompanyID"] = jointvisitobj.CompanyID
            param1["MemberID"] = jointvisitobj.MemberID
            param1["StartTime"] = jointvisitobj.StartTime
            param1["EndTime"] = jointvisitobj.EndTime
            if let activeuserid = Utils().getActiveAccount()?.userID{
                param1["UserID"] = activeuserid
            }else{
               param1["UserID"] = "0"
            }
          //  param1["UserID"] = Utils().getActiveAccount()?.userID
            param["deleteJointVisitJson"] = Common.returnjsonstring(dic:param1)
            self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlDeleteJointVisit, method: Apicallmethod.post, compeletion: { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                if(error.code == 0){
                self.arrOfJointVisit.remove(at: sender.tag)
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                self.getJointVisitList()
                print(arr)
                }else{
                    print(error.localizedDescription)
                }
            })
            
        }
        let noAction = UIAlertAction.init(title: "NO", style: .default, handler: nil)
        Common.showalertWithAction(msg:"Are you sure you want to delete joint visit?",arrAction:[yesAction,noAction], view: self)
        print(sender.tag)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension JointVisitList:BaseViewControllerDelegate{
    
}
