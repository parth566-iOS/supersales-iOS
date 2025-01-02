//
//  RootViewController.swift
//  RootControllerNavigation
//
//  Created by Stanislav Ostrovskiy on 12/5/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    static let shared = MainNavigationController()
}

class RootViewController: UIViewController {

    private var current: UIViewController!
     var activeAccount:DataUser!
    var loginObject:Login!
    var navigation:UINavigationController!
//    var deeplink: DeeplinkType? {
//        didSet {
//            handleDeeplink()
//        }
 //   }
    
    
    init() {
        current = SplashViewController()
        super.init(nibName:  nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.red
//        let lbl = UILabel.init()
//        lbl.center = view.center
//        lbl.text = "Root view"
//        lbl.textColor = UIColor.white
//        self.view.addSubview(lbl)
        self.view.isUserInteractionEnabled = true
       
      
       
        addChild(current)
        current.view.frame = view.bounds
     //   lbl.removeFromSuperview()
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func showLoginScreen() {
//        let new = MainNavigationController.shared(rootvi)
        if let   loginObject = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.LoginView) as? Login {
//            self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//            self.navigationController.navigationBar.hidden = YES;
//            [self.window setRootViewController:self.navigationController];
//            [self.window makeKeyAndVisible];
            
       let new = UINavigationController(rootViewController: loginObject)
      //  let new = MainNavigationController.shared(rootViewController: loginObject)
      
        addChild(new)
        new.view.frame = view.bounds
        new.view.isUserInteractionEnabled = true
        view.addSubview(new.view)
        new.didMove(toParent: self)
        
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        
        current = new
//      AppDelegate.shared.window?.rootViewController = new
//            AppDelegate.shared.window?.makeKeyAndVisible()
      
      
        }
//        AppDelegate.shared.window?.rootViewController = new
//        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func switchToLogout() {
        
        
//        if let topviewcontroller = UIApplication.shared.keyWindow?.rootViewController as? UIViewController{
//            if let menuview  =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: "menuviewcontroller") as? MenuViewController{
//                print("sub views  = \(menuview.view.subviews)")
//            if(topviewcontroller.view.subviews.contains(menuview.view)){
//                menuview.view.removeFromSuperview()
//                menuview.removeFromParent()
//            }
//            }
//            for view in topviewcontroller.children{
//                print(view)
//
//               // view.removeFromParent()
//            }
        
        
        loginObject = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.LoginView) as? Login ?? Login()
        let logoutScreen = UINavigationController(rootViewController: loginObject)
        animateDismissTransition(to: logoutScreen)

    }
    
    func switchToMainScreen() {
        var mainViewController = MainNavigationController.shared
       
        activeAccount =   Utils().getActiveAccount()
        print("Role id = \(activeAccount.role?.id ?? NSNumber.init(value: 0)) at root view")
        /*  if((activeAccount.roleId == 5)||(activeAccount.roleId == 6)||(activeAccount.roleId == 7) ){
         //set lead,visit,order combination screen
         }else if((activeAccount.roleId == 9)){
         //set daily repot
         }else{
         //set sales plan
         }*/
       
        if((activeAccount.role?.id == NSNumber.init(value: 5)||(activeAccount.role?.id == NSNumber.init(value: 6))||(activeAccount.role?.id == NSNumber.init(value: 7)))){
            //set lead,visit,order combination screen
        if    let dashboardobject =
            Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.DashboardSalesLeadVisitView) as? MainViewController{
              mainViewController =
                MainNavigationController(rootViewController: dashboardobject)
            }
            
            //        AppDelegate.shared.navigationController.pushViewController(dashboardobject!, animated: true)
            //AppDelegate.shared.navigationController!.setViewControllers([dashboardobject!], animated: true)
            //Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitListView)
            
        }
        else if(activeAccount.role?.id == NSNumber.init(value: 9)){
            //set daily report
            
            if let dashboardobject =
                Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.DashboardSalesLeadVisitView) as? MainViewController{
            mainViewController =
                MainNavigationController(rootViewController: dashboardobject)
            }
//            let dashboardobjectSalesPlan = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardSalesPlan) as! SalesPlanHome
//            dashboardobjectSalesPlan.isOnHome = true
//            mainViewController = MainNavigationController(rootViewController: dashboardobjectSalesPlan)

        }
        else{
            //set sales plan
            
       if  let dashboardobject =
        Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.DashboardSalesLeadVisitView) as? MainViewController{
        mainViewController =
                MainNavigationController(rootViewController: dashboardobject)
            }

            
        }
       
        animateFadeTransition(to: mainViewController) { [weak self] in
           // self?.handleDeeplink()
        }
//        AppDelegate.shared.window?.rootViewController = mainViewController
//        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        
        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)
        new.view.frame = initialFrame
        
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
//    private func handleDeeplink() {
//        if let mainNavigationController = current as? MainNavigationController, let deeplink = deeplink {
//            switch deeplink {
//            case .activity:
//                mainNavigationController.popToRootViewController(animated: false)
//                (mainNavigationController.topViewController as? MainViewController)?.showActivityScreen()
//            default:
//                // handle any other types of Deeplinks here
//                break
//            }
//
//            // reset the deeplink back no nil, so it will not be triggered more than once
//            self.deeplink = nil
//        }
 //   }
}
