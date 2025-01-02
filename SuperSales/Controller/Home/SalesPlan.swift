//
//  SalesPlan.swift
//  SuperSales
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit

 
 
class SalesPlan: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SalesPlan"
        self.salesPlandelegateObject = self
      
        
        //let activeAccount = Utils().getActiveAccount()
       
//      let attendan =  self.getLatestCheckinDetail()
//      print(attendan)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
     //   let titleOfCompanyMenu = arrOfMenuForHome.map{ $0.menuLocalText }
    // swiftlint:disable line_length
    let arrOfMenu:[UPStackMenuItem] = [UPStackMenuItem.init(image: UIImage.init(named: "icon_visit"), highlightedImage: nil,
            title: "New Visit", font: UIFont.systemFont(ofSize: 15)),
        UPStackMenuItem.init(image: UIImage.init(named: "icon_menu_beatroute"),
        highlightedImage: nil,
        title: "New Beat Route",
        font: UIFont.systemFont(ofSize: 15)),
        UPStackMenuItem.init(image: UIImage.init(named: "icon_lead"),
                             highlightedImage: nil,
        title: "New Lead",
        font: UIFont.systemFont(ofSize: 15)),
        UPStackMenuItem.init(image: UIImage.init(named: "icon_order"),
                                                                                                                                                                                                                                                                                                                                                                                                highlightedImage: nil,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        title: "New Order",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                font: UIFont.systemFont(ofSize: 15)),
        UPStackMenuItem.init(image: UIImage.init(named: "icon_cold_call"),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            highlightedImage: nil, title: "New Cold Call",font: UIFont.systemFont(ofSize: 15))]
        self.initbottomMenu(menus: arrOfMenu,control:self)
        
    }
    
    
 }
 extension SalesPlan:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    func datepickerSelectionDone() {
        
    }
    @objc func menuitemTouched(item: UPStackMenuItem,companymenu:CompanyMenus) {
        
        print(companymenu)
        print(item.title)
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        if(item.title.lowercased() == "new visit"){
        var addplanvisit: UIViewController!
        addplanvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: "visitcontainer")
//        let sbVisit =
//            UIStoryboard.init(name: Constant.StoryboardNameVisit , bundle:nil)
            //UIStoryboard.init(name: storybordname, bundle: nil)
        //addplanvisit = sbVisit.instantiateViewController(withIdentifier: "addplanvisit")
            //Common.returnclassviewcontroller(storybordname: "Visit", classname: "addplanvisit")
        self.navigationController!.pushViewController(addplanvisit, animated: true)
        }else if(item.title.lowercased() == "new beat route"){
            
        }else if(item.title.lowercased() == "new lead"){
            if  let newlead = Common.returnclassviewcontroller(storybordname: "Lead", classname: Constant.VisitSelectionView) as? Leadselection
            {
                newlead.selectionFor = SelectionOf.lead
        // self.present(newlead, animated: false, completion: nil)
                self.navigationController!.pushViewController(newlead, animated: true)
            }
            
        }else if(item.title.lowercased() == "new order"){
            
        }else if(item.title.lowercased() == "new cold call"){
            let addcoldvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit , classname: Constant.AddUnplanVisitView)
            self.navigationController!.pushViewController(addcoldvisit, animated: true)
            
        }
    }
    
    
 }

