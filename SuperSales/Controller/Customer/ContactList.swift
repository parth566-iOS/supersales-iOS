//
//  ContactList.swift
//  SuperSales
//
//  Created by Apple on 23/09/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
class ContactList: BaseViewController {

    @IBOutlet var tfContact: UITextField!
    @IBOutlet var tblContactList: UITableView!
    var arrContact:[Contact]!
    var selectedCustomerID:NSNumber?
    var isVendor:Bool!
    override func viewDidLoad() {
        DispatchQueue.main.async {
        super.viewDidLoad()
            self.setUI()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
        super.viewDidAppear(true)
        self.getContactData()
        }
    }
    
    // MARK: - Method
    func getContactData(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        arrContact = [Contact]()
        if let selectedcustId = selectedCustomerID as? NSNumber{
            arrContact = Contact.getContactsUsingCustomerID(customerId: selectedcustId)
        }else{
       
        arrContact =  Contact.getAll()
        }
        tblContactList.reloadData()
        SVProgressHUD.dismiss()
        self.tblContactList.pullToRefreshView.stopAnimating()
    }
    
    func setUI(){
        self.title = "Contact"
        self.tblContactList.addPullToRefresh { [self] in
            self.getContactData()
            
        }
        tfContact.setCommonFeature()
        self.getContactData()
        tblContactList.separatorColor = UIColor.clear
        tblContactList.tableFooterView = UIView()
        tblContactList.delegate = self
        tblContactList.dataSource = self
        tfContact.delegate  = self
        self.setrightbtn(btnType: BtnRight.homeedit, navigationItem: self.navigationItem)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
    self.salesPlandelegateObject = self
      
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

extension ContactList:BaseViewControllerDelegate{
    
    func editiconTapped(sender:UIBarButtonItem) {
            let ftcellconfig = FTCellConfiguration.init()
            ftcellconfig.textColor = UIColor.black
            let ftconfig = FTConfiguration.shared
    
            ftconfig.backgoundTintColor =  UIColor.white
        var arrOfTitle = ["Add Conatct"]
      
        
        
        FTPopOverMenu.showForSender(sender: sender.plainView
                                        , with: arrOfTitle , popOverPosition: FTPopOverPosition.automatic, config: popoverConfiguration, done: { (i) in
        print(i)
        switch i{
        case 0:
            //Add Contact
            if  let addContact = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddContactView) as? AddContact{
                addContact.isEditContact = false
                Common.skipVisitSelection = false
//                addContact.selectedCust =  LeadCustomerDetail.selectedCustomer
            
                if  let customer = CustomerDetails.getCustomerByID(cid: self.selectedCustomerID ?? NSNumber.init(value: 0)){
                addContact.selectedCust = customer
                }
                addContact.isVendor = false
                addContact.selectedContact = Contact()
//                addContact.addcontactdel = self
        self.navigationController?.pushViewController(addContact, animated: true)
            }
            break
       
        default:
            print("nothing")
        }
            }, cancel: {
                 print("cancel tapped")
            })
        }
        
}
extension ContactList:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("arr of contact count = \(arrContact.count)")
        return arrContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "customervendorcell", for: indexPath) as? CustomerVendorCell{
           if let contact = arrContact[indexPath.row] as? Contact{
            var contactname = ""
            if let firstname = contact.firstName as? String{
                contactname.append(firstname)
            }
            if let lastname = contact.lastName as? String{
                if(contactname.count > 0){
                    contactname.append(" ")
                }
                contactname.append(lastname)
            }
            cell.lblName.text = contactname
               if let custOfContact = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:contact.customerID)) as? CustomerDetails{
                   var strcustName = NSMutableAttributedString.init(string:"Customer: ",  attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])//NSAttributedString.init(AttributedString.init(string:"Customer",attri))
                   strcustName.append(NSAttributedString.init(string:custOfContact.name,  attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]))
                 //  strcustName.appending(custOfContact.name)
                   cell.lblCustName.attributedText = strcustName
                
               }
            
            
               cell.lblContactNo.textColor = UIColor.Appskybluecolor
               cell.lblContactNo.text =  contact.mobile
               cell.lblEmail.textAlignment = .right
               cell.lblEmail.text = contact.emailID
            if let emailid = contact.emailID as? String{
            if(contact.emailID.count > 0){
                cell.vwEmail.isHidden = false
            }else{
               cell.vwEmail.isHidden = true
            }
            }else{
                cell.vwEmail.isHidden = true
            }
           }
           return cell
       }else{
           return UITableViewCell()
       }
    }
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let addcontact =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddContactView) as? AddContact{
            addcontact.isVendor = false
        if let contact = arrContact[indexPath.row] as?  Contact{
            addcontact.selectedContact =  contact
        
            if let custOfcontact = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:contact.customerID)) as? CustomerDetails{
                addcontact.selectedCust = custOfcontact
            }
        }
            addcontact.isEditContact = true
            self.navigationController?.pushViewController(addcontact, animated: true)
        }
    }
    
}
extension ContactList:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
           // arrOfFilteredLowerLeverUser = BaseViewController.staticlowerUser
            let trimmedstring = textField.text?.trimmingCharacters(in: .whitespaces).lowercased()
            print(trimmedstring ?? "")
        if (textField == tfContact){
            //arrContact = Contact.getAll()
            self.getContactData()
            arrContact =
                arrContact.compactMap { (temp) -> Contact in
                    return temp
                    }.filter { (aUser) -> Bool in
                        
                        return ((aUser.firstName?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true) || (aUser.lastName?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true) || (aUser.mobile.contains(trimmedstring ?? "") == true))
            }

//            arrContact.compactMap { (temp) -> Contact in
//                    return temp
//                    }.filter { (aUser) -> Bool in
//                    
//return ((aUser.firstName?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true) || (aUser.mobile.contains(trimmedstring ?? "") == true))
//            }

//            arrContact.compactMap { (temp) -> Contact in
//                    return temp
//                    }.filter { (aUser) -> Bool in
//                 
//return ((aUser.cus?.localizedCaseInsensitiveContains(trimmedstring ?? "") == true))
//            }
            tblContactList.reloadData()
//            customerDropdown.dataSource = filteredCustomer as [String]
//            customerDropdown.reloadAllComponents()
//
//            customerDropdown.show()
          
        }
        return true
}
}
