//
//  VisitContainer.swift
//  SuperSales
//
//  Created by Apple on 16/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit

class VisitContainer: BaseViewController  {
    
    
    let baseviewcontrollerobj = BaseViewController()
    var carbonTabSwipeNavigation:CarbonTabSwipeNavigation?
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var targetView: UIView!
    var rightBarItems = [MenuTabs]()
    let activeAccount = Utils().getActiveAccount()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title =  NSLocalizedString("visit", comment: "Title of Visit List")
        if(activeAccount?.role?.id == 7){
//            rightBarItems = MenuTabs.getTabMenus(menu:[NSNumber.init(value:18),NSNumber.init(value:19),NSNumber.init(value:20),NSNumber.init(value:21)],sort:true)
rightBarItems = MenuTabs.getTabMenus(menu:[18,19,20,21],sort:true)
        }else{
//            rightBarItems = MenuTabs.getTabMenus(menu:[NSNumber.init(value:18),NSNumber.init(value:19),NSNumber.init(value:20)],sort:true)
rightBarItems = //MenuTabs.getTabMenus(menu:[18,19,20],sort:true)
            MenuTabs.getTabMenus(menu:[18,19,20],sort:true)
        }
       
      
        let arrVisitTitle = rightBarItems.map{ $0.menuLocalText }
            //rightBarItems["menuLocalText"] as? [String]
        if(arrVisitTitle.count > 0){
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation.init(items: arrVisitTitle as [Any], toolBar: toolbar, delegate: self)
        carbonTabSwipeNavigation?.insert(intoRootViewController: self, andTargetView: targetView)
            self.setUI()
        }else{
            Utils.toastmsg(message:"Menus not available",view:self.view)
        }
         

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
          self.setrightbtn(btnType: BtnRight.none,navigationItem: self.tabBarController!.navigationItem)
      //  self.salesPlandelegateObject = self
        self.btnPlus.isHidden = true
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.none,navigationItem: self.navigationItem)
if(self.view.subviews.contains(super.btnPlus)){
        self.btnPlus.backgroundColor =  UIColor.red
        super.btnPlus.isHidden = true
}
        self.hideBtnPlus()
     //   baseviewcontrollerobj.salesPlandelegateObject = self
        baseviewcontrollerobj.hideBtnPlus()
        self.tabBarController?.navigationItem.title = "Visits"
     
    }
    
    
    func setUI(){
        
      
        self.parentviewController = self
        
        carbonTabSwipeNavigation?.setTabExtraWidth(0)
        toolbar.tintColor =  UIColor.Appskybluecolor
        toolbar.barTintColor = UIColor.Appthemecolor
       

        //float width = screenSize.size.width/(items.count>3?3:items.count);
        let width = (Common.Screensize.size.width)/CGFloat(rightBarItems.count > 3 ? 3:rightBarItems.count)
      
        for i in 0...rightBarItems.count - 1{
        carbonTabSwipeNavigation?.carbonSegmentedControl?.setWidth(width, forSegmentAt: i)
        }
        
        
    carbonTabSwipeNavigation?.setNormalColor(.white, font: UIFont.boldSystemFont(ofSize: 15));
   
    carbonTabSwipeNavigation?.setSelectedColor(UIColor().colorFromHexCode(rgbValue: 0x2B3894) , font: UIFont.boldSystemFont(ofSize: 15))
    carbonTabSwipeNavigation?.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        toolbar.barTintColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
        toolbar.tintColor =  UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
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
extension VisitContainer:CarbonTabSwipeNavigationDelegate{
    
func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
    if(rightBarItems.count > 0){
    let selectedMenu = rightBarItems[Int(index)]
    print(selectedMenu.menuID)
    switch selectedMenu.menuID {
    case 18:
    //plan visit list
        if let planvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: "plannedvisitlist") as? PlannedVisitList{
    return planvisit
        }else{
            return UIViewController()
        }
        
    case 19:
    //Un plan visit list
     let unplanvisit =
        Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: "unplannedvisitlist")
        return unplanvisit
     
        
    case 20:
    // Approval visit list
   return Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: "visitapprovallist")
   
    
        
    default:
    print("default case")
    //Joint visit list
    return Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: "jointvisitlist")
        
    }
    }else{
        return UIViewController()
    }
    
}
}

extension VisitContainer:BaseViewControllerDelegate{
    
}
