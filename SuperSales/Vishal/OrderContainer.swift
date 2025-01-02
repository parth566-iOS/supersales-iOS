//
//  Orders.swift
//  SuperSales
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit

class OrderContainer: BaseViewController {
    // swiftlint:disable line_length
    var tabBarItems = ["List","Summary"]

    var carbonTabSwipeNavigation:CarbonTabSwipeNavigation?
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var targetView: UIView!

    var companyMenus:[CompanyMenus]!
    var temp:[UPStackMenuItem]!
    var arrLowerLevelUser = [CompanyUsers]()

    //Bottom menu
    let baseviewcontrollerobj = BaseViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parentviewController = self
        self.salesPlandelegateObject = self
        baseviewcontrollerobj.salesPlandelegateObject = self
        self.parentviewController = self
        self.tabBarController?.navigationItem.title = "Orders"

        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: tabBarItems, toolBar: toolbar, delegate: self)
        carbonTabSwipeNavigation?.insert(intoRootViewController: self, andTargetView: targetView)
        self.salesPlandelegateObject = self
        self.setUI()
        // Do any additional setup after loading the view.
    }
        
    func setUI(){
        carbonTabSwipeNavigation?.setTabExtraWidth(0)
        toolbar.tintColor =  UIColor.Appskybluecolor
        toolbar.barTintColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
        
        let width = (Common.Screensize.size.width)/CGFloat(tabBarItems.count > 3 ? 3:tabBarItems.count)
        
        for i in 0...tabBarItems.count - 1{
            carbonTabSwipeNavigation?.carbonSegmentedControl?.setWidth(width, forSegmentAt: i)
        }
        
        if #available(iOS 13.0, *) {
            carbonTabSwipeNavigation?.carbonSegmentedControl?.selectedSegmentTintColor = .clear
        } else {
            // Fallback on earlier versions
        }
        
        carbonTabSwipeNavigation?.setNormalColor(.white, font: UIFont(name: AppFontName.bold, size: 15)!);
        
        carbonTabSwipeNavigation?.setSelectedColor(UIColor().colorFromHexCode(rgbValue: 0x2B3894) , font: UIFont(name: AppFontName.bold, size: 15)!)
        carbonTabSwipeNavigation?.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        
        self.parentviewController = self
        companyMenus = [CompanyMenus]()
        temp = [UPStackMenuItem]()
        companyMenus = self.createUPStackMenuItems(isFromHome: true , view: self)
        for tempitem in companyMenus{
            let upstackmenu = UPStackMenuItem.init(image:  CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16))
            temp.append(upstackmenu ?? UPStackMenuItem())
        }
        companyMenus = baseviewcontrollerobj.createUPStackMenuItems(isFromHome: true, view: self)
        if(temp.count > 0){
        baseviewcontrollerobj.initbottomMenu(menus:temp , control: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setrightbtn(btnType: BtnRight.none,navigationItem: self.tabBarController!.navigationItem)
        //  self.salesPlandelegateObject = self
        self.btnPlus.isHidden = false
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.none,navigationItem: self.navigationItem)
        self.tabBarController?.navigationItem.title = "Orders"
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

extension OrderContainer:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "SOrderList") as! SOrderList
            return vc
        default:
            return UIViewController()
        }
    }
}

extension OrderContainer:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    func datepickerSelectionDone() {
        
    }
    
    @objc func menuitemTouched(item: UPStackMenuItem,companymenu:CompanyMenus) {
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
            if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                newlead.selectionFor = SelectionOf.visit
                
                self.navigationController!.pushViewController(newlead, animated: true)
            }
        }else if(companymenu.menuID == 24){
            if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                newlead.selectionFor = SelectionOf.lead
                
                self.navigationController!.pushViewController(newlead, animated: true)
            }
        }else if(companymenu.menuID == 0){
             if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                newlead.selectionFor = SelectionOf.visit
                
                self.navigationController!.pushViewController(newlead, animated: true)
            }
        }else if(companymenu.menuID == 22){
            if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                self.navigationController?.pushViewController(attendance, animated: true)
            }
        }          // let selectedcompanyid = CompanyMenus.
        else if(item.title.lowercased() == "visit"){
            
             if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                newlead.selectionFor = SelectionOf.visit
                
                self.navigationController!.pushViewController(newlead, animated: true)
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
        }else if(companymenu.menuID == 25){
            print("Sales Order")
            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC, let fvc = carbonTabSwipeNavigation?.viewControllers.allValues.first as? SOrderList {
                vc.delegate = fvc
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}
