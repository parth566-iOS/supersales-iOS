//
//  CustomerHistoryContainer.swift
//  SuperSales
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import CarbonKit
import SVProgressHUD
import FastEasyMapping

class CustomerHistoryContainer: BaseViewController {
    var carbonswipenavigationobj:CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    @IBOutlet var customerHistorytoolBar: UIToolbar!
    @IBOutlet var targetView: UIView!
    var isEdit:Bool!
    var customerID:NSNumber!
    var customerName:String!
    var customerhistoryitem:[String]!
    var startDate:String! = ""
    var endDate:String! = ""
      var redirectTo:Int! = 0
    var popup:CustomerPopup? = nil
    static var customerhistory:[String:Any]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.salesPlandelegateObject = self
        popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.ChangeCustomerPopup) as? CustomerPopup
        popup?.modalPresentationStyle = .overCurrentContext
        popup?.isEdit = isEdit
        popup?.customerId = customerID
        popup?.delegate = self
        popup?.parentViewOfPopup = self.view
        Utils.addShadow(view: self.view)
        self.present(popup!, animated: true, completion: nil)
                
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      
    }
    
    func setUI(){
        redirectTo = 0
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.setrightbtn(btnType: BtnRight.homeedit, navigationItem: self.navigationItem)
        if let customerName1 =  customerName as? String{
        if(customerName1 .count > 0){
            self.title = customerName1 
        }else{
            self.title = "Customer History"
        }
        }else{
            self.title = "Customer History"
        }
        customerhistoryitem =  ["Summary","Visit", "Lead", "Sales Order"]//, "Proposal", "Invoice"
        carbonswipenavigationobj = CarbonTabSwipeNavigation(items:customerhistoryitem, toolBar:customerHistorytoolBar , delegate:self)
              carbonswipenavigationobj.insert(intoRootViewController: self, andTargetView: targetView)
              self.style()
          carbonswipenavigationobj.setCurrentTabIndex(UInt(redirectTo), withAnimation: true)
        
    }

    
    
    
    // MARK: - Method
     func style(){
            
             let color:UIColor = UIColor.Appthemecolor
            
             let boldfont = UIFont.init(name: Common.kfontbold, size: 15)
         carbonswipenavigationobj.setIndicatorColor(UIColor.Appthemecolor)
             
             carbonswipenavigationobj.setSelectedColor(color, font: boldfont ?? UIFont.boldSystemFont(ofSize: 15))
             customerHistorytoolBar.barTintColor = UIColor.white
             // carbonswipenavigationobj.setTabExtraWidth(-10)
         carbonswipenavigationobj.carbonSegmentedControl?.setWidth((UIScreen.main.bounds.size.width)/2 , forSegmentAt: 0)
             
             //    ca
            
             
     //        for index in itemsvisitDetail! {
     //carbonswipenavigationobj.carbonSegmentedControl?.setWidth(CGFloat(200.0), forSegmentAt: (itemsvisitDetail?.firstIndex(of: index))!)
     //        }
            
                 //UIFont.init(name: kFontMedium, size: 15)
             
             
             carbonswipenavigationobj.setNormalColor(UIColor.gray, font: boldfont ?? UIFont.boldSystemFont(ofSize: 15))
         carbonswipenavigationobj.carbonTabSwipeScrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
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
extension CustomerHistoryContainer:CustomerPopUpDelegate{
    
    func customerHistoryWithResponse(name:String,dicdata:[String:Any]){
        CustomerHistoryContainer.customerhistory = dicdata
        self.title = name
        // Reports.carbonTabSwipeNavigation.viewControllers[NSNumber.init(value:selectedin)] as? DRMovement{
        var customerhistorysummary = [CustomerHistoryResult]()
        
       let arrsummary = CustomerHistoryContainer.customerhistory["Summary"] as? [[String : Any]] ?? [[String:Any]]()
        let dicOfSummary = arrsummary[0]
        /*
         var monthTotalDoneVsit:Int = 0
         var monthTotalReportVsit:Int = 0
         var monthTotalCount:Int = 0
         var monthTotalValue:Int = 0
         var monthTotalLeadWon:Int = 0
         var monthTotalLeadLost:Int = 0
         var montTotalLeadGenerated:Int = 0
         var monthTotalLeadUpdated:Int = 0
         **/
        var monthTotalDoneVisit = 0
        var monthTotalReportVsit = 0
        var monthTotalCount = 0
        var monthTotalValue = 0
        var monthTotalLeadWon = 0
        var monthTotalLeadLost = 0
        var monthTotalLeadGenerated = 0
        var monthTotalLeadUpdated = 0
      //  let arrOfResult = dicOfSummary["resultList"] as? [[String:Any]] ?? [[String:Any]]()
       
       
        
        
        for dic in arrsummary{
            if var dicOfsummary =  dic as? [String:Any]{
            var   arrOfResult = dicOfSummary["resultList"] as? [[String:Any]] ?? [[String:Any]]()
                if(arrOfResult.count > 0){
                for i in 0...arrOfResult.count - 1{
                    var dicresult = arrOfResult[i] as? [String:Any] ?? [String:Any]()
                    monthTotalDoneVisit += dicresult["monthDoneVisit"] as? Int ?? 0
                   
                    monthTotalReportVsit += dicresult["monthVisitReport"] as? Int ?? 0
                    monthTotalCount += dicresult["monthOrderCount"] as? Int ?? 0
                    monthTotalValue += dicresult["monthOrderValue"] as? Int ?? 0
                    monthTotalLeadWon += dicresult["monthLeadWon"] as? Int ?? 0
                    monthTotalLeadLost += dicresult["monthLeadLost"] as? Int ?? 0
                    monthTotalLeadGenerated += dicresult["montLeadGenerated"] as? Int ?? 0
                    monthTotalLeadUpdated += dicresult["monthLeadUpdated"] as? Int ?? 0
                    dicresult["monthTotalDoneVsit"] = monthTotalDoneVisit
                  
                    dicresult["monthTotalReportVsit"] = monthTotalReportVsit
                    dicresult["monthTotalCount"] = monthTotalCount
                    dicresult["monthTotalValue"] = monthTotalValue
                    dicresult["monthTotalLeadWon"] = monthTotalLeadWon
                    dicresult["monthTotalLeadLost"] = monthTotalLeadLost
                    dicresult["monthTotalLeadGenerated"] = monthTotalLeadGenerated
                    dicresult["monthTotalLeadUpdated"] = monthTotalLeadUpdated
                    arrOfResult.remove(at: i)
                    arrOfResult.insert(dicresult, at: i)
                }
                }
                dicOfsummary["resultList"] = arrOfResult
                let model =  CustomerHistoryResult.init(dictionary: dicOfsummary as NSDictionary)
                customerhistorysummary.append(model)
            }
            
        }
        CustomerSummary.arrCustomerHistorySummary = customerhistorysummary.first
//        CustomerSummary.noOfRecord = 
        CustomerHistoryVisit.arrVisits = CustomerHistoryContainer.customerhistory["Visit"] as? [[String : Any]] ?? [[String:Any]]()
        CustomerHistoryLead.arrLeads = CustomerHistoryContainer.customerhistory["Lead"] as? [[String : Any]] ?? [[String:Any]]()
        
        if let summaryhistory =  carbonswipenavigationobj.viewControllers[0] as? CustomerSummary{
            summaryhistory.startDate = startDate
            summaryhistory.endDate = endDate
            summaryhistory.tblCustomerHistorySummary?.reloadData()
        }
        if let visithistory =  carbonswipenavigationobj.viewControllers[1] as? CustomerHistoryVisit{
           
            visithistory.tblView?.reloadData()
        }
        if let leadhistory =  carbonswipenavigationobj.viewControllers[2] as? CustomerHistoryLead{

            leadhistory.tblLead?.reloadData()
        }
//        if let visithistory =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistoryvisit) as? CustomerHistoryVisit{
//
//            CustomerHistoryVisit.arrVisits = CustomerHistoryContainer.customerhistory["Visit"] as? [[String : Any]] ?? [[String:Any]]()
//            visithistory.tblView?.reloadData()
//        }
//
    }
    func getstartDate(std:String,edt etd:String){
        startDate = std
        endDate = etd
    }
}
extension CustomerHistoryContainer:CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
      //  let selectedmenu = CompanyMenus()
     
       let  selectedindex = Int(index)
        if(selectedindex == 0){
            if let customersummary =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistorysummary) as? CustomerSummary{
                customersummary.tblCustomerHistorySummary?.reloadData()
                customersummary.startDate = startDate
                customersummary.endDate = endDate
                
                return customersummary
            }else{
                return UIViewController()
            }
        }
        else if(selectedindex == 1){
//                  let selectedMenu = itemForReport[selectedin]
            if let visithistory =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistoryvisit) as? CustomerHistoryVisit{
           
            visithistory.tblView?.reloadData()
            return visithistory
        }else{
            return UIViewController()
        }
        }
        else if(selectedindex == 2){
            if let visithistory =   Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistorylead) as? CustomerHistoryLead{
            visithistory.tblLead?.reloadData()
            return visithistory
        }else{
            return UIViewController()
        }
        }else{
            if let orderhistory = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameCustomerHistory, classname: Constant.Customerhistorysales) as? CustomerHistorySales{
                let mapping = SOrder.defaultMapping()// your mapping here
                let store = FEMManagedObjectStore(context: SOrder.getContext())
                store.saveContextOnCommit = false;
                let deserializer = FEMDeserializer(store: store)
                orderhistory.arrSalesOrders.removeAll()
                if let a = CustomerHistoryContainer.customerhistory, let objects = deserializer.collection(fromRepresentation: a["SalesOrder"] as? [[String : Any]] ?? [[String:Any]](), mapping: mapping) as? [SOrder] {
                    orderhistory.arrSalesOrders.append(contentsOf: objects)
                }
                orderhistory.tblView?.reloadData()
                return orderhistory
            }else{
                return UIViewController()
            }
        }
    }
    }
extension CustomerHistoryContainer:BaseViewControllerDelegate{
    func editiconTapped(sender:UIBarButtonItem){
      popup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.ChangeCustomerPopup) as? CustomerPopup
         popup?.modalPresentationStyle = .overCurrentContext
            popup?.isEdit = true
         popup?.customerId = customerID
         popup?.delegate = self
            popup?.parentViewOfPopup = self.view
            Utils.addShadow(view: self.view)
        self.present(popup!, animated: true, completion: nil)
                            
    }
}
