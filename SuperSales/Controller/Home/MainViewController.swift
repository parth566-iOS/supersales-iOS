//
//  ViewController.swift
//  SuperSales
//
//  Created by Apple on 26/11/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit


//protocol SideMenuDelegate
//{
//    func sideMenuItemSelectedAtIndex(_ index : Int32)
//
//
//}


class MainViewController:  UITabBarController {
    var arrTabbarItem:[UITabBarItem]!
    @IBInspectable var defaultIndex: Int = 0
   
    let baseviewcontrollerobj = BaseViewController()

    
    var companyMenus:[CompanyMenus]!
    var temp:[UPStackMenuItem]!
    var arrOfBottomTabBar:[MenuTabs]!
    static var tabBarOfApp:UITabBar!
 //   @IBOutlet weak var tabBar: UITabBar!
    var titlesOfButtons:[String]!//= ["Visits","Leads","Ordres"]
    var arrOfUnselectedImg:[UIImage]!
    var arrOfselectedImg:[UIImage]!
    var activeroleid:NSNumber!
    //["Visits","Leads","Ordres"]
    
    var menuItems = [Dictionary<String,String>]()
    
    
    override func viewDidLoad() {
    
    super.viewDidLoad()
        self.setUI()
        
    

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController!.isNavigationBarHidden = false
    }
    override  func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
         Location.sharedInsatnce.startLocationManager()
        //let arrOfMenu:[UPStackMenuItem] =
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //self.VC?.removeFromParent()
    }
    func setUI(){
      //  self.title = NSLocalizedString("Dashboard",comment:"")
        print(baseviewcontrollerobj.activeuser?.role?.id ?? 0)
   let arrManinMenu = CompanyMenus.getComapnyMenusForSalesPlan(menu: [NSNumber.init(value: 0),NSNumber.init(value: 1),NSNumber.init(value: 2),NSNumber.init(value: 18),NSNumber.init(value: 14)], sort: true)
        for mainmenu in arrManinMenu {
          
        let menuid = mainmenu.menuID
            print("selected text  = \(mainmenu.menuLocalText) , menu id = \(mainmenu.menuID) , visible = \(mainmenu.isVisible)")
        switch menuid {
        case 18:
            if(!mainmenu.isVisible){
                //report menu
                if let  indexToRemove = self.viewControllers?.firstIndex(where:{$0 is Reports }){
                if indexToRemove < self.viewControllers?.count ?? 0 {
                    print("index = \(indexToRemove) for remove Report")
                    var viewControllers = self.viewControllers
                    viewControllers?.remove(at: indexToRemove)
                    self.viewControllers = viewControllers
                }
                }
            }
            break
            
        case 2:
            if(!mainmenu.isVisible){
                //order menu
                if let  indexToRemove = self.viewControllers?.firstIndex(where:{$0 is OrderContainer }){
                    print("index = \(indexToRemove) for remove Order ")
                if indexToRemove < self.viewControllers?.count ?? 0 {
                    var viewControllers = self.viewControllers
                    viewControllers?.remove(at: indexToRemove)
                    self.viewControllers = viewControllers
                }
                }
            }
            break
            
        case 1:
            if(!mainmenu.isVisible){
                //lead menu
                if let  indexToRemove = self.viewControllers?.firstIndex(where:{$0 is LeadContainer }){//LeadContainer
                    print("index = \(indexToRemove) for remove Lead ")
                if indexToRemove < self.viewControllers?.count ?? 0 {
                    var viewControllers = self.viewControllers
                    viewControllers?.remove(at: indexToRemove)
                    self.viewControllers = viewControllers
                }
                }
            }
            break
            
        case 0:
            if(!mainmenu.isVisible){
                //visit menu
                if let  indexToRemove = self.viewControllers?.firstIndex(where:{$0 is VisitContainer }){
                print("index = \(indexToRemove) for remove visit ")
                if indexToRemove < self.viewControllers?.count ?? 0 {
                    var viewControllers = self.viewControllers
                    viewControllers?.remove(at: indexToRemove)
                    self.viewControllers = viewControllers
               
                }
                }
            }
            break
       
            
      
            
//        case 14:
//            if(!mainmenu.isVisible){
//                //plan menu
//                let indexToRemove = 2
//                if indexToRemove < self.viewControllers?.count ?? 0 {
//                    var viewControllers = self.viewControllers
//                    viewControllers?.remove(at: indexToRemove)
//                    self.viewControllers = viewControllers
//                }
//            }
//            break
            
       
            
        default:
            print("nothing")
        }
        }
        if(self.viewControllers?.count ?? 0 > 0){
        if let salephome = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardSalesPlan) as? SalesPlanHome{
            if let  controllerIndex = self.viewControllers?.firstIndex(where:{$0 is SalesPlanHome }){
                print("selected index = \(controllerIndex) ")
                        self.selectedIndex = controllerIndex
                       
                    }
        }
        }else{
            self.selectedIndex =  0
        }
        activeroleid = baseviewcontrollerobj.activeuser?.role?.id
        
        Common.setTitleOfView(color:UIColor.white, viewController: self)
        baseviewcontrollerobj.salesPlandelegateObject = self
    
        baseviewcontrollerobj.setleftbtn(btnType: BtnLeft.menu,navigationItem: self.navigationItem)
      
        companyMenus = [CompanyMenus]()
        temp = [UPStackMenuItem]()
        companyMenus = baseviewcontrollerobj.createUPStackMenuItems(isFromHome: true , view: self)
        for tempitem in companyMenus{
      
        let upstackmenu = UPStackMenuItem.init(image:  CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16))
        temp.append(upstackmenu ?? UPStackMenuItem())
        }
        arrTabbarItem = [UITabBarItem]()
//        arrOfBottomTabBar = MenuTabs.getTabMenus(menu: [NSNumber.init(value: 0),NSNumber.init(value: 1),NSNumber.init(value: 2)], sort: true)
 arrOfBottomTabBar = MenuTabs.getTabMenus(menu: [0,1,2], sort: true)
titlesOfButtons = arrOfBottomTabBar.map{ $0.menuLocalText }
  
   
//baseviewcontrollerobj.initbottomMenu(menus:temp , control: self)
        baseviewcontrollerobj.setparentview(control: self)
    }
    
   

    
    @objc  func btnReloadTapped(){
    
      
    }
    @objc  func btnNotificationTapped(){
        
    }
    @objc  func btnSyncTapped(){
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first != nil {
            if(baseviewcontrollerobj.children.contains(BaseViewController.menuview)){
                           UIView.animate(withDuration: 0.3, animations:
                               { () -> Void in
                                BaseViewController.menuview.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width/2.5,height: UIScreen.main.bounds.size.height)
                                   self.baseviewcontrollerobj.view.layoutIfNeeded()
                                   self.baseviewcontrollerobj.view.backgroundColor = UIColor.clear
                                   BaseViewController.blurEffectView.removeFromSuperview();
                                   BaseViewController.blurEffectView.removeFromSuperview()
                           },completion:
                               {   (finished) -> Void in
           
                                BaseViewController.menuview.view.removeFromSuperview() //@ need to check
                                BaseViewController.menuview.removeFromParent()
           
                           })
                       }
//        if(baseviewcontrollerobj.children.contains(BaseViewController.menuview)){
//                UIView.animate(withDuration: 0.3, animations:
//                    { () -> Void in
//                        self.baseviewcontrollerobj.menuview.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width/2.5,height: UIScreen.main.bounds.size.height)
//                        self.baseviewcontrollerobj.view.layoutIfNeeded()
//                        self.baseviewcontrollerobj.view.backgroundColor = UIColor.clear
//                        BaseViewController.blurEffectView.removeFromSuperview();
//                        BaseViewController.blurEffectView.removeFromSuperview()
//                },completion:
//                    {   (finished) -> Void in
//
//                        self.baseviewcontrollerobj.menuview.view.removeFromSuperview() //@ need to check
//                        self.baseviewcontrollerobj.menuview.removeFromParent()
//
//                })
//            }
            
            else{
                
            }
        }
    }
    
    // MARK: - UITabbar Method
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//    //    self.title = self.inputViewController?.title
//
//        switch item.tag {
//        case 0:
//        //   tabBar.inputViewController = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: "visit")
//            self.title = self.titlesOfButtons[item.tag]
//            break
//
//        case 1:
//
//            self.title = self.titlesOfButtons[item.tag]
//            break
//        case 2:
//
//            self.title = self.titlesOfButtons[item.tag]
//            break
//
//
//
//
//        default:
//        print("nothing")
//            break
//        }
//    }

}

extension MainViewController:BaseViewControllerDelegate{
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
        }
        else if(companymenu.menuID == 24){
         if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
                 newlead.selectionFor = SelectionOf.lead
            
                self.navigationController!.pushViewController(newlead, animated: true)
        }
        }
            else if(companymenu.menuID == 0){
                if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
                as? Leadselection{
                addplanvisit.selectionFor = SelectionOf.visit
                self.navigationController!.pushViewController(addplanvisit, animated: true)
                }
            }else if(companymenu.menuID == 22){
             if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                 self.navigationController?.pushViewController(attendance, animated: true)
             }
            }          // let s
       // let selectedcompanyid = CompanyMenus.
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
        }else if(companymenu.menuID == 25){
            print("Sales Order")
            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}
extension MainViewController:SideMenuDelegate{
func sideMenuItemSelectedAtIndex(_ index: Int32)
{
    let topViewController : UIViewController = self.navigationController!.topViewController!
    print("Base View Controller is : \(topViewController) \n")
    
    
}
}
