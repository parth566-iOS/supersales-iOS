//
//  ViewTerritory.swift
//  SuperSales
//
//  Created by Apple on 27/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewTerritory: BaseViewController {
    var visitType:VisitType!
    var planVisit:PlannVisit?
    var unplanVisit:UnplannedVisit?
    var visitId:NSNumber?
    var arrTerritory:[TerritoryData]! = [TerritoryData]()
    @IBOutlet weak var tblTertiaryListing: UITableView!
    
    
    @IBOutlet var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getTerritoryList()
    }
    
    // MARK: - Method
    func setUI(){
        tblTertiaryListing.delegate = self
        tblTertiaryListing.dataSource = self
        tblTertiaryListing.estimatedRowHeight = 30
        tblTertiaryListing.rowHeight = UITableView.automaticDimension
        
        
        if(visitType == VisitType.planedvisitHistory || visitType  == VisitType.coldcallvisitHistory){
            btnSubmit.isHidden = true
            
            btnSubmit.isUserInteractionEnabled = false
        }else{
            btnSubmit.isHidden = false
            
            
            btnSubmit.isUserInteractionEnabled = true
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func AddTerritory(_ sender: UIButton) {
        if let addTerritory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddTerritory) as? AddTerritory{
            addTerritory.visitType = visitType
            addTerritory.planVisit = planVisit ?? PlannVisit()
            addTerritory.unplanVisit = unplanVisit ??  UnplannedVisit()
    self.navigationController?.pushViewController(addTerritory, animated: true)
        }
    }
    // MARK: - APICall
    func getTerritoryList(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            param["getVisitTertiaryJson"] = Common.returnjsonstring(dic: ["VisitID":unplanVisit?.localID ?? 0])
               }else{
            param["getVisitTertiaryJson"] =  Common.returnjsonstring(dic: ["VisitID":planVisit?.iD ?? 0])
               }
     
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetVisitTertiary, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
               SVProgressHUD.dismiss()
            self.arrTerritory.removeAll()
                     if(status.lowercased() == Constant.SucessResponseFromServer){
                        if(responseType == ResponseType.arr){
                            let arrOfTerritory =  arr as? [[String:Any]] ?? [[String:Any]]()
                            if(arrOfTerritory.count > 0){
                                for territory in arrOfTerritory{
                                    let territ = TerritoryData().initwithdic(dict: territory)
                                    
                                    self.arrTerritory.append(territ)
                                }
                            }
                        }
                        self.tblTertiaryListing.reloadData()
                        if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                     }
                         else if(error.code == 0){
                        self.tblTertiaryListing.reloadData()
                             if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                         }else{
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
extension ViewTerritory:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return  self.arrTerritory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let  cell = tableView.dequeueReusableCell(withIdentifier: "territorydetailcell", for: indexPath) as? TerritoryDetailCell{
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let selectedTerritory = self.arrTerritory[indexPath.row]
            cell.setData(data: selectedTerritory)
            cell.contentView.layoutIfNeeded()
            var strct = ""
            if let strc = Utils.getDateBigFormatToDefaultFormat(date: selectedTerritory.createdTime ?? "2020/12/21 00:00:00", format: "yyyy/MM/dd HH:mm:ss") as? String{
              strct = strc
            }
    cell.lblTerritoryDate.text = Utils.getDatestringWithGMT(gmtDateString: strct, format: "dd-MM-yyyy, hh:mm a")
    self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let sdate = self.dateFormatter.date(from: selectedTerritory.startDate ?? "2020/12/21 00:00:00") ?? Date()
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let atributedstringstartdate = NSMutableAttributedString().stratributed(bold: "Start Date:", normal:self.dateFormatter.string(from: sdate))
            let edate = self.dateFormatter.date(from: selectedTerritory.endDate ?? "2020/12/21 00:00:00") ?? Date()
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            cell.lblStartDate.attributedText = atributedstringstartdate
            let atributedstringenddate = NSMutableAttributedString().stratributed(bold: "End Date:", normal:self.dateFormatter.string(from: edate))
            cell.lblEndDate.attributedText   = atributedstringenddate

        return cell
        }
        else{
            return UITableViewCell()
        }
    }
     func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
            return 40
        }
    
        func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    
}
