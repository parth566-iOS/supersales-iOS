//
//  StoreCheckContainer.swift
//  SuperSales
//
//  Created by Apple on 18/03/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit
protocol StoreCheckContainerDelegate {
    func updateBrandData()
    func updateCompetitonData()
}

class StoreCheckContainer: BaseViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    //storeCheckVisitCompetitionActivityList
    @IBOutlet weak var targetView: UIView!
     var carbonswipenavigationobj:CarbonTabSwipeNavigation!
    var itemOfStoreCheck:[String] = [String]()
    static var visitType:VisitType!
    static var planVisit:PlannVisit?
    static var unplanVisit:UnplannedVisit?
    var containerDelegate:StoreCheckContainerDelegate?
    static var visitID:NSNumber!
   static  var storeCheckBrandActivityList:[StoreCheckBrandActivity] = [StoreCheckBrandActivity]()
   static var storeCheckVisitBrandActivityList:[StoreCheckVisitBrandActivity] = [StoreCheckVisitBrandActivity]()
    static var storeCheckActivityJustificationList:[StoreActivityJustifiction] = [StoreActivityJustifiction]()
    static var storeActivityConditionList:[StoreActivityCondition] = [StoreActivityCondition]()
   static var storeConditionList:[StoreCondition] = [StoreCondition]()
   static var storeJustificationList:[StoreJustification] = [StoreJustification]()
    static var storeCompetitionJustificationList:[StoreCompetitionJustification] = [StoreCompetitionJustification]()
   static var storeCompetitionList:[StoreCompetition] = [StoreCompetition]()
   static  var storeCheckVisitCompetitionActivityList:[StoreCheckVisitCompetitionActivity] = [StoreCheckVisitCompetitionActivity]()
     static  var visitBrandActivityExists:Bool =  false
     static  var visitCompetitionExists:Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(StoreCheckContainer.visitType == VisitType.coldcallvisit){
            StoreCheckContainer.visitID = NSNumber.init(value:StoreCheckContainer.unplanVisit?.localID ?? 0)
        }else{
            StoreCheckContainer.visitID = NSNumber.init(value:StoreCheckContainer.planVisit?.iD ?? 0)
        }
         
          carbonswipenavigationobj = CarbonTabSwipeNavigation()
        
        if ((activesetting.storeCheckOwnBrand  ==  1) && (activesetting.storeCheckCompetition == 1)) {
                                   // Check Brand is nil or not
                                   // If brand name name is blank then set "Own Brand"
            if(self.activeuser?.company?.brandName ==  nil){
                if(self.activeuser?.company?.brandName?.count ?? 0 > 0){
                    itemOfStoreCheck.append(self.activeuser?.company?.brandName ?? "")
                }else{
                    itemOfStoreCheck.append("Own Brand")
                }
              
            }else{
                if(self.activeuser?.company?.brandName?.count ?? 0 > 0){
                    itemOfStoreCheck.append(self.activeuser?.company?.brandName ?? "")
            }else{
                itemOfStoreCheck.append("Own Brand")
            }
              
            }
              itemOfStoreCheck.append("Competitior")
        }else if(self.activesetting.storeCheckOwnBrand == 1){
            if(self.activeuser?.company?.brandName?.count ?? 0 > 0){
                itemOfStoreCheck.append(self.activeuser?.company?.brandName ?? "")
            }else{
                itemOfStoreCheck.append("Own Brand")
            }
        }
        else if(self.activesetting.storeCheckCompetition == 1){
              itemOfStoreCheck.append("Competitior")
        }
                                  
        else{
                            itemOfStoreCheck = [String]()
                           }
        // Do any additional setup after loading the view.
        carbonswipenavigationobj = CarbonTabSwipeNavigation(items:itemOfStoreCheck, toolBar:self.toolbar, delegate:self)
             
    carbonswipenavigationobj.insert(intoRootViewController: self, andTargetView: self.targetView)
        self.style()
       let (status,message) = self.apihelper.getstorecheckdata()
    
        if(status){
            self.containerDelegate?.updateBrandData()
            self.containerDelegate?.updateCompetitonData()
          if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        }else{
            self.containerDelegate?.updateBrandData()
            self.containerDelegate?.updateCompetitonData()
            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
     
    }
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Method
    func style(){
//          let color:UIColor = Common().UIColorFromRGB(rgbValue: 0xFFDCD62)
          let font = UIFont.init(name: Common.kfontbold, size: 15)
      carbonswipenavigationobj.setIndicatorColor(Common().UIColorFromRGB(rgbValue: 0x009689))
         // carbonswipenavigationobj.setSelectedColor(color, font: font ?? UIFont.systemFont(ofSize: 15))
        carbonswipenavigationobj.setSelectedColor(UIColor().colorFromHexCode(rgbValue: 0x2B3894) , font: UIFont.boldSystemFont(ofSize: 15))
          self.toolbar.barTintColor = UIColor.Appskybluecolor
      
      carbonswipenavigationobj.carbonSegmentedControl?.setWidth((UIScreen.main.bounds.size.width)/2 , forSegmentAt: 0)
        
      //    ca
          var width = 1.0
        //  let targetviewwidth = self.targetView.frame.size.width
        if((itemOfStoreCheck.count) > 3){
              width = Double((self.targetView.frame.size.width/3.0))
          }
          else{
            width=Double(Int(UIScreen.main.bounds.size.width) / ((itemOfStoreCheck.count)))
          }
        for index in itemOfStoreCheck {
            //  print(items?.firstIndex(of: index));
            carbonswipenavigationobj.carbonSegmentedControl?.setWidth(CGFloat(width), forSegmentAt: (itemOfStoreCheck.firstIndex(of: index))!)
          }
          let boldfont = UIFont.init(name: Common.kFontMedium, size: 15)
        
          
          carbonswipenavigationobj.setNormalColor(UIColor.white, font: boldfont ?? UIFont.systemFont(ofSize: 15))
      carbonswipenavigationobj.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
         
      }
}
extension StoreCheckContainer:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
     
      
        
   
        if(index == 0){
       
       
            if let promoListObj =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.StoreCheckBrand) as? StoreCheckBrand{
               

        return promoListObj
            }else{
                return UIViewController()
            }
        }
        else{
            if   let promoListObj =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.StoreCheckCompetition) as? StoreCheckCompetition{
         
            
            return promoListObj
            }else{
                return UIViewController()
            }
        }
        
        
            
//            return INSTANTIATE_With_SB("Visit","promotionlsit")

    //    }
    }
    
    /*
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     _MenuTabs *selectedMenu = (_MenuTabs *)[items objectAtIndex:index];
     switch (selectedMenu.menuID) {
     case 18:
     return [storyboard instantiateViewControllerWithIdentifier:@"planvisit"];
     case 19:
     return [storyboard instantiateViewControllerWithIdentifier:@"unplanvisit"];
     case 20:
     return [storyboard instantiateViewControllerWithIdentifier:@"visitapproval"];
     default:
     return [storyboard instantiateViewControllerWithIdentifier:@"jointvisitlist"];
     }
     */
    
    
}
