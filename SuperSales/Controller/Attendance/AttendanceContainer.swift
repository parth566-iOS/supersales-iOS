//
//  AttendanceContainer.swift
//  SuperSales
//
//  Created by Apple on 13/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit



class AttendanceContainer: BaseViewController {
    let baseviewcontrollerobj = BaseViewController()
    
    var itemAttendance:[String]!
    
    @IBOutlet var attendanceToolbar: UIToolbar!
    
    
    @IBOutlet var attendancrTargetView: UIView!
    var carbonTabSwipeNavigation:CarbonTabSwipeNavigation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemAttendance = [String]()
        // Do any additional setup after loading the view.
        if((self.activeuser?.role?.id?.intValue ?? 0 > 6) && self.activeuser?.role?.id?.intValue != 9){
            itemAttendance = ["Self","Team"]
        }else if(self.activeuser?.role?.id == 9){
            itemAttendance = ["Self"]
        }else{
            itemAttendance = ["Team"]
        }
        
   carbonTabSwipeNavigation = CarbonTabSwipeNavigation.init(items: itemAttendance, toolBar: attendanceToolbar, delegate: self)
   carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: self.attendancrTargetView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.setUI()
    }
    
    // MARK: - Method
    func setUI(){
        baseviewcontrollerobj.setparentview(control: self)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        baseviewcontrollerobj.setleftbtn(btnType: BtnLeft.menu, navigationItem: self.navigationItem)
        self.title = "Attendance"
        self.attendanceStyle()
    }
    
    func attendanceStyle(){
       
       
      /*  let color:UIColor = Common().UIColorFromRGB(rgbValue: 0xFFDCD62)
               let font = UIFont.init(name: Common.kfontbold, size: 15)
           carbonTabSwipeNavigation.setIndicatorColor(Common().UIColorFromRGB(rgbValue: 0x009689))
               carbonTabSwipeNavigation.setSelectedColor(color, font: font ?? UIFont.systemFont(ofSize: 15))
               self.attendanceToolbar.barTintColor = UIColor.Appskybluecolor
           
           carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth((UIScreen.main.bounds.size.width)/2 , forSegmentAt: 0)
             
           //    ca
        //       var width = 1.0
       // width = Double(Common.Screensize.size.width/2)
        let width = (Common.Screensize.size.width)/CGFloat(itemAttendance.count > 3 ? 3:itemAttendance.count)
      
        for i in 0...itemAttendance.count - 1{
            print("width = \(width)")
        carbonTabSwipeNavigation?.carbonSegmentedControl?.setWidth(width, forSegmentAt: i)
        }
             //  let targetviewwidth = self.targetView.frame.size.width
             /*  if((itemAttendance?.count)! > 3){
                   width = Double((self.attendancrTargetView.frame.size.width/3.0))
               }
               else{
               
                width=Double(Int(UIScreen.main.bounds.size.width) / ((itemAttendance?.count)!))
//                print("Full width = \(Int(UIScreen.main.bounds.size.width))")
                print("count of header is = \(itemAttendance.count) items \(itemAttendance) width = \(width)")
               }*/
//               for index in itemAttendance! {
//                 //  print(items?.firstIndex(of: index));
//                 carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(CGFloat(width), forSegmentAt: (itemAttendance?.firstIndex(of: index))!)
//               }
               let boldfont = UIFont.init(name: Common.kFontMedium, size: 15)
             
      //  self.attendanceToolbar.sizeToFit()
            carbonTabSwipeNavigation.setNormalColor(UIColor.white, font: boldfont ?? UIFont.systemFont(ofSize: 15))
            carbonTabSwipeNavigation.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)*/
        
        
        
       
        
        carbonTabSwipeNavigation?.setTabExtraWidth(0)
        self.attendanceToolbar.tintColor =  UIColor.Appskybluecolor
        self.attendanceToolbar.tintColor = UIColor.Appthemecolor
       
        attendanceToolbar.barTintColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
      //  toolbar.tintColor =  UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
        //float width = screenSize.size.width/(items.count>3?3:items.count);
        let width = (Common.Screensize.size.width)/CGFloat(itemAttendance.count > 3 ? 3:itemAttendance.count)
      
        for i in 0...itemAttendance.count - 1{
        carbonTabSwipeNavigation?.carbonSegmentedControl?.setWidth(width, forSegmentAt: i)
        }
        
        
    carbonTabSwipeNavigation?.setNormalColor(.white , font: UIFont.boldSystemFont(ofSize: 15));
   
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
extension AttendanceContainer:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if(itemAttendance.count == 1){
            if(itemAttendance.contains("MY")){
                 if  let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.Attendance) as? AttendanceViewController{
                return attendance
                }else{
                    return UIViewController()
                }
            }else{
        if let attendancehistory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceHistory) as? AttendanceHistoryViewController{
                     return attendancehistory
                }else{
                    return UIViewController()
                }
            }
        }else{
            switch index {
            case 0:
                if  let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.Attendance) as? AttendanceViewController{
                return attendance
                }else{
                    return UIViewController()
                }
                
                break
                
            case 1:
    if let attendancehistory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceHistory) as? AttendanceHistoryViewController{
                     return attendancehistory
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
