//
//  UpdateLeadStatus.swift
//  SuperSales
//
//  Created by Apple on 29/06/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
import CoreLocation
import FastEasyMapping
import CoreData
import StepSlider
import MagicalRecord
import CarbonKit

protocol  UpdateLeadSatusDelegate{
    func updateProductInfo(product:SelectedProduct,Record:Int)->()
}
class UpdateLeadStatus: BaseViewController {
    
    @IBOutlet weak var stkvwWillTakeSomeTime: UIStackView!
    @IBOutlet weak var vwReminder: UIView!
    @IBOutlet weak var stkLast: UIStackView!
    @IBOutlet weak var stkWithTblProduct: UIStackView!
    @IBOutlet var btnAddPicture: UIButton!
    @IBOutlet var btnAddProduct: UIButton!
    @IBOutlet var tblProduct: UITableView!
    @IBOutlet var vwPostponeDescision: UIView!
    @IBOutlet var parentStackInfluencerSelection: UIStackView!
    @IBOutlet var btnCustomer: UIButton!
    @IBOutlet var btnInfluencer: UIButton!
    @IBOutlet var stackInflunecerCustomer: UIStackView!
    @IBOutlet weak var tfOutcome: UITextField!
    @IBOutlet var stackInfluencerSelection: UIStackView!
    @IBOutlet var btnInfluencer1: UIButton!
    @IBOutlet var btnInfluencer2: UIButton!
    //Interaction
    @IBOutlet weak var btnInteractionMeeting: UIButton!
    @IBOutlet weak var btnInteractionCall: UIButton!
    @IBOutlet weak var btnInteractionMail: UIButton!
    @IBOutlet weak var btnInteractionMessage: UIButton!
    @IBOutlet weak var btnAddNewContact: UIButton!
    @IBOutlet weak var tfContact: UITextField!
    @IBOutlet weak var tfInteractionDate: UITextField!
    @IBOutlet weak var tfInteractionTime: UITextField!
    @IBOutlet var tfReminderDate: UITextField!
    @IBOutlet var tfReminderTime: UITextField!
    @IBOutlet var btnAddPictureForLeadQuality: UIButton!
    @IBOutlet weak var stackNextAction: UIStackView!
    @IBOutlet weak var NextActionIndicator: UIButton!
    @IBOutlet weak var lblNextActionDetailTitle: UILabel!
    @IBOutlet var tfExpectedDate: UITextField!
    
    @IBOutlet weak var tfNextActionDate: UITextField!
    
    @IBOutlet weak var tfNextActionTime: UITextField!
    
    @IBOutlet weak var lblOrderExpectedTitle: UILabel!
    @IBOutlet weak var tfOrderExpectedDate: UITextField!
    
    @IBOutlet weak var vwNextActionInteraction: UIView!
    
    @IBOutlet weak var btnNextInteractionMeeting: UIButton!
    @IBOutlet var vwOrderLost: UIView!
    
    
    @IBOutlet var tfOrderLostTo: UITextField!
    
    
    @IBOutlet var tfOrderLostReason: UITextField!
    
    @IBOutlet weak var btnNextInteractionCall: UIButton!
    
    @IBOutlet weak var stkReminder: UIStackView!
    
    @IBOutlet var vwWillTakeSomeTime: UIView!
    @IBOutlet weak var btnNextInteractionMail: UIButton!
    
    
    @IBOutlet weak var btnNextInteractionMessage: UIButton!
    
    @IBOutlet weak var stackDateTimeTitle: UIStackView!
    
    
    @IBOutlet weak var stackDateTimeControl: UIStackView!
    
    @IBOutlet weak var tvDescription: Placeholdertextview!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet var stkReminderTitle: UIStackView!
    
    
    @IBOutlet var stkReminderValue: UIStackView!
    
    
    @IBOutlet var btnLeadQualified: UIButton!
    
    
    @IBOutlet var btnLeadDemoDone: UIButton!
    
    
    @IBOutlet var btnLeadProposalGiven: UIButton!
    
    
    @IBOutlet var btnLeadFinalisation: UIButton!
    
   
    
    @IBOutlet var vwLeadQualified: UIView!
    
    
    @IBOutlet var vwTrialDone: UIView!
    
    
    @IBOutlet var vwProposalSubmited: UIView!
    
    
    @IBOutlet var statusPositiveSlider: StepSlider!
    @IBOutlet var vwLeadFinalisation: UIView!
    
    @IBOutlet var lblLeadQualifiedTitle: UILabel!
    
    @IBOutlet var lblTrialDoneTitle: UILabel!
    
    @IBOutlet var lblProposalSubmitedTitle: UILabel!
    
    @IBOutlet weak var vwLeadStage6: UIView!
    
    @IBOutlet weak var vwLeadstage5: UIView!
    @IBOutlet weak var lblLeadStag5Title: UILabel!
    
    @IBOutlet weak var lblLeadStage6Title: UILabel!
    @IBOutlet weak var btnLeadStage6: UIButton!
    
    @IBOutlet weak var btnLeadStage5: UIButton!
    @IBOutlet var lblLeadFinalisationTitle: UILabel!
    
    @IBOutlet var vwChanceOfGettingOrder: UIView!
    @IBOutlet weak var tblProductListHeight: NSLayoutConstraint!
    @IBOutlet var btnLeadTypeHot: UIButton!
    
    @IBOutlet var btnLeadTypeWarm: UIButton!
    
    
    @IBOutlet var btnLeadTypeCold: UIButton!
    
    @IBOutlet var btnPastInteraction: UIButton!
    
    @IBOutlet weak var btnAddAttachmentForLeadStatus: UIButton!
    
    @IBOutlet weak var stkClearAttchement: UIStackView!
    
    @IBOutlet weak var btnAttachmentLink: UIButton!
    
    var imgOfLead:UIImage?
    var isimgforlead:Bool = false
    var isimgForAttachment:Bool = false
    var objLead:Lead!
    var carbonswipenavigationobj:CarbonTabSwipeNavigation?
    var arrSelectedProductDic:[[String:Any]] = [[String:Any]]()
    var arrOfImageWithStatus:[UIImage]! = [UIImage]()
    
    var contactID:NSNumber! = NSNumber.init(value: 0)
    var interactionID:NSNumber!
    var arrSelectedVisitoutcome:[Outcomes]!

    var nextActionDate:Date = Date()
    var interactiondate:Date = Date()
    var expectationDate:Date = Date()
    var latestactivity = UserLatestActivityForVisit.none
    var isupdateLeadStatus:Bool?
    var leadtypeEnum:LeadType!
    var arrVisitOutCome:[Outcomes]!
    var custsegment = ""
    var custType = ""
    var filteredOutcome = [Outcomes]()
    var arrOfContact = [Contact]()
    var contactDropdown:DropDown! = DropDown()
    var OrderLostDropDown:DropDown! = DropDown()
    var arrOfOrderLostReason:[String] = [String]()
    var arrOrderLostReasonID = 1
    
    var nextActionID:NSNumber = 0
    var selectedInteraction = InteractionType.metting
    
    var datepicker:UIDatePicker!
    var interactionDate:Date!
    var orderExpectedDate:Date!
    var selectedoutcomeIndexes:[IndexPath]!
    
    
    
    
    var selectedLeadOutcome:Int64! = 0
    
    var leadType:NSInteger!
    
    
    
    var arrOfProduct:[SelectedProduct]! = [SelectedProduct]()
    
    
    var tableViewHeight: CGFloat {
        tblProduct.layoutIfNeeded()
        return tblProduct.contentSize.height
    }
    static var imageExistForLeadStatus:Bool!
    static var imageForLead:UIImage?
    
    var isNegotiationDone = false
    var isLeadQualified =  false
    var isProposalGiven = false
    var isDemoDone = false
    var isLead5Stage =  false
    var isLead6Stage = false
    
    var strNextActionTime = ""
    var strInteractionTime = ""
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "SuperSales")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error {
                    fatalError("Unresolved error \(error), \(error)")
                }
            })
            return container
        }()
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedcustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.influencerID)){
            
        }else{
            self.apihelper.getCustomerDetail(cid: NSNumber.init(value:objLead.influencerID))
        }
        if let selectedcustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.secondInfluencerID)){
            
        }else{
            self.apihelper.getCustomerDetail(cid: NSNumber.init(value:objLead.secondInfluencerID))
        }
        self.setUI()
      /*  if let laststatus = objLead.leadStatusList.firstObject as? LeadStatusList{
            if(laststatus.statusFrom == "C"){
                btnCustomer.isSelected = true
                btnInfluencer.isSelected = false
                stackInflunecerCustomer.isHidden = true
            }else{
                btnCustomer.isSelected = false
                btnInfluencer.isSelected = true
                if(objLead.influencerID == 0 && objLead.secondInfluencerID == 0){
                    stackInflunecerCustomer.isHidden = true
                    stackInfluencerSelection.isHidden = true
                }else{
                    stackInflunecerCustomer.isHidden = false
                    stackInfluencerSelection.isHidden = true
                }
                if(laststatus.statusFrom == "I"){
                    btnInfluencer1.isSelected = true
                    btnInfluencer2.isSelected = false
                }else{
                    btnInfluencer1.isSelected = false
                    btnInfluencer2.isSelected = true
                }
            }
        }else   if(objLead.influencerID == 0 && objLead.secondInfluencerID == 0){
            stackInflunecerCustomer.isHidden = true
            stackInfluencerSelection.isHidden = true
        }else{
            stackInflunecerCustomer.isHidden = false
            stackInfluencerSelection.isHidden = true
            btnCustomer.isSelected = true
            if(objLead.influencerID > 0){
                let influencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.influencerID))
                btnInfluencer1.setTitle(influencer?.name, for: UIControl.State.normal)
            }
            if(objLead.secondInfluencerID > 0){
                let sinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.secondInfluencerID))
                btnInfluencer2.setTitle(sinfluencer?.name, for: UIControl.State.normal)
            }else{
                btnInfluencer2.isHidden = true
            }
        }*/
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        
        self.tblProductListHeight.constant = tblProduct.contentSize.height
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        if(AddPictureLeadStatus.arrOfImageWithStatus.count > 0){
            btnAddPictureForLeadQuality.setAttributedTitle(NSAttributedString.init(attributedString: NSAttributedString.init(string: "View Picture")), for: UIControl.State.normal)
            btnAddPictureForLeadQuality.setAttributedTitle(NSAttributedString.init(attributedString: NSAttributedString.init(string: "View Picture")), for: UIControl.State.selected)
        }else{
            btnAddPictureForLeadQuality.setTitle("Add Picture", for: UIControl.State.normal)
            btnAddPictureForLeadQuality.setTitle("Add Picture", for: UIControl.State.selected)
        }
      
    }
    
    
    //MARK: - Method
    func setUI()->(){
        if let titleattachment =  btnAttachmentLink.currentTitle{
            if(titleattachment.count > 0)
            {
                stkClearAttchement.isHidden = false
            }else{
                stkClearAttchement.isHidden = true
            }
        }else{
            stkClearAttchement.isHidden = true
        }

        let contactno =  NSAttributedString.init(string: "Add Picture", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white , NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        
        //  lblContactPersonNo.attributedText = contactno
        //        btnAddPicture.titleLabel?.attributedText = contactno
        //        btnAddPicture.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btnAddPicture.setAttributedTitle(contactno, for: UIControl.State.normal)
        btnAddPictureForLeadQuality.contentHorizontalAlignment = .left
        let attachmentTitle =  NSAttributedString.init(string: "Add Attachment", attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue , NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        
        //  lblContactPersonNo.attributedText = contactno
        //        btnAddPicture.titleLabel?.attributedText = contactno
        //        btnAddPicture.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btnAddAttachmentForLeadStatus.setAttributedTitle(attachmentTitle, for: UIControl.State.normal)
        btnAddAttachmentForLeadStatus.contentHorizontalAlignment = .left
        
        AddPictureLeadStatus.arrOfImageWithStatus = [UIImage]()
        btnSubmit.setbtnFor(title: NSLocalizedString("submit", comment: ""), type: Constant.kPositive)
        self.tfOutcome.setrightImage(img: (UIImage.init(named: "icon_down_arrow_gray")!))
        self.tfOrderLostReason.setrightImage(img: (UIImage.init(named: "icon_down_arrow_gray")!))
        statusPositiveSlider.setIndex(UInt(6-objLead.customerOrientationID), animated: true)
       
        
        
        self.title = "Lead Status"
        
        
        tfOutcome.setCommonFeature()
        tfContact.setCommonFeature()
        tfReminderDate.setCommonFeature()
        tfExpectedDate.setCommonFeature()
        tfReminderDate.setCommonFeature()
        tfReminderTime.setCommonFeature()
        tfInteractionDate.setCommonFeature()
        tfOrderLostTo.setCommonFeature()
        tfInteractionTime.setCommonFeature()
        tfNextActionDate.setCommonFeature()
        tfNextActionTime.setCommonFeature()
        tfOrderExpectedDate.setCommonFeature()
        tfOrderLostReason.setCommonFeature()
        
        
        
        
        
        
        tfContact.setBottomBorder(tf: tfContact, color: UIColor.black)
        tfExpectedDate.setBottomBorder(tf: tfExpectedDate, color: UIColor.black)
        tfContact.setrightImage(img: UIImage.init(named: "icon_search_black")!)
        tfOrderLostTo.setBottomBorder(tf: tfOrderLostTo, color: UIColor.black)
        tfOrderLostReason.setBottomBorder(tf: tfOrderLostReason, color: UIColor.black)
        
        tfNextActionDate.addBorders(edges: [UIRectEdge.bottom], color: .black, cornerradius: 0)
        tfNextActionTime.addBorders(edges: [UIRectEdge.bottom], color: .black, cornerradius: 0)
        tfReminderDate.addBorders(edges: [UIRectEdge.bottom], color: .black, cornerradius: 0)
        tfReminderTime.addBorders(edges: [UIRectEdge.bottom], color: .black, cornerradius: 0)
        tfOrderExpectedDate.addBorders(edges: [UIRectEdge.bottom], color: .black, cornerradius: 0)
        tfInteractionDate.addBorders(edges: [UIRectEdge.bottom], color: .black, cornerradius: 0)
        tfInteractionTime.addBorders(edges: [UIRectEdge.bottom], color: .black, cornerradius: 0)
        
        UpdateLeadStatus.imageExistForLeadStatus = false
        arrOfOrderLostReason = Utils.getOrderLostReason()
        if(self.activesetting.showOurChancesInLead == 1){
            vwChanceOfGettingOrder.isHidden = false
        }else{
            vwChanceOfGettingOrder.isHidden = true
        }
        if(objLead.influencerID == 0 && objLead.secondInfluencerID == 0){
            stackInflunecerCustomer.isHidden = true
            stackInfluencerSelection.isHidden = true
        }else{
            stackInflunecerCustomer.isHidden = false
            stackInfluencerSelection.isHidden = true
            btnCustomer.isSelected = true
            if(objLead.influencerID > 0){
                let influencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.influencerID))
                btnInfluencer1.setTitle(influencer?.name, for: UIControl.State.normal)
            }
            if(objLead.secondInfluencerID > 0){
                let sinfluencer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.secondInfluencerID))
                btnInfluencer2.setTitle(sinfluencer?.name, for: UIControl.State.normal)
            }else{
                btnInfluencer2.isHidden = true
            }
        }

        setNextAction(selected: false)
        
        
        arrVisitOutCome = [Outcomes]()
        arrSelectedVisitoutcome = [Outcomes]()
        self.setNextAction(selected: false)
        self.salesPlandelegateObject = self
        
        self.tfOutcome.delegate = self
        self.tfInteractionDate.delegate = self
        self.tfInteractionTime.delegate = self
        self.tfNextActionDate.delegate = self
        self.tfNextActionTime.delegate = self
        self.tfReminderDate.delegate = self
        self.tfReminderTime.delegate = self
        self.tfContact.delegate = self
        self.tfExpectedDate.delegate = self
        self.tfOrderExpectedDate.delegate = self
        
        datepicker = UIDatePicker()
        datepicker.setCommonFeature()
        tfInteractionDate.inputView =  datepicker
        tfInteractionTime.inputView = datepicker
        tfNextActionDate.inputView =  datepicker
        tfNextActionTime.inputView = datepicker
        tfOrderExpectedDate.inputView =  datepicker
        tfReminderTime.inputView =  datepicker
        tfReminderDate.inputView = datepicker
        tfExpectedDate.inputView = datepicker
        
        datepicker.date = Date()
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        tfInteractionDate.text = dateFormatter.string(from: datepicker.date)
        self.dateFormatter.dateFormat = "hh:mm a"
        tfInteractionTime.text = dateFormatter.string(from: datepicker.date)
        let arrOutcome = Outcomes.getAll()
        arrVisitOutCome = arrOutcome
       // Utils.toastmsg(message: "count of outcome before filter = \(arrOutcome.count)", view: self.view)
        for visitoutcome in arrVisitOutCome{
          
            
            custsegment = visitoutcome.customerSegment
            custType = visitoutcome.customerType
//            Utils.toastmsg(message: "\(visitoutcome.value(forKey: "customerSegment")) ,\(visitoutcome.leadOutcomeValue) , \(visitoutcome.customerSegment)", view: self.view)
//            Utils.toastmsg(message: "\(visitoutcome.value(forKey: "customerType")) ,\(visitoutcome.leadOutcomeValue) , \(visitoutcome.customerType)", view: self.view)
            //kyc1Type.components(separatedBy: ",")
            
            let arrOfSegment = custsegment.components(separatedBy: ",")
            let arrOfType = custType.components(separatedBy: ",")
            if  let selectedCustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.customerID)){
            
            let customertype = NSNumber.init(value:selectedCustomer.companyTypeID).stringValue
            let customersegment = NSNumber.init(value:selectedCustomer.segmentID).stringValue
            
            let outcomeSegment = visitoutcome.customerSegment as? String ?? "0"
            let outcomeCustomerType = visitoutcome.customerType as? String ?? "0"
//print("customer segment = \(custsegment),outcome type = \(custType),arr type = \(arrOfType.count), arr seg = \(arrOfSegment.count), filtered count = \(filteredOutcome.count)")
                if((arrOfType.contains(customertype) && arrOfSegment.contains(customersegment)) || (custsegment == "999999" && custType == "0") || ((arrOfType.count == 1 && (arrOfType.first == "" || arrOfType.first == customertype)) && (arrOfSegment.count == 1 && (arrOfSegment.first == "" || arrOfSegment.first == customersegment)))){
                    //|| (outcomeSegment.count == 0 && outcomeCustomerType.count == 0)
//                    if(arrOfType.count == 1 && arrOfSegment.count == 1){
//                        Utils.toastmsg(message: "customer segment = \(custsegment),outcome type = \(custType),arr type = \(arrOfType), arr seg = \(arrOfSegment) ,\(filteredOutcome.count) , cust = \(customertype) , \(customersegment), \(outcomeSegment) , \(outcomeCustomerType)", view: self.view)
//                    }else{
//                        Utils.toastmsg(message: "customer segment = \(custsegment),outcome type = \(custType),arr type = \(arrOfType.count), arr seg = \(arrOfSegment.count) , \(filteredOutcome.count), cust = \(customertype) , \(customersegment)", view: self.view)
//                    }
              
            }else {
               // Utils.toastmsg(message: "arr of type = \(arrOfType) => \(customertype) , arr of segment = \(arrOfSegment) => \(customersegment) , 999999  == \(outcomeCustomerType) , 0 == \(outcomeSegment) , \(filteredOutcome.count)", view: self.view)
                
                filteredOutcome.append(visitoutcome)
            }
            }else{
                Utils.toastmsg(message: "Not get Customer", view: self.view)
            }
        }
        
      
        arrVisitOutCome = arrVisitOutCome.filter{
            !filteredOutcome.contains($0)
        }
      /*  if  let selectedCustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.customerID)){
            arrVisitOutCome = Outcomes.getOutComeAccordingTocustomer(custSegment: NSNumber.init(value:selectedCustomer.segmentID).stringValue, custType: NSNumber.init(value:selectedCustomer.companyTypeID).stringValue)
         //   Utils.toastmsg(message: ("outome count is = \(arrVisitOutCome.count) \(Outcomes.getAll().first?.customerSegment)"), view: self.view)
        }
        
        var outcomes = [Outcomes]()
        let context = Outcomes.getContext()
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Outcomes")
        do {
            let outcomes =  try context.fetch(fetchRequest) as [Outcomes]
            
            // Then you can use your properties.
            
            for location in outcomes {
                Utils.toastmsg(message: ("outome value is = \(location.customerSegment) \(location.customerType) , \(location.leadOutcomeValue)"), view: self.view)
                
                print("\(location.customerSegment) , \(location)")
                
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
          }
*/
        if  let selectedCustomer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.customerID)){
        
        let customertype = NSNumber.init(value:selectedCustomer.companyTypeID).stringValue
        let customersegment = NSNumber.init(value:selectedCustomer.segmentID).stringValue
           // Utils.toastmsg(message: "count of outcome after filter = \(arrVisitOutCome.count) , \(filteredOutcome.count) , cust segment = \(customertype) , outcome = \(customersegment)", view: self.view)
        }
     
        arrOfContact.removeAll()
        arrOfContact =  Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: objLead.customerID ?? 0))
        contactDropdown.anchorView = tfContact
        contactDropdown.bottomOffset = CGPoint.init(x: 0, y: tfContact.bounds.size.height)
        contactDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfContact.text = item
            let selectedContact = self.arrOfContact[index]
            self.contactID =  NSNumber.init(value: selectedContact.iD)
            
        }
        contactDropdown.dataSource =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
        tfContact.text =  contactDropdown.dataSource.count == 0 ? "No Contacts Exists":"Select Contact"
        if let selectedcontact = Contact.getContactFromID(contactID: NSNumber(value: objLead.contactID)){
            tfContact.text = String.init(format: "\(selectedcontact.firstName ?? "") \(selectedcontact.lastName ?? "")")
            self.contactID = NSNumber(value:objLead.contactID)
        }
        contactDropdown.reloadAllComponents()
        OrderLostDropDown.dataSource = arrOfOrderLostReason
        OrderLostDropDown.anchorView = tfOrderLostReason
        OrderLostDropDown.bottomOffset = CGPoint.init(x: 0, y: tfOrderLostReason.bounds.size.height)
        OrderLostDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfOrderLostReason.text = item
            self.arrOrderLostReasonID = index
            
        }
        /*arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}*/
        tfContact.text =  contactDropdown.dataSource.count == 0 ? "No Contacts Exists":"Select Contact"
        if let selectedcontact = Contact.getContactFromID(contactID: NSNumber(value: objLead.contactID)){
            tfContact.text = String.init(format: "\(selectedcontact.firstName ?? "") \(selectedcontact.lastName ?? "")")
            self.contactID = NSNumber(value:selectedcontact.iD)
        }
        contactDropdown.reloadAllComponents()
        
        tvDescription.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        //SelectedProduct
        if let arrpro = objLead?.productList.array as? [ProductsList]{
            print("type is differnt")
            
        }
        vwPostponeDescision.isHidden = true
        vwWillTakeSomeTime.isHidden = true
        vwOrderLost.isHidden = true
        arrOfProduct = [SelectedProduct]()
        for product in objLead.productList{
            
            if let pro = product as?  ProductsList{
                var dic = [String:Any]()
                print(pro)
                dic["productName"] = pro.productName
                dic["ProductID"] = pro.productID
                dic["CategoryID"] = pro.categoryID
                dic["Quantity"] = String.init(format: "\(pro.quantity ?? 0)")
                dic["Budget"] = String.init(format: "\(pro.budget ?? 0)")
                
                dic["Price"] = String.init(format: "\(pro.budget ?? 0)")
                dic["SubCategoryName"] = pro.subCategoryName
                dic["CategoryName"] = pro.categoryName
                dic["SubCategoryID"] = pro.subcategoryID
                let selectedpro = SelectedProduct().initwithdic(dict: dic)
                arrOfProduct.append(selectedpro)
            }
        }
        
      
        tfOutcome.textColor = UIColor.black
        leadType = 1
        
        
        
        self.setContactData()
        
        
        
        //MARK: Display views as per Setting
        
        
        if(self.activesetting.showLeadQualifiedInLead == 1){
            vwLeadQualified.isHidden = false
            if(objLead.isLeadQualified == 1){
                btnLeadQualified.isSelected = true
                btnLeadQualified.isUserInteractionEnabled = false
            }
            if(self.activesetting.leadQualifiedTextInLead?.count ?? 0 > 0){
                
                self.lblLeadQualifiedTitle.text = self.activesetting.leadQualifiedTextInLead
                
            }else{
                self.lblLeadQualifiedTitle.text = "Lead Qualified/Prospect"
                
            }
        }else{
            vwLeadQualified.isHidden = true
        }
        
        if(self.activesetting.leadStage5 == 1){
            vwLeadstage5.isHidden = false
            if(objLead.leadstage5 == 1){
                btnLeadStage5.isSelected = true
                btnLeadStage5.isUserInteractionEnabled = false
            }
            if(self.activesetting.leadStage5Text?.count ?? 0 > 0){
                
                self.lblLeadStag5Title.text = self.activesetting.leadStage5Text
                
            }else{
                self.lblLeadStag5Title.text = "Lead Stage 5"
                
            }
        }else{
            vwLeadstage5.isHidden = true
        }
        
        
        
        if(self.activesetting.leadStage6 == 1){
            vwLeadStage6.isHidden = false
            if(objLead.leadstage6 == 1){
                btnLeadStage6.isSelected = true
                btnLeadStage6.isUserInteractionEnabled = false
            }
            if(self.activesetting.leadStage6Text?.count ?? 0 > 0){
                
                self.lblLeadStage6Title.text = self.activesetting.leadStage6Text
                
            }else{
                self.lblLeadStage6Title.text = "Lead Stage 6"
                
            }
        }else{
            vwLeadStage6.isHidden = true
        }
        
        if(self.activesetting.showTrialDoneInLead == 1){
            vwTrialDone.isHidden = false
            if(objLead.isTrialDone == 1){
                btnLeadDemoDone.isSelected = true
                btnLeadDemoDone.isUserInteractionEnabled = false
            }
            if(self.activesetting.trialDoneTextInLead?.count ?? 0 > 0 ){
                self.lblTrialDoneTitle.text  = self.activesetting.trialDoneTextInLead
            }else{
                self.lblTrialDoneTitle.text  = "Demo/Trial Done"
            }
        }else{
            vwTrialDone.isHidden = true
        }
        if(self.activesetting.showNegotiationInLead == 1){
            vwLeadFinalisation.isHidden = false
            if(objLead.isNegotiationDone == 1){
                btnLeadFinalisation.isSelected =  true
                btnLeadFinalisation.isUserInteractionEnabled = false
            }
            if(self.activesetting.negotiationTextInLead?.count ?? 0 > 0){
                self.lblLeadFinalisationTitle.text = self.activesetting.negotiationTextInLead
            }else{
                self.lblLeadFinalisationTitle.text = "Negotiation/Finalisation"
            }
        }else{
            vwLeadFinalisation.isHidden = true
        }
        
        if(self.activesetting.showProposalSubInLead == 1){
            vwProposalSubmited.isHidden = false
            if(objLead.proposalSubmitted == 1){
                btnLeadProposalGiven.isSelected =  true
                btnLeadProposalGiven.isUserInteractionEnabled = false
                
            }
            if(btnLeadDemoDone.isSelected  == false && btnLeadProposalGiven.isSelected == false){
                btnAddPictureForLeadQuality.isHidden = true
            }else
            {
                btnAddPictureForLeadQuality.isHidden = false
            }
            if(self.activesetting.proposalSubTextInLead?.count ?? 0 > 0){
                self.lblProposalSubmitedTitle.text = self.activesetting.proposalSubTextInLead
            }else{
                self.lblProposalSubmitedTitle.text = "Proposal Given"
            }
        }else{
            vwProposalSubmited.isHidden = true
        }
        
        tblProduct.delegate = self
        tfOrderLostReason.delegate = self
        tblProduct.dataSource =  self
        tblProductListHeight.constant = tableViewHeight
        tblProduct.reloadData()
        
        
        if(objLead.leadStatusList.count > 0){
            
            for lastoutcome in  objLead.leadStatusList{
                if let lastoutCome =  lastoutcome as? LeadStatusList{
                    if(lastoutCome.isLeadQualified == 1){
                        isLeadQualified = true
                        btnLeadQualified.isSelected = true
                        btnLeadQualified.isUserInteractionEnabled = false
                    }
                    if(lastoutCome.isTrialDone == 1){
                        isDemoDone = true
                        btnLeadDemoDone.isSelected = true
                        btnLeadDemoDone.isUserInteractionEnabled = false
                    }
                    if(lastoutCome.leadstage5 == 1){
                        isLead5Stage = true
                        btnLeadStage5.isSelected = true
                        btnLeadStage5.isUserInteractionEnabled = false
                    }
                    if(lastoutCome.leadstage6 == 1){
                        isLead6Stage = true
                        btnLeadStage6.isSelected = true
                        btnLeadStage6.isUserInteractionEnabled = false
                    }
                    if(lastoutCome.proposalSubmitted == 1){
                        isProposalGiven = true
                        btnLeadProposalGiven.isSelected = true
                        btnLeadProposalGiven.isUserInteractionEnabled = false
                    }
                    if(lastoutCome.isNegotiationDone == 1){
                        isNegotiationDone = true
                        btnLeadFinalisation.isSelected = true
                        btnLeadFinalisation.isUserInteractionEnabled = false
                    }
                }
            }
            if let lastoutcome = objLead.leadStatusList.firstObject as? LeadStatusList{
                statusPositiveSlider.setIndex(UInt(6-lastoutcome.customerOrientationID), animated: true)
                if(lastoutcome.reminder > 0){
                    self.setNextAction(selected: true)
                }else{
                    self.setNextAction(selected: false)
                }
                if(lastoutcome.statusFrom == "C"){
                    btnCustomer.isSelected = true
                    btnInfluencer.isSelected = false
                    stackInflunecerCustomer.isHidden = true
                }else{
                    btnCustomer.isSelected = false
                    btnInfluencer.isSelected = true
                    if(objLead.influencerID == 0 && objLead.secondInfluencerID == 0){
                        stackInflunecerCustomer.isHidden = true
                        stackInfluencerSelection.isHidden = true
                    }else{
                        stackInflunecerCustomer.isHidden = false
                        stackInfluencerSelection.isHidden = true
                    }
                    if(lastoutcome.statusFrom == "I"){
                        btnInfluencer1.isSelected = true
                        btnInfluencer2.isSelected = false
                    }else{
                        btnInfluencer1.isSelected = false
                        btnInfluencer2.isSelected = true
                    }
                }

                self.setContactData()
                if let selectedcontact = Contact.getContactFromID(contactID: NSNumber.init(value: lastoutcome.interactionWith ?? 0)){
                    var strcontactname = ""
                    if let firstname = selectedcontact.firstName as? String{
                        strcontactname.append(String.init(format: "\(firstname)  "))
                    }
                    if let lastname =  selectedcontact.lastName as? String{
                        strcontactname.append(lastname)
                    }
                    tfContact.text = strcontactname
                    self.contactID =  NSNumber.init(value:lastoutcome.interactionWith)
                }
                tvDescription.text =  ""//lastoutcome.remarks
                if  let outcome  =  Outcomes.getOutcome(leadSourceID: NSNumber.init(value:lastoutcome.outcomeID)){
                    arrSelectedVisitoutcome.removeAll()
                    
                    arrSelectedVisitoutcome.append(outcome)
                selectedLeadOutcome = Outcomes.getOutcome(leadSourceID: NSNumber.init(value:lastoutcome.outcomeID))?.leadOutcomeIndexID
                tfOutcome.text = Outcomes.getOutcomeFromID(leadSourceID: NSNumber.init(value:lastoutcome.outcomeID))
                    self.updateViewasperoutcome(selectedLeadOutcome: Int64(outcome.outcomeType ?? 0))
                }
                selectedInteractionType(tag:Int(lastoutcome.interactionTypeID))
                if let strn = Utils.getDateBigFormatToDefaultFormat(date: lastoutcome.orderExpectedDate ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                    if let stret = Utils.getDatestringWithGMT(gmtDateString: strn , format: "dd-MM-yyyy") as? String{
                        tfExpectedDate.text  = stret
                    }
                    
                }
                if(Int(lastoutcome.nextActionID) > 0){
                    selectedNextActionInteractionType(tag: Int(lastoutcome.nextActionID))
                    if let strn = Utils.getDateBigFormatToDefaultFormat(date: lastoutcome.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                        if let strnt = Utils.getDatestringWithGMT(gmtDateString: strn , format: "dd-MM-yyyy") as? String{
                            
                tfExpectedDate.text  = strnt
                tfNextActionDate.text = strnt
            self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
                            nextActionDate = dateFormatter.date(from: strnt) ?? Date()
                            
                           // let strnextActionDate =  Utils.getDateWithAppendingDay(day: 1, date: Date(), format: "dd-MM-yyyy hh:mm a", defaultTimeZone: true)
                         //    nextActionDate = Utils.getDateFromStringWithFormat(gmtDateString: strnt)
                            
                            
                            self.dateFormatter.dateFormat = "hh:mm a"
                            print("next action date = \(nextActionDate)")
                            tfNextActionTime.text = dateFormatter.string(from: nextActionDate)
                            
                            strNextActionTime = ""
                            if let strdate = tfNextActionDate.text{
                                strNextActionTime.append(strdate)
                            }
                            if let strtime =  tfNextActionTime.text{
                                strNextActionTime.append("  \(strtime)")
                            }
                        }
                        if let strntime = Utils.getDatestringWithGMT(gmtDateString: strn , format: "hh:mm a") as? String{
                            tfNextActionTime.text = strntime
                            // dateFormatter.string(from: nextActionDate)
                            
                            strNextActionTime = ""
                            if let strdate = tfNextActionDate.text{
                                strNextActionTime.append(strdate)
                            }
                            if let strtime =  tfNextActionTime.text{
                                strNextActionTime.append("  \(strtime)")
                            }
                            self.dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
                        nextActionDate = dateFormatter.date(from: strNextActionTime) ?? Date()
                            
                        }
                    }else{
                        
                    }
                }else{
                    selectedNextActionInteractionType(tag: Int(1.0))
                
                }
                leadType = Int(lastoutcome.leadTypeID)
                if(lastoutcome.reminder > 0 && self.activesetting.leadReminder == NSNumber.init(value: 1)){
                    NextActionIndicator.isSelected = true
                    vwReminder.isHidden = false
                    tfReminderDate.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: lastoutcome.reminderTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") ?? "22-2-2010", format: "dd-MM-yyyy")
                    tfReminderTime.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: lastoutcome.reminderTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") ??  "22-2-2010", format: "hh:mm  a")
                    
                }else{
                    vwReminder.isHidden = true
                }
                tfOrderExpectedDate.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: lastoutcome.orderExpectedDate ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") ?? "22-2-2010", format: "dd-MM-yyyy")
            }else{
                
                tfOrderExpectedDate.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: objLead.orderExpectedDate ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") ?? "22-2-2010", format: "dd-MM-yyyy")
                selectedLeadOutcome = arrVisitOutCome.first?.leadOutcomeIndexID
                tfOutcome.text =   arrVisitOutCome.first?.leadOutcomeValue ?? "outcome test"
                
                self.updateViewasperoutcome(selectedLeadOutcome: Int64(arrVisitOutCome.first?.outcomeType ?? 0))
            }
            
        }
        else{
            selectedInteractionType(tag: 1)
            selectedNextActionInteractionType(tag: 1)
            leadType =  NSInteger(objLead.leadTypeID)
            if(self.activesetting.leadReminder == NSNumber.init(value: 1) && self.objLead.reminder > 0){
                vwReminder.isHidden = false
                NextActionIndicator.isSelected = true
            }else{
                vwReminder.isHidden = true
                NextActionIndicator.isSelected = false
            }
            // arrOfProduct = Array(objLead.productList) as [SelectedProduct]
            nextActionID = 1
            //      let calender = Calendar.current
            //      var daycomponent = DateComponents.init()
            //      daycomponent.day = 1
            //      if let date =  calender.date(byAdding: daycomponent, to: Date()) as? Date{
            //          nextActionDate = calender.date(bySettingHour: 10, minute: 0, second: 0, of: date) ?? Date()
            //      }
            //        datepicker.date = nextActionDate
            //
            //datepicker.date = expectationDate
            //        self.dateFormatter.dateFormat = "dd-MM-yyyy"
            //        tfNextActionDate.text = self.dateFormatter.string(from: datepicker.date)
            //        self.dateFormatter.dateFormat = "hh:mm a"
            //        tfNextActionTime.text = self.dateFormatter.string(from: datepicker.date)
            //        strNextActionTime = ""
            //        if let strdate = tfNextActionDate.text{
            //            strNextActionTime.append(strdate)
            //        }
            //        if let strtime =  tfNextActionTime.text{
            //            strNextActionTime.append("  \(strtime)")
            //        }
            interactionID = NSNumber.init(value: 1)
            self.selectedInteractionType(tag: 1)
            //contactID = NSNumber.init(value: 0)
            tfOutcome.placeholder = "Select Outcome"
            self.btnNextActionInteractionClicked(btnInteractionMeeting)
            selectedLeadOutcome = arrVisitOutCome.first?.leadOutcomeIndexID
            tfOutcome.text =   arrVisitOutCome.first?.leadOutcomeValue
            self.updateViewasperoutcome(selectedLeadOutcome: Int64(arrVisitOutCome.first?.outcomeType ?? 0))
            tfOrderExpectedDate.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: objLead.orderExpectedDate ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") ?? "22-2-2010", format: "dd-MM-yyyy")
//            tfExpectedDate.text  = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: objLead. ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") ?? "22-2-2010", format: "dd-MM-yyyy")
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: objLead.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                nextActionDate = self.dateFormatter.date(from: strn) ?? Date()
                if let strnt = Utils.getDatestringWithGMT(gmtDateString: strn , format: "dd-MM-yyyy") as? String{
                   
                    tfNextActionDate.text = strnt
                    self.dateFormatter.dateFormat = "hh:mm a"
                    tfNextActionTime.text = dateFormatter.string(from: datepicker.date)
                    
                    strNextActionTime = ""
                    if let strdate = tfNextActionDate.text{
                        strNextActionTime.append(strdate)
                    }
                    if let strtime =  tfNextActionTime.text{
                        strNextActionTime.append("  \(strtime)")
                    }
                    self.dateFormatter.dateFormat = "dd-MM-yyyy  hh:mm a"
                    nextActionDate = self.dateFormatter.date(from:  strNextActionTime) ?? Date()
                }
            }else{
                
            }
        }
        
        
        if(self.activesetting.showAdditionalReminderInLead == NSNumber.init(value: 1) ){
            stkReminder.isHidden = false
        }else{
            stkReminder.isHidden = true
        }
        
        //Utils.getDateWithAppendingDay(day: 0, date: Date(), format: "dd-MM-yyyy")
        
        if(leadType  ==  1){
            self.configureButtonSelected(btn: btnLeadTypeHot)
            self.configureButtonNormal(btn: btnLeadTypeWarm)
            self.configureButtonNormal(btn: btnLeadTypeCold)
        }else if(leadType == 2){
            self.configureButtonSelected(btn: btnLeadTypeWarm)
            self.configureButtonNormal(btn: btnLeadTypeHot)
            self.configureButtonNormal(btn: btnLeadTypeCold)
        }else{
            self.configureButtonSelected(btn: btnLeadTypeCold)
            self.configureButtonNormal(btn: btnLeadTypeHot)
            self.configureButtonNormal(btn: btnLeadTypeWarm)
        }
        
        
        if #available(iOS 11.0, *) {
            stkLast.setCustomSpacing(30.0, after: stkLast.subviews[1])
            stkLast.setCustomSpacing(30.0, after: stkLast.subviews[2])
            stkLast.setCustomSpacing(30.0, after: stkLast.subviews[4])
            stkvwWillTakeSomeTime.setCustomSpacing(30.0, after: stkvwWillTakeSomeTime.subviews[0])
            
            
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    func updateViewasperoutcome(selectedLeadOutcome:Int64){
        print("outcome is  = \(selectedLeadOutcome)")
        if(selectedLeadOutcome == 1){
            //postpone decision
            vwPostponeDescision.isHidden = false
          
            vwWillTakeSomeTime.isHidden = true
            vwOrderLost.isHidden = true
        }else if(selectedLeadOutcome == 2){
            //order lost
            vwPostponeDescision.isHidden = true
           
            vwWillTakeSomeTime.isHidden = true
            vwOrderLost.isHidden = false
        }else if(selectedLeadOutcome == 4 || selectedLeadOutcome == 0){
            //do nothing
            vwPostponeDescision.isHidden = true
            btnAddPictureForLeadQuality.isHidden = true
            vwWillTakeSomeTime.isHidden = true
            vwOrderLost.isHidden = true
        }else{
            vwPostponeDescision.isHidden = true
            btnAddPictureForLeadQuality.isHidden = true
            vwWillTakeSomeTime.isHidden = false
            btnAddPictureForLeadQuality.isHidden = true
            DispatchQueue.main.async {
                self.tblProduct.layoutSubviews()
                self.tblProductListHeight.constant = self.tableViewHeight
                
                self.tblProduct.layoutIfNeeded()
                self.tblProduct.reloadData()
            }
            
            vwOrderLost.isHidden = true
        }
        
        
    
        lblOrderExpectedTitle.isHidden = false
        tfOrderExpectedDate.isHidden = false
       
    }
    
    
    func configureButtonSelected(btn:UIButton)->(){
        leadType = btn.tag
        btn.addBorders(edges: [.all], color: UIColor.clear, cornerradius: 0)
        //  btn.layer.borderColor = Common().UIColorFromRGB(rgbValue:0x114763).cgColor
        btn.layer.backgroundColor = UIColor.systemBlue.cgColor//UIColor.clear.cgColor
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }
    
    func configureButtonNormal(btn:UIButton)->(){
        btn.addBorders(edges: [.all], color: UIColor.black, cornerradius: 0)
        // self.addBorders(edges
        //   btn.layer.borderColor =  UIColor.systemBlue.cgColor//Common().UIColorFromRGB(rgbValue:0x114763).cgColor
        btn.backgroundColor = UIColor.clear
        btn.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
    }
    
    
    
    func setNextAction(selected:Bool)->(){
        print("btn reminder clicked")
      //  NextActionIndicator.isSelected = selected
        if(selected == true){
            NextActionIndicator.isSelected = selected
            vwReminder.isHidden =  false
            //        self.selectedNextActionInteractionType(tag: 1)
                 if(nextActionID.intValue > 0 ){
               /* if(visitType == VisitType.planedvisit){
                 nextActionDate = dateFormatter.date(from: latestvisitreport.nextActionTime ?? "22/2/2010")
                 tfNextActionDate.text = Utils.getDateWithAppendingDay(day: 0, date: nextActionDate ?? Date() , format: "dd-MM-yyyy")
                 tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: latestvisitreport.nextActionTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss"), format: "hh:mm  a")
                 }else{
                 nextActionDate = dateFormatter.date(from: unplanvisitReport.nextActionTime ?? "22/2/2010")
                 tfNextActionDate.text = Utils.getDateWithAppendingDay(day: 0, date: nextActionDate ?? Date() , format: "dd-MM-yyyy")
                 tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString: Utils.getDateBigFormatToDefaultFormat(date: unplanvisitReport.nextActionTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss"), format: "hh:mm  a")
                 }*/
            }else{
                //                let calender = Calendar.current
                //                var daycomponent = DateComponents.init()
                //                daycomponent.day = 1
                //                if let date =  calender.date(byAdding: daycomponent, to: Date()) as? Date{
                //                    nextActionDate = calender.date(bySettingHour: 0, minute: 0, second: 0, of: date) ?? Date()
                //                    print(nextActionDate ?? "f4g4")
                //
                //                }
                let strnextActionDate =  Utils.getDateWithAppendingDay(day: 1, date: Date(), format: "dd-MM-yyyy hh:mm a", defaultTimeZone: true)
                 nextActionDate = Utils.getDateFromStringWithFormat(gmtDateString: strNextActionTime)
                tfNextActionDate.text = Utils.getDateWithAppendingDayLang(day: 0, date: nextActionDate ?? Date(), format: "dd-MM-yyyy")
                tfNextActionTime.text = Utils.getDateWithAppendingDayLang(day: 0, date: nextActionDate ?? Date(), format: "hh:mm a")
                strNextActionTime = ""
                if let strdate = tfNextActionDate.text{
                    strNextActionTime.append(strdate)
                }
                if let strtime =  tfNextActionTime.text{
                    strNextActionTime.append("  \(strtime)")
                }
            
        else{
           
            
        }
    }
        }else{
            vwReminder.isHidden = true
        }
    }
    func selectedNextActionInteractionType(tag:Int){
        nextActionID = NSNumber.init(value: tag)
        switch tag {
        case 1:
            
            // sender.isSelected = !sender.isSelected
            btnNextInteractionMeeting.isSelected = true
            btnNextInteractionCall.isSelected = false
            btnNextInteractionMail.isSelected = false
            btnNextInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.metting
            break
            
        case 2:
            //  sender.isSelected = !sender.isSelected
            btnNextInteractionMeeting.isSelected = false
            btnNextInteractionCall.isSelected = true
            btnNextInteractionMail.isSelected = false
            btnNextInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.call
            break
            
        case 3:
            //  sender.isSelected = !sender.isSelected
            btnNextInteractionMeeting.isSelected = false
            btnNextInteractionCall.isSelected = false
            btnNextInteractionMail.isSelected = true
            btnNextInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.mail
            break
            
        case 4:
            // sender.isSelected = !sender.isSelected
            btnNextInteractionMeeting.isSelected = false
            btnNextInteractionCall.isSelected = false
            btnNextInteractionMail.isSelected = false
            btnNextInteractionMessage.isSelected = true
            selectedInteraction = InteractionType.message
            break
            
        default:
            print("Its default case")
        }
    }
    
    func selectedInteractionType(tag:Int){
        interactionID =  NSNumber.init(value: tag)
        switch tag {
        case 1:
            
            // sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = true
            btnInteractionCall.isSelected = false
            btnInteractionMail.isSelected = false
            btnInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.metting
            break
            
        case 2:
            //  sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = false
            btnInteractionCall.isSelected = true
            btnInteractionMail.isSelected = false
            btnInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.call
            break
            
        case 3:
            //  sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = false
            btnInteractionCall.isSelected = false
            btnInteractionMail.isSelected = true
            btnInteractionMessage.isSelected = false
            selectedInteraction = InteractionType.mail
            break
            
        case 4:
            // sender.isSelected = !sender.isSelected
            btnInteractionMeeting.isSelected = false
            btnInteractionCall.isSelected = false
            btnInteractionMail.isSelected = false
            btnInteractionMessage.isSelected = true
            selectedInteraction = InteractionType.message
            break
            
        default:
            print("Its default case")
        }
    }
    
    
    func validateReport()->Bool{
        if(arrSelectedVisitoutcome.count == 0){
            Utils.toastmsg(message:"Select Lead Outcome",view:self.view)
            return false
        }
        if(((nextActionDate.compare(Date())) == .orderedAscending) && (NextActionIndicator.isSelected == true)){
            Utils.toastmsg(message:NSLocalizedString("please_select_valid_date", comment:""),view:self.view)
            return false
        }else {
            return true
        }
    }
    
    func isCheckedOut(lat:Double,long:Double)->(){
        if(Utils().isCheckedOut(leadID: NSNumber.init(value:objLead?.iD ?? 0), userID: self.activeuser?.userID ?? NSNumber.init(value: 0)) ==  true){
            var stroutcome = ""
            if(lat > 0 && long > 0){
                let cidata = Utils.isCheckOutLead1(leadID: NSNumber.init(value:objLead?.iD ?? 0), userID: self.activeuser?.userID ?? NSNumber.init(value:0))
                //as? LeadCheckInOutList{
                let location1 = CLLocation.init(latitude: lat, longitude: long)
                let location2 = CLLocation.init(latitude: Double(cidata?.lattitude ?? "0.00") ?? 0.00, longitude: Double(cidata?.longitude ?? "0.00") ?? 0.00)
                let distanceinmeter = location1.distance(from: location2)
                
                var isSameLocation = false
                if(distanceinmeter <= self.activeuser?.company?.radiusSuperSales?.doubleValue ?? 0){
                    stroutcome = "You have not yet checked out from the lead. Do you want to check out,close the lead with update lead status ?"
                    isSameLocation = true
                }else{
                    stroutcome = "You are not at lead location. Do you want to close the lead with update lead status ?"
                    isSameLocation =  false
                }
                
                let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default) { (action) in
                    self.updateLeadStatus(isForceCheckOut: false, isClosed: true)
                }
                let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                    
                    
                }
                let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
                    if(isSameLocation == true){
                        if( stroutcome == "You have not yet checked out from the lead. Do you want to check out,close the lead with update lead status ?"){
                            self.updateLeadStatus(isForceCheckOut: true, isClosed: false)
                        }else{
                        self.updateLeadStatus(isForceCheckOut: false, isClosed: false)
                        }
                    }else{
                        self.updateLeadStatus(isForceCheckOut: false, isClosed: false)
                    }
                }
                Common.showalertWithAction(msg: stroutcome, arrAction: [yesAction,noAction,cancelAction], view: self)
                //}
            }else{
                let msg =  String.init(format:"Selected outcome is \("") \n\n Are you sure you want to set this outcome")
                let noAction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.cancel) { (action) in
                    
                }
                let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
                    self.updateLeadStatus(isForceCheckOut: false, isClosed: false)
                }
                Common.showalertWithAction(msg: msg, arrAction: [yesAction,noAction], view: self)
            }
        }
    }
    
    func uploadImage(img:UIImage){
        SVProgressHUD.show()
        self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: ConstantURL.kWSUrlUploadAttachment, img: img, imgparamname: "File", param: Common.returndefaultparameter()) { [self] (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            SVProgressHUD.dismiss()
            if(status == Constant.SucessResponseFromServer){
             
                if let imagepath = arr as? String{
                  
                    stkClearAttchement.isHidden = false
                    self.btnAttachmentLink.setTitle(imagepath, for: UIControl.State.normal)
                  
//                    DispatchQueue.main.async {
//                        self.tblExpense.reloadData()
//                        self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
//                    }
                   
                }
            }else{
                if(message.count > 0){
                    
                    print(responseType)
                    print(arr)
                    Utils.toastmsg(message:message,view: self.view)
                    if let imagepath = arr as? String{
                        stkClearAttchement.isHidden = false
                        self.btnAttachmentLink.setTitle(imagepath, for: UIControl.State.normal)
                      
                    }
                }else if error.localizedDescription.count > 0{
                    stkClearAttchement.isHidden = true
                    Utils.toastmsg(message:error.localizedDescription,view: self.view)
                   
                }else{
                    stkClearAttchement.isHidden = true
                    Utils.toastmsg(message:"Something went wrong,Please try again",view: self.view)
                  
                }
                    
                }
            }
    }
    
    
    func updateLeadStatus(isForceCheckOut:Bool,isClosed:Bool)->(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var jsonParameter = [String:Any]()
        jsonParameter["CreatedBy"] = self.activeuser?.userID
        jsonParameter["LeadID"] = NSNumber.init(value: objLead.iD)
        jsonParameter["InteractionTypeID"] = interactionID
        jsonParameter["InteractionWith"] = contactID
//Utils.getDate(date: nextActionDate as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")//
        
        jsonParameter["NextActionTime"] = Utils.getDate(date: nextActionDate as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss") //Utils.getDateUTCWithAppendingDay(day:date:format:defaultTimeZone:true) //Utils.getDateUTCWithAppendingDay(day: 0, date: nextActionDate ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)  //nextActionDate//Utils.getDateUTCWithAppendingDay(day: 0, date: nextActionDate, format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true) //Utils.getDateinstrwithaspectedFormat(givendate: nextActionDate, format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: false)
        // }
        interactiondate = dateFormatter.date(from:String.init(format: "%@ %@", tfInteractionDate.text ?? Date() as CVarArg ,tfInteractionTime.text ?? "")) ?? Date()
        jsonParameter["InteractionTime"] = Utils.getDateinstrwithaspectedFormat(givendate: interactiondate, format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: false)
        jsonParameter["LeadTypeID"] = NSNumber.init(value: leadType)
        jsonParameter["OutcomeID"] = NSNumber.init(value: selectedLeadOutcome)
        jsonParameter["NextActionID"] = nextActionID
        jsonParameter["leadAttachementPath"] =  btnAttachmentLink.currentTitle
        //jsonParameter["CustomerOrientationID"] =
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        var ExpectedDate = Date()
        var strExpectedDate = ""
        if let strexpectedDate = tfOrderExpectedDate.text{
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
            ExpectedDate = dateFormatter.date(from:String.init(format: "%@ 00:00:00", strexpectedDate)) ?? Date()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            strExpectedDate = dateFormatter.string(from: ExpectedDate)
            jsonParameter["OrderExpectedDate"] = strExpectedDate  //Utils.getDateinstrwithaspectedFormat(givendate: interactiondate!, format: "yyyy/MM/dd HH:mm:ss")
        }
        jsonParameter["OrderLostReasonID"] = arrOrderLostReasonID
        jsonParameter["CustomerOrientationID"] = NSNumber.init(value: (6 - statusPositiveSlider.index))
        
        jsonParameter["Reminder"] = NSNumber.init(value: 0)
        if(isNegotiationDone){
            jsonParameter["IsNegotiationDone"] = NSNumber.init(value: 1)
        }else{
            jsonParameter["IsNegotiationDone"] = NSNumber.init(value: 0)
        }
        if(isDemoDone){
            jsonParameter["IsTrialDone"] = NSNumber.init(value: 1)
        }else{
            jsonParameter["IsTrialDone"] = NSNumber.init(value: 0)
        }
        /*if(isDemoDone){
        jsonParameter["IsTrialDone"] = NSNumber.init(value: 1)
    }else{
        jsonParameter["IsTrialDone"] = NSNumber.init(value: 0)
    }*/
        if(isLead5Stage){
            jsonParameter["LeadStage5"] = NSNumber.init(value: 1)
        }else{
            jsonParameter["LeadStage5"] = NSNumber.init(value: 0)
        }
        if(isLead6Stage){
            jsonParameter["LeadStage6"] = NSNumber.init(value: 1)
        }else{
            jsonParameter["LeadStage6"] = NSNumber.init(value: 0)
        }
        if(isProposalGiven){
            jsonParameter["ProposalSubmitted"] = NSNumber.init(value: 1)
        }else{
            jsonParameter["ProposalSubmitted"] = NSNumber.init(value: 0)
        }
        if(isLeadQualified){
            jsonParameter["IsLeadQualified"] = NSNumber.init(value: 1)
        }else{
            jsonParameter["IsLeadQualified"] = NSNumber.init(value: 0)
        }
        
        if(self.activesetting.influencerInLead == NSNumber.init(value:1)){
            if(btnCustomer.isSelected){
                jsonParameter["StatusFrom"] = "C"
            }else{
                jsonParameter["StatusFrom"] = "I"
            }
        }else{
            jsonParameter["StatusFrom"] = "C"
        }
        jsonParameter["OrderLostTo"] = tfOrderLostTo.text
        if(tvDescription.text.count > 0){
            jsonParameter["Remarks"] = tvDescription.text
        }else {
            jsonParameter["Remarks"] = ""
        }
        
        //arrOfProduct
        // jsonParameter["updateleadproductsjson"] = Common.json(from: arrOfProduct) //"[\n\n]"
        arrSelectedProductDic = [[String:Any]]()
        if(arrOfProduct.count > 0){
            for pro in arrOfProduct{
                /*
                 {"ProductID":"23062","CategoryID":"1589","SubCategoryID":"1590","Quantity":"654","Budget":"6754321","LeadID":"328534"}
                 **/
                var dic = [String:Any]()
                //  dic["productName"] = pro.productName ?? ""
                dic["ProductID"] = pro.productID ?? 0
                if(pro.productCatId == 0){
                    dic["CategoryID"] = NSNumber.init(value:0)
                }else{
                    dic["CategoryID"] = pro.productCatId
                }
                if(pro.productSubCatId == 0){
                    dic["SubCategoryID"] = NSNumber.init(value:0)
                    //  dic["SubCategoryID"] = NSNumber.init(value:0)
                }else{
                    dic["SubCategoryID"] = pro.productSubCatId
                }
                if(pro.quantity?.count == 0){
                    dic["Quantity"] = "0"
                }else{
                    dic["Quantity"] = pro.quantity
                }
                //        if(pro.quantity == 0){
                //                           dic["Quantity"] = 0
                //                        }else{
                //                            dic["Quantity"] = pro.quantity
                //                        }
                
                if(pro.leadId?.count == 0){
                    dic["LeadID"] = objLead.iD
                }else{
                    dic["LeadID"] = pro.leadId
                }
                
                if(self.activesetting.visitProductPermission == 2 && ((dic["Budget"] as? String)?.count == 0)){
                    dic["Budget"] = String.init(format:"%@",pro.price ?? 0)
                    if let budget = dic["Budget"] as? String{
                        if(budget.count == 0 && pro.budget?.count ?? 0  > 0){
                            dic["Budget"] = String.init(format:"%@",pro.budget ?? 0)
                        }
                    }
                }else{
                    dic["Budget"] = String.init(format:"%@",pro.budget ?? 0)
                }
                arrSelectedProductDic.append(dic)
            }
        }
        
        // jsonParameter["updateleadproductsjson"] = Common.json(from: arrSelectedProductDic)
        if(isForceCheckOut == true){
            jsonParameter["LeadForceCheckOut"] = NSNumber.init(value: 1)
        }
        if(AddPictureLeadStatus.arrOfImageWithStatus.count > 0){
            if let currentCoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
                jsonParameter["ImageLattitude"] = currentCoordinate.latitude
                jsonParameter["ImageLongitude"] = currentCoordinate.longitude
            }else{
                let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
                }
                Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
            }
        }
        var param = Common.returndefaultparameter()
        param["updateleadjson"] = Common.returnjsonstring(dic: jsonParameter)
        param["updateleadproductsjson"] = Common.json(from: arrSelectedProductDic)
        
       
        
        
        var arrimgParamName = [String]()
        
        var arrOfImg = [UIImage]()
        //    if(isupdateLeadStatus == true){
        //        arrimgParamName.append("leadImage")
        //        arrOfImg.append(UpdateLeadStatus.imageForLead ?? UIImage())
        //    }
        
        if(AddPictureLeadStatus.arrOfImageWithStatus.count > 0){
            for img in 0...AddPictureLeadStatus.arrOfImageWithStatus.count-1{
                let image = AddPictureLeadStatus.arrOfImageWithStatus[img]
                arrOfImg.append(image)
                
                if(img == 0){
                    arrimgParamName.append(String.init(format:"leadImage"))
                    //                jsonParameter["ImageLattitude"] = currentCoordinate.latitude
                    //                jsonParameter["ImageLongitude"] = currentCoordinate.longitude
                }else{
                    arrimgParamName.append(String.init(format:"leadImage\(img+1)"))
                    //                jsonParameter["ImageLattitude"] = currentCoordinate.latitude
                    //                jsonParameter["ImageLongitude"] = currentCoordinate.longitude
                }
            }
        }
        
        
        print("count  = \(AddPictureLeadStatus.arrOfImageWithStatus.count) and imgs = \(arrimgParamName.count)")
        if let leadimg = UpdateLeadStatus.imageForLead as?
            UIImage{
            arrimgParamName.append("leadImage")
            arrOfImg.append(leadimg)
        }
        print("param of api call = \(param) , arr of img = \(arrOfImg)")
        self.apihelper.addCustomerWithMultipartBody(fullUrl: ConstantURL.kWSUrlUpdateLead, arrimg: arrOfImg, arrimgparamname: arrimgParamName, param: param){
            (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
          
            if(status.lowercased() == Constant.SucessResponseFromServer){
               // print("response of lead  = \(arr)")
                UpdateLeadStatus.imageForLead = UIImage()
                if ( message.count > 0 ) {
                     Utils.toastmsg(message:message,view: self.view)
                }
                let arrStatus = arr as? [[String:Any]] ?? [[String:Any]]()
                let firststatus = arrStatus.first
                let outcome = firststatus?["OutcomeID"] as? Int  ?? 0
                if(outcome  == 1 || outcome == 4 || outcome == 7 || outcome == 6){
                    let fetchrequest  = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Lead")
                    fetchrequest.predicate = NSPredicate.init(format: String.init("iD == \(self.objLead.iD)"))
                    let context = Lead.getContext()
                    do{
                        
                      //  let array = try context.fetch(fetchrequest) as [PlannVisit]
                        
                        
                       // let array = try context.fetch(fetchrequest) as [PlannVisit]
                        
                        let arrResult  = try context.fetch(fetchrequest) as [Lead]
                        for objLead in arrResult{
                            context.delete(objLead)
                        }
                        context.mr_saveToPersistentStore { status, error in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                                self.carbonswipenavigationobj?.setCurrentTabIndex(0, withAnimation: true)
//                                self.navigationController?.popViewController(animated: true)
                                SVProgressHUD.dismiss()
                            })
                        }
                    }catch{
                        
                    }
                }
                else{
                MagicalRecord.save({ (localcontext) in
                    
                    let  arr = FEMDeserializer.collection(fromRepresentation: arrStatus, mapping: LeadStatusList.defaultmapping(), context: localcontext)
                FEMDeserializer.collection(fromRepresentation:  arrStatus, mapping: LeadStatusList.defaultmapping(), context: localcontext)
                    
                    localcontext.mr_save({ (localcontext) in
                        print("saving")
                    }, completion: { (status, error) in
                        print("saved \(status) , \(error)" )
                        
                    })
                    localcontext.mr_saveToPersistentStoreAndWait()
                    //mr_saveToPersistentStoreAndWait()
                   
                    
                }, completion: { (status, error) in
                    print(status)
                    print(error?.localizedDescription ?? "")
                    if  let status = LeadStatusList.getLeadStatusById(leadId: NSNumber.init(value: self.objLead.iD)) as? LeadStatusList{
                        let folder = self.objLead.leadStatusList as! NSMutableOrderedSet
                        
                        
                        folder.insert(status, at: 0)
                        self.objLead.leadStatusList = folder as NSOrderedSet
                        
                        self.objLead.productList = status.productList
                        print("product list is of lead = \(self.objLead.productList) and  product list = \(status.productList) status = \(status)")
                        self.objLead.leadTypeID = Int64(self.leadType)
                        self.objLead.customerOrientationID = NSNumber.init(value: (6 - self.statusPositiveSlider.index)).int64Value
                        self.dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
                       let ExpectedDate = self.dateFormatter.date(from:String.init(format: "%@ 00:00:00", self.tfOrderExpectedDate.text as! CVarArg)) ?? Date()
                        self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                       // self.tfOrderExpectedDate.text = self.dateFormatter.string(from: ExpectedDate)
                        self.objLead.orderExpectedDate = self.dateFormatter.string(from: ExpectedDate)
                        self.objLead.nextActionTime = self.strNextActionTime
                        print("expected date = \(self.objLead.orderExpectedDate) , \(self.objLead.nextActionTime) , \(self.leadType) , \(self.objLead.leadStatusList.count)")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                            self.carbonswipenavigationobj?.setCurrentTabIndex(0, withAnimation: true)

                            //self.navigationController?.popViewController(animated: true)
                            SVProgressHUD.dismiss()
                        })
                    }
 //                    NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
//                    let context = Lead.getContext()
//                    context.mr_saveToPersistentStore {
//                        contextDidSave, error in
//                        print("context did saved \(status) count = \(self.objLead.leadStatusList.count) , \(self.objLead.leadTypeID) , \(contextDidSave) , \(error?.localizedDescription) in lead update status screen ")
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
//
//                            self.navigationController?.popViewController(animated: true)
//                            SVProgressHUD.dismiss()
//                        })
//                    }
                })
                }
            }else if(error.code == 0){
                if ( message.count > 0 ) {
                    SVProgressHUD.dismiss()
                     Utils.toastmsg(message:message,view: self.view)
                }
            }else{
                SVProgressHUD.dismiss()
                Utils.toastmsg(message: (error.userInfo["localiseddescription"] as? String ?? "").count ?? 0 > 0 ?(error.userInfo["localiseddescription"] as? String ?? ""):error.localizedDescription, view: self.view)
            }
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
    //MARK: - IBAction
    
    @IBAction func ChanceOfOrderGetChanged(_ sender: StepSlider) {
    }
    @IBAction func btnLeadHotClicked(_ sender: UIButton) {
        leadType = 1
        self.configureButtonSelected(btn:btnLeadTypeHot)
        self.configureButtonNormal(btn: btnLeadTypeWarm)
        self.configureButtonNormal(btn: btnLeadTypeCold)
        
    }
    
    @IBAction func btnLeadWarmClicked(_ sender: UIButton) {
        leadType = 2
        self.configureButtonSelected(btn:btnLeadTypeWarm)
        self.configureButtonNormal(btn: btnLeadTypeHot)
        self.configureButtonNormal(btn: btnLeadTypeCold)
        
        
    }
    
    
    @IBAction func btnLeadColdClicked(_ sender: UIButton) {
        leadType = 3
        self.configureButtonSelected(btn:btnLeadTypeCold)
        self.configureButtonNormal(btn: btnLeadTypeHot)
        self.configureButtonNormal(btn: btnLeadTypeWarm)
        
        
    }
    
    @IBAction func btnAddPictureClicked(_ sender: UIButton) {
        isimgforlead = true
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            Utils.toastmsg(message:"Camera is not present",view:self.view)
        }
        
    }
    func setContactData(){
        if(objLead.influencerID == 0 && objLead.secondInfluencerID == 0){
            arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: objLead.customerID))
            if let selectedcontact = Contact.getContactFromID(contactID: NSNumber(value: objLead.contactID)){
                tfContact.text = String.init(format: "\(selectedcontact.firstName ?? "") \(selectedcontact.lastName ?? "")")
                self.contactID = NSNumber(value:objLead.contactID)
            }
        }else
        if(btnCustomer.isSelected){
            arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: objLead.customerID ?? 0))
            if let selectedcontact = Contact.getContactFromID(contactID: NSNumber(value: objLead.contactID)){
                tfContact.text = String.init(format: "\(selectedcontact.firstName ?? "") \(selectedcontact.lastName ?? "")")
                self.contactID = NSNumber(value:objLead.contactID)
            }
        }else if(btnInfluencer1.isSelected){
            arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: objLead.influencerID ?? 0))
        }else{
            arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: objLead.secondInfluencerID ?? 0))
        }
        contactDropdown.dataSource =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
        contactDropdown.reloadAllComponents()
        if(tfContact.text?.count == 0){
            if(contactDropdown.dataSource.count  > 0){
                tfContact.text = "Select Contact"
            }else{
                tfContact.text = "No Contacts Exists"
            }
        }
    }
    @IBAction func btnCustomerClicked(_ sender: UIButton) {
        sender.isSelected =
        !sender.isSelected
        if(sender.isSelected){
            btnCustomer.isSelected = true
            btnInfluencer.isSelected = false
            stackInfluencerSelection.isHidden = true
        }else{
            btnCustomer.isSelected = false
            btnInfluencer.isSelected = true
            if(objLead.influencerID > 0 && objLead.secondInfluencerID > 0){
                stackInfluencerSelection.isHidden = false
            }else{
                stackInfluencerSelection.isHidden =  true
            }
        }
        self.setContactData()
        
    }
    
    
    @IBAction func btnInfluencerClicked(_ sender: UIButton) {
        sender.isSelected =
        !sender.isSelected
        if(sender.isSelected){
            btnCustomer.isSelected = false
            btnInfluencer.isSelected = true
            if(objLead.influencerID > 0 && objLead.secondInfluencerID > 0){
                stackInfluencerSelection.isHidden = false
            }else{
                stackInfluencerSelection.isHidden =  true
            }
        }else{
            btnCustomer.isSelected = true
            btnInfluencer.isSelected = false
            stackInfluencerSelection.isHidden = true
        }
        self.setContactData()
    }
    
    
    @IBAction func btnInfluencer1Clicked(_ sender: UIButton) {
        sender.isSelected =
        !sender.isSelected
        if(sender.isSelected){
            btnInfluencer1.isSelected = true
            btnInfluencer2.isSelected = false
            
            
        }else{
            btnInfluencer1.isSelected = false
            btnInfluencer2.isSelected = true
            
            
            
            
        }
        self.setContactData()
        
    }
    
    
    @IBAction func btnInfluencer2Clicked(_ sender: UIButton) {
        sender.isSelected =
        !sender.isSelected
        if(sender.isSelected){
            btnInfluencer1.isSelected = false
            btnInfluencer2.isSelected = true
            
        }else{
            btnInfluencer1.isSelected = true
            btnInfluencer2.isSelected = false
            
        }
        self.setContactData()
        
    }
    
    @IBAction func btnLeadQualifiedClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected){
            isLeadQualified = true
        }else{
            isLeadQualified = false
        }
    }
    
    @IBAction func btnTrialDoneClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected  == false && btnLeadProposalGiven.isSelected == false){
            btnAddPictureForLeadQuality.isHidden = true
        }else
        {
            btnAddPictureForLeadQuality.isHidden = false
        }
        if(sender.isSelected){
            isDemoDone = true
        }else{
            isDemoDone = false
        }
    }
    
    
    @IBAction func btnLeadProposalClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print(sender.isSelected)
        print(btnLeadDemoDone.isSelected)
        if(sender.isSelected  == false && btnLeadDemoDone.isSelected == false) {
            btnAddPictureForLeadQuality.isHidden = true
        } else /*if(sender.isSelected  ==  false ||  btnLeadDemoDone.isSelected == true){
                
                btnAddPictureForLeadQuality.isHidden = false
                }else*/{
            btnAddPictureForLeadQuality.isHidden = false
        }
        if(sender.isSelected){
            isProposalGiven = true
        }else{
            isProposalGiven = false
        }
    }
    
    @IBAction func btnLeadFinalisationClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected){
            isNegotiationDone = true
        }else{
            isNegotiationDone = false
        }
    }

    
    @IBAction func btnLead5StageClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        
        if(sender.isSelected){
            isLead5Stage = true
        }else{
            isLead5Stage = false
        }
    }
    @IBAction func btnLead6StageClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        
        if(sender.isSelected){
            isLead6Stage = true
        }else{
            isLead6Stage = false
        }
    }
    @IBAction func btnNextActionInteractionClicked(_ sender: UIButton) {
        nextActionID = NSNumber.init(value: sender.tag)
        self.selectedNextActionInteractionType(tag:sender.tag)
    }
    
    @IBAction func btnInteractionSelectionClicked(_ sender: UIButton) {
        
        self.selectedInteractionType(tag: sender.tag)
        //        switch sender.tag {
        //        case 1:
        //
        //            sender.isSelected = !sender.isSelected
        //            btnInteractionMeeting.isSelected = true
        //            btnInteractionCall.isSelected = false
        //            btnInteractionMail.isSelected = false
        //            btnInteractionMessage.isSelected = false
        //            selectedInteraction = InteractionType.metting
        //            break
        //
        //        case 2:
        //            sender.isSelected = !sender.isSelected
        //            btnInteractionMeeting.isSelected = false
        //            btnInteractionCall.isSelected = true
        //            btnInteractionMail.isSelected = false
        //            btnInteractionMessage.isSelected = false
        //            selectedInteraction = InteractionType.call
        //            break
        //
        //        case 3:
        //            sender.isSelected = !sender.isSelected
        //            btnInteractionMeeting.isSelected = false
        //            btnInteractionCall.isSelected = false
        //            btnInteractionMail.isSelected = true
        //            btnInteractionMessage.isSelected = false
        //            selectedInteraction = InteractionType.mail
        //            break
        //
        //        case 4:
        //            sender.isSelected = !sender.isSelected
        //            btnInteractionMeeting.isSelected = false
        //            btnInteractionCall.isSelected = false
        //            btnInteractionMail.isSelected = false
        //            btnInteractionMessage.isSelected = true
        //            selectedInteraction = InteractionType.message
        //            break
        //
        //        default:
        //            print("Its default case")
        //        }
        //
    }
    
    
    @IBAction func btnNextactionIndicatorClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.setNextAction(selected: sender.isSelected)
        
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        
        if(NextActionIndicator.isSelected){
            if(tfReminderDate.text?.count ?? 0 ==  0 && tfReminderDate.text?.count == 0){
                Utils.toastmsg(message:"Please select date and time",view:self.view)
                return
            }else if(tfReminderTime.text?.count == 0){
                Utils.toastmsg(message:"Please select time",view:self.view)
                return
            }else if(tfReminderDate.text?.count == 0){
                Utils.toastmsg(message:"Please select date",view:self.view)
                return
            }
        }
        if self.activesetting.mandatoryRemarksInLeadStatus == 1 {
            if self.tvDescription.text.trimString.isEmpty || self.tvDescription.text == "" {
                Utils.toastmsg(message:"Please enter remarks",view:self.view)
                return
            }
        }
        //        if(self.validateReport() == true){
        //
        //        }
        
        if  let selectedOutcome = Outcomes.getOutcome(leadSourceID: NSNumber.init(value: selectedLeadOutcome)){
            let outcomeType =  selectedOutcome.outcomeType
            if(selectedOutcome.leadOutcomeValue == "Trial Successful"){
                if(UpdateLeadStatus.imageExistForLeadStatus == false){
                    Utils.toastmsg(message:"Please upload Image",view:self.view)
                    return
                }
            }
            if(outcomeType == 5){
                Utils.toastmsg(message:"Auto Close options is used for order generation only",view:self.view)
                return
            }
            if(selectedLeadOutcome == 1 || outcomeType == 4){
                let strmsg = "Do you want to place Sales Order?"
                let noAction = UIAlertAction.init(title: NSLocalizedString("No", comment: ""), style: UIAlertAction.Style.default) { (action) in
                    let msg = "Lead will be closed and you won't be able to place order against this lead. Please confirm to close the lead!"
                    let noaction = UIAlertAction.init(title: "No", style: UIAlertAction.Style.default) { (action) in
                        
                    }
                    let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
                        self.updateLeadStatus(isForceCheckOut: false, isClosed: true)
                    }
                    Common.showalertWithAction(msg: msg, arrAction: [yesAction,noaction], view: self)
                }
                
                let yesaction =  UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
                    //Common.showalertWithAction(msg: "You should redirect to add sales order screen", arrAction: [yesaction], view: self)
                    //  let yesaction =  UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
                    //                if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC, let fvc = carbonTabSwipeNavigation?.viewControllers.allValues.first as? SOrderList {
                    //                    vc.delegate = fvc
                    //                    self.navigationController!.pushViewController(vc, animated: true)
                    //              //  }
                    //               // }
                    guard let cust = CustomerDetails.getCustomerByID(cid: NSNumber(value: self.objLead?.customerID ?? 0)), cust.statusID == 2 else {
                        Utils.toastmsg(message:NSLocalizedString("customer_is_pending_so_you_cant_create_sales_order", comment: ""),view:self.view)
                        return
                    }
                    
                    //                if let objOutcome = Outcomes.isTrialSuccessful() {
                    //                    if (setting.mandatoryTrialSuccessfulStatusForOrderInLead == 1) {
                    //                        if let objTempLead = Lead.getLeadByID(Id: Int(objLead?.iD ?? 0)), let leadOutcomes = objTempLead.leadStatusList.value(forKey: "outcomeID") as? [Int64] {
                    //                            if !leadOutcomes.contains(objOutcome.leadOutcomeIndexID) {
                    //                                self.view.window?.makeToast("Please update lead status to 'Trial Successful to place order.")
                    //                                return
                    //                            }
                    //                        }
                    //                    }
                    //                }
                    
                    if let vc = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameOrder, classname: "addeditso") as? AddEditSalesOrderVC {
                        vc.lead = self.objLead
                        self.navigationController!.pushViewController(vc, animated: true)
                    }
                }
                
                Common.showalertWithAction(msg: strmsg, arrAction: [noAction,yesaction], view: self)
            }
            else if(selectedOutcome.leadOutcomeClose == 1){
                if  let coordinate = Location.sharedInsatnce.getCurrentCoordinate(){
                    if(CLLocationCoordinate2DIsValid(coordinate)){
                        self.isCheckedOut(lat: coordinate.latitude, long: coordinate.longitude)
                        
                    }
                    
                }else{
                    let cancelaction = UIAlertAction.init(title: "CANCEL", style: UIAlertAction.Style.default, handler: nil)
                    let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: UIAlertAction.Style.default) { (action) in
                        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                    }
                    Common.showalertWithAction(msg: "Please enable Location Services in Settings", arrAction: [cancelaction,settingAction], view: self)
                }
            }else{
                if let outcometext = tfOutcome.text as? String{
                    Common.showalert(title: "SuperSales", msg: "Selected outcome is \(outcometext) \n \n Are you sure you want to set this outcome ?", yesAction: UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
                        self.updateLeadStatus(isForceCheckOut: false, isClosed: false)
                    }), noAction: UIAlertAction.init(title: "NO", style: UIAlertAction.Style.default, handler: nil), view: self)
                }
            }
        }
        
    }
    
    @IBAction func btnAddPictureLeadQualityClicked(_ sender: UIButton) {
        
        if let addContact = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameLead , classname: Constant.LeadAddPictureStatus) as? AddPictureLeadStatus{
            self.navigationController?.pushViewController(addContact, animated: true)
        }
        
        
    }
    
    @IBAction func btnAddAttchementClicked(_ sender: UIButton) {
        if(Utils.isReachable()){
      
            let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
            let cameraAction = UIAlertAction.init(title: "From Camera", style: UIAlertAction.Style.default) { (action) in
                if let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.camera) as? Bool {
                    self.isimgForAttachment = true
                    DispatchQueue.main.async {
                       let picker = UIImagePickerController()
                        picker.delegate = self
                        picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
                        picker.allowsEditing = false
                        picker.sourceType = UIImagePickerController.SourceType.camera
                        
                        self.present(picker, animated: true, completion: nil)
                    }
                }else{
                    Utils.toastmsg(message:"Camera is not present",view: self.view)
                }
            }
            let galaryAction = UIAlertAction.init(title: "From Gallery", style: UIAlertAction.Style.default) { (action) in
                if let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) as? Bool {
                    DispatchQueue.main.async {
                        self.isimgForAttachment = true
                       let picker = UIImagePickerController()
                        picker.delegate = self
                        picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
                        picker.allowsEditing = false
                        picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                        
                        self.present(picker, animated: true, completion: nil)
                    }
                }else{
                    Utils.toastmsg(message:"Camera is not present",view: self.view)
                }
            }
            Common.showalertWithAction(msg: "How you want to attach Document", arrAction: [cameraAction,galaryAction,cancelAction], view: self)
        
            
        }
        else{
            Utils.toastmsg(message:"you need interent to upload image",view: self.view)
        }
        
        
        
        
    }
    @IBAction func btnAddProductClicked(_ sender: UIButton) {
        
        if(self.activesetting.leadProductPermission == 2){
            if let multipleproductselection = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.MultipleProductSelection) as? MultipleProductSelection{
                
                multipleproductselection.customerId =  NSNumber.init(value:objLead.customerID)
                multipleproductselection.isLead1 =  true
                multipleproductselection.issalesorder = false
                multipleproductselection.multipleproductselectiondelegate = self
                
                self.navigationController?.pushViewController(multipleproductselection, animated: true)
            }
        }else{
            if let addproductobj = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.SingleProductSelection) as? Addproduct{
                addproductobj.customerId =  objLead.customerID
                addproductobj.isFromProductStock = false
                addproductobj.isVisit = false
                addproductobj.isLead1 =  true
                addproductobj.isFromSalesOrder =  false
                addproductobj.productselectionfrom = ProductSelectionFromView.leadupdatestatus
                addproductobj.productselectiondelegate = self
                addproductobj.modalPresentationStyle = .overCurrentContext
                addproductobj.parentviewforpopup = self.view
                Utils.addShadow(view: self.view)
                self.present(addproductobj, animated: true, completion: nil)
            }
        }
    }
    @IBAction func btnAddNewContactClicked(_ sender: UIButton) {
        if let addContact = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddContactView) as? AddContact{
            addContact.isEditContact = false
            if  let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:objLead.customerID ?? 0)){
                addContact.selectedCust = customer
            }
            addContact.isVendor = false
            addContact.selectedContact = Contact()
            addContact.addcontactdel = self
            self.navigationController?.pushViewController(addContact, animated: true)
        }
    }
    
    @IBAction func clearAttachmentInExpense(_ sender: UIButton) {
       
          
        if(btnAttachmentLink.currentTitle?.count ?? 0 > 0){
//                let ato =  arrHistory[sender.tag]
            var photos:Array<IDMPhoto>? = Array()
            let photo:IDMPhoto = IDMPhoto.init(url: URL.init(string: btnAttachmentLink.currentTitle?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "))
                         //photos(withURLs: [[URL.init(string: attendanceCheckinDetail?.checkInPhotoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ")]])
                photo.caption = " "
                photos?.append(photo)
                let browser:IDMPhotoBrowser = IDMPhotoBrowser.init(photos: photos)
                browser.delegate = self
                browser.displayCounterLabel = true
                browser.displayActionButton = false
                browser.autoHideInterface = false
                browser.dismissOnTouch = false
                browser.displayArrowButton = false
                browser.displayActionButton = false
                browser.disableVerticalSwipe = true
                DispatchQueue.main.async {
                self.present(browser, animated: true, completion: nil)
            }
            
        }
        
    }
  
   
    @IBAction  func deleteAttachmentInExpense(_ sender : UIButton) {
   
          
            let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
            let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in

                self.btnAttachmentLink.setTitle("", for: UIControl.State.normal)
                self.stkClearAttchement.isHidden = true
                
//                self.arrOFExpense.remove(at: indexPath.row)
//                selectedexpense.billAttachmentPath = ""
//                self.arrOFExpense.insert(selectedexpense, at: indexPath.row)
//
//                DispatchQueue.main.async {
//                    self.tblExpense.layoutIfNeeded()
//                    self.tblExpense.reloadData()
//                    self.cnstTableExpenseHeight.constant = self.tblExpense.contentSize.height
//                }
//                self.tblExpense.endUpdates()


            }
           
            Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
            
            
        
        
    }
    
    
    
}

extension UpdateLeadStatus:IDMPhotoBrowserDelegate{
    
}
extension UpdateLeadStatus:UpdateLeadSatusDelegate{
    func updateProductInfo(product:SelectedProduct,Record:Int)->(){
        arrOfProduct.remove(at: Record)
        arrOfProduct.insert(product, at: Record)
    }
}
extension UpdateLeadStatus:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        
        if(textField == tfInteractionDate){
            
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            datepicker.datePickerMode = .date
            // datepicker.date = self.dateFormatter.date(from:tfInteractionDate.text!)!
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateInteractionTime = dateFormatter.date(from: strInteractionTime)
            datepicker.date = dateInteractionTime ?? Date()
            print("interaction time = \(strInteractionTime) , \(datepicker.date) ")
            return true
        }
        else if(textField == tfInteractionTime){
            
            self.dateFormatter.dateFormat = "hh:mm a"
            datepicker.datePickerMode = .time
            //  datepicker.date = self.dateFormatter.date(from:tfInteractionTime.text!)!
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateInteractionTime = dateFormatter.date(from: strInteractionTime)
            datepicker.date = dateInteractionTime ?? Date()
            return true
        }
        else if(textField == tfNextActionDate){
            self.datepicker.minimumDate = Date()
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            datepicker.datePickerMode = .date
            datepicker.date = self.dateFormatter.date(from:tfNextActionDate.text!) ?? Date()
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datepicker.date = dateNextActionTime ?? Date()
            print("\(strNextActionTime) , \(datepicker.date)")
            
            return true
            
        }else if(textField == tfOrderExpectedDate){
            self.datepicker.minimumDate = Date()
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            self.datepicker.datePickerMode = .date
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            self.datepicker.date = self.dateFormatter.date(from: tfOrderExpectedDate.text ?? "05-02-2020") ?? Date()
            
            return true
        }
        else if(textField == tfNextActionTime){
         
            self.dateFormatter.dateFormat = "hh:mm a"
            datepicker.datePickerMode = .time
            //datepicker.date = self.dateFormatter.date(from:strNextActionTime) ?? Date()
            dateFormatter.dateFormat = "dd-MM-yyyy  hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datepicker.date = dateNextActionTime ?? Date()
            self.datepicker.minimumDate = Date()
            print("\(strNextActionTime) , \(datepicker.date)")
            return true
        }else if(textField == tfReminderDate){
            self.datepicker.minimumDate = Date()
            datepicker.datePickerMode = .date
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            if(self.tfReminderDate.text?.count ?? 0 > 0){
                datepicker.date = self.dateFormatter.date(from:tfReminderDate.text!) ?? Date()
                return true
            }else{
                datepicker.date =  Date()
            }
            return true
        }else if(textField == tfOutcome){
            if  let  visitoutcomepopup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection{
                visitoutcomepopup.arrOfSelectedLeadOutCome = arrSelectedVisitoutcome ?? [Outcomes]()
                visitoutcomepopup.modalPresentationStyle = .overCurrentContext
                visitoutcomepopup.strTitle = "Select  Outcome"
                visitoutcomepopup.parentViewOfPopup =  self.view
                visitoutcomepopup.nonmandatorydelegate = self
                visitoutcomepopup.arrOfLeadOutCome = arrVisitOutCome
                visitoutcomepopup.strLeftTitle = ""
                visitoutcomepopup.strRightTitle = ""
                visitoutcomepopup.selectionmode = SelectionMode.none
                visitoutcomepopup.isSearchBarRequire = false
                visitoutcomepopup.isFromSalesOrder =  false
                visitoutcomepopup.viewfor = ViewFor.leadoutcome
                visitoutcomepopup.isFilterRequire = false
                Utils.addShadow(view: self.view)
                // popup?.showAnimate()
                self.present(visitoutcomepopup, animated: false, completion: nil)
            }
            return false
            
        }else if(textField == tfReminderTime){
            self.datepicker.minimumDate = Date()
            datepicker.datePickerMode = .time
            self.dateFormatter.dateFormat = "hh:mm a"
            if(self.tfReminderTime.text?.count ?? 0 > 0){
                datepicker.date = self.dateFormatter.date(from:tfReminderTime.text!) ?? Date()
            }else{
                datepicker.date =  Date()
            }
            return true
        }else if(textField == tfContact){
            contactDropdown.show()
            return false
        }else if(textField == tfOrderLostReason){
            OrderLostDropDown.show()
            return false
        }else if(textField ==  tfExpectedDate){
            self.datepicker.minimumDate = Date()
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            datepicker.datePickerMode = .date
            let strtodaydate = self.dateFormatter.string(from: Date())
            datepicker.date = self.dateFormatter.date(from:tfExpectedDate.text ?? strtodaydate) ?? Date()
            
            return true
        }
        else{
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if(textField == tfInteractionDate){
            datepicker.datePickerMode = UIDatePicker.Mode.date
        }else if(textField == tfInteractionTime){
            datepicker.datePickerMode = UIDatePicker.Mode.time
        }else if(textField == tfNextActionDate){
            datepicker.datePickerMode = UIDatePicker.Mode.date
        }else if(textField == tfNextActionTime){
            datepicker.datePickerMode = UIDatePicker.Mode.time
        }else if(textField == tfOrderExpectedDate){
            datepicker.datePickerMode = UIDatePicker.Mode.date
        }else if(textField == tfExpectedDate){
            datepicker.datePickerMode = UIDatePicker.Mode.date
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfInteractionDate){
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfInteractionDate.text =  dateFormatter.string(from: datepicker.date)
            strInteractionTime = ""
            if let strdate = tfInteractionDate.text{
                strInteractionTime.append(strdate)
            }
            if let strtime =  tfInteractionTime.text{
                strInteractionTime.append("  \(strtime)")
            }
            
        }else if(textField ==  tfInteractionTime){
            dateFormatter.dateFormat = "hh:mm a"
            tfInteractionTime.text =  dateFormatter.string(from: datepicker.date)
            strInteractionTime = ""
            if let strdate = tfInteractionDate.text{
                strInteractionTime.append(strdate)
            }
            if let strtime =  tfInteractionTime.text{
                strInteractionTime.append("  \(strtime)")
            }
            
        }else if(textField == tfNextActionDate){
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfNextActionDate.text = dateFormatter.string(from: datepicker.date)
            strNextActionTime = ""
            if let strdate = tfNextActionDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfNextActionTime.text{
                strNextActionTime.append("  \(strtime)")
            }
            self.dateFormatter.dateFormat = "hh:mm a"
            datepicker.datePickerMode = .time
            //datepicker.date = self.dateFormatter.date(from:strNextActionTime) ?? Date()
            dateFormatter.dateFormat = "dd-MM-yyyy  hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            datepicker.date = dateNextActionTime ?? Date()
            nextActionDate =  datepicker.date//Utils.getDateUTCWithAppendingDay(day: 0, date: datepicker.date ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)//Utils.getDateBigFormatToCurrent(date: strNextActionTime, format: "dd-MM-yyyy, hh:mm a")
            
        }
        else if(textField == tfOrderExpectedDate){
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfOrderExpectedDate.text = dateFormatter.string(from: datepicker.date)
            //            expectationDate = expectedDatePicker.date
        }else if(textField == tfNextActionTime){
            dateFormatter.dateFormat = "hh:mm a"
            tfNextActionTime.text =  dateFormatter.string(from: datepicker.date)
            strNextActionTime = ""
            if let strdate = tfNextActionDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfNextActionTime.text{
                strNextActionTime.append("  \(strtime)")
            }
           // let strnextActionDate =  Utils.getDateWithAppendingDay(day: 0, date: Date(), format: "dd-MM-yyyy hh:mm a", defaultTimeZone: true)
            dateFormatter.dateFormat = "dd-MM-yyyy  hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
          //  datepicker.date =
            nextActionDate =  dateNextActionTime ?? Date()
        }else if(textField == tfReminderDate){
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfReminderDate.text =  dateFormatter.string(from: datepicker.date)
            
        }else if(textField == tfReminderTime){
            dateFormatter.dateFormat = "hh:mm a"
            tfReminderTime.text =  dateFormatter.string(from: datepicker.date)
            
        }else if(textField == tfExpectedDate){
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfExpectedDate.text =  dateFormatter.string(from: datepicker.date)
        }
    }
}
extension UpdateLeadStatus:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    func menuitemTouched(item: UPStackMenuItem) {
        
    }
    
    //    func datepickerSelectionDone() {
    //
    //        if(interactionTimeDatePicker.tag == 0){
    //            dateFormatter.dateFormat = "dd/MM/yyyy"
    //            tfInteractionDate.text = dateFormatter.string(from: interactionTimeDatePicker.date)
    //            interactionTimeDatePicker.date = self.dateFormatter.date(from:tfInteractionTime.text!)!
    //                                print(interactionTimeDatePicker.date)
    //        }else if(interactionTimeDatePicker.tag == 1){
    //            dateFormatter.dateFormat = "hh:mm a"
    //            tfInteractionTime.text = dateFormatter.string(from: interactionTimeDatePicker.date)
    //            interactionTimeDatePicker.date = self.dateFormatter.date(from:tfInteractionTime.text!)!
    //                                print(interactionTimeDatePicker.date)
    //        }else if(nextActionDatePicker.tag == 2){
    //            dateFormatter.dateFormat = "dd/MM/yyyy"
    //            tfNextActionDate.text = dateFormatter.string(from: nextActionDatePicker.date)
    //        }else{
    //            dateFormatter.dateFormat = "hh:mm a"
    //            tfNextActionTime.text = dateFormatter.string(from: nextActionDatePicker.date)
    //        }
    //    }
    //
    
}
extension UpdateLeadStatus:PopUpDelegateNonMandatory{
    
    
    func completionSelectedLeadOutCome(arr: [Outcomes]) {
        
        Utils.removeShadow(view: self.view)
        var selectedvisitoutcomelist = ""
        if(arr.count > 0){
            arrSelectedVisitoutcome.removeAll()
            arrSelectedVisitoutcome = arr
            if  let outcome  =  arrSelectedVisitoutcome.first{
            selectedLeadOutcome = outcome.leadOutcomeIndexID
            for i in 0...arr.count - 1 {
                let outcome = arr[i]
                if(i == 0){
                    selectedvisitoutcomelist.append(outcome.leadOutcomeValue)
                }else{
                    selectedvisitoutcomelist.append(String.init(format: ", %@", outcome.leadOutcomeValue))
                }
            }
          
                self.updateViewasperoutcome(selectedLeadOutcome: Int64(outcome.outcomeType))
            }
        }else{
            arrSelectedVisitoutcome  = [Outcomes]()
        }
        tfOutcome.text =  selectedvisitoutcomelist
        
        
        if(tfOutcome.text?.range(of: NSLocalizedString("customer_placed_order", comment:"")) != nil){
            //tfOrderValue.isHidden = false
        }
        else{
            //tfOrderValue.isHidden = true
        }
        tfOutcome.textColor = UIColor.black
        
        
    }
    
    //    func CompletionSelectedVisitOutCome(arr: [VisitOutcomes]) {
    //        print(arr)
    //        var selectedvisitoutcomelist = ""
    //        if(arr.count > 0){
    //            arrSelectedVisitoutcome.removeAll()
    //            arrSelectedVisitoutcome = arr
    //            for i in 0...arr.count - 1 {
    //                let outcome = arr[i]
    //                if(i == 0){
    //        selectedvisitoutcomelist.append(outcome.visitOutcomeValue)
    //                }else{
    //                    selectedvisitoutcomelist.append(String.init(format: ", %@", outcome.visitOutcomeValue))
    //                }
    //            }
    //        }else{
    //            arrSelectedVisitoutcome  = [VisitOutcomes]()
    //        }
    //        tfCutomerOutCome.text =  selectedvisitoutcomelist
    //        if(tfCutomerOutCome.text?.range(of: NSLocalizedString("customer_promised_to_place_order", comment:"")) != nil){
    //            lblOrderExpectedTitle.isHidden = false
    //           tfOrderExpectedDate.isHidden = false
    //        }else{
    //            lblOrderExpectedTitle.isHidden = true
    //            tfOrderExpectedDate.isHidden = true
    //        }
    //
    //        if(tfCutomerOutCome.text?.range(of: NSLocalizedString("customer_placed_order", comment:"")) != nil){
    //
    //            tfOrderValue.isHidden = false
    //        }
    //        else{
    //             tfOrderValue.isHidden = true
    //        }
    //    }
}

extension UpdateLeadStatus:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(textView == tfOutcome){
            
            if  let  visitoutcomepopup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection{
                visitoutcomepopup.arrOfSelectedLeadOutCome = arrSelectedVisitoutcome ?? [Outcomes]()
                visitoutcomepopup.modalPresentationStyle = .overCurrentContext
                visitoutcomepopup.strTitle = "Select  Outcome"
                visitoutcomepopup.parentViewOfPopup =  self.view
                visitoutcomepopup.nonmandatorydelegate = self
                visitoutcomepopup.arrOfLeadOutCome = arrVisitOutCome
                visitoutcomepopup.strLeftTitle = ""
                visitoutcomepopup.strRightTitle = ""
                visitoutcomepopup.selectionmode = SelectionMode.none
                visitoutcomepopup.isSearchBarRequire = false
                visitoutcomepopup.isFromSalesOrder =  false
                visitoutcomepopup.viewfor = ViewFor.leadoutcome
                visitoutcomepopup.isFilterRequire = false
                // popup?.showAnimate()
                self.present(visitoutcomepopup, animated: false, completion: nil)
            }
            return false
        }else{
            tvDescription.textColor = UIColor.black
            return true
        }
        
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(textView.contentSize.width > textView.frame.size.width){
            textView.setFlexibleHeight()
        }
        return true
    }
    
}
extension UpdateLeadStatus :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isimgforlead = false
        UpdateLeadStatus.imageExistForLeadStatus = false
        if(isimgForAttachment){
            isimgForAttachment = false
        }
        picker.dismiss(animated: true
                       , completion:   nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        UpdateLeadStatus.imageExistForLeadStatus = true
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        if let   image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            //        if(isimgforlead){
            if(isimgForAttachment){
                self.uploadImage(img: image)
            }else{
            if let updateimg = UpdateLeadStatus.imageForLead as? UIImage{
                if(AddPictureLeadStatus.arrOfImageWithStatus.contains(updateimg)){
                    //UpdateLeadStatus.imageForLead = image
                    //                for img in 0...AddPictureLeadStatus.arrOfImageWithStatus.count - 1{
                    //                    let imageinarr = AddPictureLeadStatus.arrOfImageWithStatus[img]
                    //                    if(imageinarr == UpdateLeadStatus.imageForLead){
                    //                        AddPictureLeadStatus.arrOfImageWithStatus.remove(at: img)
                    //                    }
                    //                }
                    if let index = AddPictureLeadStatus.arrOfImageWithStatus.firstIndex(of: updateimg){
                        
                        AddPictureLeadStatus.arrOfImageWithStatus[index] = image
                    }
                    UpdateLeadStatus.imageForLead = image
                    //  AddPictureLeadStatus.arrOfImageWithStatus.insert(image, at: 0)
                }else{
                    UpdateLeadStatus.imageForLead = image
                    AddPictureLeadStatus.arrOfImageWithStatus.insert(image, at: 0)
                }
            }else{
                UpdateLeadStatus.imageForLead = image
                AddPictureLeadStatus.arrOfImageWithStatus.insert(image, at: 0)
            }
            }
            //}
            
            
            
            btnAddPicture.backgroundColor =  UIColor.Appthemegreencolor
            btnAddPicture.setAttributedTitle(NSAttributedString.init(attributedString: NSAttributedString.init(string: "Change Picture", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])), for: UIControl.State.normal)
            btnAddPicture.setAttributedTitle(NSAttributedString.init(attributedString: NSAttributedString.init(string: "Change Picture", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])), for: UIControl.State.selected)
          
            
        }
        picker.dismiss(animated: true
            , completion:nil)
        
    }
}
extension UpdateLeadStatus:ProductSelectionDelegate{
    override func updateViewConstraints() {
        
        self.tblProductListHeight.constant  =  self.tblProduct.contentSize.height
        self.tblProductListHeight.constant = tableViewHeight
        super.updateViewConstraints()
    }
    
    func addProduct1(product: SelectedProduct) {
        Utils.removeShadow(view: self.view)
        var isproductexist = false
        var isNewProduct = false
        for prod in arrOfProduct{
            print(" \(prod.productID) ==  \(product.productID),\(prod.productCatId) ==  \(product.productCatId) " )
            if(prod.productID == product.productID && self.activesetting.productMandatoryInLead == 1){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view:self.view)
                
                return
            }else if(prod ==  product){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view:self.view)
                
                return
            }
            /*else if(arrOfProduct.contains(prod)){
             Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""))
             return
             }*/
            else if((self.activesetting.productMandatoryInLead == 0)&&(prod.productID == product.productID)&&(prod.productSubCatId == product.productSubCatId)&&(prod.productCatId == product.productCatId)){
                
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view:self.view)
                return
            }
            else{
                isproductexist = true
                isNewProduct = true
            }
        }
        if(isproductexist){
            arrOfProduct.append(product)
        }
        if !isNewProduct {
            arrOfProduct.append(product)
        }
        
        //    tblProductListHeight.constant = tableViewHeight
        //    tblProduct.layoutIfNeeded()
        //
        //    tblProduct.reloadData()
        //    tblProductListHeight.constant = tableViewHeight
        //    tblProduct.layoutIfNeeded()
        //    tblProduct.reloadData()
        self.tblProduct.isHidden = true
        
        DispatchQueue.main.async {
            self.tblProduct.layoutIfNeeded()
            
            self.tblProduct.reloadData()
            
            self.tblProductListHeight.constant = self.tblProduct.contentSize.height
            self.tblProductListHeight.constant = self.tableViewHeight
            
            self.tblProduct.isHidden = false
        }
        if(!btnLeadDemoDone.isSelected){
            btnAddPictureForLeadQuality.isHidden = true
        }else
        {
            btnAddPictureForLeadQuality.isHidden = false
        }
        
    }
}
extension UpdateLeadStatus:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrOfProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProductCell{
            cell.updateleadStatusDelegate = self
            
            let product = arrOfProduct[indexPath.row]
            let  strProductName = NSMutableAttributedString.init(string: "",attributes: [:])
            let proname =  product.productName ?? ""
            let subcatname = product.subCategoryName ?? ""
            let catname = product.categoryName ?? ""
            if(proname.count > 0){
                strProductName.append(NSAttributedString.init(string: String.init(format:"\(proname) \n"), attributes: nil))
            }else if(subcatname.count > 0){
                strProductName.append(NSAttributedString.init(string: String.init(format:"SubCat: \(subcatname) \n"), attributes: nil))
            }else{
                strProductName.append(NSAttributedString.init(string: String.init(format:"Cat: \(catname) \n"), attributes: nil))
            }
            
            cell.lblProductName.attributedText = strProductName
            cell.lblProductName.textColor = UIColor.black
            // cell.lblProductName.text = product.productName
            
            cell.tfQty.text = String.init(format:"%@",product.quantity ?? 0)
            
            cell.tfBudget.text = String.init(format:"%@",product.budget ?? 0)
            cell.setProductInfo(pro: product, record: indexPath.row)
            cell.btnDelete.tag = indexPath.row
            //  cell.btnDelete.addTarget(self, action: #selector(deleteProduct), for: UIControl.Event.touchUpInside)
            cell.delegate = self
            
            
            cell.deleteAction = { sender in
                self.deletePro(index1: indexPath.row)
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    /*   @objc func deleteProduct(sender:UIButton)->(){
     
     if let localpoint = tblProduct.convert(CGPoint.zero, to: sender) as? CGPoint{
     let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
     let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
     
     if let selectedinpath = self.tblProduct.indexPathForRow(at: localpoint) as? IndexPath{
     self.arrOfProduct.remove(at: selectedinpath.row)
     self.tblProduct.beginUpdates()
     
     self.tblProduct.deleteRows(at: [selectedinpath], with: UITableView.RowAnimation.top)
     self.tblProduct.endUpdates()
     self.tblProductListHeight.constant = self.tableViewHeight
     }
     }
     Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
     }
     }
     */
    func tableView(_ tableView:UITableView , estimatedRowHeight  index:IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView:UITableView , rowHeight index:IndexPath) -> CGFloat {
        return tableView.contentSize.height
    }
    
}
/*extension UpdateLeadStatus : ProductCellDelegate{
 func deleteProduct(cell: ProductCell) {
 if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
 let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
 let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
 
 
 self.arrOfProduct.remove(at: indexPath.row)
 
 
 self.tblProduct.beginUpdates()
 
 self.tblProductList.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
 DispatchQueue.main.async {
 self.tblProduct.layoutIfNeeded()
 self.tblProduct.reloadData()
 // self..constant = self.tblProduct.contentSize.height
 }
 self.tblProduct.endUpdates()
 
 
 }
 Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
 }
 }
 
 func deletePro(index1: Int) {
 
 if let localpoint = tblProduct.convert(CGPoint.zero, to: self.tblProductList) as? CGPoint{
 if let   indexPath = self.tblProductList.indexPathForRow(at: localpoint) as? IndexPath{
 print("clicked pro no = \(indexPath.row) ,index is = \(index1)")
 }
 let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
 let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
 
 
 self.arrOfProduct.remove(at: index1)
 
 
 self.tblProduct.beginUpdates()
 //
 self.tblProduct.deleteRows(at: [IndexPath.init(row: index1, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
 // self.tblProduct.deleteRows(at: [(self.tblProduct.indexPathForRow(at: localpoint) ?? IndexPath.init(row: 0, section: 0))], with: UITableView.RowAnimation.top)
 self.tblProduct.endUpdates()
 
 
 }
 Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
 }
 }
 }*/

extension UpdateLeadStatus : ProductCellDelegate{
    
    func deleteProduct(cell: ProductCell) {
        if let indexPath = tblProduct.indexPath(for: cell) as? IndexPath{
            let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
            let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
                
                
                
                self.arrOfProduct.remove(at: indexPath.row)
                
                self.tblProduct.beginUpdates()
                //
                self.tblProduct.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0) ?? IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.top)
                self.tblProduct.reloadData()
                self.tblProduct.endUpdates()
                
                
            }
            Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
        }
    }
    
    func deletePro(index1: Int) {
        
        if let localpoint = tblProduct.convert(CGPoint.zero, to: self.tblProduct) as? CGPoint{
            if let   indexPath = self.tblProduct.indexPathForRow(at: localpoint){
                print("clicked pro no = \(indexPath.row) ,index is = \(index1)")
            }
            let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
            let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
                
                
                self.arrOfProduct.remove(at: index1)
                
                self.tblProduct.beginUpdates()
                //
                self.tblProduct.deleteRows(at: [IndexPath.init(row: index1, section: 0) ], with: UITableView.RowAnimation.top)
                self.tblProduct.reloadData()
                self.tblProduct.endUpdates()
                
                
            }
            Common.showalertWithAction(msg: NSLocalizedString("are_you_sure_you_want_to_delete_this_item", comment: ""), arrAction: [yesAction,noAction], view: self)
        }
    }
}
extension UpdateLeadStatus:MultipleProductSelectionDelegate{
    
    func addProductFromMultipleSelection(product: SelectedProduct) {
        
        for prod in arrOfProduct{
            if(prod.productID == product.productID){
                Utils.toastmsg(message:NSLocalizedString("you_cant_add_one_product_multiple_time", comment: ""),view:self.view)
                return
            }
        }
        arrOfProduct.append(product)
        print(arrOfProduct.count)
        
        
        
        self.tblProductListHeight.constant = self.tblProduct.contentSize.height
        self.tblProductListHeight.constant = self.tableViewHeight
        DispatchQueue.main.async {
            self.tblProduct.layoutIfNeeded()
            self.tblProduct.reloadData()
            self.tblProductListHeight.constant = self.tblProduct.contentSize.height
            self.tblProductListHeight.constant = self.tableViewHeight
        }
        //        self.tblProductListHeight.constant = self.tblProduct.contentSize.height
        //
        //        tblProduct.layoutIfNeeded()
        //        tblProduct.reloadData()
        //        tblProductListHeight.constant = tableViewHeight
        //        tblProduct.layoutIfNeeded()
        //        tblProduct.reloadData()
    }
    
}
extension UpdateLeadStatus:AddContactDelegate{
    func saveContact(customerID: NSNumber, customerName: String, contactName: String, contactID: NSNumber) {
        // tfContactPerson.text = contactName
        self.tfContact.text = contactName
        self.contactID =  contactID
        arrOfContact =  Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: objLead.customerID ))
        contactDropdown.dataSource =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
        contactDropdown.reloadAllComponents()
        //  self.setAddress()
    }
}
