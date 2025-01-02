//
//  LeaveContainer.swift
//  SuperSales
//
//  Created by Apple on 06/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit

class LeaveContainer: BaseViewController, BaseViewControllerDelegate {
    
    
    @IBOutlet weak var leaveTarget: UIView!
    @IBOutlet weak var leaveToolbar: UIToolbar!
    
    let baseviewcontrollerobj = BaseViewController()
    var carbonTabSwipeNavigation:CarbonTabSwipeNavigation!
    var itemLeaves = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Method
    func setUI(){
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        baseviewcontrollerobj.setleftbtn(btnType: BtnLeft.menu, navigationItem: self.navigationItem)
        self.title = "Leaves"
        baseviewcontrollerobj.setparentview(control: self)
     //   baseviewcontrollerobj.salesPlandelegateObject = self
        if((self.activeuser?.role?.id?.intValue ?? 0 > 6) && self.activeuser?.role?.id?.intValue != 9){
            itemLeaves = ["Self","Team"]
        }else if(self.activeuser?.role?.id == 9){
            itemLeaves = ["Self"]
        }else{
            itemLeaves = ["Team"]
        }
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation.init(items: itemLeaves, toolBar: leaveToolbar, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: self.leaveTarget)
        self.expenseStyle()
    }
    
    func expenseStyle(){
        
        carbonTabSwipeNavigation?.setTabExtraWidth(0)
        self.leaveToolbar.tintColor =  UIColor.Appskybluecolor
        self.leaveToolbar.barTintColor = UIColor.Appthemecolor
       

        //float width = screenSize.size.width/(items.count>3?3:items.count);
        let width = (Common.Screensize.size.width)/CGFloat(itemLeaves.count > 3 ? 3:itemLeaves.count)
      
        for i in 0...itemLeaves.count - 1{
        carbonTabSwipeNavigation?.carbonSegmentedControl?.setWidth(width, forSegmentAt: i)
        }
        
        
    carbonTabSwipeNavigation?.setNormalColor(.white , font: UIFont.systemFont(ofSize: 15));
   
    carbonTabSwipeNavigation?.setSelectedColor(UIColor().colorFromHexCode(rgbValue: 0x2B3894) , font: UIFont.boldSystemFont(ofSize: 15))
    carbonTabSwipeNavigation?.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
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
extension LeaveContainer:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if(itemLeaves.count == 1){
            if(itemLeaves.contains("Self")){
                 if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLeave, classname: Constant.Leaves) as? LeavesViewController{
                    expense.memeberID = self.activeuser?.userID
                return expense
                }else{
                    return UIViewController()
                }
            }else{
                if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLeave, classname: Constant.LeaveList) as? LeaveListViewController{
                  
               return expense
               }else{
                   return UIViewController()
               }
            }
        }else{
            switch index {
            case 0:
                if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLeave, classname: Constant.Leaves) as? LeavesViewController{
                    expense.memeberID = self.activeuser?.userID
               return expense
               }else{
                   return UIViewController()
               }
                
                break
                
            case 1:
                if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLeave
                                                                   , classname: Constant.LeaveList) as? LeaveListViewController{
                 
               return expense
               }else{
                   return UIViewController()
               }
                break
            default:
                 return UIViewController()
            
            }
        }
    }
    
    
}
