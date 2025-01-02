//
//  CustomerContainer.swift
//  SuperSales
//
//  Created by Apple on 23/09/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit

class CustomerContainer: BaseViewController {
    let baseviewcontrollerobj = BaseViewController()
    @IBOutlet var customerToolbar: UIToolbar!
    @IBOutlet var customerTargetView: UIView!
    
    var companyMenus:[CompanyMenus]!
    var tempCustomer:[UPStackMenuItem]!
    var itemCustomer:[UIImage]!
    var carbonTabSwipeNavigation:CarbonTabSwipeNavigation!
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
        super.viewDidLoad()
          
            self.setUI()
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Method
    func setUI(){
        baseviewcontrollerobj.setparentview(control: self)
        self.setrightbtn(btnType: BtnRight.home, navigationItem: self.navigationItem)
        baseviewcontrollerobj.setleftbtn(btnType: BtnLeft.menu, navigationItem: self.navigationItem)
        self.title = "Customer"
        self.salesPlandelegateObject = self
        self.itemCustomer = [UIImage]()
       // self.itemCustomer = ["Customer","Contact"]
        tempCustomer = [UPStackMenuItem]()
        
       
        let itemCustomer = UPStackMenuItem.init(image: UIImage.init(named: "icon_menu_customer"), highlightedImage: nil, title: "Customer", font: UIFont.systemFont(ofSize: 16))
        let itemContact = UPStackMenuItem.init(image: UIImage.init(named: "icon_menu_customer"), highlightedImage: nil, title: "Contact", font: UIFont.systemFont(ofSize: 18))
        let itemVendor = UPStackMenuItem.init(image: UIImage.init(named: "icon_menu_customer"), highlightedImage: nil, title: "Vendor", font: UIFont.systemFont(ofSize: 18))
    
//        let upstackmenu = UPStackMenuItem.init(image: CompanyMenus.getImageFromMenu(menuID: Int(tempitem.menuID)), highlightedImage: nil, title: tempitem.menuLocalText, font: UIFont.boldSystemFont(ofSize: 16))
//        upstackmenu?.isUserInteractionEnabled = true
//        temp.append(upstackmenu ?? UPStackMenuItem())
        if(self.activeuser?.role?.id?.intValue ?? 0 < 8){
            self.itemCustomer = [UIImage.init(named: "people_customers_white.png")!,UIImage.init(named: "people_contacts_white")!,UIImage.init(named: "people_vendors_white")!]
            self.tempCustomer = [itemVendor!,itemContact!,itemCustomer!]
        }else{
            self.itemCustomer = [UIImage.init(named: "people_customers_white.png")!,UIImage.init(named: "people_contacts_white")!]
            self.tempCustomer = [itemContact!,itemCustomer!]
        }
        // carbonTabSwipeNavigation =[[CarbonTabSwipeNavigation alloc] initWithItems:items toolBar:self.toolBar delegate:self];
         self.carbonTabSwipeNavigation = CarbonTabSwipeNavigation.init(items: self.itemCustomer, toolBar: self.customerToolbar, delegate: self)
         self.carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: self.customerTargetView)
        companyMenus = self.createUPStackMenuItems(isFromHome: true , view: self)
        if(tempCustomer.count > 0){
       
       self.initbottomMenu(menus: tempCustomer, control: self)
        }
        customerStyle()
        self.parentviewController = self
        /*
         UPStackMenuItem *item1 = [[UPStackMenuItem alloc] initWithImage:image(@"chooser-moment-button") highlightedImage:nil title:@"Vendor" font:kFont(kFontMedium, 16)];
         UPStackMenuItem *item2 = [[UPStackMenuItem alloc] initWithImage:image(@"chooser-moment-button") highlightedImage:nil title:@"Contact" font:kFont(kFontMedium, 16)];
         UPStackMenuItem *item3 = [[UPStackMenuItem alloc] initWithImage:image(@"chooser-moment-button") highlightedImage:nil title:@"Customer" font:kFont(kFontMedium, 16)];

         NSMutableArray *itemss;
         if (account.role_id < 8)
             itemss = [[NSMutableArray alloc] initWithObjects:item1, item2, item3, nil];
         else
             itemss = [[NSMutableArray alloc] initWithObjects:item2, item3, nil];
         
         **/
    }
    
    
    func customerStyle(){
        carbonTabSwipeNavigation?.setTabExtraWidth(0)
        self.customerToolbar.tintColor =  UIColor.Appskybluecolor
        self.customerToolbar.barTintColor =  Utils.hexStringToUIColor(hex: "#00BDD6")
       

        //float width = screenSize.size.width/(items.count>3?3:items.count);
        let width = (Common.Screensize.size.width)/CGFloat(itemCustomer.count > 3 ? 3:itemCustomer.count)
      
        for i in 0...itemCustomer.count - 1{
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
extension CustomerContainer:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    func datepickerSelectionDone() {
        
    }
    
    @objc func menuitemTouched(item: UPStackMenuItem,companymenu:CompanyMenus) {
        print(companymenu)
       
        print(companymenu.menuValue ?? " ")
        print(item.title ?? " ")
        if(item.title == "Customer"){
            if  let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                addCustomer.isVendor = false
                AddCustomer.isFromInfluencer = 0
                addCustomer.isForAddAddress = false
                addCustomer.isFromColdCallVisit = false
                addCustomer.isEditCustomer = false
                addCustomer.saveCustDelegate = self
            self.navigationController?.pushViewController(addCustomer, animated: true)
            }
        }else if(item.title == "Contact"){
            if  let addContact = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddContactView) as? AddContact{
                addContact.isEditContact = false
                Common.skipVisitSelection = false
//                addContact.selectedCust =  LeadCustomerDetail.selectedCustomer
            
//                if  let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planVisit?.customerID ?? 0)){
//                addContact.selectedCust = customer
//                }
                addContact.isVendor = false
                addContact.selectedContact = Contact()
                addContact.addcontactdel = self
        self.navigationController?.pushViewController(addContact, animated: true)
            }
        }else{
            if  let addCustomer = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddCustomerView) as? AddCustomer{
                addCustomer.isVendor = true
                AddCustomer.isFromInfluencer = 0
                addCustomer.isForAddAddress = false
                addCustomer.isFromColdCallVisit = false
                addCustomer.isEditCustomer = false
                addCustomer.saveCustDelegate = self
            self.navigationController?.pushViewController(addCustomer, animated: true)
            }
        }
    }
    
}
extension CustomerContainer:AddCustomerDelegate{
    func saveCustomer(customerID: NSNumber, customerName: String, contactID: NSNumber) {
        print(customerName)
    }
    
    
    
    
}
extension CustomerContainer:AddContactDelegate{
    func saveContact(customerID: NSNumber, customerName: String, contactName: String, contactID: NSNumber) {
        print(contactName)
    }
}
extension CustomerContainer:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
       
            switch index {
            case 0:
                if  let customerlist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomer, classname: Constant.CustomerList) as? CustomerList{
                return customerlist
                }else{
                    return UIViewController()
                }
                
                break
                
            case 1:
                if let contactlist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomer, classname: Constant.ContactList) as? ContactList{
                     return contactlist
                }else{
                    return UIViewController()
                }
                break
                
            case 2:
                if let vendorlist = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomer, classname: Constant.VendorList) as? VendorList{
                     return vendorlist
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

