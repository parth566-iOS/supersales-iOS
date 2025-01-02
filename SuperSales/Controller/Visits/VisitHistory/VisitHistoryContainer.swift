//
//  VisitHistoryContainer.swift
//  SuperSales
//
//  Created by Apple on 27/01/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit

class VisitHistoryContainer: BaseViewController {
    
 var carbonTabSwipeNavigation:CarbonTabSwipeNavigation?
    @IBOutlet weak var toolbar: UIToolbar!
     @IBOutlet weak var targetView: UIView!
    var  selectedIndex:UInt!
    var itemsForVisitHistoryTitle = [String()]
    let activeAccount = Utils().getActiveAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("VISIT_HISTORY", comment: "")
        itemsForVisitHistoryTitle = [NSLocalizedString("planned", comment: ""),NSLocalizedString("cold_call", comment: "")]
        
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation.init(items: itemsForVisitHistoryTitle as [String], toolBar: toolbar, delegate: self)
        carbonTabSwipeNavigation?.insert(intoRootViewController: self, andTargetView: targetView)
        self.setUI()
        // Do any additional setup after loading the view.
    }
   
    func setUI(){
        
        self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.home,navigationItem: self.navigationItem)
        carbonTabSwipeNavigation?.setTabExtraWidth(0)
        toolbar.tintColor =  UIColor.Appskybluecolor
        toolbar.barTintColor = UIColor.Appthemecolor
        
        //float width = screenSize.size.width/(items.count>3?3:items.count);
        let width = (Common.Screensize.size.width)/CGFloat(itemsForVisitHistoryTitle.count > 3 ? 3:itemsForVisitHistoryTitle.count)
        
        for i in 0...itemsForVisitHistoryTitle.count - 1{
            carbonTabSwipeNavigation?.carbonSegmentedControl?.setWidth(width, forSegmentAt: i)
        }
        
        
        carbonTabSwipeNavigation?.setNormalColor(.white, font: UIFont.systemFont(ofSize: 15));
        
        carbonTabSwipeNavigation?.setSelectedColor(.yellow, font: UIFont.systemFont(ofSize: 15))
    carbonTabSwipeNavigation?.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        carbonTabSwipeNavigation?.setCurrentTabIndex(self.selectedIndex, withAnimation: true)
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
extension VisitHistoryContainer:CarbonTabSwipeNavigationDelegate{
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
       // let selectedMenu = [Int(index)]
        switch index {
        case 0:
            //plan visit list
            
            return Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: "historyplannedvisitlist")
            
        case 1:
            //Un plan visit list
            
            return Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: "historyunplannedvisitlist")
            
        
            
            
            
        default:
            print("default case")
            //Joint visit list
            return Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: "historyplannedvisitlist")
            
        }
        
        
    }
}

