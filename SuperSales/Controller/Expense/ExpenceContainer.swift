//
//  ExpenceContainer.swift
//  SuperSales
//
//  Created by Apple on 06/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit


class ExpenceContainer: BaseViewController, BaseViewControllerDelegate {
    
    
    @IBOutlet weak var expenseToolbar: UIToolbar!
    @IBOutlet var attendancrTargetView: UIView!
    @IBOutlet weak var btnAddExpense: UIButton!
    
    let baseviewcontrollerobj = BaseViewController()
    var carbonTabSwipeNavigation:CarbonTabSwipeNavigation!
    var itemExpense = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Method
    func setUI(){
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        baseviewcontrollerobj.setleftbtn(btnType: BtnLeft.menu, navigationItem: self.navigationItem)
        self.title = "Expense"
        baseviewcontrollerobj.setparentview(control: self)
      //  baseviewcontrollerobj.salesPlandelegateObject = self
    //    if((self.activeuser?.role?.id?.intValue ?? 0 == 6) && self.activeuser?.role?.id?.intValue != 9){
     //   if(self.activeuser?.role?.id?.intValue ?? 0 == 6 ){
        if(self.activeuser?.role?.id == 5){
            //super admin
            itemExpense = ["Team"]
            btnAddExpense.isHidden = true
        }else if(self.activeuser?.role?.id == 8){
            //executive
            itemExpense = ["Self"]
            btnAddExpense.isHidden = false
        }else{
            itemExpense = ["Self","Team"]
            btnAddExpense.isHidden = false
        }
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation.init(items: itemExpense, toolBar: expenseToolbar, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: self.attendancrTargetView)
        self.expenseStyle()
    }
    
    func expenseStyle(){
       
        carbonTabSwipeNavigation?.setTabExtraWidth(0)
        self.expenseToolbar.tintColor =  UIColor.Appskybluecolor
        self.expenseToolbar.barTintColor = UIColor.Appthemecolor
       

        //float width = screenSize.size.width/(items.count>3?3:items.count);
        let width = (Common.Screensize.size.width)/CGFloat(itemExpense.count > 3 ? 3:itemExpense.count)
      
        for i in 0...itemExpense.count - 1{
        carbonTabSwipeNavigation?.carbonSegmentedControl?.setWidth(width, forSegmentAt: i)
        }
        
        
    carbonTabSwipeNavigation?.setNormalColor(.white , font: UIFont.systemFont(ofSize: 15));
   
    carbonTabSwipeNavigation?.setSelectedColor(UIColor().colorFromHexCode(rgbValue: 0x2B3894) , font: UIFont.boldSystemFont(ofSize: 15))
    carbonTabSwipeNavigation?.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    
    //MARK: - IBAction
    @IBAction func btnAddExpenseClicked(_ sender: UIButton) {
        if let objexcel = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.AddExpense) as? AddExpenseViewController{
            objexcel.iseditExpense = false
            objexcel.fromNotification = false
            self.navigationController?.pushViewController(objexcel, animated: true)
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

}
extension ExpenceContainer:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if(itemExpense.count == 1){
            if(itemExpense.contains("Self")){
                 if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.ExpenseList) as? ExpenseListViewController{
                    expense.isMemberExpense = false
                    btnAddExpense.isHidden = false
                return expense
                }else{
                    return UIViewController()
                }
            }else{
                if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.ExpenseList) as? ExpenseListViewController{
                   expense.isMemberExpense = true
                    btnAddExpense.isHidden = true
               return expense
               }else{
                   return UIViewController()
               }
            }
        }else{
            switch index {
            case 0:
                if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.ExpenseList) as? ExpenseListViewController{
                   expense.isMemberExpense = false
                    btnAddExpense.isHidden = false
               return expense
               }else{
                   return UIViewController()
               }
                
                break
                
            case 1:
                if  let expense = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.ExpenseList) as? ExpenseListViewController{
                   expense.isMemberExpense = true
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
