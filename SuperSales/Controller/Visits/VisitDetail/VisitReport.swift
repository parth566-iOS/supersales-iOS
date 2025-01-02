//
//  VisitReport.swift
//  SuperSales
//
//  Created by Apple on 14/02/20.
//  Copyright © 2020 Bigbang. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation
import SVProgressHUD
import FastEasyMapping


class VisitReport: BaseViewController {
    
    //Interaction
    
    @IBOutlet weak var btnInteractionMeeting: UIButton!
    
    @IBOutlet weak var btnInteractionCall: UIButton!
    
    
    @IBOutlet weak var btnInteractionMail: UIButton!
    
    
    @IBOutlet weak var btnInteractionMessage: UIButton!
    
    
    @IBOutlet weak var btnAddNewContact: UIButton!
    
    
    @IBOutlet weak var tfContact: UITextField!
    
    @IBOutlet weak var tfInteractionDate: UITextField!
    
    @IBOutlet weak var tfInteractionTime: UITextField!
    
    // @IBOutlet weak var tfCutomerOutCome: UITextField!
    
    @IBOutlet weak var btnAddPicture: UIButton!
    
    @IBOutlet weak var stackNextAction: UIStackView!
    
    @IBOutlet weak var NextActionIndicator: UIButton!
    
    
    @IBOutlet weak var lblNextActionDetailTitle: UILabel!
    
    @IBOutlet weak var tfNextActionDate: UITextField!
    
    @IBOutlet weak var tfNextActionTime: UITextField!
    
    
    @IBOutlet weak var tfOrderValue: UITextField!
    
    @IBOutlet weak var lblOrderExpectedTitle: UILabel!
    @IBOutlet weak var tfOrderExpectedDate: UITextField!
    
    @IBOutlet weak var vwNextActionInteraction: UIView!
    
    @IBOutlet weak var btnNextInteractionMeeting: UIButton!
    
    @IBOutlet weak var btnNextInteractionCall: UIButton!
    
    
    @IBOutlet weak var btnNextInteractionMail: UIButton!
    
    
    @IBOutlet weak var btnNextInteractionMessage: UIButton!
    
    @IBOutlet weak var stackDateTimeTitle: UIStackView!
    
    
    @IBOutlet weak var stackDateTimeControl: UIStackView!
    
    @IBOutlet weak var tvDescription: Placeholdertextview!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var vwInterationType: UIView!
    
    @IBOutlet weak var vwInterationDateTime: UIView!
    
    
    @IBOutlet weak var vwContact: UIView!
    
    @IBOutlet var tvoutcome: Placeholdertextview!
    @IBOutlet weak var vwSubmit: UIView!
    var isHome:Bool!
    var isupdateReport:Bool?
    var latestvisitreport:VisitStatus!
    var unplanvisitReport:VisitStatusList!
    var visitType:VisitType!
    var planVisit:PlannVisit?
    var unplanVisit:UnplannedVisit?
    var contactID:NSNumber! = NSNumber.init(value: 0)
    var interactionID:NSNumber!
    var arrSelectedVisitoutcome:[VisitOutcomes]!
    var nextActionDate:Date?
    var expectationDate:Date?
    var latestactivity = UserLatestActivityForVisit.none
    
    
    var arrVisitOutCome:[VisitOutcomes]!
    var arrOfContact = [Contact]()
    var contactDropdown:DropDown! = DropDown()
    
    var nextActionID:NSNumber = 0
    var selectedInteraction = InteractionType.metting
    
    var expectedDatePicker:UIDatePicker!
    var interactionTimeDatePicker:UIDatePicker!
    var nextActionDatePicker:UIDatePicker!
    var strNextActionTime = ""
    var strInteractionTime = ""
    var selectedoutcomeIndexes:[IndexPath]!
    // var InteractionDatePicker:UIDatePicker!
    var isFromVisit:Bool!
    var isOTPRequire =  false
    var strOtp = ""
    var isForceCheckout = false
    var isForceClose = false
    var custsegment = ""
    var custType = ""
    var filteredOutcome = [VisitOutcomes]()
    var selectedCustomer = CustomerDetails()
    var arrOfVisitClose = [VisitOutcomes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        self.title = "Visit Report"
        //        if(isHome == false){
        //            self.setleftbtn(btnType: BtnLeft.back, navigationItem: self.navigationItem)
        //            self.title = "Visit Report"
        //        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    // MARK: Method
    func setUI(){
        self.btnSubmit.setbtnFor(title: "Submit", type: Constant.kPositive)
        
        btnAddPicture.contentHorizontalAlignment = .left
        
        arrVisitOutCome = [VisitOutcomes]()
        arrSelectedVisitoutcome = [VisitOutcomes]()
        self.setNextAction(selected: false)
        self.salesPlandelegateObject = self
        
        self.tvoutcome.delegate = self
        self.tfInteractionDate.delegate = self
        self.tfInteractionTime.delegate = self
        self.tfNextActionDate.delegate = self
        self.tfNextActionTime.delegate = self
        self.tfOrderExpectedDate.delegate = self
        self.tfOrderValue.delegate = self
        self.tfContact.delegate = self
        
        
        
        self.tfInteractionDate.setCommonFeature()
        self.tfInteractionTime.setCommonFeature()
        self.tfNextActionDate.setCommonFeature()
        self.tfNextActionTime.setCommonFeature()
        self.tfOrderExpectedDate.setCommonFeature()
        self.tfOrderValue.setCommonFeature()
        self.tfContact.setCommonFeature()
        
        
        interactionTimeDatePicker = UIDatePicker()
        nextActionDatePicker = UIDatePicker()
        expectedDatePicker = UIDatePicker()
        expectedDatePicker.setCommonFeature()
        nextActionDatePicker.setCommonFeature()
        interactionTimeDatePicker.setCommonFeature()
        tfInteractionDate.inputView =  interactionTimeDatePicker
        tfInteractionTime.inputView = interactionTimeDatePicker
        tfNextActionDate.inputView =  nextActionDatePicker
        tfNextActionTime.inputView = nextActionDatePicker
        tfOrderExpectedDate.inputView =  expectedDatePicker
        tfContact.setrightImage(img: UIImage.init(named: "icon_search_black")!)
        tfOrderValue.keyboardType = .numberPad
        
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        tfInteractionDate.text = self.dateFormatter.string(from: interactionTimeDatePicker.date)
        expectedDatePicker.date = Date()
        tfOrderExpectedDate.text =  self.dateFormatter.string(from: expectedDatePicker.date)
        self.dateFormatter.dateFormat = "hh:mm a"
        tfInteractionTime.text = self.dateFormatter.string(from: interactionTimeDatePicker.date)
        let arrOutcome = VisitOutcomes.getAll()
        
        
        arrVisitOutCome.removeAll()
        arrVisitOutCome = arrOutcome
        
        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
            if let cust =  CustomerDetails.getCustomerByID(cid: NSNumber.init(value: planVisit?.customerID ?? 0)){
                selectedCustomer = cust
                if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
                   /* for visitoutcome in arrVisitOutCome{
                        custsegment = visitoutcome.customerSegment
                        custType = visitoutcome.customerType
                        Utils.toastmsg(message: "\(visitoutcome.value(forKey: "customerSegment")) ,\(visitoutcome.visitOutcomeValue) , \(visitoutcome.customerSegment)", view: self.view)
                        Utils.toastmsg(message: "\(visitoutcome.value(forKey: "customerType")) ,\(visitoutcome.visitOutcomeValue) , \(visitoutcome.customerType)", view: self.view)
                        //kyc1Type.components(separatedBy: ",")
                        let arrOfSegment = custsegment.components(separatedBy: ",")
                        let arrOfType = custType.components(separatedBy: ",")
                        let customertype = NSNumber.init(value:selectedCustomer.companyTypeID).stringValue
                        let customersegment = NSNumber.init(value:selectedCustomer.segmentID).stringValue
                        print("arr of kyc = \(arrOfType) and \(customertype) , arr of segment = \(arrOfSegment) and \(customersegment) , visitstatus type = \(self.custsegment) , visitstatussegment = \(self.custType), \(visitoutcome.visitOutcomeValue)")
                        //(arrOfType.contains(customertype) && arrOfSegment.contains(customersegment)) || (custsegment == "999999" && custType == "0") || ((arrOfType.count == 1 && (arrOfType.first == "" || arrOfType.first == customertype)) && (arrOfSegment.count == 1 && (arrOfSegment.first == "" || arrOfSegment.first == customersegment)))
                        if((arrOfType.contains(customertype) && arrOfSegment.contains(customersegment)) || (self.custsegment == "999999" && self.custType == "0") || ((arrOfType.count == 1 && (arrOfType.first == "" || arrOfType.first == customertype)) && (arrOfSegment.count == 1 && (arrOfSegment.first == "" || arrOfSegment.first == customersegment)))){
                            
                            
                        }else{
                          //  Utils.toastmsg(message: "arr of kyc = \(arrOfType) => \(customertype) , arr of segment = \(arrOfSegment) => \(customersegment) , 999999  == \(custsegment) , 0 == \(custType)", view: self.view)
                            filteredOutcome.append(visitoutcome)
                        }
                        
                    }*/
                    arrVisitOutCome = VisitOutcomes.getVisitOutComeAccordingTocustomer(custSegment: NSNumber.init(value:selectedCustomer.segmentID).stringValue, custType: NSNumber.init(value:selectedCustomer.companyTypeID).stringValue)
                }
                
//                arrVisitOutCome = arrVisitOutCome.filter{
//                    !filteredOutcome.contains($0)
//                }
            }else{
                Utils.toastmsg(message: "Not get Customer", view: self.view)
                self.getCustomerDetail(cid:NSNumber.init(value: planVisit?.customerID ?? 0))
            }
        }else{
            
            
        }
        
        
        strInteractionTime = ""
        if let strdate = tfInteractionDate.text{
            strInteractionTime.append(strdate)
        }
        if let strtime =  tfInteractionTime.text{
            strInteractionTime.append("  \(strtime)")
        }
        
        
        
        if(visitType == VisitType.planedvisit || visitType == VisitType.directvisitcheckin || visitType == VisitType.beatplan || visitType == VisitType.manualvisit){
            arrOfContact.removeAll()
            //arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: planVisit?.customerID ?? 0))
            contactDropdown.anchorView = tfContact
            contactDropdown.bottomOffset = CGPoint.init(x: 0.0, y: tfContact.bounds.size.height)
            contactDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.tfContact.text = item
                
                let selectedContact = self.arrOfContact[index]
                self.contactID =  NSNumber.init(value: selectedContact.iD)
                
            }
            arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: planVisit?.customerID ?? 0))
            contactDropdown.dataSource =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
            let arrcheckincheckoutList = planVisit?.checkInOutData
            if(arrcheckincheckoutList?.count == 0){
                userLatestActivity = UserLatestActivityForVisit.none
            }else{
                if let latestcheckin = arrcheckincheckoutList?.lastObject as? VisitCheckInOutList {
                    print(latestcheckin)
                }
            }
            tfContact.text =  contactDropdown.dataSource.count == 0 ? "No Contacts Exists":
                "Select Contact"
            
            if(arrOfContact.count > 0){
                // if let selectedcontact = Contact.getContactFromID(contactID: planVisit?.contactID ?? 0){
                if let selectedcontact = Contact.getContactFromID(contactID: NSNumber.init(value:planVisit?.contactID ?? Int64(0))) as? Contact{
                    var strContact =  ""
                    if let firstname = selectedcontact.firstName as? String{
                        strContact.append(firstname)
                    }
                    if let secondname = selectedcontact.lastName as? String{
                        strContact.append(" \(secondname)")
                    }
                    tfContact.text =  strContact
                    
                }else{
                    tfContact.text =  "Select Contact"
                    
                }
            }
            btnSubmit.isHidden = false
            btnSubmit.isUserInteractionEnabled = true
        }else if(visitType == VisitType.coldcallvisit){
            arrOfContact = Contact.getContactsUsingCustomerID(customerId:  unplanVisit?.tempCustomerID ?? 0)
            tfContact.textColor = UIColor.black
            
            tfContact.text = unplanVisit?.contactName
            
            let arrcheckincheckoutlist = unplanVisit?.checkInList
            if(arrcheckincheckoutlist?.count == 0){
                userLatestActivity = UserLatestActivityForVisit.none
            }else{
                let latestcheckin = arrcheckincheckoutlist?.last
                print(latestcheckin ?? "")
            }
            btnSubmit.isHidden = false
            btnSubmit.isUserInteractionEnabled = true
        }else if((visitType == VisitType.planedvisitHistory) || (visitType == VisitType.coldcallvisitHistory)){
            btnSubmit.isHidden = true
            btnSubmit.isUserInteractionEnabled = false
            
        }else{
            btnSubmit.isHidden = false
            btnSubmit.isUserInteractionEnabled = true
        }
        contactDropdown.reloadAllComponents()
        if(isupdateReport == true){
            if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory || visitType == VisitType.directvisitcheckin || visitType == VisitType.beatplan || visitType == VisitType.manualvisit){
                
                tvDescription.text = latestvisitreport.conclusion
                self.selectedInteractionType(tag: latestvisitreport?.interactionTypeID ?? 0)
                
                if(latestvisitreport.visitOutcomeID > 0){
                    arrSelectedVisitoutcome.removeAll()
                    arrSelectedVisitoutcome.append(VisitOutcomes.getVisitOutcome(visitOutcomeIndexID:latestvisitreport?.visitOutcomeID ?? 0))
                }
                if(latestvisitreport.visitOutcome2ID > 0){
                    arrSelectedVisitoutcome.append(VisitOutcomes.getVisitOutcome(visitOutcomeIndexID:latestvisitreport.visitOutcome2ID ))
                }
                if(latestvisitreport.visitOutcome3ID > 0){
                    arrSelectedVisitoutcome.append(VisitOutcomes.getVisitOutcome(visitOutcomeIndexID:latestvisitreport?.visitOutcome3ID ?? 0))
                }
                if(latestvisitreport.visitOutcome4ID > 0){
                    arrSelectedVisitoutcome.append(VisitOutcomes.getVisitOutcome(visitOutcomeIndexID:latestvisitreport?.visitOutcome4ID ?? 0 ))
                }
                if(latestvisitreport.visitOutcome5ID > 0){
                    arrSelectedVisitoutcome.append(VisitOutcomes.getVisitOutcome(visitOutcomeIndexID:latestvisitreport.visitOutcome5ID ))
                }
                for i in 0...arrOutcome.count-1{
                    let selectedoutcome = arrOutcome[i]
                    if(latestvisitreport.visitOutcomeID > 0){
                        if(latestvisitreport.visitOutcomeID ==  selectedoutcome.visitOutcomeIndexID){
                            if(tvoutcome.text?.count == 0){
                                tvoutcome.text = selectedoutcome.visitOutcomeValue
                            }else{
                                tvoutcome.text?.append(String.init(format: ", %@",selectedoutcome.visitOutcomeValue))
                            }
                        }
                    }
                    
                    if(latestvisitreport.visitOutcome2ID > 0){
                        if(latestvisitreport.visitOutcome2ID ==  selectedoutcome.visitOutcomeIndexID){
                            if(tvoutcome.text?.count == 0){
                                tvoutcome.text = selectedoutcome.visitOutcomeValue
                            }else{
                                tvoutcome.text?.append(String.init(format: ", %@",selectedoutcome.visitOutcomeValue))
                            }
                        }
                    }
                    if(latestvisitreport.visitOutcome3ID > 0){
                        if(latestvisitreport.visitOutcome3ID ==  selectedoutcome.visitOutcomeIndexID){
                            if(tvoutcome.text?.count == 0){
                                tvoutcome.text = selectedoutcome.visitOutcomeValue
                            }else{
                                tvoutcome.text?.append(String.init(format: ", %@",selectedoutcome.visitOutcomeValue))
                            }
                        }
                    }
                    if(latestvisitreport.visitOutcome4ID > 0){
                        if(latestvisitreport.visitOutcome4ID ==  selectedoutcome.visitOutcomeIndexID){
                            if(tvoutcome.text?.count == 0){
                                tvoutcome.text = selectedoutcome.visitOutcomeValue
                            }else{
                                tvoutcome.text?.append(String.init(format: ", %@",selectedoutcome.visitOutcomeValue))
                            }
                        }
                    }
                    if(latestvisitreport.visitOutcome5ID > 0){
                        if(latestvisitreport.visitOutcome5ID ==  selectedoutcome.visitOutcomeIndexID){
                            if(tvoutcome.text?.count == 0){
                                tvoutcome.text = selectedoutcome.visitOutcomeValue
                            }else{
                                tvoutcome.text?.append(String.init(format: ", %@",selectedoutcome.visitOutcomeValue))
                            }
                        }
                    }
                }
                
                //                tvoutcome.isSelectable = false
                //                tvDescription.isSelectable = false
                tfOrderValue.isHidden = true
                lblOrderExpectedTitle.isHidden = true
                tfOrderExpectedDate.isHidden = true
                if(tvoutcome.text?.range(of: NSLocalizedString("customer_promised_to_place_order", comment:"")) != nil){
                    lblOrderExpectedTitle.isHidden = false
                    tfOrderExpectedDate.isHidden = false
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    var expectedDate = dateFormatter.date(from: latestvisitreport?.expectedDate ?? "10/10/2000")//dateFormatter.string(from: latestvisitreport?.expectedDate)
                    if let strExpextcedDate = expectedDate as? Date{
                        
                    }else{
                        expectedDate = Utils.getDateFromStringWithFormat(gmtDateString: latestvisitreport?.expectedDate ?? "10/10/2000 00:00:00")

                    }
                    tfOrderExpectedDate.text = dateFormatter.string(from: expectedDate ?? Date())
                }else{
                    lblOrderExpectedTitle.isHidden = true
                    tfOrderExpectedDate.isHidden = true
                    
                }
                
                if(tvoutcome.text?.range(of: NSLocalizedString("customer_placed_order", comment:"")) != nil){
                    tfOrderValue.text = String(latestvisitreport.orderValue)
                    tfOrderValue.isHidden = false
                }
                else{
                    tfOrderValue.isHidden = true
                }
                
                if(latestvisitreport.interactionWith == 0 || arrOfContact.count == 0){
                    tfContact.text = arrOfContact.count == 0 ? "No Contacts Exists":"Select Contact"
                    if(arrOfContact.count > 0){
                        if let selectedvisitReport = Contact.getContactFromID(contactID: NSNumber.init(value:planVisit?.contactID ?? 0)) as? Contact{
                            contactID = NSNumber.init(value:selectedvisitReport.iD)
                            var strContact =  ""
                            if let firstname = selectedvisitReport.firstName as? String{
                                strContact.append(firstname)
                            }
                            if let secondname = selectedvisitReport.lastName as? String{
                                strContact.append(" \(secondname)")
                            }
                            tfContact.text =  strContact
                            
                        }
                    }else{
                        contactID = NSNumber.init(value:0)
                    }
                }else{
                    tfContact.text =  latestvisitreport.interactionWithName
                    
                }
                if(latestvisitreport.nextActionID > 0){
                    nextActionID = NSNumber.init(value:latestvisitreport.nextActionID)
                    self.setNextAction(selected: true)
                    NextActionIndicator.isSelected = true
                    
                    let strnextActionDate = Utils.getDateBigFormatToDefaultFormat(date: latestvisitreport.nextActionTime, format: "dd-MM-yyyy")
                    //Utils.getDateBigFormatToDefaultFormat(date:latestvisitreport.nextActionTime
                    self.dateFormatter.dateFormat = "dd-MM-yyyy"
                    nextActionDate = self.dateFormatter.date(from: strNextActionTime)
                    //dateFormatter.date(from: latestvisitreport.nextActionTime ?? "22/2/2010")
                    
                    tfNextActionDate.text = strnextActionDate
                    var strvrt = ""
                    if let strvr = Utils.getDateBigFormatToDefaultFormat(date: latestvisitreport.nextActionTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") as? String{
                        strvrt = strvr
                    }
                    tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString:strvrt, format: "hh:mm  a")
                    
                    strNextActionTime = ""
                    if let strdate = tfNextActionDate.text{
                        strNextActionTime.append(strdate)
                    }
                    if let strtime =  tfNextActionTime.text{
                        strNextActionTime.append("  \(strtime)")
                    }
                }else{
                    if(visitType == VisitType.planedvisitHistory){
                        stackNextAction.isHidden =  true
                        vwNextActionInteraction.isHidden = true
                    }
                }
                contactID =  NSNumber.init(value:latestvisitreport.interactionWith)
                //                tvDescription.text = latestvisitreport.conclusion
                tvDescription.setFlexibleHeight()
                if(latestvisitreport.nextActionID == 0){
                    NextActionIndicator.isSelected = false
                    
                    stackDateTimeTitle.isHidden = true
                    vwNextActionInteraction.isHidden = true
                    
                    stackDateTimeControl.isHidden = true
                    lblNextActionDetailTitle.isHidden = true
                    
                }else{
                    NextActionIndicator.isSelected = true
                    stackDateTimeTitle.isHidden = false
                    stackDateTimeControl.isHidden = false
                    vwNextActionInteraction.isHidden = false
                    lblNextActionDetailTitle.isHidden = false
                    nextActionID = NSNumber.init(value:latestvisitreport?.nextActionID ?? 0)
                    self.selectedNextActionInteractionType(tag: latestvisitreport?.nextActionID ?? 0)
                    //                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    //                       NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                    //                       dayComponent.day = 1;
                    //                       NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
                    //                       NSDate *date = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:nextDate options:0]
                    
                    if(nextActionID.intValue > 0){
                        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
                            let strnextActionDate = Utils.getDateBigFormatToDefaultFormat(date: latestvisitreport.nextActionTime, format: "dd-MM-yyyy")
                            //Utils.getDateBigFormatToDefaultFormat(date:latestvisitreport.nextActionTime
                            self.dateFormatter.dateFormat = "dd-MM-yyyy"
                            nextActionDate = self.dateFormatter.date(from: strNextActionTime)
                            //dateFormatter.date(from: latestvisitreport.nextActionTime ?? "22/2/2010")
                            nextActionDatePicker.date = nextActionDate ?? Date()
                            tfNextActionDate.text = strnextActionDate
                            var strvrt = ""
                            if let strvr = Utils.getDateBigFormatToDefaultFormat(date: latestvisitreport.nextActionTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") as? String{
                                strvrt = strvr
                            }
                            tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString:strvrt, format: "hh:mm  a")
                            
                            strNextActionTime = ""
                            if let strdate = tfNextActionDate.text{
                                strNextActionTime.append(strdate)
                            }
                            if let strtime =  tfNextActionTime.text{
                                strNextActionTime.append("  \(strtime)")
                            }
                        }else{
                            nextActionDate = dateFormatter.date(from: unplanvisitReport.nextActionTime ?? "22/2/2010")
                            tfNextActionDate.text = Utils.getDateWithAppendingDay(day: 0, date: nextActionDate ?? Date() , format: "dd-MM-yyyy", defaultTimeZone: true)
                            var unplvrt = ""
                            if let  unplvr =  Utils.getDateBigFormatToDefaultFormat(date: unplanvisitReport.nextActionTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") as? String{
                                unplvrt = unplvr
                            }
                            tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString: unplvrt, format: "hh:mm  a")
                            strNextActionTime = ""
                            if let strdate = tfNextActionDate.text{
                                strNextActionTime.append(strdate)
                            }
                            if let strtime =  tfNextActionTime.text{
                                strNextActionTime.append("  \(strtime)")
                            }
                        }
                    }else{
                        
                        tfNextActionDate.text = Utils.getDateWithAppendingDayLang(day: 0, date: nextActionDate ?? Date(), format: "dd-MM-yyyy")
                        nextActionDatePicker.date = nextActionDate ?? Date()
                        tfNextActionTime.text = Utils.getDateWithAppendingDayLang(day: 0, date: Date(), format: "hh:mm a")
                        strNextActionTime = ""
                        if let strdate = tfNextActionDate.text{
                            strNextActionTime.append(strdate)
                        }
                        if let strtime =  tfNextActionTime.text{
                            strNextActionTime.append("  \(strtime)")
                        }
                    }
                }
                
            }else {
                
                tvDescription.text = unplanvisitReport.conclusion
                
                self.selectedInteractionType(tag: Int64(unplanvisitReport.interactionID ?? 1))
                if(unplanvisitReport.nextActionID ?? 0 > 0){
                    self.setNextAction(selected: true)
                    
                    self.selectedNextActionInteractionType(tag: Int64(unplanvisitReport.nextActionID ?? 0))
                }
                if(unplanvisitReport.interactionwithName?.count ?? 0 > 0){
                    tfContact.text = unplanvisitReport.interactionwithName
                }else{
                    var strcontactname = ""
                    if let firstcontact =  unplanVisit?.tempCustomerObj?.ContactFirstName as? String{
                        strcontactname.append(firstcontact)
                    }
                    if let lastcontact = unplanVisit?.tempCustomerObj?.ContactLastName as? String {
                        if(strcontactname.count > 0){
                            strcontactname.append(String.init(format: " \(lastcontact)"))
                        }else{
                            strcontactname.append(lastcontact)
                        }
                    }
                    tfContact.text = strcontactname
                }
                if(unplanvisitReport.visitOutcomeID ?? 0 > 0){
                    arrSelectedVisitoutcome.removeAll()
                    arrSelectedVisitoutcome.append(VisitOutcomes.getVisitOutcome(visitOutcomeIndexID:Int64(unplanvisitReport.visitOutcomeID ?? 0) ))
                }
                if(unplanvisitReport.visitOutcome2ID ?? 0 > 0){
                    
                    arrSelectedVisitoutcome.append(VisitOutcomes.getVisitOutcome(visitOutcomeIndexID:Int64(unplanvisitReport.visitOutcome2ID ?? 0) ))
                }
                if(unplanvisitReport.visitOutcome3ID ?? 0 > 0){
                    
                    arrSelectedVisitoutcome.append(VisitOutcomes.getVisitOutcome(visitOutcomeIndexID:Int64(unplanvisitReport.visitOutcome3ID ?? 0)))
                }
                if(unplanvisitReport.visitOutcome4ID ?? 0 > 0){
                    
                    arrSelectedVisitoutcome.append(VisitOutcomes.getVisitOutcome(visitOutcomeIndexID:Int64(unplanvisitReport.visitOutcome4ID ?? 0)))
                }
                if(unplanvisitReport.visitOutcome5ID ?? 0  > 0){
                    
                    arrSelectedVisitoutcome.append(VisitOutcomes.getVisitOutcome(visitOutcomeIndexID:Int64(unplanvisitReport.visitOutcome5ID ?? 0)))
                }
                for i in 0...arrOutcome.count-1{
                    let selectedoutcome = arrOutcome[i]
                    if(unplanvisitReport.visitOutcomeID ?? 0 > 0){
                        if(unplanvisitReport.visitOutcomeID == Int(selectedoutcome.visitOutcomeIndexID)){
                            if(tvoutcome.text?.count == 0){
                                tvoutcome.text = selectedoutcome.visitOutcomeValue
                            }else{
                                tvoutcome.text?.append(String.init(format: ", %@",selectedoutcome.visitOutcomeValue))
                            }
                        }
                    }
                    
                    if(unplanvisitReport.visitOutcome2ID  ?? 0 > 0){
                        if(unplanvisitReport.visitOutcome2ID ==  Int(selectedoutcome.visitOutcomeIndexID)){
                            if(tvoutcome.text?.count == 0){
                                tvoutcome.text = selectedoutcome.visitOutcomeValue
                            }else{
                                tvoutcome.text?.append(String.init(format: ", %@",selectedoutcome.visitOutcomeValue))
                            }
                        }
                    }
                    if(unplanvisitReport.visitOutcome3ID ?? 0 > 0){
                        if(unplanvisitReport.visitOutcome3ID ==  Int(selectedoutcome.visitOutcomeIndexID)){
                            if(tvoutcome.text?.count == 0){
                                tvoutcome.text = selectedoutcome.visitOutcomeValue
                            }else{
                                tvoutcome.text?.append(String.init(format: ", %@",selectedoutcome.visitOutcomeValue))
                            }
                        }
                    }
                    if(unplanvisitReport.visitOutcome4ID ?? 0 > 0){
                        if(unplanvisitReport.visitOutcome4ID ==  Int(selectedoutcome.visitOutcomeIndexID)){
                            if(tvoutcome.text?.count == 0){
                                tvoutcome.text = selectedoutcome.visitOutcomeValue
                            }else{
                                tvoutcome.text?.append(String.init(format: ", %@",selectedoutcome.visitOutcomeValue))
                            }
                        }
                    }
                    if(unplanvisitReport.visitOutcome5ID ?? 0 > 0){
                        if(unplanvisitReport.visitOutcome5ID ==  Int(selectedoutcome.visitOutcomeIndexID)){
                            if(tvoutcome.text?.count == 0){
                                tvoutcome.text = selectedoutcome.visitOutcomeValue
                            }else{
                                tvoutcome.text?.append(String.init(format: ", %@",selectedoutcome.visitOutcomeValue))
                            }
                        }
                    }
                }
                
                //                tvoutcome.isSelectable = false
                //                tvDescription.isSelectable = false
                tfOrderValue.isHidden = true
                lblOrderExpectedTitle.isHidden = true
                tfOrderExpectedDate.isHidden = true
                if(tvoutcome.text?.range(of: NSLocalizedString("customer_promised_to_place_order", comment:"")) != nil){
                    lblOrderExpectedTitle.isHidden = false
                    tfOrderExpectedDate.isHidden = false
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let expectedDate = dateFormatter.date(from: unplanvisitReport?.expectedDate ?? "10/10/2000")//dateFormatter.string(from: latestvisitreport?.expectedDate)
                    tfOrderExpectedDate.text = dateFormatter.string(from: expectedDate ?? Date())
                }else{
                    lblOrderExpectedTitle.isHidden = true
                    tfOrderExpectedDate.isHidden = true
                    
                }
                
                if(tvoutcome.text?.range(of: NSLocalizedString("customer_placed_order", comment:"")) != nil){
                    tfOrderValue.text = String(latestvisitreport.orderValue)
                    tfOrderValue.isHidden = false
                }
                else{
                    tfOrderValue.isHidden = true
                }
                
                if(unplanvisitReport.nextActionID ?? 0 > 0){
                    self.setNextAction(selected: true)
                    self.selectedNextActionInteractionType(tag: Int64(unplanvisitReport.nextActionID ?? 0))
                    self.dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
                    nextActionDate = dateFormatter.date(from: unplanvisitReport.nextActionTime ?? "22/2/2010")
                    if let interactiondate = dateFormatter.date(from: unplanvisitReport.InteractionTime ?? "22/2/2010") as?  Date{
                        
                        interactionTimeDatePicker.date = interactiondate
                    }else{
                        self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                        if let interactiondate1 = dateFormatter.date(from: unplanvisitReport.InteractionTime ?? "22/2/2010") as? Date{
                            interactionTimeDatePicker.date = interactiondate1
                        }
                    }
                    tfNextActionDate.text = Utils.getDateWithAppendingDay(day: 0, date: nextActionDate ?? Date() , format: "dd-MM-yyyy", defaultTimeZone: true)
                    
                    var strnt = ""
                    if let strn = Utils.getDateBigFormatToDefaultFormat(date: unplanvisitReport.nextActionTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") as? String{
                        strnt = strn
                    }
                    tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm a")
                    
                    tfInteractionDate.text = Utils.getDateWithAppendingDay(day: 0, date: interactionTimeDatePicker.date ?? Date() , format: "dd-MM-yyyy", defaultTimeZone: true)
                    
                    var strit = ""
                    if let strn = Utils.getDateBigFormatToDefaultFormat(date: unplanvisitReport.InteractionTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") as? String{
                        strit = strn
                    }
                    tfInteractionTime.text = Utils.getDatestringWithGMT(gmtDateString: strit, format: "hh:mm a")
                    
                }else{
                    if(visitType == VisitType.coldcallvisitHistory){
                        stackNextAction.isHidden =  true
                        vwNextActionInteraction.isHidden = true
                    }
                    
                }
            }
            
            tvDescription.setFlexibleHeight()
            tvoutcome.setFlexibleHeight()
        }else{
            var strcontactname = ""
            if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
                if let firstcontact =  unplanVisit?.tempCustomerObj?.ContactFirstName as? String{
                    strcontactname.append(firstcontact)
                }
                if let lastcontact = unplanVisit?.tempCustomerObj?.ContactLastName as? String {
                    if(strcontactname.count > 0){
                        strcontactname.append(String.init(format: " \(lastcontact)"))
                    }else{
                        strcontactname.append(lastcontact)
                    }
                }
                tfContact.text = strcontactname
            }
            self.selectedNextActionInteractionType(tag: 1)
            let calender = Calendar.current
            var daycomponent = DateComponents.init()
            daycomponent.day = 1
            if let date =  calender.date(byAdding: daycomponent, to: Date()) as? Date{
                nextActionDate = calender.date(bySettingHour: 10, minute: 0, second: 0, of: date)
                
                print(nextActionDate ?? "gerre")
                nextActionDatePicker.date = nextActionDate ?? Date()
                self.dateFormatter.dateFormat = "dd-MM-yyyy"
                tfNextActionDate.text = self.dateFormatter.string(from: nextActionDatePicker.date)
                self.dateFormatter.dateFormat = "hh:mm a"
                tfNextActionTime.text = self.dateFormatter.string(from: nextActionDatePicker.date)
                strNextActionTime = ""
                if let strdate = tfNextActionDate.text{
                    strNextActionTime.append(strdate)
                }
                if let strtime =  tfNextActionTime.text{
                    strNextActionTime.append("  \(strtime)")
                }
                expectedDatePicker.date = expectationDate ?? Date()
            }
            interactionID = NSNumber.init(value: 1)
            self.selectedInteractionType(tag: 1)
            contactID = NSNumber.init(value: 0)
            tfOrderValue.isHidden = true
            lblOrderExpectedTitle.isHidden = true
            tfOrderExpectedDate.isHidden = true
            tvoutcome.applyPlaceholderStyle(aTextview: tvoutcome,placeholderText: "Select Outcome")
            
            // tvDescription.applyPlaceholderStyle(aTextview: tvDescription,placeholderText: "Enter Description")
            
        }
        // tvDescription.addBottomBorderWithColor(color: UIColor.red, width: 1.0)
        tfOrderValue.addBorders(edges: UIRectEdge.bottom, color: UIColor.black , cornerradius: 0)
        tfOrderExpectedDate.addBorders(edges: UIRectEdge.bottom, color: UIColor.black , cornerradius: 0)
        tvDescription.addBorders(edges: UIRectEdge.bottom, color: UIColor.black, cornerradius: 0)
        
        if(visitType == VisitType.coldcallvisit || visitType == VisitType.coldcallvisitHistory){
            //            tfContact.isHidden = true
            btnAddNewContact.isHidden = true
        }
        
        if(self.activesetting.requiInteractionTypeInVisitReport == NSNumber.init(value:1)){
            vwInterationType.isHidden = false
        }else{
            vwInterationType.isHidden = true
        }
        if(self.activesetting.requiInteractionDateTimeInVisitReport == NSNumber.init(value:1)){
            vwInterationDateTime.isHidden = false
        }else{
            vwInterationDateTime.isHidden = true
        }
        
        if(self.activesetting.requiContactPersonInVisitReport == NSNumber.init(value: 1)){
            vwContact.isHidden = false
        }else{
            vwContact.isHidden = true
        }
        var strnt = ""
        if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: planVisit?.originalNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                strnt = strn
            }
        }else{
            if let strn = Utils.getDateBigFormatToDefaultFormat(date: unplanVisit?.originalNextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                strnt = strn
            }
        }
        self.dateFormatter.dateFormat =  "yyyy/MM/dd HH:mm:ss"
        let date = self.dateFormatter.date(from: strnt) ?? Date()
        let strnextactionDate =  self.dateFormatter.string(from: date)
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        let planDate = self.dateFormatter.date(from: strnextactionDate)
        //  plandate < createddate
        if(self.activesetting.allowEditVisitDataForPreviousDate == NSNumber.init(value: 0)){
            
            if(date.isEndDateIsSmallerThanCurrent(checkendDate: Date())){
                vwSubmit.isHidden = true
            }
        }
        
        
    }
    func getCustomerDetail(cid:NSNumber){
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        param["CustomerID"] =  cid
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetCustomerDetails, method: Apicallmethod.get) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            Utils.removeShadow(view: self.view)
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                var custdic = arr as? [String:Any] ?? [String:Any]()
                let arrOfAdd = custdic["AddressList"] as? [[String:Any]] ?? [[String:Any]]()
                let dicOfAdd = arrOfAdd.first as? [String:Any] ?? [String:Any]()
                let customerID = custdic["ID"] as? Int
                let type = custdic["Type"] as? String
                let nsnumCustomerID = NSNumber.init(value: customerID ?? 0)
                var nsnumContactID = NSNumber.init(value:  0)
                if((type == "U") && (nsnumCustomerID.intValue > 0)){
                    MagicalRecord.save { (localcontext) in
                        
                        FEMDeserializer.object(fromRepresentation: custdic, mapping: CustomerDetails.defaultmapping(), context: localcontext)
                        FEMDeserializer.object(fromRepresentation: dicOfAdd, mapping: AddressList.defaultmapping(), context: localcontext)
                        localcontext.mr_saveToPersistentStore { (status, error
                        ) in
                            print(error?.localizedDescription ?? "gbdfgdfgb")
                            print("after saving persistant")
                          
                            if let customer = CustomerDetails.getCustomerByID(cid:nsnumCustomerID) as? CustomerDetails{
                                
                                if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.planedvisitHistory){
                                   /* for visitoutcome in self.arrVisitOutCome{
                                        self.custsegment = visitoutcome.customerSegment
                                        self.custType = visitoutcome.customerType
                                        //kyc1Type.components(separatedBy: ",")
                                        let arrOfSegment = self.custsegment.components(separatedBy: ",")
                                        let arrOfType = self.custType.components(separatedBy: ",")
                                        let customertype = NSNumber.init(value:self.selectedCustomer.companyTypeID).stringValue
                                        let customersegment = NSNumber.init(value:self.selectedCustomer.segmentID).stringValue
                                        print("arr of kyc = \(arrOfType) and \(customertype) , arr of segment = \(arrOfSegment) and \(customersegment) , visitstatus type = \(self.custsegment) , visitstatussegment = \(self.custType), \(visitoutcome.visitOutcomeValue)")
//                                        if((arrOfType.contains(customertype) && arrOfSegment.contains(customersegment)) || (self.custsegment == "999999" && self.custType == "0")){
//
//                                        }else{
//                                            Utils.toastmsg(message: "arr of kyc = \(arrOfType) => \(customertype) , arr of segment = \(arrOfSegment) => \(customersegment) , 999999  == \(self.custsegment) , 0 == \(self.custType)", view: self.view)
//                                            self.filteredOutcome.append(visitoutcome)
//                                        }
                                        if((arrOfType.contains(customertype) && arrOfSegment.contains(customersegment)) || (self.custsegment == "999999" && self.custType == "0") || ((arrOfType.count == 1 && (arrOfType.first == "" || arrOfType.first == customertype)) && (arrOfSegment.count == 1 && (arrOfSegment.first == "" || arrOfSegment.first == customersegment)) )){
                                          //  Utils.toastmsg(message: "customer segment = \(self.custType),outcome type =\(self.custType),arr type = \(arrOfType.count), arr seg = \(arrOfSegment.count)", view: self.view)
                                      
                                    }else {
                                      //  Utils.toastmsg(message: "arr of type = \(arrOfType) => \(customertype) , arr of segment = \(arrOfSegment) => \(customersegment) , 999999  == \(self.custType) , 0 == \(self.custType)", view: self.view)
                                        
                                        self.filteredOutcome.append(visitoutcome)
                                    }
                                    }*/
                                    self.arrVisitOutCome = VisitOutcomes.getVisitOutComeAccordingTocustomer(custSegment: NSNumber.init(value:self.selectedCustomer.segmentID).stringValue, custType: NSNumber.init(value:self.selectedCustomer.companyTypeID).stringValue)
                                }
                                
//                                self.arrVisitOutCome = self.arrVisitOutCome.filter{
//                                    !self.filteredOutcome.contains($0)
//                                }
                                print("address = \(customer.addressList)" )
                                if  let adlist = customer.addressList{
                                    for add in adlist{
                                        if let address = add as? AddressList{
                                            print("late = \(address.lattitude) , long = \(address.longitude) , address = \(address)")
                                        }
                                    }
                                }
                            }
                            else{
                                Utils.toastmsg(message: "Did not get Customer", view: self.view)
                            }
                            //        if let lastContact =  CustomerDetails.mr_findAll()?.last as? CustomerDetails{
                            //                                                print(lastContact.name)
                            //                                                print(lastContact.iD)
                            //            self.getAllContactDetail(custID: NSNumber.init(value:lastContact.iD))
                            //
                            //                                            }
                        }
                        
                    } completion: { (status , error) in
                        let strAdd =      AddressList().getAddressStringByAddressId(aId:NSNumber.init(value:dicOfAdd["AddressID"] as? Int ?? 0))
                        //    print("string address = \(strAdd) ,  dic of address = \(dicOfAdd)")
                        let arrOFContact = Contact.getContactsUsingCustomerID(customerId: nsnumCustomerID)
                        if(arrOFContact.count > 0){
                            nsnumContactID = NSNumber.init(value:arrOFContact.first?.iD ?? 0)
                        }
                        
                        
                        
                        //                                      //  self.saveCustDelegate?.saveCustomer(customerID: nsnumCustomerID, customerName: self.tfCustName.text ?? "", contactID:nsnumContactID )
                        //                                        if(self.isFromColdCallVisit && self.tempCustomer?.customerProfile?.orderExpectedDate?.count ?? 0 > 0){
                        //                                            var dicparam = Common.returndefaultparameter()
                        //                                            var visitdic = [String:Any]()
                        //                                            visitdic["CompanyID"] = self.activeuser?.company?.iD
                        //                                            visitdic["CustomerID"] = dicResponse["ID"]
                        //                                            visitdic["CreatedBy"] = self.activeuser?.userID
                        //                                            visitdic["ContactID"] = NSNumber.init(value: 0)
                        //                                            visitdic["VisitTypeID"] = NSNumber.init(value: 1)
                        //                                            visitdic["SeriesPrefix"] = ""
                        //                                            visitdic["Conclusion"] = ""
                        //                                            let arrAddress = dicResponse["AddressList"] as? [[String:Any]]
                        //                                            visitdic["AddressMasterID"] = arrAddress?.first?["AddressID"]
                        //                                            visitdic["NextActionID"] = NSNumber.init(value: 6)
                        //                                            visitdic["OriginalAssignee"] = self.primaryUserID
                        //                                            let strDate = self.tempCustomer?.customerProfile?.orderExpectedDate
                        //                                            let calender = Calendar.current
                        //                                            var dayComponent = DateComponents.init()
                        //                                            dayComponent.timeZone = NSTimeZone.init(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone
                        //                                            let dtf = DateFormatter.init()
                        //                                            dtf.dateFormat = "yyyy/MM/dd HH:mm:ss"
                        //                                            let d = dtf.date(from: strDate ?? "")
                        //                                            let nextdate = calender.date(byAdding: dayComponent, to: d ?? Date())
                        //                                            let date = calender.date(bySettingHour: 10, minute: 00, second: 00, of: nextdate ?? Date())
                        //
                        //                                            visitdic["NextActionTime"] = Utils.getDateUTCWithAppendingDay(day: 0, date: date ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)//Utils.getDateWithAppendingDay(day: 0, date: date ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimeZone: true)
                        //                                            dicparam["addUpdateVisitJson"] =  Common.returnjsonstring(dic: visitdic)
                        //                                           // dicparam["addUpdateVisitProductJson"] = Common.json(from: [[String:Any]]())
                        //                                            dicparam["addUpdateVisitProductJson"] = "[\n\n]"
                        ////                                            if let arr = arrSelectedProduct as? NSMutableArray {
                        ////
                        ////                                            if(arr.count > 0){
                        ////                                                dicparam["addUpdateVisitProductJson"] = Common.json(from: arr)
                        ////
                        ////                                            }else{
                        ////                                                dicparam["addUpdateVisitProductJson"] = "[\n\n]"
                        ////                                            }
                        ////                                            }
                        //                                          print("parameter of Add visit while adding visit = \(dicparam)")
                        //                                            self.apihelper.getdeletejoinvisit(param: dicparam, strurl: ConstantURL.kWSUrlAddEditPlannedVisit, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                        //                                                SVProgressHUD.dismiss()
                        //                                                if(status.lowercased() == Constant.SucessResponseFromServer){
                        //                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        //                                                    if(self.navigationController?.viewControllers.count ?? 0 > 0){
                        //
                        //                                                                                    if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is VisitCustomerProfile }){
                        //                                        if let controller = self.navigationController?.viewControllers[controllerIndex - 2]{
                        //                                            if(controller is Leadselection){
                        //                                                if let controller = self.navigationController?.viewControllers[controllerIndex - 3]{
                        //                                                    self.navigationController?.popToViewController(controller,animated:true)
                        //                                                }else{
                        //                                                    self.navigationController?.popViewController(animated:true)
                        //                                                }
                        //                                            }else{
                        //                                            self.navigationController?.popToViewController(controller,animated:true)
                        //                                            }
                        //                                                                                        }
                        //                                                                                    }else{
                        //                                                                            self.navigationController?.popViewController(animated:true)
                        //                                                                                    }
                        //                                                                            }
                        //                                                    }
                        //                                                }else if(error.code == 0){
                        //
                        //                                                }else{
                        //
                        //                                                }
                        //                                            }
                        //                                        }
                        
                        
                        
                        if let lastContact =  CustomerDetails.mr_findAll()?.last as? CustomerDetails{
                            let arrOFContact = Contact.getContactsUsingCustomerID(customerId: nsnumCustomerID)
                            if(arrOFContact.count > 0){
                                nsnumContactID = NSNumber.init(value:arrOFContact.first?.iD ?? 0)
                            }
                            //             //   self.saveCustDelegate?.saveCustomer(customerID: nsnumCustomerID, customerName: self.tfCustName.text ?? "", contactID: nsnumContactID)
                            //            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            //            if(self.navigationController?.viewControllers.count ?? 0 > 0){
                            //
                            //                                            if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is VisitCustomerProfile }){
                            //                                                if let controller = self.navigationController?.viewControllers[controllerIndex - 2]{
                            //                                                    if(controller is Leadselection){
                            //                                                        if let controller = self.navigationController?.viewControllers[controllerIndex - 3]{
                            //                                                            self.navigationController?.popToViewController(controller,animated:true)
                            //                                                        }else{
                            //                                                            self.navigationController?.popViewController(animated:true)
                            //                                                        }
                            //                                                    }else{
                            //                                                    self.navigationController?.popToViewController(controller,animated:true)
                            //                                                    }
                            //                                                }
                            //                                            }else{
                            //                                    self.navigationController?.popViewController(animated:true)
                            //                                            }
                            //                                    }
                            //            }
                        }
                    }
                }
                else if((type == "V") && (nsnumCustomerID.intValue > 0)){
                    MagicalRecord.save { (localcontext) in
                        
                        FEMDeserializer.object(fromRepresentation: custdic, mapping: Vendor.defaultmapping(), context: localcontext)
                        FEMDeserializer.object(fromRepresentation: dicOfAdd, mapping: AddressList.defaultmapping(), context: localcontext)
                        localcontext.mr_saveToPersistentStore { (status, error
                        ) in
                            print(error?.localizedDescription ?? "gbdfgdfgb")
                            print("after saving persistant")
                            
                        }
                        
                    } completion: { (status , error) in
                        if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.planedvisitHistory){
                            /*for visitoutcome in self.arrVisitOutCome{
                                self.custsegment = visitoutcome.customerSegment
                                self.custType = visitoutcome.customerType
                                //kyc1Type.components(separatedBy: ",")
                                let arrOfSegment = self.custsegment.components(separatedBy: ",")
                                let arrOfType = self.custType.components(separatedBy: ",")
                                let customertype = NSNumber.init(value:self.selectedCustomer.companyTypeID).stringValue
                                let customersegment = NSNumber.init(value:self.selectedCustomer.segmentID).stringValue
                                print("arr of kyc = \(arrOfType) and \(customertype) , arr of segment = \(arrOfSegment) and \(customersegment) , visitstatus type = \(self.custsegment) , visitstatussegment = \(self.custType), \(visitoutcome.visitOutcomeValue)")
                                if((arrOfType.contains(customertype) && arrOfSegment.contains(customersegment)) || (self.custsegment == "999999" && self.custType == "0") || ((arrOfType.count == 1 && (arrOfType.first == "" || arrOfType.first == customertype)) && (arrOfSegment.count == 1 && (arrOfSegment.first == "" || arrOfSegment.first == customersegment)) )){
                                    
                                }else{
                                    //Utils.toastmsg(message: "arr of kyc = \(arrOfType) => \(customertype) , arr of segment = \(arrOfSegment) => \(customersegment) , 999999  == \(customersegment) , 0 == \(self.custType)", view: self.view)
                                    self.filteredOutcome.append(visitoutcome)
                                }
                                
                            }*/
                            self.arrVisitOutCome = VisitOutcomes.getVisitOutComeAccordingTocustomer(custSegment: NSNumber.init(value:self.selectedCustomer.segmentID).stringValue, custType: NSNumber.init(value:self.selectedCustomer.companyTypeID).stringValue)
                        }
                        
//                        self.arrVisitOutCome = self.arrVisitOutCome.filter{
//                            !self.filteredOutcome.contains($0)
//                        }
                    }
                }else{
                    if ( message.count > 0 ) {
                        Utils.toastmsg(message:message,view: self.view)
                    }
                }
                
            }else{
                
            }
        }
    }
    func validateReport()->Bool{
        if(arrSelectedVisitoutcome.count == 0){
            Utils.toastmsg(message:"Select Visit Outcome",view:self.view)
            return false
        }
        if(((nextActionDatePicker.date.compare(Date())) == .orderedAscending) && (NextActionIndicator.isSelected == true)){
            Utils.toastmsg(message:NSLocalizedString("please_select_valid_date", comment:""),view:self.view)
            return false
        }else {
            return true
        }
    }
    
    func selectedInteractionType(tag:Int64){
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
    
    func selectedNextActionInteractionType(tag:Int64){
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
    
    func setNextAction(selected:Bool)->(){
        if(selected == true){
            stackDateTimeTitle.isHidden = false
            stackDateTimeControl.isHidden = false
            vwNextActionInteraction.isHidden = false
            lblNextActionDetailTitle.isHidden = false
            //            if(isupdateReport ==  true){
            //                if(latestvisitreport.nextActionID > 0){
            //                NextActionIndicator.isSelected = true
            //                }else{
            //
            //                }
            //            }else{
            //                self.selectedNextActionInteractionType(tag: 1)
            //            }
            if((nextActionID.intValue > 0 && isupdateReport ==  true)){
                //  (latestvisitreport.nextActionTime.count > 0 && visitType == VisitType.planedvisit) || (unplanvisitReport.nextActionTime?.count ?? 0  > 0  && visitType == VisitType.coldcallvisit)){
                if((visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory)){
                    if let nextActionTime =  latestvisitreport.nextActionTime as? String{
                        let strnextActionDate = Utils.getDateBigFormatToDefaultFormat(date: latestvisitreport.nextActionTime, format: "dd-MM-yyyy")
                        //Utils.getDateBigFormatToDefaultFormat(date:latestvisitreport.nextActionTime
                        self.dateFormatter.dateFormat = "dd-MM-yyyy"
                        nextActionDate = self.dateFormatter.date(from: strNextActionTime)
                        //dateFormatter.date(from: latestvisitreport.nextActionTime ?? "22/2/2010")
                        
                        tfNextActionDate.text = strnextActionDate
                        var strvrt = ""
                        if let strvr = Utils.getDateBigFormatToDefaultFormat(date: latestvisitreport.nextActionTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") as? String{
                            strvrt = strvr
                        }
                        tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString:strvrt, format: "hh:mm  a")
                    }else{
                        nextActionID = NSNumber.init(value: 1)
                        let calender = Calendar.current
                        var daycomponent = DateComponents.init()
                        daycomponent.day = 1
                        if let date =  calender.date(byAdding: daycomponent, to: Date()) as? Date{
                            nextActionDate = calender.date(bySettingHour: 10, minute: 0, second: 0, of: date)
                            print(nextActionDate ?? "f4g4")
                            nextActionDatePicker.date = nextActionDate ?? Date()
                        }
                        tfNextActionDate.text = Utils.getDateWithAppendingDayLang(day: 0, date: nextActionDate ?? Date(), format: "dd-MM-yyyy")
                        tfNextActionTime.text = Utils.getDateWithAppendingDayLang(day: 0, date: nextActionDate ?? Date(), format: "hh:mm a")
                    }
                }else{
                    if let visitreportexist = unplanvisitReport as? VisitStatusList{
                        nextActionDate = dateFormatter.date(from: unplanvisitReport.nextActionTime ?? "22/2/2010")
                        
                    }else{
                        
                    }
                    
                    
                    tfNextActionDate.text = Utils.getDateWithAppendingDay(day: 0, date: nextActionDate ?? Date() , format: "dd-MM-yyyy", defaultTimeZone: true)
                    
                    var strnt = ""
                    if let strn = Utils.getDateBigFormatToDefaultFormat(date: unplanvisitReport.nextActionTime ?? "22/2/2010 00:00 am", format: "yyyy/MM/dd HH:mm:ss") as? String
                    {
                        strnt = strn
                    }
                    
                    tfNextActionTime.text = Utils.getDatestringWithGMT(gmtDateString: strnt, format: "hh:mm  a")
                }
            }else{
                
                
                /* if let strdt = Utils.getDateBigFormatToDefaultFormat(date: objVisit?.nextActionTime ?? "", format: "yyyy/MM/dd HH:mm:ss") as? String{
                 let date = Utils.getDateFromStringWithFormat(gmtDateString: strdt)
                 
                 tfDate.text = Utils.getDateWithAppendingDay(day: 0, date: date, format: "dd MMM,yyyy", defaultTimeZone: true)
                 tfTime.text = Utils.getDateWithAppendingDay(day: 0, date: date, format: "hh:mm a", defaultTimeZone: true)
                 }else{
                 tfDate.text = ""
                 tfTime.text = ""
                 }*/
                nextActionID = NSNumber.init(value: 1)
                let calender = Calendar.current
                var daycomponent = DateComponents.init()
                daycomponent.day = 1
                if let date =  calender.date(byAdding: daycomponent, to: Date()) as? Date{
                    nextActionDate = calender.date(bySettingHour: 10, minute: 0, second: 0, of: date)
                    print(nextActionDate ?? "f4g4")
                    nextActionDatePicker.date = nextActionDate ?? Date()
                }
                tfNextActionDate.text = Utils.getDateWithAppendingDayLang(day: 0, date: nextActionDate ?? Date(), format: "dd-MM-yyyy")
                tfNextActionTime.text = Utils.getDateWithAppendingDayLang(day: 0, date: nextActionDate ?? Date(), format: "hh:mm a")
                /* let calender = Calendar.current
                 var daycomponent = DateComponents.init()
                 daycomponent.day = 1
                 if let date =  calender.date(byAdding: daycomponent, to: Date()) as? Date{
                 nextActionDate = calender.date(bySettingHour: 10, minute: 0, second: 0, of: date)
                 print(nextActionDate ?? "f4g4")
                 nextActionDatePicker.date = nextActionDate ?? Date()
                 }
                 tfNextActionDate.text = Utils.getDateWithAppendingDayLang(day: 0, date: nextActionDate ?? Date(), format: "dd-MM-yyyy")
                 tfNextActionTime.text = Utils.getDateWithAppendingDayLang(day: 0, date: nextActionDate ?? Date(), format: "hh:mm a")*/
            }
        }else{
            stackDateTimeTitle.isHidden = true
            vwNextActionInteraction.isHidden = true
            
            stackDateTimeControl.isHidden = true
            lblNextActionDetailTitle.isHidden = true
        }
    }
    func createNEWVisit(){
        var param = Common.returndefaultparameter()
        let nextactiondate = dateFormatter.date(from:String.init(format: "%@ %@", tfNextActionDate.text ?? Date() as CVarArg ,tfNextActionTime.text ?? ""))
        var visitDic =  ["CompanyID":activeuser?.company?.iD ?? NSNumber.init(value: 0),"CreatedBy":activeuser?.userID ?? NSNumber.init(value: 0),"ContactID":contactID,"VisitTypeID":NSNumber.init(value: 1),"SeriesPrefix":"","Conclusion":tvDescription.text,"AddressMasterID":planVisit?.addressMasterID,"NextActionID":nextActionID,"OriginalAssignee":planVisit?.originalAssignee,"NextActionTime":Utils.getDate(date: nextactiondate as! NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")] as [String : Any]//Utils.getDate(date: datepicker.date as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")
        if(visitType == VisitType.planedvisit){
            visitDic["CustomerID"] = planVisit?.customerID
        }else{
            visitDic["CustomerID"] = unplanVisit?.customerID
        }
        param["addUpdateVisitJson"] =  Common.json(from: visitDic)
        //        if(arrOfProduct.count > 0){
        //        for pro in arrOfProduct{
        //            var dic = [String:Any]()
        //              dic["productName"] = pro.productName ?? ""
        //                    dic["ProductID"] = pro.productID ?? 0
        //                    if(pro.productCatId == 0){
        //                        dic["CategoryID"] = NSNumber.init(value:0)
        //                    }else{
        //                        dic["CategoryID"] = pro.productCatId
        //
        //                    }
        //                    if(pro.productSubCatId == 0){
        //                        dic["SubCategoryID"] = NSNumber.init(value:0)
        //                    }else{
        //                        dic["SubCategoryID"] = pro.productSubCatId
        //
        //                    }
        //                    if(pro.quantity?.count == 0){
        //                       dic["Quantity"] = "0"
        //                    }else{
        //                        dic["Quantity"] = pro.quantity
        //
        //                    }
        //                    if(pro.budget?.count == 0){
        //                       dic["Budget"] = "0"
        //                    }else{
        //                        dic["Budget"] = pro.budget
        //
        //                    }
        //
        //                    if(pro.salesDiscount?.count == 0){
        //                              dic["salesDiscount"] = "0"
        //                           }else{
        //                    dic["salesDiscount"] = pro.salesDiscount
        //                    }
        //                    if(pro.price?.count == 0){
        //                        dic["Price"] = "0"
        //                                  }else{
        //                    dic["Price"] =  pro.price
        //                    }
        //                    if(pro.maxdiscount?.count == 0){
        //                    dic["Maxdiscount"] = "0"
        //                    }else{
        //                    dic["Maxdiscount"] = pro.maxdiscount
        //                    }
        //                    if(pro.leadId?.count == 0){
        //                    dic["LeadId"] = "0"
        //                    }else{
        //                    dic["LeadId"] = pro.leadId
        //                    }
        //            if((self.activesetting.visitProductPermission == 2) && ((dic["Budget"] as? String)?.count == 0)){
        //                dic["Budget"] = String.init(format:"%@",pro.price ?? 0)
        //            }else{
        //                dic["Budget"] = String.init(format:"%@",pro.budget ?? 0)
        //                }
        //            print("dic is  = \(dic)")
        //        arrSelectedProductDic.append(dic)
        //        }
        //        }
        //
        //        if(arrSelectedProductDic.count > 0){
        //            param["addUpdateVisitProductJson"] = Common.json(from: arrSelectedProductDic)
        //
        //        }else{
        //            param["addUpdateVisitProductJson"] = "[\n\n]"
        //        }
        param["addUpdateVisitProductJson"] = "[\n\n]"
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        print("parameter of Add plan visit = \(param)")
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlAddEditPlannedVisit, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            SVProgressHUD.dismiss()
            if(status.lowercased() == Constant.SucessResponseFromServer){
                var dicVisit = arr as? [String:Any] ?? [String:Any]()
                let strCustomerName = CustomerDetails.customerNameFromCustomerID(cid: NSNumber.init(value: dicVisit["CustomerID"] as? Int ?? 0))
                if(strCustomerName.count == 0){
                    dicVisit["CustomerName"] = "Customer Not Mapped"
                }else{
                    dicVisit["CustomerName"] = strCustomerName
                }
                let reassignedId = dicVisit["ReAssigned"] as? Int ?? 0
                if(reassignedId > 0){
                    
                    if let companyuser = CompanyUsers().getUser(userId:NSNumber.init(value:reassignedId)){
                        let reassignUserName = String.init(format: "%@ %@", companyuser.firstName,companyuser.lastName)
                        dicVisit["RessigneeName"] = reassignUserName
                    }else{
                        dicVisit["RessigneeName"] = ""
                    }
                }else{
                    dicVisit["RessigneeName"] = ""
                }
                MagicalRecord.save({ (localContext) in
                    let arrvisit = FEMDeserializer.collection(fromRepresentation: [dicVisit], mapping: PlannVisit.defaultmapping(), context: localContext)
                    print(arrvisit)
                    
                }, completion: { (contextdidsave, error) in
                    print("\(contextdidsave) , error = \(error)")
                    print("visit saved")
                    if(self.isEditing){
                        NotificationCenter.default.post(name: Notification.Name("updateVisitData"), object: nil, userInfo: nil)
                    }
                    //    if let lastvisit = PlannVisit.mr_findAll()?.last as? PlannVisit{
                    //                print(lastvisit.customerName)
                    //            }
                    print(error?.localizedDescription ?? "")
                    print(self.navigationController?.viewControllers.count ?? 0)
                    //     AppDelegate.shared.rootViewController.switchToMainScreen()
                    
                    if(self.navigationController?.viewControllers.count ?? 0 > 0){
                        
                        if let  controllerIndex = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                            if let controller = self.navigationController?.viewControllers[controllerIndex - 1]{
                                self.navigationController?.popToViewController(controller,animated:true)
                            }
                        }else if let  controllerIndex1 = self.navigationController?.viewControllers.firstIndex(where:{$0 is Leadselection }){
                            if let controller = self.navigationController?.viewControllers[controllerIndex1 - 1]{
                                self.navigationController?.popToViewController(controller,animated:true)
                            }
                        }else{
                            self.navigationController?.popViewController(animated:true)
                        }
                        
                    }
                    
                    
                })
                Utils.toastmsg(message: message, view: self.view)
                self.navigationController?.popViewController(animated: true)
            }
            
            else{
                if(error.code == 0){
                    Utils.toastmsg(message: message, view:self.view)
                }else{
                    Utils.toastmsg(message: error.userInfo["localiseddescription"]  as? String
                                    ?? "", view: self.view)
                }
            }
        }
        
        
    }
    func isCheckedOut(lat:NSNumber,long:NSNumber){
        if(Utils.isCheckedOUT(visitID: NSNumber.init(value:planVisit?.iD ?? 0), userId: self.activeuser?.userID ?? 0) == false){
            
            let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
                // update visit  report and checkout also
                if(self.isOTPRequire){
                    self.isForceCheckout = false
                    self.isForceClose = false
                    self.getOTP()
                }else{
                    
                    self.updatevisitstatus(isforceCheckout: false, withCloseVisit: false)//flase
                }
            }
            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
            
            let noAction =  UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default) { (action) in
                //update  visit report
                if(self.isOTPRequire){
                    self.isForceCheckout = false
                    self.isForceClose = true
                    self.getOTP()
                }else{
                    
                    self.updatevisitstatus(isforceCheckout: false, withCloseVisit: true)//true
                }
            }
            var stroutcome = ""
            if(self.activesetting.closeVisitUpon == 2 ||  self.activesetting.closeVisitUpon == 4 || self.activesetting.closeVisitUpon == 5){
                stroutcome = self.returnmessageasperscenario(planvisit: planVisit ?? PlannVisit())
            }else{
                stroutcome = "You did not select any next action, Are you sure you want to close this visit?"
            }
            Common.showalertWithAction(msg: stroutcome, arrAction: [yesAction,noAction,cancelAction], view: self)
        }
        else{
            if(lat != 0 && long != 0){
                let checkinoutdata = Utils.isCheckedOUT1(visitID: NSNumber.init(value:planVisit?.iD ?? 0), createdBy: self.activeuser?.userID ?? 0)
                let location1 = CLLocation.init(latitude: CLLocationDegrees(truncating: lat), longitude: CLLocationDegrees(truncating: long))
                let location2 = CLLocation.init(latitude: Double(checkinoutdata?.lattitude ?? "0.00") ?? 0.00, longitude: Double(checkinoutdata?.longitude ?? "0.00") ?? 0.00)
                let distancemeter = location1.distance(from: location2)
                var stroutcome = ""
                var issameLocation = false
                if( distancemeter <= self.activeuser?.company?.radiusSuperSales?.doubleValue ?? 0){
                    if(self.activesetting.closeVisitUpon == 1){
                        var msg1 = String.init(format: "%@ %@", NSLocalizedString("selected_outcome_is", comment:""), tvoutcome.text ?? "")
                        msg1.append(" Are you sure you want to set this outcome?")
                        
                        stroutcome = msg1
                    }else{
                        stroutcome = self.returnmessageasperscenario(planvisit: planVisit ?? PlannVisit())
                        
//                        stroutcome = NSLocalizedString("you_have_not_yet_checked_out_from_the_visit_report_submission", comment:"")
                    }
                    issameLocation = true
                }else{
                    if(self.activesetting.closeVisitUpon == 2){
                        stroutcome = NSLocalizedString("you_have_not_yet_checked_out_from_the_visit_report_submission", comment: "")
                    }else{
                    stroutcome = NSLocalizedString("You_are_not_at_visit_location", comment:"");
                    }
                    issameLocation = false
                }
                let noAction = UIAlertAction.init(title:NSLocalizedString("no", comment: ""), style: .default) { (action) in
                    if(self.isOTPRequire){
                        self.isForceCheckout = false
                        self.isForceClose = true
                        self.getOTP()
                    }else{
                        
                        self.updatevisitstatus(isforceCheckout: false, withCloseVisit: true)
                    }
                }
                let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                let yesAction = UIAlertAction.init(title: NSLocalizedString("yes", comment: ""), style: .destructive) { (action) in
                    if(issameLocation == true){
                        
                        if(self.isOTPRequire){
                            self.isForceCheckout = true
                            self.isForceClose = false
                            self.getOTP()
                        }else{
                            
                            self.updatevisitstatus(isforceCheckout:true, withCloseVisit: false)
                        }
                    }else{
                        if(self.isOTPRequire){
                            self.isForceCheckout = false
                            self.isForceClose = false
                            self.getOTP()
                            
                        }else{
                            
                            self.updatevisitstatus(isforceCheckout: false, withCloseVisit: false)
                        }
                    }
                }
                Common.showalertWithAction(msg: stroutcome, arrAction: [yesAction,noAction,cancelAction], view: self)
            }
        }
    }
    func getOTP(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        if(visitType == VisitType.planedvisit){
            param["CustomerID"] = planVisit?.customerID
            param["VisitID"] = planVisit?.iD
        }else{
            param["CustomerID"] = unplanVisit?.customerID
            param["VisitID"] = unplanVisit?.localID
        }
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlForOTPToCloseVisit, method: Apicallmethod.get)  { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() == Constant.SucessResponseFromServer){
                SVProgressHUD.dismiss()
                self.strOtp = arr as? String ?? ""
                print("OTP is = \(self.strOtp)")
                self.askForOTP()
                
            }else{
                SVProgressHUD.dismiss()
                Utils.toastmsg(message: "Please wait", view: self.view)
                self.getOTP()
            }
        }
    }
    func askForOTP(){
        
        let alert = UIAlertController.init(title: "OTP", message: "Please enter your otp", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (tfotp) in
            tfotp.keyboardType = .numberPad
            tfotp.placeholder = "Enter OTP"
        }
        let verifyAction = UIAlertAction.init(title: "Verify", style: UIAlertAction.Style.default) { (action) in
            let textField = alert.textFields![0] // Force unwrapping because we know it exists.
            
            if(textField.text?.count == 0){
                Utils.toastmsg(message: "Please enter OTP", view: self.view)
                self.askForOTP()
            }else{
                self.verifyOTP(OTP:textField.text ?? "")
                //self.requestDeviation(deviationId:deviationID, reson: textField.text ?? "", selectedDate: selectedDate)
            }
            
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.default) { (action) in
            
        }
        alert.addAction(verifyAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true) {
            
        }
    }
    func verifyOTP(OTP:String){
        SVProgressHUD.show()
        if(self.strOtp.lowercased() == OTP.lowercased()){
            Utils.removeShadow(view: self.view)
            SVProgressHUD.dismiss()
            self.updatevisitstatus(isforceCheckout: isForceCheckout, withCloseVisit: isForceClose)
        }else{
            //Utils.toastmsg(message: "Please enter correct OTP", view: self.view)
            self.view.makeToast("Please enter correct OTP", duration: 2.0, position: self.view.center)
            Utils.removeShadow(view: self.view)
            SVProgressHUD.dismiss()
            self.askForOTP()
        }
        
        
    }
    func updatevisitstatus(isforceCheckout:Bool,withCloseVisit:Bool){
        
        if(arrSelectedVisitoutcome.count == 0){
            Utils.toastmsg(message:"Select Visit Outcome",view:self.view)
        }else{
            
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            var param = Common.returndefaultparameter()
            var visitReport = ["InteractionTypeID":interactionID,"InteractionWith":contactID ?? 0] as [String:Any]
            if(contactID == 0){
                visitReport["VisitTypeID"] = NSNumber.init(value: 1)
                if(visitType == VisitType.planedvisit){
                    visitReport["InteractionWithName"] = NSLocalizedString("no_contact", comment:"")
                }else{
                    visitReport["InteractionWithName"] = tfContact.text
                }
            }else{
                visitReport["VisitTypeID"] = NSNumber.init(value: 2)
                visitReport["InteractionWithName"] =  tfContact.text
            }
            if(visitType == VisitType.planedvisit){
                visitReport["VisitID"] = NSNumber.init(value: planVisit?.iD ?? 0)
            }else{
                visitReport["VisitID"] = NSNumber.init(value: unplanVisit?.localID ?? 0)
            }
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let interactiondate = dateFormatter.date(from:String.init(format: "%@ %@", tfInteractionDate.text ?? Date() as CVarArg ,tfInteractionTime.text ?? ""))
            
            //    visitReport["NextActionTime"] = Utils.getDate(date: interactiondate as! NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")
            visitReport["InteractionTime"] = Utils.getDate(date: interactiondate as! NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")
            //Utils.getDateinstrwithaspectedFormat(givendate: interactiondate!, format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: false)
            if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
            param["CustomerID"] =  planVisit?.customerID
            }else{
                param["CustomerID"] =  unplanVisit?.customerID
            }
            if(NextActionIndicator.isSelected){
                visitReport["NextActionID"] =  nextActionID
                if(self.activesetting.nextActionNewVisitCreation ==  1){
                    let nextactiondate = dateFormatter.date(from:String.init(format: "%@ %@", tfNextActionDate.text ?? Date() as CVarArg ,tfNextActionTime.text ?? ""))
                    if(visitType == VisitType.planedvisit || visitType == VisitType.planedvisitHistory){
                        visitReport["NextActionTime"] = planVisit?.createdTime
                        visitReport["CustomerID"] =  planVisit?.customerID
                    }else{
                        visitReport["NextActionTime"] = unplanVisit?.createdTime
                        visitReport["CustomerID"] =  unplanVisit?.customerID
                    }
                    
                    self.createNEWVisit()
                }else{
                    visitReport["NextActionTime"] = Utils.getDate(date: interactiondate as! NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")
                    visitReport["CustomerID"] =  planVisit?.customerID
                }
                
                //Utils.getDate(date: nextactiondate as! NSDate, withFormat: "yyyy/MM/dd HH:mm:ss")//Utils.getDateinstrwithaspectedFormat(givendate: nextactiondate!, format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: false)
                
            }
            visitReport["CreatedBy"] = self.activeuser?.userID
            switch arrSelectedVisitoutcome.count{
            case 0:
                SVProgressHUD.dismiss()
                Utils.toastmsg(message:"Select Atleast one Outcome",view:self.view)
                break
                
            case 1:
                visitReport["VisitOutcomeID"] = NSNumber.init(value:arrSelectedVisitoutcome[0].visitOutcomeIndexID)
                break
                
            case 2:
                visitReport["VisitOutcomeID"] = NSNumber.init(value:arrSelectedVisitoutcome[0].visitOutcomeIndexID)
                visitReport["VisitOutcome2ID"] = NSNumber.init(value:arrSelectedVisitoutcome[1].visitOutcomeIndexID)
                break
                
            case 3:
                visitReport["VisitOutcomeID"] = NSNumber.init(value:arrSelectedVisitoutcome[0].visitOutcomeIndexID)
                visitReport["VisitOutcome2ID"] = NSNumber.init(value:arrSelectedVisitoutcome[1].visitOutcomeIndexID)
                visitReport["VisitOutcome3ID"] = NSNumber.init(value:arrSelectedVisitoutcome[2].visitOutcomeIndexID)
                break
                
            case 4:
                visitReport["VisitOutcomeID"] = NSNumber.init(value:arrSelectedVisitoutcome[0].visitOutcomeIndexID)
                visitReport["VisitOutcome2ID"] = NSNumber.init(value:arrSelectedVisitoutcome[1].visitOutcomeIndexID)
                visitReport["VisitOutcome3ID"] = NSNumber.init(value:arrSelectedVisitoutcome[2].visitOutcomeIndexID)
                visitReport["VisitOutcome4ID"] = NSNumber.init(value:arrSelectedVisitoutcome[3].visitOutcomeIndexID)
                break
                
            case 5:
                visitReport["VisitOutcomeID"] = NSNumber.init(value:arrSelectedVisitoutcome[0].visitOutcomeIndexID)
                visitReport["VisitOutcome2ID"] = NSNumber.init(value:arrSelectedVisitoutcome[1].visitOutcomeIndexID)
                visitReport["VisitOutcome3ID"] = NSNumber.init(value:arrSelectedVisitoutcome[2].visitOutcomeIndexID)
                visitReport["VisitOutcome4ID"] = NSNumber.init(value:arrSelectedVisitoutcome[3].visitOutcomeIndexID)
                visitReport["VisitOutcome5ID"] = NSNumber.init(value:arrSelectedVisitoutcome[4].visitOutcomeIndexID)
                break
                
            default:
                print("will never come")
            }
            visitReport["Conclusion"] = tvDescription.text
            if(tvoutcome.text?.range(of: NSLocalizedString("customer_placed_order", comment:"")) != nil){
                visitReport["OrderValue"] = tfOrderValue.text ?? "0.0"
            }
            if(tvoutcome.text?.range(of: NSLocalizedString("customer_promised_to_place_order", comment:"")) != nil){
                let ExpectedDate = dateFormatter.date(from:String.init(format: "%@ 00:00:00", tfOrderExpectedDate.text ?? Date() as CVarArg))
                visitReport["ExpectedDate"] = Utils.getDateinstrwithaspectedFormat(givendate: ExpectedDate ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: false)
                visitReport["ExpectedDate"] = ExpectedDate
                if(!visitReport.keys.contains("ExpectedDate")){
                    dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
                    let ExpectedDate = dateFormatter.date(from:String.init(format: "%@ 00:00:00", tfOrderExpectedDate.text ?? Date() as CVarArg))
                    visitReport["ExpectedDate"] = Utils.getDateinstrwithaspectedFormat(givendate: ExpectedDate ?? Date(), format: "yyyy/MM/dd HH:mm:ss", defaultTimZone: false)
                    visitReport["ExpectedDate"] = Utils.getDate(date: ExpectedDate as? NSDate ?? Date() as NSDate, withFormat: "yyyy/MM/dd HH:mm:ss") // ExpectedDate
                }
            }
            if(isforceCheckout == true){
                if(Utils().getActiveSetting().closeVisitUpon == 5){
                    if(arrOfVisitClose.count > 0){
                        visitReport["VisitForceCheckOut"] = NSNumber.init(value: 1)
                    }
                }else{
                    visitReport["VisitForceCheckOut"] = NSNumber.init(value: 1)
                }
            }
            //
            //            if(withCloseVisit ==  true){
            //
            //                visitReport["CloseVisitFlag"] = NSNumber.init(value: 1)
            //
            //            }
            if(Utils().getActiveSetting().closeVisitUpon == 1){
                visitReport["CloseVisitFlag"] = NSNumber.init(value: 1)
            }else if(Utils().getActiveSetting().closeVisitUpon == 2){
                if(visitType == VisitType.planedvisit || visitType == VisitType.directvisitcheckin || visitType == VisitType.beatplan || visitType == VisitType.manualvisit){
                    let (message,lastcheckinStatus) =  Utils.latestCheckinDetailForPlanedVisit(visit: planVisit ?? PlannVisit())
                    if let arrCheckin = planVisit?.checkInOutData.array as? [VisitCheckInOutList]{
                        if(arrCheckin.count > 0){
                            var ischeckedin = false
                            for checkin in arrCheckin{
                                if(checkin.checkOutTime != nil){
                                if  let checkintime = Utils.getDateBigFormatToDefaultFormat(date: checkin.checkOutTime , format: "dd-MM-yyyy"){
                                let dateformatter = DateFormatter.init()
                                dateformatter.dateFormat = "dd-MM-yyyy"
                                let dateinstring = dateformatter.string(from: Date())
                                if(dateinstring == checkintime){
                                    ischeckedin = true
                                }
                                }
                                
                            }
                            }
                            if(ischeckedin && isForceCheckout){
                                visitReport["CloseVisitFlag"] = NSNumber.init(value: 0)
                            }else{
                                visitReport["CloseVisitFlag"] = NSNumber.init(value: 1)
                            }
                        }else{
                            visitReport["CloseVisitFlag"] = NSNumber.init(value: 1)
                        }
                    }else{
                        visitReport["CloseVisitFlag"] = NSNumber.init(value: 1)
                    }
                    
                }
                
            }else if(Utils().getActiveSetting().closeVisitUpon == 3){
                visitReport["CloseVisitFlag"] = NSNumber.init(value: 1)
            }else if(Utils().getActiveSetting().closeVisitUpon == 4 && arrOfVisitClose.count > 0){
                visitReport["CloseVisitFlag"] = NSNumber.init(value: 0)
                
            }else if(Utils().getActiveSetting().closeVisitUpon == 5){
                if(arrOfVisitClose.count > 0 &&  isForceCheckout == true){
                    visitReport["CloseVisitFlag"] = NSNumber.init(value: 0)
                }else{
                    visitReport["CloseVisitFlag"] = NSNumber.init(value: 1)
                }
            }else{
                visitReport["CloseVisitFlag"] = NSNumber.init(value: 1)
            }
            
            if(isupdateReport == true){
                if(visitType == VisitType.planedvisit || visitType == VisitType.directvisitcheckin || visitType == VisitType.beatplan || visitType == VisitType.manualvisit){
                    visitReport["ID"] = NSNumber.init(value: latestvisitreport.iD)
                }else{
                    visitReport["ID"] = NSNumber.init(value: unplanvisitReport.iD ?? 0)
                }
                visitReport["UpdatedBy"] = NSNumber.init(value:self.activeuser?.userID as? Int ?? 0)
                
            }
            
            param["updateVisitStatusJson"] = Common.json(from: visitReport)
            print("paramter of vist report submit = \(param)")
            self.apihelper.getdeletejoinvisit(param: param , strurl: ConstantURL.kWSUrlUpdateVisitStatus, method: Apicallmethod.post) { (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
                SVProgressHUD.dismiss()
                print(message)
                if(status.lowercased() == Constant.SucessResponseFromServer){
                    if(responseType == ResponseType.dic){
                        let dic = arr as? [String:Any] ?? [String:Any]()
                        print("response of visit report  = \(dic)")
                        if((dic["CloseVisitFlag"] as? Int ?? 10) == 0){
                            if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.directvisitcheckin || self.visitType == VisitType.beatplan || self.visitType == VisitType.manualvisit){
                         //visit should close
//                                let result = PlannVisit.getVisitByPredicate(predicate: NSPredicate.init(format: "iD == %d", argumentArray: [visitid ?? 0]))
////                                    let context = PlannVisit.getContext()
//                                    print("delelte visits %@",result)
//                                    if(result.count > 0 ){
//                                        for visit in result{
//                                            context.delete(visit)
//                                        }
//                                        context.mr_saveToPersistentStore { (status, error) in
//                                            if(error ==  nil){
//                                                print("context did saved \(status)")
//
//                                                self.navigationController?.popViewController(animated: true)
//                                            }else{
//                                                print("error is = \(error?.localizedDescription)")
//                                             //   Utils.toastmsg(message:error?.localizedDescription ?? "",view:self.view)
//
//                                            }
//                                        }
//                                    }
                                if ( message.count > 0 ) {
                                    Utils.toastmsg(message:message,view: self.view)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                            }else{
                                if ( message.count > 0 ) {
                                    Utils.toastmsg(message:message,view: self.view)
                                }
                                self.unplanVisit?.visitStatusList.insert(VisitStatusList().initwithDic(dict: dic), at: 0)
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            //                self.navigationController?.popViewController(animated: true)
                        }else{
                            if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.directvisitcheckin || self.visitType == VisitType.beatplan || self.visitType == VisitType.manualvisit){
                                
                                self.getplanvisitDetial(visitId: NSNumber.init(value: self.planVisit?.iD ?? 0), ForAction: "")
                                
                                
                                MagicalRecord.save({ (localcontext) in
                                    
                                    let  arr = FEMDeserializer.collection(fromRepresentation: [dic], mapping: VisitStatus.defaultmapping(), context: localcontext)
                                    print(arr)
                                    localcontext.mr_save({ (localcontext) in
                                        print("saving")
                                    })
                                }, completion: { (status, error) in
                                    print(status)
                                    print(error?.localizedDescription ?? "")
                                    if(error ==  nil){
                                        if  let status = VisitStatus.getvisitstatus(visitID:NSNumber.init(value:self.planVisit?.iD ?? 0)){
                                            let folder = self.planVisit?.visitStatusList as! NSMutableOrderedSet
                                            folder.insert(status, at: 0)
                                            self.planVisit?.visitStatusList = folder as NSOrderedSet
                                            
                                        }
                                    }else{
                                        Utils.toastmsg(message:error?.localizedDescription ?? "" ,view:self.view)
                                        print("error in saing status = \(error?.localizedDescription)")
                                    }
                                    let context = PlannVisit.getContext()
                                    context.mr_saveToPersistentStore { (status, error) in
                                        if(error ==  nil){
                                            print("context did saved \(status)")
                                            if(self.isFromVisit){
                                                VisitDetail.carbonswipenavigationobj.setCurrentTabIndex(UInt(0), withAnimation: true)
                                            }else{
                                                
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        }else{
                                            Utils.toastmsg(message:error?.localizedDescription ?? "" ,view:self.view)
                                        }
                                    }
                                    if ( message.count > 0 ) {
                                        Utils.toastmsg(message:message,view: self.view)
                                    }
                                    //          self.navigationController?.popViewController(animated: true)
                                })
                            }else{
                                let localID = dic["ID"]
                                var exist =  false
                                if let unplanstatusList = self.unplanVisit?.visitStatusList{
                                    var unplntempstatus = unplanstatusList
                                    for dict in unplanstatusList{
                                        // if let leadID = dict["localID"] as? String{
                                        
                                        
                                        if(dict.loclID == localID as? Int ?? 0){
                                            exist = true
                                        }
                                        //  }
                                        
                                    }
                                    if(exist == true){
                                        for status in 0...unplanstatusList.count - 1{
                                            let unplanstatus = unplanstatusList[status]
                                            //                                    if let latestreport = self.latestvisitreport as? VisitStatusList{
                                            //
                                            //                                    }else{
                                            //                                        self.unplanvisitReport =  self.unplanVisit?.visitStatusList.last
                                            //                                    }
                                            if(unplanstatus.loclID ?? 0 == self.unplanvisitReport.iD){
                                                unplntempstatus.remove(at: status)
                                                
                                                unplntempstatus.insert(VisitStatusList().initwithDic(dict: dic), at: status)
                                            }
                                        }
                                        self.unplanVisit?.visitStatusList = unplntempstatus
                                        //                                MagicalRecord.save { (localcontext) in
                                        //                                    print("saving")
                                        //                                } completion: { (<#Bool#>, <#Error?#>) in
                                        //                                    <#code#>
                                        //                                }
                                        
                                    }else{
                                        if ( message.count > 0 ) {
                                            Utils.toastmsg(message:message,view: self.view)
                                        }
                                        self.unplanVisit?.visitStatusList.insert(VisitStatusList().initwithDic(dict: dic), at: 0)
                                        if(self.isFromVisit){
                                            VisitDetail.carbonswipenavigationobj.setCurrentTabIndex(UInt(0), withAnimation: true)
                                        }else{
                                            
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                    
                                }else{
                                    if ( message.count > 0 ) {
                                        Utils.toastmsg(message:message,view: self.view)
                                    }
                                    self.unplanVisit?.visitStatusList.insert(VisitStatusList().initwithDic(dict: dic), at: 0)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
                }else{
                    var msg = message
                    if(message.count == 0){
                        msg = error.localizedDescription
                    }
                    Utils.toastmsg(message:msg,view:self.view)
                }
            }
        }
    }
    func getplanvisitDetial(visitId:NSNumber,ForAction:String) {
        /*
         
         NSMutableDictionary *jsonParameter = [NSMutableDictionary new];
         [jsonParameter setObject:@(account.company_info.company_id) forKey:@"CompanyID"];
         [jsonParameter setObject:@(obj.user_id) forKey:@"CreatedBy"];
         [jsonParameter setObject:@(objPlan.iD) forKey:@"ID"];
         
         NSMutableDictionary *maindict = [NSMutableDictionary new];
         [maindict setObject:[jsonParameter rs_jsonStringWithPrettyPrint:YES] forKey:@"getPlannedVisitsJson"];
         [maindict setObject:account.securityToken forKey:@"TokenID"];
         [maindict setObject:@(account.user_id) forKey:@"UserID"];
         [maindict setObject:@(account.company_info.company_id) forKey:@"CompanyID"];
         [maindict setObject:APPLICATION_TEAMWORK forKey:@"Application"];
         **/
        SVProgressHUD.show()
        var param = Common.returndefaultparameter()
        var json = ["CompanyID":self.activeuser?.company?.iD,"ID":visitId,"CreatedBy":self.activeuser?.userID]
        param["getPlannedVisitsJson"] =  Common.json(from: json)
        var planvisit:PlannVisit?
        self.apihelper.getdeletejoinvisit(param: param, strurl: ConstantURL.kWSUrlGetPlannedVisits, method: Apicallmethod.get){ (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType) in
            
            if(status.lowercased() ==  Constant.SucessResponseFromServer){
                SVProgressHUD.dismiss()
                let  arrVisit = arr as? [[String:Any]] ?? [[String:Any]]()
                print("Dictionary of visit = \(arrVisit)")
                var mutarr = [[String:Any]]()
                for visit in arrVisit{
                    let customerID = NSNumber.init(value: visit["CustomerID"] as? Int ?? 0)
                    var dic = [String:Any]()
                    dic = visit
                    if let strcustname = CustomerDetails.getCustomerNameByID(cid: customerID) as? String{
                        dic["CustomerName"] = strcustname
                    }else{
                        dic["CustomerName"] = "Customer Not Mapped"
                    }
                    let companyuerID = NSNumber.init(value: visit["ReAssigned"] as? Int ?? 0)
                    var strreassigned = ""
                    if let companyuser = CompanyUsers().getUser(userId: companyuerID){
                        strreassigned = String.init(format: "\(companyuser.firstName) \(companyuser.lastName)")
                    }
                    dic["RessigneeName"] =  strreassigned
                    mutarr.append(dic)
                }
                MagicalRecord.save({ (localContext) in
                    let arrvisit = FEMDeserializer.collection(fromRepresentation: mutarr, mapping: PlannVisit.defaultmapping(), context: localContext)
                    print("arr of visit is = \(arrvisit)")
                    
                }, completion: { (contextdidsave, error) in
                    if let planvisit = PlannVisit.getVisit(visitID: visitId) as? PlannVisit{
                        if let visitDetail = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.VisitDetailContainerView) as? VisitDetail{
                            print("count of check in at redirection time = \(planvisit.checkInOutData.count)")
                            visitDetail.visitType = VisitType.planedvisit
                            visitDetail.redirectTo =  0
                            visitDetail.planvisit = planvisit
                            self.navigationController?.pushViewController(visitDetail, animated: true)
                        }
                    }
                })
            }else{
                SVProgressHUD.dismiss()
            }
        }
    }
    func returnmessageasperscenario(planvisit:PlannVisit)->String{
        var msg = ""
        var issamelocation = false
        var ischeckedIn = 5
        if(visitType == VisitType.planedvisit || visitType == VisitType.directvisitcheckin || visitType == VisitType.beatplan || visitType == VisitType.manualvisit){
            let (message,lastcheckinStatus) =  Utils.latestCheckinDetailForPlanedVisit(visit: planVisit ?? PlannVisit())
            print(message)
            print(lastcheckinStatus)
            if let arrCheckin = planVisit?.checkInOutData.array as? [VisitCheckInOutList]{
                if(arrCheckin.count > 0){
                    var ischeckedin = false
                    for checkin in arrCheckin{
                        if(checkin.checkOutTime != nil){
                        if let checkouttime = Utils.getDateBigFormatToDefaultFormat(date: checkin.checkOutTime , format: "dd-MM-yyyy"){
                        let dateformatter = DateFormatter.init()
                        dateformatter.dateFormat = "dd-MM-yyyy"
                        let dateinstring = dateformatter.string(from: Date())
                        if(dateinstring == checkouttime){
                            ischeckedin = true
                            ischeckedIn = 1
                            
                        }
                        }
                        }else if let checkintime  = checkin.checkInTime  as? String{
                            if let checkintime = Utils.getDateBigFormatToDefaultFormat(date: checkin.checkInTime , format: "dd-MM-yyyy"){
                            let dateformatter = DateFormatter.init()
                            dateformatter.dateFormat = "dd-MM-yyyy"
                            let dateinstring = dateformatter.string(from: Date())
                            if(dateinstring == checkintime){
                                ischeckedin = true
                                ischeckedIn = 0
                                msg  = NSLocalizedString("you_have_not_yet_checked_out_from_the_visit_report_submission", comment: "")
                            }
                            }
                        }
                    }
                    if(ischeckedIn == 5 && arrCheckin.count > 0){
                        ischeckedIn = 2
                    }
                    
                    // replace  you_have_not_yet_checked_in  => you_have_not_yet_checked_out_from_the_visit_report_submission when setting is outcome or checkout 
                    if(ischeckedIn == 2){
                    msg = NSLocalizedString("you_have_not_yet_checked_out_from_the_visit_report_submission", comment: "")
                    }
                    if(ischeckedIn == 1){
                        if     let currentcoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
                            if(CLLocationCoordinate2DIsValid(currentcoordinate)){
                                let checkinoutdata = Utils.isCheckedOUT1(visitID: NSNumber.init(value:planVisit?.iD ?? 0), createdBy: self.activeuser?.userID ?? 0)
                                let location1 = CLLocation.init(latitude: CLLocationDegrees(truncating: NSNumber(value: currentcoordinate.latitude)), longitude: CLLocationDegrees(truncating: NSNumber(value: currentcoordinate.longitude)))
                                let location2 = CLLocation.init(latitude: Double(checkinoutdata?.lattitude ?? "0.00") ?? 0.00, longitude: Double(checkinoutdata?.longitude ?? "0.00") ?? 0.00)
                                let distancemeter = location1.distance(from: location2)
                                if(distancemeter <= self.activeuser?.company?.radiusSuperSales?.doubleValue ?? 0){
                                    issamelocation = true
                                    msg = NSLocalizedString("you_have_not_yet_checked_out_from_the_visit_report_submission", comment:"")
                                }
                                
                                else{
                                    msg = NSLocalizedString("You_are_not_at_visit_location", comment:"");
                                    issamelocation = false
                                }
                            }else{
                                Common.showalert(msg: "not get valid location", view: self)
                            }}else{
                                let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                                let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))!)
                                    
                                }
                                Common.showalert(title: NSLocalizedString("location_services_disabled", comment:""), msg: NSLocalizedString("please_enable_location_services_in_settings", comment:""), yesAction: settingAction, noAction: cancelAction,view:self)
                            }
                    }
                }else{
                    ischeckedIn = 0
                    msg  = NSLocalizedString("you_have_not_yet_checked_in_from_the_visit_report_submission", comment: "")
                }
            }else{
               msg = NSLocalizedString("you_have_not_yet_checked_in", comment: "")
            }
            
        }else{
            
            issamelocation = true
            msg = NSLocalizedString("you_have_not_yet_checked_out_from_the_visit_report_submission", comment:"")
        }
       return msg
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: IBAction
    
    @IBAction func btnAddPictureClicked(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            Utils.toastmsg(message:"Camera is not present",view:self.view)
        }
    }
    @IBAction func btnSelectOutcomeClicked(_ sender: UIButton) {
        if  let  visitoutcomepopup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection{
            visitoutcomepopup.arrOfSelectedVisitOutcome = arrSelectedVisitoutcome ?? [VisitOutcomes]()
            visitoutcomepopup.modalPresentationStyle = .overCurrentContext
            visitoutcomepopup.strTitle = "Visit Outcome"
            visitoutcomepopup.nonmandatorydelegate = self
            visitoutcomepopup.arrOfVisitOutCome = arrVisitOutCome
            visitoutcomepopup.strLeftTitle = "OK"
            visitoutcomepopup.strRightTitle = "Cancel"
            visitoutcomepopup.selectionmode = SelectionMode.multiple
            visitoutcomepopup.isSearchBarRequire = false
            visitoutcomepopup.isFromSalesOrder =  false
            visitoutcomepopup.viewfor = ViewFor.visitoutcome
            visitoutcomepopup.isFilterRequire = false
            // popup?.showAnimate()
            self.present(visitoutcomepopup, animated: false, completion: nil)
        }
    }
    @IBAction func btnNextActionInteractionClicked(_ sender: UIButton) {
        nextActionID = NSNumber.init(value: sender.tag)
        self.selectedNextActionInteractionType(tag:Int64(sender.tag))
    }
    @IBAction func btnInteractionSelectionClicked(_ sender: UIButton) {
        
        self.selectedInteractionType(tag: Int64(sender.tag))
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
    
    /// <#Description#>
    /// - Parameter sender: <#sender description#>
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if(self.validateReport()){
            arrOfVisitClose = self.arrSelectedVisitoutcome.filter { (outcome)    in
                outcome.visitClose == true
            }
            
            if self.activesetting.mandatoryRemarkInvisitReport == 1 {
                if self.tvDescription.text.trimString.isEmpty || self.tvDescription.text == "" {
                    Utils.toastmsg(message:"Please enter remarks",view:self.view)
                    return
                }
            }
            if(self.activesetting.closeVisitUpon == 1 || self.activesetting.closeVisitUpon == 3){
                if(arrOfVisitClose.count > 0 && self.activesetting.visitCloseOtpRequireOrNot == NSNumber.init(value: 1)){
                    self.askForOTP()
                }else{
                    var msg1 = String.init(format: "%@ %@", NSLocalizedString("selected_outcome_is", comment:""), tvoutcome.text ?? "")
                    msg1.append(" Are you sure you want to set this outcome?")
                    let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default) { (action) in
                        
                    }
                    let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
                        //visit will not close
                        
                        self.updatevisitstatus(isforceCheckout: false, withCloseVisit:true)
                        
                    }
                    Common.showalertWithAction(msg: msg1, arrAction: [noAction,yesAction],view:self)
                }
                
            }else if(self.activesetting.closeVisitUpon == 4 || self.activesetting.closeVisitUpon == 5){
                if(arrOfVisitClose.count > 0){
                    var msg = ""
                    var issamelocation = false
                    var ischeckedIn = 5
                    if(visitType == VisitType.planedvisit || visitType == VisitType.directvisitcheckin || visitType == VisitType.beatplan || visitType == VisitType.manualvisit){
                        let (message,lastcheckinStatus) =  Utils.latestCheckinDetailForPlanedVisit(visit: planVisit ?? PlannVisit())
                        if let arrCheckin = planVisit?.checkInOutData.array as? [VisitCheckInOutList]{
                            if(arrCheckin.count > 0){
                                var ischeckedin = false
                                for checkin in arrCheckin{
                                    if(checkin.checkOutTime != nil){
                                        if  let checkintime = Utils.getDateBigFormatToDefaultFormat(date: checkin.checkOutTime , format: "dd-MM-yyyy"){
                                            let dateformatter = DateFormatter.init()
                                            dateformatter.dateFormat = "dd-MM-yyyy"
                                            let dateinstring = dateformatter.string(from: Date())
                                            if(dateinstring == checkintime){
                                                ischeckedin = true
                                                ischeckedIn = 1
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                if(ischeckedIn == 5 && arrCheckin.count > 0){
                                    ischeckedIn = 2
                                }
                                if(ischeckedIn == 2){
                                    msg = NSLocalizedString("you_have_not_yet_checked_out_from_the_visit_report_submission", comment: "")
                                }
                                if(ischeckedIn == 1){
                                    if     let currentcoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
                                        if(CLLocationCoordinate2DIsValid(currentcoordinate)){
                                            let checkinoutdata = Utils.isCheckedOUT1(visitID: NSNumber.init(value:planVisit?.iD ?? 0), createdBy: self.activeuser?.userID ?? 0)
                                            let location1 = CLLocation.init(latitude: CLLocationDegrees(truncating: NSNumber(value: currentcoordinate.latitude)), longitude: CLLocationDegrees(truncating: NSNumber(value: currentcoordinate.longitude)))
                                            let location2 = CLLocation.init(latitude: Double(checkinoutdata?.lattitude ?? "0.00") ?? 0.00, longitude: Double(checkinoutdata?.longitude ?? "0.00") ?? 0.00)
                                            let distancemeter = location1.distance(from: location2)
                                            if(distancemeter <= self.activeuser?.company?.radiusSuperSales?.doubleValue ?? 0){
                                                issamelocation = true
                                                msg = NSLocalizedString("you_have_not_yet_checked_out_from_the_visit_report_submission", comment:"")
                                            }
                                            
                                            else{
                                                msg = NSLocalizedString("You_are_not_at_visit_location", comment:"");
                                                issamelocation = false
                                            }
                                        }}else{
                                            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                                            let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                                                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))!)
                                                
                                            }
                                            Common.showalert(title: NSLocalizedString("location_services_disabled", comment:""), msg: NSLocalizedString("please_enable_location_services_in_settings", comment:""), yesAction: settingAction, noAction: cancelAction,view:self)
                                        }
                                }
                            }else{
                                ischeckedIn = 0
                                msg = NSLocalizedString("you_have_not_yet_checked_in_from_the_visit_report_submission", comment:"")
                            }
                        }
                        
                    }else{
                        
                        issamelocation = true
                        msg = NSLocalizedString("you_have_not_yet_checked_out_from_the_visit_report_submission", comment:"")
                    }
                    let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
                        
                        if(ischeckedIn == 0){
                            if(self.activesetting.closeVisitUpon == 5){
                                self.updatevisitstatus(isforceCheckout: false, withCloseVisit:false)
                            }else{
                                self.updatevisitstatus(isforceCheckout: false, withCloseVisit:true)
                            }
                        }else{
                            if(issamelocation){
                                self.updatevisitstatus(isforceCheckout: true, withCloseVisit:true)
                            }else{
                                if(self.activesetting.closeVisitUpon == 5){
                                    self.updatevisitstatus(isforceCheckout: false, withCloseVisit:false)
                                }else{
                                    self.updatevisitstatus(isforceCheckout: false, withCloseVisit:true)
                                }
                            }
                        }
                    }
                    let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default) { (action) in
                        if(ischeckedIn == 0){
                            
                        }else{
                            if(self.activesetting.closeVisitUpon == 5){
                                self.updatevisitstatus(isforceCheckout: false, withCloseVisit:false)
                            }else{
                                self.updatevisitstatus(isforceCheckout: false, withCloseVisit:true)
                            }
                        }
                    }
                    Common.showalertWithAction(msg: msg, arrAction: [noAction,yesAction],view:self)
                }else{
                    var msg1 = String.init(format: "%@ %@", NSLocalizedString("selected_outcome_is", comment:""), tvoutcome.text ?? "")
                    msg1.append(" Are you sure you want to set this outcome?")
                    let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default) { (action) in
                        
                    }
                    let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
                        //visit will not close
                        self.updatevisitstatus(isforceCheckout: false, withCloseVisit:true)
                    }
                    Common.showalertWithAction(msg: msg1, arrAction: [noAction,yesAction],view:self)
                }
                
            }else if(self.validateReport() == true) {
                //            if(visitType == VisitType.planedvisit){
                if(NextActionIndicator.isSelected == false){
                    if     let currentcoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
                        if(CLLocationCoordinate2DIsValid(currentcoordinate)){
                            if(visitType == VisitType.planedvisit ){
                                self.isCheckedOut(lat: NSNumber.init(value:currentcoordinate.latitude), long: NSNumber.init(value:currentcoordinate.longitude))
                            }else{
                                var  msg = ""
                                if(self.activesetting.closeVisitUpon == 1){
                                    var msg1 = String.init(format: "%@ %@", NSLocalizedString("selected_outcome_is", comment:""), tvoutcome.text ?? "")
                                    msg1.append(" Are you sure you want to set this outcome?")
                                    msg =  msg1
                                }else{
                                    
                                    msg = String.init(format: "%@", NSLocalizedString("you_do_not_select_any_next_action_are_you_sure_you_want_to_close_this_visit", comment:""))
                                }
                                
                                print("message = \(msg)")
                                let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default) { (action) in
                                    if(self.isOTPRequire){
                                        self.isForceCheckout = false
                                        self.isForceClose = true
                                        self.getOTP()
                                        
                                    }else{
                                        self.updatevisitstatus(isforceCheckout: false, withCloseVisit:  true)
                                    }
                                }
                                let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
                                    if(self.isOTPRequire){
                                        self.isForceCheckout = false
                                        self.isForceClose = false
                                        self.getOTP()
                                    }else{
                                        if(self.activesetting.closeVisitUpon == 1 ){
                                            //visit will not close
                                            if(self.activesetting.mandatoryPictureInVisit == 1 ){
                                                if(self.visitType ==  VisitType.coldcallvisit || self.visitType == VisitType.coldcallvisitHistory){
                                                    if(self.unplanVisit?.isPictureAvailable ==  1){
                                                        self.updatevisitstatus(isforceCheckout: false, withCloseVisit:true)
                                                    }else{
                                                        Utils.toastmsg(message:NSLocalizedString("please_add_picture_in_this_visit_to_do_check_out", comment: ""),view: self.view)
                                                        return
                                                    }
                                                }else{
                                                    self.updatevisitstatus(isforceCheckout: false, withCloseVisit:true)
                                                }
                                            }else{
                                                self.updatevisitstatus(isforceCheckout: false, withCloseVisit:true)
                                            }
                                        }else{
                                            self.updatevisitstatus(isforceCheckout: true, withCloseVisit:false)
                                        }
                                    }
                                }
                                Common.showalertWithAction(msg: msg, arrAction: [noAction,yesAction],view:self)
                            }
                        }
                        
                    }else {
                        let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
                        let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                            UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))!)
                            
                        }
                        Common.showalert(title: NSLocalizedString("location_services_disabled", comment:""), msg: NSLocalizedString("please_enable_location_services_in_settings", comment:""), yesAction: settingAction, noAction: cancelAction,view:self)
                    }
                    
                }
                else{
                    var msg = String.init(format: "%@ %@", NSLocalizedString("selected_outcome_is", comment:""), tvoutcome.text ?? "")
                    msg.append(" Are you sure you want to set this outcome?")
                    
                    print("message = \(msg)")
                    let noAction = UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: nil)
                    let yesAction = UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .destructive) { (action) in
                        if(self.isOTPRequire){
                            self.isForceCheckout = false
                            self.isForceClose = true
                            self.getOTP()
                        }else{
                            
                            self.updatevisitstatus(isforceCheckout: false, withCloseVisit: true)
                        }
                    }
                    Common.showalertWithAction(msg: msg, arrAction: [noAction,yesAction],view:self)
                }
            }
        }
    }
    
    @IBAction func btnAddNewContactClicked(_ sender: UIButton) {
        if let addContact = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNameVisit, classname: Constant.AddContactView) as? AddContact{
            addContact.isEditContact = false
            if  let customer = CustomerDetails.getCustomerByID(cid: NSNumber.init(value:planVisit?.customerID ?? 0)){
                addContact.selectedCust = customer
            }
            addContact.isVendor = false
            addContact.selectedContact = Contact()
            addContact.addcontactdel = self
            self.navigationController?.pushViewController(addContact, animated: true)
        }
    }
}

extension VisitReport:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == tfInteractionDate){
            
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            interactionTimeDatePicker.datePickerMode = .date
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            interactionTimeDatePicker.date = self.dateFormatter.date(from:strInteractionTime) ?? Date()
            print("\(strInteractionTime) , \( interactionTimeDatePicker.date)")
            return true
        }
        else if(textField == tfInteractionTime){
            
            self.dateFormatter.dateFormat = "hh:mm a"
            interactionTimeDatePicker.datePickerMode = .time
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateInteractionTime = dateFormatter.date(from: strInteractionTime)
            interactionTimeDatePicker.date = dateInteractionTime ?? Date()
            
            //            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            //            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            //            datepicker.date = dateNextActionTime ?? Date()
            
            
            
            
            //            self.dateFormatter.dateFormat = "hh:mm a"
            //            datepicker.datePickerMode = .time
            //          //  datepicker.date = self.dateFormatter.date(from:tfInteractionTime.text!)!
            //        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            //        let dateInteractionTime = dateFormatter.date(from: strInteractionTime)
            //        datepicker.date = dateInteractionTime ?? Date()
            print("INTERACTION TIME = \(strInteractionTime) , \(interactionTimeDatePicker.date) , \(dateInteractionTime)")
            return true
        }
        else if(textField == tfNextActionDate){
            
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            nextActionDatePicker.datePickerMode = .date
            nextActionDatePicker.date = self.dateFormatter.date(from:tfNextActionDate.text!)!
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            nextActionDatePicker.date = dateNextActionTime ?? Date()
            print("\(strNextActionTime) , \(nextActionDatePicker.date)")
            return true
        }else if(textField == tfOrderExpectedDate){
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            expectedDatePicker.datePickerMode = .date
            expectedDatePicker.date = self.dateFormatter.date(from: tfOrderExpectedDate.text ?? "05-02-2020") ?? Date()
            
            return true
        }
        else if(textField == tfNextActionTime){
            self.dateFormatter.dateFormat = "hh:mm a"
            nextActionDatePicker.datePickerMode = .time
            // nextActionDatePicker.date = self.dateFormatter.date(from:tfNextActionTime.text!)!
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let dateNextActionTime = dateFormatter.date(from: strNextActionTime)
            nextActionDatePicker.date = dateNextActionTime ?? Date()
            print("\(strNextActionTime) , \(nextActionDatePicker.date)")
            return true
            
        }else if(textField == tfContact){
            if(visitType == VisitType.planedvisit || visitType == VisitType.directvisitcheckin || visitType == VisitType.manualvisit){
                contactDropdown.show()
                return false
            }else{
                return true
            }
        }
        else{
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if(textField == tfInteractionDate){
            interactionTimeDatePicker.datePickerMode = UIDatePicker.Mode.date
        }else if(textField == tfInteractionTime){
            interactionTimeDatePicker.datePickerMode = UIDatePicker.Mode.time
        }else if(textField == tfNextActionDate){
            nextActionDatePicker.datePickerMode = UIDatePicker.Mode.date
        }else if(textField == tfNextActionTime){
            nextActionDatePicker.datePickerMode = UIDatePicker.Mode.time
        }else if(textField == tfOrderExpectedDate){
            expectedDatePicker.datePickerMode = UIDatePicker.Mode.date
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == tfInteractionDate){
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfInteractionDate.text =  dateFormatter.string(from: interactionTimeDatePicker.date)
            
            strInteractionTime = ""
            if let strdate = tfInteractionDate.text{
                strInteractionTime.append(strdate)
            }
            if let strtime =  tfInteractionTime.text{
                strInteractionTime.append("  \(strtime)")
            }
            
        }else if(textField ==  tfInteractionTime){
            dateFormatter.dateFormat = "hh:mm a"
            tfInteractionTime.text =  dateFormatter.string(from: interactionTimeDatePicker.date)
            //            dateFormatter.dateFormat = "dd-MM-yyyy"
            //            interactionTimeDatePicker.date = self.dateFormatter.date(from:tfInteractionTime.text!)!
            print(interactionTimeDatePicker.date)
            strInteractionTime = ""
            if let strdate = tfInteractionDate.text{
                strInteractionTime.append(strdate)
            }
            if let strtime =  tfInteractionTime.text{
                strInteractionTime.append("  \(strtime)")
            }
            
        }else if(textField == tfNextActionDate){
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfNextActionDate.text = dateFormatter.string(from: nextActionDatePicker.date)
            nextActionDate = nextActionDatePicker.date
            strNextActionTime = ""
            if let strdate = tfNextActionDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfNextActionTime.text{
                strNextActionTime.append("  \(strtime)")
            }
        }else if(textField == tfOrderExpectedDate){
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            tfOrderExpectedDate.text = dateFormatter.string(from: expectedDatePicker.date)
            expectationDate = expectedDatePicker.date
            expectedDatePicker.tag = 0
        }else{
            
            
            
            
            dateFormatter.dateFormat = "hh:mm a"
            tfNextActionTime.text =  dateFormatter.string(from: nextActionDatePicker.date)
            strNextActionTime = ""
            if let strdate = tfNextActionDate.text{
                strNextActionTime.append(strdate)
            }
            if let strtime =  tfNextActionTime.text{
                strNextActionTime.append("  \(strtime)")
            }
        }
    }
}

extension VisitReport:BaseViewControllerDelegate{
    func editiconTapped() {
        
    }
    
    func menuitemTouched(item: UPStackMenuItem) {
        
    }
    
    func datepickerSelectionDone() {
        
        if(interactionTimeDatePicker.tag == 0){
            dateFormatter.dateFormat = "dd/MM/yyyy"
            tfInteractionDate.text = dateFormatter.string(from: interactionTimeDatePicker.date)
            interactionTimeDatePicker.date = self.dateFormatter.date(from:tfInteractionTime.text!)!
            print(interactionTimeDatePicker.date)
            
        }else if(interactionTimeDatePicker.tag == 1){
            dateFormatter.dateFormat = "hh:mm a"
            tfInteractionTime.text = dateFormatter.string(from: interactionTimeDatePicker.date)
            interactionTimeDatePicker.date = self.dateFormatter.date(from:tfInteractionTime.text!)!
            print(interactionTimeDatePicker.date)
        }else if(nextActionDatePicker.tag == 2){
            dateFormatter.dateFormat = "dd/MM/yyyy"
            tfNextActionDate.text = dateFormatter.string(from: nextActionDatePicker.date)
        }else if(expectedDatePicker.tag == 0){
            dateFormatter.dateFormat = "dd/MM/yyyy"
            tfOrderExpectedDate.text = dateFormatter.string(from: expectedDatePicker.date)
        }else{
            dateFormatter.dateFormat = "hh:mm a"
            tfNextActionTime.text = dateFormatter.string(from: nextActionDatePicker.date)
        }
    }
    
    
}

extension VisitReport:PopUpDelegateNonMandatory{
    
    
    func completionSelectedVisitOutCome(arr: [VisitOutcomes]) {
        Utils.removeShadow(view: self.view)
        var selectedvisitoutcomelist = ""
        if(arr.count > 0){
            arrSelectedVisitoutcome.removeAll()
            arrSelectedVisitoutcome = arr
            for i in 0...arr.count - 1 {
                let outcome = arr[i]
                print("otp value = \(outcome.visitOutcomeCloseByOtp)")
                if(i == 0){
                    selectedvisitoutcomelist.append(outcome.visitOutcomeValue)
                }else{
                    selectedvisitoutcomelist.append(String.init(format: ", %@", outcome.visitOutcomeValue))
                }
            }
        }else{
            arrSelectedVisitoutcome  = [VisitOutcomes]()
        }
        let arrOTPRequireToClose = self.arrSelectedVisitoutcome.filter { (outcome)    in
            outcome.visitOutcomeCloseByOtp == true
        }
        arrOfVisitClose = self.arrSelectedVisitoutcome.filter { (outcome)    in
            outcome.visitClose == true
        }
        /*
         wrong implementation
         if(arrOTPRequireToClose.count > 0){
         print(arrOTPRequireToClose)
         isOTPRequire = true
         }else{
         isOTPRequire = false
         }
         */
        isOTPRequire = false
        tvoutcome.text =  selectedvisitoutcomelist
        tvoutcome.setFlexibleHeight()
        if(tvoutcome.text?.range(of: NSLocalizedString("customer_promised_to_place_order", comment:"")) != nil){
            
            lblOrderExpectedTitle.isHidden = false
            tfOrderExpectedDate.isHidden = false
        }else{
            lblOrderExpectedTitle.isHidden = true
            tfOrderExpectedDate.isHidden = true
        }
        
        if(tvoutcome.text?.range(of: NSLocalizedString("customer_placed_order", comment:"")) != nil){
            tfOrderValue.isHidden = false
        }
        else{
            tfOrderValue.isHidden = true
        }
        tvoutcome.textColor = UIColor.black
        tvoutcome.setFlexibleHeight()
        
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

extension VisitReport:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(textView == tvoutcome){
            
            if  let  visitoutcomepopup = Common.returnclassviewcontroller(storybordname: Constant.StoryboardNamePopUp, classname: Constant.CustomPopupView) as? CustomerSelection{
                visitoutcomepopup.arrOfSelectedVisitOutcome = arrSelectedVisitoutcome ?? [VisitOutcomes]()
                visitoutcomepopup.modalPresentationStyle = .overCurrentContext
                visitoutcomepopup.strTitle = "Visit Outcome"
                visitoutcomepopup.nonmandatorydelegate = self
                visitoutcomepopup.arrOfVisitOutCome = arrVisitOutCome
                visitoutcomepopup.strLeftTitle = "Okay"
                visitoutcomepopup.strRightTitle = "Cancel"
                visitoutcomepopup.selectionmode = SelectionMode.multiple
                visitoutcomepopup.isSearchBarRequire = false
                visitoutcomepopup.isFromSalesOrder =  false
                visitoutcomepopup.viewfor = ViewFor.visitoutcome
                visitoutcomepopup.isFilterRequire = false
                visitoutcomepopup.parentViewOfPopup = self.view
                // popup?.showAnimate()
                Utils.addShadow(view: self.view)
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

extension VisitReport:AddContactDelegate{
    func saveContact(customerID: NSNumber, customerName: String, contactName: String, contactID: NSNumber) {
        // tfContactPerson.text = contactName
        
        self.tfContact.text = contactName
        
        self.contactID =  contactID
        arrOfContact = Contact.getContactsUsingCustomerID(customerId: NSNumber.init(value: planVisit?.customerID ?? 0))
        contactDropdown.dataSource =  arrOfContact.map{ String.init(format: "%@ %@", $0.firstName , $0.lastName )}
        contactDropdown.reloadAllComponents()
        //        if let newaddedContact = Contact.getContactFromID(contactID: contactID) as? Contact
        //        {
        //
        //        }      //  self.setAddress()
    }
}
extension VisitReport :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true
                       , completion:   nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        //        imgUploadByUser.backgroundColor = .black
        //        activityIndicator.startAnimating()
        
        var param = Common.returndefaultparameter()
        if let currentcoordinate = Location.sharedInsatnce.getCurrentCoordinate(){
            
            param["lattitude"] = currentcoordinate.latitude
            param["longitude"] = currentcoordinate.longitude
        }else{
            SVProgressHUD.dismiss()
            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil)
            let settingAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: ""), style: .default) { (action) in
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString) ?? (URL.init(string: "www.google.com"))! )
            }
            Common.showalertWithAction(msg:NSLocalizedString("location_services_disabled", comment: "") , arrAction:[cancelAction,settingAction], view: self)
        }
        param["createdBy"] = self.activeuser?.userID
        if(visitType == VisitType.planedvisit || visitType == VisitType.beatplan){
            param["visitID"] = planVisit?.iD
        }else{
            param["visitID"] = unplanVisit?.localID
        }
        param["companyID"] = self.activeuser?.company?.iD
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            //  arrOfImages.append(chosenImage)
            self.apihelper.addunplanVisitpostWithMultipartBody(fullUrl: ConstantURL.kWSUrlUploadVisitImage, img: chosenImage, imgparamname: "visitImage", param: param)
            {
                (totalpages,pagesavailable,lastsynctime,arr,status,message,error,responseType)
                in
                SVProgressHUD.dismiss()
                if ( message.count > 0 ) {
                    Utils.toastmsg(message:message,view: self.view)
                }
                
                if(self.visitType == VisitType.planedvisit || self.visitType == VisitType.manualvisit){
                    self.planVisit?.isPictureAvailable = 1
                    self.planVisit?.managedObjectContext?.mr_save({ (localcontext) in
                        print("saving")
                    }, completion: { (status, error) in
                        print(error?.localizedDescription ?? "no error")
                        print("saved")
                        //  self.setData()
                    })
                    
                }else{
                    self.unplanVisit?.isPictureAvailable = 1
                    // self.setData()
                }
                
            }
        }
        // self.imgUploadByUser.contentMode = .scaleAspectFit
        
        
        //        self.imgUploadByUser.image = Common.createImage(withImage: chosenImage, forSize: CGSize.init(width: chosenImage.size.width > 200 ? 200 : chosenImage.size.width , height: chosenImage.size.height > 200 ? 200 :  chosenImage.size.height))
        //        self.UploadRequest()
        
        dismiss(animated:true, completion: nil)
        
    }
}
