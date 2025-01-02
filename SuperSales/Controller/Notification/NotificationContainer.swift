//
//  NotificationContainer.swift
//  SuperSales
//
//  Created by mac on 21/11/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit


class NotificationContainer: BaseViewController {
    @IBOutlet weak var notificationToolbar: UIToolbar!
    
    
    @IBOutlet weak var notificationTargetView: UIView!
    var itemnotifications:Array<String>!
    var carbonswipenavigationobj:CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    

    // MARK: - function
    func setUI(){
        self.salesPlandelegateObject = self
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back
                        , navigationItem: self.navigationItem)
        itemnotifications = [NSLocalizedString("notificationList", comment: ""),NSLocalizedString("notificationApproval", comment: "")]
        carbonswipenavigationobj = CarbonTabSwipeNavigation(items:itemnotifications, toolBar:notificationToolbar , delegate:self)
        self.title = NSLocalizedString("notificationListTitle", comment: "")
       carbonswipenavigationobj.insert(intoRootViewController: self, andTargetView: self.notificationTargetView)

      self.style()
    }
    
    
    func style(){
//        let color:UIColor = Common().UIColorFromRGB(rgbValue: 0xFFDCD62)
//        let font = UIFont.init(name: Common.kfontbold, size: 15)
    carbonswipenavigationobj.setIndicatorColor(Common().UIColorFromRGB(rgbValue: 0x009689))
      //  carbonswipenavigationobj.setSelectedColor(color, font: font ?? UIFont.systemFont(ofSize: 15))
        carbonswipenavigationobj.setNormalColor(UIColor.white, font: UIFont.boldSystemFont(ofSize: 15))
        carbonswipenavigationobj.setSelectedColor(Common().UIColorFromRGB(rgbValue: 0xFFCE4B), font: UIFont.boldSystemFont(ofSize: 15))
        self.notificationToolbar.barTintColor = UIColor.init(red: 0/255.0, green: 144/255.0, blue: 247/255.0, alpha: 1.0)
        
        //UIColor.Appskybluecolor
    
    carbonswipenavigationobj.carbonSegmentedControl?.setWidth((UIScreen.main.bounds.size.width)/2 , forSegmentAt: 0)
      
    //    ca
        var width = 1.0
      //  let targetviewwidth = self.targetView.frame.size.width
        if((itemnotifications?.count)! > 3){
            width = Double((self.notificationTargetView.frame.size.width/3.0))
        }
        
        else{
            width=Double(Int(UIScreen.main.bounds.size.width) / ((itemnotifications?.count)!))
            print("count of header is = \(itemnotifications.count) items \(itemnotifications) width = \(width)")
        }
        for index in itemnotifications! {
          //  print(items?.firstIndex(of: index));
          carbonswipenavigationobj.carbonSegmentedControl?.setWidth(CGFloat(width), forSegmentAt: (itemnotifications?.firstIndex(of: index))!)
        }
        let boldfont = UIFont.init(name: Common.kFontMedium, size: 15)
      
        
       // carbonswipenavigationobj.setNormalColor(UIColor.white, font: boldfont ?? UIFont.systemFont(ofSize: 15))
        carbonswipenavigationobj.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
        notificationToolbar.barTintColor = UIColor.Appskybluecolor//UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
        notificationToolbar.tintColor = UIColor.Appskybluecolor// UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
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
extension NotificationContainer:BaseViewControllerDelegate{
    
}

extension NotificationContainer:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if(itemnotifications.count == 1){
            if(itemnotifications.contains("NOTIFICATIONS")){
                 if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.NotificationList) as? NotificationList{
                   // expense.isMemberExpense = false
                return expense
                }else{
                    return UIViewController()
                }
            }else{
                if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.NotificationApproval) as? NotificationApproval{
                //   expense.isMemberExpense = true
               return expense
               }else{
                   return UIViewController()
               }
            }
        }else{
            switch index {
            case 0:
                if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.NotificationList) as? NotificationList{
                  // expense.isMemberExpense = false
               return expense
               }else{
                   return UIViewController()
               }
                
                break
                
            case 1:
                if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.NotificationApproval) as? NotificationApproval{
                 //  expense.isMemberExpense = true
               return expense
               }else{
                   return UIViewController()
               }
                break
            default:
                 return UIViewController()
            print("rvrwrtrtrt")
            }
        }
    }
    
    
}

