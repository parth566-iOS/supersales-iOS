//
//  Orders.swift
//  SuperSales
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit

class Orders: BaseViewController {
    // swiftlint:disable line_length
    var companyMenus:[CompanyMenus]!
    var temp:[UPStackMenuItem]!
    var arrLowerLevelUser = [CompanyUsers]()
    let baseviewcontrollerobj = BaseViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Orders"
       
        
        
        if(BaseViewController.staticlowerUser?.count ?? 0 > 0 ){
            arrLowerLevelUser = BaseViewController.staticlowerUser!
            
        }else{
           // SalesPlanHome().fetchuser()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(true)
    self.setrightbtn(btnType: BtnRight.none,navigationItem: self.tabBarController!.navigationItem)
    self.tabBarController?.navigationItem.title = "Orders"
          }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.salesPlandelegateObject = self
        self.setUI()
    }
    
    //MARK: - Method
    func setUI(){
        self.parentviewController = self
        companyMenus = [CompanyMenus]()
               temp = [UPStackMenuItem]()
               companyMenus = self.createUPStackMenuItems(isFromHome: true , view: self)
               for tempitem in companyMenus{
                   let upstackmenu = UPStackMenuItem.init(image:  CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16))
                   temp.append(upstackmenu ?? UPStackMenuItem())
               }
        if(temp.count > 0){
        baseviewcontrollerobj.initbottomMenu(menus:temp , control: self)
        }
    }
    /*
    // MARK:
     Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: IBAction
    
    
}
extension Orders:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    func datepickerSelectionDone() {
        
    }
    @objc func menuitemTouched(item: UPStackMenuItem,companymenu:CompanyMenus) {
        
        print(companymenu)
        print(companymenu.menuID)
        print(companymenu)
        
           if(companymenu.menuID == 32){
               //add manualvisit
               if  let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
            Common.skipVisitSelection = false
               
               addjointvisit.visitType = VisitType.manualvisit
               
               self.navigationController!.pushViewController(addjointvisit, animated: true)
               }
               
               
           }else if(companymenu.menuID == 29){
               if let addunplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddUnplanVisitView) as? AddUnPlanVisit{
              
               self.navigationController!.pushViewController(addunplanvisit, animated: true)
               }
           }else if(companymenu.menuID == 31){
               //corporate meeting
           }else if(companymenu.menuID == 33){
               //beat plan
               let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView
               self.navigationController!.pushViewController(beatplancontainer!, animated: true)
           }else if(companymenu.menuID == 28){
               if let addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddplanVisitView) as? AddPlanVisit{
               //    self.dismiss(animated: false) {
               self.navigationController!.pushViewController(addplanvisit, animated: true)
               }
               //plan a visit
           }else if(companymenu.menuID == 26){
            //Add Activity
            if let addActivity = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.AddActivity) as? AddActivity{
                    
                    self.navigationController?.pushViewController(addActivity, animated: true)
            }
           }else if(companymenu.menuID == 504){
               //kpi data
           }else if(companymenu.menuID == 30){
               //Direct Visit Check-IN
               if let addjointvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddjointVisitView)  as? AddJoinVisitViewController{
            Common.skipVisitSelection = false
               
               addjointvisit.visitType = VisitType.directvisitcheckin
              
               self.navigationController!.pushViewController(addjointvisit, animated: true)
               }
           }else if(companymenu.menuID == 23){
            if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
            as? Leadselection{
            addplanvisit.selectionFor = SelectionOf.visit
            self.navigationController!.pushViewController(addplanvisit, animated: true)
            }
           }else if(companymenu.menuID == 24){
            if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                    newlead.selectionFor = SelectionOf.lead
               
                   self.navigationController!.pushViewController(newlead, animated: true)
           }
           }else if(companymenu.menuID == 0){
            if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
            as? Leadselection{
            addplanvisit.selectionFor = SelectionOf.visit
            self.navigationController!.pushViewController(addplanvisit, animated: true)
            }
           }else if(companymenu.menuID == 22){
            if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                self.navigationController?.pushViewController(attendance, animated: true)
            }
           }          // let selectedcompanyid = CompanyMenus.
           else if(companymenu.menuID == 18){
            if let objexcel = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ExcelReport) as? ExcelReport{
                self.navigationController?.pushViewController(objexcel, animated: true)
            }
           }
           else if(item.title.lowercased() == "visit"){
               
            if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
            as? Leadselection{
            addplanvisit.selectionFor = SelectionOf.visit
            self.navigationController!.pushViewController(addplanvisit, animated: true)
            }
           }else if(item.title.lowercased() == "new beat route"){
               
           }else if(item.title.lowercased() == "lead"){
               if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
               newlead.selectionFor = SelectionOf.lead
          
              self.navigationController!.pushViewController(newlead, animated: true)
               }
           }else if(item.title.lowercased() == "beat plan"){
               if let beatplancontainer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameBeatPlan, classname: Constant.BeatPlanConatinerview) as? BeatPlanContainerView{
               self.navigationController!.pushViewController(beatplancontainer, animated: true)
               }
           }
    }
    
    
}
