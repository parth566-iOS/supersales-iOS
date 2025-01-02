//
//  Visits.swift
//  SuperSales
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit

class Visits: BaseViewController {
    
    var companyMenus:[CompanyMenus]!
    var temp:[UPStackMenuItem]!
    var arrLowerLevelUser = [CompanyUsers]()
    
    @IBOutlet weak var vwAttendance: UIView!
    
    @IBOutlet weak var vwDate: UIView!
    @IBOutlet weak var vwTeam: UIView!
    //  @IBOutlet weak var lblAttributed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.navigationItem.title = "Visits"
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
       // self.initbottomMenu(menus: temp, control: self)
    }

    // MARK: Method
    func setUI(){
        
        
        self.salesPlandelegateObject = self
        let styleleft = NSMutableParagraphStyle()
        styleleft.alignment = NSTextAlignment.left
        let styleright = NSMutableParagraphStyle()
        styleright.alignment = NSTextAlignment.right
        
        if(BaseViewController.staticlowerUser?.count ?? 0 > 0 ){
            arrLowerLevelUser = BaseViewController.staticlowerUser!
            
        }else{
            //  SalesPlanHome().fetchuser()
        }
        if(self.activeuser?.role?.id == NSNumber.init(value: 5)){
            vwAttendance.isHidden = true
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
    
    // MARK: -(IBAction)
    
   
}
extension Visits:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    
    func datepickerSelectionDone() {
        
    }
    
    @objc func menuitemTouched(item: UPStackMenuItem,companymenu:CompanyMenus) {
        
        print(companymenu)
        
       
//        let backItem = UIBarButtonItem()
//        backItem.title = " "
//        navigationItem.backBarButtonItem = backItem
        
    if(item.title.lowercased() == "visit"){
          
        if let  addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.VisitSelectionView)
        as? Leadselection{
        addplanvisit.selectionFor = SelectionOf.visit
        self.navigationController!.pushViewController(addplanvisit, animated: true)
        }
        }else if(item.title.lowercased() == "new beat route"){

        }else if(item.title.lowercased() == "lead"){
        if   let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSelectionView) as? Leadselection{
            newlead.selectionFor = SelectionOf.lead
        //self.present(newlead, animated: false, completion: nil)
        self.navigationController!.pushViewController(newlead, animated: true)
        }

        }else if(companymenu.menuID == 25){
            print("Sales Order")
            if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}
