//
//  AddLead.swift
//  SuperSales
//
//  Created by Apple on 25/12/19.
//  Copyright © 2019 Bigbang. All rights reserved.
//

import UIKit
import SVProgressHUD
import FastEasyMapping
import MagicalRecord

class AddLead: BaseViewController {
    public static var isEditLead:Bool!
    var leadtype:LeadType!
    public static var LeadDic:[String:Any]! = [String:Any]()
    public static var objLead:Lead!
    var initalleaddic:[String:Any] = [String:Any]()
    var editLeaddic:[String:Any] = [String:Any]()
    var currenleadstage = Leadstage.leadstage1
    @IBOutlet weak var btnLead1Step: UIButton!
    
    @IBOutlet weak var btnLead2Step: UIButton!
    
    @IBOutlet weak var btnLead3Step: UIButton!
    
    @IBOutlet weak var btnLead4Step: UIButton!
    
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet var vwTarget: UIView!
    
    @IBOutlet weak var scrlTarget: UIScrollView!
    
    var editLeadDic = [String:Any]()
    let noOFCustomer = Utils.getDefaultIntValue(key: Constant.kNoOfCustomer)
    let noOfTotalCustomer = Utils.getDefaultIntValue(key:  Constant.kTotalCustomer)
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async{
            self.currenleadstage = Leadstage.leadstage1
            self.reflactAction()
        }
        self.setUI()
        //set Lead Stage 1
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
            Common.skipVisitSelection = true
       
//        currenleadstage = Leadstage.leadstage1
//        self.reflactAction()
    }
    func setUI(){
        //for top bar back button
      
        self.btnPrevious.setbtnFor(title: "Previous", type: Constant.kPositive)
        if(AddLead.isEditLead == true){
        self.title = "Edit Lead"
            
            editLeadDic["ID"] = NSNumber.init(value:AddLead.objLead.iD)
            editLeadDic["SeriesPostfix"] = NSNumber.init(value:AddLead.objLead.seriesPostfix)
            editLeadDic["SeriesPrefix"] = AddLead.objLead.seriesPrefix
            editLeadDic["LeadTypeID"] = AddLead.objLead.leadTypeID
            LeadAddProduct.arrOfProduct = [SelectedProduct]()
            LeadAddProduct.arrOfProductDic = [[String:Any]]()
            if(LeadAddProduct.arrOfEditProduct.count == 0){
            for product in AddLead.objLead.productList{
        if let addedproduct = product as? ProductsList{
            
            
        var dic = [String:Any]()
        var subcatid = 0
        var budget = 0
    if  let subcat = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value:addedproduct.categoryID)){
        subcatid = Int(subcat.iD)
        }
            if let pbudget = addedproduct.budget{
                budget = Int(pbudget)
        }
            var strProductName = ""
            if let productname = addedproduct.productName as? String{
                if(productname.count > 0){
                let productName = productname
             strProductName.append(productName)
                }else{
                   
            if let subcatid = addedproduct.subcategoryID as? Int64 {
            if(subcatid > 0){
            let prosubcat = ProductSubCat.getSubCatName(subcatid: NSNumber.init(value:subcatid))
                        if(prosubcat.count > 0){
                            strProductName.append(("SubCat: \(prosubcat) \n"))
                        }
                        }
                     }else{
                if let catid = addedproduct.categoryID as? Int64 {
                            let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:catid))
                            if(procatname.count > 0){
                                strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                            }
                        }
                    }
                }
            }else{
             
                      if let catid = addedproduct.categoryID as? Int64 {
                            let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:addedproduct.categoryID))
                            if(procatname.count > 0){
                                strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                            }
                        }
                   
                }
//
            dic = ["productName":strProductName,"ProductID":addedproduct.productID,"CategoryID":addedproduct.categoryID,"SubCategoryID":subcatid,"Quantity":String.init(format:"\(addedproduct.quantity)") ,"Budget": String.init(format:"\(budget)")] as [String : Any]
            let product = SelectedProduct().initwithdic(dict: dic)
            LeadAddProduct.arrOfProduct.append(product)
            LeadAddProduct.arrOfEditProduct.append(product)
                }
            }
            }else{
                for product in AddLead.objLead.productList{
            if let addedproduct = product as? ProductsList{
                
                
            var dic = [String:Any]()
            var subcatid = 0
            var budget = 0
                if(addedproduct.subcategoryID > 0){
                    subcatid = Int(addedproduct.subcategoryID)
                }else
        if  let subcat = ProductSubCat.getSubCatProduct(subcatid: NSNumber.init(value:addedproduct.categoryID)){
            subcatid = Int(subcat.iD)
            }
                if let pbudget = addedproduct.budget{
                    budget = pbudget.intValue
            }
                var strProductName = ""
                if let productname = addedproduct.productName as? String{
                    if(productname.count > 0){
                    let productName = productname
                 strProductName.append(productName)
                    }else{
                       
                if let subcatid = addedproduct.subcategoryID as? Int64 {
                if(subcatid > 0){
                let prosubcat = ProductSubCat.getSubCatName(subcatid: NSNumber.init(value:subcatid))
                            if(prosubcat.count > 0){
                                strProductName.append(("SubCat: \(prosubcat) \n"))
                            }
                            }
                         }else{
                    if let catid = addedproduct.categoryID as? Int64 {
                                let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:catid))
                                if(procatname.count > 0){
                                    strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                                }
                            }
                        }
                    }
                }else{
                 
                          if let catid = addedproduct.categoryID as? Int64 {
                                let procatname = ProdCategory.getCategoryName(catId: NSNumber.init(value:addedproduct.categoryID))
                                if(procatname.count > 0){
                                    strProductName.append(String.init(format:"Cat: \(procatname) \n"))
                                }
                            }
                       
                    }
    //
                dic = ["productName":strProductName,"ProductID":addedproduct.productID,"CategoryID":addedproduct.categoryID,"SubCategoryID":subcatid,"Quantity":String.init(format:"\(addedproduct.quantity)") ,"Budget": String.init(format:"\(budget)")] as [String : Any]//String.init(format:"\(budget)")
    let product = SelectedProduct().initwithdic(dict: dic)
            
    LeadAddProduct.arrOfProduct.append(product)
   
                    }
                }
            }
            for prod in LeadAddProduct.arrOfProduct{
                var dic = [String:Any]()
    if(self.activesetting.leadProductPermission == 2){
        dic["Budget"] = String.init(format:"%@",prod.price ?? 0)
    }else{
        dic["Budget"] = String.init(format:"%@",prod.budget ?? 0)
        }
              //dic["Budget"] = prod.budget
                dic["CategoryID"] = prod.productCatId
                dic["ProductID"] = prod.productID
                dic["Quantity"] = prod.quantity
                dic["SubCategoryID"] = prod.productSubCatId
//                print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
                LeadAddProduct.arrOfProductDic.append(dic)
                    }
           // print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
            LeadSourceInfluencer.leadSourceIndex = AddLead.objLead.leadSourceID
            AddLeadFourthStep.nextActionID = NSNumber.init(value:AddLead.objLead.nextActionID)
            AddLeadFourthStep.leadNegotiationDone = NSNumber.init(value: AddLead.objLead.isNegotiationDone)
            AddLeadFourthStep.leadProposalGiven = NSNumber.init(value: AddLead.objLead.askedForProposal)
            AddLeadFourthStep.leadDemoDone = NSNumber.init(value: AddLead.objLead.isTrialDone)
            AddLeadFourthStep.leadQualified = NSNumber.init(value: AddLead.objLead.isLeadQualified)
            AddLeadFourthStep.isLead5Stage = NSNumber.init(value: AddLead.objLead.leadstage5)
            AddLeadFourthStep.isLead6Stage = NSNumber.init(value: AddLead.objLead.leadstage6)
            AddLeadFourthStep.nextActionDate = Utils.getDateBigFormatToCurrent(date: AddLead.objLead.nextActionTime, format:"yyyy/MM/dd HH:mm:ss")
           // AddLeadFourthStep.nextActionTime = Utils.getDateBigFormatToCurrent(date: AddLead.objLead.nextActionTime, format:"yyyy/MM/dd HH:mm:ss")
            AddLeadFourthStep.originalAssignee = NSNumber.init(value:AddLead.objLead.originalAssignee)
            AddLeadFourthStep.nextActionDate = Utils.getDateBigFormatToCurrent(date: Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: AddLead.objLead.nextActionTime, format: "yyyy/MM/dd HH:mm:ss") ?? "2020/10/02 10:10:10", format: "dd-MM-yyyy, hh:mm a"), format:"yyyy/MM/dd HH:mm:ss")
            AddLeadFourthStep.positivity =  NSNumber.init(value:AddLead.objLead.customerOrientationID)
            
            AddLeadFourthStep.response = AddLead.objLead.response
            AddLeadFourthStep.remarks =  AddLead.objLead.remarks
            if(AddLead.objLead.reminder > 0){
                AddLeadFourthStep.isReminderSelected = true
            }else{
                AddLeadFourthStep.isReminderSelected = false
            }
//                if isEditData = AddLead.LeadDic["addleadjson"] as? [String:Any]{
//                self.editLeaddic = isEditData
//               }
            self.editLeaddic["Remarks"] = AddLead.objLead.remarks
            self.editLeaddic["IsNegotiationDone"] = AddLeadFourthStep.leadNegotiationDone
            self.editLeaddic["AskedForProposal"] = AddLeadFourthStep.leadProposalGiven
            self.editLeaddic["IsTrialDone"] = AddLeadFourthStep.leadDemoDone
            self.editLeaddic["ProposalSubmitted"] = AddLeadFourthStep.leadProposalGiven
            self.editLeaddic["IsLeadQualified"] = AddLeadFourthStep.leadQualified
            self.editLeaddic["LeadSourceID"] = LeadSourceInfluencer.leadSourceIndex
            self.editLeaddic["LeadStage5"] = AddLeadFourthStep.isLead5Stage
            self.editLeaddic["LeadStage6"] = AddLeadFourthStep.isLead6Stage
           // self.editLeaddic["Remarks"] =
             
            self.editLeaddic["LeadSourceID"] = LeadSourceInfluencer.leadSourceIndex
      
            AddLead.LeadDic["addleadjson"] = editLeadDic
        }else{
        self.title = "Add Lead"
       
            self.initialiseLeadData()
        }
    
    self.setleftbtn(btnType: BtnLeft.back,navigationItem: self.navigationItem)
        
//set round button
self.btnNext.layer.cornerRadius = 10
self.btnPrevious.layer.cornerRadius = 10
self.btnLead1Step.layer.cornerRadius = 28
self.btnLead2Step.layer.cornerRadius = 28
self.btnLead3Step.layer.cornerRadius = 28
self.btnLead4Step.layer.cornerRadius = 28
if(AddLead.isEditLead == false){
    AddLead.objLead = Lead()
    var initalleaddic = [String:Any]()
    initalleaddic["CustomerID"] = 0
    initalleaddic["ContactID"] = NSNumber.init(value:0)
    initalleaddic["NextActionID"] = NSNumber.init(value:1)
    initalleaddic["CustomerOrientationID"] = NSNumber.init(value:1)
    initalleaddic["Reminder"] = NSNumber.init(value:0)
    initalleaddic["CompanyID"] = self.activeuser?.company?.iD
    initalleaddic["Response"] = AddLeadFourthStep.response
            if(self.leadtype == LeadType.hot){
        initalleaddic["LeadTypeID"] = NSNumber.init(value:1)
            }else if(self.leadtype == LeadType.warm){
        initalleaddic["LeadTypeID"] = NSNumber.init(value:2)
            }else{
                initalleaddic["LeadTypeID"] = NSNumber.init(value:3)
            }

    AddLead.LeadDic["addleadjson"] = initalleaddic
        }else{
    editLeadDic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
    editLeadDic["CustomerID"] = AddLead.objLead.customerID
    editLeadDic["ContactID"] = AddLead.objLead.contactID
    editLeadDic["CustomerOrientationID"] = AddLead.objLead.customerOrientationID
    editLeadDic["Reminder"] = AddLead.objLead.reminder
    editLeadDic["CompanyID"] = self.activeuser?.company?.iD
    AddLead.LeadDic["addleadjson"] = editLeadDic
    //Set Data
    //let selectedCustomer = CustomerDetails
        }
       
    }
    
    func initialiseLeadData(){
        LeadCustomerDetail.selectedCustomer = nil
        LeadCustomerDetail.contactID = NSNumber.init(value: 0)
        LeadAddProduct.arrOfProduct = [SelectedProduct]()
        LeadAddProduct.arrOfProductDic = [[String:Any]]()
        LeadSourceInfluencer.selectedsource = nil
        LeadSourceInfluencer.selectedFirstInfluencer =  nil
        LeadSourceInfluencer.selectedSecondInfluencer = nil
        
        AddLeadFourthStep.response = ""
        AddLeadFourthStep.positivity = NSNumber.init(value: 0)
        AddLeadFourthStep.remarks = ""
        AddLeadFourthStep.nextActionDate = nil
        AddLeadFourthStep.orderExpectedDate = nil
        AddLeadFourthStep.reminderDate = nil
        
        AddLeadFourthStep.nextActionID  = NSNumber.init(value: 1)
        AddLeadFourthStep.leadNegotiationDone = NSNumber.init(value: 0)
        AddLeadFourthStep.leadProposalGiven = NSNumber.init(value: 0)
        AddLeadFourthStep.isLead6Stage = NSNumber.init(value: 0)
        AddLeadFourthStep.isLead5Stage = NSNumber.init(value: 0)
        AddLeadFourthStep.leadDemoDone = NSNumber.init(value: 0)
        AddLeadFourthStep.leadQualified = NSNumber.init(value: 0)
        AddPictureLeadStatus.arrOfImageWithStatus = [UIImage]()
        
        AddLead.LeadDic["addleadjson"] = [String:Any]()
    }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
//MARK: - (Method)
func checkValidation(){
    var message = ""
    self.initalleaddic =  AddLead.LeadDic["addleadjson"] as! [String : Any]
    if let cust  = LeadCustomerDetail.selectedCustomer as? CustomerDetails {
        if(LeadCustomerDetail.selectedCustomer.iD == 0){
            initalleaddic["CustomerID"] = LeadCustomerDetail.selectedTempCustomer.iD
        }else{
        initalleaddic["CustomerID"] = LeadCustomerDetail.selectedCustomer.iD
        }
        initalleaddic["AddressMasterID"] = LeadCustomerDetail.addressMasterID
        self.initalleaddic["ContactID"] = LeadCustomerDetail.contactID

        self.initalleaddic["SeriesPrefix"] = ""
        self.initalleaddic["OriginalAssignee"] = AddLeadFourthStep.originalAssignee
        self.initalleaddic["CreatedBy"] = self.activeuser?.userID
        initalleaddic["LeadSourceID"] = LeadSourceInfluencer.leadSourceIndex
        self.initalleaddic["IsNegotiationDone"] = AddLeadFourthStep.leadNegotiationDone
        initalleaddic["AskedForProposal"] = AddLeadFourthStep.leadProposalGiven
        initalleaddic["ProposalSubmitted"] = AddLeadFourthStep.leadProposalGiven
        initalleaddic["IsTrialDone"] = AddLeadFourthStep.leadDemoDone
        initalleaddic["IsLeadQualified"] = AddLeadFourthStep.leadQualified
        initalleaddic["LeadStage5"] = AddLeadFourthStep.isLead5Stage
        initalleaddic["LeadStage6"] = AddLeadFourthStep.isLead6Stage
        initalleaddic["NextActionTime"] =  Utils.getDateUTCWithAppendingDay(day: 0, date: AddLeadFourthStep.nextActionDate, format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)//Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate , format: "yyyy/MM/dd HH:mm:ss")//Utils.getDate(date: AddLeadFourthStep.nextActionTime, withFormat: "yyyy/MM/dd HH:mm:ss")//

        initalleaddic["OrderExpectedDate"] =  Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.orderExpectedDate , format: "yyyy/MM/dd HH:mm:ss")
        if(AddLeadFourthStep.strReminderDate.count > 0){
        if let reminderDate = AddLeadFourthStep.reminderDate as? Date{
        initalleaddic["ReminderTime"] = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate , format: "yyyy/MM/dd HH:mm:ss")
        }else{
            initalleaddic["ReminderTime"] =  nil
        }
        }else{

        }
        initalleaddic["NextActionID"] = AddLeadFourthStep.nextActionID
        if(AddLeadFourthStep.isReminderSelected){
            initalleaddic["Reminder"] = NSNumber.init(value: 1)
        }else{
        initalleaddic["Reminder"] =  NSNumber.init(value: 0)
        }
        initalleaddic["Response"] = AddLeadFourthStep.response
        initalleaddic["CustomerOrientationID"] = AddLeadFourthStep.positivity
        initalleaddic["Remarks"] = AddLeadFourthStep.remarks

        AddLead.LeadDic["addleadjson"] = initalleaddic
        let dicLead = AddLead.LeadDic["addleadjson"] as? [String:Any]
                //AddLead.objLead.productList
        if(dicLead?["CustomerID"] as? Int == 0){
        message = "Please select the Customer"
        currenleadstage = Leadstage.leadstage1
    }else  if(LeadAddProduct.arrOfProduct.count == 0){
       if(self.activesetting.productMandatoryInLead == 1){
        message = "Please select the Product"
        }else{
        message = "Please select the Product  Category/Product SubCategory"
        }
                 currenleadstage = Leadstage.leadstage3
    }else if(AddLeadFourthStep.isReminderSelected){
        if(AddLeadFourthStep.strReminderDate.count  == 0 ){
            message = "Please select Reminder Date"
        }else if(AddLeadFourthStep.strReminerTime.count  == 0){
            message = "Please select Reminder Time"
        }
        currenleadstage = Leadstage.leadstage4
    }
    //    if let strnextactiontime = dicLead?["NextActionTime"] as? String{
        if((Utils.getDateFromStringWithFormat(gmtDateString: dicLead?["NextActionTime"] as! String).compare(Date()) == .orderedAscending)&&(AddLead.isEditLead == false)){
                 message = "Please select valid next action time"
            currenleadstage = Leadstage.leadstage4
                 }
        //}
        if((Utils.getDateFromStringWithFormat(gmtDateString: dicLead?["OrderExpectedDate"] as! String).compare(Date()) == .orderedAscending)&&(AddLead.isEditLead == false)){
                 message = "Please select valid order expected date"
            currenleadstage = Leadstage.leadstage4
                 }
 
    }
    else if let tempcust = LeadCustomerDetail.selectedTempCustomer as? TempcustomerDetails{
        
        initalleaddic["CustomerID"] = LeadCustomerDetail.selectedTempCustomer.iD
        
        initalleaddic["AddressMasterID"] = LeadCustomerDetail.addressMasterID
        self.initalleaddic["ContactID"] = LeadCustomerDetail.contactID

        self.initalleaddic["SeriesPrefix"] = ""
        self.initalleaddic["OriginalAssignee"] = AddLeadFourthStep.originalAssignee
        self.initalleaddic["CreatedBy"] = self.activeuser?.userID
        initalleaddic["LeadSourceID"] = LeadSourceInfluencer.leadSourceIndex
        self.initalleaddic["IsNegotiationDone"] = AddLeadFourthStep.leadNegotiationDone
        initalleaddic["AskedForProposal"] = AddLeadFourthStep.leadProposalGiven
        initalleaddic["ProposalSubmitted"] = AddLeadFourthStep.leadProposalGiven
        initalleaddic["IsTrialDone"] = AddLeadFourthStep.leadDemoDone
        initalleaddic["IsLeadQualified"] = AddLeadFourthStep.leadQualified
        initalleaddic["LeadStage5"] = AddLeadFourthStep.isLead5Stage
        initalleaddic["LeadStage6"] = AddLeadFourthStep.isLead6Stage
        initalleaddic["NextActionTime"] =  Utils.getDateUTCWithAppendingDay(day: 0, date: AddLeadFourthStep.nextActionDate, format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)//Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate , format: "yyyy/MM/dd HH:mm:ss")//Utils.getDate(date: AddLeadFourthStep.nextActionTime, withFormat: "yyyy/MM/dd HH:mm:ss")//

        initalleaddic["OrderExpectedDate"] =  Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.orderExpectedDate , format: "yyyy/MM/dd HH:mm:ss")
        if(AddLeadFourthStep.strReminderDate.count > 0){
        if let reminderDate = AddLeadFourthStep.reminderDate as? Date{
        initalleaddic["ReminderTime"] = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate , format: "yyyy/MM/dd HH:mm:ss")
        }else{
            initalleaddic["ReminderTime"] =  nil
        }
        }else{

        }
        initalleaddic["NextActionID"] = AddLeadFourthStep.nextActionID
        if(AddLeadFourthStep.isReminderSelected){
            initalleaddic["Reminder"] = NSNumber.init(value: 1)
        }else{
        initalleaddic["Reminder"] =  NSNumber.init(value: 0)
        }
        initalleaddic["Response"] = AddLeadFourthStep.response
        initalleaddic["CustomerOrientationID"] = AddLeadFourthStep.positivity
        initalleaddic["Remarks"] = AddLeadFourthStep.remarks

        AddLead.LeadDic["addleadjson"] = initalleaddic
        let dicLead = AddLead.LeadDic["addleadjson"] as? [String:Any]
                //AddLead.objLead.productList
        if(dicLead?["CustomerID"] as? Int == 0){
        message = "Please select the Customer"
        currenleadstage = Leadstage.leadstage1
    }else  if(LeadAddProduct.arrOfProduct.count == 0){
       if(self.activesetting.productMandatoryInLead == 1){
        message = "Please select the Product"
        }else{
        message = "Please select the Product  Category/Product SubCategory"
        }
                 currenleadstage = Leadstage.leadstage3
    }else if(AddLeadFourthStep.isReminderSelected){
        if(AddLeadFourthStep.strReminderDate.count  == 0 ){
            message = "Please select Reminder Date"
        }else if(AddLeadFourthStep.strReminerTime.count  == 0){
            message = "Please select Reminder Time"
        }
        currenleadstage = Leadstage.leadstage4
    }
    //    if let strnextactiontime = dicLead?["NextActionTime"] as? String{
        if((Utils.getDateFromStringWithFormat(gmtDateString: dicLead?["NextActionTime"] as! String).compare(Date()) == .orderedAscending)&&(AddLead.isEditLead == false)){
                 message = "Please select valid next action time"
            currenleadstage = Leadstage.leadstage4
                 }
        //}
        if((Utils.getDateFromStringWithFormat(gmtDateString: dicLead?["OrderExpectedDate"] as! String).compare(Date()) == .orderedAscending)&&(AddLead.isEditLead == false)){
                 message = "Please select valid order expected date"
            currenleadstage = Leadstage.leadstage4
                 }
 
    }
    else{
     message = "Please Select Customer"
        currenleadstage = Leadstage.leadstage1
        if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        self.reflactAction()
    }
    
            if(message.count > 0){
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                self.reflactAction()
               
            }
            else{
                var param = Common.returndefaultparameter()
                //AddLead.LeadDic["addleadjson"]
                if let cust  = LeadCustomerDetail.selectedCustomer as? CustomerDetails {
                    if(LeadCustomerDetail.selectedCustomer.iD == 0){
                        initalleaddic["CustomerID"] = LeadCustomerDetail.selectedTempCustomer.iD
                    }else{
                    initalleaddic["CustomerID"] = LeadCustomerDetail.selectedCustomer.iD
                    }
                }else{
                    initalleaddic["CustomerID"] = LeadCustomerDetail.selectedTempCustomer.iD
                }
               
                initalleaddic["AddressMasterID"] = LeadCustomerDetail.addressMasterID
                self.initalleaddic["ContactID"] = LeadCustomerDetail.contactID
                
                self.initalleaddic["SeriesPrefix"] = ""
                self.initalleaddic["OriginalAssignee"] = AddLeadFourthStep.originalAssignee
                self.initalleaddic["CreatedBy"] = self.activeuser?.userID
                initalleaddic["LeadSourceID"] = LeadSourceInfluencer.leadSourceIndex
                self.initalleaddic["IsNegotiationDone"] = AddLeadFourthStep.leadNegotiationDone
                initalleaddic["AskedForProposal"] = AddLeadFourthStep.leadProposalGiven
                initalleaddic["ProposalSubmitted"] = AddLeadFourthStep.leadProposalGiven
                initalleaddic["IsTrialDone"] = AddLeadFourthStep.leadDemoDone
                initalleaddic["IsLeadQualified"] = AddLeadFourthStep.leadQualified
                initalleaddic["LeadStage5"] = AddLeadFourthStep.isLead5Stage
                initalleaddic["LeadStage6"] = AddLeadFourthStep.isLead6Stage
                
                initalleaddic["NextActionTime"] = Utils.getDateUTCWithAppendingDay(day: 0, date: AddLeadFourthStep.nextActionDate, format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)//Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.nextActionDate , format: "yyyy/MM/dd HH:mm:ss")//
                
                initalleaddic["OrderExpectedDate"] = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.orderExpectedDate , format: "yyyy/MM/dd HH:mm:ss")
                if(AddLeadFourthStep.strReminderDate.count > 0){
                if let reminderDate = AddLeadFourthStep.reminderDate as? Date{
                initalleaddic["ReminderTime"] = Utils.getDateWithAppendingDayLang(day: 0, date: AddLeadFourthStep.reminderDate , format: "yyyy/MM/dd HH:mm:ss")
                }else{
                    initalleaddic["ReminderTime"] =  nil
                }
                }else{
                   
                }
                initalleaddic["NextActionID"] = AddLeadFourthStep.nextActionID
                if(AddLeadFourthStep.isReminderSelected){
                    initalleaddic["Reminder"] = NSNumber.init(value: 1)
                }else{
                initalleaddic["Reminder"] =  NSNumber.init(value: 0)
                }
                initalleaddic["Response"] = AddLeadFourthStep.response
                initalleaddic["CustomerOrientationID"] = AddLeadFourthStep.positivity
              //  initalleaddic["Remarks"] = AddLeadFourthStep.remarks
                
                AddLead.LeadDic["addleadjson"] = initalleaddic
                
param["addleadjson"] = Common.returnjsonstring(dic: AddLead.LeadDic?["addleadjson"] as! [String : Any])
                print(LeadAddProduct.arrOfProductDic)
                LeadAddProduct.arrOfProductDic = [[String:Any]]()
                for prod in LeadAddProduct.arrOfProduct{
                    var dic = [String:Any]()
                    if(self.activesetting.leadProductPermission == 2){
                        let strprice = String.init(format:"%@",prod.price ?? 0)
                        if let tfstrprice = strprice as? String{
                            if(tfstrprice.count > 0){
                                dic["Budget"] = String.init(format:"%@",tfstrprice ?? 0)
                            }else{
                                dic["Budget"] = String.init(format:"%@",prod.budget ?? 0)
                            }
                        }else{
                            dic["Budget"] = String.init(format:"%@",prod.budget ?? 0)
                        }
                        
                        //dic["Budget"] = String.init(format:"%@",prod.price ?? 0)
                    }else{
                        dic["Budget"] = String.init(format:"%@",prod.budget ?? 0)
                        }
                              //dic["Budget"] = prod.budget
                    dic["CategoryID"] = prod.productCatId
                    dic["ProductID"] = prod.productID
                    dic["Quantity"] = prod.quantity
                    dic["SubCategoryID"] = prod.productSubCatId
               //     print("count of product = \(LeadAddProduct.arrOfProductDic.count)")
                LeadAddProduct.arrOfProductDic.append(dic)
                                    }
param["addleadproductjson"] = Common.json(from: LeadAddProduct.arrOfProductDic)
            
SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
print("paramter of  Add / Edit Lead  = \(param)")
self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetAddlead, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
    if(status.lowercased() == Constant.SucessResponseFromServer){
        LeadAddProduct.arrOfEditProduct = [SelectedProduct]()
        print("arr is = \(arr)")
        self.initialiseLeadData()
        
        SVProgressHUD.dismiss()
    if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
        print(responseType)
if(responseType ==  ResponseType.dic){
    let dicVisit = arr as? [String:Any] ?? [String:Any]()
    if(CustomerDetails.getAllCustomers().count > 0 &&  self.noOfTotalCustomer < self.noOFCustomer){
        SVProgressHUD.dismiss()
   
        MagicalRecord.save({ (localContext) in
   let arr =  FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: Lead.defaultmapping(), context: localContext)
    print(arr)
    localContext.mr_save({ (localContext) in
    print("saving")
        
    }, completion: { (status, error) in
    print("saved")
        if let lastlead =  Lead.getAll().last as? Lead{
            if let product = lastlead.productList.firstObject as? ProductsList{
                print(product.categoryID)
                print(product.productID)
                //print(product.subCategoryID)
            }
        }
})
            localContext.mr_saveToPersistentStoreAndWait()

}, completion: { (contextdidsave, error) in
         print(contextdidsave,error)
                   
                                    if(AddLead.isEditLead == false){
                        
                                    if(self.navigationController?.viewControllers.count ?? 0 > 0){
                       
                        if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                            if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                                self.navigationController?.popToViewController(controller,animated:true)
                            }
                        }
                                    
                        }else{
                self.navigationController?.popViewController(animated:true)
                        }
                                    }else{
    NotificationCenter.default.post(name: Notification.Name.init("updateLeadData"), object: nil,userInfo: nil)
self.navigationController?.popViewController(animated: true)
                                    }
                                    })
    }else{
        
        let tempcustid = NSNumber.init(value:LeadCustomerDetail.selectedTempCustomer?.iD ?? 0)
        Utils().getCustomerDetail(cid: tempcustid) { (status) in
            SVProgressHUD.dismiss()
              MagicalRecord.save({ (localContext) in
        let arr =  FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: Lead.defaultmapping(), context: localContext)
         print(arr)
         localContext.mr_save({ (localContext) in
         print("saving")
             
         }, completion: { (status, error) in
         print("saved")
             if let lastlead =  Lead.getAll().last as? Lead{
                 if let product = lastlead.productList.firstObject as? ProductsList{
                     print(product.categoryID)
                     print(product.productID)
                    print(lastlead.productList.count)
                 }
             }
     })
                 localContext.mr_saveToPersistentStoreAndWait()

     }, completion: { (contextdidsave, error) in
              print(contextdidsave,error)
                        
                                         if(AddLead.isEditLead == false){
                             
                                         if(self.navigationController?.viewControllers.count ?? 0 > 0){
                            
                             if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                                 if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                                     self.navigationController?.popToViewController(controller,animated:true)
                                 }
                             }
                                         
                             }else{
                     self.navigationController?.popViewController(animated:true)
                             }
                                         }else{
         NotificationCenter.default.post(name: Notification.Name.init("updateLeadData"), object: nil,userInfo: nil)
     self.navigationController?.popViewController(animated: true)
                                         }
                                         })
    }}

}}else if(error.code == 0){
          SVProgressHUD.dismiss()
        if(message.lowercased() == "invalid- token"){
            LeadCustomerDetail.contactID = NSNumber.init(value: 0)
            LeadCustomerDetail.selectedCustomer =  nil// CustomerDetails()
            LeadAddProduct.arrOfProduct = [SelectedProduct]()
            LeadAddProduct.arrOfProductDic = [[String:Any]]()
            LeadSourceInfluencer.selectedsource = nil
            AddLeadFourthStep.nextActionDate = nil
            AddLeadFourthStep.orderExpectedDate = nil
            AddLeadFourthStep.reminderDate = nil
            AddPictureLeadStatus.arrOfImageWithStatus = [UIImage]()
        }
      self.dismiss(animated: true, completion: nil)
        if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
           }else{
          SVProgressHUD.dismiss()
       var strerrmsg = ""
            if let errmsg = error.userInfo["localiseddescription"] as? String{
                if(errmsg.count > 0){
                strerrmsg = errmsg
                }else{
                    strerrmsg = error.localizedDescription
                }
            }
            if(strerrmsg.lowercased() == "invalid- token"){
                LeadCustomerDetail.contactID = NSNumber.init(value: 0)
                LeadCustomerDetail.selectedCustomer =  nil// CustomerDetails()
                LeadAddProduct.arrOfProduct = [SelectedProduct]()
                LeadAddProduct.arrOfProductDic = [[String:Any]]()
                LeadSourceInfluencer.selectedsource = nil
                AddLeadFourthStep.nextActionDate = nil
                AddLeadFourthStep.orderExpectedDate = nil
                AddLeadFourthStep.reminderDate = nil
                AddPictureLeadStatus.arrOfImageWithStatus = [UIImage]()
            }
      self.dismiss(animated: true, completion: nil)
Utils.toastmsg(message:(error.userInfo["localiseddescription"] as? String)?.count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription,view: self.view)
           }
    
                }
                

                
            
        }
    }
        
        // MARK: - (IBAction)
        
        
        @IBAction func btnAddLeadClicked(_ sender: UIButton) {
            
            switch sender.tag {
            case 1:
                sender.isSelected = !sender.isSelected
                currenleadstage = Leadstage.leadstage1
                self.reflactAction()
                break
                
            case 2:
                
                sender.isSelected = !sender.isSelected
                currenleadstage = Leadstage.leadstage2
                self.reflactAction()
                break
                
            case 3:
                
                sender.isSelected = !sender.isSelected
                currenleadstage = Leadstage.leadstage3
                self.reflactAction()
                break
                
            case 4:
                
                sender.isSelected = !sender.isSelected
                currenleadstage = Leadstage.leadstage4
                self.reflactAction()
                break
                
            case 5:
                
                switch currenleadstage {
                case Leadstage.leadstage2:
                    currenleadstage = Leadstage.leadstage1
                    
                    break
                case Leadstage.leadstage3:
                    currenleadstage = Leadstage.leadstage2
                    break
                case Leadstage.leadstage4:
                    currenleadstage = Leadstage.leadstage3
                    break
                default:
                    print("Default")
                }
                self.reflactAction()
                break
            case 6:
                
                switch currenleadstage {
                case Leadstage.leadstage1:
                    currenleadstage = Leadstage.leadstage2
                    self.reflactAction()
                    break
                case Leadstage.leadstage2:
                    currenleadstage = Leadstage.leadstage3
                    self.reflactAction()
                    break
                    
                case Leadstage.leadstage3:
                    currenleadstage = Leadstage.leadstage4
                    self.reflactAction()
                    break
                    
                case Leadstage.leadstage4:
                   
                    if(AddLeadFourthStep.isReminderSelected){
                        var message = ""
                        if(AddLeadFourthStep.strReminderDate.count  == 0 ){
                            message = "Please select Reminder Date"
                            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                        }else if(AddLeadFourthStep.strReminerTime.count  == 0){
                            message = "Please select Reminder Time"
                            if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                        }else{
                            self.checkValidation()
                        }
                    }else{
                    self.checkValidation()
                    }
                    print("Submit Process")
                    break
                    
                    
                }
                
                break
                
            default:
                print("default case")
            }
            
            
            
            
        }
        
        
func reflactAction(){
    var firstView = UIView()
    var firstviewcontroller = UIViewController()
    var secondView = UIView()
    var secondviewcontroller = UIViewController()
    var thirdView = UIView()
    var thirdviewcontroller = UIViewController()
    var fourthView = UIView()
    var fourthviewcontroller = UIViewController()
    
if let leadcustomerdetail =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.AddLeadCustomerDetail) as? LeadCustomerDetail{
    firstviewcontroller = leadcustomerdetail
    if let vw = leadcustomerdetail.view {
        firstView = vw
    }
    }
            //AddLeadSoureInfluencer
if let leadsourceInfluencer =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.AddLeadSoureInfluencer) as? LeadSourceInfluencer{
    secondviewcontroller =  leadsourceInfluencer
    if let vw = leadsourceInfluencer.view {
      secondView = vw
    }
    }
if let leadaddproduct =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.AddLeadProduct) as? LeadAddProduct{
                thirdviewcontroller = leadaddproduct
                if let vw = leadaddproduct.view {
                    thirdView = vw
                }
            }else{
                
            }
            if let leadFourthStep =  Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead, classname: Constant.AddLeadFourthStep) as? AddLeadFourthStep{
                fourthviewcontroller = leadFourthStep
                if let vw = leadFourthStep.view {
                    fourthView = vw
                }
            }
    print("subviews are = \(self.view.subviews)")
            switch currenleadstage {
                
            case Leadstage.leadstage1:
                
                btnLead1Step.isSelected = true
                btnLead2Step.isSelected =  false
                btnLead3Step.isSelected =  false
                btnLead4Step.isSelected =  false
                btnPrevious.isHidden = true
                
    if(scrlTarget.subviews.contains(firstView)){
    firstviewcontroller.didMove(toParent:self)
    }else{
        scrlTarget.addSubview(firstView)
    self.addChild(firstviewcontroller)
    firstviewcontroller.didMove(toParent: self)
    }
    btnPrevious.isUserInteractionEnabled = false
                self.btnNext.setbtnFor(title: "Next", type: Constant.kPositive)
               
                
    break
                
    case Leadstage.leadstage2:
    btnLead2Step.isSelected = true
    btnLead1Step.isSelected =  false
    btnLead3Step.isSelected =  false
    btnLead4Step.isSelected =  false
                btnPrevious.isHidden = false
        
        scrlTarget.addSubview(secondView)
                //if(scrlTarget.subviews.contains(secondView)){
        if(self.children.contains(secondviewcontroller)){
                    secondviewcontroller.didMove(toParent:self)
                }else{
                    scrlTarget.addSubview(secondView)
                    self.addChild(secondviewcontroller)
                    secondviewcontroller.didMove(toParent: self)
                }
                btnPrevious.isUserInteractionEnabled = true
        self.btnNext.setbtnFor(title: "Next", type: Constant.kPositive)
                break
            case Leadstage.leadstage3:
                btnLead3Step.isSelected = true
                btnLead1Step.isSelected =  false
                btnLead2Step.isSelected =  false
                btnLead4Step.isSelected =  false
                btnPrevious.isHidden = false
                if(scrlTarget.subviews.contains(thirdView)){
                    thirdviewcontroller.didMove(toParent:self)
                }else{
                    scrlTarget.addSubview(thirdView)
                    self.addChild(thirdviewcontroller)
                    thirdviewcontroller.didMove(toParent: self)
                }
                btnPrevious.isUserInteractionEnabled = true
                self.btnNext.setbtnFor(title: "Next", type: Constant.kPositive)
                break
            case Leadstage.leadstage4:
                
                btnLead4Step.isSelected = true
                btnLead1Step.isSelected =  false
                btnLead2Step.isSelected =  false
                btnLead3Step.isSelected =  false
                btnPrevious.isHidden = false
                if(scrlTarget.subviews.contains(fourthView)){
                    fourthviewcontroller.didMove(toParent:self)
                }else{
                    scrlTarget.addSubview(fourthView)
                    self.addChild(fourthviewcontroller)
                    fourthviewcontroller.didMove(toParent: self)
                }
                btnPrevious.isUserInteractionEnabled = true
                self.btnNext.setbtnFor(title: NSLocalizedString("submit", comment: ""), type: Constant.kPositive)
              
                break
                
            }
            
          
            
        }
}
