//
//  Leads.swift
//  SuperSales
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit

class Leads: BaseViewController {
    var companyMenus:[CompanyMenus]!
    var temp:[UPStackMenuItem]!
    var arrLowerLevelUser = [CompanyUsers]()
    let baseviewcontrollerobj = BaseViewController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.salesPlandelegateObject = self
        baseviewcontrollerobj.salesPlandelegateObject = self
         self.title = "Leads"
        if(BaseViewController.staticlowerUser?.count ?? 0 > 0 ){
            arrLowerLevelUser = BaseViewController.staticlowerUser!
            
        }else{
          //  SalesPlanHome().fetchuser()
        }
        // Do any additional setup after loading the view.
    }
  
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        companyMenus = [CompanyMenus]()
        temp = [UPStackMenuItem]()
        companyMenus = self.createUPStackMenuItems(isFromHome: true, view: self)
        for tempitem in companyMenus{
            let upstackmenu = UPStackMenuItem.init(image:  CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16))
           
            temp.append(upstackmenu ?? UPStackMenuItem())
        }
        baseviewcontrollerobj.salesPlandelegateObject = self
        if(temp.count > 0){
        baseviewcontrollerobj.initbottomMenu(menus:temp , control: self)
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
extension Leads:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    func datepickerSelectionDone() {
        
    }
    
    @objc func menuitemTouched(item: UPStackMenuItem,companymenu:CompanyMenus) {
        
        print(companymenu)
        
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        if(item.title.lowercased() == "visit"){
            
            if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
            as? Leadselection{
            addplanvisit.selectionFor = SelectionOf.visit
            self.navigationController!.pushViewController(addplanvisit, animated: true)
            }
        }else if(item.title.lowercased() == "new beat route"){
            
        }else if(item.title.lowercased() == "new lead"){
            if  let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
            newlead.selectionFor = SelectionOf.lead
            //  self.present(newlead, animated: false, completion: nil)
            self.navigationController!.pushViewController(newlead, animated: true)
            }
            
        }else if(companymenu.menuID == 22){
            if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
                self.navigationController?.pushViewController(attendance, animated: true)
            }
        }    else if(companymenu.menuID == 18){
            if let objexcel = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ExcelReport) as? ExcelReport{
                self.navigationController?.pushViewController(objexcel, animated: true)
            }
           }else if(companymenu.menuID == 25){
            print("Sales Order")
            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}
