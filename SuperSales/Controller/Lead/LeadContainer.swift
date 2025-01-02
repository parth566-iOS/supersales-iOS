//
//  LeadContainer.swift
//  SuperSales
//
//  Created by mac on 04/03/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit


class LeadContainer: BaseViewController {
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var targetView: UIView!
    var carbonTabSwipeNavigation:CarbonTabSwipeNavigation?
    var arrLeadTitle = ["List","Summary"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setrightbtn(btnType: BtnRight.none,navigationItem:self.tabBarController!.navigationItem)
           self.tabBarController?.navigationItem.title = "Lead"
        LeadSummary.totalnumberofRecord = 0
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        carbonTabSwipeNavigation?.setCurrentTabIndex(0, withAnimation: true)
    }
    //MARK: - Method
    func setUI(){
        
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation.init(items: arrLeadTitle as [Any], toolBar: toolbar, delegate: self)
        carbonTabSwipeNavigation?.insert(intoRootViewController: self, andTargetView: targetView)
        carbonTabSwipeNavigation?.setTabExtraWidth(0)
        toolbar.tintColor =  UIColor.Appskybluecolor
        toolbar.barTintColor = UIColor.Appthemecolor
       

        //float width = screenSize.size.width/(items.count>3?3:items.count);
        let width = (Common.Screensize.size.width)/CGFloat(arrLeadTitle.count > 3 ? 3:arrLeadTitle.count)
      
        for i in 0...arrLeadTitle.count - 1{
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
extension LeadContainer:CarbonTabSwipeNavigationDelegate{
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if(index == 0){
            if let planvisit = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadListView) as? LeadListView{
                return planvisit
            }else{
                return UIViewController()
            }
        }else{
            if let leadsummary = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadSummary) as? LeadSummary{
                return leadsummary
            }else{
                return UIViewController()
            }
        }
    }
    
}
