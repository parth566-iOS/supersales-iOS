//
//  MenuViewController.swift
//  SuperSales
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet weak var btnCloseMenuOverlay: UIButton!
    @IBOutlet weak var vwSidePanel: UIView!
    var sidemenudelegate : SideMenuDelegate?
    var arrayMenuOptions = [Dictionary<String,String>]()
    var activeUser:DataUser!
    fileprivate let viewModel = SliderModel()
 
    
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblUserEmail: UILabel!
    
    @IBOutlet weak var tblMenu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.sidemenudelegate = self
        activeUser = Utils().getActiveAccount()
        self.view.backgroundColor = .clear
        self.tblMenu.delegate = viewModel
        self.tblMenu.dataSource = viewModel
        self.tblMenu.estimatedRowHeight = 100
        self.tblMenu.rowHeight = UITableView.automaticDimension
        self.tblMenu.sectionHeaderHeight = 50
        self.tblMenu.separatorStyle = .none
        
        viewModel.reloadSections = { [weak self] (section: Int) in
            self!.tblMenu.beginUpdates()
            self!.tblMenu.reloadSections([section], with: .fade)
            self!.tblMenu.reloadData()
           // self!.tblMenu.reloadSections([section], with: .fade)
            self!.tblMenu.endUpdates()
        }
        
        self.tblMenu.reloadData()
        self.setData()
        self.setUI()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidLayoutSubviews() {
           self.view .bringSubviewToFront(imgUser)
           imgUser.layer.cornerRadius = imgUser.frame.size.width/2
           imgUser.layer.masksToBounds = true
       }
    func setUI(){
        imgUser.backgroundColor = UIColor.clear
        lblUserEmail.setMultilineLabel(lbl: lblUserEmail)
       // imgUser.layer.borderColor = UIColor.white.cgColor
       // imgUser.layer.borderWidth = 0.0
        if(self.activeUser.picture?.count ?? 0  > 0){
            //self.activeUser.picture ?? ""
            imgUser.sd_setImage(with: URL.init(string: self.activeUser.picture ?? ""), placeholderImage: UIImage.init(named: "icon_placeholder_user"), options: SDWebImageOptions.init()) { (img, err, SDImageCacheType, url) in
                print("image downloaded")
                }
            }else{
                    
        self.imgUser.image = UIImage.init(named: "icon_placeholder_user")
                }

        let tapView = UITapGestureRecognizer.init(target: self, action: #selector(upperviewtapped))
        self.upperView.isUserInteractionEnabled = true
        self.upperView.addGestureRecognizer(tapView)
    }
    func setData(){
        if let activeuser = activeUser{
            if(activeuser.userID?.intValue ?? 0 > 0){
            self.lblUserName.text = String.init(format: "%@ %@", arguments:[activeUser.firstName ?? "" ,activeUser.lastName ?? ""])
            self.lblUserEmail.text = activeUser.emailID
        }
        }
    }
    
    @objc func upperviewtapped(){
        self.removeSliderView(UIButton())
        let userprofile = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameMain, classname: Constant.UserProfile)
        self.navigationController?.pushViewController(userprofile, animated: true)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func removeSliderView(_ button:UIButton!){
        BaseViewController.blurEffectView?.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations:
            { () -> Void in
                self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)

            self.view.layoutIfNeeded()
                self.view.backgroundColor = UIColor.clear
        },completion:
            {   (finished) -> Void in
             self.view.removeFromSuperview() //@ need to check
             self.parent?.navigationController?.view.backgroundColor = .clear
                self.parent?.navigationController?.view.alpha = 1.0
                self.removeFromParent()
      })
    }
}
extension MenuViewController:SliderClickDelegate{
    
    func setViewAsPerSelection(selectedMenu:CompanyMenus){
    self.removeSliderView(UIButton())
        print("navigation = \(self.navigationController) ")
        if let navigation  = self.navigationController as? UINavigationController{
    if(selectedMenu.menuID == 0){
    //open visit list
    let visitList = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: "visitcontainer")
    visitList.title = selectedMenu.menuLocalText;
        navigation.pushViewController(visitList, animated: true)
   
    }else if(selectedMenu.menuID == 1){
        if let newlead = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.LeadContainer) as? LeadContainer {//LeadContainer
       // newlead.selectionFor = SelectionOf.lead
            navigation.pushViewController(newlead, animated: true)
        }
    }else if(selectedMenu.menuID == 16){
        if let customervendor = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomer, classname: Constant.CustomerContainer) as? CustomerContainer{
            navigation.pushViewController(customervendor, animated: true)
        }
    }else if(selectedMenu.menuID == 14){
    if let salesplan = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameSalesPaln, classname: Constant.DashboardSalesPlan) as? SalesPlanHome{
        salesplan.isOnHome = false
        salesplan.isHome = false
        SalesPlanHome.screenselection =  Dashboardscreen.salesplan
        navigation.pushViewController(salesplan, animated: true)
        }
        }else if(selectedMenu.menuID == 22 || selectedMenu.menuID == 4){
         if let attendance = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameAttendance, classname: Constant.AttendanceContainer) as? AttendanceContainer{
            navigation.pushViewController(attendance, animated: true)
         }
        }else if(selectedMenu.menuID  == 18){
            if let objexcel = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameReport, classname: Constant.ExcelReport) as? ExcelReport{
                navigation.pushViewController(objexcel, animated: true)
            }
           }
        else if(selectedMenu.menuID  == 5){
            //leave module
            if let objexcel = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLeave, classname: Constant.LeaveContainer) as? LeaveContainer{
                navigation.pushViewController(objexcel, animated: true)
            }
           }
        else if(selectedMenu.menuID  == 6){
            //expense module
            if let objexcel = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameExpense, classname: Constant.ExpenseContainer) as? ExpenceContainer{
                navigation.pushViewController(objexcel, animated: true)
            }
           }else if(selectedMenu.menuID == 7){
            //Activity List
            if let activityList = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameActivity, classname: Constant.ActivityList) as? ActivityList{
                
                navigation.pushViewController(activityList, animated: true)
            }
        }else if(selectedMenu.menuID == 8){
            //Knowledge center
            if let activityList = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameKnowledgeCenter, classname: Constant.KnowledgeCenter) as? KnowledgeCenter{
                
                navigation.pushViewController(activityList, animated: true)
            }
        }else if(selectedMenu.menuID == 10){
            print("Sales Order")
            if let a = (self.navigationController?.viewControllers.first as? MainViewController)?.selectedViewController as? OrderContainer {
                if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC, let fvc = a.carbonTabSwipeNavigation?.viewControllers.allValues.first as? SOrderList {
                    vc.delegate = fvc
                    self.navigationController!.pushViewController(vc, animated: true)
                }
            }else if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }else if(selectedMenu.menuID == 169){
            print("home")
            AppDelegate.shared.rootViewController.switchToMainScreen()
        }
        }else{
            if(selectedMenu.menuID == 169){
                print("home")
                AppDelegate.shared.rootViewController.switchToMainScreen()
            }else{
                Utils.toastmsg(message:"Not get navigation",view: self.view)
            }
        }
    }
}
